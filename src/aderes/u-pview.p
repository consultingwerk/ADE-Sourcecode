/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
* This program passes the current results of the query
* to the .p supplied in the argument list.
*
* This file is needed by the tty to GUI conversion for those v6 Results
* applications that have the need to send out to other print "view programs".
*
* Input Parameters
*
*    arg    The file to run.
*
*  Output Parameter
*
*    lRet    True if Results should repaint the user interface.
*
*/

DEFINE INPUT  PARAMETER arg    AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER lRet   AS LOGICAL   NO-UNDO INITIAL FALSE.

{ aderes/u-pvars.i }

DEFINE VARIABLE f-name    AS CHARACTER NO-UNDO INITIAL "temp.p".
DEFINE VARIABLE textName  AS CHARACTER NO-UNDO INITIAL "temp.txt".
DEFINE VARIABLE apArgs    AS CHARACTER NO-UNDO.
DEFINE VARIABLE retState  AS LOGICAL   NO-UNDO.

/*
* Set the cursor to the wait state. In case the thru function
* takes alot of time
*/

RUN adecomm/_setcurs.p("WAIT":u).

/* Put the current state of the query into a .p file */
apArgs = f-name + ",":u + qbf-module.

RUN aderes/sffire.p("AdminProgWrite4GL", apArgs, OUTPUT retState).

/* Start the output.  */
OUTPUT TO VALUE(textName).

RUN VALUE(f-name).

OUTPUT CLOSE.

RUN VALUE(arg) (textName).

OS-DELETE VALUE(f-name).
OS-DELETE VALUE(textName).

RUN adecomm/_setcurs.p("").

/* u-pview.p - end of file */

