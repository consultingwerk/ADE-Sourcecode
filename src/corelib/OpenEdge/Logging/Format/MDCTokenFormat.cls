/************************************************
Copyright (c) 2018-2019, 2021 by Progress Software Corporation. All rights reserved.
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
        define variable ctx as Progress.Lang.Object no-undo.
        define variable val as Progress.Lang.Object no-undo.
        define variable iter as IIterator no-undo.
        define variable token as Token no-undo.
        
        // No context? No work!
        if MDC:IsEmpty() then
            return.
        
        assign ctx = pEvent:Message:GetContext('tokens':u).
        if    not valid-object(ctx)
           or not type-of(ctx, IList)
           or cast(ctx, IList):Size eq 0
        then
            return.
        
        assign iter = cast(ctx, IList):Iterator().
        TOKEN-LOOP:
        do while iter:HasNext():
            assign val = iter:Next().
            
            if    not valid-object(val)
               or not type-of(val, Token)
            then
                next TOKEN-LOOP.
            
            assign token = cast(val, Token).
            if     not token:Arg eq '':u
               and OpenEdge.Logging.MDC:Has(token:Arg)
            then
                assign token:Value = OpenEdge.Logging.MDC:Get(token:Arg).
        end.
    end method.
    
end class.