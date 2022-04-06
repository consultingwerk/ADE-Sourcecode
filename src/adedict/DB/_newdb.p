/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _newdb.p

Description:   
   Put up a dialog box to get parameters for creating a new database.
   and create the database by calling prodb.  Most of this code has been
   put into a common dialog service so it can be called from outside
   the dictionary.

Author: Laura Stern

Date Created: 01/27/92

----------------------------------------------------------------------------*/

{adedict/dictvar.i shared}
{adedict/brwvar.i shared}


/*------------------------------ Mainline code ------------------------------*/

Define var newdb  as char     NO-UNDO.
Define var olddb  as char     NO-UNDO.
Define var stat   as logical  NO-UNDO.

assign
   newdb = ""
   olddb = ""
   current-window = (if s_win_Logo = ? then s_win_Browse else s_win_Logo).

run adecomm/_dbcreat.p (INPUT olddb, INPUT-OUTPUT newdb).

if newdb <> ? then
   run adedict/DB/_connect.p (INPUT newdb).
