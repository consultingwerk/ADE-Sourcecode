/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
* u-define.p -
*
* This function can set up the shared information needed by the application.
*
* This file must accept as an argument the function that runs Results.
*
* This program can be used to defined shared variables that are needed
* for user extensions to RESULTS.  The input parameter is the main
* RESULTS program.  Proper use of this program is to place the DEFINEs
* before the RUN VALUE(funcName), then do the RUN, then place any shut-down
* code.  The RETURN returns to the outer most RESULTS procedures which
* clean up temporary files.
*
*/

DEFINE INPUT PARAMETER functionName AS CHARACTER NO-UNDO.

/*
* Your definitions goes here
*/

/*
* The following line is required!
*/

RUN VALUE(functionName).

RETURN.

/* u-define.p - end of file */

