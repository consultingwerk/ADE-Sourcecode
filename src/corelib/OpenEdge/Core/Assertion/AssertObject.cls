/************************************************
Copyright (c)  2014, 2016, 2020, 2022 by Progress Software Corporation. All rights reserved.
*************************************************/
 /*------------------------------------------------------------------------
    File        : AssertObject
    Purpose     : Assertions specific to Object(s)
    Syntax      :
    Description :
    Author(s)   : psajja
    Created     : Tue Dec 16 12:28:50 IST 2014
    Notes       :
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.AssertionFailedError.
using OpenEdge.Core.Collections.ICollection.
using OpenEdge.Core.Collections.IMap.
using OpenEdge.Core.DataTypeEnum.
using OpenEdge.Core.DataTypeHelper.
using Progress.Lang.Object.

class OpenEdge.Core.Assertion.AssertObject:

    /**
     * Identical to the methods provided via the Assert class.
     * Creates the following methods per ABL datatype:
     * - 2 IsNull (w/ & w/o argument name)
     * - 2 IsUnknown (w/ & w/o argument name)
     * - 2 IsNull for Arrays (w/ & w/o argument name)
     * - 2 IsUnknown for Arrays (w/ & w/o argument name)
     */
    { OpenEdge/Core/Assertion/assertisunknown.i &DataType = Object }

    /**
     * Identical to the methods provided via the Assert class.
     * Creates the following methods per ABL datatype:
     * - 2 NotNull (w/ & w/o argument name)
     * - 2 NotUnknown (w/ & w/o argument name)
     * - 2 NotNull for Arrays (w/ & w/o argument name)
     * - 2 NotUnknown for Arrays (w/ & w/o argument name)
     */
    { OpenEdge/Core/Assertion/assertnotunknown.i &DataType = Object }

    /**
     * Creates the following methods per ABL datatype:
     * - 2 NotNullOrEmpty (w/ & w/o argument name)
     * - 2 NotUnknowOrEmpty (w/ & w/o argument name)
     * Only for Object datatype:
     * - 2 NotNullOrEmpty for Arrays (w/ & w/o argument name)
     * - 2 NotUnknownOrEmpty for Arrays (w/ & w/o argument name)
     */
    { OpenEdge/Core/Assertion/assertnotunknownorempty.i &DataType = Object }
    { OpenEdge/Core/Assertion/assertnotunknownorempty.i &DataType = ICollection }
    { OpenEdge/Core/Assertion/assertnotunknownorempty.i &DataType = IMap }

    /**
     * Identical to the methods provided via the Assert class.
     * Creates the following methods per ABL datatype:
     * - 1 Equals
     * - 1 NotEqual
     */
    { OpenEdge/Core/Assertion/assertequality.i &DataType = Object }

    /**
     * Creates the following methods per ABL datatype:
     * - 2 HasDeterminateExtent (w/ & w/o argument name)
     * - 2 IsIndeterminateArray (w/ & w/o argument name)
     */
    { OpenEdge/Core/Assertion/assertextent.i &DataType = Object }

    /**
     * Creates common methods to assert class properties:
     * - IsInterface/NotInterface
     * - IsAbstract/NotAbstract
     * - IsFinal/NotFinal
     * - IsType/NotType
     * - IsSerializable/NotSerializable
     */
    { OpenEdge/Core/Assertion/assertclass.i }

end class.