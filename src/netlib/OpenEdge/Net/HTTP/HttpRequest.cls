/************************************************
Copyright (c)  2014, 2015 by Progress Software Corporation. All rights reserved.
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
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Net.HTTP.Cookie.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.HttpHeaderBuilder.
using OpenEdge.Net.HTTP.HttpMessage.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.MethodEnum.
using OpenEdge.Net.URI.

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
    
    /* temp vars for keeping values between ctor and init */
    define private variable moURI as URI no-undo.
    define private variable mcMethod as character no-undo.
    
    /** Default constructor */
    constructor public HttpRequest():
    end constructor.
    
    /** Constructor.
    
        @param MethodEnum       The method/verb for this request
        @param URI              The target resource for this request */
    constructor public HttpRequest(input poMethod as MethodEnum,
                                   input poURI as URI):
        this-object(string(poMethod), poURI).
    end constructor.
    
    /** Constructor.
    
        @param character The method/verb for this request
        @param URI       The target resource for this request */
    constructor public HttpRequest(input pcMethod as character,
                                   input poURI as URI):
        super().
        
        Assert:NotNullOrEmpty(pcMethod, 'Method').
        Assert:NotNull(poURI, 'URI').
        
        /* keep for later; kludgy but we need to create the header collection
           first and then assign . Use the default constructor instead */
        assign moURI    = poURI
               mcMethod = pcMethod.
    end constructor.
    
    /** Initialiser */
    method override public void Initialize():
        super:Initialize().
        
        if valid-object(moURI) then
            assign this-object:URI    = moURI
                   this-object:Method = mcMethod
                   
                   moURI    = ?
                   mcMethod = ?.
    end method.

    /** Removes all cookies from this request */        
    method override public void ClearCookies():
        super:ClearCookies().
        
        RemoveHeader('Cookie':u).
    end method.
    
    /** Removes a cookie from this request 
    
        @param Cookie The cookie to remove. */
    method override public void RemoveCookie(input poCookie as Cookie):
        define variable oHeader as HttpHeader no-undo.
        define variable oCookie as Cookie no-undo.
        define variable oIterator as IIterator no-undo.
        
        super:RemoveCookie(input poCookie).

        if this-object:Cookies:Size eq 0 then
            RemoveHeader('Cookie':u).
        else
            assign oHeader = GetHeader('Cookie':u).
        if valid-object(oHeader) then
        do:
            /* clear values */
            assign oHeader:Value = '':u
                   oIterator     = this-object:Cookies:Iterator()
                   /* get first one */
                   oCookie = cast(oIterator:Next(), Cookie).
            if valid-object(oCookie) then
                assign oHeader:Value = substitute('&1=&2':u, oCookie:Name, oCookie:Value).
            
            do while oIterator:HasNext():
                assign oCookie = cast(oIterator:Next(), Cookie).
                oHeader:SetParameterValue(oCookie:Name, oCookie:Value).
            end.
        end.
    end method.

    /** Adds a cookie to this request 
    
        @param Cookie The cookie to add. */
    method override public void SetCookie(input poCookie as Cookie):
        define variable oHeader as HttpHeader no-undo.
        
        super:SetCookie(input poCookie).
        
        assign oHeader = GetHeader('Cookie':u).
        if not valid-object(oHeader) then
            SetHeader(HttpHeaderBuilder
                          :Build('Cookie':u)
                          :Value(substitute('&1=&2':u, poCookie:Name, poCookie:Value))
                          :Header).
        else
            oHeader:SetParameterValue(poCookie:Name, poCookie:Value).
    end method.
    
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