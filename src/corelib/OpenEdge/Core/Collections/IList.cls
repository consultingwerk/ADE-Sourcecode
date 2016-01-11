/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : IList
    Purpose     : An ordered collection that gives control over where in the 
                  list each element is inserted. 
                  Allows elements to be accessed by their integer index in 
                  addition to by the element. 
    Description : 
    @author hdaniels
    Created     : Wed Jan 09 09:57:42 EST 2008
    Notes       : * All methods (and comments) except ToTable are an exact match to Java  
                    List interface. Size is implemented as property
                  * Based on the AutoEdge|TheFactory version                                 
  ----------------------------------------------------------------------*/
using OpenEdge.Core.Collections.ICollection.
using OpenEdge.Core.Collections.IIterator. 
using OpenEdge.Core.Collections.IListIterator. 
using OpenEdge.Core.Collections.IList. 
using Progress.Lang.Object.

interface OpenEdge.Core.Collections.IList inherits ICollection:  
   /** Inserts the specified element at the specified position in this list. 
       
       @param integer  The position at which to insert the object
       @param Object   The object to add
       @return Logical Returns true if the operation succeeded */
   method public logical Add(input piIndex as integer, input poElement as Object).   
   
   /* Inserts all of the elements in the specified collection into this list 
      at the specified position (optional operation).
      
      @param integer The iposition at which to add the collection
      @param ICollection the collection of objects to add
      @return logical True if the operation succeeded. */
   method public logical AddAll(input piIndex as integer,input poCollection as ICollection).
   
   /** Appends all the elements in the array this list, optionally
       at the specified position. */
   method public logical AddArray(input piIndex as integer, c as Object extent).
   
   /** Returns the element at the specified position in this list.
       
       @param integer The index of the object to return
       @return Object  The object returned. */
   method public Object Get(input piIndex as integer). 
 
   /** Returns the index in this list of the first occurrence of the specified 
       element, or 0 if this list does not contain this element.
       
       @param Object   The object to check.
       @return integer The index of the passed-in object */       
   method public integer IndexOf(input poElement as Object). 
   
   /* Returns a list iterator over the elements in this list in proper sequence. 
    
       @return IListIterator The ordered iterator */        
   method public IListIterator ListIterator().
   
   /** Returns a list iterator of the elements in this list (in proper sequence),
       starting at the specified position in this list.
       
       @param integer The starting position for the new iterator
       @return IListIterator The ordered iterator */
   method public IListIterator ListIterator(input piIndex as integer).
   
   /** Returns the index in this list of the last occurrence of the 
       specified element, or 0 if this list does not contain this element.
       
       @param Object The object to check
       @return integer The index of the last occurrence of the object */
   method public integer LastIndexOf(input poElement as Object).
  
   /** Removes the element at the specified position in this list
        
        @param integer The index to remove
        @return Object The object that was removed. */
   method public Object Remove (input piIndex as integer). 
   
   /** Replaces the element at the specified position in this list with the 
       specified element
       
       @param integer The position to add
       @param Object The object to add to the List
       @return Object The object that was replaced/removed from the List */
   method public Object    Set (input piIndex as integer, input poElement as Object).
   
   /** Returns a view of the portion of this list between the specified 
       fromIndex, inclusive, and toIndex, exclusive.
       
       @param integer The starting position for the new List (included)
       @param integer The end position for the new List (excluded)
       @return IList  The new List */
   method public IList SubList(input poFromPosition as integer, input poToPosition as integer).
   
end interface.
