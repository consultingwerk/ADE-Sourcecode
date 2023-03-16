&if 1=0 &then
/************************************************
Copyright (c) 2022 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : OpenEdge/Core/Assertion/assertnumeric.i
    Purpose     : Include for allowing us to dynamically create numeric checks
                  for values via IsZero/NotZero/IsPositive/IsNegative methods
    Description :
    Author(s)   : dugrau
    Created     : Mon May 2 13:20:42 EDT 2022
    Notes       : * Arguments:
                        DataType : The input ABL datatype to assert as 0/+/-
                  * Usage example: the below creates methods for character
                        { OpenEdge/Core/Assertion/assertnumeric.i &DataType = integer }
  ----------------------------------------------------------------------*/
&endif

&scoped-define CommentShort /~** Asserts that the {&DataType} is of expected value.~
 @param {&DataType} the value to check~
 @throws AssertionFailedError Error thrown if {&DataType} is not of expected value */

&scoped-define CommentLong  /~** Asserts that the {&DataType} is of expected value.~
 @param {&DataType} the value to check~
 @param character the identifying name for the AssertionFailedError~
 @throws AssertionFailedError Error thrown if {&DataType} is not of expected value */

    {&CommentShort}
    method public static void IsZero (input pArgument as {&DataType}):
        NotUnknown(pArgument, "argument":u).

        if pArgument ne 0 then
            undo, throw new AssertionFailedError(substitute('&1 must be zero':u, "argument":u), 0).
    end method. // IsZero

    {&CommentLong}
    method public static void IsZero (input pArgument as {&DataType}, input pcName as character):
        NotUnknown(pArgument, pcName).

        if pArgument ne 0 then
            undo, throw new AssertionFailedError(substitute('&1 must be zero':u, pcName), 0).
    end method. // IsZero

    {&CommentShort}
    method public static void NotZero (input pArgument as {&DataType}):
        // No check for NotUnknown as unknown is technically valid.
        if pArgument eq 0 then
            undo, throw new AssertionFailedError(substitute('&1 cannot be zero':u, "argument":u), 0).
    end method. // NotZero

    {&CommentLong}
    method public static void NotZero (input pArgument as {&DataType}, input pcName as character):
        // No check for NotUnknown as unknown is technically valid.
        if pArgument eq 0 then
            undo, throw new AssertionFailedError(substitute('&1 cannot be zero':u, pcName), 0).
    end method. // NotZero

    {&CommentShort}
    method public static void NonZero (input pArgument as {&DataType}):
        // No check for NotUnknown as unknown is technically valid.
        if pArgument eq 0 then
            undo, throw new AssertionFailedError(substitute('&1 cannot be zero':u, "argument":u), 0).
    end method. // NonZero

    {&CommentLong}
    method public static void NonZero (input pArgument as {&DataType}, input pcName as character):
        // No check for NotUnknown as unknown is technically valid.
        if pArgument eq 0 then
            undo, throw new AssertionFailedError(substitute('&1 cannot be zero':u, pcName), 0).
    end method. // NonZero

    {&CommentShort}
    method public static void NonZero (input pArgument as {&DataType} extent):
        define variable iLoop as int64 no-undo.
        define variable iMax  as int64 no-undo.

        // No check for NotUnknown as unknown is technically valid.
        AssertArray:HasDeterminateExtent(pArgument, "argument":u).
        iMax = extent(pArgument).
        do iLoop = 1 to iMax:
            NonZero(pArgument[iLoop], substitute('Extent &2 of &1':u, "argument":u, iLoop)).
        end.
    end method. // NonZero

    {&CommentLong}
    method public static void NonZero (input pArgument as {&DataType} extent, input pcName as character):
        define variable iLoop as int64 no-undo.
        define variable iMax  as int64 no-undo.

        // No check for NotUnknown as unknown is technically valid.
        AssertArray:HasDeterminateExtent(pArgument, pcName).
        iMax = extent(pArgument).
        do iLoop = 1 to iMax:
            NonZero(pArgument[iLoop], substitute('Extent &2 of &1':u, pcName, iLoop)).
        end.
    end method. // NonZero

    {&CommentShort}
    method public static void IsNegative (input pArgument as {&DataType}):
        NotUnknown(pArgument, "argument":u).

        if pArgument ge 0 then
            undo, throw new AssertionFailedError(substitute('&1 must be negative':u, "argument":u), 0).
    end method. // IsNegative

    {&CommentLong}
    method public static void IsNegative (input pArgument as {&DataType}, input pcName as character):
        NotUnknown(pArgument, pcName).

        if pArgument ge 0 then
            undo, throw new AssertionFailedError(substitute('&1 must be negative':u, pcName), 0).
    end method. // IsNegative

    {&CommentShort}
    method public static void IsPositive (input pArgument as {&DataType}):
        NotUnknown(pArgument, "argument":u).

        if pArgument le 0 then
            undo, throw new AssertionFailedError(substitute('&1 must be positive':u, "argument":u), 0).
    end method. // IsPositive

    {&CommentLong}
    method public static void IsPositive (input pArgument as {&DataType}, input pcName as character):
        NotUnknown(pArgument, pcName).

        if pArgument le 0 then
            undo, throw new AssertionFailedError(substitute('&1 must be positive':u, pcName), 0).
    end method. // IsPositive

    {&CommentShort}
    method public static void IsZeroOrNegative (input pArgument as {&DataType}):
        NotUnknown(pArgument, "argument":u).

        if pArgument gt 0 then
            undo, throw new AssertionFailedError(substitute('&1 must be zero or negative':u, "argument":u), 0).
    end method. // IsZeroOrNegative

    {&CommentLong}
    method public static void IsZeroOrNegative (input pArgument as {&DataType}, input pcName as character):
        NotUnknown(pArgument, pcName).

        if pArgument gt 0 then
            undo, throw new AssertionFailedError(substitute('&1 must be zero or negative':u, pcName), 0).
    end method. // IsZeroOrNegative

    {&CommentShort}
    method public static void IsZeroOrPositive (input pArgument as {&DataType}):
        NotUnknown(pArgument, "argument":u).

        if pArgument lt 0 then
            undo, throw new AssertionFailedError(substitute('&1 must be zero or positive':u, "argument":u), 0).
    end method. // IsZeroOrPositive

    {&CommentLong}
    method public static void IsZeroOrPositive (input pArgument as {&DataType}, input pcName as character):
        NotUnknown(pArgument, pcName).

        if pArgument lt 0 then
            undo, throw new AssertionFailedError(substitute('&1 must be zero or positive':u, pcName), 0).
    end method. // IsZeroOrPositive

    {&CommentShort}
    method public static void NotNullOrZero (input pArgument as {&DataType}):
        NotUnknown(pArgument, "argument":u).
        NotZero(pArgument, "argument":u).
    end method. // NotNullOrZero

    {&CommentLong}
    method public static void NotNullOrZero (input pArgument as {&DataType}, input pcName as character):
        NotUnknown(pArgument, pcName).
        NotZero(pArgument, pcName).
    end method. // NotNullOrZero
