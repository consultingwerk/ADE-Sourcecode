/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : SetCookieSetHeaderFilter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge 
    Created     : Thu Feb 12 09:08:39 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Net.HTTP.Cookie.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.IHttpMessage.
using OpenEdge.Net.HTTP.IHttpMessageWriter.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Header.SetCookieSetHeaderFilter implements IHttpMessageWriter: 
	define public property Message as IHttpMessage no-undo get. private set.
	
	define variable mcCookie as character no-undo. 

    constructor public SetCookieSetHeaderFilter(input poMessage as IHttpMessage):
        Assert:NotNull(poMessage, 'Http message').
        assign this-object:Message = poMessage.
    end constructor.

	method public void Open(  ):
	    assign mcCookie = '':u.		  
	end method.

	method public void Write( input poData as Object):
        Assert:IsType(poData, get-class(HttpHeader)).
        assign mcCookie = cast(poData, HttpHeader):Value.
	end method.
	
	method public void Write( input-output pcData as longchar ):
	    assign mcCookie = pcData.
	end method.

    method public void Write( input-output pcData as character ):
        assign mcCookie = pcData.
    end method.

    method public void Write( input phData as handle ):
        /* no-op */
    end method.

	method public void Write( input pmData as memptr ):
        Assert:IsPositive(get-size(pmData), 'Data').
        assign mcCookie= get-string(pmData, 1).
	end method.

	method public void Flush():
        this-object:Message:SetCookie(Cookie:Parse(mcCookie)).
	end method.
	
	method public void Close(  ):
	    Flush().
	end method.

end class.