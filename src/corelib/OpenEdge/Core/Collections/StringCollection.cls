/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : StringCollection
    Purpose     : A collection of String and character/longchar objects
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Feb 20 12:55:57 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Collections.IStringCollection.
using OpenEdge.Core.String.

{OpenEdge/Core/Collections/typedcollectionclass.i
    &CollectionType = StringCollection
    &ValueType      = String
    &Package        = OpenEdge.Core.Collections
    &ImplementsType = IStringCollection
    &NoEndClass     = true
}
    /** Appends the specified element to list if not already present
    
        @param longchar The element to add to the collection
        @return logical True if the operation succeeded. */
    method public logical Add(input pcElement as longchar):
        return super:Add(new String(pcElement)).
    end method.

    /** [SLOW: O(n)] Adds an array of elements to the collection.  
       
        @param longchar[] An array of elements to add to the collection
        @return logical True if the operation succeeded. */
    method public logical AddArray(input pcElements as longchar extent):
        define variable oStringArray as String extent no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        assign iMax = extent(pcElements)
               extent(oStringArray) = iMax.
        do iLoop = 1 to iMax:
            oStringArray[iLoop] = new String(pcElements[iLoop]).
        end.
        
        return super:AddArray(oStringArray).        
    end method.
    
    /** Check whether the colleciton contains at least one object
        that matches the passed in object. 
        
        @param Object The object
        @return logical Returns true if the object is in the collection */
    method public logical Contains (input pcElement as longchar):
        return super:Contains(new String(pcElement)). 
    end method.    
    
   /** Removes the first occurrence in this list of the specified element
   
        @param Object The 
        @return logical True if the operation succeded. */
    method public logical Remove (input pcElement as longchar):
        return super:Remove(new String(pcElement)).
    end method.    

end class.
