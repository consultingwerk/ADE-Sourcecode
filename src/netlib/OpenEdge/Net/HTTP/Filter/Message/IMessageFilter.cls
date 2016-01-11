/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : MessageFilter
    Purpose     : Abstract, common filter functionality for a message (request or
                  response).
    Author(s)   : pjudge
    Created     : Thu Oct 30 09:24:44 EDT 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.Filter.FilterActionEnum.
using OpenEdge.Net.HTTP.HttpMessage.
using Progress.Lang.Object.

interface OpenEdge.Net.HTTP.Filter.Message.IMessageFilter:
    
    /** Indicates whether this filter applies to the current message. 
        
        @param HttpMessage The message to check
        @return logical True if the current filter can be used. */
    method public logical CanFilter(input poMessage as HttpMessage).
    
    /** Performs implementation-specific filtering for a message.
        
        @param HttpMessage The message to filter
        @return FilterActionEnum Status of the fitler action. The caller decides
                                 what to do with this information. Filters will
                                 typically return Stop or OK. */
    method public FilterActionEnum ExecuteFilter(input poMessage as HttpMessage).
    
end interface.