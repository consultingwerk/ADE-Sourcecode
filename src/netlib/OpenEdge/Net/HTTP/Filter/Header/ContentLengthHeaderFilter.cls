/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : ContentLengthHeaderFilter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Feb 14 11:47:30 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.Filter.Header.HeaderFilter.
using OpenEdge.Net.HTTP.HttpMessage.

class OpenEdge.Net.HTTP.Filter.Header.ContentLengthHeaderFilter inherits HeaderFilter:
	constructor public ContentLengthHeaderFilter (input poMessage as HttpMessage):
		super (input 'Content-Length', input poMessage).
	end constructor.
	
	method override public logical AddHeader(input pcName as character, input pcValue as character):
        assign this-object:Message:ContentLength = integer(pcValue) no-error.
        return false.
	end method.
	
	method override public logical RemoveHeader(input pcName as character):
	    this-object:Message:ContentLength = ?.
	    return false.
	end method.
	
end class.