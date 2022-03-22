/************************************************
Copyright (c) 2018, 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : QueryOperatorHelper
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2018-06-15
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.BusinessLogic.QueryOperatorEnum.
using OpenEdge.BusinessLogic.QueryOperatorHelper.

class OpenEdge.BusinessLogic.QueryOperatorHelper:

    {&_proparse_ prolint-nowarn(varusage)}
    var static private character mOperatorNames.
    
    /* Static constructor */
    constructor static QueryOperatorHelper():
        assign mOperatorNames = get-class(QueryOperatorEnum):GetEnumNames().
    end constructor.
    
    /* Helper method to turn a string operator into an enum
       
       @param character The operator
       @param QueryOperatorEnum An enum operator. UNKNOWN/NULL if it cannot be converted into an enum */
    method static public QueryOperatorEnum ToEnum(input pOperator as character):
        case pOperator:
            when '':u or
            when ? then
                return ?.
            
            when '=':u or
            when 'eq':u then
                return QueryOperatorEnum:Eq.
            
            when '>':u or
            when 'gt':u then
                return QueryOperatorEnum:Gt.
            
            when '>=':u or
            when 'ge':u or
            when 'gte':u then
                return QueryOperatorEnum:Ge.
            
            when '<':u or
            when 'lt':u then
                return QueryOperatorEnum:Lt.
            
            when '<=':u or
            when 'le':u or
            when 'lte':u then
                return QueryOperatorEnum:Le.
            
            when '<>':u or
            when 'neq':u then
                return QueryOperatorEnum:Ne.
            
            when 'startswith':u or
            when 'beginswith':u then
                return QueryOperatorEnum:Begins.
            
            when 'endswith':u then
                return QueryOperatorEnum:Matches.
            
            otherwise
                // if this is an actual operator then return the enum
                if lookup(pOperator, QueryOperatorHelper:mOperatorNames) eq 0 then
                    return ?.
                else
                    return QueryOperatorEnum:GetEnum(pOperator).
        end case.
    end method.
    
end class.