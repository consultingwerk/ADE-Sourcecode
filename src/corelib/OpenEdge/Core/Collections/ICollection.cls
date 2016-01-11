/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : ICollection
    Purpose     : A collection represents a group of objects, known as its 
                  elements.
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Sun Dec 16 20:04:13 EST 2007
    Notes       : All methods (and comments) except ToTable and AddArray 
                  are an exact match to Java Collection interface. 
                  Size is implemented as property
                  * Based on the AutOEdge|TheFactory version                                                                     
  ----------------------------------------------------------------------*/

using OpenEdge.Core.Collections.ICollection.
using OpenEdge.Core.Collections.IIterable.
using Progress.Lang.Object.

interface OpenEdge.Core.Collections.ICollection inherits IIterable:
    /** Returns the number of elements in this list. */
    define public property Size as integer no-undo get.
  
    /** Appends the specified element to list if not already present
    
        @param Object The element to add to the collection
        @return logical True if the operation succeeded. */
    method public logical Add(input poElement as Object).
     
    /** Appends all of the elements in the specified collection
       
        @param ICollection A collection of elements to add to the collection
        @return logical True if the operation succeeded. */
    method public logical AddAll(input poCollection as ICollection).
    
    /** Adds an array of elements to the collection 
       
        @param Object[] An array of elements to add to the collection
        @return logical True if the operation succeeded. */    
    method public logical AddArray(input poElements as Object extent).
    
    /** Removes all of the elements from this list */
    method public void Clear().
    
    /** Check whether the colleciton contains at least one object
        that matches the passed in object. 
        
        @param Object The object
        @return logical Returns true if the object is in the collection */
    method public logical Contains (input poElement as Object).
    
    /** Returns true if this list contains all of the elements of the
        specified collection.
        
        @param ICollection The collection of obejcts to check
        @return logical True if all the elements match */
   method public logical ContainsAll(input poCollection as ICollection). 
   
   /** Indicates whether this collection has any elements.
       
       @return logical True if the collection is empty. */ 
   method public logical IsEmpty().
   
   /** Removes the first occurrence in this list of the specified element
   
        @param Object The 
        @return logical True if the operation succeded. */
    method public logical Remove (input poElement as Object).
    
    /** Removes from this list all the elements that are contained in the
        specified collection (optional operation).
        
        @param ICollection The collection to remove.
        @return logical True if the operation succeeded. */
    method public logical RemoveAll (input poCollection as ICollection).
    
    /** Retains only the elements in this list that are contained in the
        specified collection (optional operation).
        
        @param ICollection The collection to retain
        @return Logical True if the object changed  */
    method public logical RetainAll (input poCollection as ICollection).
    
    /** Returns the contents of the collection as temp-table. This is a shallow
        copy of the collection - basically a new set of references is created.
    
        @param output table-handle The collection as a temp-table */
    method public void ToTable (output table-handle tt).
    
    /** Returns the contents of the collection as an array of objects.
    
        @return Object[] The collection returnes as an object array */
    method public Object extent ToArray ().
    
end interface.
