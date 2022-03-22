/************************************************
Copyright (c) 2013, 2021 by Progress Software Corporation. All rights reserved.
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
using OpenEdge.Core.Assert.

class OpenEdge.Core.Collections.ListIterator
implements IListIterator:
    var private Progress.Collections.IList<Object> mIteratedList.
    var private integer mCurrentIndex.
    
    /* Constructor
       
       @param Progress.Collections.IList<Object> The list being iterated over */
    constructor package-private ListIterator(input pList as Progress.Collections.IList<Object>):
        this-object(pList, 0).
    end constructor.
    
    /* Constructor
       
       @param Progress.Collections.IList<Object> The list being iterated over
       @param integer The starting index */
    constructor package-private ListIterator(input pList as Progress.Collections.IList<Object>,
                                             input pIdx as integer):
        Assert:NotNull(pList, 'Iterated list').
        Assert:IsZeroOrPositive(pIdx, 'List index').
        
        assign mIteratedList = pList
               mCurrentIndex = pIdx
               .
    end constructor.
    
    /** Indicates whether there's a previous element.
        
        @return logical True if there is a previous element */
    method public logical HasPrevious():
        return ((mCurrentIndex - 1) ge 1).
    end method.
    
    /** Returns the previous element
    
        @return Object */
    method public Object Previous():
        Assert:IsTrue(this-object:HasPrevious()).
        assign mCurrentIndex -= 1.
        
        return mIteratedList:Get(mCurrentIndex).
    end method.
    
    /** Returns the index of the previous item.
        
        @return integer The index of the previous element */
    method public integer PreviousIndex(  ):
        return max(mCurrentIndex - 1, 0).
    end method.
    
    /** Returns the next elements' index.
         
        @return integer The index of the next element */
    method public integer NextIndex(  ):
        if mCurrentIndex eq mIteratedList:Count then
            return 0.
        else
            return (mCurrentIndex + 1).
    end method.
    
    /** Indicates whether there's another element
    
        @return Logical Trues if the iterator has another element */
    method public logical HasNext():
        return ((mCurrentIndex + 1) le mIteratedList:Count).
    end method.

    /** Returns the next object in the iterator. Next being the next object
        at the iterator's current position.
        
        @return Object The object at the 'next' position. */
    method public Object Next(  ):
        Assert:IsTrue(this-object:HasNext()).
        assign mCurrentIndex += 1.
        
        return mIteratedList:Get(mCurrentIndex).
    end method.
    
    /** Removes an entry from the iterator.
        
        @return logical True if the operation succeeeded. */
    method public logical Remove():
        Assert:NotZero(mCurrentIndex, 'Current iterator position').
        mIteratedList:RemoveAt(mCurrentIndex).
        
        return true.
    end method.
    
end class.
