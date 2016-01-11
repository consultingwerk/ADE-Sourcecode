/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : EntityFilterNode
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue May 27 15:45:38 EDT 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.Filter.Entity.EntityContentTypeFilter.
using OpenEdge.Net.HTTP.Filter.Entity.EntityFilterNode.
 
{OpenEdge/Core/Collections/typedlistnode.i
    &Package    = OpenEdge.Net.HTTP.Filter.Entity
    &NodeType   = EntityFilterNode
    &ValueType  = EntityContentTypeFilter
}
