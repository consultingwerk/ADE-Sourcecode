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
/* s-define.p - file/field selection for d-main.p and r-main.p (l-main.p?) */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/t-define.i }
{ prores/t-set.i &mod=s &set=4 }

DEFINE VARIABLE qbf-c AS CHARACTER            NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER              NO-UNDO.
DEFINE VARIABLE qbf-m AS CHARACTER EXTENT  10 NO-UNDO.
DEFINE VARIABLE qbf-s AS CHARACTER            NO-UNDO.
DEFINE VARIABLE qbf-t AS CHARACTER INITIAL "" NO-UNDO.

{ prores/s-top.i } /* form statement */

FORM
  qbf-m[ 1] FORMAT "x(30)" SKIP
  qbf-m[ 2] FORMAT "x(30)" SKIP
  qbf-m[ 3] FORMAT "x(30)" SKIP
  qbf-m[ 4] FORMAT "x(30)" SKIP
  qbf-m[ 5] FORMAT "x(30)" SKIP
  qbf-m[ 6] FORMAT "x(30)" SKIP
  qbf-m[ 7] FORMAT "x(30)" "(+-*/)" SKIP
  qbf-m[ 8] FORMAT "x(30)" SKIP
  qbf-m[ 9] FORMAT "x(30)" SKIP
  qbf-m[10] FORMAT "x(30)" SKIP
  WITH FRAME qbf-define NO-LABELS ATTR-SPACE ROW 2 COLUMN 14 OVERLAY
  COLOR DISPLAY VALUE(qbf-mlo) PROMPT VALUE(qbf-mhi).

ASSIGN
  qbf-s      = qbf-module
  qbf-module = qbf-module + "4s".
ON CURSOR-UP BACK-TAB. ON CURSOR-DOWN TAB.

IF qbf-file[1] = "" THEN qbf-c = "A".
ELSE
DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
  qbf-c = (IF qbf-s = "l" THEN ""
          ELSE qbf-lang[IF qbf-s = "r" THEN 24 ELSE 21]).
  DISPLAY
    " " + qbf-lang[22] @ qbf-m[ 1] /*F. Fields*/
    " " + qbf-lang[23] @ qbf-m[ 2] /*A. Active Files*/
    " " + qbf-c        @ qbf-m[ 3] /*21:W. Width/Format & 24:T. Totals & Subs*/
    " " + qbf-lang[25] @ qbf-m[ 4] /*R. Running Total*/
    " " + qbf-lang[26] @ qbf-m[ 5] /*P. Percent Total*/
    " " + qbf-lang[27] @ qbf-m[ 6] /*C. Counters*/
    " " + qbf-lang[28] @ qbf-m[ 7] /*M. Math*/
    " " + qbf-lang[29] @ qbf-m[ 8] /*S. String Expr*/
    " " + qbf-lang[30] @ qbf-m[ 9] /*N. Numeric Expr*/
    " " + qbf-lang[31] @ qbf-m[10] /*D. Date Expr*/
  /*" " + qbf-lang[32] @ qbf-m[11]   L. Logical Expr*/
    WITH FRAME qbf-define NO-LABELS ATTR-SPACE ROW 2 COLUMN 14 OVERLAY
    COLOR DISPLAY VALUE(qbf-mlo) PROMPT VALUE(qbf-mhi).
  qbf-c = "".
  IF (qbf-s = "d" AND qbf-d-attr[1] <> "FIXED") OR qbf-s = "l" THEN
    CHOOSE FIELD qbf-m[1 FOR 2] qbf-m[4 FOR 7] COLOR VALUE(qbf-mhi) AUTO-RETURN
      WITH FRAME qbf-define.
  ELSE
    CHOOSE FIELD qbf-m[1 FOR 10] COLOR VALUE(qbf-mhi) AUTO-RETURN
      WITH FRAME qbf-define.
  HIDE FRAME qbf-define NO-PAUSE.
  qbf-c = SUBSTRING("FA" + STRING(qbf-s = "r","T/W") + "RPCMSNDL",
          FRAME-INDEX,1).
END.

ON CURSOR-UP CURSOR-UP. ON CURSOR-DOWN CURSOR-DOWN.
qbf-module = qbf-s.

IF qbf-c = "F" THEN 
  RUN prores/r-column.p.
ELSE
IF INDEX("RPCMSNDL",qbf-c) > 0 THEN
  RUN prores/r-calc.p (LC(qbf-c)).
ELSE
IF qbf-c = "A" THEN DO:
  DO qbf-i = 1 TO 5:
    RUN prores/r-file.p (qbf-i).
    DISPLAY { prores/s-draw.i } WITH FRAME qbf-top.
    IF KEYFUNCTION(LASTKEY) = "END-ERROR" or qbf-file[qbf-i] = "" THEN LEAVE.
  END.
  IF qbf-i > 1 THEN DO:
    RUN prores/r-file.p (- qbf-i).
    IF qbf-rc# = 0 THEN 
      RUN prores/r-column.p.
  END.
END.
ELSE
IF qbf-c = "T" THEN 
  RUN prores/r-total.p.
ELSE
IF qbf-c = "W" THEN 
  RUN prores/s-format.p ("d",?).

{ prores/t-reset.i }
RETURN.
