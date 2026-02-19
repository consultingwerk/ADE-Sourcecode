/************************************************
Copyright (c) 2016, 2018, 2021, 2024 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : ObjectArrayHolder
    Purpose     : OO holder for an array of objects
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2016-08-01
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.IObjectArrayHolder.

class OpenEdge.Core.ObjectArrayHolder implements IObjectArrayHolder:
    /* An array of objects to hold. */
    define public property Value as Progress.Lang.Object extent no-undo get. set.

    /* Constructor.

       @param integer The size of the array. Must be >0 */
    constructor public ObjectArrayHolder(input pSize as integer):
        super ().

        Assert:IsPositive(pSize, 'Array size').
        assign extent(this-object:Value) = pSize.
    end constructor.

    /* Default constructor */
    constructor public ObjectArrayHolder():
        super ().
    end constructor.

    /* Constructor

       @param Object[] An array of objects to 'hold' */
    constructor public ObjectArrayHolder(input pValue as Progress.Lang.Object extent):
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
        var IObjectArrayHolder oCompare.
        var integer iLoop, iMax.

        // If object references are equal, then it's the same object. Done!
        if super:Equals(PO) then return true.

        // Need to dive deeper to confirm equality, checking if this uses the same interface.
        if type-of(PO, IObjectArrayHolder) then do:
            // Cast object for comparison to the expected interface.
            oCompare = cast(PO, IObjectArrayHolder).

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

    method override public character ToString():
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable cValue as character no-undo.
        define variable cDelim as character no-undo.

        assign iMax = extent(this-object:Value)
               cDelim = '':u.
        do iLoop = 1 to iMax:
            assign cValue = substitute('&1&2&3':u,
                                cValue,
                                cDelim,
                                (if valid-object(this-object:Value[iLoop]) then this-object:Value[iLoop]:ToString() else ?) )
                   cDelim = ',':u.
        end.

        return cValue.
    end method.

end class.