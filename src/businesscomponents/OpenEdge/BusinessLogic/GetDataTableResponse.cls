/* *************************************************************************************************************************
Copyright (c) 2018-2020 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
 /*------------------------------------------------------------------------
    File        : GetDataTableResponse
    Description : 
    Author(s)   : pjudge
    Created     : 2018-06-15
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.BusinessLogic.IGetDataTableResponse.
using OpenEdge.BusinessLogic.IO.JsonPropertyNameEnum.
using OpenEdge.Core.Assert.
using OpenEdge.Core.Json.IJsonSerializer.
using OpenEdge.Core.Json.JsonPropertyHelper.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.

class OpenEdge.BusinessLogic.GetDataTableResponse implements IGetDataTableResponse, IJsonSerializer:
    /* Returns the paging context to be passed back to the business entity when requesting the next set */ 
    define public property NextPagingContext as character no-undo get. set. 
    
    /* Returns the paging context to be passed back to the business entity when requesting the previous set */
    define public property PreviousPagingContext as character no-undo get. set. 
    
    /* Returns the name of the ProDataset Table */
    define public property TableName as character no-undo 
        get.
        private set. 
    
    /* Default constructor */
    constructor public GetDataTableResponse():
        this-object('':u).
    end constructor.
    
    /* Constructor
       
       @param character (mandatory) The table name for which to return this count */
    constructor public GetDataTableResponse(input pTableName as character):
        super ().
        
        Assert:NotNull(pTableName, 'Table name').
        assign this-object:TableName = pTableName.
    end constructor.
    
    /* Serializes this object
       
       @return JsonConstruct The serialized object. Always JsonObject. */
    method public JsonConstruct ToJsonConstruct():
        define variable data as JsonObject no-undo.
        
        assign data = new JsonObject().
        
        data:Add(string(JsonPropertyNameEnum:tableName),     TableName).
        data:Add(string(JsonPropertyNameEnum:nextPagingCtx), NextPagingContext).
        data:Add(string(JsonPropertyNameEnum:prevPagingCtx), PreviousPagingContext).
        
        return data.
    end method.
    
    /* Desrializes this object
       
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
        
        if JsonPropertyHelper:HasTypedProperty(data, string(JsonPropertyNameEnum:nextPagingCtx), JsonDataType:STRING) then
            assign NextPagingContext = data:GetCharacter(string(JsonPropertyNameEnum:nextPagingCtx)). 
        
        if JsonPropertyHelper:HasTypedProperty(data, string(JsonPropertyNameEnum:prevPagingCtx), JsonDataType:STRING) then
            assign PreviousPagingContext = data:GetCharacter(string(JsonPropertyNameEnum:prevPagingCtx)). 
    end method.
    
end class.