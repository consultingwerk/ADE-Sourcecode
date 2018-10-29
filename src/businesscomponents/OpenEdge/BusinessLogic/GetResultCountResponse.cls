/* *************************************************************************************************************************
Copyright (c) 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
 /*------------------------------------------------------------------------
    File        : GetResultCountResponse
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2018-06-15
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.BusinessLogic.IGetResultCountResponse.
using Ccs.BusinessLogic.IGetTableResultCountResponse.
using OpenEdge.Core.Assert.

class OpenEdge.BusinessLogic.GetResultCountResponse implements IGetResultCountResponse:
    
    /* Returns the result counts per requested table */
    define public property ResultCounts as IGetTableResultCountResponse extent no-undo get. set. 
    
    /* default constructor */
    constructor public GetResultCountResponse (  ):
        super ().
    end constructor.
    
    /* Constructor
       
       @param integer A positive number, representing the number of tables in this response */
    constructor public GetResultCountResponse(input pNumTables as integer):
        super().
        
        Assert:IsPositive(pNumTables, 'Num tables').
        assign extent(ResultCounts) = pNumTables.
    end constructor.
    
    /* Constructor
       
       @param IGetTableResultCountResponse[] The table responses */
    constructor public GetResultCountResponse(input pCounts as IGetTableResultCountResponse extent):
        super().
        
        Assert:HasDeterminateExtent(pCounts, 'Result counts').
        assign this-object:ResultCounts = pCounts.
    end constructor.
    
end class.