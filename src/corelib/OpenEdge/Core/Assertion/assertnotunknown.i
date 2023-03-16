&if 1=0 &then
/************************************************
Copyright (c) 2022 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : OpenEdge/Core/Assertion/assertnotunknown.i
    Purpose     : Include for allowing us to dynamically create Not[Null|Unknown] methods
    Description :
    Author(s)   : dugrau
    Created     : Thu Apr 28 16:40:42 EDT 2022
    Notes       : * Arguments:
                        DataType : The input ABL datatype to assert as unknown
                  * Usage example: the below creates methods for character
                        { OpenEdge/Core/Assertion/assertnotunknown.i &DataType = character }

                  Primitive types behave in a similar manner, though objects and handles
                  require a slight change to how they evaluate their "unknown" values
  ----------------------------------------------------------------------*/
&endif

&scoped-define CommentShort /~** Asserts that the {&DataType} is not unknown.~
 @param {&DataType} the value to check~
 @throws AssertionFailedError Error thrown if {&DataType} is unknown */

&scoped-define CommentLong  /~** Asserts that the {&DataType} is not unknown.~
 @param {&DataType} the value to check~
 @param character the identifying name for the AssertionFailedError~
 @throws AssertionFailedError Error thrown if {&DataType} is unknown */

&scoped-define CommentShortArray /~** Asserts that the {&DataType} array is not unknown.~
 @param {&DataType} the value to check~
 @throws AssertionFailedError Error thrown if {&DataType} is unknown */

&scoped-define CommentLongArray  /~** Asserts that the {&DataType} array is not unknown.~
 @param {&DataType} the value to check~
 @param character the identifying name for the AssertionFailedError~
 @throws AssertionFailedError Error thrown if {&DataType} is unknown */

    {&CommentShort}
    method public static void NotNull (input pArgument as {&DataType}):
    &if "{&Datatype}" eq "Object" &then
        if not valid-object(pArgument) then
            undo, throw new AssertionFailedError(substitute('&1 cannot be unknown':u, "argument":u), 0).
    &elseif "{&Datatype}" eq "handle" &then
        if not valid-handle(pArgument) then
            undo, throw new AssertionFailedError(substitute('&1 cannot be unknown':u, "argument":u), 0).
    &elseif "{&Datatype}" eq "memptr" &then
        if string(pArgument) eq "?" then
            undo, throw new AssertionFailedError(substitute('&1 cannot be unknown':u, "argument":u), 0).
    &else
        if pArgument eq ? then
            undo, throw new AssertionFailedError(substitute('&1 cannot be unknown':u, "argument":u), 0).
    &endif
    end method. // NotNull

    {&CommentLong}
    method public static void NotNull (input pArgument as {&DataType}, input pcName as character):
    &if "{&Datatype}" eq "Object" &then
        if not valid-object(pArgument) then
            undo, throw new AssertionFailedError(substitute('&1 cannot be unknown':u, pcName), 0).
    &elseif "{&Datatype}" eq "handle" &then
        if not valid-handle(pArgument) then
            undo, throw new AssertionFailedError(substitute('&1 cannot be unknown':u, pcName), 0).
    &elseif "{&Datatype}" eq "memptr" &then
        if string(pArgument) eq "?" then
            undo, throw new AssertionFailedError(substitute('&1 cannot be unknown':u, pcName), 0).
    &else
        if pArgument eq ? then
            undo, throw new AssertionFailedError(substitute('&1 cannot be unknown':u, pcName), 0).
    &endif
    end method. // NotNull

    {&CommentShort}
    method public static void NotUnknown (input pArgument as {&DataType}):
    &if "{&Datatype}" eq "Object" &then
        if not valid-object(pArgument) then
            undo, throw new AssertionFailedError(substitute('&1 cannot be unknown':u, "argument":u), 0).
    &elseif "{&Datatype}" eq "handle" &then
        if not valid-handle(pArgument) then
            undo, throw new AssertionFailedError(substitute('&1 cannot be unknown':u, "argument":u), 0).
    &elseif "{&Datatype}" eq "memptr" &then
        if string(pArgument) eq "?" then
            undo, throw new AssertionFailedError(substitute('&1 cannot be unknown':u, "argument":u), 0).
    &else
        if pArgument eq ? then
            undo, throw new AssertionFailedError(substitute('&1 cannot be unknown':u, "argument":u), 0).
    &endif
    end method. // NotUnknown

    {&CommentLong}
    method public static void NotUnknown (input pArgument as {&DataType}, input pcName as character):
    &if "{&Datatype}" eq "Object" &then
        if not valid-object(pArgument) then
            undo, throw new AssertionFailedError(substitute('&1 cannot be unknown':u, pcName), 0).
    &elseif "{&Datatype}" eq "handle" &then
        if not valid-handle(pArgument) then
            undo, throw new AssertionFailedError(substitute('&1 cannot be unknown':u, pcName), 0).
    &elseif "{&Datatype}" eq "memptr" &then
        if string(pArgument) eq "?" then
            undo, throw new AssertionFailedError(substitute('&1 cannot be unknown':u, pcName), 0).
    &else
        if pArgument eq ? then
            undo, throw new AssertionFailedError(substitute('&1 cannot be unknown':u, pcName), 0).
    &endif
    end method. // NotUnknown

    {&CommentShortArray}
    method public static void NotNull (input pArgument as {&DataType} extent):
        if extent(pArgument) eq ? then // Same as HasDeterminateExtent but with customized error message.
            undo, throw new AssertionFailedError(substitute('&1 cannot be unknown':u, "argument":u), 0).
    end method. // NotNull

    {&CommentLongArray}
    method public static void NotNull (input pArgument as {&DataType} extent, input pcName as character):
        if extent(pArgument) eq ? then // Same as HasDeterminateExtent but with customized error message.
            undo, throw new AssertionFailedError(substitute('&1 cannot be unknown':u, pcName), 0).
    end method. // NotNull

    {&CommentShortArray}
    method public static void NotUnknown (input pArgument as {&DataType} extent):
        if extent(pArgument) eq ? then // Same as HasDeterminateExtent but with customized error message.
            undo, throw new AssertionFailedError(substitute('&1 cannot be unknown':u, "argument":u), 0).
    end method. // NotUnknown

    {&CommentLongArray}
    method public static void NotUnknown (input pArgument as {&DataType} extent, input pcName as character):
        if extent(pArgument) eq ? then // Same as HasDeterminateExtent but with customized error message.
            undo, throw new AssertionFailedError(substitute('&1 cannot be unknown':u, pcName), 0).
    end method. // NotUnknown
