/************************************************
Copyright (c)  2014-2016 by Progress Software Corporation. All rights reserved.
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
            
            SetHost(poURI).
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
    
    /** Removes cookies from this message for a given name
    
        @param character The name of the cookie(s) to remove. */
    method override public void RemoveCookie( input pcName as character ):
        define variable oHeader as HttpHeader no-undo.
        define variable lExists as logical no-undo.
        
        super:RemoveCookie(pcName).

        if this-object:Cookies:Size eq 0 then
            RemoveHeader('Cookie':u).
        else
            assign oHeader = GetHeader('Cookie':u).
        if valid-object(oHeader) and oHeader:Name eq 'Cookie':u then
        do:
            assign lExists = oHeader:RemoveParameters(pcName).
            /* this cookie may be the first cookie in the list, so remove it */
            if not lExists and oHeader:Value begins pcName then
                assign oHeader:Value = '':u.
        end.
    end method.
    
    /** Adds a cookie to this request 
    
        @param Cookie The cookie to add. */
    method override public void SetCookie(input poCookie as Cookie):
        define variable oHeader as HttpHeader no-undo.
        
        super:SetCookie(input poCookie).
        
        if HasHeader('Cookie':u) then
            GetHeader('Cookie':u):SetParameterValue(poCookie:Name, poCookie:Value).
        else
            SetHeader(HttpHeaderBuilder
                          :Build('Cookie':u)
                          :Value(substitute('&1=&2':u, poCookie:Name, poCookie:Value))
                          :Header).
    end method.
    
    /** Sets the Host header based on the request's URI */    
    method protected void SetHost(input poUri as URI):
        define variable cHost as character no-undo.
        
        if valid-object(poUri) then
            assign cHost = poUri:Host
                         + (if poUri:Port eq ? then '':u
                            else
                            ':':u + string(poUri:Port)).
        
        SetHeader(HttpHeaderBuilder:Build('Host':u):Value(cHost):Header).
    end method.
    
end class. 