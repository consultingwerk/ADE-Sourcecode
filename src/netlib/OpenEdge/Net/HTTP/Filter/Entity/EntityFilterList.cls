/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : EntityFilterList
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue May 27 15:46:18 EDT 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.Filter.Entity.EntityFilterNode.
using Progress.Lang.Object.
 
{OpenEdge/Core/Collections/typedlinkedlist.i
    &Package    = OpenEdge.Net.HTTP.Filter.Entity
    &ListType   = EntityFilterList
    &NodeType   = EntityFilterNode
    &NoEndClass = true
}
    
    method public void Add(input poEntity as Object):
        define variable iLoop as integer no-undo.
        define variable lStopFilter as logical no-undo.
        define variable oNode as EntityFilterNode no-undo.
        
        assign oNode       = this-object:First
               lStopFilter = false.
        
        do while valid-object(oNode):
            if valid-object(oNode:Data:Message:Entity) and
               poEntity:GetClass():IsA(oNode:Data:EntityType) then 
                lStopFilter = oNode:Data:AddEntity(input poEntity).
            
            if lStopFilter then
                leave.
            
            /* pass it on */
            assign oNode = oNode:Next.
        end.
    end method.
    
end class.