/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : SetCookieHeaderFilter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Feb 14 11:47:30 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.Cookie.
using OpenEdge.Net.HTTP.Filter.Header.HeaderFilter.
using OpenEdge.Net.HTTP.HttpMessage.
using OpenEdge.Net.HTTP.HttpRequest.
using OpenEdge.Net.HTTP.HttpResponse.

class OpenEdge.Net.HTTP.Filter.Header.CookieHeaderFilter inherits HeaderFilter:
	constructor public CookieHeaderFilter (input poMessage as HttpMessage):
		super (input '*Cookie', input poMessage).
	end constructor.
	
	method override public logical AddHeader( input pcName as character, input pcValue as character):
	    define variable oRequest as HttpRequest no-undo.
	    define variable oCookie as Cookie no-undo.
	    
        if type-of(this-object:Message, HttpRequest) then
            oRequest = cast(this-object:Message, HttpRequest).
	    else
	        oRequest = cast(this-object:Message, HttpResponse):Request.
        
        oCookie = Cookie:Parse(pcValue).
        
        /* Ignore cookies from domains other than the one we're dealing with */
        if oCookie:DomainMatches(oRequest:URI:Host) then
            this-object:Message:SetCookieEntry(oCookie).
        
	    return true.
	end method.
	
	method override public logical RemoveHeader(input pcName as character):
	    return true.
	    /* NO-OP */
	end method.
	
end class.