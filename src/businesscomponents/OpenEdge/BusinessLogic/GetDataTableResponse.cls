/* *************************************************************************************************************************
Copyright (c) 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
 /*------------------------------------------------------------------------
    File        : GetDataTableResponse
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2018-06-15
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.BusinessLogic.IGetDataTableResponse.
using OpenEdge.Core.Assert.

class OpenEdge.BusinessLogic.GetDataTableResponse implements IGetDataTableResponse: 
    /* Returns the paging context to be passed back to the business entity when requesting the next set */ 
    define public property NextPagingContext as character no-undo get. set. 
    
    /* Returns the paging context to be passed back to the business entity when requesting the previous set */
    define public property PreviousPagingContext as character no-undo get. set. 
    
    /* Returns the name of the ProDataset Table */
    define public property TableName as character no-undo 
        get.
        private set. 
    
    /* Constructor
       
       @param character (mandatory) The table name for which to return this count */
    constructor public GetDataTableResponse (input pTableName as character):
        super ().
        
        Assert:NotNullOrEmpty(pTableName, 'Table name').
        assign this-object:TableName = pTableName.
    end constructor.

end class.