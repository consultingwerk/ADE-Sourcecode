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
/* s-page.p - allows a user to page up and down in a physical file */

{ prores/s-system.i }
{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-f AS CHARACTER NO-UNDO. /* quoter'd file name */
DEFINE INPUT PARAMETER qbf-z AS INTEGER   NO-UNDO. /* starting seek position */
DEFINE INPUT PARAMETER qbf-e AS LOGICAL   NO-UNDO. /* hilite ** lines */

DEFINE VARIABLE qbf-a AS LOGICAL INITIAL FALSE NO-UNDO. /* scrap logical */
DEFINE VARIABLE qbf-b AS INTEGER               NO-UNDO. /* seek back */
DEFINE VARIABLE qbf-c AS CHARACTER             NO-UNDO. /* scrap char */
DEFINE VARIABLE qbf-d AS INTEGER               NO-UNDO. /* down */
DEFINE VARIABLE qbf-h AS INTEGER INITIAL     1 NO-UNDO. /* horizontal pos */
DEFINE VARIABLE qbf-l AS INTEGER               NO-UNDO. /* screen line */
DEFINE VARIABLE qbf-p AS INTEGER INITIAL     1 NO-UNDO. /* current page */
DEFINE VARIABLE qbf-q AS INTEGER               NO-UNDO. /* scrap integer */
DEFINE VARIABLE qbf-s AS INTEGER EXTENT   1024 NO-UNDO. /* page seek pos's */
DEFINE VARIABLE qbf-t AS CHARACTER             NO-UNDO. /* text from stream */
DEFINE VARIABLE qbf-w AS INTEGER INITIAL     1 NO-UNDO. /* width */

DEFINE STREAM qbf-io.

qbf-d = SCREEN-LINES - (IF qbf-module BEGINS "q" THEN 4 ELSE 3).

FORM
  qbf-t FORMAT "x(76)"
  WITH FRAME qbf-attr ATTR-SPACE NO-LABELS OVERLAY
  COLUMN 1 ROW (IF qbf-module BEGINS "q" THEN 3 ELSE 2) qbf-d DOWN.
FORM
  qbf-t FORMAT "x(78)"
  WITH FRAME qbf-none NO-ATTR-SPACE NO-LABELS OVERLAY
  COLUMN 1 ROW (IF qbf-module BEGINS "q" THEN 3 ELSE 2) qbf-d DOWN.

ASSIGN
  qbf-s    = ?
  qbf-s[1] = qbf-z. /* maybe we don't want to start at top-of-file */

INPUT STREAM qbf-io FROM VALUE(qbf-f) NO-ECHO.
DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  IMPORT STREAM qbf-io qbf-t.
END.
IF SEEK(qbf-io) = ? THEN RETURN. /* empty file or already at eof */

PAUSE 0.
IF qbf-e THEN
  DISPLAY "" @ qbf-t WITH FRAME qbf-attr.
ELSE
  DISPLAY "" @ qbf-t WITH FRAME qbf-none.
STATUS DEFAULT.

{ prores/t-set.i &mod=r &set=3 }

/*Press [CURSOR-UP] and [CURSOR-DOWN] to navigate, [END-ERROR] when done.*/
MESSAGE qbf-lang[16].

/* "Page" */
PUT SCREEN ROW SCREEN-LINES COLUMN 60 FILL("-",19). 
PUT SCREEN ROW SCREEN-LINES COLUMN 74 FILL(" ",5). 
PUT SCREEN ROW SCREEN-LINES COLUMN 74 - LENGTH(qbf-lang[17]) qbf-lang[17].

DO WHILE TRUE:

  SEEK STREAM qbf-io TO qbf-s[qbf-p].

  IF qbf-e THEN
    UP FRAME-LINE(qbf-attr) - 1 WITH FRAME qbf-attr.
  ELSE
    UP FRAME-LINE(qbf-none) - 1 WITH FRAME qbf-none.

  qbf-q = (IF qbf-s[qbf-p + 1] < 0 THEN - qbf-s[qbf-p + 1] ELSE qbf-d).

  DO qbf-l = 1 TO qbf-q ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
    qbf-b = SEEK(qbf-io).
    IMPORT STREAM qbf-io qbf-t.

    /* turn tabs into spaces */
    DO WHILE INDEX(qbf-t,CHR(9)) > 0:
      SUBSTRING(qbf-t,INDEX(qbf-t,CHR(9)),1) = " ".
    END.
    /* blow away cr's */
    DO WHILE INDEX(qbf-t,CHR(13)) > 0:
      SUBSTRING(qbf-t,INDEX(qbf-t,CHR(13)),1) = "".
    END.
    /* elegantly handle ff's */
    IF qbf-t BEGINS CHR(12) THEN DO:
      IF qbf-l > 1 THEN UNDO,LEAVE.
      qbf-t = SUBSTRING(qbf-t,2).
    END.

    qbf-c = (IF qbf-e AND qbf-t BEGINS "** " THEN "MESSAGES" ELSE "NORMAL").
    IF qbf-e THEN DO:
      DISPLAY SUBSTRING(qbf-t,qbf-h) @ qbf-t WITH FRAME qbf-attr.
      COLOR DISPLAY VALUE(qbf-c) qbf-t WITH FRAME qbf-attr.
    END.
    ELSE
    IF INPUT FRAME qbf-none qbf-t <> SUBSTRING(qbf-t,qbf-h) THEN
      DISPLAY SUBSTRING(qbf-t,qbf-h) @ qbf-t WITH FRAME qbf-none.

    qbf-w = MAXIMUM(qbf-w,LENGTH(qbf-t)).
    IF qbf-l < qbf-d THEN
      IF qbf-e THEN
        DOWN WITH FRAME qbf-attr.
      ELSE
        DOWN WITH FRAME qbf-none.
  END.

  /* This block handles checking to see if the next page is empty -
  meaning a ff ends the last page.  This keeps us from showing an extra
  blank screen at the end of the report. */
  IF SEEK(qbf-io) <> ? THEN DO:
    ASSIGN
      qbf-q = SEEK(qbf-io)
      qbf-c = "".
    REPEAT WHILE qbf-c = "":
      qbf-c = ?.
      IMPORT STREAM qbf-io qbf-c.
      IF qbf-c BEGINS CHR(12) THEN qbf-c = SUBSTRING(qbf-c,2).
    END.
    IF qbf-c = ? THEN
      qbf-b = 1 - qbf-l.
    ELSE
      SEEK STREAM qbf-io TO qbf-q.
  END.

  IF qbf-s[qbf-p + 1] = ? THEN
    qbf-s[qbf-p + 1] = (IF qbf-l > qbf-d THEN
                         SEEK(qbf-io)
                       ELSE IF qbf-t BEGINS CHR(12) THEN
                         qbf-b
                       ELSE
                         1 - qbf-l
                       ).

  IF seek(qbf-io) = ? THEN DO:
    /* This gets around PROGRESS' habit of closing */
    /* streams automatically when the eof is hit.  */
    INPUT STREAM qbf-io CLOSE.
    INPUT STREAM qbf-io FROM VALUE(qbf-f) NO-ECHO.
  END.

  /* "<<more/------" and "more>>/------" */
  PUT SCREEN ROW SCREEN-LINES COLUMN  3 STRING(qbf-h > 1,
    "<<" + qbf-lang[5] + "/" + FILL("-",LENGTH(qbf-lang[5]) + 2)).
  PUT SCREEN ROW SCREEN-LINES COLUMN 10 STRING(qbf-w - 77 > qbf-h,
    qbf-lang[5] + ">>" + "/" + FILL("-",LENGTH(qbf-lang[5]) + 2)).
  PUT SCREEN ROW SCREEN-LINES COLUMN 75 STRING(qbf-p,"ZZZZ").
  IF qbf-w > (IF qbf-e THEN 76 ELSE 78) AND NOT qbf-a THEN DO:
    qbf-a = TRUE.
    MESSAGE qbf-lang[7]. /*Use < and > to scroll report left/right*/
  END.

  /* if text doesn't full screen, clear empty lines below last displayed line */
  DO WHILE qbf-l <= qbf-d:
    IF qbf-e THEN DO WITH FRAME qbf-attr:
      COLOR DISPLAY NORMAL qbf-t.
      CLEAR NO-PAUSE.
      IF qbf-l < qbf-d THEN DOWN.
    END.
    ELSE DO WITH FRAME qbf-none:
      COLOR DISPLAY NORMAL qbf-t.
      CLEAR NO-PAUSE.
      IF qbf-l < qbf-d THEN DOWN.
    END.
    qbf-l = qbf-l + 1.
  END.

  /* actions initiated here */
  READKEY.
  qbf-c = KEYFUNCTION(LASTKEY).
  IF CAN-DO("*-DOWN,RETURN, ",qbf-c) AND qbf-s[qbf-p + 1] >= 0 AND qbf-p < 1023
    THEN qbf-p = qbf-p + 1.
  ELSE IF qbf-c MATCHES "*-UP" AND qbf-p > 1 THEN qbf-p = qbf-p - 1.
  ELSE IF qbf-c = "HELP" AND LENGTH(qbf-module) > 2 THEN RUN prores/applhelp.p.
  ELSE IF CAN-DO("MOVE,HOME",qbf-c) THEN ASSIGN qbf-p = 1 qbf-h = 1.
  ELSE IF CAN-DO("<,*-LEFT",qbf-c) AND qbf-h > 1 THEN qbf-h = qbf-h - 20.
  ELSE IF CAN-DO(">,*-RIGHT",qbf-c)
    AND qbf-h < qbf-w - (IF qbf-e THEN 75 ELSE 77)
    THEN qbf-h = qbf-h + 20.
  ELSE IF CAN-DO("GO,END-ERROR",qbf-c) THEN LEAVE.

END.

INPUT STREAM qbf-io CLOSE.
HIDE FRAME qbf-attr NO-PAUSE.
HIDE FRAME qbf-none NO-PAUSE.
HIDE MESSAGE NO-PAUSE.

{ prores/t-reset.i }
RETURN.
