/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : HeaderFilterNode
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue May 27 15:26:26 EDT 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.Filter.Header.IHeaderFilter.
using OpenEdge.Net.HTTP.Filter.Header.HeaderFilterNode.

{OpenEdge/Core/Collections/typedlistnode.i
    &Package    = OpenEdge.Net.HTTP.Filter.Header
    &NodeType   = HeaderFilterNode
    &ValueType  = IHeaderFilter
}
