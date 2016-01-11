/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : ListNode
    Purpose     : Singly-linked list node/element containing general Object data
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Feb 13 13:26:08 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Collections.ListNode.
using Progress.Lang.Object.

{OpenEdge/Core/Collections/typedlistnode.i
    &Package    = OpenEdge.Core.Collections
    &NodeType   = ListNode
    &ValueType  = Object
    &IsSerializable = true
}
