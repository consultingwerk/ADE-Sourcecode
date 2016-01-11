 /*------------------------------------------------------------------------
    File        : ProxyHttpRequest
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Jan 30 09:33:58 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.HttpRequestDecorator.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.ISupportProxy.
using OpenEdge.Net.URI.
using OpenEdge.Net.HTTP.HttpHeaderBuilder.

class OpenEdge.Net.HTTP.ProxyHttpRequest inherits HttpRequestDecorator  
        implements ISupportProxy:
    
    /** The URI to use as a proxy for this request eg. http://proxy.example.com/ */
    define public property ProxyURI as URI no-undo
        get.
        set(input poProxyServer as URI):
            assign this-object:ProxyURI = poProxyServer.
            SetHost().
        end set.
        
    constructor public ProxyHttpRequest(input poHttpRequest as IHttpRequest):
        super(poHttpRequest).
    end constructor.
    
    method private void SetHost():
        define variable cHost as character no-undo.
        define variable oHostURI as URI no-undo.
        
        if valid-object(ProxyURI) then
            assign oHostURI = ProxyURI.
        else
            assign oHostURI = URI.
        
        assign cHost = oHostURI:Host
                     + (if oHostURI:Port eq ? then '':u
                        else
                        ':':u + string(oHostURI:Port)).
        
        SetHeader(HttpHeaderBuilder:Build('Host':u):Value(cHost):Header).
    end method.
    
end class.