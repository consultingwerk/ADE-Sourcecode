/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : JsonAddEntityFilter
    Purpose     : Filter for adding an entity to a request
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Feb 17 13:06:38 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.Filter.FilterActionEnum.
using OpenEdge.Net.HTTP.Filter.Message.IMessageFilter.
using OpenEdge.Net.HTTP.HttpMessage.
using Progress.Lang.Object.
using OpenEdge.Net.HTTP.HttpRequest.
using Progress.Json.ObjectModel.JsonConstruct.

class OpenEdge.Net.HTTP.Filter.Payload.JsonAddEntityFilter implements IMessageFilter: 
    constructor public JsonAddEntityFilter():
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
        @param Object Filter data. This argument is input-output because the 
                      filter data objects may be (re)created by the method.
        @return FilterActionEnum Status of the fitler action. The caller decides
                                 what to do with this information. Filters will
                                 typically return Stop or OK. */
    method public FilterActionEnum ExecuteFilter(input poMessage as HttpMessage).
        assign poMessage:ContentType = 'application/json'.
        
        return FilterActionEnum:Stop.
    end method.
    
end class.