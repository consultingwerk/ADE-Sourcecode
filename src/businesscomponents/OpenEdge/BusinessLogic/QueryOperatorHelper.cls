/************************************************
Copyright (c)  2018 by Progress Software Corporation. All rights reserved.
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

class OpenEdge.BusinessLogic.QueryOperatorHelper: 

    /* Helper method to turn a string operator into an enum
       
       @param character The operator
       @param QueryOperatorEnum An enum operator  */
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
            when 'new':u then
                return QueryOperatorEnum:Ne.
            
            when 'startswith':u then
                return QueryOperatorEnum:Begins.
            
            otherwise
                return QueryOperatorEnum:GetEnum(pOperator).
        end.
        
    end method.
    
end class.