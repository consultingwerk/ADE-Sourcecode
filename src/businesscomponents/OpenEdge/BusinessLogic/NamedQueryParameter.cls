/* *************************************************************************************************************************
Copyright (c) 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : NamedQueryParameter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2018-06-15
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.BusinessLogic.INamedQueryParameter.
using Ccs.Common.Support.IPrimitiveArrayHolder.
using Ccs.Common.Support.IPrimitiveHolder.
using OpenEdge.Core.Assert.

class OpenEdge.BusinessLogic.NamedQueryParameter implements INamedQueryParameter: 
    
    /* Returns the name of the named query parameter */
    define public property Name as character no-undo 
        get.
        private set. 
    
    /* Returns a single value for this named query parameter */
    define public property Value as IPrimitiveHolder no-undo
        get.
        set(input pValue as IPrimitiveHolder ):
            Assert:NotNull(pValue, 'Parameter value holder').
            assign this-object:Value = pValue.
        end set. 
    
    /* Returns a list of values for this named query parameter */
    define public property Values as IPrimitiveArrayHolder no-undo
        get.
        set(input pValues as IPrimitiveArrayHolder ):
            Assert:NotNull(pValues, 'Parameter value holder').
            assign this-object:Values = pValues.
        end set.
    
    /* Constructor
       
       @param character (mandatory) The parameter name */
    constructor public NamedQueryParameter(input pName as character):
        super ().
        
        Assert:NotNullOrEmpty(pName, 'Parameter name').
        assign this-object:Name = pName.
    end constructor.

    /* Constructor
       
       @param character (mandatory) The parameter name 
       @param IPrimitiveHolder The parameter value */
    constructor public NamedQueryParameter(input pName as character,
                                           input pValue as IPrimitiveHolder):
        this-object(pName).
        
        assign this-object:Value = pValue.
    end constructor.

    /* Constructor
       
       @param character (mandatory) The parameter name
       @param IPrimitiveArrayHolder The parameter values */
    constructor public NamedQueryParameter(input pName as character,
                                           input pValues as IPrimitiveArrayHolder):
        this-object(pName).
        
        assign this-object:Values = pValues.
    end constructor.

end class.