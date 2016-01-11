&if 1=0 &then
/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : OpenEdge/Core/Collections/typedmapinterface.i
    Purpose     : Include allowing us to workaround the lack of generics in ABL  
    Author(s)   : 
    Created     : Wed Dec 11 14:16:42 EST 2013
    Notes       : * Arguments:
                        Package        : The package name for this interface (excludes interface)
                        MapType        : The name for this interface (excludes package)
                        KeyType        : The type (class or interface) to be used for the Map's key   
                        ValueType      : The type (class or interface) to be used for the Map's value
                        NoEndInterface : Passed if the containing interface has additional methods to be added. 
                                         If specified, the containing interface must add END INTERFACE
                        (opt) ParentCollectionType: The type of the parent collection. Defaults to the IMap interface.                                          
                  * Usage example: the below creates a collection 
                        {OpenEdge/Core/Collections/typedmapinterface.i
                            &Package   = OpenEdge.InjectABL.Binding.Modules
                            &MapType   = IInjectionModuleCollection
                            &KeyType   = OpenEdge.Core.String
                            &ValueType = OpenEdge.InjectABL.Binding.Modules.IInjectionModule}
  ----------------------------------------------------------------------*/
&endif  
&if defined(Package) eq 0 &then
    &scoped-define Package  
    &scoped-define FullType {&MapType} 
&elseif defined(Package) gt 0 &then
    &if length(trim("{&Package}")) eq  0 &then
        &scoped-define FullType {&MapType}
    &else
        &if substring("{&Package}", length("{&Package}"), 1) eq '.' &then
            &scoped-define FullType {&Package}{&MapType}
        &else
            &scoped-define FullType {&Package}.{&MapType}
        &endif
    &endif                
&endif

&if defined(ParentCollectionType) eq 0 &then
    &scoped-define ParentCollectionType OpenEdge.Core.Collections.IMap
&endif

interface {&FullType} inherits {&ParentCollectionType}:
    /** Associates the specified value with the specified key in this map (optional operation).*/
    method public {&ValueType} Put(input poKey as {&KeyType}, input poValue as {&ValueType}).

    /** Removes the mapping for this key from this map if it is present (optional operation).*/
    method public {&ValueType} Remove(input poKey as {&KeyType}).
    
    /** Returns true if this map contains a mapping for the specified key. */    
    method public logical ContainsKey(input poKey as {&KeyType}).
    
    /** Returns true if this map maps one or more keys to the specified value.*/
    method public logical ContainsValue(input poValue as {&ValueType}).

    /** Returns the value to which this map maps the specified key.*/
    method public {&ValueType} Get(input poKey as {&KeyType}).
    
    /** Adds all data from the input map into this map */    
    method public void PutAll(input poMap as {&FullType}).
&if defined(NoEndInterface) eq 0 &then
end interface. 
&endif 
