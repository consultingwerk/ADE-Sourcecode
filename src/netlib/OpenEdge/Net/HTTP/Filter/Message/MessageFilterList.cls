/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : MessageFilterList
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue May 27 15:36:46 EDT 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Net.HTTP.Filter.FilterActionEnum.
using OpenEdge.Net.HTTP.Filter.Message.IMessageFilter.
using OpenEdge.Net.HTTP.Filter.Message.MessageFilterNode.
using OpenEdge.Net.HTTP.HttpMessage.
using Progress.Lang.Object.

{OpenEdge/Core/Collections/typedlinkedlist.i
    &Package    = OpenEdge.Net.HTTP.Filter.Message
    &ListType   = MessageFilterList
    &NodeType   = MessageFilterNode
    &NoEndClass = true
}

    /** Applies a filter to this message.  
        
        @param Object The filter data being applied 
        @param FilterActionEnum The result of the filter action. */
    method public FilterActionEnum Filter(input poMessage as HttpMessage):
        define variable oNode as MessageFilterNode no-undo.
        define variable oFilterAction as FilterActionEnum no-undo.
        
        assign oNode = this-object:First
               oFilterAction = FilterActionEnum:OK.
        
        do while valid-object(oNode):
            /* validate that we can perform the filter */
            if oNode:Data:CanFilter(poMessage) then
            do:
                assign oFilterAction = oNode:Data:ExecuteFilter(input poMessage).
                leave.
            end.
            
            if oFilterAction:Equals(FilterActionEnum:Stop) then
                assign oNode = ?.
            else
                /* pass it on */
                assign oNode = oNode:Next.
        end.
        
        return oFilterAction.
    end method.
    
    /** Factory method for getting filters. Allows reuse of filters.
        Future: filters can be singletons.
        
        @param Progress.Lang.Class The type (class) of filter
        @return IMessageFilter A filter instance. */
    method public IMessageFilter GetFilterInstance(input poType as class Progress.Lang.Class):
        Assert:IsType(poType, get-class(IMessageFilter)).
        
        return cast(poType:New(), IMessageFilter).        
    end method.
    
end class.