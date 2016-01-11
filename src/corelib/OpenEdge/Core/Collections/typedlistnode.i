&if 1=0 &then
/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : OpenEdge/Core/Collections/typedlistnode.i
    Purpose     : Include allowing us to workaround the lack of generics in ABL
    Notes       : * Arguments:
                        (opt) Package  : The package name for this type(excludes class name)
                        NodeType       : The name of this class.
                        ValueType      : The type (class or interface) to be used for the 'Data' value. Depending on
                                         containing class, can take advantage of USING.
                        (opt) NoEndClass: Passed if the containing interface has additional methods to be added. 
                                         If specified, the containing interface must add END CLASS
                        (opt) IsSerializable: Is this a serializable type? true or false                                            
                  * Usage example: the below creates a geenric ListNode object 
                        {OpenEdge/Core/Collections/typedlistnode.i
                            &Package    = OpenEdge.Core.Collections
                            &NodeType   = ListNode
                            &ValueType  = Object    }
  ----------------------------------------------------------------------*/
&endif  
&if defined(Package) eq 0 &then
    &scoped-define Package  
    &scoped-define FullType {&NodeType} 
&elseif defined(Package) gt 0 &then
    &if length(trim("{&Package}")) eq  0 &then
        &scoped-define FullType {&NodeType}
    &else
        &if substring("{&Package}", length("{&Package}"), 1) eq '.' &then 
            &scoped-define FullType {&Package}{&NodeType} 
        &else 
            &scoped-define FullType {&Package}.{&NodeType} 
        &endif
    &endif
&endif

&if defined(IsSerializable) &then
    &if "{&IsSerializable}" eq "true" &then    
        &scoped-define Serializable serializable    
    &endif
&endif 

class {&FullType} {&Serializable}: 
    define public property Next as class {&NodeType} no-undo get. set.
    define public property Data as class {&ValueType} no-undo get. set.
    
    constructor public {&NodeType}(input poData as class {&ValueType}):
        this-object:Data = poData.
    end constructor.

&if defined(NoEndClass) eq 0 &then
end class. 
&endif 

