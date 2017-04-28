/************************************************
Copyright (c)  2016 by Progress Software Corporation. All rights reserved.
*************************************************/
 /*------------------------------------------------------------------------
    File        : DateHolder
    Purpose     : OO holder for a primitive ABL DATE value. 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-07-29
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.TimeStamp.
using Ccs.Common.Support.IDateHolder.

class OpenEdge.Core.DateHolder 
        implements IDateHolder:
             
    define variable moTimeStamp as TimeStamp no-undo.

    define public property Value as date no-undo
        get():
            return moTimeStamp:ToDate().
        end get.
    set(input pValue as date):
        assign moTimeStamp = new OpenEdge.Core.TimeStamp(pValue).
    end set.

	constructor public DateHolder(  ):
		super ().
	end constructor.
		
	constructor public DateHolder ( input pcTimeStamp as character ):
		super ().
		
		assign moTimeStamp = new OpenEdge.Core.TimeStamp(pcTimeStamp).
	end constructor.
		
	constructor public DateHolder ( input ptDate as date ):
		super().
		
		assign this-object:Value = ptDate.
	end constructor.

end class.