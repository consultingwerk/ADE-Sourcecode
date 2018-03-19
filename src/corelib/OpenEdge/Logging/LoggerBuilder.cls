/************************************************
Copyright (c) 2016-2017 by Progress Software Corporation. All rights reserved.
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
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Core.StringConstant.
using OpenEdge.Core.Util.BuilderRegistry.
using OpenEdge.Core.Util.ConfigBuilder.
using OpenEdge.Logging.ConfigFileLoggerBuilder.
using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.Filter.LogFilterBuilder.
using OpenEdge.Logging.Filter.LoggerFilterList.
using OpenEdge.Logging.Filter.LoggerFilterNode.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.LogLevelEnum.
using OpenEdge.Logging.Logger.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Logging.LoggerFilterRegistry.
using OpenEdge.Logging.VoidLogger.

class OpenEdge.Logging.LoggerBuilder inherits ConfigBuilder:
    /* returns a logger instance */
    define public property Logger as ILogWriter no-undo 
        get():
            return GetLoggerInstance(). 
        end get.
    
    // (mandatory) The logger type that we want to build 
    define public property LoggerType as character no-undo get. private set.
    
    // The name of the default logger to use in the GetLogger() method.
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
    
    /* Adds a filter to the logger being built
       
       @param  character The filter name to add  
       @return LoggerBuilder This builder object  */
    method public LoggerBuilder AddFilter(input pcFilterName as character):
        Assert:NotNullOrEmpty(pcFilterName, 'Log filter name').
        
        AppendArrayCharacterValue('filterName':u, pcFilterName).
                        
        return this-object.
    end method.
        
    /* Constructs the actual logger instance
       
       @return ILogWriter A new or cached logged */
    method protected ILogWriter GetLoggerInstance():
        define variable logWriter as ILogWriter no-undo.
        
        if log-manager:logfile-name ne ? then
        do:
            if not HasOption('logLevel':u) then
                LogAt(LogLevelEnum:GetEnum(log-manager:logging-level)) no-error.
            
            AddFilter(LoggerFilterRegistry:ABL_SUBSTITUTE_FORMAT).
            AddFilter(LoggerFilterRegistry:ERROR_FORMAT).
            AddFilter(LoggerFilterRegistry:LOG_MANAGER_FORMAT).
            AddFilter(LoggerFilterRegistry:LOG_MANAGER_WRITER).
        end.
        
        if HasOption('filterName':u) then
            assign logWriter = BuildFilterLogger(). 
        
        if not valid-object(logWriter) then 
            assign logWriter = new VoidLogger(this-object:LoggerType).
        
        return logWriter.
    end method.
    
    /* Creates a default logger based that uses the config in this class
       
       @return ILogWriter A logger */
    method protected ILogWriter BuildFilterLogger():
        define variable filterList as LoggerFilterList no-undo.
        define variable filter as ILoggerFilter no-undo.
        define variable logLevel as LogLevelEnum no-undo.
        define variable filterNames as character extent no-undo.
        define variable loop as integer no-undo.
        define variable numFilters as integer no-undo.
        
        if not HasOption('filterName':u) then
            return ?.
        
        // get the logging level. first check for a set option, then derive it
        if HasOption('logLevel':u) then
            assign logLevel = cast(GetOptionObjectValue('logLevel':u), LogLevelEnum).
        if not valid-object(logLevel) then
            assign logLevel = LogLevelEnum:DEFAULT.
        
        assign filterList  = new LoggerFilterList()
               filterNames = GetOptionStringArrayValue('filterName':u)
               numFilters  = extent(filterNames)
               .
        if    numFilters eq 0 
           or numFilters eq ? then
            return ?.
        
        do loop = 1 to numFilters:
            assign filter = LogFilterBuilder:Build(filterNames[loop])
                                :Filter.
            filterList:InsertLast(new LoggerFilterNode(filter)).
        end.
        
        return new OpenEdge.Logging.Logger(this-object:LoggerType, logLevel, filterList).
    end method.
    
end class.
