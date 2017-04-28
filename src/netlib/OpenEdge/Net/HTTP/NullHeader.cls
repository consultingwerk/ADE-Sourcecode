/************************************************
Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : NullHeader
    Purpose     : A special header with a UNKNOWN Name and Value, intended 
                  to allow calls to GetHeader() to be chained 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-10-14
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Net.HTTP.HttpHeader.

class OpenEdge.Net.HTTP.NullHeader inherits HttpHeader final:
    
    constructor public NullHeader():
        // we'll replace the Name in a sec 
        super('X-NULL-HEADER':u).
        
        assign this-object:Name  = ?
               this-object:Value = ?.
    end constructor.
    
    method override protected character GetValue():
        return ?.
	end method.
	
    /* Validates a header value. Should throw an error if the value
       is not valid.
       
       @param character The (prospective) header value */
    method override protected void Validate(input pcValue as character):
        Assert:IsNull(pcValue, 'Null header value').
    end method.
    
end class.