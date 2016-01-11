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
/* a-perm.p - do Module and Query permissions setting */

{ prores/s-system.i }
{ prores/t-define.i }
{ prores/a-define.i }

DEFINE INPUT PARAMETER qbf-g AS CHARACTER NO-UNDO.
/*
qbf-g = "m" - edit MODULE permissions
qbf-g = "q" - edit QUERY permissions
*/

DEFINE VARIABLE qbf-a AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE VARIABLE qbf-c AS CHARACTER             NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER               NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER               NO-UNDO.
DEFINE VARIABLE qbf-k AS INTEGER               NO-UNDO.
DEFINE VARIABLE qbf-m AS CHARACTER EXTENT   18 NO-UNDO.
DEFINE VARIABLE qbf-p AS CHARACTER EXTENT    4 NO-UNDO.
DEFINE VARIABLE qbf-q AS CHARACTER INITIAL  "" NO-UNDO.

FORM
  qbf-m[1] FORMAT "x(20)" SKIP
  qbf-m[2] FORMAT "x(20)" SKIP
  qbf-m[3] FORMAT "x(20)" SKIP
  qbf-m[4] FORMAT "x(20)" SKIP
  qbf-m[5] FORMAT "x(20)" SKIP
  qbf-m[6] FORMAT "x(20)" SKIP(1)
  WITH FRAME qbf-mperm ROW 3 COLUMN 2 NO-BOX ATTR-SPACE NO-LABELS OVERLAY.
FORM
  qbf-m[ 1] FORMAT "x(10)" ":"
  qbf-m[ 7] FORMAT "x(10)" ":"
  qbf-m[13] FORMAT "x(10)" SKIP
  qbf-m[ 2] FORMAT "x(10)" ":"
  qbf-m[ 8] FORMAT "x(10)" ":"
  qbf-m[14] FORMAT "x(10)" SKIP
  qbf-m[ 3] FORMAT "x(10)" ":"
  qbf-m[ 9] FORMAT "x(10)" ":"
  qbf-m[15] FORMAT "x(10)" SKIP
  qbf-m[ 4] FORMAT "x(10)" ":"
  qbf-m[10] FORMAT "x(10)" ":"
  qbf-m[16] FORMAT "x(10)" SKIP
  qbf-m[ 5] FORMAT "x(10)" ":"
  qbf-m[11] FORMAT "x(10)" ":"
  qbf-m[17] FORMAT "x(10)" SKIP
  qbf-m[ 6] FORMAT "x(10)" ":"
  qbf-m[12] FORMAT "x(10)" ":"
  qbf-m[18] FORMAT "x(10)" SKIP(1)
  WITH FRAME qbf-qperm ROW 3 COLUMN 2 NO-BOX ATTR-SPACE NO-LABELS OVERLAY.

IF qbf-g = "m" THEN DO:
  { prores/t-set.i &mod=a &set=1 }
  /*"Query,Report,Labels,Data Export,User,Administration"*/
  qbf-q = qbf-lang[1] + "," + qbf-lang[2] + "," + qbf-lang[3] + ","
        + qbf-lang[4] + "," + qbf-lang[5] + "," + qbf-lang[6].
END.
ELSE DO:
  { prores/t-set.i &mod=q &set=2 }
  /*"Next,Prev,First,Last,Add,Update,Copy,Delete,View,Browse,"*/
  /*+ "Join,Query,Where,Total,Order,Module,Info,User"*/
  DO qbf-k = 1 TO 18:
    qbf-q = (IF qbf-k = 1 THEN "" ELSE qbf-q + ",") + ENTRY(1,qbf-lang[qbf-k]).
  END.
END.

/* load up local values */
{ prores/t-set.i &mod=a &set=5 }

/*  8:"Select a module from"  11:"Select a function from" */
/*  9:"the list at left to"   12:"the list at left to"    */
/* 10:"set permissions for."  13:"set permissions for."   */
DISPLAY
  "   " qbf-lang[IF qbf-g = "m" THEN  8 ELSE 11] FORMAT "x(30)" SKIP
  "<--" qbf-lang[IF qbf-g = "m" THEN  9 ELSE 12] FORMAT "x(30)" SKIP
  "   " qbf-lang[IF qbf-g = "m" THEN 10 ELSE 13] FORMAT "x(30)" SKIP
  WITH FRAME qbf-arrow ROW 4 COLUMN 45 NO-BOX NO-ATTR-SPACE NO-LABELS OVERLAY.

DO qbf-k = 1 TO 6:
  IF qbf-g = "m" THEN
    DISPLAY
      " " + ENTRY(qbf-k,qbf-q) @ qbf-m[qbf-k]
      WITH FRAME qbf-mperm.
  ELSE
    DISPLAY /* do 3 at a time for speed */
      " " + ENTRY(qbf-k     ,qbf-q) @ qbf-m[qbf-k     ]
      " " + ENTRY(qbf-k +  6,qbf-q) @ qbf-m[qbf-k +  6]
      " " + ENTRY(qbf-k + 12,qbf-q) @ qbf-m[qbf-k + 12]
      WITH FRAME qbf-qperm.
END.

DISPLAY
  qbf-lang[1] + ":" @ qbf-c FORMAT "x(40)" NO-ATTR-SPACE SKIP /*Permissions*/
  qbf-p[1]    FORMAT "x(76)" SKIP
  qbf-p[2]    FORMAT "x(76)" SKIP
  qbf-p[3]    FORMAT "x(76)" SKIP
  qbf-p[4]    FORMAT "x(76)" SKIP
  /*    *                   - All users are allowed access.            */
  /*    <user>,<user>,etc.  - Only these users have access.            */
  /*    !<user>,!<user>,*   - All except these users have access.      */
  /*    acct*               - Only users that begin with "acct" allowed*/
  /*List users by their login IDs, and separate them with commas.      */
  /*IDs may contain wildcards.  Use exclamation marks to exclude users.*/
  qbf-lang[2] FORMAT "x(78)" NO-ATTR-SPACE SKIP
  qbf-lang[3] FORMAT "x(78)" NO-ATTR-SPACE SKIP
  qbf-lang[4] FORMAT "x(78)" NO-ATTR-SPACE SKIP
  qbf-lang[5] FORMAT "x(78)" NO-ATTR-SPACE SKIP
  qbf-lang[6] FORMAT "x(78)" NO-ATTR-SPACE SKIP
  qbf-lang[7] FORMAT "x(78)" NO-ATTR-SPACE SKIP
  WITH FRAME qbf-both ROW 10 COLUMN 2 NO-BOX ATTR-SPACE NO-LABELS OVERLAY.
COLOR DISPLAY INPUT qbf-p[1 FOR 4] WITH FRAME qbf-both.

/*"Press [END-ERROR] when done making changes."*/
/*"Press [GO] to save, [END-ERROR] to undo changes."*/
STATUS DEFAULT qbf-lang[14].
STATUS INPUT qbf-lang[15].
ON CURSOR-UP BACK-TAB. ON CURSOR-DOWN TAB.
DO WHILE TRUE ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
  IF qbf-a THEN
    DISPLAY
      qbf-lang[1] + ":" @ qbf-c /*"Permissions:"*/
      "" @ qbf-p[1] "" @ qbf-p[2] "" @ qbf-p[3] "" @ qbf-p[4]
      WITH FRAME qbf-both.
  IF qbf-g = "m" THEN
    CHOOSE FIELD qbf-m[1 FOR  6] AUTO-RETURN WITH FRAME qbf-mperm.
  ELSE
    CHOOSE FIELD qbf-m[1 FOR 18] AUTO-RETURN WITH FRAME qbf-qperm.
  qbf-i = FRAME-INDEX.
  IF qbf-i = 0 THEN UNDO,RETRY.
  DISPLAY qbf-lang[1] + ": (" + ENTRY(qbf-i,qbf-q) + ")" @ qbf-c
    WITH FRAME qbf-both. /*"Permissions:"*/
  ASSIGN
    qbf-c    = (IF qbf-g = "m" THEN qbf-m-perm[qbf-i] ELSE qbf-q-perm[qbf-i])
    qbf-p[1] = (IF qbf-c > "" THEN qbf-c ELSE
               (IF qbf-g = "m" OR qbf-i < 5 OR qbf-i > 8 THEN "*" ELSE "!*"))
    qbf-p[2] = ""
    qbf-p[3] = ""
    qbf-p[4] = ""
    qbf-a    = TRUE.
  DO qbf-j = 1 TO 3 WHILE LENGTH(qbf-p[qbf-j]) > 76:
    ASSIGN
      qbf-k            = R-INDEX(SUBSTRING(qbf-p[qbf-j],1,76),",")
      qbf-k            = (IF qbf-k = 0 THEN 76 ELSE qbf-k)
      qbf-p[qbf-j + 1] = SUBSTRING(qbf-p[qbf-j],qbf-k + 1)
      qbf-p[qbf-j    ] = SUBSTRING(qbf-p[qbf-j],1,qbf-k).
  END.
  ON CURSOR-UP CURSOR-UP. ON CURSOR-DOWN CURSOR-DOWN.
  DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
    UPDATE qbf-p[1] qbf-p[2] qbf-p[3] qbf-p[4] WITH FRAME qbf-both.
    IF qbf-p[2] <> "" AND NOT qbf-p[1] MATCHES "*," THEN
      qbf-p[1] = qbf-p[1] + ",".
    IF qbf-p[3] <> "" AND NOT qbf-p[2] MATCHES "*," THEN
      qbf-p[2] = qbf-p[2] + ",".
    IF qbf-p[4] <> "" AND NOT qbf-p[3] MATCHES "*," THEN
      qbf-p[3] = qbf-p[3] + ",".
    ASSIGN
      qbf-a = FALSE
      qbf-c = qbf-p[1] + qbf-p[2] + qbf-p[3] + qbf-p[4].
    IF qbf-c MATCHES "*," THEN qbf-c = SUBSTRING(qbf-c,1,LENGTH(qbf-c) - 1).
    IF qbf-g = "m"  /* module permissions */
      AND qbf-i = 6 /* admin module */
      AND NOT CAN-DO(qbf-c,USERID("RESULTSDB")) THEN DO:
      MESSAGE qbf-lang[16].
      /* You cannot exclude yourself from Administration! */
      UNDO,RETRY.
    END.
    IF qbf-g = "m" THEN
      qbf-m-perm[qbf-i] = qbf-c.
    ELSE
      qbf-q-perm[qbf-i] = qbf-c.
  END.
  ON CURSOR-UP BACK-TAB. ON CURSOR-DOWN TAB.
END.

ON CURSOR-UP CURSOR-UP. ON CURSOR-DOWN CURSOR-DOWN.
HIDE FRAME qbf-mperm NO-PAUSE.
HIDE FRAME qbf-qperm NO-PAUSE.
HIDE FRAME qbf-both  NO-PAUSE.
HIDE FRAME qbf-arrow NO-PAUSE.
HIDE MESSAGE NO-PAUSE.
STATUS DEFAULT.
STATUS INPUT.
{ prores/t-reset.i }
RETURN.
