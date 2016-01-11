/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

