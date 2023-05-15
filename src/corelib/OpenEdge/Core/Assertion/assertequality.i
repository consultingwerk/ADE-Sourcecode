&if 1=0 &then
/************************************************
Copyright (c) 2022,2023 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : OpenEdge/Core/Assertion/assertequality.i
    Purpose     : Include for allowing us to dynamically create Equals/NotEqual methods
    Description :
    Author(s)   : dugrau
    Created     : Mon May 2 10:20:42 EDT 2022
    Notes       : * Arguments:
                        DataType : The input ABL datatype to assert equality
                  * Usage example: the below creates methods for character
                        { OpenEdge/Core/Assertion/assertequality.i &DataType = character }

                  Primitive types behave in a similar manner, though objects require
                  a more complex evaluation and performed in the AssertObject class
  ----------------------------------------------------------------------*/
&endif

&scoped-define CommentEquals /~** Asserts that value 'a' equals 'b'.~
 @param {&DataType} the known value~
 @param {&DataType} the comparison value~
 @throws AssertionFailedError Error thrown if values differ */

&scoped-define CommentNotEqual  /~** Asserts that value 'a' differs from 'b'.~
 @param {&DataType} the known value~
 @param {&DataType} the comparison value~
 @throws AssertionFailedError Error thrown if values are equal */

&if "{&Datatype}" eq "longchar" &then
    &scoped-define MsgType longchar
&else
    &scoped-define MsgType character
&endif

    {&CommentEquals}
&if "{&Datatype}" eq "recid" &then
    {&_proparse_ prolint-nowarn(recidkeyword)}
&endif
    method public static void Equals (input a as {&DataType}, input b as {&DataType}):
        define variable subMessage as {&MsgType} no-undo initial "Expected: &1 but was: &2":u.

    &if "{&Datatype}" eq "Object" &then
        NotUnknown(a). // Object must be known.

        if not a:Equals(b) then
            return error new AssertionFailedError(substitute(subMessage, string(a), string(b)), 0).
    &elseif "{&Datatype}" eq "memptr" &then
        // First check for identical size of memptrs.
        if get-size(a) ne get-size(b) then
            return error new AssertionFailedError(substitute(subMessage, get-size(a), get-size(b)), 0).

        // If sizes are equals then compare contents by use of hashing
        if message-digest("SHA-256", a) ne message-digest("SHA-256", b) then
            return error new AssertionFailedError("Hashes of memptr values are not equal":u, 0).
    &elseif "{&Datatype}" eq "raw" &then
        // Use a simpler error message as raw values cannot be output directly.
        if not (a eq b) then
            return error new AssertionFailedError("Raw values are not equal":u, 0).
    &elseif "{&Datatype}" eq "character" &then
        if not (a eq b) then do:
            if (length(a) + length(b)) ge 30000 then
                // Use a simpler error message to avoid errors from too-long substitutions.
                return error new AssertionFailedError("Character values are not equal":u, 0).
            else
                return error new AssertionFailedError(substitute(subMessage, a, b), 0).
        end.
    &elseif "{&Datatype}" eq "longchar" &then
        // Always use a simpler error message to avoid errors from too-long substitutions.
        if not (a eq b) then
            return error new AssertionFailedError("Longchar values are not equal":u, 0).
    &else
        if not (a eq b) then
            return error new AssertionFailedError(substitute(subMessage, a, b), 0).
    &endif
    end method. // Equals

    {&CommentNotEqual}
&if "{&Datatype}" eq "recid" &then
    {&_proparse_ prolint-nowarn(recidkeyword)}
&endif
    method public static void NotEqual (input a as {&DataType}, input b as {&DataType}):
        define variable subMessage as {&MsgType} no-undo initial "&1 and &2 are equal":u.

    &if "{&Datatype}" eq "Object" &then
        NotUnknown(a). // Object must be known.

        if a:Equals(b) then
            return error new AssertionFailedError(substitute(subMessage, string(a), string(b)), 0).
    &elseif "{&Datatype}" eq "memptr" &then
        // If both size and contents (hashes) match then values are considered equal.
        if get-size(a) eq get-size(b) and message-digest("SHA-256", a) eq message-digest("SHA-256", b) then
            return error new AssertionFailedError(substitute(subMessage, "Hash of 'a'":u, "hash of 'b'":u), 0).
    &elseif "{&Datatype}" eq "raw" &then
        // Use a simpler error message as raw values cannot be output directly.
        if a eq b then
            return error new AssertionFailedError("Raw values are equal":u, 0).
    &elseif "{&Datatype}" eq "character" &then
        if a eq b then do:
            if (length(a) + length(b)) ge 30000 then
                // Use a simpler error message to avoid errors from too-long substitutions.
                return error new AssertionFailedError("Character values are equal":u, 0).
            else
                return error new AssertionFailedError(substitute(subMessage, a, b), 0).
        end.
    &elseif "{&Datatype}" eq "longchar" &then
        // Always use a simpler error message to avoid errors from too-long substitutions.
        if a eq b then
            return error new AssertionFailedError("Longchar values are equal":u, 0).
    &else
        if a eq b then
            return error new AssertionFailedError(substitute(subMessage, a, b), 0).
    &endif
    end method. // NotEqual
