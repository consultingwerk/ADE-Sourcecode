/* *************************************************************************************************************************
Copyright (c) 2018-2021 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : GetDataTableRequest
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2018-06-15
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.BusinessLogic.IGetDataTableRequest.
using Ccs.BusinessLogic.IQueryDefinition.
using Ccs.BusinessLogic.IQueryEntry.
using Ccs.BusinessLogic.IQuerySortEntry.
using OpenEdge.BusinessLogic.IO.JsonPropertyNameEnum.
using OpenEdge.BusinessLogic.QueryDefinition.
using OpenEdge.BusinessLogic.Filter.FilterParser.
using OpenEdge.BusinessLogic.Filter.AblFilterParser.
using OpenEdge.Core.Assert.
using OpenEdge.Core.Json.IJsonSerializer.
using OpenEdge.Core.Json.JsonConverter.
using OpenEdge.Core.Json.JsonPropertyHelper.
using OpenEdge.Core.Json.JsonSerializer.
using OpenEdge.Core.String.
using OpenEdge.Core.StringConstant.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.

class OpenEdge.BusinessLogic.GetDataTableRequest implements IGetDataTableRequest, IJsonSerializer:
    /* Returns the number of records requested by the caller of the Business Entity getData method */
    define public property NumRecords as int64 no-undo get. set.
    
    /* Returns the paging context */
    define public property PagingContext as character no-undo get. set.
    
    /* Returns the abstract query defintion for this request */
    define public property QueryDefinition as IQueryDefinition no-undo get. set.
    
    /* Returns the Query String for this table */
    define public property QueryString as character no-undo get. set.
    
    /* Returns the number of records to skip */
    define public property Skip as int64 no-undo get. set.
    
    /* Returns the name of the ProDataset Table */
    define public property TableName as character no-undo
        get.
        private set.
    
    /* Default constructor */
    constructor public GetDataTableRequest ():
        this-object('':u).
    end constructor.
    
    /* Constructor
       
       @param character (mandatory) The table name for which to return this count */
    constructor public GetDataTableRequest (input pTableName as character):
        super().
        
        Assert:NotNull(pTableName, 'Table name').
        assign this-object:TableName = pTableName.
    end constructor.
    
    method override public character ToString():
        return substitute('&1: qry:&2; num-rec:&3; skip:&4',
                this-object:TableName,
                (if valid-object(this-object:QueryDefinition) then this-object:QueryDefinition:ToString() else this-object:QueryString),
                this-object:NumRecords,
                this-object:Skip
                ).
    end method.
    
    /* Serializes this object to JSON
       
       @return JsonConstruct a JSON Object representation of this object */
    method public JsonConstruct ToJsonConstruct():
        define variable data as JsonObject no-undo.
        
        assign data = new JsonObject().
        
        data:Add(string(JsonPropertyNameEnum:tableName), this-object:TableName).
        data:Add(string(JsonPropertyNameEnum:pagingCtx), this-object:PagingContext).
        data:Add(string(JsonPropertyNameEnum:top),       this-object:NumRecords).
        data:Add(string(JsonPropertyNameEnum:skip),      this-object:Skip).
        
        if not this-object:QueryString eq '':u then
            data:Add(string(JsonPropertyNameEnum:query), this-object:QueryString).
        else
            JsonConverter:AddToObject(JsonPropertyNameEnum:query, this-object:QueryDefinition, data).
        
        return data.
    end method.
    
    /* Turns JSON into an object.
       
       - This method expects a JSON object
       - If the "query" property is a string, this method tries to convert it to a IQueryDefinition object
       
       @param JsonConstruct The input JSON */
    method public void FromJson(input pJson as JsonConstruct):
        define variable data as JsonObject no-undo.
        define variable fp as FilterParser no-undo.
        define variable qd as QueryDefinition no-undo.
        define variable qryWhere as character no-undo.
        define variable qryString as String no-undo.
        
        if not valid-object(pJson)
        or not type-of(pJson, JsonObject)
        then
            return.
        
        assign data = cast(pJson, JsonObject).
        
        if JsonPropertyHelper:HasTypedProperty(data, string(JsonPropertyNameEnum:tableName), JsonDataType:STRING) then
            assign this-object:TableName = data:GetCharacter(string(JsonPropertyNameEnum:tableName)).
        
        if JsonPropertyHelper:HasTypedProperty(data, string(JsonPropertyNameEnum:pagingCtx), JsonDataType:STRING) then
            assign this-object:PagingContext = data:GetCharacter(string(JsonPropertyNameEnum:pagingCtx)).
        
        if JsonPropertyHelper:HasTypedProperty(data, string(JsonPropertyNameEnum:top), JsonDataType:NUMBER) then
            assign this-object:NumRecords = data:GetInt64(string(JsonPropertyNameEnum:top)).
        
        if JsonPropertyHelper:HasTypedProperty(data, string(JsonPropertyNameEnum:skip), JsonDataType:NUMBER) then
            assign this-object:Skip = data:GetInt64(string(JsonPropertyNameEnum:skip)).
        
        if JsonPropertyHelper:HasTypedProperty(data, string(JsonPropertyNameEnum:query), JsonDataType:STRING) then
            assign qryWhere = data:GetCharacter(string(JsonPropertyNameEnum:query))
                   
                   fp = new AblFilterParser()
                   qd = new QueryDefinition()
                   this-object:QueryDefinition = qd
                   // parse the string for "where" and "by" expressions
                   qryString         = new String(qryWhere)
                   qd:QuerySelection = fp:ParseWhere(qryString)
                   qd:QuerySort      = fp:ParseSortBy(qryString)
                   .
        else
        if JsonPropertyHelper:HasTypedProperty(data, string(JsonPropertyNameEnum:query), JsonDataType:OBJECT) then
            assign this-object:QueryDefinition = cast(JsonSerializer:ToAblObject(data:GetJsonObject(string(JsonPropertyNameEnum:query)),
                                                                                 get-class(IQueryDefinition),
                                                                                 get-class(QueryDefinition)),
                                                      IQueryDefinition).
    end method.
    
end class.
