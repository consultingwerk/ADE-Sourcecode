/* *************************************************************************************************************************
Copyright (c) 2016-2017 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : DataObjectHandler
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jul 23 10:03:19 EDT 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.DateTimeAddIntervalEnum.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Core.LogicalValue.
using OpenEdge.Core.Memptr.
using OpenEdge.Core.SemanticVersion.
using OpenEdge.Core.String.
using OpenEdge.Core.StringConstant.
using OpenEdge.Core.WidgetHandle.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.ISupportLogging.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using OpenEdge.Net.HTTP.Filter.Writer.EntityWriterBuilder.
using OpenEdge.Net.HTTP.HttpRequestError.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.MethodEnum.
using OpenEdge.Net.HTTP.StatusCodeEnum.
using OpenEdge.Net.HTTP.StatusCodeHelper.
using OpenEdge.Net.MimeTypeHelper.
using OpenEdge.Net.URI.
using OpenEdge.Web.DataObject.DataObjectError.
using OpenEdge.Web.DataObject.DataObjectEventArgs.
using OpenEdge.Web.DataObject.DataObjectHandler.
using OpenEdge.Web.DataObject.DataObjectService.
using OpenEdge.Web.DataObject.HandlerErrorEventArgs.
using OpenEdge.Web.DataObject.HandlerLoadEntityEventArgs.
using OpenEdge.Web.DataObject.IOperationHandler.
using OpenEdge.Web.DataObject.MappedOperation.
using OpenEdge.Web.DataObject.OperationInvocationEventArgs.
using OpenEdge.Web.DataObject.ServiceDiscoveryEventArgs.
using OpenEdge.Web.DataObject.ServiceRegistry.
using OpenEdge.Web.DataObject.TargetTypeEnum.
using OpenEdge.Web.DataObject.Writer.OperationHandlerRegistry.
using OpenEdge.Web.IWebRequest.
using OpenEdge.Web.SendExceptionError.
using OpenEdge.Web.WebRequest.
using OpenEdge.Web.WebResponse.
using OpenEdge.Web.WebResponseWriter.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.AppError.
using Progress.Web.IWebHandler.

class OpenEdge.Web.DataObject.DataObjectHandler implements IWebHandler, ISupportInitialize, ISupportLogging, IOperationHandler:
    
    /* Event published before the service lookup occurs in the registry;  
       
       @param Progress.Lang.Object The handler publishing the event
       @param ServiceLookupEventArgs Event args for this event */
    define static public event DiscoverService signature void (input pSender as Progress.Lang.Object,
                                                               input pEventArgs as ServiceDiscoveryEventArgs). 
    
    /* Event published when an error is encountered 
       
       @param Progress.Lang.Object The handler publishing the event
       @param HandlerErrorEventArgs Event args for this event */
    define static public event OperationError signature void (input poSender as Progress.Lang.Object,
                                                              input poEventArgs as HandlerErrorEventArgs). 
    
    /* Event published to invoke/load a piece of business logic (aka Business Entity).
       
       @param Progress.Lang.Object The handler publishing the event
       @param HandlerLoadEntityEventArgs Event args for this event */
    define static public event LoadEntity signature void (input poSender as Progress.Lang.Object,
                                                          input poEventArgs as HandlerLoadEntityEventArgs). 

    /* Event published to unload a piece of business logic (aka Business Entity).
       
       @param Progress.Lang.Object The handler publishing the event
       @param HandlerLoadEntityEventArgs Event args for this event */
    define static public event UnloadEntity signature void (input poSender as Progress.Lang.Object,
                                                            input poEventArgs as HandlerLoadEntityEventArgs). 
    
    /* Event published before the business logic function is called by the handler
       
       @param Progress.Lang.Object The handler publishing the event
       @param OperationInvocationEventArgs Event args for this event */
    define static public event Invoking signature void (input poSender as Progress.Lang.Object,
                                                        input poEventArgs as OperationInvocationEventArgs). 

    /* Event published after the business logic function was called by the handler 
       
       @param Progress.Lang.Object The handler publishing the event
       @param OperationInvocationEventArgs Event args for this event */
    define static public event Invoked signature void (input poSender as Progress.Lang.Object,
                                                       input poEventArgs as OperationInvocationEventArgs).
    
    // A reference to the Logger in use by an implementer
    define public property Logger as ILogWriter no-undo
        get(): 
            if not valid-object(this-object:Logger) then
                assign this-object:Logger = LoggerBuilder:GetLogger(get-class(DataObjectHandler)).
            
            return this-object:Logger.
        end get.
        set.
    
    /* Holds references to BE's, for cases where there's no external factory/service manager 
       The ServiceName and URI are derived from the URI path, which are CASE-SENSITIVE (see URI/spec RFC3986) */
    define static private temp-table TargetRef no-undo
        field Service as character case-sensitive
        field Version as character
        field EntityName as character
        field Entity as Progress.Lang.Object
        index idx1 as primary unique Service Version EntityName.
    
    /* Default constructor*/
    constructor public DataObjectHandler():
        super().
    end constructor.
    
    destructor DataObjectHandler():
        Destroy().
    end destructor.
    
    /* Handles an exception that has been raised in an event handler used to process
       the request.
       
       @param DataObjectEventArgs A valid event args object 
       @return integer A non-null status code use to deal with errors */
    method protected integer HandleException(input poEventArgs as DataObjectEventArgs):
        Assert:NotNull(poEventArgs, 'Event args').
        return HandleException(poEventArgs:Error,
                               poEventArgs:Request,
                               poEventArgs:Response,
                               poEventArgs:BusinessEntity,
                               poEventArgs:Operation).
    end method.
    
    /* Handles an exception that has been raised while dealing with the request.
       The OE default is to return a status code; to customise, subscribe to the 
       OperationError event  and change the ReturnStatusCode value.
       
       If any errors occur in processing the exception, we log them and
       fall back to static error pages. This method MUST always exectute
       completely.
       
       This method NEVER throws an error
       
       @param Progress.Lang.Error The as-yet-unhandled exception
       @param IWebRequest The request that resulting in the exception
       @param IHttpResponse The current response object, if any
       @param Progress.Lang.Object The 'business entity' object, if any
       @return integer A non-null status code use to deal with errors */
    method protected integer HandleException(input poError    as Progress.Lang.Error,
                                             input poRequest  as IWebRequest,
                                             input poResponse as IHttpResponse,
                                             input poBusinessEntity as Progress.Lang.Object,
                                             input poOperation as MappedOperation):
        define variable oArgs as HandlerErrorEventArgs no-undo.
        define variable oWriter as WebResponseWriter no-undo.
        define variable oEntityWriter as MessageWriter no-undo.
        define variable cEnvelope as character no-undo.
        define variable iStatusCode as integer no-undo.
        define variable cContentType as character no-undo.
        
        Assert:NotNull(poRequest,  'Web request').
        Assert:NotNull(poResponse, 'Web response').
        Assert:NotNull(poError, 'Error').
        
        Logger:Error(substitute('Exception raised for &1 &2; Entity=&3; Operation=&4',
                              poRequest:Method,
                              poRequest:URI:ToString(),
                              (if valid-object(poBusinessEntity) then poBusinessEntity:ToString() else '':u),
                              (if valid-object(poOperation) then poOperation:ToString() else '':u)),
                      poError).
        
        assign oArgs                = new HandlerErrorEventArgs(poRequest, poResponse)
               oArgs:Error          = poError
               oArgs:BusinessEntity = poBusinessEntity
               .
        oArgs:SetOperation(poOperation).
        
        if valid-object(poOperation) then
            assign cContentType = poOperation:ContentType.
        else
            assign cContentType = 'application/json':u.
        
        assign oEntityWriter = EntityWriterBuilder:Build(cContentType)
                                    :Writer.
        
        // if we can find a writer for this content type then write in that format
        if valid-object(oEntityWriter) and
           // we must be able to return something that the client can read
           ValidateContentType(poRequest, cContentType) then
            oEntityWriter:Open().
        else
            // no writer so we use the static pages in PASOE 
            assign oEntityWriter = ?.
               
        /* We have some default behaviour ... which is to return an error code. Use the
           response status for a default */
        if type-of(poError, SendExceptionError) then
        do:
            assign iStatusCode = integer(cast(poError, SendExceptionError):StatusCode).
            Logger:Error(substitute('SendExceptionError status: &1 (&2)', 
                         iStatusCode, cast(poError, SendExceptionError):StatusMessage)).
        end.    // SendExceptionError
        else
            /* all we know is something horrible happened ... */
            assign iStatusCode = integer(StatusCodeEnum:InternalServerError).
        
        assign oArgs:Response:StatusCode   = iStatusCode
               oArgs:Response:StatusReason = StatusCodeHelper:GetMessage(iStatusCode)
               .
        if valid-object(oEntityWriter) then
        do on error undo, throw:
            oEntityWriter:Write(poError).
            oEntityWriter:Close().
            
            assign oArgs:Response:Entity       = oEntityWriter:Entity
                   oArgs:Response:ContentType  = cContentType
                   // we're handling it ourselves 
                   oArgs:ReturnStatusCode     = 0
                   .
            /* Something went wrong while writing the error body.
               Log it and fall back to static error pages. */
            catch oError as Progress.Lang.Error :
                Logger:Error('Error writing exception', oError).
                
                assign oArgs:ReturnStatusCode = iStatusCode.
            end catch.
        end.
        else
            assign oArgs:ReturnStatusCode = iStatusCode.

        /* see if anyone is going to customise this */
        OnOperationError(oArgs).
        
        /* a non-zero value means that we will use the static pages */
        if oArgs:ReturnStatusCode eq 0 then
        do on error undo, throw:
            /* is there an envelope? */
            if     valid-object(poOperation) 
               and poOperation:Options:HasErrorEnvelope
               then
                AddResponseEnvelope(poResponse, poOperation, poOperation:Options:ErrorEnvelope).
        
            WriteResponse(oArgs:Response).
            
            /* Something went wrong while writing the http response.
               Log it and fall back to static error pages. */
            catch oError as Progress.Lang.Error :
                Logger:Error('Error writing response', oError).
                
                assign oArgs:ReturnStatusCode = iStatusCode.
            end catch.
        end.
        
        return oArgs:ReturnStatusCode.
        
        catch oError as Progress.Lang.Error :
            /* Something went wrong while processing errors */
            Logger:Error('Error handling exceptions: using default status code 500/Internal Server Error', oError).
            
            return integer(StatusCodeEnum:InternalServerError).
        end catch.
    end method.
    
    /* Dumps a complete response to the output stream. Does not allow for
       incremental Write() calls. 
       
       @param IHttpResponse The response being written. */
    method protected void WriteResponse(input poResponse as IHttpResponse):
        define variable oStreamWriter as WebResponseWriter no-undo.
                  
        /* dump to stream */
        assign oStreamWriter = new WebResponseWriter(poResponse).
        oStreamWriter:Open().

        finally:
            oStreamWriter:Close().
        end finally.
    end method.
    
    /* Initializer/Startup */
    method public void Initialize():
    end method.
    
    /* Destroy/Shutdown/Anti-Initializer */
    method public void Destroy():
        RemoveAllEntities(this-object:GetClass():TypeName, '').
    end method.
    
/** HANDLING OF THE REQUEST **/    
    /* Returns a usable instance of a business entity/logic class
       
       @param HandlerLoadEntityEventArgs Event args for the operation */
    method protected void InvokeEntity(input pEntityLoadArgs as HandlerLoadEntityEventArgs):
        define variable invokeTime as datetime extent 2 no-undo.
        
        Assert:NotNull(pEntityLoadArgs, 'Entity load event args').
        
        assign invokeTime[1] = now.
        
        OnLoadEntity(pEntityLoadArgs).
        
        if not valid-object(pEntityLoadArgs:BusinessEntity) then
            undo, throw new SendExceptionError(StatusCodeEnum:ServiceUnavailable,
                                               new AppError(substitute('Unable to instantiate business entity &2 &1 ; type-of: &3',
                                                                pEntityLoadArgs:Operation:TargetName,
                                                                pEntityLoadArgs:Operation:TargetType,
                                                                (if valid-object(pEntityLoadArgs:EntityType) then pEntityLoadArgs:EntityType:TypeName else get-class(Progress.Lang.Object):TypeName) ),
                                                            0)).
        
        Logger:Debug(substitute('Using business entity &1 of type &2',
                                pEntityLoadArgs:BusinessEntity,
                                pEntityLoadArgs:BusinessEntity:GetClass():TypeName)).
        
        if valid-object(pEntityLoadArgs:EntityType) then
            Assert:IsType(pEntityLoadArgs:BusinessEntity, pEntityLoadArgs:EntityType).
        
        assign invokeTime[2] = now.
        
        Logger:Debug(substitute('Using entity &1 for operation &2',
                        pEntityLoadArgs:BusinessEntity:ToString(), pEntityLoadArgs:Operation:ToString())).
        Logger:Trace(substitute('Entity &1 invoked in &2(ms)',
                        pEntityLoadArgs:BusinessEntity:ToString(),
                        interval(invokeTime[2], invokeTime[1], string(DateTimeAddIntervalEnum:Milliseconds)))).
    end method.
    
    /* Processes a request. The primary entrypoint into the handler.
       Is just a wrapper around the HandleRequest(IWebRequest) method.
       
       @return integer The HTTP status code that PASOE may use to return static pages. Use 0 for DIY */
    method public integer HandleRequest():
        return HandleRequest(new WebRequest()).
    end method.
    
    /* Creates an HTTP Response object for an operation and populates it with
       default values from that operation.
       
       @param  MappedOperation A valid operation to perform
       @return IHttpResponse  The HTTP response containing the result of the operation */
    method protected IHttpResponse CreateOperationResponse(input poOperation as MappedOperation):
        define variable httpResponse as IHttpResponse no-undo.
        
        Assert:NotNull(poOperation, 'Mapped operation').
        
        // Set the default response values from the operation
        assign httpResponse             = CreateDefaultResponse()
               
               httpResponse:ContentType = poOperation:ContentType
               httpResponse:StatusCode  = poOperation:StatusCode      when poOperation:StatusCode ne 0
               .
        return httpResponse.
    end method.

    /* Creates a default HTTP Response object.
       
       This is in its own method in case of overriding.
       
       @return IHttpResponse  The default HTTP response */
    method protected IHttpResponse CreateDefaultResponse():
        define variable httpResponse as IHttpResponse no-undo.
        
        assign httpResponse = new WebResponse().
        
        return httpResponse.
    end method.
    
    /* Processes a request. Uses an input parameter to allow for better testability/mocking.      
       
       @param IWebRequest The current request
       @return integer The HTTP status code that PASOE may use to return static pages. Use 0 for DIY */
    method protected integer HandleRequest(input poRequest as IWebRequest):
        /* default behaviour is to handle this ourselves */
        define variable iStatusCode as integer no-undo initial 0.
        define variable oResponse as IHttpResponse no-undo.
        define variable oOperation as MappedOperation no-undo.
        define variable oMessageBody as Progress.Lang.Object no-undo.
        define variable oOperationArgs as OperationInvocationEventArgs no-undo.
        define variable oOperationHandler as IOperationHandler no-undo.
        define variable serviceLogger as ILogWriter no-undo.
        define variable dohLogger as ILogWriter no-undo.
        
        //The FindOperation() call should not return a null, but verify since it's an overrideable method
        assign oOperation = FindOperation(poRequest).
        Assert:NotNull(oOperation, 'Mapped operation').
        
        // Set the default response values from the operation
        assign oResponse = CreateOperationResponse(oOperation).
        
        // Use a per-service logger named "OpenEdge.Web.DataObject.DataObjectHandler.<ServiceName>" 
        do on error undo, throw:
            assign serviceLogger = LoggerBuilder:GetLogger(get-class(DataObjectHandler):TypeName + '.':u + oOperation:ServiceName).
            if not serviceLogger:Equals(this-object:Logger) then
            do:
                assign dohLogger          = this-object:Logger
                       this-object:Logger = serviceLogger
                       .
                dohLogger:Info(substitute('Service &1 logging performed by &2 at &3', 
                                    oOperation:ServiceName, serviceLogger:Name, serviceLogger:LogLevel:ToString())).
            end.
            /* Don't fail because we can't log per-service. Use the current logger */
            catch oError as Progress.Lang.Error:
                Logger:Error(substitute('Unable to determine logger for service &1; using default logger &2',
                                        oOperation:ServiceName, this-object:Logger:Name),
                             oError).
            end catch.
        end.
        
        /* the operation must be able to service the request, per the Accept header */
        if not ValidateContentType(poRequest, oOperation:ContentType) then
            undo, throw new SendExceptionError(StatusCodeEnum:NotAcceptable,
                                               new AppError(substitute('Request "Accept" header value "&1" and operation ContentType "&2" value are not compatible',
                                                                 poRequest:GetHeader('Accept':u):Value,
                                                                 oOperation:ContentType),
                                                            0)).
        
        assign iStatusCode = PerformOperation(poRequest,
                                              ExtractMessageBody(poRequest, oOperation),
                                              oResponse, 
                                              oOperation).
        if iStatusCode eq 0 then
        do:
            AddResponseEnvelope(oResponse, oOperation).
            WriteResponse(oResponse).
        end.
        
        return iStatusCode.
        /* errors? */
        catch doErr as DataObjectError:
            assign iStatusCode = HandleException(doErr:Error, doErr:Request, doErr:Response, doErr:BusinessEntity, doErr:Operation).
            return iStatusCode.
        end catch.
        catch oError as Progress.Lang.Error:
            // if there are errors thrown from the FindOperation (run before CreateOperationResponse())
            if not valid-object(oResponse) then
                assign oResponse = CreateDefaultResponse().
            
            assign iStatusCode = HandleException(oError, poRequest, oResponse, ?, oOperation).
            return iStatusCode.
        end catch.
        finally:
            Logger:Trace(substitute('Operation returned status code &1 / &2',
                            iStatusCode,
                            StatusCodeHelper:GetMessage(iStatusCode))).
            // reset the logger
            if valid-object(dohLogger) then 
                assign this-object:Logger = dohLogger.
        end finally.
    end method.
    
    /* Ensures that the request's Accept header and the operation's 
       ContentType values are compatible, per https://tools.ietf.org/html/rfc7231#section-5.3.2
       
       ContentType must be a complete type/subtype.
       Accept may contain type/subtype, type/<star> or <star>/<star> values. If <star>/<star>
       values appear the we can service the request.
       
       @param IWebRequest The request that resulting in the exception
       @param character The MIME type we're wanting to return (usally from the operation) 
       @return logical TRUE if the operation's ContentType is compatible with the request's Accept value */
    method protected logical ValidateContentType(input poRequest as IWebRequest,                                              
                                                 input pcContentType as character):
        define variable cAccept as character no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable lValidType as logical no-undo.
        define variable cReqType as character extent 2 no-undo.
        define variable cOperType as character extent 2 no-undo.
        
        Assert:NotNull(poRequest, 'Request').
        Assert:NotNullOrEmpty(pcContentType, 'Content type').
        
        // We assume */* with no Accept header (ie accept all)
        if not poRequest:HasHeader('Accept':u) then
            return true.

        assign cAccept = poRequest:GetHeader('Accept':u):Value
               iMax    = num-entries(cAccept).
        
        Logger:Debug(substitute('"Accept" value: &1', cAccept)).
        Logger:Debug(substitute('Operation ContentType: &1', pcContentType)).
        
        assign lValidType = false
               cOperType  = MimeTypeHelper:SplitType(pcContentType)
               .
        do iLoop = 1 to iMax while not lValidType:
            assign cReqType = MimeTypeHelper:SplitType(entry(iLoop, cAccept))
                   .
            // stars mean anything goes; exact match means we're good here          
            if (cReqType[1] eq '*':u        and cReqType[2] eq '*':u) or
               (cReqType[1] eq cOperType[1] and cReqType[2] eq cOperType[2]) then
            do:
                assign lValidType = true.
                leave.
            end.
            
            // unless the request is * (done above) we want a match
            if cReqType[1] ne cOperType[1] then
                next.

            // *-groups and exact matches
            if cReqType[2] eq '*':u or
               cReqType[2] eq cOperType[2] then
            do:
                assign lValidType = true.
                leave.
            end.
        end.
        
        return lValidType.
    end method.
    
    /* Internal worker method to do the action defined by a mapped operation
       
       @param IWebRequest The request that resulting in the exception
       @param P.L.Object The message body of the incoming request. Typically 
                         will be transformed from bytes into something useful; may also have an envelope removed.
       @param IHttpResponse The current response object
       @param MappedOperation The mapped operation
       @return integer A non-null status code use to deal with errors */
    method private integer PerformOperation(input poRequest as IWebRequest,
                                            input poMessageBody as Progress.Lang.Object,
                                            input poResponse as IHttpResponse,
                                            input poOperation as MappedOperation):
        define variable iStatusCode as integer no-undo.
        define variable oOperationArgs as OperationInvocationEventArgs no-undo.
        define variable oOperationHandler as IOperationHandler no-undo.
        define variable iTimeout as integer no-undo.
        define variable oStopError as Progress.Lang.Error no-undo.
        define variable operationLogger as ILogWriter no-undo.
        define variable operationTime as datetime no-undo.
        define variable entityArgs as HandlerLoadEntityEventArgs no-undo.
        
        Assert:NotNull(poRequest,   'Web request').
        Assert:NotNull(poResponse,  'Web response').
        Assert:NotNull(poOperation, 'Mapped operation').
        
        assign operationTime       = now
               entityArgs          = new HandlerLoadEntityEventArgs(poRequest, poOperation)
               entityArgs:Response = poResponse
               .
        InvokeEntity(entityArgs).
        
        assign oOperationArgs             = new OperationInvocationEventArgs(poRequest,
                                                                             entityArgs:BusinessEntity,
                                                                             poResponse,
                                                                             poOperation)
               oOperationArgs:RequestBody = poMessageBody
               iStatusCode                = 0
               .
        OnInvoking(oOperationArgs).
        
        /* do the work */
        assign oOperationHandler = GetOperationHandler(poOperation:TargetType)
               operationLogger   = cast(oOperationHandler, ISupportLogging):Logger
               // always use the DOH's logger
               cast(oOperationHandler, ISupportLogging):Logger = this-object:Logger
               
               oStopError        = new HttpRequestError(string(integer(StatusCodeEnum:RequestTimeOut)),
                                             poRequest:Method,
                                             poRequest:URI:ToString()).

        Logger:Trace(substitute('Service &2 &1 &3 handler init time(ms)=&4', 
                            poOperation:ServiceName, 
                            string(poOperation:Method),
                            string(poOperation:TargetType),
                            interval(now, operationTime, string(DateTimeAddIntervalEnum:Milliseconds)))).
        
        assign operationTime = now
               iTimeout      = poOperation:Options:Timeout
               .
        if valid-object(oOperationHandler) then
        do  on stop undo, return error oStopError
            on error undo, throw
            stop-after iTimeout:
            
            assign iStatusCode = oOperationHandler:Execute(poRequest, poMessageBody, poResponse, poOperation, entityArgs:BusinessEntity).
        end.
        else
            undo, throw new AppError(substitute('Unable to service request for "&1 &2"',
                                            poOperation:Method, 
                                            poOperation:ServiceURI), 
                                    0).
        
        Logger:Trace(substitute('Service &2 &1 execute handler time(ms)=&3', 
                            poOperation:ServiceName, 
                            string(poOperation:Method),                            
                            interval(now, operationTime, string(DateTimeAddIntervalEnum:Milliseconds)))).
        
        assign oOperationArgs = new OperationInvocationEventArgs(poRequest, entityArgs:BusinessEntity, poResponse, poOperation)
               oOperationArgs:RequestBody      = poMessageBody
               oOperationArgs:ReturnStatusCode = iStatusCode
               .
        OnInvoked(oOperationArgs).
        if valid-object(oOperationArgs:Error) then
            undo, throw new DataObjectError(oOperationArgs).
        
        return oOperationArgs:ReturnStatusCode.
        catch doeErr as DataObjectError:
            undo, throw doeErr.
        end catch.
        catch err as Progress.Lang.Error:
            define variable dohError as DataObjectError no-undo.
            
            assign dohError                = new DataObjectError()
                   dohError:Error          = err
                   dohError:Request        = poRequest
                   dohError:Response       = poResponse
                   dohError:BusinessEntity = entityArgs:BusinessEntity
                   dohError:Operation      = poOperation
                   .
            undo, throw dohError.
        end catch.
        finally:
            // We're done with this request - tell clients that they can let go
            OnUnloadEntity(entityArgs).
            
            Logger:Trace(substitute('Service &1 operation &2 &3 execution time(ms)=&4', 
                            poOperation:ServiceName, 
                            string(poOperation:Method),
                            poOperation:ServiceURI,
                            interval(now, operationTime, string(DateTimeAddIntervalEnum:Milliseconds)))).
            //reset to original/default. NO-ERROR to avoid trying to do this if the operation handler is invalid 
            assign cast(oOperationHandler, ISupportLogging):Logger = operationLogger no-error.
        end finally.
    end method.
    
    /* Factory method for retrieving an operation handler   
       
       @param character The operation type for which to find a handler
       @return IOperationHandler A handler, if one exists */
    method protected IOperationHandler GetOperationHandler(input pTargetType as character):
        define variable oHandler as IOperationHandler no-undo.
        define variable oHandlerType as class Progress.Lang.Class no-undo.
        
        Assert:NotNullOrEmpty(pTargetType).
        if pTargetType eq string(TargetTypeEnum:Self) then
            return this-object.
        
        assign oHandler = cast(GetEntity(get-class(IOperationHandler):TypeName, '':u, pTargetType),
                               IOperationHandler).
        if not valid-object(oHandler) then
        do:
            assign oHandlerType = OperationHandlerRegistry:Registry:Get(pTargetType).
            
            Assert:IsType(oHandlerType, get-class(IOperationHandler)).
            oHandler = dynamic-new string(oHandlerType:TypeName) ().
            
            if valid-object(oHandler) and type-of(oHandler, ISupportInitialize) then
                cast(oHandler, ISupportInitialize):Initialize().
            
            SetEntity(get-class(IOperationHandler):TypeName, '':u, pTargetType, oHandler).
        end.
        
        return oHandler.
    end method.
    
    /* Lists service names, versions and catalogs for all currently-registered services. 
       
       @param MappedOperation The mapped operation
       @param IWebRequest The request that resulting in the exception
       @param P.L.Object The message body of the incoming request. Typically 
                         will be transformed from bytes into something useful; may also have an envelope removed.
       @param IHttpResponse The current response object, if any
       @return integer A non-null status code use to deal with errors */
    method protected integer ListServices(input poOperation as MappedOperation,
                                          input poRequest  as IWebRequest,
                                          input poMessageBody as Progress.Lang.Object,
                                          input poResponse as IHttpResponse):
        define variable regdSvc as DataObjectService extent no-undo.
        define variable regdOps as MappedOperation extent no-undo.
        define variable oServices as JsonObject no-undo.
        define variable oVersions as JsonArray no-undo.
        define variable svcVersion as JsonObject no-undo.
        define variable svcOps as JsonArray no-undo.
        define variable maxSvc as integer no-undo.
        define variable svcCnt as integer no-undo.
        define variable maxOps as integer no-undo.
        define variable opsCnt as integer no-undo.
        define variable oCatalog as JsonObject no-undo.
        define variable iStatusCode as integer no-undo.
        define variable catalogResponse as IHttpResponse no-undo.
        define variable catalogOperation as MappedOperation no-undo.
        define variable operationURL as URI no-undo.
        
        Assert:NotNull(poOperation, 'Operation').
        Assert:NotNull(poRequest, 'Web request').
        Assert:NotNull(poResponse, 'Web response').
        
        assign oServices         = new JsonObject() 
               poResponse:Entity = oServices
               iStatusCode       = 0
               
               regdSvc           = ServiceRegistry:GetServices()
               maxSvc            = extent(regdSvc)
               .
        do svcCnt = 1 to maxSvc:
            if oServices:Has(regdSvc[svcCnt]:Name) then
                assign oVersions = oServices:GetJsonArray(regdSvc[svcCnt]:Name).
            else
            do:
                assign oVersions = new JsonArray().
                oServices:Add(regdSvc[svcCnt]:Name, oVersions).
            end.
            
            // if there's a catalog registered, use that. otherwise guesstimate 
            if valid-object(regdSvc[svcCnt]:Catalog) then
                assign oCatalog = regdSvc[svcCnt]:Catalog.
            else
            do:
                assign oCatalog         = ?
                       catalogOperation = regdSvc[svcCnt]:GetOperation('dataservice.catalog':u).
                if valid-object(catalogOperation) then
                do:
                    if not ValidateContentType(poRequest, catalogOperation:ContentType) then
                        Logger:Warn(substitute('Request "Accept" header value "&1" and catalog operation ContentType "&2" value are not compatible',
                                        poRequest:GetHeader('Accept':u):Value,
                                        catalogOperation:ContentType)).
                    else
                    do:
                        assign catalogResponse = CreateOperationResponse(catalogOperation).
                        // don't care about the return code, just the content
                        PerformOperation(poRequest, poMessageBody, catalogResponse, catalogOperation)
                            no-error.
                        if type-of(catalogResponse:Entity, JsonObject) then
                            assign oCatalog = cast(catalogResponse:Entity, JsonObject).
                        else
                            Logger:Warn(substitute('Unable to convert catalog for service &1 v&2 to JsonObject', 
                                                regdSvc[svcCnt]:Name,
                                                regdSvc[svcCnt]:Version:ToString())).
                    end.
                end.    // aliased to CATALOG
            end.
            
            assign svcVersion = new JsonObject().
            oVersions:Add(svcVersion).
                        
            svcVersion:Add('version':u, regdSvc[svcCnt]:Version:ToString()).
            
            // add even if null
            svcVersion:Add('catalog':u, oCatalog).
            
            assign svcOps = new JsonArray().
            svcVersion:Add('operations':u, svcOps).
            
            assign extent(regdOps) = ?
                   regdOps         = regdSvc[svcCnt]:GetOperations()
                   maxOps          = extent(regdOps)
                   .
            do opsCnt = 1 to maxOps:
                assign oCatalog     = new JsonObject()
                       
                       operationURL      = new URI(poRequest:URI:Scheme, poRequest:URI:Host, poRequest:URI:Port)
                       operationURL:Path = trim(poRequest:WebAppPath, '/':u)  + '/':u + trim(poRequest:TransportPath, '/':u) + '/' + trim(poRequest:PathInfo, '/':u)
                       .
                oCatalog:Add('uri':u, regdOps[opsCnt]:ServiceURI).
                oCatalog:Add('method':u, string(regdOps[opsCnt]:Method)).
                oCatalog:Add('name':u, regdOps[opsCnt]:Name).
                
                if not regdSvc[svcCnt]:Name eq ServiceRegistry:ROOT_SERVICE_NAME then
                    operationURL:AddPathSegment(regdSvc[svcCnt]:Name).
                if not regdOps[opsCnt]:ServiceURI eq ServiceRegistry:ROOT_SERVICE_URI then
                    operationURL:AddPathSegment(regdOps[opsCnt]:ServiceURI).
                
                oCatalog:Add('url':u, operationURL:ToString()).
                
                svcOps:Add(oCatalog). 
            end.
        end.    // services
        
        return iStatusCode.
    end method.

    /* Publishes the 'ServiceDiscovery' event with the provided args 
    
       @param ServiceDiscoveryEventArgs The args for this event */
    method protected void OnDiscoverService (input poEventArgs as ServiceDiscoveryEventArgs):
        Assert:NotNull(poEventArgs, 'Event args').
        
        DataObjectHandler:DiscoverService:Publish(this-object, poEventArgs).
        
        // Run our local 'handler'
        DiscoverServiceHandler(this-object, poEventArgs).
        
        if valid-object(poEventArgs:Error) then
            undo, throw poEventArgs:Error.
        
        // no error, but stop
        if poEventArgs:Cancel then
            undo, throw new AppError(substitute('Service discovery for &1 version &1 was cancelled',
                                        poEventArgs:Name,
                                        poEventArgs:Version),
                                     0).
    end method.
    
    /* Publishes the 'Invoking' event with the provided args 
    
       @param OperationInvocationEventArgs The args for this event */
    method protected void OnInvoking(input poEventArgs as OperationInvocationEventArgs):
        Assert:NotNull(poEventArgs, 'Event args').
        
        DataObjectHandler:Invoking:Publish(this-object, poEventArgs).
        
        if valid-object(poEventArgs:Error) then
            undo, throw new DataObjectError(poEventArgs).
        
        if poEventArgs:Cancel then
            undo, throw new AppError(substitute('Running of &2 in &1 for operation &2 cancelled',
                                        poEventArgs:Operation:TargetFunction,
                                        poEventArgs:Operation:TargetName, 
                                        poEventArgs:Operation:ToString()),
                                     0).
        catch doe as DataObjectError:
            undo, throw doe.
        end catch.
        catch ple as Progress.Lang.Error:
            assign poEventArgs:Error = ple.
            undo, throw new DataObjectError(poEventArgs).
        end catch.
    end method.
    
    /* Publishes the 'Invoked' event with the provided args 
    
       @param OperationInvocationEventArgs The args for this event */
    method protected void OnInvoked(input poEventArgs as OperationInvocationEventArgs):
        Assert:NotNull(poEventArgs, 'Event args').
        
        DataObjectHandler:Invoked:Publish(this-object, poEventArgs).
        
        if valid-object(poEventArgs:Error) then
            undo, throw new DataObjectError(poEventArgs).
        
        if poEventArgs:Cancel then
            undo, throw new AppError(substitute('Running of &2 in &1 for operation &2 cancelled',
                                        poEventArgs:Operation:TargetFunction,
                                        poEventArgs:Operation:TargetName, 
                                        poEventArgs:Operation:ToString()),
                                     0).
        catch doe as DataObjectError:
            undo, throw doe.
        end catch.
        catch ple as Progress.Lang.Error:
            assign poEventArgs:Error = ple.
            undo, throw new DataObjectError(poEventArgs).
        end catch.
    end method.

    /* Publishes the 'OperationError' event with the provided args 
    
       @param HandlerErrorEventArgs The args for this event */
    method protected void OnOperationError(input poEventArgs as HandlerErrorEventArgs):
        Assert:NotNull(poEventArgs, 'Event args').
        
        DataObjectHandler:OperationError:Publish(this-object, poEventArgs).
    end method.
    
    /* Publishes the 'LoadEntity' event with the provided args 
    
       @param HandlerErrorEventArgs The args for this event */
    method protected void OnLoadEntity(input poEventArgs as HandlerLoadEntityEventArgs):
        Assert:NotNull(poEventArgs, 'Event args').
        
        DataObjectHandler:LoadEntity:Publish(this-object, poEventArgs).
        
        // Run our local 'handler'
        LoadEntityHandler(this-object, poEventArgs).
        
        if valid-object(poEventArgs:Error) then
            undo, throw new DataObjectError(poEventArgs).
        
        if poEventArgs:Cancel then
            undo, throw new AppError(substitute('Business entity &1 load for operation &2 cancelled',
                                        poEventArgs:Operation:TargetName, poEventArgs:Operation:ToString()),
                                     0).
        catch doe as DataObjectError:
            undo, throw doe.
        end catch.
        catch ple as Progress.Lang.Error:
            assign poEventArgs:Error = ple.
            undo, throw new DataObjectError(poEventArgs).
        end catch.
    end method.
    
    /* Publishes the 'UnloadEntity' event with the provided args 
       
       @param HandlerErrorEventArgs The args for this event */
    method protected void OnUnloadEntity(input poEventArgs as HandlerLoadEntityEventArgs):
        Assert:NotNull(poEventArgs, 'Event args').
        
        DataObjectHandler:UnloadEntity:Publish(this-object, poEventArgs).
        
        // Run our local 'handler'
        UnloadEntityHandler(this-object, poEventArgs).
        
        if valid-object(poEventArgs:Error) then
            undo, throw new DataObjectError(poEventArgs).
        
        catch doe as DataObjectError:
            undo, throw doe.
        end catch.
        catch ple as Progress.Lang.Error:
            assign poEventArgs:Error = ple.
            undo, throw new DataObjectError(poEventArgs).
        end catch.
    end method.
    
    /* Executes the operation.  
       
       We don't care about the entity in this handler (since we are the handler)  
       
       @param IWebRequest The request that resulting in the exception
       @param P.L.Object The message body of the incoming request. Typically 
                         will be transformed from bytes into something useful; may also have an envelope removed. 
       @param IHttpResponse The current response object, if any
       @param MappedOperation The mapped operation
       @param P.L.Object The business logic/entity
       @return integer A non-null status code use to deal with errors */
    method public integer Execute(input poRequest as IWebRequest,
                                  input poMessageBody as Progress.Lang.Object,
                                  input poResponse as IHttpResponse,
                                  input poOperation as MappedOperation,
                                  input poBusinessEntity as Progress.Lang.Object):
        /* default behaviour is to handle this ourselves */
        define variable iStatusCode as integer no-undo initial 0.
        
        Assert:NotNull(poRequest,   'Web request').
        Assert:NotNull(poResponse,  'Web response').
        Assert:NotNull(poOperation, 'Mapped operation').
        Assert:NotNull(poBusinessEntity, 'Entity').
        
        case poOperation:TargetFunction:
            when 'ListServices':u then
                assign iStatusCode = this-object:ListServices(poOperation, poRequest, poMessageBody, poResponse).
            otherwise
                assign iStatusCode = integer(StatusCodeEnum:MethodNotAllowed).                
        end case.
        
        return iStatusCode.
    end method.
    
    /* Retrieves a cached entity if one exits
       
       @param character The service name
       @param character The entity name (for an operation)
       @return Progress.Lang.Object The cached entity, if one exists */
    method private Progress.Lang.Object GetEntity (input pcService as character,
                                                   input pVersion as character,
                                                   input pcEntityName as character):
        define variable oBusinessEntity as Progress.Lang.Object no-undo.
        define buffer lbEntity for TargetRef.
        
        Assert:NotNullOrEmpty(pcService, 'Service name').
        Assert:NotNull(pVersion, 'Service version').
        Assert:NotNullOrEmpty(pcEntityName, 'Entity name').
        
        find lbEntity where
             lbEntity.Service eq pcService and
             lbEntity.Version eq pVersion and
             lbEntity.EntityName eq pcEntityName
             no-error.
        if available lbEntity then
            assign oBusinessEntity = lbEntity.Entity.
                 
        return oBusinessEntity.
    end method.
    
    /* Caches an entity instance for a given service & operation 
       
       @param character The service name
       @param character The service version
       @param character The entity name 
       @param Progress.Lang.Object The entity instance. may be null/unknown
       @return logical Returns TRUE if the entity was alrady cached */
    method private logical SetEntity(input pcService as character,
                                     input pVersion as character,
                                     input pcEntityName as character,
                                     input poBusinessEntity as Progress.Lang.Object):
        define variable lExists as logical no-undo.
        define buffer lbEntity for TargetRef.

        Assert:NotNullOrEmpty(pcService, 'Service name').
        Assert:NotNull(pVersion, 'Service version').
        Assert:NotNullOrEmpty(pcEntityName, 'Entity name').
        
        find lbEntity where
             lbEntity.Service eq pcService and
             lbEntity.Version eq pVersion and
             lbEntity.EntityName eq pcEntityName
             no-error.
        assign lExists = available lbEntity. 
        if not lExists then
        do:
            create lbEntity.
            assign lbEntity.Service    = pcService
                   lbEntity.Version    = pVersion
                   lbEntity.EntityName = pcEntityName
                   .
        end.
        
        assign lbEntity.Entity = poBusinessEntity.
        return lExists.                                                
    end method.

    /* Removes a cached entity instance for a given service & operation 
       
       @param character The service name
       @param character The service version
       @param character The entity name */
    method private logical RemoveEntity(input pcService as character,
                                        input pVersion as character,
                                        input pcEntityName as character):
        define variable lExists as logical no-undo.
        define buffer lbEntity for TargetRef.

        Assert:NotNullOrEmpty(pcService, 'Service name').
        Assert:NotNull(pVersion, 'Service version').
        Assert:NotNullOrEmpty(pcEntityName, 'Entity name').
        
        find lbEntity where
             lbEntity.Service eq pcService and
             lbEntity.Version eq pVersion and
             lbEntity.EntityName eq pcEntityName
             no-error.
        assign lExists = available lbEntity. 
        if lExists then
        do:
            Logger:Debug(substitute('Cached entity "&1" removed for service "&2" &3',
                            lbEntity.EntityName, pcService, pVersion)).
            delete lbEntity.
        end.
        
        return lExists.
    end method.

    /* Removes all the cached entity instances for a given service 
    
       @param character The service name 
       @param character The service version */
    method private void RemoveAllEntities(input pcService as character,
                                          input pVersion as character):
        define variable lExists as logical no-undo.
        define buffer lbEntity for TargetRef.

        Assert:NotNullOrEmpty(pcService, 'Service name').
        Assert:NotNull(pVersion, 'Service version').
        
        for each lbEntity where
                 lbEntity.Service eq pcService and
                 lbEntity.Version eq pVersion:
            Logger:Debug(substitute('Cached entity "&1" removed for service "&2" &3',
                            lbEntity.EntityName, pcService, pVersion)).
            delete lbEntity.
        end.
    end method.
    
    /* Retrieves the actual data from an request. Strips the envelop ('request' or similar) 
       
       @param  IWebRequest The incoming request `
       @param  OperationArgument Metadata about what to do with this request
       @return Progress.Lang.Object The extracted body */
    method protected Progress.Lang.Object ExtractMessageBody (input poRequest as IWebRequest,
                                                              input poOperation as MappedOperation):
        define variable oBody as Progress.Lang.Object no-undo.
        define variable oEntityWriter as MessageWriter no-undo.
        
        Assert:NotNull(poOperation, 'Operation'). 
        Assert:NotNull(poRequest, 'Web Request').
        
        /*  Convert the body from bytes into something stronger-typed */
        assign oBody = poRequest:Entity.
        
        Logger:Trace(substitute('Request has body: &1', valid-object(oBody))).
        if valid-object(oBody) then
            Logger:Trace(substitute('Request body: &1 val=&2',
                            oBody:GetClass():TypeName,
                            oBody:ToString())).
        
        /* no body or nothing in it */
        if not valid-object(oBody) then
            return new Memptr(0).
        
        if type-of(oBody, Memptr) and 
           cast(oBody, Memptr):Size eq 0 then
            return oBody.
        
        /* default to using what's in the body as-is.
           We will have either a JsonObject, a WidgetHandle(XML) or Memptr (everything else). */
        if type-of(oBody, Memptr) then
        do:
            if poRequest:ContentType eq '':u then
                Logger:Warn(substitute('Request "&1 &2" has no Content-Type header. The &3 may not be able to process the request properly.',
                                poRequest:Method,
                                poRequest:URI:ToString(),
                                this-object:GetClass():TypeName )).
            else
            do:
                assign oEntityWriter = EntityWriterBuilder:Build(poRequest):Writer.
                if valid-object(oEntityWriter) then
                do:
                    oEntityWriter:Open().
                    oEntityWriter:Write(oBody).
                    oEntityWriter:Close().
                    
                    assign oBody = oEntityWriter:Entity.
                    
                    Logger:Trace(substitute('Request body written as &1 for Content-Type &2',
                                    oBody:GetClass():TypeName,
                                    poRequest:ContentType)).
                end.
                else
                    Logger:Warn(substitute('Unable to find entity writer for Content-Type &3 header for request &1 &2',
                                    poRequest:Method,
                                    poRequest:URI:ToString(),
                                    poRequest:ContentType)).
            end.
        end.
        
        /* is there an envelope? */
        if not poOperation:Options:HasRequestEnvelope
           or  poOperation:Options:RequestEnvelope eq '':u  
           then
            return oBody.
        
        Logger:Info(substitute('Extracting request data from envelope "&1"', poOperation:Options:RequestEnvelope)).
       
        /* now we have the envelope, get the children of it */
        case true:
            when MimeTypeHelper:IsJson(poRequest:ContentType) then
            do:
                Assert:IsType(oBody, get-class(JsonObject)).
                
                if not cast(oBody, JsonObject):Has(poOperation:Options:RequestEnvelope) then
                do:
                    Logger:Warn(substitute('Unable to find envelope "&1" in request &2 &3',
                                poOperation:Options:RequestEnvelope,
                                poRequest:Method,
                                poRequest:URI:ToString())).
                    return oBody.
                end.
                
                case cast(oBody, JsonObject):GetType(poOperation:Options:RequestEnvelope):
                    when JsonDataType:OBJECT  then return cast(oBody, JsonObject):GetJsonObject(poOperation:Options:RequestEnvelope).
                    when JsonDataType:ARRAY   then return cast(oBody, JsonObject):GetJsonArray(poOperation:Options:RequestEnvelope). 
                    when JsonDataType:STRING  then return new OpenEdge.Core.String(cast(oBody, JsonObject):GetCharacter(poOperation:Options:RequestEnvelope)).
                    when JsonDataType:BOOLEAN then return new LogicalValue(cast(oBody, JsonObject):GetLogical(poOperation:Options:RequestEnvelope)).
                    when JsonDataType:NUMBER  then return new OpenEdge.Core.Decimal(cast(oBody, JsonObject):GetDecimal(poOperation:Options:RequestEnvelope)).
                    when JsonDataType:NULL    then return ?.
                end case.
            end.    //JSON
            
            otherwise
                Logger:Warn(substitute('Unable to extract content from envelope &1 for content-type &2',
                                poOperation:Options:RequestEnvelope, poRequest:ContentType)).
        end case.
        
        return oBody. 
    end method.

    /* Adds a 'response' or similar envelope to the body. At this point the incoming body should be
       in 'entity' format (ie non pure bytes).
       
       @param IHttpResponse The outgoing message 
       @param MappedOperation Metadata about what to do with this request 
       @param character The envelope to use. Nulls not allowed; blanks are a no-op */
    method protected void AddResponseEnvelope(input poResponse as IHttpResponse,
                                              input poOperation as MappedOperation,
                                              input pcEnvelope as character):
        define variable oBody as JsonObject no-undo.
        define variable oEntityWriter as MessageWriter no-undo.

        Assert:NotNull(poOperation, 'Mapped operation'). 
        Assert:NotNull(poResponse, 'Response').
        Assert:NotNull(pcEnvelope, 'Response envelope').
        
        if pcEnvelope eq '':u then
            return.
            
        if not valid-object(poResponse:Entity) then
            return.
        
        assign oEntityWriter = EntityWriterBuilder:Build(poResponse):Writer.
        if not valid-object(oEntityWriter) then
        do:
            Logger:Warn(substitute('Unable to find entity writer for &1', poResponse:ContentType)).
            return.
        end.
        
        oEntityWriter:Open().
        oEntityWriter:Write(poResponse:Entity).
        oEntityWriter:Close().
        
        /* now we have the envelope, wrap it */
        case true:
            when MimeTypeHelper:IsJson(poOperation:ContentType) then
            do:
                Assert:IsType(oEntityWriter:Entity, get-class(JsonConstruct)).
                assign oBody = new JsonObject().

                case true:
                    when type-of(oEntityWriter:Entity, JsonObject) then oBody:Add(pcEnvelope, cast(oEntityWriter:Entity, JsonObject)).
                    when type-of(oEntityWriter:Entity, JsonArray)  then oBody:Add(pcEnvelope, cast(oEntityWriter:Entity, JsonArray)).
                end case.
                
                assign poResponse:Entity = oBody.

                Logger:Warn(substitute('Added envelope "&1" for operation &2',
                                pcEnvelope, poOperation:ToString())).
            end.    //JSON
            
            otherwise
                Logger:Warn(substitute('Unable to add envelope &1 for content-type &2',
                                pcEnvelope, poOperation:ContentType)).
        end case.
    end method.
    
    /* Adds a 'response' or similar envelope to the body. At this point the incoming body should be
       in 'entity' format (ie non pure bytes).
       
       @param IHttpResponse The outgoing message 
       @param MappedOperation Metadata about what to do with this request */
    method protected void AddResponseEnvelope(input poResponse as IHttpResponse,
                                              input poOperation as MappedOperation):
        Assert:NotNull(poOperation, 'Mapped operation'). 
        Assert:NotNull(poResponse, 'Response').
        
        /* is there an envelope? */
        if not poOperation:Options:HasResponseEnvelope then
            return.
        
        AddResponseEnvelope(poResponse, poOperation, poOperation:Options:ResponseEnvelope).
    end method.
    
    /* Returns a mapped operation for this request
       
       @param IWebRequest The incoming request 
       @return MappedOperation A valid operation to use for this request. Should not be null, throw instead
       @throws AssertionFailedError Thrown on poor/missing inputs 
       @throws SendExceptionError Thrown if the operation could not be found */
    method protected MappedOperation FindOperation(input poRequest as IWebRequest):
        define variable oOperation as MappedOperation no-undo.
        define variable cServicePaths as character case-sensitive extent no-undo.
        define variable cPathType as character no-undo.
        define variable cUriTemplate as character case-sensitive no-undo.
        define variable discoveryArgs as ServiceDiscoveryEventArgs no-undo.
        
        Assert:NotNull(poRequest, 'Request').
        
        Logger:Trace(substitute('Request received for &1 &2',
                        poRequest:Method, poRequest:URI:ToString())).
        
        // First check for a matych on the actual path (non-tokenised)
        assign discoveryArgs = new ServiceDiscoveryEventArgs(poRequest).
        
        OnDiscoverService(discoveryArgs).
        
        // no service was found
        if not valid-object(discoveryArgs:Service) then
        do:
            Logger:Error(substitute('Service not found for "&1"',
                                    discoveryArgs:Name)).
            return error new SendExceptionError(StatusCodeEnum:NotFound).
        end.
        
        Logger:Trace(substitute('Service "&1" found for "&2 &3"',
                                discoveryArgs:Service:ToString(),
                                poRequest:Method, 
                                poRequest:URI:ToString() )).
        
        assign cPathType = 'service path'.
        Logger:Trace(substitute('Searching for mapped operation for service "&1" with &3 "&2"',
                                string(discoveryArgs:Service), discoveryArgs:ServiceURI, cPathType)).
        
        assign oOperation = discoveryArgs:Service:GetOperation(discoveryArgs:ServiceURI, MethodEnum:GetEnum(poRequest:Method)).
        if not valid-object(oOperation) then
        do:
            // Now check for a match on the tokenised path
            assign cUriTemplate = poRequest:UriTemplate.
            if index(cUriTemplate, StringConstant:CURLY_OPEN) gt 0 then
            do:
                assign cServicePaths            = SplitServicePath(cUriTemplate)
                       discoveryArgs:ServiceURI = cServicePaths[2]
                       .
                // if there are no tokens in the relative URI it's a no-op
                if index(discoveryArgs:ServiceURI, StringConstant:CURLY_OPEN) eq 0 then
                    assign discoveryArgs:ServiceURI = '':u.
                if not discoveryArgs:ServiceURI eq '':u then
                do:
                    assign cPathType = 'URI template'.
                    Logger:Trace(substitute('Searching for mapped operation for service "&1" with &3 "&2"',
                                            discoveryArgs:Service:Name, discoveryArgs:ServiceURI, cPathType)).
                    assign oOperation = discoveryArgs:Service:GetOperation(discoveryArgs:ServiceURI, MethodEnum:GetEnum(poRequest:Method)).
                end.
            end.
        end.
        
        if not valid-object(oOperation) then
        do:
            Logger:Error(substitute('Mapped operation not found for service "&1" with &3 "&2"',
                                    discoveryArgs:Service:Name, discoveryArgs:ServiceURI, cPathType)).
            return error new SendExceptionError(StatusCodeEnum:NotFound).
        end.
        
        Logger:Debug(substitute('Using mapped operation for &1 &4 &2: &3',
                        string(oOperation:Method),
                        discoveryArgs:ServiceURI,
                        string(oOperation),
                        cPathType)).        
        
        return oOperation.
    end method.

    /* Event handler to unload a piece of business logic (aka Business Entity).
       
       @param Progress.Lang.Object The handler publishing the event
       @param HandlerLoadEntityEventArgs Event args for this event */
    method public void UnloadEntityHandler(input pSender as Progress.Lang.Object,
                                           input pEventArgs as HandlerLoadEntityEventArgs):
        // If we have unloaded the entity, or something already went wrong, return
        if not valid-object(pEventArgs:BusinessEntity)
           or pEventArgs:Cancel
           or valid-object(pEventArgs:Error)
           then
            return.
        
        case pEventArgs:Request:GetContextValue('SERVLET_SRVR_DEBUG':u):
            /* rules per web/objects/web-util.p */
            when 'On':u or
            when 'Enabled':u then
                RemoveEntity(pEventArgs:Operation:ServiceName,
                             string(pEventArgs:Operation:ServiceVersion),
                             pEventArgs:Operation:TargetName).
        end case.
        
        catch ple as Progress.Lang.Error:
            assign pEventArgs:Error = ple.
        end catch.
        finally:
            assign error-status:error = false.
        end finally.
    end method.
    
    /* Event handler invoke/load a piece of business logic (aka Business Entity).
       
       @param Progress.Lang.Object The handler publishing the event
       @param HandlerLoadEntityEventArgs Event args for this event */
    method public void LoadEntityHandler(input pSender as Progress.Lang.Object,
                                         input pEventArgs as HandlerLoadEntityEventArgs).
        define variable hProcedure as handle no-undo.
        define variable targetType as TargetTypeEnum no-undo.
        
        // If we have an entity, or something already went wrong, return
        if    valid-object(pEventArgs:BusinessEntity)
           or pEventArgs:Cancel
           or valid-object(pEventArgs:Error)
           then
            return.
        
        // Use a CCS Service Manager if extant, and let it control this object's lifecycle
        if valid-object(Ccs.Common.Application:ServiceManager) then
            assign pEventArgs:BusinessEntity = Ccs.Common.Application:ServiceManager
                                                    :getService(pEventArgs:Operation:EntityType,
                                                                pEventArgs:Operation:TargetName).
        
        if valid-object(pEventArgs:BusinessEntity) then
            Logger:Debug(substitute('Business entity reference for &3 (entity type: &2) obtained from &1',
                            Ccs.Common.Application:ServiceManager:GetClass():TypeName,
                            pEventArgs:Operation:EntityType,
                            pEventArgs:Operation:TargetName)).
        else
        do:
            Logger:Debug(substitute('Business entity &1 (type-of &4) invoked by &2 as target type &3',
                            pEventArgs:Operation:TargetName,
                            string(this-object),
                            pEventArgs:Operation:TargetType,
                            (if valid-object(pEventArgs:EntityType) then pEventArgs:EntityType:TypeName else get-class(Progress.Lang.Object):TypeName) )).
            
            assign targetType = TargetTypeEnum:GetEnum(pEventArgs:Operation:TargetType) no-error.
            case targetType:
                when TargetTypeEnum:Self then
                    assign pEventArgs:BusinessEntity = this-object.
                
                when TargetTypeEnum:Void or
                when TargetTypeEnum:File then
                    assign pEventArgs:BusinessEntity = GetOperationHandler(pEventArgs:Operation:TargetType).  
                
                when TargetTypeEnum:Class then
                do:
                    assign pEventArgs:BusinessEntity = GetEntity(pEventArgs:Operation:ServiceName, pEventArgs:Operation:ServiceVersion:ToString(), pEventArgs:Operation:TargetName).
                    if not valid-object(pEventArgs:BusinessEntity) then
                    do:
                        pEventArgs:BusinessEntity = dynamic-new string(pEventArgs:Operation:TargetName) ().
                        SetEntity(pEventArgs:Operation:ServiceName,
                                  pEventArgs:Operation:ServiceVersion:ToString(),
                                  pEventArgs:Operation:TargetName, 
                                  pEventArgs:BusinessEntity).
                    end.
                end.    /* class */
                
                when TargetTypeEnum:Procedure then
                do:
                    assign pEventArgs:BusinessEntity = GetEntity(pEventArgs:Operation:ServiceName,
                                                       pEventArgs:Operation:ServiceVersion:ToString(),
                                                       pEventArgs:Operation:TargetName).
                    
                    if not valid-object(pEventArgs:BusinessEntity) then
                    do:
                        run value(pEventArgs:Operation:TargetName) persistent set hProcedure.
                        assign pEventArgs:BusinessEntity = new WidgetHandle(hProcedure, true /* auto-destroy */ ).
                        SetEntity(pEventArgs:Operation:ServiceName,
                                  pEventArgs:Operation:ServiceVersion:ToString(),
                                  pEventArgs:Operation:TargetName,
                                  pEventArgs:BusinessEntity).
                    end.
                end.    /* proc */
                
                otherwise
                do:
                    Logger:Trace(substitute('Unsupported target type &1 for operation &2', 
                                    pEventArgs:Operation:TargetType, 
                                    pEventArgs:Operation:ToString())).
                    assign pEventArgs:BusinessEntity = ?
                           error-status:error        = no   // from the failed GetEnum() call
                           .
                end.
            end case.
        end.
        
        catch loadError as Progress.Lang.Error:
            assign pEventArgs:Error = loadError.
        end catch.
    end method.
    
    /* Event handler for service discovery
       
       @param Progress.Lang.Object The handler publishing the event
       @param ServiceLookupEventArgs Event args for this event */
    method public void DiscoverServiceHandler(input pSender as Progress.Lang.Object,
                                              input pEventArgs as ServiceDiscoveryEventArgs):
        define variable servicePaths as character extent no-undo.
        
        // If we have a service, or something already went wrong, return
        if    valid-object(pEventArgs:Service)
           or pEventArgs:Cancel
           or valid-object(pEventArgs:Error)
           then
            return.
        
        // we have a default name algorithm
        if String:IsNullOrEmpty(pEventArgs:Name) then
            assign servicePaths          = SplitServicePath(pEventArgs:Request:PathInfo)
                   pEventArgs:Name       = servicePaths[1]
                   pEventArgs:ServiceURI = servicePaths[2]
                   .
        if valid-object(pEventArgs:Registry) then
            if pEventArgs:Registry:HasService(pEventArgs:Name, pEventArgs:Version) then
                assign pEventArgs:Service = pEventArgs:Registry:GetService(pEventArgs:Name, pEventArgs:Version).
        else
            // Look in the default registry
            if ServiceRegistry:HasService(pEventArgs:Name, pEventArgs:Version) then
                assign pEventArgs:Service = ServiceRegistry:GetService(pEventArgs:Name, pEventArgs:Version).
        
        // If we don't have a registered service, look on disk
        if not valid-object(pEventArgs:Service) then
            // try to load from disk (.GEN and/or .MAP)
            if not ServiceRegistry:TryFindService(pEventArgs:Name, pEventArgs:Version,  pEventArgs:Request:WebAppPath) then
            do:
                Logger:Debug(substitute('Service not found for "&1 &2"',
                                        pEventArgs:Request:Method, pEventArgs:Request:URI:ToString())).
                undo, throw new SendExceptionError(StatusCodeEnum:NotFound,
                                                   new AppError(substitute('Service not found for "&1 &2"',
                                                                    pEventArgs:Request:Method, 
                                                                    pEventArgs:Request:URI:ToString()),
                                                                0)).
            end.
            else
                assign pEventArgs:Service  = ServiceRegistry:GetService(pEventArgs:Name, pEventArgs:Version)
                       // set the registry, in case it was previously set
                       pEventArgs:Registry = pEventArgs:Service:Registry
                       .
        catch e as Progress.Lang.Error:
            assign pEventArgs:Error = e.
        end catch.
    end method.
    
    /* Splits a URI path into a service and service-relative-uri. Can be used for
       tokenised paths or 'real' paths.
       
       @param character A path to split/parse
       @return character[2] An array of strings from the path. The first extent is
                            the service name. The second extent is the service-relative 
                            URI */
    method protected character extent 2 SplitServicePath (input pcPath as character):
        define variable cPath as character case-sensitive extent 2 no-undo.
        
        Assert:NotNull(pcPath, 'Path info').
        
        assign /* PathInfo is going to be /pdo/service/resource/blah or
                  /service/resource/blah  */
               cPath[2] = trim(pcPath, '/':u)
               cPath[1] = entry(1, cPath[2], '/':u)
               .
        // could be /pdo/ or /something-else-service
        if cPath[1] eq 'pdo':u then
        do:
            if num-entries(cPath[2], '/':u) ge 2 then
                assign cPath[1] = trim(entry(2, cPath[2], '/':u), '/':u)
                       // remove the service component from the path 
                       entry(2, cPath[2], '/':u) = '':u.
            else
                assign cPath[1] = '':u.
        end.
        
        // remove the or pdo service component from the path
        assign entry(1, cPath[2], '/':u) = '':u
               cPath[2] = trim(cPath[2], '/':u)
               .
        /* we don't want a blank key so we use 'ROOT' */
        if cPath[1] eq '':u then
            assign cPath[1] = ServiceRegistry:ROOT_SERVICE_NAME. 
        
        /* we don't want a blank uri so we use '/' */
        if cPath[2] eq '':u then
            assign cPath[2] = ServiceRegistry:ROOT_SERVICE_URI.
        
        return cPath.
    end method. 
    
end class.
