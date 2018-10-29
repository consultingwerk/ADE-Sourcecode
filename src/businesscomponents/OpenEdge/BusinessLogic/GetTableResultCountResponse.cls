/* *************************************************************************************************************************
Copyright (c) 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
 /*------------------------------------------------------------------------
    File        : GetTableResultCountResponse
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2018-06-15
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.BusinessLogic.IGetTableResultCountResponse.
using OpenEdge.Core.Assert.

class OpenEdge.BusinessLogic.GetTableResultCountResponse implements IGetTableResultCountResponse: 
    /* Returns is the result is exact (TRUE) or Guessed or Cached (FALSE) */
    define public property Exact as logical no-undo get. set. 
    
    /* Returns the number of results for this table */
    define public property NumResults as int64 no-undo get. set. 
    
    /* Returns the name of the table this result belongs to */
    define public property TableName as character no-undo
        get.
        private set.
    
    /* Constructor
       
       @param character (mandatory) The table name for which to return this count
       @param int64 The number of records returned
       @param logical TRUE if this result is exact. */
    constructor public GetTableResultCountResponse (input pTableName as character,
                                                    input pNumResults as int64,
                                                    input pExact as logical):
        this-object(pTableName).
        
        Assert:NotUnknown(pExact, 'Exact flag').
        Assert:NotNull(pNumResults, 'Num results').
        
        assign this-object:Exact      = pExact
               this-object:NumResults = pNumResults
               .
    end constructor.
    
    /* Constructor
       
       @param character (mandatory) The table name for which to return this count */
    constructor public GetTableResultCountResponse (input pTableName as character):
        super ().
        
        Assert:NotNullOrEmpty(pTableName, 'Table name').
        assign this-object:TableName = pTableName.
    end constructor.
end class.