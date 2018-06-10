/* *************************************************************************************************************************
Copyright (c) 2016-2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : LogFilterBuilder
    Purpose     : Builder for Filter filters (writers, formatters)
    Description : 
    Author(s)   : pjudge
    Created     : 2016-11-14
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Core.Util.BuilderRegistry.
using OpenEdge.Core.Util.ConfigBuilder.
using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.Filter.LogFilterBuilder.
using OpenEdge.Logging.Format.ISupportFormatting.
using OpenEdge.Logging.LogFilterBuilderRegistry.
using OpenEdge.Logging.LoggerFilterRegistry.
using Progress.IO.FileOutputStream.
using Progress.IO.OutputStream.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.

class OpenEdge.Logging.Filter.LogFilterBuilder inherits ConfigBuilder:
    /** The filter being built */ 
    define public property Filter as ILoggerFilter no-undo
        get():
            if not valid-object(this-object:Filter) then
                assign this-object:Filter = NewFilter().
            
            return this-object:Filter.
        end get.
        private set.
        
    /** (mandatory) The Filter type for which we want to log */
    define public property FilterType as character no-undo get. private set.
    
    /** Returns log writer build for a logging type
        
        @param  P.L.Class The Filter type for which to build the logger
        @return LogFilterBuilder The entity writer builder to use  */
    method static public LogFilterBuilder Build(input pfilterType as class Progress.Lang.Class):
        Assert:NotNull(pfilterType, 'Filter type').
        
        return LogFilterBuilder:Build(pfilterType:TypeName).
    end method.
    
    /** Returns log writer build for a logging type
        
        @param  character The Filter type for which to build the logger
        @return LogFilterBuilder The entity writer builder to use  */
    method static public LogFilterBuilder Build(input pcFilterType as character):
        return LogFilterBuilder:Build(pcFilterType, LogFilterBuilderRegistry:Registry). 
    end method.
    
    /** Returns log writer build for a logging type
        
        @param  character The Filter type for which to build the logger
        @param  BuilderRegistry A registry of Filter writers to user
        @return LogFilterBuilder The entity writer builder to use  */
    method static public LogFilterBuilder Build(input pcFilterType as character,
                                                input poWriters as BuilderRegistry):
        define variable oBuilderType as Progress.Lang.Class no-undo.
        define variable oBuilder as LogFilterBuilder no-undo.
        
        Assert:NotNull(pcFilterType, 'Filter type').
        Assert:NotNull(poWriters, 'Writer builder registry').
        Assert:IsType(poWriters:ValueType, get-class(LogFilterBuilder)).
        
        assign oBuilderType = poWriters:Get(pcFilterType).
        if valid-object(oBuilderType) then
            Assert:IsType(oBuilderType, get-class(LogFilterBuilder)).        
        else
            // default is this class 
            assign oBuilderType = get-class(LogFilterBuilder).
        
        oBuilder = dynamic-new string(oBuilderType:TypeName) (pcFilterType).
        
        if type-of(oBuilder, ISupportInitialize) then
            cast(oBuilder, ISupportInitialize):Initialize().
        
        return oBuilder.
    end method.

    /* Constructor */
    constructor public LogFilterBuilder (input pcFilterType as character):
        Assert:NotNull(pcFilterType, 'Filter type').
        assign this-object:FilterType = pcFilterType.
    end method.
    
     /** Adds or overwrites an option for the client library.
        
        @param  JsonObject The Filter options (can be anything)
        @return LogFilterBuilder This builder object. */
    method public LogFilterBuilder Options(input poValue as JsonObject):
        Assert:NotNull(poValue, 'Filter options').
        
        SetOption('loggerOptions':u, poValue).
        
        return this-object.
    end method.
    
    /** Sets the output destination
        
        @param  character The filename to write to
        @return LogFilterBuilder This builder object. */
    method public LogFilterBuilder WriteTo(input pcLogFile as character ):
        Assert:NotNullOrEmpty(pcLogFile, 'Logfile name').
        
        SetOption('writeToFileName':u, pcLogFile).
        
        return this-object.
    end method.

    /** Indicates whether to append to the log
        
        @param  character The filename to write to
        @return LogFilterBuilder This builder object. */
    method public LogFilterBuilder Append(input plAppendToLog as logical):
        Assert:NotUnknown(plAppendToLog, 'Append to log').
        
        SetOption('appendToLog':u, plAppendToLog).
        
        return this-object.
    end method.
    
    /** Sets the output destination
        
        @param  FileOutputStream The filename to write to
        @return LogFilterBuilder This builder object. */
    method public LogFilterBuilder WriteTo(input poLogFile as FileOutputStream ):
        Assert:NotNull(poLogFile, 'Logfile name').
        
        SetOption('writeToFileStream':u, poLogFile).
        
        return this-object.
    end method.
    
    /** Sets the output destination
        
        @param  OutputStream The filename to write to
        @return LogFilterBuilder This builder object. */
    method public LogFilterBuilder WriteTo(input poOutput as OutputStream ):
        Assert:NotNull(poOutput, 'Log output destination').
        
        SetOption('writeToStream':u, poOutput).
        
        return this-object.
    end method.
    
    /** Sets a format string for a filter
        
        @param  character The filename to write to
        @return LogFilterBuilder This builder object. */
    method public LogFilterBuilder FormatAs(input pcFormat as character):
        Assert:NotNullOrEmpty(pcFormat, 'Filter format string').
        
        SetOption('formatString':u, pcFormat).
        
        return this-object.
    end method.    
    
    /** Sets the logging level for the logger
        
        @param  BuilderRegistry The registry containing the map of log writers
        @return LogFilterBuilder This builder object. */
    method public LogFilterBuilder FromRegistry(input poLoggerFilterRegistry as BuilderRegistry):
        Assert:NotNull(poLoggerFilterRegistry, 'Filter registry').
        Assert:IsType(poLoggerFilterRegistry:ValueType, get-class(ILoggerFilter)).
        
        SetOption('filterRegistry':u, poLoggerFilterRegistry).
        
        return this-object.
    end method.
    
    /** Returns a filter writer from a registry; either the optional one set via loggerFilterRegistry or
        the default LoggerFilterRegistry:Registry. It's the caller's responsibility to invoke and 
        use the filter type returned. 
        
        @param character The filter type name 
        @return Progress.Lang.Class The type of the filter writer. */
    method protected class Progress.Lang.Class GetFilterType(input filterTypeName as character):
        define variable filterType as class Progress.Lang.Class no-undo.
        define variable filterRegistry as BuilderRegistry no-undo.
        
        Assert:NotNull(filterTypeName, 'Filter type name').
        
        if HasOption('filterRegistry':u) then
            assign filterRegistry = cast(GetOptionObjectValue('filterRegistry':u), BuilderRegistry).
        else
            assign filterRegistry = LoggerFilterRegistry:Registry.
        
        Assert:IsType(filterRegistry:ValueType, get-class(ILoggerFilter)).
        
        assign filterType = filterRegistry:Get(filterTypeName).
        
        if valid-object(filterType) then
            Assert:IsType(filterType, get-class(ILoggerFilter)).
        
        return filterType.
    end method.
    
    /* Creates the instance.
       
       @return ILoggerFilter A filter instance  */
    method protected ILoggerFilter NewFilter():
        define variable logFilter as ILoggerFilter no-undo.
        define variable filterType as class Progress.Lang.Class no-undo.
        define variable formatString as character no-undo.
        define variable filterOptions as JsonObject no-undo.
        
        assign filterType = GetFilterType(this-object:FilterType).
        if not valid-object(filterType) then
            return logFilter.
        
        logFilter = dynamic-new string(filterType:TypeName) ().
        
        if type-of(logFilter, ISupportFormatting) then
        do:
            assign formatString = GetOptionStringValue('formatString':u).
            if     formatString eq ? 
               and HasOption('loggerOptions':u) then
            do:
                assign filterOptions = cast(GetOptionObjectValue('loggerOptions':u), JsonObject).
                if     valid-object(filterOptions) 
                   and filterOptions:Has('format':u) 
                   and filterOptions:GetType('format':u) eq JsonDataType:STRING then
                    assign formatString = filterOptions:GetCharacter('format':u).                        
            end.
            
            if formatString ne ? then
                assign cast(logFilter, ISupportFormatting):Format = formatString. 
        end.
        
        if type-of(logFilter, ISupportInitialize) then
            cast(logFilter, ISupportInitialize):Initialize().
        
        return logFilter.
    end method.
    
end class.
