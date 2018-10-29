/************************************************
Copyright (c) 2015-2017 by Progress Software Corporation. All rights reserved.
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
using OpenEdge.Net.HTTP.ClientOptions.
using OpenEdge.Net.HTTP.IHttpClientLibrary.
using OpenEdge.Net.HTTP.Lib.ClientLibraryBuilder.
using OpenEdge.Net.ServerConnection.ClientSocket.
using OpenEdge.Net.ServerConnection.ClientSocketConnectionParameters.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Logging.ISupportLogging.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Net.HTTP.Lib.ABLSockets.ABLSocketLibrary.

class OpenEdge.Net.HTTP.Lib.ABLSockets.ABLSocketLibraryBuilder inherits ClientLibraryBuilder:
    /* constants. private and properties to make immutable */
    define private property LIB_NAME as character init 'Lib-ABLSockets':u no-undo get.
    define private property LIB_VERSION as character init '0.5.0':u no-undo get.
    
    /* A useable, built instance of a IHttpClientLibrary */
    define override public property Library as IHttpClientLibrary no-undo
        get():
            return NewLib().
        end get.
    
    /* Default constructor */
    constructor public ABLSocketLibraryBuilder():
        super().
    end constructor.
    
    /** Creates the ABL socket wrapper/holder class, based on the config */
    method protected ClientSocket CreateClientSocket():
        define variable oSocket as ClientSocket no-undo.
        
        if HasOption(get-class(ClientSocket):TypeName) then
            assign oSocket = cast(GetOptionObjectValue(get-class(ClientSocket):TypeName), ClientSocket).
        else
        do:
            assign oSocket = new ClientSocket().
            if     type-of(oSocket, ISupportLogging) 
               and HasOption(get-class(ILogWriter):TypeName) then
                    assign cast(oSocket, ISupportLogging):Logger = cast(GetOptionObjectValue(get-class(ILogWriter):TypeName), ILogWriter).
            
            /* assume a passed-in object is useable as-is. Only inititialize if new */
            if type-of(oSocket, ISupportInitialize) then
                cast(oSocket, ISupportInitialize):Initialize().
        end.
                            
        return oSocket.
    end method.
    
    /** Builds the connection parameter from the config options.
        
        @return ClientSocketConnectionParameters The complete connection parameters. */
    method protected ClientSocketConnectionParameters BuildSocketConnectionParams ():
        define variable oConnectionParams as ClientSocketConnectionParameters no-undo.
        
        if HasOption(get-class(ClientSocketConnectionParameters):TypeName) then
            assign oConnectionParams = cast(GetOptionObjectValue(get-class(ClientSocketConnectionParameters):TypeName), ClientSocketConnectionParameters).
        else
        do:
            assign oConnectionParams = new ClientSocketConnectionParameters().
            
            /* assume a passed-in object is useable as-is. These options only apply to defaults. */            
            if HasOption(PROP_SSL_HOSTVERIFY) then
                assign oConnectionParams:VerifyHost = GetOptionLogicalValue(PROP_SSL_HOSTVERIFY).
            
            if HasOption(PROP_REUSESESSION) then
                assign oConnectionParams:ReuseSession = GetOptionLogicalValue(PROP_REUSESESSION).
            
            if HasOption(PROP_SSL_PROTOCOLS) then
                assign oConnectionParams:SslProtocols = GetOptionStringArrayValue(PROP_SSL_PROTOCOLS).
            
            if HasOption(PROP_SSL_CIPHERS) then
                assign oConnectionParams:SslCiphers = GetOptionStringArrayValue(PROP_SSL_CIPHERS).
            
            if HasOption(PROP_SERVERNAME) then
                assign oConnectionParams:ServerNameIndicator = GetOptionStringValue(PROP_SERVERNAME).
            
            // Finally, initialise the parmas if needed
            if type-of(oConnectionParams, ISupportInitialize) then
                cast(oConnectionParams, ISupportInitialize):Initialize().
        end.
        
        return oConnectionParams.
    end method.
    
    /** helper method to do the actual build  */ 
    method private IHttpClientLibrary NewLib():
        define variable oLibrary as IHttpClientLibrary no-undo.
        define variable oLibType as Progress.Lang.Class no-undo.
        define variable oSocket as ClientSocket no-undo.
        define variable oParams as ClientSocketConnectionParameters no-undo.
        define variable oOptions as ClientOptions no-undo.
        
        assign oLibType = ClientLibraryBuilder:Registry:Get(get-class(IHttpClientLibrary):TypeName).
        /* We know the signature to the default library's constructor - make sure that the type we
           get is of that type */
        Assert:IsType(oLibType, get-class(OpenEdge.Net.HTTP.Lib.ABLSockets.ABLSocketLibrary)).
        
        assign oSocket = CreateClientSocket()
               oParams = BuildSocketConnectionParams()
               oOptions = new ClientOptions() 
               .
        /* SET OPTIONS */
        if HasOption('requestTimeout':u) then
            oOptions:RequestTimeout = GetOptionNumericValue('requestTimeout':u).
        
        oLibrary = dynamic-new string(oLibType:TypeName) (this-object:LIB_NAME,
                                                          this-object:LIB_VERSION,
                                                          oSocket,
                                                          oParams,
                                                          oOptions  ).
        // Add logging
        if     type-of(oLibrary, ISupportLogging) 
           and HasOption(get-class(ILogWriter):TypeName) then
                assign cast(oLibrary, ISupportLogging):Logger = cast(GetOptionObjectValue(get-class(ILogWriter):TypeName), ILogWriter).
        
        if type-of(oLibrary, ISupportInitialize) then
            cast(oLibrary, ISupportInitialize):Initialize().
        
        return oLibrary.
    end method.
    
end class.