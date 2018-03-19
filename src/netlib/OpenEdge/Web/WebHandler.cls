/************************************************
Copyright (c) 2015-2017 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
   Purpose     : Abstract class to use as a basis for building WebSpeed for
                 PASOE request handlers
   Syntax      : 
   Description : 
   Author(s)   : mbanks
   Created     : Wed Jan 14 14:38:25 EST 2015
   Notes       : * Concrete child classes must implement the HandleNotImplemented and
                   HandleNotAllowedMethod methods so which are the baseline on 
                   we control the messages back (either created entirely in ABL or
                   served by PASOE).
                 * Concrete child classes MAY implement HandleException if they want
                   to control the way error states are handled. The default is to return 
                   an integer status code. 
 ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.ISupportLogging.
using OpenEdge.Logging.LogLevelEnum.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Net.HTTP.MethodEnum.
using OpenEdge.Net.HTTP.StatusCodeEnum.
using OpenEdge.Net.MimeTypeHelper.
using OpenEdge.Web.IWebRequest.
using OpenEdge.Web.SendExceptionError.
using OpenEdge.Web.WebRequest.
using Progress.Web.IWebHandler.
using OpenEdge.Web.WebHandler.

class OpenEdge.Web.WebHandler abstract
            implements IWebHandler, ISupportLogging :

    // A reference to the Logger in use by an implementer
    define public property Logger as ILogWriter no-undo get. set.
    
    /* Default constructor */
    constructor public WebHandler():
        assign this-object:Logger = LoggerBuilder:GetLogger(get-class(WebHandler)).
    end constructor.
    
    /* Handle request by calling the specific handler for the request method
       
       @return integer An HTTP status code. Zero means that the webhandler will take care of
                       any errors. A non-zero value means that the PASOE webapp's error handling 
                       will return a standard page for the error */
    method public integer HandleRequest( ):
        define variable webRequest as IWebRequest no-undo.
        define variable httpStatus as integer no-undo.
        
        assign webRequest = new WebRequest()
               httpStatus = integer(StatusCodeEnum:None)
               .
        /* Check http method and dispatch to corresponding handler */
        case MethodEnum:GetEnum(webRequest:Method):
            when MethodEnum:DELETE  then assign httpStatus = HandleDelete(webRequest).
            when MethodEnum:GET     then assign httpStatus = HandleGet(webRequest).
            when MethodEnum:HEAD    then assign httpStatus = HandleHead(webRequest).
            when MethodEnum:OPTIONS then assign httpStatus = HandleOptions(webRequest).
            when MethodEnum:POST    then assign httpStatus = HandlePost(webRequest).
            when MethodEnum:PUT     then assign httpStatus = HandlePut(webRequest).
            when MethodEnum:TRACE   then assign httpStatus = HandleTrace(webRequest).
            when MethodEnum:PATCH   then assign httpStatus = HandlePatch(webRequest).
            otherwise                    assign httpStatus = HandleNotImplemented(webRequest).
        end case.
        
        // Assume no malice here, just now knowing/forgetting to RETURN <int>.
        if httpStatus eq ? then
        do:
            Logger:Debug(substitute('&1 method handler returned status code of ?; default to 0/zero', webRequest:Method)).
            assign httpStatus = 0.
        end.
        
        /* good */
        return httpStatus.
        /* catch everything and deal with it */
        catch oError as Progress.Lang.Error:
            /* run with no-error to suppress any further errors being thrown up.
               if we have a unknown status, then we will return 0 since we can't
               really throw errors here. */
            assign httpStatus = HandleException(oError, webRequest) no-error.
            if httpStatus eq ? then
            do:
                Logger:Info(substitute('EXCEPTION STATUS CODE UNKNOWN: &1 &2', webRequest:Method, webRequest:URI:Path)).
                Logger:Info('EXCEPTION STATUS CODE UNKNOWN: 0/ZERO RETURNED').
                assign httpStatus = 0.
            end.
            return httpStatus.
        end catch.
    end method.
    
    /* Handles an exception that has been raised while dealing with the request 
    
       @param Progress.Lang.Error The as-yet-unhandled exception
       @param IWebRequest The request that resulting in the exception
       @return integer A non-null status code use to deal with errors */
    method protected integer HandleException(input poError as Progress.Lang.Error,
                                             input poRequest as IWebRequest):
        define variable iReturnCode as integer no-undo.
        
        assign iReturnCode = integer(StatusCodeEnum:None).
        
        if not valid-object(poError) then
            assign iReturnCode = integer(StatusCodeEnum:InternalServerError).             
        else
        do:
            /* bad: We know something went wrong, and we were told what */
            if type-of(poError, SendExceptionError) then
                assign iReturnCode = integer(cast(poError, SendExceptionError):StatusCode).
            else            
                assign iReturnCode = integer(StatusCodeEnum:InternalServerError).             
            
            // Raise a Trace event to get the exception name and call stack 
            Logger:Error(substitute('Request error for &1 &2: status code &3', 
                                poRequest:Method,
                                poRequest:URI:Path,
                                iReturnCode), 
                         poError).
        end.
        
        return iReturnCode.
    end method.
    
    /* Handler for unsupported methods
       
       @param IWebRequest The request being serviced 
       @return integer An optional status code. A zero or null value means this 
                              method will deal with all errors */
    method abstract protected integer HandleNotAllowedMethod(input poRequest as IWebRequest).
       
    /* Handler for unknown methods
       
       @param IWebRequest The request being serviced 
       @return integer An optional status code. A zero or null value means this 
                              method will deal with all errors */
    method abstract protected integer HandleNotImplemented(input poRequest as IWebRequest).
       
    /* Default handler for the HTTP DELETE method
       
       @param IWebRequest The request being serviced 
       @return integer An optional status code. A zero or null value means this 
                              method will deal with all errors */
    method protected integer HandleDelete(input poRequest as IWebRequest):
        return HandleNotAllowedMethod(poRequest).    
    end method.

    /* Default handler for the HTTP GET method
       
       @param IWebRequest The request being serviced 
       @return integer An optional status code. A zero or null value means this 
                              method will deal with all errors */
    method protected integer HandleGet(input poRequest as IWebRequest):
        return HandleNotAllowedMethod(poRequest).    
    end method.

    /* Default handler for the HTTP POST method
       
       @param IWebRequest The request being serviced 
       @return integer An optional status code. A zero or null value means this 
                              method will deal with all errors */
    method protected integer HandlePost(input poRequest as IWebRequest):
        return HandleNotAllowedMethod(poRequest).    
    end method.

    /* Default handler for the HTTP PUT method
       
       @param IWebRequest The request being serviced 
       @return integer An optional status code. A zero or null value means this 
                              method will deal with all errors */
    method protected integer HandlePut(input poRequest as IWebRequest):
        return HandleNotAllowedMethod(poRequest).    
    end method.

    /* Default handler for the HTTP PATCH method
       
       @param IWebRequest The request being serviced 
       @return integer An optional status code. A zero or null value means this 
                              method will deal with all errors */
    method protected integer HandlePatch(input poRequest as IWebRequest):
        return HandleNotAllowedMethod(poRequest).    
    end method.

    /* Default handler for the HTTP HEAD method
       
       @param IWebRequest The request being serviced 
       @return integer An optional status code. A zero or null value means this 
                              method will deal with all errors */
    method protected integer HandleHead(input poRequest as IWebRequest):
        return HandleNotAllowedMethod(poRequest).    
    end method.

    /* Default handler for the HTTP OPTIONS method
       
       @param IWebRequest The request being serviced 
       @return integer An optional status code. A zero or null value means this 
                              method will deal with all errors */
    method protected integer HandleOptions(input poRequest as IWebRequest):
         return HandleNotAllowedMethod(poRequest).    
    end method.
        
    /* Default handler for the HTTP TRACE method
       
       @param IWebRequest The request being serviced 
       @return integer An optional status code. A zero or null value means this 
                              method will deal with all errors */
    method protected integer HandleTrace(input poRequest as IWebRequest):
        return HandleNotAllowedMethod(poRequest).    
    end method.
    
    /** Logs a message 
        
        @param character The message to log
        @param integer  The level this message should be logged at */
    method protected void LogMessage(input pcMessage as character,
                                     input piLogLevel as integer):
        case piLogLevel:
            when integer(LogLevelEnum:FATAL) then Logger:Fatal(pcMessage).
            when integer(LogLevelEnum:ERROR) then Logger:Error(pcMessage).
            when integer(LogLevelEnum:WARN ) then Logger:Warn(pcMessage).
            when integer(LogLevelEnum:INFO ) then Logger:Info(pcMessage).
            when integer(LogLevelEnum:DEBUG) then Logger:Debug(pcMessage).
            when integer(LogLevelEnum:TRACE) then Logger:Trace(pcMessage).
            otherwise 
                Logger:Warn(pcMessage).
        end case.
    end method.
    
    /* Ensures that the request's Accept header and the operation's 
       ContentType values are compatible, per https://tools.ietf.org/html/rfc7231#section-5.3.2
       
       ContentType must be a complete type/subtype.
       Accept may contain type/subtype, type/<star> or <star>/<star> values. If <star>/<star>
       values appear the we can service the request.
       
       @param IWebRequest The request that resulting in the exception
       @param character The MIME type we're wanting to return (usally from the operation) 
       @return logical TRUE if the operation's ContentType is compatible with the request's Accept value */
    method protected logical CanAcceptContentType(input pRequest as IWebRequest,                                              
                                                  input pContentType as character):
        define variable reqAccept as character no-undo.
        define variable cnt as integer no-undo.
        define variable maxTypes as integer no-undo.
        define variable canAccept as logical no-undo.
        define variable reqCType as character extent 2 no-undo.
        define variable compCType as character extent 2 no-undo.
        
        Assert:NotNull(pRequest, 'Request').
        Assert:NotNullOrEmpty(pContentType, 'Content type').
        
        // We assume */* with no Accept header (ie accept all)
        if not pRequest:HasHeader('Accept':u) then
            return true.
        
        assign reqAccept = pRequest:GetHeader('Accept':u):Value
               maxTypes  = num-entries(reqAccept)
               .
        Logger:Debug(substitute('Request "Accept" header: &1', reqAccept)).
        Logger:Debug(substitute('Response Content-Type: &1', pContentType)).
        
        assign canAccept = false
               compCType = MimeTypeHelper:SplitType(pContentType)
               .
        do cnt = 1 to maxTypes while not canAccept:
            assign reqCType = MimeTypeHelper:SplitType(entry(cnt, reqAccept))
                   .
            // stars mean anything goes; exact match means we're good here          
            if    (reqCType[1] eq '*':u        and reqCType[2] eq '*':u) 
               or (reqCType[1] eq compCType[1] and reqCType[2] eq compCType[2]) 
               then
            do:
                assign canAccept = true.
                leave.
            end.
            
            // unless the request is * (done above) we want a match
            if reqCType[1] ne compCType[1] then
                next.
            
            // *-groups and exact matches
            if    reqCType[2] eq '*':u
               or reqCType[2] eq compCType[2] 
               then
            do:
                assign canAccept = true.
                leave.
            end.
        end.
        
        return canAccept.
    end method.
    
end class.