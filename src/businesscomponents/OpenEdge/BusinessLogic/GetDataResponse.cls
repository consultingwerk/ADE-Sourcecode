/* *************************************************************************************************************************
Copyright (c) 2018-2020 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : GetDataResponse
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2018-06-15
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.BusinessLogic.IGetDataResponse.
using Ccs.BusinessLogic.IGetDataTableResponse.
using OpenEdge.BusinessLogic.GetDataTableResponse.
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

class OpenEdge.BusinessLogic.GetDataResponse implements IGetDataResponse, IJsonSerializer:
    /* Returns the custom response object */
    define public property CustomResponse as Progress.Lang.Object no-undo get. set. 
    
    /* Returns the Table requests*/
    define public property TableResponses as IGetDataTableResponse extent no-undo get. set.
    
    /* Default constructor */
    constructor public GetDataResponse():
        super ().
    end constructor.
    
    /* Constructor
       
       @param integer A positive number, representing the number of tables in this response */
    constructor public GetDataResponse(input pNumTables as integer):
        super().
        
        Assert:IsPositive(pNumTables, 'Num tables').
        assign extent(TableResponses) = pNumTables.
    end constructor.
    
    /* Constructor
       
       @param IGetDataTableResponse A positive number, representing the number of tables in this response */
    constructor public GetDataResponse(input pResponses as IGetDataTableResponse extent):
        super().
        
        Assert:HasDeterminateExtent(pResponses, 'Table responses').
        assign this-object:TableResponses = pResponses.
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
        
        // process the responses array
        if JsonPropertyHelper:HasTypedProperty(data, string(JsonPropertyNameEnum:responses), JsonDataType:ARRAY) then
        do:
            assign ja     = data:GetJsonArray(string(JsonPropertyNameEnum:responses))
                   cnt    = ja:Length
                   extent(TableResponses) = ?
                   extent(TableResponses) = cnt
                   .
            ARRAY-LOOP:
            do loop = 1 to cnt:
                if ja:GetType(loop) eq JsonDataType:OBJECT then
                    assign TableResponses[loop] = cast(JsonSerializer:ToAblObject(ja:GetJsonObject(loop),
                                                                                  get-class(IGetDataTableResponse),
                                                                                  get-class(GetDataTableResponse)),
                                                       IGetDataTableResponse)
                           .
            end.
        end.
        
        // the custom response
        if JsonPropertyHelper:HasTypedProperty(data, string(JsonPropertyNameEnum:customResponse), JsonDataType:OBJECT) then
        do: 
            assign data                       = data:GetJsonObject(string(JsonPropertyNameEnum:customResponse))
                   this-object:CustomResponse = JsonSerializer:Deserialize(data)
                   .
            if not valid-object(this-object:CustomResponse) then
                assign this-object:CustomResponse = data.
        end.
    end method.
    
    /* Serializes this object to JSON
       
       - The tablerequest array is serialized in 
       - the CustomResponse object is serialized using standard OE-serialzation
       
       @return JsonConstruct a JSON Object representation of this object */
    method public JsonConstruct ToJsonConstruct():
        define variable responseData as JsonObject no-undo.
        
        assign responseData = new JsonObject().
        
        // TABLE RESPONSES
        responseData:Add(string(JsonPropertyNameEnum:responses),      JsonConverter:ToArray(this-object:TableResponses)).
        
        // CUSTOM RESPONSE. Use the explicit 'serialize' because we don't know what OOABL type this custom object is
        responseData:Add(string(JsonPropertyNameEnum:customResponse), JsonSerializer:Serialize(this-object:CustomResponse)).
        
        return responseData.
    end method.
    
end class.