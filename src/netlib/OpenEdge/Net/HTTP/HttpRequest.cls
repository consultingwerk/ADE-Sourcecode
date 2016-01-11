/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : HttpRequest
    Purpose     : Contains an HTTP Request per RFC2616 and friends
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Dec 18 13:24:00 EST 2013
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Net.HTTP.Cookie.
using OpenEdge.Net.HTTP.HttpMessage.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.MethodEnum.
using OpenEdge.Net.URI.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.HttpHeaderBuilder.

class OpenEdge.Net.HTTP.HttpRequest inherits HttpMessage
            implements IHttpRequest:
    
    /** (mandatory) GET/PUT/POST etc. Defaults to GET. */
    define public property Method as character no-undo get. set.
    
    /** (mandatory) The URI to request eg. http://progress.com/ */
    define public property URI as URI no-undo
        get.
        set(input poURI as URI):
            Assert:NotNull(poURI, 'URI').
            
            assign this-object:URI = poURI.
            SetHost().
        end set.
    
    /** The content types which we will accept in response to this request */
    define public property AcceptContentType as character extent no-undo get. set.
        
    /** Defautl constructor */
    constructor public HttpRequest():
    end constructor.
    
    /** Constructor.
    
        @param MethodEnum       The method/verb for this request
        @param URI              The target resource for this request */
    constructor public HttpRequest(input poMethod as MethodEnum,
                                   input poURI as URI):
        this-object(poMethod:Name, poURI).
    end constructor.
    
    /** Constructor.
    
        @param character The method/verb for this request
        @param URI       The target resource for this request */
    constructor public HttpRequest(input pcMethod as character,
                                   input poURI as URI):
        super().
        
        Assert:NotNullOrEmpty(pcMethod, 'Method').
        Assert:NotNull(poURI, 'URI').
        
        assign this-object:URI    = poURI
               this-object:Method = pcMethod.
    end constructor.
        
    /** Sets the Host header based on the request's URI */	
    method private void SetHost():
        define variable cHost as character no-undo.
        
        assign cHost = this-object:URI:Host
                     + (if this-object:URI:Port eq ? then '':u
                        else
                        ':':u + string(this-object:URI:Port)).
        
        SetHeader(HttpHeaderBuilder:Build('Host':u):Value(cHost):Header).
    end method.
    
end class. 