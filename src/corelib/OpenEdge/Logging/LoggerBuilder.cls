/************************************************
Copyright (c) 2016-2021 by Progress Software Corporation. All rights reserved.
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
using OpenEdge.Logging.Logger.
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
            define variable logWriter as ILogWriter no-undo.
            
            // we don't check for a cached logger here because the child logger builders might
            // clear the cache prior to building.
            
            do on error undo, throw:
                assign logWriter = GetLoggerInstance().
                catch err as Progress.Lang.Error:
                    assign logWriter = ?.
                    LoggerBuilder:LogMessage(substitute('Error building logger &1: &2',
                                                this-object:LoggerType,
                                                err:GetMessage(1)),
                                             LogLevelEnum:ERROR).
                end catch.
            end.
            // last-resort to ensure that we always return a valid instance
            if not valid-object(logWriter) then
            do:
                assign logWriter = new VoidLogger(this-object:LoggerType).
                LoggerBuilder:CacheInstance(this-object:LoggerType, logWriter).
            end.
            
            return logWriter.
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
    
    // A cache of logger instances, unique by LoggerName
    define static private temp-table Logger no-undo
        field LoggerName     as character
        field LoggerInstance as Progress.Lang.Object
        field CachedAt       as datetime
        
        index idx1 as primary unique LoggerName
        .
    
    // the name of this class; we could calculate it each time we need it but a string version is faster
    define static private variable LOGGER_BUILDER_TYPE_NAME as character no-undo initial 'OpenEdge.Logging.LoggerBuilder':u.
    
    /* Static constructor */
    constructor static LoggerBuilder():
        define variable cnt as integer no-undo.
        
        assign mLogLevels   = get-class(LogLevelEnum):GetEnumValues()
               mMaxLogLevel = 0
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
    end constructor.
    
    /** Returns a logger (ILogWriter).
        
        @param P.L.Class The typename for which to find a logger
        @return ILogWriter An instance of the default logger */
    method static public ILogWriter GetLogger(input poLoggerType as class Progress.Lang.Class):
        Assert:NotNull(poLoggerType, 'Logger type':u).
        
        // we don't check for a cached logger here because the child logger builders might
        // clear the cache prior to building.
        
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
        
        // we don't check for a cached logger here because the child logger builders might
        // clear the cache prior to building.
        
        return LoggerBuilder:Build(loggerName):Logger.
    end method.
    
    /** Returns a logger (ILogWriter)
        
        @param character The logger name
        @return ILogWriter An instance of the default logger */
    method static public ILogWriter GetLogger(input pcLoggerType as character):
        if pcLoggerType eq '':u or pcLoggerType eq ? then
            assign pcLoggerType = LoggerBuilder:DefaultLogger.
        
        // we don't check for a cached logger here because the child logger builders might
        // clear the cache prior to building.
        
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
        
        ClearExternalBuild('LogAt':u).
        
        SetOption('logLevel':u, poLevel).
        
        return this-object.
    end method.
    
    /* This method removes the logger being built if the builder-methods are
       called externally (in user code). If they are called internally, then
       
       @param character The method being checked: AddFilter and LogAt */
    method protected void ClearExternalBuild(input pMethodName as character):
        define variable loop as integer no-undo.
        define variable progName as character no-undo.
        
        // no need, if it's not cached
        if not LoggerBuilder:IsCached(this-object:LoggerType) then
            return.
        
        // if the AddFilter method is called from manual Build():AddFilter():AddFilter() code
        // then we want to remove any cached instance of this logger.
        // However, if AddFilter() is called from a GetLogger() call in another builder, we let the builder
        // do the cache checks
        
        // start at 2 to avoid this method.
        assign loop = 2.
        CALLING-LOOP:
        do while not program-name(loop) eq ?:
            assign progName = program-name(loop).
            // skip any overrides
            if progName eq pMethodName + ' ':u + OpenEdge.Logging.LoggerBuilder:LOGGER_BUILDER_TYPE_NAME then
            do:
                assign loop = loop + 1.
                next CALLING-LOOP.
            end.
            
            if   num-entries(progName, StringConstant:SPACE) eq 2
            and  entry(2, progName, StringConstant:SPACE) ne OpenEdge.Logging.LoggerBuilder:LOGGER_BUILDER_TYPE_NAME
            then
                LoggerBuilder:RemoveFromCache(this-object:LoggerType).
            
            leave CALLING-LOOP.
        end.
    end method.
    
    /* Adds a filter to the logger being built, with options in Json form
       
       @param  character The filter name to add
       @param  JsonObject The filter options
       @return LoggerBuilder This builder object  */
    method public LoggerBuilder AddFilter(input pFilterName as character,
                                          input pFilterOptions as JsonObject):
        define variable filterList as IList no-undo.
        
        ClearExternalBuild('AddFilter':u).
        
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
        
        ClearExternalBuild('AddFilter':u).
        
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
    
    /* Removes an instance record for a logger. Does not do anything to the logger itself (since it may
       be in use)
       
       @param character The logger name
       @return logical TRUE if the instance record was removed */
    method static protected logical RemoveFromCache(input pLoggerName as character):
        define buffer bLogger for Logger.
        
        if FindLoggerInstance(buffer bLogger, pLoggerName) then
        do:
            delete bLogger.
            return true.
        end.
        
        return false.
    end method.
    
    /* Indicates whether a cached instance of a logger exists.
       
       @param character The logger name
       @return logical TRUE if there's a valid instance of ILogWriter for the given logger name */
    method static protected logical IsCached(input pLoggerName as character):
        define buffer bLogger for Logger.
        
        if FindLoggerInstance(buffer bLogger, pLoggerName) then
            return valid-object(bLogger.LoggerInstance).
        
        return false.
    end method.
    
    /* Clears/empties the cache of logger instances */
    method static protected void ClearCache():
        define buffer bLogger for Logger.
        
        empty temp-table bLogger.
    end method.
    
    /* Returns a cached logger instance.
       
       @param character The logger name
       @param ILogWriter An instance of ILogWriter for the given logger, or UNKNOWN if not cached */
    method static protected ILogWriter GetCachedInstance(input pLoggerName as character):
        define buffer bLogger for Logger.
        
        if FindLoggerInstance(buffer bLogger, pLoggerName) then
            return cast(bLogger.LoggerInstance, ILogWriter).
        
        return ?.
    end method.
    
    /* Caches a logger instance for a logger name
       
       @param character The logger name
       @param ILogWriter The logger instance */
    method static protected void CacheInstance(input pLoggerName as character,
                                               input pLogger as ILogWriter):
        define buffer bLogger for Logger.
        
        Assert:NotNull(pLoggerName, 'Logger name').
        
        if not FindLoggerInstance(buffer bLogger, pLoggerName) then
        do:
            create bLogger.
            assign bLogger.LoggerName = pLoggerName.
        end.
        
        assign bLogger.LoggerInstance = pLogger
               bLogger.CachedAt       = now
               .
    end method.
    
    /* Helper method to find the correct logger records
       
       @param buffer The Logger temp-table buffer
       @param character The logger name
       @return logical TRUE if a record for the logger can be found, FALSE otherwise */
    method static private logical FindLoggerInstance(buffer pLogger for Logger,
                                                     input pLoggerName as character):
        release pLogger.
        
        if can-find(pLogger where pLogger.LoggerName eq pLoggerName) then
        {&_proparse_ prolint-nowarn(findnoerror)}
            find pLogger
           where pLogger.LoggerName eq pLoggerName.
        
        return (available pLogger).
    end method.
    
    /* Constructs the actual logger instance
       
       @return ILogWriter A new or cached logged */
    method protected ILogWriter GetLoggerInstance():
        define variable logWriter as ILogWriter no-undo.
        define variable logAt as LogLevelEnum no-undo.
        define variable filterIsStackWriter as logical no-undo.
         
        // use the specified/configured value first.
        // otherwise use the log-manager's as a default
        if  not HasOption('filters':u)
        and not log-manager:logfile-name eq ?
        then
        do:
            if LoggerBuilder:IsCached('LoggerBuilder:LOG-MANAGER':u) then
                assign logWriter = LoggerBuilder:GetCachedInstance('LoggerBuilder:LOG-MANAGER':u).
            
            // Set logging level based on log-manager's logging-level
            if log-manager:logging-level gt mMaxLogLevel then
                assign logAt = LogLevelEnum:GetEnum(mMaxLogLevel).
            else
            if lookup(string(log-manager:logging-level), mLogLevels) gt 0 then
                assign logAt = LogLevelEnum:GetEnum(log-manager:logging-level).
            else
                assign logAt = LogLevelEnum:DEFAULT.
            
            // we're not using the cached version, since the logging level has changed
            if  valid-object(logWriter)
            and not logWriter:LogLevel eq logAt
            then
                assign logWriter = ?.
            
            // if the debug-alert didn't change , then we can use the
            // existing instance
            if  valid-object(logWriter)
            and type-of(logWriter, Logger)
            then
            do:
                // we should have at least 1 extent here but protect with a NO-ERROR
                assign filterIsStackWriter =    cast(logWriter, Logger):LogFilters[1]:GetClass()
                                             eq LoggerFilterRegistry:Registry:Get(LoggerFilterRegistry:STACK_WRITER_FORMAT)
                       no-error.
                
                if (    session:debug-alert and     filterIsStackWriter)
                or (not session:debug-alert and not filterIsStackWriter)
                then
                    return logWriter.
                
                // reset in case something went wrong
                assign error-status:error = no.
            end.
            
            LogAt(logAt).
            
            // Add default filters
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
        end.    // logmanager enabled
        else
        // Use a cached version if it exists. At this point any child builders
        // will have done their config changes, so anything that's in the cache now
        // is there rightfully
        if LoggerBuilder:IsCached(this-object:LoggerType) then
            return LoggerBuilder:GetCachedInstance(this-object:LoggerType).
        
        // now try to build a logger from the set of filters
        assign logWriter = BuildFilterLogger().
        
        if not valid-object(logWriter) then
            assign logWriter = new VoidLogger(this-object:LoggerType).
        
        // Using the LOG-MANAGER
        if valid-object(logAt) then
            LoggerBuilder:CacheInstance('LoggerBuilder:LOG-MANAGER':u, logWriter).
        else
        if valid-object(logWriter) then
            LoggerBuilder:CacheInstance(this-object:LoggerType, logWriter).
        
        return logWriter.
    end method.
    
    /* Adds JSON configuration for loggers, filters and builders
        
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
        
        // get the logging level. first check for a set option, then derive it
        if HasOption('logLevel':u) then
            assign logLevel = cast(GetOptionObjectValue('logLevel':u), LogLevelEnum).
        if not valid-object(logLevel) then
            assign logLevel = LogLevelEnum:DEFAULT.
        
        if not HasOption('filters':u) then
            return ?.
        
        assign filterConfig = GetOptionObjectValue('filters':u).
        if not type-of(filterConfig, IList) then
            return ?.
        
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
       ONLY for use by the LoggerBuilder, Logger and other classes in this package(hence PACKAGE-PROTECTED).
       This is intentionally a very primitive log writer.
       
       Messages are written to the first location found by the algorithm below
       1. If a log-manager exists, write there. This will always be the case on a server (PASOE or Classic A/S & WS)
       2. The session's temp-dir in a file called loggerbuilder.log
       
       Messages are APPENDED to the output file
       
       @param character    The message to write
       @param LogLevelEnum The level of the message */
    method static package-protected void LogMessage(input pMessage as character,
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
