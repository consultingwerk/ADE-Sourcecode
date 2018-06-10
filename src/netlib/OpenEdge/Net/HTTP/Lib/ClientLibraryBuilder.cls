/************************************************
Copyright (c) 2015-2017 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : ClientLibraryBuilder
    Purpose     : Creates/builds instances of OpenEdge.Net.HTTP.IHttpClientLibrary
                  -implementing objects
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Jan 13 13:59:53 EST 2015
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Net.HTTP.BuilderRegistry.
using OpenEdge.Net.HTTP.ConfigBuilder.
using OpenEdge.Net.HTTP.IHttpClientLibrary.
using OpenEdge.Net.HTTP.Lib.ABLSockets.ABLSocketLibrary.
using OpenEdge.Net.HTTP.Lib.ABLSockets.ABLSocketLibraryBuilder.
using OpenEdge.Net.HTTP.Lib.ClientLibraryBuilder.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Lib.ClientLibraryBuilder abstract inherits ConfigBuilder:
    
    /** Registry for the mapping of library types to their builder. */
    define static public property Registry as BuilderRegistry no-undo
        get():
            define variable oRegistry as BuilderRegistry no-undo.
            if not valid-object(ClientLibraryBuilder:Registry) then
            do:
                assign oRegistry = new BuilderRegistry().
                ClientLibraryBuilder:InitializeRegistry(oRegistry).                
                assign ClientLibraryBuilder:Registry = oRegistry.
            end.
            return ClientLibraryBuilder:Registry.
        end get.
        private set.
    
    // 'magic names' for properties
    define protected property PROP_SSL_PROTOCOLS  as character init 'sslprotocols':u no-undo get.
    define protected property PROP_SSL_CIPHERS    as character init 'sslciphers':u   no-undo get.
    define protected property PROP_SSL_HOSTVERIFY as character init 'sslhostverify':u no-undo get.
    define protected property PROP_REUSESESSION   as character init 'reusesession':u no-undo get.
    define protected property PROP_SERVERNAME     as character init 'servername':u no-undo get.
    
    /** Each concrete builder will implement this differently */
    define abstract public property Library as IHttpClientLibrary no-undo get.
    
    /** Adds initial values into the registry 
    
        @param BuilderRegistry The registry to populate */
    method static private void InitializeRegistry(input poRegistry as BuilderRegistry):
        /* default builder */
        poRegistry:Put(get-class(ClientLibraryBuilder):TypeName,
                       get-class(ABLSocketLibraryBuilder)).
        
        /* default library */
        poRegistry:Put(get-class(IHttpClientLibrary):TypeName,
                       get-class(ABLSocketLibrary)).
    end method.
    
    /** Builder director method.
        
        @return ClientBuilder A builder for the requested type */
    method static public ClientLibraryBuilder Build():
        define variable oBuilderType as Progress.Lang.Class no-undo.
        define variable oCLB as ClientLibraryBuilder no-undo.
        
        assign oBuilderType = ClientLibraryBuilder:Registry:Get(get-class(ClientLibraryBuilder):TypeName).
        Assert:IsType(oBuilderType, get-class(ClientLibraryBuilder)).
    
        /* Issue PSC00326382 means that we must use dynamic-new instead of New() */
        oCLB = dynamic-new string(oBuilderType:TypeName) ().
    
        if type-of(oCLB, ISupportInitialize) then
            cast(oCLB, ISupportInitialize):Initialize().
        
        return oCLB.
    end method.
    
    /** Sets the server name indicator for TLS.
        
        @param  character The server name indicator
        @return ClientLibraryBuilder This builder object */
    method public ClientLibraryBuilder ServerNameIndicator(input pServerName as character):
        Assert:NotNullOrEmpty(pServerName, 'Server name').
        
        SetOption(PROP_SERVERNAME, pServerName).
        return this-object.
    end method.
    
    /** Add an array of SSL protocols to the config. Replaces any existing
        protocols. 
     
        @param character[] A non-empty array of protocols.
        @return ClientLibraryBuilder This builder object */
    method public ClientLibraryBuilder SetSslProtocols (input pcProtocols as character extent):
        SetOption(PROP_SSL_PROTOCOLS, new JsonArray(pcProtocols)).
        
        return this-object.
    end method.
    
    /** Adds (appends) a single SSL protocol to the config.
     
        @param character A non-empty protocols.
        @return ClientLibraryBuilder This builder object */
    method public ClientLibraryBuilder AddSslProtocol (input pcProtocol as character):
        define variable oList as JsonArray no-undo.
        
        Assert:NotNullOrEmpty(pcProtocol, 'SSL protocols').
        
        if not HasOption(PROP_SSL_PROTOCOLS) then
            SetOption(PROP_SSL_PROTOCOLS, new JsonArray()).
            
        assign oList = cast(GetOptionObjectValue(PROP_SSL_PROTOCOLS), JsonArray).
        
        oList:Add(pcProtocol).
        
        return this-object.
    end method.
    
    /** Add an array of SSL ciphers to the config. Replaces any existing
        ciphers. 
     
        @param character[] A non-empty array of ciphers.
        @return ClientLibraryBuilder This builder object */
    method public ClientLibraryBuilder SetSslCiphers (input pcCiphers as character extent):
        SetOption(PROP_SSL_CIPHERS, new JsonArray(pcCiphers)).
        
        return this-object.
    end method.
    
    /** Adds (appends) a single SSL cipher to the config.
     
        @param character A non-empty cipher.
        @return ClientLibraryBuilder This builder object */
    method public ClientLibraryBuilder AddSslCipher (input pcCipher as character):
        define variable oList as JsonArray no-undo.
        
        Assert:NotNullOrEmpty(pcCipher, 'SSL cipher').

        if not HasOption(PROP_SSL_CIPHERS) then
            SetOption(PROP_SSL_CIPHERS, new JsonArray()).
            
        assign oList = cast(GetOptionObjectValue(PROP_SSL_CIPHERS), JsonArray).
        
        oList:Add(pcCipher).
        
        return this-object.
    end method.
    
    /** Determines whether the SSL host should be verified
        
        @param logical True if host verification should be enabled
        @return ClientLibraryBuilder This builder object */
    method public ClientLibraryBuilder SslVerifyHost (input plVerify as logical):
        Assert:NotUnknown(plVerify, 'SSL host verification').
        
        SetOption(PROP_SSL_HOSTVERIFY, plVerify).
        
        return this-object.
    end method.
    
    /** Determines whether (SSL) sessions should be reused.
        
        @param logical TRUE if sessions should be reused
        @return ClientLibraryBuilder This builder object */
    method public ClientLibraryBuilder ReuseSession(input pReuse as logical):
        Assert:NotUnknown(pReuse, 'Session reuse flag').
        
        SetOption(PROP_REUSESESSION, pReuse).
        
        return this-object.
    end method.
    
    /** Adds or overwrites an option for the client library.
        
        @param  character The name of the option
        @param  character The value of the option (can be anything)
        @return ClientLibraryBuilder This builder object. */
    method public ClientLibraryBuilder Option(input pcName as character,
                                              input pcValue as character):
        
        Assert:NotNullOrEmpty(pcName, 'Option name').
        SetOption(pcName, pcValue).
        
        return this-object.
    end method.                                                     

    /** Adds or overwrites an option for the client library.
        
        @param  character The name of the option
        @param  Object The value of the option (can be anything)
        @return ClientLibraryBuilder This builder object. */
    method public ClientLibraryBuilder Option(input pcName as character,
                                              input poValue as Object):
        
        Assert:NotNullOrEmpty(pcName, 'Option name').
        SetOption(pcName, poValue).
        
        return this-object.
    end method.                                                     

    /** Adds or overwrites an option for the client library.
        
        @param  character The name of the option
        @param  int64 The value of the option (can be anything)
        @return ClientLibraryBuilder This builder object. */
    method public ClientLibraryBuilder Option(input pcName as character,
                                              input piValue as int64):
        Assert:NotNullOrEmpty(pcName, 'Option name').
        SetOption(pcName, piValue).

        return this-object.
    end method.                                                     

    /** Adds or overwrites an option for the client library.
        
        @param  character The name of the option
        @param  decimal The value of the option (can be anything)
        @return ClientLibraryBuilder This builder object. */
    method public ClientLibraryBuilder Option(input pcName as character,
                                              input pdValue as decimal):
        
        Assert:NotNullOrEmpty(pcName, 'Option name').
        SetOption(pcName, pdValue).
        
        return this-object.
    end method.                                                     

    /** Adds or overwrites an option for the client library.
        
        @param  character The name of the option
        @param  logical The value of the option (can be anything)
        @return ClientLibraryBuilder This builder object. */
    method public ClientLibraryBuilder Option(input pcName as character,
                                              input plValue as logical):
        
        Assert:NotNullOrEmpty(pcName, 'Option name').
        SetOption(pcName, plValue).

        return this-object.
    end method.
    
    /** Sets the value of the RequestTimeout option.
    
        @param Decimal A zero or positive value
        @return ClientLibraryBuilder This builder object. */
    method public ClientLibraryBuilder SetRequestTimeout(input pdValue as decimal):
        Assert:IsZeroOrPositive(pdValue, 'Request Timeout').
        SetOption('requestTimeout':u, pdValue).
        
        return this-object.
    end method.
    
    /** Override the default log writer to be used with this http client
    
        @param ILogWriter The log writer to be used
        @return ClientLibraryBuilder This builder instance */
    method public ClientLibraryBuilder UsingLogger(input poLogger as ILogWriter):
        Assert:NotNull(poLogger, 'Log writer').
        
        SetOption(get-class(ILogWriter):TypeName, poLogger).
        
        return this-object.
    end method.
    
end class.
