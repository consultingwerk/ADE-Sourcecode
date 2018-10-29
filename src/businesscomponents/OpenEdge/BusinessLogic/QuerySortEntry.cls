/* *************************************************************************************************************************
Copyright (c) 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : QuerySortEntry
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2018-06-15
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.BusinessLogic.IQuerySortEntry.
using Ccs.BusinessLogic.SortOrderEnum.
using OpenEdge.Core.Assert.

class OpenEdge.BusinessLogic.QuerySortEntry implements IQuerySortEntry:
    /* Returns the name of the field for this query sort entry */
    define public property FieldName as character no-undo
        get.
        private set. 
    
    /* Returns the sort order for this query sort entry */
    define public property SortOrder as SortOrderEnum no-undo get. set.
    
    /* Constructor
       
       @param character (mandatory) The field name
       @param SortOrderEnum (mandatory) The sort direction */
    constructor public QuerySortEntry (input pFieldName as character,
                                       input pSortDirection as SortOrderEnum):
        Assert:NotNullOrEmpty(pFieldName, 'Field name').
        Assert:NotNull(pSortDirection, 'Sort direction').
        
        assign this-object:FieldName = pFieldName
               this-object:SortOrder = pSortDirection
               .
    end constructor.
    
    /* Constructor
       
       @param character (mandatory) The field name  */
    constructor public QuerySortEntry (input pFieldName as character):
        this-object(pFieldName, SortOrderEnum:Ascending).
    end constructor.
    
end class.