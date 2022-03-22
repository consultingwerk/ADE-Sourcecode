/* *************************************************************************************************************************
Copyright (c) 2018-2019, 2021 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : TokenContextFormat
    Purpose     : (Re)Builds a message from a set of tokenised values
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2018-11-19
    Notes       : - This format filter should be the _last_ filter before any writers,
                    so that the log message can be properly constructed
                  - This filter is cached in the LoggerFilterRegistry as the REPLACE_TOKENS_FORMAT filter
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.IList.
using OpenEdge.Core.StringConstant.
using OpenEdge.Core.Util.Token.
using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.LogEvent.

class OpenEdge.Logging.Format.TokenContextFormat
                implements ILoggerFilter:
    
    /** Performs implementation-specific filtering for a logger type
        
        @param LogEvent The current log event to filter */
    method public void ExecuteFilter(input pEvent as LogEvent):
        define variable iter as IIterator no-undo.
        define variable val as Progress.Lang.Object no-undo.
        define variable ctx as Progress.Lang.Object no-undo.
        define variable token as Token no-undo.
        
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
            if not token:Value eq ? then
                assign pEvent:Message:Message = replace(pEvent:Message:Message,
                                                        '$':u + StringConstant:CURLY_OPEN + string(token) + StringConstant:CURLY_CLOSE,
                                                        token:Value).
        end.
    end method.
end class.