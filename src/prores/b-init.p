/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* b-init.p - build initialization */

{ prores/s-system.i }
{ prores/t-define.i }

DEFINE VARIABLE qbf-a AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-b AS LOGICAL   NO-UNDO.
DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO.

/*-----------------------------------------------------------------------+
2                                                                        |
3         There are three ways to build query forms for PROGRESS         |
4         RESULTS.  At any time after the query forms are built,         |
5         they can be manually tailored.                                 |
6                                                                        |
7 +----------+                                                           |
8 | MANUAL   |  You want to manually define each query form.             |
9 +----------+                                                           |
0                                                                        |
1 +----------+  After you pick a subset of files from the connected      |
2 | SEMI     |  databases, RESULTS will generate query forms only        |
3 +----------+  for the selected files.                                  |
4                                                                        |
5 +----------+                                                           |
6 | AUTO     |  RESULTS will generate all query forms automatically.     |
7 +----------+                                                           |
8                                                                        |
9-----------------------------------------------------------------------*/

FORM
  SKIP(1)
  qbf-lang[21] FORMAT "x(72)" SKIP
  qbf-lang[22] FORMAT "x(72)" SKIP
  qbf-lang[23] FORMAT "x(72)" SKIP(1)
  SPACE(15) qbf-lang[24] FORMAT "x(56)" SKIP
  SPACE(15) qbf-lang[25] FORMAT "x(56)" SKIP /*auto*/
  SPACE(15) qbf-lang[26] FORMAT "x(56)" SKIP(1)
  SPACE(15) qbf-lang[27] FORMAT "x(56)" SKIP
  SPACE(15) qbf-lang[28] FORMAT "x(56)" SKIP /*semi*/
  SPACE(15) qbf-lang[29] FORMAT "x(56)" SKIP(1)
  SPACE(15) qbf-lang[30] FORMAT "x(56)" SKIP
  SPACE(15) qbf-lang[31] FORMAT "x(56)" SKIP /*manual*/
  SPACE(15) qbf-lang[32] FORMAT "x(56)" SKIP(1)
  WITH FRAME qbf-bot OVERLAY NO-LABELS NO-ATTR-SPACE
  COLUMN 1 ROW 1 COLOR DISPLAY VALUE(qbf-mlo) PROMPT VALUE(qbf-mhi)
  TITLE COLOR VALUE(qbf-mlo) " " + qbf-product + " ".

FORM
  qbf-c FORMAT "x(8)"
  WITH FRAME qbf-one OVERLAY NO-LABELS ATTR-SPACE COLUMN 3 ROW 7
  COLOR DISPLAY VALUE(qbf-mlo) PROMPT VALUE(qbf-mhi).
FORM
  qbf-c FORMAT "x(8)"
  WITH FRAME qbf-two OVERLAY NO-LABELS ATTR-SPACE COLUMN 3 ROW 11
  COLOR DISPLAY VALUE(qbf-mlo) PROMPT VALUE(qbf-mhi).
FORM
  qbf-c FORMAT "x(8)"
  WITH FRAME qbf-thr OVERLAY NO-LABELS ATTR-SPACE COLUMN 3 ROW 15
  COLOR DISPLAY VALUE(qbf-mlo) PROMPT VALUE(qbf-mhi).

HIDE ALL NO-PAUSE.
/* even tho no .qc file, this still initializes other vars */
RUN prores/a-load.p (OUTPUT qbf-b).

/* batch mode build for our own ccall script:compres */
IF TERMINAL = "" THEN DO:
  RUN prores/b-build.p (3).
  QUIT.
END.

{ prores/t-set.i &mod=a &set=1 }
qbf-b = TRUE.
/*The file "DBNAME.qc" was not found.  This means*/
/*that you need to do an "Initial Build" on this */
/*database.  Do you want to do this now?         */
RUN prores/s-box.p (INPUT-OUTPUT qbf-b,?,?,
  qbf-lang[10] + ' "' + qbf-qcfile + '.qc" ' + qbf-lang[11]).
IF NOT qbf-b THEN QUIT.

PAUSE 0.
DISPLAY qbf-lang[21 FOR 12] WITH FRAME qbf-bot.
PAUSE 0.
/* qbf-lang[15] = "MANUAL,SEMI,AUTO" */
DISPLAY ENTRY(1,qbf-lang[15]) @ qbf-c WITH FRAME qbf-one.
DISPLAY ENTRY(2,qbf-lang[15]) @ qbf-c WITH FRAME qbf-two.
DISPLAY ENTRY(3,qbf-lang[15]) @ qbf-c WITH FRAME qbf-thr.
PAUSE 0.
qbf-a = 3.

DO WHILE TRUE:
  COLOR DISPLAY VALUE(IF qbf-a = 1 THEN qbf-mhi ELSE qbf-mlo) qbf-c
    WITH FRAME qbf-one.
  COLOR DISPLAY VALUE(IF qbf-a = 2 THEN qbf-mhi ELSE qbf-mlo) qbf-c
    WITH FRAME qbf-two.
  COLOR DISPLAY VALUE(IF qbf-a = 3 THEN qbf-mhi ELSE qbf-mlo) qbf-c
    WITH FRAME qbf-thr.
  PUT CURSOR COLUMN 13 ROW qbf-a * 4 + 4.
  READKEY.
  IF      CHR(LASTKEY) = SUBSTRING(ENTRY(1,qbf-lang[15]),1,1) THEN qbf-a = 1.
  ELSE IF CHR(LASTKEY) = SUBSTRING(ENTRY(2,qbf-lang[15]),1,1) THEN qbf-a = 2.
  ELSE IF CHR(LASTKEY) = SUBSTRING(ENTRY(3,qbf-lang[15]),1,1) THEN qbf-a = 3.
  ELSE IF CAN-DO("TAB,*-DOWN,*RIGHT*, ",KEYFUNCTION(LASTKEY)) THEN
    qbf-a = (IF qbf-a = 3 THEN 1 ELSE qbf-a + 1).
  ELSE IF CAN-DO("BACK-TAB,*-UP,*LEFT*",KEYFUNCTION(LASTKEY)) THEN
    qbf-a = (IF qbf-a = 1 THEN 3 ELSE qbf-a - 1).
  ELSE IF CAN-DO("RETURN,GO,END-ERROR",KEYFUNCTION(LASTKEY)) THEN LEAVE.
  ELSE BELL.
END.

PUT CURSOR OFF.
HIDE FRAME qbf-one NO-PAUSE.
HIDE FRAME qbf-two NO-PAUSE.
HIDE FRAME qbf-thr NO-PAUSE.
HIDE FRAME qbf-bot NO-PAUSE.

IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN QUIT.

/* 1=manual 2=semi 3=auto 4=continue-from-checkpoint */
RUN prores/b-build.p (qbf-a).

RETURN.
