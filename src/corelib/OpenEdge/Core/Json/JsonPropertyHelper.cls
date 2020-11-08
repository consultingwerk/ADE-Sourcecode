/* *************************************************************************************************************************
Copyright (c) 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : JsonPropertyHelper
    Purpose     : General JSON property value helper
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2018-12-13
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.

class OpenEdge.Core.Json.JsonPropertyHelper:
    /* Indicates whether a JSON object has a property of a specific
       name and JSON type.
       
       @param JsonObject The JSON object containing the property
       @param character The property name
       @return logical TRUE if the parent is valid AND the property exists AND is of the specified type */
    method static public logical HasTypedProperty(input pParent as JsonObject,
                                                  input pProperty as character,
                                                  input pJsonType as integer):
        if   pProperty eq '':u
           or pProperty eq ?
           or not valid-object(pParent)
           or pJsonType lt 1
           or pJsonType gt 6
        then
            return false.
        
        return     valid-object(pParent)
               and pParent:Has(pProperty)
               and pParent:GetType(pProperty) eq pJsonType.
    end method.
    
    /* Returns a JSON array for a named property
       
       @param JsonObject The JSON object into which to upsert the property
       @param character The property name
       @param logical TRUE if the method should always return a valid JSON array. FALSE will return
                       an unknown value if an property does not yet exist of the specific type even if
                       the property exists with a different datatype.
       @return JsonArray The JSON array. May be unknown/invalid */
    method static public JsonArray GetArrayValue(input pParent as JsonObject,
                                                 input pProperty as character,
                                                 input pAlwaysReturn as logical):
        define variable propVal as JsonArray no-undo.
        
        Assert:NotNull(pParent, 'Parent JSON').
        Assert:NotNullOrEmpty(pProperty, 'Property name').
        
        if pParent:Has(pProperty) then
        do:
            if pParent:GetType(pProperty) eq JsonDataType:ARRAY then
                assign propVal = pParent:GetJsonArray(pProperty).
            else
            if pAlwaysReturn then
            do:
                assign propVal = new JsonArray(). 
                pParent:Set(pProperty, propVal).
            end.
        end.
        else
        if pAlwaysReturn then
        do:
            assign propVal = new JsonArray(). 
            pParent:Add(pProperty, propVal).
        end.
        
        return propVal.
    end method.
    
    /* Returns a JSON object for a named property
       
       @param JsonObject The JSON object into which to upsert the property
       @param character The property name
       @param logical TRUE if the method should always return a valid JSON array. FALSE will return
                      an unknown value if an property does not yet exist of the specific type
                      even if the property exists with a different datatype
       @return JsonObject The JSON object. May be unknown/invalid */
    method static public JsonObject GetObjectValue(input pParent as JsonObject,
                                                   input pProperty as character,
                                                   input pAlwaysReturn as logical):
        define variable propVal as JsonObject no-undo.
        
        Assert:NotNull(pParent, 'Parent JSON').
        Assert:NotNullOrEmpty(pProperty, 'Property name').
        
        if pParent:Has(pProperty) then
        do:
            if pParent:GetType(pProperty) eq JsonDataType:OBJECT then
                assign propVal = pParent:GetJsonObject(pProperty).
            else
            if pAlwaysReturn then
            do:
                assign propVal = new JsonObject(). 
                pParent:Set(pProperty, propVal).
            end.
        end.
        else
        if pAlwaysReturn then
        do:
            assign propVal = new JsonObject(). 
            pParent:Add(pProperty, propVal).
        end.
        
        return propVal.
    end method.
    
end class.