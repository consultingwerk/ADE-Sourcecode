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
/* r-short.p - summary report options */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/t-define.i }

{ prores/t-set.i &mod=r &set=5 }

DEFINE VARIABLE qbf-a AS LOGICAL   NO-UNDO.
DEFINE VARIABLE qbf-b AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-p AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-w AS LOGICAL   NO-UNDO. /* was already summary */

DEFINE VARIABLE qbf-m AS CHARACTER EXTENT 17 NO-UNDO.

FORM
  qbf-m[ 1] FORMAT "x(33)" SKIP
  qbf-m[ 2] FORMAT "x(33)" SKIP
  qbf-m[ 3] FORMAT "x(33)" SKIP
  qbf-m[ 4] FORMAT "x(33)" SKIP
  qbf-m[ 5] FORMAT "x(33)" SKIP
  qbf-m[ 6] FORMAT "x(33)" SKIP
  qbf-m[ 7] FORMAT "x(33)" SKIP
  qbf-m[ 8] FORMAT "x(33)" SKIP
  qbf-m[ 9] FORMAT "x(33)" SKIP
  qbf-m[10] FORMAT "x(33)" SKIP
  qbf-m[11] FORMAT "x(33)" SKIP
  qbf-m[12] FORMAT "x(33)" SKIP
  qbf-m[13] FORMAT "x(33)" SKIP
  qbf-m[14] FORMAT "x(33)" SKIP
  qbf-m[15] FORMAT "x(33)" SKIP
  qbf-m[16] FORMAT "x(33)" SKIP
  qbf-m[17] FORMAT "x(33)" SKIP
  WITH FRAME qbf-what ROW 3 COLUMN 1 NO-ATTR-SPACE OVERLAY NO-LABELS.

IF qbf-order[1] = "" THEN DO:
  /* Sorry, the "Totals Only" option cannot be selected   */
  /* until you choose the "Order" fields for sorting your */
  /* report.^^Please select these order fields using the  */
  /* "Order" option from the main Report menu, and then   */
  /* re-select this option.                               */
  RUN prores/s-error.p ("#4").
  RETURN.
END.

DO qbf-i = 0 TO 4
  WHILE qbf-order[qbf-i + 1] <> "":
END.
ASSIGN
  qbf-b = qbf-order[qbf-i]
  qbf-w = qbf-r-attr[8] = 1
  qbf-a = qbf-w
  qbf-c = qbf-lang[1]
  SUBSTRING(qbf-c,INDEX(qbf-c,"~{1~}"),3) = qbf-b.
RUN prores/s-box.p (INPUT-OUTPUT qbf-a,"#2","#3",qbf-c).
/*
1: Defining a Totals Only report "collapses" the report
   output to show only summary information.  Based on the
   last field in your "Order" list, a new line of output
   will be generated each time that order field value
   changes.^For the report you are currently defining, a
   new line of output will be generated each time the ~{1~}
   field changes.^Make this a Totals Only report?
2: ENABLE
3: DISABLE
*/

IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN RETURN.
IF NOT qbf-a THEN DO:
  DO qbf-i = 1 TO qbf-rc#:
    qbf-p = INDEX(qbf-rca[qbf-i],"$").
    IF qbf-p > 0 THEN SUBSTRING(qbf-rca[qbf-i],qbf-p,1) = "".
  END.
  qbf-r-attr[8] = 0.
  RETURN.
END.

qbf-r-attr[8] = 1. /* make summary report. */

/*
make initial guess at which fields should be summarized.  must be:
  1. non-calculated
  2. numeric (integer or decimal)
  3. non-index component
  4. non-array
*/
IF NOT qbf-w THEN
  DO qbf-i = 1 TO qbf-rc#:
    qbf-c = ?.
    IF (qbf-rct[qbf-i] = 4 OR qbf-rct[qbf-i] = 5)
      /*AND INDEX(qbf-rcn[qbf-i],"[") = 0*/ THEN
      RUN prores/s-lookup.p
        (qbf-rcn[qbf-i],"","","FIELD:INDEX-FIELD",OUTPUT qbf-c).
    IF qbf-c = "n" THEN qbf-rca[qbf-i] = qbf-rca[qbf-i] + "$".
  END.

/* load up help text */
qbf-i = 0.
IF LENGTH(qbf-b) > 33 THEN
  qbf-b = "..." + SUBSTRING(qbf-b,LENGTH(qbf-b) - 29,30).
DO qbf-p = 1 TO 17:
  IF qbf-m[qbf-p] = "" THEN DO:
    qbf-i = qbf-i + 1.
    IF qbf-i = 4 THEN LEAVE.
    ASSIGN
      qbf-m[qbf-p] = qbf-lang[qbf-i + 6]
      qbf-j        = INDEX(qbf-m[qbf-p],"~{1~}").
    IF qbf-j > 0 THEN SUBSTRING(qbf-m[qbf-p],qbf-j,3) = qbf-b.
  END.

  IF LENGTH(qbf-m[qbf-p]) < 33 THEN
    qbf-p = qbf-p + 1. /* skip line */
  ELSE
    ASSIGN
      qbf-j            = R-INDEX(SUBSTRING(qbf-m[qbf-p],1,33)," ")
      qbf-j            = (IF qbf-j = 0 THEN 33 ELSE qbf-j)
      qbf-m[qbf-p + 1] = TRIM(SUBSTRING(qbf-m[qbf-p],qbf-j + 1))
      qbf-m[qbf-p    ] = TRIM(SUBSTRING(qbf-m[qbf-p],1,qbf-j)).
END.

PAUSE 0.
MESSAGE STRING(qbf-lang[5],"x(78)").
MESSAGE STRING(qbf-lang[6],"x(78)").
DISPLAY qbf-m WITH FRAME qbf-what.
/*
5: This list shows all the fields you currently have defined for
6: this report.  Those marked with an asterisk will be summarized.
7..20:
   If you select a numeric field to
   summarize, a subtotal for that
   field will appear each time the
   {1}
   field value changes.

   If you select a nonnumeric
   field, a count showing the
   number of records in each
   {1}
   group will appear.

   If you do not choose to
   summarize a field, then the
   value contained in the last
   record in the group will appear.
*/

qbf-c = "".
DO qbf-i = 1 TO qbf-rc#:
  IF INDEX(qbf-rca[qbf-i],"$") > 0 THEN
    qbf-c = qbf-c + (IF qbf-c = "" THEN "" ELSE ",") + ENTRY(1,qbf-rcn[qbf-i]).
END.

/*let user select*/
RUN prores/c-star.p (INPUT-OUTPUT qbf-c).

HIDE MESSAGE NO-PAUSE.
HIDE FRAME qbf-what NO-PAUSE.

IF KEYFUNCTION(LASTKEY) <> "END-ERROR" THEN
  DO qbf-i = 1 TO qbf-rc#:
    /*was on  and  is on  -> do nothing*/
    /*was off and  is off -> do nothing*/
    /*was off and  is on  -> turn on*/
    ASSIGN
      qbf-a = CAN-DO(qbf-c,ENTRY(1,qbf-rcn[qbf-i]))
      qbf-p = INDEX(qbf-rca[qbf-i],"$").
    IF qbf-a AND qbf-p = 0 THEN qbf-rca[qbf-i] = qbf-rca[qbf-i] + "$".
    /*was on  and  is off -> turn off*/
    IF NOT qbf-a AND qbf-p > 0 THEN SUBSTRING(qbf-rca[qbf-i],qbf-p,1) = "".
  END.

RETURN.
