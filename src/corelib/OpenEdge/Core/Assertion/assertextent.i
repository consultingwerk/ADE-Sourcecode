&if 1=0 &then
/************************************************
Copyright (c) 2022 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : OpenEdge/Core/Assertion/assertextent.i
    Purpose     : Include for allowing us to dynamically checking extents
    Description :
    Author(s)   : dugrau
    Created     : Tue May 3 08:00:42 EDT 2022
    Notes       : * Arguments:
                        DataType : The input ABL datatype to assert as determinate or not
                  * Usage example: the below creates methods for character
                        { OpenEdge/Core/Assertion/assertextent.i &DataType = character }

                  Primitive types behave in a similar manner, though certain datatypes
                  require a slight change to how they evaluate their extent values
  ----------------------------------------------------------------------*/
&endif

&scoped-define CommentDeterminateShort /~** Asserts that the {&DataType} extent is set.~
 @param {&DataType} the value to check~
 @throws AssertionFailedError Error thrown if {&DataType} extent is not set */

&scoped-define CommentDeterminateLong  /~** Asserts that the {&DataType} extent is set.~
 @param {&DataType} the value to check~
 @param character the identifying name for the AssertionFailedError~
 @throws AssertionFailedError Error thrown if {&DataType} extent is not set */

&scoped-define CommentIndeterminateShort /~** Asserts that the {&DataType} extent is not set.~
 @param {&DataType} the value to check~
 @throws AssertionFailedError Error thrown if {&DataType} extent is set */

&scoped-define CommentIndeterminateLong  /~** Asserts that the {&DataType} extent is not set.~
 @param {&DataType} the value to check~
 @param character the identifying name for the AssertionFailedError~
 @throws AssertionFailedError Error thrown if {&DataType} extent is set */

    {&CommentDeterminateShort}
&if "{&Datatype}" eq "recid" &then
    {&_proparse_ prolint-nowarn(recidkeyword)}
&endif
    method public static void HasDeterminateExtent (input pArgument as {&DataType} extent):
        if extent(pArgument) eq ? then
            undo, throw new AssertionFailedError(substitute('&1 array cannot be indeterminate':u, 'argument':u), 0).
    end method. // HasDeterminateExtent

    {&CommentDeterminateLong}
&if "{&Datatype}" eq "recid" &then
    {&_proparse_ prolint-nowarn(recidkeyword)}
&endif
    method public static void HasDeterminateExtent (input pArgument as {&DataType} extent, input pcName as character):
        if extent(pArgument) eq ? then
            undo, throw new AssertionFailedError(substitute('&1 array cannot be indeterminate':u, pcName), 0).
    end method. // HasDeterminateExtent

    {&CommentIndeterminateShort}
&if "{&Datatype}" eq "recid" &then
    {&_proparse_ prolint-nowarn(recidkeyword)}
&endif
    method public static void IsIndeterminateArray (input pArgument as {&DataType} extent):
        if extent(pArgument) ne ? then
            undo, throw new AssertionFailedError(substitute('&1 array must be indeterminate':u, 'argument':u), 0).
    end method. // IsIndeterminateArray

    {&CommentIndeterminateLong}
&if "{&Datatype}" eq "recid" &then
    {&_proparse_ prolint-nowarn(recidkeyword)}
&endif
    method public static void IsIndeterminateArray (input pArgument as {&DataType} extent, input pcName as character):
        if extent(pArgument) ne ? then
            undo, throw new AssertionFailedError(substitute('&1 array must be indeterminate':u, pcName), 0).
    end method. // IsIndeterminateArray
