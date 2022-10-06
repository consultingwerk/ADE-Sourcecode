/************************************************
Copyright (c) 2014-2019, 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : ABLSocketLibrary
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : Mon Jan 20 09:46:05 EST 2014
    Notes       :
----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.IAdaptable.
using OpenEdge.Core.StringConstant.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.ISupportLogging.
using OpenEdge.Logging.LogLevelEnum.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Net.HTTP.ClientOptions.
using OpenEdge.Net.HTTP.Filter.Payload.ClientSocketResponseWriter.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using OpenEdge.Net.HTTP.Filter.Payload.RawMessage.
using OpenEdge.Net.HTTP.Filter.Writer.EntityWriterBuilder.
using OpenEdge.Net.HTTP.Filter.Writer.RequestWriterBuilder.
using OpenEdge.Net.HTTP.HttpHeaderBuilder.
using OpenEdge.Net.HTTP.HttpRequestError.
using OpenEdge.Net.HTTP.IHttpClientLibrary.
using OpenEdge.Net.HTTP.IHttpMessageWriter.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.ISecureConnectionAuthenticatedRequest.
using OpenEdge.Net.HTTP.ISupportProxy.
using OpenEdge.Net.HTTP.ITraceableRequest.
using OpenEdge.Net.HTTP.MethodEnum.
using OpenEdge.Net.HTTP.RequestBuilder.
using OpenEdge.Net.HTTP.ResponseBuilder.
using OpenEdge.Net.HTTP.StatusCodeEnum.
using OpenEdge.Net.ServerConnection.ClientSocket.
using OpenEdge.Net.ServerConnection.ClientSocketConnectionParameters.
using OpenEdge.Net.ServerConnection.SocketReadEventArgs.
using OpenEdge.Net.URI.
using OpenEdge.Net.UriSchemeEnum.
using OpenEdge.Security.ICredentials.
using Progress.Lang.AppError.
using Progress.Lang.Error.
using OpenEdge.Net.HTTP.Lib.ABLSockets.ABLSocketLibrary.

class OpenEdge.Net.HTTP.Lib.ABLSockets.ABLSocketLibrary
        implements IHttpClientLibrary, ISupportLogging:
    
    // A reference to the Logger in use by an implementer
    define public property Logger as ILogWriter no-undo
        get():
            if not valid-object(this-object:Logger) then
                assign this-object:Logger = LoggerBuilder:GetLogger(get-class(ABLSocketLibrary)).
            return this-object:Logger.
        end get.
        set.
    
    /* Error numbers for errors returned in this class. Private since this class
       alone will use them and read only to avoid anyone messing with them.
       A property to prevent changes. */
    {&_proparse_ prolint-nowarn(varusage)}
    define private property miErrorNo_RequestTimeout        as integer initial 100 no-undo get.
    define private property miErrorNo_ConnectionTimeout     as integer initial 101 no-undo get.
    define private property miErrorNo_ConnectionFailure     as integer initial 102 no-undo get.
    define private property miErrorNo_RequestWriteTimeout   as integer initial 103 no-undo get.
    {&_proparse_ prolint-nowarn(varusage)}
    define private property miErrorNo_RequestReadTimeout    as integer initial 104 no-undo get.
    define private property miErrorNo_RequestReadTerminated as integer initial 105 no-undo get.
    define private property miErrorNo_BadRequest            as integer initial 106 no-undo get.
    define private property miErrorNo_MissingTlsCredentials as integer initial 107 no-undo get.
    
    /** (mandatory) A free-text name for this library. Used for the USER-AGENT
        string. */
    define public property LibraryName as character no-undo get. private set.
    
    /** (mandatory) A free-text semantic version string for this library. Used for the USER-AGENT
        string. */
    define public property LibraryVersion as character no-undo get. private set.
    
    /** Miscellanous options (like timeouts) for this client. May be used to set underlying timeouts */
    define public property Options as ClientOptions no-undo get. private set.
    
    /** The physical socket used to connect to the server */
    define private variable moSocketLib as ClientSocket no-undo.
    
    /** Parameters for the connection */
    define private variable moSocketConnectionParam as ClientSocketConnectionParameters no-undo.
    
    /* stateful variables used by the callbacks */
    define private variable moResponseWriter as IHttpMessageWriter no-undo.

    /* used for debug/logging purposes */
    define private variable miChunkNumber as integer no-undo.
    
    /* instance variable to let socket callbacks know whether to log certain info or not */
    define private variable mTracingRequest as logical no-undo.

    /** Constructor.
        
        @param character This library's name
        @param character This library's version (semver)
        @param ClientSocket The socket used to execute the request
        @param ClientSocketConnectionParameters Connection information for the server used */
    constructor public ABLSocketLibrary(input pcLibraryName as character,
                                        input pcLibraryVersion as character,
                                        input poSocket as ClientSocket,
                                        input poSocketConnectionParams as ClientSocketConnectionParameters):
        this-object(pcLibraryName,
                    pcLibraryVersion,
                    poSocket,
                    poSocketConnectionParams,
                    new ClientOptions()).
    end constructor.
    
    /** Constructor.
        
        @param character This library's name
        @param character This library's version (semver)
        @param ClientSocket The socket used to execute the request
        @param ClientSocketConnectionParameters Connection information for the server used
        @param ClientOptions Options    */
    constructor public ABLSocketLibrary(input pcLibraryName as character,
                                        input pcLibraryVersion as character,
                                        input poSocket as ClientSocket,
                                        input poSocketConnectionParams as ClientSocketConnectionParameters,
                                        input poOptions as ClientOptions):
        Assert:NotNull(poSocket, 'Client socket').
        Assert:NotNull(poSocketConnectionParams, 'Default connection parameters').
        Assert:NotNullOrEmpty(pcLibraryName, 'Library Name').
        Assert:NotNullOrEmpty(pcLibraryVersion, 'Library Version').
        Assert:NotNull(poOptions, 'Client options').
        
        assign this-object:LibraryName    = pcLibraryName
               this-object:LibraryVersion = pcLibraryVersion
               this-object:Options        = poOptions
               
               moSocketLib             = poSocket
               moSocketConnectionParam = poSocketConnectionParams
               .
    end constructor.
    
    destructor public ABLSocketLibrary():
        assign moSocketLib = ?
               moSocketConnectionParam = ?.
    end destructor.
    
    /** Event handler for dealing with read timeouts received from the ClientSocket
        
        @param ClientSocket The socket object receiving the response
        @param SocketReadEventArgs Arguments pertaining to the data received */
    method public void ReadTimeoutHandler(input poSender as ClientSocket,
                                          input poEventArgs as SocketReadEventArgs):
        return error new HttpRequestError(string(integer(StatusCodeEnum:RequestTimeOut)),
                                          'read':u,
                                          moSocketConnectionParam:URI:ToString()).
    end method.
    
    /** Event handler for dealing with ReadTerminated events received from the ClientSocket
        
        @param ClientSocket The socket object receiving the response
        @param SocketReadEventArgs Arguments pertaining to the data received */
    method public void ReadTerminatedHandler(input poSender as ClientSocket,
                                             input poEventArgs as SocketReadEventArgs):
        return error new AppError('Read terminated for ' + moSocketConnectionParam:URI:ToString(),
                                  miErrorNo_RequestReadTerminated).
    end method.
    
    /** Event handler for dealing with data received from the ClientSocket
        
        @param ClientSocket The socket object receiving the response
        @param SocketReadEventArgs Arguments pertaining to the data received */
    method public void DataReceivedHandler(input poSender as ClientSocket,
                                           input poEventArgs as SocketReadEventArgs):
        define variable cChunkFile as character no-undo.
        define variable writeBytes as int64 no-undo.
        
        if not mTracingRequest
        and Logger:LogLevel ge LogLevelEnum:DEBUG
        then
        do:
            assign miChunkNumber = miChunkNumber + 1
                   // we don't want to write less than 0 or more than the total bytes in the Data member
                   writeBytes    = min(max(0, poEventArgs:BytesRead), poEventArgs:Data:Size)
                   .
            Logger:Debug(substitute('CHUNK: NUM= &1':u, miChunkNumber)).
            Logger:Debug(substitute('CHUNK: SIZE(b)= &1':u, poEventArgs:Data:Size)).
            Logger:Debug(substitute('CHUNK: READ(b)= &1':u, poEventArgs:BytesRead)).
            
            if logger:LogLevel ge LogLevelEnum:TRACE then
            do:
                assign cChunkFile = session:temp-dir + substitute('response-data-chunk-&1.txt':u, string(miChunkNumber, '99999':u)).
                Logger:Trace(substitute('CHUNK: FILE= &1':u, cChunkFile)).
                
                output to value(cChunkFile).
                put unformatted
                    '================================':u skip
                    'NEW CHUNK (':u poEventArgs:Data:Size ')':u skip
                    'BYTES READ (':u poEventArgs:BytesRead ')':u skip
                    '================================':u skip.
                output close.
                
                copy-lob from poEventArgs:Data:Value starting at 1 for writeBytes
                         to file cChunkFile
                         append
                         no-convert.
            end.
            
            copy-lob from poEventArgs:Data:Value starting at 1 for writeBytes
                     to file session:temp-dir + 'response-data-received.txt':u
                     append
                     no-convert.
        end.
        
        /* Process the number of bytes read chunk */
        moResponseWriter:Write(poEventArgs).
    end method.
    
    /* Creates an HTTPS tunnel (using CONNECT) for the proxy request
       
       @param IHttpRequest The request to proxy */
    method protected void CreateTunnel(input pProxyReq as ISupportProxy):
        define variable baseRequest as IHttpRequest no-undo.
        define variable connectRequest as IHttpRequest no-undo.
        define variable connectResponse as IHttpResponse no-undo.
        define variable rr as RawMessage no-undo.
        define variable tracingCurrentRequest as logical no-undo.
        
        if type-of(pProxyReq, IAdaptable) then
            assign baseRequest = cast(cast(pProxyReq, IAdaptable):GetAdapter(get-class(IHttpRequest)), IHttpRequest).
        else
        if type-of(pProxyReq, IHttpRequest) then
            assign baseRequest = cast(pProxyReq, IHttpRequest).
        
        Assert:IsType(pProxyReq, get-class(IHttpRequest)).
        
        // only HTTPS servers are proxied.
        if not baseRequest:URI:Scheme    eq string(UriSchemeEnum:https)
        //If the connection to the proxy is HTTPS, then no need for a tunnel
           or  pProxyReq:ProxyURI:Scheme eq string(UriSchemeEnum:https)
        then
            return.
        
        Logger:Debug(substitute('Creating HTTP tunnel via CONNECT to &1', baseRequest:URI:ToString())).
        
        assign connectRequest  = RequestBuilder:Build('CONNECT':u, baseRequest:URI)
                                        :ViaProxy(pProxyReq:ProxyURI)
                                        :AddHeader(baseRequest:GetHeader('User-Agent':u))
                                        :Request
               connectResponse = ResponseBuilder:Build():Response
               .
        if baseRequest:HasHeader('Proxy-Authorization':u) then
            connectRequest:SetHeader(baseRequest:GetHeader('Proxy-Authorization':u)).
        
        /* Construct the complete HTTP request for the CONNECT request */
        assign rr = SerializeRequest(connectRequest)
               tracingCurrentRequest = mTracingRequest
               // do not trace the CONNECT request
               mTracingRequest       = no
               .
        MakeSyncRequest(moSocketLib, connectRequest, connectResponse, rr).
        // reset for the main request
        assign mTracingRequest = tracingCurrentRequest.
        
        // Per https://tools.ietf.org/html/rfc2817 section 5.3, any 2xx status code is good
        if (200 <= connectResponse:StatusCode and connectResponse:StatusCode < 300) then
        do on error undo, throw:
            // On success, we need to tell the socket connection to upgrade to TLS
            moSocketLib:StartTls(baseRequest:URI:Host).
        
            catch sockErr as Progress.Lang.Error:
                Logger:Error(substitute('Unable to create HTTP tunnel to &1', baseRequest:URI:ToString()),
                             sockErr).
                undo, throw sockErr.
            end catch.
        end.
        else
            return error new AppError(
                                substitute('Connection failure for proxy server &1 on port &2',
                                    moSocketConnectionParam:URI:Host,
                                    moSocketConnectionParam:URI:Port),
                                miErrorNo_ConnectionFailure).
    end method.
    
    /* Executes a synchronous request against the currently-connected server.
       
       DO NOT USE this method - use the version that takes a RawMessage parameter
       for the raw request. This method will be relatively slow.
       
       This method SHOULD NOT perform Connect() and Disconnect() operations.
       
       @param ClientSocket The server/socket on which to make the request
       @param HttpRequest The request to execute
       @param HttpResponse The response from the server for that request
       @param ByteBucket The formatted bytes representing the request */
    @deprecated(since='12.5.0').
    method protected void MakeSyncRequest(input pServer as ClientSocket,
                                          input pRequest as IHttpRequest,
                                          input pResponse as IHttpResponse,
                                          input pRequestBody as ByteBucket):
        var RawMessage rr = new RawMessage().
        var integer pos, startAt.
        
        Logger:Warn('MakeSyncRequest(ClientSocket,IHttpRequest,IHttpResponse,ByteBucket) is being deprecated from OpenEdge release 12.5.0. Please refactor.').
                
        // request line
        pos = pRequestBody:IndexOf(StringConstant:CRLF).
        if pos gt 0 then
            rr:StartLine:PutBytes(pRequestBody:GetBytes(1, pos + 1)).
        
        // headers
        assign startAt = pos + 2   // LF + next
               pos     = pRequestBody:IndexOf(StringConstant:CRLF + StringConstant:CRLF, startAt)
               .
        if pos gt 0 then
            rr:Headers:PutBytes(pRequestBody:GetBytes(startAt, pos + 3 - startAt + 1)).
        
        // body
        assign startAt = pos + 4.
        if startAt lt pRequestBody:Size then
        do:
            assign rr:Body = ByteBucket:Instance().
            rr:Body:PutBytes(pRequestBody:GetBytes(startAt, pRequestBody:Size - startAt + 1)).
        end.
        MakeSyncRequest(pServer, pRequest, pResponse, rr).
    end method.
    
    /* Executes a synchronous request against the currently-connected server.
       
       This method SHOULD NOT perform Connect() and Disconnect() operations.
       
       @param ClientSocket The server/socket on which to make the request
       @param HttpRequest The request to execute
       @param HttpResponse The response from the server for that request
       @param RawMessage The formatted bytes representing the request */
    @since(rel='12.5.0').
    method protected void MakeSyncRequest(input pServer as ClientSocket,
                                          input pRequest as IHttpRequest,
                                          input pResponse as IHttpResponse,
                                          input pRawRequest as RawMessage):
        define variable dTimeout as decimal no-undo.
        define variable traceRequest as ITraceableRequest no-undo.
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        define variable timer as datetime-tz extent 2 no-undo.
        define variable responseBody as ByteBucket no-undo.
        define variable requestEntity as Progress.Lang.Object no-undo.
        
        Assert:NotNull(pServer, 'Server connection').
        Assert:NotNull(pRequest, 'HTTP request').
        Assert:NotNull(pResponse, 'HTTP response').
        
        // return a useful error when the server is not connect. This method is NOT responsible for making connections
        if not pServer:Connected then
            return error new AppError(substitute('Connection failure for server &1 on port &2 ',
                                            moSocketConnectionParam:URI:Host,
                                            moSocketConnectionParam:URI:Port),
                                      miErrorNo_ConnectionFailure).
        
        // assign data to the trace.
        if mTracingRequest then
        do on error undo, throw:
            // given that mTracingRequest is true, these should not fail
            if type-of(pRequest, IAdaptable) then
                assign traceRequest = cast(cast(pRequest, IAdaptable):GetAdapter(get-class(ITraceableRequest)), ITraceableRequest).
            else
            if type-of(pRequest, ITraceableRequest) then
                assign traceRequest = cast(pRequest, ITraceableRequest).
            
            assign cnt = extent(traceRequest:RequestRules)
                   requestEntity   = pRequest:Entity
                   pRequest:Entity = pRawRequest:Body
                   .
            // apply all of the REQUEST rules
            do loop = 1 to cnt
            on error undo, throw:
                if valid-object(traceRequest:RequestRules[loop]) then
                    traceRequest:RequestRules[loop]:ApplyPolicy(pRequest, traceRequest:TraceData).
                
                catch err as Progress.Lang.Error:
                    Logger:Error(substitute('Error applying policy with request tracing rule &1':u, traceRequest:RequestRules[loop]:GetClass():TypeName), err).
                end catch.
            end.
            finally:
                // reset the request's entity
                assign pRequest:Entity = requestEntity.
            end finally.
        end.
        else
        if Logger:LogLevel ge LogLevelEnum:DEBUG then
        do:
            Logger:Debug(substitute('REQUEST: FILE= &1':u, session:temp-dir + 'request-raw.txt':u)).
            
            copy-lob from pRawRequest:StartLine:Value
                     to   file session:temp-dir + 'request-raw.txt':u.
            
            copy-lob from pRawRequest:Headers:Value
                     to   file session:temp-dir + 'request-raw.txt':u
                     append.
            
            if valid-object(pRawRequest:Body) then
                copy-lob from pRawRequest:Body:Value
                         to   file session:temp-dir + 'request-raw.txt':u
                         append.
            
            Logger:Debug(substitute('RESPONSE: FILE= &1':u, session:temp-dir + 'response-data-received.txt':u)).
            assign miChunkNumber = 0.
            output to value(session:temp-dir + 'response-data-received.txt':u).
            output close.
        end.
        
        /* GO! */
        assign dTimeout = this-object:Options:RequestTimeout
               timer[1] = now
               .
        do on stop undo, return error new AppError(substitute('Request write timeout for server &1 on port &2 ',
                                                        moSocketConnectionParam:URI:Host,
                                                        moSocketConnectionParam:URI:Port), miErrorNo_RequestWriteTimeout)
           stop-after dTimeout:
            pServer:WriteData(pRawRequest:StartLine).
            pServer:WriteData(pRawRequest:Headers).
            if valid-object(pRawRequest:Body) then
                pServer:WriteData(pRawRequest:Body).
        end.
        
        assign timer[2] = now.
        if mTracingRequest then
            assign traceRequest:TraceData:TimeSend = interval(timer[2], timer[1], 'milliseconds':u).
        
        assign responseBody     = ByteBucket:Instance()
               moResponseWriter = new ClientSocketResponseWriter(pResponse, responseBody)
               .
        moResponseWriter:Open().
        
        /* set the request  for context */
        moResponseWriter:Write(pRequest).
        
        /* the socket object works on callbacks. these will
           populate the HttpResponse object
           
           Do NOT use the STOP-AFTER modifier; let the socket's wait-for deal
           with its own timeouts */
        assign timer[1] = now.
        do on error undo, throw
           on stop  undo, retry:  // trap stop and/or timeout conditions
            
            if retry then // STOP
                undo, throw new AppError(substitute('Stop condition raised while waiting for response from server &1 on port &2 ',
                                                    moSocketConnectionParam:URI:Host,
                                                    moSocketConnectionParam:URI:Port),
                                                    miErrorNo_RequestReadTerminated).
            
            /* for cases where we re-use the socket object, we need to handle subscriptions, and not
               as previously in Initialize()/Destroy() */
            pServer:DataReceived:Subscribe(DataReceivedHandler).
            pServer:ReadTimeout:Subscribe(ReadTimeoutHandler).
            pServer:ReadTerminated:Subscribe(ReadTerminatedHandler).
            
            pServer:WaitForResponse(dTimeout).
            
            finally:
                pServer:DataReceived:Unsubscribe(DataReceivedHandler).
                pServer:ReadTimeout:Unsubscribe(ReadTimeoutHandler).
                pServer:ReadTerminated:Unsubscribe(ReadTerminatedHandler).
            end finally.
        end.
        
        moResponseWriter:Close().

        assign timer[2] = now.
        // Add the message body here because we have it all of its raw/bytes glory.
        if mTracingRequest then
        do on error undo, throw:
            assign traceRequest:TraceData:TimeReceived = interval(timer[2], timer[1], 'milliseconds':u)
                   pResponse:Entity                    = responseBody
                   cnt = extent(traceRequest:ResponseRules)
                   .
            traceRequest:TraceData:SetResponseInfo(pResponse).
            // apply all of the RESPONSE rules
            do loop = 1 to cnt
            on error undo, throw:
                if valid-object(traceRequest:ResponseRules[loop]) then
                    traceRequest:ResponseRules[loop]:ApplyPolicy(pResponse, traceRequest:TraceData).
                     
                catch err as Progress.Lang.Error:
                    Logger:Error(substitute('Error applying policy with response tracing rule &1':u, traceRequest:ResponseRules[loop]:GetClass():TypeName), err).
                end catch.
            end.
            
            finally:
                // it hasn't been set yet
                assign pRequest:Entity = ?.
            end finally.
        end.

        // HEAD requests have no bodies, so don't bother
        if pRequest:Method ne MethodEnum:HEAD:ToString() then
            ExtractEntity(pResponse, responseBody).
        
        finally:
            assign moResponseWriter = ?.
        end finally.
    end method.
    
    /** Executes an HTTP request, and returns a response
        
        Timeouts:
        - the connect and write-data calls are controlled by STOP-AFTER
        - the read-data calls (WaitForResponse) are handled by the socket
        
        @param HttpRequest The request to execute
        @param HttpResponse The response from the server for that request. */
    method public void Execute(input poRequest as IHttpRequest,
                               input poResponse as IHttpResponse):
        define variable dTimeout as decimal no-undo.
        define variable cUserAgent as character no-undo.
        define variable oProxyRequest as ISupportProxy no-undo.
        define variable proxyURI as URI no-undo.
        define variable scar as ISecureConnectionAuthenticatedRequest no-undo.
        define variable creds as ICredentials no-undo.
        define variable traceRequest as ITraceableRequest no-undo.
        define variable timer as datetime extent 2 no-undo.
        define variable rawRequest as RawMessage no-undo.
        
        Assert:NotNull(poRequest,  'Http request').
        Assert:NotNull(poResponse, 'Http response').
        
        assign dTimeout = this-object:Options:RequestTimeout.
        Logger:Info(substitute('REQUEST: TIMEOUT(s)=&1':u, dTimeout)).
        
        /* Set the User-Agent string. Will look something like
                OpenEdge-HttpClient/0.2.0 (WIN32/64) OpenEdge/11.5.0.0.1108 Lib-ABLSockets/0.2.0
         */
        if poRequest:HasHeader('User-Agent':u) then
            assign cUserAgent = poRequest:GetHeader('User-Agent':u):Value.
        
        assign cUserAgent = substitute('&1 &2/&3':u,
                                cUserAgent,
                                this-object:LibraryName,
                                this-object:LibraryVersion).
        poRequest:SetHeader(HttpHeaderBuilder:Build('User-Agent':u):Value(cUserAgent):Header).
        
        // are we tracing this request?
        if type-of(poRequest, IAdaptable) then
            assign traceRequest = cast(cast(poRequest, IAdaptable):GetAdapter(get-class(ITraceableRequest)), ITraceableRequest).
        else
        if type-of(poRequest, ITraceableRequest) then
            assign traceRequest = cast(poRequest, ITraceableRequest).
        
        /* Ready! */
        if type-of(poRequest, IAdaptable) then
            assign oProxyRequest = cast(cast(poRequest, IAdaptable):GetAdapter(get-class(ISupportProxy)), ISupportProxy).
        else
        if type-of(poRequest, ISupportProxy) then
            assign oProxyRequest = cast(poRequest, ISupportProxy).
        
        if     valid-object(oProxyRequest)
           and valid-object(oProxyRequest:ProxyURI)
        then
            assign moSocketConnectionParam:URI = oProxyRequest:ProxyURI.
        else
            assign moSocketConnectionParam:URI = poRequest:URI.
        
        // Check for client credentials
        if type-of(poRequest, IAdaptable) then
            assign scar = cast(cast(poRequest, IAdaptable):GetAdapter(get-class(ISecureConnectionAuthenticatedRequest)),
                               ISecureConnectionAuthenticatedRequest).
        else
        if type-of(poRequest, ISecureConnectionAuthenticatedRequest) then
            assign scar = cast(poRequest, ISecureConnectionAuthenticatedRequest).
        
        // If the request implements ISecureConnectionAuthenticatedRequest and no credentials are available,
        // an AppError must be thrown.
        if valid-object(scar) then
        do:
            assign creds = scar:GetCredentials(moSocketConnectionParam).
            if not valid-object(creds) then
                undo, throw new AppError(substitute('Credentials not provided for server &1 on port &2 ',
                                                     moSocketConnectionParam:URI:Host,
                                                     moSocketConnectionParam:URI:Port),
                                         miErrorNo_MissingTlsCredentials).
            
            assign moSocketConnectionParam:ClientCredentials = creds.
            
            // Ensure that SSL sessions are *not* reused.
            // This works around https://progresssoftware.atlassian.net/browse/OCTA-34701
            if moSocketConnectionParam:ReuseSession then
            do:
                Logger:Warn(substitute('ReuseSession is TRUE for the connection to &1:&2. Setting to FALSE For TLS client authentication to avoid accidental credential reuse',
                                        moSocketConnectionParam:URI:Host,
                                        moSocketConnectionParam:URI:Port)).
                
                // Force the socket to never reuse SSL sessions because each connection must have its own creds
                assign moSocketConnectionParam:ReuseSession = false.
                
                // If the socket exists, then there has been at least one connection
                // made with it, and so the existing SSL session will be reused. Destroy
                // the server handle to make sure that we don't reuse that session.
                if valid-object(moSocketLib:Server) then
                    moSocketLib:DestroyServer().
            end.
        end.
        
        /* Construct the complete HTTP request. */
        assign rawRequest = SerializeRequest(poRequest).
        
        /* Steady! */
        assign timer[1] = now.
        do on stop undo, return error new AppError(substitute('Connection timeout for server &1 on port &2 ',
                                    moSocketConnectionParam:URI:Host,
                                    moSocketConnectionParam:URI:Port), miErrorNo_ConnectionTimeout)
           stop-after dTimeout:
            
            moSocketLib:Connect(moSocketConnectionParam).
        end.
        assign timer[2]        = now
               mTracingRequest = (valid-object(traceRequest) and traceRequest:TracingEnabled)
               .
        if mTracingRequest then
            assign traceRequest:TraceData:TimeConnect = interval(timer[2], timer[1], 'milliseconds':u)
                   traceRequest:TraceData:ClientHost  = moSocketLib:LocalHost
                   traceRequest:TraceData:ClientPort  = moSocketLib:LocalPort
                   traceRequest:TraceData:ServerHost  = moSocketLib:RemoteHost
                   traceRequest:TraceData:ServerPort  = moSocketLib:RemotePort
                   .
        /* return a useful error when the server cannot connect */
        if not moSocketLib:Connected then
            return error new AppError(
                                substitute('Connection failure for server &1 on port &2 ',
                                    moSocketConnectionParam:URI:Host,
                                    moSocketConnectionParam:URI:Port),
                                miErrorNo_ConnectionFailure).
        
        // for HTTPS servers over a proxy, tunnel
        if     valid-object(oProxyRequest)
           and valid-object(oProxyRequest:ProxyURI)
        then
        do:
            CreateTunnel(oProxyRequest).
            
            // Don't use the proxy URI to build the request for tunnels. The ProxyURI is used to
            // determine some stuff; from here on, we need to treat the request as
            if poRequest:URI:Scheme eq string(UriSchemeEnum:https) then
                assign proxyURI               = oProxyRequest:ProxyURI
                       oProxyRequest:ProxyURI = ?
                       .
        end.
        
        MakeSyncRequest(moSocketLib, poRequest, poResponse, rawRequest).
        
        // Reset the ProxyURI for tunnelled requests
        if valid-object(proxyURI) then
            assign oProxyRequest:ProxyURI = proxyURI.
        
        finally:
            // Only disconnect here because we want to keep the connect open for
            // HTTPS tunnels
            if valid-object(moSocketLib) then
                moSocketLib:Disconnect().
            
            // do not reuse the credentials - each request must provie its own
            if valid-object(moSocketConnectionParam) then
                assign moSocketConnectionParam:ClientCredentials = ?
                       moSocketConnectionParam:URI               = ?
                       .
        end finally.
    end method.
    
    method private RawMessage SerializeRequest(input pRequest as IHttpRequest):
        define variable oBodyWriter as MessageWriter no-undo.
        define variable errMsg as character no-undo.
        
        assign oBodyWriter = RequestWriterBuilder:Build(pRequest):Writer.
        if not valid-object(oBodyWriter) then
        do:
            assign errMsg = substitute('Unable to build request for transmission: no builder available for HTTP Version+Method: "&1+&2" ',
                                       pRequest:Version, pRequest:Method ).
            Logger:Error(errMsg).
            return error new AppError(errMsg, miErrorNo_BadRequest).
        end.
        
        oBodyWriter:Open().
        /* writes the message's contents into the message body */
        oBodyWriter:Write(pRequest).
        oBodyWriter:Close().
        
        if not type-of(oBodyWriter:Entity, RawMessage) then
        do:
            assign errMsg = substitute('Unable to build request for transmission: builder entity type &1 is not &2',
                                       oBodyWriter:Entity:GetClass():TypeName,
                                       get-class(RawMessage):TypeName).
            Logger:Error(errMsg).
            return error new AppError(errMsg, miErrorNo_BadRequest).
        end.
        
        return cast(oBodyWriter:Entity, RawMessage).
    end method.
    
    /** Constructs the Entity object for the response, based on the
        ContentType
        
        @param IHttpResponse The response into which to add the entity representation of the body
        @param ByteBucket The message body in plain-text form */
    method private void ExtractEntity(input poResponse as IHttpResponse,
                                      input poMessageBody as ByteBucket):
        define variable oEntityWriter as MessageWriter no-undo.
        define variable iBytesWritten as int64 no-undo.
        
        case true:
            /* populate the entity if there's content (signalled by content-type) */
            when poResponse:ContentType ne '':u then
            do:
                assign oEntityWriter = EntityWriterBuilder:Build(poResponse):Writer.
                if not valid-object(oEntityWriter) then
                    return.
                
                oEntityWriter:Open().
                assign iBytesWritten = oEntityWriter:Write(poMessageBody).
                oEntityWriter:Close().
                
                if iBytesWritten ne poResponse:ContentLength then
                    Logger:Warn(substitute('EXTRACT ENTITY: WARNING: ContentLength = &1 ; bytes written = &2':u, poResponse:ContentLength, iBytesWritten)).
                
                /* get the nicely-formatted/parsed body and add it to the response */
                assign poResponse:Entity        = oEntityWriter:Entity
                       poResponse:ContentLength = iBytesWritten.
            end.
            
            // Some servers don't play nice and send the Content-Type header
            when poResponse:ContentLength gt 0 or
            when poMessageBody:Size gt 0 then
            do:
                Logger:Warn('EXTRACT ENTITY: No Content-Type header':u).
                Logger:Warn('EXTRACT ENTITY: Response Content-Type set to application/octet-stream':u).
                
                assign poResponse:Entity        = poMessageBody:GetBytes()
                       poResponse:ContentType   = 'application/octet-stream':u
                       poResponse:ContentLength = poMessageBody:Size.
            end.
        end case.
        
        catch oError as Error:
            Logger:Error('EXTRACT ENTITY ERROR: Response entity contains raw message body':u, oError).
            Logger:Error(substitute('EXTRACT ENTITY: Response Content-Type changed from &1 to application/octet-stream':u, poResponse:ContentType)).
            Logger:Info('EXTRACT ENTITY: Original Content-Type stored as a X-Orig-Content-Type header in the response').
            
            // Keep the former/old Content-Type value
            poResponse:SetHeader(HttpHeaderBuilder:Build('X-Orig-Content-Type':u):Value(poResponse:ContentType):Header).
            
            assign poResponse:Entity        = poMessageBody:GetBytes()
                   poResponse:ContentType   = 'application/octet-stream':u
                   poResponse:ContentLength = poMessageBody:Size
                   .
        end catch.
    end method.
    
end class.
