/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : HtmlBodyRequestFilter
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
using OpenEdge.Core.Assert.

class OpenEdge.Net.HTTP.Filter.Payload.HtmlBodyRequestFilter inherits DefaultRequestFilter: 
		
	constructor public HtmlBodyRequestFilter(input poMessage as IHttpRequest):
		super (input poMessage).
	end constructor.
	
	method override protected ByteBucket ExtractEntity():
        define variable oBody as ByteBucket no-undo.
        
        Assert:IsType(this-object:Message:Entity, get-class(String)).

        assign oBody = ByteBucket:Instance().
               
        oBody:PutString(cast(this-object:Message:Entity, String)).
        
        return oBody.
	end method.

end class.