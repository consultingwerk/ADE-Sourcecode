&if 1=0 &then
/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : OpenEdge/Core/Collections/typedcollectionclass.i
    Purpose     : Include allowing us to workaround the lack of generics in ABL
    Notes       : * Arguments:
                        (opt) Package  : The package name for this interface(excludes interface)
                        CollectionType : The interface name only for this type (excludes package).
                        ValueType      : The type (class or interface) to be used for the Array's value. Depending on
                                          containing class, can take advantage of USING.
                        (opt) NoEndClass: Passed if the containing interface has additional methods to be added. 
                                         If specified, the containing interface must add END CLASS
                        (opt) ParentCollectionType: The type of the parent collection. Defaults to the Collection class.                                            
                  * Usage example: the below creates a 
                        {OpenEdge/Core/Collections/typedcollectionclass.i
                            &Package        = OpenEdge.InjectABL.Binding.Modules
                            &CollectionType = ModuleArray
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
&endif

&if defined(ParentCollectionType) eq 0 &then
    &scoped-define ParentCollectionType OpenEdge.Core.Collections.Collection
&endif    

&if defined(ImplementsType) gt 0 &then
    &scoped-define Interfaces implements {&ImplementsType}
&else
    &scoped-define ImplementsType OpenEdge.Core.Collections.ICollection
&endif    

&if defined(IsSerializable) &then
&if keyword-all('serializable') eq 'serializable' &then
    &scoped-define serializable serializable
&endif 
&endif

class {&FullType} {&serializable} inherits {&ParentCollectionType} {&Interfaces}:
    constructor public {&CollectionType}():
        super().
    end constructor.
    
    constructor public {&CollectionType}(input poCollection as {&ImplementsType}):
        super(input poCollection).
    end constructor.

    /** Add an object to the collection.
    
        @param {&ValueType} The object to add to the collection
        @return logical True if the operation succeeded.     */    
    method public logical Add(input newObject as {&ValueType}):
        return super:Add(newObject).
    end method.
    
    /** Add an array of objects to the collection.
    
        @param {&CollectionType}[] The array to add to the collection
        @return logical True if the operation succeeded.     */    
    method public logical AddArray(input poArray as {&ValueType} extent):
        return super:AddArray(poArray).
    end method.

    /** Remove an object from the collection.
    
        @param {&ValueType} The object to remove from the collection
        @return logical True if the operation succeeded.     */    
    method public logical Remove(input oldObject as {&ValueType}):
        return super:Remove(oldObject).
    end method.
    
    &if defined(Interfaces) gt 0 &then
    /** Add a collection of objects to the collection.
    
        @param {&CollectionType} The collection to add to the collection
        @return logical True if the operation succeeded.     */    
    method public logical AddAll(input poCollection as {&ImplementsType}):
        return super:AddAll(poCollection).
    end method.
    
    /* Removes from this collection all the elements that are contained in the
       specified collection (optional operation). 
       
       @param  {&CollectionType} The collection of objects to remove.
       @return logical True if the operation succeeded. */
    method public logical RemoveAll(input poCollection as {&ImplementsType}):
        return super:RemoveAll(poCollection).
    end method.
    
    /* Retains only the elements in this list that are contained in the 
       specified collection (optional operation). return true if the object changed 
       
       @param  {&CollectionType} The collection of objects to retain.
       @return logical True if the operation succeeded. */
    method public logical RetainAll(input poCollection as {&ImplementsType}):
        return super:RetainAll(poCollection).
    end method.
    &endif
    
    /** Determine whether an object is in the collection.
        
        @param {&ValueType} The object to check in the collection
        @return logical True if the operation succeeded.     */    
    method public logical Contains(input checkObject as {&ValueType}):
        return super:Contains(checkObject).
    end method.
    
    /* Returns the elements in this collection as an ABL array.
       
       @return {&ValueType}[]  An ABL array of the objects in this collection */
    method public {&ValueType} extent To{&ValueType}Array ():
        return cast(super:ToArray(), {&ValueType}). 
    end method.
&if defined(NoEndClass) eq 0 &then     
end class. 
&endif 
