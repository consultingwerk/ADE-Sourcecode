/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* s-help.p - does help for results */

{ prores/s-system.i }
{ prores/t-define.i }

DEFINE VARIABLE qbf-f AS CHARACTER           NO-UNDO. /* frame-value */
DEFINE VARIABLE qbf-i AS INTEGER   INITIAL 0 NO-UNDO. /* seek index */
DEFINE VARIABLE qbf-m AS CHARACTER           NO-UNDO. /* module */
DEFINE VARIABLE qbf-q AS CHARACTER           NO-UNDO. /* t-q-???.h location */
DEFINE VARIABLE qbf-s AS CHARACTER           NO-UNDO. /* t-s-???.h location */
DEFINE VARIABLE qbf-t AS CHARACTER EXTENT 18 NO-UNDO. /* text */

ASSIGN
  qbf-q = SEARCH("prores/reslang/t-q-" + qbf-langset + ".h")
  qbf-s = SEARCH("prores/reslang/t-s-" + qbf-langset + ".h").

/* translate location into qbf-m, which is index into help system */
ASSIGN
  qbf-m = qbf-module
  qbf-f = TRIM(FRAME-VALUE).
IF qbf-m BEGINS "where,"        THEN qbf-m = "w3s".
ELSE IF qbf-m BEGINS "browse,"  THEN qbf-m = "q10s".
ELSE IF qbf-m = "a"             THEN qbf-m = "a" + STRING(FRAME-INDEX).
ELSE IF qbf-m = "e"             THEN DO: { prores/t-set.i &mod=a &set=1 } END.
ELSE IF qbf-m = "l4s"           THEN DO: { prores/t-set.i &mod=l &set=2 } END.
ELSE IF qbf-m = "r5s"           THEN DO: { prores/t-set.i &mod=r &set=2 } END.
ELSE IF CAN-DO("d4s,r4s",qbf-m) THEN DO: { prores/t-set.i &mod=s &set=4 } END.

IF CAN-DO("d4s,e,l4s,r4s,r5s",qbf-m) THEN
  DO qbf-i = 1 TO 32:
    IF qbf-f = qbf-lang[qbf-i] THEN LEAVE.
  END.
IF qbf-i > 0 AND qbf-i < 33 THEN qbf-m = qbf-m + STRING(qbf-i).

/*
assign
  qbf-t[1] = "qbf-module =[" + qbf-module + "]"
  qbf-t[2] = "db.fil.fld =[" + frame-db + "." + frame-file + "."
           + frame-field + "]"
  qbf-t[3] = "frame-value=[" + frame-value + "]".
  qbf-t[4] = "frame-index=[" + string(frame-index) + "]".
do qbf-i = 1 to 14 while program-name(qbf-i) <> ?:
  qbf-t[qbf-i + 4] = "  #" + string(qbf-i) + " " + program-name(qbf-i).
end.

find reshelp where reshelp.cat = qbf-m no-error.
if available reshelp then assign
  qbf-t[ 1] = reshelp.words[ 1] qbf-t[ 2] = reshelp.words[ 2]
  qbf-t[ 3] = reshelp.words[ 3] qbf-t[ 4] = reshelp.words[ 4]
  qbf-t[ 5] = reshelp.words[ 5] qbf-t[ 6] = reshelp.words[ 6]
  qbf-t[ 7] = reshelp.words[ 7] qbf-t[ 8] = reshelp.words[ 8]
  qbf-t[ 9] = reshelp.words[ 9] qbf-t[10] = reshelp.words[10]
  qbf-t[11] = reshelp.words[11] qbf-t[12] = reshelp.words[12]
  qbf-t[13] = reshelp.words[13] qbf-t[14] = reshelp.words[14]
  qbf-t[15] = reshelp.words[15] qbf-t[16] = reshelp.words[16]
  qbf-t[17] = reshelp.words[17] qbf-t[18] = reshelp.words[18].
*/

qbf-f = "".
INPUT FROM VALUE(qbf-q) NO-ECHO.
REPEAT WHILE qbf-f <> qbf-m:
  qbf-f = "*".
  IMPORT qbf-f qbf-i.
END.
IF qbf-f = "*" THEN DO:
  { prores/t-set.i &mod=s &set=4 }
  ASSIGN
    qbf-t[4] = FILL("-",LENGTH(qbf-lang[1]))
    qbf-t[5] = qbf-lang[1] /*Sorry, no help is yet available for this option.*/
    qbf-t[6] = qbf-t[4].
END.
ELSE DO:
  INPUT CLOSE.
  INPUT FROM VALUE(qbf-s) NO-ECHO.
  SEEK INPUT TO qbf-i.
  qbf-f = "".
  DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
    IMPORT qbf-f qbf-t.
  END.
  INPUT CLOSE.
  IF qbf-f <> qbf-m THEN DO:
    /* something is out of sync here!  attempt to fix up q-help.h */
    INPUT FROM VALUE(qbf-s) NO-ECHO.
    OUTPUT TO  VALUE(qbf-q) NO-ECHO.
    REPEAT:
      qbf-i = SEEK(INPUT).
      IMPORT qbf-f.
      IF qbf-f = qbf-m THEN DO:
        /* while we are at it, get the help text */
        SEEK INPUT TO qbf-i.
        IMPORT qbf-f qbf-t.
      END.
      EXPORT qbf-f qbf-i.
    END.
    INPUT CLOSE.
    OUTPUT CLOSE.
  END.
END.

{ prores/t-set.i &mod=s &set=4 }
qbf-i = (IF SCREEN-LINES = 21 THEN 2 ELSE 3).
PAUSE 0.
DISPLAY
  qbf-t[ 1] FORMAT "x(76)" SKIP  qbf-t[ 2] FORMAT "x(76)" SKIP
  qbf-t[ 3] FORMAT "x(76)" SKIP  qbf-t[ 4] FORMAT "x(76)" SKIP
  qbf-t[ 5] FORMAT "x(76)" SKIP  qbf-t[ 6] FORMAT "x(76)" SKIP
  qbf-t[ 7] FORMAT "x(76)" SKIP  qbf-t[ 8] FORMAT "x(76)" SKIP
  qbf-t[ 9] FORMAT "x(76)" SKIP  qbf-t[10] FORMAT "x(76)" SKIP
  qbf-t[11] FORMAT "x(76)" SKIP  qbf-t[12] FORMAT "x(76)" SKIP
  qbf-t[13] FORMAT "x(76)" SKIP  qbf-t[14] FORMAT "x(76)" SKIP
  qbf-t[15] FORMAT "x(76)" SKIP  qbf-t[16] FORMAT "x(76)" SKIP
  qbf-t[17] FORMAT "x(76)" SKIP  qbf-t[18] FORMAT "x(76)" SKIP
  WITH FRAME qbf-help COLUMN 1 ROW qbf-i NO-LABELS ATTR-SPACE OVERLAY.
PUT SCREEN ROW qbf-i COLUMN 3 COLOR MESSAGES " " + qbf-product + " ".
PUT SCREEN ROW qbf-i COLUMN 77 - LENGTH(qbf-lang[2])
  COLOR MESSAGES " " + qbf-lang[2] + " ". /*"Help"*/
DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  PAUSE.
END.

{ prores/t-reset.i }
HIDE FRAME qbf-help NO-PAUSE.
RETURN.
