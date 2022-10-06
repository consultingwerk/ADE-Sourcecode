/************************************************
Copyright (c) 2016, 2019, 2022 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : LogicalValue
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : Mon Jun 06 12:27:33 EDT 2016
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

USING Ccs.Common.Support.ILogicalHolder.
USING OpenEdge.Core.Assert.
USING Progress.Collections.IComparable.

class OpenEdge.Core.LogicalValue implements ILogicalHolder,
           // Compare to the interface so that other implementations of ILogicalHolder can be sorted with this one
           IComparable<ILogicalHolder>:

    define public property Format as character no-undo get. set.

    define public property Value as logical  no-undo get.
        private set.

    constructor public LogicalValue(input plVal as logical):
        assign this-object:Value = plVal
               this-object:Format = 'yes/no':u.
    end constructor.

    method override public character ToString():
        return trim(string(this-object:Value, this-object:Format)).
    end method.
    method override public logical Equals(INPUT PO AS Progress.Lang.Object):
         define variable ocLV as OpenEdge.Core.LogicalValue no-undo.
         define variable valCompare as logical no-undo.
         if super:Equals(PO) then
             return true.
         if type-of(PO, OpenEdge.Core.LogicalValue)  then
         do:
             ocLV = cast(PO, OpenEdge.Core.LogicalValue).
             return 
                    this-object:Value = ocLV:Value.
         end.
         else
         if type-of(PO, ILogicalHolder) then
         do:
           valCompare = dynamic-property(PO, 'Value').
           If this-object:Value eq valCompare then 
             return true.
         end.
         return false.
    end method.
    
        /* Comparison method, used by SortedSet's default comparer
        
        - If the returned value is less than 0 (zero), then the current object sorts before the object passed in.
        - If the returned value equals 0 (zero) , then the current object occupies the same position in the sort order.
        - If the returned value is greater than 0(zero), then the current object sorts after the object passed in.
        - If either object's Value is the unknown value (?), then that sorts high/early/before
        
        @param ILogicalHolder The object to compare to.
        @return integer  0 = same object
                        +1 = sorts after
                        -1 = sorts before   */
    method public integer CompareTo(input pOther as ILogicalHolder):
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

