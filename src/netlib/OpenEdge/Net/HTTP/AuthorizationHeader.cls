/* *************************************************************************************************************************
Copyright (c) 2017 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : AuthorizationHeader
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2017-12-05
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.StringConstant.
using OpenEdge.Net.HTTP.HttpHeader.
using Progress.Lang.AppError.
using OpenEdge.Core.Assert.

class OpenEdge.Net.HTTP.AuthorizationHeader inherits HttpHeader:
    /* Constructor
    
       @param character A non-empty header name */
    constructor public AuthorizationHeader(input pName as character):
        super (pName).
        
        assign this-object:ParamDelimiter = StringConstant:SPACE.
    end constructor.
    
    /* Constructor
       
       @param character A non-empty header name
       @param character A valid header value    */
    constructor public AuthorizationHeader (input pName as character, input pValue as character):
        super (input pName, input pValue).
    end constructor.
    
    /* Validates a header value. Should throw an error if the value
       is not valid.
       
       @param character The (prospective) header value */
    method override protected void Validate(input pValue as character):
        super:Validate(pValue).
        
        if num-entries(pValue, StringConstant:SPACE) lt 2 then
            undo, throw new AppError(substitute('Authorization header value must have at least 2 " "-delimited parts: &1', pValue), 0).
    end method.
    
end class.