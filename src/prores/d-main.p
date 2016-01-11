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
/* d-main.p - Data Export module main procedure */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/s-print.i }
{ prores/t-define.i }
{ prores/s-menu.i }
{ prores/t-set.i &mod=d &set=2 }

DEFINE VARIABLE qbf#  AS INTEGER  INITIAL    ? NO-UNDO.
DEFINE VARIABLE qbf-a AS LOGICAL               NO-UNDO.
DEFINE VARIABLE qbf-b AS LOGICAL               NO-UNDO.
DEFINE VARIABLE qbf-c AS CHARACTER             NO-UNDO.
DEFINE VARIABLE qbf-d AS LOGICAL  INITIAL TRUE NO-UNDO. /* qbf# redraw flag */
DEFINE VARIABLE qbf-e AS DECIMAL  DECIMALS   3 NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER               NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER               NO-UNDO.
DEFINE VARIABLE qbf-m AS CHARACTER EXTENT   12 NO-UNDO.
DEFINE VARIABLE qbf-o AS INTEGER               NO-UNDO. /* qbf# old value */
DEFINE VARIABLE qbf-s AS CHARACTER             NO-UNDO.
DEFINE VARIABLE qbf-t AS CHARACTER             NO-UNDO.
DEFINE VARIABLE qbf-w AS LOGICAL  INITIAL TRUE NO-UNDO.
DEFINE VARIABLE qbf-x AS CHARACTER             NO-UNDO.

{ prores/s-top.i NEW } /* definition for qbf-top frame */

/*
+----------------------------- Data Export Layout -----------------------------+
|Fields:                                                                       |
|      :                                                                       |
|      :                                                                       |
|      :                                                                       |
|      :                                                                       |
|    Export Type: PROGRESS     Headers: no   (export names as first record)    |
|   Record start:                                                              |
|     Record end: cr lf                                                        |
|Field delimiter: '"'                                                          |
|Field separator: ' '                                                          |
+------------------------------------------------------------------------------+
*/
FORM
  qbf-m[ 8]      FORMAT "x(7)"  qbf-m[1]      FORMAT "x(69)" SKIP
  qbf-m[ 9]      FORMAT "x(7)"  qbf-m[2]      FORMAT "x(69)" SKIP
  qbf-m[10]      FORMAT "x(7)"  qbf-m[3]      FORMAT "x(69)" SKIP
  qbf-m[11]      FORMAT "x(7)"  qbf-m[4]      FORMAT "x(69)" SKIP
  qbf-m[12]      FORMAT "x(7)"  qbf-m[5]      FORMAT "x(69)" SKIP
  qbf-lang[ 7]   FORMAT "x(16)" qbf-d-attr[1] FORMAT "x(10)"
    qbf-lang[ 8] FORMAT "x(12)"
    qbf-c        FORMAT "x(37)" SKIP
  qbf-lang[10]   FORMAT "x(16)" qbf-d-attr[3] FORMAT "x(60)" SKIP
  qbf-lang[11]   FORMAT "x(16)" qbf-d-attr[4] FORMAT "x(60)" SKIP
  qbf-lang[12]   FORMAT "x(16)" qbf-d-attr[5] FORMAT "x(60)" SKIP
  qbf-lang[13]   FORMAT "x(16)" qbf-d-attr[6] FORMAT "x(60)" SKIP
  WITH FRAME d-bottom ROW 10 COLUMN 1 WIDTH 80 NO-ATTR-SPACE OVERLAY NO-LABELS
  TITLE COLOR NORMAL " " + qbf-lang[4] + " ". /*Data Export Layout*/
qbf-x = qbf-lang[9].

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

DISPLAY
  ENTRY(1,qbf-lang[5]) @ qbf-m[ 8]
  ENTRY(2,qbf-lang[5]) @ qbf-m[ 9]
  ENTRY(3,qbf-lang[5]) @ qbf-m[10]
  ENTRY(4,qbf-lang[5]) @ qbf-m[11]
  ENTRY(5,qbf-lang[5]) @ qbf-m[12]
  qbf-lang[7] qbf-lang[8] qbf-lang[10 FOR 4]
  WITH FRAME d-bottom.

DO WHILE TRUE ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:

  { prores/t-set.i &mod=d &set=2 }
  VIEW FRAME qbf-top.
  VIEW FRAME d-bottom.

  ASSIGN /*                              1234567890 1234567890*/
    qbf-m-aok = STRING(qbf-file[1] = "","ynyyynnyny/yyyyyyyyyy")
              + STRING(qbf-user,"y/n") + "y"
    qbf-d     = TRUE.

  IF qbf-w THEN DO:
    ASSIGN
      qbf-m     = ""
      qbf-m[10] = ?
      qbf-a     = FALSE
      qbf-j     = 1
      qbf-w     = FALSE.
    RUN prores/s-ask.p (INPUT-OUTPUT qbf-a).
    RUN prores/d-edit.p (INPUT-OUTPUT qbf-m[10]).

    DO qbf-i = 1 to qbf-rc#:
      qbf-c = qbf-rcf[qbf-i].
      IF qbf-d-attr[1] = "FIXED" AND STRING(0,"9.") = "0," THEN
        RUN prores/d-extra.p (INPUT-OUTPUT qbf-c).
      qbf-c = ENTRY(1,qbf-rcn[qbf-i]) + (IF qbf-d-attr[1] = "FIXED"
              THEN ' "' + qbf-c + '"' ELSE '').
      IF LENGTH(qbf-c) + 1 + LENGTH(qbf-m[qbf-j]) > 69 THEN qbf-j = qbf-j + 1.
      IF qbf-j = 6 THEN LEAVE.
      qbf-m[qbf-j] = qbf-m[qbf-j] + qbf-c + ",".
    END.
    IF qbf-j = 6 THEN
      qbf-m[5] = SUBSTRING(qbf-m[5],1,66) + "...".
    ELSE
      qbf-m[qbf-j] = SUBSTRING(qbf-m[qbf-j],1,LENGTH(qbf-m[qbf-j]) - 1).
    qbf-c = "".
    DO qbf-i = 1 TO 5 WHILE qbf-order[qbf-i] <> "":
      qbf-c = qbf-c + "BY " + qbf-order[qbf-i] + " ".
    END.
    IF LENGTH(qbf-c) > 70 THEN SUBSTRING(qbf-c,68,3) = "...".
    DISPLAY { prores/s-draw.i } qbf-c WITH FRAME qbf-top.
    DISPLAY
      qbf-m[1 FOR 5]
      qbf-d-attr[1]
      LC(TRIM(ENTRY(IF qbf-d-attr[2] BEGINS "t" THEN 1 ELSE 2,qbf-boolean)))
        + " " + qbf-x @ qbf-c
      SUBSTRING(qbf-m[10],  1,48) @ qbf-d-attr[3]
      SUBSTRING(qbf-m[10], 49,48) @ qbf-d-attr[4]
      SUBSTRING(qbf-m[10], 97,48) @ qbf-d-attr[5]
      SUBSTRING(qbf-m[10],145,48) @ qbf-d-attr[6]
      WITH FRAME d-bottom.
  END.

  IF qbf# = ? THEN
    RUN prores/s-menu.p
      (INPUT-OUTPUT qbf#,INPUT-OUTPUT qbf-o,INPUT-OUTPUT qbf-d).

  IF (qbf# = 2 OR qbf# = 3) AND qbf-file[1] <> "" AND qbf-rcn[1] = "" THEN DO:
    qbf# = ?.
    RUN prores/s-error.p ("#15").
  END.
  IF qbf# = 2 OR qbf# = 3 THEN DO:
    qbf-a = TRUE.
    DO qbf-i = 1 TO qbf-rc# WHILE qbf-a:
      qbf-a = NOT qbf-rcc[qbf-i] BEGINS "e".
    END.
    IF NOT qbf-a THEN
      RUN prores/s-box.p (INPUT-OUTPUT qbf-a,?,?,"#14").
    IF NOT qbf-a THEN 
      qbf# = ?.
    /*
    14: Data Export does not support the exporting of stacked
        arrays.  If you continue, they will be eliminated from
        the export.^Do you wish to continue?
    15: Sorry, cannot export data with no fields defined.
    */
  END.

  /*------------------------------------------------------------------- Get */
  IF qbf# = 1 THEN DO:
    qbf-a = qbf-file[1] = "".
    IF NOT qbf-a THEN
      RUN prores/s-box.p (INPUT-OUTPUT qbf-a,?,?,"#21").
      /*"You did not clear the current export format.  "
      + "Do you still want to continue?"*/
    IF qbf-a THEN 
      RUN prores/i-dir.p ("d",TRUE).
    qbf-w = TRUE.
  END.
  ELSE
  /*------------------------------------------------------------------- Put */
  IF qbf# = 2 THEN
    RUN prores/i-dir.p ("d",FALSE).
  ELSE
  /*------------------------------------------------------------------- Run */
  IF qbf# = 3 THEN DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
    IF qbf-file[1] = "" THEN DO:
      qbf-w = TRUE.
      RUN prores/i-dir.p ("d",TRUE).
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
    MESSAGE qbf-lang[22]. /*"Generating export program..."*/
    ASSIGN
      qbf-b = qbf-pr-type[qbf-device] = "term"
      qbf-a = qbf-d-attr[1] = "PROGRESS" AND qbf-b.
    IF qbf-a THEN qbf-d-attr[1] = "ASCII".
      /* get around EXPORT when OUTPUT TO TERMINAL */
    RUN prores/d-write.p (qbf-tempdir).
    IF qbf-a THEN qbf-d-attr[1] = "PROGRESS".
    HIDE MESSAGE.
    MESSAGE qbf-lang[23]. /*"Compiling export program..."*/
    COMPILE VALUE(qbf-tempdir + ".p").
    HIDE MESSAGE.
    ASSIGN
      qbf-c     = ?
      qbf-total = 0
      qbf-a     = TRUE.
    IF qbf-b AND qbf-pr-dev[qbf-device] <> TERMINAL THEN qbf-c = TERMINAL.
    IF qbf-b THEN
      HIDE ALL.
    ELSE
      MESSAGE qbf-lang[24]. /*"Running generated program..."*/
    qbf-a = TRUE.
    DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
      IF qbf-c <> ? THEN TERMINAL = qbf-pr-dev[qbf-device].
      IF qbf-b THEN
        OUTPUT TO TERMINAL PAGED.
      ELSE IF CAN-DO("view,page",qbf-pr-type[qbf-device]) THEN
        OUTPUT TO VALUE(qbf-tempdir + ".d") PAGE-SIZE 0.
      ELSE IF qbf-pr-type[qbf-device] = "thru" THEN
        OUTPUT THROUGH VALUE(qbf-pr-dev[qbf-device]) PAGE-SIZE 0.
      ELSE IF qbf-pr-app THEN
        OUTPUT TO VALUE(qbf-pr-dev[qbf-device]) PAGE-SIZE 0 APPEND.
      ELSE IF qbf-pr-type[qbf-device] <> "prog" THEN
        OUTPUT TO VALUE(qbf-pr-dev[qbf-device]) PAGE-SIZE 0.
      PAUSE BEFORE-HIDE.
      RUN prores/s-print.p (1). /* output init string */
      qbf-e = { prores/s-etime.i }.
      IF qbf-pr-type[qbf-device] = "prog" THEN
        RUN VALUE(qbf-pr-dev[qbf-device]) (qbf-tempdir + ".p").
      ELSE
        RUN VALUE(qbf-tempdir + ".p").
      ASSIGN
        qbf-a = FALSE
        qbf-e = ({ prores/s-etime.i } - qbf-e) * .001.
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
    IF qbf-b THEN
      DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
        PAUSE.
      END.
    PAUSE 0 BEFORE-HIDE.
    OUTPUT CLOSE.
    IF qbf-b OR CAN-DO("term,view,prog",qbf-pr-type[qbf-device]) THEN DO:
      HIDE ALL NO-PAUSE.
      IF qbf-c <> ? THEN TERMINAL = qbf-c.
    END.
    HIDE MESSAGE.
    PAUSE BEFORE-HIDE.
    IF qbf-a THEN DO:
      RUN prores/s-error.p
        (qbf-lang[25] + ' "' + qbf-pr-dev[qbf-device] + '"').
      /*"Could not write to file or device"*/
    END.
    ELSE
    IF qbf-total >= 0 AND qbf-pr-type[qbf-device] <> "term" THEN DO:
      ASSIGN
        qbf-i    = TRUNCATE(qbf-e,0)
        qbf-c    = qbf-lang[26] /* {1} records exported. */
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
    /* current list: */
    /*
    PROGRESS - PROGRESS Export
    ASCII    - Generic ASCII format
    ASCII-H  - ASCII with Field-name header
    FIXED    - Fixed-width ASCII (SDF)
    CSV      - Comma-separated value (CSV)
    DIF      - DIF
    SYLK     - SYLK
    WS       - WordStar
    WORD     - Microsoft Word
    WORD4WIN - Microsoft Word for Windows
    WPERF    - WordPerfect
    OFISW    - CTOS/BTOS OfisWriter
    USER     - User
    */
    { prores/t-set.i &mod=d &set=3 }
    ASSIGN
      qbf-w = TRUE
      qbf-s = ENTRY(1,qbf-lang[1])
      qbf-t = ENTRY(2,qbf-lang[1]).
    DO qbf-i = 2 TO qbf-i + 1 WHILE qbf-lang[qbf-i] <> "*":
      IF ENTRY(1,qbf-lang[qbf-i]) = "USER" AND qbf-u-expo = "" THEN NEXT.
      ASSIGN
        qbf-s = qbf-s + "," + TRIM(ENTRY(1,qbf-lang[qbf-i]))
        qbf-t = qbf-t + "," + ENTRY(2,qbf-lang[qbf-i]).
      IF ENTRY(1,qbf-lang[qbf-i]) = "USER"
        THEN qbf-t = qbf-t + " - " + ENTRY(1,qbf-u-enam).
    END.
    RUN prores/c-entry.p (qbf-t,"r002c023d013",OUTPUT qbf-i).
    IF qbf-i > 0 THEN DO:
      ASSIGN
        qbf-t         = "ASCII,ASCII-H,FIXED"
        qbf-a         = CAN-DO(qbf-t,qbf-d-attr[1])
                    AND CAN-DO(qbf-t,ENTRY(qbf-i,qbf-s))
        qbf-c         = ""
        qbf-d-attr[1] = ENTRY(qbf-i,qbf-s).
      IF qbf-a THEN
        /* from ascii/ascii-h/fixed -> ascii/ascii-h/fixed */
        /* preserve settings for qbf-d-attr[3..7] */
        qbf-d-attr[2] = TRIM(STRING(qbf-d-attr[1] MATCHES "*-H","true/false")).
      ELSE DO:
        { prores/d-type.i &type=qbf-d-attr[1] }
      END.
      IF CAN-DO(qbf-t,qbf-d-attr[1]) THEN
        RUN prores/d-edit.p (INPUT-OUTPUT qbf-c).
    END.
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
      RUN prores/i-zap.p ("d").
    ELSE
      RUN prores/s-box.p (INPUT-OUTPUT qbf-a,?,?,"#31").
      /*"Are you sure that you want to reset the export settings?"*/
    IF qbf-a THEN 
      RUN prores/s-zap.p.
  END.
  ELSE
  /*------------------------------------------------------------------ Info */
  IF qbf# = 9 THEN
    RUN prores/s-info.p ("d").
  ELSE
  /*---------------------------------------------------------------- Module */
  IF qbf# = 10 THEN DO:
    RUN prores/s-module.p ("d",OUTPUT qbf-c).
    IF qbf-c <> ? THEN DO:
      qbf-module = qbf-c.
      LEAVE.
    END.
  END.
  ELSE
  /*------------------------------------------------------------------ User */
  IF qbf# = 11 THEN DO:
    qbf-module = "d".
    RUN VALUE(qbf-u-prog).
    IF qbf-module <> "d" THEN LEAVE.
  END.
  ELSE
  /* ----------------------------------------------------------------- Exit */
  IF qbf# = 12 THEN DO:
    qbf-a = qbf-file[1] = "".
    IF NOT qbf-a THEN 
      RUN prores/s-box.p (INPUT-OUTPUT qbf-a,?,?,"#32").
      /*Are you sure you want to exit this module?*/
    IF qbf-a THEN DO:
      ASSIGN
        qbf-time   = ""
        qbf-module = ?.
      LEAVE.
    END.
  END.

  PAUSE BEFORE-HIDE.
  qbf# = ?.
END.

HIDE FRAME d-bottom NO-PAUSE.
HIDE FRAME qbf-top  NO-PAUSE.
HIDE MESSAGE NO-PAUSE.
{ prores/t-reset.i }
RETURN.
