&if 1=0 &then
/************************************************
Copyright (c) 2022 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : OpenEdge/Core/Assertion/assertnotunknownorempty.i
    Purpose     : Include for allowing us to dynamically create Not[Null|Unknown]OrEmpty methods
    Description :
    Author(s)   : dugrau
    Created     : Mon May 2 10:20:42 EDT 2022
    Notes       : * Arguments:
                        DataType : The input ABL datatype to assert as unknown or empty
                  * Usage example: the below creates methods for character
                        { OpenEdge/Core/Assertion/assertnotunknownorempty.i &DataType = character }

                  Primitive types behave in a similar manner, though objects and handles
                  require a slight change to how they evaluate their "unknown" values
  ----------------------------------------------------------------------*/
&endif

&scoped-define CommentShort /~** Asserts that the {&DataType} is not unknown or empty.~
 @param {&DataType} the value to check~
 @throws AssertionFailedError Error thrown if {&DataType} is unknown */

&scoped-define CommentLong  /~** Asserts that the {&DataType} is not unknown or empty.~
 @param {&DataType} the value to check~
 @param character the identifying name for the AssertionFailedError~
 @throws AssertionFailedError Error thrown if {&DataType} is unknown */

&scoped-define CommentShortArray /~** Asserts that the {&DataType} array is not unknown or empty.~
 @param {&DataType} the value to check~
 @throws AssertionFailedError Error thrown if {&DataType} is unknown */

&scoped-define CommentLongArray  /~** Asserts that the {&DataType} array is not unknown or empty.~
 @param {&DataType} the value to check~
 @param character the identifying name for the AssertionFailedError~
 @throws AssertionFailedError Error thrown if {&DataType} is unknown */

    {&CommentShort}
    method public static void NotNullOrEmpty (input pArgument as {&DataType}):
    &if "{&Datatype}" eq "Object" &then
        NotUnknown(input pArgument, input 'argument':u).
    &elseif "{&Datatype}" eq "ICollection" &then
        NotUnknown(input pArgument, input 'argument':u).

        if pArgument:Size eq 0 then
            undo, throw new AssertionFailedError(substitute('&1 cannot be empty: collection must have at least one entry':u, 'argument':u), 0).
    &elseif "{&Datatype}" eq "IMap" &then
        NotUnknown(input pArgument, input 'argument':u).

        if pArgument:Size eq 0 then
            undo, throw new AssertionFailedError(substitute('&1 cannot be empty: map must have at least one entry':u, 'argument':u), 0).
    &else
        NotUnknown(pArgument, "argument":u).
        NotEmpty(pArgument, "argument":u).
    &endif
    end method. // NotNullOrEmpty

    {&CommentLong}
    method public static void NotNullOrEmpty (input pArgument as {&DataType}, input pcName as char):
    &if "{&Datatype}" eq "Object" &then
        NotUnknown(input pArgument, input pcName).
    &elseif "{&Datatype}" eq "ICollection" &then
        NotUnknown(input pArgument, input pcName).

        if pArgument:Size eq 0 then
            undo, throw new AssertionFailedError(substitute('&1 cannot be empty: collection must have at least one entry':u, pcName), 0).
    &elseif "{&Datatype}" eq "IMap" &then
        NotUnknown(input pArgument, input pcName).

        if pArgument:Size eq 0 then
            undo, throw new AssertionFailedError(substitute('&1 cannot be empty: map must have at least one entry':u, pcName), 0).
    &else
        NotUnknown(pArgument, pcName).
        NotEmpty(pArgument, pcName).
    &endif
    end method. // NotNullOrEmpty

    {&CommentShort}
    method public static void NotUnknownOrEmpty (input pArgument as {&DataType}):
    &if "{&Datatype}" eq "Object" &then
        NotUnknown(input pArgument, input 'argument':u).
    &elseif "{&Datatype}" eq "ICollection" &then
        NotUnknown(input pArgument, input 'argument':u).

        if pArgument:Size eq 0 then
            undo, throw new AssertionFailedError(substitute('&1 cannot be empty: collection must have at least one entry':u, 'argument':u), 0).
    &elseif "{&Datatype}" eq "IMap" &then
        NotUnknown(input pArgument, input 'argument':u).

        if pArgument:Size eq 0 then
            undo, throw new AssertionFailedError(substitute('&1 cannot be empty: map must have at least one entry':u, 'argument':u), 0).
    &else
        NotUnknown(pArgument, "argument":u).
        NotEmpty(pArgument, "argument":u).
    &endif
    end method. // NotUnknownOrEmpty

    {&CommentLong}
    method public static void NotUnknownOrEmpty (input pArgument as {&DataType}, input pcName as char):
    &if "{&Datatype}" eq "Object" &then
        NotUnknown(input pArgument, input pcName).
    &elseif "{&Datatype}" eq "ICollection" &then
        NotUnknown(input pArgument, input 'argument':u).

        if pArgument:Size eq 0 then
            undo, throw new AssertionFailedError(substitute('&1 cannot be empty: collection must have at least one entry':u, pcName), 0).
    &elseif "{&Datatype}" eq "IMap" &then
        NotUnknown(input pArgument, input 'argument':u).

        if pArgument:Size eq 0 then
            undo, throw new AssertionFailedError(substitute('&1 cannot be empty: map must have at least one entry':u, pcName), 0).
    &else
        NotUnknown(pArgument, pcName).
        NotEmpty(pArgument, pcName).
    &endif
    end method. // NotUnknownOrEmpty

    {&CommentShortArray}
    method public static void NotNullOrEmpty (input pArgument as {&DataType} extent):
    &if "{&Datatype}" eq "Object" &then
        NotUnknown(pArgument, "argument":u).
    &elseif lookup("{&Datatype}", "ICollection,IMap") gt 0 &then
        undo, throw new AssertionFailedError(substitute('Method not supported for array of &1':u, "{&Datatype}"), 0).
    &else
        NotUnknown(pArgument, "argument":u).
        NotEmpty(pArgument, "argument":u).
    &endif
    end method. // NotNullOrEmpty

    {&CommentLongArray}
    method public static void NotNullOrEmpty (input pArgument as {&DataType} extent, input pcName as char):
    &if "{&Datatype}" eq "Object" &then
        NotUnknown(pArgument, "argument":u).
    &elseif lookup("{&Datatype}", "ICollection,IMap") gt 0 &then
        undo, throw new AssertionFailedError(substitute('Method not supported for array of &1':u, "{&Datatype}"), 0).
    &else
        NotUnknown(pArgument, pcName).
        NotEmpty(pArgument, pcName).
    &endif
    end method. // NotNullOrEmpty

&if lookup("{&Datatype}", "ICollection,IMap") eq 0 &then
    {&CommentShortArray}
    method public static void NotUnknownOrEmpty (input pArgument as {&DataType} extent):
    &if "{&Datatype}" eq "Object" &then
        NotUnknown(input pArgument, input 'argument':u).
    &else
        NotUnknown(pArgument, "argument":u).
        NotEmpty(pArgument, "argument":u).
    &endif
    end method. // NotUnknownOrEmpty

    {&CommentLongArray}
    method public static void NotUnknownOrEmpty (input pArgument as {&DataType} extent, input pcName as char):
    &if "{&Datatype}" eq "Object" &then
        NotUnknown(pArgument, "argument":u).
    &else
        NotUnknown(pArgument, pcName).
        NotEmpty(pArgument, pcName).
    &endif
    end method. // NotUnknownOrEmpty
&endif
