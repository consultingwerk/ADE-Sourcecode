/* *************************************************************************************************************************
Copyright (c) 2016-2017 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : ResolvedTokenFormat
    Purpose     : Formats a token-based message using the OE.Logging.TokenResolver
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Nov 16 13:02:52 EST 2016
    Notes       : - The Format string in this
                    ${msg}
                        (LogMessage.Message)
                    ${msg.[sub-token]}
                    sub-token
                        grp                 LogMessage.GroupName
                        logger[.format]     LogEvent.LoggerName
                        level               LogEvent.LogLevel
                        stack.depth         LogEvent.Callstack[depth]; the lesser of the size of the stack or <depth>; set to 1 if not specified 
                        t.[arg]             LogEvent.TimeStamp
                            arg is * Group args for T (T= time). from TokenResolver
                        cp.[arg]            LogEvent.LoggedBy
                        err         LogEvent.Error
                   - All of the msg.[sub-token] messages are fully-resolved here except
                     for the ts.[arg] tokens which are passed into the TokenResolver
                           
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.Format.ISupportFormatting.
using OpenEdge.Logging.LogEvent.
using OpenEdge.Logging.TokenResolver.
using OpenEdge.Logging.TokenResolverEventArgs.

class OpenEdge.Logging.Format.ResolvedTokenFormat implements ILoggerFilter,ISupportFormatting:
    // stateful variable so we know which event we're dealing with in the callback 
    define private variable mCurrentEvent as LogEvent no-undo.
    
    /* Format for the logger name. See the TokenResolve class for more */
    define public property Format as character no-undo get. set.
    
    /* Default constructor */
    constructor public ResolvedTokenFormat ():
        TokenResolver:TokenResolved:Subscribe(this-object:TokenResolvedHandler).
    end constructor.        
    
    /** Performs implementation-specific filtering for a logger type
        
        @param LogMessage The message to log. */
    method public void ExecuteFilter( input poEvent as LogEvent ):
        if not valid-object(poEvent) then
            return.
        
        assign mCurrentEvent           = poEvent
               // pass the input message through in case it has tokens itself
               poEvent:Message:Message = TokenResolver:Resolve(poEvent:Message:Message)
               // now format per this filter's Format
               poEvent:Message:Message = TokenResolver:Resolve(this-object:Format)
               .
        finally:
            assign mCurrentEvent = ?.
        end finally.
    end method.
    
    /* Callback to handle token replacement with LogEvent/LogMessage context
       
       @param Object The sender
       @param TokenResolverEventArgs The token resolution args  */
    method public void TokenResolvedHandler (input pSender as Progress.Lang.Object,
                                             input pArgs as TokenResolverEventArgs):
        define variable formatString as character no-undo.
        define variable idx as integer no-undo.
        
        if not valid-object(mCurrentEvent) then
            return.
        
        // only care about what we know
        if not pArgs:TokenGroup eq 'msg':u then
            return.
        
        // we may have child tokens
        case entry(1, pArgs:TokenArg, '.':u):
            when '':u or
            when 'msg':u  then
                assign pArgs:TokenValue = mCurrentEvent:Message:Message.
            when 'grp':u  then
                assign pArgs:TokenValue = mCurrentEvent:Message:GroupName.
            when 'logger':u  then
            do:
                if num-entries(pArgs:TokenArg, '.':u) gt 1 then
                    assign formatString = trim(entry(2, pArgs:TokenArg, '.':u)).
                else
                    assign formatString = '':u.
                
                // use the pre-formatted logger name if possible
                if mCurrentEvent:ShortNameFormat eq formatString then
                    assign pArgs:TokenValue = mCurrentEvent:LoggerShortName.
                else
                    assign pArgs:TokenValue = TokenResolver:ResolveName(formatString, mCurrentEvent:LoggerName).
            end.    //logger
            
            when 'stack':u then
            do:
                case true:
                    when extent(mCurrentEvent:CallStack) eq ? then
                        assign idx = 0.
                    when num-entries(pArgs:TokenArg, '.':u) gt 1 then
                        // the number cannot be larger than the actual callstack size
                        assign idx = min(integer(entry(2, pArgs:TokenArg, '.':u)), extent(mCurrentEvent:CallStack)). 
                    otherwise
                        assign idx = 1.
                end case.
                
                if idx gt 0 then                
                    assign pArgs:TokenValue = mCurrentEvent:CallStack[idx].
            end.    // stack 
            
            when 'level':u  then
                assign pArgs:TokenValue = mCurrentEvent:LogLevel:ToString().
            when 'err':u  then
                assign pArgs:TokenValue = mCurrentEvent:Error:ToString().
            when 't':u then
                assign pArgs:TokenValue = TokenResolver:ResolveTime(entry(2, pArgs:TokenArg, '.':u), mCurrentEvent:TimeStamp).
            when 'cp':u then
                assign pArgs:TokenValue = TokenResolver:ResolveUser(entry(2, pArgs:TokenArg, '.':u), mCurrentEvent:LoggedBy).
            // leave it alone otherwise 
        end case.
    end method.
    
end class.
