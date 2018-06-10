/************************************************
Copyright (c) 2013, 2017 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : EntrySet
    Purpose     : 
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : apr 2010
    Notes       : no empty constructor, specialized for KeySet of IMap 
                 - Changes to the map are reflected here, and vice-versa. 
                 - Supports removal and removes the corresponding map entry from the map
                   (Iterator.remove, Collection.remove, removeAll, retainAll and clear) .
                 - Do not support add and addAll.   
                 - no empty constructor, specialised for IMap 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Collections.MapBackedCollection.
using OpenEdge.Core.Collections.EntrySetIterator. 
using OpenEdge.Core.Collections.IIterator. 
using OpenEdge.Core.Collections.ISet.  
using OpenEdge.Core.Collections.IMapEntry.
using OpenEdge.Core.Collections.IMap.
using OpenEdge.Core.Collections.ICollection.
using OpenEdge.Core.Assert.
using Progress.Lang.Object.

class OpenEdge.Core.Collections.EntrySet serializable inherits MapBackedCollection
            implements ISet:
    constructor public EntrySet (poMap as IMap,phTT as handle,pcKeyField as char):
        super (poMap,phTT,pcKeyField ).
    end constructor.
    
     /* Returns a new IIterator over the entryset. */
    method public override IIterator Iterator():    
        return new EntrySetIterator(
                    OwningMap,
                    this-object,
                    this-object:OwningBuffer,
                    this-object:KeyField:name).
    end method.
    
    /* abstract because this could be a key or value */
    method override public logical Contains( checkObject as Object):
        Assert:IsType(checkObject, get-class(IMapEntry)).
        
        return OwningMap:KeySet:Contains(cast(checkObject, IMapEntry):Key).
    end method.
    
    method override public logical ContainsAll(input poCollection as ICollection):
        define variable oIterator as IIterator no-undo.               
        define variable oEntry as Object    no-undo.
        
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
            oEntry = oIterator:Next().
            Assert:IsType(oEntry, get-class(IMapEntry)).
            
            if not OwningMap:ContainsKey(cast(oEntry, IMapEntry):Key) then
                return false.
        end.
        
        return true.
    end method.
    
    /* abstract because this could be a collection of keys or values */
    method override public logical Remove(poOld as Object):
        Assert:IsType(poOld, get-class(IMapEntry)).
        
        return OwningMap:KeySet:Remove(cast(poOld, IMapEntry):Key).
    end method.
    
    /* abstract because this could be a collection of keys or values */
    method override public logical RemoveAll(poRemoveCol as ICollection):
        define variable oIterator as IIterator no-undo.
        define variable oEntry as Object    no-undo.
        define variable oKey as Object    no-undo.
        define variable lRemoved as logical no-undo.
        
        oIterator = poRemoveCol:Iterator().
        do while oIterator:HasNext():
            oEntry = oIterator:Next().
            Assert:IsType(oEntry, get-class(IMapEntry)).
            
            oKey = OwningMap:Get(cast(oEntry, IMapEntry):Key).
            
            if cast(oEntry, IMapEntry):Key:Equals(oKey) then
                OwningMap:Remove(oKey).
        end.            

        return lRemoved.        
    end method.
    
    /* abstract because this could be a collection of keys or values */
    method override public logical RetainAll(input poRetainCollection as ICollection).
        define variable oIterator as IIterator no-undo.
        define variable oMapEntry as IMapEntry no-undo.
        define variable lAny as logical no-undo.   
        
        oIterator = this-object:Iterator().
        do while oIterator:HasNext():
            oMapEntry = cast(oIterator:Next(), IMapEntry).
            
            if not poRetainCollection:Contains(oMapEntry) then 
            do:
                do while Remove(oMapEntry):
                    lAny = true.
                end.
            end.
        end.
        return lAny.
    end method.
    
end class.
