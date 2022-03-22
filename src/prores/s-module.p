/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* s-module.p - switch modules routines */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/t-define.i }
{ prores/c-form.i }
{ prores/t-set.i &mod=a &set=1 }

DEFINE INPUT  PARAMETER qbf-s AS CHARACTER           NO-UNDO.
DEFINE OUTPUT PARAMETER qbf-o AS CHARACTER INITIAL ? NO-UNDO.

DEFINE VARIABLE qbf-b AS CHARACTER INITIAL "" NO-UNDO.
DEFINE VARIABLE qbf-c AS CHARACTER INITIAL "" NO-UNDO.
DEFINE VARIABLE qbf-l AS INTEGER   INITIAL  0 NO-UNDO.
DEFINE VARIABLE qbf-m AS CHARACTER EXTENT   5 NO-UNDO.

FORM
  qbf-m[1] FORMAT "x(16)" SKIP
  qbf-m[2] FORMAT "x(16)" SKIP
  qbf-m[3] FORMAT "x(16)" SKIP
  qbf-m[4] FORMAT "x(16)" SKIP
  qbf-m[5] FORMAT "x(16)" SKIP
  WITH FRAME qbf-jumper ROW 2 COLUMN 60 ATTR-SPACE NO-LABELS OVERLAY
  COLOR DISPLAY VALUE(qbf-mlo) PROMPT VALUE(qbf-mhi).

/*message "[s-module.p]" view-as alert-box.*/

ASSIGN
  qbf-time  = "" /* reset timer and counter */
  qbf-total = 0  /* reset timer and counter */
  qbf-c     = ?.

IF qbf-s <> "q" AND INDEX(qbf-secure,"q") > 0 AND qbf-form# > 0 THEN
  ASSIGN
    qbf-b        = qbf-b + "q"
    qbf-l        = qbf-l + 1
    qbf-m[qbf-l] = qbf-lang[1]. /*"Q. Query"*/
IF qbf-s <> "r" AND INDEX(qbf-secure,"r") > 0 THEN
  ASSIGN
    qbf-b        = qbf-b + "r"
    qbf-l        = qbf-l + 1
    qbf-m[qbf-l] = qbf-lang[2]. /*"R. Reports"*/
IF LDBNAME("FTDB") = ? THEN CREATE ALIAS "FTDB" FOR DATABASE VALUE(LDBNAME(1)).
IF LDBNAME("FTDB") <> ? THEN
  RUN prores/s-lookup.p
    ("FTDB","_menu","","FILE:RECID",OUTPUT qbf-c).
IF qbf-c = ? THEN 
  DELETE ALIAS "FTDB".
IF qbf-s = "r"
  AND INDEX(qbf-secure,"r") > 0
  AND qbf-ftbang
  AND qbf-c <> ?
  AND (SEARCH("ft.p") <> ? OR SEARCH("ft.r") <> ?) THEN
  ASSIGN
    qbf-b        = qbf-b + "f"
    qbf-l        = qbf-l + 1
    qbf-m[qbf-l] = qbf-lang[8]. /*"F. FAST TRACK"*/
IF qbf-s <> "l" AND INDEX(qbf-secure,"l") > 0 THEN
  ASSIGN
    qbf-b        = qbf-b + "l"
    qbf-l        = qbf-l + 1
    qbf-m[qbf-l] = qbf-lang[3]. /*"L. Labels"*/
IF qbf-s <> "d" AND INDEX(qbf-secure,"d") > 0 THEN
  ASSIGN
    qbf-b        = qbf-b + "d"
    qbf-l        = qbf-l + 1
    qbf-m[qbf-l] = qbf-lang[4]. /*"D. Data Export"*/
IF qbf-user     AND INDEX(qbf-secure,"u") > 0 THEN
  ASSIGN
    qbf-b        = qbf-b + "u"
    qbf-l        = qbf-l + 1
    qbf-m[qbf-l] = qbf-lang[5]. /*"U. User"*/

/* no other modules to switch to. */
IF qbf-l = 0 THEN DO:
  BELL.
  RETURN.
END.

DISPLAY qbf-m[1 FOR 5] WITH FRAME qbf-jumper.
STATUS DEFAULT qbf-lang[12].  /*'Select module or press [END-ERROR]'*/

ASSIGN
  qbf-c      = qbf-module
  qbf-module = "e0".
DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE WITH FRAME qbf-jumper:
  IF qbf-l = 1 THEN
    CHOOSE FIELD qbf-m[1 FOR 1] AUTO-RETURN COLOR VALUE(qbf-mhi).
  ELSE IF qbf-l = 2 THEN
    CHOOSE FIELD qbf-m[1 FOR 2] AUTO-RETURN COLOR VALUE(qbf-mhi).
  ELSE IF qbf-l = 3 THEN
    CHOOSE FIELD qbf-m[1 FOR 3] AUTO-RETURN COLOR VALUE(qbf-mhi).
  ELSE IF qbf-l = 4 THEN
    CHOOSE FIELD qbf-m[1 FOR 4] AUTO-RETURN COLOR VALUE(qbf-mhi).
  ELSE
    CHOOSE FIELD qbf-m[1 FOR 5] AUTO-RETURN COLOR VALUE(qbf-mhi).
  qbf-o = SUBSTRING(qbf-b,FRAME-INDEX,1).
END.
qbf-module = qbf-c.

STATUS DEFAULT.
{ prores/t-reset.i }
HIDE FRAME qbf-jumper NO-PAUSE.
RETURN.
