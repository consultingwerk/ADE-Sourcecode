/************************************************
Copyright (c) 2019 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : FilterParser
    Purpose     : A parent/abstract filter parse class for creating
                  objects data requests for a CCS Business Entity's getData()
                  and getResultCount() operations
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-12-07
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.BusinessLogic.IGetDataRequest.
using Ccs.BusinessLogic.IQueryEntry.
using Ccs.BusinessLogic.IQuerySortEntry.
using OpenEdge.Core.Assert.

class OpenEdge.BusinessLogic.Filter.FilterParser abstract:
    /* An ordered set of table names used to create this filter.
       Typically just one, but potentially more */
    define public property FilterTable as character extent no-undo
        get.
        private set.
    
    /* Default constructor. */
    constructor public FilterParser():
        this-object('':u).
    end constructor.
    
    /* Constructor.
       
       @param character (mandatory) A table name for which to construct the filter */
    constructor public FilterParser(input pTable as character):
        super().
        Assert:NotNull(pTable, 'Table name').
        assign extent(FilterTable)        = 1
               this-object:FilterTable[1] = pTable
               .
    end constructor.
    
    /* Constructor.
       
       @param character[] (mandatory) An array of table name for which to construct the filter */
    constructor public FilterParser(input pTable as character extent):
        super().
        Assert:NotNull(pTable, 'Table name').
        assign this-object:FilterTable = pTable.
    end constructor.
    
    /* Reads and processes (parses) a complete data filter.
       
       @param P.L.Object The filter data
       @param IGetDataRequest A new filter object */
    method abstract public IGetDataRequest Parse(input pData as Progress.Lang.Object).
    
    /* Parses where/filter phrase and returns an IQueryEntry object for a single table
       
       @param P.L.Object The filter/where clause data
       @return IQueryEntry The query entry.We return one of an IQueryPredicate (single clause) 
                           or an IQueryGroup (many clauses) */
    method abstract public IQueryEntry ParseWhere(input pWhere as Progress.Lang.Object).
    
    /* Parses an SORT-BY phrase and returns an array of IQuerySortEntry objects.
       
       @param P.L.Object The SORT-BY data
       @return IQuerySortEntry[] An array of sort phrases. An indeterminate array is returned if the input phrase is empty */
    method abstract public IQuerySortEntry extent ParseSortBy(input pSortBy as Progress.Lang.Object).
    
end class.