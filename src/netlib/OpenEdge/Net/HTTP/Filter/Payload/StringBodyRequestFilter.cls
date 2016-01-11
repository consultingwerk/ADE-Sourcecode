/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : StringBodyRequestFilter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jan 29 10:47:13 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.String.
using OpenEdge.Net.HTTP.Filter.Payload.DefaultRequestFilter.
using OpenEdge.Net.HTTP.IHttpRequest.

class OpenEdge.Net.HTTP.Filter.Payload.StringBodyRequestFilter inherits DefaultRequestFilter: 
		
	constructor public StringBodyRequestFilter(input poMessage as IHttpRequest):
		super (input poMessage).
	end constructor.
	
	method override protected ByteBucket ExtractEntity():
        define variable oBody as ByteBucket no-undo.

        assign oBody = ByteBucket:Instance().
                 
        oBody:PutString(this-object:Message:Entity:ToString()).
        
        return oBody.
	end method.

end class.