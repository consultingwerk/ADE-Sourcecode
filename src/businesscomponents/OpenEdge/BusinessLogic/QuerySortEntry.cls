/* *************************************************************************************************************************
Copyright (c) 2018-2020 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : QuerySortEntry
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2018-06-15
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.BusinessLogic.IQuerySortEntry.
using Ccs.BusinessLogic.SortOrderEnum.
using OpenEdge.BusinessLogic.IO.JsonPropertyNameEnum.
using OpenEdge.Core.Assert.
using OpenEdge.Core.Json.IJsonSerializer.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonObject.
using OpenEdge.Core.Json.JsonPropertyHelper.
using Progress.Json.ObjectModel.JsonDataType.
 
class OpenEdge.BusinessLogic.QuerySortEntry implements IQuerySortEntry, IJsonSerializer:
    /* Returns the name of the field for this query sort entry */
    define public property FieldName as character no-undo
        get.
        private set. 
    
    /* Returns the sort order for this query sort entry */
    define public property SortOrder as SortOrderEnum no-undo get. set.
    
    /* Constructor
       
       @param character (mandatory) The field name
       @param SortOrderEnum (mandatory) The sort direction */
    constructor public QuerySortEntry (input pFieldName as character,
                                       input pSortDirection as SortOrderEnum):
        Assert:NotNull(pFieldName, 'Field name').
        Assert:NotNull(pSortDirection, 'Sort direction').
        
        assign this-object:FieldName = pFieldName
               this-object:SortOrder = pSortDirection
               .
    end constructor.
    
    /* Default constructor */
    constructor public QuerySortEntry():
        this-object('':u, SortOrderEnum:Ascending).
    end constructor.
    
    /* Constructor
       
       @param character (mandatory) The field name  */
    constructor public QuerySortEntry (input pFieldName as character):
        this-object(pFieldName, SortOrderEnum:Ascending).
    end constructor.
    
    method override public character ToString():
        return substitute("field: &1; direction: &2":u,
                          this-object:FieldName, (if this-object:SortOrder eq SortOrderEnum:descending then "desc":u else "asc":u)).
    end method.
    
    /* SERIALIZATION METHOD:returns a JsonConstruct (JsonDataType:OBJECT or JsonDataType:ARRAY) representation 
       of this object.
       
       @return JsonConstruct A JSON representation of this object. May be unknown (JsonDataType:NULL). */
    method public JsonConstruct ToJsonConstruct():
        define variable data as JsonObject no-undo.
        
        assign data = new JsonObject().
        data:Add(string(JsonPropertyNameEnum:fieldName), this-object:FieldName).
        data:Add(string(JsonPropertyNameEnum:order),     string(this-object:SortOrder)).
        
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
        
        // FIELD NAME
        if JsonPropertyHelper:HasTypedProperty(data, string(JsonPropertyNameEnum:fieldName), JsonDataType:STRING) then
            assign this-object:FieldName = data:GetCharacter(string(JsonPropertyNameEnum:fieldName)).
        
        // SORT ORDER
        if JsonPropertyHelper:HasTypedProperty(data, string(JsonPropertyNameEnum:order), JsonDataType:STRING) then
            assign this-object:SortOrder = SortOrderEnum:GetEnum(data:GetCharacter(string(JsonPropertyNameEnum:order))).
    end method.

end class.