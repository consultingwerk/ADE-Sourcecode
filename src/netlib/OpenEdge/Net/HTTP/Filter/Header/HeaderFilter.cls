/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : HeaderFilter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Feb 14 11:43:22 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Net.HTTP.HttpMessage.

class OpenEdge.Net.HTTP.Filter.Header.HeaderFilter abstract:
    define public property HeaderName as character no-undo get. private set.
    
    /** (mandatory) The message (request/response) that this filter is applied to. */
    define public property Message as HttpMessage no-undo get. private set.
    
    constructor public HeaderFilter (input pcHeaderName as character,
                                     input poMessage as HttpMessage):
        Assert:NotNull(poMessage, 'Message ').
        Assert:NotNullOrEmpty(pcHeaderName, 'Header name').
        
        assign this-object:HeaderName = pcHeaderName
               this-object:Message = poMessage.
    end constructor.
    
    /* to be implemented by the individual filter types*/
    method abstract public logical AddHeader(input pcName as character,
                                             input pcValue as character).
    method abstract public logical RemoveHeader(input pcName as character).
    
end class.