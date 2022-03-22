/* *************************************************************************************************************************
Copyright (c) 2016, 2021 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : VoidLogger
    Purpose     : Empty/null logger. Does nothing.
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2016-12-05
    Notes       :
  ----------------------------------------------------------------------*/
// NO THROW EVAH
//block-level on error undo, throw.

using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.LogLevelEnum.
using OpenEdge.Logging.LogMessage.
using OpenEdge.Logging.VoidLogger.
using OpenEdge.Core.Assert.

class OpenEdge.Logging.VoidLogger final implements ILogWriter:
    // (mandatory) The level being logged at
    define public property LogLevel as LogLevelEnum no-undo get. private set.
    
    // (mandatory) Name for this logger
    define public property Name as character no-undo get. private set.
    
    /* Constructor
           
       @param character The name of this logger implementation */
    constructor public VoidLogger(input pcName as character):
        Assert:NotNull(pcName, 'Logger name').
        
        assign this-object:Name     = pcName
               this-object:LogLevel = LogLevelEnum:OFF
               .
    end constructor.
    
/** FATAL **/
    /* Log for a simple message
       
       @param character The message to log. */
    method public void Fatal(input pcMessage as character):
        // Message sink, so no-op
    end method.
    
    /* Log for a group and a simple message
        
       @param character The message group for this message
       @param character The message to log. */
    method public void Fatal(input pcMessageGroup as character, input pcMessage as character):
        // Message sink, so no-op
    end method.
    
    /* Log for a simple message
       
       @param LogMessage The message to log. */
    method public void Fatal(input poMessage as LogMessage):
        // Message sink, so no-op
    end method.
        
    /* Log for a group and a simple message
        
       @param character The message group for this message
       @param character The message to log.
       @param Progress.Lang.Error An error to log */
    method public void Fatal(input pcMessageGroup as character, input pcMessage as character, input poError as Progress.Lang.Error):
        // Message sink, so no-op
    end method.

    /* Log for a message and error
       
       @param LogMessage The message to log.
       @param Progress.Lang.Error An error to log */
    method public void Fatal(input poMessage as LogMessage, input poError as Progress.Lang.Error):
        // Message sink, so no-op
    end method.

    /* Log for a simple message
       
       @param character The message to log.
       @param Progress.Lang.Error An error to log */
    method public void Fatal(input pcMessage as character, input poError as Progress.Lang.Error):
        // Message sink, so no-op
    end method.

/** ERROR **/
    /* Log for a simple message
       
       @param character The message to log. */
    method public void Error(input pcMessage as character):
        // Message sink, so no-op
    end method.
    
    /* Log for a group and a simple message
        
       @param character The message group for this message
       @param character The message to log. */
    method public void Error(input pcMessageGroup as character, input pcMessage as character):
        // Message sink, so no-op
    end method.
    
    /* Log for a simple message
       
       @param LogMessage The message to log. */
    method public void Error(input poMessage as LogMessage):
        // Message sink, so no-op
    end method.
    
    /* Log for a group and a simple message
        
       @param character The message group for this message
       @param character The message to log.
       @param Progress.Lang.Error An error to log */
    method public void Error(input pcMessageGroup as character, input pcMessage as character, input poError as Progress.Lang.Error):
        // Message sink, so no-op
    end method.

    /* Log for a message and error
       
       @param LogMessage The message to log.
       @param Progress.Lang.Error An error to log */
    method public void Error(input poMessage as LogMessage, input poError as Progress.Lang.Error):
        // Message sink, so no-op
    end method.

    /* Log for a simple message
       
       @param character The message to log.
       @param Progress.Lang.Error An error to log */
    method public void Error(input pcMessage as character, input poError as Progress.Lang.Error):
        // Message sink, so no-op
    end method.

/** WARN **/
    /* Log for a simple message
       
       @param character The message to log. */
    method public void Warn(input pcMessage as character):
        // Message sink, so no-op
    end method.
    
    /* Log for a group and a simple message
        
       @param character The message group for this message
       @param character The message to log. */
    method public void Warn(input pcMessageGroup as character, input pcMessage as character):
        // Message sink, so no-op
    end method.
    
    /* Log for a simple message
       
       @param LogMessage The message to log. */
    method public void Warn(input poMessage as LogMessage):
        // Message sink, so no-op
    end method.

    /* Log for a group and a simple message
        
       @param character The message group for this message
       @param character The message to log.
       @param Progress.Lang.Error An error to log */
    method public void Warn(input pcMessageGroup as character, input pcMessage as character, input poError as Progress.Lang.Error):
        // Message sink, so no-op
    end method.

    /* Log for a message and error
       
       @param LogMessage The message to log.
       @param Progress.Lang.Error An error to log */
    method public void Warn(input poMessage as LogMessage, input poError as Progress.Lang.Error):
        // Message sink, so no-op
    end method.

    /* Log for a simple message
       
       @param character The message to log.
       @param Progress.Lang.Error An error to log */
    method public void Warn(input pcMessage as character, input poError as Progress.Lang.Error):
        // Message sink, so no-op
    end method.

/** INFO **/
    /* Log for a simple message
       
       @param character The message to log. */
    method public void Info(input pcMessage as character):
        // Message sink, so no-op
    end method.
    
    /* Log for a group and a simple message
        
       @param character The message group for this message
       @param character The message to log. */
    method public void Info(input pcMessageGroup as character, input pcMessage as character):
        // Message sink, so no-op
    end method.
    
    /* Log for a simple message
       
       @param LogMessage The message to log. */
    method public void Info(input poMessage as LogMessage):
        // Message sink, so no-op
    end method.
    
    /* Log for a group and a simple message
        
       @param character The message group for this message
       @param character The message to log.
       @param Progress.Lang.Error An error to log */
    method public void Info(input pcMessageGroup as character, input pcMessage as character, input poError as Progress.Lang.Error):
        // Message sink, so no-op
    end method.

    /* Log for a message and error
       
       @param LogMessage The message to log.
       @param Progress.Lang.Error An error to log */
    method public void Info(input poMessage as LogMessage, input poError as Progress.Lang.Error):
        // Message sink, so no-op
    end method.

    /* Log for a simple message
       
       @param character The message to log.
       @param Progress.Lang.Error An error to log */
    method public void Info(input pcMessage as character, input poError as Progress.Lang.Error):
        // Message sink, so no-op
    end method.
    
/** DEBUG **/
    /* Log for a simple message
       
       @param character The message to log. */
    method public void Debug(input pcMessage as character):
        // Message sink, so no-op
    end method.
    
    /* Log for a group and a simple message
        
       @param character The message group for this message
       @param character The message to log. */
    method public void Debug(input pcMessageGroup as character, input pcMessage as character):
        // Message sink, so no-op
    end method.
    
    /* Log for a simple message
       
       @param LogMessage The message to log. */
    method public void Debug(input poMessage as LogMessage):
        // Message sink, so no-op
    end method.

    /* Log for a group and a simple message
        
       @param character The message group for this message
       @param character The message to log.
       @param Progress.Lang.Error An error to log */
    method public void Debug(input pcMessageGroup as character, input pcMessage as character, input poError as Progress.Lang.Error):
        // Message sink, so no-op
    end method.

    /* Log for a message and error
       
       @param LogMessage The message to log.
       @param Progress.Lang.Error An error to log */
    method public void Debug(input poMessage as LogMessage, input poError as Progress.Lang.Error):
        // Message sink, so no-op
    end method.
               
    /* Log for a simple message
       
       @param character The message to log.
       @param Progress.Lang.Error An error to log */
    method public void Debug(input pcMessage as character, input poError as Progress.Lang.Error):
        // Message sink, so no-op
    end method.

/** TRACE **/
    /* Log for a simple message
       
       @param character The message to log. */
    method public void Trace(input pcMessage as character):
        // Message sink, so no-op
    end method.
    
    /* Log for a group and a simple message
        
       @param character The message group for this message
       @param character The message to log. */
    method public void Trace(input pcMessageGroup as character, input pcMessage as character):
        // Message sink, so no-op
    end method.
    
       /* Log for a simple message
       
       @param LogMessage The message to log. */
    method public void Trace(input poMessage as LogMessage):
        // Message sink, so no-op
    end method.
    
    /* Log for a group and a simple message
        
       @param character The message group for this message
       @param character The message to log.
       @param Progress.Lang.Error An error to log */
    method public void Trace(input pcMessageGroup as character, input pcMessage as character, input poError as Progress.Lang.Error):
        // Message sink, so no-op
    end method.

    /* Log for a message and error
       
       @param LogMessage The message to log.
       @param Progress.Lang.Error An error to log */
    method public void Trace(input poMessage as LogMessage, input poError as Progress.Lang.Error):
        // Message sink, so no-op
    end method.

    /* Log for a simple message
       
       @param character The message to log.
       @param Progress.Lang.Error An error to log */
    method public void Trace(input pcMessage as character, input poError as Progress.Lang.Error):
        // Message sink, so no-op
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
        
        if not type-of(poRef, VoidLogger) then
            return false.
        
        return (cast(poRef, VoidLogger):Name eq this-object:Name).
    end method.
    
end class.
