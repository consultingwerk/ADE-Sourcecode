/* *************************************************************************************************************************
Copyright (c) 2016-2017, 2019, 2021 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
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

using OpenEdge.Core.Collections.IList.
using OpenEdge.Core.Collections.List.
using OpenEdge.Core.Util.Token.
using OpenEdge.Core.Util.TokenResolver.
using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.Filter.LoggerFilterList.
using OpenEdge.Logging.Filter.LoggerFilterNode.
using OpenEdge.Logging.Format.ISupportFormatting.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.LogEvent.
using OpenEdge.Logging.LogLevelEnum.
using OpenEdge.Logging.LogMessage.
using OpenEdge.Logging.Logger.
using OpenEdge.Logging.LoggerBuilder.
using Progress.Lang.AppError.

class OpenEdge.Logging.Logger final implements ILogWriter, ISupportFormatting:
    // (mandatory) Holds filters for formatting the messagesto this logger
    define public property LogFilters as ILoggerFilter extent no-undo
        get.
        private set.
    
    // (mandatory) The level being logged at
    define public property LogLevel as LogLevelEnum no-undo get. private set.
    
    // (mandatory) Name for this logger
    define public property Name as character no-undo get. private set.
    
    /* (optional) The short-name of this logger. The short name is the
        logger name with the ShortNameFormat applied. This property is a cheat/optimisation
        to prevent having to re-calculate a formatted name */
    define protected property ShortName as character no-undo get. private set.
    
    /* (optional) The short-name-format of the logger logging this event.
       See the TokenResolve class for more detail */
    define public property Format as character no-undo
        get.
        set(input pFormat as character):
            if pFormat ne this-object:Format then
                assign this-object:Format    = pFormat
                       this-object:ShortName = TokenResolver:ResolveName(pFormat, this-object:Name)
                       .
        end set.
    
    /* Constructor
       
       --- USE FOR BACKWARDS COMPATIBILITLY ONLY ---
       
       @param character The name of this logger implementation
       @param LogLevelEnum The level we're logging at
       @param LoggerFilterList A list of filters to format and write the log data */
    constructor public Logger(input pcName as character,
                              input poLevel as LogLevelEnum,
                              input poLogFilters as LoggerFilterList):
        {&_proparse_ prolint-nowarn(varusage)}
        define variable filters as ILoggerFilter extent no-undo.
        define variable list as IList no-undo.
        define variable filterNode as LoggerFilterNode no-undo.
        
        this-object(pcName, poLevel, filters).
        
        assign list       = new List()
               filterNode = poLogFilters:First
               .
        do while valid-object(filterNode):
            list:Add(filterNode:Data).
            assign filterNode = filterNode:Next.
        end.
        
        assign this-object:LogFilters = cast(list:ToArray(), ILoggerFilter).
    end constructor.
    
    /* Constructor
       
       @param character The name of this logger implementation
       @param LogLevelEnum The level we're logging at
       @param LoggerFilterList A list of filters to format and write the log data */
    constructor public Logger(input pcName as character,
                              input poLevel as LogLevelEnum,
                              input poLogFilters as ILoggerFilter extent):
        if not valid-object(poLevel) then
            assign poLevel = LogLevelEnum:DEFAULT.
        
        assign this-object:Name       = pcName
               this-object:Format     = '1C':u
               this-object:LogFilters = poLogFilters
               this-object:LogLevel   = poLevel
               .
    end constructor.
    
/** FATAL **/
    /* Log for a simple message
       
       @param character The message to log. */
    method public void Fatal(input pcMessage as character):
        if this-object:LogLevel lt LogLevelEnum:FATAL then
            return.
        
        WriteMessage(LogLevelEnum:FATAL, new LogMessage(this-object:Name, pcMessage), ?).
        catch err as Progress.Lang.Error:
            WriteError(err).
        end catch.
    end method.
    
    /* Log for a group and a simple message
        
       @param character The message group for this message
       @param character The message to log. */
    method public void Fatal(input pcMessageGroup as character,
                             input pcMessage as character):
        if this-object:LogLevel lt LogLevelEnum:FATAL then
            return.
        
        WriteMessage(LogLevelEnum:FATAL, new LogMessage( pcMessageGroup, pcMessage), ?).
        catch err as Progress.Lang.Error:
            WriteError(err).
        end catch.
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
        catch err as Progress.Lang.Error:
            WriteError(err).
        end catch.
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
        catch err as Progress.Lang.Error:
            WriteError(err).
        end catch.
    end method.

/** ERROR **/
    /* Log for a simple message
       
       @param character The message to log. */
    method public void Error(input pcMessage as character):
        if this-object:LogLevel lt LogLevelEnum:ERROR then
            return.
            
        WriteMessage(LogLevelEnum:ERROR, new LogMessage(this-object:Name, pcMessage), ?).
        catch err as Progress.Lang.Error:
            WriteError(err).
        end catch.
    end method.
    
    /* Log for a group and a simple message
        
       @param character The message group for this message
       @param character The message to log. */
    method public void Error(input pcMessageGroup as character,
                             input pcMessage as character):
        if this-object:LogLevel lt LogLevelEnum:ERROR then
            return.
            
        WriteMessage(LogLevelEnum:ERROR, new LogMessage(pcMessageGroup, pcMessage), ?).
        catch err as Progress.Lang.Error:
            WriteError(err).
        end catch.
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
        catch err as Progress.Lang.Error:
            WriteError(err).
        end catch.
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
        catch err as Progress.Lang.Error:
            WriteError(err).
        end catch.
    end method.
    
/** WARN **/
    /* Log for a simple message
       
       @param character The message to log. */
    method public void Warn(input pcMessage as character):
        if this-object:LogLevel lt LogLevelEnum:WARN then
            return.
            
        WriteMessage(LogLevelEnum:WARN, new LogMessage(this-object:Name, pcMessage), ?).
        catch err as Progress.Lang.Error:
            WriteError(err).
        end catch.
    end method.
    
    /* Log for a group and a simple message
        
       @param character The message group for this message
       @param character The message to log. */
    method public void Warn(input pcMessageGroup as character,
                             input pcMessage as character):
        if this-object:LogLevel lt LogLevelEnum:WARN then
            return.
        
        WriteMessage(LogLevelEnum:WARN, new LogMessage(pcMessageGroup, pcMessage), ?).
        catch err as Progress.Lang.Error:
            WriteError(err).
        end catch.
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
        catch err as Progress.Lang.Error:
            WriteError(err).
        end catch.
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
        catch err as Progress.Lang.Error:
            WriteError(err).
        end catch.
    end method.
    
    /* Log for a group and a simple message
        
       @param character The message group for this message
       @param character The message to log. */
    method public void Info(input pcMessageGroup as character,
                             input pcMessage as character):
        if this-object:LogLevel lt LogLevelEnum:INFO then
            return.
            
        WriteMessage(LogLevelEnum:INFO, new LogMessage(pcMessageGroup, pcMessage), ?).
        catch err as Progress.Lang.Error:
            WriteError(err).
        end catch.
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
        catch err as Progress.Lang.Error:
            WriteError(err).
        end catch.
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
        catch err as Progress.Lang.Error:
            WriteError(err).
        end catch.
    end method.
    
/** DEBUG **/
    /* Log for a simple message
       
       @param character The message to log. */
    method public void Debug(input pcMessage as character):
        if this-object:LogLevel lt LogLevelEnum:DEBUG then
            return.
            
        WriteMessage(LogLevelEnum:DEBUG, new LogMessage(this-object:Name, pcMessage), ?).
        catch err as Progress.Lang.Error:
            WriteError(err).
        end catch.
    end method.
    
    /* Log for a group and a simple message
        
       @param character The message group for this message
       @param character The message to log. */
    method public void Debug(input pcMessageGroup as character,
                             input pcMessage as character):
        if this-object:LogLevel lt LogLevelEnum:DEBUG then
            return.
            
        WriteMessage(LogLevelEnum:DEBUG, new LogMessage(pcMessageGroup, pcMessage), ?).
        catch err as Progress.Lang.Error:
            WriteError(err).
        end catch.
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
        catch err as Progress.Lang.Error:
            WriteError(err).
        end catch.
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
        catch err as Progress.Lang.Error:
            WriteError(err).
        end catch.
    end method.
    
/** TRACE **/
    /* Log for a simple message
       
       @param character The message to log. */
    method public void Trace(input pcMessage as character):
        if this-object:LogLevel lt LogLevelEnum:TRACE then
            return.
       
        WriteMessage(LogLevelEnum:TRACE, new LogMessage(this-object:Name, pcMessage), ?).
        catch err as Progress.Lang.Error:
            WriteError(err).
        end catch.
    end method.
    
    /* Log for a group and a simple message
        
       @param character The message group for this message
       @param character The message to log. */
    method public void Trace(input pcMessageGroup as character,
                             input pcMessage as character):
        if this-object:LogLevel lt LogLevelEnum:TRACE then
            return.
        
        WriteMessage(LogLevelEnum:TRACE, new LogMessage(pcMessageGroup, pcMessage), ?).
        catch err as Progress.Lang.Error:
            WriteError(err).
        end catch.
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
        catch err as Progress.Lang.Error:
            WriteError(err).
        end catch.
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
        catch err as Progress.Lang.Error:
            WriteError(err).
        end catch.
    end method.
    
    /* Writes a log message
       
       @param LogLevelEnum The level at which the message was logged
       @param LogMessage the message to be written
       @param P.L.Error An error, if logged */
    method private void WriteMessage(input poLogLevel as LogLevelEnum,
                                     input poMessage as LogMessage,
                                     input poError as Progress.Lang.Error):
        define variable oEvent as LogEvent no-undo.
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        
        if valid-object(poError) then
            assign oEvent = new LogEvent(poLogLevel, poMessage, poError, now).
        else
            assign oEvent = new LogEvent(poLogLevel, poMessage, now).
        
        assign oEvent:Logger          = this-object
               oEvent:LoggerName      = this-object:Name
               oEvent:ShortNameFormat = this-object:Format
               oEvent:LoggerShortName = this-object:ShortName
               
               oEvent:LoggedBy = security-policy:get-client()
               .
        // Use the LogEvent's Message since we know it exists (the input poMessage may be ?)
        ExtractMessageTokens(oEvent:Message).
        // process the message with the filter chain
        assign cnt = extent(LogFilters).
        do loop = 1 to cnt:
            if valid-object(LogFilters[loop]) then
                LogFilters[loop]:ExecuteFilter(oEvent).
        end.
        
        catch err as Progress.Lang.Error:
            WriteError(err).
        end catch.
    end method.
    
    /* Writes any errors to the LoggerBuilder's log. See LoggerBuilder:LogMessage()
       for details.
       
       @param Progress.Lang.Error An error to be written to the log.    */
    method private void WriteError(input pError as Progress.Lang.Error):
        var character retVal.
        
        if not valid-object(pError) then
            return.
        
        if type-of(pError, AppError) then
        do:
            assign retVal = cast(pError, AppError):ReturnValue.
            
            // Write the error to the loggerbuilder's log
            if retVal eq ?
            or retVal eq '':u
            then
                LoggerBuilder:LogMessage(pError:GetMessage(1), LogLevelEnum:ERROR).
            else
                LoggerBuilder:LogMessage(retVal, LogLevelEnum:ERROR).
        end.    // Apperror
        else
            // Write the error to the loggerbuilder's log
            LoggerBuilder:LogMessage(pError:GetMessage(1), LogLevelEnum:ERROR).
        
    end method.
    
    /* Extracts tokens from the message text and adds them to the message's context.
       
       @param LogMessage The current message to parse */
    method private void ExtractMessageTokens(input pMessage as LogMessage):
        define variable msgTokens as Token extent no-undo.
        define variable ctxTokens as Progress.Lang.Object no-undo.
        
        if not valid-object(pMessage) then
            return.
        
        // extract all the tokens from the message
        assign msgTokens = TokenResolver:Parse(pMessage:Message).
        if extent(msgTokens) eq ? then
            return.
        
        assign ctxTokens = pMessage:GetContext('tokens':u).
        if    not valid-object(ctxTokens)
           or not type-of(ctxTokens, IList)
        then
        do:
            assign ctxTokens = new List().
            pMessage:AddContext('tokens':u, ctxTokens).
        end.
        
        // if there's a list in the event context already, add the message tokens to it, even if the context
        // list is empty
        if type-of(ctxTokens, IList) then
            cast(ctxTokens, IList):AddArray(msgTokens).
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