/* *************************************************************************************************************************
Copyright (c) 2018-2020 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : UpdateDataRequest
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2018-06-20
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.BusinessLogic.CommitScopeEnum.
using Ccs.BusinessLogic.IUpdateDataRequest.
using OpenEdge.BusinessLogic.IO.JsonPropertyNameEnum.
using OpenEdge.Core.Json.IJsonSerializer.
using OpenEdge.Core.Json.JsonPropertyHelper.
using OpenEdge.Core.Json.JsonSerializer.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.

class OpenEdge.BusinessLogic.UpdateDataRequest implements IUpdateDataRequest, IJsonSerializer:
    /* Returns the CommitScope to be used by the updateData method. The value is considered as a recommendation as 
       the Business Entity may ignore this setting and use a different commit scope based on the business logic 
       requirements */
    define public property CommitScope as CommitScopeEnum no-undo get. set. 
    
    /* Returns a custom request object */
    define public property CustomRequest as Progress.Lang.Object no-undo get. set.
    
    /* Serializes this object to JSON
       
       @return JsonConstruct a JSON Object representation of this object */
    method public JsonConstruct ToJsonConstruct():
        define variable responseData as JsonObject no-undo.
        
        assign responseData = new JsonObject().
        // COMMIT SCOPE
        responseData:Add(string(JsonPropertyNameEnum:commitScope), string(CommitScope)).
        
        // CUSTOM RESPONSE. Use the explicit 'serialize' because we don't know what OOABL type this custom object is
        responseData:Add(string(JsonPropertyNameEnum:customRequest), JsonSerializer:Serialize(this-object:CustomRequest)).
        
        return responseData.
    end method.
    
    /* Deserializes this object from JSON.
       
       @param JsonConstruct This object represented as JSON */
    method public void FromJson(input pJson as JsonConstruct):
        define variable data as JsonObject no-undo.
        
        if    not valid-object(pJson)
           or not type-of(pJson, JsonObject)
        then
            return.
        
        assign data = cast(pJson, JsonObject).
        
        // COMMIT SCOPE
        if JsonPropertyHelper:HasTypedProperty(data, string(JsonPropertyNameEnum:commitScope), JsonDataType:STRING) then
            assign this-object:CommitScope = CommitScopeEnum:GetEnum(data:GetCharacter(string(JsonPropertyNameEnum:commitScope))).
        
        // CUSTOM REQUEST
        if JsonPropertyHelper:HasTypedProperty(data, string(JsonPropertyNameEnum:customRequest), JsonDataType:OBJECT) then
        do:
            assign data                      = data:GetJsonObject(string(JsonPropertyNameEnum:customRequest))
                   this-object:CustomRequest = JsonSerializer:Deserialize(data)
                   .
            if not valid-object(this-object:CustomRequest) then
                assign this-object:CustomRequest = data.
        end.
    end method.
    
end class.