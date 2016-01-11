/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : BodyFilterList
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue May 27 15:36:46 EDT 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.ByteBucket.
using OpenEdge.Net.HTTP.Filter.Body.BodyFilterNode.
using Progress.Lang.Object.

{OpenEdge/Core/Collections/typedlinkedlist.i
    &Package    = OpenEdge.Net.HTTP.Filter.Body
    &ListType   = BodyFilterList
    &NodeType   = BodyFilterNode
    &NoEndClass = true
}

    /** Populates an Entity object for the HttpResponse 
        
        @param HttpResponse The Response being operated on. */
    method public void Extract(input-output poEntity as Object):
        define variable iLoop as integer no-undo.
        define variable oNode as BodyFilterNode no-undo.
        define variable iMax as integer no-undo.
        define variable lStopFilter as logical no-undo.
        
        assign oNode       = this-object:First
               lStopFilter = false.
        
        do while valid-object(oNode):
            assign iMax = extent(oNode:Data:ContentType).
            do iLoop = 1 to iMax:
                if oNode:Data:ContentType[iLoop] eq oNode:Data:Message:ContentType then
                do:
                    assign lStopFilter = oNode:Data:ExtractBody(input-output poEntity).
                    leave.
                end.
            end.
            
            if lStopFilter then
                leave.
            
            /* pass it on */
            assign oNode = oNode:Next.
        end.
    end method.
    
    method public void Insert(input-output poMessageBody as ByteBucket):
        define variable iLoop as integer no-undo.
        define variable oNode as BodyFilterNode no-undo.
        define variable iMax as integer no-undo.
        define variable lStopFilter as logical no-undo.
        
        assign oNode       = this-object:First
               lStopFilter = false.
        
        do while valid-object(oNode):
            assign iMax = extent(oNode:Data:ContentType).
            do iLoop = 1 to iMax:
                if oNode:Data:ContentType[iLoop] eq oNode:Data:Message:ContentType then
                do:
                    assign lStopFilter = oNode:Data:InsertBody(input-output poMessageBody)
                           oNode:Data:Message:ContentLength = poMessageBody:Size. 
                    leave.
                end.
            end.
            
            if lStopFilter then
                leave.
            
            /* pass it on */
            assign oNode = oNode:Next.
        end.
    end method.
    
end class.