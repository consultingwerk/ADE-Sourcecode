/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : LinkedList
    Purpose     : A single linked list containing Object nodes.
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Feb 13 13:23:49 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Collections.ListNode.

{OpenEdge/Core/Collections/typedlinkedlist.i
    &Package    = OpenEdge.Core.Collections
    &ListType   = LinkedList
    &NodeType   = ListNode
    &IsSerializable = true
}
