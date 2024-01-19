/************************************************
Copyright (c) 2013,2014,2017-2018,2021-2023 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : Set
    Purpose     : A collection that contains no duplicate elements.
    Syntax      :
    Description :
    @author hdaniels
    Created     : Wed Jan 09 10:45:45 EST 2008
    Notes       : * As of 12.6, this class wraps a List<Object>
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

// Since the OE.Core.Collections and Progress.Collections types have same/similar names,
// use the fully-qualified names as far as possible to reduce confusion over which type
// is being used. This is especially true for classes such as IIterator.

using OpenEdge.Core.Assert.
using Progress.Lang.Object.

class OpenEdge.Core.Collections.Set
serializable
implements OpenEdge.Core.Collections.ISet:

    /* The holder of the list data */
    var serializable private Progress.Collections.IList<Object> mBackingList.

    /** Returns the number of elements in this list. */
    define final non-serializable public property Size as integer no-undo
        get():
            return mBackingList:Count.
        end get.

    /* Default constructor */
    constructor public Set():
        assign mBackingList = new Progress.Collections.List<Object>().
    end constructor.

    /* Constructor

       @param ISet Initial set */
    constructor public Set (input copyset as OpenEdge.Core.Collections.ISet):
        this-object().

        this-object:AddAll(copyset).
    end constructor.

    /** Adds an array of elements to the collection

        @param Object[] An array of elements to add to the collection
        @return logical True if the operation succeeded. */
    method public logical AddArray( input poElements as Progress.Lang.Object extent ):
        var integer loop, cnt = extent(poElements).
        var logical addedElem = false.

        do loop = 1 to cnt:
            if valid-object(poElements[loop])
            and this-object:Add(poElements[loop])
            then
                assign addedElem = true.
        end.

        return addedElem.
    end method.

    /** Removes all of the elements from this list */
    method public void Clear():
        mBackingList:Clear().
    end method.

    /** Check whether the collection contains at least one object
        that matches the passed in object.

        @param Object The object
        @return logical Returns true if the object is in the collection */
    method public logical Contains( checkObject as Object):
        if not valid-object(checkObject) then
            return false.

        return mBackingList:Contains(checkObject).
    end method.

    /** Returns true if this list contains all of the elements of the
        specified collection.

        @param OpenEdge.Core.Collections.ICollection The collection of obejcts to check
        @return logical True if all the elements match */
    method public logical ContainsAll( input poCollection as OpenEdge.Core.Collections.ICollection ):
        var OpenEdge.Core.Collections.IIterator iter.

        Assert:NotNull(poCollection, 'Collection to check').

        /* if the 'check' collection is empty, then true */
        if poCollection:IsEmpty() then
            return true.

        /* if the passed in collection is larger than this collection,
           this cannot be true. */
        if poCollection:Size gt this-object:Size then
            return false.

        assign iter = poCollection:Iterator().
        do while iter:HasNext():
            if not mBackingList:Contains(iter:Next()) then
                return false.
        end.

        return true.
    end method.

    /** Appends an unknown value element to the set if not already present

        @return logical True if the operation succeeded. */
    method public logical AddNull():
        // Since the change to use List<T> as the backing store, that class may allow
        // the addition of the unknown value and so we should do the same for the Set.

        if mBackingList:Contains(?) then
            return false.

        return mBackingList:Add(?).
    end method.

    /** Appends the specified element to the set if not already present

        @param Object The element to add to the collection (may not be an unknown value)
        @return logical True if the operation succeeded. */
    method public logical Add(obj as Object):
        Assert:NotNull(obj, 'Object to add').

        if mBackingList:Contains(obj) then
            return false.

        return mBackingList:Add(obj).
    end method.

    /** Adds all of the input collection to the current list.
        Items from the input collection as added to the END of
        the current list.
        To prepend items, call AddAll(1, ICollection)

        @param OpenEdge.Core.Collections.ICollection The collection to add.
        @return logical TRUE if items were added (ie the input collection has at least one item) */
    method public logical AddAll(collection as  OpenEdge.Core.Collections.ICollection):
        var OpenEdge.Core.Collections.IIterator iterator.
        var logical anyAdded = false.

        if not valid-object(collection) then
            return false.

        assign iterator = collection:Iterator()
               anyAdded = false
               .
        do while iterator:HasNext():
            if this-object:Add(Iterator:Next()) then
               anyAdded = true.
        end.

        return anyAdded.
    end method.

    /* Equals if and only if Set and every member of the specified set is contained in this set

       @param Object The object to compare
       @param logical TRUE if the object to compare is equal */
    method public override logical Equals(o as Object):
        define variable oSet as OpenEdge.Core.Collections.ISet no-undo.
        var Progress.Collections.IIterator<Object> iter.

        if super:Equals(o) then
            return true.

        if type-of(o,OpenEdge.Core.Collections.ISet) then
        do:
            assign oSet = cast(o,OpenEdge.Core.Collections.ISet).
            if oSet:Size = this-object:Size then
            do:
                assign iter = mBackingList:GetIterator().
                do while iter:MoveNext():
                    if not oSet:Contains(iter:Current) then
                        return false.
                end.
                return true.
            end.
        end.

        return false.
    end method.

   /** Indicates whether this collection has any elements.

       @return logical True if the collection is empty. */
    method public logical IsEmpty():
        return mBackingList:IsEmpty.
    end method.

    /* Returns a new IIterator over the collection.
       @return OpenEdge.Core.Collections.IIterator  An iterator for this list */
    method public OpenEdge.Core.Collections.IIterator Iterator():
        return new OpenEdge.Core.Collections.ListIterator(mBackingList).
    end method.

   /** Removes the occurrence in this Set of the specified element

       @param Object The object to remove
       @return logical True if the operation succeded. */
    method public logical Remove( input poElement as Progress.Lang.Object):
        if not valid-object(poElement) then
            return false.

        return mBackingList:Remove(poElement).
    end method.

    /** Removes from this Set all the elements that are contained in the
        specified collection (optional operation).

        @param OpenEdge.Core.Collections.ICollection The collection to remove.
        @return logical True if the operation succeeded. */
    method public logical RemoveAll(collection as  OpenEdge.Core.Collections.ICollection):
        define variable iterator   as OpenEdge.Core.Collections.IIterator no-undo.
        define variable anyRemoved as logical no-undo.

        iterator = collection:Iterator().
        do while iterator:HasNext():
            if remove(iterator:Next()) then
                anyRemoved = true.
        end.

        return anyRemoved.
    end method.

    /** Retains only the elements in this Set that are contained in the
        specified collection (optional operation).

        This method creates a UNION of the input collection and this Set.

        @param OpenEdge.Core.Collections.ICollection The collection to retain
        @return Logical True if the object changed  */
    method public logical RetainAll(input poCollection as OpenEdge.Core.Collections.ICollection ):
        var logical lAny = false.
        var integer loop, cnt = mBackingList:Count.

        // if the Set is empty, it will continue to stay empty
        do loop = 1 to cnt:
            if not poCollection:Contains(mBackingList:Get(loop)) then
            do:
                mBackingList:RemoveAt(loop).
                assign lAny = true
                       // this MUST be 0 so that the loop reset behaves
                       // as expected, ie at 1
                       loop = 0
                       // we've removed an item
                       cnt -= 1
                       .
            end.
        end.

        return lAny.
    end method.

    /** Returns the contents of the collection as an array of objects.

        @return Object[] The collection returnes as an object array */
    method public Progress.Lang.Object extent ToArray():
        var integer cnt, loop.
        var Object[] arr.

        if mBackingList:Count eq 0 then
            return arr.

        assign cnt         = mBackingList:Count
               extent(arr) = cnt
               .
        do loop = 1 to cnt:
            assign arr[loop] = mBackingList:Get(loop).
        end.

        return arr.
    end method.

    /** Returns the contents of the collection as temp-table. This is a shallow
        copy of the collection - basically a new set of references is created.

        @param output table-handle The collection as a temp-table */
    method public void ToTable( output table-handle tt ):
        var integer loop, cnt = mBackingList:Count.
        var handle buf.

        create temp-table tt.
        tt:add-new-field('objectref', 'Progress.Lang.Object').
        tt:add-new-index('objidx', yes, yes).
        tt:add-index-field('objidx', 'objectref').
        tt:temp-table-prepare('ttSet').

        assign buf = tt:default-buffer-handle.

        do loop = 1 to cnt:
            buf:buffer-create().
            assign buf::objectref = mBackingList:Get(loop).
            buf:buffer-release().
        end.
        finally:
            delete object tt.
        end finally.
    end method.

end class.
