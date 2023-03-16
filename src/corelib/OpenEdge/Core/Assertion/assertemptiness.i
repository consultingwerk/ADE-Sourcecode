&if 1=0 &then
/************************************************
Copyright (c) 2022 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : OpenEdge/Core/Assertion/assertemptiness.i
    Purpose     : Include for allowing us to dynamically create [Is|Not]Empty methods
    Description :
    Author(s)   : dugrau
    Created     : Tue May 3 08:00:42 EDT 2022
    Notes       : * Arguments:
                        DataType : The input ABL datatype to assert as empty (or not)
                  * Usage example: the below creates methods for character
                        { OpenEdge/Core/Assertion/assertemptiness.i &DataType = character }

                  Primitive types behave in a similar manner, though certain datatypes
                  require a slight change to how they evaluate their "empty" values
  ----------------------------------------------------------------------*/
&endif

&scoped-define CommentEmptyShort /~** Asserts that the {&DataType} is empty (blank).~
 @param {&DataType} the value to check~
 @throws AssertionFailedError Error thrown if {&DataType} is not empty (blank) */

&scoped-define CommentEmptyLong  /~** Asserts that the {&DataType} is empty (blank).~
 @param {&DataType} the value to check~
 @param character the identifying name for the AssertionFailedError~
 @throws AssertionFailedError Error thrown if {&DataType} is not empty (blank) */

&scoped-define CommentNotEmptyShort /~** Asserts that the {&DataType} is not empty (blank).~
 @param {&DataType} the value to check~
 @throws AssertionFailedError Error thrown if {&DataType} is empty (blank) */

&scoped-define CommentNotEmptyLong  /~** Asserts that the {&DataType} is not empty (blank).~
 @param {&DataType} the value to check~
 @param character the identifying name for the AssertionFailedError~
 @throws AssertionFailedError Error thrown if {&DataType} is empty (blank) */

&scoped-define CommentEmptyShortArray /~** Asserts that the {&DataType} array is empty (blank).~
 @param {&DataType} the value to check~
 @throws AssertionFailedError Error thrown if {&DataType} array is not empty (blank) */

&scoped-define CommentEmptyLongArray  /~** Asserts that the {&DataType} array is empty (blank).~
 @param {&DataType} the value to check~
 @param character the identifying name for the AssertionFailedError~
 @throws AssertionFailedError Error thrown if {&DataType} array is not empty (blank) */

&scoped-define CommentNotEmptyShortArray /~** Asserts that the {&DataType} array is not empty (blank).~
 @param {&DataType} the value to check~
 @throws AssertionFailedError Error thrown if {&DataType} array is empty (blank) */

&scoped-define CommentNotEmptyLongArray  /~** Asserts that the {&DataType} array is not empty (blank).~
 @param {&DataType} the value to check~
 @param character the identifying name for the AssertionFailedError~
 @throws AssertionFailedError Error thrown if {&DataType} array is empty (blank) */

    {&CommentEmptyShort}
    method public static void IsEmpty (input pArgument as {&DataType}):
    &if "{&Datatype}" eq "handle" &then
        NotUnknown(pArgument, 'argument':u). // Checking for emptiness implies a known value.

        if lookup(pArgument:type, "buffer,buffer-field,temp-table") eq 0 then
            undo, throw new AssertionFailedError(substitute('&1 is not a valid handle type':u, 'argument':u)).

        if pArgument:type eq "temp-table" then
            pArgument = pArgument:default-buffer-handle.
        else if pArgument:type eq "buffer-field" then
            pArgument = pArgument:buffer-handle.

        pArgument:find-first() no-error.
        NotAvailable(pArgument, 'argument':u).
    &elseif "{&Datatype}" eq "memptr" &then
        if get-size(pArgument) ne 0 then
            undo, throw new AssertionFailedError(substitute('&1 must be empty':u, 'argument':u), 0).
    &elseif "{&Datatype}" eq "longchar" &then
        define variable iRawLength as int64 no-undo.

        NotUnknown(pArgument, 'argument':u).
        assign iRawLength = length(pArgument, 'raw':u). // number of bytes in the argument

        /* no characters is pretty empty */
        if iRawLength gt 0 or
           /* TRIM converts everything to cpinternal, which may not be able to 'see' all the characters
              that are in the argument. So, if the lengths differ, then there's something that's not a space
              (strong assumption) and we're OK, Jack.
              If the lengths match, we are ok to convert and we try to trim. */
           (iRawLength eq length(pArgument) and trim(pArgument) ne '':u) then
            undo, throw new AssertionFailedError(substitute('&1 must be empty':u, 'argument':u), 0).
    &else
        NotUnknown(pArgument, 'argument':u). // Checking for emptiness implies a known value.

        // TRIM will strip off spaces etc. Since this is a character parameter, it's already in
        // CPINTERNAL and so doesn't suffer from the issues described in NotEmpty(longchar, char).
        if trim(pArgument) ne '':u then
            undo, throw new AssertionFailedError(substitute('&1 must be empty':u, 'argument':u), 0).
    &endif
    end method. // IsEmpty

    {&CommentEmptyLong}
    method public static void IsEmpty (input pArgument as {&DataType}, input pcName as character):
    &if "{&Datatype}" eq "handle" &then
        NotUnknown(pArgument, pcName). // Checking for emptiness implies a known value.

        if lookup(pArgument:type, "buffer,buffer-field,temp-table") eq 0 then
            undo, throw new AssertionFailedError(substitute('&1 is not a valid handle type':u, pcName)).

        if pArgument:type eq "temp-table" then
            pArgument = pArgument:default-buffer-handle.
        else if pArgument:type eq "buffer-field" then
            pArgument = pArgument:buffer-handle.

        pArgument:find-first() no-error.
        NotAvailable(pArgument, pcName).
    &elseif "{&Datatype}" eq "memptr" &then
        if get-size(pArgument) ne 0 then
            undo, throw new AssertionFailedError(substitute('&1 must be empty':u, pcName), 0).
    &elseif "{&Datatype}" eq "longchar" &then
        define variable iRawLength as int64 no-undo.

        NotUnknown(pArgument, pcName). // Checking for emptiness implies a known value.
        assign iRawLength = length(pArgument, 'raw':u). // number of bytes in the argument

        /* no characters is pretty empty */
        if iRawLength gt 0 or
           /* TRIM converts everything to cpinternal, which may not be able to 'see' all the characters
              that are in the argument. So, if the lengths differ, then there's something that's not a space
              (strong assumption) and we're OK, Jack.
              If the lengths match, we are ok to convert and we try to trim. */
           (iRawLength eq length(pArgument) and trim(pArgument) ne '':u) then
            undo, throw new AssertionFailedError(substitute('&1 must be empty':u, pcName), 0).
    &else
        NotUnknown(pArgument, pcName). // Checking for emptiness implies a known value.

        // TRIM will strip off spaces etc. Since this is a character parameter, it's already in
        // CPINTERNAL and so doesn't suffer from the issues described in NotEmpty(longchar, char).
        if trim(pArgument) ne '':u then
            undo, throw new AssertionFailedError(substitute('&1 must be empty':u, pcName), 0).
    &endif
    end method. // IsEmpty

    {&CommentNotEmptyShort}
    method public static void NotEmpty (input pArgument as {&DataType}):
    &if "{&Datatype}" eq "handle" &then
        NotUnknown(pArgument, 'argument':u). // Checking for emptiness implies a known value.

        if lookup(pArgument:type, "buffer,buffer-field,temp-table") eq 0 then
            undo, throw new AssertionFailedError(substitute('&1 is not a valid handle type':u, 'argument':u)).

        if pArgument:type eq "temp-table" then
            pArgument = pArgument:default-buffer-handle.
        else if pArgument:type eq "buffer-field" then
            pArgument = pArgument:buffer-handle.

        pArgument:find-first() no-error.
        IsAvailable(pArgument, 'argument':u).
    &elseif "{&Datatype}" eq "memptr" &then
        if get-size(pArgument) eq 0 then
            undo, throw new AssertionFailedError(substitute('&1 cannot be empty':u, 'argument':u), 0).
    &elseif "{&Datatype}" eq "longchar" &then
        define variable iRawLength as int64 no-undo.

        NotUnknown(pArgument, 'argument':u). // Checking for emptiness implies a known value.
        assign iRawLength = length(pArgument, 'raw':u). // number of bytes in the argument

        /* no characters is pretty empty */
        if iRawLength eq 0 or
           /* TRIM converts everything to cpinternal, which may not be able to 'see' all the characters
              that are in the argument. So, if the lengths differ, then there's something that's not a space
              (strong assumption) and we're OK, Jack.
              If the lengths match, we are ok to convert and we try to trim. */
           (iRawLength eq length(pArgument) and trim(pArgument) eq '':u) then
            undo, throw new AssertionFailedError(substitute('&1 cannot be empty':u, 'argument':u), 0).
    &else
        NotUnknown(pArgument, 'argument':u). // Checking for emptiness implies a known value.

        // TRIM will strip off spaces etc. Since this is a character parameter, it's already in
        // CPINTERNAL and so doesn't suffer from the issues described in NotEmpty(longchar, char).
        if trim(pArgument) eq '':u then
            undo, throw new AssertionFailedError(substitute('&1 cannot be empty':u, 'argument':u), 0).
    &endif
    end method. // NotEmpty

    {&CommentNotEmptyLong}
    method public static void NotEmpty (input pArgument as {&DataType}, input pcName as character):
    &if "{&Datatype}" eq "handle" &then
        NotUnknown(pArgument, pcName). // Checking for emptiness implies a known value.

        if lookup(pArgument:type, "buffer,buffer-field,temp-table") eq 0 then
            undo, throw new AssertionFailedError(substitute('&1 is not a valid handle type':u, pcName)).

        if pArgument:type eq "temp-table" then
            pArgument = pArgument:default-buffer-handle.
        else if pArgument:type eq "buffer-field" then
            pArgument = pArgument:buffer-handle.

        pArgument:find-first() no-error.
        IsAvailable(pArgument, pcName).
    &elseif "{&Datatype}" eq "memptr" &then
        if get-size(pArgument) eq 0 then
            undo, throw new AssertionFailedError(substitute('&1 cannot be empty':u, pcName), 0).
    &elseif "{&Datatype}" eq "longchar" &then
        define variable iRawLength as int64 no-undo.

        NotUnknown(pArgument, pcName). // Checking for emptiness implies a known value.
        assign iRawLength = length(pArgument, 'raw':u). // number of bytes in the argument

        /* no characters is pretty empty */
        if iRawLength eq 0 or
           /* TRIM converts everything to cpinternal, which may not be able to 'see' all the characters
              that are in the argument. So, if the lengths differ, then there's something that's not a space
              (strong assumption) and we're OK, Jack.
              If the lengths match, we are ok to convert and we try to trim. */
           (iRawLength eq length(pArgument) and trim(pArgument) eq '':u) then
            undo, throw new AssertionFailedError(substitute('&1 cannot be empty':u, pcName), 0).
    &else
        NotUnknown(pArgument, pcName). // Checking for emptiness implies a known value.

        // TRIM will strip off spaces etc. Since this is a character parameter, it's already in
        // CPINTERNAL and so doesn't suffer from the issues described in NotEmpty(longchar, char).
        if trim(pArgument) eq '':u then
            undo, throw new AssertionFailedError(substitute('&1 cannot be empty':u, pcName), 0).
    &endif
    end method. // NotEmpty

    {&CommentEmptyShortArray}
    method public static void IsEmpty (input pArgument as {&DataType} extent):
        define variable iLoop as int64 no-undo.
        define variable iMax  as int64 no-undo.

    &if "{&Datatype}" ne "memptr" &then
        NotUnknown(pArgument, 'argument':u). // Checking for emptiness implies a known value.
    &endif
        AssertArray:HasDeterminateExtent(pArgument, 'argument':u). // Must have declared extent.
        iMax = extent(pArgument).
        do iLoop = 1 to iMax:
            // If any element is found to be non-empty it will cause an assertion error.
            IsEmpty(pArgument[iLoop], substitute('Extent &2 of &1':u, 'argument':u, iLoop)).
        end.
    end method. // IsEmpty

    {&CommentEmptyLongArray}
    method public static void IsEmpty (input pArgument as {&DataType} extent, input pcName as character):
        define variable iLoop as int64 no-undo.
        define variable iMax  as int64 no-undo.

    &if "{&Datatype}" ne "memptr" &then
        NotUnknown(pArgument, pcName). // Checking for emptiness implies a known value.
    &endif
        AssertArray:HasDeterminateExtent(pArgument, pcName). // Must have declared extent.
        iMax = extent(pArgument).
        do iLoop = 1 to iMax:
            // If any element is found to be non-empty it will cause an assertion error.
            IsEmpty(pArgument[iLoop], substitute('Extent &2 of &1':u, pcName, iLoop)).
        end.
    end method. // IsEmpty

    {&CommentNotEmptyShortArray}
    method public static void NotEmpty (input pArgument as {&DataType} extent):
        define variable iLoop as int64 no-undo.
        define variable iMax  as int64 no-undo.

    &if "{&Datatype}" ne "memptr" &then
        NotUnknown(pArgument, 'argument':u). // Checking for emptiness implies a known value.
    &endif
        AssertArray:HasDeterminateExtent(pArgument, 'argument':u). // Must have declared extent.
        iMax = extent(pArgument).
        do iLoop = 1 to iMax:
            // If any element is found to be empty it will cause an assertion error.
            NotEmpty(pArgument[iLoop], substitute('Extent &2 of &1':u, 'argument':u, iLoop)).
        end.
    end method. // NotEmpty

    {&CommentNotEmptyLongArray}
    method public static void NotEmpty (input pArgument as {&DataType} extent, input pcName as character):
        define variable iLoop as int64 no-undo.
        define variable iMax  as int64 no-undo.

    &if "{&Datatype}" ne "memptr" &then
        NotUnknown(pArgument, pcName). // Checking for emptiness implies a known value.
    &endif
        AssertArray:HasDeterminateExtent(pArgument, pcName). // Must have declared extent.
        iMax = extent(pArgument).
        do iLoop = 1 to iMax:
            // If any element is found to be empty it will cause an assertion error.
            NotEmpty(pArgument[iLoop], substitute('Extent &2 of &1':u, pcName, iLoop)).
        end.
    end method. // NotEmpty
