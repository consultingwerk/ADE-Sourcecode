/************************************************
Copyright (c) 2016, 2019, 2022-2023 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : Integer
    Purpose     : Holds (wraps) an ABL primitive INTEGER/INT64 value.
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : Fri Jun 03 13:54:42 EDT 2016
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.IInt64Holder.
using OpenEdge.Core.Assert.
using Progress.Collections.IComparable.
using Progress.Collections.IHashable.

class OpenEdge.Core.Integer
implements IInt64Holder
           // Compare to the interface so that other implementations of IIntegerHolder can be sorted with this one
         , IComparable<IInt64Holder>
         , IHashable
:

    // Note that this holder's Value was not made immutable like Decimal for one reason or another,
    // and should not be changed as it could break usage in any code already utilizing the class.
    define public property Value as int64 no-undo get. set. 

    constructor public Integer (input piValue as int64):
        assign this-object:Value = piValue.
    end constructor.

    constructor public Integer (input piValue as integer):
        assign this-object:Value = piValue.
    end constructor.
    
    method override public logical Equals (input PO as Progress.Lang.Object):
         define variable ocInt as OpenEdge.Core.Integer no-undo.
         define variable valCompare as integer no-undo.

        if super:Equals(PO) then
            return true.

        if type-of(PO, OpenEdge.Core.Integer) then
        do:
            ocInt = cast(PO, OpenEdge.Core.Integer).
            return this-object:Value eq ocInt:Value.
        end.
        else if type-of(PO, IInt64Holder) then
        do:
            valCompare = dynamic-property(PO, 'Value').
            If this-object:Value eq valCompare then
                return true.
        end.

        return false.
    end method.

    method override public character ToString ():
        return string(this-object:Value).
    end method.
    
    /* Comparison method, used by SortedSet's default comparer
    
        - If the returned value is less than 0 (zero), then the current object sorts before the object passed in.
        - If the returned value equals 0 (zero) , then the current object occupies the same position in the sort order.
        - If the returned value is greater than 0(zero), then the current object sorts after the object passed in.
        - If either object's Value is the unknown value (?), then that sorts high/early/before
        
        @param IInt64Holder The object to compare to.
        @return integer  0 = same object
                        +1 = sorts after
                        -1 = sorts before   */
    method public integer CompareTo (input pOther as IInt64Holder):
        Assert:NotNull(pOther, 'CompareTo object').
        
        if this-object:Value eq pOther:Value then
            return 0.

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
