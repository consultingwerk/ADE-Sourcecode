/************************************************
Copyright (c) 2013-2014, 2017, 2020-2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : Array
    Purpose     : Hold and manage a collection of objects within a variable with extent.  
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jun 14 11:35:49 EDT 2012
    Notes       : * Based on the AutoEdge|TheFactory version 
                  Updated 11/13/2019 by S.E. Southwell - Make size
                  reflect number of items rather than underlying array size.
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.AssertionFailedError.
using OpenEdge.Core.Collections.Array.
using OpenEdge.Core.Collections.ArrayIterator.
using OpenEdge.Core.Collections.ICollection.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.IList.
using OpenEdge.Core.Collections.IListIterator.
using OpenEdge.Core.Collections.List.
using OpenEdge.Core.Collections.ResizeError.
using Progress.Lang.Object.

class OpenEdge.Core.Collections.Array serializable
            implements IList:
    
    /* only ever used for ToTable() */
    define static private temp-table ttArray no-undo
        field ObjIndex as integer
        field ObjRef as Object
        index idx1 as primary unique ObjIndex.
    
    /* The default length (#extents) of the underlying array. Defaults to 10 */
    define public static property DefaultArraySize as integer no-undo get. set.
    
    /* Keep incrementally growing array length as new elements are added.
       This may negatively impact performance since prior to OE12 the contents of the array are copied
       to and from a temporary array. */
    define public property AutoExpand as logical no-undo get. set.
    
    /* If true, we'll discard stuff off the bottom of the stack if
       we resize the array's length smaller than its contents (size). */
    define public property DiscardOnShrink as logical no-undo get. set.
    
    /* The actual holding array */
    define protected property Value as Object extent no-undo get. set.
    
    // The actual number of elements in the array (not the size of the underlying array)
    // It's a variable instead of property since the 'set' of the size has effects
    define private variable mSize as integer no-undo initial 0.
    
    /* The number of elements in the array, or 0 if empty. The Size is the data in the array */
    define public property Size as integer no-undo
        get():
            return mSize.
        end.
        set(input piSize as integer):
            assign mSize = UpdateLength(piSize).
        end.
    
    /* The size of the underlying array (number of extents). This may or may not correspond with the Size */
    define protected property Length as integer no-undo
        get():
            return extent(this-object:Value).
        end get.
        set(input pLength as integer):
            assign this-object:Size = pLength.
        end set.
    
    /* Static constructor */
    constructor static Array():
        assign Array:DefaultArraySize = 10.
    end constructor.
    
    /* Constructor
       
       @param integer The length of the array */
    constructor public Array(input pLength as integer):
        // manually set the array length here; no need to call the function,
        // which does a bunch of validation, that we know is not needed since we're
        // in the constructor. 
        //
        // We also do not want to set the Size of the array, just the Length
        if not pLength eq ?
        and pLength gt 0
        then
            assign extent(this-object:Value) = pLength
                   mSize                     = pLength
                   .
        
        assign AutoExpand      = false
               DiscardOnShrink = false
               .
    end constructor.
    
    /* Constructor
       
       @param Progress.Lang.Object[] An array to shallow-clone (ie copy elements into self) */
    constructor public Array(input poArray as Object extent):
        define variable max as integer no-undo.
        define variable loop as integer no-undo.
        
        this-object(extent(poArray)).
        
        assign max = extent(poArray).
        do loop = 1 to max:
            assign this-object:Value[loop] = poArray[loop].
        end.
    end constructor.
    
    /* Default constructor */
    constructor public Array():
        this-object(Array:DefaultArraySize).
        // we don't have any elements yet
        assign mSize = 0.
    end constructor.
    
    /* destructor */
    destructor Array():
        empty temp-table ttArray.
    end destructor.
    
    /* Changes the Length of the array. This method does *not* change the Size, but returns the
       new size. Respects the AutoExpand and DiscardOnShrink properties.
       
       @param integer The new length. If null or negative, then the DefaultArraySize is used. If zero, the array is reset
       @return integer The size of the array (ie how many elements). This may have changed, 
                       particularly if the array was shrunk */
    method private integer UpdateLength(input pNewLength as integer):
&if integer(entry(1, proversion, '.')) lt 12 &then
        define variable oTempObject as Object extent no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
&endif
        // anything <0 or ? is the default size 
        if    pNewLength eq ?
           or pNewLength lt 0
        then
            assign pNewLength = OpenEdge.Core.Collections.Array:DefaultArraySize.
        
        if pNewLength eq this-object:Length then
            return pNewLength.
        
        if  pNewLength lt this-object:Size
        and not DiscardOnShrink
        then
            undo, throw new ResizeError('Array', 'smaller'). 
        
        if  pNewLength gt this-object:Length
        and not AutoExpand
        then
            undo, throw new ResizeError('Array', 'larger').
        
        // If the new size is 0 then make the array intedeterminate
        if pNewLength eq 0 then
        do:
            assign extent(this-object:Value) = ?.
            return 0.
        end.
        
        // if this is an indeterminate array, then just make the array big and set the Size to 0
        if this-object:Length eq ? then
        do:
            assign extent(this-object:Value) = pNewLength.
            return pNewLength.
        end.
&if integer(entry(1, proversion, '.')) ge 12 &then
        assign extent(this-object:Value) = pNewLength.
&else
        assign extent(oTempObject)       = this-object:Length
               oTempObject               = this-object:Value
               iMax                      = min(this-object:Size, pNewLength)
               extent(this-object:Value) = ?
               extent(this-object:Value) = pNewLength
               .
        /* On init this loop won't execute */
        do iLoop = 1 to iMax:
            assign this-object:Value[iLoop] = oTempObject[iLoop].
        end.
&endif
        return pNewLength.
    end method.
    
    /* Set the value at the end of the array.
       
       @param P.L.Object An object to add to the array */
    method public void SetValue(input poValue as Object):
        SetValue(poValue, (this-object:Size + 1)).
    end method.
    
    /* Get the value of the object at the given position in the array.
       
       @param integer The index of the item to return. Must be non-negative
       @return P.L.Object The object at the index location. May be null  */
    method public Object GetValue(input piExtent as integer):
        Assert:IsPositive(piExtent, 'Index').
        
        if piExtent gt this-object:Size then
            undo, throw new AssertionFailedError(substitute('Requested index &1 is greater than array size &2',
                                                           piExtent, this-object:Size ), 0).
        
        return this-object:Value[piExtent].
    end method.
    
    /* Inserts an element, and moves the rest along
       
       @param integer A positive index
       @param P.L.Object The element to add */
    method protected void InsertElement(input pIndex as integer,
                                        input pElement as Progress.Lang.Object):
        define variable loop as integer no-undo.
        
        Assert:IsPositive(pIndex, 'Insertion index').
        
        // make room if needed. We are expanding this array potentially
        UpdateLength(max(this-object:Length, mSize + 1, pIndex + 1)).
        
        if pIndex le mSize then
        do loop = mSize to pIndex by -1:
            // move the values to the right
            assign this-object:Value[loop + 1] = this-object:Value[loop]. 
        end.
        
        assign this-object:Value[pIndex] = pElement
               mSize                     = mSize + 1
               .
    end method.
    
    /* Inserts elements from an array, and moves the rest along
       
       @param integer A positive index
       @param P.L.Object[] The elements to add */
    method protected void InsertElements(input pIndex as integer,
                                         input pElement as Progress.Lang.Object extent):
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        define variable idxForSize as integer no-undo.
        
        assign cnt = extent(pElement).
        if cnt eq ? then
            return.
        
        Assert:IsPositive(pIndex, 'Insertion index').
        
        // if there's nothing in the array, there's nothing to move
        assign idxForSize = pIndex - 1.
        
        // make room if needed. We are expanding the array
        UpdateLength(max(this-object:Length, mSize + cnt, idxForSize + cnt)).
        
        if pIndex le mSize then
        do loop = mSize to pIndex by -1:
            // move the values to the right
            assign this-object:Value[loop + cnt] = this-object:Value[loop].
        end.
        
        // remove 1 to get around off-by-one errors
        assign mSize = max(mSize, idxForSize) + cnt
               cnt   = cnt - 1
               .
        do loop = 0 to cnt:
            assign this-object:Value[pIndex + loop] = pElement[loop + 1].
        end.
    end method.
    
    /* Set the value for a particular index to an object
       
       @param P.L.Object An object to add to the array
       @param integer  The index at which to add */
    method public void SetValue(input poValue as Object,
                                input piExtent as integer):
        Assert:IsPositive(piExtent, 'Index').
        
        if this-object:Length eq ?
        or piExtent gt this-object:Length 
        then
            // this method will throw a ResizeError if needed
            UpdateLength(integer(piExtent + round(0.5 * this-object:Length, 0))).
        
        assign this-object:Value[piExtent] = poValue
               mSize                       = max(mSize, piExtent)
               .
    end method.
    
    /* Add an object to the array at the end. Logical alias for SetValue.
       Always returns true if there's not an error
       
       @param P.L.Object The object to add to the array.
       @return logical returns TRUE */
    method public logical Add(input o as Object):
        SetValue(o).
        return true.
    end method.
    
    /* Add items from the supplied collection to this Array
     
       @param ICollection A collection of objects to add.
       @return logical Returns TRUE if any the array was added, FALSE if not. */
    method public logical AddAll(input c as ICollection):
        return AddArray(c:ToArray()).
    end method.
    
    /* Adds all of the elements in the input array to this one, starting at the end
       of the array.
       
       @param Progress.Lang.Object[] An array of objects to add. May be indeterminate.
       @return logical Returns TRUE if any the array was added, FALSE if not. */
    method public logical AddArray(input c as Object extent):
        return AddArray(this-object:Size + 1, c).
    end method.
    
    /* Remove all elements from the array and sets the size to 0. Keeps the array's length as-is */
    method public void Clear():
        // Empty the contents, but keep the array at its current length
        assign this-object:Value = ?
               mSize             = 0
               .
    end method.
    
    /* See whether the passed-in object is a member of the Array
       
       @param P.L.Object An object to check. Can be unknown
       @return logical TRUE if the passed-in object appears at least once in the array */
    method public logical Contains(input o as Object):
        define variable iMax as integer no-undo.
        define variable iLoop as integer no-undo.
        
        assign iMax = this-object:Size.
        do iLoop = 1 to iMax:
            if (     valid-object(this-object:Value[iLoop]) and this-object:Value[iLoop]:Equals(o) )
            or ( not valid-object(this-object:Value[iLoop]) and not valid-object(o) )
            then
                return true.
        end.
        
        return false.
    end method.
    
    /* Returns true if this list contains all of the elements of the
        specified collection.
        
        @param ICollection The collection of objects to check
        @return logical True if all the elements match */
    method public logical ContainsAll(input poCollection as ICollection):
        define variable oIterator as IIterator no-undo.
        
        Assert:NotNull(poCollection, 'Check collection').
        
        /* if the 'check' collection is empty, then true */  
        if poCollection:IsEmpty() then
            return true.
        
        /* if the passed in collection is larger than this collection,
           this cannot be true. */
        if poCollection:Size gt this-object:Size then
            return false.
        
        assign oIterator = poCollection:Iterator().
        do while oIterator:HasNext():
            if not this-object:Contains(oIterator:Next()) then
                return false.
        end.
        
        return true.
    end method.   
    
    /* Provide an iterator for the Array. This is an ArrayIterator which implements IIterator and ListIterator.
       
       @return IIterator An iterator for this array */
    method public IIterator Iterator():
        return ListIterator().
    end method.
    
    /* Report whether the object contains anything. Underlying variable extent size
       may be > 0 and the object still be empty.
       
       @return logical TRUE is the Size is 0, FALSE otherwise */
    method public logical IsEmpty():
        return (this-object:Size eq 0).
    end method.
    
    /* Remove an object from the array. This method removes only the first match it finds. To remove
       all of the instances of the object, either call Remove(obj) until it returns false, or create 
       a collection with a single element, and call RemoveAll(coll).
       
       @param P.L.Object The object to remove
       @return logical TRUE if the object was removed */
    method public logical Remove(input o as Object):
        define variable iMax as integer no-undo.
        define variable iLoop as integer no-undo.
        define variable iRemovedIndex as integer no-undo.
        
        assign iMax          = this-object:Size
               iRemovedIndex = 0
               .
        do iLoop = 1 to iMax while iRemovedIndex eq 0:
            if (     valid-object(this-object:Value[iLoop]) and this-object:Value[iLoop]:Equals(o) )
            or ( not valid-object(this-object:Value[iLoop]) and not valid-object(o) )
            then
                assign iRemovedIndex = iLoop.
        end.
        
        if not iRemovedIndex eq 0 then
            this-object:Remove(iRemovedIndex).
        
        return not (iRemovedIndex eq 0).
    end method.
    
    /* Removes all of those elements that appear in the input collection.
       
       @param ICollection The collection containing the elements to remove 
       @return logical TRUE if any elements were removed */
    method public logical RemoveAll( input c as ICollection):
        define variable oIterator as IIterator no-undo.
        define variable oRemove  as Object no-undo.
        define variable lAny as logical no-undo.
        
        oIterator = c:Iterator().
        lAny = false.
        do while oIterator:HasNext():
            oRemove = oIterator:Next().
            do while this-object:Remove(oRemove):
                lAny = true.
            end.
        end.
        
        return lAny.
    end method.
    
    /* Keeps only those elements that appear in the input collection; all others
       are removed from the array
       
       @param ICollection The collection containing the elements to retain 
       @return logical TRUE if any elements were removed */
    method public logical RetainAll(input pCollection as ICollection):
        define variable oChild as Object no-undo.  
        define variable lAny as logical no-undo.
        define variable loop as integer no-undo.
        define variable tmpArray as Progress.Lang.Object extent no-undo.
        define variable tmpIdx as integer no-undo.
        
        Assert:NotNull(pCollection, 'Retain collection').
        
        assign extent(tmpArray) = Length
               tmpIdx           = 1
               .
        if pCollection:Size gt 0 then
        do loop = 1 to mSize:
            assign oChild = this-object:Value[loop].
            if pCollection:Contains(oChild) then
                assign tmpArray[tmpIdx] = oChild
                       tmpIdx           = tmpIdx + 1
                       lAny             = true
                       .
        end.
        
        assign this-object:Value = tmpArray
               mSize             = tmpIdx - 1
               .
        
        return lAny.
    end method.

    /* Returns the array as a temp-table
       
       @param table-handle A cope of ttArray containing the array */
    method public void ToTable( output table-handle tt):
        define variable iMax as integer no-undo.
        define variable iLoop as integer no-undo.
        
        empty temp-table ttArray.
        iMax = this-object:Size.
        do iLoop = 1 to iMax:
            create ttArray.
            assign ttArray.ObjIndex = iLoop
                   ttArray.ObjRef = this-object:Value[iLoop]. 
        end.
        
        tt = temp-table ttArray:handle.
    end method.
    
    /* Returns an array of size this-object:Size, with all references to the original array
       (a shallow copy). 
       
       @return Progress.Lang.Object[] A new array. May be indeterminate */
    method public Object extent ToArray():
        define variable arr as Progress.Lang.Object extent no-undo.
        
        if this-object:Size eq 0 then
            return arr.
&if integer(entry(1, proversion, '.')) lt 12 &then
        define variable loop as integer no-undo.
        define variable max as integer no-undo.
        assign max         = this-object:Size
               extent(arr) = max
               .
        do loop = 1 to max:
            assign arr[loop] = this-object:Value[loop].
        end.
&else
    assign arr         = this-object:Value
           extent(arr) = this-object:Size
           .
&endif
        return arr.
    end method.
    
    /* Deep clone. or rather deep enough since we don't know what the elements' Clone()
       operations do, so this may end up being a memberwise clone 
       
       @return P.L.Object the cloned object */
    method override public Object Clone():
        define variable oClone as ICollection no-undo.
        
        oClone = cast(this-object:GetClass():New(), ICollection).
        CloneElements(oClone).
        
        return oClone.
    end method.
    
    /* Clones this objects's elements into a collection
       
       @param ICollection The collections into which to clone this array's elements */
    method protected void CloneElements(input poClone as ICollection):
        define variable loop as integer no-undo.
        
        Assert:NotNull(poClone, 'Clone target collection').
        
        do loop = 1 to mSize:
            if valid-object(this-object:Value[loop]) then
                /* The object being cloned may not have a Clone() method */
                poClone:Add(this-object:Value[loop]:Clone()).
            else
                poClone:Add(?).
        end.
    end method.
    
    /* Adds the element to the array, at the index provicded
       
       @param integer A positive integer value
       @param Progress.Lang.Object[] An array of objects to add. May be indeterminate.
       @return logical Returns TRUE if the object was added, FALSE if not. */
    method public logical Add(input pIndex as integer,
                              input pElement as Progress.Lang.Object):
        Assert:IsPositive(pIndex, 'List index').
        if pIndex gt this-object:Size then
            return error new AssertionFailedError(substitute('List index &1 is larger than the list size &2', pIndex, this-object:Size)).
        
        InsertElement(pIndex, pElement).
        
        return true.
    end method.
    
    /* Adds the collection to the array, at the index provicded
       
       @param integer A non-negative integer value
       @param ICollection A collection of objects to add.
       @return logical Returns TRUE if the object was added, FALSE if not. */
    method public logical AddAll(input pIndex as integer,
                                 input pCollection as ICollection):
        Assert:NotNull(pCollection, 'Input collection').
        Assert:IsPositive(pIndex, 'Insertion index').
        
        return AddArray(pIndex, pCollection:ToArray()).
    end method.
    
    /* Adds all of the elements in the input array to this one, starting at the index
       
       @param integer A non-negative integer value
       @param Progress.Lang.Object[] An array of objects to add. May be indeterminate.
       @return logical Returns TRUE if any the array was added, FALSE if not. */
    method public logical AddArray(input pIndex as integer,
                                   input pArray as Progress.Lang.Object extent):
        if extent(pArray) eq ? then
            return false.
        
        InsertElements(pIndex, pArray).
        
        return true.
    end method.
    
    /* Returns the object represented by the index
       
       @param integer The sequence to find. Must be positive and <= the Size.  
       @return Object The object represented by the sequence. May be ? */
    method public Progress.Lang.Object Get(input pIndex as integer ):
        return GetValue(pIndex).
    end method.
    
    /* Returns the first index or 0/zero for the given element
       
       @param P.L.O The element to find
       @return integer The first index at which the element can be found, or 0 */
    method public integer IndexOf( input pElement as Progress.Lang.Object ):
        define variable loop as integer no-undo.
        
        do loop = 1 to mSize:
            if (     valid-object(this-object:Value[loop]) and this-object:Value[loop]:Equals(pElement) )
            or ( not valid-object(this-object:Value[loop]) and not valid-object(pElement) )
            then
                return loop.
        end.    
        
        return 0.
    end method.
    
    /* Returns an iterator for this list
       
       @return IListIterator An iterator */
    method public IListIterator ListIterator():
        return ListIterator(0).
    end method.
    
    /* Returns an iterator for this list. The index must be 'off by 1',
       so that the Next() and Previous() semantics in the IListIterator work.
       This means that the range of values is 0 ... array Size - 1
       
       @param integer A non-negative index to start iterating at. From 0 to Size - 1.
       @return IListIterator An iterator */
    method public IListIterator ListIterator(input pIndex as integer):
        Assert:IsZeroOrPositive(pIndex, 'List iterator index').
        
        if pIndex gt 0
        and pIndex ge this-object:Size 
        then
            undo, throw new AssertionFailedError(substitute('Index &1 is >= the collection size of &2', pIndex, this-object:Size), 0).
        
        return new ArrayIterator(this-object, pIndex).
    end method.
    
    /* Returns the last index or 0/zero for the given element
       
       @param P.L.O The element to find
       @return integer The last index at which the element can be found, or 0 */
    method public integer LastIndexOf(input pElement as Progress.Lang.Object):
        define variable loop as integer no-undo.
        
        do loop = mSize to 1 by -1:
            if (     valid-object(this-object:Value[loop]) and this-object:Value[loop]:Equals(pElement) )
            or ( not valid-object(this-object:Value[loop]) and not valid-object(pElement) )
            then
                return loop.
        end.
        
        return 0.
    end method.
    
    /* Removes an entry and reduces the array's size
       
       @param integer The positive index
       @return P.L.O The object that was removed */
    method public Progress.Lang.Object Remove(input pIndex as integer):
        define variable prevObj as Progress.Lang.Object no-undo.
        define variable loop as integer no-undo.
        define variable max as integer no-undo.
        
        Assert:IsPositive(pIndex, 'List index').
        if pIndex gt this-object:Size then
            undo, throw new AssertionFailedError(substitute('Index &1 is larger than the collection size of &2', pIndex, this-object:Size), 0).
        
        assign prevObj = GetValue(pIndex)
               max     = this-object:Size - 1
               .
        do loop = pIndex to max:
            assign this-object:Value[loop] = this-object:Value[loop + 1]. 
        end.
        assign this-object:Value[mSize] = ?
               mSize                    = mSize - 1
               .
        return prevObj.
    end method.
    
    /* Overwrites an element at an index with another 
       
       @param integer The positive index location to overwrite
       @param P.L.Object The object to save. May be null
       @return P.L.Object The object being replaced in the array */
    method public Progress.Lang.Object Set(input pIndex as integer,
                                           input pElement as Progress.Lang.Object ):
        define variable prevObj as Progress.Lang.Object no-undo.
        
        Assert:IsPositive(pIndex, 'List index').
        if pIndex gt this-object:Size then
            undo, throw new AssertionFailedError(substitute('Index &1 is larger than the collection size of &2', pIndex, this-object:Size), 0).
        
        assign prevObj = GetValue(pIndex).
        SetValue(pElement, pIndex).
        
        return prevObj.
    end method.
    
    /* Returns a view of the portion of this list between the specified fromIndex, inclusive, and toIndex, exclusive.
       
       The fromIndex value must be positive and <= this list's Size
       The toIndex value must be positive and <= this list's Size 
       The fromIndex value must be <= toIndex value
       If fromIndex and toIndex are equal, the returned list has 1 entry.
       
       @param integer fromIndex Low endpoint (INCLUSIVE) of the subList
       @param integer toIndex   High endpoint (INCLUSIVE) of the subList
       @return IList a List containing the items. Has at least 1 entry. */
    method public IList SubList(input pFromIndex as integer,
                                input pToIndex as integer):
        define variable list as IList no-undo.
        define variable loop as integer no-undo.
        
        Assert:IsPositive(pFromIndex, 'List From-Index').
        Assert:IsPositive(pToIndex, 'List To-Index').
        
        if pFromIndex gt this-object:Size then
            undo, throw new AssertionFailedError(substitute('From-Index &1 is larger than the collection size of &2', pFromIndex, this-object:Size)).
        if pToIndex gt this-object:Size then
            undo, throw new AssertionFailedError(substitute('To-Index range &1 is larger than the collection size of &2', pToIndex, this-object:Size)).
        if pFromIndex gt pToIndex then
            undo, throw new AssertionFailedError(substitute('From-Index &1 is larger To-Index &2', pFromIndex, pToIndex)).
        
        assign list = new List().
        do loop = pFromIndex to pToIndex:
            list:Add(this-object:Value[loop]).
        end.
        
        return list.
    end method.

    /* Two Lists  are defined to be equal if they are the same size and
       all of the elements in this collection are in the to-compare List and 
       in the same sequence.
       
       @param P.L.Object
       @return logical TRUE if the Lists are equal. FALSE otherwise */
    method public override logical Equals(o as Object):
        define variable list as IList no-undo.
        define variable loop as integer no-undo.
        define variable elem as Progress.Lang.Object no-undo.
        
        if super:Equals(o) then 
            return true.
        
        if type-of(o, IList) then
        do:
            assign list = cast(o, IList).
            if not list:Size eq this-object:Size then
                return false.
            
            do loop = 1 to mSize:
                assign elem = list:Get(loop).
                if (     valid-object(this-object:Value[loop]) and not this-object:Value[loop]:Equals(elem) )
                or ( not valid-object(this-object:Value[loop]) and valid-object(elem) )
                then
                    return false.
            end.
            return true.
        end.
        
        return false.
    end method.

end class.
