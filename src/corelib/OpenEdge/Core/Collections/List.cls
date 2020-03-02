/************************************************
Copyright (c) 2013, 2016-2019 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : List
    Purpose     : 
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Wed Jan 09 10:45:45 EST 2008
    Notes       : 
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Assertion.AssertArray.
using OpenEdge.Core.AssertionFailedError.
using OpenEdge.Core.Collections.AbstractTTCollection.
using OpenEdge.Core.Collections.ICollection.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.IList.
using OpenEdge.Core.Collections.IListIterator.
using OpenEdge.Core.Collections.Iterator.
using OpenEdge.Core.Collections.List.
using OpenEdge.Core.Collections.ListIterator.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Core.Collections.List serializable inherits AbstractTTCollection
        implements IList:
    /* default temp-table  */ 
    define serializable protected temp-table ttList no-undo
      field sequence as int
      field objectref as Object 
      index objidx objectref
      index seq as unique primary sequence
      .
    /* Default constructor */
    constructor public List():
        super (temp-table ttList:handle,'objectref').        
    end constructor.
       
    constructor public List (list as IList):
        super (cast (list,ICollection),temp-table ttList:handle,'objectref').        
    end constructor.
    
    constructor protected List ( input poCol as ICollection, input phtt as handle, input pcField as character ):
        super (input poCol, input phtt, input pcField).
    end constructor.
        
    constructor protected List ( input phtt as handle, input pcField as character ):
        super (input phtt, input pcField).
    end constructor.
    
    constructor protected List ( input phtt as handle, input hField as handle ):
        super (input phtt, input hField).
    end constructor.
    
    /* Find the FIRST reference of the search object; the search order 
       is by the List's Sequence. This means that if there are 2 instances
       of this object, a dev will need to iterate over the collection to 
       determine which ones match. 
       
       @param Progress.Lang.Object The search object */
    method protected override void FindBufferUseObject(findObject as Object):
        FindBufferUseObject(findObject, buffer ttList).
    end method.
    
    /* Find the FIRST reference of the search object; the search order 
       is by the List's Sequence. This means that if there are 2 instances
       of this object, a dev will need to iterate over the collection to 
       determine which ones match. 
       
       The input buffer is RELEASED (so that we don't leak scope).
       
       @param Progress.Lang.Object The search object 
       @param buffer ttList The buffer to search    */
    method protected void FindBufferUseObject(findObject as Object,
                                              buffer pbList for ttList):
        define variable listItem as rowid no-undo.
        
        assign listItem = ?. 
        release pbList.         // RELEASE THE LISTS
        
        for each pbList  where 
                 pbList.objectref eq findObject 
                 by pbList.sequence
                 while listItem eq ?:
            // we won't get in here unless there's the identical reference 
            assign listItem = rowid(pbList).
        end.
        
        for each pbList
                 by pbList.sequence
                 while listItem eq ?:
            if pbList.objectref:Equals(findObject) then
                assign listItem = rowid(pbList).
        end.
        
        if not listItem eq ? then
            find pbList where rowid(pbList) eq listItem.
    end method.
    
    method public logical Add(seq as integer, obj as Object ):    
        define buffer btList for ttList.
        
        Assert:IsPositive(seq, 'List index').
        if seq gt this-object:Size then
            return error new AssertionFailedError(substitute('List index &1 is larger than the list size &2', seq, this-object:Size)).
        
        if super:Add(obj) then
        do:
            for each btList where
                     btList.sequence ge seq
                     by btList.sequence descending:
                assign btList.sequence = btList.sequence + 1.
            end.
            
            // Don't use, in case we have the same item more than once: FindBufferUseObject(obj)
            // The just-added item, with the default Sequence
            find btList where btList.sequence eq 0.
            assign btList.Sequence = seq.
            
            return true.
        end.
        return false.
    end method.
    
    method public override logical Add(obj as Object ):
        if super:Add(obj) then
        do:
            // Don't use, in case we have the same item more than once: FindBufferUseObject(obj[iLoop])
            // The just-added item, with the default Sequence
            find ttList where ttList.sequence eq 0.
            assign ttList.Sequence = this-object:Size.
            return true.
        end.
        
        return false.
    end method.
    
    /** Adds all of the input collection to the current list.
        Items from the input collection as added to the END of 
        the current list.
        To prepend items, call AddAll(1, ICollection)
        
        @param ICollection The collection to add.
        @return logical TRUE if items were added (ie the input collection has at least one item) */
    method override public logical AddAll(c as ICollection):
        return this-object:AddAll(this-object:Size + 1, c).
    end method.
    
    /** Adds all of the input collection to the current list, starting at the
        index given (ie the index passed is the first item) 
        
        @param integer The index from which to add. Must be non-zero and positive 
        @param ICollection The collection to add
        @return logical TRUE if items were added (ie the input collection has at least one item) */
    method public logical AddAll(seq as int,c as ICollection):
        define buffer btList for ttList.
        define variable iterator as IIterator no-undo.
        
        Assert:NotNull(c, 'Collection').
        Assert:IsPositive(seq, 'List index').
        
        if c:Size eq 0 then
            return false.
        
        // Don't allow us to add stuff at a point beyond the size of this collection
        assign seq = min(seq, this-object:Size + 1).
        
        for each btList where btList.sequence >= seq by btList.sequence desc:
            assign btList.sequence = btList.sequence + c:Size.
        end.
        
        assign iterator = c:Iterator(). 
        do while iterator:HasNext():
            super:Add(iterator:Next()).
            // Don't use, in case we have the same item more than once: FindBufferUseObject(oItem)
            // The just-added item, with the default Sequence
            find btList where btList.sequence eq 0.
            assign btList.sequence = seq
                   seq             = seq + 1
                   .
        end.
        return true.
    end method.
    
    method public logical AddArray(seq as int, obj as Object extent):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define buffer btList for ttList.
        
        Assert:IsPositive(seq, 'List index').
        AssertArray:HasDeterminateExtent(obj, 'Items array').
        
        assign iMax = extent(obj).
        for each btList where btList.sequence >= seq by btList.sequence desc:
            assign btList.sequence = btList.sequence + iMax + 1. 
        end.
        
        do iLoop = 1 to iMax:
            super:Add(obj[iLoop]).
            
            // Don't use, in case we have the same item more than once: FindBufferUseObject(obj[iLoop])
            // The just-added item, with the default Sequence
            find btList where btList.sequence eq 0.
            assign btList.Sequence = seq
                   seq             = seq + 1.
        end.
        
        return true.
    end method.
     
    /* Two Lists  are defined to be equal if they are the same size and
       all of the elements in this collection are in the to-compare List and 
       in the same sequence.
       
       @param P.L.Object
       @return logical TRUE if the Lists are equal. FALSE otherwise */
    method public override logical Equals(o as Object):
        define buffer btList for ttList.
        define variable list as IList no-undo.
        
        if super:Equals(o) then 
            return true.
        
        if type-of(o, IList) then
        do:
            assign list = cast(o, IList).
            if not list:Size eq this-object:Size then
                return false.
            
            for each btList:
                if not btlist.objectref:Equals(list:Get(btList.sequence)) then
                    return false.
            end.
            return true.
        end.
        
        return false.
    end method.
    
    /* Returns the object represented by the index
       
       @param integer The sequence to find. Must be positive and <= the Size.  
       @return Object The object represented by the sequence. May be ? */
    method public Object Get(i as integer):
        define buffer bList for ttList.
         
        Assert:IsPositive(i, 'List index').
        if i gt this-object:Size then
            undo, throw new AssertionFailedError(substitute('Index &1 is larger than List size &2', i, this-object:Size)).
        
        if can-find(bList where bList.sequence eq i) then
            find bList where bList.sequence eq i.
        
        if avail bList then 
            return bList.objectref.
        else
            return ?.
    end method.
    
    method public integer IndexOf(obj as Object ):
        define variable iIndex as integer no-undo.
        
        assign iIndex = 0.
        // this loop picks up invalid object references too
        for each ttList where
                 ttList.objectref = obj 
                 by ttList.sequence
                 while iIndex eq 0:
            assign iIndex = ttList.sequence. 
        end.
        
        for each ttList 
                 by ttList.Sequence
                 while iIndex eq 0: 
            if ttList.objectref:Equals(obj) then
                assign iIndex = ttList.sequence. 
        end.
        
        return iIndex.    
    end method.
     
    /* Returns a new IIterator over the collection.  */
    method public override IIterator Iterator(  ):        
        return new Iterator(this-object,temp-table ttList:handle,"objectref","sequence").
    end method.
    
    /* Returns a new IListIterator over the collection.  */
    method public IListIterator ListIterator(  ):
        return new ListIterator(this-object,temp-table ttList:handle,"objectref","sequence").
    end method.
    
    /* Returns a new IListIterator over the collection.*/
    method public IListIterator ListIterator(i as integer):
        Assert:IsPositive(i, 'List index').
        
        return new ListIterator(this-object,temp-table ttList:handle,"objectref","sequence","sequence >= " + string(i)).
    end method.
    
    method public integer LastIndexOf(obj as Object ):
        define variable iIndex as integer no-undo.
        
        assign iIndex = 0.
        // this loop picks up invalid object references too
        for each ttList where ttList.objectref = obj 
                 by ttList.sequence descending
                 while iIndex eq 0:
            assign iIndex = ttList.sequence. 
        end.
        
        for each ttList 
                 by ttList.Sequence descending
                 while iIndex eq 0: 
            if ttList.objectref:Equals(obj) then
                assign iIndex = ttList.sequence. 
        end.
        
        return iIndex.    
    end method.
    
    method override public logical Remove(oldObject as Object ):
        define variable iStart as integer no-undo.
        define buffer btList for ttList.
        
        findBufferUseObject(oldObject, buffer btList). 
        if avail btList then
        do:
            iStart = btList.sequence.
            if super:remove(oldobject) then
            do:
                // reorder incl the one we removed
                for each btList where btList.Sequence >= iStart:
                    assign btList.sequence = btList.Sequence - 1.
                end.
                
                return true.
            end. 
        end.    
        return false.
    end method.
    
    /** Removes an item at the given index
    
        @param integer The index to remove. Must be between 1 and the size of the List
        @return Progress.Lang.Object The item that was removed. */
    method public Object Remove(i as integer):
        define variable oldObject as Object.
        define buffer bList for ttList.
        
        Assert:IsPositive(i, 'List index').
        if i gt this-object:Size then
            undo, throw new AppError(substitute('Index &1 is larger than the collection size of &2', i, this-object:Size), 0).
        
        if can-find(bList where bList.sequence eq i) then
            find bList where bList.sequence eq i.
        
        if available bList then
        do:
            assign oldObject = bList.objectref.
            delete bList.
            
            // reorder incl the one we removed
            for each bList where bList.Sequence >= i:
                assign bList.sequence = bList.Sequence - 1.
            end.
            
            //Only the parent can set the Size
            Resize().
        end.
        
        return oldObject.
    end method.
    
    method public Object Set(input i as integer, input poReplacement as Object ):
        define variable oldObject as Object.
        define buffer bList for ttList.
        
        Assert:IsPositive(i, 'List index').
        if i gt this-object:Size then
            undo, throw new AppError(substitute('Index &1 is larger than the collection size of &2', i, this-object:Size), 0).
        
        if can-find(bList where bList.sequence eq i) then
            find bList where bList.sequence eq i.
        
        if available bList then
            assign oldObject       = bList.objectref
                   bList.objectref = poReplacement
                   .
        return oldObject.
    end method.
    
    /* Returns a view of the portion of this list between the specified fromIndex, inclusive, and toIndex, exclusive.
       
       The fromIndex value must be positive and <= this list's Size
       The toIndex value must be positive and <= this list's Size 
       The fromIndex value must be <= toIndex value
       If fromIndex and toIndex are equal, the returned list has 1 entry.
       
       @param integer fromIndex Low endpoint (INCLUSIVE) of the subList
       @param integer toIndex   High endpoint (INCLUSIVE) of the subList
       @return IList a List containing the items. Has at least 1 entry. */
    method public IList SubList(fromIndex as integer, toIndex as integer):
        define variable list as IList no-undo.
        define buffer lbList for ttList.
        
        Assert:IsPositive(fromIndex, 'List From-Index').
        Assert:IsPositive(toIndex, 'List To-Index').
        
        if fromIndex gt this-object:Size then
            undo, throw new AssertionFailedError(substitute('From-Index &1 is larger than the collection size of &2', fromIndex, this-object:Size)).
        if toIndex gt this-object:Size then
            undo, throw new AssertionFailedError(substitute('To-Index range &1 is larger than the collection size of &2', toIndex, this-object:Size)).
        if fromIndex gt toIndex then
            undo, throw new AssertionFailedError(substitute('From-Index &1 is larger To-Index &2', fromIndex, toIndex)).
        
        assign list = new List().
        for each lbList where
                 lbList.sequence ge fromIndex and
                 lbList.sequence le toIndex
                 by lbList.sequence:
            
            list:Add(lbList.objectref).
        end.
        
        return list.
    end method.
    
end class.
