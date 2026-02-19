/************************************************
Copyright (c) 2016, 2021, 2024 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : LongcharArrayHolder
    Purpose     : OO holder for an array of character or long values
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2016-08-01
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.ILongcharArrayHolder.
using OpenEdge.Core.Assert.

class OpenEdge.Core.LongcharArrayHolder implements ILongcharArrayHolder:
    /* The longchar value being held */
    define public property Value as longchar extent no-undo get. set.

    /* Constructor.

       @param integer The size of the array. Must be >0 */
    constructor public LongcharArrayHolder(input pSize as integer):
        super ().

        Assert:IsPositive(pSize, 'Array size').
        assign extent(this-object:Value) = pSize.
    end constructor.

    /* Default Constructor */
    constructor public LongcharArrayHolder ( ):
        super ().
    end constructor.

    /* Constructor

       @param longchar[] The Value array */
    constructor public LongcharArrayHolder (input pcValue as longchar extent):
        this-object().
        assign this-object:Value = pcValue.
    end constructor.

    /* Constructor

       @param character[] The Value array */
    constructor public LongcharArrayHolder (input pcValue as character extent):
        this-object().
        assign this-object:Value = pcValue.
    end constructor.

    /* Check equality between an instance of this class and another object.
       Equality can mean the same object reference ID or identical extents
       with the same values in the same sequence. Comparison must be made
       between another object instance which implements the same interface.

        @param Object The object to compare to this instance
        @return logical */
    method override public logical Equals (input PO as Progress.Lang.Object):
        var ILongcharArrayHolder oCompare.
        var integer iLoop, iMax.

        // If object references are equal, then it's the same object. Done!
        if super:Equals(PO) then return true.

        // Need to dive deeper to confirm equality, checking if this uses the same interface.
        if type-of(PO, ILongcharArrayHolder) then do:
            // Cast object for comparison to the expected interface.
            oCompare = cast(PO, ILongcharArrayHolder).

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