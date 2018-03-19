/************************************************
Copyright (c) 2014-2017 by Progress Software Corporation. All rights reserved.
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
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.ISupportLogging.
using OpenEdge.Logging.LogLevelEnum.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Net.HTTP.ClientOptions.
using OpenEdge.Net.HTTP.Filter.Payload.ClientSocketResponseWriter.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using OpenEdge.Net.HTTP.Filter.Writer.EntityWriterBuilder.
using OpenEdge.Net.HTTP.Filter.Writer.RequestWriterBuilder.
using OpenEdge.Net.HTTP.HttpHeaderBuilder.
using OpenEdge.Net.HTTP.HttpRequestError.
using OpenEdge.Net.HTTP.IHttpClientLibrary.
using OpenEdge.Net.HTTP.IHttpMessageWriter.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.ISupportProxy.
using OpenEdge.Net.HTTP.Lib.ABLSockets.ABLSocketLibrary.
using OpenEdge.Net.HTTP.MethodEnum.
using OpenEdge.Net.HTTP.StatusCodeEnum.
using OpenEdge.Net.ServerConnection.ClientSocket.
using OpenEdge.Net.ServerConnection.ClientSocketConnectionParameters.
using OpenEdge.Net.ServerConnection.SocketReadEventArgs.
using Progress.Lang.AppError.
using Progress.Lang.Error.

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
    define private property miErrorNo_RequestTimeout        as integer initial 100 no-undo get.
    define private property miErrorNo_ConnectionTimeout     as integer initial 101 no-undo get.
    define private property miErrorNo_ConnectionFailure     as integer initial 102 no-undo get.
    define private property miErrorNo_RequestWriteTimeout   as integer initial 103 no-undo get.
    define private property miErrorNo_RequestReadTimeout    as integer initial 104 no-undo get.
    define private property miErrorNo_RequestReadTerminated as integer initial 105 no-undo get.
    
    /** (mandatory) A free-text name for this library. Used for the USER-AGENT
        string. */
    define public property LibraryName as character no-undo get. private set.

    /** (mandatory) A free-text semantic version string for this library. Used for the USER-AGENT
        string. */
    define public property LibraryVersion as character no-undo get. private set.

    /** Miscellanous options (like timeouts) for this client. May be used to set underlying timeouts */
    define public property Options as ClientOptions no-undo get. private set.
    
    define private variable moSocketLib as ClientSocket no-undo.
    define private variable moSocketConnectionParam as ClientSocketConnectionParameters no-undo.
    
    /* stateful variables used by the callbacks */
    define private variable moResponseWriter as IHttpMessageWriter no-undo.

    /* used for debug/logging purposes */
    define private variable miChunkNumber as integer no-undo.

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
        
        if Logger:LogLevel ge LogLevelEnum:DEBUG then 
        do:
            assign miChunkNumber = miChunkNumber + 1.
            
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
                
                copy-lob poEventArgs:Data:Value to file cChunkFile append.
            end.
            
            copy-lob poEventArgs:Data:Value to file session:temp-dir + 'response-data-received.txt':u append.
        end.
        
        /* Process the number of bytes read chunk */        
        moResponseWriter:Write(poEventArgs).
    end method.
  
    /** Executes an HTTP request, and returns a response
        
        Timeouts:
        - the connect and write-data calls are controlled by STOP-AFTER
        - the read-data calls (WaitForResponse) are handled by the socket 
        
        @param HttpRequest The request to execute
        @param HttpResponse The response from the server for that request. */    
    method public void Execute(input poRequest as IHttpRequest,
                               input poResponse as IHttpResponse):        
        define variable oMessageBody as ByteBucket no-undo.
        define variable dTimeout as decimal no-undo.
        define variable cUserAgent as character no-undo.
        define variable oProxyRequest as ISupportProxy no-undo.
        
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
        poRequest:SetHeader(
            HttpHeaderBuilder:Build('User-Agent':u):Value(cUserAgent):Header).
        
        /* Ready! */
        /* Construct the complete HTTP request. */
        assign oMessageBody = ByteBucket:Instance().
        ExtractBody(poRequest, oMessageBody).
        
        if Logger:LogLevel ge LogLevelEnum:DEBUG then
        do:
            Logger:Debug(substitute('REQUEST: FILE= &1':u, session:temp-dir + 'request-raw.txt':u)).
            copy-lob from oMessageBody:GetBytes():Value 
                     to   file session:temp-dir + 'request-raw.txt':u.
            
            Logger:Debug(substitute('RESPONSE: FILE= &1':u, session:temp-dir + 'response-data-received.txt':u)).
            assign miChunkNumber = 0.
            output to value(session:temp-dir + 'response-data-received.txt':u).
            output close.
        end.
        
        /* Steady! */
        if type-of(poRequest, IAdaptable) then
            assign oProxyRequest = cast(cast(poRequest, IAdaptable):GetAdapter(get-class(ISupportProxy)), ISupportProxy).
        else
        if type-of(poRequest, ISupportProxy) then
            assign oProxyRequest = cast(poRequest, ISupportProxy).
        
        if valid-object(oProxyRequest) and valid-object(oProxyRequest:ProxyURI) then
            assign moSocketConnectionParam:URI = oProxyRequest:ProxyURI.
        else
            assign moSocketConnectionParam:URI = poRequest:URI.
        
        do on stop undo, return error new AppError(substitute('Connection timeout for server &1 on port &2 ',
                                    moSocketConnectionParam:URI:Host,
                                    moSocketConnectionParam:URI:Port), miErrorNo_ConnectionTimeout)
           stop-after dTimeout:
            moSocketLib:Connect(moSocketConnectionParam).
        end.
        
        /* return a useful error when the server cannot connect */
        if not moSocketLib:Connected then
            return error new AppError(
                                substitute('Connection failure for server &1 on port &2 ',
                                    moSocketConnectionParam:URI:Host,
                                    moSocketConnectionParam:URI:Port),
                                miErrorNo_ConnectionFailure).
        
        /* GO! */
        do on stop undo, return error new AppError(substitute('Request write timeout for server &1 on port &2 ',
                                    moSocketConnectionParam:URI:Host,
                                    moSocketConnectionParam:URI:Port), miErrorNo_RequestWriteTimeout)
           stop-after dTimeout: 
            moSocketLib:WriteData(oMessageBody:GetBytes()).
        end.
        
        /* we can reuse the bytebucket */
        assign moResponseWriter = new ClientSocketResponseWriter(poResponse, oMessageBody).
        moResponseWriter:Open().
        
        /* set the request  for context */
        moResponseWriter:Write(poRequest).
        
        /* the socket object works on callbacks. these will
           populate the HttpResponse object 
           
           Do NOT use the STOP-AFTER modifier; let the socket's wait-for deal
           with its own tiemouts */
        do on error undo, throw :
            /* for cases where we re-use the socket object, we need to handle subscriptions, and not
               as previously in Initialize()/Destroy() */
            moSocketLib:DataReceived:Subscribe(DataReceivedHandler).
            moSocketLib:ReadTimeout:Subscribe(ReadTimeoutHandler).
            moSocketLib:ReadTerminated:Subscribe(ReadTerminatedHandler).
            
            moSocketLib:WaitForResponse(dTimeout).
            
            finally:
                moSocketLib:DataReceived:Unsubscribe(DataReceivedHandler).
                moSocketLib:ReadTimeout:Unsubscribe(ReadTimeoutHandler).
                moSocketLib:ReadTerminated:Unsubscribe(ReadTerminatedHandler).
            end finally.
        end.
        
        moResponseWriter:Close().
        
        // HEAD requests have no bodies, so don't bother
        if poRequest:Method ne MethodEnum:HEAD:ToString() then 
            ExtractEntity(poResponse, oMessageBody).
                        
        finally:
            moResponseWriter = ?.
            if valid-object(moSocketLib) then
                moSocketLib:Disconnect().
        end finally.
    end method.
    
    /** Constructs the message body from the request's Entity object
        
        @param IHttpRequest The request form which to extract the body
        @param ByteBucket The message body in plain-text form */
    method private void ExtractBody(input poRequest as IHttpRequest,
                                    input poMessageBody as ByteBucket):
        define variable oBodyWriter as MessageWriter no-undo.
        
        assign oBodyWriter = RequestWriterBuilder:Build()
                                    :WriteTo(poMessageBody)
                                    :Writer.
        if not valid-object(oBodyWriter) then
            return error new AppError('Unable to build request for transmission', 0).
        
        oBodyWriter:Open().
        /* writes the message's contents into the message body */
        oBodyWriter:Write(poRequest).
        oBodyWriter:Close().
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
            Logger:Error('EXTRACT ENTITY ERROR':u, oError).
            Logger:Error('EXTRACT ENTITY: Response entity contains raw message body':u).
            Logger:Error(substitute('EXTRACT ENTITY: Response Content-Type changed from &1 to application/octet-stream':u, poResponse:ContentType)).
            
            assign poResponse:Entity        = poMessageBody:GetBytes()
                   poResponse:ContentType   = 'application/octet-stream':u
                   poResponse:ContentLength = poMessageBody:Size.
        end catch.
    end method.
    
end class.
