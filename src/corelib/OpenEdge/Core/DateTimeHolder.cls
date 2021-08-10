/************************************************
Copyright (c) 2016, 2021 by Progress Software Corporation. All rights reserved.
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

using Ccs.Common.Support.IDateTimeHolder.
using OpenEdge.Core.TimeStamp.

class OpenEdge.Core.DateTimeHolder implements IDateTimeHolder:
    /* The holder of this datetime value */
    define variable moTimeStamp as TimeStamp no-undo.
    
    /* The datetime value */
    define public property Value as datetime no-undo
        get():
            return moTimeStamp:ToDateTime().
        end get.
    set(input pValue as datetime):
        assign moTimeStamp = new OpenEdge.Core.TimeStamp(pValue).
    end set.
    
    /* Default constructor */
    constructor public DateTimeHolder():
        define variable dt as datetime no-undo initial ?.
        assign moTimeStamp = new OpenEdge.Core.TimeStamp(dt).
    end constructor.
    
    /* Constructor.
       
       @param character Datetime value in ISO-DATE format */
    constructor public DateTimeHolder ( input pcTimeStamp as character ):
        assign moTimeStamp = new OpenEdge.Core.TimeStamp(pcTimeStamp).
    end constructor.
        
    /* Constructor.
       
       @param datetime Datetime value */
    constructor public DateTimeHolder ( input ptDateTime as datetime ):
        assign moTimeStamp = new OpenEdge.Core.TimeStamp(ptDateTime).
    end constructor.

end class.