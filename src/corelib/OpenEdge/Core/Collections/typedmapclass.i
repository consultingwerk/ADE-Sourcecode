&if 1=0 &then
/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : OpenEdge/Core/Collections/typedmapclass.i
    Purpose     : Include allowing us to workaround the lack of generics in ABL  
    Author(s)   : 
    Created     : Wed Dec 11 14:16:42 EST 2013
    Notes       : * Arguments:
                        Package     : The package name for this class (excludes class)
                        MapType     : The class name only for this type (excludes package).
                        KeyType     : The type (class or interface) to be used for the Map's key. Depending on
                                      containing class, can take advantage of USING.   
                        ValueType   : The type (class or interface) to be used for the Map's value. Depending on
                                      containing class, can take advantage of USING.
                        NoEndClass  : Passed if the containing class has additional methods to be added. 
                                      If specified, the containing class must
                        (opt) ParentCollectionType: The type of the parent collection. Defaults to the Map class.                                       
                  * Usage example: the below creates a collection 
                        {OpenEdge/Core/Collections/typedmapclass.i
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
    &scoped-define ParentCollectionType OpenEdge.Core.Collections.Map
&endif

&if defined(ImplementsType) gt 0 &then
    &scoped-define Interfaces implements {&ImplementsType}
&else
    &scoped-define ImplementsType OpenEdge.Core.Collections.IMap
&endif    

class {&FullType} serializable inherits {&ParentCollectionType} {&Interfaces}:
/*    constructor public {&MapType}(input poMap as {&FullType}):*/
    constructor public {&MapType}(input poMap as {&ImplementsType}):
        super(poMap).
    end constructor.
    
    constructor public {&MapType}():
        super().
    end constructor.
    
    /* Associates the specified value with the specified key in this map (optional operation).*/
    method public {&ValueType} Put(input poKey as {&KeyType}, input poValue as {&ValueType}):
        return cast(super:Put(poKey, poValue), {&ValueType}).
    end method.
    
    /* Removes the mapping for this key from this map if it is present (optional operation).*/
    method public {&ValueType} Remove(input poKey as {&KeyType}):
        return cast(super:Remove(poKey), {&ValueType}).
    end method.
    
    /* Returns true if this map contains a mapping for the specified key. */
    method public logical ContainsKey(input poKey as {&KeyType}):
        return super:ContainsKey(poKey).
    end method.
    
    /* Returns true if this map maps one or more keys to the specified value.*/
    method public logical ContainsValue(input poValue as {&ValueType}):
        return super:ContainsValue(poValue).
    end method.
       
        /* Returns the value to which this map maps the specified key.*/
    method public {&ValueType} Get(input poKey as {&KeyType}):
        return cast(super:Get(poKey), {&ValueType}).
    end method.
    
    &if defined(Interfaces) gt 0 &then
    method public void PutAll(input poMap as {&ImplementsType}):
        super:PutAll(poMap).
    end method.
    &endif
&if defined(NoEndClass) eq 0 &then     
end class. 
&endif 
