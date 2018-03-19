/************************************************
Copyright (c) 2016-2017 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : ILoggerFilter
    Purpose     : Filter functionality definition for a message
    Author(s)   : pjudge
    Created     : 2016-11-16
    Notes       : * Implementers of this interface can be
                        - message formatters
                        - message writers (to disk, file, db etc)
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Logging.LogEvent.

interface OpenEdge.Logging.Filter.ILoggerFilter:
    
    /** Performs implementation-specific filtering for a logger type
        
        @param LogEvent The log event to filter. */
    method public void ExecuteFilter(input poEvent as LogEvent).
    
end interface.
