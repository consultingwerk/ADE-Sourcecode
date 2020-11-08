/* *************************************************************************************************************************
Copyright (c) 2018-2019 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
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
using OpenEdge.Core.Assert.
using OpenEdge.Core.AssertionFailedError.

class OpenEdge.BusinessLogic.QueryPredicate implements IQueryPredicate:

    /* Returns the name of the field for this query predicate */
    define public property FieldName as character no-undo 
        get.
        private set. 
    
    /* Returns the operator for this query predicate */
    define public property Join as JoinEnum no-undo get. set. 
    
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
    
    /* Constructor
       
       @param character (mandatory) The field name 
       @param QueryOperatorEnum The operator 
       @param IPrimitiveHolder The predicate value */
    constructor public QueryPredicate (input pFieldName as character,
                                       input pOperator as QueryOperatorEnum,
                                       input pValue as IPrimitiveHolder):
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
        return trim(substitute('&1 &2 &3 &4',
                               this-object:FieldName,
                               this-object:Operator:ToString(),
                               (if valid-object(this-object:Value) then this-object:Value:ToString() else if valid-object(this-object:Values) then this-object:Values:ToString() else ?),
                               (if valid-object(this-object:Join) then this-object:Join:ToString() else '':u))).
    end method.
 
end class
.