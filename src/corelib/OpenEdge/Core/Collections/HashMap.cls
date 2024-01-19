/************************************************
Copyright (c) 2023 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : Map
    Purpose     : A map containing P.L.Object keys and values.
    Description :
    Author(s)   : dugrau
    Created     : Sun Apr 11 01:35:13 EDT 2010
    Notes       : An implementation of OpenEdge.Core.Collections.IMap
                  which uses the Progress.Collections.HashMap for storage.
                  
                  This class differs from OpenEdge.Core.Collections.Map in
                  the following important ways:
                    - The implicit FIFO ordering of keys is not supported
                    - The ContainsValue method is not implemented by default
                    - Only key objects which produce the same HashCode will
                      be found in the internal P.C.HashMap instance (IOW:
                      even if another object is considered Equals(), it may
                      produce a different hash-code value)

                  NOTICE: This class is intended for backwards compatibility
                  with applications using the OpenEdge.Core.Collections though
                  for Map objects it is highly recommended to directly use the
                  new Progress.Collections.HashMap<K,V> class directly.
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Collections.ICollection.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.IMap.
using OpenEdge.Core.Collections.IMapEntry.
using OpenEdge.Core.Collections.ISet.
using OpenEdge.Core.Collections.MapEntry.
using OpenEdge.Core.Collections.ObjectEqualityComparer.
using OpenEdge.Core.Collections.Set.
using Progress.Collections.HashMap.
using Progress.Collections.KeyValuePair.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Core.Collections.HashMap
serializable
implements IMap:

    /* New for OE12.8: Changed from temp-table to the new HashMap object as the holder of the map data. */
    var private HashMap<Object, Object> mBackingHashMap.

    /* The size of the Map, being the number of keys */
    define public property Size as integer no-undo
    get():
        return this-object:mBackingHashMap:Count.
    end.

    /* A collection (OE.Core.Set) of only the values in the Map, ordered by key */
    define public property Values as ICollection no-undo
    get():
        var Progress.Collections.IIterator<KeyValuePair<Object, Object>> iter.
        var ICollection mapValues = new Set().
        var Object oVal.

        // Iterate over the key List, returning a Object to look up the HashMap value.
        iter = this-object:mBackingHashMap:GetIterator().
        repeat while iter:MoveNext():
            if valid-object(iter:Current) then
                // Add the object (or unknown value) directly to the new set of values.
                oVal = this-object:mBackingHashMap:GetValue(iter:Current:Value).
                if valid-object(oVal) then
                    mapValues:Add(oVal).
                else
                    mapValues:AddNull(). // Purposefully add an unknown value to the Set.
        end.

        return mapValues.
    end.

    /* A set (OE.Core.Set) of only the keys (in order of entry) from the Map */
    define public property KeySet as ISet no-undo
    get():
        var Progress.Collections.IIterator<KeyValuePair<Object, Object>> iter.
        var ISet mapKeys = new Set().

        // Iterate over the key List, returning a single Object for each entry.
        iter = this-object:mBackingHashMap:GetIterator().
        repeat while iter:MoveNext():
            // Keys should always be a valid object, but let's just make 100% sure.
            if valid-object(iter:Current:Key) then
                mapKeys:Add(iter:Current:Key).
            else
                mapKeys:Add(?).
        end.

        return mapKeys.
    end.

    /* A set (OE.Core.Set) of key-value pairs (in order of entry) from the Map */
    define public property EntrySet as ISet no-undo
    get():
        var Progress.Collections.IIterator<KeyValuePair<Object, Object>> iter.
        var ISet entrySet = new Set().

        // Iterate over the key List, returning a single Object for each entry.
        iter = this-object:mBackingHashMap:GetIterator().
        repeat while iter:MoveNext():
            // Create a new MapEntry which points back to this Map object and a specific key object.
            // When a value is needed, it will use the Get() on the parent Map object by this Key.
            entrySet:Add(new MapEntry(this-object, iter:Current:Key)).
        end.

        return entrySet.
    end.

    /* Destructor */
    destructor HashMap ( ):
        delete object this-object:mBackingHashMap.
    end destructor.

    /* Default constructor */
    constructor HashMap ( ):
        super().

        this-object:mBackingHashMap = new HashMap<Object, Object>(new ObjectEqualityComparer()).
    end constructor.

    /* Constructor. Populates the map with the contents of another map.

       @param IMap Contains entries to add to this map. Entries are just added to this map, and are not cloned/duplicated */
    constructor HashMap (input pMap as IMap):
        this-object(). // Call the no-parameter constructor for this class.

        if valid-object(pMap) then
            this-object:PutAll(pMap).
    end constructor.

    /* Removes all mappings from this map (optional operation). */
    method public void Clear ( ):
        this-object:mBackingHashMap:Clear().
    end method.

    /* Returns true if this map contains a mapping for the specified key.

       @param Object The key for the map entry. Must be valid and of type P.L.Object
       @return logical TRUE if the map contains an entry with the specified key; FALSE otherwise */
    method public logical ContainsKey (input pKey as Object):
        Assert:NotNull(pKey).

        // Simply return true if the map contains the key by hash (integer).
        if this-object:mBackingHashMap:ContainsKey(pKey) then
            return true. // Only true when the key exists by hash.

        return false. // Otherwise we cannot or did not find a match.
    end method.

    /* Returns true if this map contains all of the keys in a collection.

       @param ICollection A collection of keys. Must be a valid object.
       @return logical TRUE if all the keys in the input collection are in this map */
    method public logical ContainsAllKeys (input pKeys as ICollection):
        var IIterator iter.
        var Object checkItem.

        Assert:NotNull(pKeys, 'Keys collection').

        // if the 'check' collection is empty, then true
        if pKeys:IsEmpty() then
            return true.

        // if there are fewer items in this collection than the source, this one can't have them all
        if this-object:Size lt pKeys:Size then
            return false.

        assign iter = pKeys:Iterator().
        do while iter:HasNext():
            assign checkItem = iter:Next().

            // the ContainsKey() method throws errors if the item is not a valid object.
            if not valid-object(checkItem) then
                return false.

            if not this-object:ContainsKey(checkItem) then
                return false.
        end.

        return true.
    end method.

    /* Returns true if there's at least one value in the map that equals the input value.

       @param Object The value to find. May be null/unknown.
       @return logical TRUE if at least one value exists in the map; FALSE otherwise. */
    method public logical ContainsValue (input pValue as Object):
        // This method is not available within the Progress.Collections.HashMap
        undo, throw new AppError("The method ContainsValue is not implemented.").
    end method.

    /* Returns true if this map maps one or more keys to the specified value.

       @param ICollection A collection of values
       @return logical TRUE if all of the values in the source collection are values in the map's Values */
    method public logical ContainsAllValues (input pValues as ICollection):
        // This method is not available within the Progress.Collections.HashMap
        undo, throw new AppError("The method ContainsAllValues is not implemented.").
    end method.

    /* Retrieves the value for a particular key

        @param Object The key for the map entry. The value object must be valid and of type P.L.Object
        @return Object The associated value, or unknown if the entry does not exist. If the value exists, it will be of type Progress.Lang.Object */
    method public Object Get (input pKey as Object):
        var Object pValue.
        var logical lFound.

        Assert:NotNull(pKey, 'Map key').

        // Attempts to find the matching key first, and may or may not return an object.
        lFound = this-object:mBackingHashMap:TryGetValue(pKey, output pValue).
        if lFound then
            return pValue. // Return the object.
        else
            return ?.

        catch err as Progress.Lang.Error:
            return ?. // TryGetValue may raise an error if the value cannot be returned.
        end catch.
    end method.

    /* Returns true if this map contains no key-value mappings.

       @return logical TRUE if the map has no entries; FALSE otherwise */
    method public logical IsEmpty ( ):
        return this-object:mBackingHashMap:IsEmpty.
    end method.

    /* Adds a value and/or key to the map.

       @param Object The key for the map entry. Must be a valid object, but may have an empty or unknown value. Is unique in the map.
       @param Object The value for the key. May be a valid Object.
       @return Object The previous value, or unknown if none. Unknown is a valid value too. */
    method public Object Put (input pKey as Object,
                              input pValue as Object):
        var Object oldValue.
        var logical lFound.

        Assert:NotNull(pKey, 'Map key'). // Key must be a valid object.

        // Determine whether to update or add the value based on whether the key was found in the Map.
        if this-object:mBackingHashMap:ContainsKey(pKey) then do:
            // We expect this to be true given that we could find a key, but let's use the return value anyway.
            lFound = this-object:mBackingHashMap:TryGetValue(pKey, output oldValue).
            if lFound then
                this-object:mBackingHashMap:Set(pKey, pValue). // Update the existing value for this key.
        end. // lKeyExists
        else do:
            // This will use the given key object to create a new entry since the key did not exist.
            this-object:mBackingHashMap:Add(pKey, pValue).
        end. // not lKeyExists

        return oldValue. // Just return the Object as found.
    end method.

    /* Adds all entries from another map to this one (optional operation).

       @param IMap A valid map */
    method public void PutAll (input pMap as IMap):
        var IMapEntry mapEntry.
        var IIterator iter.

        Assert:NotNull(pMap, 'Source map').
        if type-of(pMap, IMap) then
            this-object:PutAll(cast(pMap, IMap)).
        else do:
            assign iter = pMap:EntrySet:Iterator().
            do while iter:HasNext():
                assign mapEntry = cast(iter:Next(), IMapEntry).

                // Treat as Object/Object and do additional checks in that Put().
                if valid-object(mapEntry) then
                    this-object:Put(mapEntry:Key, mapEntry:Value).
            end.
        end.
    end method.

    /* Removes the mappings for all key from this map if it is present (optional operation).

        @param ICollection A collection of keys to remove */
    method public void RemoveAll (input pKeys as ICollection):
        var Object keyObj.
        var IIterator iter.

        Assert:NotNull(pKeys, 'Keys collection').

        assign iter = pKeys:Iterator().
        do while iter:HasNext():
            assign keyObj = iter:Next().

            this-object:Remove(keyObj).
        end.
    end method.

    /* Removes the map entry for a particular key

        @param Object The key for the map entry. Must be a valid object.
        @return Object The associated value, or unknown if there is no entry. */
    method public Object Remove (input pKey as Object):
        var Object oldValue.
        var logical lKeyExists, lFound.

        Assert:NotNull(pKey, 'Object map').

        lFound = this-object:mBackingHashMap:TryGetValue(pKey, output oldValue).
        if lFound then do:
            this-object:mBackingHashMap:Remove(pKey). // Remove the HashMap entry identified by Key.
            return oldValue. // Return the object.
        end.
        else
            return ?.

        catch err as Progress.Lang.Error:
            return ?. // TryGetValue may raise an error if the value cannot be returned.
        end catch.
    end method.


    /* Compares this Map to another object, confirming if both are IMap objects with identical mappings.

        @param Object The other object to compare (if also an IMap)
        @return logical True if the given object is also a map and the two Maps represent the same mappings. */
    method public override logical Equals(oRef as Object):
        var IMap oMap.
        var Object oValue.
        var Progress.Collections.IIterator<KeyValuePair<Object, Object>> iter.

        if not valid-object(oRef) then
            return false. // Parameter was just an unknown value.

        if super:Equals(oRef) then
            return true. // eg. Same object (handle) reference.

        if type-of(oRef, IMap) then do:
            oMap = cast(oRef,IMap).

            // Only proceed if both have the same count of entries.
            if oMap:Size eq this-object:Size then do:

                // Iterate over the backing HashMap itself, returning true only if everything matches.
                iter = this-object:mBackingHashMap:GetIterator().
                repeat while iter:MoveNext():
                    // Note that values may be unknown or any Object,
                    // while keys must always be a valid Object.
                    if valid-object(iter:Current) then do:
                        // First, check if the same key exists in the reference map.
                        if not oMap:ContainsKey(iter:Current:Key) then
                            return false. // Reference map does not contain this key.

                        // Next, check if the values are the same.
                        oValue = oMap:Get(iter:Current:Key).
                        if valid-object(iter:Current:Value) then do:
                            // Value for this key is a valid object, so compare.
                            if not iter:Current:Value:Equals(oValue) then
                                return false.
                        end.
                        else do:
                            // Value for this key is unknown, so confirm with reference.
                            if oValue ne ? then return false. // No match if other is not unknown.
                        end.
                    end.
                end.

                return true. // Only returned if successfully iterated over the same number of entries.
            end.
        end.

        return false. // Fall-through case assumes not equal (eg. reference object is not an IMap).
    end method.

end class.
