/* *************************************************************************************************************************
Copyright (c) 2016-2020 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
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
using OpenEdge.Core.Session.
using OpenEdge.Core.String.
using OpenEdge.Core.StringConstant.
using OpenEdge.Core.WidgetHandle.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.ISupportLogging.
using OpenEdge.Logging.Logger.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using OpenEdge.Net.HTTP.Filter.Writer.EntityWriterBuilder.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.HttpRequestError.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.MethodEnum.
using OpenEdge.Net.HTTP.StatusCodeEnum.
using OpenEdge.Net.HTTP.StatusCodeHelper.
using OpenEdge.Net.MimeTypeHelper.
using OpenEdge.Net.URI.
using OpenEdge.Security.Principal.
using OpenEdge.Web.DataObject.AuthorizeOperationEventArgs.
using OpenEdge.Web.DataObject.DataObjectError.
using OpenEdge.Web.DataObject.DataObjectHandler.
using OpenEdge.Web.DataObject.DataObjectService.
using OpenEdge.Web.DataObject.HandlerErrorEventArgs.
using OpenEdge.Web.DataObject.HandlerLoadEntityEventArgs.
using OpenEdge.Web.DataObject.IOperationEventHandler.
using OpenEdge.Web.DataObject.IOperationHandler.
using OpenEdge.Web.DataObject.IServiceEventHandler.
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

class OpenEdge.Web.DataObject.DataObjectHandler
        implements  IWebHandler,                                                        // So that we can handle requests
                    ISupportInitialize, ISupportLogging,                                // General infrastructure
                    IOperationHandler, IOperationEventHandler, IServiceEventHandler:    // DOH workings
    
    /* Sometimes the DOH is mapped to /web/pdo; sometimes to /web/api; sometimes to /web. 
       In all of these cases we want to throw that paths segment away */
    define static public property HANDLER_PREFIX as character no-undo initial 'pdo':u
        get.
        set.
    
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
    
    /* Event published to perform any authorization on the operation
       
       @param Progress.Lang.Object The handler publishing the event
       @param AuthorizeOperationEventArgs Event args for this event */
    define static public event AuthorizeOperation signature void (input pSender as Progress.Lang.Object,
                                                                  input pEventArgs as AuthorizeOperationEventArgs). 
    
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
                assign this-object:Logger = LoggerBuilder:GetLogger(this-object:GetClass()).
            
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
       @param DataObjectService The service for which the error was raised
       @param MappedOperation The operation for which the error was raised
       @return integer A non-null status code use to deal with errors */
    method protected integer HandleException(input poError    as Progress.Lang.Error,
                                             input poRequest  as IWebRequest,
                                             input poResponse as IHttpResponse,
                                             input poBusinessEntity as Progress.Lang.Object,
                                             input pService as DataObjectService,
                                             input poOperation as MappedOperation):
        define variable oArgs as HandlerErrorEventArgs no-undo.
        
        Assert:NotNull(poRequest,  'Web request').
        Assert:NotNull(poError, 'Error').
        
        Logger:Error(substitute('Exception raised for &1 &2; Entity=&3; Operation=&4',
                              poRequest:Method,
                              poRequest:URI:ToString(),
                              (if valid-object(poBusinessEntity) then poBusinessEntity:ToString() else '':u),
                              (if valid-object(poOperation) then poOperation:ToString() else '':u)),
                      poError).
        
        // We'll need a response
        if not valid-object(poResponse) then
            assign poResponse = CreateDefaultResponse().
        
        assign oArgs                = new HandlerErrorEventArgs(poRequest, poResponse, poError)
               // don't pass the BusinessEntity in the constructor, since that validates for nulls  
               oArgs:BusinessEntity = poBusinessEntity
               .
        oArgs:SetService(pService).
        oArgs:SetOperation(poOperation).
        
        OnOperationError(oArgs).
        
        /* a non-zero value means that we will use the static pages */
        if oArgs:ReturnStatusCode eq 0 then
        do:
            /* is there an envelope? */
            if     valid-object(poOperation) 
               and poOperation:Options:HasErrorEnvelope
            then
                AddResponseEnvelope(poResponse, poOperation, poOperation:Options:ErrorEnvelope).
            
            WriteResponse(oArgs:Response).
        end.    
        
        return oArgs:ReturnStatusCode.
        catch oError as Progress.Lang.Error:
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
        RemoveAllEntities(get-class(IOperationHandler):TypeName, '*':u).
    end method.
    
/** HANDLING OF THE REQUEST **/    
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
        define variable hdrs as HttpHeader extent no-undo.
        define variable cnt as integer no-undo.
        define variable numHdr  as integer no-undo.
        
        Assert:NotNull(poOperation, 'Mapped operation').
        
        // Set the default response values from the operation
        assign httpResponse             = CreateDefaultResponse()
               
               httpResponse:ContentType = poOperation:ContentType
               httpResponse:StatusCode  = poOperation:StatusCode      when poOperation:StatusCode ne 0
               .
        // Headers
        poOperation:Headers:GetAll(output hdrs).
        httpResponse:SetHeaders(hdrs).
        
        // Cookies
        httpResponse:SetCookies(poOperation:Cookies:ToCookieArray()).
        
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
        define variable svc as DataObjectService no-undo.
        define variable oOperation as MappedOperation no-undo.
        define variable oMessageBody as Progress.Lang.Object no-undo.
        define variable oOperationArgs as OperationInvocationEventArgs no-undo.
        define variable serviceLogger as ILogWriter no-undo.
        define variable dohLogger as ILogWriter no-undo.
        
        //The FindOperation() call should not return a null, but verify since it's an overrideable method
        assign svc        = FindService(poRequest)
               oOperation = FindOperation(svc, poRequest)
               .
        Assert:NotNull(oOperation, 'Mapped operation').
        
        // Set the default response values from the operation
        assign oResponse = CreateOperationResponse(oOperation).
        
        // Use a per-service logger named "OpenEdge.Web.DataObject.DataObjectHandler.<ServiceName>"
        do on error undo, throw:
            assign serviceLogger = LoggerBuilder:GetLogger(get-class(DataObjectHandler):TypeName + '.':u + svc:Name).
            if not serviceLogger:Equals(this-object:Logger) then
            do:
                assign dohLogger          = this-object:Logger
                       this-object:Logger = serviceLogger
                       .
                dohLogger:Info(substitute('Service &1 logging performed by &2 at &3', 
                                    svc:Name,
                                    serviceLogger:Name, string(serviceLogger:LogLevel))).
            end.
            /* Don't fail because we can't log per-service. Use the current logger */
            catch oError as Progress.Lang.Error:
                Logger:Error(substitute('Unable to determine logger for service &1; using default logger &2',
                                        svc:Name, this-object:Logger:Name),
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
                                              svc,
                                              oOperation).
        if iStatusCode eq 0 then
        do:
            AddResponseEnvelope(oResponse, oOperation).
            WriteResponse(oResponse).
        end.
        
        return iStatusCode.
        /* errors? */
        catch doErr as DataObjectError:
            assign iStatusCode = HandleException(doErr:Error,
                                                 doErr:Request,
                                                 doErr:Response, 
                                                 doErr:BusinessEntity, 
                                                 doErr:Service,
                                                 doErr:Operation).
            return iStatusCode.
        end catch.
        catch oError as Progress.Lang.Error:
            assign iStatusCode = HandleException(oError, poRequest, oResponse, ?, svc, oOperation).
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
    
    /* Event handler for the event published when an error is encountered
       
       @param Progress.Lang.Object The handler publishing the event
       @param HandlerErrorEventArgs Event args for this event */
    method public void AuthorizeOperationHandler(input pSender as Progress.Lang.Object,
                                                 input pEventArgs as AuthorizeOperationEventArgs):
        if    pEventArgs:Cancel
           or valid-object(pEventArgs:Error)
           or extent(pEventArgs:Operation:AccessControl) eq ?
        then
            return.
        
        Logger:Trace(substitute('Operation target "&1:&2" requires one of ACL roles ["&3"]',
                                pEventArgs:Operation:TargetName,
                                pEventArgs:Operation:TargetFunction,
                                String:Join(pEventArgs:Operation:AccessControl, '","':u) )).
        
        // The fact that there are ACLs set for this operation means that we should report on the fact that the
        // user isn't set, and throw an error. 
        if not valid-object(pEventArgs:User) then
            Logger:Warn(substitute('Unable to authorize operation "&1:&2": no user asserted. One of ACL roles required ["&3"]',
                                   pEventArgs:Operation:TargetName,
                                   pEventArgs:Operation:TargetFunction,
                                   String:Join(pEventArgs:Operation:AccessControl, '","':u) )).
        else
        // user passes muster
        if pEventArgs:User:AuthorizeOne(pEventArgs:Operation:AccessControl) then
            return.
        
        // there is a user, and the Authorization failed 
        undo, throw new SendExceptionError(StatusCodeEnum:Unauthorized).
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
                                            input pService as DataObjectService,
                                            input poOperation as MappedOperation):
        define variable iStatusCode as integer no-undo.
        define variable oOperationArgs as OperationInvocationEventArgs no-undo.
        define variable oOperationHandler as IOperationHandler no-undo.
        define variable iTimeout as integer no-undo.
        define variable oStopError as Progress.Lang.Error no-undo.
        define variable operationLogger as ILogWriter no-undo.
        define variable operationTime as datetime no-undo.
        define variable entityArgs as HandlerLoadEntityEventArgs no-undo.
        define variable authzArgs as AuthorizeOperationEventArgs no-undo.
        define variable curUser as Principal no-undo.
        
        Assert:NotNull(poRequest,   'Web request').
        Assert:NotNull(poResponse,  'Web response').
        Assert:NotNull(poOperation, 'Mapped operation').
        
        // Before anything, authorize the operation
        // get the currently-asserted user 
        assign curUser = Principal:Import().
        if not valid-object(curUser) then
            assign curUser = Principal:Import(session:current-request-info).
        
        assign authzArgs          = new AuthorizeOperationEventArgs(poRequest,
                                                                    pService,
                                                                    poOperation,
                                                                    curUser)
               authzArgs:Response = poResponse
               .
        OnAuthorizeOperation(authzArgs).
        
        assign entityArgs          = new HandlerLoadEntityEventArgs(poRequest, pService, poOperation)
               entityArgs:Response = poResponse
               operationTime       = now
               .
        OnLoadEntity(entityArgs).
        // we need a BE to continue
        if not valid-object(entityArgs:BusinessEntity) then
            undo, throw new AppError(substitute('Unable to instantiate business entity &2 &1 ; type-of: &3',
                                                entityArgs:Operation:TargetName,
                                                entityArgs:Operation:TargetType,
                                                (if valid-object(entityArgs:EntityType) then entityArgs:EntityType:TypeName else get-class(Progress.Lang.Object):TypeName) ),
                                                0).
        if valid-object(entityArgs:BusinessEntity) then
            Assert:IsType(entityArgs:BusinessEntity, entityArgs:EntityType).
        
        Logger:Trace(substitute('Entity &1 invoked in &2(ms)',
                        entityArgs:BusinessEntity:ToString(),
                        interval(now, operationTime, string(DateTimeAddIntervalEnum:Milliseconds)))).
        Logger:Debug(substitute('Using business entity &1 of type &2 for operation &3',
                                string(entityArgs:BusinessEntity),
                                (if valid-object(entityArgs:EntityType) then entityArgs:EntityType:TypeName else entityArgs:BusinessEntity:GetClass():TypeName) ),
                                string(poOperation)).
        
        assign oOperationArgs             = new OperationInvocationEventArgs(poRequest,
                                                                             entityArgs:BusinessEntity,
                                                                             poResponse,
                                                                             pService,
                                                                             poOperation)
               oOperationArgs:RequestBody = poMessageBody
               iStatusCode                = 0
               .
        OnInvoking(oOperationArgs).
        
        /* do the work */
        assign operationTime     = now
               oOperationHandler = GetOperationHandler(poOperation:TargetType)
               operationLogger   = cast(oOperationHandler, ISupportLogging):Logger
               // always use the DOH's logger
               cast(oOperationHandler, ISupportLogging):Logger = this-object:Logger
               
               oStopError        = new HttpRequestError(string(integer(StatusCodeEnum:RequestTimeOut)),
                                             poRequest:Method,
                                             poRequest:URI:ToString()).
        
        Logger:Trace(substitute('Service &2 &1 operation handler for target type &3 init time(ms)=&4', 
                            pService:Name,
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
            
            assign iStatusCode = oOperationHandler:Execute(poRequest, poMessageBody, poResponse, pService, poOperation, entityArgs:BusinessEntity).
        end.
        else
            undo, throw new AppError(substitute('Unable to service request for "&1 &2"',
                                            poOperation:Method, 
                                            poOperation:ServiceURI), 
                                    0).
        
        Logger:Trace(substitute('Service &1 operation &1 execute handler time(ms)=&3', 
                            pService:Name,
                            string(poOperation:Method),
                            interval(now, operationTime, string(DateTimeAddIntervalEnum:Milliseconds)))).
        
        assign oOperationArgs = new OperationInvocationEventArgs(poRequest, entityArgs:BusinessEntity, poResponse, pService, poOperation)
               oOperationArgs:RequestBody      = poMessageBody
               oOperationArgs:ReturnStatusCode = iStatusCode
               .
        OnInvoked(oOperationArgs).
        if valid-object(oOperationArgs:Error) then
            undo, throw new DataObjectError(oOperationArgs).
        
        return oOperationArgs:ReturnStatusCode.
        catch doeErr as DataObjectError:
            // don't wrap this in another DataObjectError; just throw it along
            undo, throw doeErr.
        end catch.
        catch see as SendExceptionError:
            // don't wrap this in a DataObjectError; just throw it along
            undo, throw see.
        end catch.
        catch err as Progress.Lang.Error:
            define variable dohError  as DataObjectError no-undo.
            
            assign dohError                = new DataObjectError()
                   dohError:Error          = err
                   dohError:Request        = poRequest
                   dohError:Response       = poResponse
                   dohError:Service        = pService
                   dohError:Operation      = poOperation
                   .
            if valid-object(entityArgs) then
                assign dohError:BusinessEntity = entityArgs:BusinessEntity.
            
            undo, throw dohError.
        end catch.
        finally:
            // We're done with this request - tell clients that they can let go
            if valid-object(entityArgs) then
                OnUnloadEntity(entityArgs).
            
            //reset to original/default.
            if valid-object(oOperationHandler) then
                assign cast(oOperationHandler, ISupportLogging):Logger = operationLogger.
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
    
    @TODO(txt="needs refactoring out of here").
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
        define variable operationPath as character no-undo.
        
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
                        PerformOperation(poRequest, poMessageBody, catalogResponse, regdSvc[svcCnt], catalogOperation).
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
                       operationPath     = trim(poRequest:WebAppPath, '/':u)  + '/':u + trim(poRequest:TransportPath, '/':u) + '/' + trim(poRequest:PathInfo, '/':u)
                       .
                oCatalog:Add('uri':u, regdOps[opsCnt]:ServiceURI).
                
                oCatalog:Add('method':u, string(regdOps[opsCnt]:Method)).
                oCatalog:Add('name':u, regdOps[opsCnt]:Name).
                
                if not regdSvc[svcCnt]:Name eq DataObjectService:ROOT_SERVICE_NAME then
                    assign operationPath = operationPath + '/':u + trim(regdSvc[svcCnt]:Name, '/':u).
                     
                if not regdOps[opsCnt]:ServiceURI eq DataObjectService:ROOT_SERVICE_URI then
                    assign operationPath = operationPath + '/':u + trim(regdOps[opsCnt]:ServiceURI, '/':u).
                
                assign operationURL:Path = operationPath.
                 
                oCatalog:Add('url':u, operationURL:ToString()).
                
                svcOps:Add(oCatalog). 
            end.
        end.    // services
        
        return iStatusCode.
    end method.
    
    /* Publishes the 'ServiceDiscovery' event with the provided args 
    
       @param ServiceDiscoveryEventArgs The args for this event */
    method protected void OnDiscoverService(input poEventArgs as ServiceDiscoveryEventArgs):
        Assert:NotNull(poEventArgs, 'Event args').
        
        DataObjectHandler:DiscoverService:Publish(this-object, poEventArgs).
        
        if valid-object(poEventArgs:Error) then
            undo, throw new DataObjectError(poEventArgs).
        
        if poEventArgs:Cancel then
            Logger:Debug(substitute('Default DiscoverServiceHandler cancelled for service &1', poEventArgs:Service)).
        else
            // Run our local 'handler'
            DiscoverServiceHandler(this-object, poEventArgs).
        
        if valid-object(poEventArgs:Error) then
            undo, throw new DataObjectError(poEventArgs).
        
        catch doe as DataObjectError:
            undo, throw doe.
        end catch.
        catch see as SendExceptionError:
            undo, throw see.
        end catch.
        catch ple as Progress.Lang.Error:
            assign poEventArgs:Error = new SendExceptionError(StatusCodeEnum:NotFound, ple).
            undo, throw new DataObjectError(poEventArgs).
        end catch.
    end method.
    
    /* Publishes the 'AuthorizeOperation' event with the provided args 
       
       @param AuthorizeOperationEventArgs The args for this event */
    method protected void OnAuthorizeOperation(input pEventArgs as AuthorizeOperationEventArgs):
        Assert:NotNull(pEventArgs, 'Event args').
        
        DataObjectHandler:AuthorizeOperation:Publish(this-object, pEventArgs).
        
        if valid-object(pEventArgs:Error) then
            undo, throw new DataObjectError(pEventArgs).
        
        if pEventArgs:Cancel then
            Logger:Debug(substitute('Default AuthorizeOperationHandler cancelled for operation &1', string(pEventArgs:Operation))).
        else
            AuthorizeOperationHandler(this-object, pEventArgs).
        
        if valid-object(pEventArgs:Error) then
            undo, throw new DataObjectError(pEventArgs).
        
        catch doe as DataObjectError:
            undo, throw doe.
        end catch.
        catch see as SendExceptionError:
            undo, throw see.
        end catch.
        catch ple as Progress.Lang.Error:
            assign pEventArgs:Error = new SendExceptionError(StatusCodeEnum:Unauthorized, ple).
            undo, throw new DataObjectError(pEventArgs).
        end catch.
    end method.
    
    /* Publishes the 'Invoking' event with the provided args 
       
       @param OperationInvocationEventArgs The args for this event */
    method protected void OnInvoking(input poEventArgs as OperationInvocationEventArgs):
        Assert:NotNull(poEventArgs, 'Event args').
        
        DataObjectHandler:Invoking:Publish(this-object, poEventArgs).
        
        if valid-object(poEventArgs:Error) then
            undo, throw new DataObjectError(poEventArgs).
        
        if poEventArgs:Cancel then
            Logger:Debug(substitute('Default InvokingHandler cancelled for operation &1', string(poEventArgs:Operation))).
        else
        // If all went well, run the local 'handler'
            InvokingHandler(this-object, poEventArgs).
        
        if valid-object(poEventArgs:Error) then
            undo, throw new DataObjectError(poEventArgs).
        
        catch doe as DataObjectError:
            undo, throw doe.
        end catch.
        catch see as SendExceptionError:
            undo, throw see.
        end catch.
        catch ple as Progress.Lang.Error:
            assign poEventArgs:Error = new SendExceptionError(StatusCodeEnum:ServiceUnavailable, ple).
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
        
        // If all went well, run the local 'handler'
        if poEventArgs:Cancel then
            Logger:Debug(substitute('Default InvokedHandler cancelled for operation &1', string(poEventArgs:Operation))).
        else
            InvokedHandler(this-object, poEventArgs).
        
        if valid-object(poEventArgs:Error) then
            undo, throw new DataObjectError(poEventArgs).
        
        catch doe as DataObjectError:
            undo, throw doe.
        end catch.
        catch see as SendExceptionError:
            undo, throw see.
        end catch.
        catch ple as Progress.Lang.Error:
            assign poEventArgs:Error = new SendExceptionError(StatusCodeEnum:ServiceUnavailable, ple).
            undo, throw new DataObjectError(poEventArgs).
        end catch.
    end method.
    
    /* Publishes the 'OperationError' event with the provided args 
       
       @param HandlerErrorEventArgs The args for this event */
    method protected void OnOperationError(input poEventArgs as HandlerErrorEventArgs):
        Assert:NotNull(poEventArgs, 'Event args').
        
        DataObjectHandler:OperationError:Publish(this-object, poEventArgs).
        if valid-object(poEventArgs:Error) then
            undo, throw poEventArgs:Error.
        
        // If all went well, run the local 'handler'. We expect the OperationError property to be filled; 
        // that's data for the error. The Error property is an error-in-processing-the-operationerror
        if poEventArgs:Cancel then
            Logger:Debug(substitute('Default OperationErrorHandler cancelled for operation error &1', string(poEventArgs:OperationError))). 
        else
            OperationErrorHandler(this-object, poEventArgs).
        
        if valid-object(poEventArgs:Error) then
            undo, throw poEventArgs:Error.
        
        catch doe as DataObjectError:
            undo, throw doe.
        end catch.
        catch see as SendExceptionError:
            undo, throw see.
        end catch.
        catch ple as Progress.Lang.Error :
            assign poEventArgs:Error = new SendExceptionError(StatusCodeEnum:InternalServerError, ple).
            undo, throw new DataObjectError(poEventArgs).
        end catch.
    end method.
    
    /* Publishes the 'LoadEntity' event with the provided args 
       
       @param HandlerErrorEventArgs The args for this event */
    method protected void OnLoadEntity(input poEventArgs as HandlerLoadEntityEventArgs):
        Assert:NotNull(poEventArgs, 'Event args').
        
        DataObjectHandler:LoadEntity:Publish(this-object, poEventArgs).
        
        if valid-object(poEventArgs:Error) then
            undo, throw new DataObjectError(poEventArgs).
        
        if poEventArgs:Cancel then 
            Logger:Debug(substitute('Default LoadEntityHandler cancelled for entity type &1', poEventArgs:EntityType:TypeName)).
        else
            // If all went well, run the local 'handler'
            LoadEntityHandler(this-object, poEventArgs).
        
        if valid-object(poEventArgs:Error) then
            undo, throw new DataObjectError(poEventArgs).
        
        catch doe as DataObjectError:
            undo, throw doe.
        end catch.
        catch see as SendExceptionError:
            undo, throw see.
        end catch.
        catch ple as Progress.Lang.Error:
            assign poEventArgs:Error = new SendExceptionError(StatusCodeEnum:ServiceUnavailable, ple).
            undo, throw new DataObjectError(poEventArgs).
        end catch.
    end method.
    
    /* Publishes the 'UnloadEntity' event with the provided args 
       
       @param HandlerErrorEventArgs The args for this event */
    method protected void OnUnloadEntity(input poEventArgs as HandlerLoadEntityEventArgs):
        Assert:NotNull(poEventArgs, 'Event args').
        
        DataObjectHandler:UnloadEntity:Publish(this-object, poEventArgs).
        
        if valid-object(poEventArgs:Error) then
            undo, throw new DataObjectError(poEventArgs).
        
        // If all went well, run the local 'handler'
        if poEventArgs:Cancel then
            Logger:Debug(substitute('Default UnloadEntityHandler cancelled for entity type &1', poEventArgs:EntityType:TypeName)).
        else
            UnloadEntityHandler(this-object, poEventArgs).
        
        if valid-object(poEventArgs:Error) then
            undo, throw new DataObjectError(poEventArgs).
        
        catch doe as DataObjectError:
            undo, throw doe.
        end catch.
        catch see as SendExceptionError:
            undo, throw see.
        end catch.
        catch ple as Progress.Lang.Error:
            assign poEventArgs:Error = new SendExceptionError(StatusCodeEnum:ServiceUnavailable, ple).
            undo, throw new DataObjectError(poEventArgs).
        end catch.
    end method.
    
    /* Executes the operation.  
       
       We don't care about the entity in this handler (since we are the handler)  
       
       @param IWebRequest The request that resulting in the exception
       @param P.L.Object The message body of the incoming request. Typically 
                         will be transformed from bytes into something useful; may also have an envelope removed. 
       @param IHttpResponse The current response object, if any
       @param DataObjectService The service
       @param MappedOperation The mapped operation
       @param P.L.Object The business logic/entity
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
        
        if can-find(lbEntity where
                    lbEntity.Service eq pcService and
                    lbEntity.Version eq pVersion and
                    lbEntity.EntityName eq pcEntityName) then
            find lbEntity where
                 lbEntity.Service eq pcService and
                 lbEntity.Version eq pVersion and
                 lbEntity.EntityName eq pcEntityName
                 .
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
        
        assign lExists = can-find(lbEntity where
                                  lbEntity.Service eq pcService and
                                  lbEntity.Version eq pVersion and
                                  lbEntity.EntityName eq pcEntityName).
        if lExists then
            find lbEntity where
                 lbEntity.Service    eq pcService and
                 lbEntity.Version    eq pVersion and
                 lbEntity.EntityName eq pcEntityName
                 .
        else
        do:
            create lbEntity.
            assign lbEntity.Service    = pcService
                   lbEntity.Version    = pVersion
                   lbEntity.EntityName = pcEntityName
                   .
            Logger:Debug(substitute('Entity "&1" cached for service "&2" &3',
                                    pcEntityName, poBusinessEntity:GetClass():TypeName, pcService, pVersion)).
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
        Assert:NotNull(pcEntityName, 'Entity name').
        
        assign lExists = can-find(lbEntity where
                                  lbEntity.Service eq pcService and
                                  lbEntity.Version eq pVersion and
                                  lbEntity.EntityName eq pcEntityName).
        if lExists then
        do:
            find lbEntity where
                 lbEntity.Service eq pcService and
                 lbEntity.Version eq pVersion and
                 lbEntity.EntityName eq pcEntityName
                 .
            Logger:Debug(substitute('Cached entity "&1" removed for service "&2" &3',
                            lbEntity.EntityName, pcService, pVersion)).
            delete lbEntity.
        end.
        
        return lExists.
    end method.
    
    /* Removes all the cached entity instances for a given service 
    
       @param character The service name 
       @param character The service version. If * then all versions cleared */
    method private void RemoveAllEntities(input pcService as character,
                                          input pVersion as character):
        define variable lExists as logical no-undo.
        define buffer lbEntity for TargetRef.
        define query qEntity for lbEntity.
       
        Assert:NotNullOrEmpty(pcService, 'Service name').
        Assert:NotNull(pVersion, 'Service version').
        
        if pVersion eq '*':u then
            open query qEntity preselect each lbEntity where
                                              lbEntity.Service eq pcService.
        else
            open query qEntity preselect each lbEntity where
                                              lbEntity.Service eq pcService and 
                                              lbEntity.Version eq pVersion.
        get first qEntity.
        do while not query qEntity:query-off-end:
            Logger:Debug(substitute('Cached entity "&1" removed for service "&2" &3',
                            lbEntity.EntityName, lbEntity.Service, lbEntity.Version)).
            delete lbEntity.
            get next qEntity.
        end.
        finally:
            close query qEntity.
        end finally.
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
    
    /* Returns a service for this request
       
       @param IWebRequest The incoming request 
       @return DataObjectService A valid service to use for this request. Should not be null, throw instead
       @throws AssertionFailedError Thrown on poor/missing inputs 
       @throws SendExceptionError Thrown if the operation could not be found */
    method protected DataObjectService FindService(input poRequest as IWebRequest):
        define variable svc as DataObjectService no-undo.
        define variable servicePaths as character case-sensitive extent no-undo.
        define variable discoveryArgs as ServiceDiscoveryEventArgs no-undo.
        
        Assert:NotNull(poRequest, 'Request').
        
        Logger:Trace(substitute('Request received for &1 &2',
                        poRequest:Method, poRequest:URI:ToString())).
        
        assign servicePaths             = SplitServicePath(poRequest:PathInfo)
               
               discoveryArgs            = new ServiceDiscoveryEventArgs(poRequest)
               discoveryArgs:Name       = servicePaths[1]
               discoveryArgs:ServiceURI = servicePaths[2]
               discoveryArgs:Registry   = ServiceRegistry:Registry
               .
        OnDiscoverService(discoveryArgs).
        
        // no service was found
        if not valid-object(discoveryArgs:Service) then
            return error new SendExceptionError(StatusCodeEnum:NotFound,
                                                substitute('Service not found for "&1"', discoveryArgs:Name) ).
        
        Logger:Trace(substitute('Service "&1" found for "&2 &3"',
                                discoveryArgs:Service:ToString(),
                                poRequest:Method,
                                poRequest:URI:ToString() )).
        
        return discoveryArgs:Service.
    end method.
    
    /* Returns a mapped operation for this service and request
       
       @param DataObjectService The service in which to find the operation
       @param IWebRequest The incoming request 
       @return MappedOperation A valid operation to use for this request. Should not be null, throw instead
       @throws AssertionFailedError Thrown on poor/missing inputs 
       @throws SendExceptionError Thrown if the operation could not be found */
    method protected MappedOperation FindOperation(input pService as DataObjectService,
                                                   input poRequest as IWebRequest):
        define variable oOperation as MappedOperation no-undo.
        define variable cServicePaths as character case-sensitive extent no-undo.
        define variable cPathType as character no-undo.
        define variable cUriTemplate as character case-sensitive no-undo.
        define variable serviceURI as character case-sensitive no-undo.
        
        Assert:NotNull(pService, 'Service').   
        Assert:NotNull(poRequest, 'Request').
        
        // First check for a match on the actual path (non-tokenised)
        assign cServicePaths = SplitServicePath(poRequest:PathInfo)
               cPathType     = 'service path'
               serviceURI   = cServicePaths[2]
               .
        Logger:Trace(substitute('Searching for mapped operation for service "&1" with &3 "&2"',
                                string(pService), serviceURI, cPathType)).
        
        assign oOperation = pService:GetOperation(serviceURI, MethodEnum:GetEnum(poRequest:Method)).
        if not valid-object(oOperation) then
        do:
            // Now check for a match on the tokenised path
            assign cUriTemplate = poRequest:UriTemplate.
            if index(cUriTemplate, StringConstant:CURLY_OPEN) gt 0 then
            do:
                assign cServicePaths = SplitServicePath(cUriTemplate)
                       serviceURI    = cServicePaths[2]
                       .
                // if there are no tokens in the relative URI it's a no-op
                if index(serviceURI, StringConstant:CURLY_OPEN) gt 0 then
                do:
                    assign cPathType = 'URI template'.
                    Logger:Trace(substitute('Searching for mapped operation for service "&1" with &3 "&2"',
                                            pService:Name, serviceURI, cPathType)).
                    assign oOperation = pService:GetOperation(serviceURI, MethodEnum:GetEnum(poRequest:Method)).
                end.
            end.
        end.
        
        if not valid-object(oOperation) then
            return error new SendExceptionError(StatusCodeEnum:NotFound,
                                                substitute('Mapped operation not found for service "&1" with &3 "&2"',
                                                           pService:Name, serviceURI, cPathType)).
        
        Logger:Debug(substitute('Using mapped operation for &1 &4 &2: &3',
                        string(oOperation:Method), serviceURI, string(oOperation), cPathType)).
        
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
                RemoveEntity(pEventArgs:Service:Name,
                             string(pEventArgs:Service:Version),
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
        define variable enumValue as int64 no-undo.
        
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
            
            assign enumValue = get-class(TargetTypeEnum):GetEnumValue(pEventArgs:Operation:TargetType).
            if enumValue ne ? then
                assign targetType = TargetTypeEnum:GetEnum(pEventArgs:Operation:TargetType).
            case targetType:
                when TargetTypeEnum:Self then
                    assign pEventArgs:BusinessEntity = this-object.
                
                when TargetTypeEnum:Void or
                when TargetTypeEnum:File then
                    assign pEventArgs:BusinessEntity = GetOperationHandler(pEventArgs:Operation:TargetType).  
                
                when TargetTypeEnum:Class then
                do:
                    assign pEventArgs:BusinessEntity = GetEntity(pEventArgs:Service:Name, string(pEventArgs:Service:Version), pEventArgs:Operation:TargetName).
                    if not valid-object(pEventArgs:BusinessEntity) then
                    do:
                        pEventArgs:BusinessEntity = dynamic-new string(pEventArgs:Operation:TargetName) ().
                        SetEntity(pEventArgs:Service:Name,
                                  string(pEventArgs:Service:Version),
                                  pEventArgs:Operation:TargetName, 
                                  pEventArgs:BusinessEntity).
                    end.
                end.    /* class */
                
                when TargetTypeEnum:Procedure then
                do:
                    assign pEventArgs:BusinessEntity = GetEntity(pEventArgs:Service:Name,
                                                       pEventArgs:Service:Version:ToString(),
                                                       pEventArgs:Operation:TargetName).
                    
                    if not valid-object(pEventArgs:BusinessEntity) then
                    do:
                        run value(pEventArgs:Operation:TargetName) persistent set hProcedure.
                        assign pEventArgs:BusinessEntity = new WidgetHandle(hProcedure, true /* auto-destroy */ ).
                        SetEntity(pEventArgs:Service:Name,
                                  pEventArgs:Service:Version:ToString(),
                                  pEventArgs:Operation:TargetName,
                                  pEventArgs:BusinessEntity).
                    end.
                end.    /* proc */
                
                otherwise
                do:
                    Logger:Trace(substitute('Unsupported target type &1 for operation &2', 
                                    pEventArgs:Operation:TargetType, 
                                    pEventArgs:Operation:ToString())).
                    assign pEventArgs:BusinessEntity = ?.
                end.
            end case.
        end.
        
        catch loadError as Progress.Lang.Error:
            assign pEventArgs:Error = loadError.
        end catch.
    end method.
    
    /* Event handler for the event published when an error is encountered.
       
       If the HandlerErrorEventArgs:OperationError is of type SendExceptionError then
       we use the SendExceptionError's StatusCode for the response; otherwise we return
       an Internal Server Error (501).
       
       @param Progress.Lang.Object The handler publishing the event
       @param HandlerErrorEventArgs Event args for this event */
    method public void OperationErrorHandler (input pSender as Progress.Lang.Object,
                                              input pEventArgs as HandlerErrorEventArgs): 
        define variable entityWriter as MessageWriter no-undo.
        define variable contentType as character no-undo.
        
        if not pEventArgs:ReturnStatusCode eq 0
           or pEventArgs:Cancel
           or valid-object(pEventArgs:Error)
        then
            return.
        
        if valid-object(pEventArgs:Operation) then
            assign contentType = pEventArgs:Operation:ContentType.
        else
            assign contentType = 'application/json':u.
        
        assign entityWriter = EntityWriterBuilder:Build(contentType):Writer.
        
        // if we can find a writer for this content type then write in that format
        if     valid-object(entityWriter)
               // we must be able to return something that the client can read
           and ValidateContentType(pEventArgs:Request, contentType)
        then
        do:
            entityWriter:Open().
            entityWriter:Write(pEventArgs:OperationError).
            entityWriter:Close().
            
            /* We have some default behaviour ... which is to return an error code. Use the
               response status for a default */
            if type-of(pEventArgs:OperationError, SendExceptionError) then
                assign pEventArgs:Response:StatusCode   = integer(cast(pEventArgs:OperationError, SendExceptionError):StatusCode)
                       pEventArgs:Response:StatusReason = cast(pEventArgs:OperationError, SendExceptionError):StatusMessage
                       .
            else
                // all we know is something horrible happened ...
                assign pEventArgs:Response:StatusCode   = integer(StatusCodeEnum:InternalServerError)
                       pEventArgs:Response:StatusReason = StatusCodeHelper:GetMessage(StatusCodeEnum:InternalServerError)
                       .
            
            // we're handling the error message ourselves
            assign pEventArgs:ReturnStatusCode      = 0
                   pEventArgs:Response:Entity       = entityWriter:Entity
                   pEventArgs:Response:ContentType  = contentType
                   .
        end.
        else
            // we don't know how to write the error response, so let the webapp handle it
            assign pEventArgs:ReturnStatusCode = integer(StatusCodeEnum:InternalServerError).
    end method.
    
    /* Event handler for the event published before the business logic function is called by the handler
       
       @param Progress.Lang.Object The handler publishing the event
       @param OperationInvocationEventArgs Event args for this event */
    method public void InvokingHandler (input pSender as Progress.Lang.Object,
                                        input pEventArgs as OperationInvocationEventArgs):
    end method. 
    
    /* Event handler for the event published after the business logic function was called by the handler
       
       @param Progress.Lang.Object The handler publishing the event
       @param OperationInvocationEventArgs Event args for this event */
    method public void InvokedHandler (input pSender as Progress.Lang.Object,
                                       input pEventArgs as OperationInvocationEventArgs):
    end method.
    
    /* Event handler for service discovery
       
       @param Progress.Lang.Object The handler publishing the event
       @param ServiceLookupEventArgs Event args for this event */
    method public void DiscoverServiceHandler(input pSender as Progress.Lang.Object,
                                              input pEventArgs as ServiceDiscoveryEventArgs):
        // If we have a service, or something already went wrong, return
        if    valid-object(pEventArgs:Service)
           or pEventArgs:Cancel
           or valid-object(pEventArgs:Error)
        then
            return.
        
        if not valid-object(pEventArgs:Registry) then
        do:
            Logger:Trace(substitute('Service registry not set for "&1 &2"; using default',
                                pEventArgs:Request:Method,
                                pEventArgs:Request:URI:ToString())).
            assign pEventArgs:Registry = ServiceRegistry:Registry.
        end.
        
        if pEventArgs:Registry:HasService(pEventArgs:Name, pEventArgs:Version) then
            assign pEventArgs:Service = pEventArgs:Registry:GetService(pEventArgs:Name, pEventArgs:Version).
        
        // If we don't have a registered service, look on disk
        if not valid-object(pEventArgs:Service) then
        do:
            // Use the registry from the args for loading the service into.
            assign ServiceRegistry:Loader:Registry = pEventArgs:Registry. 
            
            // try to load from disk (.GEN and/or .MAP)
            if ServiceRegistry:Loader:TryFindService(pEventArgs:Name, pEventArgs:Version, pEventArgs:Request:WebAppPath) then
                assign pEventArgs:Service = pEventArgs:Registry:GetService(pEventArgs:Name, pEventArgs:Version).
            else
            do:
                Logger:Debug(substitute('Service not found for "&1 &2"',
                                        pEventArgs:Request:Method, pEventArgs:Request:URI:ToString())).
                undo, throw new SendExceptionError(StatusCodeEnum:NotFound,
                                                   new AppError(substitute('Service not found for "&1 &2"',
                                                                    pEventArgs:Request:Method, 
                                                                    pEventArgs:Request:URI:ToString()),
                                                                0)).
            end.
        end.
    end method.
    
    /* Splits a URI path into a service and service-relative-uri. Can be used for
       tokenised paths or 'real' paths.
       
       @param character A path to split/parse
       @return character[2] An array of strings from the path. The first extent is
                            the service name. The second extent is the service-relative URI */
    method protected character extent 2 SplitServicePath (input pcPath as character):
        define variable cPath as character case-sensitive extent 2 no-undo.
        
        Assert:NotNull(pcPath, 'Path info').
        assign /* PathInfo is going to be /pdo/service/resource/blah or
                  /service/resource/blah  */
               cPath[2] = trim(pcPath, '/':u)
               cPath[1] = entry(1, cPath[2], '/':u)
               .
        // could be /pdo/ or /something-else-service
        if cPath[1] eq DataObjectHandler:HANDLER_PREFIX then
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
            assign cPath[1] = DataObjectService:ROOT_SERVICE_NAME. 
        
        /* we don't want a blank uri so we use '/' */
        if cPath[2] eq '':u then
            assign cPath[2] = DataObjectService:ROOT_SERVICE_URI.
        
        return cPath.
    end method. 
    
end class.
