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
/* u-print.p - user-supplied print driver */

DEFINE INPUT PARAMETER qbf-f AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-b AS CHARACTER EXTENT   500 NO-UNDO.
DEFINE VARIABLE qbf-d AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-l AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-m AS CHARACTER EXTENT     3 NO-UNDO.
DEFINE VARIABLE qbf-r AS INTEGER   INITIAL    1 NO-UNDO.
DEFINE VARIABLE qbf-s AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-t AS CHARACTER INITIAL   "" NO-UNDO.
DEFINE VARIABLE qbf-u AS INTEGER   INITIAL    1 NO-UNDO.
DEFINE VARIABLE qbf-w AS LOGICAL   INITIAL TRUE NO-UNDO.

FORM
  qbf-b[qbf-r] FORMAT "x(76)"
  WITH FRAME qbf-pick SCROLL 1 OVERLAY NO-LABELS
  qbf-d DOWN ROW 1 COLUMN 1 ATTR-SPACE.

FORM
  qbf-t FORMAT "x(76)"
  WITH FRAME qbf-type
  OVERLAY NO-LABELS ROW SCREEN-LINES - 2 COLUMN 1 ATTR-SPACE.

IF CAN-DO("UNIX,OS2",OPSYS) THEN
  OUTPUT THROUGH "quoter > _qbf2.d".
ELSE
  OUTPUT TO "_qbf1.d" NO-ECHO.
RUN VALUE(qbf-f).
OUTPUT CLOSE.
IF OPSYS = "MSDOS" THEN
  DOS SILENT "quoter _qbf1.d > _qbf2.d".
ELSE IF OPSYS = "VMS" THEN
  VMS SILENT "PROGRESS/TOOLS=QUOTER/OUTPUT=_qbf2.d _qbf1.d".
ELSE IF OPSYS = "BTOS" THEN
  BTOS OS-QUOTER "_qbf1.d" "_qbf2.d".
  /*BTOS SILENT "[Sys]<Dlc>Quoter.Run" Quoter "_qbf1.d > _qbf2.d".*/

INPUT FROM "_qbf2.d" NO-ECHO.
REPEAT WHILE qbf-u < 500:
  IMPORT qbf-b[qbf-u].
  IF qbf-b[qbf-u] BEGINS CHR(12) THEN
    qbf-b[qbf-u] = SUBSTRING(qbf-b[qbf-u],2).
  IF qbf-b[qbf-u] = "" THEN NEXT.
  qbf-u = qbf-u + 1.
END.
INPUT CLOSE.

ASSIGN
  qbf-m[1] = 'Browse with cursor or page keys; '
           + 'or type search string and press ['
           + KBLABEL("RETURN") + '].'
  qbf-m[2] = 'Use ['
           + (IF KBLABEL("CURSOR-UP") BEGINS "CTRL-"
             THEN 'CURSOR-UP' ELSE KBLABEL("CURSOR-UP"))
           + '] and ['
           + (IF KBLABEL("CURSOR-DOWN") BEGINS "CTRL-"
             THEN 'CURSOR-DOWN' ELSE KBLABEL("CURSOR-DOWN"))
           + '] to navigate, ['
           + KBLABEL("END-ERROR") + '] to exit.'
  qbf-d    = SCREEN-LINES - 5.

HIDE ALL NO-PAUSE.

MESSAGE STRING(qbf-m[2],"x(80)").
DISPLAY "" @ qbf-b[qbf-r] WITH FRAME qbf-pick.

DO WHILE TRUE:

  qbf-r = MINIMUM(qbf-u,MAXIMUM(qbf-r,1)).
  IF qbf-r < FRAME-LINE(qbf-pick) THEN
    DOWN qbf-r - FRAME-LINE(qbf-pick) WITH FRAME qbf-pick.

  DISPLAY (IF LENGTH(qbf-t) > 0 THEN qbf-t ELSE qbf-m[1]) @ qbf-t
    WITH FRAME qbf-type.

  IF qbf-w THEN DO:
    ASSIGN
      qbf-l = MAXIMUM(1,FRAME-LINE(qbf-pick))
      qbf-s = qbf-r - qbf-l + 1
      qbf-w = FALSE.
    UP qbf-l - 1 WITH FRAME qbf-pick.
    IF qbf-s < 1 THEN
      ASSIGN
        qbf-s = 1
        qbf-l = 1
        qbf-r = 1.
    DO qbf-j = qbf-s TO qbf-s + qbf-d - 1:
      IF qbf-j > qbf-u THEN
        CLEAR FRAME qbf-pick NO-PAUSE.
      ELSE
        DISPLAY qbf-b[qbf-j] @ qbf-b[qbf-r] WITH FRAME qbf-pick.
      IF qbf-j < qbf-s + qbf-d - 1 THEN DOWN WITH FRAME qbf-pick.
    END.
    UP qbf-d - qbf-l WITH FRAME qbf-pick.
  END.

  READKEY PAUSE 0.
  DISPLAY qbf-b[qbf-r] WITH FRAME qbf-pick.
  IF LASTKEY = -1 THEN DO:
    COLOR DISPLAY INPUT  qbf-b[qbf-r] WITH FRAME qbf-pick.
    READKEY.
    COLOR DISPLAY NORMAL qbf-b[qbf-r] WITH FRAME qbf-pick.
  END.

  IF (KEYFUNCTION(LASTKEY) = "BACKSPACE" AND LENGTH(qbf-t) > 0)
    OR (KEYFUNCTION(LASTKEY) = CHR(LASTKEY) AND LASTKEY >= 32) THEN DO:
    qbf-t = (IF KEYFUNCTION(LASTKEY) = "BACKSPACE"
            THEN SUBSTRING(qbf-t,1,LENGTH(qbf-t) - 1)
            ELSE qbf-t + CHR(LASTKEY)).
    NEXT.
  END.

  IF CAN-DO("GO,RETURN",KEYFUNCTION(LASTKEY)) AND qbf-t <> "" THEN DO:
    ASSIGN
      qbf-w = TRUE
      qbf-s = 0.
    DO qbf-j = qbf-r + 1 TO qbf-u WHILE qbf-s = 0:
      IF INDEX(qbf-b[qbf-j],qbf-t) > 0 THEN qbf-s = qbf-j.
    END.
    DO qbf-j = 1 TO qbf-r WHILE qbf-s = 0:
      IF INDEX(qbf-b[qbf-j],qbf-t) > 0 THEN qbf-s = qbf-j.
    END.
    ASSIGN
      qbf-j = (IF qbf-j <= qbf-u THEN qbf-j ELSE qbf-r)
      qbf-s = qbf-j - qbf-r + FRAME-LINE(qbf-pick)
      qbf-r = qbf-j.
    IF qbf-s < 1 OR qbf-s > qbf-d THEN
      qbf-w = TRUE.
    ELSE
      UP FRAME-LINE(qbf-pick) - qbf-s WITH FRAME qbf-pick.
    NEXT.
  END.

  qbf-t = "".
  IF CAN-DO("CURSOR-DOWN,RETURN",KEYFUNCTION(LASTKEY))
    AND qbf-r < qbf-u THEN DO:
    qbf-r = qbf-r + 1.
    IF FRAME-LINE(qbf-pick) = qbf-d THEN
      SCROLL UP WITH FRAME qbf-pick.
    ELSE
      DOWN WITH FRAME qbf-pick.
  END.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "CURSOR-UP" AND qbf-r > 1 THEN DO:
    qbf-r = qbf-r - 1.
    IF FRAME-LINE(qbf-pick) = 1 THEN
      SCROLL DOWN WITH FRAME qbf-pick.
    ELSE
      UP WITH FRAME qbf-pick.
  END.
  ELSE
  IF CAN-DO("GO,PAGE-DOWN,BOTTOM-COLUMN",KEYFUNCTION(LASTKEY)) THEN DO:
    ASSIGN
      qbf-r = qbf-r + qbf-d
      qbf-w = TRUE.
    IF qbf-r + qbf-d - FRAME-LINE(qbf-pick) > qbf-u THEN DO:
      qbf-r = qbf-u.
      DOWN MINIMUM(qbf-u,qbf-d) - FRAME-LINE(qbf-pick) WITH FRAME qbf-pick.
    END.
  END.
  ELSE
  IF CAN-DO("PAGE-UP,TOP-COLUMN",KEYFUNCTION(LASTKEY)) THEN
    ASSIGN
      qbf-r = qbf-r - qbf-d
      qbf-w = TRUE.
  ELSE
  IF CAN-DO("HOME,MOVE",KEYFUNCTION(LASTKEY)) THEN DO:
    ASSIGN
      qbf-r = (IF qbf-r > 1 THEN 1 ELSE qbf-u)
      qbf-w = TRUE.
    UP FRAME-LINE(qbf-pick) - (IF qbf-r = 1 THEN 1 ELSE qbf-d)
      WITH FRAME qbf-pick.
  END.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN LEAVE.

END.

HIDE FRAME qbf-pick NO-PAUSE.
HIDE FRAME qbf-type NO-PAUSE.
HIDE MESSAGE NO-PAUSE.

RETURN.
