/************************************************
Copyright (c) 2014, 2020, 2022 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : StringKeyedMap
    Purpose     : A map containing String keys and general Object values.
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : Wed Dec 18 13:55:14 EST 2013
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Collections.EntrySet.
using OpenEdge.Core.Collections.ICollection.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.IMap.
using OpenEdge.Core.Collections.IMapEntry.
using OpenEdge.Core.Collections.ISet.
using OpenEdge.Core.Collections.IStringKeyedMap.
using OpenEdge.Core.Collections.KeySet.
using OpenEdge.Core.Collections.StringKeyedMap.
using OpenEdge.Core.Collections.ValueCollection.
using OpenEdge.Core.String.
using Progress.Lang.Object.

class OpenEdge.Core.Collections.StringKeyedMap implements IStringKeyedMap:
    // The bucket in which we hold all the StringStringMaps. There's only ever one (since its static)
    // so this class is responsible for clenaing up after itself
    define static private temp-table StrKeyMap no-undo
        field ParentMap as int64
        field Key as character
        field ValObj as Progress.Lang.Object
        index idxParent as primary ParentMap    // This index ensures that the default record order is 'as-added' and not by Key
        index idxKey as unique ParentMap Key
        .
    
    /* Returns the number of key-value mappings in this map.*/
    define public property Size as integer no-undo get. protected set.
    
    /* A collection of only the values in the Map */
    define public property Values as ICollection no-undo
    get():
        /* Return a new ValueCollection on each request. This is somewhat
           inefficient, but doing so prevents a circular reference from being created.
           
           This property is typically used in a transient fashion (ie for iteration
           over the contents of the Map) and is expected to be scoped to a small block
           like a single method. */
        return new ValueCollection(this-object, temp-table StrKeyMap:handle, substitute('ParentMap eq &1':u, int64(this-object)), "ValObj").
    end.
    
    /* An  ordered set of only the keys in the Map */
    define public property KeySet as ISet no-undo
    get():
        /* Return a new KeySet on each request. This is somewhat
           inefficient, but doing so prevents a circular reference from being created.
           
           This property is typically used in a transient fashion (ie for iteration
           over the contents of the Map) and is expected to be scoped to a small block
           like a single method. */
        return new KeySet(this-object, temp-table StrKeyMap:handle, substitute('ParentMap eq &1':u, int64(this-object)), "Key").
    end.
    
    /* An ordered set of key-value objects in the Map */
    define public property EntrySet as ISet no-undo
    get():
        /* Return a new EntrySet on each request. This is somewhat
           inefficient, but doing so prevents a circular reference from being created.
           
           This property is typically used in a transient fashion (ie for iteration
           over the contents of the Map) and is expected to be scoped to a small block
           like a single method. */
        return new EntrySet(this-object, temp-table StrKeyMap:handle, substitute('ParentMap eq &1':u, int64(this-object)), "Key").
    end.
    
    /* Destructor */
    destructor StringKeyedMap():
        this-object:Clear().
    end destructor.
    
    /* Default constructor */
    constructor public StringKeyedMap():
        super().
    end constructor.
    
    /* Constructor. Populates the map with the contents of another map.
       
       @param IMap Contains entries to add to this map. Entries are just added to this map, and are not cloned/duplicated */
    constructor public StringKeyedMap(input pMap as IMap):
        this-object().
        
        if valid-object(pMap) then
            PutAll(pMap).
    end constructor.
    
    /* Removes all mappings from this map (optional operation). */
    method public void Clear():
        define buffer bMap for StrKeyMap.
        
        for each bMap
           where bMap.ParentMap eq int64(this-object):
            delete bMap.
        end.
        assign this-object:Size = 0.
    end method.
    
    /* Helper method to find a map entry by key
       
       @param character The key value to find
       @param buffer for StrKeyMap
       @return logical TRUE if a record exists with the given key; FALSE if there are no matching entries */
    method private logical FindMapRecord(input pKey as character, buffer pMap for StrKeyMap):
        release pMap.

        if can-find(pMap
              where pMap.ParentMap eq int64(this-object)
                and pMap.Key eq pKey                    )
        then
            {&_proparse_ prolint-nowarn(findnoerror)}
            find pMap
           where pMap.ParentMap eq int64(this-object)
             and pMap.Key eq pKey.
        
        return (available pMap).
    end method.

    /* Adds a value and/or key to the map.
       Does the actual addition into the StrKeyMap table.
       
       @param character The key for the map entry. May be empty or unknown. Is unique in the map.
       @param Object The value matching the key. May be empty or unknown.
       @return Object The previous value, or unknown if none. Unknown is a valid value too. */
    method public Progress.Lang.Object Put(input pKey as character,
                                           input pValue as Progress.Lang.Object):
        define variable oldValue as Object no-undo.
        define buffer bMap for StrKeyMap.
        
        FindMapRecord(pKey, buffer bMap).
        if not available bMap then
        do:
            create bMap.
            assign bMap.ParentMap = int64(this-object)
                   bMap.Key       = pKey
                   oldValue       = ?
                   Size           = Size + 1
                   .
        end.
        else
            assign oldValue = bMap.ValObj.
        
        assign bMap.ValObj = pValue.
        
        return oldValue.
    end method.
    
    /** Retrieves the value for a particular key
        
        @param character The key value
        @return Object The associated value */
    method public Progress.Lang.Object Get(input pKey as character):
        define buffer bMap for StrKeyMap.
        
        FindMapRecord(pKey, buffer bMap).
        if available bMap then
            return bMap.ValObj.
        else
            return ?.
    end method.

    /* Returns true if this map contains no key-value mappings.
    
       @return logical TRUE if the map has no entries; FALSE otherwise */
    method public logical IsEmpty():
        return (this-object:Size eq 0).
    end method.

    /** Indicates whether a map exists for this key

        @param character the key value. May be unknown
        @return logical True if this key exists; FALSE otherwise */
    method public logical ContainsKey(input pcKey as character):
        define buffer bMap for StrKeyMap.
        
        FindMapRecord(pcKey, buffer bMap).
        return (available bMap).
    end method.
    
    /* Returns true if this map contains a mapping for the specified key.
       
       @param Object A key value. Must be valid and of type OE.Core.String
       @return logical TRUE of the map contains an entry with the specified key; FALSE otherwise */
    method public logical ContainsKey(input pKey as Progress.Lang.Object):
        Assert:IsType(pKey, get-class(String)).
        
        return ContainsKey(cast(pKey, String)).
    end method.
    
    /* Returns true if this map contains a mapping for the specified key.
       
       @param String A key value. Must be valid
       @return logical TRUE of the map contains an entry with the specified key; FALSE otherwise */
    method public logical ContainsKey(input pKey as String):
        define buffer bMap for StrKeyMap.
        
        Assert:NotNull(pKey, 'Map key').
        
        FindMapRecord(pKey:ToString(), buffer bMap).
        return (available bMap).
    end method.
    
    /* Returns true if this map contains all of the keys in a collection.
       
       @param ICollection A collection of keys. Must be a valid object.
       @return logical TRUE if all the keys in the input collection are in this map */
    method public logical ContainsAllKeys(input pKeys as ICollection):
        define variable iter as IIterator no-undo.
        define variable item as Progress.Lang.Object no-undo.
        
        Assert:NotNull(pKeys, 'Keys collection').
        
        // if the 'check' collection is empty, then true
        if pKeys:IsEmpty() then
            return true.
        
        // if there are fewer items in this collection than the source, this one can't have them all
        if this-object:Size lt pKeys:Size then
            return false.
        
        assign iter = pKeys:Iterator().
        do while iter:HasNext():
            assign item = iter:Next().
            // the ContainsKey() method throws errors on these conditions;
            // we just want to return false
            if not valid-object(item) then
                return false.
            
            if not this-object:ContainsKey(item:ToString()) then
                return false.
        end.
        
        return true.
    end method.
    
    /* Returns true if this map contains all of the values in a collection.
       
       @param ICollection A collection of values. Must be a valid object.
       @return logical TRUE if all the values in the input collection are in this map */
    method public logical ContainsValue(input pValue as Progress.Lang.Object):
        define buffer bMap for StrKeyMap.
        
        find bMap
       where bMap.ParentMap eq int64(this-object)
         and bMap.ValObj eq pValue
         no-error.
        
        if available bMap then
            return true.
        
        // if the passed-in value is ? and there is a null value in the map, the FIND above would have
        // found it, so we can short-circuit here
        if valid-object(pValue) then
        for each bMap
           where bMap.ParentMap eq int64(this-object):
            if pValue:Equals(bMap.ValObj) then
                return true.
        end.
        
        return false.
    end method.
    
    /* Returns true if this map maps one or more keys to the specified value.
       
       @param ICollection A collection of values
       @return logical TRUE if all of the values in the source collection are values in the map's Values */
    method public logical ContainsAllValues(input pValues as ICollection):
        define variable iter as IIterator no-undo.
        define variable item as Progress.Lang.Object no-undo.
        
        Assert:NotNull(pValues, 'Check values').
        
        /* if the 'check' collection is empty, then true */
        if pValues:IsEmpty() then
            return true.
        
        /* if the passed in collection is larger than this collection,
           this cannot be true. */
        if pValues:Size gt this-object:Size then
            return false.
        
        /* one or both collections has data */
        assign iter = pValues:Iterator().
        do while iter:HasNext():
            assign item = iter:Next().
            
            // the ContainsValue() method throws errors if the item is not a valid String object.
            // we just want to return false
            if  valid-object(item)
            and not type-of(item, String)
            then
                return false.
            // null items are supported
            if not this-object:ContainsValue(item) then
                return false.
        end.
        
        return true.
    end method.
    
    /** Retrieves the value for a particular key
        
        @param Object The key value. The value object must be valid and of type OpenEdge.Core.String
        @return Object The associated value, or unknown if the entry does not exist. If the value exists, it will be of type OpenEdge.Core.String */
    method public Progress.Lang.Object Get(input pKey as Progress.Lang.Object):
        Assert:IsType(pKey, get-class(String)).
        
        return get(cast(pKey, String)).
    end method.
    
    /** Retrieves the value for a particular key
        
        @param String The key value. The value object must be valid.
        @return Object The associated value, or unknown if the entry does not exist */
    method public Progress.Lang.Object Get(input pKey as String):
        define buffer bMap for StrKeyMap.
        
        Assert:NotNull(pKey, 'Map key').
        
        FindMapRecord(pKey:ToString(), buffer bMap).
        if available bMap then
            return bMap.ValObj.
        else
            return ?.
    end method.
    
    /* Adds a value and/or key to the map.
       
       @param Object The key for the map entry. Must be a valid value and must be of type OpenEdge.Core.String, but may have an empty or unknown value. Is unique in the map.
       @param Object The value matching the key. If it is a valid value, it must be of type OpenEdge.Core.String, but may have an empty or unknown value.
       @return Object The previous value, or unknown if none. If a valid value, will be of type OpenEdge.Core.String. Unknown is a valid value too. */
    method public Progress.Lang.Object Put(input pKey as Progress.Lang.Object,
                                           input pValue as Progress.Lang.Object):
        Assert:IsType(pKey, get-class(String)).
        if valid-object(pValue) then
            Assert:IsType(pValue, get-class(String)).
        
        return this-object:Put(pKey:ToString(), cast(pValue, String)).
    end method.
    
    /* Adds a value and/or key to the map.
       
       @param String The key for the map entry. Must be a valid value, but may have an empty or unknown value. Is unique in the map.
       @param Object The value matching the key. Must be a valid value, but may have an empty or unknown value.
       @return Object The previous value, or unknown if none. Unknown is a valid value too. */
    method public Progress.Lang.Object Put(input pKey as String,
                                           input pValue as Progress.Lang.Object):
        Assert:NotNull(pKey, 'Map key').
        
        return this-object:Put(pKey:ToString(), pValue).
    end method.
    
    /* Copies all of the mappings from the specified map to this map (optional operation).
       
       @param IMap A valid map */
    method public void PutAll(input pMap as IMap):
        define variable mapEntry as IMapEntry no-undo.
        define variable iter  as IIterator no-undo.
        
        Assert:NotNull(pMap, 'Source map').
        
        if type-of(pMap, IStringKeyedMap) then
            PutAll(cast(pMap, IStringKeyedMap)).
        else
        do:
            assign iter = pMap:EntrySet:Iterator().
            do while iter:HasNext():
                assign mapEntry = cast(iter:Next(), IMapEntry).
                this-object:Put(mapEntry:Key, mapEntry:Value).
            end.
        end.
    end method.
    
    /* Adds all the values from an input map
       
       @param IStringStringMap A valid map */
    method public void PutAll(input pMap as IStringKeyedMap):
        define variable mapEntry as IMapEntry no-undo.
        define variable iter  as IIterator no-undo.
        define buffer srcMap for StrKeyMap.
        define buffer tgtMap for StrKeyMap.
        
        Assert:NotNull(pMap, 'Source map').
        
        if type-of(pMap, StringKeyedMap) then
        for each srcMap
           where srcMap.ParentMap eq int64(pMap):
            
            FindMapRecord(srcMap.Key, buffer tgtMap).
            if not available tgtMap then
            do:
                create tgtMap.
                assign tgtMap.ParentMap = int64(this-object)
                       tgtMap.Key       = srcMap.Key
                       Size             = Size + 1
                       .
            end.
            assign tgtMap.ValObj  = srcMap.ValObj.
        end.
        else
        do:
            assign iter = pMap:EntrySet:Iterator().
            do while iter:HasNext():
                assign mapEntry = cast(iter:Next(), IMapEntry).
                this-object:Put(string(mapEntry), mapEntry:Value).
            end.
        end.
    end method.
    
    /** Removes the mappings for all key from this map if it is present (optional operation).
        
        @param ICollection A collection of keys to remove */
    method public void RemoveAll(input pKeys as ICollection):
        define variable key as Progress.Lang.Object no-undo.
        define variable iter  as IIterator no-undo.
        define buffer bMap for StrKeyMap.
        
        Assert:NotNull(pKeys, 'Keys collection').
        
        assign iter = pKeys:Iterator().
        do while iter:HasNext():
            assign key = iter:Next().
            if FindMapRecord(string(key), buffer bMap) then
            do:
               assign Size = Size - 1.
               delete bMap.
           end.
        end.
    end method.
    
    /** Removes the value for a particular key
    
        @param Object The key value. Must be a valid object, and must be of type OpenEdge.Core.String
        @return Object The associated value (of type OpenEdge.Core.String), or unknown if there is no entry. */
    method public Progress.Lang.Object Remove(input pKey as Progress.Lang.Object):
        Assert:IsType(pKey, get-class(String)).
        
        return Remove(cast(pKey, String)).
    end method.
    
    /** Removes the value for a particular key
    
        @param String The key value. Must be a valid object.
        @return Object The associated value, or unknown if there is no entry. */
    method public Progress.Lang.Object Remove(input pKey as String):
        define variable oldVal as Object no-undo.
        define buffer bMap for StrKeyMap.
        
        Assert:NotNull(pKey, 'Object map').
        
        FindMapRecord(pKey:ToString(), buffer bMap).
        if available bMap then
        do:
            assign oldVal = bMap.ValObj
                   Size   = Size - 1
                   .
            delete bMap.
        end.
        
        return oldVal.
    end method.
    
    /** Removes the value for a particular key
    
        @param character The key value
        @return Object associated value */
    method public Progress.Lang.Object Remove(input pcKey as character):
        define variable oldVal as Object no-undo.
        define buffer bMap for StrKeyMap.
        
        FindMapRecord(pcKey, buffer bMap).
        if available bMap then
        do:
            assign oldVal = bMap.ValObj
                   Size   = Size - 1
                   .
            delete bMap.
        end.
        
        return oldVal.
    end method.
end class.
