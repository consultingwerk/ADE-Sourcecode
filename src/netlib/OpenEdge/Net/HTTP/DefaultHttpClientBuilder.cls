/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : DefaultHttpClientBuilder
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Jan 14 14:53:46 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Assertion.AssertJson.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Core.JsonDataTypeEnum.
using OpenEdge.Net.HTTP.ClientBuilder.
using OpenEdge.Net.HTTP.HttpClientDecorator.
using OpenEdge.Net.HTTP.IHttpClient.
using OpenEdge.Net.HTTP.ISupportCookies.
using OpenEdge.Net.HTTP.ICookieJar.
using OpenEdge.Net.HTTP.ISupportProxy.
using OpenEdge.Net.URI.
using Progress.Json.ObjectModel.JsonObject.

class OpenEdge.Net.HTTP.DefaultHttpClientBuilder inherits ClientBuilder
             implements ISupportInitialize:
                 
    /** Returns a configured client. */
    define override public property Client as IHttpClient no-undo
        get():
            return NewClient().
        end get.

    constructor public DefaultHttpClientBuilder():
        super().
    end method.

    method public void Initialize():
        Named('OpenEdge-HttpClient':u, '0.3.0':u).
    end method.
    
    method public void Destroy():
    end method.
    /** Returns a useable HttpClient based on the config.
        
        @return IHttpClient A useable HttpClient instance */
    method private IHttpClient NewClient():
        define variable oClient as IHttpClient no-undo.
        define variable oClientType as Progress.Lang.Class no-undo.
        
        /* INVOKE */
        Assert:IsTrue(HasOption(PROP_CLIENT_NAME)).
        Assert:IsTrue(HasOption(PROP_CLIENT_VERSION)).
        
        assign oClientType = ClientBuilder:Registry:Get(get-class(IHttpClient):TypeName).
        
        /* We know the signature to the default client's constructor - make sure that the type we
           get is of that type */
        Assert:IsType(oClientType, get-class(OpenEdge.Net.HTTP.HttpClient)).
        
        oClient = dynamic-new string(oClientType:TypeName) (GetOptionStringValue(PROP_CLIENT_NAME),
                                                            GetOptionStringValue(PROP_CLIENT_VERSION),
                                                            BuildLibrary()).
        
        /* SET OPTIONS */
        if HasOption('numRetries':u) then
            oClient:Options:NumRetries = GetOptionNumericValue('numRetries':u).
        if HasOption('pauseBetweenRetry':u) then
            oClient:Options:PauseBetweenRetry = GetOptionNumericValue('pauseBetweenRetry':u).
        if HasOption('requestTimeout':u) then
            oClient:Options:RequestTimeout = GetOptionNumericValue('requestTimeout':u).
        
        /* INIT if needed  */
        if type-of(oClient, ISupportInitialize) then
            cast(oClient, ISupportInitialize):Initialize().
        
        /* COOKIES? */
        if HasOption(get-class(ICookieJar):TypeName) then
            assign oClient = ClientBuilder:DecorateClient(get-class(ISupportCookies), oClient)
                   cast(oClient, ISupportCookies):CookieJar = cast(GetOptionObjectValue(get-class(ICookieJar):TypeName), ICookieJar).
        
        /* PROXY? */
        if HasOption(get-class(ISupportProxy):TypeName) then
            assign oClient = ClientBuilder:DecorateClient(get-class(ISupportProxy), oClient)
                   cast(oClient, ISupportProxy):ProxyURI = cast(GetOptionObjectValue(get-class(ISupportProxy):TypeName), URI).
        return oClient.
    end method.
    
end class.