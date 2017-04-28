/************************************************
Copyright (c) 2015-2016 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : ProxyHttpClient
    Purpose     : Http client with support for proxy server, for all requests
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu May 22 15:12:49 EDT 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.IAdaptable.
using OpenEdge.Net.HTTP.HttpClientDecorator.
using OpenEdge.Net.HTTP.IHttpClient.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.ISupportProxy.
using OpenEdge.Net.HTTP.RequestBuilder.
using OpenEdge.Net.URI.

class OpenEdge.Net.HTTP.ProxyHttpClient inherits HttpClientDecorator
                implements ISupportProxy:

    /** The URI to use as a proxy for this request eg. http://proxy.example.com/ */
    define public property ProxyURI as URI no-undo get. set. 

    constructor public ProxyHttpClient(input poClient as IHttpClient,
                                       input poProxy  as URI):
        this-object(poClient).
        
        Assert:NotNull(poProxy, 'Proxy server URI').
        assign this-object:ProxyURI = poProxy.
    end constructor.

    constructor public ProxyHttpClient(input poClient as IHttpClient):
        super(poClient).
    end constructor.
    
    method override public void Execute(input poRequest as IHttpRequest,
                                        input poResponse as IHttpResponse):
        define variable oProxyRequest as ISupportProxy no-undo.
        
        if type-of(poRequest, IAdaptable) then
            assign oProxyRequest = cast(cast(poRequest, IAdaptable):GetAdapter(get-class(ISupportProxy)), ISupportProxy).
        else
        if type-of(poRequest, ISupportProxy) then
            assign oProxyRequest = cast(poRequest, ISupportProxy).
            
        if not valid-object(oProxyRequest) then
            assign poRequest = RequestBuilder:DecorateRequest(get-class(ISupportProxy), poRequest)
                   oProxyRequest = cast(poRequest, ISupportProxy).
        
        /* We need to be able to proxy the request. */
        Assert:IsType(poRequest, get-class(ISupportProxy)).
        assign oProxyRequest:ProxyURI = this-object:ProxyURI.
        
        super:Execute(poRequest, poResponse).
    end method.
    
end class.