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
/* s-main.p - PROGRESS RESULTS main menu */

{ prores/s-system.i }
{ prores/c-form.i   }
{ prores/s-define.i NEW }
{ prores/t-define.i NEW }
{ prores/i-define.i NEW }
{ prores/s-print.i  NEW }
{ prores/s-menu.i   NEW }
{ prores/reswidg.i  NEW }

DEFINE SHARED VARIABLE microqbf AS LOGICAL NO-UNDO.

DEFINE VARIABLE qbf-a AS LOGICAL                       NO-UNDO.
DEFINE VARIABLE qbf-c AS CHARACTER                     NO-UNDO.
DEFINE VARIABLE qbf-e AS CHARACTER INITIAL ""          NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER                       NO-UNDO.
DEFINE VARIABLE qbf-l AS INTEGER   INITIAL 0           NO-UNDO.
DEFINE VARIABLE qbf-m AS CHARACTER INITIAL "" EXTENT 7 NO-UNDO.
DEFINE VARIABLE qbf-o AS CHARACTER INITIAL ?           NO-UNDO.
DEFINE VARIABLE qbf-p AS CHARACTER                     NO-UNDO.

qbf-p = PROPATH.

/* use our own special little help file here. */
ON HELP ANYWHERE RUN prores/s-help.p.

/*
if test-drive version of results, then use the following line:
IF _CBIT(_CONTROL,112) AND NOT _CBIT(_CONTROL,32) THEN

if pads versions of results, then use the following line:
IF NOT _CBIT(_CONTROL,32) THEN

IF NOT _CBIT(_CONTROL,32) THEN /* see above */
  qbf-e = "#13".
ELSE
*/
qbf-i = GET-LICENSE ("RESULTS").

IF qbf-i = 1 THEN
  MESSAGE 'Wrong string!'.
ELSE IF qbf-i = 2 THEN
  qbf-e = "#33".
ELSE IF qbf-i = 3 THEN
  qbf-e = "#13".
ELSE
  RUN prores/a-init.p (TRUE,OUTPUT qbf-e).

IF qbf-e <> "" THEN DO:
  { prores/t-set.i &mod=a &set=1 }
  HIDE MESSAGE NO-PAUSE.
  /*
  13: "You have not purchased RESULTS.  Program terminated."
  16: "There are no databases connected."
  17: "Cannot execute when a database has logical name starting with RESULTS."
  18: "Quit"
  33: "Your copy of RESULTS is past its expiration date."
  */
  qbf-continu = qbf-lang[18]. /* used by s-error.p */
  RUN prores/s-error.p (qbf-e).
  QUIT.
END.

microqbf = TRUE.

IF SEARCH(qbf-qcfile + ".qc") = ? THEN
  RUN prores/b-init.p.

qbf-signon = ?. /* force recache */
RUN prores/a-load.p (OUTPUT qbf-a).
IF qbf-a THEN DO: /* flag indicates we blew up during build */
  RUN prores/b-build.p (4).
  qbf-signon = ?. /* force recache */
END.

FORM SKIP(1)
  SPACE(3) qbf-m[1] FORMAT "x(20)" SKIP
  SPACE(3) qbf-m[2] FORMAT "x(20)" SKIP
  SPACE(3) qbf-m[3] FORMAT "x(20)" SKIP
  SPACE(3) qbf-m[4] FORMAT "x(20)" SKIP
  SPACE(3) qbf-m[5] FORMAT "x(20)" SKIP
  SPACE(3) qbf-m[6] FORMAT "x(20)" SKIP
  SPACE(3) qbf-m[7] FORMAT "x(20)" SKIP(1)
  WITH FRAME qbf-main CENTERED ROW 4 WIDTH 30 ATTR-SPACE NO-LABELS
  TITLE COLOR VALUE(qbf-mlo) " " + qbf-product + " "
  COLOR DISPLAY VALUE(qbf-mlo) PROMPT VALUE(qbf-mhi).

DO WHILE TRUE ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE WITH FRAME qbf-main:

  IF qbf-signon = ? THEN DO:
    RUN prores/a-load.p (OUTPUT qbf-a).
    CLEAR NO-PAUSE.
  END.
  RUN prores/s-zap.p. /* reset all values */

  /* reload main menu if language changed */
  IF qbf-o <> qbf-langset THEN DO:
    { prores/t-set.i &mod=a &set=1 }
    ASSIGN
      qbf-o    = qbf-langset
      qbf-m[1] = qbf-lang[1]
      qbf-m[2] = qbf-lang[2]
      qbf-m[3] = qbf-lang[3]
      qbf-m[4] = qbf-lang[4]
      qbf-m[5] = qbf-lang[5]
      qbf-m[6] = qbf-lang[6]
      qbf-m[7] = qbf-lang[7].
  END.

  IF INDEX(qbf-secure,"q") > 0 AND qbf-form# = 0 THEN
    SUBSTRING(qbf-secure,INDEX(qbf-secure,"q"),1) = " ".
  IF INDEX(qbf-secure,"u") > 0 AND NOT qbf-user THEN
    SUBSTRING(qbf-secure,INDEX(qbf-secure,"u"),1) = " ".

  HIDE ALL NO-PAUSE.

  ASSIGN
    qbf-a = ?
    qbf-c = ""
    qbf-l = 1.
  DO qbf-i = 1 TO 6:
    IF INDEX(qbf-secure,SUBSTRING("qrldua",qbf-i,1)) = 0 THEN NEXT.
    DISPLAY " " + qbf-m[qbf-i] @ qbf-m[qbf-l].
    ASSIGN
      qbf-l = qbf-l + 1
      qbf-c = qbf-c + SUBSTRING("qrldua",qbf-i,1).
  END.
  DISPLAY " " + qbf-m[7] @ qbf-m[qbf-l].

  ASSIGN
    qbf-c      = qbf-c + "e"
    qbf-module = "e".

  STATUS DEFAULT.
  ON CURSOR-UP BACK-TAB. ON CURSOR-DOWN TAB.
  DO ON ENDKEY UNDO,LEAVE:
    IF      qbf-l = 1 THEN
      CHOOSE FIELD qbf-m[1 FOR 1] AUTO-RETURN COLOR VALUE(qbf-mhi).
    ELSE IF qbf-l = 2 THEN
      CHOOSE FIELD qbf-m[1 FOR 2] AUTO-RETURN COLOR VALUE(qbf-mhi).
    ELSE IF qbf-l = 3 THEN
      CHOOSE FIELD qbf-m[1 FOR 3] AUTO-RETURN COLOR VALUE(qbf-mhi).
    ELSE IF qbf-l = 4 THEN
      CHOOSE FIELD qbf-m[1 FOR 4] AUTO-RETURN COLOR VALUE(qbf-mhi).
    ELSE IF qbf-l = 5 THEN
      CHOOSE FIELD qbf-m[1 FOR 5] AUTO-RETURN COLOR VALUE(qbf-mhi).
    ELSE IF qbf-l = 6 THEN
      CHOOSE FIELD qbf-m[1 FOR 6] AUTO-RETURN COLOR VALUE(qbf-mhi).
    ELSE IF qbf-l = 7 THEN
      CHOOSE FIELD qbf-m[1 FOR 7] AUTO-RETURN COLOR VALUE(qbf-mhi).
    qbf-module = SUBSTRING(qbf-c,FRAME-INDEX,1).
  END.

  ON CURSOR-UP CURSOR-UP. ON CURSOR-DOWN CURSOR-DOWN.
  HIDE NO-PAUSE.

  DO WHILE qbf-module <> ?:
    IF      qbf-module = "Q" THEN RUN prores/q-main.p.
    ELSE IF qbf-module = "R" THEN RUN prores/r-main.p.
    ELSE IF qbf-module = "L" THEN RUN prores/l-main.p.
    ELSE IF qbf-module = "D" THEN RUN prores/d-main.p.
    ELSE IF qbf-module = "A" THEN RUN prores/a-main.p.
    ELSE IF qbf-module = "F" THEN DO:
      { prores/t-set.i &mod=r &set=4 }
      RUN prores/r-ft.p.
      qbf-module = "r".
    END.
    ELSE IF qbf-module = "U" THEN DO:
      qbf-module = ?.
      RUN VALUE(qbf-u-prog).
    END.
    ELSE IF qbf-module = "E" THEN DO:
      { prores/t-set.i &mod=a &set=1 }
      ASSIGN
        qbf-a = FALSE
        qbf-c = qbf-lang[14]
        SUBSTRING(qbf-c,INDEX(qbf-c,"~{1~}"),3) = qbf-product.
        /*Are you sure that you want to exit "{1}" now?*/
      RUN prores/s-box.p (INPUT-OUTPUT qbf-a,?,?,qbf-c).
      IF qbf-a THEN UNDO,LEAVE.
      qbf-module = ?.
    END.
  END.

END.

/* catch end-error case: */
IF qbf-a = ? THEN DO:
  ON CURSOR-UP CURSOR-UP.
  ON CURSOR-DOWN CURSOR-DOWN.
END.

HIDE FRAME qbf-main NO-PAUSE.

microqbf = FALSE.

RUN prores/a-init.p (FALSE,OUTPUT qbf-e).

PROPATH = qbf-p.

IF qbf-goodbye THEN
  QUIT.
ELSE
  RETURN "RETURN".
