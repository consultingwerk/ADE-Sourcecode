/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : VoidWriter
    Purpose     : No-op or VOID logger. Does nothing. Swallows everything.
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-11-10
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.LogEvent.

class OpenEdge.Logging.Writer.VoidWriter implements ILoggerFilter:
    
    /** Performs implementation-specific filtering for a logger type
        
        @param LogMessage The message to log. */
        method public void ExecuteFilter( input poEvent as LogEvent ):
            /* NOTHING HAPPENS HERE */
        end method.
        
end class.
