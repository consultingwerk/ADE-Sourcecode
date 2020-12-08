/************************************************
Copyright (c) 2019 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : JsonConfigLoggerBuilder
    Purpose     : Builds a filter logger from stored JSON configuration
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2019-08-01
    Notes       : * Builds a logger based on JSON config (from anywhere)
                    - matching the schema in $DLC/src/corelib/OpenEdge/Logging/logging.config.schema 
                  * Values are taken from this builder and loaded config read from the input JSON. 
                    Any values set in this builder OVERRIDE the config values
                  * The logger name resolution follows that of log4j - described at
                     https://logging.apache.org/log4j/1.2/manual.html .
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Util.BuilderRegistry.
using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.Filter.LogFilterBuilder.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.LogLevelEnum.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Logging.VoidLogger.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.AppError.
using OpenEdge.Logging.JsonConfigLoggerBuilder.
using OpenEdge.Core.Json.JsonPropertyHelper.

class OpenEdge.Logging.JsonConfigLoggerBuilder inherits LoggerBuilder:
    
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
    
    /** Registry for mapping builder types to their implementations
        
        This is the registry of LogFilterBuilders and not the registry of
        log writers. */
    define static private property FilterBuilders as BuilderRegistry no-undo
        get():
            if not valid-object(JsonConfigLoggerBuilder:FilterBuilders) then
                assign JsonConfigLoggerBuilder:FilterBuilders = new BuilderRegistry(get-class(LogFilterBuilder)).
            
            return JsonConfigLoggerBuilder:FilterBuilders.
        end get.
        private set.
    
    // Registry for holding this factory's logger filters
    define static private property Filters as BuilderRegistry no-undo
        get():
            if not valid-object(JsonConfigLoggerBuilder:Filters) then
                assign JsonConfigLoggerBuilder:Filters = new BuilderRegistry(get-class(ILoggerFilter)).
            
            return JsonConfigLoggerBuilder:Filters.
        end get.
        private set.
    
    define static private temp-table Logger no-undo
        field LoggerName     as character
        field LogLevel       as character
        field LoggerInstance as Progress.Lang.Object    // ILogWriter
        
        index idx1 as primary unique LoggerName
        .
    
    define static private temp-table LogFilter no-undo
        field LoggerName        as character
        field FilterName        as character
        field Order             as integer
        field FilterOptions     as Progress.Lang.Object     // JsonObject
        
        index idx1 as primary unique LoggerName Order
        .
    
    /* Constructor
       
       @param character The logger type being built */
    constructor public JsonConfigLoggerBuilder (input pcLoggerType as character):
        super(pcLoggerType).
    end method.
    
    /* Clears all the current logger configurations */
    method static public void ClearConfig():
        empty temp-table Logger.
        empty temp-table LogFilter.
        
        JsonConfigLoggerBuilder:FilterBuilders:Clear().
        JsonConfigLoggerBuilder:Filters:Clear().
    end method.
    
    /* Loads logging configuration from JSON. Is an ADDITIVE operation - existing
       config is not cleared. To remove existing config, call the ClearConfig() 
       static method.
       
       @param JsonObject JSON representation of the lgging configuration */
    method static public void LoadConfig(input pConfig as JsonObject):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable iInnerLoop as integer no-undo.
        define variable iInnerMax as integer no-undo.
        // LONGCHAR arrays don't suffer from certain size constraints
        define variable cNames as longchar extent no-undo.
        define variable propertyName as character no-undo.
        define variable oConfig as JsonObject no-undo.
        define variable oData as JsonObject no-undo.
        define variable oType as JsonObject no-undo.
        define variable oFilters as JsonArray no-undo.
        define variable resolvedType as class Progress.Lang.Class no-undo.
        
        define buffer lbLogger for Logger.
        define buffer lbFilter for LogFilter.
        
        if not valid-object(pConfig) then
            return.
        
        if JsonPropertyHelper:HasTypedProperty(pConfig, PROP_DEFAULT_LOGGER, JsonDataType:STRING) then
            assign JsonConfigLoggerBuilder:DefaultLogger = pConfig:GetCharacter(JsonConfigLoggerBuilder:PROP_DEFAULT_LOGGER).
        
        if JsonPropertyHelper:HasTypedProperty(pConfig, PROP_LOGGER, JsonDataType:OBJECT) then
        do:
            assign oConfig = pConfig:GetJsonObject(PROP_LOGGER)
                   cNames  = oConfig:GetNames()
                   iMax    = extent(cNames)
                   .
            do iLoop = 1 to iMax:
                // convert to string/char for ease-of-use
                assign propertyName = string(cNames[iLoop]).
                // first in wins
                if can-find(lbLogger where lbLogger.LoggerName eq propertyName) then
                    next.
                
                if not oConfig:GetType(propertyName) eq JsonDataType:OBJECT then
                    next.
                
                create lbLogger.
                assign oData               = oConfig:GetJsonObject(propertyName)
                       lbLogger.LoggerName = propertyName
                       .
                if JsonPropertyHelper:HasTypedProperty(oData, PROP_LEVEL, JsonDataType:STRING) then
                    assign lbLogger.LogLevel = oData:GetCharacter(PROP_LEVEL).
                
                if JsonPropertyHelper:HasTypedProperty(oData, PROP_FILTER_LIST, JsonDataType:ARRAY) then
                do:
                    assign oFilters  = oData:GetJsonArray(PROP_FILTER_LIST)
                           iInnerMax = oFilters:Length
                           .
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
        if JsonPropertyHelper:HasTypedProperty(pConfig, PROP_FILTER_GROUP, JsonDataType:OBJECT) then
        do:
            assign extent(cNames) = ?
                   oConfig        = pConfig:GetJsonObject(PROP_FILTER_GROUP)
                   cNames         = oConfig:GetNames()
                   iMax           = extent(cNames)
                   .
            do iLoop = 1 to iMax:
                // this will give us the filter's type 
                assign propertyName = cNames[iLoop]
                       resolvedType = GetABLType(oConfig, propertyName)
                       .
                if valid-object(resolvedType) then
                    JsonConfigLoggerBuilder:Filters:Put(propertyName, resolvedType).
                
                // is there a builder for the filter?
                if oConfig:GetType(propertyName) eq JsonDataType:OBJECT then
                do:
                    assign oData        = oConfig:GetJsonObject(propertyName)
                           resolvedType = GetABLType(oData, PROP_BUILDER)
                           .
                    if valid-object(resolvedType) then
                        JsonConfigLoggerBuilder:FilterBuilders:Put(propertyName, resolvedType).
                end.    // is an Object
           end.
        end.
        catch loadError as Progress.Lang.Error:
            LoggerBuilder:LogMessage(substitute('Error loading JSON : &1', loadError:GetMessage(1)),
                                     LogLevelEnum:ERROR).
        end catch.
    end method.
    
    /* Constructs the actual logger instance
       
       @return ILogWriter A new or cached logged */
    method override protected ILogWriter GetLoggerInstance():
        define variable logWriter as ILogWriter no-undo.
        define variable filter as ILoggerFilter no-undo.
        define variable logLevel as LogLevelEnum no-undo.
        define variable filterBuilder as LogFilterBuilder no-undo.
        
        define buffer lbLogger for Logger.
        define buffer lbFilter for LogFilter.
        
        if FindLogger(this-object:LoggerType, buffer lbLogger) then
        do:
            // use the cached version of the logger if there is one for this config
            if valid-object(lbLogger.LoggerInstance) then
                return cast(lbLogger.LoggerInstance, ILogWriter).
            
            // Set the level
            if HasOption(PROP_LEVEL) then
                assign logLevel = cast(GetOptionObjectValue(PROP_LEVEL), LogLevelEnum).
            
            if not valid-object(logLevel) then
                assign logLevel = FindLevel(lbLogger.LoggerName).
            
            if valid-object(logLevel) then
                LogAt(logLevel).
            
            // build the filters
            for each lbFilter where
                     lbFilter.LoggerName eq lbLogger.LoggerName
                     by lbFilter.Order:
                
                if JsonConfigLoggerBuilder:FilterBuilders:Has(lbFilter.FilterName) then
                    assign filterBuilder = LogFilterBuilder:Build(lbFilter.FilterName, JsonConfigLoggerBuilder:FilterBuilders).
                else
                    assign filterBuilder = LogFilterBuilder:Build(lbFilter.FilterName).
                
                if JsonConfigLoggerBuilder:Filters:Has(lbFilter.FilterName) then
                    filterBuilder:FromRegistry(JsonConfigLoggerBuilder:Filters).
                
                // add JSON options to the filter builder 
                filterBuilder:Options(cast(lbFilter.FilterOptions, JsonObject)).
                
                // now build the filter and add to the config
                assign filter = filterBuilder:Filter.
                
                if valid-object(filter) then
                    AddFilter(filter).
                else
                    LogMessage(substitute('Unable to build filter "&1" for logger "&2"',
                                          lbFilter.FilterName, 
                                          lbFilter.LoggerName  ),
                               LogLevelEnum:WARN).
            end.
        end.
        
        // Let the config-driven builder build the logger: if we don't have config for it, 
        // try the default (which is typically log-manager-based) 
        assign logWriter = super:GetLoggerInstance().
        
        // cache the logger
        if available lbLogger then
            assign lbLogger.LoggerInstance = logWriter.
        
        return logWriter.
        catch err as Progress.Lang.Error:
            LoggerBuilder:LogMessage(substitute('Error building logger &1: &2', lbLogger.LoggerName, err:GetMessage(1)),
                                     LogLevelEnum:ERROR).
            
            return new VoidLogger(lbLogger.LoggerName).
        end catch.
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
        
        if can-find(lbLogger where lbLogger.LoggerName eq pcLoggerType) then
            find lbLogger where lbLogger.LoggerName eq pcLoggerType.
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
            if can-find(lbLogger where lbLogger.LoggerName eq pcLoggerType) then
                find lbLogger where lbLogger.LoggerName eq pcLoggerType.
            if available lbLogger then
                assign logLevel = LogLevelEnum:GetEnum(lbLogger.LogLevel)
                       no-error.
        end.
        
        if not valid-object(logLevel) 
           // don't loop forever
           and JsonConfigLoggerBuilder:DefaultLogger ne pcLoggerType 
        then 
            assign logLevel = FindLevel(JsonConfigLoggerBuilder:DefaultLogger).
        
        if not valid-object(logLevel) then
            assign logLevel = LogLevelEnum:DEFAULT.
        
        return logLevel.
        finally:
            // for cases where the LogLevelEnum:GetEnum() fails
            assign error-status:error = no.
        end finally.
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
           or not valid-object(poParent)
        then
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
        define variable isDefault as logical no-undo. 
        
        // so we don't end up with a previously-found buffer
        release pbLogger.
        
        if can-find(pbLogger where pbLogger.LoggerName eq pcLoggerType) then
            find pbLogger where pbLogger.LoggerName eq pcLoggerType.
        if available pbLogger then
            return true.
        
        // if there's only one entry then we've checked already
        assign dotPos    = r-index(pcLoggerType, '.':u)
               // check for the default against the input value now, since we chop it up in a sec
               isDefault = JsonConfigLoggerBuilder:DefaultLogger eq pcLoggerType
               .
        do while dotPos gt 0:
            assign pcLoggerType = substring(pcLoggerType, 1, dotPos - 1)
                   dotPos       = r-index(pcLoggerType, '.':u).
            if can-find(pbLogger where pbLogger.LoggerName eq pcLoggerType) then
                find pbLogger where pbLogger.LoggerName eq pcLoggerType.
            if available pbLogger then
                return true.
        end.
        
        // don't recurse
        if not isDefault then
            return FindLogger(JsonConfigLoggerBuilder:DefaultLogger, buffer pbLogger).
        
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
