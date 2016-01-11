/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : IIterator
    Purpose     : traverses a collection forward 
    Syntax      : 
    Description : 
    @author hdaniels
    Created     :  
    Notes       : * Based on the AutoEdge|TheFactory version
  ----------------------------------------------------------------------*/
using Progress.Lang.Object.

interface OpenEdge.Core.Collections.IIterator:
    /** Indicates whether there's another element
    
        @return Logical Trues if the iterator has anotehanother element */
    method public logical HasNext().
    
    /** Returns the next object in the iterator. Next being the next object
        at the iterator's current position. 
        
        @return Object The object at the 'next' position. */
    method public Object Next().
    
    /** Removes an entry from the iterator.
        
        @return logical True if the operation succeeeded. */
    method public logical Remove().
end interface.

 
