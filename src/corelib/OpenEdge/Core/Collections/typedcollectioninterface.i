&if 1=0 &then
/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : OpenEdge/Core/Collections/typedcollectioninterface.i
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
                        (opt) ParentCollectionType: The type of the parent collection. Defaults to the ICollection interface.                                          
                  * Usage example: the below creates a 
                        {OpenEdge/Core/Collections/typedcollectioninterface.i
                            &Package        = OpenEdge.InjectABL.Binding.Modules
                            &CollectionType = IModuleArray
                            &ValueType      = OpenEdge.ICnjectABL.Binding.Modules.IInjectionModule}
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
&endif

&if defined(ParentCollectionType) eq 0 &then
    &scoped-define ParentCollectionType OpenEdge.Core.Collections.ICollection
&endif

interface {&FullType} inherits {&ParentCollectionType}:
    /** Add an object to the collection.
    
        @param {&ValueType} The object to add to the collection
        @return logical True if the operation succeeded.     */    
    method public logical Add(input newObject as class {&ValueType}).
    
    /** Add a collection of objects to the collection.
    
        @param {&CollectionType} The collection to add to the collection
        @return logical True if the operation succeeded.     */    
    method public logical AddAll(input poCollection as class {&FullType}).
    
    /** Add an array of objects to the collection.
    
        @param {&CollectionType}[] The array to add to the collection
        @return logical True if the operation succeeded.     */    
    method public logical AddArray(input poArray as class {&ValueType} extent).

    /** Remove an object from the collection.
    
        @param {&ValueType} The object to remove from the collection
        @return logical True if the operation succeeded.     */    
    method public logical Remove(input oldObject as class {&ValueType}).
    
    /* Removes from this collection all the elements that are contained in the
       specified collection (optional operation). 
       
       @param  {&CollectionType} The collection of objects to remove.
       @return logical True if the operation succeeded. */
    method public logical RemoveAll(input poCollection as class {&FullType}).
    
    /* Retains only the elements in this list that are contained in the 
       specified collection (optional operation). return true if the object changed 
       
       @param  {&CollectionType} The collection of objects to retain.
       @return logical True if the operation succeeded. */
    method public logical RetainAll(input poCollection as class {&FullType}).
    
    /** Determine whether an object is in the collection.
        
        @param {&ValueType} The object to check in the collection
        @return logical True if the operation succeeded.     */    
    method public logical Contains(input checkObject as class {&ValueType}).
    
    /* Returns the elements in this collection as an ABL array.
       
       @return {&ValueType}[]  An ABL array of the objects in this collection */
    /* Returns the elements in this collection as an ABL array.
       
       @return {&CollectionType}[]  An ABL array of the objects in this collection */
    method public class {&ValueType} extent To{&ValueType}Array ():
    
&if defined(NoEndInterface) eq 0 &then     
end interface. 
&endif 
