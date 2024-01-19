/************************************************
Copyright (c) 2014, 2019-2021, 2023 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : StringStringMap
    Purpose     : A map containing OE.Core.String keys and String values.
    Description :
    Author(s)   : pjudge
    Created     : Wed Dec 18 13:55:14 EST 2013
    Notes       : An implementation of OpenEdge.Core.Collections.IMap
                  which now uses the Progress.Collections.HashMap for
                  data storage.

                  NOTICE: This class is intended for backwards compatibility
                  with applications using the OpenEdge.Core.Collections though
                  for Map objects it is highly recommended to directly use the
                  new Progress.Collections.HashMap<K,V> class directly.
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using Ccs.Common.Support.ILongcharHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Core.Collections.ICollection.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.IMap.
using OpenEdge.Core.Collections.IMapEntry.
using OpenEdge.Core.Collections.ISet.
using OpenEdge.Core.Collections.IStringStringMap.
using OpenEdge.Core.Collections.MapEntry.
using OpenEdge.Core.Collections.Set.
using OpenEdge.Core.String.
using OpenEdge.Core.StringConstant.
using Progress.Collections.HashMap.
using Progress.Collections.KeyValuePair.
using Progress.Collections.List.
using Progress.Lang.Object.

class OpenEdge.Core.Collections.StringStringMap
implements IStringStringMap:

    /* New for OE12.8: Changed from temp-table to the new HashMap object as the holder of the map data. */
    var private HashMap<ILongcharHolder, ILongcharHolder> mBackingHashMap.

    /* Separate listing of unique key entries, sorted by order of addition to the HashMap object. */
    var private List<ILongcharHolder> mKeyList.

    /* Returns the number of key-value mappings in this map.*/
    define public property Size as integer no-undo
    get():
        return this-object:mBackingHashMap:Count.
    end.

    /* A collection (OE.Core.Set) of only the values in the Map, ordered by key */
    define public property Values as ICollection no-undo
    get():
        var Progress.Collections.IIterator<ILongcharHolder> iter.
        var ICollection mapValues = new Set().
        var Object oVal.

        // Iterate over the key List, returning a ILongcharHolder to look up the HashMap value.
        iter = this-object:mKeyList:GetIterator().
        repeat while iter:MoveNext():
            if valid-object(iter:Current) then
                // Add the object (or unknown value) directly to the new set of values.
                oVal = this-object:mBackingHashMap:GetValue(iter:Current).
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
        var Progress.Collections.IIterator<ILongcharHolder> iter.
        var ISet mapKeys = new Set().

        // Iterate over the key List, returning a single ILongcharHolder for each entry.
        iter = this-object:mKeyList:GetIterator().
        repeat while iter:MoveNext():
            // Keys should always be a valid object, but let's just make 100% sure.
            if valid-object(iter:Current) then
                mapKeys:Add(iter:Current).
            else
                mapKeys:Add(new String(StringConstant:UNKNOWN)).
        end.

        return mapKeys.
    end.

    /* A set (OE.Core.Set) of key-value pairs (in order of entry) from the Map */
    define public property EntrySet as ISet no-undo
    get():
        var Progress.Collections.IIterator<ILongcharHolder> iter.
        var ISet entrySet = new Set().

        // Iterate over the key List, returning a single ILongcharHolder for each entry.
        iter = this-object:mKeyList:GetIterator().
        repeat while iter:MoveNext():
            // Create a new MapEntry which points back to this StringStringMap object and a specific key object.
            // When a value is needed, it will use the Get() on the parent StringStringMap object by this Key.
            entrySet:Add(new MapEntry(this-object, iter:Current)).
        end.

        return entrySet.
    end.

    /* Destructor */
    destructor StringStringMap ( ):
        delete object this-object:mBackingHashMap.
        delete object this-object:mKeyList.
    end destructor.

    /* Default constructor */
    constructor public StringStringMap ( ):
        super().

        this-object:mBackingHashMap = new HashMap<ILongcharHolder, ILongcharHolder>().
        this-object:mKeyList = new List<ILongcharHolder>().
    end constructor.

    /* Constructor. Populates the map with the contents of another map.

       @param IMap Contains entries to add to this map. Entries are just added to this map, and are not cloned/duplicated */
    constructor public StringStringMap (input pMap as IMap):
        this-object(). // Call the no-parameter constructor for this class.

        if valid-object(pMap) then
            this-object:PutAll(pMap).
    end constructor.

    /* Removes all mappings from this map (optional operation). */
    method public void Clear ( ):
        this-object:mBackingHashMap:Clear().
        this-object:mKeyList:Clear().
    end method.

    /* Returns true if this map contains a mapping for the specified key.

       @param Object The key for the map entry. Must be valid and of type OE.Core.String
       @return logical TRUE if the map contains an entry with the specified key; FALSE otherwise */
    method public logical ContainsKey (input pKey as Object):
        Assert:IsType(pKey, get-class(String)).

        return this-object:ContainsKey(cast(pKey, String)).
    end method.

    /* Returns true if this map contains a mapping for the specified key.

       @param String The key for the map entry. Must be valid
       @return logical TRUE of the map contains an entry with the specified key; FALSE otherwise */
    method public logical ContainsKey (input pKey as String):
        return this-object:mBackingHashMap:ContainsKey(pKey).
    end method.

    /* Indicates whether a map exists for this key

        @param character The key for the map entry. May be unknown or blank.
        @return logical TRUE of the map contains an entry with the specified key; FALSE otherwise */
    method public logical ContainsKey (input pcKey as character):
        return this-object:ContainsKey(new String(pcKey)).
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

            // the ContainsKey() method throws errors if the item is not a valid String object.
            if not valid-object(checkItem) and not type-of(checkItem, String) then
                return false.

            if not this-object:ContainsKey(checkItem) then
                return false.
        end.

        return true.
    end method.

    /* Allows checking for either a valid object or a null value as present in this map. */
    method private logical ContainsValueOrNull (input pValue as Object):
        var Progress.Collections.IIterator<KeyValuePair<ILongcharHolder, ILongcharHolder>> iter.
        var Object hValue.

        // Iterate over the backing HashMap itself, returning true if we find a match.
        iter = this-object:mBackingHashMap:GetIterator().
        repeat while iter:MoveNext():
            // Note that values may be unknown or any Object.
            if valid-object(iter:Current) then do:
                assign hValue = iter:Current:Value.

                if valid-object(pValue) then do:
                    // Search value is an object, so use the Equals comparator.
                    if pValue:Equals(hValue) then return true.
                end.
                else do:
                    // Search value is unknown, so return true if we find such a value.
                    if hValue eq ? then return true.
                end.
            end.
        end.

        return false. // Default when nothing found.
    end method.

    /* Returns true if there's at least one value in the map that equals the input value.

       @param Object The value to find. May be null/unknown.
       @return logical TRUE if at least one value exists in the map; FALSE otherwise. */
    method public logical ContainsValue (input pValue as Object):
        if valid-object(pValue) then do:
            Assert:IsType(pValue, get-class(ILongcharHolder)). // Any object Value should be an ILongcharHolder.
            return this-object:ContainsValueOrNull(pValue).
        end.
        else
            return this-object:ContainsValueOrNull(?).
    end method.

    /* Returns TRUS if there's at least one value in the map that equals the input value.

       @param String The value to find. May be null/unknown.
       @return logical TRUE if at least one value exists in the map; FALSE otherwise. */
    method public logical ContainsValue (input pValue as String):
        if valid-object(pValue) then
            return this-object:ContainsValueOrNull(pValue).
        else
            return this-object:ContainsValueOrNull(?).
    end method.

    /* Indicates whether there is at least one value represented
        by the parameter in the map.

       @param character The value to find. May be unknown.
       @return logical TRUE if at least one value exists in the map; FALSE otherwise. */
    method public logical ContainsValue (input pValue as character):
        if pValue ne ? then
            // If not unknown, create a new String object with the character value.
            return this-object:ContainsValueOrNull(new String(pValue)).
        else
            return this-object:ContainsValueOrNull(?).
    end method.

    /* Returns true if this map maps one or more keys to the specified value.

       @param ICollection A collection of values
       @return logical TRUE if all of the values in the source collection are values in the map's Values */
    method public logical ContainsAllValues (input pValues as ICollection):
        var IIterator iter.
        var Object checkItem.

        Assert:NotNull(pValues, 'Check values').

        /* if the 'check' collection is empty, then true */
        if pValues:IsEmpty() then
            return true.

        // if there are fewer items in this collection than the source, this one can't have them all
        if this-object:Size lt pValues:Size then
            return false.

        /* one or both collections has data */
        assign iter = pValues:Iterator().
        do while iter:HasNext():
            assign checkItem = iter:Next().

            // note: null/unknown items should be supported
            if not this-object:ContainsValue(checkItem) then
                return false.
        end.

        return true.
    end method.

    /* Retrieves the value for a particular key

        @param Object The key for the map entry. The value object must be valid and of type OpenEdge.Core.String
        @return Object The associated value, or unknown if the entry does not exist. If the value exists, it will be of type OpenEdge.Core.String */
    method public Object Get (input pKey as Object):
        Assert:IsType(pKey, get-class(String)).

        return this-object:Get(cast(pKey, String)).
    end method.

    /* Retrieves the value for a particular key

        @param String The key for the map entry.
        @return String The associated value, or unknown if the entry does not exist */
    method public String Get (input pKey as String):
        var logical lFound.
        var Object pValue.

        Assert:NotNull(pKey, 'Map key').

        // Attempts to find the matching key first, and may or may not return an object.
        lFound = this-object:mBackingHashMap:TryGetValue(cast(pKey, String), output pValue).
        if lFound then do:
            if valid-object(pValue) then
                return cast(pValue, String). // Return the entire String object.
            else
                return ?.
        end.
        else
            return ?.

        catch err as Progress.Lang.Error:
            return ?. // TryGetValue may raise an error if the value cannot be returned.
        end catch.
    end method.

    /* Retrieves the value for a particular key

        @param character The key for the map entry.
        @return longchar The associated value, or unknown if the entry does not exist */
    method public longchar Get (input pKey as character):
        var logical lFound.
        var Object pValue.

        // Attempts to find the matching key first, and may or may not return an object.
        lFound = this-object:mBackingHashMap:TryGetValue(new String(pKey), output pValue).
        if lFound then do:
            if valid-object(pValue) then
                return cast(pValue, ILongcharHolder):Value. // Return the value from the ILongcharHolder object.
            else
                return ?.
        end.
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

    /* Values may be either String objects or the unknown value. */
    method private String PutStringOrNull (input pKey   as String,
                                           input pValue as String):
        var logical lFound, lCreated.
        var Object oldValue.

        Assert:NotNull(pKey, 'Map key'). // Key must be a String object.

        // Check if an entry with the given key already exists.
        lFound = this-object:mBackingHashMap:TryGetValue(pKey, output oldValue).
        if lFound then do:
            this-object:mBackingHashMap:Set(pKey, pValue). // Update the existing value for this key.
        end.
        else do:
            lCreated = this-object:mBackingHashMap:Add(pKey, pValue). // Create a new key-value Map entry.
            if lCreated then
                this-object:mKeyList:Add(pKey). // Update ordered List with new Key entry.
        end.

        return cast(oldValue, String). // Must return a String object.
    end method.

    /* Adds a value and/or key to the map.

       @param Object The key for the map entry. Must be a valid value and must be of type OpenEdge.Core.String, but may have an empty or unknown value. Is unique in the map.
       @param Object The value for the key. If it is a valid value, it must be of type OpenEdge.Core.String, but may have an empty or unknown value.
       @return String The previous value, or unknown if none. If a valid value, will be of type OpenEdge.Core.String. Unknown is a valid value too. */
    method public Object Put (input pKey as Object,
                              input pValue as Object):
        Assert:IsType(pKey, get-class(ILongcharHolder)). // We accept an Object as Key, but it must be an ILongcharHolder.

        if valid-object(pValue) then
            Assert:IsType(pValue, get-class(String)).

        // Both the Key and Value must be String objects.
        return this-object:Put(cast(pKey, String), cast(pValue, String)).
    end method.

    /* Adds a value and/or key to the map.

       @param String The key for the map entry. Must be a valid object, but may have an empty or unknown value. Is unique in the map.
       @param String The value for the key. May be a valid String object.
       @return String The previous value, or unknown if none. Unknown is a valid value too. */
    method public String Put (input pKey as String,
                              input pValue as String):
        return this-object:PutStringOrNull(pKey, pValue).
    end method.

    /* Adds a value and/or key to the map.

       @param character The key for the map entry. May be empty or unknown. Is unique in the map.
       @param character The value for the key. May be empty or unknown.
       @return character The previous value, or unknown if none. Unknown is a valid value too. */
    method public character Put (input pcKey as character,
                                 input pcValue as character):
        var String oldValue.

        if pcValue ne ? then
            oldValue = this-object:PutStringOrNull(new String(pcKey), new String(pcValue)).
        else
            oldValue = this-object:PutStringOrNull(new String(pcKey), ?).

        if valid-object(oldValue) then
            return string(oldValue:Value). // Return as a character (not longchar).
        else
            return ?.
    end method.

    /* Adds a value and/or key to the map.

       @param character The key for the map entry. May be empty or unknown. Is unique in the map.
       @param longchar The value for the key. May be empty or unknown.
       @return character The previous value, or unknown if none. Unknown is a valid value too. */
    method public longchar Put (input pcKey as character,
                                input pcValue as longchar):
        var String oldValue.

        if pcValue ne ? then
            oldValue = this-object:PutStringOrNull(new String(pcKey), new String(pcValue)).
        else
            oldValue = this-object:PutStringOrNull(new String(pcKey), ?).

        if valid-object(oldValue) then
            return oldValue:Value.
        else
            return ?.
    end method.

    /* Adds all entries from another map to this one (optional operation).

       @param IMap A valid map */
    method public void PutAll (input pMap as IMap):
        var IMapEntry mapEntry.
        var IIterator iter.

        Assert:NotNull(pMap, 'Source map').
        if type-of(pMap, IStringStringMap) then
            this-object:PutAll(cast(pMap, IStringStringMap)).
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

    /* Adds all the values from an input map (optional operation).

       @param IStringStringMap A valid map */
    method public void PutAll (input pMap as IStringStringMap):
        var MapEntry mapEntry.
        var IIterator iter.

        Assert:NotNull(pMap, 'Source map').

        // Iterate over the entries of the given map and add/set as necessary via the Put method.
        assign iter = pMap:EntrySet:Iterator().
        do while iter:HasNext():
            assign mapEntry = cast(iter:Next(), MapEntry).
            // Key and Value are both considered as String objects because this is an IStringStringMap.
            if valid-object(mapEntry) then
                this-object:Put(cast(mapEntry:Key, String), cast(mapEntry:Value, String)).
        end.
    end method.

    /* Removes the mappings for all key from this map if it is present (optional operation).

        @param ICollection A collection of keys to remove */
    method public void RemoveAll (input pKeys as ICollection):
        var Object keyObj.
        var IIterator iter.
        var String keyString.

        Assert:NotNull(pKeys, 'Keys collection').

        assign iter = pKeys:Iterator().
        do while iter:HasNext():
            assign keyObj = iter:Next().

            // We always expect a String as key.
            if type-of(keyObj, String) then
                assign keyString = cast(keyObj, String).
            else
                // Because the ICollection is generic, the key object could technically
                // be anything legal. So "string" it and create a new key object as String.
                assign keyString = new String(string(keyObj)).

            this-object:Remove(keyString).
        end.
    end method.

    /* Removes the value for a particular key

        @param Object The key for the map entry. Must be a valid object, and must be of type OpenEdge.Core.String
        @return Object The associated value (of type OpenEdge.Core.String), or unknown if there is no entry. */
    method public Object Remove (input pKey as Object):
        Assert:IsType(pKey, get-class(String)).

        return this-object:Remove(cast(pKey, String)).
    end method.

    /* Removes the map entry for a particular key

        @param String The key for the map entry. Must be a valid object.
        @return String The associated value, or unknown if there is no entry. */
    method public String Remove (input pKey as String):
        var Object oldValue.
        var logical lFound.

        Assert:NotNull(pKey, 'Object map').

        lFound = this-object:mBackingHashMap:TryGetValue(pKey, output oldValue).
        if lFound then do:
            this-object:mBackingHashMap:Remove(pKey). // Remove the HashMap entry identified by Key.
            this-object:mKeyList:Remove(pKey). // Remove the unique Key entry from the List.
            return cast(oldValue, String). // Return as String object.
        end.
        else
            return ?.

        catch err as Progress.Lang.Error:
            return ?. // TryGetValue may raise an error if the value cannot be returned.
        end catch.
    end method.

    /* Removes the value for a particular key

        @param character The key for the map entry, as longchar primitive.
        @return longchar The associated value, or unknown if there is no entry. */
    method public longchar Remove (input pcKey as character):
        var ILongcharHolder oldValue = this-object:Remove(new String(pcKey)).

        if valid-object(oldValue) then
            return oldValue:Value. // Return the longchar value of the ILongcharHolder object.
        else
            return ?.
    end method.

end class.
