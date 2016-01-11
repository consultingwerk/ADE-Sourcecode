&if 1=0 &then
/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : OpenEdge/Core/Collections/typedlinkedlist.i
    Purpose     : Include allowing us to workaround the lack of generics in ABL
                  Defines a single-linked-list (ie forward/one-way only)
    Notes       : * Arguments:
                        (opt) Package  : The package name for this interface(excludes interface)
                        ListType       : The type of this list
                        NodeType       : The type of the nodes that this list manages
                        (opt) NoEndClass: Passed if the containing interface has additional methods to be added. 
                                         If specified, the containing interface must add END CLASS
                  * Usage example: the below creates a geenric ListNode object 
                        {OpenEdge/Core/Collections/typedlinkedlist.i
                            &Package    = OpenEdge.Core.Collections
                            &ListType   = LinkedList
                            &NodeType   = ListNode }
  ----------------------------------------------------------------------*/
&endif  
&if defined(Package) eq 0 &then
    &scoped-define Package  
    &scoped-define FullType {&ListType} 
&elseif defined(Package) gt 0 &then
    &if length(trim("{&Package}")) eq  0 &then
        &scoped-define FullType {&ListType}
    &else
        &if substring("{&Package}", length("{&Package}"), 1) eq '.' &then 
            &scoped-define FullType {&Package}{&ListType} 
        &else 
            &scoped-define FullType {&Package}.{&ListType} 
        &endif
    &endif
&endif

&if defined(IsSerializable) &then
&if keyword-all('serializable') eq 'serializable' &then
    &scoped-define serializable serializable
&endif 
&endif

&if defined(ImplementsType) gt 0 &then
    &scoped-define Interfaces implements {&ImplementsType}
&endif

class {&FullType} {&serializable} {&Interfaces}:
    /** The first node in this list */
    define public property First as class {&NodeType} no-undo get. private set.
    
    constructor public {&ListType}():
    end constructor.

    /** Constructor
        @param  {&NodeType} The first node this list is managing */
    constructor public {&ListType}(input poNode as class {&NodeType}):
        OpenEdge.Core.Assert:NotNull(poNode, 'Node').
        
        InsertFirst(poNode).
    end constructor.
    
    /** Removes the first node, and replaces it with the next in the list.
        Equivalent to a stack pop. */
    method public void RemoveFirst():
        if valid-object(this-object:First) and
           valid-object(this-object:First:Next) then
            InsertFirst(this-object:First:Next).
        /* GC will clean up this-object:First if necessary */
    end method.
    
    /** Adds a Node in the first position. Will move the linked list along.
        The new node cannot have a valid Next property.
        
        @param {&NodeType} The node to insert. */            
    method public void InsertFirst(input poNode as class {&NodeType}):
        OpenEdge.Core.Assert:NotNull(poNode, 'Node').
        OpenEdge.Core.Assert:IsNull(poNode:Next, 'Node').
        
        if valid-object(this-object:First) then
            assign poNode:Next = this-object:First.
        
        this-object:First = poNode.
    end method.

    /** Adds a Node at the end of the list. 
        
        @param {&NodeType} The node to insert. */            
    method public void InsertLast(input poNode as class {&NodeType}):
        define variable oLastNode as class {&NodeType} no-undo.
        
        OpenEdge.Core.Assert:NotNull(poNode, 'Node').
        
        assign oLastNode = this-object:First.
        do while valid-object(oLastNode) and
                 valid-object(oLastNode:Next):
            assign oLastNode = oLastNode:Next. 
        end.
        
        /* if there are no nodes at all, set it to the first */
        if not valid-object(oLastNode) then
            assign this-object:First = poNode.
        else
            assign oLastNode:Next = poNode.
    end method.
    
    /** Adds a Node after another specified Node.
    
        @param {&NodeType} The node to insert the new node after.
        @param {&NodeType} The new node to insert. */            
    method static public void InsertAfter(input poNode as class {&NodeType}, 
                                          input poNewNode as class {&NodeType}):
        OpenEdge.Core.Assert:NotNull(poNode, 'Node').
        OpenEdge.Core.Assert:NotNull(poNewNode, 'New node').
        
        assign poNewNode:Next = poNode:Next
               poNode:Next = poNewNode.
    end method.
    
    /** Removes a Node after another specified Node. Ensures the list is still 
        linked. 
    
        @param {&NodeType} The node to insert the new node after. */
    method static public void RemoveAfter(input poNode as class {&NodeType}):
        OpenEdge.Core.Assert:NotNull(poNode, 'Node').
        
        if valid-object(poNode:Next) then
            assign poNode:Next = poNode:Next:Next.        
    end method.
    
&if defined(NoEndClass) eq 0 &then     
end class. 
&endif 

    