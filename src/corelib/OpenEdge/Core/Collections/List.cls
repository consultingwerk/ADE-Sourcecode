/************************************************
Copyright (c) 2013, 2016-2019, 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : List
    Purpose     : An ordered collection of elements.
    Syntax      :
    Description :
    @author hdaniels
    Created     : Wed Jan 09 10:45:45 EST 2008
    Notes       : * As of 12.5, this class acts as a wrapper around the built-in List<>
                  * The List<> class should be used instead of this, since it supports
                    generic types.
                  * Another major difference between this type and the built-in, is that
                    this List cannot have unknown values added - though they can be Set()
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

// Since the OE.Core.Collections and Progress.Collections types have same/similar names,
// use the fully-qualified names as far as possible to reduce confusion over which type
// is being used
using OpenEdge.Core.Assert.
using OpenEdge.Core.Assertion.AssertArray.
using OpenEdge.Core.AssertionFailedError.
using Progress.Lang.AppError.
using Progress.Lang.Object.

@deprecated(from='12.5.0', reason='Use Progress.Collections.List').
class OpenEdge.Core.Collections.List
serializable
implements OpenEdge.Core.Collections.IList:
    
    // for ToTable() only
    define private temp-table ttList no-undo
      field sequence as int
      field objectref as Object
      index objidx objectref
      index seq as unique primary sequence
      .
    
    /* The holder of the list data */
    var private Progress.Collections.IList<Object> mBackingList.
    
    /** Returns the number of elements in this list. */
    define public property Size as integer no-undo
        get():
            return mBackingList:Count.
        end get.
      
    /* Default constructor */
    constructor public List():
        this-object(new Progress.Collections.List<Object>()).
    end constructor.
    
    /* Constructor.
       
       Allows the construction of a new List with a provided backing list. Called from SubList().
       
       @param Progress.Collections.IList<Object> */
    constructor private List (input pBackingList as Progress.Collections.IList<Object>):
        Assert:NotNull(pBackingList, 'Backing list').
        assign mBackingList = pBackingList.
    end constructor.
    
    /* Constructor.
       
       @param OpenEdge.Core.Collections.IList A collection whose contents to add to this List */
    constructor public List (input pList as OpenEdge.Core.Collections.IList):
        this-object().
        
        AddAll(pList).
    end constructor.
    
   /** Inserts the specified element at the specified position in this list.
       
       @param integer  The position at which to insert the object
       @param Object   The object to add
       @return Logical Returns true if the operation succeeded
       @throws Progress.Lang.SysError(18193) */
    method public logical Add(input pSeq as integer,
                              input pItem as Object ):
        if not valid-object(pItem) then
            return false.
        
        mBackingList:Insert(pSeq, pItem).
        
        return true.
    end method.

    /** Appends the specified element to list if not already present
        
        @param Object The element to add to the collection
        @return logical True if the operation succeeded. */
    method public logical Add(input pItem as Object):
        if not valid-object(pItem) then
            return false.
        
        mBackingList:Add(pItem).
        
        return true.
    end method.
    
    /** Adds all of the input collection to the current list.
        Items from the input collection as added to the END of
        the current list.
        To prepend items, call AddAll(1, ICollection)
        
        @param OpenEdge.Core.Collections.ICollection The collection to add.
        @return logical TRUE if items were added (ie the input collection has at least one item) */
    method public logical AddAll(input pCollection as OpenEdge.Core.Collections.ICollection):
        return this-object:AddAll(this-object:Size + 1, pCollection).
    end method.
    
    /** Adds all of the input collection to the current list, starting at the
        index given (ie the index passed is the first item)
        
        @param integer The index from which to add. Must be non-zero and positive
        @param OpenEdge.Core.Collections.ICollection The collection to add
        @return logical TRUE if items were added (ie the input collection has at least one item) */
    method public logical AddAll(input pSeq as integer,
                                 input pCollection as OpenEdge.Core.Collections.ICollection):
        var OpenEdge.Core.Collections.IIterator iter.
        var Object item.
        var logical listChanged = false, listEmpty.
        
        Assert:NotNull(pCollection, 'Collection').
        Assert:IsPositive(pSeq, 'List index').
        
        if pCollection:IsEmpty() then
            return false.
        
        assign listEmpty = mBackingList:IsEmpty
               iter      = pCollection:Iterator()
               .
        do while iter:HasNext():
            assign item = iter:Next().
            if valid-object(item) then
            do:
                if listEmpty then
                    mBackingList:Add(item).
                else
                    mBackingList:Insert(pSeq, item).
                
                assign pSeq       += 1
                       listChanged = yes
                       .
            end.
        end.
        
        return listChanged.
    end method.
    
    /** Adds an array of elements to the collection
       
        @param Object[] An array of elements to add to the collection
        @return logical True if the operation succeeded. */
    method public logical AddArray(input pItems as Object extent):
        var integer cnt, loop.
        var logical listChanged = false.
        
        assign cnt = extent(pItems).
        do loop = 1 to cnt:
            if valid-object(pItems[loop]) then
            do:
                this-object:Add(pItems[loop]).
                assign listChanged = yes.
            end.
        end.
        
        return listChanged.
    end method.
    
    /** Returns true if this list contains all of the elements of the
        specified collection.
        
        @param OpenEdge.Core.Collections.ICollection The collection of obejcts to check
        @return logical True if all the elements match */
    method public logical ContainsAll(input poCollection as OpenEdge.Core.Collections.ICollection ):
        var OpenEdge.Core.Collections.IIterator iter.
        
        Assert:NotNull(poCollection, 'Collection').
        
        if poCollection:IsEmpty() then
            return true.
        
        assign iter = poCollection:Iterator().
        do while iter:HasNext():
            if not mBackingList:Contains(iter:Next()) then
                return false.
        end.
        
        return true.
    end method.

    /** Check whether the colleciton contains at least one object
        that matches the passed in object.
        
        @param Object The object
        @return logical Returns true if the object is in the collection */
    method public logical Contains( input poElement as Object ):
        return mBackingList:Contains(poElement).
    end method.
    
    /** Returns the contents of the collection as temp-table. This is a shallow
        copy of the collection - basically a new set of references is created.
    
        @param output table-handle The collection as a temp-table */
    method public void ToTable( output table-handle tt):
        var integer loop, cnt = mBackingList:Count.
        
        empty temp-table ttList.
        tt = temp-table ttList:handle.
        
        do loop = 1 to cnt:
            create ttList.
            assign ttList.sequence  = loop
                   ttList.objectref = mBackingList:Get(loop)
                   .
        end.
    end method.
    
    /** Removes from this list all the elements that are contained in the
        specified collection (optional operation).
        
        @param OpenEdge.Core.Collections.ICollection The collection to remove.
        @return logical True if the operation succeeded. */
    method public logical RemoveAll( input poCollection as OpenEdge.Core.Collections.ICollection ):
        var OpenEdge.Core.Collections.IIterator iter.
        
        Assert:NotNull(poCollection, 'Collection').
        
        if poCollection:IsEmpty() then
            return false.
        
        assign iter = poCollection:Iterator().
        do while iter:HasNext():
            mBackingList:Remove(iter:Next()).
        end.
        
        return true.
    end method.

    /** Retains only the elements in this list that are contained in the
        specified collection (optional operation).
        
        @param OpenEdge.Core.Collections.ICollection The collection to retain
        @return Logical True if the object changed  */
    method public logical RetainAll( input poCollection as OpenEdge.Core.Collections.ICollection):
        var OpenEdge.Core.Collections.IIterator iter.
        var Object item.
        var logical hasChanged = false.
        
        Assert:NotNull(poCollection, 'Collection').
        
        if poCollection:IsEmpty() then
        do:
            mBackingList:Clear().
            return true.
        end.
        
        assign iter = poCollection:Iterator().
        do while iter:HasNext():
            assign item = iter:Next().
            if not mBackingList:Contains(item) then
            do:
                mBackingList:Remove(item).
                assign hasChanged = true.
            end.
        end.
        
        return hasChanged.
    end method.

    /** Removes all of the elements from this list */
    method public void Clear(  ):
        mBackingList:Clear().
    end method.

    /** Returns the contents of the collection as an array of objects.
    
        @return Object[] The collection returnes as an object array */
    method public Object extent ToArray(  ):
        var integer cnt, idx.
        var Object[] arr.
        var Progress.Collections.IIterator<Object> iter.
        
        if mBackingList:Count eq 0 then
            return arr.
        
        assign extent(arr) = mBackingList:Count
               iter        = mBackingList:GetIterator()
               .
        do while iter:MoveNext():
            assign idx     += 1
                   arr[idx] = iter:Current
                   .
        end.
        
        return arr.
    end method.

   /** Indicates whether this collection has any elements.
       
       @return logical True if the collection is empty. */
    method public logical IsEmpty(  ):
        return mBackingList:IsEmpty.
    end method.

    /** Adds an array of elements to the collection
       
        @param Object[] An array of elements to add to the collection
        @return logical True if the operation succeeded. */
    method public logical AddArray(input pSeq as integer,
                                   input pItems as Object extent):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        var logical listChanged = false.
        
        Assert:IsPositive(pSeq, 'List index').
        
        assign iMax = extent(pItems).
        do iLoop = 1 to iMax:
            if valid-object(pItems[iLoop]) then
            do:
                mBackingList:Insert(pSeq, pItems[iLoop]).
                assign pSeq       += 1
                       listChanged = true
                       .
            end.
        end.
        
        return listChanged.
    end method.
     
    /* Two Lists  are defined to be equal if they are the same size and
       all of the elements in this collection are in the to-compare List and
       in the same sequence.
       
       @param P.L.Object
       @return logical TRUE if the Lists are equal. FALSE otherwise */
    method public override logical Equals(o as Object):
        define variable list as OpenEdge.Core.Collections.IList no-undo.
        var OpenEdge.Core.Collections.IIterator iter.
        var integer idx.
        var Object[2] element.
        
        if super:Equals(o) then
            return true.
        
        if type-of(o, OpenEdge.Core.Collections.IList) then
        do:
            assign list = cast(o, OpenEdge.Core.Collections.IList).
            if not list:Size eq this-object:Size then
                return false.
            
            assign iter = list:Iterator().
            do while iter:HasNext():
                assign idx       += 1
                       element[1] = mBackingList:Get(idx)
                       element[2] = iter:Next()
                       .
                // if one item is not valid, and the other is, they cannot be the same
                if valid-object(element[1])
                and not valid-object(element[2])
                then
                    return false.
                
                if not valid-object(element[1])
                and valid-object(element[2])
                then
                    return false.
                
                // if both items are not valid, then they are the same
                // if they are both valid, check for equality
                if valid-object(element[1])
                and valid-object(element[2])
                and not element[1]:Equals(element[2])
                then
                    return false.
            end.
            
            return true.
        end.
        
        return false.
    end method.
    
    /* Returns the object represented by the index
       
       @param integer The sequence to find. Must be positive and <= the Size.
       @return Object The object represented by the sequence. May be ? */
    method public Object Get(input pIdx as integer):
        Assert:IsPositive(pIdx, 'List index').
        
        if pIdx gt this-object:Size then
            undo, throw new AssertionFailedError(substitute('Index &1 is larger than List size &2', pIdx, this-object:Size)).
        
        return mBackingList:Get(pIdx).
    end method.
    
   /** Returns the index in this list of the first occurrence of the specified
       element, or 0 if this list does not contain this element.
       
       @param Object   The object to check.
       @return integer The index of the passed-in object */
    method public integer IndexOf(input pItem as Object ):
        return mBackingList:IndexOf(pItem).
    end method.
    
    /* Returns a new IIterator over the collection.
       @return OpenEdge.Core.Collections.IIterator  An iterator for this list */
    method public OpenEdge.Core.Collections.IIterator Iterator():
        return new OpenEdge.Core.Collections.ListIterator(mBackingList).
    end method.
    
    /* Returns a new IListIterator over the collection.
       
       @return OpenEdge.Core.Collections.IListIterator  An iterator for this list */
    method public OpenEdge.Core.Collections.IListIterator ListIterator():
        return new OpenEdge.Core.Collections.ListIterator(mBackingList).
    end method.
    
   /** Returns a list iterator of the elements in this list (in proper sequence),
       starting at the specified position in this list.
       
       @param integer The starting position for the new iterator
       @return IListIterator The ordered iterator */
    method public OpenEdge.Core.Collections.IListIterator ListIterator(pStartIdx as integer):
        Assert:IsPositive(pStartIdx, 'List index').
        if pStartIdx gt mBackingList:Count then
            return error new AssertionFailedError(substitute('Index &1 is larger than List size &2',
                                                            pStartIdx, mBackingList:Count)).
        
        return new OpenEdge.Core.Collections.ListIterator(mBackingList, pStartIdx).
    end method.
    
   /** Returns the index in this list of the last occurrence of the
       specified element, or 0 if this list does not contain this element.
       
       @param Object The object to check
       @return integer The index of the last occurrence of the object */
    method public integer LastIndexOf(input pItem as Object):
        var Progress.Lang.Object elem.
        // check if the item exists at all
        var integer loop, cnt, idx = mBackingList:IndexOf(pItem).
        
        if idx eq 0 then
            return 0.
        
        // go from the next index (since we know the item is at idx)
        assign cnt = idx + 1.
        
        // use a 'manual iterator' rather than the List's Iterator() since
        // the iterator only goes forwards
        // we know that there's at least one matching item in the list, at index "idx",
        // so see if there's another between that index and the end of the list
        ELEM-LOOP:
        do loop = mBackingList:Count to cnt by -1:
            assign elem = mBackingList:Get(loop).
            if (not valid-object(pItem) and not valid-object(elem))
            or elem:Equals(pItem)
            then
            do:
                assign idx = loop.
                leave ELEM-LOOP.
            end.
        end.
        
        return idx.
    end method.
    
   /** Removes the first occurrence in this list of the specified element
   
        @param Object The
        @return logical True if the operation succeded. */
    method public logical Remove(input pItem as Object):
        return mBackingList:Remove(pItem).
    end method.
    
    /** Removes an item at the given index
    
        @param integer The index to remove. Must be between 1 and the size of the List
        @return Progress.Lang.Object The item that was removed.
        @throws Progress.Lang.SysError(18193) */
    method public Object Remove(input pIdx as integer):
        define variable oldObject as Object no-undo.
        
        assign oldObject = mBackingList:Get(pIdx).
        mBackingList:RemoveAt(pIdx).
        
        return oldObject.
    end method.
    
   /** Replaces the element at the specified position in this list with the
       specified element
       
       @param integer The position to add
       @param Object The object to add to the List
       @return Object The object that was replaced/removed from the List
       @throws Progress.Lang.SysError(18193) */
    method public Object Set(input pIdx as integer,
                             input poReplacement as Object ):
        // the previous implementation allowed an unknown object to be Set().
        return mBackingList:Set(pIdx, poReplacement).
    end method.
    
    /* Returns a view of the portion of this list between the specified fromIndex, inclusive, and toIndex, exclusive.
       
       The fromIndex value must be positive and <= this list's Size
       The toIndex value must be positive and <= this list's Size
       The fromIndex value must be <= toIndex value
       If fromIndex and toIndex are equal, the returned list has 1 entry.
       
       @param integer fromIndex Low endpoint (INCLUSIVE) of the subList
       @param integer toIndex   High endpoint (INCLUSIVE) of the subList
       @return IList a List containing the items. Has at least 1 entry. */
    method public OpenEdge.Core.Collections.IList SubList(input pFromIndex as integer,
                                                          input pToIndex as integer):
        var Progress.Collections.List<Object> list = new Progress.Collections.List<Object>().
        var integer loop.
                
        Assert:IsPositive(pFromIndex, 'List From-Index').
        Assert:IsPositive(pToIndex, 'List To-Index').
        
        if pFromIndex gt this-object:Size then
            undo, throw new AssertionFailedError(substitute('From-Index &1 is larger than the collection size of &2', pFromIndex, this-object:Size)).
        if pToIndex gt this-object:Size then
            undo, throw new AssertionFailedError(substitute('To-Index range &1 is larger than the collection size of &2', pToIndex, this-object:Size)).
        if pFromIndex gt pToIndex then
            undo, throw new AssertionFailedError(substitute('From-Index &1 is larger To-Index &2', pFromIndex, pToIndex)).
        
        do loop = pFromIndex to pToIndex:
            // Add directly in case an unknown value has been Set()
            list:Add(mBackingList:Get(loop)).
        end.
        
        return new OpenEdge.Core.Collections.List(list).
    end method.
    
end class.
