/************************************************
Copyright (c) 2016-2017 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : ConfigFileLoggerBuilder
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Dec 05 09:48:11 EST 2016
    Notes       : * Assumes the config is stored in a JSON file
                    - named logging.config
                    - matching the schema in @DLC/src/corelib/OpenEdge/Logging/logging.config.schema
                  * Values are taken from this builder and loaded config read from logging.config. 
                    Any values set in this builder OVERRIDE the config values
                  * The logger name resolution follows that of log4j - described at
                     https://logging.apache.org/log4j/1.2/manual.html .
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Util.BuilderRegistry.
using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.Filter.LogFilterBuilder.
using OpenEdge.Logging.Filter.LoggerFilterList.
using OpenEdge.Logging.Filter.LoggerFilterNode.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.LogLevelEnum.
using OpenEdge.Logging.Logger.
using OpenEdge.Logging.LoggerBuilder.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.AppError.
using OpenEdge.Logging.ConfigFileLoggerBuilder.
using Progress.Json.ObjectModel.ObjectModelParser.

class OpenEdge.Logging.ConfigFileLoggerBuilder inherits LoggerBuilder: 
    // Monitors the time at which the config was last loaded
    define static private variable CONFIG_FILE_TIMESTAMP as datetime init ? no-undo.
    
    // The name of the file (in propath) that contains logging configuration.
    define static private variable CONFIG_FILE_NAME as character no-undo
            initial 'logging.config':u.
    
    // variables to hold the JSON property names
    define static private variable PROP_DEFAULT_LOGGER  as character initial 'DEFAULT_LOGGER':u no-undo.
    define static private variable PROP_LOGGER          as character initial 'logger':u         no-undo.
    define static private variable PROP_LEVEL           as character initial 'logLevel':u       no-undo.
    define static private variable PROP_FILTER_LIST     as character initial 'filters':u        no-undo.
    define static private variable PROP_FILTER_GROUP    as character initial 'filter':u         no-undo.
    define static private variable PROP_NAME            as character initial 'name':u           no-undo.
    define static private variable PROP_TYPE            as character initial 'type':u           no-undo.
    define static private variable PROP_HASH            as character initial 'hash':u           no-undo.
    define static private variable PROP_BUILDER         as character initial 'builder':u        no-undo.
    define static private variable PROP_FILE_NAME       as character initial 'fileName':u       no-undo.
    define static private variable PROP_FORMAT_STRING   as character initial 'format':u         no-undo.
    define static private variable PROP_APPEND_LOG      as character initial 'appendTo':u       no-undo.
    
    /** Registry for mapping builder types to their implementations
        
        This is the registry of LogFilterBuilders and not the registry of 
        log writers. */
    define static private property FilterBuilders as BuilderRegistry no-undo
        get():
            if not valid-object(ConfigFileLoggerBuilder:FilterBuilders) then
                assign ConfigFileLoggerBuilder:FilterBuilders = new BuilderRegistry(get-class(LogFilterBuilder)).
            
            return ConfigFileLoggerBuilder:FilterBuilders.
        end get.
        private set.
    
    // Registry for holding this factory's logger filters
    define static private property Filters as BuilderRegistry no-undo
        get():
            if not valid-object(ConfigFileLoggerBuilder:Filters) then
                assign ConfigFileLoggerBuilder:Filters = new BuilderRegistry(get-class(ILoggerFilter)).
            
            return ConfigFileLoggerBuilder:Filters.
        end get.
        private set.
    
    define static private temp-table Logger no-undo
        field LoggerName as character
        field LogLevel   as character
        
        index idx1 as primary unique LoggerName
        .
        
    define static private temp-table LogFilter no-undo
        field LoggerName as character
        field FilterName as character
        field Order as integer
        field FilterOptions as Progress.Lang.Object     // JsonObject
        
        index idx1 as primary unique LoggerName Order
        .
    
    /* Static constructor */
    constructor static ConfigFileLoggerBuilder():
        LoadFromFile(ConfigFileLoggerBuilder:CONFIG_FILE_NAME).
    end constructor.
    
    /* Loads logging config from a file
       
       @param character The filename to load. */
    method static private void LoadFromFile(input pFileName as character):
        define variable lastTouch as datetime no-undo.
        
        Assert:NotNullOrEmpty(pFileName, 'Config file').
        
        assign file-info:file-name = pFileName.
        
        // if there's no file, do nothing.
        if file-info:full-pathname eq ? then
        do: 
            // We previously loaded some config, and now have removed the file
            if not CONFIG_FILE_TIMESTAMP eq ? then
                ClearConfig().
            
            return.
        end.
        
        assign lastTouch = add-interval(datetime(file-info:file-mod-date), file-info:file-mod-time, 'seconds':u).
        
        // Load config file if it exists and the file MOD timestamp is after the last value
        if lastTouch gt CONFIG_FILE_TIMESTAMP then
        do:
            ClearConfig().
            assign CONFIG_FILE_TIMESTAMP = lastTouch. 
            LoadConfig(cast(new ObjectModelParser():ParseFile(file-info:full-pathname), JsonObject)).
        end.
    end method.
    
    /* Constructor
       
       @param character The logger type being built */
    constructor public ConfigFileLoggerBuilder (input pcLoggerType as character):
        super(pcLoggerType).
    end method.    

    /* Clears all the current logger configurations */
    method static public void ClearConfig():
        empty temp-table Logger.
        empty temp-table LogFilter.
        
        ConfigFileLoggerBuilder:FilterBuilders:Clear().
        ConfigFileLoggerBuilder:Filters:Clear().
    end method.

    /* Loads logging configuration from JSON
       
       @param JsonObject JSON representation of the lgging configuration */
    method static public void LoadConfig(input poJson as JsonObject):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable iInnerLoop as integer no-undo.
        define variable iInnerMax as integer no-undo.
        define variable cNames as character extent no-undo.
        define variable oConfig as JsonObject no-undo.
        define variable oData as JsonObject no-undo.
        define variable oType as JsonObject no-undo.
        define variable oFilters as JsonArray no-undo.
        define variable resolvedType as class Progress.Lang.Class no-undo.
        
        define buffer lbLogger for Logger.
        define buffer lbFilter for LogFilter.
        
        Assert:NotNull(poJson, 'JSON config').
        
        if poJson:Has(ConfigFileLoggerBuilder:PROP_DEFAULT_LOGGER) and poJson:GetType(ConfigFileLoggerBuilder:PROP_DEFAULT_LOGGER) eq JsonDataType:STRING then
            assign ConfigFileLoggerBuilder:DefaultLogger = poJson:GetCharacter(ConfigFileLoggerBuilder:PROP_DEFAULT_LOGGER).
        
        if poJson:Has(PROP_LOGGER) and poJson:GetType(PROP_LOGGER) eq JsonDataType:OBJECT then
        do:
            assign oConfig = poJson:GetJsonObject(PROP_LOGGER)
                   cNames  = oConfig:GetNames()
                   iMax    = extent(cNames)
                   .
            do iLoop = 1 to iMax:
                if not oConfig:GetType(cNames[iLoop]) eq JsonDataType:OBJECT then
                    next.
                
                // first in wins
                if can-find(lbLogger where lbLogger.LoggerName eq cNames[iLoop]) then
                    next.
                
                create lbLogger.
                assign oData               = oConfig:GetJsonObject(cNames[iLoop])
                       lbLogger.LoggerName = cNames[iLoop]
                       .
                if oData:Has(PROP_LEVEL) and oData:GetType(PROP_LEVEL) eq JsonDataType:STRING then
                    assign lbLogger.LogLevel = oData:GetCharacter(PROP_LEVEL).
                
                if oData:Has(PROP_FILTER_LIST) and oData:GetType(PROP_FILTER_LIST) eq JsonDataType:ARRAY then
                do:
                    assign oFilters  = oData:GetJsonArray(PROP_FILTER_LIST)
                           iInnerMax = oFilters:Length.
                    // there should be at least one, but if not, then this is a no-op logger (not even void)
                    do iInnerLoop = 1 to iInnerMax:
                         create lbFilter.
                         assign lbFilter.LoggerName = lbLogger.LoggerName
                                lbFilter.Order      = iInnerLoop
                                .
                         case oFilters:GetType(iInnerLoop):
                             when JsonDataType:OBJECT then
                             do:
                                 assign oData = oFilters:GetJsonObject(iInnerLoop)
                                        lbFilter.FilterOptions = oData
                                        lbFilter.FilterName    = oData:GetCharacter(PROP_NAME)
                                        .
                                // strip the filterName property from the options 
                                oData:Remove(PROP_NAME).
                             end.
                             when JsonDataType:STRING then
                                 assign lbFilter.FilterName = oFilters:GetCharacter(iInnerLoop).
                         end case.
                     end.
                end.
            end.
        end.
        
        // Register FORMAT filters
        if poJson:Has(PROP_FILTER_GROUP) and poJson:GetType(PROP_FILTER_GROUP) eq JsonDataType:OBJECT then
        do:
            assign oConfig = poJson:GetJsonObject(PROP_FILTER_GROUP)
                   extent(cNames) = ?
                   cNames  = oConfig:GetNames()
                   iMax    = extent(cNames)
                   .
            do iLoop = 1 to iMax:
                // this will give us the filter's type 
                assign resolvedType = GetABLType(oConfig, cNames[iLoop]).                    
                if valid-object(resolvedType) then
                    ConfigFileLoggerBuilder:Filters:Put(cNames[iLoop], resolvedType).
                
                // is there a builder for the filter?
                if oConfig:GetType(cNames[iLoop]) eq JsonDataType:OBJECT then
                do:
                    assign oData        = oConfig:GetJsonObject(cNames[iLoop])
                           resolvedType = GetABLType(oData, PROP_BUILDER)
                           .                    
                    if valid-object(resolvedType) then
                        ConfigFileLoggerBuilder:FilterBuilders:Put(cNames[iLoop], resolvedType).
                end.    // is an Object
           end.
       end.
    end method.
    
    /* Constructs the actual logger instance
       
       @return ILogWriter A new or cached logged */
    method override protected ILogWriter GetLoggerInstance():
        define variable logWriter as ILogWriter no-undo.
        define variable filter as ILoggerFilter no-undo.
        define variable filterList as LoggerFilterList no-undo.
        define variable logLevel as LogLevelEnum no-undo.
        define variable filterBuilder as LogFilterBuilder no-undo.
        define variable loggerOptions as JsonObject no-undo.
        
        define buffer lbLogger for Logger.
        define buffer lbFilter for LogFilter.

        // reload on every logger request. Will no-op if the file hasn't changed
        LoadFromFile(ConfigFileLoggerBuilder:CONFIG_FILE_NAME).
        
        if FindLogger(this-object:LoggerType, buffer lbLogger) then
        do:
            if HasOption(PROP_LEVEL) then
                assign logLevel = cast(GetOptionObjectValue(PROP_LEVEL), LogLevelEnum).
            
            if not valid-object(logLevel) then
                assign logLevel = FindLevel(lbLogger.LoggerName).
                                        
            assign filterList  = new LoggerFilterList().
            for each lbFilter where
                     lbFilter.LoggerName eq lbLogger.LoggerName
                     by lbFilter.Order:
                
                if ConfigFileLoggerBuilder:FilterBuilders:Has(lbFilter.FilterName) then
                    assign filterBuilder = LogFilterBuilder:Build(lbFilter.FilterName, ConfigFileLoggerBuilder:FilterBuilders).
                else
                    assign filterBuilder = LogFilterBuilder:Build(lbFilter.FilterName).
                
                if ConfigFileLoggerBuilder:Filters:Has(lbFilter.FilterName) then
                    filterBuilder:FromRegistry(ConfigFileLoggerBuilder:Filters).
                
                if valid-object(lbFilter.FilterOptions) then
                do:
                    assign loggerOptions = cast(lbFilter.FilterOptions, JsonObject).
                    
                    // Extract the filter options we know about
                    if     loggerOptions:Has(PROP_FILE_NAME) 
                       and loggerOptions:GetType(PROP_FILE_NAME) eq JsonDataType:STRING 
                       then
                        filterBuilder:WriteTo(loggerOptions:GetCharacter(PROP_FILE_NAME)).
                    
                    if     loggerOptions:Has(PROP_FORMAT_STRING) 
                       and loggerOptions:GetType(PROP_FORMAT_STRING) eq JsonDataType:STRING 
                       then
                        filterBuilder:FormatAs(loggerOptions:GetCharacter(PROP_FORMAT_STRING)).
                    
                    if     loggerOptions:Has(PROP_APPEND_LOG) 
                       and loggerOptions:GetType(PROP_APPEND_LOG) eq JsonDataType:BOOLEAN 
                       then
                        filterBuilder:Append(loggerOptions:GetLogical(PROP_APPEND_LOG)).
                    
                    // write all the options anyway, for those we don't know about
                    filterBuilder:Options(loggerOptions).
                end.
                
                assign filter = filterBuilder:Filter.
                if valid-object(filter) then
                    filterList:InsertLast(new LoggerFilterNode(filter)).
            end.
            
            assign logWriter = new Logger(lbLogger.LoggerName, logLevel, filterList).
        end.
        
        if not valid-object(logWriter) then
            assign logWriter = super:GetLoggerInstance().
        
        return logWriter.
    end method.
    
    /* Finds the log level for a logger to use, based on the logger type
       
       Algorithm is
       1) exact match
       2) chop off the trailing .-delimited entry, repeating
       3) find the logger defined as DEFAULT_LOGGER, folling steps 1 & 2
       
       @param  character The logger type to find
       @return LogLevelEnum returns a log level , if any */
    method private LogLevelEnum FindLevel(input pcLoggerType as character):
        define variable logLevel as LogLevelEnum no-undo.
        define variable dotPos as integer no-undo.
        
        define buffer lbLogger for Logger.
        
        find lbLogger where
             lbLogger.LoggerName eq pcLoggerType
             no-error.
        if available lbLogger then
            assign logLevel = LogLevelEnum:GetEnum(lbLogger.LogLevel)
                   no-error.
        if valid-object(logLevel) then
            return logLevel.

        assign dotPos = r-index(pcLoggerType, '.':u).
        // if there's only one entry then we've checked already
        do while not valid-object(logLevel) and dotPos gt 0:
            assign pcLoggerType = substring(pcLoggerType, 1, dotPos - 1)
                   dotPos       = r-index(pcLoggerType, '.':u).
            find lbLogger where
                 lbLogger.LoggerName eq pcLoggerType
                 no-error.
            if available lbLogger then
                assign logLevel = LogLevelEnum:GetEnum(lbLogger.LogLevel)
                       no-error.
        end.
        
        if not valid-object(logLevel) 
           // don't loop forever
           and ConfigFileLoggerBuilder:DefaultLogger ne pcLoggerType then 
            assign logLevel = FindLevel(ConfigFileLoggerBuilder:DefaultLogger).
        
        if not valid-object(logLevel) then
            assign logLevel = LogLevelEnum:DEFAULT.
        
        return logLevel.
    end method.
    
    /* Returns a type name from a property we expect to have a type. Basically resolving the
       typeName / typeProperty values into an P.L.C 
          "definitions": {
            "typeName": {
              "type": "string",
              "description": "An OOABL type name",
              "pattern": "^[A-Za-z]+[A-Za-z$0-9-&#%.]+[A-Za-z$0-9-&#%]*$"
            },
            "typeProperty": {
              "type": "object",
              "properties": {
                "type": {"$ref": "#/definitions/typeName"},
                "hash": {
                  "type": "string",
                  "description": "A hash value to validate that the OOABL type is the expected version."
                }
              },
              "required": ["type"]
            },
            "builderProperty": {
              "oneOf": [
                {"$ref": "#/definitions/typeProperty"},
                {"$ref": "#/definitions/typeName"}
              ]
            }
          },
      
      @param JsonObject The JSON containign the type property
      @param character  The name of the propert
      @return P.L.Class A resolve ABL type name. May be unknown */
    method static private class Progress.Lang.Class GetABLType(input poParent as JsonObject,
                                                               input pcPropName as character):
        define variable typeName as character no-undo.
        define variable typeData as JsonObject no-undo.
        
        if    pcPropName eq '':u 
           or pcPropName eq ? 
           or not valid-object(poParent) then
            return ?.
        
        if poParent:Has(pcPropName) then
        do:
            case poParent:GetType(pcPropName):
                when JsonDataType:STRING then
                    assign typeName = poParent:GetCharacter(pcPropName).
                
                when JsonDataType:OBJECT then
                do:
                    assign typeData = poParent:GetJsonObject(pcPropName)
                           typeName = typeData:GetCharacter(PROP_TYPE)
                           .
                    if typeData:Has(PROP_HASH) and typeData:GetType(PROP_HASH) eq JsonDataType:STRING then
                        ValidateFilter(typeName, typeData:GetCharacter(PROP_HASH)).
                end.
                otherwise
                    assign typeName = ?.
            end case.
            
            if typeName ne ? then
                return Progress.Lang.Class:GetClass(typeName).
        end.
        
        return ?.
    end method.
    
    /* Find a temp-table record/config for a logger to use
       
       Algorithm is
       1) exact match
       2) chop off the trailing .-delimited entry, repeating
       3) find the logger defined as DEFAULT_LOGGER, following steps 1 & 2
       4) return a void logger (just to have a reference)
       
       @param  character The logger type to find
       @param  buffer A buffer reference to the logger temp-table
       @return logical TRUE if a logger record was found. If TRUE, the 
                       buffer will AVAILABLE; if false, not     */
    method private logical FindLogger(input pcLoggerType as character,
                                      buffer pbLogger for Logger):
        define variable dotPos as integer no-undo.
        
        find pbLogger where
             pbLogger.LoggerName eq pcLoggerType
             no-error.
        if available pbLogger then
            return true.
        
        // if there's only one entry then we've checked already
        assign dotPos = r-index(pcLoggerType, '.':u).
        do while dotPos gt 0:
            assign pcLoggerType = substring(pcLoggerType, 1, dotPos - 1)
                   dotPos       = r-index(pcLoggerType, '.':u).
            find pbLogger where
                 pbLogger.LoggerName eq pcLoggerType
                 no-error.
            if available pbLogger then
                return true.
        end.
        
        // don't recurse
        if ConfigFileLoggerBuilder:DefaultLogger ne pcLoggerType then
            return FindLogger(ConfigFileLoggerBuilder:DefaultLogger, buffer pbLogger).
            
        return false.
    end method.
    
    /* Ensures that a Filter type is the one we were expecting. 
        
       @param character (mandatory) The ABL Filter name used to process the event
       @param character (optional) A hash used to verify the Filter's authenticity
       @throws AppError If a hash is passed and the Filter type's hash does not match */
    method static private void ValidateFilter(input pcFilterType as character,
                                              input pcFilterHash as character ):
        if pcFilterHash eq '':u or pcFilterHash eq ? then
            return.
        
        Assert:NotNullOrEmpty(pcFilterType, 'Filter type').
        
        assign rcode-info:file-name = replace(pcFilterType, '.':u, '/':u).
        if rcode-info:md5-value ne pcFilterHash then
            return error new AppError(substitute('Filter error: invalid Filter &1', pcFilterType), 0).
    end method.
    
end class.
