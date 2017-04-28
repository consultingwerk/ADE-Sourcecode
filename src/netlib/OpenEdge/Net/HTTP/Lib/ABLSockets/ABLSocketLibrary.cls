/************************************************
Copyright (c) 2014-2016 by Progress Software Corporation. All rights reserved.
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
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Net.HTTP.Filter.Payload.ClientSocketResponseWriter.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using OpenEdge.Net.HTTP.Filter.Writer.EntityWriterBuilder.
using OpenEdge.Net.HTTP.Filter.Writer.RequestWriterBuilder.
using OpenEdge.Net.HTTP.HttpHeaderBuilder.
using OpenEdge.Net.HTTP.IHttpClientLibrary.
using OpenEdge.Net.HTTP.IHttpMessageWriter.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.ISupportProxy.
using OpenEdge.Net.ServerConnection.ClientSocket.
using OpenEdge.Net.ServerConnection.ClientSocketConnectionParameters.
using OpenEdge.Net.ServerConnection.SocketReadEventArgs.
using Progress.Lang.AppError.
using Progress.Lang.Error.

class OpenEdge.Net.HTTP.Lib.ABLSockets.ABLSocketLibrary 
        implements IHttpClientLibrary, ISupportInitialize:
    
    /* Error numbers for errors returned in this class. Private since this class
       alone will use them and read only to avoid anyone messing with them.
       A property to prevent changes. */
    define private property miErrorNo_RequestTimeout        as integer initial 100 no-undo get.
    define private property miErrorNo_ConnectionTimeout     as integer initial 101 no-undo get.
    define private property miErrorNo_ConnectionFailure     as integer initial 102 no-undo get.
    define private property miErrorNo_RequestWriteTimeout   as integer initial 103 no-undo get.
    define private property miErrorNo_RequestReadTimeout    as integer initial 104 no-undo get.
    
    /** (mandatory) A free-text name for this library. Used for the USER-AGENT
        string. */
    define public property LibraryName as character no-undo get. private set.

    /** (mandatory) A free-text semantic version string for this library. Used for the USER-AGENT
        string. */
    define public property LibraryVersion as character no-undo get. private set.

    define private variable moSocketLib as ClientSocket no-undo.
    define private variable moSocketConnectionParam as ClientSocketConnectionParameters no-undo.
    
    /* stateful variables used by the callbacks */
    define private variable moResponseWriter as IHttpMessageWriter no-undo.

    /* used for debug/logging purposes */
    define private variable miChunkNumber as integer no-undo.

    /** Constructor.
        
        @param character This library's name
        @param character This library's version (semver)
        @param JsonObject  Valid JSON containing config information */
    constructor public ABLSocketLibrary(input pcLibraryName as character,
                                  input pcLibraryVersion as character,
                                  input poSocket as ClientSocket,
                                  input poSocketConnectionParams as ClientSocketConnectionParameters):
        Assert:NotNull(poSocket, 'Client socket').
        Assert:NotNull(poSocketConnectionParams, 'Default connection parameters').
        Assert:NotNullOrEmpty(pcLibraryName, 'Library Name').
        Assert:NotNullOrEmpty(pcLibraryVersion, 'Library Version').
        
        assign this-object:LibraryName = pcLibraryName
               this-object:LibraryVersion = pcLibraryVersion
               moSocketLib = poSocket
               moSocketConnectionParam = poSocketConnectionParams.
    end constructor.
    
    destructor public ABLSocketLibrary():
        Destroy().
        assign moSocketLib = ?
               moSocketConnectionParam = ?.
    end destructor.    
    
	method public void Initialize():
        moSocketLib:DataReceived:Subscribe(DataReceivedHandler).
    end method.
    
    method public void Destroy():
        moSocketLib:DataReceived:Unsubscribe(DataReceivedHandler).
    end method.

    /** Event handler for dealing with data received from the ClientSocket
        
        @param ClientSocket The socket object receiving the response 
        @param SocketReadEventArgs Arguments pertaining to the data received */
    method public void DataReceivedHandler(input poSender as ClientSocket,
                                           input poEventArgs as SocketReadEventArgs):
        define variable cChunkFile as character no-undo.
        
        if log-manager:logging-level ge 5 then
        do:
            assign miChunkNumber = miChunkNumber + 1.
            
            LogMessage(substitute('CHUNK: NUM= &1':u, miChunkNumber), 5).
            LogMessage(substitute('CHUNK: SIZE(b)= &1':u, poEventArgs:Data:Size), 5).
            LogMessage(substitute('CHUNK: READ(b)= &1':u, poEventArgs:BytesRead), 5).
            
            if log-manager:logging-level ge 6 then
            do:
                assign cChunkFile = session:temp-dir + substitute('response-data-chunk-&1.txt':u, string(miChunkNumber, '99999':u)).
                LogMessage(substitute('CHUNK: FILE= &1':u, cChunkFile), 6).
                
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
        
        @param HttpRequest The request to execute
        @param HttpResponse The response from the server for that request. */    
    method public void Execute(input poRequest as IHttpRequest,
                               input poResponse as IHttpResponse):        
        define variable oMessageBody as ByteBucket no-undo.
        define variable iTimeout as integer no-undo.
        define variable cUserAgent as character no-undo.
        
        Assert:NotNull(poRequest,  'Http request').
        Assert:NotNull(poResponse, 'Http response'). 
        
        assign iTimeout = 0.
        
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
        
        if log-manager:logging-level ge 5 then
        do:
            LogMessage('REQUEST: FILE= ':u + session:temp-dir + 'request-raw.txt':u, 5).
            copy-lob from oMessageBody:GetBytes():Value 
                     to   file session:temp-dir + 'request-raw.txt':u.
            
            LogMessage('RESPONSE: FILE= ':u + session:temp-dir + 'response-data-received.txt':u, 5).
            assign miChunkNumber = 0.
            output to value(session:temp-dir + 'response-data-received.txt':u).
            output close.
        end.
        
        /* Steady! */
        do on stop undo, return error new AppError(substitute('Connection timeout for server &1 on port &2 ',
                                    moSocketConnectionParam:URI:Host,
                                    moSocketConnectionParam:URI:Port), miErrorNo_ConnectionTimeout)
           stop-after iTimeout:
           
           if type-of(poRequest, ISupportProxy) then
                assign moSocketConnectionParam:URI = cast(poRequest, ISupportProxy):ProxyURI.
            else
                assign moSocketConnectionParam:URI = poRequest:URI.
            
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
           stop-after iTimeout: 
            moSocketLib:WriteData(oMessageBody:GetBytes()).
        end.
        
        /* we can reuse the bytebucket */        
        assign moResponseWriter = new ClientSocketResponseWriter(poResponse, oMessageBody).
        moResponseWriter:Open().
        
        /* set the request  for context */
        moResponseWriter:Write(poRequest).
        
        /* the socket object works on callbacks. these will
           populate the HttpResponse object */
        do on stop undo, return error new AppError(substitute('Request read timeout for server &1 on port &2 ',
                                    moSocketConnectionParam:URI:Host,
                                    moSocketConnectionParam:URI:Port), miErrorNo_RequestReadTimeout)
           stop-after iTimeout:
            moSocketLib:WaitForResponse(0).
        end.
        
        moResponseWriter:Close().
        
        /* populate the entity if there's content (signalled by content-type) */
        if poResponse:ContentType ne '':u then
            ExtractEntity(poResponse, oMessageBody).
        
        finally:
            moResponseWriter = ?.
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
        
        assign oEntityWriter = EntityWriterBuilder:Build(poResponse):Writer.
        if not valid-object(oEntityWriter) then
            return.
        
        oEntityWriter:Open().
        assign iBytesWritten = oEntityWriter:Write(poMessageBody).
        oEntityWriter:Close().
        
        if iBytesWritten ne poResponse:ContentLength then
            LogMessage(substitute('EXTRACT ENTITY: WARNING: ContentLength = &1 ; bytes written = &2':u, poResponse:ContentLength, iBytesWritten), 3).
        
        /* get the nicely-formatted/parsed body and add it to the response */
        assign poResponse:Entity        = oEntityWriter:Entity
               poResponse:ContentLength = iBytesWritten.
        
        catch oError as Error:
            LogMessage(substitute('EXTRACT ENTITY: ERROR = &1':u, oError:ToString()), 1).
            LogMessage('EXTRACT ENTITY: Response entity contains raw message body':u, 1).
            
            assign poResponse:Entity        = poMessageBody:GetBytes()
                   poResponse:ContentLength = poMessageBody:Size.
        end catch.
    end method.
    
    /** Logs a message 
        
        @param character The message to log
        @param integer  The level this message should be logged at */
    method private void LogMessage(input pcMessage as character,
                                   input piLogLevel as integer):
        if log-manager:logfile-name eq ? then
            return.
        
        if log-manager:logging-level ge piLogLevel then
            log-manager:write-message(pcMessage, 'HTTPCLIB':u).
    end method.
    
end class.