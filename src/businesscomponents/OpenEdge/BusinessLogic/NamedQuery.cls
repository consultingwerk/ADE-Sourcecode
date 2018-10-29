/* *************************************************************************************************************************
Copyright (c) 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
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
using OpenEdge.Core.Assert.

class OpenEdge.BusinessLogic.NamedQuery implements INamedQuery: 
    /*  Returns the name of the named query */
    define public property Name as character no-undo 
        get.
        private set. 
    
    /* Returns the array of (optional) parameters of the named query. Each Named Query Parameter consists of an
       identifier (name) and a value (primitive holder) or values (primitive array holder) */
    define public property Parameters as INamedQueryParameter extent no-undo get. set.
    
    /* Constructor
       
       @param character (mandatory) The query name  */
    constructor public NamedQuery (input pQryName as character):
        super ().
        
        Assert:NotNullOrEmpty(pQryName, 'Query name').
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
    
end class.