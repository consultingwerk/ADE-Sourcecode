/* *************************************************************************************************************************
Copyright (c) 2016, 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
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
using OpenEdge.Core.Memptr.
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

class OpenEdge.Web.DataObject.FileOperationHandler implements ISupportLogging, IOperationHandler:
    /* A reference to the Logger in use by an implementer */
    define public property Logger as ILogWriter no-undo get. set.

    define private variable mcInstanceRoot as character no-undo.
    
    constructor public FileOperationHandler():
        assign mcInstanceRoot = replace(os-getenv ('CATALINA_BASE':u), StringConstant:BACKSLASH, '/':u).
               Logger         = LoggerBuilder:GetLogger(get-class(FileOperationHandler))
               .
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
                                  input pService as DataObjectService,
                                  input poOperation as MappedOperation, 
                                  input poBusinessEntity as Progress.Lang.Object):
        /* default behaviour is to handle this ourselves */
        define variable iStatusCode as integer no-undo initial 0.
        
        Assert:NotNull(poRequest,   'Web request').
        Assert:NotNull(poResponse,  'Web response').
        Assert:NotNull(poOperation, 'Mapped operation').
        
        case poOperation:Method:
            when MethodEnum:GET then
                assign iStatusCode = this-object:Read(poOperation, poRequest, poResponse).
            
            when MethodEnum:HEAD then
                assign iStatusCode       = this-object:Read(poOperation, poRequest, poResponse)
                       poResponse:Entity = ?.
            
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
        define variable iLoop         as integer   no-undo.
        define variable iMax          as integer   no-undo.
        define variable cEntry        as character no-undo.
        define variable cName         as character no-undo.
        define variable cValue        as character no-undo.
        define variable cDelim        as character no-undo.
        define variable startPos as integer no-undo.
        define variable endPos as integer no-undo.
        
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
    
    /* Reads a file off disk and puts it into the response Entity
       
       @param MappedOperation The current operation
       @param IWebRequest The source request
       @param IHttpResponse the response
       @return integer The status code to return */
    method protected integer Read(input poOperation as MappedOperation,
                                  input poRequest   as IWebRequest,
                                  input poResponse  as IHttpResponse):  
        define variable mFileContent  as memptr               no-undo.
        define variable iStatusCode   as integer              no-undo.
        define variable oEntity       as Progress.Lang.Object no-undo.
        define variable oEntityWriter as MessageWriter        no-undo.
        define variable iBytesWritten as int64                no-undo.
        
        Assert:NotNull(poRequest,   'Web request ').
        Assert:NotNull(poResponse,  'Web Response').
        Assert:NotNull(poOperation, 'Mapped operation').
        
        assign iStatusCode         = 0
               file-info:file-name = ResolveTokens(poOperation, poRequest)
               .
        if     file-info:full-pathname eq ?
           and r-index(substitute(file-info:file-name, StringConstant:BACKSLASH, '/':u), '/':u) eq 0 
        then
        do:
            assign file-info:file-name = poRequest:ResolvedWebAppPath + poOperation:TargetName. //file-info:file-name.
            Logger:Warn(substitute('Directory not specified in operation target (&1). Default to the webapp~'s root dir: &2', 
                            poOperation:TargetName, poRequest:ResolvedWebAppPath)).
        end.
        
        ValidateFile(file-info:handle, poRequest:ResolvedWebAppPath).
        CanRead(file-info:handle).
        
        Logger:Debug(substitute('Reading file "&1"', file-info:full-pathname)).
        
        /* Read the file off disk */
        copy-lob from file file-info:full-pathname to mFileContent.
        
        assign poResponse:Entity = new Memptr(mFileContent).
        
        return iStatusCode.
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
    method protected integer Write(input poOperation as MappedOperation,
                                   input poRequest   as IWebRequest,
                                   input poMessageBody as Progress.Lang.Object,
                                   input poResponse  as IHttpResponse):
        define variable oFileWriter as MessageWriter no-undo.
        define variable oFile as class Memptr no-undo.
        define variable fullPath as character no-undo.
        define variable filePath as character no-undo.
        define variable chrPos as integer no-undo.
        
        Assert:NotNull(poRequest, 'Web request ').
        Assert:NotNull(poOperation, 'Mapped operation').
        Assert:NotNull(poMessageBody, 'Message body').
        
        assign file-info:file-name = ResolveTokens(poOperation, poRequest).
        // The file doesn't exist. Check whether the directory does
        if file-info:full-pathname eq ? then
        do:
            assign filePath = substitute(file-info:file-name, StringConstant:BACKSLASH, '/':u)
                   chrPos   = r-index(filePath, '/':u)
                   .
            // default to the webapps' root dir
            if chrPos eq 0 then
            do:
                assign file-info:file-name = poRequest:ResolvedWebAppPath.
                Logger:Warn(substitute('Directory not specified in operation target (&1). File will be written into the webapp~'s root dir: &2', 
                                poOperation:TargetName, poRequest:ResolvedWebAppPath)).
            end.
            else
                assign file-info:file-name = substring(filePath, 1, chrPos - 1).
            
            ValidateDirectory(file-info:handle, poRequest:ResolvedWebAppPath).
            
            assign fullPath              = file-info:full-pathname + '/':u + substring(filePath, chrPos + 1)
                   poResponse:StatusCode = integer(StatusCodeEnum:Created)
                   .
        end.    // new file
        else
        do:
            ValidateFile(file-info:handle, poRequest:ResolvedWebAppPath).
            Logger:Warn(substitute('File "&1" exists and will be overwritten', file-info:full-pathname)).
            assign fullPath = file-info:full-pathname.
        end.
        
        // check whether we can write to the file/directory
        CanWrite(file-info:handle).
        
        assign oFileWriter = BodyWriterBuilder:Build(poRequest):Writer.
        if not valid-object(oFileWriter) then
            undo, throw new SendExceptionError(StatusCodeEnum:UnsupportedMediaType).
        
        oFileWriter:Open().
        /* writes the message's contents into the message body */
        oFileWriter:Write(poMessageBody).
        oFileWriter:Close().
        
        assign oFile = cast(oFileWriter:Entity, ByteBucket):GetBytes().
        
        copy-lob from oFile:Value to file fullPath.
        
        return 0.
    end method.
    
    /* Ensures that the file is in an appropriate location
       
       @param handle The FILE-INFO handle representing the directory
       @param character The tomcat webapp path */
    method private void ValidateDirectory(input phFile as handle,
                                          input pcWebAppPath as character):
        define variable cFullName  as character no-undo.
        
        /* must be a directory */
        if    phFile:full-pathname eq ?
           or index(phFile:file-type, 'D':u) eq 0
        then
        do:
            Logger:Error(substitute('Operation target "&1" does not represent a directory', phFile:file-name)).
            undo, throw new SendExceptionError(StatusCodeEnum:NotFound).
        end.
        
        assign cFullName    = replace(phFile:full-pathname, StringConstant:BACKSLASH, '/':u)
               pcWebAppPath = right-trim(replace(pcWebAppPath, StringConstant:BACKSLASH, '/':u), '/':u)
               .
        if not cFullName begins pcWebAppPath then 
        do:
            Logger:Error(substitute('Directory "&1" is not located in current webapp: &2', cFullName, pcWebAppPath)).
            undo, throw new SendExceptionError(StatusCodeEnum:Forbidden).
        end.
    end method.
    
    /* Ensures that the file is in an appropriate location
       
       @param handle The FILE-INFO handle representing the file
       @param character The tomcat webapp name */
    method private void ValidateFile(input phFile as handle,
                                     input pcWebAppPath as character):
        define variable cFullName  as character no-undo.
        
        /* must be a file */
        if    phFile:full-pathname eq ?
           or index(phFile:file-type, 'F':u) eq 0
        then
        do:
            Logger:Error(substitute('Operation target "&1" does not represent a file', phFile:file-name)). 
            undo, throw new SendExceptionError(StatusCodeEnum:NotFound).
        end.
        
        assign cFullName    = replace(phFile:full-pathname, StringConstant:BACKSLASH, '/':u)
               pcWebAppPath = right-trim(replace(pcWebAppPath, StringConstant:BACKSLASH, '/':u), '/':u)
               .
        if not cFullName begins pcWebAppPath then
        do:
            logger:Error(substitute('Directory "&1" is not located in current webapp: &2', cFullName, pcWebAppPath)).
            undo, throw new SendExceptionError(StatusCodeEnum:Forbidden).
        end.
        
        if cFullName begins pcWebAppPath + '/WEB-INF':u then
        do:
            Logger:Error(substitute('Directory acccess for "&1" is forbidden', cFullName)).
            undo, throw new SendExceptionError(StatusCodeEnum:Forbidden).
        end.
    end method.
    
    /* Ensures that we have read permissions for this file
       
       @param handle The FILE-INFO handle representing the file */
    method private void CanRead(input phFile as handle):
        /* just have write permission */
        if    phFile:file-type eq ?
           or index(phFile:file-type, 'R':u) eq 0 
        then
        do:
            Logger:Error(substitute('"&1" does not have read permissions', phFile:file-name)).
            undo, throw new SendExceptionError(StatusCodeEnum:Forbidden).
        end.
    end method. 
    
    /* Ensures that we have write permissions for this file
       
       @param handle The FILE-INFO handle representing the file */
    method private void CanWrite(input phFile as handle):
        /* just have write permission */
        if    phFile:file-type eq ?
           or index(phFile:file-type, 'W':u) eq 0
        then
        do:
            Logger:Error(substitute('"&1" does not have write permissions', phFile:file-name)).
            undo, throw new SendExceptionError(StatusCodeEnum:Forbidden).
        end.
    end method. 
    
    /* Deletes a file from disk
       
       @param MappedOperation The current operation
       @param IWebRequest The source request
       @param IHttpResponse the response
       @return integer The status code to return */
    method protected integer Remove(input poOperation as MappedOperation,
                                    input poRequest  as IWebRequest,
                                    input poResponse as IHttpResponse):
        Assert:NotNull(poRequest, 'Web request ').
        Assert:NotNull(poResponse, 'Web Response').
        Assert:NotNull(poOperation, 'Mapped operation').
        
        assign file-info:file-name = ResolveTokens(poOperation, poRequest).
        if     file-info:full-pathname eq ?
           and r-index(substitute(file-info:file-name, StringConstant:BACKSLASH, '/':u), '/':u) eq 0 
        then
        do:
            assign file-info:file-name = poRequest:ResolvedWebAppPath + file-info:file-name.
            Logger:Warn(substitute('Directory not specified in operation target (&1). Default to the webapp~'s root dir: &2', 
                            poOperation:TargetName, poRequest:ResolvedWebAppPath)).
        end.
        
        ValidateFile(file-info:handle, poRequest:ResolvedWebAppPath).
        CanWrite(file-info:handle).
        
        os-delete value(file-info:full-pathname).
        if os-error gt 0 then
        do:
            Logger:Error(substitute('Unable to remove file "&1". Error: &2', file-info:full-pathname, os-error)).
            undo, throw new SendExceptionError(StatusCodeEnum:InternalServerError).
        end.
        
        return 0.
    end method.
    
end class.