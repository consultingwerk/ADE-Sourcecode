/************************************************
Copyright (c) 2016-2018, 2021 by Progress Software Corporation. All rights reserved.
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
    define public property LoggerName as character no-undo get. set.
    
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
    
    /* (optional) The short-name of the logger logging this event. The short name is the logger name */
    define public property LoggerShortName as character no-undo get. set.
    
    /* (optional) The short-name-format of the logger logging this event */
    define public property ShortNameFormat as character no-undo get. set.
    
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
        BuildStack().
    end constructor.
    
    /* Destructor */
    destructor public LogEvent():
        if valid-handle(this-object:LoggedBy) then
            delete object this-object:LoggedBy no-error.
    end destructor.
    
    /* Builds the calls stack of the log event */
    method private void BuildStack():
        define variable iMax as integer no-undo.
        define variable iLoop as integer no-undo.
        define variable cStack as character no-undo.
        define variable cDelim as character no-undo.
        define variable cProgName as character no-undo.
        
        // we want the line that did the logging. If -debugalert is set, always show
        if not session:debug-alert
           and this-object:LogLevel lt LogLevelEnum:DEBUG
           then
            assign iMax = 1.
        
        assign cDelim = '':u
               iLoop  = 1
               .
        CALLING-LOOP:
        do while program-name(iLoop) ne ?:
            assign cProgName = program-name(iLoop)
                   iLoop     = iLoop + 1
                   .
            // don't add the logging infrastructure to the log stack
            if     num-entries(cProgName, StringConstant:SPACE) ge 2
               and entry(2, cProgName, StringConstant:SPACE) begins 'OpenEdge.Logging.':u
            then
                next CALLING-LOOP.
            
            assign cStack = cStack + cDelim + cProgName
                   cDelim = StringConstant:LF.
            if iMax eq 1 then
                leave CALLING-LOOP.
        end.
        
        if iMax eq 0 then
            assign iMax = num-entries(cStack, cDelim).
        
        assign extent(CallStack) = iMax.
        do iLoop = 1 to iMax:
            assign CallStack[iLoop] = entry(iLoop, cStack, StringConstant:LF).
        end.
    end method.
    
end class.
