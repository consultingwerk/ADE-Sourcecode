/************************************************
Copyright (c) 2015-2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : ClientBuilder
    Purpose     : Allows the construction of a working HttpClient via a fluent
                  interface. 
    Syntax      : ClientBuilder:Build(<type>).
    Description : 
    Author(s)   : pjudge
    Created     : Tue Jan 13 10:52:05 EST 2015
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Net.HTTP.BuilderRegistry.
using OpenEdge.Net.HTTP.ClientBuilder.
using OpenEdge.Net.HTTP.ConfigBuilder.
using OpenEdge.Net.HTTP.CookieJarBuilder.
using OpenEdge.Net.HTTP.DefaultHttpClientBuilder.
using OpenEdge.Net.HTTP.HttpClient.
using OpenEdge.Net.HTTP.HttpClientDecorator.
using OpenEdge.Net.HTTP.ICookieJar.
using OpenEdge.Net.HTTP.IHttpClient.
using OpenEdge.Net.HTTP.IHttpClientLibrary.
using OpenEdge.Net.HTTP.ISupportCookies.
using OpenEdge.Net.HTTP.ISupportProxy.
using OpenEdge.Net.HTTP.Lib.ClientLibraryBuilder.
using OpenEdge.Net.HTTP.ProxyHttpClient.
using OpenEdge.Net.HTTP.StatefulHttpClient.
using OpenEdge.Net.URI.

class OpenEdge.Net.HTTP.ClientBuilder abstract inherits ConfigBuilder:
    
    /** Registry for mapping build types to their implementations */
    define static public property Registry as BuilderRegistry no-undo
        get():
            define variable oRegistry as BuilderRegistry no-undo.
            if not valid-object(ClientBuilder:Registry) then
            do:
                assign oRegistry = new BuilderRegistry().
                ClientBuilder:InitializeRegistry(oRegistry).                
                assign ClientBuilder:Registry = oRegistry.
            end.
            return ClientBuilder:Registry.
        end get.
        private set.
    
    /* constants. protected and properties to make immutable */
    define protected property PROP_CLIENT_NAME as character init 'clientName':u no-undo get.
    define protected property PROP_CLIENT_VERSION as character init 'clientVersion':u no-undo get.
    
    /** Returns a configured client. */
    define abstract property Client as IHttpClient no-undo get.
    
    /** Adds initial values into the registry 
    
        @param BuilderRegistry The registry to populate */
    method static private void InitializeRegistry(input poRegistry as BuilderRegistry):
        /* default builder */
        poRegistry:Put(get-class(ClientBuilder):TypeName,
                       get-class(DefaultHttpClientBuilder)).
        
        /* default client, proxy client and stateful client types */
        poRegistry:Put(get-class(IHttpClient):TypeName,
                       get-class(HttpClient)).
        poRegistry:Put(get-class(ISupportProxy):TypeName,
                       get-class(ProxyHttpClient)).
        poRegistry:Put(get-class(ISupportCookies):TypeName,
                       get-class(StatefulHttpClient)).
                       
    end method.
    
    /** Builder director method.
        
        @return ClientBuilder A builder for the requested type */
    method static public ClientBuilder Build():
        define variable oBuilderType as Progress.Lang.Class no-undo.
        define variable oCB as ClientBuilder no-undo.
        
        assign oBuilderType = ClientBuilder:Registry:Get(get-class(ClientBuilder):TypeName).
        Assert:IsType(oBuilderType, get-class(ClientBuilder)).
        
        /* Issue PSC00326382 means that we must use dynamic-new instead of New() */
        oCB = dynamic-new string(oBuilderType:TypeName) ().        
        
        if type-of(oCB, ISupportInitialize) then
            cast(oCB, ISupportInitialize):Initialize().
        
        return oCB.
    end method.
    
    /** Sets the value of the NumRetries option.
        
        @param integer A zero or positive value
        @return ClientBuilder This builder object. */
    method public ClientBuilder SetNumRetries(input piValue as integer):
        Assert:IsZeroOrPositive(piValue, 'Retry count').
        SetOption('numRetries':u, piValue).
        
        return this-object.
    end method.
            
    /** Sets the value of the PauseBetweenRetry option.
    
        @param Decimal A zero or positive value
        @return ClientBuilder This builder object. */
    method public ClientBuilder SetRetryPause(input pdValue as decimal):
        Assert:IsZeroOrPositive(pdValue, 'Retry pause').
        SetOption('pauseBetweenRetry':u, pdValue).
        
        return this-object.
    end method.

    /** Sets the value of the RequestTimeout option.
    
        @param Decimal A zero or positive value
        @return ClientBuilder This builder object. */
    method public ClientBuilder SetRequestTimeout(input pdValue as decimal):
        Assert:IsZeroOrPositive(pdValue, 'Request Timeout').
        SetOption('requestTimeout':u, pdValue).
        
        return this-object.
    end method.
    
    /** Sets a cookie jar for managing cookies.
        
        @param ICookieJar The cookie jar which manages cookies for this client 
        @return ClientBuilder */
    method public ClientBuilder KeepCookies(input poCookieJar as ICookieJar):
        Assert:NotNull(poCookieJar, 'Cookie jar').
        
        SetOption(get-class(ICookieJar):TypeName, poCookieJar).
        
        return this-object.
    end method.
    
    /** Uses a default cookie for managing cookies.
        
        @return ClientBuilder */
    method public ClientBuilder KeepCookies():
        return this-object:KeepCookies( CookieJarBuilder:Build():CookieJar ).
    end method.
    
    /** Sets the URI to use as a proxy server for all requests
        
        @param URI The proxy server URI
        @return ClientBuilder This builder object. */
    method public ClientBuilder ViaProxy(input poProxyURI as URI):
        Assert:NotNull(poProxyURI, 'Proxy server URI').
        
        SetOption(get-class(ISupportProxy):TypeName, poProxyURI).
        
        return this-object.
    end method.

    /** Sets the URI to use as a proxy server for all requests
        
        @param character The proxy server URI
        @return ClientBuilder This builder object. */
    method public ClientBuilder ViaProxy(input pcProxyURI as character):
        Assert:NotNullOrEmpty(pcProxyURI, 'Proxy server URI').
        
        return ViaProxy(URI:Parse(pcProxyURI)).
    end method.
    
    /** Sets the client name and version
        
        @param character The client name
        @param character The client version (semantic version: major.minor.patch).
        @return ClientBuilder This builder object. */
    method public ClientBuilder Named(input pcName as character,
                                      input pcVersion as character):
        Assert:NotNullOrEmpty(pcName,    'Client name').
        Assert:NotNullOrEmpty(pcVersion, 'Client version').
                                                            
        SetOption(PROP_CLIENT_NAME, pcName).
        SetOption(PROP_CLIENT_VERSION, pcVersion).
        
        return this-object.                                          
    end method.
    
    /** Override the default client library to be used with this http client.
    
        @param IHttpClientLibrary The library to be used
        @return ClientBuilder This builder instance */
    method public ClientBuilder UsingLibrary(input poLibrary as IHttpCLientLibrary):
        Assert:NotNull(poLibrary, 'Http library').
        
        SetOption(get-class(IHttpClientLibrary):TypeName, poLibrary).
        
        return this-object.
    end method.    

    /** Override the default log writer to be used with this http client
    
        @param ILogWriter The log writer to be used
        @return ClientBuilder This builder instance */
    method public ClientBuilder UsingLogger(input poLogger as ILogWriter):
        Assert:NotNull(poLogger, 'Log writer').
        
        SetOption(get-class(ILogWriter):TypeName, poLogger).
        
        return this-object.
    end method.    
    
    /**  Helper method to build a http client library */
    method protected IHttpClientLibrary BuildLibrary():
        define variable oLibBuilder as ClientLibraryBuilder no-undo.
        
        If HasOption(get-class(IHttpClientLibrary):TypeName) then
            return cast(GetOptionObjectValue(get-class(IHttpClientLibrary):TypeName), IHttpClientLibrary).
        else
        do:
            /* Build the client, 'passing down' any default values we have */
            assign oLibBuilder = ClientLibraryBuilder:Build().
            
            if HasOption('requestTimeout':u) then
                oLibBuilder:SetRequestTimeout(GetOptionNumericValue('requestTimeout':u)).
            
            if HasOption(get-class(ILogWriter):TypeName) then
                oLibBuilder:UsingLogger(cast(GetOptionObjectValue(get-class(ILogWriter):TypeName), ILogWriter)).
            
            return oLibBuilder:Library.
        end.
    end method.
    
    /** Decorate the client with additional behaviour
            
        @param  Class The type of decorator to use
        @param  IHttpClient The client/instance we're decorating
        @return IHttpClient The new, decorating client */
    method static public IHttpClient DecorateClient(input poDecorationType as Progress.Lang.Class,
                                                    input poDecoratedClient as IHttpClient):
        define variable oDecorator as IHttpClient no-undo.
        define variable oDecoratorType as Progress.Lang.Class no-undo.
        define variable oClient as IHttpClient no-undo.
        
        assign oDecoratorType = ClientBuilder:Registry:Get(poDecorationType:TypeName).

       if not valid-object(oDecoratorType) then
            return poDecoratedClient.
        
        /* got to be able to decorate ... */            
        Assert:IsType(oDecoratorType, get-class(HttpClientDecorator)).
        
        oClient = dynamic-new string(oDecoratorType:TypeName) (input poDecoratedClient).

        if type-of(oClient, ISupportInitialize) then
            cast(oClient, ISupportInitialize):Initialize().

        return oClient.
    end method.    
end class.