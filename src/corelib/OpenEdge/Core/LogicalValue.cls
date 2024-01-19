/************************************************
Copyright (c) 2016, 2019, 2022-2023 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : LogicalValue
    Purpose     : Holds (wraps) an ABL primitive LOGICAL value.
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : Mon Jun 06 12:27:33 EDT 2016
    Notes       : * The wrapped value is immutable
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.ILogicalHolder.
using OpenEdge.Core.Assert.
using Progress.Collections.IComparable.
using Progress.Collections.IHashable.

class OpenEdge.Core.LogicalValue
implements ILogicalHolder
           // Compare to the interface so that other implementations of ILogicalHolder can be sorted with this one
         , IComparable<ILogicalHolder>
         , IHashable
:

    define public property Format as character no-undo get. set.

    define public property Value as logical  no-undo get.
        private set. // The wrapped value is immutable

    constructor public LogicalValue(input plVal as logical):
        assign this-object:Value = plVal
               this-object:Format = 'yes/no':u.
    end constructor.

    method override public character ToString ():
        return trim(string(this-object:Value, this-object:Format)).
    end method.

    method override public logical Equals (input PO as Progress.Lang.Object):
        define variable ocLV as OpenEdge.Core.LogicalValue no-undo.
        define variable valCompare as logical no-undo.

        if super:Equals(PO) then
            return true.
        if type-of(PO, OpenEdge.Core.LogicalValue)  then
        do:
            ocLV = cast(PO, OpenEdge.Core.LogicalValue).
            return this-object:Value eq ocLV:Value.
        end.
        else if type-of(PO, ILogicalHolder) then
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
    method public integer CompareTo (input pOther as ILogicalHolder):
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

    /* Hashing method for creating a proper index for use with Progress.Collections.HashMap

        @return integer Result of the hash-code method using this object's comparable value(s) */
    method public integer HashCode ( ):
        // In order to create a meaningful hash for an object instance,
        // we should follow suite with how the Equals() logic works.
        // By using the full class name plus the object's comparable value(s)
        // this should be consistent for any instance of this object type.
        return hash-code(this-object:GetClass():TypeName, this-object:Value).
    end method.

end class.

