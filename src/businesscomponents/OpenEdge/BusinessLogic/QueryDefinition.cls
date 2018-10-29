/* *************************************************************************************************************************
Copyright (c) 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : QueryDefinition
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2018-06-15
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.BusinessLogic.IQueryDefinition.
using Ccs.BusinessLogic.IQueryEntry.
using Ccs.BusinessLogic.IQuerySortEntry.
using OpenEdge.Core.Assert.

class OpenEdge.BusinessLogic.QueryDefinition implements IQueryDefinition: 
    /* Returns the list of query predicates or query groups for this query definition */
    define public property QuerySelection as IQueryEntry no-undo get. set. 
    
    /* Returns the list of query sort entries */
    define public property QuerySort as IQuerySortEntry extent no-undo get. set.
    
    /* Default constructor */
    constructor public QueryDefinition():
        super ().
    end constructor.
    
    /* Constructor.
       
       @param IQueryEntry The query selection phrase */
    constructor public QueryDefinition(input pEntry as IQueryEntry):
        this-object().
        
        Assert:NotNull(pEntry, 'Query entry').
        assign this-object:QuerySelection = pEntry.
    end constructor.

    /* Constructor.
       
       @param IQueryEntry The query selection phrase
       @param IQuerySortEntry[] Sort phrases */
    constructor public QueryDefinition(input pEntry as IQueryEntry,
                                       input pSort as IQuerySortEntry extent):
        this-object(pEntry).
        
        Assert:HasDeterminateExtent(pSort, 'Query sort entries').
        assign this-object:QuerySort = pSort.
    end constructor.
    
    method override public character ToString():
        define variable qrySort as character no-undo.
        define variable cnt as integer no-undo.
        define variable loop as integer no-undo.
        
        assign cnt     = extent(this-object:QuerySort)
               qrySort = '[':u
               .
        do loop = 1 to cnt:
            assign qrySort = qrySort + '],[':u.
            if valid-object(this-object:QuerySort[loop]) then
                assign qrySort = qrySort + this-object:QuerySort[loop]:ToString().
            else
                assign qrySort = qrySort + '?':u.
        end.
        assign qrySort = qrySort + ']':u.
        
        return substitute('selection:&1; sort:&2',
                (if valid-object(this-object:QuerySelection) then this-object:QuerySelection:ToString() else ?),
                qrySort ).
    end method.
    
end class.