/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
* This program creates a .p of the current query and passes the program
* to the .p supplied in the argument list.
*
* This file is needed by the tty to GUI conversion for those v6 Results
* applications that have the need to set printer characteristics before
* sending the output
*
* Input Parameters
*
*    arg    The file to run.
*
*  Output Parameter
*
*    retStat True if Results should repaint the user interface.
*
*/

DEFINE INPUT  PARAMETER arg     AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER retStat AS LOGICAL   NO-UNDO INITIAL FALSE.

{ aderes/u-pvars.i }

DEFINE VARIABLE f-name    AS CHARACTER NO-UNDO INITIAL "temp.p".
DEFINE VARIABLE apArgs    AS CHARACTER NO-UNDO.
DEFINE VARIABLE retState  AS LOGICAL   NO-UNDO.

/*
* Set the cursor to the wait state. In case the thru function
* takes alot of time
*/
RUN adecomm/_setcurs.p("WAIT":u).

/* Put the current state of the query into a .p file */
apArgs = f-name + ",":u + qbf-module.

RUN aderes/sffire.p("AdminProgWrite4GL":u, apArgs, OUTPUT retState).

/* Start the output.  */

RUN VALUE(arg)(f-name).

OS-DELETE VALUE(f-name).

RUN adecomm/_setcurs.p("").

/* u-pprog.p - end of file */

