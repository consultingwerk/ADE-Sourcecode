/************************************************
Copyright (c)  2016 by Progress Software Corporation. All rights reserved.
*************************************************/
 /*------------------------------------------------------------------------
    File        : DateTimeHolder
    Purpose     : OO holder for a primitive ABL DATE value. 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-07-29
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.TimeStamp.
using Ccs.Common.Support.IDateTimeHolder.

class OpenEdge.Core.DateTimeHolder 
        implements IDateTimeHolder:
             
    define variable moTimeStamp as TimeStamp no-undo.

    define public property Value as datetime no-undo
        get():
            return moTimeStamp:ToDateTime().
        end get.
    set(input pValue as datetime):
        assign moTimeStamp = new OpenEdge.Core.TimeStamp(pValue).
    end set.

	constructor public DateTimeHolder(  ):
		super ().
	end constructor.
		
	constructor public DateTimeHolder ( input pcTimeStamp as character ):
		super ().
		
		assign moTimeStamp = new OpenEdge.Core.TimeStamp(pcTimeStamp).
	end constructor.
		
	constructor public DateTimeHolder ( input ptDateTime as datetime ):
		super().
		
		assign this-object:Value = ptDateTime.
	end constructor.

end class.