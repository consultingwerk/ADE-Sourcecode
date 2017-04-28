/* *************************************************************************************************************************
Copyright (c) 2016-2017 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : LogManagerFormat
    Purpose     : Provides a standard format for writing log-manager messages via write-message()
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-11-17
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.StringConstant.
using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.Format.ISupportFormatting.
using OpenEdge.Logging.LogEvent.
using OpenEdge.Logging.TokenResolver.

class OpenEdge.Logging.Format.LogManagerFormat implements ILoggerFilter, ISupportFormatting:
    
    /* Format for the logger name. See the TokenResolve class for more */
    define public property Format as character initial '1K':u no-undo get. set.
    
    /** Performs implementation-specific filtering for a logger type
        
        @param LogMessage The message to log. */
    method public void ExecuteFilter( input poEvent as LogEvent):
        assign poEvent:Message:Message = substitute('[&3 &1] &2':u,
                                                string(poEvent:LogLevel), 
                                                poEvent:Message:Message,
                                                TokenResolver:Resolve(substitute('$&1name.&3.&2}':u, 
                                                                        StringConstant:CURLY_OPEN,
                                                                        poEvent:LoggerName,
                                                                        this-object:Format ))
                                                ).
    end method.
    
end class.
