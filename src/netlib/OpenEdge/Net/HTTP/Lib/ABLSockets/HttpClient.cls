/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : HttpClient
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
using OpenEdge.Core.Memptr.
using OpenEdge.Net.HTTP.ClientOptions.
using OpenEdge.Net.HTTP.HttpRequest.
using OpenEdge.Net.HTTP.HttpResponse.
using OpenEdge.Net.HTTP.IHttpClientLibrary.
using OpenEdge.Net.HTTP.ResponseBuilder.
using Progress.Lang.AppError.
using com.dotr.socket.BaseSocket.
using OpenEdge.Net.UriSchemeEnum.

class OpenEdge.Net.HTTP.Lib.ABLSockets.HttpClient implements IHttpClientLibrary:
    /* Error numbers for errors returned in this class. Private since this class
       alone will use them and read only to avoid anyone messing with them. */
    define private property miErrorNo_RequestTimeout        as integer initial 100 no-undo get.
    define private property miErrorNo_ConnectionTimeout     as integer initial 101 no-undo get.
    define private property miErrorNo_ConnectionFailure     as integer initial 102 no-undo get.
    define private property miErrorNo_RequestWriteTimeout   as integer initial 103 no-undo get.
    define private property miErrorNo_RequestReadTimeout    as integer initial 104 no-undo get.
    
    define public property LibraryName as character no-undo get. private set.
    define public property LibraryVersion as character no-undo get. private set.

    /** Miscellanous options (like timeouts) for this library */
    define public property Options as ClientOptions no-undo get. private set.
    
    define private variable moSocketLib as BaseSocket no-undo.
    
    /* stateful variables used by the callbacks */
    define private variable moCurrentResponse as HttpResponse no-undo.
    define private variable moResponseData as ByteBucket no-undo.

    constructor public HttpClient(input pcAppName as character,
                                  input pcAppVersion as character,
                                  input poOptions as ClientOptions):
        super ().
        
        Assert:NotNullOrEmpty(pcAppName, 'Library Name').
        Assert:NotNullOrEmpty(pcAppVersion, 'Library Version').
        Assert:NotNull(poOptions, 'Client Options').
        
        assign this-object:LibraryName = pcAppName
               this-object:LibraryVersion = pcAppVersion
               this-object:Options = poOptions.
	end constructor.
	
	method public void Initialize():
        assign moSocketLib = new BaseSocket()
               moResponseData = ByteBucket:Instance().
        
        moSocketLib:DataReceived:Subscribe(DataReceivedHandler).
        moSocketLib:TimedOut:Subscribe(TimedOutHandler).
    end method.
    
    method public void Destroy():
        moSocketLib:DataReceived:Unsubscribe(DataReceivedHandler).
        moSocketLib:TimedOut:Unsubscribe(TimedOutHandler).
        
        assign moCurrentResponse = ?
               moSocketLib = ?
               moResponseData = ?.
    end method.
    
    method public void TimedOutHandler (input poObject as BaseSocket):
        return error new AppError('Request timed out', miErrorNo_RequestTimeout).
    end method.
    
    method public void DataReceivedHandler(input poObject as BaseSocket, input pmData as memptr):
        if session:debug-alert then
            copy-lob pmData to file session:temp-dir + 'response-raw-whole.txt' append.

        /* Dump the response data into a bucket. We will parse it later. */ 
        moResponseData:PutBytes(get-pointer-value(pmData),
                                get-size(pmData)).
    end method.
    
    method public HttpResponse Execute(input poRequest as HttpRequest):
        define variable iPort as integer no-undo.
        define variable oRequestBody as class Memptr no-undo.
        define variable iTimeout as integer no-undo.
        
        assign iPort    = poRequest:URI:Port
               iTimeout = 0.
        
        /* In this case, there's no port in the URL returned by :URI () */
        if iPort eq ? then
        case poRequest:URI:Scheme:
            when UriSchemeEnum:Http  then assign iPort = 80.
            when UriSchemeEnum:Https then assign iPort = 443.
        end case.
        
        /* construct the complete HTTP request */
        oRequestBody = poRequest:BuildRequest(this-object).
        
        if session:debug-alert then
            copy-lob from oRequestBody:Value 
                     to   file session:temp-dir + 'request-raw.txt'.        

        /* Ready! */
        assign moSocketLib:SSL = poRequest:URI:Scheme:Equals(UriSchemeEnum:Https).
        
        /* Steady! */
        do on stop undo, return error new AppError(substitute('Connection timeout for server &1 on port &2 ',
                                    poRequest:URI:Host,
                                    iPort), miErrorNo_ConnectionTimeout)
           stop-after iTimeout: 
            moSocketLib:Connect(poRequest:URI:Host, iPort).
        end.
        /* return a useful error when the server cannot connect */
        if not moSocketLib:CONNECTED then
            return error new AppError(
                                substitute('Connection failure for server &1 on port &2 ',
                                    poRequest:URI:Host,
                                    iPort),
                                miErrorNo_ConnectionFailure).
        
        /* GO! */
        do on stop undo, return error new AppError(substitute('Request write timeout for server &1 on port &2 ',
                                    poRequest:URI:Host,
                                    iPort), miErrorNo_RequestWriteTimeout)
           stop-after iTimeout: 
            moSocketLib:WriteData(oRequestBody:Value).
        end.
        
        /* the socket object works on callbacks. these will
           populate the HttpResponse object */
        do on stop undo, return error new AppError(substitute('Request read timeout for server &1 on port &2 ',
                                    poRequest:URI:Host,
                                    iPort), miErrorNo_RequestReadTimeout)
           stop-after iTimeout: 
            moSocketLib:WaitForResponse(0).
        end.
        
        moCurrentResponse = ResponseBuilder:Build(poRequest, moResponseData).
        return moCurrentResponse.
        finally:
            moSocketLib:Disconnect().
            moResponseData:Clear().
        end finally.
    end method.
    
end class.