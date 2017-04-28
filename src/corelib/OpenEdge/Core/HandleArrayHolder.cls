/************************************************
Copyright (c)  2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : HandleArrayHolder
    Purpose     : OO holder for an array of handle values 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-08-01
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using Ccs.Common.Support.IHandleArrayHolder.

class OpenEdge.Core.HandleArrayHolder implements IHandleArrayHolder: 

	define public property Value as handle extent no-undo get. set. 
		
	constructor public HandleArrayHolder (  ):
		super ().
	end constructor.
    
    constructor public HandleArrayHolder(input pValue as handle extent):
        this-object().
        assign this-object:Value = pValue.
    end constructor.

end class.