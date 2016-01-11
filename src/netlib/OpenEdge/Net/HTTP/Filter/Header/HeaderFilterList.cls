/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : HeaderFilterList
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue May 27 15:25:58 EDT 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Net.HTTP.Filter.FilterActionEnum.
using OpenEdge.Net.HTTP.Filter.Header.HeaderFilterNode.
using OpenEdge.Net.HTTP.HttpMessage.
using OpenEdge.Net.HTTP.Filter.Header.IHeaderFilter.

{OpenEdge/Core/Collections/typedlinkedlist.i
    &Package    = OpenEdge.Net.HTTP.Filter.Header
    &ListType   = HeaderFilterList
    &NodeType   = HeaderFilterNode
    &NoEndClass = true
}

    /** Filter for  headers
        
        @param character The header name 
        @param character The header value 
        @param HttpMessage The filter data to use */
    method public void Filter(input pcName as character,
                              input pcValue as character,
                              input poMessage as HttpMessage):
        define variable oFilterAction as FilterActionEnum no-undo.
        define variable oNode as HeaderFilterNode no-undo.
        
        assign oNode = this-object:First
               oFilterAction = FilterActionEnum:Continue.
               
        do while valid-object(oNode):
            /* validate that we can perform the filter */
            if oNode:Data:CanFilter(pcName) then
            do:
                assign oFilterAction = oNode:Data:ExecuteFilter(pcName, pcValue, poMessage).
                leave.
            end.
            
            if oFilterAction:Equals(FilterActionEnum:Stop) then
                assign oNode = ?.
            else            
                /* pass it on */
                assign oNode = oNode:Next.
        end.
    end method.
    
    /** Factory method for getting filters. Allows reuse of filters.
        Future: filters can be singletons.
        
        @param Progress.Lang.Class The type (class) of filter
        @return IHeaderFilter A filter instance. */
    method public IHeaderFilter GetFilterInstance(input poType as class Progress.Lang.Class):
        Assert:IsType(poType, get-class(IHeaderFilter)).
        
        return cast(poType:New(), IHeaderFilter).        
    end method.
    
end class.