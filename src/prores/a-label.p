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
/* a-label.p - patterns for label-field guessing */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/t-define.i }
{ prores/t-set.i &mod=a &set=8 }

DEFINE VARIABLE qbf-c AS CHARACTER           NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER             NO-UNDO.
DEFINE VARIABLE qbf-l AS CHARACTER EXTENT 10 NO-UNDO.
DEFINE VARIABLE qbf-m AS CHARACTER EXTENT 10 NO-UNDO.
DEFINE VARIABLE qbf-s AS CHARACTER           NO-UNDO
  INITIAL "name,addr1,addr2,addr3,city,state,zip,zip+4,csz,country".

DO qbf-i = 1 TO 10:
  ASSIGN
    qbf-l[qbf-i] = SUBSTRING(ENTRY(qbf-i,qbf-lang[9]),1,5)
    qbf-l[qbf-i] = FILL(" ",5 - LENGTH(qbf-l[qbf-i])) + qbf-l[qbf-i] + ":".
  /*qbf-lang[9]:"Name,Addr1,Addr2,Addr3,City,State,Zip,Zip+4,C-S-Z,Cntry"*/
END.

/* Enter the field names that hold the address information.  Use CAN-DO  */
/* style lists for matching these field-names ("*" matches any number of */
/* characters, "." matches any one character).  This information is used */
/* for creating default mailing labels.  Note that some entries may be   */
/* redundant - for example, if you always store city, state and zip in   */
/* separate fields, you do not need to use the "C-S-Z" line.             */
DISPLAY
  qbf-lang[1] FORMAT "x(78)" SKIP
  qbf-lang[2] FORMAT "x(78)" SKIP
  qbf-lang[3] FORMAT "x(78)" SKIP
  qbf-lang[4] FORMAT "x(78)" SKIP
  qbf-lang[5] FORMAT "x(78)" SKIP
  qbf-lang[6] FORMAT "x(78)" SKIP
  qbf-lang[7] FORMAT "x(78)" SKIP
  qbf-lang[8] FORMAT "x(78)" SKIP
  WITH FRAME qbf-instr ROW 3 COLUMN 2 NO-BOX NO-LABELS NO-ATTR-SPACE OVERLAY.

/*
  10: "Field containing <name>"
  11: "Field containing <first> line of address (e.g. street)"
  12: "Field containing <second> line of address (e.g. PO Box)"
  13: "Field containing <third> line of address (optional)"
  14: "Field containing name of <city>"
  15: "Field containing name of <state>"
  16: "Field containing <zip code> (5 or 9 digits)"
  17: "Field containing <last four digits> of zip code"
  18: "Field containing <combined city-state-zip>"
  19: "Field containing <country>"
*/
FORM
  qbf-l[ 1] FORMAT "x(6)" qbf-l-auto[ 1] FORMAT "x(70)" ATTR-SPACE SKIP
  qbf-l[ 2] FORMAT "x(6)" qbf-l-auto[ 2] FORMAT "x(70)" ATTR-SPACE SKIP
  qbf-l[ 3] FORMAT "x(6)" qbf-l-auto[ 3] FORMAT "x(70)" ATTR-SPACE SKIP
  qbf-l[ 4] FORMAT "x(6)" qbf-l-auto[ 4] FORMAT "x(70)" ATTR-SPACE SKIP
  qbf-l[ 5] FORMAT "x(6)" qbf-l-auto[ 5] FORMAT "x(70)" ATTR-SPACE SKIP
  qbf-l[ 6] FORMAT "x(6)" qbf-l-auto[ 6] FORMAT "x(70)" ATTR-SPACE SKIP
  qbf-l[ 7] FORMAT "x(6)" qbf-l-auto[ 7] FORMAT "x(70)" ATTR-SPACE SKIP
  qbf-l[ 8] FORMAT "x(6)" qbf-l-auto[ 8] FORMAT "x(70)" ATTR-SPACE SKIP
  qbf-l[ 9] FORMAT "x(6)" qbf-l-auto[ 9] FORMAT "x(70)" ATTR-SPACE SKIP
  qbf-l[10] FORMAT "x(6)" qbf-l-auto[10] FORMAT "x(70)" ATTR-SPACE SKIP
  WITH FRAME qbf-fields
  ROW 11 COLUMN 2 NO-BOX NO-ATTR-SPACE NO-LABELS OVERLAY.

/* to avoid time-consuming redraw in color normal after leaving update */
COLOR DISPLAY INPUT
  qbf-l-auto[1 FOR 10]
  WITH FRAME qbf-fields.

DISPLAY qbf-l qbf-l-auto[1 FOR 10] WITH FRAME qbf-fields.

DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:

  qbf-c = "".
  SET qbf-l-auto[1 FOR 10]
    WITH FRAME qbf-fields
    EDITING:
      /* the following block pretends that "help" allows an expression */
      IF FRAME-INDEX = 0 THEN APPLY KEYCODE(KBLABEL("TAB")).
      IF qbf-c <> qbf-lang[FRAME-INDEX + 9] THEN DO:
        qbf-c = qbf-lang[FRAME-INDEX + 9].
        STATUS INPUT qbf-c.
      END.
      READKEY.
      APPLY LASTKEY.
    END.

  DO qbf-i = 1 TO 10:
    IF qbf-l-auto[qbf-i] = ? THEN qbf-l-auto[qbf-i] = "".
  END.

END.

STATUS INPUT.
HIDE FRAME qbf-fields NO-PAUSE.
HIDE FRAME qbf-instr  NO-PAUSE.

{ prores/t-reset.i }
RETURN.
