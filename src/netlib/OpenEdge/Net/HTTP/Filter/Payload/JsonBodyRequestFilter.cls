/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : JsonBodyRequestFilter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jan 29 10:47:13 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Net.HTTP.Filter.Payload.DefaultRequestFilter.
using OpenEdge.Net.HTTP.IHttpRequest.
using Progress.Json.ObjectModel.JsonConstruct.

class OpenEdge.Net.HTTP.Filter.Payload.JsonBodyRequestFilter inherits DefaultRequestFilter: 
		
	constructor public JsonBodyRequestFilter(input poMessage as IHttpRequest):
		super (input poMessage).
	end constructor.
	
	method override protected ByteBucket ExtractEntity(  ):
        define variable mJson as memptr no-undo.
        define variable oBody as ByteBucket no-undo.
        
        Assert:IsType(this-object:Message:Entity, get-class(JsonConstruct)).

        cast(this-object:Message:Entity, JsonConstruct):Write(mJson).
        
        /* Add the JSON to the message body's bytebucket */
        assign oBody = ByteBucket:Instance().
        
        oBody:PutBytes(get-pointer-value(mJson), get-size(mJson)).
        
        return oBody.
        finally:
            set-size(mJson) = 0.
        end finally.	    
	end method.

end class.