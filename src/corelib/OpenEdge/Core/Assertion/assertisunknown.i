&if 1=0 &then
/************************************************
Copyright (c) 2022 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : OpenEdge/Core/Assertion/assertisunknown.i
    Purpose     : Include for allowing us to dynamically create Is[Null|Unknown] methods
    Description :
    Author(s)   : dugrau
    Created     : Thu Apr 29 13:01:42 EDT 2022
    Notes       : * Arguments:
                        DataType : The input ABL datatype to assert as unknown
                  * Usage example: the below creates methods for character
                        { OpenEdge/Core/Assertion/assertisunknown.i &DataType = character }

                  Primitive types behave in a similar manner, though objects and handles
                  require a slight change to how they evaluate their "unknown" values
  ----------------------------------------------------------------------*/
&endif

&scoped-define CommentShort /~** Asserts that the {&DataType} is unknown.~
 @param {&DataType} the value to check~
 @throws AssertionFailedError Error thrown if {&DataType} is not unknown */

&scoped-define CommentLong  /~** Asserts that the {&DataType} is unknown.~
 @param {&DataType} the value to check~
 @param character the identifying name for the AssertionFailedError~
 @throws AssertionFailedError Error thrown if {&DataType} is is unknown */

&scoped-define CommentShortArray /~** Asserts that the {&DataType} array is unknown.~
 @param {&DataType} the value to check~
 @throws AssertionFailedError Error thrown if {&DataType} is not unknown */

&scoped-define CommentLongArray  /~** Asserts that the {&DataType} array is unknown.~
 @param {&DataType} the value to check~
 @param character the identifying name for the AssertionFailedError~
 @throws AssertionFailedError Error thrown if {&DataType} is not unknown */

    {&CommentShort}
    method public static void IsNull (input pArgument as {&DataType}):
    &if "{&Datatype}" eq "Object" &then
        if valid-object(pArgument) then
            undo, throw new AssertionFailedError(substitute('&1 must be unknown':u, "argument":u), 0).
    &elseif "{&Datatype}" eq "handle" &then
        if valid-handle(pArgument) then
            undo, throw new AssertionFailedError(substitute('&1 must be unknown':u, "argument":u), 0).
    &elseif "{&Datatype}" eq "memptr" &then
        if string(pArgument) ne "?" then
            undo, throw new AssertionFailedError(substitute('&1 must be unknown':u, "argument":u), 0).
    &else
        if not (pArgument eq ?) then
            undo, throw new AssertionFailedError(substitute('&1 must be unknown':u, "argument":u), 0).
    &endif
    end method. // IsNull

    {&CommentLong}
    method public static void IsNull (input pArgument as {&DataType}, input pcName as character):
    &if "{&Datatype}" eq "Object" &then
        if valid-object(pArgument) then
            undo, throw new AssertionFailedError(substitute('&1 must be unknown':u, pcName), 0).
    &elseif "{&Datatype}" eq "handle" &then
        if valid-handle(pArgument) then
            undo, throw new AssertionFailedError(substitute('&1 must be unknown':u, pcName), 0).
    &elseif "{&Datatype}" eq "memptr" &then
        if string(pArgument) ne "?" then
            undo, throw new AssertionFailedError(substitute('&1 must be unknown':u, pcName), 0).
    &else
        if not (pArgument eq ?) then
            undo, throw new AssertionFailedError(substitute('&1 must be unknown':u, pcName), 0).
    &endif
    end method. // IsNull

    {&CommentShort}
    method public static void IsUnknown (input pArgument as {&DataType}):
    &if "{&Datatype}" eq "Object" &then
        if valid-object(pArgument) then
            undo, throw new AssertionFailedError(substitute('&1 must be unknown':u, "argument":u), 0).
    &elseif "{&Datatype}" eq "handle" &then
        if valid-handle(pArgument) then
            undo, throw new AssertionFailedError(substitute('&1 must be unknown':u, "argument":u), 0).
    &elseif "{&Datatype}" eq "memptr" &then
        if string(pArgument) ne "?" then
            undo, throw new AssertionFailedError(substitute('&1 must be unknown':u, "argument":u), 0).
    &else
        if not (pArgument eq ?) then
            undo, throw new AssertionFailedError(substitute('&1 must be unknown':u, "argument":u), 0).
    &endif
    end method. // IsUnknown

    {&CommentLong}
    method public static void IsUnknown (input pArgument as {&DataType}, input pcName as character):
    &if "{&Datatype}" eq "Object" &then
        if valid-object(pArgument) then
            undo, throw new AssertionFailedError(substitute('&1 must be unknown':u, pcName), 0).
    &elseif "{&Datatype}" eq "handle" &then
        if valid-handle(pArgument) then
            undo, throw new AssertionFailedError(substitute('&1 must be unknown':u, pcName), 0).
    &elseif "{&Datatype}" eq "memptr" &then
        if string(pArgument) ne "?" then
            undo, throw new AssertionFailedError(substitute('&1 must be unknown':u, pcName), 0).
    &else
        if not (pArgument eq ?) then
            undo, throw new AssertionFailedError(substitute('&1 must be unknown':u, pcName), 0).
    &endif
    end method. // IsUnknown

    {&CommentShortArray}
    method public static void IsNull (input pArgument as {&DataType} extent):
        if extent(pArgument) ne ? then // Same as IsIndeterminateArray but with customized error message.
            undo, throw new AssertionFailedError(substitute('&1 must be unknown':u, "argument":u), 0).
    end method. // IsNull

    {&CommentLongArray}
    method public static void IsNull (input pArgument as {&DataType} extent, input pcName as character):
        if extent(pArgument) ne ? then // Same as IsIndeterminateArray but with customized error message.
            undo, throw new AssertionFailedError(substitute('&1 must be unknown':u, pcName), 0).
    end method. // IsNull

    {&CommentShortArray}
    method public static void IsUnknown (input pArgument as {&DataType} extent):
        if extent(pArgument) ne ? then // Same as IsIndeterminateArray but with customized error message.
            undo, throw new AssertionFailedError(substitute('&1 must be unknown':u, "argument":u), 0).
    end method. // IsUnknown

    {&CommentLongArray}
    method public static void IsUnknown (input pArgument as {&DataType} extent, input pcName as character):
        if extent(pArgument) ne ? then // Same as IsIndeterminateArray but with customized error message.
            undo, throw new AssertionFailedError(substitute('&1 must be unknown':u, pcName), 0).
    end method. // IsUnknown
