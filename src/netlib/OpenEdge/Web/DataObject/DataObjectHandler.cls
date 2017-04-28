/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
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
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Core.LogLevelEnum.
using OpenEdge.Core.LogicalValue.
using OpenEdge.Core.Memptr.
using OpenEdge.Core.Util.ILogWriter.
using OpenEdge.Core.Util.ISupportLogging.
using OpenEdge.Core.Util.LogManagerLogger.
using OpenEdge.Core.WidgetHandle.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using OpenEdge.Net.HTTP.Filter.Writer.EntityWriterBuilder.
using OpenEdge.Net.HTTP.HttpRequestError.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.MethodEnum.
using OpenEdge.Net.HTTP.StatusCodeEnum.
using OpenEdge.Net.HTTP.StatusCodeHelper.
using OpenEdge.Net.MimeTypeHelper.
using OpenEdge.Web.DataObject.FileOperationHandler.
using OpenEdge.Web.DataObject.HandlerErrorEventArgs.
using OpenEdge.Web.DataObject.HandlerLoadEntityEventArgs.
using OpenEdge.Web.DataObject.IOperationHandler.
using OpenEdge.Web.DataObject.MappedOperation.
using OpenEdge.Web.DataObject.OperationInvocationEventArgs.
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
using OpenEdge.Web.DataObject.DataObjectHandler.

class OpenEdge.Web.DataObject.DataObjectHandler implements IWebHandler, ISupportInitialize, ISupportLogging, IOperationHandler:
    /* Event published when an error is encountered 
       
       @param Progress.Lang.Object The handler publishing the event
       @param HandlerErrorEventArgs Event args for this event */
    define static public event OperationError signature void (input poSender as Progress.Lang.Object,
                                                              input poEventArgs as HandlerErrorEventArgs). 
    
    /* Event published to invoke/load a piece of business logic (aka Business Entity).
       
       If none exists, we try a simple DYNAMIC-NEW. 
       
       @param Progress.Lang.Object The handler publishing the event
       @param HandlerLoadEntityEventArgs Event args for this event */
    define static public event LoadEntity signature void (input poSender as Progress.Lang.Object,
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
    
    /* Lets a logging subsystem subscribe to our log messages */
    define public event LogMessage signature void (input poSender as Progress.Lang.Object,
                                                   input pcMessageGroup as character,
                                                   input pcMessage as character,
                                                   input poLogLevel as LogLevelEnum).


    /* Holds references to BE's, for cases where there's no external factory/service manager */
    define static private temp-table TargetRef no-undo
        field Service as character
        field EntityName as character
        field Entity as Progress.Lang.Object
        index idx1 as primary unique Service EntityName. 
            
    /* Reference to logger */
    define private variable moLogger as ILogWriter no-undo.
    
    constructor public DataObjectHandler():
        super().
        
        assign moLogger = new LogManagerLogger().
        /* Initialize() should be called externally since we implement ISupportInitialize */
    end constructor.

    destructor DataObjectHandler():
        Destroy().
    end destructor.
    
    /* Handles an exception that has been raised while dealing with the request.
       The OE default is to return a status code; to customise, subscribe to the 
       OperationError event  and change the ReturnStatusCode value
       
       @param Progress.Lang.Error The as-yet-unhandled exception
       @param IWebRequest The request that resulting in the exception
       @param IHttpResponse The current response object, if any
       @param Progress.Lang.Object The 'business entity' object, if any
       @return integer A non-null status code use to deal with errors */
    method protected integer HandleException(input poError    as Progress.Lang.Error,
                                             input poRequest  as IWebRequest,
                                             input poResponse as IHttpResponse,
                                             input poBusinessEntity   as Progress.Lang.Object,
                                             input poOperation as MappedOperation):
        define variable oArgs as HandlerErrorEventArgs no-undo.
        define variable oWriter as WebResponseWriter no-undo.
        define variable oEntityWriter as MessageWriter no-undo.
        define variable cEnvelope as character no-undo.
        define variable iStatusCode as integer no-undo.
        define variable cContentType as character no-undo.
        
        Assert:NotNull(poRequest, 'Web request').
        Assert:NotNull(poRequest, 'Web response').
        Assert:NotNull(poError, 'Error').
        
        LogMessage(substitute('EXCEPTION RAISED: &1 &2 : Error=&3 (&5); Entity=&4; Operation=&6':u,
                      poRequest:Method, 
                      poRequest:URI:ToString(), 
                      poError:ToString(), 
                      (if valid-object(poBusinessEntity) then poBusinessEntity:ToString() else '':u),
                      poError:GetClass():TypeName,
                      (if valid-object(poOperation) then poOperation:ToString() else '':u)), 
                   LogLevelEnum:ERROR).
        
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
        case true:
            /* We know something went wrong, and we were told what */
            when type-of(poError, SendExceptionError) then
            do:
                LogMessage(substitute('SEND EXCEPTION ERROR: &1', cast(poError, SendExceptionError):StatusMessage),
                           LogLevelEnum:ERROR).
                LogMessage(substitute('SEND EXCEPTION ERROR: &1', cast(poError, SendExceptionError):GetClass():TypeName),
                           LogLevelEnum:ERROR).
                LogMessage(substitute('SEND EXCEPTION ERROR: &1', poError:CallStack), 
                           LogLevelEnum:ERROR).
                
                assign iStatusCode = integer(cast(poError, SendExceptionError):StatusCode).

                if valid-object(cast(poError, SendExceptionError):InnerError) then
                do:
                    LogMessage(substitute('SEND EXCEPTION INNER ERROR: &1', cast(poError, SendExceptionError):InnerError:GetClass():TypeName),
                               LogLevelEnum:ERROR).
                    LogMessage(substitute('SEND EXCEPTION INNER ERROR: &1', cast(poError, SendExceptionError):InnerError:GetMessage(1)),        
                               LogLevelEnum:ERROR).
                    LogMessage(substitute('SEND EXCEPTION INNER ERROR: &1', cast(poError, SendExceptionError):InnerError:CallStack),            
                               LogLevelEnum:ERROR).
                    
                end.
            end.    // SendExceptionError
            otherwise
            /* all we know is something horrible happened ... */
            do:
                LogMessage(substitute('INTERNAL ERROR: &1', poError:GetMessage(1)),       LogLevelEnum:ERROR).
                LogMessage(substitute('INTERNAL ERROR: &1', poError:GetClass():TypeName), LogLevelEnum:ERROR).
                LogMessage(substitute('INTERNAL ERROR: &1', poError:CallStack),           LogLevelEnum:ERROR).
                
                assign iStatusCode = integer(StatusCodeEnum:InternalServerError).
            end.    // generalise
        end case.
                
        if valid-object(oEntityWriter) then
        do:
            oEntityWriter:Write(poError).
            oEntityWriter:Close().
            
            assign oArgs:Response:StatusCode   = iStatusCode
                   oArgs:Response:StatusReason = StatusCodeHelper:GetMessage(iStatusCode)
                   oArgs:Response:Entity       = oEntityWriter:Entity
                   oArgs:Response:ContentType  = cContentType
                   // we're handling it ourselves 
                   oArgs:ReturnStatusCode     = 0
                   . 
        end.
        else
            assign oArgs:ReturnStatusCode = iStatusCode.
            
        /* see if anyone is going to customise this */
        OnOperationError(oArgs).
        
        /* a non-zero value means that we will use the static pages */
        if oArgs:ReturnStatusCode eq 0 then
        do:
            /* is there an envelope? */
            if valid-object(poOperation) and
               poOperation:Options:Has('errorEnvelope':u) then
            do:
                if poOperation:Options:GetType('errorEnvelope':u) eq JsonDataType:BOOLEAN and
                   poOperation:Options:GetLogical('errorEnvelope':u) then
                    assign cEnvelope = 'error':u.
                else
                    assign cEnvelope = poOperation:Options:GetCharacter('errorEnvelope':u).
                
                AddResponseEnvelope(poResponse, poOperation, cEnvelope).
            end.    
        
            WriteResponse(oArgs:Response).
        end.
        
        return oArgs:ReturnStatusCode.
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
        moLogger:SubscribeTo(this-object).
    end method.
    
    /* Destroy/Shutdown/Anti-Initializer */
    method public void Destroy():
        RemoveAllEntities(this-object:GetClass():TypeName).
        
        moLogger:UnsubscribeFrom(this-object).
    end method.
    
/** HANDLING OF THE REQUEST **/    
    /* Returns a useable instance of a business entity/logic class
       
       @param character The (internal) id of the mapped operation
       @return Progress.Lang.Object the business entity instance */
    method protected Progress.Lang.Object InvokeEntity(input poOperation as MappedOperation,
                                                       input poRequest as IWebRequest):
        define variable oArgs   as HandlerLoadEntityEventArgs no-undo.
        define variable oBusinessEntity as Progress.Lang.Object no-undo.
        define variable hProcedure as handle no-undo.
        
        Assert:NotNull(poOperation, 'Mapped operation').
        
        assign oArgs = new HandlerLoadEntityEventArgs(poRequest, poOperation).
        
        case poOperation:TargetType:
            when TargetTypeEnum:Self then
                assign oArgs:EntityType = get-class(DataObjectHandler).
            when TargetTypeEnum:Void then
                assign oArgs:EntityType = get-class(DataObjectHandler).
            when TargetTypeEnum:File then
                assign oArgs:EntityType = get-class(FileOperationHandler).                            
            when TargetTypeEnum:Procedure then
                assign oArgs:EntityType = get-class(WidgetHandle).
            otherwise
               /* default since we don't know what this type should be */
               assign oArgs:EntityType = get-class(Progress.Lang.Object).
        end case.
        
        OnLoadEntity(oArgs).
        
        /* bzzzt */
        if valid-object(oArgs:Error) then
            undo, throw oArgs:Error.
        
        if oArgs:Cancel then
        do:
            LogMessage(substitute('Business entity &1 load for operation &2 cancelled',
                            poOperation:TargetName,
                            poOperation:ToString()),
                       LogLevelEnum:WARN). 
            undo, throw new AppError(substitute('Business entity &1 load for operation &2 cancelled',
                                        poOperation:TargetName,
                                        poOperation:ToString()),
                                     0).                        
        end.
        
        assign oBusinessEntity = oArgs:BusinessEntity.
        
        if not valid-object(oBusinessEntity) then
        case poOperation:TargetType:
            when TargetTypeEnum:Void or 
            when TargetTypeEnum:Self then
                assign oBusinessEntity = this-object.
            when TargetTypeEnum:File then
                assign oBusinessEntity = GetOperationHandler(TargetTypeEnum:File).  
            when TargetTypeEnum:Class then
            do:
                assign oBusinessEntity = GetEntity(poOperation:ServiceName, poOperation:TargetName).
                
                if not valid-object(oBusinessEntity) then
                do:
                    oBusinessEntity = dynamic-new string(poOperation:TargetName) ().
                    SetEntity(poOperation:ServiceName, poOperation:TargetName, oBusinessEntity).
                end.
            end.    /* class */
            when TargetTypeEnum:Procedure then
            do:
                assign oBusinessEntity = GetEntity(poOperation:ServiceName, poOperation:TargetName).
                if not valid-object(oBusinessEntity) then
                do:
                    run value(poOperation:TargetName) persistent set hProcedure.
                    assign oBusinessEntity = new WidgetHandle(hProcedure).
                    SetEntity(poOperation:ServiceName, poOperation:TargetName, oBusinessEntity).
                end.
            end.    /* proc */
            otherwise
                assign oBusinessEntity = ?.
        end case.
        
        if valid-object(oArgs:EntityType) then
            Assert:IsType(oBusinessEntity, oArgs:EntityType).
        
        LogMessage(substitute('Using entity &1 for operation &2',
                        oBusinessEntity:ToString(), poOperation:ToString()),
                   LogLevelEnum:DEBUG).
        
        return oBusinessEntity.        
    end method.
    
    /* Processes a request. The primary entrypoint into the handler.
       
       @return integer The HTTP status code that PASOE may use to return static pages. Use 0 for DIY */
    method public integer HandleRequest():
        /* default behaviour is to handle this ourselves */
        define variable iStatusCode as integer no-undo initial 0.
        define variable cService as character no-undo.
        define variable cServicePath as character no-undo.
        define variable oRequest as IWebRequest no-undo.
        define variable oResponse as IHttpResponse no-undo.
        define variable oOperation as MappedOperation no-undo.
        define variable oBusinessEntity as Progress.Lang.Object no-undo.
        define variable oMessageBody as Progress.Lang.Object no-undo.
        define variable oOperationArgs as OperationInvocationEventArgs no-undo.
        define variable oOperationHandler as IOperationHandler no-undo.
        
        assign session:error-stack-trace = (log-manager:logging-level ge int64(LogLevelEnum:ERROR))
               
               oRequest  = new WebRequest()
               oResponse = new WebResponse()
               
               // PathInfo is going to be /pdo/service/resource/blah 
               cServicePath = trim(substring(oRequest:PathInfo, 5), '/':u)
               // now we should have service/resource/blah or empty
               cService     = entry(1, cServicePath, '/':u)
               .
        /* we don't want a blank key so we use 'ROOT' */
        if cService eq '':u then
            assign cService = ServiceRegistry:ROOT_SERVICE_NAME. 

        /* find the individual operation 
           there should be no leading / so the first / we find is the beginning of the service path/URI */
        assign cServicePath = trim(substring(cServicePath, index(cServicePath, '/':U) + 1), '/':u).
        
        /* we don't want a blank key so we use '/' */
        if cServicePath eq '':u or 
           cServicePath eq cService then
            assign cServicePath = ServiceRegistry:ROOT_SERVICE_URI.
        
        LogMessage(substitute('Request received for &1 &2 ; service=&3 ; service path=&4',
                        oRequest:Method, oRequest:URI:ToString(), cService, cServicePath),
                   LogLevelEnum:TRACE).
        
        /* find the service */
        if not ServiceRegistry:TryFindService(cService, oRequest:WebAppPath) then
        do:
            assign oResponse:StatusCode = integer(StatusCodeEnum:NotFound).            
            LogMessage(substitute('Service not found for "&1 &2"',
                                    oRequest:Method, oRequest:URI:ToString()),
                               LogLevelEnum:DEBUG).
            /* assign-and-return so that we can log it in the FINALLY */
            assign iStatusCode = HandleException(new SendExceptionError(StatusCodeEnum:NotFound), 
                                                 oRequest,
                                                 oResponse,
                                                 this-object,     //oBusinessEntity
                                                 oOperation).
            return iStatusCode. 
        end.
        
        assign oOperation = ServiceRegistry:GetOperation(cService, cServicePath, MethodEnum:GetEnum(oRequest:Method)).
        if not valid-object(oOperation) then
        do:
            assign oResponse:StatusCode = integer(StatusCodeEnum:NotImplemented).
            LogMessage(substitute('Mapped operation not found for service "&1" with path "&2"',
                                    cService, cServicePath),
                               LogLevelEnum:DEBUG).
            /* assign-and-return so that we can log it in the FINALLY */
            assign iStatusCode = HandleException(new SendExceptionError(StatusCodeEnum:NotImplemented),
                                                 oRequest,
                                                 oResponse,
                                                 this-object,     //oBusinessEntity
                                                 oOperation).
            return iStatusCode.
        end.

        LogMessage(substitute('Using mapped operation for &1 &2: &3',
                        string(oOperation:Method), cServicePath,
                        string(oOperation)),
                   LogLevelEnum:DEBUG).
        
        /* the operation must be able to service the request, per the Accept header */
        if not ValidateContentType(oRequest, oOperation:ContentType) then
            undo, throw new SendExceptionError(StatusCodeEnum:NotAcceptable,
                                               new AppError(substitute('Request "Accept" header value "&1" and operation ContentType "&2" value are not compatible',
                                                                 oRequest:GetHeader('Accept':u):Value,
                                                                 oOperation:ContentType),
                                                            0)).
        
        assign iStatusCode = PerformOperation(oRequest,
                                              ExtractMessageBody(oRequest, oOperation),
                                              oResponse, 
                                              oOperation).
        if iStatusCode eq 0 then
        do:
            AddResponseEnvelope(oResponse, oOperation).
            WriteResponse(oResponse).
        end.
        
        return iStatusCode.
        /* errors? */
        catch oError as Progress.Lang.Error:
            /* don't want any unhandled exceptions from handling exceptions leaking out and ruining the party */
            assign iStatusCode = HandleException(oError, oRequest, oResponse, oBusinessEntity, oOperation) no-error.
            if iStatusCode eq ? then
            do:
                assign iStatusCode = integer(StatusCodeEnum:InternalServerError).
                
                LogMessage(substitute('EXCEPTION STATUS CODE UNKNOWN: &1 &2', oRequest:Method, oRequest:URI:Path),
                           LogLevelEnum:ERROR).
            end.
            
            return iStatusCode.
        end catch.
        finally:
            LogMessage(substitute('Operation returned status code &1 / &2',
                            iStatusCode,
                            StatusCodeHelper:GetMessage(iStatusCode)),
                       LogLevelEnum:TRACE).
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
        
        LogMessage(substitute('"Accept" value: &1', 
                       cAccept),
                   LogLevelEnum:DEBUG).
        LogMessage(substitute('Operation ContentType: &1',
                       pcContentType),
                   LogLevelEnum:DEBUG).
                               
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
        define variable oBusinessEntity as Progress.Lang.Object no-undo.
        define variable oOperationArgs as OperationInvocationEventArgs no-undo.
        define variable oOperationHandler as IOperationHandler no-undo.
        define variable iTimeout as integer no-undo.
        define variable oStopError as Progress.Lang.Error no-undo.
        
        Assert:NotNull(poRequest,   'Web request').
        Assert:NotNull(poResponse,  'Web response').
        Assert:NotNull(poOperation, 'Mapped operation').
    
        assign poResponse:ContentType = poOperation:ContentType
               poResponse:StatusCode  = poOperation:StatusCode      when poOperation:StatusCode ne 0
               
               oBusinessEntity            = InvokeEntity(poOperation, poRequest)
               oOperationArgs             = new OperationInvocationEventArgs(poRequest, oBusinessEntity, poResponse, poOperation)
               oOperationArgs:RequestBody = poMessageBody
               iStatusCode    = 0
               .
        OnInvoking(oOperationArgs).
        if valid-object(oOperationArgs:Error) then
            return HandleException(oOperationArgs:Error, 
                                   oOperationArgs:Request,
                                   oOperationArgs:Response, 
                                   oOperationArgs:BusinessEntity,
                                   oOperationArgs:Operation ).
        
        /* do the work */
        assign oOperationHandler = GetOperationHandler(poOperation:TargetType).
                oStopError       = new HttpRequestError(string(integer(StatusCodeEnum:RequestTimeOut)),
                                             poRequest:Method,
                                             poRequest:URI:ToString()).

        if poOperation:Options:Has('timeout':u) and
           poOperation:Options:GetType('timeout':u) eq JsonDataType:NUMBER then
            assign iTimeout = poOperation:Options:GetInteger('timeout':u).                      
        
        if valid-object(oOperationHandler) then
        do  on stop undo, return error oStopError
            on error undo, throw
            
            stop-after iTimeout:

            assign iStatusCode = oOperationHandler:Execute(poRequest, poMessageBody, poResponse, poOperation, oBusinessEntity).        
        end.
        else
            undo, throw new AppError(substitute('Unable to service request for "&1 &2"',
                                            poOperation:Method, 
                                            poOperation:ServiceURI), 
                                    0).

        assign oOperationArgs = new OperationInvocationEventArgs(poRequest, oBusinessEntity, poResponse, poOperation)
               oOperationArgs:RequestBody     = poMessageBody
               oOperationArgs:ReturnStatusCode = iStatusCode
               .
        OnInvoked(oOperationArgs).
        if valid-object(oOperationArgs:Error) then
            return HandleException(oOperationArgs:Error, 
                                   oOperationArgs:Request,
                                   oOperationArgs:Response, 
                                   oOperationArgs:BusinessEntity,
                                   oOperationArgs:Operation ).
        
        return oOperationArgs:ReturnStatusCode.
    end method.
    
    /* Factory method for retrieving an operation handler   
       
       @param TargetTypeEnum The operation type for which to find a handler
       @return IOperationHandler A handler, if one exists */
    method protected IOperationHandler GetOperationHandler(input poTargetType as TargetTypeEnum):
        define variable oHandler as IOperationHandler no-undo.
        define variable oHandlerType as class Progress.Lang.Class no-undo.
        define variable cTypeName as character no-undo.
        
        Assert:NotNull(poTargetType).
        
        if poTargetType:Equals(TargetTypeEnum:Self) then
            return this-object.
        
        assign cTypeName = substitute('&1.&2':u,
                                poTargetType:GetClass():TypeName,
                                poTargetType:ToString())
               oHandler  = cast(GetEntity(this-object:GetClass():TypeName, cTypeName),
                               IOperationHandler).
        
        if not valid-object(oHandler) then
        do:
            assign oHandlerType = OperationHandlerRegistry:Registry:Get(cTypeName).
            
            Assert:IsType(oHandlerType, get-class(IOperationHandler)).
            oHandler = dynamic-new string(oHandlerType:TypeName) (moLogger).
            
            if valid-object(oHandler) and type-of(oHandler, ISupportInitialize) then
                cast(oHandler, ISupportInitialize):Initialize().
            
            SetEntity(this-object:GetClass():TypeName, cTypeName,
                      oHandler).
        end.
        
        return oHandler.
    end method.

    /* Retrieves a catalog for a named service. First tries to run a mapped 
       operation, then looks in the serviceregistry
       
       @param MappedOperation The mapped operation
       @param IWebRequest The request that resulting in the exception
       @param P.L.Object The message body of the incoming request. Typically 
                         will be transformed from bytes into something useful; may also have an envelope removed.
       @param IHttpResponse The current response object, if any
       @return integer A non-null status code use to deal with errors */ 
    method protected integer GetCatalog(input pcServiceName as character,
                                        input poRequest  as IWebRequest,
                                        input poMessageBody as Progress.Lang.Object,
                                        input poResponse as IHttpResponse):
        define variable oCatalogOperation as MappedOperation no-undo.
        define variable oCatalog as JsonObject no-undo.
        define variable iStatusCode as integer no-undo.
        
        Assert:NotNullOrEmpty(pcServiceName, 'Service').
        Assert:NotNull(poRequest, 'Web request').
        Assert:NotNull(poResponse, 'Web response').
        
        assign oCatalogOperation = ServiceRegistry:GetOperation(pcServiceName, ServiceRegistry:ROOT_SERVICE_URI, MethodEnum:GET).
        if not valid-object(oCatalogOperation) then
            assign oCatalog    = ServiceRegistry:GetServiceCatalog(pcServiceName)
                   iStatusCode = 0
                   
                   poResponse:ContentType = 'application/json':u
                   poResponse:Entity      = oCatalog.
        else
            assign iStatusCode = PerformOperation(poRequest, poMessageBody, poResponse, oCatalogOperation).                   
        
        return iStatusCode.
    end method.
    
    /* Deregisters all known services 
       
       @param MappedOperation The mapped operation
       @param IWebRequest The request that resulting in the exception
       @param IHttpResponse The current response object, if any
       @return integer A non-null status code use to deal with errors */
    method protected integer DeregisterAllServices(input poOperation as MappedOperation,
                                                   input poRequest  as IWebRequest,
                                                   input poResponse as IHttpResponse):
        define variable oServices as JsonArray no-undo.
        define variable oHeader as JsonObject no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable cServices as character extent no-undo.
        define variable iStatusCode as integer no-undo.
        
        Assert:NotNull(poOperation, 'Operation').
        Assert:NotNull(poRequest, 'Web request').
        Assert:NotNull(poResponse, 'Web response').
        
        assign oHeader           = new JsonObject() 
               oServices         = new JsonArray()
               poResponse:Entity = oServices
               iStatusCode       = 0
               
               iMax = ServiceRegistry:GetServices(output cServices).
        
        oHeader:Add('services':u, oServices).
            
        do iLoop = 1 to iMax:
            ServiceRegistry:DeregisterService(cServices[iLoop]).
            RemoveAllEntities(cServices[iLoop]).
            
            oServices:Add(cServices[iLoop]).
        end.
        
        return iStatusCode.
    end method.
    
    /* Deregisters asingle known services 
       
       @param MappedOperation The mapped operation
       @param IWebRequest The request that resulting in the exception
       @param IHttpResponse The current response object, if any
       @return integer A non-null status code use to deal with errors */
    method protected integer DeregisterService(input poOperation as MappedOperation,
                                               input poRequest  as IWebRequest,
                                               input poResponse as IHttpResponse):
        define variable oHeader as JsonObject no-undo.
        define variable oServices as JsonArray no-undo.
        define variable iStatusCode as integer no-undo.
        
        Assert:NotNull(poOperation, 'Operation').
        Assert:NotNull(poRequest, 'Web request').
        Assert:NotNull(poResponse, 'Web response').
        
        assign oHeader           = new JsonObject() 
               oServices         = new JsonArray()
               poResponse:Entity = oServices
               iStatusCode       = 0
               .
    
        LogMessage(substitute('DeregisterService called for &1',
                        poOperation:ServiceName),
                   LogLevelEnum:DEBUG).

        oHeader:Add('services':u, oServices).
        
        ServiceRegistry:DeregisterService(poOperation:ServiceName).
        RemoveAllEntities(poOperation:ServiceName).

        oServices:Add(poOperation:ServiceName).

        return iStatusCode.
    end method.

    /* Lists catalogs for all currently-registered services. 
       
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
        define variable oServices as JsonObject no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable cServices as character extent no-undo.
        define variable oCatalog as JsonObject no-undo.
        define variable iStatusCode as integer no-undo.
        define variable oCatalogResponse as IHttpResponse no-undo.
        
        Assert:NotNull(poOperation, 'Operation').
        Assert:NotNull(poRequest, 'Web request').
        Assert:NotNull(poResponse, 'Web response').
        
        assign oServices              = new JsonObject() 
               poResponse:Entity      = oServices
               iStatusCode            = 0
               
               iMax = ServiceRegistry:GetServices(output cServices).
        do iLoop = 1 to iMax:
            if cServices[iLoop] eq ServiceRegistry:ROOT_SERVICE_NAME then
            do:
                /* this value will be overwritten if there are other services. */
                assign iStatusCode = integer(StatusCodeEnum:NotFound).
                next.
            end.
            
            assign oCatalog         = ? 
                   oCatalogResponse = new WebResponse()
                   iStatusCode      = this-object:GetCatalog(cServices[iLoop], poRequest, poMessageBody, oCatalogResponse)
                   .
            if iStatusCode ne 0 then
                return iStatusCode.
            
            if type-of(oCatalogResponse:Entity, JsonObject) then
                assign oCatalog = cast(oCatalogResponse:Entity, JsonObject).
            else
                LogMessage(substitute('Unable to convert catalog for service &1 to JsonObject',
                                cServices[iLoop]), 
                           LogLevelEnum:ERROR).
            
            oServices:Add(cServices[iLoop], oCatalog).
        end.
        
        return iStatusCode.
    end method.
    
    /** Logs a message 
        
        @param character The message to log
        @param integer  The level this message should be logged at */
    method private void LogMessage(input pcMessage as character,
                                   input poLogLevel as LogLevelEnum):
        this-object:LogMessage:Publish(this-object,
                                       'DOH-HDLR':u,
                                       pcMessage,
                                       poLogLevel).
    end method.
    
    /* Publishes the 'Invoking' event with the provided args 
    
       @param OperationInvocationEventArgs The args for this event */
    method protected void OnInvoking(input poEventArgs as OperationInvocationEventArgs):
        Assert:NotNull(poEventArgs, 'Event args').
        
        DataObjectHandler:Invoking:Publish(this-object, poEventArgs).
    end method.
    
    /* Publishes the 'Invoked' event with the provided args 
    
       @param OperationInvocationEventArgs The args for this event */
    method protected void OnInvoked(input poEventArgs as OperationInvocationEventArgs):
        Assert:NotNull(poEventArgs, 'Event args').
        
        DataObjectHandler:Invoked:Publish(this-object, poEventArgs).
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
            when 'DeregisterAllServices':u then
                assign iStatusCode = this-object:DeregisterAllServices(poOperation, poRequest, poResponse).
            when 'DeregisterService':u then
                assign iStatusCode = this-object:DeregisterService(poOperation, poRequest, poResponse).
            when 'ListServices':u then
                assign iStatusCode = this-object:ListServices(poOperation, poRequest, poMessageBody, poResponse).
            when 'GetCatalog':u then
                assign iStatusCode = this-object:GetCatalog(poOperation:ServiceName,
                                                            poRequest, 
                                                            poMessageBody,
                                                            poResponse).
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
                                                   input pcEntityName as character):
        define variable oBusinessEntity as Progress.Lang.Object no-undo.
        define buffer lbEntity for TargetRef.
        
        Assert:NotNullOrEmpty(pcService, 'Service').
        Assert:NotNullOrEmpty(pcEntityName, 'Entity name').
        
        find lbEntity where
             lbEntity.Service eq pcService and
             lbEntity.EntityName eq pcEntityName
             no-error.
        if available lbEntity then
            assign oBusinessEntity = lbEntity.Entity.
                 
        return oBusinessEntity.
    end method.
    
    /* Caches an entity instance for a given service & operation 
       
       @param character The service name
       @param character The entity name 
       @param Progress.Lang.Object The entity instance. may be null/unknown
       @return logical Returns TRUE if the entity was alrady cached */
    method private logical SetEntity(input pcService as character,
                                     input pcEntityName as character,
                                     input poBusinessEntity as Progress.Lang.Object):
        define variable lExists as logical no-undo.
        define buffer lbEntity for TargetRef.

        Assert:NotNullOrEmpty(pcService, 'Service').
        Assert:NotNullOrEmpty(pcEntityName, 'Entity name').
        
        find lbEntity where
             lbEntity.Service eq pcService and
             lbEntity.EntityName eq pcEntityName
             no-error.
        assign lExists = available lbEntity. 
        if not lExists then
        do:
            create lbEntity.
            assign lbEntity.Service    = pcService
                   lbEntity.EntityName = pcEntityName
                   .
        end.
        
        assign lbEntity.Entity = poBusinessEntity.
        return lExists.                                                
    end method.

    /* Removes a cached entity instance for a given service & operation 
       
       @param character The service name
       @param character The entity name */
    method private logical RemoveEntity(input pcService as character,
                                        input pcEntityName as character):
        define variable lExists as logical no-undo.
        define buffer lbEntity for TargetRef.

        Assert:NotNullOrEmpty(pcService, 'Service').
        Assert:NotNullOrEmpty(pcEntityName, 'Entity name').
        
        find lbEntity where
             lbEntity.Service eq pcService and
             lbEntity.EntityName eq pcEntityName
             no-error.
        assign lExists = available lbEntity. 
        if lExists then
        do:
            LogMessage(substitute('Cached entity "&1" removed for service "&2"',
                            lbEntity.EntityName, pcService),
                      LogLevelEnum:DEBUG).
            delete lbEntity.
        end.
        
        return lExists.
    end method.

    /* Removes all the cached entity instances for a given service 
    
       @param character The service name */
    method private void RemoveAllEntities(input pcService as character):
        define variable lExists as logical no-undo.
        define buffer lbEntity for TargetRef.

        Assert:NotNullOrEmpty(pcService, 'Service').

        for each lbEntity where lbEntity.Service eq pcService:
            LogMessage(substitute('Cached entity "&1" removed for service "&2"',
                            lbEntity.EntityName, pcService),
                      LogLevelEnum:DEBUG).
            delete lbEntity.
        end.
    end method.
    
    /* Retrieves the actual data from an request. Strips the envelop ('request' or similar) 
       
       @param  IWebRequest The incoming request `
       @param  OperationArgument Metadata about what to do with this request
       @return Progress.Lang.Object The extracted body */
    method protected Progress.Lang.Object ExtractMessageBody (input poRequest as IWebRequest,
                                                              input poOperation as MappedOperation):
        define variable cEnvelope as character no-undo.
        define variable oBody as Progress.Lang.Object no-undo.
        define variable oEntityWriter as MessageWriter no-undo.
        
        Assert:NotNull(poOperation, 'Operation'). 
        Assert:NotNull(poRequest, 'Web Request').
        
        /*  Convert the body from bytes into something stronger-typed */
        assign oBody = poRequest:Entity.
        
        LogMessage(substitute('Request has body: &1',
                        valid-object(oBody)),
                   LogLevelEnum:TRACE).
        if valid-object(oBody) then
            LogMessage(substitute('Request body: &1 val=&2',
                            oBody:GetClass():TypeName,
                            oBody:ToString()),
                       LogLevelEnum:TRACE).
        
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
            assign oEntityWriter = EntityWriterBuilder:Build(poRequest):Writer.
            if valid-object(oEntityWriter) then
            do:
                oEntityWriter:Open().
                oEntityWriter:Write(oBody).
                oEntityWriter:Close().
                
                assign oBody = oEntityWriter:Entity.
                
                LogMessage(substitute('Request body written as &1 for Content-Type &2',
                                oBody:GetClass():TypeName,
                                poRequest:ContentType),
                           LogLevelEnum:TRACE).
            end.
        end.
        
        /* is there an envelope? */
        if not poOperation:Options:Has('requestEnvelope':u) then
            return oBody.
        
        if poOperation:Options:GetType('requestEnvelope':u) eq JsonDataType:BOOLEAN and
           poOperation:Options:GetLogical('requestEnvelope':u) then
            assign cEnvelope = 'request':u.
        else
            assign cEnvelope = poOperation:Options:GetCharacter('requestEnvelope':u).
        
        if cEnvelope eq '':u then
            return oBody. 
        
        LogMessage(substitute('Extracting request data from envelope "&1"',
                        cEnvelope),
                   LogLevelEnum:INFO).
       
        /* now we have the envelope, get the children of it */
        case true:
            when MimeTypeHelper:IsJson(poRequest:ContentType) then
            do:
                Assert:IsType(oBody, get-class(JsonObject)).
                
                if not cast(oBody, JsonObject):Has(cEnvelope) then
                do:
                    LogMessage(substitute('Unable to find envelope "&1" in request &2 &3',
                                cEnvelope,
                                poRequest:Method,
                                poRequest:URI:ToString()),
                               LogLevelEnum:WARN).
                    return oBody.
                end.
                
                case cast(oBody, JsonObject):GetType(cEnvelope):
                    when JsonDataType:OBJECT  then return cast(oBody, JsonObject):GetJsonObject(cEnvelope).
                    when JsonDataType:ARRAY   then return cast(oBody, JsonObject):GetJsonArray(cEnvelope). 
                    when JsonDataType:STRING  then return new OpenEdge.Core.String(cast(oBody, JsonObject):GetCharacter(cEnvelope)).
                    when JsonDataType:BOOLEAN then return new LogicalValue(cast(oBody, JsonObject):GetLogical(cEnvelope)).
                    when JsonDataType:NUMBER  then return new OpenEdge.Core.Decimal(cast(oBody, JsonObject):GetDecimal(cEnvelope)).
                    when JsonDataType:NULL    then return ?.
                end case.
            end.    //JSON
            
            otherwise
                LogMessage(substitute('Unable to extract content from envelope &1 for content-type &2',
                                cEnvelope, poRequest:ContentType),
                           LogLevelEnum:WARN).
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
            LogMessage (substitute('Unable to find entity writer for &1',
                            poResponse:ContentType),
                        LogLevelEnum:WARN).
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

                LogMessage(substitute('Added envelope "&1" for operation &2',
                                pcEnvelope, poOperation:ToString()),
                           LogLevelEnum:WARN).
            end.    //JSON
            
            otherwise
                LogMessage(substitute('Unable to add envelope &1 for content-type &2',
                                pcEnvelope, poOperation:ContentType),
                           LogLevelEnum:WARN).
        end case.
    end method.
    
    /* Adds a 'response' or similar envelope to the body. At this point the incoming body should be
       in 'entity' format (ie non pure bytes).
       
       @param IHttpResponse The outgoing message 
       @param MappedOperation Metadata about what to do with this request */
    method protected void AddResponseEnvelope(input poResponse as IHttpResponse,
                                              input poOperation as MappedOperation):
        define variable cEnvelope as character no-undo.
        
        Assert:NotNull(poOperation, 'Mapped operation'). 
        Assert:NotNull(poResponse, 'Response').

        /* is there an envelope? */
        if not poOperation:Options:Has('responseEnvelope':u) then
            return.
            
        if poOperation:Options:GetType('responseEnvelope':u) eq JsonDataType:BOOLEAN and
           poOperation:Options:GetLogical('responseEnvelope':u) then
            assign cEnvelope = 'response':u.
        else
            assign cEnvelope = poOperation:Options:GetCharacter('responseEnvelope':u).
        
        AddResponseEnvelope(poResponse, poOperation, cEnvelope).
    end method.

end class.
