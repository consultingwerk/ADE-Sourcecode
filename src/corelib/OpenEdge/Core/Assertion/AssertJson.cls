/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : AssertJson
    Purpose     : Assertions specific to JSON constructs
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Nov 05 16:37:30 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.AssertionFailedError.
using Progress.Json.ObjectModel.JsonObject.
using OpenEdge.Core.Assert.
using OpenEdge.Core.Assertion.AssertJson.
using OpenEdge.Core.JsonDataTypeEnum.

class OpenEdge.Core.Assertion.AssertJson:
    
    /** Asserts that a Json object has a particularly-named property (of any type).
        
        @param JsonObject The JSON object being checked
        @param character The name of the property being checked
        @throws AssertionFailedError Error thrown if the property does not exist */
    method public static void HasProperty(input poObject as JsonObject, input pcName as character):
        Assert:NotNull(poObject, 'JSON Object').
        Assert:NotNullOrEmpty(pcName, 'Property name').
        
        if not poObject:Has(pcName) then
            return error new AssertionFailedError(
                            substitute('JSON Object does not have a property named ~'&1~'', pcName) , 0).
    end method.

    /** Asserts that a the value of a property is null
        
        @param JsonObject The JSON object being checked
        @param character The name of the property being checked
        @throws AssertionFailedError Error thrown if the property does not exist */
    method public static void PropertyIsNull(input poObject as JsonObject, input pcName as character):
        AssertJson:HasProperty(poObject, pcName).
        
        if not poObject:IsNull(pcName) then
            return error new AssertionFailedError(
                            substitute('Property ~'&1~' must be null', pcName) , 0).
    end method.
    
    /** Asserts that a the value of a property is not null
        
        @param JsonObject The JSON object being checked
        @param character The name of the property being checked
        @throws AssertionFailedError Error thrown if the property does not exist */
    method public static void PropertyNotNull(input poObject as JsonObject, input pcName as character):
        AssertJson:HasProperty(poObject, pcName).
        
        if poObject:IsNull(pcName) then
            return error new AssertionFailedError(
                            substitute('Property ~'&1~' must not be null', pcName) , 0).
    end method.

    /** Asserts that a JSON Object has a particularly-named property of a 
        particular type.
        
        @param JsonObject The JSON object being checked
        @param character The name of the property being checked
        @param JsonDataTypeEnum The data type being checked
        @throws AssertionFailedError Error thrown if the property does not exist */
    method public static void PropertyIsType(input poObject as JsonObject,
                                             input pcName as character,
                                             input poPropertyType as JsonDataTypeEnum):
        AssertJson:HasProperty(poObject, pcName).
        Assert:NotNull(poPropertyType, 'Property type').
        
        if not poObject:GetType(pcName) eq poPropertyType:Value then
            return error new AssertionFailedError(
                            substitute('Property ~'&1~' must be of type &2',
                                            pcName,
                                            poPropertyType:Name) , 0).
    end method.
    
end class.