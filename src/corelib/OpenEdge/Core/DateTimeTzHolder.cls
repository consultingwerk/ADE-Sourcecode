/************************************************
Copyright (c) 2016, 2021 by Progress Software Corporation. All rights reserved.
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

class OpenEdge.Core.DateTimeTzHolder implements IDateTimeTzHolder:
    /* The holder of this datetime-tz value */
    define variable moTimeStamp as TimeStamp no-undo.

    /* The datetime-tz value */
    define public property Value as datetime-tz no-undo
        get():
            return moTimeStamp:ToDateTimeTz().
        end get.
    set(input pValue as datetime-tz):
        assign moTimeStamp = new OpenEdge.Core.TimeStamp(pValue).
    end set.
    
    /* Default constructor */
    constructor public DateTimeTzHolder(  ):
        define variable dtz as datetime-tz no-undo initial ?.
        assign moTimeStamp = new OpenEdge.Core.TimeStamp(dtz).
    end constructor.
        
    /* Constructor.
       
       @param character Datetime-tz value in ISO-DATE format */
    constructor public DateTimeTzHolder ( input pcTimeStamp as character ):
        assign moTimeStamp = new OpenEdge.Core.TimeStamp(pcTimeStamp).
    end constructor.
    
    /* Constructor.
       
       @param datetime-tz Datetime-tz value */
    constructor public DateTimeTzHolder ( input ptDateTime as datetime-tz ):
        assign moTimeStamp = new OpenEdge.Core.TimeStamp(ptDateTime).
    end constructor.

end class.