/* *************************************************************************************************************************
Copyright (c) 2018, 2020 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : GetDataRequest
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2018-06-15
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.BusinessLogic.IGetDataRequest.
using Ccs.BusinessLogic.IGetDataTableRequest.
using Ccs.BusinessLogic.INamedQuery.
using OpenEdge.BusinessLogic.GetDataTableRequest.
using OpenEdge.BusinessLogic.IO.JsonPropertyNameEnum.
using OpenEdge.BusinessLogic.NamedQuery.
using OpenEdge.Core.Assert.
using OpenEdge.Core.Json.IJsonSerializer.
using OpenEdge.Core.Json.JsonConverter.
using OpenEdge.Core.Json.JsonPropertyHelper.
using OpenEdge.Core.Json.JsonSerializer.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.

class OpenEdge.BusinessLogic.GetDataRequest implements IGetDataRequest, IJsonSerializer: 
    /* Returns the custom parameter object */
    define public property CustomParameter as Progress.Lang.Object no-undo get. set. 
    
    /* Returns the named query instance */
    define public property NamedQuery as INamedQuery no-undo get. set. 
    
    /* Returns the Table requests */
    define public property TableRequests as IGetDataTableRequest extent no-undo get. set. 
    
    /* Default constructor */
    constructor public GetDataRequest():
        super ().
    end constructor.

    /* Constructor
       
       @param INamedQuery The named query for this request */
    constructor public GetDataRequest(input pQuery as INamedQuery):
        super().
        
        Assert:NotNull(pQuery, 'Named query').
        assign this-object:NamedQuery = pQuery.
    end constructor.
    
    /* Constructor
       
       @param integer A positive number, representing the number of tables in this response */
    constructor public GetDataRequest(input pNumTables as integer):
        super().
        
        Assert:IsPositive(pNumTables, 'Num tables').
        assign extent(TableRequests) = pNumTables.
    end constructor.
    
    /* Constructor
       
       @param IGetDataTableRequest[] The table requests */
    constructor public GetDataRequest(input pRequests as IGetDataTableRequest extent):
        super().
        
        assign this-object:TableRequests = pRequests.
    end constructor.
    
    /* Deserializes this object from JSON.
       
       @param JsonConstruct This object represented as JSON */
    method public void FromJson(input pJson as JsonConstruct):
        define variable data as JsonObject no-undo.
        define variable ja as JsonArray no-undo.
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        
        if    not valid-object(pJson)
           or not type-of(pJson, JsonObject)
        then
            return.
        
        assign data = cast(pJson, JsonObject).
        
        // NAMED QUERY
        if JsonPropertyHelper:HasTypedProperty(data, string(JsonPropertyNameEnum:namedQuery), JsonDataType:OBJECT) then
            assign NamedQuery = cast(JsonSerializer:ToAblObject(data:GetJsonObject(string(JsonPropertyNameEnum:namedQuery)),
                                                                get-class(INamedQuery),
                                                                get-class(NamedQuery)),
                                     INamedQuery).
        
        // TABLE REQUESTS
        if JsonPropertyHelper:HasTypedProperty(data, string(JsonPropertyNameEnum:requests), JsonDataType:ARRAY) then
        do:
            assign ja     = data:GetJsonArray(string(JsonPropertyNameEnum:requests))
                   cnt    = ja:Length
                   extent(TableRequests) = ?
                   extent(TableRequests) = cnt
                   .
            ARRAY-LOOP:
            do loop = 1 to cnt:
                if ja:GetType(loop) eq JsonDataType:OBJECT then
                    assign TableRequests[loop] = cast(JsonSerializer:ToAblObject(ja:GetJsonObject(loop),
                                                                                 get-class(IGetDataTableRequest),
                                                                                 get-class(GetDataTableRequest)),
                                                      IGetDataTableRequest).
            end.
        end.
        
        // CUSTOM PARAMETER
        if JsonPropertyHelper:HasTypedProperty(data, string(JsonPropertyNameEnum:customParameter), JsonDataType:OBJECT) then
        do:
            assign data                        = data:GetJsonObject(string(JsonPropertyNameEnum:customParameter))
                   this-object:CustomParameter = JsonSerializer:Deserialize(data)
                   .
            if not valid-object(this-object:CustomParameter) then
                assign this-object:CustomParameter = data.
        end.
    end method.
    
    /* Serializes this object to JSON
       
       @return JsonConstruct a JSON Object representation of this object */
    method public JsonConstruct ToJsonConstruct():
        define variable responseData as JsonObject no-undo.
        
        assign responseData = new JsonObject().
        
        // NAMED QUERY
        JsonConverter:AddToObject(JsonPropertyNameEnum:namedQuery,
                                  this-object:NamedQuery,
                                  responseData).
        
        // TABLE REQUESTS
        responseData:Add(string(JsonPropertyNameEnum:requests),
                         JsonConverter:ToArray(this-object:TableRequests)).
        
        // CUSTOM PARAMETER
        responseData:Add(string(JsonPropertyNameEnum:customParameter),
                         JsonSerializer:Serialize(this-object:CustomParameter)).
        
        return responseData.
    end method.
    
end class.