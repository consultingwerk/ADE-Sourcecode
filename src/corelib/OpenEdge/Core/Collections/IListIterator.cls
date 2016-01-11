/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : IListIterator
    Purpose     : An iterator for lists that can traverse the list in 
                  both directions
    Syntax      : 
    Description : 
    @author hdaniels
    Created     :  
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.Core.Collections.IIterator.
using Progress.Lang.Object.

interface OpenEdge.Core.Collections.IListIterator inherits IIterator:
    
    /** Returns the next elements' index.
         
        Return integer The index of the next element */
    method public integer NextIndex().
    
    /** Indicates whether there's a previous element.  
        
        @return logical True if there is a previous element */
    method public logical HasPrevious().
    
    /** Returns the previous element
    
        @return Object */
    method public Object Previous().
    
    /** Returns the index of the previous item.
        
        Return integer The index of the previous element */
    method public integer PreviousIndex().
end interface.

 
