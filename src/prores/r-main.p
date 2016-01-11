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
/* r-main.p - Report Writer module main procedure */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/s-print.i }
{ prores/r-define.i NEW }
{ prores/t-define.i }
{ prores/s-menu.i }
{ prores/t-set.i &mod=r &set=3 }

DEFINE VARIABLE qbf#  AS INTEGER INITIAL    ? NO-UNDO. /* action */
DEFINE VARIABLE qbf-h AS INTEGER INITIAL    1 NO-UNDO. /* horz offset */
DEFINE VARIABLE qbf-w AS LOGICAL INITIAL TRUE NO-UNDO. /* redraw */

/*scrap*/
DEFINE VARIABLE qbf-a AS LOGICAL              NO-UNDO.
DEFINE VARIABLE qbf-b AS LOGICAL              NO-UNDO.
DEFINE VARIABLE qbf-c AS CHARACTER            NO-UNDO.
DEFINE VARIABLE qbf-d AS LOGICAL INITIAL TRUE NO-UNDO. /* qbf# redraw flag */
DEFINE VARIABLE qbf-e AS DECIMAL   DECIMALS 3 NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER              NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER              NO-UNDO.
DEFINE VARIABLE qbf-m AS CHARACTER EXTENT   6 NO-UNDO.
DEFINE VARIABLE qbf-o AS INTEGER              NO-UNDO. /* qbf# old value */
DEFINE VARIABLE qbf-s AS CHARACTER            NO-UNDO.
DEFINE VARIABLE qbf-t AS CHARACTER            NO-UNDO.

{ prores/s-top.i NEW } /* definition for qbf-top frame */

FORM
  qbf-layout[ 1] FORMAT "x(78)" SKIP
  qbf-layout[ 2] FORMAT "x(78)" SKIP
  qbf-layout[ 3] FORMAT "x(78)" SKIP
  qbf-layout[ 4] FORMAT "x(78)" SKIP
  qbf-layout[ 5] FORMAT "x(78)" SKIP
  qbf-layout[ 6] FORMAT "x(78)" SKIP
  qbf-layout[ 7] FORMAT "x(78)" SKIP
  qbf-layout[ 8] FORMAT "x(78)" SKIP
  qbf-layout[ 9] FORMAT "x(78)" SKIP
  qbf-layout[10] FORMAT "x(78)" SKIP
  WITH FRAME r-bottom ROW 10 COLUMN 1 WIDTH 80 NO-LABELS NO-ATTR-SPACE
  TITLE COLOR NORMAL " " + qbf-lang[4] + " ". /*Report Layout*/

HIDE ALL NO-PAUSE.
PAUSE 0.

DISPLAY
  ENTRY(1,qbf-lang[1]) @ qbf-m[1]
  ENTRY(2,qbf-lang[1]) @ qbf-m[2]
  ENTRY(3,qbf-lang[1]) @ qbf-m[3]
  ENTRY(4,qbf-lang[1]) @ qbf-m[4]
  ENTRY(5,qbf-lang[1]) @ qbf-m[5]
  qbf-lang[2]          @ qbf-m[6]
  WITH FRAME qbf-top.

DO WHILE TRUE:

  { prores/t-set.i &mod=r &set=3 }
  VIEW FRAME qbf-top.
  VIEW FRAME r-bottom.

  ASSIGN /*                              1234567890 1234567890*/
    qbf-m-aok = STRING(qbf-file[1] = "","ynyyynnyny/yyyyyyyyyy")
              + STRING(qbf-user,"y/n") + "y"
    qbf-d     = TRUE.

  IF qbf-w OR qbf-rcw[1] = ? THEN DO: /* redraw */
    ASSIGN
      qbf-i = qbf-r-size
      qbf-w = FALSE
      qbf-a = FALSE.
    RUN prores/s-ask.p (INPUT-OUTPUT qbf-a).
    RUN prores/r-draw.p. /* build qbf-layout[] */
    ASSIGN
      qbf-h = (IF qbf-r-size = qbf-i THEN qbf-h ELSE 1)
      qbf-c = "".
    DO qbf-i = 1 TO 5 WHILE qbf-order[qbf-i] <> "":
      qbf-c = qbf-c + "BY " + qbf-order[qbf-i] + " ".
    END.
    IF LENGTH(qbf-c) > 70 THEN SUBSTRING(qbf-c,68,3) = "...".
    DISPLAY { prores/s-draw.i } qbf-c WITH FRAME qbf-top.

    DISPLAY
      SUBSTRING(qbf-layout[ 1],qbf-h) @ qbf-layout[ 1]
      SUBSTRING(qbf-layout[ 2],qbf-h) @ qbf-layout[ 2]
      SUBSTRING(qbf-layout[ 3],qbf-h) @ qbf-layout[ 3]
      SUBSTRING(qbf-layout[ 4],qbf-h) @ qbf-layout[ 4]
      SUBSTRING(qbf-layout[ 5],qbf-h) @ qbf-layout[ 5]
      SUBSTRING(qbf-layout[ 6],qbf-h) @ qbf-layout[ 6]
      SUBSTRING(qbf-layout[ 7],qbf-h) @ qbf-layout[ 7]
      SUBSTRING(qbf-layout[ 8],qbf-h) @ qbf-layout[ 8]
      SUBSTRING(qbf-layout[ 9],qbf-h) @ qbf-layout[ 9]
      SUBSTRING(qbf-layout[10],qbf-h) @ qbf-layout[10]
      WITH FRAME r-bottom.
    IF qbf-r-size <= 78 THEN HIDE MESSAGE NO-PAUSE.
  END.

  PUT SCREEN ROW 9 COLUMN 79 - LENGTH(qbf-lang[21]) /*"Totals Only"*/
    STRING(qbf-r-attr[8] = 1,
    qbf-lang[21] + "/" + FILL("-",LENGTH(qbf-lang[21]))).
  /* "<<more/------" and "more>>/------" */
  PUT SCREEN ROW 21 COLUMN  3 STRING(qbf-h > 1,
    "<<" + qbf-lang[5] + "/" + FILL("-",LENGTH(qbf-lang[5]) + 2)).
  PUT SCREEN ROW 21 COLUMN 10 STRING(qbf-r-size - qbf-h > 77,
    qbf-lang[5] + ">>/" + FILL("-",LENGTH(qbf-lang[5]) + 2)).

  /* "Report,Width" */
  qbf-j = 75 - LENGTH(qbf-lang[6]).
  DO qbf-i = 1 TO NUM-ENTRIES(qbf-lang[6]):
    PUT SCREEN ROW 21 COLUMN qbf-j ENTRY(qbf-i,qbf-lang[6]).
    qbf-j = qbf-j + 1 + LENGTH(ENTRY(qbf-i,qbf-lang[6])).
  END.

  PUT SCREEN ROW 21 COLUMN 76 STRING(qbf-r-size,"ZZ9").
  IF qbf-r-size > 78 THEN MESSAGE STRING(qbf-lang[7],"x(80)").
    /*"Use < and > to scroll report left/right"*/

  IF qbf# = ? THEN
    RUN prores/s-menu.p
      (INPUT-OUTPUT qbf#,INPUT-OUTPUT qbf-o,INPUT-OUTPUT qbf-d).

  /*HIDE MESSAGE NO-PAUSE.*/

  IF qbf# = 2 OR qbf# = 3 THEN DO:
    qbf-c = ?.
    IF qbf-file[1] <> "" AND qbf-rcn[1] = "" THEN qbf-c = "#23".
    ELSE
    IF qbf-r-size > 255 THEN qbf-c = "#8".
    ELSE
    IF qbf-r-attr[8] = 0 THEN .
    ELSE
    IF qbf-order[1] = "" THEN qbf-c = "#19".
    ELSE DO qbf-j = 1 TO qbf-rc# WHILE qbf-c = ?:
      IF qbf-rcc[qbf-j] BEGINS "e" THEN qbf-c = "#20".
    END.
    IF qbf-c <> ? THEN DO:
      /*
      8:  Sorry, cannot generate report with width of more than 255
          characters
      19: Sorry, cannot generate a Totals Only report when no order-by
          fields are defined.
      20: Sorry, cannot generate a Totals Only report with stacked-array
          fields defined.
      23: Sorry, cannot generate a report with no fields defined.
      */
      RUN prores/s-error.p (qbf-c).
      qbf# = ?.
      NEXT.
    END.
  END.

  /*------------------------------------------------------------------- Get */
  IF qbf# = 1 THEN DO:
    qbf-a = qbf-file[1] = "".
    IF NOT qbf-a THEN
      RUN prores/s-box.p (INPUT-OUTPUT qbf-a,?,?,"#9").
    /*You did not clear the current report.  Do you still want to continue?*/
    IF qbf-a THEN 
      RUN prores/i-dir.p ("r",TRUE).
    qbf-w = TRUE.
  END.
  ELSE
  /*-------------------------------------------------------------------- Put */
  IF qbf# = 2 THEN
    RUN prores/i-dir.p ("r",FALSE).
  ELSE
  /*-------------------------------------------------------------------- Run */
  IF qbf# = 3 THEN DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
    IF qbf-file[1] = "" THEN DO:
      qbf-w = TRUE.
      RUN prores/i-dir.p ("r",TRUE).
      IF qbf-file[1] = "" THEN UNDO,LEAVE.
      NEXT.
    END.

    PAUSE 0.
    qbf-a = TRUE.
    RUN prores/s-ask.p (INPUT-OUTPUT qbf-a).
    IF NOT qbf-a THEN UNDO,LEAVE.
    RUN prores/c-print.p (OUTPUT qbf-a).
    IF NOT qbf-a THEN UNDO,LEAVE.
    PAUSE 0 BEFORE-HIDE.
    MESSAGE qbf-lang[10]. /*Generating program...*/
    RUN prores/r-write.p (qbf-tempdir).
    HIDE MESSAGE.
    MESSAGE qbf-lang[11]. /*Compiling generated program...*/
    COMPILE VALUE(qbf-tempdir + ".p").
    HIDE MESSAGE.
    ASSIGN
      qbf-c     = ?
      qbf-total = 0
      qbf-a     = TRUE
      qbf-b     = qbf-pr-type[qbf-device] = "term".
    DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
      IF qbf-b THEN DO:
        qbf-c = (IF qbf-pr-dev[qbf-device] = TERMINAL THEN ? ELSE TERMINAL).
        HIDE ALL.
        IF qbf-c <> ? THEN TERMINAL = qbf-pr-dev[qbf-device].
        OUTPUT TO TERMINAL PAGED.
        PAUSE BEFORE-HIDE.
        qbf-e = { prores/s-etime.i }.
        RUN VALUE(qbf-tempdir + ".p").
        qbf-e = ({ prores/s-etime.i } - qbf-e) * .001.
      END.
      ELSE DO:
        MESSAGE qbf-lang[12]. /*Running generated program...*/
        qbf-i = (IF qbf-pr-type[qbf-device] = "page" THEN SCREEN-LINES - 3
                ELSE qbf-r-attr[2]).
        IF qbf-pr-type[qbf-device] = "thru" THEN
          OUTPUT THROUGH VALUE(qbf-pr-dev[qbf-device])
            PAGED PAGE-SIZE VALUE(qbf-i).
        ELSE IF CAN-DO("view,page",qbf-pr-type[qbf-device]) THEN
          OUTPUT TO VALUE(qbf-tempdir + ".d") PAGED PAGE-SIZE VALUE(qbf-i).
        ELSE IF qbf-pr-app THEN
          OUTPUT TO VALUE(qbf-pr-dev[qbf-device])
            PAGED PAGE-SIZE VALUE(qbf-i) APPEND.
        ELSE IF qbf-pr-type[qbf-device] <> "prog" THEN
          OUTPUT TO VALUE(qbf-pr-dev[qbf-device]) PAGED PAGE-SIZE VALUE(qbf-i).
        RUN prores/s-print.p (1). /* output init string */
        PAUSE BEFORE-HIDE.
        qbf-e = { prores/s-etime.i }.
        IF qbf-pr-type[qbf-device] = "prog" THEN
          RUN VALUE(qbf-pr-dev[qbf-device]) (qbf-tempdir + ".p").
        ELSE
          RUN VALUE(qbf-tempdir + ".p").
        qbf-e = ({ prores/s-etime.i } - qbf-e) * .001.
      END.
      qbf-a = FALSE.
      IF qbf-pr-type[qbf-device] = "view" THEN DO:
        PAUSE 0 BEFORE-HIDE.
        OUTPUT CLOSE.
        HIDE ALL.
        qbf-t = qbf-pr-dev[qbf-device] + " " + qbf-tempdir + ".d".
        IF      OPSYS = "BTOS"  THEN BTOS VALUE(qbf-t).
        ELSE IF OPSYS = "MSDOS" THEN DOS  VALUE(qbf-t).
        ELSE IF OPSYS = "OS2"   THEN OS2  VALUE(qbf-t).
        ELSE IF OPSYS = "UNIX"  THEN UNIX VALUE(qbf-t).
        ELSE IF OPSYS = "VMS"   THEN VMS  VALUE(qbf-t).
      END.
      IF qbf-pr-type[qbf-device] = "page" THEN DO:
        OUTPUT CLOSE.
        RUN prores/s-quoter.p
          (qbf-tempdir + ".d",qbf-tempdir + "1.d").
        PUT SCREEN ROW 1 COLUMN 1 FILL(" ",80).
        RUN prores/s-page.p (qbf-tempdir + "1.d",0,FALSE).
      END.
    END.
    PAUSE BEFORE-HIDE.
    OUTPUT CLOSE.
    IF CAN-DO("term,view,prog",qbf-pr-type[qbf-device]) THEN DO:
      HIDE ALL NO-PAUSE.
      IF qbf-c <> ? THEN TERMINAL = qbf-c.
    END.
    ELSE
      HIDE MESSAGE NO-PAUSE.
    IF qbf-a THEN DO:
      /*Could not write to file or device*/
      RUN prores/s-error.p
        (qbf-lang[13] + ' "' + qbf-pr-dev[qbf-device] + '"').
    END.
    ELSE
    IF qbf-pr-type[qbf-device] <> "term" THEN DO:
      ASSIGN
        qbf-i    = TRUNCATE(qbf-e,0)
        qbf-c    = qbf-lang[18] /* {1} records included in report */
        qbf-time = STRING(TRUNCATE(qbf-e / 60,0)) + ":"
                 + STRING(qbf-i MODULO 60,"99")
                 + (IF qbf-i = qbf-e THEN "" ELSE STRING(qbf-e - qbf-i))
        SUBSTRING(qbf-c,INDEX(qbf-c,"~{1~}"),3) = STRING(qbf-total).
      MESSAGE COLOR VALUE(IF qbf-total > 0 THEN "NORMAL" ELSE "MESSAGES") qbf-c.
    END.
  END.
  ELSE
  /*---------------------------------------------------------------- Define */
  IF qbf# = 4 THEN DO:
    qbf-w = TRUE.
    RUN prores/s-define.p.
  END.
  ELSE
  /*-------------------------------------------------------------- Settings */
  IF qbf# = 5 THEN DO:
    qbf-w = TRUE.
    RUN prores/r-set.p (TRUE).
  END.
  ELSE
  /*----------------------------------------------------------------- Where */
  IF qbf# = 6 THEN DO:
    qbf-w = TRUE.
    RUN prores/r-where.p.
  END.
  ELSE
  /*----------------------------------------------------------------- Order */
  IF qbf# = 7 THEN DO:
    qbf-w = TRUE.
    RUN prores/s-order.p.
  END.
  ELSE
  /*----------------------------------------------------------------- Clear */
  IF qbf# = 8 THEN DO:
    ASSIGN
      qbf-w = TRUE
      qbf-a = qbf-file[1] = "".
    IF qbf-a THEN
      RUN prores/i-zap.p ("r").
    ELSE
      RUN prores/s-box.p (INPUT-OUTPUT qbf-a,?,?,"#14").
      /*Are you sure you want to clear the current report definition?*/
    IF qbf-a THEN 
      RUN prores/s-zap.p.
  END.
  ELSE
  /*------------------------------------------------------------------ Info */
  IF qbf# = 9 THEN
    RUN prores/s-info.p ("r").
  ELSE
  /*---------------------------------------------------------------- Module */
  IF qbf# = 10 THEN DO:
    RUN prores/s-module.p ("r",OUTPUT qbf-c).
    IF qbf-c <> ? THEN DO:
      qbf-module = qbf-c.
      LEAVE.
    END.
  END.
  ELSE
  /*------------------------------------------------------------------ User */
  IF qbf# = 11 THEN DO:
    qbf-module = "r".
    RUN VALUE(qbf-u-prog).
    IF qbf-module <> "r" THEN LEAVE.
  END.
  ELSE
  /*-------------------------------------------------------------- H-Scroll */
  IF qbf# = 13 OR qbf# = 14 THEN DO:
    /* the display was split up to shrink the amount of -l space needed */
    ASSIGN
      qbf-i    = qbf-h + (IF qbf# = 13 THEN -16 ELSE 16)
      qbf-h    = (IF qbf-i < 1 OR qbf-r-size - qbf-i < 62
                 THEN qbf-h ELSE qbf-i)
      qbf-m[1] = SUBSTRING(qbf-layout[1],qbf-h)
      qbf-m[2] = SUBSTRING(qbf-layout[2],qbf-h)
      qbf-m[3] = SUBSTRING(qbf-layout[3],qbf-h)
      qbf-m[4] = SUBSTRING(qbf-layout[4],qbf-h)
      qbf-m[5] = SUBSTRING(qbf-layout[5],qbf-h).
    DISPLAY
      qbf-m[1] WHEN qbf-m[1] <> INPUT qbf-layout[1] @ qbf-layout[1]
      qbf-m[2] WHEN qbf-m[2] <> INPUT qbf-layout[2] @ qbf-layout[2]
      qbf-m[3] WHEN qbf-m[3] <> INPUT qbf-layout[3] @ qbf-layout[3]
      qbf-m[4] WHEN qbf-m[4] <> INPUT qbf-layout[4] @ qbf-layout[4]
      qbf-m[5] WHEN qbf-m[5] <> INPUT qbf-layout[5] @ qbf-layout[5]
      WITH FRAME r-bottom.
    ASSIGN
      qbf-m[1] = SUBSTRING(qbf-layout[ 6],qbf-h)
      qbf-m[2] = SUBSTRING(qbf-layout[ 7],qbf-h)
      qbf-m[3] = SUBSTRING(qbf-layout[ 8],qbf-h)
      qbf-m[4] = SUBSTRING(qbf-layout[ 9],qbf-h)
      qbf-m[5] = SUBSTRING(qbf-layout[10],qbf-h).
    DISPLAY
      qbf-m[1] WHEN qbf-m[1] <> INPUT qbf-layout[ 6] @ qbf-layout[ 6]
      qbf-m[2] WHEN qbf-m[2] <> INPUT qbf-layout[ 7] @ qbf-layout[ 7]
      qbf-m[3] WHEN qbf-m[3] <> INPUT qbf-layout[ 8] @ qbf-layout[ 8]
      qbf-m[4] WHEN qbf-m[4] <> INPUT qbf-layout[ 9] @ qbf-layout[ 9]
      qbf-m[5] WHEN qbf-m[5] <> INPUT qbf-layout[10] @ qbf-layout[10]
      WITH FRAME r-bottom.
  END.
  ELSE
  /*------------------------------------------------------------------ Exit */
  IF qbf# = 12 THEN DO:
    qbf-a = qbf-file[1] = "".
    IF NOT qbf-a THEN 
      RUN prores/s-box.p (INPUT-OUTPUT qbf-a,?,?,"#15").
      /*"Are you sure you want to exit this module?"*/
    IF qbf-a THEN DO:
      ASSIGN
        qbf-time   = ""
        qbf-module = ?.
      LEAVE.
    END.
  END.

  PAUSE BEFORE-HIDE.
  ASSIGN
    qbf#       = ?
    qbf-module = "r".

END.

HIDE FRAME qbf-top  NO-PAUSE.
HIDE FRAME r-bottom NO-PAUSE.
PUT SCREEN ROW 1 COLUMN 1 FILL(" ",80).
HIDE MESSAGE NO-PAUSE.
{ prores/t-reset.i }
RETURN.
