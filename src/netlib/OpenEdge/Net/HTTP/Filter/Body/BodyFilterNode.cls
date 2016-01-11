/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : BodyFilterNode
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue May 27 15:37:27 EDT 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.Filter.Body.BodyFilterNode.
using OpenEdge.Net.HTTP.Filter.Body.MessageBodyFilter.

{OpenEdge/Core/Collections/typedlistnode.i
    &Package    = OpenEdge.Net.HTTP.Filter.Body
    &NodeType   = BodyFilterNode
    &ValueType  = MessageBodyFilter
}
