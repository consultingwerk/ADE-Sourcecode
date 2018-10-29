/************************************************
Copyright (c) 2014, 2018 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : StatefulHttpClient
    Purpose     : Http client with support for cookies
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu May 22 15:12:49 EDT 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Net.HTTP.Cookie.
using OpenEdge.Net.HTTP.HttpClientDecorator.
using OpenEdge.Net.HTTP.ICookieJar.
using OpenEdge.Net.HTTP.IHttpClient.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.ISupportCookies.

class OpenEdge.Net.HTTP.StatefulHttpClient inherits HttpClientDecorator
        implements ISupportCookies:
    
    /* The state maintained by this client */
    define public property CookieJar as ICookieJar no-undo get. set. 
    
    /* Constructor
       
       @param IHttpClient The client to be decorated
       @param ICookieJar The state maintained by this client */
    constructor public StatefulHttpClient(input poClient    as IHttpClient,
                                          input poCookieJar as ICookieJar):
        this-object(poClient).
        
        Assert:NotNull(poCookieJar).
        assign this-object:CookieJar = poCookieJar.
    end constructor.
    
    /* Constructor
       
       @param IHttpClient The client to be decorated */
    constructor public StatefulHttpClient(input poClient    as IHttpClient):
        super(poClient).
    end constructor.

    method override public void Execute(input poRequest  as IHttpRequest,
                                        input poResponse as IHttpResponse):
        define variable iNumCookies as integer no-undo.
        define variable oCookies as Cookie extent no-undo.
        define variable iLoop  as integer no-undo.
        define variable cDomain as character no-undo.
        define variable cPath as character no-undo.
        
        assign iNumCookies = this-object:CookieJar:GetCookies(poRequest:URI, output oCookies).
        
        poRequest:SetCookies(oCookies).
        
        super:Execute(poRequest, poResponse).
        
        assign extent(oCookies) = ?
               iNumCookies = poResponse:GetCookies(output oCookies).

        do iLoop = 1 to iNumCookies:
            
            /* Make sure we have a domain and path for these cookies. */
            assign cDomain = oCookies[iLoop]:Domain
                   cPath   = oCookies[iLoop]:Path.
            if not cDomain begins '.':u then
                assign cDomain = '.':u + cDomain.
            
            /* blank domain/path means it applies only to this request.
               do NOT add a '.' to it */
            if cDomain eq '.':u then
                assign cDomain = poRequest:URI:Host.
            
            if cPath eq '':u then
                assign cPath = poRequest:URI:Path.
            
            /* cookie domain must match request host */
            if not poRequest:URI:Host matches '*':u + left-trim(oCookies[iLoop]:Domain, '.':u) then
                next.
            
            /* add to the jar */
            this-object:CookieJar:AddCookie(cDomain, cPath, oCookies[iLoop]).
        end.
    end method.
    
end class.