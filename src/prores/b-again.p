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
/* b-again.p - recompile query forms when schema changed or database ported */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/t-define.i }
{ prores/c-form.i }
{ prores/a-define.i NEW }
{ prores/t-set.i &mod=b &set=1 }
{ prores/reswidg.i }
{ prores/resfunc.i }

DEFINE INPUT PARAMETER qbf-z AS LOGICAL NO-UNDO.
/*
qbf-z - "lazy" rebuild.  if true, only rebuilds forms which are
        missing .r's.  called with qbf-z = TRUE by a-form.p.
*/

DEFINE VARIABLE qbf-b AS CHARACTER   NO-UNDO.
DEFINE VARIABLE qbf-c AS CHARACTER   NO-UNDO.
DEFINE VARIABLE qbf-d AS DATE        NO-UNDO.
DEFINE VARIABLE qbf-f AS CHARACTER   NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER     NO-UNDO.
DEFINE VARIABLE qbf-k AS INTEGER     NO-UNDO.
DEFINE VARIABLE qbf-l AS LOGICAL     NO-UNDO.
DEFINE VARIABLE qbf-m AS CHARACTER   NO-UNDO EXTENT 4.
DEFINE VARIABLE qbf-q AS CHARACTER   NO-UNDO.
DEFINE VARIABLE qbf-s AS INTEGER     NO-UNDO.
DEFINE VARIABLE qbf-t AS INTEGER     NO-UNDO.
DEFINE VARIABLE qbf-u AS LOGICAL     NO-UNDO INITIAL TRUE. /*DEBUG code*/
DEFINE VARIABLE qbf-x AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE qbf-a2
  FIELD iIndex AS INTEGER LABEL "Index"
  FIELD lValue AS LOGICAL LABEL "Value"
  INDEX iIndex IS UNIQUE iIndex.
DEFINE BUFFER buf-a2 FOR qbf-a2.
&GLOBAL-DEFINE FIND_QBF_A2 FIND qbf-a2 WHERE qbf-a2.iIndex =
&GLOBAL-DEFINE FIND_BUF_A2 FIND buf-a2 WHERE buf-a2.iIndex =

DEFINE STREAM qbf-io.
IF TERMINAL <> "" THEN 
  OUTPUT STREAM qbf-io TO TERMINAL.
PAUSE 0.

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
  WITH FRAME qbf-shadow 10 DOWN ROW 3 COLUMN 2 NO-ATTR-SPACE NO-BOX OVERLAY.

FORM
  qbf-l FORMAT "*/ "      ATTR-SPACE SPACE(0)
  qbf-q FORMAT "x(10)" NO-ATTR-SPACE SPACE(0)
  qbf-f FORMAT "x(54)"    ATTR-SPACE SPACE(0)
  qbf-c FORMAT "x(8)"  NO-ATTR-SPACE
  WITH FRAME qbf-down OVERLAY NO-LABELS NO-BOX
  SCREEN-LINES - 8 DOWN ROW 8 COLUMN 2.

/*message "[b-again.p]" skip view-as alert-box.*/
  
PAUSE 0.
IF TERMINAL <> "" THEN DO:
  DISPLAY " " @ qbf-q WITH FRAME qbf-shadow.
  DOWN 4 WITH FRAME qbf-shadow.
  UNDERLINE qbf-q WITH FRAME qbf-shadow.
  qbf-c = ENTRY(1,qbf-lang[16]). /*"Elapsed time"*/
  PUT SCREEN ROW 3 COLUMN 68 - LENGTH(qbf-c) qbf-c + " =".
  qbf-c = ENTRY(2,qbf-lang[16]). /*"Average time"*/
  PUT SCREEN ROW 4 COLUMN 68 - LENGTH(qbf-c) qbf-c + " =".
  IF NOT qbf-z THEN
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
PAUSE 0.

ASSIGN
  qbf-d = TODAY
  qbf-s = TIME.
IF qbf-z THEN
FOR EACH qbf-form:
  CREATE qbf-a2.
  ASSIGN 
    qbf-a2.iIndex = qbf-form.iIndex
    qbf-a2.lValue = TRUE. /* lazy recompile assumes all forms up-to-date */
END.
ELSE
DO qbf-k = 1 TO qbf-form#:
  {&FIND_QBF_FORM} qbf-k.
  CREATE qbf-a2.
  ASSIGN
    qbf-a2.iIndex = qbf-k
    qbf-x         = { prores/s-etime.i }
    qbf-i         = (TODAY - qbf-d) * 86400 + TIME - qbf-s
    qbf-f         = ENTRY(1,qbf-form.cValue)
    qbf-q         = ENTRY(2,qbf-form.cValue)
    qbf-q         = (IF qbf-q = "" THEN 
                       SUBSTRING(qbf-f,INDEX(qbf-f,".") + 1,8)
                     ELSE qbf-q).

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
    DISPLAY qbf-q qbf-f.
  END.

  OUTPUT TO VALUE(qbf-qcfile + ".ql") ECHO APPEND.
  PUT UNFORMATTED FILL("-",76) SKIP.

  qbf-c = qbf-lang[20] + ' "' + ENTRY(1,qbf-form.cValue) + '".'.
  { prores/b-log.i &text=qbf-c } /*rebuilding file "<filename>"*/

  /* from s-zap.p */
  ASSIGN
    qbf-name    = ""   /* <-- file stuff */
    qbf-order   = ""
    qbf-file    = ""
    qbf-where   = ""
    qbf-of      = ""
    qbf-rc#     = 0    /* <-- field stuff */
    qbf-rcn     = ""
    qbf-rcl     = ""
    qbf-rcf     = ""
    qbf-rca     = ""
    qbf-rcc     = ""
    qbf-rcw     = ?
    qbf-rct     = 0
    qbf-form-ok = FALSE /* <-- local stuff */
    qbf-c       = ENTRY(1,qbf-form.cValue)
    qbf-q       = ENTRY(2,qbf-form.cValue)
    qbf-db[1]   = SUBSTRING(qbf-c,1,INDEX(qbf-c,".") - 1)
    qbf-file[1] = SUBSTRING(qbf-c,INDEX(qbf-c,".") + 1)
    qbf-q       = (IF qbf-q = "" THEN SUBSTRING(qbf-c,INDEX(qbf-c,".") + 1,8)
                  ELSE qbf-q)
    qbf-f       = ""
    qbf-b       = (IF INDEX(qbf-c,".") = 0 THEN LDBNAME("RESULTSDB")
                  ELSE SUBSTRING(qbf-c,1,INDEX(qbf-c,".") - 1))
    qbf-c       = qbf-lang[21]
    SUBSTRING(qbf-c,INDEX(qbf-c,"~{1~}"),3) = qbf-q.
  { prores/b-status.i &text=qbf-c } /*Scanning form "{1}" for changes*/

  CREATE ALIAS "QBF$0" FOR DATABASE VALUE(SDBNAME(qbf-b)).
  { prores/b-debug.i &when="before" &what="q-read  " }
  RUN prores/q-read.p (qbf-q).
  ASSIGN
    qbf-f = ""
    qbf-b = "".
  DO qbf-i = 1 TO { prores/s-limcol.i } WHILE qbf-rcn[qbf-i] <> "":
    IF SUBSTRING(qbf-rca[qbf-i],1,3) <> "nnn" THEN
      qbf-f = qbf-f + (IF qbf-f = "" THEN "" ELSE ",") + qbf-rcn[qbf-i].
    IF SUBSTRING(qbf-rca[qbf-i],4,1) = "y" THEN
      qbf-b = qbf-b + (IF qbf-b = "" THEN "" ELSE ",") + qbf-rcn[qbf-i].
  END.
  { prores/b-debug.i &when=" after" &what="q-read  " }

  IF SEARCH(qbf-q + ".i") = ? THEN 
    qbf-form-ok = FALSE.
  IF SEARCH(qbf-a-attr[1]) = ? AND qbf-a-attr[3] = "default" THEN
    qbf-form-ok = FALSE.

  IF qbf-form-ok THEN DO:
    { prores/b-log.i &text=qbf-lang[23] } /*Form unchanged.*/
    qbf-a2.lValue = TRUE.
  END.
  ELSE IF qbf-f = "" THEN DO:
    { prores/b-log.i &text=qbf-lang[26] } /*No fields on form.  Query deleted.*/
    ASSIGN
      qbf-form.cValue = ""
      qbf-form.cDesc  = "".
  END.
  ELSE DO:
    qbf-c = ENTRY(2,qbf-lang[6]) + ' "' + qbf-a-attr[1] + '".'.
    { prores/b-status.i &text=qbf-c } /*Working on form "<filename>".*/
    IF TERMINAL <> "" THEN
      DISPLAY STREAM qbf-io qbf-q + ".f" @ qbf-q WITH FRAME qbf-down.

    IF qbf-a-attr[3] = "default" THEN DO:
      { prores/b-debug.i &when="before" &what="f-write " }
      RUN prores/f-write.p (qbf-f).
      { prores/b-debug.i &when=" after" &what="f-write " }
    END.

    qbf-c = ENTRY(3,qbf-lang[6]) + ' "' + qbf-q + '.p"'.
    { prores/b-status.i &text=qbf-c } /*Working on program "<filename>.p"*/
    IF TERMINAL <> "" THEN
      DISPLAY STREAM qbf-io qbf-q + ".p" @ qbf-q WITH FRAME qbf-down.

    { prores/b-debug.i &when="before" &what="f-browse" }
    IF qbf-b = "" THEN
      RUN prores/f-browse.p
        (qbf-db[1],qbf-file[1],qbf-f,OUTPUT qbf-b).
    { prores/b-debug.i &when=" after" &what="f-browse" }

    { prores/b-debug.i &when="before" &what="s-lookup" }
    RUN prores/a-lookup.p
      (qbf-db[1],qbf-file[1],qbf-f,"b",OUTPUT qbf-c).
    DO qbf-i = 1 TO { prores/s-limcol.i }:
      SUBSTRING(qbf-rca[qbf-i],4,1)
        = STRING(CAN-DO(qbf-b,qbf-rcn[qbf-i]),"y/n").
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
END. /* qbf-k = 1 TO qbf-form# */

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
    qbf-form# = qbf-form# + 1.

  {&FIND_BUF_FORM} qbf-form#.
  {&FIND_QBF_A2} qbf-i.
  {&FIND_BUF_A2} qbf-form#.
  ASSIGN
    buf-a2.lValue       = qbf-a2.lValue
    buf-form.cValue     = qbf-form.cValue
    buf-form.cDesc      = qbf-form.cDesc 
    buf-form.xValue     = qbf-form.xValue.
  IF qbf-i <> qbf-form# THEN
    ASSIGN
      qbf-form.cValue = ""
      qbf-form.cDesc  = ""
      qbf-form.xValue = "".
END.

OUTPUT TO VALUE(qbf-qcfile + ".ql") ECHO APPEND.
PUT UNFORMATTED FILL("-",76) SKIP 'phase= recompile' SKIP.
OUTPUT CLOSE.

STATUS DEFAULT.
PAUSE 0 BEFORE-HIDE.

IF TERMINAL <> "" THEN DO:
  PUT SCREEN ROW 4 COLUMN 3 qbf-lang[5]. /*"Re-Compiling"*/
  CLEAR FRAME qbf-down ALL.
END.

ASSIGN
  qbf-t = (TODAY - qbf-d) * 86400 + TIME - qbf-s
  qbf-d = TODAY
  qbf-s = TIME
  qbf-l = FALSE. /* any failed compilations? */
DO qbf-k = 1 TO qbf-form#:
  {&FIND_QBF_FORM} qbf-k.
  {&FIND_QBF_A2} qbf-k.
  ASSIGN
    qbf-x = { prores/s-etime.i }
    qbf-i = (TODAY - qbf-d) * 86400 + TIME - qbf-s
    qbf-f = ENTRY(1,qbf-form.cValue)
    qbf-q = ENTRY(2,qbf-form.cValue)
    qbf-q = (IF qbf-q = "" THEN 
               SUBSTRING(qbf-f,INDEX(qbf-f,".") + 1,8)
             ELSE qbf-q).

  /* look for missing .r's */
  ASSIGN
    qbf-c = SEARCH(qbf-q + ".p")
    qbf-b = SEARCH(qbf-q + ".r")
    SUBSTRING(qbf-c,LENGTH(qbf-c),1) = "r".
  IF qbf-c BEGINS "./" THEN 
    qbf-c = SUBSTRING(qbf-c,3).
  IF qbf-b BEGINS "./" THEN 
    qbf-b = SUBSTRING(qbf-b,3).
  IF qbf-c <> qbf-b THEN 
    qbf-a2.lValue = FALSE.
  IF qbf-z AND qbf-a2.lValue THEN NEXT.

  IF TERMINAL <> "" THEN DO WITH FRAME qbf-down:
    PUT SCREEN ROW 4 COLUMN LENGTH(qbf-lang[5]) + 4
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
    DISPLAY qbf-q + ".r" @ qbf-q qbf-f.
  END.

  OUTPUT TO VALUE(qbf-qcfile + ".ql") ECHO APPEND.
  /*24: 'HH:MM:SS "<filename>.p" does not need recompiling.'*/
  /* 5: 'HH:MM:SS Re-Compiling "<filename>.p"'*/
  qbf-c = (IF qbf-a2.lValue THEN
             '"' + qbf-q + '.p" ' + qbf-lang[24]
           ELSE
             qbf-lang[5] + ' "' + qbf-q + '.p"').
  { prores/b-log.i &text=qbf-c }

  IF NOT qbf-a2.lValue THEN DO:
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
        qbf-l = TRUE
        qbf-c = qbf-lang[30]
        SUBSTRING(qbf-c,INDEX(qbf-c,"~{1~}"),3) = qbf-q + ".p".
      { prores/b-log.i &text=qbf-c } /*Compile of "{1}" failed*/
    END.
  END.

  OUTPUT CLOSE.
  qbf-i = { prores/s-etime.i } - qbf-x.
  IF TERMINAL <> "" THEN DO WITH FRAME qbf-down:
    DISPLAY (IF qbf-a2.lValue THEN "   --" ELSE { prores/b-time.i qbf-i }) @ qbf-c.
    COLOR DISPLAY NORMAL qbf-q qbf-f.
  END.

END.

/*qbf-lang[29]="Done!"*/
OUTPUT TO VALUE(qbf-qcfile + ".ql") ECHO APPEND.
PUT UNFORMATTED 'phase= done' SKIP FILL("-",76) SKIP.
{ prores/b-log.i &text=qbf-lang[29] }
PUT UNFORMATTED FILL("-",76) SKIP.
OUTPUT CLOSE.

IF qbf-l AND TERMINAL <> "" THEN 
  RUN prores/b-browse.p (FALSE).

HIDE FRAME qbf-shadow.
HIDE FRAME qbf-down.
HIDE MESSAGE.
PAUSE BEFORE-HIDE.

{ prores/t-reset.i }
RETURN.
