/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
* This is an example a generic OUTPUT TO statement. This file is called
* from the user interface as an admin defined feature.
*
* Input Parameters
*
*    arg    The destination for the output of the Results query. The filter
*           is provided from the definition of the admin feature.
*
*  Output Parameter
*
*    lRet   True if Results should repaint the user interface.
*
* This file can be duplicate and/or altered as needed.
*
*
*/

DEFINE INPUT  PARAMETER arg    AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER lRet   AS LOGICAL   NO-UNDO INITIAL FALSE.

{ aderes/u-pvars.i }

DEFINE VARIABLE f-name AS CHARACTER NO-UNDO INITIAL "temp.p":u.
DEFINE VARIABLE apArgs   AS CHARACTER NO-UNDO.
DEFINE VARIABLE retState AS LOGICAL   NO-UNDO.

/*
* Set the cursor to the wait state. In case the thru function
* takes alot of time
*/
RUN adecomm/_setcurs.p("WAIT":u).

/* Put the current state of the query into a .p file */
apArgs = f-name + ",":u + qbf-module.

RUN aderes/sffire.p("AdminProgWrite4GL":u, apArgs, OUTPUT retState).

/* Start the output.  */
OUTPUT TO VALUE(arg).

RUN VALUE(f-name).

OUTPUT CLOSE.

OS-DELETE VALUE(f-name).

RUN adecomm/_setcurs.p("").

/* u-to.p - end of file */

