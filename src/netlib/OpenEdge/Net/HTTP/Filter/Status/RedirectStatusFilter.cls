/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : RedirectStatusFilter
    Purpose     : 
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
using OpenEdge.Net.HTTP.StatusCodeEnum.
using OpenEdge.Net.HTTP.HttpResponse.

class OpenEdge.Net.HTTP.Filter.Status.RedirectStatusFilter implements IMessageFilter: 
    
    constructor public RedirectStatusFilter():
    end constructor.
    
    /** Indicates whether this filter applies to the current message. 
        
        @param HttpMessage The message to check
        @return logical True if the current filter can be used. */
    method public logical CanFilter(input poMessage as HttpMessage):
        define variable lCanFilter as logical no-undo.
        define variable oStatus as StatusCodeEnum no-undo.
        
        assign lCanFilter = type-of(poMessage, HttpResponse).
        
        if lCanFilter then
            assign oStatus = cast(poMessage, HttpResponse):StatusCode
                   lCanFilter = (oStatus:Equals(StatusCodeEnum:Found) or
                                 oStatus:Equals(StatusCodeEnum:MovedPermanently) ).
        return lCanFilter.
    end method.
    
    /** Performs implementation-specific filtering for a message.
        
        @param HttpMessage The message to filter
        @return FilterActionEnum Status of the fitler action. The caller decides
                                 what to do with this information. Filters will
                                 typically return Stop or OK. */
    method public FilterActionEnum ExecuteFilter(input poMessage as HttpMessage):
        define variable cLocation as character no-undo.
        
        assign cLocation = poMessage:GetHeaderEntry('Location').
        
        /* the value of the Location header is the new host/path */
        cast(poMessage, HttpResponse):Request:SetURI(string(cLocation)).        
        
        return FilterActionEnum:Retry.
    end method.
    
end class.