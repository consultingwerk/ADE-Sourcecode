/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * u-table.p - table-level security for RESULTS
 *
 *    An example file to provide the function interface that is expected
 *    by RESULTS. The Admin is going to provide their security for the
 *    tables available in the database(s).
 *
 *    RESULTS will RUN this file once during startup.  This file will be 
 *    RUN as RESULTS Core builds its list of tables from the database(s).
 *
 *    RESULTS does provide a Core equivalent to this program. If this
 *    program is not hooked to RESULTS, RESULTS will use the current
 *    state of the permissions of the tables.
 *
 *    From the Integration Procedure menu, hook this function into RESULTS.
 *    In the Integration Procedures dialog box choose "Table Security" and 
 *    change the codepath.
 *
 *    This function, if hooked in as is, will not change the permissions
 *
 *  Input Parameters
 *
 *    dName      The name of the database
 *
 *    uName      The name of the user
 *
 *    tList      A comma separated list of table names to be checked
 *
 *    aList      A comma separated list of alias reference tables. For
 *               example, if entry 5 of this list is "Customer" then
 *               entry 5 of tList is a table alias for "Customer"
 *
 *  Input-Output Parameters
 *
 *    sList      A comma separated list of true/false character strings.
 *
 *  Each list will have the same number of entries in it. Each is a parallel
 *  list of information.
 */

DEFINE INPUT PARAMETER        dName AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER        uName AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER        tList AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER        aList AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER sList AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-i AS INTEGER NO-UNDO.

DO qbf-i = 1 TO NUM-ENTRIES(tList):

  /*
  * Your code goes here
  */

END.

/* u-table.p - end of file */

