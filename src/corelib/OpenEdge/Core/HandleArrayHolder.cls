/************************************************
Copyright (c) 2016, 2021, 2024 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : HandleArrayHolder
    Purpose     : OO holder for an array of handle values
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2016-08-01
    Notes       :
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using Ccs.Common.Support.IHandleArrayHolder.
using OpenEdge.Core.Assert.

class OpenEdge.Core.HandleArrayHolder implements IHandleArrayHolder:
    /* The value being held */
    define public property Value as handle extent no-undo get. set.

    /* Constructor.

       @param integer The size of the array. Must be >0 */
    constructor public HandleArrayHolder(input pSize as integer):
        super ().

        Assert:IsPositive(pSize, 'Array size').
        assign extent(this-object:Value) = pSize.
    end constructor.

    /* Default Constructor */
    constructor public HandleArrayHolder (  ):
        super ().
    end constructor.

    /* Constructor

       @param handle[] The Value array */
    constructor public HandleArrayHolder(input pValue as handle extent):
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
        var IHandleArrayHolder oCompare.
        var integer iLoop, iMax.

        // If object references are equal, then it's the same object. Done!
        if super:Equals(PO) then return true.

        // Need to dive deeper to confirm equality, checking if this uses the same interface.
        if type-of(PO, IHandleArrayHolder) then do:
            // Cast object for comparison to the expected interface.
            oCompare = cast(PO, IHandleArrayHolder).

            // If not the same extent count then arrays are obviously different.
            if extent(this-object:Value) ne extent(oCompare:Value) then return false.

            // Compare equal # arrays based on values and sequence.
            iMax = extent(this-object:Value).
            do iLoop = 1 to iMax:
                // Leave at the first sign of a mis-matched value.
                if this-object:Value[iLoop] ne oCompare:Value[iLoop] then return false.
            end.
            return true. // If still here, every element matched.
        end.

        return false. // Failsafe for any other case (eg. different class type).
    end method.

end class.