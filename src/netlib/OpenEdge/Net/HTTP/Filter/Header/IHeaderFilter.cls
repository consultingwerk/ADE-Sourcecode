/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : HeaderFilter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Feb 14 11:43:22 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.Filter.FilterActionEnum.
using OpenEdge.Net.HTTP.HttpMessage.

interface OpenEdge.Net.HTTP.Filter.Header.IHeaderFilter:
    /** The name of the header that this filter applies to. Can be a complete
        header or part thereof. This property mainly allows external inspection
        but also allows clean code, since it allows us to restruict hard-coding.  */
    define public property HeaderName as character no-undo get. 
    
    /** Indicates whether this filter applies to the current header.     

        @param  character The header name to filter
        @return logical True if the current filter can be used. */
    method public logical CanFilter(input pcName as character).
    
    /** Performs implementation-specific filtering for a header.
        
        @param character The header name on which to filter
        @param character The header value 
        @param HttpMessage Filter data. The data to which the filter is applied.
                           This is only relevant for HttpMessages (request or
                           response).
        @return FilterActionEnum Status of the fitler action. The caller decides
                                 what to do with this information. Filters will
                                 typically return Stop or OK. */
    method public FilterActionEnum ExecuteFilter(input pcName as character,
                                                 input pcValue as character,
                                                 input poFilterData as HttpMessage).
end interface.