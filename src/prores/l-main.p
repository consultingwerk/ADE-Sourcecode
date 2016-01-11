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
/* l-main.p - Labels module main procedure */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/s-print.i }
{ prores/t-define.i }
{ prores/s-menu.i }
{ prores/t-set.i &mod=l &set=2 }

DEFINE VARIABLE qbf#  AS INTEGER   INITIAL    ? NO-UNDO.
DEFINE VARIABLE qbf-a AS LOGICAL                NO-UNDO.
DEFINE VARIABLE qbf-b AS LOGICAL                NO-UNDO.
DEFINE VARIABLE qbf-c AS CHARACTER              NO-UNDO.
DEFINE VARIABLE qbf-d AS LOGICAL   INITIAL TRUE NO-UNDO. /* qbf# redraw flag */
DEFINE VARIABLE qbf-e AS DECIMAL   DECIMALS   3 NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-m AS CHARACTER EXTENT     6 NO-UNDO.
DEFINE VARIABLE qbf-o AS INTEGER                NO-UNDO. /* qbf# old value */
DEFINE VARIABLE qbf-t AS CHARACTER              NO-UNDO.
DEFINE VARIABLE qbf-w AS LOGICAL   INITIAL TRUE NO-UNDO.
DEFINE VARIABLE qbf-x AS CHARACTER              NO-UNDO.

DEFINE VARIABLE qbf-co AS INTEGER NO-UNDO.
DEFINE VARIABLE qbf-lm AS INTEGER NO-UNDO.
DEFINE VARIABLE qbf-ls AS INTEGER NO-UNDO.
DEFINE VARIABLE qbf-na AS INTEGER NO-UNDO.
DEFINE VARIABLE qbf-th AS INTEGER NO-UNDO.
DEFINE VARIABLE qbf-tm AS INTEGER NO-UNDO.

{ prores/s-top.i NEW } /* definition for qbf-top frame */

/*
+------------------------------------------------------------------------------+
|Omit Blank Lines: yes   Total Height: 6__   Text to Text Spacing: 30_  (width)|
|  Copies of Each: 1__     Top Margin: 0__     Left Margin Indent: 0__         |
|                  | o | @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ | o ||
|   Label Text --> |   |   :    2                                         |   ||
|   and Fields --> | o |   :    3                                         | o ||
|                  |   |   :    4                                         |   ||
|                  | o |   :    5                                         | o ||
|Number of         |   |   :    6                                         |   ||
|Labels            | o | field #n                                         | o ||
|Across:       ___ |   | 123456789012345678901234567890123456789012345678 |   ||
+------------------------------------------------------------------------------+
*/
FORM
  qbf-lang[ 6] FORMAT "x(17)" qbf-x  ATTR-SPACE FORMAT "x(3)"
  qbf-lang[ 8] FORMAT "x(15)" qbf-th ATTR-SPACE FORMAT ">>9"
  qbf-lang[10] FORMAT "x(22)" qbf-ls ATTR-SPACE FORMAT ">>9" SPACE(0)
    qbf-lang[12] FORMAT "x(7)" SKIP

  qbf-lang[ 7] FORMAT "x(17)" qbf-co ATTR-SPACE FORMAT ">>9"
  qbf-lang[ 9] FORMAT "x(15)" qbf-tm ATTR-SPACE FORMAT ">>9"
  qbf-lang[11] FORMAT "x(22)" qbf-lm ATTR-SPACE FORMAT ">>9" SKIP

  SPACE(18)
        "| o |" qbf-l-text[1] FORMAT "x(48)" ATTR-SPACE SPACE(0) "| o |" SKIP
  qbf-lang[13] FORMAT "x(13)"
    "--> |   |" qbf-l-text[2] FORMAT "x(48)" ATTR-SPACE SPACE(0) "|   |" SKIP
  qbf-lang[14] FORMAT "x(13)"
    "--> | o |" qbf-l-text[3] FORMAT "x(48)" ATTR-SPACE SPACE(0) "| o |" SKIP
  SPACE(18)
        "|   |" qbf-l-text[4] FORMAT "x(48)" ATTR-SPACE SPACE(0) "|   |" SKIP
  SPACE(18)
        "| o |" qbf-l-text[5] FORMAT "x(48)" ATTR-SPACE SPACE(0) "| o |" SKIP
  qbf-lang[15] FORMAT "x(17)"
        "|   |" qbf-l-text[6] FORMAT "x(48)" ATTR-SPACE SPACE(0) "|   |" SKIP
  qbf-lang[16] FORMAT "x(17)"
        "| o |" qbf-l-text[7] FORMAT "x(48)" ATTR-SPACE SPACE(0) "| o |" SKIP
  qbf-lang[17] FORMAT "x(13)" qbf-na FORMAT ">>9" ATTR-SPACE SPACE(0)
        "|   |" qbf-l-text[8] FORMAT "x(48)" ATTR-SPACE SPACE(0) "|   |" SKIP

  WITH FRAME l-bottom ROW 10 COLUMN 1 WIDTH 80 NO-LABELS NO-ATTR-SPACE
  TITLE COLOR NORMAL " " + qbf-lang[4] + " ". /*Label Layout*/

FORM
  qbf-tm VALIDATE(qbf-tm >= 0,qbf-lang[2])
  qbf-th VALIDATE(qbf-th >  1 AND qbf-th <= { prores/s-limlbl.i },qbf-lang[3])
  qbf-na VALIDATE(qbf-na >  0,qbf-lang[4])
  qbf-co VALIDATE(qbf-co >  0,qbf-lang[5])
  qbf-lm VALIDATE(qbf-lm >= 0,qbf-lang[6])
  qbf-ls VALIDATE(qbf-ls >= 0 OR INPUT qbf-na = 1,qbf-lang[7])
  WITH FRAME l-bottom.
/*
VALIDATE:
qbf-lang[ 2]: Top margin cannot be negative
qbf-lang[ 3]: Total height must be greater than one
qbf-lang[ 4]: Number of labels across must be at least one
qbf-lang[ 5]: Number of copies must be at least one
qbf-lang[ 6]: Left margin cannot be negative
qbf-lang[ 7]: Text spacing must be greater than one
HELP:
qbf-lang[ 8]: Shift lower lines up when line is blank
qbf-lang[ 9]: Number of lines from the top of label to first line of print
qbf-lang[10]: Total height of label measured in lines
qbf-lang[11]: Number of labels across
qbf-lang[12]: Number of copies of each label
qbf-lang[13]: Number of spaces from edge of label to first print position
qbf-lang[14]: Distance from left edge of one label to edge of next
*/

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

DISPLAY qbf-lang[6 FOR 12] WITH FRAME l-bottom.

DO WHILE TRUE ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:

  { prores/t-set.i &mod=l &set=2 }
  VIEW FRAME qbf-top.
  VIEW FRAME l-bottom.
  HIDE FRAME l-define NO-PAUSE.

  ASSIGN /*                              1234567890 1234567890*/
    qbf-m-aok = STRING(qbf-file[1] = "","ynyyynnyny/yyyyyyyyyy")
              + STRING(qbf-user,"y/n") + "y"
    qbf-d     = TRUE.

  IF qbf-w THEN DO:
    ASSIGN
      qbf-a = FALSE
      qbf-c = ""
      qbf-m = ""
      qbf-w = FALSE.
    RUN prores/s-ask.p (INPUT-OUTPUT qbf-a).
    DO qbf-i = 1 TO 5 WHILE qbf-order[qbf-i] <> "":
      qbf-c = qbf-c + "BY " + qbf-order[qbf-i] + " ".
    END.
    IF LENGTH(qbf-c) > 70 THEN SUBSTRING(qbf-c,68,3) = "...".
    DISPLAY { prores/s-draw.i } qbf-c WITH FRAME qbf-top.
    DISPLAY
      qbf-l-attr[1] @ qbf-lm
      qbf-l-attr[2] @ qbf-ls
      qbf-l-attr[3] @ qbf-th
      qbf-l-attr[4] @ qbf-tm
      qbf-l-attr[5] @ qbf-na
      qbf-l-attr[7] @ qbf-co
      LC(TRIM(ENTRY(IF qbf-l-attr[6] <> 0 THEN 1 ELSE 2,qbf-boolean))) @ qbf-x
      { prores/s-dots.i qbf-l-text[1] 48 } @ qbf-l-text[1]
      { prores/s-dots.i qbf-l-text[2] 48 } @ qbf-l-text[2]
      { prores/s-dots.i qbf-l-text[3] 48 } @ qbf-l-text[3]
      { prores/s-dots.i qbf-l-text[4] 48 } @ qbf-l-text[4]
      { prores/s-dots.i qbf-l-text[5] 48 } @ qbf-l-text[5]
      { prores/s-dots.i qbf-l-text[6] 48 } @ qbf-l-text[6]
      { prores/s-dots.i qbf-l-text[7] 48 } @ qbf-l-text[7]
      { prores/s-dots.i qbf-l-text[8] 48 } @ qbf-l-text[8]
      WITH FRAME l-bottom.
  END.

  IF qbf# = ? THEN
    RUN prores/s-menu.p
      (INPUT-OUTPUT qbf#,INPUT-OUTPUT qbf-o,INPUT-OUTPUT qbf-d).

  /*------------------------------------------------------------------- Get */
  IF qbf# = 1 THEN DO:
    qbf-a = qbf-file[1] = "".
    IF NOT qbf-a THEN 
      RUN prores/s-box.p (INPUT-OUTPUT qbf-a,?,?,"#19").
    /*"You did not clear the current label.  Do you still want to continue?"*/
    IF qbf-a THEN 
      RUN prores/i-dir.p ("l",TRUE).
    qbf-w = TRUE.
  END.
  ELSE
  /*------------------------------------------------------------------- Put */
  IF qbf# = 2 THEN
    RUN prores/i-dir.p ("l",FALSE).
  ELSE
  /*------------------------------------------------------------------- Run */
  IF qbf# = 3 THEN DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
    IF qbf-file[1] = "" THEN DO:
      qbf-w = TRUE.
      RUN prores/i-dir.p ("l",TRUE).
      IF qbf-file[1] = "" THEN UNDO,LEAVE.
      NEXT.
    END.
    PAUSE 0.
    qbf-j = 0.
    DO qbf-i = { prores/s-limlbl.i } TO 1 BY -1 WHILE qbf-l-text[qbf-i] = "": END.
    IF qbf-i = 0 THEN DO:
      /*"There is no label text or fields to print!"*/
      RUN prores/s-error.p ("#21").
      UNDO,LEAVE.
    END.
    DO WHILE qbf-i > 0:
      ASSIGN
        qbf-j = qbf-j + (IF qbf-l-text[qbf-i] MATCHES "*~~~~" THEN 0 ELSE 1)
        qbf-i = qbf-i - 1.
    END.
    ASSIGN
      qbf-a = qbf-j <= qbf-l-attr[3]
      qbf-c = qbf-lang[20]
      SUBSTRING(qbf-c,INDEX(qbf-c,"~{1~}"),3) = STRING(qbf-l-attr[3])
      SUBSTRING(qbf-c,INDEX(qbf-c,"~{2~}"),3) = STRING(qbf-j).
    IF NOT qbf-a THEN
      RUN prores/s-box.p (INPUT-OUTPUT qbf-a,?,?,qbf-c).
      /*Your label height is {1}, but you have {2} lines defined.  Some
      information will not fit on the label size you have defined, and
      therefore will not be printed.  Do you still want to continue and
      print these labels?*/
    IF NOT qbf-a THEN UNDO,LEAVE.
    qbf-a = TRUE.
    RUN prores/s-ask.p (INPUT-OUTPUT qbf-a).
    IF NOT qbf-a THEN UNDO,LEAVE.
    RUN prores/c-print.p (OUTPUT qbf-a).
    IF NOT qbf-a THEN UNDO,LEAVE.
    PAUSE 0 BEFORE-HIDE.
    MESSAGE qbf-lang[22]. /*"Generating labels program..."*/
    RUN prores/l-write.p (qbf-tempdir).
    HIDE MESSAGE.
    MESSAGE qbf-lang[23]. /*"Compiling labels program..."*/
    COMPILE VALUE(qbf-tempdir + ".p").
    HIDE MESSAGE.
    ASSIGN
      qbf-b     = qbf-pr-type[qbf-device] = "term"
      qbf-c     = ?
      qbf-total = 0.
    IF qbf-b AND qbf-pr-dev[qbf-device] <> TERMINAL THEN qbf-c = TERMINAL.
    IF qbf-b THEN
      HIDE ALL.
    ELSE
      MESSAGE qbf-lang[24]. /*"Running generated program..."*/
    qbf-a = TRUE.
    DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
      IF qbf-c <> ? THEN TERMINAL = qbf-pr-dev[qbf-device].
      IF qbf-pr-type[qbf-device] = "term" THEN
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
        qbf-e = ({ prores/s-etime.i } - qbf-e) * .001
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
        RUN prores/s-quoter.p (qbf-tempdir + ".d",qbf-tempdir + "1.d").
        PUT SCREEN ROW 1 COLUMN 1 FILL(" ",80).
        RUN prores/s-page.p (qbf-tempdir + "1.d",0,FALSE).
      END.
    END.
    IF qbf-b AND qbf-total > 0 THEN DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
      PAUSE.
    END.
    PAUSE 0 BEFORE-HIDE.
    OUTPUT CLOSE.
    PAUSE BEFORE-HIDE.
    IF CAN-DO("term,view,prog",qbf-pr-type[qbf-device]) THEN DO:
      HIDE ALL NO-PAUSE.
      IF qbf-c <> ? THEN TERMINAL = qbf-c.
    END.
    ELSE
      HIDE MESSAGE NO-PAUSE.
    IF qbf-a THEN DO:
      RUN prores/s-error.p
        (qbf-lang[25] + ' "' + qbf-pr-dev[qbf-device] + '"').
      /*Could not write to file or device*/
    END.
    ELSE
    IF qbf-total >= 0 AND qbf-pr-type[qbf-device] <> "term" THEN DO:
      ASSIGN
        qbf-i    = TRUNCATE(qbf-e,0)
        qbf-c    = qbf-lang[26] /* {1} labels printed. */
        qbf-time = STRING(TRUNCATE(qbf-e / 60,0)) + ":"
                 + STRING(qbf-i MODULO 60,"99")
                 + (IF qbf-i = qbf-e THEN "" ELSE STRING(qbf-e - qbf-i))
        SUBSTRING(qbf-c,INDEX(qbf-c,"~{1~}"),3) = STRING(qbf-total).
      MESSAGE COLOR VALUE(IF qbf-total > 0 THEN "NORMAL" ELSE "MESSAGES") qbf-c.
    END.
  END.
  ELSE
  /*---------------------------------------------------------------- Define */
  IF qbf# = 4 THEN DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
    ASSIGN
      qbf-w = TRUE
      qbf-a = TRUE
      qbf-c = qbf-module
      qbf-module = qbf-module + "4s".
    IF qbf-file[1] <> "" THEN DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
      DISPLAY
        " " + qbf-lang[27] @ qbf-m[1] FORMAT "x(30)" SKIP /*F. Fields*/
        " " + qbf-lang[28] @ qbf-m[2] FORMAT "x(30)" SKIP /*A. Active Files*/
        WITH FRAME l-define NO-LABELS ATTR-SPACE ROW 2 COLUMN 14 OVERLAY
        COLOR DISPLAY VALUE(qbf-mlo) PROMPT VALUE(qbf-mhi).
      CHOOSE FIELD qbf-m[1 FOR 2] COLOR VALUE(qbf-mhi) AUTO-RETURN
        WITH FRAME l-define.
      HIDE FRAME l-define NO-PAUSE.
      qbf-a = FRAME-INDEX = 2.
    END.
    qbf-module = qbf-c.
    IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN UNDO,LEAVE.
    IF qbf-a THEN DO:
      DO qbf-i = 1 TO 5:
        RUN prores/r-file.p (qbf-i).
        DISPLAY { prores/s-draw.i } WITH FRAME qbf-top.
        IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN LEAVE.
      END.
      IF qbf-i > 1 THEN 
        RUN prores/r-file.p (- qbf-i).
    END.

    IF qbf-file[1] = "" THEN UNDO,LEAVE.
    DISPLAY { prores/s-draw.i } WITH FRAME qbf-top.
    qbf-a = TRUE.
    DO qbf-i = 1 TO { prores/s-limlbl.i } WHILE qbf-a:
      qbf-a = qbf-l-text[qbf-i] = "".
    END.
    IF qbf-a THEN DO:
      RUN prores/s-box.p (INPUT-OUTPUT qbf-a,?,?,"#29").
        /*"Should this program try to select the fields for the labels "
        + "automatically?"*/
      IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN .
      ELSE IF qbf-a THEN 
        RUN prores/l-guess.p.
      ELSE DO:
        ASSIGN
          qbf-t = ""
          qbf-i = 1.
        RUN prores/c-field.p ("field","",INPUT-OUTPUT qbf-t).
        DO WHILE qbf-t <> "":
          ASSIGN
            qbf-l-text[qbf-i] = qbf-l-text[qbf-i]
                              + qbf-left + ENTRY(1,qbf-t) + qbf-right
            qbf-t             = SUBSTRING(qbf-t,INDEX(qbf-t + ",",",") + 1)
            qbf-i             = MINIMUM(qbf-i + 1,{ prores/s-limlbl.i }).
        END.
      END.
    END.

    RUN prores/l-edit.p.
  END.
  ELSE
  /*-------------------------------------------------------------- Settings */
  IF qbf# = 5 THEN DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
    { prores/t-set.i &mod=l &set=3 }
    ASSIGN
      qbf-module = "l5a"
      qbf-c = ""
      qbf-w = TRUE
      qbf-x = LC(TRIM(ENTRY(IF qbf-l-attr[6] <> 0 THEN 1 ELSE 2,qbf-boolean))).
    DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
      SET qbf-x qbf-co qbf-th qbf-tm qbf-ls qbf-lm qbf-na WITH FRAME l-bottom
        EDITING:
          /* hack for multi-lingual help message texts */
          /* see FORM stmt for l-bottom for comments on qbf-lang[8..14] */
          qbf-i = (IF FRAME-FIELD = "qbf-x"  THEN  8
              ELSE IF FRAME-FIELD = "qbf-co" THEN 12
              ELSE IF FRAME-FIELD = "qbf-th" THEN 10
              ELSE IF FRAME-FIELD = "qbf-tm" THEN  9
              ELSE IF FRAME-FIELD = "qbf-ls" THEN 14
              ELSE IF FRAME-FIELD = "qbf-lm" THEN 13
              ELSE                                11).
          IF qbf-c <> qbf-lang[qbf-i] THEN DO:
            STATUS INPUT qbf-lang[qbf-i].
            ASSIGN
              qbf-c      = qbf-lang[qbf-i]
              qbf-module = "l5s" + TRIM(STRING(qbf-i,">>")).
          END.
          READKEY.
          IF FRAME-FIELD = "qbf-x" THEN DO:
            IF CHR(LASTKEY) = SUBSTRING(TRIM(ENTRY(1,qbf-boolean)),1,1) THEN
              qbf-x = LC(TRIM(ENTRY(1,qbf-boolean))).
            ELSE
            IF CHR(LASTKEY) = SUBSTRING(TRIM(ENTRY(2,qbf-boolean)),1,1) THEN
              qbf-x = LC(TRIM(ENTRY(2,qbf-boolean))).
            ELSE
              APPLY LASTKEY.
          END.
          ELSE
            APPLY LASTKEY.
          IF INPUT FRAME l-bottom qbf-x <> qbf-x THEN
            DISPLAY qbf-x WITH FRAME l-bottom.
        END.
      IF qbf-na > 1 AND qbf-ls = 0 THEN DO:
        NEXT-PROMPT qbf-ls WITH FRAME l-bottom.
        BELL. /*If more than one label across, text spacing must be > 0*/
        MESSAGE qbf-lang[1].
        UNDO,RETRY.
      END.
      ASSIGN
        qbf-l-attr[1] = qbf-lm
        qbf-l-attr[2] = qbf-ls
        qbf-l-attr[3] = qbf-th
        qbf-l-attr[4] = qbf-tm
        qbf-l-attr[5] = qbf-na
        qbf-l-attr[6] = (IF qbf-x BEGINS
                        SUBSTRING(TRIM(ENTRY(1,qbf-boolean)),1,1)
                        THEN 1 ELSE 0)
        qbf-l-attr[7] = qbf-co.
    END.
    STATUS INPUT.
    qbf-module = "l".
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
      RUN prores/i-zap.p ("l").
    ELSE
      RUN prores/s-box.p (INPUT-OUTPUT qbf-a,?,?,"#31").
      /*"Are you sure that you want to clear these settings?"*/
    IF qbf-a THEN 
      RUN prores/s-zap.p.
  END.
  ELSE
  /*------------------------------------------------------------------ Info */
  IF qbf# = 9 THEN
    RUN prores/s-info.p ("l").
  ELSE
  /*---------------------------------------------------------------- Module */
  IF qbf# = 10 THEN DO:
    RUN prores/s-module.p ("l",OUTPUT qbf-c).
    IF qbf-c <> ? THEN DO:
      qbf-module = qbf-c.
      LEAVE.
    END.
  END.
  ELSE
  /*------------------------------------------------------------------ User */
  IF qbf# = 11 THEN DO:
    qbf-module = "l".
    RUN VALUE(qbf-u-prog).
    IF qbf-module <> "l" THEN LEAVE.
  END.
  ELSE
  /*------------------------------------------------------------------ Exit */
  IF qbf# = 12 THEN DO:
    qbf-a = qbf-file[1] = "".
    IF NOT qbf-a THEN 
      RUN prores/s-box.p (INPUT-OUTPUT qbf-a,?,?,"#32").
      /*"Are you sure you want to exit this module?"*/
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

HIDE FRAME qbf-top  NO-PAUSE.
HIDE FRAME l-bottom NO-PAUSE.
HIDE MESSAGE NO-PAUSE.
{ prores/t-reset.i }
RETURN.
