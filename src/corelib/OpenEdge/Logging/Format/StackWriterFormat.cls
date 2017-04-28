/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : StackWriterFormat
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-11-17
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.LogEvent.

class OpenEdge.Logging.Format.StackWriterFormat implements ILoggerFilter: 
    define private property LF as character initial '~n':u no-undo get.
    define private property TAB as character initial '~t':u no-undo get.
    
    /** Performs implementation-specific filtering for a logger type
        
        @param LogMessage The message to log. */
    method public void ExecuteFilter( input poEvent as LogEvent):
        define variable stackCnt as integer no-undo.
        define variable stackSize as integer no-undo.
        define variable delim as character no-undo.
        
        assign stackSize = extent(poEvent:CallStack).
        if stackSize ne ? then
        do:
            assign poEvent:Message:Message = poEvent:Message:Message
                                           + LF + TAB
                                           + 'Log stack:'.
            do stackCnt = 1 to stackSize:
                assign poEvent:Message:Message = poEvent:Message:Message
                                               + LF + TAB + TAB
                                               + poEvent:CallStack[stackCnt]. 
            end.
        end.
        end method.
        
end class.
