/************************************************
Copyright (c) 2014-2017, 2022 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : AssertArray
    Purpose     : Assertions of truth for various arrays
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2017-02-01
    Notes       :
  ----------------------------------------------------------------------*/

using Progress.Lang.Object.
using OpenEdge.Core.AssertionFailedError.
using OpenEdge.Core.Assertion.AssertObject.
using OpenEdge.Core.Assert.

block-level on error undo, throw.

class OpenEdge.Core.Assertion.AssertArray:

    /**
     * Identical to the methods provided via the Assert class.
     * Creates the following methods per ABL datatype:
     * - 2 HasDeterminateExtent (w/ & w/o argument name)
     * - 2 IsIndeterminateArray (w/ & w/o argument name)
     */
    { OpenEdge/Core/Assertion/assertextent.i &DataType = character }
    { OpenEdge/Core/Assertion/assertextent.i &DataType = longchar }
    { OpenEdge/Core/Assertion/assertextent.i &DataType = integer }
    { OpenEdge/Core/Assertion/assertextent.i &DataType = int64 }
    { OpenEdge/Core/Assertion/assertextent.i &DataType = decimal }
    { OpenEdge/Core/Assertion/assertextent.i &DataType = date }
    { OpenEdge/Core/Assertion/assertextent.i &DataType = datetime }
    { OpenEdge/Core/Assertion/assertextent.i &DataType = datetime-tz }
    { OpenEdge/Core/Assertion/assertextent.i &DataType = handle }
    { OpenEdge/Core/Assertion/assertextent.i &DataType = logical }
    { OpenEdge/Core/Assertion/assertextent.i &DataType = memptr }
    { OpenEdge/Core/Assertion/assertextent.i &DataType = raw }
    { OpenEdge/Core/Assertion/assertextent.i &DataType = recid }
    { OpenEdge/Core/Assertion/assertextent.i &DataType = rowid }
    { OpenEdge/Core/Assertion/assertextent.i &DataType = Object }

    /**
     * Creates the following methods per ABL datatype:
     * - 1 Equals
     */
    { OpenEdge/Core/Assertion/assertequalityextent.i &DataType = character }
    { OpenEdge/Core/Assertion/assertequalityextent.i &DataType = longchar }
    { OpenEdge/Core/Assertion/assertequalityextent.i &DataType = integer }
    { OpenEdge/Core/Assertion/assertequalityextent.i &DataType = int64 }
    { OpenEdge/Core/Assertion/assertequalityextent.i &DataType = decimal }
    { OpenEdge/Core/Assertion/assertequalityextent.i &DataType = date }
    { OpenEdge/Core/Assertion/assertequalityextent.i &DataType = datetime }
    { OpenEdge/Core/Assertion/assertequalityextent.i &DataType = datetime-tz }
    { OpenEdge/Core/Assertion/assertequalityextent.i &DataType = handle }
    { OpenEdge/Core/Assertion/assertequalityextent.i &DataType = logical }
    { OpenEdge/Core/Assertion/assertequalityextent.i &DataType = memptr }
    { OpenEdge/Core/Assertion/assertequalityextent.i &DataType = raw }
    { OpenEdge/Core/Assertion/assertequalityextent.i &DataType = recid }
    { OpenEdge/Core/Assertion/assertequalityextent.i &DataType = rowid }
    { OpenEdge/Core/Assertion/assertequalityextent.i &DataType = Object }

end class.