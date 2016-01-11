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
/* i-pick.p - scrolling list of user directory items */

{ prores/s-system.i }
{ prores/t-define.i }
{ prores/i-define.i }

DEFINE INPUT  PARAMETER qbf-m AS CHARACTER NO-UNDO. /*module*/
DEFINE INPUT  PARAMETER qbf-g AS LOGICAL   NO-UNDO. /*TRUE=get,FALSE=put*/
DEFINE INPUT-OUTPUT PARAMETER qbf-n AS CHARACTER NO-UNDO. /*name*/
DEFINE OUTPUT PARAMETER qbf-o AS INTEGER   NO-UNDO. /*position in dir*/

DEFINE VARIABLE qbf-b AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-d AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-l AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-p AS INTEGER   INITIAL    ? NO-UNDO.
DEFINE VARIABLE qbf-r AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-t AS CHARACTER INITIAL   "" NO-UNDO.
DEFINE VARIABLE qbf-u AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-w AS LOGICAL   INITIAL TRUE NO-UNDO.
DEFINE VARIABLE qbf-x AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-z AS CHARACTER              NO-UNDO.

ASSIGN
  qbf-b = (IF     qbf-m = "d" THEN qbf-d-lo
          ELSE IF qbf-m = "g" THEN qbf-g-lo
          ELSE IF qbf-m = "l" THEN qbf-l-lo
          ELSE IF qbf-m = "q" THEN qbf-q-lo
          ELSE                     qbf-r-lo) - 1
      /*- (IF qbf-g THEN 0 ELSE 1)*/
  qbf-u = (IF     qbf-m = "d" THEN qbf-d-hi
          ELSE IF qbf-m = "g" THEN qbf-g-hi
          ELSE IF qbf-m = "l" THEN qbf-l-hi
          ELSE IF qbf-m = "q" THEN qbf-q-hi
          ELSE                     qbf-r-hi) - qbf-b.

FORM
  qbf-dir-flg[qbf-r] FORMAT "*/ " NO-ATTR-SPACE
  qbf-dir-ent[qbf-r] FORMAT "x(48)"
  WITH FRAME qbf-pick SCROLL 1 OVERLAY NO-LABELS ATTR-SPACE
  qbf-d DOWN ROW 4 COLUMN 5
  COLOR DISPLAY VALUE(qbf-plo) PROMPT VALUE(qbf-phi)
  TITLE COLOR VALUE(qbf-plo) " " + qbf-lang[9] + " " /*"Choose"*/
    + ENTRY(INDEX("dglqr",qbf-m),qbf-lang[10])
    + " " + ENTRY(IF qbf-g THEN 1 ELSE 2,qbf-lang[14]) + " ".
/*10:"an Export Format,a Graph,a Label,a Query,a Report"*/
/*14:"to Load,to Save,to Delete"*/

FORM
  qbf-t FORMAT "x(49)"
  WITH FRAME qbf-type OVERLAY NO-LABELS ATTR-SPACE
  ROW qbf-d + 6 COLUMN 5
  COLOR DISPLAY VALUE(qbf-plo) PROMPT VALUE(qbf-phi).

IF qbf-u <= 0 OR qbf-b < 0 THEN RETURN.
{ prores/t-set.i &mod=i &set=0 }

ASSIGN
  qbf-r = 1
  qbf-d = SCREEN-LINES - 10
  qbf-t = qbf-lang[IF qbf-g THEN 16 ELSE 17]
  SUBSTRING(qbf-t,INDEX(qbf-t,"~{1~}"),3)
        = ENTRY(INDEX("dglqr",qbf-m),qbf-lang[11])
  qbf-dir-ent[qbf-b + 1] = "<<" + qbf-t + ">>".
/*11:"export format,graph,label,query,report"*/
/*16:"grab {1} from another directory"*/
/*17:"save as new {1}"*/

IF qbf-n <> "" AND qbf-n <> ? THEN DO:
  DO qbf-j = 1 TO qbf-u:
    IF qbf-n = qbf-dir-ent[qbf-j + qbf-b] THEN LEAVE.
  END.
  IF qbf-j <= qbf-u THEN
    ASSIGN
      qbf-p = MINIMUM(qbf-d,qbf-j)
      qbf-r = qbf-j.
END.

ASSIGN
  qbf-d = MINIMUM(qbf-u,qbf-d)
  qbf-n = ?
  qbf-z = FILL("Z",LENGTH(STRING(qbf-u)))
  qbf-x = 56 - LENGTH(qbf-z)
  qbf-t = "".

PAUSE 0 BEFORE-HIDE.
VIEW FRAME qbf-pick.

PUT SCREEN ROW qbf-d + 5 COLUMN qbf-x COLOR VALUE(qbf-plo) STRING(qbf-u).
qbf-x = qbf-x - LENGTH(qbf-xofy) - 1.
PUT SCREEN ROW qbf-d + 5 COLUMN qbf-x COLOR VALUE(qbf-plo) qbf-xofy.
qbf-x = qbf-x - LENGTH(qbf-z) - 1.

STATUS DEFAULT qbf-lang[23].
/* Press [GO] to select, [INSERT-MODE] to    */
/* toggle name/desc/db, [END-ERROR] to exit. */

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
      qbf-j = qbf-r - (IF qbf-p = ? THEN qbf-l ELSE qbf-p) + 1.
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
        DISPLAY
          qbf-dir-flg[qbf-i + qbf-b] @ qbf-dir-flg[qbf-r]
          { prores/i-pick.i qbf-i }         @ qbf-dir-ent[qbf-r]
          WITH FRAME qbf-pick.
      IF qbf-i < qbf-j + qbf-d - 1 THEN
        DOWN 1 WITH FRAME qbf-pick.
    END.
    qbf-l = (IF qbf-p = ? THEN qbf-l ELSE qbf-p).
    UP qbf-d - qbf-l WITH FRAME qbf-pick.
    ASSIGN
      qbf-p = ?
      qbf-w = FALSE.
    PUT SCREEN ROW qbf-d + 5 COLUMN 7 COLOR VALUE(qbf-plo)
      ENTRY(qbf-toggle4,qbf-lang[6]). /*"Desc,Program,Database"*/
  END.

  DISPLAY
    qbf-dir-flg[qbf-r + qbf-b] @ qbf-dir-flg[qbf-r]
    { prores/i-pick.i qbf-r }         @ qbf-dir-ent[qbf-r]
    WITH FRAME qbf-pick.

  PUT SCREEN ROW qbf-d + 5 COLUMN qbf-x COLOR VALUE(qbf-plo)
    STRING(qbf-r,qbf-z).
  COLOR DISPLAY VALUE(qbf-phi) qbf-dir-ent[qbf-r] WITH FRAME qbf-pick.
  READKEY.
  COLOR DISPLAY VALUE(qbf-plo) qbf-dir-ent[qbf-r] WITH FRAME qbf-pick.

  IF (KEYFUNCTION(LASTKEY) = CHR(LASTKEY) AND LASTKEY >= 32)
    OR (KEYFUNCTION(LASTKEY) = "BACKSPACE" AND LENGTH(qbf-t) > 0) THEN DO:
    qbf-t = (IF KEYFUNCTION(LASTKEY) = "BACKSPACE"
            THEN SUBSTRING(qbf-t,1,LENGTH(qbf-t) - 1)
            ELSE qbf-t + CHR(LASTKEY)).
    IF qbf-t = "" OR { prores/i-pick.i qbf-r } BEGINS qbf-t THEN NEXT.
    DO qbf-l = qbf-r TO qbf-u:
      IF { prores/i-pick.i qbf-l } BEGINS qbf-t THEN LEAVE.
    END.
    IF qbf-l > qbf-u THEN DO:
      DO qbf-l = 1 TO qbf-r:
        IF { prores/i-pick.i qbf-l } BEGINS qbf-t THEN LEAVE.
      END.
      IF qbf-l > qbf-r THEN qbf-l = qbf-u + 1.
    END.
    IF qbf-l > qbf-u THEN DO:
      qbf-t = CHR(LASTKEY).
      DO qbf-l = 1 TO qbf-u:
        IF { prores/i-pick.i qbf-l } BEGINS qbf-t THEN LEAVE.
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
  IF CAN-DO("CURSOR-DOWN,TAB",KEYFUNCTION(LASTKEY))
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
  IF CAN-DO("GO,RETURN",KEYFUNCTION(LASTKEY)) THEN DO:
    ASSIGN
      qbf-n = qbf-dir-ent[qbf-r + qbf-b]
      qbf-o = qbf-r - 1. /*(IF qbf-g THEN 0 ELSE 1)*/
    LEAVE.
  END.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "HELP" THEN DO:
    RUN prores/applhelp.p.
    PUT SCREEN ROW qbf-d + 5 COLUMN 7 COLOR VALUE(qbf-plo)
      ENTRY(qbf-toggle4,qbf-lang[6]). /*"Desc,Program,Database"*/
    PUT SCREEN ROW qbf-d + 5 COLUMN qbf-x + LENGTH(qbf-z) + 1
      COLOR VALUE(qbf-plo) qbf-xofy.
    PUT SCREEN ROW qbf-d + 5 COLUMN qbf-x + LENGTH(qbf-z + qbf-xofy) + 2
      COLOR VALUE(qbf-plo) STRING(qbf-u).
  END.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN LEAVE.

END.

HIDE FRAME qbf-pick NO-PAUSE.
HIDE FRAME qbf-type NO-PAUSE.
PAUSE BEFORE-HIDE.
STATUS DEFAULT.

{ prores/t-reset.i }
RETURN.
