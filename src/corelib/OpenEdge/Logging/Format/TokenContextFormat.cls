/* *************************************************************************************************************************
Copyright (c) 2018-2019, 2021-2022 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
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

using OpenEdge.Core.StringConstant.
using OpenEdge.Core.Util.Token.
using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.Format.LogMessageTokenResolver.
using OpenEdge.Logging.LogEvent.
using Progress.Collections.IIterator.

class OpenEdge.Logging.Format.TokenContextFormat
inherits LogMessageTokenResolver
implements ILoggerFilter:
    
    /** Performs implementation-specific filtering for a logger type
        
        @param LogEvent The current log event to filter */
    method public void ExecuteFilter(input pEvent as LogEvent):
        var IIterator<Token> iter.
        
        if not valid-object(pEvent:Message:Tokens) then
            return.
        
        // resolve any unresolved token values
        ResolveMessageTokens(pEvent:Message:Tokens, pEvent).
        
        assign iter = pEvent:Message:Tokens:GetIterator().
        ITER-LOOP:
        do while iter:MoveNext():
            // In case of unknown values. The LogMessage's Tokens property is a Set, but this code (ie compiler) does not guarantee that.
            if not valid-object(iter:Current) then
                next ITER-LOOP.
            
            if not iter:Current:Value eq ? then
                assign pEvent:Message:Message = replace(pEvent:Message:Message,
                                                        '$':u + StringConstant:CURLY_OPEN + string(iter:Current) + StringConstant:CURLY_CLOSE,
                                                        iter:Current:Value).
            else
            // unknown value uses "?" and is allowed
            if iter:Current:AllowUnknownValue then
                assign pEvent:Message:Message = replace(pEvent:Message:Message,
                                                        '$':u + StringConstant:CURLY_OPEN + string(iter:Current) + StringConstant:CURLY_CLOSE,
                                                        '?').
        end.
    end method.
end class.