/************************************************
Copyright (c) 2016-2019 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : LoggerBuilder
    Purpose     : A factory for creating loggers
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Nov 16 21:43:11 EST 2016
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.IList.
using OpenEdge.Core.Collections.List.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Core.KeyValuePair.
using OpenEdge.Core.StringConstant.
using OpenEdge.Core.Util.BuilderRegistry.
using OpenEdge.Core.Util.ConfigBuilder.
using OpenEdge.Logging.ConfigFileLoggerBuilder.
using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.Filter.LogFilterBuilder.
using OpenEdge.Logging.Format.AnonymizedTokenFormat.
using OpenEdge.Logging.Format.MDCTokenFormat.
using OpenEdge.Logging.Format.ResolvedTokenFormat.
using OpenEdge.Logging.Format.TokenContextFormat.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.LogLevelEnum.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Logging.LoggerFilterRegistry.
using OpenEdge.Logging.VoidLogger.
using Progress.Json.ObjectModel.JsonObject.

class OpenEdge.Logging.LoggerBuilder inherits ConfigBuilder:
    /* Private variable with the enum (int64) vaues in the OpenEdge.Logging.LogLevelEnum type. Used
       when we get the default log-manager-based logger */
    define static private variable mLogLevels as character no-undo.
    
    /* Holds the maximum log level in the OpenEdge.Logging.LogLevelEnum type. Used
       when we get the default log-manager-based logger*/
    define static private variable mMaxLogLevel as int64 no-undo.
    
    /* returns a logger instance */
    define public property Logger as ILogWriter no-undo 
        get():
            return GetLoggerInstance(). 
        end get.
    
    /* (mandatory) The logger type that we want to build */ 
    define public property LoggerType as character no-undo get. private set.
    
    /* The name of the default logger to use in the GetLogger() method. */
    define static public property DefaultLogger as character no-undo get. set.
    
    /** Registry for mapping builder types to their implementations
        
        This is the registry of LoggerBuilders */
    define static public property Registry as BuilderRegistry no-undo
        get():
            if not valid-object(LoggerBuilder:Registry) then
            do:
                assign LoggerBuilder:Registry = new BuilderRegistry(get-class(LoggerBuilder)).
                // Use the config file as a default (with a 'name' of *) 
                LoggerBuilder:Registry:Put('*':u, get-class(ConfigFileLoggerBuilder)).
            end.
            
            return LoggerBuilder:Registry.
        end get.
        private set.
    
    /* Static constructor */
    constructor static LoggerBuilder():
        define variable cnt as integer no-undo.
        
        assign mLogLevels    = get-class(LogLevelEnum):GetEnumValues()
               mMaxLogLevel  = 0
               .
        do cnt = num-entries(mLogLevels) to 1 by -1:
            assign mMaxLogLevel = max(mMaxLogLevel, int64(entry(cnt, mLogLevels))).
        end.
    end constructor.
    
    /* Constructor
       
       @param character The logger type being built */
    constructor public LoggerBuilder (input pcLoggerType as character):
        Assert:NotNull(pcLoggerType, 'Logger type').
        assign this-object:LoggerType = pcLoggerType.
    end method.
    
    /** Returns a logger (ILogWriter). 
        
        @param P.L.Class The typename for which to find a logger
        @return ILogWriter An instance of the default logger */
    method static public ILogWriter GetLogger(input poLoggerType as class Progress.Lang.Class):
        Assert:NotNull(poLoggerType, 'Logger type':u).
        
        return LoggerBuilder:Build(poLoggerType:TypeName):Logger.
    end method.
    
    /** Returns a logger (ILogWriter). 
        
        @param handle The procedure for which to find a logger
        @return ILogWriter An instance of the default logger */
    method static public ILogWriter GetLogger(input pLoggerType as handle):
        define variable loggerName as character no-undo.
        
        if    valid-handle(pLoggerType)
           and can-query(pLoggerType, 'FILE-NAME':U)
           then
            assign loggerName = replace(pLoggerType:file-name,'/':u, '.':u)
                   loggerName = replace(loggerName, StringConstant:BACKSLASH, '.':u)
                   loggerName = substring(loggerName, 1, r-index(loggerName, '.':u) - 1)
                   .
        else
            assign loggerName = LoggerBuilder:DefaultLogger.
        
        return LoggerBuilder:Build(loggerName):Logger.
    end method.
    
    /** Returns a logger (ILogWriter)
        
        @param character The logger name 
        @return ILogWriter An instance of the default logger */
    method static public ILogWriter GetLogger(input pcLoggerType as character):
        if pcLoggerType eq '':u or pcLoggerType eq ? then
            assign pcLoggerType = LoggerBuilder:DefaultLogger.
        
        return LoggerBuilder:Build(pcLoggerType):Logger.
    end method.
    
    /* Returns a builder for a logger
        
       @param character The logger type
       @param  BuilderRegistry A registry of Filter writers to user
       @return LoggerBuilder A builder for that logger */
    method static public LoggerBuilder Build(input pcLoggerType as character,
                                             input poBuilders as BuilderRegistry):
        define variable builder as LoggerBuilder no-undo.
        define variable builderType as Progress.Lang.Class no-undo.
        define variable dotPos as integer no-undo.
        define variable searchLogger as character no-undo.
        
        Assert:NotNull(pcLoggerType, 'Logger type').
        if valid-object(poBuilders) then
        do:
            Assert:NotNull(poBuilders, 'Logger builder registry').
            Assert:IsType(poBuilders:ValueType, get-class(LoggerBuilder)).
            
            assign builderType = poBuilders:Get(pcLoggerType).
            if not valid-object(builderType) then
                assign dotPos       = r-index(pcLoggerType, '.':u)
                       searchLogger = pcLoggerType
                       .
            // if there's only one entry then we've checked already    
            do while not valid-object(builderType) and dotPos gt 0:
                assign searchLogger = substring(searchLogger, 1, dotPos - 1)
                       dotPos       = r-index(searchLogger, '.':u)
                       builderType  = poBuilders:Get(searchLogger)
                       .
            end.
            // search for the default '*' value
            if not valid-object(builderType) then
                assign builderType = poBuilders:Get('*':u).
        end.
        
        // default is this class
        if not valid-object(builderType) then
            assign builderType = get-class(LoggerBuilder).
        
        builder = dynamic-new string(builderType:TypeName) (pcLoggerType).
        
        if type-of(builder, ISupportInitialize) then
            cast(builder, ISupportInitialize):Initialize().
        
        return builder.
    end method.
    
    /* Returns a builder for a logger
       
       @param character The logger type
       @return LoggerBuilder A builder for that logger */
    method static public LoggerBuilder Build(input pcLoggerType as character):
        return LoggerBuilder:Build(pcLoggerType, LoggerBuilder:Registry).
    end method.
    
    /* Sets the log level for this logger.
       
       @param  LogLevelEnum the level to log at  
       @return LoggerBuilder This builder object  */
    method public LoggerBuilder LogAt(input poLevel as LogLevelEnum):
        Assert:NotNull(poLevel, 'Log level').
        
        SetOption('logLevel':u, poLevel).
        
        return this-object.
    end method.
    
    /* Adds a filter to the logger being built, with options in Json form 
       
       @param  character The filter name to add
       @param  JsonObject The filter options
       @return LoggerBuilder This builder object  */
    method public LoggerBuilder AddFilter(input pFilterName as character,
                                          input pFilterOptions as JsonObject):
        define variable filterList as IList no-undo.
        
        if HasOption('filters') then
            assign filterList = cast(GetOptionObjectValue('filters'), IList).
        else
        do:
            assign filterList = new List().
            SetOption('filters', filterList). 
        end.
        
        filterList:Add(new KeyValuePair(pFilterName, pFilterOptions)).
        
        return this-object.
    end method.
    
    /* Adds a filter to the logger being built
       
       @param  character The filter name to add
       @return LoggerBuilder This builder object  */
    method public LoggerBuilder AddFilter(input pcFilterName as character):
        return AddFilter(pcFilterName, ?).
    end method.
    
    /* Adds a filter to the logger being built
       
       @param  ILoggerFilter The filter to add  
       @return LoggerBuilder This builder object  */
    method public LoggerBuilder AddFilter(input pFilter as ILoggerFilter):
        define variable filterList as IList no-undo.
        
        Assert:NotNull(pFilter, 'Log Filter').
        
        if HasOption('filters') then
            assign filterList = cast(GetOptionObjectValue('filters'), IList).
        else
        do:
            assign filterList = new List().
            SetOption('filters', filterList). 
        end.
        
        filterList:Add(pFilter).
        
        return this-object.
    end method.
    
    /* Constructs the actual logger instance
       
       @return ILogWriter A new or cached logged */
    method protected ILogWriter GetLoggerInstance():
        define variable logWriter as ILogWriter no-undo.
        define variable logAt as LogLevelEnum no-undo.
        
        // use the specified/configured value first.
        // otherwise use the log-manager's as a default
        if not log-manager:logfile-name eq ? then
        do:
            if not HasOption('logLevel':u) then
            do:
                if log-manager:logging-level gt mMaxLogLevel then
                    assign logAt = LogLevelEnum:GetEnum(mMaxLogLevel).
                else
                if lookup(string(log-manager:logging-level), mLogLevels) gt 0 then
                    assign logAt = LogLevelEnum:GetEnum(log-manager:logging-level).
                else
                    assign logAt = LogLevelEnum:DEFAULT.
                
                LogAt(logAt).
            end.    //log level
            
            // if there are some filters configured, use those,
            // otherwise use the defaults
            if not HasOption('filters':u) then
            do:
                // If the debug-alert flag is set, then write the log stack
                if session:debug-alert then
                    AddFilter(LoggerFilterRegistry:STACK_WRITER_FORMAT).
                
                AddFilter(LoggerFilterRegistry:ERROR_FORMAT).
                
                // resolves any of the standard tokens
                AddFilter(LoggerFilterRegistry:TOKEN_FORMAT).
                // writes any resolved tokens into the message
                AddFilter(LoggerFilterRegistry:REPLACE_TOKENS_FORMAT).
                
                // write to the log-manager
                AddFilter(LoggerFilterRegistry:LOG_MANAGER_FORMAT).
                AddFilter(LoggerFilterRegistry:LOG_MANAGER_WRITER).
            end.    // default filters
        end.    // logmanager enabled
        
        // now try to build a logger from the set of filters 
        assign logWriter = BuildFilterLogger(). 
        
        return logWriter.
        
        catch loadError as Progress.Lang.Error:
            LoggerBuilder:LogMessage(substitute('Error building logger &1 : &2', this-object:LoggerType, loadError:GetMessage(1)),
                                     LogLevelEnum:ERROR).
        end catch.
        finally:
            // if we fail to buld a logger, use the void logger
            if not valid-object(logWriter) then
                return new VoidLogger(this-object:LoggerType).
        end finally.
    end method.
    
    /* Adds JSON configuration for loggers, fitlers and builders
        
       @param  JsonObject The JSON configuration for a logger
       @return LoggerBuilder This builder object  */
    method public LoggerBuilder FromConfig(input pJsonConfig as JsonObject):
        SetOption('logging.config':u, pJsonConfig).
        
        return this-object.
    end method.
    
    /* Creates a default logger based that uses the config in this class
       
       @return ILogWriter A logger */
    method protected ILogWriter BuildFilterLogger():
        define variable filterIdx as integer no-undo.
        define variable filterList as ILoggerFilter extent no-undo.
        define variable filter as ILoggerFilter no-undo.
        define variable logLevel as LogLevelEnum no-undo.
        define variable filterConfig as Progress.Lang.Object no-undo.
        define variable filterData as Progress.Lang.Object no-undo.
        define variable filterIter as IIterator no-undo.
        define variable filterOptions as JsonObject no-undo.
        define variable missingTokenFilter as logical no-undo initial false.
        
        if not HasOption('filters':u) then
            return ?.
        
        assign filterConfig = GetOptionObjectValue('filters':u).
        if not type-of(filterConfig, IList) then
            return ?.
        
        // get the logging level. first check for a set option, then derive it
        if HasOption('logLevel':u) then
            assign logLevel = cast(GetOptionObjectValue('logLevel':u), LogLevelEnum).
        if not valid-object(logLevel) then
            assign logLevel = LogLevelEnum:DEFAULT.
        
        assign filterIter = cast(filterConfig, IList):Iterator().
        if cast(filterConfig, IList):Size eq 0 then
            return ?. 
        
        assign extent(filterList) = cast(filterConfig, IList):Size.
        
        do while filterIter:HasNext():
            assign filterData = filterIter:Next().
            case true:
                when not valid-object(filterData) then
                    assign filter = ?.
                
                // Filter added as an instance of ILoggerFilter
                when type-of(filterData, ILoggerFilter) then
                    assign filter = cast(filterData, ILoggerFilter).
                
                // Filter added as a name, optionally with config
                when type-of(filterData, KeyValuePair) then
                    assign filterOptions = cast(cast(filterData, KeyValuePair):Value, JsonObject)
                           filter        = LogFilterBuilder:Build(string(cast(filterData, KeyValuePair):Key))
                                                :Options(filterOptions)
                                                :Filter
                           .
                // we don't know what to do with this
                otherwise
                    assign filter = ?.
            end case.
            
            case true:
                when not valid-object(filter) then
                    LogMessage(substitute('Unable to build filter "&1" for logger "&2"',
                                          string(filterData),
                                          this-object:LoggerType       ),
                               LogLevelEnum:WARN).
                
                // the token resolver filter ones we know about
                when type-of(filter, ResolvedTokenFormat) or
                when type-of(filter, AnonymizedTokenFormat) or
                when type-of(filter, MDCTokenFormat) then
                    assign missingTokenFilter = true.
                
                when type-of(filter, TokenContextFormat) then
                    assign missingTokenFilter = false.
                
                otherwise
                    .   //no-op
            end case.
            
            if valid-object(filter) then
                assign filterIdx             = filterIdx + 1
                       filterList[filterIdx] = filter
                       .
        end.
        
        // Even if there were filters configured, none of them may have been able to be built
        if not valid-object(filterList[1]) then
            return ?.
        
        if missingTokenFilter then
            LoggerBuilder:LogMessage(substitute('REPLACE_TOKENS_FORMAT filter is missing for logger "&1"; token values will not be written out',
                                                this-object:LoggerType),
                                     LogLevelEnum:WARN).
        
        return new OpenEdge.Logging.Logger(this-object:LoggerType, logLevel, filterList).
    end method.
    
    /* Logs error/messages that are written before a logger instance is successfully built.
       ONLY for use by the LoggerBuilder (hence protected). This is intentionally a very 
       primitive log writer.
       
       Messages are written to the first location found by the algorithm below 
       1. If a log-manager exists, write there. This will always be the case on a server (PASOE or Classic A/S & WS) 
       2. The session's temp-dir in a file called loggerbuilder.log
       
       Messages are APPENDED to the output file
       
       @param character    The message to write
       @param LogLevelEnum The level of the message */
    method static protected void LogMessage(input pMessage as character,
                                            input pLevel as LogLevelEnum):
        define variable logfile as character no-undo.
        
        if not valid-object(pLevel) then
            assign pLevel = LogLevelEnum:DEFAULT.
        
        assign pMessage = substitute('[&1] &2':u, string(pLevel), pMessage).
        
        if log-manager:logfile-name eq ? then
        do:
            assign logfile = substitute('&1/loggerbuilder.log':u, session:temp-dir).
            
            output to value(logfile) append.
                put unformatted '[':u iso-date(now) '] ':u pMessage skip.
            output close.
        end.
        else
            // Running on an OE server (PASOE)
            log-manager:write-message(pMessage, 'LoggerBldr':u).
    end method.
    
end class.
