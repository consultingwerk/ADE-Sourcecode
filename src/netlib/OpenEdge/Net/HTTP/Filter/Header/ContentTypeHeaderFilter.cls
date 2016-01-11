/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : ContentTypeHeaderFilter
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

class OpenEdge.Net.HTTP.Filter.Header.ContentTypeHeaderFilter inherits HeaderFilter:
	constructor public ContentTypeHeaderFilter (input poMessage as HttpMessage):
		super (input 'Content-Type', input poMessage).
	end constructor.
	
	method override public logical AddHeader( input pcName as character, input pcValue as character):
	    define variable iIdx as integer no-undo.
	    
	    iIdx = index(pcValue, ';').
	    
	    if iIdx gt 0 then
	       assign this-object:Message:ContentType = substring(pcValue, 1, iIdx - 1)
	              this-object:Message:ContentTypeEncoding = left-trim(substring(pcValue, iIdx + 1)).   
	    else
            this-object:Message:ContentType = pcValue.
        
        return true.
	end method.
	
	method override public logical RemoveHeader(input pcName as character):
	    return true.
	end method.
	
end class.