/************************************************
Copyright (c) 2013, 2016-2018 by Progress Software Corporation. All rights reserved.
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
    define protected temp-table ttList no-undo
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
        define variable listItem as rowid no-undo.
        
        assign listItem = ?. 
        for each ttList where 
                 ttList.objectref eq findObject 
                 by ttList.sequence
                 while listItem eq ?:
            // we won't get in here unless there's the identical reference 
            assign listItem = rowid(ttList).
        end.
        
        for each ttList 
                 by ttList.sequence
                 while listItem eq ?:
            if ttList.objectref:Equals(findObject) then
                assign listItem = rowid(ttList).
        end.
        
        if not listItem eq ? then
            find ttList where rowid(ttList) eq listItem.
    end method.
    
    method public logical Add(seq as integer, obj as Object ):    
        define buffer btList for ttList.
        
        Assert:IsPositive(seq, 'List index').
        
        if super:Add(obj) then
        do:
            for each btList where btList.sequence >= seq by btList.sequence desc:
                btList.sequence = btList.sequence + 1. 
            end.
            
            // Don't use, in case we have the same item more than once: FindBufferUseObject(obj)
            // The just-added item, with the default Sequence
            find ttList where ttList.sequence eq 0.
            assign ttList.Sequence = seq.
            return true.
        end.
        return false.
    end method.
    
    method public override logical Add(obj as Object ):    
        if super:Add(obj) then
        do:
            // Don't use, in case we have the same item more than once: FindBufferUseObject(obj)
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
            find ttList where ttList.sequence eq 0.
            assign ttList.sequence = seq
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
        
        iMax = extent(obj).
        
        for each btList where btList.sequence >= seq by btList.sequence desc:
            btList.sequence = btList.sequence + iMax + 1. 
        end.
        
        do iLoop = 1 to iMax:
            super:Add(obj[iLoop]).
            
            // Don't use, in case we have the same item more than once: FindBufferUseObject(obj[iLoop])
            // The just-added item, with the default Sequence
            find ttList where ttList.sequence eq 0.
            ttList.Sequence = Seq.
            seq = seq + 1.
        end.
        
        return true.         
    end method.
     
    /* two lists are defined to be equal if they contain the same elements in the same order */
    method public override logical Equals(o as Object):
        define buffer btList for ttList.
        define variable oList as List no-undo.
        
        if super:Equals(o) then 
            return true.
        
        if type-of(o,List) then
        do:
            assign oList = cast(o,List).
            if not oList:Size eq Size then
                return false.
            for each btList:
                // This method uses the ttList buffer
                FindBufferUseObject(oList:Get(btList.Sequence)).
                if not available ttList then
                    return false.
            end.
            return true.
        end.
        return false.    
    end method.    
    
    method public Object Get(i as integer):
        Assert:IsPositive(i, 'List index').
        if i gt this-object:Size then
            undo, throw new AssertionFailedError(substitute('Index &1 is larger than List size &2', i, this-object:Size)).
        
        if can-find(ttList where ttList.sequence eq i) then
            find ttList where ttList.sequence = i no-error.
        if avail ttList then 
            return ttList.objectref.
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
        findBufferUseObject(oldObject). 
        if avail ttList then
        do:
            iStart = ttList.sequence.
            if super:remove(oldobject) then
            do:
                for each btList where btList.Sequence > iStart:
                    btList.sequence = btList.Sequence - 1.     
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
        define buffer btList for ttList.
        
        Assert:IsPositive(i, 'List index').
        if i gt this-object:Size then
            undo, throw new AppError(substitute('Index &1 is larger than the collection size of &2', i, this-object:Size), 0).
        
        // Get() finds the ttList record
        assign oldObject = this-object:Get(i).
        delete ttList.
        
        //Only the parent can set the Size
        Resize().
        
        for each btList where 
                 btList.sequence gt i 
                 by btList.sequence:
            assign btList.sequence = btList.sequence - 1. 
        end.
        
        return oldObject.
    end method.
    
    method public Object Set(input i as integer, input poReplacement as Object ):
        define variable oldObject as Object.
        
        Assert:IsPositive(i, 'List index').
        if i gt this-object:Size then
            undo, throw new AppError(substitute('Index &1 is larger than the collection size of &2', i, this-object:Size), 0).
         
        if can-find(ttList where ttList.sequence eq i) then
        do: 
            find ttList where ttList.sequence = i no-error.
            assign 
                oldObject        = ttList.objectref  
                ttList.objectref = poReplacement.
        end.
        return oldObject.
    end method.
    
    method public IList SubList(fromIndex as integer, toIndex as integer):
        define variable list as IList no-undo.
        define variable oObject as Object no-undo.
        
        Assert:IsPositive(fromIndex, 'List start index').
        Assert:IsPositive(toIndex, 'List end index').
        
        if fromIndex gt this-object:Size then
            undo, throw new AppError(substitute('From-Index &1 is larger than the collection size of &2', fromIndex, this-object:Size), 0).
        
        if (fromIndex + toIndex) gt this-object:Size then
            undo, throw new AppError(substitute('To-Index range &1 is larger than the collection size of &2', fromIndex + toIndex, this-object:Size), 0).
        
        if fromIndex ge toIndex then
            undo, throw new AppError(substitute('From-Index &1 is larger To-Index &2', fromIndex, toIndex), 0).
        
        list = new List().
        do fromIndex = fromIndex to toIndex - 1:
           oObject = get(fromIndex).
           if valid-object(oObject) then
              list:add(oObject).  
           else do: 
              delete object list. 
              return ?. 
           end.     
        end.
        return list.
    end method.
     
end class.
