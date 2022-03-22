/* *************************************************************************************************************************
Copyright (c) 2019, 2021 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : ConfigPropertyFilterBuilder
    Purpose     : Auto-sets filter properties from configbuilder values
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2019-07-26
    Notes       : * Properties must be
                    - for an instance (not static)
                    - publicly writable
                  * The type property and JSON property must be identical (case-insensitive comparison)
                  * Only properties of certain data types are set:
                   - character
                   - character[]: The property must be indeterminate or the extents of the config value
                                  and property must be equal
                   - decimal
                   - datetime-tz
                   - logical
                   - Progress.Lang.Object: The config type is checked against the property type
                  * If property values cannot be set, for any reason, they are simply skipped.
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.Filter.LogFilterBuilder.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Reflect.AccessMode.
using Progress.Reflect.DataType.
using Progress.Reflect.Property.

class OpenEdge.Logging.Filter.ConfigPropertyFilterBuilder inherits LogFilterBuilder:
    /* Constructor
       
       @param character The type of filter being build. */
    constructor public ConfigPropertyFilterBuilder (input pcFilterType as character):
        super (input pcFilterType).
    end constructor.
    
    /* Creates the instance.
       
       @return ILoggerFilter A filter instance  */
    method override protected ILoggerFilter NewFilter():
        define variable logFilter as ILoggerFilter no-undo.
        define variable filterType as class Progress.Lang.Class no-undo.
        
        assign filterType = GetFilterType(this-object:FilterType).
        if not valid-object(filterType) then
            return logFilter.
        
        logFilter = dynamic-new string(filterType:TypeName) ().
        
        SetPropValuesFromConfig(logFilter).
        
        if type-of(logFilter, ISupportInitialize) then
            cast(logFilter, ISupportInitialize):Initialize().
        
        return logFilter.
    end method.
    
    /* Sets any publicly writable property values from saved configuration.
       
       Only properties of certain data types are set:
       - character
       - character[]: The property must be indeterminate or the extents of the config value and property must be equal
       - decimal
       - datetime-tz
       - logical
       - Progress.Lang.Object: The config type is checked against the property type
       
       If property values cannot be set, for any reason, they are simply skipped.
       
       @param ILoggerFilter The filter instance on which to set values */
    method private void SetPropValuesFromConfig(input pFilter as ILoggerFilter):
        define variable filterProps as Property extent no-undo.
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        define variable objValue as Progress.Lang.Object no-undo.
        define variable chrValue as character extent no-undo.
        
        Assert:NotNull(pFilter, 'Logger filter instance').
        
        assign filterProps = pFilter:GetClass():GetProperties()
               cnt         = extent(filterProps)
               .
        PROPERTY-LOOP:
        do loop = 1 to cnt
           on error undo, throw:
           
            // ignore properties defined on Progress.Lang.Object. The EQ ? check is probably faster than
            // EQ GET-CLASS(Progress.Lang.Object)
            if filterProps[loop]:DeclaringClass:SuperClass eq ? then
                next PROPERTY-LOOP.
            
            // must be able to set the value
            if     filterProps[loop]:CanWrite
               and not filterProps[loop]:SetterAccessMode eq AccessMode:Public
            then
                next PROPERTY-LOOP.
            
            if not HasOption(filterProps[loop]:Name) then
                next PROPERTY-LOOP.
            
            // data types must match; the GetOption*Value method throws an error if the stored type isn't as expected
            // by the name
            if filterProps[loop]:Extent eq 0 then
            case filterProps[loop]:DataType:
                when DataType:Character then
                    filterProps[loop]:Set(pFilter, GetOptionStringValue(filterProps[loop]:Name)).
                
                when DataType:Decimal then
                    filterProps[loop]:Set(pFilter, GetOptionNumericValue(filterProps[loop]:Name)).
                
                when DataType:Logical then
                    filterProps[loop]:Set(pFilter, GetOptionLogicalValue(filterProps[loop]:Name)).
                
                when DataType:DateTimeTZ then
                do:
                    // assume strings are in ISO-DATE format
                    if GetOptionType(filterProps[loop]:Name) eq 'string':u then
                        filterProps[loop]:Set(pFilter, datetime-tz(GetOptionStringValue(filterProps[loop]:Name))).
                    else
                        filterProps[loop]:Set(pFilter, GetOptionDateTimeValue(filterProps[loop]:Name)).
                end.
                
                when DataType:Object then
                do:
                    assign objValue = GetOptionObjectValue(filterProps[loop]:Name).
                    // the stored option value must be of the property's declared type
                    if     valid-object(objValue)
                       and not objValue:GetClass():IsA(filterProps[loop]:DataTypeName)
                    then
                        next PROPERTY-LOOP.
                    
                    filterProps[loop]:Set(pFilter, objValue).
                end.
            end case.
            else
            case filterProps[loop]:DataType:
                when DataType:Character then
                do:
                    assign extent(chrValue) = ?
                           chrValue         = GetOptionStringArrayValue(filterProps[loop]:Name)
                           .
                    if    filterProps[loop]:Extent eq ?
                       or filterProps[loop]:Extent eq extent(chrValue)
                    then
                        filterProps[loop]:Set(pFilter, chrValue).
                end.
            end case.
            
            {&_proparse_ prolint-nowarn(varusage)}
            catch uncaught as Progress.Lang.Error:
                // no-op: see method comment
            end catch.
        end.    // PROPERTY-LOOP
    end method.
    
end class.