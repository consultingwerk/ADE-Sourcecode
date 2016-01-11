/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : ListIterator
    Purpose     : 
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Wed Jan 02 23:38:28 EST 2008
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.
using Progress.Lang.Object.
using OpenEdge.Core.Collections.ICollection.
using OpenEdge.Core.Collections.IListIterator.
using OpenEdge.Core.Collections.Iterator.

class OpenEdge.Core.Collections.ListIterator inherits Iterator implements IListIterator:

    constructor public ListIterator (poCol as ICollection,tt as handle, objField as char, seqField as char):
        super (poCol,tt,objfield, seqField).               
    end constructor. 
    
    constructor public ListIterator (poCol as ICollection,tt as handle, objField as char, seqField as char,querystring as char):
        super (poCol,tt,objfield, seqField, querystring).               
    end constructor. 
      
    method public logical HasPrevious(  ):
        define variable offend as logical no-undo.
        if QueryHandle:query-off-end then 
        do:
            QueryHandle:reposition-backward(1).
            offend = QueryHandle:query-off-end.
            QueryHandle:reposition-forward(1).
            return not offend. 
        end. 
        else 
            return QueryHandle:current-result-row > 1.       
    end method.        
    
    method public Object Previous(  ):
        QueryHandle:get-prev().
          return if BufferHandle:avail then ObjectFieldHandle:buffer-value() else ?. 
    end method.
    
    method public integer PreviousIndex(  ):
        if QueryHandle:query-off-end = false then 
            return QueryHandle:current-result-row - 1.
    end method.
    
    method public integer NextIndex(  ):
        if QueryHandle:query-off-end = false then 
            return max(QueryHandle:current-result-row + 1,
                        QueryHandle:num-results).
        else if HasNext() then
            return 1.
    end method.
    
end class.
