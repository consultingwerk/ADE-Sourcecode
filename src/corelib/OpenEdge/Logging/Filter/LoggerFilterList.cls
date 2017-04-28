/************************************************
Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : LoggerFilterList
    Purpose     : A list of filter nodes to process
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-11-16
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Logging.Filter.LoggerFilterNode.
using OpenEdge.Logging.LogEvent.

{OpenEdge/Core/Collections/typedlinkedlist.i
    &Package    = OpenEdge.Logging.Filter
    &ListType   = LoggerFilterList
    &NodeType   = LoggerFilterNode
    &NoEndClass = false
}

    /** Performs implementation-specific filtering for a logger type
        
        @param LogMessage The message to log. */
    method public void ExecuteFilter(input poEvent as LogEvent):
        define variable oNode as LoggerFilterNode no-undo.
        
        Assert:NotNull(poEvent, 'Log event').
        
        assign oNode = this-object:First.
        do while valid-object(oNode):
            oNode:Data:ExecuteFilter(poEvent).
            
            /* pass it on */
            assign oNode = oNode:Next.
        end.
    end method.
    
end class.
