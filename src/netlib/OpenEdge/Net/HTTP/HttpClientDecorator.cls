/************************************************
Copyright (c) 2015, 2019 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : HttpClientDecorator
    Purpose     : Decorator class for decoracting/customising Http Clients
                  without requiring inheritance. This allows us to construct 
                  more complex clients (say with cookies, no proxy OR with cookies,
                  with proxy) without having to have individual types for all the 
                  combinations                  
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Jan 21 09:26:18 EST 2015
    Notes       : * There's a decent description of Decorator pattern in Wikipedia
                    at http://en.wikipedia.org/wiki/Decorator_pattern
                  * This class should be extended to provide specific functionality.
                    For instance, adding support for proxies, or cookies 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Net.HTTP.ClientOptions.
using OpenEdge.Net.HTTP.IHttpClient.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.ResponseBuilder.

class OpenEdge.Net.HTTP.HttpClientDecorator abstract implements IHttpClient:
    /* the decorated client. this can be a decoration or an actual http client */
    define protected property DecoratedHttpClient as IHttpClient no-undo get. private set.

	define public property ClientName as character no-undo 
	get():
	    return DecoratedHttpClient:ClientName.
	end get.
	private set.

	define public property ClientVersion as character no-undo 
    get():
        return DecoratedHttpClient:ClientVersion.
    end get.
    private set.

	define public property Options as ClientOptions no-undo 
	get():
	    return DecoratedHttpClient:Options.
    end get.
	private set. 
	
	constructor public HttpClientDecorator(input poHttpClient as IHttpClient):
	    Assert:NotNull(poHttpClient, 'Http client').

	    assign this-object:DecoratedHttpClient = poHttpClient.
    end constructor.
    
	/** Executes an HTTP request.
	
	    This method wraps the Execute(Req,Resp) call in the same way that the
	    HttpClient does. If does so in order to ensure that the Execute(req, resp)
	    is always called, because we don't want to force each decorator to have
	    to implement this call.
        
        @param  HttpRequest Request parameters (URL, method, etc)
        @return HttpResponse Includes status and payload */
    method  public IHttpResponse Execute(input poRequest as IHttpRequest):
        define variable oResponse as IHttpResponse no-undo.
        
        assign oResponse = ResponseBuilder:Build():Response.
        
        this-object:Execute(poRequest, oResponse).
        
        return oResponse.
    end method.

	method public void Execute( input poRequest as IHttpRequest, input poResponse as IHttpResponse):
		DecoratedHttpClient:Execute(poRequest, poResponse).
	end method.
	
end class.