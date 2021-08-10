/* *************************************************************************************************************************
Copyright (c) 2018-2020 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : NamedQueryParameter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2018-06-15
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.BusinessLogic.INamedQueryParameter.
using Ccs.Common.Support.IPrimitiveArrayHolder.
using Ccs.Common.Support.IPrimitiveHolder.
using OpenEdge.BusinessLogic.IO.JsonPropertyNameEnum.
using OpenEdge.Core.Assert.
using OpenEdge.Core.Json.IJsonSerializer.
using OpenEdge.Core.Json.JsonConverter.
using OpenEdge.Core.Json.JsonPropertyHelper.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.

class OpenEdge.BusinessLogic.NamedQueryParameter implements INamedQueryParameter, IJsonSerializer: 
    
    /* Returns the name of the named query parameter */
    define public property Name as character no-undo 
        get.
        private set. 
    
    /* Returns a single value for this named query parameter */
    define public property Value as IPrimitiveHolder no-undo
        get.
        set(input pValue as IPrimitiveHolder ):
            Assert:NotNull(pValue, 'Parameter value holder').
            assign this-object:Value = pValue.
        end set. 
    
    /* Returns a list of values for this named query parameter */
    define public property Values as IPrimitiveArrayHolder no-undo
        get.
        set(input pValues as IPrimitiveArrayHolder ):
            Assert:NotNull(pValues, 'Parameter value holder').
            assign this-object:Values = pValues.
        end set.
    
    /* Default Constructor */
    constructor public NamedQueryParameter():
        this-object('':u).
    end constructor.

    /* Constructor
       
       @param character (mandatory) The parameter name */
    constructor public NamedQueryParameter(input pName as character):
        super ().
        
        Assert:NotNull(pName, 'Parameter name').
        assign this-object:Name = pName.
    end constructor.

    /* Constructor
       
       @param character (mandatory) The parameter name 
       @param IPrimitiveHolder The parameter value */
    constructor public NamedQueryParameter(input pName as character,
                                           input pValue as IPrimitiveHolder):
        this-object(pName).
        
        assign this-object:Value = pValue.
    end constructor.

    /* Constructor
       
       @param character (mandatory) The parameter name
       @param IPrimitiveArrayHolder The parameter values */
    constructor public NamedQueryParameter(input pName as character,
                                           input pValues as IPrimitiveArrayHolder):
        this-object(pName).
        
        assign this-object:Values = pValues.
    end constructor.
    
    /* Serializes this object
       
       @return JsonConstruct The serialized object. Always JsonObject. */
    method public JsonConstruct ToJsonConstruct():
        define variable data as JsonObject no-undo.
        
        assign data = new JsonObject().
        data:Add(string(JsonPropertyNameEnum:name), Name).

        if valid-object(this-object:Values) then
            JsonConverter:AddToObject(JsonPropertyNameEnum:value, this-object:Values, data).
        else
            JsonConverter:AddToObject(JsonPropertyNameEnum:value, this-object:Value, data). 
        
        return data.
    end method.
    
    /* Deserializes this object
       
       @param JsonConstruct The serialized object - always a JsonObject. */
    method public void FromJson( input pJson as JsonConstruct):
        define variable data as JsonObject no-undo.
        
        if    not valid-object(pJson)
           or not type-of(pJson, JsonObject)
        then
            return.
            
        assign data = cast(pJson, JsonObject).
        
        if JsonPropertyHelper:HasTypedProperty(data, string(JsonPropertyNameEnum:name), JsonDataType:STRING) then
            assign this-object:Name = data:GetCharacter(string(JsonPropertyNameEnum:name)).
        
        if data:Has(string(JsonPropertyNameEnum:value)) then
        case data:GetType(string(JsonPropertyNameEnum:value)):
            when JsonDataType:NULL then
                assign this-object:Value = ?. 
            
            when JsonDataType:ARRAY then
                assign this-object:Values = JsonConverter:ToPrimitiveArray(data:GetJsonArray(string(JsonPropertyNameEnum:value))).
            
            otherwise
                assign this-object:Value = JsonConverter:ToScalar(data, string(JsonPropertyNameEnum:value)). 
        end case.
    end method.
end class.