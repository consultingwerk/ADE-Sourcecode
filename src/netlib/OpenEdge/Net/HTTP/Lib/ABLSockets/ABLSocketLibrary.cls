/************************************************
Copyright (c)  2014, 2015 by Progress Software Corporation. All rights reserved.
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
using OpenEdge.Net.HTTP.Filter.Writer.ContentTypeResponseWriterBuilder.
using OpenEdge.Net.HTTP.Filter.Writer.RequestWriterBuilder.
using OpenEdge.Net.HTTP.HttpHeaderBuilder.
using OpenEdge.Net.HTTP.IHttpClientLibrary.
using OpenEdge.Net.HTTP.IHttpMessageWriter.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.ServerConnection.ClientSocket.
using OpenEdge.Net.ServerConnection.ClientSocketConnectionParameters.
using OpenEdge.Net.ServerConnection.SocketReadEventArgs.
using Progress.Lang.AppError.
using Progress.Lang.Object.

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
    
	method public void Initialize():
        moSocketLib:DataReceived:Subscribe(DataReceivedHandler).
    end method.
    
    method public void Destroy():
        moSocketLib:DataReceived:Unsubscribe(DataReceivedHandler).
        
        assign moSocketLib = ?.
    end method.

    /** Event handler for dealing with data received from the ClientSocket
        
        @param ClientSocket The socket object receiving the response 
        @param SocketReadEventArgs Arguments pertaining to the data received */
    method public void DataReceivedHandler(input poSender as ClientSocket,
                                           input poEventArgs as SocketReadEventArgs):
        if session:debug-alert then
        do:
            output to value(session:temp-dir + 'response-data-received.txt':u) append.
            put unformatted                        skip(2) 
                '================================' skip
                'NEW CHUNK (' poEventArgs:Data:Size ')' skip
                '================================' skip.
            output close.
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
        
        if session:debug-alert then
        do:
            copy-lob from oMessageBody:GetBytes():Value 
                     to   file session:temp-dir + 'request-raw.txt':u.

            output to value(session:temp-dir + 'response-data-received.txt':u).
            output close.
        end.
        
        /* Steady! */
        do on stop undo, return error new AppError(substitute('Connection timeout for server &1 on port &2 ',
                                    poRequest:URI:Host,
                                    poRequest:URI:Port), miErrorNo_ConnectionTimeout)
           stop-after iTimeout:
            moSocketConnectionParam:URI = poRequest:URI. 
            moSocketLib:Connect(moSocketConnectionParam).
        end.
        
        /* return a useful error when the server cannot connect */
        if not moSocketLib:Connected then
            return error new AppError(
                                substitute('Connection failure for server &1 on port &2 ',
                                    poRequest:URI:Host,
                                    poRequest:URI:Port),
                                miErrorNo_ConnectionFailure).
        
        /* GO! */
        do on stop undo, return error new AppError(substitute('Request write timeout for server &1 on port &2 ',
                                    poRequest:URI:Host,
                                    poRequest:URI:Port), miErrorNo_RequestWriteTimeout)
           stop-after iTimeout: 
            moSocketLib:WriteData(oMessageBody:GetBytes()).
        end.
        
        /* we can reuse the bytebucket */        
        assign moResponseWriter = new ClientSocketResponseWriter(poResponse, oMessageBody).
        moResponseWriter:Open().
        
        /* the socket object works on callbacks. these will
           populate the HttpResponse object */
        do on stop undo, return error new AppError(substitute('Request read timeout for server &1 on port &2 ',
                                    poRequest:URI:Host,
                                    poRequest:URI:Port), miErrorNo_RequestReadTimeout)
           stop-after iTimeout:
            moSocketLib:WaitForResponse(0).
        end.
        
        moResponseWriter:Close().
        
        /* populate the entity */
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
        define variable oRequestWriter as IHttpMessageWriter no-undo.
        
        assign oRequestWriter = RequestWriterBuilder:Build(poRequest).
        if not valid-object(oRequestWriter) then
            return error new AppError('Unable to buld request for transmission', 0).
        
        oRequestWriter:Open().
        /* writes the message's contents into the message body */
        oRequestWriter:Write(poMessageBody).
        oRequestWriter:Close().        
    end method.
    
    /** Constructs the Entity object for the response, based on the
        ContentType 
        
        @param IHttpResponse The response into which to add the entity representation of the body
        @param ByteBucket The message body in plain-text form */
    method private void ExtractEntity(input poResponse as IHttpResponse,
                                      input poMessageBody as ByteBucket):
        define variable oResponseEntityWriter as IHttpMessageWriter no-undo.
        
        assign oResponseEntityWriter = ContentTypeResponseWriterBuilder:Build(poResponse).
        
        if not valid-object(oResponseEntityWriter) then
            return.
        
        oResponseEntityWriter:Open().
        oResponseEntityWriter:Write(poMessageBody).
        oResponseEntityWriter:Close().
    end method.
    
end class.