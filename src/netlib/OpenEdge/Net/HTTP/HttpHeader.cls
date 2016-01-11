/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : HttpHeader
    Purpose     : A basic HTTP header. Can be extended for headers that have multi-part values
                  (like Content-Type which has an optional charset= part.
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Feb 11 11:49:10 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.

class OpenEdge.Net.HTTP.HttpHeader:
    /** (mandatory) The name of the header */
    define public property Name as character no-undo get. private set.
    
    /** A header value */
    define public property Value as character no-undo get. set.
    
    constructor public HttpHeader(input pcName as character,
                              input pcValue as character):
        this-object(pcName).
        Assert:NotNull(pcValue, 'Header value').
        
        assign this-object:Value = pcValue. 
    end constructor.

    constructor public HttpHeader(input pcName as character):
        Assert:NotNullOrEmpty(pcName, 'Header name').
        assign this-object:Name = pcName. 
    end constructor.
    
end class.