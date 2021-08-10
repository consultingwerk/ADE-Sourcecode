/************************************************
Copyright (c) 2016, 2021 by Progress Software Corporation. All rights reserved.
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

using Ccs.Common.Support.IDateHolder.
using OpenEdge.Core.TimeStamp.

class OpenEdge.Core.DateHolder implements IDateHolder:
    
    /* The holder of this date */
    define private variable moTimeStamp as TimeStamp no-undo.

    /* Returns the DATE value held by this holder class */
    define public property Value as date no-undo
        get():
            return moTimeStamp:ToDate().
        end get.
    set(input pValue as date):
        assign moTimeStamp = new OpenEdge.Core.TimeStamp(pValue).
    end set.
    
    /* Default constructor */
    constructor public DateHolder(  ):
        define variable dt as date no-undo initial ?.
        assign moTimeStamp = new OpenEdge.Core.TimeStamp(dt).
    end constructor.
    
    /* Constructor
        
       @param character An ISO-DATE representation of a timestamp */
    constructor public DateHolder ( input pcTimeStamp as character ):
        assign moTimeStamp = new OpenEdge.Core.TimeStamp(pcTimeStamp).
    end constructor.
        
    /* Constructor
        
       @param date The date to hold */
    constructor public DateHolder ( input ptDate as date ):
        assign moTimeStamp = new OpenEdge.Core.TimeStamp(ptDate).
    end constructor.

end class.