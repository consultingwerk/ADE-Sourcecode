/************************************************
Copyright (c) 2016, 2021-2022 by Progress Software Corporation. All rights reserved.
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
using OpenEdge.Core.Assert.
using OpenEdge.Core.TimeStamp.
using Progress.Collections.IComparable.

class OpenEdge.Core.DateTimeHolder implements IDateTimeHolder,
           // Compare to the interface so that other implementations of IDateTimeHolder can be sorted with this one
           IComparable<IDateTimeHolder>:
               
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

    /* Comparison method, used by SortedSet's default comparer
        
        - If the returned value is less than 0 (zero), then the current object sorts before the object passed in.
        - If the returned value equals 0 (zero) , then the current object occupies the same position in the sort order.
        - If the returned value is greater than 0(zero), then the current object sorts after the object passed in.
        - If either object's Value is the unknown value (?), then that sorts high/early/before
        
        @param IDateTimeHolder The object to compare to.
        @return integer  0 = same object
                        +1 = sorts after
                        -1 = sorts before   */
    method public integer CompareTo(input pOther as IDateTimeHolder):
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