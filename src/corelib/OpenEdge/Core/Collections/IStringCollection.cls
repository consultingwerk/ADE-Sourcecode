/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : IStringCollection
    Purpose     : Interface defining a typed String Collection 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Dec 18 13:58:44 EST 2013
    Notes       : * Also contains ICollection methods using ABL primitives instead 
                    of OpenEdge.Core.String  
  ----------------------------------------------------------------------*/

using OpenEdge.Core.Collections.IStringCollection.
using OpenEdge.Core.String.

{OpenEdge/Core/Collections/typedcollectioninterface.i 
    &Package        = OpenEdge.Core.Collections
    &CollectionType = IStringCollection
    &ValueType      = String 
    
    &NoEndInterface = true
}

    /** Appends the specified element to list if not already present
    
        @param longchar The element to add to the collection
        @return logical True if the operation succeeded. */
    method public logical Add(input pcElement as longchar).

    /** Adds an array of elements to the collection 
       
        @param longchar[] An array of elements to add to the collection
        @return logical True if the operation succeeded. */
    method public logical AddArray(input pcElements as longchar extent).
    
    /** Check whether the colleciton contains at least one object
        that matches the passed in object. 
        
        @param Object The object
        @return logical Returns true if the object is in the collection */
    method public logical Contains (input pcElement as longchar).    
    
   /** Removes the first occurrence in this list of the specified element
   
        @param Object The 
        @return logical True if the operation succeded. */
    method public logical Remove (input pcElement as longchar).    

end interface.            
