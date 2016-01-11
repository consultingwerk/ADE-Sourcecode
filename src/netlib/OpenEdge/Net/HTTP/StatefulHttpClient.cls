/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : StatefulHttpClient
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu May 22 15:12:49 EDT 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Net.HTTP.CookieJar.
using OpenEdge.Net.HTTP.HttpClient.
using OpenEdge.Net.HTTP.HttpRequest.
using OpenEdge.Net.HTTP.HttpResponse.
using OpenEdge.Net.HTTP.ICookieJar.
using OpenEdge.Net.HTTP.Cookie.

class OpenEdge.Net.HTTP.StatefulHttpClient inherits HttpClient: 
    define private variable moCookieJar as ICookieJar no-undo.

    constructor public StatefulHttpClient():
        assign moCookieJar = CookieJar:Instance().
    end constructor.

    method override public HttpResponse Execute(input poRequest as HttpRequest):
        define variable oResponse as HttpResponse no-undo.
        define variable oIterator as IIterator no-undo.
        
        poRequest:AddCookies(moCookieJar:GetCookies(poRequest:URI)).
        
        oResponse = super:Execute(poRequest).
        
        assign oIterator = oResponse:GetCookiesIterator().
        do while oIterator:HasNext():
            moCookieJar:AddCookie(cast(oIterator:Next(), Cookie)).
        end.
        
        return oResponse.
    end method.    
end class.