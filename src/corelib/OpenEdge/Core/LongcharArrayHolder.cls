/************************************************
Copyright (c)  2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : LongcharArrayHolder
    Purpose     : OO holder for an array of character or long values 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-08-01
    Notes       : 
  ----------------------------------------------------------------------*/
using Ccs.Common.Support.ILongcharArrayHolder.

block-level on error undo, throw.

class OpenEdge.Core.LongcharArrayHolder implements ILongcharArrayHolder: 
	define public property Value as longchar extent no-undo get. set. 
		
	constructor public LongcharArrayHolder ( ):
		super ().
	end constructor.
	
	constructor public LongcharArrayHolder (input pcValue as longchar extent):
        this-object().
        assign this-object:Value = pcValue.
    end constructor.
    
    constructor public LongcharArrayHolder (input pcValue as character extent):
        this-object().
        assign this-object:Value = pcValue.
    end constructor.    
    
end class.