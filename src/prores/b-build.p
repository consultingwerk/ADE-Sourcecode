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
/* b-build.p - do the build (manual, automatic, and continue-from-checkpoint) */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/t-define.i }
{ prores/c-form.i }
{ prores/a-define.i NEW }
{ prores/t-set.i &mod=b &set=1 }
{ prores/reswidg.i }
{ prores/resfunc.i }

DEFINE INPUT PARAMETER qbf-a AS INTEGER NO-UNDO.
/*
  qbf-a = 1 - interactive build        (was TRUE)
  qbf-a = 2 - semi-automatic build
  qbf-a = 3 - automatic build          (was FALSE)
  qbf-a = 4 - continue from checkpoint (was ?)
*/

DEFINE VARIABLE qbf-u AS LOGICAL INITIAL FALSE NO-UNDO. /*turn on DEBUG code?*/

DEFINE VARIABLE qbf-b AS CHARACTER  NO-UNDO.
DEFINE VARIABLE qbf-c AS CHARACTER  NO-UNDO.
DEFINE VARIABLE qbf-d AS DATE       NO-UNDO.
DEFINE VARIABLE qbf-e AS LOGICAL    NO-UNDO.
DEFINE VARIABLE qbf-f AS CHARACTER  NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-k AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-l AS LOGICAL    NO-UNDO.
DEFINE VARIABLE qbf-m AS CHARACTER  NO-UNDO EXTENT 4.
DEFINE VARIABLE qbf-n AS INTEGER    NO-UNDO. /* next avail qry# */
DEFINE VARIABLE qbf-q AS CHARACTER  NO-UNDO.
DEFINE VARIABLE qbf-s AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-t AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-x AS INTEGER    NO-UNDO.

DEFINE STREAM qbf-io.
IF TERMINAL <> "" THEN 
  OUTPUT STREAM qbf-io TO TERMINAL.

/*
+------------------------------------------------------------------------------+
| Working on _____ of _____ (___%)                     Elapsed time = HH:MM:SS |
| [Re]Compiling _____ of _____ (___%)                  Average time = MM:SS.SS |
|                                                                              |
| * Program    Database File Name                                     Time     |
| - ---------- ------------------------------------------------------ -------- |
| x x(10)      x(54)                                                  MM:SS.SS |
+---12345678901234567890123456789012345678901234567890123456789012345----------+
*/

FORM
  qbf-q FORMAT "x(78)" NO-LABEL
  WITH FRAME qbf-shadow DOWN ROW 2 COLUMN 1 WIDTH 80 NO-ATTR-SPACE OVERLAY
  TITLE COLOR NORMAL " " + qbf-product + " ".

FORM
  qbf-l FORMAT "*/ "      ATTR-SPACE SPACE(0)
  qbf-q FORMAT "x(10)" NO-ATTR-SPACE SPACE(0)
  qbf-f FORMAT "x(54)"    ATTR-SPACE SPACE(0)
  qbf-c FORMAT "x(8)"  NO-ATTR-SPACE
  WITH FRAME qbf-down OVERLAY NO-LABELS NO-BOX
  SCREEN-LINES - 8 DOWN ROW 8 COLUMN 2.

/*message "[b-build.p]" view-as alert-box.*/

PAUSE 0.
IF TERMINAL <> "" AND qbf-a <> 1 THEN 
DO WITH FRAME qbf-shadow:
  qbf-c = ENTRY(1,qbf-lang[16]). /*"Elapsed time"*/
  DISPLAY FILL(" ",66 - LENGTH(qbf-c)) + qbf-c + " =" @ qbf-q.
  /*PUT SCREEN ROW 3 COLUMN 68 - LENGTH(qbf-c) qbf-c + " =".*/
  DOWN.
  qbf-c = ENTRY(2,qbf-lang[16]). /*"Average time"*/
  DISPLAY FILL(" ",66 - LENGTH(qbf-c)) + qbf-c + " =" @ qbf-q.
  /*PUT SCREEN ROW 4 COLUMN 68 - LENGTH(qbf-c) qbf-c + " =".*/
  DOWN 3.
  UNDERLINE qbf-q.
END.
PAUSE 0.

ASSIGN
  qbf-l     = FALSE /* have not read in checkpoint file */
  qbf-form# = 0.
IF qbf-a = 4 THEN DO:
  STATUS DEFAULT qbf-lang[17].  /*Reading in checkpoint file.*/
  INPUT FROM VALUE(qbf-qcfile + ".qc") NO-ECHO.
  REPEAT WHILE qbf-a = 4:
    IMPORT qbf-m.
    IF qbf-m[1] BEGINS "mode" THEN 
      qbf-a = LOOKUP(qbf-m[1],"manual,semi,auto").
    ELSE
    IF qbf-m[1] BEGINS "file" THEN DO:
      ASSIGN
        qbf-form#           = qbf-form# + 1.

      {&FIND_QBF_FORM} qbf-form#.
      ASSIGN
        qbf-form.cValue     = qbf-m[2]
        qbf-form.cDesc      = qbf-m[3]
        qbf-form.xValue     = qbf-m[4].
    END.
  END.
  INPUT CLOSE.
  IF qbf-a = 4 THEN DO:
    /* 'Checkpoint file is corrupt.  Remove .qc file and restart ' */
    /* + 'build from beginning.' */
    RUN prores/s-error.p ("#2").
    QUIT.
  END.
  qbf-l = TRUE. /* have read in checkpoint file */
END.

IF NOT qbf-l AND qbf-a > 1 THEN DO:
  OUTPUT TO VALUE(qbf-qcfile + ".ql") ECHO.
  PUT UNFORMATTED FILL("-",76) SKIP.
  /*Scanning files to build initial list of query forms...*/
  { prores/b-status.i &text=qbf-lang[9] }
  RUN prores/b-merge.p (TRUE,OUTPUT qbf-l).
  OUTPUT CLOSE.
END.

/* if semi-automatic mode, let user turn on/off forms */
IF NOT qbf-l AND qbf-a = 2 THEN DO:
  RUN prores/b-pick.p.
  IF KEYFUNCTION(LASTKEY) = "END-ERROR" OR qbf-form# < 1 THEN QUIT.
END.

IF qbf-a = 1 THEN DO:
  PAUSE 0.
  DISPLAY " " @ qbf-q WITH FRAME qbf-shadow.
  PAUSE 0.
  qbf-l = FALSE.
  DO WHILE NOT qbf-l:
    RUN prores/a-form.p (FALSE).
    /*Are you done defining query forms?*/
    RUN prores/s-box.p (INPUT-OUTPUT qbf-l,?,?,"#10").
    /* checkpoint time! */
    { prores/b-check.i }
  END.
  PAUSE 0.
  DOWN 4 WITH FRAME qbf-shadow.
  UNDERLINE qbf-q WITH FRAME qbf-shadow.
END.

IF TERMINAL <> "" THEN DO:
  qbf-c = ENTRY(1,qbf-lang[16]). /*"Elapsed time"*/
  PUT SCREEN ROW 3 COLUMN 68 - LENGTH(qbf-c) qbf-c + " =".
  qbf-c = ENTRY(2,qbf-lang[16]). /*"Average time"*/
  PUT SCREEN ROW 4 COLUMN 68 - LENGTH(qbf-c) qbf-c + " =".
  PUT SCREEN ROW 3 COLUMN 3 qbf-lang[3]. /*"Working on"*/
  PUT SCREEN ROW 6 COLUMN 3
    "* "
    + STRING(ENTRY(1,qbf-lang[1]),"x(11)")
    + STRING(ENTRY(2,qbf-lang[1]),"x(55)")
    + ENTRY(3,qbf-lang[1]).
  PUT SCREEN ROW 7 COLUMN  2 " ".
  PUT SCREEN ROW 7 COLUMN  4 " ".
  PUT SCREEN ROW 7 COLUMN 15 " ".
  PUT SCREEN ROW 7 COLUMN 70 " ".
  PUT SCREEN ROW 7 COLUMN 79 " ".
END.

ASSIGN
  qbf-d = TODAY
  qbf-s = TIME.
DO qbf-k = 1 TO qbf-form#:
  {&FIND_QBF_FORM} qbf-k.
  IF INDEX(qbf-form.cValue,",") > 0     /* from checkpoint */
    OR qbf-form.cValue = "" THEN NEXT.  /* from user & b-pick.p */
  
  ASSIGN
    qbf-x = { prores/s-etime.i }
    qbf-i = (TODAY - qbf-d) * 86400 + TIME - qbf-s
    qbf-q = SUBSTRING(qbf-form.cValue,INDEX(qbf-form.cValue,".") + 1,8)
    qbf-f = qbf-q
    qbf-c = "".
  DO WHILE SEARCH(qbf-q + ".r") <> ? OR SEARCH(qbf-q + ".p") <> ?
    OR     SEARCH(qbf-q + ".i") <> ? OR SEARCH(qbf-q + ".f") <> ?:
    ASSIGN
      qbf-n = qbf-n + 1
      qbf-q = "qry" + STRING(qbf-n,"99999").
  END.
  /*"<filename>" already exists.  Instead using "<filename>".*/
  qbf-f = (IF qbf-f = qbf-q THEN ""
           ELSE '"' + qbf-f + '" ' + qbf-lang[19] + ' "' + qbf-q + '".'
          ).

  IF TERMINAL <> "" THEN DO WITH FRAME qbf-down:
    PUT SCREEN ROW 3 COLUMN LENGTH(qbf-lang[3]) + 4
      STRING(qbf-k) + " " + qbf-xofy + " " + STRING(qbf-form#)
      + " (" + STRING(TRUNCATE(qbf-k / qbf-form# * 100,0)) + "%)      ".
    PUT SCREEN ROW 3 COLUMN 71
      STRING(TRUNCATE(qbf-i / 3600,0),"99") /* to handle >24 hours */
      + SUBSTRING(STRING(qbf-i MODULO 3600,"HH:MM:SS"),3,6).
    qbf-i = (IF qbf-k = 1 THEN 0 ELSE qbf-i / (qbf-k - 1) * 1000).
    PUT SCREEN ROW 4 COLUMN 71 { prores/b-time.i qbf-i }.
    IF INPUT qbf-f = "" THEN .
    ELSE IF FRAME-LINE = FRAME-DOWN THEN SCROLL UP.
    ELSE DOWN 1.
    COLOR DISPLAY MESSAGES qbf-q qbf-f.
    DISPLAY qbf-q qbf-form.cValue @ qbf-f.
  END.

  OUTPUT TO VALUE(qbf-qcfile + ".ql") ECHO APPEND.
  PUT UNFORMATTED FILL("-",76) SKIP.

  qbf-c = ENTRY(1,qbf-lang[6]) + ' "' + qbf-form.cValue + '".'.
  { prores/b-log.i &text=qbf-c } /*working on file "<filename>".*/
  IF qbf-f <> "" THEN { prores/b-log.i &text=qbf-f }

  /* from s-zap.p */
  ASSIGN
    qbf-name        = ""   /* <-- file stuff */
    qbf-order       = ""
    qbf-file        = ""
    qbf-where       = ""
    qbf-of          = ""
    qbf-rc#         = 0    /* <-- field stuff */
    qbf-rcn         = ""
    qbf-rcl         = ""
    qbf-rcf         = ""
    qbf-rca         = ""
    qbf-rcc         = ""
    qbf-rcw         = ?
    qbf-rct         = 0
    qbf-c           = qbf-form.cValue /* <-- this file stuff */
    qbf-db[1]       = SUBSTRING(qbf-c,1,INDEX(qbf-c,".") - 1)
    qbf-file[1]     = SUBSTRING(qbf-c,INDEX(qbf-c,".") + 1)
    qbf-form.cValue = qbf-c + ','
                    + (IF qbf-q = SUBSTRING(qbf-file[1],1,8) THEN "" ELSE qbf-q)
                    + ',' + STRING(qbf-k,"9999")
    qbf-form.cDesc  = ""
    qbf-f           = "*"
    qbf-a-attr[1]   = qbf-q + ".f"
    qbf-a-attr[2]   = LC(qbf-file[1]) /* form name */
    qbf-a-attr[3]   = "default"
    qbf-c           = ENTRY(2,qbf-lang[6]) + ' "' + qbf-a-attr[1] + '".'.

  { prores/b-status.i &text=qbf-c } /*Working on form "<filename>".*/
  IF TERMINAL <> "" THEN
    DISPLAY STREAM qbf-io qbf-q + ".f" @ qbf-q WITH FRAME qbf-down.

  RUN prores/a-lookup.p (qbf-db[1],qbf-file[1],"","q",OUTPUT qbf-c).
  IF qbf-c = "NONE" THEN DO:
    /*Cannot build query form unless RECID or UNIQUE INDEX available.*/
    PUT UNFORMATTED "** " qbf-lang[22] SKIP.
    ASSIGN
      qbf-e           = TRUE
      qbf-f           = ""
      qbf-form.cValue = ""
      qbf-form.cDesc  = "".
    IF TERMINAL <> "" THEN
      DISPLAY STREAM qbf-io "" @ qbf-q WITH FRAME qbf-down.
  END.
  ELSE DO:
    { prores/b-debug.i &when="before" &what="f-guess " }
    RUN prores/f-guess.p (TRUE,INPUT-OUTPUT qbf-f).
    { prores/b-debug.i &when=" after" &what="f-guess " }

    { prores/b-debug.i &when="before" &what="f-write " }
    RUN prores/f-write.p (qbf-f).
    { prores/b-debug.i &when=" after" &what="f-write " }
    IF qbf-f = "" THEN DO:
      /*No fields left on form.  Query form not being generated.*/
      PUT UNFORMATTED "** " qbf-lang[25] SKIP.
      qbf-e = TRUE.
    END.
  END.

  IF qbf-f = "" THEN DO:
    ASSIGN
      qbf-form.cValue = ""
      qbf-form.cDesc  = "".
    IF TERMINAL <> "" THEN
      DISPLAY STREAM qbf-io "" @ qbf-q WITH FRAME qbf-down.
  END.
  ELSE DO:
    qbf-c = ENTRY(3,qbf-lang[6]) + ' "' + qbf-q + '.p"'.
    { prores/b-status.i &text=qbf-c } /*Working on program "<filename>.p"*/

    IF TERMINAL <> "" THEN
      DISPLAY STREAM qbf-io qbf-q + ".p" @ qbf-q WITH FRAME qbf-down.

    { prores/b-debug.i &when="before" &what="f-browse" }
    RUN prores/f-browse.p (qbf-db[1],qbf-file[1],qbf-f,OUTPUT qbf-b).
    { prores/b-debug.i &when=" after" &what="f-browse" }

    { prores/b-debug.i &when="before" &what="s-lookup" }
    RUN prores/a-lookup.p (qbf-db[1],qbf-file[1],qbf-f,"b",OUTPUT qbf-c).
    DO qbf-i = 1 TO { prores/s-limcol.i }:
      SUBSTRING(qbf-rca[qbf-i],4,1) =
        STRING(CAN-DO(qbf-b,qbf-rcn[qbf-i]),"y/n").
    END.
    { prores/b-debug.i &when=" after" &what="s-lookup" }

    { prores/b-debug.i &when="before" &what="q-write " }
    RUN prores/q-write.p (qbf-q).
    { prores/b-debug.i &when=" after" &what="q-write " }

  END.

  ASSIGN
    qbf-i = { prores/s-etime.i } - qbf-x
    qbf-c = qbf-db[1] + "." + qbf-file[1] + " "
          + qbf-lang[28] + " " + { prores/b-time.i qbf-i }.
  { prores/b-log.i &text=qbf-c } /*<filename> Elapsed time MM:SS.SS*/

  OUTPUT CLOSE.

  IF TERMINAL <> "" THEN DO WITH FRAME qbf-down:
    DISPLAY { prores/b-time.i qbf-i } @ qbf-c.
    COLOR DISPLAY NORMAL qbf-q qbf-f.
  END.

  /* checkpoint time! */
  IF qbf-k MODULO 10 = 0 OR qbf-k = qbf-form# THEN DO:
    { prores/b-check.i }
  END.

END.

/* clean out unnecessary variable usage in -l space */
RUN prores/s-zap.p.

/* pack the viewable file listing */
ASSIGN
  qbf-k     = qbf-form#
  qbf-form# = 0.
DO qbf-i = 1 TO qbf-k:
  {&FIND_QBF_FORM} qbf-i.
  IF qbf-form.cValue = "" THEN NEXT.
  ASSIGN
    qbf-form#           = qbf-form# + 1.

  {&FIND_BUF_FORM} qbf-form#.
  ASSIGN
    qbf-c               = ENTRY(1,qbf-form.cValue)
    qbf-c               = SUBSTRING(qbf-c,INDEX(qbf-c,".") + 1,8)
    buf-form.cValue     = ENTRY(1,qbf-form.cValue) + ','
                        + (IF ENTRY(2,qbf-form.cValue) = qbf-c THEN ""
                          ELSE ENTRY(2,qbf-form.cValue))
                        + ',' + STRING(qbf-form#,"9999")
    buf-form.cDesc      = ""
    buf-form.xValue     = qbf-form.xValue.
  IF qbf-i <> qbf-form# THEN
    ASSIGN
      qbf-form.cValue = ""
      qbf-form.cDesc  = ""
      qbf-form.xValue = "".
END.

OUTPUT TO VALUE(qbf-qcfile + ".ql") ECHO APPEND.
PUT UNFORMATTED FILL("-",76) SKIP.
RUN prores/b-join.p.
RUN prores/b-misc.p.
PUT UNFORMATTED FILL("-",76) SKIP.
qbf-c = qbf-lang[31] + ' "' + qbf-qcfile + '.qc"'.
{ prores/b-status.i &text=qbf-c } /*Writing config file "<dbname>.qc"*/

{ prores/a-fast.i }
RUN prores/a-fast.p (OUTPUT qbf-b).
RUN prores/a-write.p.

DO qbf-i = 1 TO NUM-ENTRIES(qbf-b):
  COMPILE VALUE(ENTRY(qbf-i,qbf-b)) SAVE ATTR-SPACE.
END.
RUN prores/a-zap.p (qbf-b).

PUT UNFORMATTED FILL("-",76) SKIP 'phase= compile' SKIP.
OUTPUT CLOSE.

STATUS DEFAULT.
PAUSE 0 BEFORE-HIDE.

IF TERMINAL <> "" THEN DO:
  PUT SCREEN ROW 4 COLUMN 3 qbf-lang[4]. /*"Compiling"*/
  CLEAR FRAME qbf-down ALL.
END.

ASSIGN
  qbf-t = (TODAY - qbf-d) * 86400 + TIME - qbf-s
  qbf-d = TODAY
  qbf-s = TIME.
DO qbf-k = 1 TO qbf-form#:
  {&FIND_QBF_FORM} qbf-k.
  ASSIGN
    qbf-x = { prores/s-etime.i }
    qbf-i = (TODAY - qbf-d) * 86400 + TIME - qbf-s
    qbf-q = ENTRY(2,qbf-form.cValue).
  IF qbf-q = "" THEN
    ASSIGN
      qbf-q = ENTRY(1,qbf-form.cValue)
      qbf-q = SUBSTRING(qbf-q,INDEX(qbf-q,".") + 1,8).

  IF TERMINAL <> "" THEN DO WITH FRAME qbf-down:
    PUT SCREEN ROW 4 COLUMN LENGTH(qbf-lang[4]) + 4
      STRING(qbf-k) + " " + qbf-xofy + " " + STRING(qbf-form#)
      + " (" + STRING(TRUNCATE(qbf-k / qbf-form# * 100,0)) + "%)      ".
    PUT SCREEN ROW 3 COLUMN 71
      STRING(TRUNCATE((qbf-i + qbf-t) / 3600,0),"99")
      + SUBSTRING(STRING((qbf-i + qbf-t) MODULO 3600,"HH:MM:SS"),3,6).
    qbf-i = (IF qbf-k = 1 THEN 0 ELSE qbf-i / (qbf-k - 1) * 1000).
    PUT SCREEN ROW 4 COLUMN 71 { prores/b-time.i qbf-i }.
    IF INPUT qbf-f = "" THEN .
    ELSE IF FRAME-LINE = FRAME-DOWN THEN SCROLL UP.
    ELSE DOWN 1.
    COLOR DISPLAY MESSAGES qbf-q qbf-f.
    DISPLAY qbf-q + ".r" @ qbf-q ENTRY(1,qbf-form.cValue) @ qbf-f.
  END.

  OUTPUT TO VALUE(qbf-qcfile + ".ql") ECHO APPEND.
  qbf-c = qbf-lang[4] + ' "' + qbf-q + '.p"'.
  { prores/b-log.i &text=qbf-c } /*Compiling "<filename>.p"*/
  IF SEARCH(qbf-q + ".r") <> ? THEN
    RUN prores/a-zap.p (qbf-q + ".r").
  HIDE MESSAGE NO-PAUSE.
  DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
    COMPILE VALUE(qbf-q + ".p") SAVE ATTR-SPACE.
  END.
  ASSIGN
    qbf-c = SEARCH(qbf-q + ".p")
    SUBSTRING(qbf-c,LENGTH(qbf-c),1) = "r".
  IF SEARCH(qbf-q + ".r") <> qbf-c THEN DO:
    ASSIGN
      qbf-e = TRUE
      qbf-c = qbf-lang[30]
      SUBSTRING(qbf-c,INDEX(qbf-c,"~{1~}"),3) = qbf-q + ".p".
    { prores/b-log.i &text=qbf-c } /*Compile of "{1}" failed*/
  END.

  OUTPUT CLOSE.
  qbf-i = { prores/s-etime.i } - qbf-x.
  IF TERMINAL <> "" THEN DO WITH FRAME qbf-down:
    DISPLAY { prores/b-time.i qbf-i } @ qbf-c.
    COLOR DISPLAY NORMAL qbf-q qbf-f.
  END.

END.

/*qbf-lang[29]="Done!"*/
OUTPUT TO VALUE(qbf-qcfile + ".ql") ECHO APPEND.
PUT UNFORMATTED 'phase= done' SKIP FILL("-",76) SKIP.
{ prores/b-log.i &text=qbf-lang[29] }
PUT UNFORMATTED FILL("-",76) SKIP.
OUTPUT CLOSE.

IF qbf-e AND TERMINAL <> "" THEN 
  RUN prores/b-browse.p (TRUE).

HIDE FRAME qbf-shadow.
HIDE FRAME qbf-down.
HIDE MESSAGE.
PAUSE BEFORE-HIDE.

{ prores/t-reset.i }
RETURN.
