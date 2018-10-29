/* *************************************************************************************************************************
Copyright (c) 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : GetDataTableRequest
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2018-06-15
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.BusinessLogic.IGetDataTableRequest.
using Ccs.BusinessLogic.IQueryDefinition.
using OpenEdge.Core.Assert.

class OpenEdge.BusinessLogic.GetDataTableRequest implements IGetDataTableRequest:
     
    /* Returns the number of records requested by the caller of the Business Entity getData method */
    define public property NumRecords as int64 no-undo get. set.
    
    /* Returns the paging context */
    define public property PagingContext as character no-undo get. set. 
    
    /* Returns the abstract query defintion for this request */
    define public property QueryDefinition as IQueryDefinition no-undo get. set. 
    
    /* Returns the Query String for this table */
    define public property QueryString as character no-undo get. set. 
    
    /* Returns the number of records to skip */
    define public property Skip as int64 no-undo get. set. 
    
    /* Returns the name of the ProDataset Table */
    define public property TableName as character no-undo 
        get.
        private set. 
    
    /* Default constructor */
    constructor public GetDataTableRequest ():
        this-object('':u).
    end constructor.
    
    /* Constructor
       
       @param character (mandatory) The table name for which to return this count */
    constructor public GetDataTableRequest (input pTableName as character):
        super().
        
        Assert:NotNull(pTableName, 'Table name').
        assign this-object:TableName = pTableName.
    end constructor.
    
    method override public character ToString():
        return substitute('&1: qry:&2; num-rec:&3; skip:&4',
                this-object:TableName,
                (if valid-object(this-object:QueryDefinition) then this-object:QueryDefinition:ToString() else this-object:QueryString),
                this-object:NumRecords,
                this-object:Skip
                ).
    end method.
    
end class.