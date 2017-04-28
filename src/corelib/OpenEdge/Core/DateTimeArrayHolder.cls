/************************************************
Copyright (c)  2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : DateTimeArrayHolder
    Purpose     : OO holder for an array of datetime values 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-08-01
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using Ccs.Common.Support.IDateTimeArrayHolder.

class OpenEdge.Core.DateTimeArrayHolder implements IDateTimeArrayHolder: 

	define public property Value as datetime extent no-undo get. set. 
		
	constructor public DateTimeArrayHolder (  ):
		super ().
	end constructor.
    
    constructor public DateTimeArrayHolder(input pValue as datetime extent):
        this-object().
        assign this-object:Value = pValue.
    end constructor.

    method override public character ToString():
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable cValue as character no-undo.
        define variable cDelim as character no-undo.
        
        assign iMax = extent(this-object:Value)
               cDelim = '':u. 
        do iLoop = 1 to iMax:
            assign cValue = substitute('&1&2&3':u,
                                cValue,
                                cDelim,
                                this-object:Value[iLoop])
                   cDelim = ',':u.
        end.
        
        return cValue.
    end method.

end class.