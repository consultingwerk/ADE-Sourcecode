&if 1=0 &then
/************************************************
Copyright (c) 2022 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : OpenEdge/Core/Assertion/assertequalityextent.i
    Purpose     : Include for allowing us to dynamically create Equals methods
    Description :
    Author(s)   : dugrau
    Created     : Tue May 3 13:19:42 EDT 2022
    Notes       : * Arguments:
                        DataType : The input ABL datatype to assert equality
                  * Usage example: the below creates methods for character
                        { OpenEdge/Core/Assertion/assertequalityextent.i &DataType = character }
  ----------------------------------------------------------------------*/
&endif

&scoped-define CommentEquals /~** Asserts that array 'a' equals array 'b'.~
 @param {&DataType} the known array~
 @param {&DataType} the comparison array~
 @throws AssertionFailedError Error thrown if arrays differ */

    {&CommentEquals}
&if "{&Datatype}" eq "recid" &then
    {&_proparse_ prolint-nowarn(recidkeyword)}
&endif
    method public static void Equals (input pSource as {&DataType} extent, input pTarget as {&DataType} extent):
        define variable srcSize as int64 no-undo.
        define variable tgtSize as int64 no-undo.
        define variable loop    as int64 no-undo.

        assign srcSize = extent(pSource)
               tgtSize = extent(pTarget).
        if    (srcSize eq ? and tgtSize ne ?)
           or srcSize ne tgtSize then
            undo, throw new AssertionFailedError(substitute('Arrays are different sizes (source=&1; target=&2)':u, srcSize, tgtSize), 0).

        do loop = 1 to srcSize:
            Assert:Equals(pSource[loop], pTarget[loop]).
        end.

        catch e as Progress.Lang.Error:
            if type-of(e, AssertionFailedError) then
                undo, throw e.
            else
                undo, throw new AssertionFailedError(substitute('Array value differ for index &1':u, loop), 0).
        end catch.
    end method. // Equals
