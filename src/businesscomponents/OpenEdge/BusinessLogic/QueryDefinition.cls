/* *************************************************************************************************************************
Copyright (c) 2018-2020 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : QueryDefinition
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2018-06-15
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.BusinessLogic.IQueryDefinition.
using Ccs.BusinessLogic.IQueryEntry.
using Ccs.BusinessLogic.IQuerySortEntry.
using OpenEdge.BusinessLogic.IO.JsonPropertyNameEnum.
using OpenEdge.BusinessLogic.IO.QueryEntryDeserializer.
using OpenEdge.Core.Assert.
using OpenEdge.Core.Json.IJsonSerializer.
using OpenEdge.Core.Json.JsonConverter.
using OpenEdge.Core.Json.JsonPropertyHelper.
using OpenEdge.Core.Json.JsonSerializer.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.

class OpenEdge.BusinessLogic.QueryDefinition implements IQueryDefinition, IJsonSerializer:
    
    /* Returns the list of query predicates or query groups for this query definition */
    define public property QuerySelection as IQueryEntry no-undo get. set. 
    
    /* Returns the list of query sort entries */
    define public property QuerySort as IQuerySortEntry extent no-undo get. set.
    
    /* Default constructor */
    constructor public QueryDefinition():
        super ().
    end constructor.
    
    /* Constructor.
       
       @param IQueryEntry The query selection phrase */
    constructor public QueryDefinition(input pEntry as IQueryEntry):
        this-object().
        
        Assert:NotNull(pEntry, 'Query entry').
        assign this-object:QuerySelection = pEntry.
    end constructor.
    
    /* Constructor.
       
       @param IQueryEntry The query selection phrase
       @param IQuerySortEntry[] Sort phrases */
    constructor public QueryDefinition(input pEntry as IQueryEntry,
                                       input pSort as IQuerySortEntry extent):
        this-object(pEntry).
        
        assign this-object:QuerySort = pSort.
    end constructor.
    
    method override public character ToString():
        define variable qrySort as character no-undo.
        define variable cnt as integer no-undo.
        define variable loop as integer no-undo.
        
        assign cnt = extent(this-object:QuerySort).
        do loop = 1 to cnt:
            assign qrySort = qrySort + '[':u.
            if valid-object(this-object:QuerySort[loop]) then
                assign qrySort = qrySort + this-object:QuerySort[loop]:ToString().
            else
                assign qrySort = qrySort + '?':u.
        end.
        if not cnt eq ? then
            assign qrySort = qrySort + ']':u.
        
        return substitute('selection: &1; sort: &2',
                (if valid-object(this-object:QuerySelection) then this-object:QuerySelection:ToString() else ?),
                qrySort ).
    end method.
    
    /* SERIALIZATION METHOD:returns a JsonConstruct (JsonDataType:OBJECT or JsonDataType:ARRAY) representation 
       of this object.
       
       @return JsonConstruct A JSON representation of this object. May be unknown (JsonDataType:NULL). */
    method public JsonConstruct ToJsonConstruct():
        define variable data as JsonObject no-undo.
        
        assign data = new JsonObject().
        
        JsonConverter:AddToObject(JsonPropertyNameEnum:filter, this-object:QuerySelection, data).
        data:Add(string(JsonPropertyNameEnum:sort), JsonConverter:ToArray(this-object:QuerySort)).
        
        return data.
    end method.
    
    /* DESERIALIZATION METHOD: populates this object with data from the JSON representation.
       
       @param JsonConstruct A JSON representation of this object. May be unknown (JsonDataType:NULL). */
    method public void FromJson(input pJson as JsonConstruct):
        define variable data as JsonObject no-undo.
        
        if    not valid-object(pJson)
           or not type-of(pJson, JsonObject) 
        then
            return.
        
        assign data = cast(pJson, JsonObject).
        
        if JsonPropertyHelper:HasTypedProperty(data, string(JsonPropertyNameEnum:filter), JsonDataType:OBJECT) then
            assign this-object:QuerySelection = QueryEntryDeserializer:QueryEntryFromJson(data:GetJsonObject(string(JsonPropertyNameEnum:filter))).
        
        if JsonPropertyHelper:HasTypedProperty(data, string(JsonPropertyNameEnum:sort), JsonDataType:ARRAY) then
            assign this-object:QuerySort = cast(JsonSerializer:Deserialize(data:GetJsonArray(string(JsonPropertyNameEnum:sort))),
                                                IQuerySortEntry).
    end method.
end class.