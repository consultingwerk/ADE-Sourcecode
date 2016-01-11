/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : OKStatusFilter
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

class OpenEdge.Net.HTTP.Filter.Status.OKStatusFilter implements IMessageFilter: 
    
    constructor public OKStatusFilter():
    end constructor.
    
    /** Indicates whether this filter applies to the current message. 
        
        @param HttpMessage The message to check
        @return logical True if the current filter can be used. */
	method public logical CanFilter(input poMessage as HttpMessage):
	    define variable lCanFilter as logical no-undo.
	    
	    lCanFilter = type-of(poMessage, HttpResponse) and
	                 cast(poMessage, HttpResponse):StatusCode:Equals(StatusCodeEnum:OK).
	    
	    return lCanFilter.
	end method.


    /** Performs implementation-specific filtering for a message.
        
        @param HttpMessage The message to filter
        @return FilterActionEnum Status of the fitler action. The caller decides
                                 what to do with this information. Filters will
                                 typically return Stop or OK. */
	method public FilterActionEnum ExecuteFilter(input poMessage as HttpMessage):
        return FilterActionEnum:OK.
	end method.
	
end class.