/************************************************
Copyright (c) 2013-2022 by Progress Software Corporation
and/or one of its subsidiaries or affiliates. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : Assert
    Purpose     : General assertions of truth.
    Syntax      :
    Description :
    @author pjudge
    Created     : Wed Mar 03 10:08:57 EST 2010
    Notes       : * This version based on the AutoEdge|TheFactory version
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Assertion.AssertArray.
using OpenEdge.Core.Assertion.AssertObject.
using OpenEdge.Core.AssertionFailedError.
using OpenEdge.Core.Collections.ICollection.
using OpenEdge.Core.Collections.IMap.
using OpenEdge.Core.DataTypeEnum.
using OpenEdge.Core.DataTypeHelper.
using Progress.Lang.Object.

class OpenEdge.Core.Assert:

    /**
     * Creates the following methods per ABL datatype:
     * - 2 IsNull (w/ & w/o argument name)
     * - 2 IsUnknown (w/ & w/o argument name)
     * - 2 IsNull for Arrays (w/ & w/o argument name)
     * - 2 IsUnknown for Arrays (w/ & w/o argument name)
     */
    { OpenEdge/Core/Assertion/assertisunknown.i &DataType = character }
    { OpenEdge/Core/Assertion/assertisunknown.i &DataType = longchar }
    { OpenEdge/Core/Assertion/assertisunknown.i &DataType = integer }
    { OpenEdge/Core/Assertion/assertisunknown.i &DataType = int64 }
    { OpenEdge/Core/Assertion/assertisunknown.i &DataType = decimal }
    { OpenEdge/Core/Assertion/assertisunknown.i &DataType = date }
    { OpenEdge/Core/Assertion/assertisunknown.i &DataType = datetime }
    { OpenEdge/Core/Assertion/assertisunknown.i &DataType = datetime-tz }
    { OpenEdge/Core/Assertion/assertisunknown.i &DataType = handle }
    { OpenEdge/Core/Assertion/assertisunknown.i &DataType = logical }
    { OpenEdge/Core/Assertion/assertisunknown.i &DataType = raw }
    { OpenEdge/Core/Assertion/assertisunknown.i &DataType = Object }

    /**
     * Creates the following methods per ABL datatype:
     * - 2 NotNull (w/ & w/o argument name)
     * - 2 NotUnknown (w/ & w/o argument name)
     * - 2 NotNull for Arrays (w/ & w/o argument name)
     * - 2 NotUnknown for Arrays (w/ & w/o argument name)
     */
    { OpenEdge/Core/Assertion/assertnotunknown.i &DataType = character }
    { OpenEdge/Core/Assertion/assertnotunknown.i &DataType = longchar }
    { OpenEdge/Core/Assertion/assertnotunknown.i &DataType = integer }
    { OpenEdge/Core/Assertion/assertnotunknown.i &DataType = int64 }
    { OpenEdge/Core/Assertion/assertnotunknown.i &DataType = decimal }
    { OpenEdge/Core/Assertion/assertnotunknown.i &DataType = date }
    { OpenEdge/Core/Assertion/assertnotunknown.i &DataType = datetime }
    { OpenEdge/Core/Assertion/assertnotunknown.i &DataType = datetime-tz }
    { OpenEdge/Core/Assertion/assertnotunknown.i &DataType = handle }
    { OpenEdge/Core/Assertion/assertnotunknown.i &DataType = logical }
    { OpenEdge/Core/Assertion/assertnotunknown.i &DataType = raw }
    { OpenEdge/Core/Assertion/assertnotunknown.i &DataType = Object }

    /**
     * Creates the following methods per ABL datatype:
     * - 2 IsEmpty (w/ & w/o argument name)
     * - 2 NotEmpty (w/ & w/o argument name)
     * - 2 NotEmpty for Arrays (w/ & w/o argument name)
     */
    { OpenEdge/Core/Assertion/assertemptiness.i &DataType = character }
    { OpenEdge/Core/Assertion/assertemptiness.i &DataType = longchar }
    { OpenEdge/Core/Assertion/assertemptiness.i &DataType = handle }
    { OpenEdge/Core/Assertion/assertemptiness.i &DataType = memptr }

    /**
     * Creates the following methods per ABL datatype:
     * - 2 NotNullOrEmpty (w/ & w/o argument name)
     * - 2 NotUnknowOrEmpty (w/ & w/o argument name)
     * Only for Character/Longchar/Object datatypes:
     * - 2 NotNullOrEmpty for Arrays (w/ & w/o argument name)
     * - 2 NotUnknownOrEmpty for Arrays (w/ & w/o argument name)
     */
    { OpenEdge/Core/Assertion/assertnotunknownorempty.i &DataType = character }
    { OpenEdge/Core/Assertion/assertnotunknownorempty.i &DataType = longchar }
    { OpenEdge/Core/Assertion/assertnotunknownorempty.i &DataType = Object }
    { OpenEdge/Core/Assertion/assertnotunknownorempty.i &DataType = ICollection }
    { OpenEdge/Core/Assertion/assertnotunknownorempty.i &DataType = IMap }

    /**
     * Creates the following methods per ABL datatype:
     * - 1 Equals
     * - 1 NotEqual
     */
    { OpenEdge/Core/Assertion/assertequality.i &DataType = character }
    { OpenEdge/Core/Assertion/assertequality.i &DataType = longchar }
    { OpenEdge/Core/Assertion/assertequality.i &DataType = integer }
    { OpenEdge/Core/Assertion/assertequality.i &DataType = int64 }
    { OpenEdge/Core/Assertion/assertequality.i &DataType = decimal }
    { OpenEdge/Core/Assertion/assertequality.i &DataType = date }
    { OpenEdge/Core/Assertion/assertequality.i &DataType = datetime }
    { OpenEdge/Core/Assertion/assertequality.i &DataType = datetime-tz }
    { OpenEdge/Core/Assertion/assertequality.i &DataType = handle }
    { OpenEdge/Core/Assertion/assertequality.i &DataType = logical }
    { OpenEdge/Core/Assertion/assertequality.i &DataType = memptr }
    { OpenEdge/Core/Assertion/assertequality.i &DataType = raw }
    { OpenEdge/Core/Assertion/assertequality.i &DataType = recid }
    { OpenEdge/Core/Assertion/assertequality.i &DataType = rowid }
    { OpenEdge/Core/Assertion/assertequality.i &DataType = Object }

    /**
     * Creates the following methods per ABL datatype:
     * - 2 IsZero (w/ & w/o argument name)
     * - 2 NotZero (w/ & w/o argument name)
     * - 2 IsNegative (w/ & w/o argument name)
     * - 2 IsPositive (w/ & w/o argument name)
     * - 2 IsZeroOrNegative (w/ & w/o argument name)
     * - 2 IsZeroOrPositive (w/ & w/o argument name)
     * - 2 NotNullOrZero (w/ & w/o argument name)
     */
    { OpenEdge/Core/Assertion/assertnumeric.i &DataType = integer }
    { OpenEdge/Core/Assertion/assertnumeric.i &DataType = int64 }
    { OpenEdge/Core/Assertion/assertnumeric.i &DataType = decimal }

    /**
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
    { OpenEdge/Core/Assertion/assertextent.i &DataType = logical }
    { OpenEdge/Core/Assertion/assertextent.i &DataType = memptr }
    { OpenEdge/Core/Assertion/assertextent.i &DataType = handle }
    { OpenEdge/Core/Assertion/assertextent.i &DataType = raw }
    { OpenEdge/Core/Assertion/assertextent.i &DataType = recid }
    { OpenEdge/Core/Assertion/assertextent.i &DataType = rowid }
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

    method public static void IsAvailable (input pArgument as handle, input pcName as character):
        NotUnknown(pArgument, pcName).

        if lookup(pArgument:type, "buffer,buffer-field") eq 0 then
            undo, throw new AssertionFailedError(substitute('&1 is not a valid handle type':u, pcName)).

        if not pArgument:available then
            undo, throw new AssertionFailedError(substitute('record in buffer &1 is not available':u, pcName), 0).
    end method.

    method public static void IsAvailable (input pArgument as handle):
        NotUnknown(pArgument, 'argument':u).

        if lookup(pArgument:type, "buffer,buffer-field") eq 0 then
            undo, throw new AssertionFailedError(substitute('&1 is not a valid handle type':u, 'argument':u)).

        if not pArgument:available then
            undo, throw new AssertionFailedError(substitute('record in buffer &1 is not available':u, 'argument':u), 0).
    end method.

    method public static void NotAvailable (input pArgument as handle, input pcName as character):
        NotUnknown(pArgument, pcName).

        if lookup(pArgument:type, "buffer,buffer-field") eq 0 then
            undo, throw new AssertionFailedError(substitute('&1 is not a valid handle type':u, pcName)).

        if pArgument:available then
            undo, throw new AssertionFailedError(substitute('record in buffer &1 is available':u, pcName), 0).
    end method.

    method public static void NotAvailable (input pArgument as handle):
        NotUnknown(pArgument, "argument":u).

        if lookup(pArgument:type, "buffer,buffer-field") eq 0 then
            undo, throw new AssertionFailedError(substitute('&1 is not a valid handle type':u, 'argument':u)).

        if pArgument:available then
            undo, throw new AssertionFailedError(substitute('record in buffer &1 is available':u, "argument":u), 0).
    end method.

    method public static void IsInteger (input pArgument as character, input pcName as character):
        {&_proparse_ prolint-nowarn(varusage)}
        define variable iCheckVal as integer no-undo.

        iCheckVal = integer(pArgument) no-error.
        if error-status:error then
            undo, throw new AssertionFailedError(substitute('&1 is not an integer value':u, pcName), 0).
    end method.

    method public static void IsInteger (input pArgument as character):
        IsInteger(pArgument, "argument":u). // Call the longer method due to amount of code.
    end method.

    method public static void IsDecimal (input pArgument as character, input pcName as character):
        {&_proparse_ prolint-nowarn(varusage)}
        define variable iCheckVal as integer no-undo.

        iCheckVal = decimal(pArgument) no-error.
        if error-status:error then
            undo, throw new AssertionFailedError(substitute('&1 is not a decimal value':u, pcName), 0).
    end method.

    method public static void IsDecimal (input pArgument as character):
        IsDecimal(pArgument, "argument":u). // Call the longer method due to amount of code.
    end method.

    method public static void IsInt64 (input pArgument as character, input pcName as character):
        {&_proparse_ prolint-nowarn(varusage)}
        define variable iCheckVal as int64 no-undo.

        iCheckVal = int64(pArgument) no-error.
        if error-status:error then
            undo, throw new AssertionFailedError(substitute('&1 is not an int64 value':u, pcName), 0).
    end method.

    method public static void IsInt64 (input pArgument as character):
       IsInt64(pArgument, "argument":u). // Call the longer method due to amount of code.
    end method.

    method public static void IsTrue (input pArgument as logical, input pcName as character):
        /* deliberate not true */
        if not (pArgument eq true) then
            undo, throw new AssertionFailedError(substitute('&1 is not true':u, pcName), 0).
    end method.

    method public static void IsTrue (input a as logical):
        if not (a eq true) then
            return error new AssertionFailedError(substitute("Expected: TRUE but was: &1":u, a), 0).
    end method.

    method public static void IsFalse (input pArgument as logical, input pcName as character):
        /* deliberate not false */
        if not (pArgument eq false) then
            undo, throw new AssertionFailedError(substitute('&1 is not false':u, pcName), 0).
    end method.

    method public static void IsFalse (input a as logical):
        if not (a eq false) then
            return error new AssertionFailedError(substitute("Expected: FALSE but was: &1":u, a), 0).
    end method.

    method public static void NotTrue (input pArgument as logical, input pcName as character):
        if pArgument eq true then
            undo, throw new AssertionFailedError(substitute('&1 is true':u, pcName), 0).
    end method.

    method public static void NotTrue (input pArgument as logical):
        if pArgument eq true then
            undo, throw new AssertionFailedError(substitute('&1 is true':u, "argument":u), 0).
    end method.

    method public static void NotFalse (input pArgument as logical, input pcName as character):
        if pArgument eq false then
            undo, throw new AssertionFailedError(substitute('&1 is false':u, pcName), 0).
    end method.

    method public static void NotFalse (input pArgument as logical):
        if pArgument eq false then
            undo, throw new AssertionFailedError(substitute('&1 is false':u, "argument":u), 0).
    end method.

    /* Asserts that the input value can be converted to a logical value

       @param character A character expression to evaluate
       @param character The format mask for the logical value
       @param character The name of the argument
       @throws AssertionFailedError */
    method public static void IsLogical (input pcValue as character, input pcMask as character, input pcName as character):
        {&_proparse_ prolint-nowarn(varusage)}
        define variable lValue as logical no-undo.

        NotUnknownOrEmpty(pcMask, 'Format mask').

        assign lValue = logical(pcValue, pcMask) no-error.
        if error-status:error then
            undo, throw new AssertionFailedError(substitute('&1 does not evaluate to a logical value with mask &2':u, pcName, pcMask), 0).
    end method.

    /* Asserts that the input value can be converted to a logical value with the
       default/built-in format mask (see doc)

       @param character A character expression to evaluate
       @throws AssertionFailedError */
    method public static void IsLogical (input pcValue as character):
        IsLogical(pcValue, "argument":u).
    end method.

    /* Asserts that the input value can be converted to a logical value with the
       default/built-in format mask (see doc)

       @param character A character expression to evaluate
       @param character The name of the argument
       @throws AssertionFailedError */
    method public static void IsLogical (input pcValue as character, input pcName as character):
        {&_proparse_ prolint-nowarn(varusage)}
        define variable lValue as logical no-undo.

        assign lValue = logical(pcValue) no-error.
        if error-status:error then
            undo, throw new AssertionFailedError(substitute('&1 does not evaluate to a logical value':u, pcName), 0).
    end method.

    /** Raises an AssertionFailedError.

        @param mesg the message to be used for the AssertionFailedError
        @throws AssertionFailedError Error thrown */
    method public static void RaiseError(mesg as character):
        NotUnknown(mesg).
        return error new AssertionFailedError(mesg, 0).
    end method.

    /* Asserts that the input value is in the provided list

       @param character  The value to check
       @param longchar  A comma-separated list to check against
       @param character The name of the argument */
    method static public void IsIn (input pValue as character, input pList as longchar, input pName as character):
        IsIn(pValue, pList, ',':u, pName).
    end method.

    /* Asserts that the input value is in the provided list

       @param character  The value to check
       @param longchar  A delimited-separated list to check against
       @param character The delimiter character
       @param character The name of the argument */
    method static public void IsIn (input pValue as character,
                                    input pList  as longchar,
                                    input pDelim as character,
                                    input pName  as character):
        define variable idx as integer no-undo.

        NotEqual(pValue, pDelim).

        assign idx = lookup(pValue, pList, pDelim).
        if    idx eq 0      // value not in list
           or idx eq ?      // value or list are ?
        then do:
            /* Combine any character substitutions first, then longchar substitutions. */
            define variable subMessage as longchar no-undo.
            assign subMessage = substitute('&1 ("&2") is not in the list: &3':u, pName, pValue, '&1':u).
            undo, throw new AssertionFailedError(substitute(subMessage, pList), 0).
        end.
    end method.

    /* Asserts that the input value is NOT in the provided list

       @param character  The value to check
       @param longchar  A COMMA-separated list to check against
       @param character The name of the argument */
    method static public void NotIn (input pValue as character,
                                     input pList  as longchar,
                                     input pName  as character):
        NotIn(pValue, pList, ',':u, pName).
    end method.

    /* Asserts that the input value is NOT in the provided list

       @param character  The value to check
       @param longchar  A delimited-separated list to check against
       @param character The delimiter character
       @param character The name of the argument */
    method static public void NotIn (input pValue as character,
                                     input pList  as longchar,
                                     input pDelim as character,
                                     input pName  as character):
        // if the list is empty/null then nothing can be in it
        if    pList eq ?
           or pList eq '':u
        then
            return.

        NotEqual(pValue, pDelim).

        // covers positive values (is a valid value, not in the list) and ? (unknown value)
        if not lookup(pValue, pList, pDelim) eq 0 then do:
            /* Combine any character substitutions first, then longchar substitutions. */
            define variable subMessage as longchar no-undo.
            assign subMessage = substitute('&1 ("&2") is in the list: &3':u, pName, pValue, '&1':u).
            undo, throw new AssertionFailedError(substitute(subMessage, pList), 0).
        end.
    end method.

end class.
