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

using OpenEdge.Net.HTTP.Filter.Header.HeaderFilterNode.

{OpenEdge/Core/Collections/typedlinkedlist.i
    &Package    = OpenEdge.Net.HTTP.Filter.Header
    &ListType   = HeaderFilterList
    &NodeType   = HeaderFilterNode
    &NoEndClass = true
}

    /** Filter for adding headers
        
        @param character The header name 
        @param character The header value */
    method public void Add(input pcName as character,
                           input pcValue as character):
        define variable lStopFilter as logical no-undo.
        define variable oNode as HeaderFilterNode no-undo.
        
        assign oNode       = this-object:First
               lStopFilter = false.
               
        do while valid-object(oNode):
            if pcName matches oNode:Data:HeaderName then
                assign lStopFilter = oNode:Data:AddHeader(pcName, pcValue).
            
            if lStopFilter then
                leave.
            
            /* pass it on */
            assign oNode = oNode:Next.
        end.
    end method.
    
    /** Filter for removing headers
        
        @param character The header name 
        @param character The header value */

    method public void Remove(input pcName as character):
        define variable lStopFilter as logical no-undo.
        define variable oNode as HeaderFilterNode no-undo.
        
        assign oNode       = this-object:First
               lStopFilter = false.
        
        do while valid-object(oNode):
            if pcName matches oNode:Data:HeaderName then
                assign lStopFilter = oNode:Data:RemoveHeader(pcName).
            
            if lStopFilter then
                leave.
            
            /* pass it on */
            assign oNode = oNode:Next.
        end.
    end method.
    
end class.