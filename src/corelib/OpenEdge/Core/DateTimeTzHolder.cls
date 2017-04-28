/************************************************
Copyright (c)  2016 by Progress Software Corporation. All rights reserved.
*************************************************/
 /*------------------------------------------------------------------------
    File        : DateTimeTzHolder
    Purpose     : OO holder for a primitive ABL DATE value. 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-07-29
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.TimeStamp.
using Ccs.Common.Support.IDateTimeTzHolder.

class OpenEdge.Core.DateTimeTzHolder 
        implements IDateTimeTzHolder:
             
    define variable moTimeStamp as TimeStamp no-undo.

    define public property Value as datetime-tz no-undo
        get():
            return moTimeStamp:ToDateTimeTz().
        end get.
    set(input pValue as datetime-tz):
        assign moTimeStamp = new OpenEdge.Core.TimeStamp(pValue).
    end set.

	constructor public DateTimeTzHolder(  ):
		super ().
	end constructor.
		
	constructor public DateTimeTzHolder ( input pcTimeStamp as character ):
		super ().
		
		assign moTimeStamp = new OpenEdge.Core.TimeStamp(pcTimeStamp).
	end constructor.
		
	constructor public DateTimeTzHolder ( input ptDateTime as datetime-tz ):
		super().
		
		assign this-object:Value = ptDateTime.
	end constructor.

end class.