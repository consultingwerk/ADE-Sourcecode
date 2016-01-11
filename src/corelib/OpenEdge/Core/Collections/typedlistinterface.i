&if 1=0 &then
/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : OpenEdge/Core/Collections/typedlistinterface.i
    Purpose     : Include allowing us to workaround the lack of generics in ABL 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Jun 20 10:35:42 EDT 2012
    Notes       : * Arguments:
                        (opt) Package  : The package name for this interface(excludes interface)
                        CollectionType : The interface name only for this type (excludes package).
                        ValueType      : The type (class or interface) to be used for the Array's value. Depending on
                                          containing class, can take advantage of USING.
                        (opt) NoEndInterface : Passed if the containing interface has additional methods to be added. 
                                         If specified, the containing interface must add END INTERFACE
                        (opt) ParentCollectionType: The type of the parent collection. Defaults to the IList interface.                                          
                  * Usage example: the below creates a 
                        {OpenEdge/Core/Collections/typedcollectioninterface.i
                            &Package        = OpenEdge.InjectABL.Binding.Modules
                            &CollectionType = IModuleArray
                            &ValueType      = OpenEdge.InjectABL.Binding.Modules.IInjectionModule}
  ----------------------------------------------------------------------*/
&endif  
&if defined(Package) eq 0 &then
    &scoped-define Package  
    &scoped-define FullType {&CollectionType} 
&elseif defined(Package) gt 0 &then
    &if length(trim("{&Package}")) eq  0 &then
        &scoped-define FullType {&CollectionType}
    &else
        &if substring("{&Package}", length("{&Package}"), 1) eq '.' &then
            &scoped-define FullType {&Package}{&CollectionType}
        &else
            &scoped-define FullType {&Package}.{&CollectionType}
        &endif
    &endif                

&if defined(ParentCollectionType) eq 0 &then
    &scoped-define ParentCollectionType OpenEdge.Core.Collections.IList
&endif    

interface {&FullType} inherits {&ParentCollectionType}:
    /* Inserts the specified element at the specified position in this list 
       (optional operation).*/      
    method public logical Add(i as int, o as {&ValueType}).
       
    /* Appends the specified element to the end of this list 
       (optional operation). */
    method public logical Add(o as {&ValueType}).
       
    /* Appends all of the elements in the specified collection to the end 
      of this list, in the order that they are returned by the specified 
      collection's iterator (optional operation). */
    method public logical AddAll(c as {&FullType}).
       
    /* Inserts all of the elements in the specified collection into this list 
      at the specified position (optional operation).  */
    method public logical AddAll(i as int,c as {&FullType}).
       
    /** Appends all the elements in the array this list, optionally
       at the specified position. */
    method public logical AddArray(c as {&ValueType} extent).
    method public logical AddArray(i as int, c as {&ValueType} extent).
       
    /* Returns true if this list contains the specified element. */
    method public logical Contains (o as {&ValueType}). 
       
    /* Returns true if this list contains all of the elements of the 
      specified collection. */
    method public logical ContainsAll(c as {&FullType}). 
       
    /* Returns the element at the specified position in this list. */       
    method public {&ValueType} Get{&ValueType}(i as int). 
     
    /* Returns the index in this list of the first occurrence of the specified 
      element, or 0 if this list does not contain this element.  */       
    method public integer IndexOf(o as {&ValueType}). 
       
    /*  Returns the index in this list of the last occurrence of the 
       specified element, or 0 if this list does not contain this element. */
    method public integer LastIndexOf(o as {&ValueType}).
       
    /* Removes the element at the specified position in this list
     (optional operation). */
    method public {&ValueType} Remove{&ValueType}(i as integer). 
       
    /* Removes the first occurrence in this list of the specified element 
     (optional operation). */
    method public logical Remove (o as {&ValueType}). 
    
    /* Removes from this list all the elements that are contained in the 
      specified collection (optional operation). */
    method public logical RemoveAll (c as {&FullType}). 
      
    /* Retains only the elements in this list that are contained in the 
      specified collection (optional operation).*/
    method public logical RetainAll (c as {&FullType}). 
      
    /* Replaces the element at the specified position in this list with the 
      specified element (optional operation). */
    method public {&ValueType} Set (i as int, o as {&ValueType}).
    
    /* Returns a view of the portion of this list between the specified 
      fromIndex, inclusive, and toIndex, exclusive. */
    method public {&FullType} SubList{&ValueType}(fromIndex as int, toIndex as int).
    
    /* returns the contents of the list as an array */
    method public {&ValueType} extent To{&ValueType}Array (): 
    
&if defined(NoEndInterface) eq 0 &then     
end interface. 
&endif    