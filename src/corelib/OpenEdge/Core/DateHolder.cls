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
using OpenEdge.Core.Assert.
using OpenEdge.Core.TimeStamp.
using Progress.Collections.IComparable.

class OpenEdge.Core.DateHolder implements IDateHolder,
           // Compare to the interface so that other implementations of IDateHolder can be sorted with this one
           IComparable<IDateHolder>:
    
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

    /* Comparison method, used by SortedSet's default comparer
        
        - If the returned value is less than 0 (zero), then the current object sorts before the object passed in.
        - If the returned value equals 0 (zero) , then the current object occupies the same position in the sort order.
        - If the returned value is greater than 0(zero), then the current object sorts after the object passed in.
        - If either object's Value is the unknown value (?), then that sorts high/early/before
        
        @param IDateHolder The object to compare to.
        @return integer  0 = same object
                        +1 = sorts after
                        -1 = sorts before   */
    method public integer CompareTo(input pOther as IDateHolder):
        Assert:NotNull(pOther, 'CompareTo object').
        
        if this-object:Value eq pOther:Value then
            return 0.
        else
        // unknown values sort first/lower
        if this-object:Value gt pOther:Value
        or pOther:Value eq ?
        then
            return +1.
        else
        if this-object:Value lt pOther:Value
        or this-object:Value eq ?
        then
            return -1.
        
        // this will raise an error in the Comparer; we should never get here though.
        return ?.
    end method.
    
end class.