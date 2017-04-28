/************************************************
Copyright (c) 2016-2017 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : LogEvent
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Nov 16 14:03:05 EST 2016
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.StringConstant.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.LogLevelEnum.
using OpenEdge.Logging.LogMessage.

class OpenEdge.Logging.LogEvent serializable:
    // (optional) The logger that initiated this event
    define public property Logger as ILogWriter no-undo get. set.
    
    // (optional) The name of the logger
    define public property LoggerName as character no-undo
        get():
            if valid-object(Logger) then
                return Logger:Name.
            
            return this-object:LoggerName. 
        end get.
        set(input pcName as character):
            if not valid-object(Logger) then
                assign this-object:LoggerName = pcName.
        end set. 
            
    // (mandatory) THe level of this event
    define public property LogLevel as LogLevelEnum no-undo get. private set.
    
    // The more-or-less exact time when the log event occurred 
    define public property TimeStamp as datetime-tz no-undo get. private set.
    
    // The log message
    define public property Message as LogMessage no-undo get. private set.
    
    // An error to log
    define public property Error as Progress.Lang.Error no-undo get. private set.
    
    // The current stack trace, of where the LOG event occurred. Not the error stack trace
    define public property CallStack as character extent no-undo get. private set.
    
    /* (optional) The user logging this event */
    define public property LoggedBy as handle no-undo get. set.
    
    /* Constructor
       
       @param LogLevelEnum The level this log event was at 
       @param LogMessage The message to log
       @param P.L.Error The error being logged
       @param datetime-tz The timestamp of the log event */
    constructor public LogEvent(input poLevel as LogLevelEnum, 
                                input poMessage as LogMessage,
                                input poError as Progress.Lang.Error,
                                input ptTimeStamp as datetime-tz):
        this-object(poLevel, poMessage, poError).
        
        assign this-object:TimeStamp = ptTimeStamp.
    end constructor.

    /* Constructor
       
       @param LogLevelEnum The level this log event was at
       @param LogMessage The message to log
       @param datetime-tz The timestamp of the log event */
    constructor public LogEvent(input poLevel as LogLevelEnum,
                                input poMessage as LogMessage,
                                input ptTimeStamp as datetime-tz):
        this-object(poLevel, poMessage).
        
        assign this-object:TimeStamp = ptTimeStamp.
    end constructor.
    
    /* Constructor
       
       @param LogLevelEnum The level this log event was at
       @param LogMessage The message to log
       @param P.L.Error The error being logged */
    constructor public LogEvent(input poLevel as LogLevelEnum,
                                input poMessage as LogMessage,
                                input poError as Progress.Lang.Error):
        this-object(poLevel, poMessage).
        
        assign this-object:Error = poError.
    end constructor.
                                        
    /* Constructor
       
       @param LogLevelEnum The level this log event was at
       @param LogMessage The message to log */
    constructor public LogEvent(input poLevel as LogLevelEnum,
                                input poMessage as LogMessage):
        if not valid-object(poMessage) then
            assign poMessage = new LogMessage('':u, '':u).
            
        if not valid-object(poLevel) then
            assign poLevel = LogLevelEnum:DEFAULT.
        
        assign this-object:Message   = poMessage
               this-object:TimeStamp = now
               this-object:LogLevel  = poLevel
               .
        if this-object:LogLevel ge LogLevelEnum:DEBUG then
            BuildStack().
    end constructor.
    
    /* Builds the calls stack of the log event */
    method private character extent BuildStack():
        define variable iMax as integer no-undo.
        define variable iLoop as integer no-undo.
        define variable cStack as character no-undo.
        define variable cDelim as character no-undo.
        define variable cProgName as character no-undo.
        
        assign cDelim = '':u
               iLoop  = 1
               .
        do while program-name(iLoop) ne ?:
            assign cProgName = program-name(iLoop)
                   iLoop     = iLoop + 1
                   .
            // don't add the logging infrastructure to the log stack
            if num-entries(cProgName, StringConstant:SPACE) ge 2 then 
            case entry(2, cProgName, StringConstant:SPACE):
                when get-class(OpenEdge.Logging.Logger):TypeName or
                when this-object:GetClass():TypeName then
                    next.
            end case.
            
            assign cStack = cStack + cDelim + cProgName
                   cDelim = StringConstant:LF. 
        end.
        
        assign iMax              = num-entries(cStack, cDelim)
               extent(CallStack) = iMax
               .
        do iLoop = 1 to iMax:
            assign CallStack[iLoop] = entry(iLoop, cStack, StringConstant:LF).
        end.
    end method.
    
end class.
