/* *************************************************************************************************************************
Copyright (c) 2016-2018, 2022 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : FullTextFormat
    Purpose     : Write a log message in a standard format
                    "["<timestamp>"]" <logger-short-name> <log-level>":" <log message>
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : Wed Nov 16 13:02:52 EST 2016
    Notes       : * The <logger-short-name> default formatting is 1K. This uses the first letter (existing case) of all
                    dot-delimited entries in the logger name, except for the last entry, which is kept as-is.
                    See the OpenEdge.Core.Util.TokenResolver class comments for info about the formatting.
                    Examples:
                        "OpenEdge.Security.Provider.UserTableAuthProvider" shortens to "O.S.P.UserTableAuthProvider"
                        "com.progress.AuthProvider" shortens to "c.p.AuthProvider"
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.StringConstant.
using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.Format.ISupportFormatting.
using OpenEdge.Logging.LogEvent.
using OpenEdge.Logging.TokenResolver.

class OpenEdge.Logging.Format.FullTextFormat implements ILoggerFilter, ISupportFormatting:
    
    /* Format for the logger name. See the OpenEdge.Core.Util.TokenResolver class for more */
    define public property Format as character initial '1K':u no-undo get. set.
    
    /** Performs implementation-specific filtering for a logger type
        
        @param LogMessage The message to log. */
    method public void ExecuteFilter( input poEvent as LogEvent ):
        define variable messageGroup as character no-undo.
        
        // Avoid recalculating this on each call
        if this-object:Format eq poEvent:ShortNameFormat
        or this-object:Format eq ''
        then
            assign messageGroup = poEvent:LoggerShortName.
        else
            assign messageGroup = TokenResolver:ResolveName(this-object:Format, poEvent:LoggerName).
        
        assign poEvent:Message:Message = substitute('[&1] &2 &3: &4':U,
                            /*1*/ iso-date(poEvent:TimeStamp),
                            /*2*/ messageGroup,
                            /*3*/ string(poEvent:LogLevel),
                            /*4*/ poEvent:Message:Message).
        end method.
        
end class.
