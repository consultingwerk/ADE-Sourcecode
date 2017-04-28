/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : MemptrArrayHolder
    Purpose     : OO holder for an array of datetime values 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-08-01
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using Ccs.Common.Support.IMemptrArrayHolder.

class OpenEdge.Core.MemptrArrayHolder implements IMemptrArrayHolder: 

	define public property Value as memptr extent no-undo get. set. 
		
	constructor public MemptrArrayHolder (  ):
		super ().
	end constructor.
    
    constructor public MemptrArrayHolder(input pValue as memptr extent):
        this-object().
        assign this-object:Value = pValue.
    end constructor.

end class.