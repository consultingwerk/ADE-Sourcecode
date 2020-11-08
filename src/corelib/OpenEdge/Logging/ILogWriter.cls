/************************************************
Copyright (c) 2016, 2019-2020 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : ILogWriter
    Purpose     : Interface for loggers (log writers)
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Jun 07 16:09:44 EDT 2016
    Notes       : * Based on the slf4j.org Logger interface 
                    www.slf4j.org/api/org/slf4j/Logger.html
  ----------------------------------------------------------------------*/

using OpenEdge.Logging.LogLevelEnum.
using OpenEdge.Logging.LogMessage.

interface OpenEdge.Logging.ILogWriter:
    // (mandatory) Name for this logger
    define public property Name as character no-undo get.
    
    // (mandatory) The level being logged at
    define public property LogLevel as LogLevelEnum no-undo get.
    
/** FATAL **/
    /* Log for a simple message 
       
       @param character The message to log. */
    method public void Fatal(input pcMessage as character).
    
    /* Log for a group and a simple message
        
       @param character The message group for this message 
       @param character The message to log. */    
    method public void Fatal(input pcMessageGroup as character,
                             input pcMessage as character).
    
    /* Log for a simple message 
       
       @param LogMessage The message to log. */
    method public void Fatal(input poMessage as LogMessage).

    /* Log for a group and a simple message
        
       @param character The message group for this message 
       @param character The message to log. 
       @param Progress.Lang.Error An error to log */
    method public void Fatal(input pcMessageGroup as character,
                             input pcMessage as character,
                             input poError as Progress.Lang.Error).

    /* Log for a message and error
       
       @param LogMessage The message to log. 
       @param Progress.Lang.Error An error to log */    
    method public void Fatal(input poMessage as LogMessage,
                             input poError as Progress.Lang.Error).
    
    /* Log for a simple message 
       
       @param character The message to log. 
       @param Progress.Lang.Error An error to log */
    method public void Fatal(input pcMessage as character,
                             input poError as Progress.Lang.Error).
    
/** ERROR **/
    /* Log for a simple message 
       
       @param character The message to log. */
    method public void Error(input pcMessage as character).
    
    /* Log for a group and a simple message
        
       @param character The message group for this message 
       @param character The message to log. */    
    method public void Error(input pcMessageGroup as character,
                             input pcMessage as character).

    /* Log for a simple message 
       
       @param LogMessage The message to log. */
    method public void Error(input poMessage as LogMessage).

    /* Log for a group and a simple message
        
       @param character The message group for this message 
       @param character The message to log. 
       @param Progress.Lang.Error An error to log */
    method public void Error(input pcMessageGroup as character,
                             input pcMessage as character,
                             input poError as Progress.Lang.Error).

    /* Log for a message and error
       
       @param LogMessage The message to log. 
       @param Progress.Lang.Error An error to log */    
    method public void Error(input poMessage as LogMessage,
                             input poError as Progress.Lang.Error).
    
    /* Log for a simple message 
       
       @param character The message to log. 
       @param Progress.Lang.Error An error to log */
    method public void Error(input pcMessage as character,
                             input poError as Progress.Lang.Error).
    
/** WARN **/
    /* Log for a simple message 
       
       @param character The message to log. */
    method public void Warn(input pcMessage as character).
    
    /* Log for a group and a simple message
        
       @param character The message group for this message 
       @param character The message to log. */    
    method public void Warn(input pcMessageGroup as character,
                            input pcMessage as character).
    
    /* Log for a simple message 
       
       @param LogMessage The message to log. */
    method public void Warn(input poMessage as LogMessage).
        
    /* Log for a group and a simple message
        
       @param character The message group for this message 
       @param character The message to log. 
       @param Progress.Lang.Error An error to log */
    method public void Warn(input pcMessageGroup as character,
                            input pcMessage as character,
                            input poError as Progress.Lang.Error).

    /* Log for a message and error
       
       @param LogMessage The message to log. 
       @param Progress.Lang.Error An error to log */    
    method public void Warn(input poMessage as LogMessage,
                            input poError as Progress.Lang.Error).

    /* Log for a simple message 
       
       @param character The message to log. 
       @param Progress.Lang.Error An error to log */
    method public void Warn(input pcMessage as character,
                            input poError as Progress.Lang.Error).
    
/** INFO **/
    /* Log for a simple message 
       
       @param character The message to log. */
    method public void Info(input pcMessage as character).
    
    /* Log for a group and a simple message
        
       @param character The message group for this message 
       @param character The message to log. */    
    method public void Info(input pcMessageGroup as character,
                            input pcMessage as character).
    
    /* Log for a simple message 
       
       @param LogMessage The message to log. */
    method public void Info(input poMessage as LogMessage).
        
    /* Log for a group and a simple message
        
       @param character The message group for this message 
       @param character The message to log. 
       @param Progress.Lang.Error An error to log */
    method public void Info(input pcMessageGroup as character,
                            input pcMessage as character,
                            input poError as Progress.Lang.Error).

    /* Log for a message and error
       
       @param LogMessage The message to log. 
       @param Progress.Lang.Error An error to log */    
    method public void Info(input poMessage as LogMessage,
                            input poError as Progress.Lang.Error).
    
    /* Log for a simple message 
       
       @param character The message to log. 
       @param Progress.Lang.Error An error to log */
    method public void Info(input pcMessage as character,
                            input poError as Progress.Lang.Error).
    
/** DEBUG **/
    /* Log for a simple message 
       
       @param character The message to log. */
    method public void Debug(input pcMessage as character).
    
    /* Log for a group and a simple message
        
       @param character The message group for this message 
       @param character The message to log. */    
    method public void Debug(input pcMessageGroup as character,
                             input pcMessage as character).
    
    /* Log for a simple message 
       
       @param LogMessage The message to log. */
    method public void Debug(input poMessage as LogMessage).

    /* Log for a group and a simple message
        
       @param character The message group for this message 
       @param character The message to log. 
       @param Progress.Lang.Error An error to log */
    method public void Debug(input pcMessageGroup as character,
                             input pcMessage as character,
                             input poError as Progress.Lang.Error).

    /* Log for a message and error
       
       @param LogMessage The message to log. 
       @param Progress.Lang.Error An error to log */    
    method public void Debug(input poMessage as LogMessage,
                             input poError as Progress.Lang.Error).

    /* Log for a simple message 
       
       @param character The message to log. 
       @param Progress.Lang.Error An error to log */
    method public void Debug(input pcMessage as character,
                             input poError as Progress.Lang.Error).
    
/** TRACE **/
    /* Log for a simple message 
       
       @param character The message to log. */
    method public void Trace(input pcMessage as character).
    
    /* Log for a group and a simple message
        
       @param character The message group for this message 
       @param character The message to log. */    
    method public void Trace(input pcMessageGroup as character,
                             input pcMessage as character).

    /* Log for a simple message 
       
       @param LogMessage The message to log. */
    method public void Trace(input poMessage as LogMessage).

    /* Log for a group and a simple message
        
       @param character The message group for this message 
       @param character The message to log. 
       @param Progress.Lang.Error An error to log */
    method public void Trace(input pcMessageGroup as character,
                             input pcMessage as character,
                             input poError as Progress.Lang.Error).


    /* Log for a message and error
       
       @param LogMessage The message to log. 
       @param Progress.Lang.Error An error to log */    
    method public void Trace(input poMessage as LogMessage,
                             input poError as Progress.Lang.Error).

    /* Log for a simple message 
       
       @param character The message to log. 
       @param Progress.Lang.Error An error to log */
    method public void Trace(input pcMessage as character,
                             input poError as Progress.Lang.Error).

end interface.
