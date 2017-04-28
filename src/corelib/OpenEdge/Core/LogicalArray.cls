/************************************************
Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : LogicalArray
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Jun 08 21:05:28 EDT 2016
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using Ccs.Common.Support.ILogicalArrayHolder.

class OpenEdge.Core.LogicalArray implements ILogicalArrayHolder: 

	define public property Value as logical extent no-undo get. private set.	 

    constructor public LogicalArray(input plVal as logical extent):
        assign this-object:Value = plVal.
    end constructor.

end class.