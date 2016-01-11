/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : StatusCodeFilter
    Purpose     :   
    Author(s)   : pjudge
    Created     : Fri Feb 14 11:43:22 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.Filter.Status.StatusCodeFilter.
using OpenEdge.Net.HTTP.Filter.Status.StatusCodeFilterNode.

{OpenEdge/Core/Collections/typedlistnode.i
    &Package    = OpenEdge.Net.HTTP.Filter.Status
    &NodeType   = StatusCodeFilterNode
    &ValueType  = StatusCodeFilter
}
