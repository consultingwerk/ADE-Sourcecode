/* *************************************************************************************************************************
Copyright (c) 2016-2017, 2019, 2021 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : ResolvedTokenFormat
    Purpose     : Formats a token-based message using the OE.Core.Util.TokenResolver
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : Wed Nov 16 13:02:52 EST 2016
    Notes       : - The format tokens are resolved first, then any message tokens
                  - The format defaults to ${msg.msg}
                  - This filter has special handling for the following tokens
                    ${msg}
                        (LogMessage.Message)
                    ${msg.[sub-token]}
                    sub-token
                        grp                 LogMessage.GroupName
                        logger[.format]     LogEvent.LoggerName
                        level               LogEvent.LogLevel
                        stack.depth         LogEvent.Callstack[depth]; the lesser of the size of the stack or <depth>; set to 1 if not specified
                        cp.[arg]            LogEvent.LoggedBy
                        err                 LogEvent.Error; passed to the TokenResolver's ResolveError() method
                   - All of the msg.[sub-token] messages are fully-resolved here
                   - The ${t.*} and ${cp.*} tokens are passed into the TokenResolver's ResolveTime() and ResolveUser()
                     methods with a value taken from the LogEvent (as opposed to the system default values).
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.IList.
using OpenEdge.Core.Collections.List.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Core.StringConstant.
using OpenEdge.Core.Util.Token.
using OpenEdge.Core.Util.TokenResolver.
using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.Format.ISupportFormatting.
using OpenEdge.Logging.LogEvent.

class OpenEdge.Logging.Format.ResolvedTokenFormat
            implements ILoggerFilter, ISupportFormatting, ISupportInitialize:
    
    /* Format for the logger name. See the TokenResolve class for more */
    define public property Format as character no-undo get. set.
    
    /* An array of extracted format tokens */
    define private variable mFormatTokens as Token extent no-undo.
    
    /* Default constructor */
    constructor public ResolvedTokenFormat():
        // default format is simply the whole message
        assign this-object:Format = '$~{msg.msg}':u.
    end constructor.
    
    method public void Initialize():
        assign mFormatTokens = TokenResolver:Parse(this-object:Format).
    end method.
    
    method public void Destroy():
        assign extent(mFormatTokens) = ?.
    end method.
    
    /** Performs implementation-specific filtering for a logger type
        
        @param LogMessage The message to log. */
    method public void ExecuteFilter(input pEvent as LogEvent):
        define variable ctx as Progress.Lang.Object no-undo.
        define variable val as Progress.Lang.Object no-undo.
        define variable iter as IIterator no-undo.
        define variable token as Token no-undo.
        define variable formatString as character no-undo.
        define variable idx as integer no-undo.
        
        assign ctx = pEvent:Message:GetContext('tokens':u).
        if    not valid-object(ctx)
           or not type-of(ctx, IList)
        then
        do:
            assign ctx = new List().
            pEvent:Message:AddContext('tokens':u, ctx).
        end.
        
        // if there's a list in the event context already, add the message tokens to it,
        // even if the context list is empty
        // add at the beginning so that the format tokens are resolved first, then the message tokens
        if not extent(mFormatTokens) eq ? then
            cast(ctx, IList):AddArray(1, mFormatTokens).
        
        // no tokens; unlikely though
        if cast(ctx, IList):Size eq 0 then
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
            
            // only care about what we know
            case token:Group:
                // Certain tokens are need values from the LogEvent
                when 'cp':u then
                    assign token:Value = TokenResolver:ResolveUser(token:Arg, pEvent:LoggedBy).
                
                when 't':u then
                    assign token:Value = TokenResolver:ResolveTime(token:Arg, pEvent:TimeStamp).
                
                // we may have child tokens
                when 'msg':u then
                case entry(1, token:Arg, '.':u):
                    when '':u or
                    when 'msg':u then
                        assign // this is a special token and we don't keep the value.
                               pEvent:Message:Message = replace(this-object:Format,
                                                                '$':u + StringConstant:CURLY_OPEN + string(token) + StringConstant:CURLY_CLOSE,
                                                                pEvent:Message:Message ).
                    
                    when 'grp':u then
                        assign token:Value = pEvent:Message:GroupName.
                    
                    when 'logger':u then
                    do:
                        if num-entries(token:Arg, '.':u) gt 1 then
                            assign formatString = trim(entry(2, token:Arg, '.':u)).
                        else
                            assign formatString = '':u.
                        
                        // use the pre-formatted logger name if possible
                        if pEvent:ShortNameFormat eq formatString then
                            assign token:Value = pEvent:LoggerShortName.
                        else
                            assign token:Value = TokenResolver:ResolveName(formatString, pEvent:LoggerName).
                    end.    //logger
                    
                    when 'stack':u then
                    do:
                        case true:
                            when extent(pEvent:CallStack) eq ? then
                                assign idx = 0.
                            when num-entries(token:Arg, '.':u) gt 1 then
                                // the number cannot be larger than the actual callstack size
                                assign idx = min(integer(entry(2, token:Arg, '.':u)), extent(pEvent:CallStack)).
                            otherwise
                                assign idx = 1.
                        end case.
                        
                        if idx gt 0 then
                            assign token:Value = pEvent:CallStack[idx].
                    end.    // stack
                    
                    when 'level':u  then
                        assign token:Value = pEvent:LogLevel:ToString().
                    
                    when 'err':u  then
                        // the tokenArg is ERR.<SOMETHING> or just ERR
                        assign token:Value = TokenResolver:ResolveError(substring(token:Arg, 5), pEvent:Error).
                end case.   // MSG.*
                
                otherwise
                    // resolve all unresolved tokens using standard resolution
                    if token:Value eq ? then
                        assign token:Value = TokenResolver:ResolveToken(token:Group, token:Arg, ?).
            end case.
        end.
    end method.
    
end class.
