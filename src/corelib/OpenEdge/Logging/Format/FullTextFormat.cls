/* *************************************************************************************************************************
Copyright (c) 2016-2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
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
    define public property Format as character initial '1C':u no-undo get. set.
    
    /** Performs implementation-specific filtering for a logger type
        
        @param LogMessage The message to log. */
    method public void ExecuteFilter( input poEvent as LogEvent ):
        define variable messageGroup as character no-undo.
        
        if poEvent:Message:GroupName eq '':u then
        do: 
            if this-object:Format eq poEvent:ShortNameFormat then
                assign messageGroup = poEvent:LoggerShortName.
            else
                assign messageGroup = TokenResolver:ResolveName(this-object:Format, poEvent:LoggerName).
        end.
        else
            assign messageGroup = poEvent:Message:GroupName.
        
        assign poEvent:Message:Message = substitute('[&1] &3 &2: &4':U,
                            /*1*/ iso-date(poEvent:TimeStamp),
                            /*2*/ string(poEvent:LogLevel),
                            /*3*/ messageGroup,
                            /*4*/ poEvent:Message:Message).
        end method.
        
end class.
