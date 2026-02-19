/* *************************************************************************************************************************
Copyright (c) 2016,2021,2024-2025 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : MemptrArrayHolder
    Purpose     : OO holder for an array of datetime values
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2016-08-01
    Notes       :
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using Ccs.Common.Support.IMemptrArrayHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Core.HashAlgorithmEnum.

class OpenEdge.Core.MemptrArrayHolder implements IMemptrArrayHolder:

    /* The value being held */
    define public property Value as memptr extent no-undo get. set.

    /* Constructor.

       @param integer The size of the array. Must be >0 */
    constructor public MemptrArrayHolder(input pSize as integer):
        super ().

        Assert:IsPositive(pSize, 'Array size').
        assign extent(this-object:Value) = pSize.
    end constructor.

    /* Default Constructor */
    constructor public MemptrArrayHolder (  ):
        super ().
    end constructor.

    /* Constructor

       @param memptr[] The Value array */
    constructor public MemptrArrayHolder(input pValue as memptr extent):
        this-object().
        assign this-object:Value = pValue.
    end constructor.

    /* Check equality between an instance of this class and another object.
       Equality can mean the same object reference ID or identical extents
       with the same values in the same sequence. Comparison must be made
       between another object instance which implements the same interface.

        @param Object The object to compare to this instance
        @return logical */
    method override public logical Equals (input PO as Progress.Lang.Object):
        var IMemptrArrayHolder oCompare.
        var integer iLoop, iMax.

        // If object references are equal, then it's the same object. Done!
        if super:Equals(PO) then return true.

        // Need to dive deeper to confirm equality, checking if this uses the same interface.
        if type-of(PO, IMemptrArrayHolder) then do:
            // Cast object for comparison to the expected interface.
            oCompare = cast(PO, IMemptrArrayHolder).

            // If not the same extent count then arrays are obviously different.
            if extent(this-object:Value) ne extent(oCompare:Value) then return false.

            // Compare equal # arrays based on values and sequence.
            iMax = extent(this-object:Value).
            do iLoop = 1 to iMax:
                // While this makes use of a hashing algorithm it is merely for checksum comparisons between object values.
                // This should trigger a leave of the loop at the first sign of a mis-matched value.
                {&_proparse_prolint-nowarn(digest)}
                if message-digest(string(HashAlgorithmEnum:SHA-256), this-object:Value[iLoop]) ne
                   message-digest(string(HashAlgorithmEnum:SHA-256), oCompare:Value[iLoop]) then return false.
            end.
            return true. // If still here, every element matched.
        end.

        return false. // Failsafe for any other case (eg. different class type).
    end method.

end class.