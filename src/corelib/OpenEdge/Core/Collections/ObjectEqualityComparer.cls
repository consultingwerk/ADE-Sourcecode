/************************************************
Copyright (c) 2023 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : ObjectEqualityComparer
    Purpose     : Default <Object> implementation for HashMap instances
    Description : 
    Author(s)   : egarcia, dugrau
    Created     : Mon May 15 00:18:04 EDT 2023
    Notes       : Basic implementation for use with HashMap<K,V> in lieu
                  of using Key objects with the IHashable interface.
                  This will work for custom classes which have not yet
                  implemented the expected methods for HashCode() and
                  a custom Equals() operation.
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Progress.Collections.IEqualityComparer.
using Progress.Collections.IHashable.
using Progress.Lang.Object.

class OpenEdge.Core.Collections.ObjectEqualityComparer
implements IEqualityComparer<Object>:

    method logical Equals(objectRef as Object, otherObj as Object):
        // Every class inherits from PLO which has a basic Equals() method.
        if valid-object(otherObj) then do:
            // Use the class Equals() for comparison, which should either return
            // via an override method or by comparing the Object reference ID's.
            // It is highly advised (and hoped) that the object has a customized
            // comparison defined as this is crucial for Collections usage.
            return objectRef:Equals(otherObj).
        end.

        // We must assume the Other object for comparision is the unknown value,
        // as by definition this is a valid object, so we cannot have a match.
        return false.
    end method.

    method integer HashCode(objectValue as Object):
        // Check if the object is an IHashable type first.
        if type-of(objectValue, IHashable) then
            // Use a customized HashCode() available under the IHashable interface.
            return cast(objectValue, IHashable):HashCode().
        else
            // Create a hash of this Object which should be its reference ID.
            // By definition, this should be unique for each object instance.
            return hash-code(objectValue).
    end method.

end class.
