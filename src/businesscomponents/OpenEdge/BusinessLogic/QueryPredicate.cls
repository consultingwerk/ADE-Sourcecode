/* *************************************************************************************************************************
Copyright (c) 2018-2021 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : QueryPredicate
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2018-06-15
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.BusinessLogic.IQueryPredicate.
using Ccs.BusinessLogic.JoinEnum.
using Ccs.BusinessLogic.QueryOperatorEnum.
using Ccs.Common.Support.IPrimitiveArrayHolder.
using Ccs.Common.Support.IPrimitiveHolder.
using OpenEdge.BusinessLogic.IO.JsonPropertyNameEnum.
using OpenEdge.Core.Assert.
using OpenEdge.Core.AssertionFailedError.
using OpenEdge.Core.Json.IJsonSerializer.
using OpenEdge.Core.Json.JsonConverter.
using OpenEdge.Core.Json.JsonPropertyHelper.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.

class OpenEdge.BusinessLogic.QueryPredicate implements IQueryPredicate, IJsonSerializer:

    /* Returns the name of the field for this query predicate */
    define public property FieldName as character no-undo
        get.
        private set.
    
    /* Returns the operator for this query predicate */
    define public property Join as JoinEnum no-undo
        get.
        set(input pJoin as JoinEnum):
            Assert:NotNull(pJoin, 'Join operator').
            
            assign this-object:Join = pJoin.
        end set.
    
    /* Returns the operator for this query predicate */
    define public property Operator as QueryOperatorEnum no-undo
        get.
        private set.
    
    /* Returns a single value for this query predicate */
    define public property Value as IPrimitiveHolder no-undo
        get.
        private set.
    
    /* Returns a list of values for this query predicate */
    define public property Values as IPrimitiveArrayHolder no-undo
        get.
        private set.
    
    /* Default constructor - for JSON deserialization only */
    constructor public QueryPredicate():
        super().
    end constructor.
    
    /* Constructor
       
       @param character (mandatory) The field name
       @param QueryOperatorEnum The operator
       @param IPrimitiveHolder The predicate value */
    constructor public QueryPredicate (input pFieldName as character,
                                       input pOperator as QueryOperatorEnum,
                                       input pValue as IPrimitiveHolder):
        this-object().
        Assert:NotNullOrEmpty(pFieldName, 'Predicate field name').
        Assert:NotNull(pValue, 'Predicate value holder ').
        
        Assert:NotNull(pOperator, 'Predicate operator').
        if    pOperator eq QueryOperatorEnum:InList
           or pOperator eq QueryOperatorEnum:InRange
        then
            undo, throw new AssertionFailedError(substitute('Predicate operator cannot be &1 for a scalar value',
                                                    string(pOperator))).
        
        assign this-object:FieldName = pFieldName
               this-object:Operator  = pOperator
               this-object:Value     = pValue
               .
    end constructor.
    
    /* Constructor
       
       @param character (mandatory) The field name
       @param QueryOperatorEnum The operator
       @param IPrimitiveArrayHolder The predicate value */
    constructor public QueryPredicate (input pFieldName as character,
                                       input pOperator as QueryOperatorEnum,
                                       input pValues as IPrimitiveArrayHolder):
        this-object().
        Assert:NotNullOrEmpty(pFieldName, 'Predicate field name').
        Assert:NotNull(pValues, 'Predicate values holder ').
        
        Assert:NotNull(pOperator, 'Predicate operator').
        if     not pOperator eq QueryOperatorEnum:InList
           and not pOperator eq QueryOperatorEnum:InRange
        then
            undo, throw new AssertionFailedError('Predicate operator must be InList or InRange for an array value').
        
        assign this-object:FieldName = pFieldName
               this-object:Operator  = pOperator
               this-object:Values    = pValues
               .
    end constructor.
    
    method override public character ToString():
        define variable strVal as character no-undo.
        
        assign strVal = trim(substitute('&1 &2 &3':u,
                               this-object:FieldName,
                               string(this-object:Operator),
                               (if valid-object(this-object:Value) then string(this-object:Value) else string(this-object:Values)))).
        // optionally, prefix this predicate with its join
        if valid-object(this-object:Join)
        and not this-object:Join eq JoinEnum:None
        then
            assign strVal = string(this-object:Join) + ' ':u + strVal.
        
        return strVal.
    end method.
     
    /* SERIALIZATION METHOD:returns a JsonConstruct (JsonDataType:OBJECT or JsonDataType:ARRAY) representation
       of this object.
       
       @return JsonConstruct A JSON representation of this object. May be unknown (JsonDataType:NULL). */
    method public JsonConstruct ToJsonConstruct():
        define variable data as JsonObject no-undo.
        
        assign data = new JsonObject().
        
        data:Add(string(JsonPropertyNameEnum:fieldName), this-object:FieldName).
        data:Add(string(JsonPropertyNameEnum:join),      string(this-object:Join)).
        data:Add(string(JsonPropertyNameEnum:operator),  string(this-object:Operator)).
        
        if valid-object(this-object:Values) then
            data:Add(string(JsonPropertyNameEnum:value), JsonConverter:ToArray(this-object:Values)).
        else
            JsonConverter:AddToObject(JsonPropertyNameEnum:value, this-object:Value, data).
        
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
        
        // JOIN
        if JsonPropertyHelper:HasTypedProperty(data, string(JsonPropertyNameEnum:join), JsonDataType:STRING) then
            assign this-object:Join = JoinEnum:GetEnum(data:GetCharacter(string(JsonPropertyNameEnum:join))).
        
        // OPERATOR
        if JsonPropertyHelper:HasTypedProperty(data, string(JsonPropertyNameEnum:operator), JsonDataType:STRING) then
            assign this-object:Operator = QueryOperatorEnum:GetEnum(data:GetCharacter(string(JsonPropertyNameEnum:operator))).
        
        // VALUE(S)
        if JsonPropertyHelper:HasTypedProperty(data, string(JsonPropertyNameEnum:value), JsonDataType:ARRAY) then
            assign this-object:Values = JsonConverter:ToPrimitiveArray(data:GetJsonArray(string(JsonPropertyNameEnum:value)))
                   this-object:Value = ?
                   .
        else
        if not JsonPropertyHelper:HasTypedProperty(data, string(JsonPropertyNameEnum:value), JsonDataType:NULL) then
            assign this-object:Value  = JsonConverter:ToScalar(data, string(JsonPropertyNameEnum:value))
                   this-object:Values = ?
                   .
        
    end method.
end class
.