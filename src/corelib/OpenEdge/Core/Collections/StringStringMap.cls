/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : StringStringMap
    Purpose     : A map containing String keys and String values.
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Dec 18 13:55:14 EST 2013
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Collections.IStringStringMap.
using OpenEdge.Core.String.
using Progress.Lang.Object.

{OpenEdge/Core/Collections/typedmapclass.i
    &Package        = OpenEdge.Core.Collections
    &ImplementsType = IStringStringMap
    
    &MapType   = StringStringMap
    &KeyType   = String
    &ValueType = String
     
    &NoEndClass = true  }

    /** Adds an entry to the map
        
        @param character The key value
        @param longchar The value
        @return longchar The value added (may be previous value) */
    method public longchar Put(input pcKey as character, input pcValue as longchar):
        define variable oOldValue as String no-undo.
        define variable lcOldValue as longchar no-undo.
                        
        oOldValue = this-object:Put(new String(pcKey), new String(pcValue)).
        if valid-object(oOldValue) then
            lcOldValue = oOldValue:Value.
        else
            lcOldValue = ?. 
        
        return lcOldValue.
    end method.
    
    /** Retrieves the value for a particular key
    
        @param character The key value
        @return longchar The associated value */
    method public longchar Get(input pcKey as character):
        define variable oValue as Object no-undo.
        
        assign oValue = this-object:Get(new String(pcKey)).
        if valid-object(oValue) then
            return cast(oValue, String):Value.
        else
            return ?.
    end method.
    
    /** Removes the value for a particular key
    
        @param character The key value
        @return longchar The associated value */
    method public longchar Remove(input pcKey as character):
        define variable oValue as Object no-undo.
        
        assign oValue = this-object:Remove(new String(pcKey)).
        if valid-object(oValue) then
            return cast(oValue, String):Value.
        else
            return ?.
    end method.
    
    /** Indicates whether a map exists for this key

        @param character the key value
        @return logical True if this key exists */
    method public logical ContainsKey(input pcKey as character):
        return this-object:ContainsKey(new String(pcKey)).
    end method.

    /** Indicates whether there is at least one value represented
        by the parameter in the map.
        
        @param longchar The value
        @return logical True if there is at least one entry with this value */    
    method public logical ContainsValue(input pcValue as character):
        return this-object:ContainsValue(new String(pcValue)).
    end method.
    
end class.