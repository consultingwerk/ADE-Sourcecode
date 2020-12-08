/************************************************
Copyright (c) 2013, 2015, 2017-2018, 2020 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : Map
    Purpose     : Unique Key-Value mapping collection 
    Syntax      :  
    Description : 
    @author hdaniels
    Created     : Sun Apr 11 01:35:13 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Collections.EntrySet.
using OpenEdge.Core.Collections.ICollection.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.IMap.
using OpenEdge.Core.Collections.ISet.
using OpenEdge.Core.Collections.KeySet.
using OpenEdge.Core.Collections.Map.
using OpenEdge.Core.Collections.ValueCollection.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Core.Collections.Map serializable
        implements IMap:
    
    define protected temp-table ttMap no-undo 
      field KeyRef      as Object 
      field ValueRef    as Object
      index validx ValueRef
      index keyidx as unique primary KeyRef.
    
    /* The size of the Map, being the number of keys */
    define public property Size as integer no-undo 
        get.
        private set. 
    
    /* A collection of only the values in the Map */
    define public property Values as ICollection no-undo 
    get():
        /* Return a new ValueCollection on each request. This is somewhat
           inefficient, but doing so prevents a circular reference from being created.
           
           This property is typically used in a transient fashion (ie for iteration
           over the contents of the Map) and is expected to be scoped to a small block
           like a single method. */
        return new ValueCollection(this-object,temp-table ttMap:handle,"ValueRef").
    end.   
   
    /* An  ordered set of only the keys in the Map */
    define public property KeySet as ISet no-undo 
    get():
        /* Return a new KeySet on each request. This is somewhat
           inefficient, but doing so prevents a circular reference from being created.
           
           This property is typically used in a transient fashion (ie for iteration
           over the contents of the Map) and is expected to be scoped to a small block
           like a single method. */
        return new KeySet(this-object,temp-table ttMap:handle,"KeyRef").
    end.   
         
    /* An ordered set of key-value objects in the Map */
    define public property EntrySet as ISet no-undo 
    get():
        /* Return a new EntrySet on each request. This is somewhat
           inefficient, but doing so prevents a circular reference from being created.
           
           This property is typically used in a transient fashion (ie for iteration
           over the contents of the Map) and is expected to be scoped to a small block
           like a single method. */
        return new EntrySet(this-object,temp-table ttMap:handle,"KeyRef").
    end.   
            
    /* Empties the map's contents */
    method public void Clear():
        empty temp-table ttMap.
        assign this-object:Size = 0.
    end method.

    /* Returns true if the given object is also a map and the two Maps represent the same mappings.  */
    method public override logical Equals(o as Object):
        define buffer btMap for ttMap.
        define variable oMap as IMap no-undo.
        define variable oValue as Object no-undo.
        
        if super:Equals(o) then 
            return true.
        if type-of(o,IMap) then
        do:
            oMap = cast(o,IMap).
            if oMap:Size = Size then
            do:
                for each btMap:
                    oValue = oMap:Get(btMap.KeyRef).
                    if oValue <> ? and oValue <> btMap.ValueRef then
                        return false.
                    
                    if oValue = ? then
                    do:
                       if not oMap:ContainsKey(btMap.KeyRef) then
                           return false. 
                       if btMap.ValueRef <> ? then
                           return false.
                    end.       
                end.
                return true.
            end.    
        end.
        return false.    
    end method.    
    
    /* Indicates whether the map has any entries.
       
       @return logical TRUE if the map is empty (no entries) and false otherwise */
    method public logical IsEmpty(  ):
        return not can-find(first ttMap).
    end method.

    /* Indicates whether the map contains a particular key
       
       @param Object A key value to search
       @return Logical TRUE if the map contains the key value */
    method public logical ContainsKey(input poKey as Object):
        define variable lContainsKey as logical no-undo.
        define buffer lbMap for ttMap.
        
        if not valid-object(poKey) then
            return false.
        
        /* try by-reference first */
        lContainsKey = can-find(lbMap where lbMap.KeyRef = poKey). 
        for each lbMap while lContainsKey = false:
            lContainsKey = lbMap.KeyRef:Equals(poKey).
        end.
               
        return lContainsKey.
    end method.
    
    /* Returns true if this map contains all of the keys passed in. 
       
       @param ICollection The collection of keys
       @return logical TRUE if all of the keys in the input collection are in the map */
    method public logical ContainsAllKeys(input poKeys as ICollection):
        define variable oIterator as IIterator.
        
        Assert:NotNull(poKeys, 'Check keys').
        
        /* if the 'check' collection is empty, then true */  
        if poKeys:IsEmpty() then
            return true.
        
        /* if the passed in collection is larger than this collection,
           this cannot be true. */
        if poKeys:Size gt this-object:Size then
            return false.
        
        /* one or both collections has data */
        oIterator = poKeys:Iterator().
        do while oIterator:HasNext():
            if not this-object:ContainsKey(oIterator:Next()) then
                return false.
        end.
        
        return true.
    end method.
    
    /* Returns true if this map contains all of the values passed in. 
       
       @param ICollection The collection of values 
       @return logical TRUE if all of the values in the input collection are in the map */
    method public logical ContainsAllValues(input poValues as ICollection):
        define variable oIterator as IIterator.
        
        Assert:NotNull(poValues, 'Check values').
        
        /* if the 'check' collection is empty, then true */  
        if poValues:IsEmpty() then
            return true.
        
        /* if the passed in collection is larger than this collection,
           this cannot be true. */
        if poValues:Size gt this-object:Size then
            return false.
        
        /* one or both collections has data */
        oIterator = poValues:Iterator().
        do while oIterator:HasNext():
            if not this-object:ContainsValue(oIterator:Next()) then
                return false.
        end.
        
        return true.
    end method.
    
    /* Returns true if this map contains the value passed in. 
       
       @param ICollection The value to check
       @return logical TRUE if the value is in the map */
    method public logical ContainsValue(poValue as class Object):
        define variable lContainsValue as logical no-undo.
        define buffer lbMap for ttMap.
        
        if not valid-object(poValue) then
            return false.
        
        /* try by-reference first */
        lContainsValue = can-find(lbMap where lbMap.ValueRef = poValue). 
        for each lbMap while lContainsValue = false:
            lContainsValue = lbMap.ValueRef:Equals(poValue).
        end.
                       
        return lContainsValue.
    end method.
    
    /* Returns a value for a given key in the Map 
       
       @param  Object The key fopr which to return a value. NULL/unknown if the key is not in the map
       @return Object The value represented by the key */ 
    method public Object Get(poKey as Object):
        define variable oValue as Object no-undo.
        define buffer lbMap for ttMap.
       
        if not valid-object(poKey) then
            return oValue.
        
        if can-find(lbMap where lbMap.KeyRef eq poKey) then
            find lbMap where lbMap.KeyRef = poKey.
        if avail lbMap then
            assign oValue = lbMap.ValueRef.
        
        for each lbMap while not valid-object(oValue):
            if lbMap.KeyRef:Equals(poKey) then
                assign oValue = lbMap.ValueRef.
        end.
        
        return oValue.
    end method.
    
    /* Add entry to the map, return old value of any. Note that return of unknown could 
       also mean that the old mapped value was unknown... (check Size before and after)
       
       @param Object The key for this mapping
       @param Object The value for the mapping 
       @return Object If a value is replaced, the previous value is returned, otherwise null */   
    method public Object Put(poKey as Object, poValue as class Object):
        define variable oOld as Object no-undo.
        define buffer lbMap for ttMap.
        define buffer putMap for ttMap.
        
        if not valid-object(poKey) then
            return oOld. 
        
        if poKey:Equals(this-object) then
             undo, throw new AppError("A Map cannot have itself as key.").
        /* not a real transaction, but scoping of updates 
          (not tested without, so not sure if it is really needed... )  */
        do transaction:
            /* try by-reference first */
            if can-find(lbMap where lbMap.KeyRef eq poKey) then
                find putMap where putMap.KeyRef eq poKey.
            if not available putMap then        
            for each lbMap while not available putMap:
                if lbMap.KeyRef:Equals(poKey) then 
                    find putMap where rowid(putMap) eq rowid(lbMap).
            end.
            // Add an entry
            if not avail putMap then
            do:
                create putMap.
                assign putMap.KeyRef = poKey
                       Size = Size + 1.
            end.
            else
                // Update an entry
                assign oOld = putMap.ValueRef.
            
            assign putMap.ValueRef = poValue.
        end.
        
        return oOld.
    end method.
    
    /* Adds all entries from another map to this one.
       
       @param IMap The input map */
    method public void PutAll(poMap as IMap):
        define variable oKey as Object no-undo.
        define variable oIter as IIterator no-undo.    
 
        oIter = poMap:KeySet:Iterator(). 
        do while oIter:hasNext():
            oKey = oIter:Next().
            this-object:Put(oKey,poMap:Get(oKey)).
        end.
    end method.
    
    /* Removes an entry
     
       @param Object The key for the entry to remove
       @param Object the value associated with that key. May be null.  Note that return of unknown could 
       also mean that the old mapped value was unknown. */ 
    method public Object Remove(input poKey as Object):
        define variable oOld as Object no-undo.
        define buffer lbMap for ttMap.
        define buffer removeMap for ttMap.
        
        if not valid-object(poKey) then
            return ?.
        
        /* try by-reference first */
        if can-find(removeMap  where removeMap.KeyRef eq poKey) then
            find removeMap where removeMap.KeyRef eq poKey.
        
        if not available removeMap then
        for each lbMap while not available removeMap:
            if lbMap.KeyRef:Equals(poKey) then
                find removeMap where rowid(removeMap) eq rowid(lbMap).
        end.
        
        if avail removeMap then
        do:
            assign oOld = removeMap.ValueRef
                   Size = Size - 1.
            delete removeMap.
        end.
        
        return oOld.
    end method.

    /** Removes the mappings for all key from this map if it is present (optional operation).
        
        @param ICollection A collection of keys to remove */
    method public void RemoveAll(input poKeys as ICollection).
        define variable oIterator as IIterator no-undo.
        define variable oRemove  as Object.
        define buffer removeMap for ttMap. 
        
        oIterator = poKeys:iterator().
        do while oIterator:HasNext():
            oRemove = oIterator:Next().
            for each removeMap where removeMap.KeyRef eq oRemove:
                delete removeMap.
                Size = Size - 1.
            end.
            
            for each removeMap:
                if removeMap.KeyRef:Equals(oRemove) then
                do:
                    delete removeMap.
                    Size = Size - 1.
                end.
            end.
        end.
    end method.
    
    /* Constructor. Creates a new map an populates with with a set of values.
    
       @param IMap Contains values to add to this map */
    constructor public Map (input poMap as IMap):
        super ().    
        if type-of(poMap, Map) then
        do:
            poMap:Values:ToTable(output table ttMap).
            Size = poMap:Size.
        end. 
        else
            PutAll(poMap).  
    end constructor.
    
    /* Default constructor */
    constructor public Map (  ):
        super ().   
    end constructor.

    destructor public Map ( ):
        this-object:Clear().
    end destructor.

end class.
