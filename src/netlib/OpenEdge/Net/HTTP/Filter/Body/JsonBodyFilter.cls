/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : JsonBodyFilter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Feb 17 13:06:38 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Memptr.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Net.HTTP.HttpMessage.
using OpenEdge.Net.HTTP.Filter.Body.MessageBodyFilter.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Body.JsonBodyFilter inherits MessageBodyFilter:
    define variable moParser as ObjectModelParser no-undo.
    define private variable mcTypes as character extent 1 no-undo
        initial ['application/json'].
    
    constructor public JsonBodyFilter(input poMessage as HttpMessage):
		super(mcTypes, poMessage).
		
        moParser  = new ObjectModelParser().
    end constructor.
    
    /** Replaces any existing object with JSON content. this is not an append. */
	method override public logical ExtractBody(input-output poEntity as Object):
        assign poEntity = cast(moParser:Parse(this-object:Message:MessageBody:GetBytes():Value), JsonConstruct).        
        
        return true.
	end method.
	
	/** Replaces the existing message body with the contents of the Entity */
	method override public logical InsertBody(input-output poMessageBody as ByteBucket):
	    define variable mJson as memptr no-undo.
	    
        cast(this-object:Message:Entity, JsonConstruct):Write(mJson).
        
        if not valid-object(poMessageBody) then
            poMessageBody = ByteBucket:Instance().

        poMessageBody:PutBytes(get-pointer-value(mJson), get-size(mJson)).
        
        return true.
        finally:
            set-size(mJson) = 0.
        end finally.
	end method.
	
end class.