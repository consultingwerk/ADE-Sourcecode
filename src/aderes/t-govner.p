/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
*   This code sample show how to use
*
*      1) included text
*      2) supplement Results predefined features.
*
*   This code fragment implements a simple record governor.
*/

/*
* This code fragment is an VAR defined feature. So we have the
* ususal argument list. But, this code won't use them.
*/

DEFINE INPUT  PARAMETER args  AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER qbf-s AS LOGICAL   NO-UNDO INITIAL FALSE.

DEFINE VARIABLE tableList AS CHARACTER NO-UNDO.
DEFINE VARIABLE codeFrag  AS CHARACTER NO-UNDO.
DEFINE VARIABLE ss        AS LOGICAL   NO-UNDO.

/*
* Set a governor on the outermost table. Allow only 10 to come out.
*
*    1) A dialog box could've been created to get the count of the number
*       of records to be displayed. If a dialog box were to be used then
*       this code would be executed when OK was chosen.
*
*    2) This example hardcodes the fragment. In many cases it would be
*       possible to make the code fragment "{yourFrag.i}". As long as
*       youFrag.i is in the PROPATH it will be found.
*/

codeFrag = "DEFINE VARIABLE xxCount AS INTEGER NO-UNDO. "
         + "IF (xxCount > 10) THEN RETURN. "
         + "xxCount = xxCount + 1. ".

/*
* vgtbll returns a comma-sep list of tables that are currently in the query.
* The order is "outermost, inner, innermost ..."
*
* If there are no tables the list is empty.
*/

RUN aderes/vgtbll.p (OUTPUT tableList).

/*
* Note there is no check for empty table list. There could be, but this
* code assumes that this feature would be made insensitive if there
* is no active query.
*/

/*
* Set the governor on the outermost table in the query. When Results needs
* to generate code the code fragment will be included. It is up to the
* writer to make sure the code fragment will compile. The Results code
* will look something like:
*
*    ...
*    FOR EACH sports.customer NO-LOCK:
*
*        /* code fragment */
*        DEFINE VARIABLE xxCount AS INTEGER NO-UNDO.
*        IF (xxCount > 10) THEN RETURN.
*        xxCount = xxCount + 1.
*    END.
*    ...
*/

RUN aderes/vstbli.p (ENTRY(1,tableList),"",?,?,?,codeFrag,OUTPUT ss).

/*
* Each table can have its own code fragment. If desired, several governors
* could be created.
*/

/*
* The next line of code executes the standard Results print preview. In this
* sample code, Results' print preview has been augmented. What to worry
* about?
*
*     1) This sample code redefines Print Preview. In most cases you would
*        want to remove the standard Print Preview. To do this: 1) Goto
*        Feature Security and change the security so no-one can use
*        PrintPreview. This step will take PrintPreview out of the menu and
*        toolbar. 2) Add the feature that defines this code fragment to the
*        menu and/or toolbar. 3) Manage the feature in your feature
*        sensitivity function.
*
* However, for test purposes, you can keep both Print Previews defined in
* the interface. THen you can test them side-by-side to see how they work.
*/

RUN aderes/sffire.p ("PrintPreview",?,OUTPUT ss).

/*
* For this test, reset the include code. There governor is only used for
* VAR print preview.
*/

RUN aderes/vstbli.p (ENTRY(1,tableList),"",?,?,?,"",OUTPUT ss).

/* t-govner.p - end of file */

