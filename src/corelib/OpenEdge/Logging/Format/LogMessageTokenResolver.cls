/* *************************************************************************************************************************
Copyright (c) 2022-2023,2025 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
 /*------------------------------------------------------------------------
    File        : LogMessageTokenResolver
    Purpose     : Abstract class that knows how to resolve tokens for the LogMessage/
                  LogEvent
    Syntax      :
    Description :
    Author(s)   : pjudge
    Notes       : - This filter has special handling for the following tokens
                    ${msg.[sub-token]}
                    sub-token
                        grp                 LogMessage.GroupName
                        logger[.format]     LogEvent.LoggerName
                        level               LogEvent.LogLevel
                        stack.depth         LogEvent.Callstack[depth]; the lesser of the size of the stack or <depth>; set to 1 if not specified
                        cp.[arg]            LogEvent.LoggedBy
                        err                 LogEvent.Error; passed to the TokenResolver's ResolveError() method
                   - All of the msg.[sub-token] messages are fully-resolved here
                   - Any ${t.*} and ${cp.*} tokens are passed into the TokenResolver's ResolveTime() and ResolveUser()
                     methods with a value taken from the LogEvent (as opposed to the system default values).
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Util.Token.
using OpenEdge.Core.Util.TokenResolver.
using OpenEdge.Logging.LogEvent.
using Progress.Collections.IIterator.
using Progress.Collections.ISet.

class OpenEdge.Logging.Format.LogMessageTokenResolver
abstract
:
    /* Resolves a set of tokens, using values from a particular LogEvent

       @param ISet<Token> A set of tokens.
       @param LogEvent The current logevent (message). Provides context for the tokens. */
    method protected void ResolveMessageTokens(input pTokens as ISet<Token>,
                                               input pEvent as LogEvent):
        var character formatString.
        var IIterator<Token> iter.
        var integer idx.

        // no-op, no failure if there are no tokens or context/event
        if not valid-object(pTokens)
        or not valid-object(pEvent)
        then
            return.

        assign iter = pTokens:GetIterator().
        do while iter:MoveNext():
            // A valid resolved value has not been set yet for the token (<group>.<arg>).
            // We try to resolve the value, even if ? is a valid value, since at this
            // point we don't know whether the value has actually been set or not.

            // There are some groups or arguments which should always be resolved on every
            // occurrence as they may have changed since the last time they were resolved.
            // Specifically t[ime].now|iso|mtime or msg.level values which are important
            // to log messages which are used to reflect timings of events.
            case iter:Current:Group:
                when 't':u or
                when 'time' then
                    case iter:Current:Arg:
                        when 'now':u or
                        when 'iso':u or
                        when 'mtime':u then
                            assign iter:Current:Value = ?.
                    end case.
                when 'msg':u then do:
                    if iter:Current:Arg eq 'level':u then
                        assign iter:Current:Value = ?.
                end.
            end case.

            if iter:Current:Value eq ? then
            case iter:Current:Group:
                // Certain tokens use values from the LogEvent
                when 'cp':u then
                    assign iter:Current:Value = TokenResolver:ResolveUser(iter:Current:Arg, pEvent:LoggedBy).

                when 't':u or
                when 'time':u then
                    assign iter:Current:Value = TokenResolver:ResolveTime(iter:Current:Arg, pEvent:TimeStamp).

                // we may have child tokens
                when 'msg':u then
                    case entry(1, iter:Current:Arg, '.':u):
                        when 'grp':u then
                            assign iter:Current:Value = pEvent:Message:GroupName.

                        when 'logger':u then
                        do:
                            if num-entries(iter:Current:Arg, '.':u) gt 1 then
                                assign formatString = trim(entry(2, iter:Current:Arg, '.':u)).
                            else
                                assign formatString = '':u.

                            // use the pre-formatted logger name if possible
                            if pEvent:ShortNameFormat eq formatString then
                                assign iter:Current:Value = pEvent:LoggerShortName.
                            else
                                assign iter:Current:Value = TokenResolver:ResolveName(formatString, pEvent:LoggerName).
                        end.    //logger

                        when 'stack':u then
                        do:
                            case true:
                                when extent(pEvent:CallStack) eq ? then
                                    assign idx = 0.
                                when num-entries(iter:Current:Arg, '.':u) gt 1 then
                                    // the number cannot be larger than the actual callstack size
                                    assign idx = min(integer(entry(2, iter:Current:Arg, '.':u)), extent(pEvent:CallStack)).
                                otherwise
                                    assign idx = 1.
                            end case.

                            if idx gt 0 then
                                assign iter:Current:Value = pEvent:CallStack[idx].
                        end.    // stack

                        when 'level':u  then
                            assign iter:Current:Value = pEvent:LogLevel:ToString().

                        when 'err':u  then
                            // the tokenArg is ERR.<SOMETHING> or just ERR
                            assign iter:Current:Value = TokenResolver:ResolveError(substring(iter:Current:Arg, 5), pEvent:Error).
                    end case.   // MSG.*

                when 'name' then
                do:
                    // tokenArg = format-expression "." name
                    assign idx = index(iter:Current:Arg, '.').
                    if idx gt 0 then
                        assign iter:Current:Value = TokenResolver:ResolveName(substring(iter:Current:Arg, 1, idx - 1), substring(iter:Current:Arg, idx + 1)).
                end.    // NAME.*

                otherwise
                    // resolve all unresolved tokens using standard resolution
                    assign iter:Current:Value = TokenResolver:ResolveToken(iter:Current:Group, iter:Current:Arg, ?).
            end case.
        end.
    end method.
end class.