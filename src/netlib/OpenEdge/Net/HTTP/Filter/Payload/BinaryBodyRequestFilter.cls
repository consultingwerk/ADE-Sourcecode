/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : BinaryBodyRequestFilter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jan 29 10:47:13 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.AssertionFailedError.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.Memptr.
using OpenEdge.Net.HTTP.Filter.Payload.DefaultRequestFilter.
using OpenEdge.Net.HTTP.IHttpRequest.

class OpenEdge.Net.HTTP.Filter.Payload.BinaryBodyRequestFilter inherits DefaultRequestFilter: 
		
	constructor public BinaryBodyRequestFilter(input poMessage as IHttpRequest):
		super (input poMessage).
	end constructor.
	
	method override protected ByteBucket ExtractEntity(  ):
        define variable mJson as memptr no-undo.
        define variable oBody as ByteBucket no-undo.
        
        if not this-object:Message:Entity:GetClass():IsA(get-class(ByteBucket)) and
           not this-object:Message:Entity:GetClass():IsA(get-class(Memptr)) then
            return error new AssertionFailedError('Entity is not a binary type', 0).
        
        /* Add the JSON to the message body's bytebucket */
        if type-of(this-object:Message:Entity, Memptr) then
        do:
            assign oBody = ByteBucket:Instance().
            oBody:PutBytes(cast(this-object:Message:Entity, Memptr):GetPointerValue(),
                           cast(this-object:Message:Entity, Memptr):Size).
        end.
        else
            assign oBody = cast(this-object:Message:Entity, ByteBucket).
        
        return oBody.
        finally:
            set-size(mJson) = 0.
        end finally.	    
	end method.

end class.