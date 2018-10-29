/* *************************************************************************************************************************
Copyright (c) 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : GetDataResponse
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2018-06-15
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.BusinessLogic.IGetDataResponse.
using Ccs.BusinessLogic.IGetDataTableResponse.
using OpenEdge.Core.Assert.

class OpenEdge.BusinessLogic.GetDataResponse implements IGetDataResponse: 
    /* Returns the custom response object */
    define public property CustomResponse as Progress.Lang.Object no-undo get. set. 
    
    /* Returns the Table requests*/
    define public property TableResponses as IGetDataTableResponse extent no-undo get. set.
    
    /* Default constructor */        
    constructor public GetDataResponse():
        super ().
    end constructor.
    
    /* Constructor
       
       @param integer A positive number, representing the number of tables in this response */
    constructor public GetDataResponse(input pNumTables as integer):
        super().
        
        Assert:IsPositive(pNumTables, 'Num tables').
        assign extent(TableResponses) = pNumTables.
    end constructor.

    /* Constructor
       
       @param IGetDataTableResponse A positive number, representing the number of tables in this response */
    constructor public GetDataResponse(input pResponses as IGetDataTableResponse extent):
        super().
        
        Assert:HasDeterminateExtent(pResponses, 'Table responses').
        assign this-object:TableResponses = pResponses.
    end constructor.
    
end class.