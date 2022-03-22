/************************************************
Copyright (c) 2013, 2018, 2020-2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : ArrayIterator
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jun 14 12:13:12 EDT 2012
    Notes       : * Based on the AutoEdge|TheFactory version
                  Updated 11/13/2019 - Implemented IListIterator to make
                  more compatible in situations where Lists are replaced by
                  arrays for memory usage reasons.
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Collections.Array.
using OpenEdge.Core.Collections.ArrayIterator.
using OpenEdge.Core.Collections.IListIterator.
using Progress.Lang.Object.

class OpenEdge.Core.Collections.ArrayIterator implements IListIterator:
    define protected property CurrentExtent as integer no-undo get. set.
    define protected property IteratedArray as Array no-undo  get. set .
    
    /* Constructor
       
       @param Array The array over which to iterate */
    constructor public ArrayIterator(input poIteratedArray as Array):
        this-object(poIteratedArray, 0).
    end constructor.
    
    /* Constructor
       
       @param Array The array over which to iterate
       @param integer The starting extent/index */
    constructor public ArrayIterator(input pIteratedArray as Array,
                                     input pIndex as integer):
        Assert:NotNull(pIteratedArray, 'Iterated Array').
        Assert:IsZeroOrPositive(pIndex, 'Index').
        
        assign CurrentExtent = pIndex
               IteratedArray = pIteratedArray
               .
    end constructor.
    
    method public logical HasNext():
        return ((CurrentExtent + 1) le IteratedArray:Size).
    end method.
    
    method public logical HasPrevious():
        return ((CurrentExtent - 1) ge 1).
    end method.
    
    /* Returns the index of the element that would be returned by a subsequent call to next().
       Returns list size if the list iterator is at the end of the list.
       
       @return integer The next index or the array size if at the end */
    method public integer NextIndex(  ):
        return min(CurrentExtent + 1, IteratedArray:Size).
    end method.
    
    /* Returns the index of the element that would be returned by a subsequent call to previous().
       Returns 0 if the list iterator is at the beginning of the list.
       
       @return integer The previous index or 0/zero if at the beginning */
    method public integer PreviousIndex():
        return max(CurrentExtent - 1, 0).
    end method.
    
    method public Object Next():
        Assert:IsTrue(this-object:HasNext()).
        assign CurrentExtent = CurrentExtent + 1.
        return IteratedArray:GetValue(CurrentExtent).
    end method.
    
    method public Object Previous():
        Assert:IsTrue(this-object:HasPrevious()).
        assign CurrentExtent = CurrentExtent - 1.
        return IteratedArray:GetValue(CurrentExtent).
    end method.
    
    method public logical Remove():
        Assert:NotZero(CurrentExtent, 'Current iterator position').
        return IteratedArray:Remove(IteratedArray:GetValue(CurrentExtent)).
    end method.
    
end class.