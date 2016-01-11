/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : ABLSocketLibraryBuilder
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Jan 14 14:01:12 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Net.HTTP.IHttpClientLibrary.
using OpenEdge.Net.HTTP.Lib.ClientLibraryBuilder.
using OpenEdge.Net.ServerConnection.ClientSocket.
using OpenEdge.Net.ServerConnection.ClientSocketConnectionParameters.

class OpenEdge.Net.HTTP.Lib.ABLSockets.ABLSocketLibraryBuilder inherits ClientLibraryBuilder:
    /* constants. private and properties to make immutable */
    define private property LIB_NAME as character init 'Lib-ABLSockets':u no-undo get.
    define private property LIB_VERSION as character init '0.3.0':u no-undo get.
     
    define override public property Library as IHttpClientLibrary no-undo
        get():
            return NewLib().
        end get.

    constructor public ABLSocketLibraryBuilder():
        super().
    end constructor.
    
    /** Creates the ABL socket wrapper/holder class, based on the config */
    method protected ClientSocket CreateClientSocket():
        define variable oSocket as ClientSocket no-undo.
        
        assign oSocket = new ClientSocket().
               
        if HasOption('SO-KEEPALIVE':u) then
            assign oSocket:KeepAlive = GetOptionLogicalValue('SO-KEEPALIVE':u).
        if HasOption('TCP-NODELAY':u) then
            assign oSocket:NoDelay = GetOptionLogicalValue('TCP-NODELAY':u).
        if HasOption('SO-REUSEADDR':u) then
            assign oSocket:ReuseAddress = GetOptionLogicalValue('SO-REUSEADDR':u).
        if HasOption('SO-RCVBUF':u) then
            assign oSocket:ReceiveBufferSize = GetOptionNumericValue('SO-RCVBUF':u).
        if HasOption('SO-SNDBUF':u) then
            assign oSocket:SendBufferSize = GetOptionNumericValue('SO-SNDBUF':u).              
        if HasOption('SO-RCVTIMEO':u) then
            assign oSocket:ReceiveTimeout = GetOptionNumericValue('SO-RCVTIMEO':u).
        if HasOption('SO-LINGER':u) then
            assign oSocket:LingerTime = GetOptionNumericValue('SO-LINGER':u).
        
        return oSocket.
    end method.
    
    /** Builds the connection parameter from the config options.
        
        @return ClientSocketConnectionParameters The complete connection parameters. */
    method protected ClientSocketConnectionParameters BuildSocketConnectionParams ():
        define variable oConnectionParams as ClientSocketConnectionParameters no-undo.
        
        assign oConnectionParams = new ClientSocketConnectionParameters().
        
        if HasOption(PROP_SSL_HOSTVERIFY) then
            oConnectionParams:VerifyHost = not GetOptionLogicalValue(PROP_SSL_HOSTVERIFY).
        
        if HasOption(PROP_SSL_PROTOCOLS) then
            oConnectionParams:SslProtocols = GetOptionStringValue(PROP_SSL_PROTOCOLS).
        
        if HasOption(PROP_SSL_CIPHERS) then
            oConnectionParams:SslCiphers = GetOptionStringValue(PROP_SSL_CIPHERS).
        
        return oConnectionParams.
    end method.
    
    /** helper method to do the actual build  */ 
    method private IHttpClientLibrary NewLib():
        define variable oLibrary as IHttpClientLibrary no-undo.
        define variable oLibType as Progress.Lang.Class no-undo.
        
        assign oLibType = ClientLibraryBuilder:Registry:Get(get-class(IHttpClientLibrary):TypeName).
        /* We know the signature to the default library's constructor - make sure that the type we
           get is of that type */
        Assert:IsType(oLibType, get-class(OpenEdge.Net.HTTP.Lib.ABLSockets.ABLSocketLibrary)).
        
        define variable oSocket as ClientSocket no-undo.
        define variable oParams as ClientSocketConnectionParameters no-undo.
        
        oSocket = CreateClientSocket().
        oParams = BuildSocketConnectionParams().
        
        oLibrary = dynamic-new string(oLibType:TypeName) (this-object:LIB_NAME,
                                                          this-object:LIB_VERSION,
                                                          oSocket,
                                                          oParams ).
        if type-of(oLibrary, ISupportInitialize) then
            cast(oLibrary, ISupportInitialize):Initialize().
        
        return oLibrary.
    end method.
    
end class.