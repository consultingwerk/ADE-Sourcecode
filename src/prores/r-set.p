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
/* r-set.p - D. Default Report Options */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/t-define.i }
{ prores/t-set.i &mod=r &set=2 }

DEFINE INPUT PARAMETER qbf-a AS LOGICAL NO-UNDO.
/*
  TRUE  - called from r-main.p (Report Writer)
  FALSE - called from a-main.p (Administration)
*/

DEFINE VARIABLE qbf-c AS CHARACTER           NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER             NO-UNDO.
DEFINE VARIABLE qbf-m AS CHARACTER EXTENT 12 NO-UNDO.
DEFINE VARIABLE qbf-s AS CHARACTER           NO-UNDO.
DEFINE VARIABLE qbf-t AS CHARACTER           NO-UNDO.

FORM SKIP(12)
  WITH FRAME r-box NO-LABELS NO-ATTR-SPACE OVERLAY
  ROW 2 COLUMN 22 WIDTH 34
  COLOR DISPLAY VALUE(qbf-mlo) PROMPT VALUE(qbf-mhi).
FORM
  WITH FRAME r-settings NO-LABELS ATTR-SPACE NO-BOX OVERLAY
  ROW (IF qbf-a THEN 3 ELSE 4)
  COLUMN (IF qbf-a THEN 23 ELSE 2)
  COLOR DISPLAY VALUE(qbf-mlo) PROMPT VALUE(qbf-mhi).

PAUSE 0.
/*"Press [END-ERROR] when done making changes."*/
IF qbf-a THEN
  VIEW FRAME r-box.
ELSE
  STATUS DEFAULT qbf-lang[32].

PAUSE 0.
ASSIGN
  qbf-s      = qbf-module
  qbf-module = "r5s".
ON CURSOR-DOWN TAB. ON CURSOR-UP BACK-TAB.

DO WHILE TRUE ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE WITH FRAME r-settings:
  /*
  15: F.  Formats and Labels | 21: RH. Right  Header
  16: P.  Page Ejects        | 22: LF. Left   Footer
  17: T.  Totals Only Report | 23: CF. Center Footer
  18: S.  Spacing            | 24: RF. Right  Footer
  19: LH. Left   Header      | 25: FO. First-page-only Header
  20: CH. Center Header      | 26: LO. Last-page-only  Footer
  */
  IF qbf-a AND qbf-file[1] <> "" THEN DISPLAY
    "  " + qbf-lang[15] @ qbf-m[ 1] FORMAT "x(30)" SKIP  /*F. Formats & Labels*/
    "  " + qbf-lang[16] @ qbf-m[ 2] FORMAT "x(30)" SKIP  /*P. Page Ejects*/
    "  " + qbf-lang[17] @ qbf-m[ 3] FORMAT "x(30)" SKIP. /*T. Ttls-Only Report*/
  DISPLAY
    "  " + qbf-lang[18] @ qbf-m[ 4] FORMAT "x(30)" SKIP  /*S. Spacing*/
    "  " + qbf-lang[19] @ qbf-m[ 5] FORMAT "x(30)" SKIP  /*LH. Left   H*/
    "  " + qbf-lang[20] @ qbf-m[ 6] FORMAT "x(30)" SKIP  /*CH. Center H*/
    "  " + qbf-lang[21] @ qbf-m[ 7] FORMAT "x(30)" SKIP  /*RH. Right  H*/
    "  " + qbf-lang[22] @ qbf-m[ 8] FORMAT "x(30)" SKIP  /*LF. Left   F*/
    "  " + qbf-lang[23] @ qbf-m[ 9] FORMAT "x(30)" SKIP  /*CF. Center F*/
    "  " + qbf-lang[24] @ qbf-m[10] FORMAT "x(30)" SKIP  /*RF. Right  F*/
    "  " + qbf-lang[25] @ qbf-m[11] FORMAT "x(30)" SKIP  /*FO. First-pg-only H*/
    "  " + qbf-lang[26] @ qbf-m[12] FORMAT "x(30)" SKIP. /*LO. Last-pg-only  F*/

  IF qbf-a AND qbf-file[1] <> "" THEN
    CHOOSE FIELD qbf-m[1 FOR 12] COLOR VALUE(qbf-mhi) AUTO-RETURN.
  ELSE
    CHOOSE FIELD qbf-m[4 FOR  9] COLOR VALUE(qbf-mhi) AUTO-RETURN.
  ON CURSOR-DOWN CURSOR-DOWN. ON CURSOR-UP CURSOR-UP.
  ASSIGN
    qbf-c = qbf-lang[FRAME-INDEX + 14]
    qbf-t = SUBSTRING(qbf-c,INDEX(qbf-c,".") + 2)
    qbf-i = INDEX(qbf-t,"  ").
  DO WHILE qbf-i > 0:
    ASSIGN
      SUBSTRING(qbf-t,qbf-i,2) = " "
      qbf-i = INDEX(qbf-t,"  ").
  END.
  IF qbf-a THEN DO:
    HIDE FRAME r-settings NO-PAUSE.
    HIDE FRAME r-box      NO-PAUSE.
  END.
  IF      FRAME-INDEX =  1 THEN RUN prores/s-format.p ("r",?).
  ELSE IF FRAME-INDEX =  2 THEN RUN prores/r-page.p.
  ELSE IF FRAME-INDEX =  3 THEN RUN prores/r-short.p.
  ELSE IF FRAME-INDEX =  4 THEN RUN prores/r-space.p.
  ELSE IF FRAME-INDEX =  5 THEN RUN prores/r-header.p ( 7,qbf-t).
  ELSE IF FRAME-INDEX =  6 THEN RUN prores/r-header.p (10,qbf-t).
  ELSE IF FRAME-INDEX =  7 THEN RUN prores/r-header.p (13,qbf-t).
  ELSE IF FRAME-INDEX =  8 THEN RUN prores/r-header.p (16,qbf-t).
  ELSE IF FRAME-INDEX =  9 THEN RUN prores/r-header.p (19,qbf-t).
  ELSE IF FRAME-INDEX = 10 THEN RUN prores/r-header.p (22,qbf-t).
  ELSE IF FRAME-INDEX = 11 THEN RUN prores/r-header.p ( 1,qbf-t).
  ELSE IF FRAME-INDEX = 12 THEN RUN prores/r-header.p ( 4,qbf-t).
  IF qbf-a THEN LEAVE.
END.

qbf-module = qbf-s.
ON CURSOR-DOWN CURSOR-DOWN. ON CURSOR-UP CURSOR-UP.
HIDE FRAME r-settings NO-PAUSE.
HIDE FRAME r-box      NO-PAUSE.
HIDE MESSAGE NO-PAUSE.
STATUS DEFAULT.
{ prores/t-reset.i }
RETURN.
