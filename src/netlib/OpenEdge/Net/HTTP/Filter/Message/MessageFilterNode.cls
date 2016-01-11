/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : MessageFilterNode
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue May 27 15:37:27 EDT 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.Filter.Message.IMessageFilter.

{OpenEdge/Core/Collections/typedlistnode.i
    &Package    = OpenEdge.Net.HTTP.Filter.Message
    &NodeType   = MessageFilterNode
    &ValueType  = IMessageFilter
}
