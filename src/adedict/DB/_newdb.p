/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
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
