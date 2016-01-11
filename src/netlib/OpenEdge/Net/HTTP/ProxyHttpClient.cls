/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
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
using OpenEdge.Net.HTTP.HttpClientDecorator.
using OpenEdge.Net.HTTP.IHttpClient.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.RequestBuilder.
using OpenEdge.Net.HTTP.ISupportProxy.
using OpenEdge.Net.URI.

class OpenEdge.Net.HTTP.ProxyHttpClient inherits HttpClientDecorator
                implements ISupportProxy:

    /** The URI to use as a proxy for this request eg. http://proxy.example.com/ */
	define public property ProxyURI as URI no-undo get. set. 

    constructor public ProxyHttpClient(input poClient as IHttpClient,
                                       input poProxy  as URI):
        super(poClient).
        
		Assert:NotNull(poProxy, 'Proxy server URI').
        assign this-object:ProxyURI = poProxy.
    end constructor.
    
    method override public void Execute(input poRequest as IHttpRequest,
                                        input poResponse as IHttpResponse):
        /* We need to be able to proxy the request. */
        assign poRequest = RequestBuilder:DecorateRequest(get-class(ISupportProxy), poRequest).
        Assert:IsType(poRequest, get-class(ISupportProxy)).
        
        assign cast(poRequest, ISupportProxy):ProxyURI = this-object:ProxyURI.
        
        super:Execute(poRequest, poResponse).
    end method.
    
end class.