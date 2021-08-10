/* *************************************************************************************************************************
Copyright (c) 2018, 2020 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
 /*------------------------------------------------------------------------
    File        : GetResultCountResponse
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2018-06-15
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.BusinessLogic.IGetResultCountResponse.
using Ccs.BusinessLogic.IGetTableResultCountResponse.
using OpenEdge.BusinessLogic.GetTableResultCountResponse.
using OpenEdge.BusinessLogic.IO.JsonPropertyNameEnum.
using OpenEdge.Core.Assert.
using OpenEdge.Core.Json.IJsonSerializer.
using OpenEdge.Core.Json.JsonConverter.
using OpenEdge.Core.Json.JsonPropertyHelper.
using OpenEdge.Core.Json.JsonSerializer.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.

class OpenEdge.BusinessLogic.GetResultCountResponse implements IGetResultCountResponse, IJsonSerializer:
    /* Returns the result counts per requested table */
    define public property ResultCounts as IGetTableResultCountResponse extent no-undo get. set. 
    
    /* default constructor */
    constructor public GetResultCountResponse ():
        super ().
    end constructor.
    
    /* Constructor
       
       @param integer A positive number, representing the number of tables in this response */
    constructor public GetResultCountResponse(input pNumTables as integer):
        super().
        
        Assert:IsPositive(pNumTables, 'Num tables').
        assign extent(ResultCounts) = pNumTables.
    end constructor.
    
    /* Constructor
       
       @param IGetTableResultCountResponse[] The table responses */
    constructor public GetResultCountResponse(input pCounts as IGetTableResultCountResponse extent):
        super().
        
        Assert:HasDeterminateExtent(pCounts, 'Result counts').
        assign this-object:ResultCounts = pCounts.
    end constructor.
    
    /* Deserializes this object from JSON.
       
       @param JsonConstruct This object represented as JSON */
    method public void FromJson(input pJson as JsonConstruct):
        define variable data as JsonObject no-undo.
        define variable ja as JsonArray no-undo.
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        
        if not valid-object(pJson) 
        or not type-of(pJson, JsonObject)
        then
            return.
        
        assign data = cast(pJson, JsonObject).
        
        // process the responses array
        if JsonPropertyHelper:HasTypedProperty(data, string(JsonPropertyNameEnum:resultCounts), JsonDataType:ARRAY) then
        do:
            assign ja     = data:GetJsonArray(string(JsonPropertyNameEnum:resultCounts))
                   cnt    = ja:Length
                   // reset
                   extent(ResultCounts) = ?
                   extent(ResultCounts) = cnt
                   .
            ARRAY-LOOP:
            do loop = 1 to cnt:
                if ja:GetType(loop) eq JsonDataType:OBJECT then
                    assign this-object:ResultCounts[loop] = cast(JsonSerializer:ToAblObject(ja:GetJsonObject(loop),
                                                                                            get-class(IGetTableResultCountResponse),
                                                                                            get-class(GetTableResultCountResponse)),
                                                                 IGetTableResultCountResponse).
            end.
        end.
    end method.
    
    method public JsonConstruct ToJsonConstruct():
        define variable responseData as JsonObject no-undo.
        
        assign responseData = new JsonObject().
        responseData:Add(string(JsonPropertyNameEnum:resultCounts), JsonConverter:ToArray(ResultCounts)).
        
        return responseData.
    end method.
    
end class.