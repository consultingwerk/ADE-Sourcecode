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
/* s-order.p - build BY clauses */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/t-define.i }
{ prores/t-set.i &mod=s &set=4 }

DEFINE VARIABLE qbf-a  AS LOGICAL            NO-UNDO.
DEFINE VARIABLE qbf-c  AS CHARACTER          NO-UNDO.
DEFINE VARIABLE qbf-d  AS LOGICAL   EXTENT 5 NO-UNDO.
DEFINE VARIABLE qbf-i  AS INTEGER            NO-UNDO.
DEFINE VARIABLE qbf-j  AS INTEGER            NO-UNDO.
DEFINE VARIABLE qbf-k  AS INTEGER            NO-UNDO.
DEFINE VARIABLE qbf-l  AS INTEGER            NO-UNDO.
DEFINE VARIABLE qbf-m  AS CHARACTER EXTENT 5 NO-UNDO.
DEFINE VARIABLE qbf-n  AS CHARACTER          NO-UNDO. /*1st char of false [15]*/
DEFINE VARIABLE qbf-o  AS CHARACTER          NO-UNDO.
DEFINE VARIABLE qbf-v1 AS CHARACTER          NO-UNDO.
DEFINE VARIABLE qbf-v2 AS CHARACTER          NO-UNDO.
DEFINE VARIABLE qbf-v3 AS CHARACTER          NO-UNDO.
DEFINE VARIABLE qbf-v4 AS CHARACTER          NO-UNDO.
DEFINE VARIABLE qbf-v5 AS CHARACTER          NO-UNDO.
DEFINE VARIABLE qbf-y  AS CHARACTER          NO-UNDO. /*1st char of true [15]*/

FORM
  qbf-v1 FORMAT "x(8)" ATTR-SPACE qbf-order[1] FORMAT "x(40)" SKIP
  qbf-v2 FORMAT "x(8)" ATTR-SPACE qbf-order[2] FORMAT "x(40)" SKIP
  qbf-v3 FORMAT "x(8)" ATTR-SPACE qbf-order[3] FORMAT "x(40)" SKIP
  qbf-v4 FORMAT "x(8)" ATTR-SPACE qbf-order[4] FORMAT "x(40)" SKIP
  qbf-v5 FORMAT "x(8)" ATTR-SPACE qbf-order[5] FORMAT "x(40)" SKIP(1)
  HEADER
  qbf-lang[16] FORMAT "x(50)" SKIP /*For each component, type "a" for*/
  qbf-lang[17] FORMAT "x(50)" SKIP /*ascending or "d" for descending.*/
  WITH ROW 2 COLUMN 27 OVERLAY NO-LABELS NO-ATTR-SPACE
  COLOR DISPLAY VALUE(qbf-mlo) PROMPT VALUE(qbf-mhi) WITH FRAME qbf-sort.

/* qbf-lang[15] holds the display string for "asc/desc" */
ASSIGN
  qbf-a    = FALSE
  qbf-o    = ""
  qbf-d    = TRUE
  qbf-y    = SUBSTRING(qbf-lang[15],1,1)
  qbf-n    = SUBSTRING(qbf-lang[15],INDEX(qbf-lang[15],"/") + 1,1)
  qbf-m[1] = qbf-order[1]
  qbf-m[2] = qbf-order[2]
  qbf-m[3] = qbf-order[3]
  qbf-m[4] = qbf-order[4]
  qbf-m[5] = qbf-order[5].
DO qbf-i = 1 TO 5 WHILE qbf-order[qbf-i] <> "":
  ASSIGN
    qbf-l = INDEX(qbf-order[qbf-i]," DESC") - 1
    qbf-l = (IF qbf-l <= 0 THEN LENGTH(qbf-order[qbf-i]) ELSE qbf-l)
    qbf-o = qbf-o + (IF qbf-i = 1 THEN "" ELSE ",")
          + SUBSTRING(qbf-order[qbf-i],1,qbf-l).
END.

RUN prores/c-field.p ("*field","r002c032",INPUT-OUTPUT qbf-o).
IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN DO:
  { prores/t-reset.i }
  RETURN.
END.

qbf-order = "".
DO qbf-i = 1 TO 5:
  ASSIGN
    qbf-order[qbf-i] = ENTRY(qbf-i,qbf-o + ",,,,")
    qbf-a            = qbf-a OR qbf-order[qbf-i] <> "".
  DO qbf-j = 1 TO 5:
    IF qbf-m[qbf-j] BEGINS qbf-order[qbf-i] AND qbf-m[qbf-j] MATCHES "* DESC"
      THEN qbf-d[qbf-i] = FALSE.
  END.
  IF qbf-order[qbf-i] = "" AND qbf-r-attr[9] >= qbf-i THEN
    qbf-r-attr[9] = qbf-r-attr[9] - 1.
END.

IF qbf-a THEN DO:
  DISPLAY qbf-order[1 FOR 5] WITH FRAME qbf-sort.
  DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE WITH FRAME qbf-sort:
    UPDATE
      qbf-v1 WHEN qbf-order[1] <> ""
      qbf-v2 WHEN qbf-order[2] <> ""
      qbf-v3 WHEN qbf-order[3] <> ""
      qbf-v4 WHEN qbf-order[4] <> ""
      qbf-v5 WHEN qbf-order[5] <> ""
      EDITING:
        ASSIGN
          qbf-v1 = STRING(qbf-d[1],qbf-lang[15])
          qbf-v2 = STRING(qbf-d[2],qbf-lang[15])
          qbf-v3 = STRING(qbf-d[3],qbf-lang[15])
          qbf-v4 = STRING(qbf-d[4],qbf-lang[15])
          qbf-v5 = STRING(qbf-d[5],qbf-lang[15]).
        DISPLAY
          qbf-v1 WHEN qbf-v1 <> INPUT qbf-v1 AND qbf-order[1] <> ""
          qbf-v2 WHEN qbf-v2 <> INPUT qbf-v2 AND qbf-order[2] <> ""
          qbf-v3 WHEN qbf-v3 <> INPUT qbf-v3 AND qbf-order[3] <> ""
          qbf-v4 WHEN qbf-v4 <> INPUT qbf-v4 AND qbf-order[4] <> ""
          qbf-v5 WHEN qbf-v5 <> INPUT qbf-v5 AND qbf-order[5] <> "".
        IF NOT FRAME-FIELD BEGINS "qbf-v" THEN APPLY KEYCODE(KBLABEL("TAB")).
        READKEY.
        IF LENGTH(KEYFUNCTION(LASTKEY)) > 1 THEN
          APPLY LASTKEY.
        ELSE
          ASSIGN
            qbf-i        = INTEGER(SUBSTRING(FRAME-FIELD,6))
            qbf-d[qbf-i] = (IF     CHR(LASTKEY) = qbf-y THEN TRUE
                           ELSE IF CHR(LASTKEY) = qbf-n THEN FALSE
                           ELSE qbf-d[qbf-i]).
      END.

    DO qbf-i = 1 TO 5 WHILE qbf-order[qbf-i] <> "":
      qbf-order[qbf-i] = qbf-order[qbf-i]
                       + (IF qbf-d[qbf-i] THEN "" ELSE " DESC").
    END.
  END.
END.

{ prores/s-order.i }

HIDE FRAME qbf-sort NO-PAUSE.
{ prores/t-reset.i }
RETURN.
