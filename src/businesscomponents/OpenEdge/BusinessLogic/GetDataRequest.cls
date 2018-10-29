/* *************************************************************************************************************************
Copyright (c) 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : GetDataRequest
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2018-06-15
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.BusinessLogic.IGetDataRequest.
using Ccs.BusinessLogic.IGetDataTableRequest.
using Ccs.BusinessLogic.INamedQuery.
using OpenEdge.Core.Assert.

class OpenEdge.BusinessLogic.GetDataRequest implements IGetDataRequest: 
    /* Returns the custom parameter object */
    define public property CustomParameter as Progress.Lang.Object no-undo get. set. 
    
    /* Returns the named query instance */
    define public property NamedQuery as INamedQuery no-undo get. set. 
    
    /* Returns the Table requests */
    define public property TableRequests as IGetDataTableRequest extent no-undo get. set. 
    
    /* Default constructor */
    constructor public GetDataRequest (  ):
        super ().
    end constructor.

    /* Constructor
       
       @param INamedQuery The named query for this request */
    constructor public GetDataRequest(input pQuery as INamedQuery):
        super().
        
        Assert:NotNull(pQuery, 'Named query').
        assign this-object:NamedQuery = pQuery.
    end constructor.
        
    /* Constructor
       
       @param integer A positive number, representing the number of tables in this response */
    constructor public GetDataRequest(input pNumTables as integer):
        super().
        
        Assert:IsPositive(pNumTables, 'Num tables').
        assign extent(TableRequests) = pNumTables.
    end constructor.
    
    /* Constructor
       
       @param IGetDataTableRequest[] The table requests */
    constructor public GetDataRequest(input pRequests as IGetDataTableRequest extent):
        super().
        
        Assert:HasDeterminateExtent(pRequests, 'Table requests').
        assign this-object:TableRequests = pRequests.
    end constructor.
    
end class.