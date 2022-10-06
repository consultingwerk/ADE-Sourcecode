/************************************************
Copyright (c) 2018-2019, 2021-2022 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : MDCTokenFormat
    Purpose     : A formatter for MDC-based tokens.
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2018-11-19
    Notes       : - The tokens must be of the format
                    ${mdc.context-key}
                    where the "context-key" value is a key used (Put) into
                    the session's MDC
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.IList.
using OpenEdge.Core.Util.Token.
using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.LogEvent.
using OpenEdge.Logging.MDC.

class OpenEdge.Logging.Format.MDCTokenFormat implements ILoggerFilter:
    
    /** Performs implementation-specific filtering for a logger type
        
        @param LogEvent The current log event to filter */
    method public void ExecuteFilter(input pEvent as LogEvent):
        var Progress.Collections.IIterator<Token> iter.
        
        // No context? No work!
        if MDC:IsEmpty()
        // no tokens? no work!
        or not valid-object(pEvent:Message:Tokens)
        then
            return.
        
        assign iter = pEvent:Message:Tokens:GetIterator().
        TOKEN-LOOP:
        do while iter:MoveNext():
            // In case of unknown values. The LogMessage's Tokens property is a Set, but this code (ie compiler) does not guarantee that.
            if valid-object(iter:Current)
            and not iter:Current:Arg eq '':u
            and OpenEdge.Logging.MDC:Has(iter:Current:Arg)
            then
                assign iter:Current:Value = OpenEdge.Logging.MDC:Get(iter:Current:Arg).
        end.
    end method.
    
end class.