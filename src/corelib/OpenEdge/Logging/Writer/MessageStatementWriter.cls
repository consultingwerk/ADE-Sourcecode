/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : MessageStatementWriter
    Purpose     : Writes the message as a MESSAGE statement.
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-11-22
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.LogEvent.

class OpenEdge.Logging.Writer.MessageStatementWriter implements ILoggerFilter:
    
    /** Performs implementation-specific filtering for a logger type
        
        @param LogMessage The message to log. */
    method public void ExecuteFilter( input poEvent as LogEvent):
        message poEvent:Message:Message.
    end method.
        
end class.
