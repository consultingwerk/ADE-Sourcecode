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
/* r-header.p - get header/footer definitions from user */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/t-define.i }
{ prores/t-set.i &mod=r &set=1 }

DEFINE INPUT PARAMETER qbf-e AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER qbf-t AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-a AS LOGICAL   INITIAL FALSE NO-UNDO. /*insert*/
DEFINE VARIABLE qbf-f AS CHARACTER               NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER                 NO-UNDO.
DEFINE VARIABLE qbf-m AS CHARACTER EXTENT      3 NO-UNDO.
DEFINE VARIABLE qbf-o AS CHARACTER               NO-UNDO.

{ prores/c-field.i
  &new=NEW &down=13 &row="ROW 4" &column="COLUMN 36" &title=qbf-f
}

PAUSE 0.

ASSIGN /*2: "Line" */
  qbf-m[1] = FILL(" ",7 - LENGTH(qbf-lang[2])) + qbf-lang[2] + " #1:"
  qbf-m[2] = FILL(" ",7 - LENGTH(qbf-lang[2])) + qbf-lang[2] + " #2:"
  qbf-m[3] = FILL(" ",7 - LENGTH(qbf-lang[2])) + qbf-lang[2] + " #3:".

FORM SKIP(1)
  qbf-m[1]  NO-ATTR-SPACE FORMAT "x(11)"
    qbf-r-head[qbf-e    ] FORMAT "x(50)" SKIP
  qbf-m[2]  NO-ATTR-SPACE FORMAT "x(11)"
    qbf-r-head[qbf-e + 1] FORMAT "x(50)" SKIP
  qbf-m[3]  NO-ATTR-SPACE FORMAT "x(11)"
    qbf-r-head[qbf-e + 2] FORMAT "x(50)" SKIP(1)
  HEADER
  /*"Enter expressions for the"*/
  qbf-lang[1] + " " + qbf-t FORMAT "x(62)" SKIP
  WITH FRAME r-head ROW 3 COLUMN 8 WIDTH 66 NO-LABELS OVERLAY ATTR-SPACE.

FORM
  /*{COUNT}  Records listed so far  :  {TIME}  Time report started*/
  /*{TODAY}  Today's date           :  {NOW}   Current time       */
  /*{PAGE}   Current page number    :  {USER}  User running report*/
  /*{VALUE <expression>;<format>} to insert variables             */
  qbf-lang[4] FORMAT "x(64)" SKIP
  qbf-lang[5] FORMAT "x(64)" SKIP
  qbf-lang[6] FORMAT "x(64)" SKIP
  qbf-lang[7] FORMAT "x(64)" SKIP
  HEADER
  /*These functions are available for use in header and footer text*/
  qbf-lang[3] FORMAT "x(64)" SKIP
  WITH FRAME r-func ROW 12 COLUMN 8 WIDTH 66 NO-LABELS OVERLAY NO-ATTR-SPACE.
IF qbf-file[1] = "" AND INDEX(qbf-lang[7],"(") > 0 THEN
  qbf-lang[7] = SUBSTRING(qbf-lang[7],1,INDEX(qbf-lang[7],"(") - 1).

DISPLAY qbf-m[1 FOR 3] WITH FRAME r-head.
DISPLAY qbf-lang[4 FOR 4] WITH FRAME r-func.
DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  IF qbf-file[1] <> "" THEN
    STATUS INPUT qbf-lang[9].
  /* Press [GO] to save, [GET] to insert field, [END-ERROR] to undo. */
  UPDATE qbf-r-head[qbf-e] qbf-r-head[qbf-e + 1] qbf-r-head[qbf-e + 2]
    WITH FRAME r-head
    EDITING:
      READKEY.
      IF KEYFUNCTION(LASTKEY) = "INSERT-MODE" THEN qbf-a = NOT qbf-a.
      IF KEYFUNCTION(LASTKEY) = "GET" AND qbf-file[1] <> "" THEN DO:
        ASSIGN
          qbf-f = " " + qbf-lang[8] + " " /*Choose Field to Insert*/
          qbf-o = "".
        STATUS INPUT "".
        VIEW FRAME qbf-pick.
        RUN prores/s-field.p ("*field","","!raw,!rowid,*",INPUT-OUTPUT qbf-o).
        HIDE FRAME qbf-pick NO-PAUSE.
        STATUS INPUT qbf-lang[9].
        IF qbf-o <> "" THEN DO:
          RUN prores/s-lookup.p (qbf-o,"","","FIELD:TYP&FMT",OUTPUT qbf-f).
          IF NOT qbf-a THEN 
            APPLY KEYCODE(KBLABEL("INSERT-MODE")).
          qbf-o = qbf-left + "VALUE " + qbf-o + ";"
                + SUBSTRING(qbf-f,INDEX(qbf-f,",") + 1) + qbf-right.
          DO qbf-i = 1 TO LENGTH(qbf-o):
            APPLY ASC(SUBSTRING(qbf-o,qbf-i,1)).
          END.
          IF NOT qbf-a THEN APPLY KEYCODE(KBLABEL("INSERT-MODE")).
        END.
      END.
      ELSE
        APPLY LASTKEY.
    END.
END.

IF qbf-r-head[qbf-e    ] = ? THEN qbf-r-head[qbf-e    ] = "".
IF qbf-r-head[qbf-e + 1] = ? THEN qbf-r-head[qbf-e + 1] = "".
IF qbf-r-head[qbf-e + 2] = ? THEN qbf-r-head[qbf-e + 2] = "".

/* slide up lines to remove gaps */
/*
IF qbf-r-head[qbf-e] = "" THEN ASSIGN
  qbf-r-head[qbf-e    ] = qbf-r-head[qbf-e + 1]
  qbf-r-head[qbf-e + 1] = qbf-r-head[qbf-e + 2]
  qbf-r-head[qbf-e + 2] = "".
IF qbf-r-head[qbf-e] = "" THEN ASSIGN
  qbf-r-head[qbf-e    ] = qbf-r-head[qbf-e + 1]
  qbf-r-head[qbf-e + 1] = "".
IF qbf-r-head[qbf-e + 1] = "" THEN ASSIGN
  qbf-r-head[qbf-e + 1] = qbf-r-head[qbf-e + 2]
  qbf-r-head[qbf-e + 2] = "".
*/

HIDE FRAME r-func NO-PAUSE.
HIDE FRAME r-head NO-PAUSE.
STATUS INPUT.

{ prores/t-reset.i }
RETURN.
