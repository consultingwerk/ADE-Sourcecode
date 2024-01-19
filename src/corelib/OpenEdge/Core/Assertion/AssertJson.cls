/************************************************
Copyright (c) 2014, 2019-2021, 2023 by Progress Software Corporation. All rights reserved.
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

using OpenEdge.Core.Assert.
using OpenEdge.Core.Assertion.AssertJson.
using OpenEdge.Core.AssertionFailedError.
using OpenEdge.Core.JsonDataTypeEnum.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonObject.

class OpenEdge.Core.Assertion.AssertJson:
    /** Asserts that a JSON object has a specific number of properties

        @param JsonObject The JSON object being checked
        @param integer The number of properties it must have
        @throws AssertionFailedError Error thrown if the JSON object is not valid
        @throws AssertionFailedError Error thrown if the property count is negative
        @throws AssertionFailedError Error thrown if the number of properties is not equal to the count */
    method public static void HasPropertyCount(input pJson as JsonObject,
                                               input pCnt as integer):
        var longchar[] propNames.
        var integer propCnt.

        Assert:NotNull(pJson, 'JSON Object').
        Assert:IsZeroOrPositive(pCnt, 'Property count').

        assign propNames = pJson:GetNames()
               propCnt   = extent(propNames)
               .
        if propCnt eq ? then
            assign propCnt = 0.

        Assert:Equals(pCnt, propCnt).
    end method.

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

    /** Asserts that an array extent value is null

        @param JsonArray The JSON object being checked
        @param integer The index being checked
        @throws AssertionFailedError Error thrown if the property does not exist */
    method public static void IndexIsNull(input pArray as JsonArray, input pIdx as integer):
        Assert:NotNull(pArray, 'JSON Array').
        Assert:IsPositive(pIdx, 'Array index').

        if pIdx gt pArray:Length then
            return error new AssertionFailedError(substitute('Index &1 is larger than the array size &2', pIdx, pArray:Length), 0).

        if not pArray:IsNull(pIdx) then
            return error new AssertionFailedError(
                            substitute('Index &1 must be null', pIdx) , 0).
    end method.

    /** Asserts that an array extent value is null

        @param JsonArray The JSON object being checked
        @param integer The index being checked
        @throws AssertionFailedError Error thrown if the property does not exist */
    method public static void IndexNotNull(input pArray as JsonArray, input pIdx as integer):
        Assert:NotNull(pArray, 'JSON Array').
        Assert:IsPositive(pIdx, 'Array index').

        if pIdx gt pArray:Length then
            return error new AssertionFailedError(substitute('Index &1 is larger than the array size &2', pIdx, pArray:Length), 0).

        if pArray:IsNull(pIdx) then
            return error new AssertionFailedError(
                            substitute('Index &1 must be not be null', pIdx) , 0).
    end method.

    /** Asserts that a JSON Array has a index of a particular type.

        @param JsonArray The JSON object being checked
        @param integer The index being checked
        @param JsonDataTypeEnum The data type being checked
        @throws AssertionFailedError Error thrown if the property does not exist */
    method public static void IndexIsType(input poArray as JsonArray,
                                          input piIdx as integer,
                                          input poPropertyType as JsonDataTypeEnum):
        Assert:NotNull(poArray, 'JSON Array').
        Assert:IsPositive(piIdx, 'Array index').

        if piIdx gt poArray:Length then
            return error new AssertionFailedError(substitute('Index &1 is larger than the array size &2', piIdx, poArray:Length), 0).

        {&_proparse_ prolint-nowarn(overflow)}
        if not poArray:GetType(piIdx) eq poPropertyType:GetValue() then
            return error new AssertionFailedError(
                            substitute('Index &1 must be of type &2', piIdx, string(poPropertyType)), 0).
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

        {&_proparse_ prolint-nowarn(overflow)}
        if not poObject:GetType(pcName) eq poPropertyType:GetValue() then
            return error new AssertionFailedError(
                            substitute('Property ~'&1~' must be of type &2',
                                            pcName,
                                            string(poPropertyType)) , 0).
    end method.

end class.