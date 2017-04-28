/* *************************************************************************************************************************
Copyright (c) 2016-2017 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : Logger
    Purpose     : Public logger implementation
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-11-10
    Notes       : * This implementation is the only implementation of the ILogWriter.
                    It acts as a facade to a ILoggerImplementation which may be
                    a single type or a facade/decorator or filter chain.
                  * We don't want to throw any errors except from the constructor
  ----------------------------------------------------------------------*/
// NO THROW EVAH
//block-level on error undo, throw.

using OpenEdge.Logging.Filter.LoggerFilterList.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.LogEvent.
using OpenEdge.Logging.LogLevelEnum.
using OpenEdge.Logging.LogMessage.
using OpenEdge.Logging.Logger.

class OpenEdge.Logging.Logger final implements ILogWriter:
    // (mandatory) Holds filters for formatting the messagesto this logger
    define private variable moLogFilters as LoggerFilterList no-undo.
    
    // (mandatory) The level being logged at
    define public property LogLevel as LogLevelEnum no-undo get. private set. 
        
    // (mandatory) Name for this logger
    define public property Name as character no-undo get. private set.
        
    /* Constructor
           
       @param character The name of this logger implementation
       @param LogLevelEnum The level we're logging at
       @param LoggerFilterList A list of filters to format and write the log data */
    constructor public Logger(input pcName as character,
                              input poLevel as LogLevelEnum,
                              input poLogFilters as LoggerFilterList):
        if not valid-object(poLevel) then
            assign poLevel = LogLevelEnum:DEFAULT.
        
        assign this-object:Name = pcName
               moLogFilters = poLogFilters
               this-object:LogLevel = poLevel
               .
    end constructor.
    
/** FATAL **/
    /* Log for a simple message 
       
       @param character The message to log. */
    method public void Fatal(input pcMessage as character):
        if this-object:LogLevel lt LogLevelEnum:FATAL then
            return.
        
        WriteMessage(LogLevelEnum:FATAL, new LogMessage(this-object:Name, pcMessage), ?).
    end method.
    
    /* Log for a group and a simple message
        
       @param character The message group for this message 
       @param character The message to log. */    
    method public void Fatal(input pcMessageGroup as character,
                             input pcMessage as character):
        if this-object:LogLevel lt LogLevelEnum:FATAL then
            return.
        
        WriteMessage(LogLevelEnum:FATAL, new LogMessage( pcMessageGroup, pcMessage), ?).
    end method.
    
    /* Log for a simple message 
       
       @param LogMessage The message to log. */
    method public void Fatal(input poMessage as LogMessage):
        if this-object:LogLevel lt LogLevelEnum:FATAL then
            return.
        
        WriteMessage(LogLevelEnum:FATAL, poMessage, ?).
    end method.
        
    /* Log for a group and a simple message
        
       @param character The message group for this message 
       @param character The message to log. 
       @param Progress.Lang.Error An error to log */
    method public void Fatal(input pcMessageGroup as character,
                             input pcMessage as character,
                             input poError as Progress.Lang.Error):
        if this-object:LogLevel lt LogLevelEnum:FATAL then
            return.
        
        WriteMessage(LogLevelEnum:FATAL, new LogMessage(pcMessageGroup, pcMessage), poError).
    end method.

    /* Log for a message and error
       
       @param LogMessage The message to log. 
       @param Progress.Lang.Error An error to log */    
    method public void Fatal(input poMessage as LogMessage,
                             input poError as Progress.Lang.Error):
        if this-object:LogLevel lt LogLevelEnum:FATAL then
            return.
        
        WriteMessage(LogLevelEnum:FATAL, poMessage, poError).
    end method.

    /* Log for a simple message 
       
       @param character The message to log. 
       @param Progress.Lang.Error An error to log */
    method public void Fatal(input pcMessage as character,
                             input poError as Progress.Lang.Error):
        if this-object:LogLevel lt LogLevelEnum:FATAL then
            return.
        
        WriteMessage(LogLevelEnum:FATAL, new LogMessage(this-object:Name, pcMessage), poError).
    end method.

/** ERROR **/
    /* Log for a simple message 
       
       @param character The message to log. */
    method public void Error(input pcMessage as character):
        if this-object:LogLevel lt LogLevelEnum:ERROR then
            return.
            
        WriteMessage(LogLevelEnum:ERROR, new LogMessage(this-object:Name, pcMessage), ?).
    end method.
    
    /* Log for a group and a simple message
        
       @param character The message group for this message 
       @param character The message to log. */    
    method public void Error(input pcMessageGroup as character,
                             input pcMessage as character):
        if this-object:LogLevel lt LogLevelEnum:ERROR then
            return.
            
        WriteMessage(LogLevelEnum:ERROR, new LogMessage(pcMessageGroup, pcMessage), ?).
    end method.
    
    /* Log for a simple message 
       
       @param LogMessage The message to log. */
    method public void Error(input poMessage as LogMessage):
        if this-object:LogLevel lt LogLevelEnum:ERROR then
            return.
        
        WriteMessage(LogLevelEnum:ERROR, poMessage, ?).
    end method.
    
    /* Log for a group and a simple message
        
       @param character The message group for this message 
       @param character The message to log. 
       @param Progress.Lang.Error An error to log */
    method public void Error(input pcMessageGroup as character,
                             input pcMessage as character,
                             input poError as Progress.Lang.Error):
        if this-object:LogLevel lt LogLevelEnum:ERROR then
            return.
        
        WriteMessage(LogLevelEnum:ERROR, new LogMessage(pcMessageGroup, pcMessage), poError).
    end method.

    /* Log for a message and error
       
       @param LogMessage The message to log. 
       @param Progress.Lang.Error An error to log */    
    method public void Error(input poMessage as LogMessage,
                             input poError as Progress.Lang.Error):
        if this-object:LogLevel lt LogLevelEnum:ERROR then
            return.
        
        WriteMessage(LogLevelEnum:ERROR, poMessage, poError).
    end method.

    /* Log for a simple message 
       
       @param character The message to log. 
       @param Progress.Lang.Error An error to log */
    method public void Error(input pcMessage as character,
                             input poError as Progress.Lang.Error):
        if this-object:LogLevel lt LogLevelEnum:ERROR then
            return.
        
        WriteMessage(LogLevelEnum:ERROR, new LogMessage(this-object:Name, pcMessage), poError).
    end method.

/** WARN **/
    /* Log for a simple message 
       
       @param character The message to log. */
    method public void Warn(input pcMessage as character):
        if this-object:LogLevel lt LogLevelEnum:WARN then
            return.
            
        WriteMessage(LogLevelEnum:WARN, new LogMessage(this-object:Name, pcMessage), ?).
    end method.
    
    /* Log for a group and a simple message
        
       @param character The message group for this message 
       @param character The message to log. */    
    method public void Warn(input pcMessageGroup as character,
                             input pcMessage as character):
        if this-object:LogLevel lt LogLevelEnum:WARN then
            return.
        
        WriteMessage(LogLevelEnum:WARN, new LogMessage(pcMessageGroup, pcMessage), ?).
    end method.
    
    /* Log for a simple message 
       
       @param LogMessage The message to log. */
    method public void Warn(input poMessage as LogMessage):
        if this-object:LogLevel lt LogLevelEnum:WARN then
            return.
        
        WriteMessage(LogLevelEnum:WARN, poMessage, ?).
    end method.

    /* Log for a group and a simple message
        
       @param character The message group for this message 
       @param character The message to log. 
       @param Progress.Lang.Error An error to log */
    method public void Warn(input pcMessageGroup as character,
                            input pcMessage as character,
                            input poError as Progress.Lang.Error):
        if this-object:LogLevel lt LogLevelEnum:WARN then
            return.
        
        WriteMessage(LogLevelEnum:WARN, new LogMessage(pcMessageGroup, pcMessage), poError).
    end method.

    /* Log for a message and error
       
       @param LogMessage The message to log. 
       @param Progress.Lang.Error An error to log */    
    method public void Warn(input poMessage as LogMessage,
                            input poError as Progress.Lang.Error):
        if this-object:LogLevel lt LogLevelEnum:WARN then
            return.
        
        WriteMessage(LogLevelEnum:WARN, poMessage, poError).
    end method.

    /* Log for a simple message 
       
       @param character The message to log. 
       @param Progress.Lang.Error An error to log */
    method public void Warn(input pcMessage as character,
                            input poError as Progress.Lang.Error):
        if this-object:LogLevel lt LogLevelEnum:WARN then
            return.
        
        WriteMessage(LogLevelEnum:WARN, new LogMessage(this-object:Name, pcMessage), poError).
    end method.

/** INFO **/
    /* Log for a simple message 
       
       @param character The message to log. */
    method public void Info(input pcMessage as character):
        if this-object:LogLevel lt LogLevelEnum:INFO then
            return.
            
        WriteMessage(LogLevelEnum:INFO, new LogMessage(this-object:Name, pcMessage), ?).
    end method.
    
    /* Log for a group and a simple message
        
       @param character The message group for this message 
       @param character The message to log. */    
    method public void Info(input pcMessageGroup as character,
                             input pcMessage as character):
        if this-object:LogLevel lt LogLevelEnum:INFO then
            return.
            
        WriteMessage(LogLevelEnum:INFO, new LogMessage(pcMessageGroup, pcMessage), ?).
    end method.
    
    /* Log for a simple message 
       
       @param LogMessage The message to log. */
    method public void Info(input poMessage as LogMessage):
        if this-object:LogLevel lt LogLevelEnum:INFO then
            return.
        
        WriteMessage(LogLevelEnum:INFO, poMessage, ?).
    end method.
    
    /* Log for a group and a simple message
        
       @param character The message group for this message 
       @param character The message to log. 
       @param Progress.Lang.Error An error to log */
    method public void Info(input pcMessageGroup as character,
                            input pcMessage as character,
                            input poError as Progress.Lang.Error):
        if this-object:LogLevel lt LogLevelEnum:INFO then
            return.
        
        WriteMessage(LogLevelEnum:INFO, new LogMessage(pcMessageGroup, pcMessage), poError).
    end method.

    /* Log for a message and error
       
       @param LogMessage The message to log. 
       @param Progress.Lang.Error An error to log */    
    method public void Info(input poMessage as LogMessage,
                             input poError as Progress.Lang.Error):
        if this-object:LogLevel lt LogLevelEnum:INFO then
            return.
        
        WriteMessage(LogLevelEnum:INFO, poMessage, poError).
    end method.

    /* Log for a simple message 
       
       @param character The message to log. 
       @param Progress.Lang.Error An error to log */
    method public void Info(input pcMessage as character,
                            input poError as Progress.Lang.Error):
        if this-object:LogLevel lt LogLevelEnum:INFO then
            return.
        
        WriteMessage(LogLevelEnum:INFO, new LogMessage(this-object:Name, pcMessage), poError).
    end method.
    
/** DEBUG **/
    /* Log for a simple message 
       
       @param character The message to log. */
    method public void Debug(input pcMessage as character):
        if this-object:LogLevel lt LogLevelEnum:DEBUG then
            return.
            
        WriteMessage(LogLevelEnum:DEBUG, new LogMessage(this-object:Name, pcMessage), ?).
    end method.
    
    /* Log for a group and a simple message
        
       @param character The message group for this message 
       @param character The message to log. */    
    method public void Debug(input pcMessageGroup as character,
                             input pcMessage as character):
        if this-object:LogLevel lt LogLevelEnum:DEBUG then
            return.
            
        WriteMessage(LogLevelEnum:DEBUG, new LogMessage(pcMessageGroup, pcMessage), ?).
    end method.
    
    /* Log for a simple message 
       
       @param LogMessage The message to log. */
    method public void Debug(input poMessage as LogMessage):
        if this-object:LogLevel lt LogLevelEnum:DEBUG then
            return.
        
        WriteMessage(LogLevelEnum:DEBUG, poMessage, ?).
    end method.

    /* Log for a group and a simple message
        
       @param character The message group for this message 
       @param character The message to log. 
       @param Progress.Lang.Error An error to log */
    method public void Debug(input pcMessageGroup as character,
                             input pcMessage as character,
                             input poError as Progress.Lang.Error):
        if this-object:LogLevel lt LogLevelEnum:DEBUG then
            return.
        
        WriteMessage(LogLevelEnum:DEBUG, new LogMessage(pcMessageGroup, pcMessage), poError).
    end method.

    /* Log for a message and error
       
       @param LogMessage The message to log. 
       @param Progress.Lang.Error An error to log */    
    method public void Debug(input poMessage as LogMessage,
                             input poError as Progress.Lang.Error):
        if this-object:LogLevel lt LogLevelEnum:DEBUG then
            return.
        
        WriteMessage(LogLevelEnum:DEBUG, poMessage, poError).
    end method.
               
    /* Log for a simple message 
       
       @param character The message to log. 
       @param Progress.Lang.Error An error to log */
    method public void Debug(input pcMessage as character,
                             input poError as Progress.Lang.Error):
        if this-object:LogLevel lt LogLevelEnum:DEBUG then
            return.
        
        WriteMessage(LogLevelEnum:DEBUG, new LogMessage(this-object:Name, pcMessage), poError).
    end method.

/** TRACE **/
    /* Log for a simple message 
       
       @param character The message to log. */
    method public void Trace(input pcMessage as character):
        if this-object:LogLevel lt LogLevelEnum:TRACE then
            return.
       
        WriteMessage(LogLevelEnum:TRACE, new LogMessage(this-object:Name, pcMessage), ?).
    end method.
    
    /* Log for a group and a simple message
        
       @param character The message group for this message 
       @param character The message to log. */    
    method public void Trace(input pcMessageGroup as character,
                             input pcMessage as character):
        if this-object:LogLevel lt LogLevelEnum:TRACE then
            return.
        
        WriteMessage(LogLevelEnum:TRACE, new LogMessage(pcMessageGroup, pcMessage), ?).
    end method.
    
       /* Log for a simple message 
       
       @param LogMessage The message to log. */
    method public void Trace(input poMessage as LogMessage):
        if this-object:LogLevel lt LogLevelEnum:TRACE then
            return.
        
        WriteMessage(LogLevelEnum:TRACE, poMessage, ?).
    end method.
    
    /* Log for a group and a simple message
        
       @param character The message group for this message 
       @param character The message to log. 
       @param Progress.Lang.Error An error to log */
    method public void Trace(input pcMessageGroup as character,
                             input pcMessage as character,
                             input poError as Progress.Lang.Error):
        if this-object:LogLevel lt LogLevelEnum:TRACE then
            return.
        
        WriteMessage(LogLevelEnum:TRACE, new LogMessage(pcMessageGroup, pcMessage), poError).
    end method.

    /* Log for a message and error
       
       @param LogMessage The message to log. 
       @param Progress.Lang.Error An error to log */    
    method public void Trace(input poMessage as LogMessage,
                             input poError as Progress.Lang.Error):
        if this-object:LogLevel lt LogLevelEnum:TRACE then
            return.
        
        WriteMessage(LogLevelEnum:TRACE, poMessage, poError).
    end method.

    /* Log for a simple message 
       
       @param character The message to log. 
       @param Progress.Lang.Error An error to log */
    method public void Trace(input pcMessage as character,
                             input poError as Progress.Lang.Error):
        if this-object:LogLevel lt LogLevelEnum:TRACE then
            return.
        
        WriteMessage(LogLevelEnum:TRACE, new LogMessage(this-object:Name, pcMessage), poError).
    end method.
    
    /* Writes a log message
       
       @param LogMessage the message to be written */
    method private void WriteMessage(input poLogLevel as LogLevelEnum,
                                     input poMessage as LogMessage,
                                     input poError as Progress.Lang.Error):
        define variable oEvent as LogEvent no-undo.
        
        if valid-object(poError) then
            assign oEvent = new LogEvent(poLogLevel, poMessage, poError, now).
        else
            assign oEvent = new LogEvent(poLogLevel, poMessage, now).
        
        assign oEvent:Logger   = this-object
               oEvent:LoggedBy = security-policy:get-client()
               .
        moLogFilters:ExecuteFilter(oEvent).
        
        catch oError as Progress.Lang.Error :
            // CATCH & SWALLOW. we can't have an error being logged so, yeah
        end catch.
    end method.

    /* Compares two instances
       
       Loggers are equal iff
       - they have the same obejct reference ('handle'), or
       - they are both instances of OpenEdge.Logging.Logger and
         the Name property value is identical on both (= match)
       
       @param P.L.Object
       @return logical TRUE if these are the same logger object */
    method override public logical Equals( input poRef as Progress.Lang.Object ):
        if super:Equals(poRef) then
          return true.
          
        if not type-of(poRef, Logger) then
            return false.
            
        return (cast(poRef, Logger):Name eq this-object:Name).             
    end method.
    
end class.