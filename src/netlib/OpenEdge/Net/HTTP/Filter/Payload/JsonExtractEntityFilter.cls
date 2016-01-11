/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : JsonExtractEntityFilter
    Purpose     : Constructs a Message Body from a request's Entity 
                  (extracts data from an Entity)
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Feb 17 13:06:38 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.ConcreteHttpRequest.
using OpenEdge.Net.HTTP.Filter.FilterActionEnum.
using OpenEdge.Net.HTTP.Filter.Message.IMessageFilter.
using OpenEdge.Net.HTTP.HttpMessage.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Lang.Object.
using Progress.Json.ObjectModel.JsonConstruct.
using OpenEdge.Net.HTTP.HttpRequest.

class OpenEdge.Net.HTTP.Filter.Payload.JsonExtractEntityFilter implements IMessageFilter:
    define variable moParser as ObjectModelParser no-undo.
    
    constructor public JsonExtractEntityFilter():
        moParser  = new ObjectModelParser().
    end constructor.
    
    /** Indicates whether this filter applies to the current message. 
        
        @param HttpMessage The message to check
        @return logical True if the current filter can be used. */
    method public logical CanFilter(input poMessage as HttpMessage):
        define variable lCanFilter as logical no-undo.
        define variable oEntity as Object no-undo.
        
        lCanFilter = type-of(poMessage, HttpRequest).
        
        if lCanFilter then
            assign oEntity    = cast(poMessage, HttpRequest):Entity
                   lCanFilter = valid-object(oEntity) and 
                                oEntity:GetClass():IsA(get-class(JsonConstruct)).
        return lCanFilter.
    end method.
    
    /** Performs implementation-specific filtering for a message.
        
        @param HttpMessage The message to filter
        @return FilterActionEnum Status of the fitler action. The caller decides
                                 what to do with this information. Filters will
                                 typically return Stop or OK. */
    method public FilterActionEnum ExecuteFilter(input poMessage as HttpMessage):
        define variable mJson as memptr no-undo.
        define variable oConcreteRequest as ConcreteHttpRequest no-undo.
        
        cast(poMessage:Entity, JsonConstruct):Write(mJson).
        
        oConcreteRequest = cast(poMessage, ConcreteHttpRequest).
        oConcreteRequest:AddMessageBody().
        
        /* Add the JSON to the message body's bytebucket */
        oConcreteRequest:MessageBody:PutBytes(
            get-pointer-value(mJson), get-size(mJson)).
        
        poMessage:ContentLength = oConcreteRequest:MessageBody:Size.
        
        return FilterActionEnum:Stop.
        finally:
            set-size(mJson) = 0.
        end finally.
    end method.
    
end class.