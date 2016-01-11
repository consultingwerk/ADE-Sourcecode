/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : DefaultHeaderBuilder
    Purpose     : Simple, general header builder
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Feb 13 13:35:13 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.HttpHeaderBuilder.
using OpenEdge.Core.Assert.

class OpenEdge.Net.HTTP.DefaultHeaderBuilder inherits HttpHeaderBuilder: 

    /** Each concrete builder will implement this differently */
    define override public property Header as HttpHeader no-undo
        get():
            if not valid-object(this-object:Header) then
                assign this-object:Header = NewHeader().
            
            return this-object:Header.
        end get.
        private set.
    
	constructor public DefaultHeaderBuilder(input pcHeaderName as character):
		super(pcHeaderName).
	end constructor.
        
    method private HttpHeader NewHeader():
        define variable oHeader as HttpHeader no-undo.
        
        assign oHeader = new HttpHeader(this-object:HeaderName).
        
        if HasOption('paramDelimiter':u) then
            assign oHeader:ParamDelimiter = GetOptionStringValue('paramDelimiter':u).
        
        if HasOption('hdrValue':u) then
            assign oHeader:Value = GetOptionStringValue('hdrValue':u).
        
        return oHeader.
    end method.
    
end class.