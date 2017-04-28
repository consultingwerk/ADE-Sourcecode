/* *************************************************************************************************************************
Copyright (c) 2016-2017 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : FullTextFormat
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Nov 16 13:02:52 EST 2016
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.StringConstant.
using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.Format.ISupportFormatting.
using OpenEdge.Logging.LogEvent.
using OpenEdge.Logging.TokenResolver.

class OpenEdge.Logging.Format.FullTextFormat implements ILoggerFilter, ISupportFormatting:
         
    /* Format for the logger name. See the TokenResolve class for more */
    define public property Format as character initial '1K':u no-undo get. set.
    
    /** Performs implementation-specific filtering for a logger type
        
        @param LogMessage The message to log. */
    method public void ExecuteFilter( input poEvent as LogEvent ):
        assign poEvent:Message:Message = substitute('[&1] &3 &2: &4&5':U,
                            /*1*/ iso-date(poEvent:TimeStamp),
                            /*2*/ string(poEvent:LogLevel),
                            /*3*/ (if poEvent:Message:GroupName eq '':u then TokenResolver:Resolve('$~{name.':u + this-object:Format + '.':u + poEvent:LoggerName + '}':u) else poEvent:Message:GroupName),
                            /*4*/ poEvent:Message:Message,
                            /*5*/ StringConstant:CRLF).
        end method.
        
end class.
