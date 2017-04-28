/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
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
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.ISupportLogging.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using OpenEdge.Net.HTTP.Filter.Writer.BodyWriterBuilder.
using OpenEdge.Net.HTTP.Filter.Writer.EntityWriterBuilder.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.MethodEnum.
using OpenEdge.Net.HTTP.StatusCodeEnum.
using OpenEdge.Net.HTTP.StatusCodeHelper.
using OpenEdge.Web.DataObject.IOperationHandler.
using OpenEdge.Web.DataObject.MappedOperation.
using OpenEdge.Web.IWebRequest.
using OpenEdge.Web.SendExceptionError.
using Progress.Lang.AppError.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Web.DataObject.FileOperationHandler.

class OpenEdge.Web.DataObject.FileOperationHandler implements ISupportLogging, IOperationHandler:
    // A reference to the Logger in use by an implementer
    define public property Logger as ILogWriter no-undo get. set.

    define private variable mcInstanceRoot as character no-undo.
    
    constructor public FileOperationHandler():
        assign mcInstanceRoot = replace(os-getenv ('CATALINA_BASE':u), '~\':u, '/':u).
               Logger         = LoggerBuilder:GetLogger(get-class(FileOperationHandler))
               .
    end constructor.
    
    /* Executes the operation.  
       
       @param IWebRequest The request that resulting in the exception
       @param P.L.Object The message body of the incoming request. Typically 
                         will be transformed from bytes into something useful; may also have an envelope removed. 
       @param IHttpResponse The current response object, if any
       @param MappedOperation The mapped operation
       @param P.L.Object The business entity (business logic service)  
       @return integer A non-null status code use to deal with errors */
    method public integer Execute(input poRequest  as IWebRequest,
                                  input poMessageBody as Progress.Lang.Object,
                                  input poResponse as IHttpResponse,
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
        define variable cSourceFile as character no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable cEntry as character no-undo.
        define variable cName as character no-undo.
        define variable cValue as character no-undo.
        define variable cDelim as character no-undo.
        
        Assert:NotNull(poRequest, 'Web request ').
        Assert:NotNull(poOperation, 'Mapped operation').
        
        assign cSourceFile = replace(poOperation:TargetName, '~\':u, '/':u)
               iMax        = num-entries(cSourceFile, '/':u)
               cDelim      = '':u
               .
        do iLoop = 1 to iMax while index(cSourceFile, '$':u) gt 0:
            assign cEntry = entry(iLoop, cSourceFile, '/':u).
            if cEntry begins '$':u then
            do:
                case cEntry:
                    when '$CATALINA_BASE':u then
                        assign cValue = mcInstanceRoot.
                    when '$oepas-webapp':u then
                    do:
                        assign cValue = left-trim(poRequest:WebAppPath, '/':u).
                        if cValue eq '':u then
                            assign cValue = 'ROOT':u.
                    end.
                    otherwise
                    do:
                        assign cValue = os-getenv(substring(cEntry, 2)).
                        if cValue eq ? then
                            assign cValue = cEntry.
                    end.
                end case.
                if cValue ne ? then
                do:
                    Logger:Info(substitute('Token "&1" replaced by "&2" ', cEntry, cValue)).
                    assign cEntry = cValue.
                end.
            end.

            assign cResolvedFile = cResolvedFile + cDelim + cEntry
                   cDelim = '/':u.
        end.
                
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
        define variable mFileContent as memptr no-undo.
        define variable iStatusCode as integer no-undo.
        define variable oEntity as Progress.Lang.Object no-undo.
        define variable oEntityWriter as MessageWriter no-undo.
        define variable iBytesWritten as int64 no-undo.
        
        Assert:NotNull(poRequest,   'Web request ').
        Assert:NotNull(poResponse,  'Web Response').
        Assert:NotNull(poOperation, 'Mapped operation').
                            
        assign iStatusCode         = 0
               file-info:file-name = ResolveTokens(poOperation, poRequest).
        if file-info:full-pathname eq ? then
        do:
            assign poResponse:StatusCode   = integer(StatusCodeEnum:NotFound)
                   poResponse:StatusReason = StatusCodeHelper:GetMessage(StatusCodeEnum:NotFound)
                   poResponse:ContentType  = '':u.
            
            Logger:Error(substitute('Unable to find file &1', file-info:file-name)).
            undo, throw new SendExceptionError(StatusCodeEnum:NotFound,
                                               new AppError(substitute('Unable to find file &1', file-info:file-name), 0)).
        end.
        
        Logger:Debug(substitute('Reading from file &1', file-info:full-pathname)).
                   
        VerifyReadAccess(file-info:handle, left-trim(poRequest:WebAppPath, '/':u)).                            
        
        /* Read the file off disk */
        copy-lob from file file-info:full-pathname to mFileContent.
        
        /* Convert it to a real/strong Object, if possible. If not, simply
           return content. */
        assign oEntityWriter = EntityWriterBuilder:Build(poResponse):Writer.
        if valid-object(oEntityWriter) then
        do on error undo, throw:
            oEntityWriter:Open().
            assign iBytesWritten = oEntityWriter:Write(mFileContent).
            oEntityWriter:Close().
            
            /* get the nicely-formatted/parsed body and add it to the response */
            assign oEntity = oEntityWriter:Entity.
            
            catch oError as Progress.Lang.Error:
                Logger:Error('READ FILE':u, oError).
                Logger:Error('READ FILE: Response entity contains raw message body':u). 
                Logger:Error(substitute('READ FILE: Response Content-Type changed from &1 to application/octet-stream':u,
                                       poResponse:ContentType)).
                                       
                assign oEntity                = new Memptr(mFileContent)
                       poResponse:ContentType = 'application/octet-stream':u
                       .
            end catch.
        end.
        else
            assign oEntity       = new Memptr(mFileContent)
                   iBytesWritten = get-size(mFileContent)
                   .
        assign poResponse:Entity        = oEntity  
               poResponse:ContentLength = iBytesWritten               
               .
        return iStatusCode.
        finally:
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
                
        Assert:NotNull(poRequest, 'Web request ').
        Assert:NotNull(poOperation, 'Mapped operation').
        Assert:NotNull(poMessageBody, 'Message body').
        
        assign file-info:file-name = ResolveTokens(poOperation, poRequest).
        if file-info:full-pathname eq ? then
            undo, throw new AppError(substitute('Unable to service request for &1 &2', poRequest:Method, poRequest:URI:ToString()),
                            0).
        
        VerifyWriteAccess(file-info:handle, poRequest:WebAppPath).
        
        assign oFileWriter = BodyWriterBuilder:Build(poRequest)
                                    :Writer.
        if not valid-object(oFile) then
            undo, throw new SendExceptionError(StatusCodeEnum:UnsupportedMediaType).
        
        oFileWriter:Open().
        /* writes the message's contents into the message body */
        oFileWriter:Write(poMessageBody).
        oFileWriter:Close().
        
        assign oFile = cast(oFileWriter:Entity, ByteBucket):GetBytes().
        
        copy-lob from oFile:Value to file file-info:full-pathname.
        
        return 0.
    end method.
    
    /* Ensures that we have write permissions for this file
       
       @param handle The FILE-INFO handle representing the file
       @param character The tomcat webapp name */
    method private void VerifyWriteAccess(input phFile as handle,
                                          input pcWebAppPath as character):
        /* must be a file */
        if index(phFile:file-type, 'F':u) eq 0 then
        do:
            Logger:Error(substitute('Filename "&1" does not represent a file', phFile:file-name)).
            undo, throw new SendExceptionError(StatusCodeEnum:BadRequest).
        end.
        
        /* Warn if the file is outside the instance and webapp */
        if not phFile:full-pathname begins mcInstanceRoot then
            Logger:Warn(substitute('File "&1" is not located in current instance: &2', 
                            phFile:file-name, mcInstanceRoot)).
        else
        if not phFile:full-pathname begins substitute('&1/webapps/&2/':u,
                                                mcInstanceRoot, pcWebAppPath) then
            Logger:Warn(substitute('File "&1" is not located in current webapp: &2', 
                                phFile:file-name, pcWebAppPath)).
        
        /* no paths/relative paths allowed*/
        if phFile:file-name begins '.':u or
           phFile:file-name begins '/':u or
           phFile:file-name begins '~\':u then 
        do:
            Logger:Error(substitute('Filename "&1" cannot start with: . / \ ', phFile:file-name)).
            undo, throw new SendExceptionError(StatusCodeEnum:BadRequest).
        end.
        
        /* just have write permission */
        if index(phFile:file-type, 'W':u) eq 0 then
        do:
            Logger:Error(substitute('Filename "&1" does not have write permissions', phFile:file-name)).
            undo, throw new SendExceptionError(StatusCodeEnum:Forbidden).
        end.
    end method. 

    /* Ensures that we have read permissions for this file
       
       @param handle The FILE-INFO handle representing the file
       @param character The tomcat webapp name */
    method private void VerifyReadAccess(input phFile as handle,
                                         input pcWebAppPath as character):
        define variable cFullName as character no-undo.
        if pcWebAppPath eq '':u then
            assign pcWebAppPath = 'ROOT':u.
        
        /* must be a file */
        if index(phFile:file-type, 'F':u) eq 0 then
        do:
            Logger:Error(substitute('File "&1" does not represent a file', phFile:file-name)).
            undo, throw new SendExceptionError(StatusCodeEnum:BadRequest).
        end.
        
        assign cFullName = replace(phFile:full-pathname, '~\':u, '/':u).             
        /* Warn if the file is outside the instance and webapp */
        if not cFullName begins mcInstanceRoot then
            Logger:Warn(substitute('File "&1" is not located in current instance: &2', 
                            phFile:file-name, mcInstanceRoot)).
        else
        if not cFullName begins substitute('&1/webapps/&2/':u,
                                                mcInstanceRoot, pcWebAppPath) then
            Logger:Warn(substitute('File "&1" is not located in current webapp: &2', 
                            phFile:file-name, pcWebAppPath)).
        
        /* no paths/relative paths allowed*/
        if phFile:file-name begins '.':u or
           phFile:file-name begins '/':u or
           phFile:file-name begins '~\':u then 
        do:
            Logger:Error(substitute('File "&1" cannot start with: . / \ ', 
                            phFile:file-name)).
            undo, throw new SendExceptionError(StatusCodeEnum:BadRequest).
        end.
        
        /* just have write permission */
        if index(phFile:file-type, 'R':u) eq 0 then
        do:
            Logger:Error(substitute('File "&1" does not have read permissions', phFile:file-name)).
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
        if file-info:full-pathname eq ? then
            undo, throw new AppError(substitute('Unable to service request for &1 &2', poRequest:Method, poRequest:URI:ToString()),
                            0).
        
        VerifyWriteAccess(file-info:handle, poRequest:WebAppPath).
        
        os-delete value(file-info:full-pathname).
        if os-error gt 0 then
            undo, throw new AppError(substitute('Unable to perform action. Error: &1', os-error), 0).
        
        return 0.
    end method.                                                     
    
end class.