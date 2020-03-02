/* *************************************************************************************************************************
Copyright (c) 2018-2019 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : QueryGroup
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2018-06-15
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.BusinessLogic.IQueryEntry.
using Ccs.BusinessLogic.IQueryGroup.
using Ccs.BusinessLogic.JoinEnum.
using OpenEdge.Core.Assert.

class OpenEdge.BusinessLogic.QueryGroup implements IQueryGroup:

    /* Returns the array of query predicates and nested query groups */
    define public property Entries as IQueryEntry extent no-undo get. set.
    
    /* Returns the logical operator that shold be used to join this query entry to its predecessor in the current list */
    define public property Join as JoinEnum no-undo get. set.
    
    /* Default constructor */
    constructor public QueryGroup (  ):
        super ().
    end constructor.
    
    /* Constructor
       
       @param integer The number of query entries in this group */
    constructor public QueryGroup(input pNumEntries as integer):
        super ().
        
        Assert:IsPositive(pNumEntries, 'Num query entries '). 
        assign extent(Entries) = pNumEntries.
    end constructor.

    method override public character ToString():
        define variable queryString as character no-undo.
        define variable cnt as integer no-undo.
        define variable loop as integer no-undo.

        assign cnt = extent(this-object:Entries).

        do loop = 1 to cnt:
            queryString = substitute('&1 &2 (&3)',
                                     trim(queryString),
                                     if queryString eq "" then "" else this-object:Join:ToString(),
                                     trim(this-object:Entries[loop]:ToString())).
        end.

        return trim(queryString).
    end method.

end class.