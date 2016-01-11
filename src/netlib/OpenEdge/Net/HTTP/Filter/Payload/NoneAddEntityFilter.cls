/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : NoneAddEntityFilter
    Purpose     : Filter for when the entity is unset/set to ?
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
using OpenEdge.Net.HTTP.HttpRequest.
using OpenEdge.Core.WidgetHandle.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Payload.NoneAddEntityFilter implements IMessageFilter:

    constructor public NoneAddEntityFilter():
    end constructor.
    
    /** Indicates whether this filter applies to the current message. 
        
        @param HttpMessage The message to check
        @return logical True if the current filter can be used. */
    method public logical CanFilter(input poMessage as HttpMessage):
        return type-of(poMessage, HttpRequest) and
                     not valid-object(cast(poMessage, HttpRequest):Entity).
    end method.
    
    /** Performs implementation-specific filtering for a message.
        
        @param HttpMessage The message to filter
        @return FilterActionEnum Status of the fitler action. The caller decides
                                 what to do with this information. Filters will
                                 typically return Stop or OK. */
    method public FilterActionEnum ExecuteFilter(input poMessage as HttpMessage).
        assign poMessage:ContentType   = ? 
               poMessage:ContentLength = 0.
        
        return FilterActionEnum:Stop.
    end method.    
    
end class.