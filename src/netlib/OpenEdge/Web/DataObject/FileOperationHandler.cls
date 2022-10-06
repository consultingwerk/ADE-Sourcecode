/* *************************************************************************************************************************
Copyright (c) 2016, 2018, 2021-2022 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : FileOperationHandler
    Purpose     : Delegate for mapped file operations for the DOH
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : Fri May 20 12:15:00 EDT 2016
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.File.
using OpenEdge.Core.FileInfo.
using OpenEdge.Core.Folder.
using OpenEdge.Core.OsErrorEnum.
using OpenEdge.Core.StringConstant.
using OpenEdge.Core.Util.TokenResolver.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.ISupportLogging.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using OpenEdge.Net.HTTP.Filter.Writer.BodyWriterBuilder.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.MethodEnum.
using OpenEdge.Net.HTTP.StatusCodeEnum.
using OpenEdge.Web.DataObject.DataObjectService.
using OpenEdge.Web.DataObject.IOperationHandler.
using OpenEdge.Web.DataObject.MappedOperation.
using OpenEdge.Web.IWebRequest.
using OpenEdge.Web.SendExceptionError.
using OpenEdge.Web.DataObject.FileOperationHandler.
using OpenEdge.Core.Memptr.

class OpenEdge.Web.DataObject.FileOperationHandler implements ISupportLogging, IOperationHandler:
    /* A reference to the Logger in use by an implementer */
    define public property Logger as ILogWriter no-undo get. set.
    
    /* Default constructor */
    constructor public FileOperationHandler():
        assign this-object:Logger = LoggerBuilder:GetLogger(get-class(FileOperationHandler)).
    end constructor.
    
    /* Executes the operation.
       
       @param IWebRequest The request that resulting in the exception
       @param P.L.Object The message body of the incoming request. Typically
                         will be transformed from bytes into something useful; may also have an envelope removed.
       @param IHttpResponse The current response object, if any
       @param DataObjectService The service being operated on
       @param MappedOperation The mapped operation
       @param P.L.Object The business entity (business logic service)
       @return integer A non-null status code use to deal with errors */
    method public integer Execute(input poRequest as IWebRequest,
                                  input poMessageBody as Progress.Lang.Object,
                                  input poResponse as IHttpResponse,
                                  {&_proparse_ prolint-nowarn(varusage)}
                                  input pService as DataObjectService,
                                  input poOperation as MappedOperation,
                                  {&_proparse_ prolint-nowarn(varusage)}
                                  input poBusinessEntity as Progress.Lang.Object):
        /* default behaviour is to handle this ourselves */
        define variable iStatusCode as integer no-undo initial 0.
        
        Assert:NotNull(poRequest,   'Web request').
        Assert:NotNull(poResponse,  'Web response').
        Assert:NotNull(poOperation, 'Mapped operation').
        
        case poOperation:Method:
            when MethodEnum:GET or
            when MethodEnum:HEAD then
                assign iStatusCode = this-object:Read(poOperation, poRequest, poResponse).
            
            when MethodEnum:DELETE then
                assign iStatusCode = this-object:Remove(poOperation, poRequest, poResponse).
            
            when MethodEnum:PUT   or
            when MethodEnum:POST  or
            when MethodEnum:PATCH then
                assign iStatusCode = this-object:Write(poOperation, poRequest, poMessageBody, poResponse).
            
            otherwise
                undo, throw new SendExceptionError(StatusCodeEnum:MethodNotAllowed).
        end case.
        
        return iStatusCode.
    end method.
    
    /* Resolves any tokens in the file name (TargetName) into appropriate values
       
       @param MappedOperation The operation
       @param IWebRequest The current request
       @return character The resolved filename */
    method protected character ResolveTokens(input poOperation as MappedOperation,
                                             input poRequest   as IWebRequest):
        define variable cResolvedFile as character no-undo.
        define variable cSourceFile   as character no-undo.
        
        Assert:NotNull(poRequest, 'Web request ').
        Assert:NotNull(poOperation, 'Mapped operation').
        
        // no tokens? no problem!
        if index(poOperation:TargetName, '$':u) eq 0 then
            return poOperation:TargetName.
        // use the Token Resolver's format and algorithms
        assign cSourceFile   = replace(poOperation:TargetName, '$CATALINA_BASE':u, '$~{env.CATALINA_BASE}':u)
               cSourceFile   = replace(cSourceFile,            '$oepas-webapp':u,  '$~{web.webapp}':u)
               
               cResolvedFile = replace(TokenResolver:Resolve(cSourceFile), StringConstant:BACKSLASH, '/':u)
               .
        return cResolvedFile.
    end method.
    
    /* Reads a file off disk and puts it into the response Entity.
       If the operation is a HEAD request, then do not add the body.
       
       @param MappedOperation The current operation
       @param IWebRequest The source request
       @param IHttpResponse the response
       @return integer The status code to return */
    method protected integer Read(input poOperation as MappedOperation,
                                  input poRequest   as IWebRequest,
                                  input poResponse  as IHttpResponse):
        var memptr mFileContent.
        var File reqFile.
        var Folder webAppPath.
        
        Assert:NotNull(poRequest,   'Web request ').
        Assert:NotNull(poResponse,  'Web Response').
        Assert:NotNull(poOperation, 'Mapped operation').
        
        assign reqFile    = ResolveTarget(poOperation, poRequest)
               webAppPath = new Folder(poRequest:ResolvedWebAppPath)
               .
        ValidatePath(reqFile, webAppPath).
        CanRead(reqFile).
        
        Logger:Debug(substitute('Reading file "&1"', reqFile:AbsoluteFileName())).
        
        assign poResponse:ContentLength = reqFile:Size.
        
        // for HEAD requests, don't bother reading the file
        if not poOperation:Method eq MethodEnum:HEAD then
        do:
            /* Read the file off disk */
            copy-lob from file reqFile:AbsoluteFileName() to mFileContent.
            
            assign poResponse:Entity = new Memptr(mFileContent).
        end.
        
        return 0.
        finally:
            if get-size(mFileContent) gt 0 then
                set-size(mFileContent) = 0.
        end finally.
    end method.
    
    /* Writes a file to disk from the request's Entity
       
       @param MappedOperation The current operation
       @param IWebRequest The source request
       @param IHttpResponse the response
       @return integer The status code to return */
    {&_proparse_ prolint-nowarn(varusage)}
    method protected integer Write(input poOperation as MappedOperation,
                                   input poRequest   as IWebRequest,
                                   input poMessageBody as Progress.Lang.Object,
                                   input poResponse  as IHttpResponse):
        var MessageWriter oFileWriter.
        var File reqFile.
        var Folder webAppPath.
        
        Assert:NotNull(poRequest, 'Web request ').
        Assert:NotNull(poOperation, 'Mapped operation').
        Assert:NotNull(poMessageBody, 'Message body').
        
        assign reqFile    = ResolveTarget(poOperation, poRequest)
               webAppPath = new Folder(poRequest:ResolvedWebAppPath)
               .
        // The file doesn't exist. Check whether we can create the file in its folder
        if not reqFile:FileExists then
        do:
            ValidatePath(reqFile:GetFolder(), webAppPath).
            if not reqFile:CanCreate then
            do:
                Logger:Error(substitute('Unable to create file "&1"', reqFile:AbsolutePath())).
                undo, throw new SendExceptionError(StatusCodeEnum:Forbidden).
            end.
        end.
        else
        do:
            ValidatePath(reqFile, webAppPath).
            Logger:Warn(substitute('File "&1" exists and will be overwritten', reqFile:AbsolutePath())).
        end.
        
        // Check whether we can write to the file/directory
        CanWrite(reqFile).
        
        assign oFileWriter = BodyWriterBuilder:Build(poRequest):Writer.
        if not valid-object(oFileWriter) then
            undo, throw new SendExceptionError(StatusCodeEnum:UnsupportedMediaType).
        
        oFileWriter:Open().
        /* writes the message's contents into the message body */
        oFileWriter:Write(poMessageBody).
        oFileWriter:Close().
        
        copy-lob from cast(oFileWriter:Entity, ByteBucket):Value to file reqFile:Name.
        
        return 0.
    end method.
    
    /* Ensures that the file or folder is in an appropriate location
       
       @param FileInfo the file or folder to validate
       @param Folder The tomcat webapp path */
    method private void ValidatePath(input pPath as FileInfo,
                                     input pWebAppPath as Folder ):
        var character pathType.
        
        if type-of(pPath, File) then
            assign pathType = 'file'.
        else
        if type-of(pPath, Folder) then
            assign pathType = 'directory'.
        else
        // just in case another's added
            assign pathType = 'path'.
        
        if not pPath:Exists then
        do:
            Logger:Error(substitute('Operation target "&1" does not represent a &2', pPath:Name, pathType)).
            undo, throw new SendExceptionError(StatusCodeEnum:NotFound).
        end.
        
        if not pPath:AbsolutePath() begins pWebAppPath:AbsolutePath() then
        do:
            Logger:Error(substitute('&3 "&1" is not located in current webapp: &2', pPath:Name, pWebAppPath:Name, pathType)).
            undo, throw new SendExceptionError(StatusCodeEnum:Forbidden).
        end.
        
        if pPath:AbsolutePath() begins pWebAppPath:AbsolutePath() + '/WEB-INF':u then
        do:
            Logger:Error(substitute('&2 access for "&1" is forbidden', pPath:Name, pathType)).
            undo, throw new SendExceptionError(StatusCodeEnum:Forbidden).
        end.
    end method.

    /* Ensures that we have read permissions for this file or folder
       
       @param FileInfo The file or folder */
    method private void CanRead(input pPath as FileInfo):
        if not pPath:CanRead then
        do:
            Logger:Error(substitute('"&1" does not have read permissions', pPath:Name)).
            undo, throw new SendExceptionError(StatusCodeEnum:Forbidden).
        end.
    end method.
    
    /* Ensures that we have write permissions for this file or folder
       
       @param FileInfo The file or folder */
    method private void CanWrite(input pPath as FileInfo):
        /* just have write permission */
        if not pPath:CanWrite then
        do:
            Logger:Error(substitute('"&1" does not have write permissions', pPath:Name)).
            undo, throw new SendExceptionError(StatusCodeEnum:Forbidden).
        end.
    end method.
    
    /* Creates a File instance representing the operation's target
       Relative operation targets are made relative to the webapp's folder.
       
       @param MappedOperation The current operation.
       @param IWebRequest The request being serviced
       @return File A file instance representing the operation target path/file */
    method private File ResolveTarget(input pOperation as MappedOperation,
                                      input pRequest as IWebRequest):
        var File f = new File(ResolveTokens(pOperation, pRequest)).
        
        if f:Exists then
            return f.
        
        // if the target is just a file name, no folder, then add to webapp path
        if f:Folder eq '' then
        do:
            assign f = new File(pRequest:ResolvedWebAppPath + f:Basename).
            Logger:Warn(substitute('Directory not specified in operation target (&1). Default to the webapp~'s root dir: &2',
                                    pOperation:TargetName, pRequest:ResolvedWebAppPath)).
        end.
        
        if f:IsRelativePath then
        do:
            if f:Folder begins './' then
                assign f = new File(pRequest:ResolvedWebAppPath + substring(f:Name, 3)).
            else
                assign f = new File(pRequest:ResolvedWebAppPath + f:Name).
        end.
        
        return f.
    end method.
    
    /* Deletes a file from disk
       
       @param MappedOperation The current operation
       @param IWebRequest The source request
       @param IHttpResponse the response
       @return integer The status code to return */
    method protected integer Remove(input poOperation as MappedOperation,
                                    input poRequest  as IWebRequest,
                                    input poResponse as IHttpResponse):
        var File reqFile.
        var Folder webAppPath.
        
        Assert:NotNull(poRequest, 'Web request ').
        Assert:NotNull(poResponse, 'Web Response').
        Assert:NotNull(poOperation, 'Mapped operation').
        
        assign reqFile    = ResolveTarget(poOperation, poRequest)
               webAppPath = new Folder(poRequest:ResolvedWebAppPath)
               .
        ValidatePath(reqFile, webAppPath).
        CanWrite(reqFile).
        
        if not reqFile:Delete() then
        do:
            Logger:Error(substitute('Unable to remove file "&1". Error: &2',
                                    reqFile:AbsoluteFileName(),
                                    string(OsErrorEnum:GetEnum(os-error)))).
            undo, throw new SendExceptionError(StatusCodeEnum:InternalServerError).
        end.
        
        return 0.
    end method.
    
end class.