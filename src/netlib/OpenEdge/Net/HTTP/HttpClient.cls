/************************************************
Copyright (c) 2014-2017, 2019, 2021-2023 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : HttpClient
    Purpose     : Public HttpClient. All client code should be written against this class.
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : Fri Feb 14 10:44:00 EST 2014
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.IMemptrHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Core.File.
using OpenEdge.Core.IAdaptable.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.ISupportLogging.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Net.HTTP.ClientBuilder.
using OpenEdge.Net.HTTP.ClientOptions.
using OpenEdge.Net.HTTP.Cookie.
using OpenEdge.Net.HTTP.Filter.Writer.StatusCodeWriterBuilder.
using OpenEdge.Net.HTTP.HttpClient.
using OpenEdge.Net.HTTP.HttpHeaderBuilder.
using OpenEdge.Net.HTTP.IAuthenticatedRequest.
using OpenEdge.Net.HTTP.IHttpClient.
using OpenEdge.Net.HTTP.IHttpClientLibrary.
using OpenEdge.Net.HTTP.IHttpMessageWriter.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.ISupportProxy.
using OpenEdge.Net.HTTP.ITraceableRequest.
using OpenEdge.Net.HTTP.RequestBuilder.
using OpenEdge.Net.HTTP.ResponseBuilder.
using OpenEdge.Net.HTTP.Trace.ExchangeData.
using OpenEdge.Net.HTTP.Trace.IOutputConfig.
using OpenEdge.Net.HTTP.Trace.MessageTypeEnum.
using OpenEdge.Net.HTTP.Trace.OutputTypeEnum.
using OpenEdge.Net.HTTP.Trace.TraceConfig.
using OpenEdge.Net.HTTP.Trace.TraceConfigLoader.
using OpenEdge.Net.HTTP.TransferEncodingEnum.
using OpenEdge.Net.URI.
using Progress.Json.ObjectModel.JsonObject.

class OpenEdge.Net.HTTP.HttpClient
implements IHttpClient, ISupportInitialize, ISupportLogging, IAdaptable:
    /** (mandatory) A free-text name for this http client. Used for the USER-AGENT
        string. */
    define public property ClientName as character no-undo get. private set.

    /** (mandatory) A free-text semantic version string for this http client. Used for the USER-AGENT
        string. */
    define public property ClientVersion as character no-undo get. private set.

    /** Miscellanous options (like timeouts) for this client */
    define public property Options as ClientOptions no-undo get. private set.

    // A reference to the Logger in use by an implementer
    define public property Logger as ILogWriter no-undo
        get():
            if not valid-object(this-object:Logger) then
                assign this-object:Logger = LoggerBuilder:GetLogger(get-class(HttpClient)).

            return this-object:Logger.
        end get.
        set.

    /* The current trace configuration. May change per Execute() call, depending on the configuration */
    @since(rel='12.5.0').
    define protected property TraceConfig as TraceConfig no-undo
        get.
        set.

    /* An array of current/recent trace data. May be indeterminate if no requests have been traced */
    @since(rel='12.5.0').
    define protected property TraceData as ExchangeData extent no-undo
        get.
        set.

    /* Flag to indicate whether tracing is allowed on the current Execute() call. */
    define variable mAllowTracingOnExecute as logical no-undo.

    /* Reference to the library that does the actual work. */
    define private variable moWwwLib as IHttpClientLibrary no-undo.

    /** Factory method for instantiating a new http client client.
        This "Instance" method remains because it's already used elsewhere.
        The ClientBuilder() should be called directly in most cases.

        @return HttpClient A useful, constructed HttpClient. */
    method static public HttpClient Instance():
        /* assumption is that the default client is this type: OpenEdge.Net.HTTP.HttpClient */
        return cast(ClientBuilder:Build():Client, HttpClient).
    end method.

    /** Constructor.

        @param character The name of this Http Client
        @param character The (semantic: major.minor.patch) version of this Http Client
        @param IHttpClientLibrary The library performing the actual work */
    constructor public HttpClient(input pcClientName    as character,
                                  input pcClientVersion as character,
                                  input poLibrary as IHttpClientLibrary):
        Assert:NotNullOrEmpty(pcClientName, 'Client name').
        Assert:NotNullOrEmpty(pcClientVersion, 'Client version').
        Assert:NotNull(poLibrary, 'Http library').

        assign this-object:ClientName    = pcClientName
               this-object:ClientVersion = pcClientVersion
               this-object:Options       = new ClientOptions()

               moWwwLib = poLibrary
               .
    end constructor.

    destructor HttpClient():
        Destroy().
    end destructor.

    /** Executes an HTTP request.

        If this code changes, the code in HttpClientDecorator should
        too, to preserve the 'wrapper' nature of this method.

        @param  HttpRequest Request parameters (URL, method, etc)
        @return HttpResponse Includes status and payload */
    method public IHttpResponse Execute(input poRequest as IHttpRequest):
        define variable oResponse as IHttpResponse no-undo.

        assign oResponse = ResponseBuilder:Build():Response.

        Execute(poRequest, oResponse).

        return oResponse.
    end method.

    /* Starts tracing for this request, if so configured.

       @param IHttpRequest The current request. INPUT-OUTPUT since this method may decorate it. */
    @since(rel='12.5.0').
    method protected void RequestTraceStart(input-output pRequest as IHttpRequest):
        define variable oProxyReq    as ISupportProxy     no-undo.
        define variable traceRequest as ITraceableRequest no-undo.
        define variable iCount       as integer           no-undo.
        define variable iLoop        as integer           no-undo.
        define variable lPassedFilters as logical           no-undo.

        // Tracing not allowed for this request.
        if not mAllowTracingOnExecute then
            return.

        // will create a new decorator or return the current decorated request
        assign pRequest     = RequestBuilder:DecorateRequest(get-class(ITraceableRequest), pRequest)
               traceRequest = cast(pRequest, ITraceableRequest)
               .
        /* If the TraceConfig is enabled then check policy rules. */
        if this-object:TraceConfig:Enabled
        then do:
            /* Need to check for at least 1 UrlRule to confirm we have a valid policy for tracing this request. */
            assign iCount         = extent(this-object:TraceConfig:FilterRules)
                   /* Requests are allowed to be traced by default - a rule must actively disallow tracing */
                   lPassedFilters = true
                   .
            FILTER-LOOP:
            do iLoop = 1 to iCount
            on error undo, throw:
                if valid-object(this-object:TraceConfig:FilterRules[iLoop])
                and this-object:TraceConfig:FilterRules[iLoop]:MessageType:IsFlagSet(MessageTypeEnum:Request)
                then
                /* Confirm policy applies to this HttpRequest, otherwise we end any tracing activity. */
                    assign lPassedFilters = this-object:TraceConfig:FilterRules[iLoop]:ApplyPolicy(pRequest).

                if not lPassedFilters then
                do:
                    Logger:Debug(substitute('Tracing filter rule &1 returned FALSE for request to &2 &3',
                                            this-object:TraceConfig:FilterRules[iLoop]:GetClass():TypeName,
                                            pRequest:Method,
                                            pRequest:URI:BaseUri + pRequest:URI:Path)).
                    leave FILTER-LOOP.
                end.
                // Assume that any errors from a filter rule mean that we don't trace
                catch uncaught as Progress.Lang.Error :
                    assign lPassedFilters = false.
                    leave FILTER-LOOP.
                end catch.
            end.

            /* If the URL is valid then add information to this TraceableRequest. */
            if lPassedFilters then
            do:
                assign traceRequest:TraceData     = new ExchangeData()
                       traceRequest:RequestRules  = this-object:TraceConfig:RequestRules
                       traceRequest:ResponseRules = this-object:TraceConfig:ResponseRules
                       .
                /* Store information pertaining to the URL (path + query string) for this request. */
                traceRequest:TraceData:SetRequestInfo(pRequest).

                if this-object:TraceConfig:OutputType eq OutputTypeEnum:Proxy then
                do:
                    /* Check if the current request is already decorated as an ISupportProxy request. */
                    assign oProxyReq = cast(cast(pRequest, IAdaptable):GetAdapter(get-class(ISupportProxy)), ISupportProxy).
                    if valid-object(oProxyReq) then
                    do:
                        traceRequest:DisableTracing().
                        Logger:Info(substitute('Client cannot trace request to &1 &2 via proxy as it is already configured to use a proxy at &3',
                                               pRequest:Method, pRequest:URI:BaseUri + pRequest:URI:Path,
                                               string(oProxyReq:ProxyURI) )).
                    end.
                    else
                    if valid-object(this-object:TraceConfig:OutputConfig)
                    then
                        /* Decorate this request as a proxy and set the ProxyURI to the configured endpoint. */
                        assign pRequest = RequestBuilder:DecorateRequest(get-class(ISupportProxy), pRequest)
                               cast(pRequest, ISupportProxy):ProxyURI = cast(this-object:TraceConfig:OutputConfig, URI)
                               .
                    else
                        traceRequest:DisableTracing().
                end.
            end. /* URL is valid */
            else
                traceRequest:DisableTracing().
        end. /* Tracing Enabled */
        else
            /* If the request allows tracing, but the configuration has enabled=false then do no tracing. */
            traceRequest:DisableTracing().

        Logger:Debug(substitute('Request to &1 &2 has "&3" tracing &4',
                                pRequest:Method, pRequest:URI:BaseUri + pRequest:URI:Path,
                                string(this-object:TraceConfig:OutputType),
                                string(traceRequest:TracingEnabled, 'enabled/disabled'))).
        if traceRequest:TracingEnabled then
        do:
            Logger:Debug(substitute('Tracing output config for &1: &2',
                                    string(this-object:TraceConfig:OutputType),
                                    string(this-object:TraceConfig:OutputConfig))).
            assign traceRequest:TraceData:StartedAt = now.
        end.
    end method.

    /** A single request has completed, so stop tracing that request

        @param IHttpRequest The current request
        @param IHttpResponse The current response */
    @since(rel='12.5.0').
    method protected void RequestTraceEnd(input pRequest as IHttpRequest,
                                          input pResponse as IHttpResponse):
        var ITraceableRequest traceReq.
        var integer idx, cnt, loop.

        if not mAllowTracingOnExecute then
            return.

        if type-of(pRequest, IAdaptable) then
            assign traceReq  = cast(cast(pRequest, IAdaptable):GetAdapter(get-class(ITraceableRequest)), ITraceableRequest).
        else
        if type-of(pRequest, ITraceableRequest) then
            assign traceReq = cast(pRequest, ITraceableRequest).

        if not valid-object(traceReq)
        or not traceReq:TracingEnabled
        then
            return.

        // is there a response filter?
        assign cnt = extent(this-object:TraceConfig:FilterRules).
        do loop = 1 to cnt
        on error undo, throw:
            if valid-object(this-object:TraceConfig:FilterRules[loop])
            // don't run against the request rules
            and this-object:TraceConfig:FilterRules[loop]:MessageType:IsFlagSet(MessageTypeEnum:Response)
            and not this-object:TraceConfig:FilterRules[loop]:ApplyPolicy(pResponse)
            then
            do:
                Logger:Debug(substitute('Tracing filter rule &1 returned FALSE for request to &2 &3; response status &4',
                                        this-object:TraceConfig:FilterRules[loop]:GetClass():TypeName,
                                        pRequest:Method,
                                        pRequest:URI:BaseUri + pRequest:URI:Path,
                                        pResponse:StatusCode)).

                // we filter out this request/response
                return.
            end.
            // Assume that any errors from a filter rule mean that we don't trace
            catch uncaught as Progress.Lang.Error :
                return.
            end catch.
        end.

        // now we can do something with the trace
        assign idx = extent(this-object:TraceData).
        if idx eq ? then
            assign idx = 1.
        else
            assign idx += 1.

        assign extent(this-object:TraceData) = idx
               this-object:TraceData[idx]    = traceReq:TraceData
               .
    end method.

    /** Initialise the tracing functionality. This method determines whether tracing is "allowed", by checking
        the ClientOptions' AllowTracing property and/or the client request (which may be decorated with the ITraceableRequest
        interface). If the request is a traceable request, then the value of its TracingEnabled flag is used to determine
        whether tracing is allowed for this request. If not, then the value of the Options' AllowTracing flag is used.

        This method should be called before any processing/handling of the request is done, since the RequestTraceStart method
        may decorate the request with the ITraceableRequest interface (in the case that tracing was enabled for the client).

        @param IHttpRequest The 'initial' request (aka the request passed into Execute() */
    @since(rel='12.5.0').
    method protected void RequestTraceInit(input pRequest as IHttpRequest):
        var ITraceableRequest traceRequest.

        Assert:NotNull(pRequest, 'Request').

        /* Has this request been turned into a traceable request? */
        if type-of(pRequest, IAdaptable) then
            assign traceRequest = cast(cast(pRequest, IAdaptable):GetAdapter(get-class(ITraceableRequest)), ITraceableRequest).
        else
        if type-of(pRequest, ITraceableRequest) then
            assign traceRequest = cast(pRequest, ITraceableRequest).

        // An individual request may have tracing enabled or disabled. This overrides any setting done at the ClientRequest.
        if valid-object(traceRequest) then
            assign mAllowTracingOnExecute = traceRequest:TracingEnabled.
        else
        // if the request is not a traceable request, use the Options to dis/allow
            assign mAllowTracingOnExecute = this-object:Options:AllowTracing.

        // Obtain the HttpClient Tracing configuration, returned as a TraceConf ig object.
        if mAllowTracingOnExecute then
        do:
            if not valid-object(this-object:Options:TraceConfig) then
                assign this-object:TraceConfig = TraceConfigLoader:LoadRules().
            else
            if type-of(this-object:Options:TraceConfig, File) then
                assign this-object:TraceConfig = TraceConfigLoader:LoadRules(cast(this-object:Options:TraceConfig, File):Name).
            else
            if type-of(this-object:Options:TraceConfig, JsonObject) then
                assign this-object:TraceConfig = TraceConfigLoader:LoadRules(cast(this-object:Options:TraceConfig, JsonObject)).
            else
            if type-of(this-object:Options:TraceConfig, TraceConfig) then
                assign this-object:TraceConfig = cast(this-object:Options:TraceConfig, TraceConfig).

            assign // Double check that there's a config available. We expect so, but who knows?
                   mAllowTracingOnExecute  = valid-object(this-object:TraceConfig)
                   .
        end.
    end method.

    /** Executes an HTTP request.

        @param IHttpRequest Request parameters (URL, method, etc)
        @param IHttpResponse Includes status and payload*/
    method public void Execute(input poRequest  as IHttpRequest,
                               input poResponse as IHttpResponse):
        define variable iNumRetries  as integer no-undo.
        define variable rRequestHash as raw extent 2 no-undo.
        define variable oAuthRequest as IAuthenticatedRequest no-undo.

        Assert:NotNull(poRequest,  'Http request').
        Assert:NotNull(poResponse, 'Http response').

        RequestTraceInit(poRequest).

        assign iNumRetries  = 0.
        /* Use looping instead of recursion to avoid deeping the call stack */
        REQ-LOOP:
        repeat:
            // each request, including redirects, needs to check whether it should have tracing enabled
            // it also needs its own TraceData
            RequestTraceStart(input-output poRequest).

            if this-object:Options:NumRetries gt 0 then
            do:
               if iNumRetries eq 0 then
                    Logger:Debug(substitute('Initial request for &2 &3; max retries=&1',
                                      this-object:Options:NumRetries, poRequest:Method, poRequest:URI:ToString())).
                else
                    Logger:Debug(substitute('Retry attempt &1 of &2 for &3 &4',
                                    iNumRetries, this-object:Options:NumRetries, poRequest:Method, poRequest:URI:ToString())).
            end.

            /* Update the request as needed */
            AddUserAgent(poRequest).

            if type-of(poRequest, IAdaptable) then
                assign oAuthRequest = cast(cast(poRequest, IAdaptable):GetAdapter(get-class(IAuthenticatedRequest)),
                                           IAuthenticatedRequest).
            else
            if type-of(poRequest, IAuthenticatedRequest) then
                assign oAuthRequest = cast(poRequest, IAuthenticatedRequest).
            else
                assign oAuthRequest = ?.

            if valid-object(oAuthRequest) then
            do:
                Logger:Debug(substitute('Authenticated request: method = &1, challenge = &2',
                                oAuthRequest:AuthenticationMethod, oAuthRequest:AuthenticationChallenge)).
                oAuthRequest:AddAuthentication().
            end.

            assign rRequestHash[2] = rRequestHash[1].

            /* make the request.
               request timeouts must be handled by the client library */
            moWwwLib:Execute(poRequest, poResponse).

            assign rRequestHash[1] = poRequest:ContentMD5.

            /* Check for redirects, auth and friends */
            if ProcessStatusAction(poRequest, poResponse) then
                leave REQ-LOOP.

            if this-object:Options:NumRetries eq 0 then
            do:
                Logger:Info(substitute('Client will not attempt retry of &1 &2 after response status code &3',
                                poRequest:Method, poRequest:URI:ToString(), poResponse:StatusCode)).
                leave REQ-LOOP.
            end.
            else
            if this-object:Options:NumRetries gt 0 then
            do:
                if iNumRetries ge this-object:Options:NumRetries then
                    leave REQ-LOOP.
                if this-object:Options:PauseBetweenRetry gt 0 then
                    pause this-object:Options:PauseBetweenRetry no-message.

                // Reset the response, for the next request, so that we don't have
                // any cruft left in the response (eg a Content-Length header)
                //
                // Only do this if we are retrying; for other cases we want to return
                // the existing response. Don't Destroy()/Initialize() because we need to
                // keep the cookies for this whole 'logical request'
                //
                // On each retry, the transfer encoding should be reset (to none)
                poResponse:ClearHeaders().
                assign poResponse:Entity           = ?
                       poResponse:StatusCode       = 0
                       poResponse:TransferEncoding = string(TransferEncodingEnum:None)
                       .
            end.

            if rRequestHash[1] eq rRequestHash[2] then
                assign iNumRetries = iNumRetries + 1.
            else
                assign iNumRetries = 0.
            finally:
                // on each loop iteration, stash the trace data
                RequestTraceEnd(poRequest, poResponse).
            end finally.
        end.        // REQ-LOOP

        finally:
            // Ensure that an attempt to write available trace data is made, always
            WriteTraceData().
            ClearTraceData().
        end finally.
    end method.

    /** Process the action resulting from the status evaluation

        @param HttpResponse The response in question
        @return logical Returns TRUE if the loop is complete */
    method protected logical ProcessStatusAction(input poRequest  as IHttpRequest,
                                                 input poResponse as IHttpResponse):
        define variable oStatusCodeWriter as IHttpMessageWriter no-undo.
        define variable cookies as Cookie extent no-undo.

        assign oStatusCodeWriter = StatusCodeWriterBuilder:Build(poRequest, poResponse).
        if valid-object(oStatusCodeWriter) then
        do:
            // Copy any cookies from the response into the request. This is typically some
            // form of session cookie (JSESSIONID) or similar
            poResponse:GetCookies(output cookies).
            poRequest:SetCookies(cookies).

            // Now apply the response to the request
            oStatusCodeWriter:Open().
            oStatusCodeWriter:Write(poResponse).
            oStatusCodeWriter:Close().

            /* The writer may have changed the message (auth in particular), so use the
               writer's message in place of the input message. */
            assign poRequest = cast(oStatusCodeWriter:Message, IHttpRequest).

            /* status changes will require a retry */
            return false.
        end.

        /* with no status code processing, all done */
        return true.
    end method.

    /* Initializer/Startup */
    method public void Initialize():
        // no-op; method from interface
    end method.

    /* Destroy/Shutdown/Anti-Initializer */
    method public void Destroy():
        if type-of(moWwwLib, ISupportInitialize) then
            cast(moWwwLib, ISupportInitialize):Destroy().
    end method.

    /** Adds a User-Agent string relevant to this client.

        @param HttpRequest The request to which to add the user-agent string */
    method protected void AddUserAgent(input poRequest as IHttpRequest):
        /* Set the User-Agent string. Will look something like
                OpenEdge-HttpClient/0.7.0 (WIN32/64) OpenEdge/12.7.0.0.1008 */
        poRequest:SetHeader(
            HttpHeaderBuilder:Build('User-Agent':u)
                    :Value(substitute('&1/&2 (&4/&5) OpenEdge/&3':u,
                                this-object:ClientName,
                                this-object:ClientVersion,
                                proversion(1),
                                opsys,
                                process-architecture))
                    :Header).
    end method.

    /** Clear the latest (current) trace data and configuration */
    @since(rel='12.5.0').
    method protected void ClearTraceData():
        assign extent(this-object:TraceData) = ?
               this-object:TraceConfig       = ?
               mAllowTracingOnExecute        = false
               .
    end method.

    /* Writes a set of trace data to using the output target specified by a configuration

       The current trace data and configuration are used */
    @since(rel='12.5.0').
    method protected void WriteTraceData():
        var IOutputConfig cfg.
        var IMemptrHolder formattedData.

        // if tracing is not allowed, or if there's no trace data collected,
        // return
        if not mAllowTracingOnExecute
        or extent(this-object:TraceData) eq ?
        then
            return.

        // Be explicit about what types can be written or what actually has something to write.
        if TraceConfig:OutputType eq OutputTypeEnum:None
        or TraceConfig:OutputType eq OutputTypeEnum:Proxy
        then
            return.

        if type-of(this-object:TraceConfig:OutputConfig, IOutputConfig)
        then
        do:
            // if the formatter or writer is not valid/set up, or formatted data is not
            // valid, errors will be thrown, caught and logged in this method
            assign cfg           = cast(this-object:TraceConfig:OutputConfig, IOutputConfig)
                   formattedData = cfg:Formatter:Format(this-object:TraceData)
                   .
            cfg:Writer:Write(formattedData).
        end.
        else
            Logger:Debug(substitute('Trace data is not written for "&1" traces with config &2',
                                    string(this-object:TraceConfig:OutputType),
                                    string(this-object:TraceConfig:OutputConfig))).

        // Don't stop executing the request if something goes wrong
        catch err as Progress.Lang.Error:
            Logger:Error(substitute('Error writing trace data for "&1" trace with config &2',
                                    string(this-object:TraceConfig:OutputType),
                                    string(this-object:TraceConfig:OutputConfig)),
                         err).
        end catch.
    end method.

    /* Returns an adapter for this client

       @param P.L.Class The type we want to adapt this message to
       @return P.L.Object The adapter. Will typically be of the type specified by the input argument */
    @since(rel='12.5.0').
    method public Progress.Lang.Object GetAdapter(input pAdaptTo as class Progress.Lang.Class):
        Assert:NotNull(pAdaptTo, 'Adapter').

        if this-object:GetClass():IsA(pAdaptTo) then
            return this-object.

        return ?.
    end method.

end class.
