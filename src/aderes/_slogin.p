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
/*
 * _slogin.p - default RESULTS login procedure, using the official
 *             looking login screen
 */

{ login.i NEW } /* login.i is copied into aderes */

DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-s AS CHARACTER NO-UNDO.

HIDE MESSAGE NO-PAUSE.

/* Prompt for userid and password in all connected   */
/* Progress databases (If not supplied as startup    */
/* parameters).  Non-Progress databases MUST supply  */
/* userid/passwd using -U and -P startup parameters. */

qbf-s = LDBNAME("DICTDB").
IF NUM-DBS > 1 AND LDBNAME("DICTDB") = "DICTDB" THEN DO ON ERROR UNDO,LEAVE:
  BELL.
  MESSAGE
    "WARNING: You cannot use security if you have more than one database    ".
  MESSAGE
    "         connected and the logical name of one database is DICTDB.     ".
  HIDE MESSAGE.
END.
ELSE DO qbf-i = 1 to NUM-DBS:
  IF DBTYPE(qbf-i) <> "PROGRESS" THEN NEXT.
  CREATE ALIAS "DICTDB" FOR DATABASE VALUE(LDBNAME(qbf-i)).
  RUN _login.p (TRUE).
END.
IF qbf-s <> ? THEN
  CREATE ALIAS "DICTDB" FOR DATABASE VALUE(qbf-s).
HIDE MESSAGE NO-PAUSE.

RETURN.

/* _slogin.p - end of file */

