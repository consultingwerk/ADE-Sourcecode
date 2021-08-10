/* *************************************************************************************************************************
Copyright (c) 2018-2020 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
 /*------------------------------------------------------------------------
    File        : GetTableResultCountResponse
    Description :
    Author(s)   : pjudge
    Created     : 2018-06-15
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.BusinessLogic.IGetTableResultCountResponse.
using OpenEdge.BusinessLogic.IO.JsonPropertyNameEnum.
using OpenEdge.Core.Assert.
using OpenEdge.Core.Json.IJsonSerializer.
using OpenEdge.Core.Json.JsonPropertyHelper.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.

class OpenEdge.BusinessLogic.GetTableResultCountResponse implements IGetTableResultCountResponse, IJsonSerializer:
    /* Returns is the result is exact (TRUE) or Guessed or Cached (FALSE) */
    define public property Exact as logical no-undo get. set.
    
    /* Returns the number of results for this table */
    define public property NumResults as int64 no-undo get. set.
    
    /* Returns the name of the table this result belongs to */
    define public property TableName as character no-undo
        get.
        private set.
    
    /* Default constructor */
    constructor public GetTableResultCountResponse():
        super().
    end constructor.
    
    /* Constructor
       
       @param character (mandatory) The table name for which to return this count
       @param int64 The number of records returned
       @param logical TRUE if this result is exact. */
    constructor public GetTableResultCountResponse (input pTableName as character,
                                                    input pNumResults as int64,
                                                    input pExact as logical):
        this-object(pTableName).
        
        Assert:NotUnknown(pExact, 'Exact flag').
        Assert:NotNull(pNumResults, 'Num results').
        
        assign this-object:Exact      = pExact
               this-object:NumResults = pNumResults
               .
    end constructor.
    
    /* Constructor
       
       @param character (mandatory) The table name for which to return this count */
    constructor public GetTableResultCountResponse (input pTableName as character):
        super ().
        
        Assert:NotNull(pTableName, 'Table name').
        assign this-object:TableName = pTableName.
    end constructor.
    
    /* Serializes this object
       
       @return JsonConstruct The serialized object. Always JsonObject. */
    method public JsonConstruct ToJsonConstruct():
        define variable data as JsonObject no-undo.
        
        assign data = new JsonObject().
        
        data:Add(string(JsonPropertyNameEnum:tableName),  TableName).
        data:Add(string(JsonPropertyNameEnum:exact),      Exact).
        data:Add(string(JsonPropertyNameEnum:numResults), NumResults).
        
        return data.
    end method.
    
    /* Deserializes this object
       
       @param JsonConstruct The serialized object - always a JsonObject. */
    method public void FromJson(input pData as JsonConstruct):
        define variable data as JsonObject no-undo.
        
        if    not valid-object(pData)
           or not type-of(pData, JsonObject)
        then
            return.
        
        assign data = cast(pData, JsonObject).
        
        if JsonPropertyHelper:HasTypedProperty(data, string(JsonPropertyNameEnum:tableName), JsonDataType:STRING) then
            assign TableName = data:GetCharacter(string(JsonPropertyNameEnum:tableName)).
        
        if JsonPropertyHelper:HasTypedProperty(data, string(JsonPropertyNameEnum:exact), JsonDataType:BOOLEAN) then
            assign Exact = data:GetLogical(string(JsonPropertyNameEnum:exact)).
        
        if JsonPropertyHelper:HasTypedProperty(data, string(JsonPropertyNameEnum:numResults), JsonDataType:NUMBER) then
            assign NumResults = data:GetInt64(string(JsonPropertyNameEnum:numResults)).
    end method.
    
end class.