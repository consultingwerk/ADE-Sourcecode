/* *************************************************************************************************************************
Copyright (c) 2018-2020 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : NamedQuery
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2018-06-15
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.BusinessLogic.INamedQuery.
using Ccs.BusinessLogic.INamedQueryParameter.
using OpenEdge.BusinessLogic.IO.JsonPropertyNameEnum.
using OpenEdge.BusinessLogic.NamedQueryParameter.
using OpenEdge.Core.Assert.
using OpenEdge.Core.Json.IJsonSerializer.
using OpenEdge.Core.Json.JsonConverter.
using OpenEdge.Core.Json.JsonPropertyHelper.
using OpenEdge.Core.Json.JsonSerializer.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.

class OpenEdge.BusinessLogic.NamedQuery implements INamedQuery, IJsonSerializer: 
    /*  Returns the name of the named query */
    define public property Name as character no-undo 
        get.
        private set. 
    
    /* Returns the array of (optional) parameters of the named query. Each Named Query Parameter consists of an
       identifier (name) and a value (primitive holder) or values (primitive array holder) */
    define public property Parameters as INamedQueryParameter extent no-undo
        get.
        set.
    
    /* Default constructor. Needed for IJsonSerializer */
    constructor public NamedQuery():
        this-object('':u).
    end constructor.
    
    /* Constructor
       
       @param character (mandatory) The query name  */
    constructor public NamedQuery (input pQryName as character):
        super ().
        
        Assert:NotNull(pQryName, 'Query name').
        assign this-object:Name = pQryName.
    end constructor.
    
    /* Constructor
       
       @param character (mandatory) The query name  
       @param integer A positive number, representing the number of parameters */
    constructor public NamedQuery(input pQryName as character,
                                  input pNumParams as integer):
        this-object(pQryName).
        
        Assert:IsPositive(pNumParams , 'Num query parameters'). 
        assign extent(Parameters) = pNumParams .
    end constructor.
    
    /* Constructor
       
       @param character (mandatory) The query name  
       @param INamedQueryParameter[] The named query parameters */
    constructor public NamedQuery(input pQryName as character,
                                  input pParams as INamedQueryParameter extent):
        this-object(pQryName).
        
        Assert:HasDeterminateExtent(pParams , 'Query parameters'). 
        assign this-object:Parameters = pParams .
    end constructor.
    
    /* Serializes this object
       
       @return JsonConstruct The serialized object. Always JsonObject. */
    method public JsonConstruct ToJsonConstruct():
        define variable data as JsonObject no-undo.
        
        data = new JsonObject().
        
        data:Add(string(JsonPropertyNameEnum:name),   Name).
        data:Add(string(JsonPropertyNameEnum:params), JsonConverter:ToArray(this-object:Parameters)).
        
        return data.
    end method.
    
    /* Deserializes this object
       
       @param JsonConstruct The serialized object - always a JsonObject. */
    method public void FromJson( input pJson as JsonConstruct):
        define variable data as JsonObject no-undo.
        define variable ja as JsonArray no-undo.
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        
        if    not valid-object(pJson)
           or not type-of(pJson, JsonObject)
        then
            return.
        
        assign data = cast(pJson, JsonObject).
        
        if JsonPropertyHelper:HasTypedProperty(data, string(JsonPropertyNameEnum:name), JsonDataType:STRING) then
            assign this-object:Name = data:GetCharacter(string(JsonPropertyNameEnum:name)).
        
        if JsonPropertyHelper:HasTypedProperty(data, string(JsonPropertyNameEnum:params), JsonDataType:ARRAY) then
        do:
            assign ja  = data:GetJsonArray(string(JsonPropertyNameEnum:params))
                   cnt = ja:Length
                   extent(Parameters) = ?
                   extent(Parameters) = cnt
                   .
            ARRAY-LOOP:
            do loop = 1 to cnt:
                if ja:GetType(loop) eq JsonDataType:OBJECT then
                    assign Parameters[loop] = cast(JsonSerializer:ToAblObject(ja:GetJsonObject(loop),
                                                                              get-class(INamedQueryParameter),
                                                                              get-class(NamedQueryParameter)),
                                                   INamedQueryParameter).
            end.
        end.
    end method.
end class.