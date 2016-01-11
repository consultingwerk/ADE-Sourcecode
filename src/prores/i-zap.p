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
/* i-zap.p - mass delete of user directory items */

{ prores/s-system.i }
{ prores/t-define.i }
{ prores/i-define.i }

DEFINE INPUT PARAMETER qbf-m AS CHARACTER NO-UNDO. /* module type */

DEFINE VARIABLE qbf-b AS INTEGER                NO-UNDO. /* base ptr */
DEFINE VARIABLE qbf-d AS INTEGER                NO-UNDO. /* down */
DEFINE VARIABLE qbf-f AS LOGICAL   EXTENT { prores/s-limdir.i } NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-k AS INTEGER   INITIAL    0 NO-UNDO. /* # to delete */
DEFINE VARIABLE qbf-l AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-n AS INTEGER   INITIAL    ? NO-UNDO.
DEFINE VARIABLE qbf-o AS CHARACTER              NO-UNDO.
DEFINE VARIABLE qbf-r AS INTEGER                NO-UNDO. /* recid */
DEFINE VARIABLE qbf-t AS CHARACTER INITIAL   "" NO-UNDO. /* typed */
DEFINE VARIABLE qbf-u AS INTEGER                NO-UNDO. /* max */
DEFINE VARIABLE qbf-w AS LOGICAL   INITIAL TRUE NO-UNDO. /* redraw */
DEFINE VARIABLE qbf-x AS INTEGER                NO-UNDO. /* column */
DEFINE VARIABLE qbf-z AS CHARACTER              NO-UNDO. /* fmt of max */

IF qbf-dir-ent# = 0 THEN 
  RUN prores/i-read.p.

ASSIGN
  qbf-b = (IF qbf-m = "d" THEN qbf-d-lo
      ELSE IF qbf-m = "g" THEN qbf-g-lo
      ELSE IF qbf-m = "l" THEN qbf-l-lo
      ELSE IF qbf-m = "q" THEN qbf-q-lo
      ELSE                     qbf-r-lo)
  qbf-u = (IF qbf-m = "d" THEN qbf-d-hi
      ELSE IF qbf-m = "g" THEN qbf-g-hi
      ELSE IF qbf-m = "l" THEN qbf-l-hi
      ELSE IF qbf-m = "q" THEN qbf-q-hi
      ELSE                     qbf-r-hi) - qbf-b.

FORM
  qbf-f[qbf-r]       FORMAT "*/ " NO-ATTR-SPACE
  qbf-dir-ent[qbf-r] FORMAT "x(48)"
  WITH FRAME qbf-pick SCROLL 1 OVERLAY NO-LABELS ATTR-SPACE
  qbf-d DOWN ROW 3 COLUMN 5
  COLOR DISPLAY VALUE(qbf-plo) PROMPT VALUE(qbf-phi)
  TITLE COLOR VALUE(qbf-plo) " " + qbf-lang[9] + " " /*"Choose"*/
    + ENTRY(INDEX("dglqr",qbf-m),qbf-lang[12])
    + " " + ENTRY(3,qbf-lang[14]) + " ". /*"to Delete"*/
  /*12:"Export Formats,Graphs,Labels,Queries,Reports"*/

FORM
  qbf-t FORMAT "x(49)"
  WITH FRAME qbf-type OVERLAY NO-LABELS ATTR-SPACE
  ROW qbf-d + 5 COLUMN 5
  COLOR DISPLAY VALUE(qbf-plo) PROMPT VALUE(qbf-phi).

IF qbf-u <= 0 OR qbf-b <= 0 THEN RETURN.
{ prores/t-set.i &mod=i &set=0 }

ASSIGN
  qbf-z = FILL("Z",LENGTH(STRING(qbf-u)))
  qbf-x = 56 - LENGTH(qbf-z)
  qbf-d = MINIMUM(qbf-u,SCREEN-LINES - 9)
  qbf-r = 1
  qbf-t = "".

PAUSE 0 BEFORE-HIDE.
VIEW FRAME qbf-pick.

/*"All Marked objects will be deleted.  Use [RETURN] to mark/unmark."*/
/*"Press [GO] when done, or [END-ERROR] to not delete."*/
MESSAGE STRING(qbf-lang[19],"x(78)").
MESSAGE STRING(qbf-lang[20],"x(78)").

PUT SCREEN ROW qbf-d + 4 COLUMN qbf-x COLOR VALUE(qbf-plo) STRING(qbf-u).
qbf-x = qbf-x - LENGTH(qbf-xofy) - 1.
PUT SCREEN ROW qbf-d + 4 COLUMN qbf-x COLOR VALUE(qbf-plo) qbf-xofy.
qbf-x = qbf-x - LENGTH(qbf-z) - 1.

DO WHILE TRUE:

  qbf-r = MINIMUM(qbf-u,MAXIMUM(qbf-r,1)).
  IF qbf-r < FRAME-LINE(qbf-pick) THEN
    DOWN qbf-r - FRAME-LINE(qbf-pick) WITH FRAME qbf-pick.
  IF LENGTH(qbf-t) > 0 THEN
    DISPLAY qbf-t WITH FRAME qbf-type.
  ELSE
    HIDE FRAME qbf-type NO-PAUSE.

  IF qbf-w THEN DO:
    ASSIGN
      qbf-l = MAXIMUM(1,FRAME-LINE(qbf-pick))
      qbf-j = qbf-r - qbf-l + 1
      qbf-w = FALSE.
    UP qbf-l - 1 WITH FRAME qbf-pick.
    IF qbf-j < 1 THEN
      ASSIGN
        qbf-j = 1
        qbf-l = 1
        qbf-r = 1.
    DO qbf-i = qbf-j TO qbf-j + qbf-d - 1:
      IF qbf-i > qbf-u THEN
        CLEAR FRAME qbf-pick NO-PAUSE.
      ELSE
        DISPLAY qbf-f[qbf-i] @ qbf-f[qbf-r]
          { prores/i-pick.i qbf-i 1 } @ qbf-dir-ent[qbf-r]
          WITH FRAME qbf-pick.
      IF qbf-i < qbf-j + qbf-d - 1 THEN
        DOWN 1 WITH FRAME qbf-pick.
    END.
    UP qbf-d - qbf-l WITH FRAME qbf-pick.
    PUT SCREEN ROW qbf-d + 4 COLUMN 7 COLOR VALUE(qbf-plo)
      ENTRY(qbf-toggle4,qbf-lang[6]). /*"Desc,Program,Database"*/
  END.

  DISPLAY qbf-f[qbf-r] { prores/i-pick.i qbf-r 1 } @ qbf-dir-ent[qbf-r]
    WITH FRAME qbf-pick.

  PUT SCREEN ROW qbf-d + 4 COLUMN qbf-x COLOR VALUE(qbf-plo)
    STRING(qbf-r,qbf-z).
  COLOR DISPLAY VALUE(qbf-phi) qbf-f[qbf-r] qbf-dir-ent[qbf-r]
    WITH FRAME qbf-pick.
  READKEY.
  COLOR DISPLAY VALUE(qbf-plo) qbf-f[qbf-r] qbf-dir-ent[qbf-r]
    WITH FRAME qbf-pick.

  IF (KEYFUNCTION(LASTKEY) = CHR(LASTKEY) AND LASTKEY >= 32)
    OR (KEYFUNCTION(LASTKEY) = "BACKSPACE" AND LENGTH(qbf-t) > 0) THEN DO:
    qbf-t = (IF KEYFUNCTION(LASTKEY) = "BACKSPACE"
            THEN SUBSTRING(qbf-t,1,LENGTH(qbf-t) - 1)
            ELSE qbf-t + CHR(LASTKEY)).
    IF qbf-t = "" OR { prores/i-pick.i qbf-r 1 } BEGINS qbf-t THEN NEXT.
    DO qbf-l = qbf-r TO qbf-u:
      IF { prores/i-pick.i qbf-l 1 } BEGINS qbf-t THEN LEAVE.
    END.
    IF qbf-l > qbf-u THEN DO:
      DO qbf-l = 1 TO qbf-r:
        IF { prores/i-pick.i qbf-l 1 } BEGINS qbf-t THEN LEAVE.
      END.
      IF qbf-l > qbf-r THEN qbf-l = qbf-u + 1.
    END.
    IF qbf-l > qbf-u THEN DO:
      qbf-t = CHR(LASTKEY).
      DO qbf-l = 1 TO qbf-u:
        IF { prores/i-pick.i qbf-l 1 } BEGINS qbf-t THEN LEAVE.
      END.
    END.
    ASSIGN
      qbf-l = (IF qbf-l <= qbf-u THEN qbf-l ELSE qbf-r)
      qbf-j = qbf-l - qbf-r + FRAME-LINE(qbf-pick)
      qbf-r = qbf-l.
    IF qbf-j < 1 OR qbf-j > qbf-d THEN
      qbf-w = TRUE.
    ELSE
      UP FRAME-LINE(qbf-pick) - qbf-j WITH FRAME qbf-pick.
    NEXT.
  END.

  qbf-t = "".
  IF KEYFUNCTION(LASTKEY) = "INSERT-MODE" THEN
    ASSIGN
      qbf-w       = TRUE
      qbf-toggle4 = (qbf-toggle4 MODULO 3) + 1.
  IF KEYFUNCTION(LASTKEY) = "RETURN" THEN DO:
    ASSIGN
      qbf-k        = qbf-k + (IF qbf-f[qbf-r] THEN -1 ELSE 1)
      qbf-f[qbf-r] = NOT qbf-f[qbf-r].
    DISPLAY qbf-f[qbf-r] WITH FRAME qbf-pick.
  END.
  IF CAN-DO("RETURN,CURSOR-DOWN,TAB",KEYFUNCTION(LASTKEY))
    AND qbf-r < qbf-u THEN DO:
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
    IF qbf-r + qbf-d - FRAME-LINE(qbf-pick) > qbf-u THEN DO:
      qbf-r = qbf-u.
      DOWN MINIMUM(qbf-u,qbf-d) - FRAME-LINE(qbf-pick) WITH FRAME qbf-pick.
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
      qbf-r = (IF qbf-r > 1 THEN 1 ELSE qbf-u)
      qbf-w = TRUE.
    UP FRAME-LINE(qbf-pick) - (IF qbf-r = 1 THEN 1 ELSE qbf-d)
      WITH FRAME qbf-pick.
  END.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "END-ERROR"
    OR (qbf-k = 0 AND KEYFUNCTION(LASTKEY) = "GO") THEN DO:
    HIDE FRAME qbf-pick NO-PAUSE.
    HIDE FRAME qbf-type NO-PAUSE.
    HIDE MESSAGE        NO-PAUSE.
    PAUSE BEFORE-HIDE.
    { prores/t-reset.i }
    RETURN.
  END.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "GO" THEN LEAVE.

END.

HIDE MESSAGE NO-PAUSE.
MESSAGE qbf-lang[15]. /*"Working..."*/

RUN prores/s-prefix.p (qbf-dir-nam,OUTPUT qbf-t).
ASSIGN
  qbf-n = 0
  qbf-t = qbf-t
        + (IF qbf-m = "d" THEN "exp"
      ELSE IF qbf-m = "g" THEN "gfx"
      ELSE IF qbf-m = "l" THEN "lbl"
      ELSE IF qbf-m = "q" THEN "qry"
      ELSE                     "rep").

DO qbf-i = 1 TO qbf-u:
  IF qbf-f[qbf-i] THEN DO:
    qbf-dir-ent[qbf-i + qbf-b] = ?.
    NEXT.
  END.
  qbf-n = qbf-n + 1.
  IF qbf-n = qbf-i THEN NEXT.
  ASSIGN
    qbf-dir-ent[qbf-n + qbf-b] = qbf-dir-ent[qbf-i + qbf-b]
    qbf-dir-dbs[qbf-n + qbf-b] = qbf-dir-dbs[qbf-i + qbf-b]
    qbf-dir-flg[qbf-n + qbf-b] = qbf-dir-flg[qbf-i + qbf-b]
    qbf-dir-ent[qbf-i + qbf-b] = ?
    qbf-o = qbf-lang[21] /*"Moving number {1} to position {2}."*/
    SUBSTRING(qbf-o,INDEX(qbf-o,"~{1~}"),3) = STRING(qbf-i)
    SUBSTRING(qbf-o,INDEX(qbf-o,"~{2~}"),3) = STRING(qbf-n).
  HIDE MESSAGE NO-PAUSE.
  MESSAGE qbf-o.
  IF OPSYS = "UNIX" THEN
    UNIX SILENT cp
      VALUE(qbf-t + STRING(qbf-i,"99999") + ".p")
      VALUE(qbf-t + STRING(qbf-n,"99999") + ".p").
  ELSE IF OPSYS = "MSDOS" THEN
    DOS SILENT copy
      VALUE(qbf-t + STRING(qbf-i,"99999") + ".p")
      VALUE(qbf-t + STRING(qbf-n,"99999") + ".p") ">nul".
  ELSE IF OPSYS = "OS2" THEN
    OS2 SILENT copy
      VALUE(qbf-t + STRING(qbf-i,"99999") + ".p")
      VALUE(qbf-t + STRING(qbf-n,"99999") + ".p") ">nul".
  ELSE IF OPSYS = "BTOS" THEN
    BTOS SILENT OS-COPY
      VALUE(qbf-t + STRING(qbf-i,"99999") + ".p")
      VALUE(qbf-t + STRING(qbf-n,"99999") + ".p").
  ELSE IF OPSYS = "VMS" THEN
    VMS SILENT copy
      VALUE(qbf-t + STRING(qbf-i,"99999") + ".p")
      VALUE(qbf-t + STRING(qbf-n,"99999") + ".p").
END.
DO WHILE qbf-n < qbf-u:
  ASSIGN
    qbf-n = qbf-n + 1
    qbf-o = qbf-lang[22] /*"Deleting number {1}."*/
    SUBSTRING(qbf-o,INDEX(qbf-o,"~{1~}"),3) = STRING(qbf-n).
  HIDE MESSAGE NO-PAUSE.
  MESSAGE qbf-o.  /*"Deleting number"*/
  RUN prores/a-zap.p (qbf-t + STRING(qbf-n,"99999") + ".p").
END.

HIDE MESSAGE NO-PAUSE.
/*"Writing out updated report directory..."*/
MESSAGE qbf-lang[24].

IF SEARCH(qbf-dir-nam) = ? THEN
  OUTPUT TO VALUE(qbf-dir-nam) NO-ECHO.
ELSE
  OUTPUT TO VALUE(SEARCH(qbf-dir-nam)) NO-ECHO.

PUT UNFORMATTED
  '/*' SKIP
  'config= directory'  SKIP
  'version= ' qbf-vers SKIP.

qbf-o = "".
DO qbf-i = 1 TO qbf-dir-ent#:
  IF   qbf-i = qbf-d-lo OR qbf-i = qbf-g-lo OR qbf-i = qbf-l-lo
    OR qbf-i = qbf-q-lo OR qbf-i = qbf-r-lo
    OR qbf-dir-ent[qbf-i] = ? THEN NEXT.
  qbf-t = (IF qbf-i <= qbf-d-hi THEN 'export'
      ELSE IF qbf-i <= qbf-g-hi THEN 'graph'
      ELSE IF qbf-i <= qbf-l-hi THEN 'label'
      ELSE IF qbf-i <= qbf-q-hi THEN 'query'
      ELSE                           'report').
  IF qbf-t = qbf-o THEN
    qbf-k = qbf-k + 1.
  ELSE
    ASSIGN
      qbf-k = 1
      qbf-o = qbf-t.
  PUT CONTROL qbf-t STRING(qbf-k) '= '.
  EXPORT qbf-dir-ent[qbf-i] qbf-dir-dbs[qbf-i].
END.

PUT UNFORMATTED '*/' SKIP.
OUTPUT CLOSE.

RUN prores/i-read.p. /* refresh cache */

HIDE FRAME qbf-pick NO-PAUSE.
HIDE FRAME qbf-type NO-PAUSE.
HIDE MESSAGE        NO-PAUSE.
PAUSE BEFORE-HIDE.

{ prores/t-reset.i }
RETURN.
