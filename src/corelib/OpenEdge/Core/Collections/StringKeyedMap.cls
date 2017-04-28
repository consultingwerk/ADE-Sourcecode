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

using OpenEdge.Core.Collections.IStringKeyedMap.
using OpenEdge.Core.String.
using Progress.Lang.Object.

{OpenEdge/Core/Collections/typedmapclass.i
    &Package        = OpenEdge.Core.Collections
    &ImplementsType = IStringKeyedMap
    
    &MapType   = StringKeyedMap
    &KeyType   = String
    &ValueType = Progress.Lang.Object
     
    &NoEndClass = true  }

    /** Adds an entry to the map
        
        @param character The key value
        @param Object The value
        @return Object The value added (may be previous value) */
    method public Object Put(input pcKey as character, input poValue as Progress.Lang.Object):
        return this-object:Put(new String(pcKey), poValue).
    end method.
        
    /** Retrieves the value for a particular key
    
        @param character The key value
        @return longchar The associated value */
    method public Progress.Lang.Object Get(input pcKey as character):
        return this-object:Get(new String(pcKey)).
    end method.
    
    /** Removes the value for a particular key
    
        @param character The key value
        @return longchar The associated value */
    method public Progress.Lang.Object Remove(input pcKey as character):
        return this-object:Remove(new String(pcKey)).
    end method.
    
    /** Indicates whether a map exists for this key

        @param character the key value
        @return logical True if this key exists */
    method public logical ContainsKey(input pcKey as character):
        return this-object:ContainsKey(new String(pcKey)).
    end method.

end class.