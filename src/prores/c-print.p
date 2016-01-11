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
/* c-print.p - scrolling list of output devices */

{ prores/s-system.i }
{ prores/t-define.i }
{ prores/s-print.i }

DEFINE OUTPUT PARAMETER qbf-a AS LOGICAL INITIAL FALSE NO-UNDO.

/*local:*/
DEFINE VARIABLE qbf-d AS INTEGER                 NO-UNDO.
DEFINE VARIABLE qbf-f AS INTEGER                 NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER                 NO-UNDO.
DEFINE VARIABLE qbf-l AS INTEGER                 NO-UNDO.
DEFINE VARIABLE qbf-o AS INTEGER   INITIAL ?     NO-UNDO.
DEFINE VARIABLE qbf-r AS INTEGER                 NO-UNDO.
DEFINE VARIABLE qbf-s AS INTEGER                 NO-UNDO.
DEFINE VARIABLE qbf-t AS CHARACTER INITIAL ""    NO-UNDO.
DEFINE VARIABLE qbf-w AS LOGICAL   INITIAL TRUE  NO-UNDO.
DEFINE VARIABLE qbf-x AS INTEGER                 NO-UNDO.
DEFINE VARIABLE qbf-z AS CHARACTER               NO-UNDO.

/*forms:*/
FORM
  qbf-printer[qbf-r] FORMAT "x(32)"
  WITH FRAME qbf-pick SCROLL 1 OVERLAY NO-LABELS ATTR-SPACE
  qbf-d DOWN ROW 3 COLUMN 22
  COLOR DISPLAY VALUE(qbf-plo) PROMPT VALUE(qbf-phi)
  TITLE COLOR VALUE(qbf-plo) " " + qbf-lang[13] + " ".
    /*"Select Output Device"*/

FORM
  qbf-t FORMAT "x(32)"
  WITH FRAME qbf-type OVERLAY NO-LABELS ATTR-SPACE
  ROW qbf-d + 5 COLUMN 22
  COLOR DISPLAY VALUE(qbf-plo) PROMPT VALUE(qbf-phi).

FORM
  qbf-t FORMAT "x(48)"
    VALIDATE(qbf-t <> "" AND qbf-t <> ? AND KEYWORD(qbf-t) <> "TERMINAL",
    qbf-lang[23])
  /*Cannot use this option with specified output destination*/
  HEADER
  qbf-lang[24] FORMAT "x(50)" NO-ATTR-SPACE /*"Enter output filename"*/
  WITH FRAME qbf-file OVERLAY ATTR-SPACE ROW 7 CENTERED NO-LABELS
  COLOR DISPLAY VALUE(qbf-plo) PROMPT VALUE(qbf-phi).

qbf-pr-app = FALSE. /* immediately reset append flag */

IF qbf-printer# <= 0 THEN RETURN.

/* if only one printer device and it is type "prog", run automatically */
IF qbf-printer# = 1 AND qbf-pr-type[1] = "prog" THEN DO:
  ASSIGN
    qbf-a      = TRUE
    qbf-device = 1.
  RETURN.
END.

{ prores/t-set.i &mod=c &set=0 }

ASSIGN
  qbf-f = qbf-device
  qbf-r = 1
  qbf-d = SCREEN-LINES - 11.
IF qbf-f <> 0 AND qbf-f <> ? AND qbf-f <= qbf-printer# THEN
  ASSIGN
    qbf-o = MINIMUM(qbf-d,qbf-f)
    qbf-r = qbf-f.
ASSIGN
  qbf-d = MINIMUM(qbf-printer#,qbf-d)
  qbf-f = 0
  qbf-z = FILL("Z",LENGTH(STRING(qbf-printer#)))
  qbf-x = 56 - LENGTH(qbf-z).

PAUSE 0 BEFORE-HIDE.
VIEW FRAME qbf-pick.

PUT SCREEN ROW qbf-d + 4 COLUMN qbf-x COLOR VALUE(qbf-plo) STRING(qbf-printer#).
qbf-x = qbf-x - LENGTH(qbf-xofy) - 1.
PUT SCREEN ROW qbf-d + 4 COLUMN qbf-x COLOR VALUE(qbf-plo) qbf-xofy.
qbf-x = qbf-x - LENGTH(qbf-z) - 1.

DO WHILE TRUE:

  qbf-r = MINIMUM(qbf-printer#,MAXIMUM(qbf-r,1)).
  IF qbf-r < FRAME-LINE(qbf-pick) THEN
    DOWN qbf-r - FRAME-LINE(qbf-pick) WITH FRAME qbf-pick.

  IF LENGTH(qbf-t) > 0 THEN
    DISPLAY qbf-t WITH FRAME qbf-type.
  ELSE
    HIDE FRAME qbf-type NO-PAUSE.

  IF qbf-w THEN DO:
    ASSIGN
      qbf-l = MAXIMUM(1,FRAME-LINE(qbf-pick))
      qbf-s = qbf-r - (IF qbf-o = ? THEN qbf-l ELSE qbf-o) + 1.
    UP qbf-l - 1 WITH FRAME qbf-pick.
    IF qbf-s < 1 THEN
      ASSIGN
        qbf-s = 1
        qbf-l = 1
        qbf-r = 1.
    DO qbf-i = qbf-s TO qbf-s + qbf-d - 1:
      IF qbf-i > qbf-printer# THEN
        CLEAR FRAME qbf-pick NO-PAUSE.
      ELSE
        DISPLAY qbf-printer[qbf-i] @ qbf-printer[qbf-r] WITH FRAME qbf-pick.
      IF qbf-i < qbf-s + qbf-d - 1 THEN
        DOWN 1 WITH FRAME qbf-pick.
    END.
    qbf-l = (IF qbf-o = ? THEN qbf-l ELSE qbf-o).
    UP qbf-d - qbf-l WITH FRAME qbf-pick.
    ASSIGN
      qbf-o = ?
      qbf-w  = FALSE.
  END.

  DISPLAY qbf-printer[qbf-r] WITH FRAME qbf-pick.

  PUT SCREEN ROW qbf-d + 4 COLUMN qbf-x COLOR VALUE(qbf-plo)
    STRING(qbf-r,qbf-z).
  COLOR DISPLAY VALUE(qbf-phi) qbf-printer[qbf-r] WITH FRAME qbf-pick.
  READKEY.
  COLOR DISPLAY VALUE(qbf-plo) qbf-printer[qbf-r] WITH FRAME qbf-pick.

  IF (KEYFUNCTION(LASTKEY) = CHR(LASTKEY) AND LASTKEY >= 32)
    OR (KEYFUNCTION(LASTKEY) = "BACKSPACE" AND LENGTH(qbf-t) > 0) THEN DO:
    qbf-t = (IF KEYFUNCTION(LASTKEY) = "BACKSPACE"
            THEN SUBSTRING(qbf-t,1,LENGTH(qbf-t) - 1)
            ELSE qbf-t + CHR(LASTKEY)).
    IF qbf-t = "" OR qbf-printer[qbf-r] BEGINS qbf-t THEN NEXT.
    DO qbf-l = qbf-r TO qbf-printer#:
      IF qbf-printer[qbf-l] BEGINS qbf-t THEN LEAVE.
    END.
    IF qbf-l > qbf-printer# THEN DO:
      DO qbf-l = 1 TO qbf-r:
        IF qbf-printer[qbf-l] BEGINS qbf-t THEN LEAVE.
      END.
      IF qbf-l > qbf-r THEN qbf-l = qbf-printer# + 1.
    END.
    IF qbf-l > qbf-printer# THEN DO:
      qbf-t = CHR(LASTKEY).
      DO qbf-l = 1 TO qbf-printer#:
        IF qbf-printer[qbf-l] BEGINS qbf-t THEN LEAVE.
      END.
    END.
    ASSIGN
      qbf-l = (IF qbf-l <= qbf-printer# THEN qbf-l ELSE qbf-r)
      qbf-s = qbf-l - qbf-r + FRAME-LINE(qbf-pick)
      qbf-r = qbf-l.
    IF qbf-s < 1 OR qbf-s > qbf-d THEN
      qbf-w = TRUE.
    ELSE
      UP FRAME-LINE(qbf-pick) - qbf-s WITH FRAME qbf-pick.
    NEXT.
  END.

  qbf-t = "".
  IF CAN-DO("CURSOR-DOWN,TAB",KEYFUNCTION(LASTKEY))
    AND qbf-r < qbf-printer# THEN DO:
    qbf-r = qbf-r + 1.
    IF FRAME-LINE(qbf-pick) = FRAME-DOWN(qbf-pick) THEN
      SCROLL UP WITH FRAME qbf-pick.
    ELSE
      DOWN WITH FRAME qbf-pick.
  END.
  ELSE
  IF CAN-DO("CURSOR-UP,BACK-TAB",KEYFUNCTION(LASTKEY)) AND qbf-r > 1 THEN DO:
    qbf-r = qbf-r - 1.
    IF FRAME-LINE(qbf-pick) = 1 THEN
      SCROLL DOWN WITH FRAME qbf-pick.
    ELSE
      UP WITH FRAME qbf-pick.
  END.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "PAGE-DOWN" THEN DO:
    ASSIGN
      qbf-r = qbf-r + qbf-d
      qbf-w = TRUE.
    IF qbf-r + qbf-d - FRAME-LINE(qbf-pick) > qbf-printer# THEN DO:
      qbf-r = qbf-printer#.
      DOWN MINIMUM(qbf-printer#,qbf-d) - FRAME-LINE(qbf-pick)
        WITH FRAME qbf-pick.
    END.
  END.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "PAGE-UP" THEN
    ASSIGN
      qbf-r = qbf-r - qbf-d
      qbf-w = TRUE.
  ELSE
  IF CAN-DO("HOME,MOVE",KEYFUNCTION(LASTKEY)) THEN DO:
    ASSIGN
      qbf-r = (IF qbf-r > 1 THEN 1 ELSE qbf-printer#)
      qbf-w = TRUE.
    UP FRAME-LINE(qbf-pick) - (IF qbf-r = 1 THEN 1 ELSE qbf-d)
      WITH FRAME qbf-pick.
  END.
  ELSE
  IF CAN-DO("GO,RETURN",KEYFUNCTION(LASTKEY)) THEN DO:
    ASSIGN
      qbf-a      = TRUE
      qbf-device = qbf-r.
    IF qbf-pr-type[qbf-device] = "file" THEN DO:
      ASSIGN
        qbf-t = (IF qbf-module = "r" THEN "report.txt"
            ELSE IF qbf-module = "l" THEN "label.txt"
            ELSE IF qbf-module = "d" THEN "export.txt"
            ELSE "").
        qbf-a = (qbf-t = "").
      IF NOT qbf-a THEN DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
        UPDATE qbf-t WITH FRAME qbf-file.
        ASSIGN
          qbf-a                  = TRUE
          qbf-pr-dev[qbf-device] = qbf-t.
        IF SEARCH(qbf-t) <> ? THEN /* Append to existing file? */
          RUN prores/s-box.p (INPUT-OUTPUT qbf-pr-app,?,?,"#22").
      END.
    END.
    LEAVE.
  END.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN LEAVE.

END.

HIDE FRAME qbf-pick NO-PAUSE.
HIDE FRAME qbf-type NO-PAUSE.
HIDE FRAME qbf-file NO-PAUSE.
PAUSE BEFORE-HIDE.

{ prores/t-reset.i }
RETURN.
