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
/* c-vector.p - before, during and after support for vectors */

/* this is called by c-field.p and q-field.p, which have already loaded
up the qbf-lang array */

{ prores/s-system.i }
{ prores/t-define.i }

DEFINE INPUT        PARAMETER qbf-w AS CHARACTER NO-UNDO. /*ante,edit,post*/
DEFINE INPUT        PARAMETER qbf-m AS LOGICAL   NO-UNDO. /*module*/
DEFINE INPUT-OUTPUT PARAMETER qbf-o AS CHARACTER NO-UNDO.
DEFINE OUTPUT       PARAMETER qbf-v AS CHARACTER NO-UNDO.
/*
qbf-w = "ante" - pre display, "edit" - selected field, "post" - cleanup
qbf-m = TRUE  - called from report-writer, allow stacked array elements
      = FALSE - called from data-export, don't allow stacked
      = ?     - only allow a single element to be chosen
qbf-o = output variable
*/

DEFINE VARIABLE qbf-a AS LOGICAL   NO-UNDO.
DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-e AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-h AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-k AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-l AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-tmp AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-t AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-x AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-y AS INTEGER   NO-UNDO.

/*
  qbf-lang[16] = '        Database' /* max length 16 */
  qbf-lang[17] = '            File' /* max length 16 */
  qbf-lang[18] = '           Field' /* max length 16 */
  qbf-lang[19] = '  Maximum Extent' /* max length 16 */
*/
FORM
  qbf-e NO-LABEL FORMAT "x(48)" SKIP
  HEADER
  qbf-lang[16] FORMAT "x(16)" NO-ATTR-SPACE SPACE(0) ":"
    SUBSTRING(ENTRY(1,qbf-o),1,INDEX(ENTRY(1,qbf-o),".") - 1)
    FORMAT "x(32)" SKIP
  qbf-lang[17] FORMAT "x(16)" NO-ATTR-SPACE SPACE(0) ":"
    SUBSTRING(ENTRY(1,qbf-o),INDEX(ENTRY(1,qbf-o),".") + 1)
    FORMAT "x(32)" SKIP
  qbf-lang[18] FORMAT "x(16)" NO-ATTR-SPACE SPACE(0) ":"
    ENTRY(2,qbf-o) FORMAT "x(32)" SKIP
  qbf-lang[19] FORMAT "x(16)" NO-ATTR-SPACE SPACE(0) ":"
    ENTRY(3,qbf-o) FORMAT "x(4)"  SKIP(1)
  qbf-lang[27] FORMAT "x(50)" SKIP
  qbf-lang[28] FORMAT "x(50)" SKIP
  qbf-lang[29] FORMAT "x(50)" SKIP
  /* "Leave blank for stacked array elements, or enter a" */
  /* "comma-separated list of individual array elements" */
  /* "to include side-by-side in the report." */
  WITH FRAME qbf-r-vector ROW qbf-y + 1 COLUMN qbf-x + 5
  OVERLAY ATTR-SPACE SIDE-LABELS.
FORM
  qbf-e NO-LABEL FORMAT "x(48)" SKIP
  HEADER
  qbf-lang[16] FORMAT "x(16)" NO-ATTR-SPACE SPACE(0) ":"
    SUBSTRING(ENTRY(1,qbf-o),1,INDEX(ENTRY(1,qbf-o),".") - 1)
    FORMAT "x(32)" SKIP
  qbf-lang[17] FORMAT "x(16)" NO-ATTR-SPACE SPACE(0) ":"
    SUBSTRING(ENTRY(1,qbf-o),INDEX(ENTRY(1,qbf-o),".") + 1)
    FORMAT "x(32)" SKIP
  qbf-lang[18] FORMAT "x(16)" NO-ATTR-SPACE SPACE(0) ":"
    ENTRY(2,qbf-o) FORMAT "x(32)" SKIP
  qbf-lang[19] FORMAT "x(16)" NO-ATTR-SPACE SPACE(0) ":"
    ENTRY(3,qbf-o) FORMAT "x(4)"  SKIP(1)
  qbf-lang[30] FORMAT "x(50)" SKIP
  qbf-lang[31] FORMAT "x(50)" SKIP
  /* "Enter a comma-separated list of individual array" */
  /* "elements to include side-by-side as fields." */
  WITH FRAME qbf-d-vector ROW qbf-y + 1 COLUMN qbf-x + 5
  OVERLAY ATTR-SPACE SIDE-LABELS.
FORM
  qbf-j NO-LABEL FORMAT ">>>>"
    VALIDATE(qbf-j > 0 AND qbf-j <= INTEGER(ENTRY(3,qbf-o)),
      qbf-lang[20] + " " + STRING(INPUT qbf-j) + " " + qbf-lang[21] + " "
      + ENTRY(3,qbf-o) + ".") SKIP
    /* qbf-lang[20,21] = "The value" "is outside the range 1 to" */
  HEADER
  qbf-lang[16] FORMAT "x(16)" NO-ATTR-SPACE SPACE(0) ":"
    SUBSTRING(ENTRY(1,qbf-o),1,INDEX(ENTRY(1,qbf-o),".") - 1)
    FORMAT "x(32)" SKIP
  qbf-lang[17] FORMAT "x(16)" NO-ATTR-SPACE SPACE(0) ":"
    SUBSTRING(ENTRY(1,qbf-o),INDEX(ENTRY(1,qbf-o),".") + 1)
    FORMAT "x(32)" SKIP
  qbf-lang[18] FORMAT "x(16)" NO-ATTR-SPACE SPACE(0) ":"
    ENTRY(2,qbf-o) FORMAT "x(32)" SKIP
  qbf-lang[19] FORMAT "x(16)" NO-ATTR-SPACE SPACE(0) ":"
    ENTRY(3,qbf-o) FORMAT "x(4)"  SKIP(1)
  qbf-lang[32] FORMAT "x(50)" SKIP
  /* "Enter the subscript of the array element to use." */
  WITH FRAME qbf-w-vector ROW qbf-y + 1 COLUMN qbf-x + 5
  OVERLAY ATTR-SPACE SIDE-LABELS.

IF qbf-w BEGINS "a" THEN DO:
  ASSIGN
    qbf-t = qbf-o
    qbf-o = ""  /* field names go here (w/o []) */
    qbf-v = "". /* array elements go here       */
  DO qbf-j = 1 TO NUM-ENTRIES(qbf-t):
    ASSIGN
      qbf-c = ENTRY(qbf-j,qbf-t)
      qbf-k = INDEX(qbf-c,"[")
      qbf-e = SUBSTRING(qbf-c,1,IF qbf-k = 0 THEN LENGTH(qbf-c) ELSE qbf-k - 1)
      qbf-l = INDEX(qbf-o + ",",qbf-e + ",").
    IF qbf-l = 0 THEN
      qbf-o = qbf-o + (IF qbf-o = "" THEN "" ELSE ",") + qbf-e.
    IF qbf-l = 0 AND qbf-k = 0 THEN /* new instance, not array */
      qbf-v = qbf-v + (IF qbf-v = "" THEN "" ELSE ",") + STRING(qbf-j) + ":".
    ELSE IF qbf-l = 0 THEN /* new instance, array */
      qbf-v = qbf-v + (IF qbf-v = "" THEN "" ELSE ",") + STRING(qbf-j) + ":"
            + SUBSTRING(qbf-c,qbf-k + 1,INDEX(qbf-c,"]") - qbf-k - 1).
    ELSE DO: /* old instance, array */
      qbf-l = LOOKUP(qbf-e,qbf-o).
/*
** added qbf-tmp for when there is more than one array defined as fields.
*/
      qbf-tmp = INTEGER(ENTRY(1, ENTRY(qbf-l, qbf-v),":")).
      qbf-h = INDEX(qbf-v,STRING(qbf-tmp) + ":").
      IF qbf-h > 0 THEN
      SUBSTRING(qbf-v,qbf-h,LENGTH(ENTRY(qbf-l,qbf-v)))
        = ENTRY(qbf-l,qbf-v) + " "
        + SUBSTRING(qbf-c,qbf-k + 1,INDEX(qbf-c,"]") - qbf-k - 1).
    END.
  END.
  ASSIGN
    qbf-t = qbf-v
    qbf-v = "".
  DO qbf-j = 1 TO NUM-ENTRIES(qbf-t):
    qbf-v = qbf-v + (IF qbf-j = 1 THEN "" ELSE ",")
          + SUBSTRING(ENTRY(qbf-j,qbf-t),INDEX(ENTRY(qbf-j,qbf-t),":") + 1).
  END.
END.

ELSE

IF qbf-w BEGINS "e" THEN DO:
  DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
    ASSIGN
      qbf-x = INTEGER(SUBSTRING(qbf-w,2,3))
      qbf-y = INTEGER(SUBSTRING(qbf-w,5,3))
      qbf-e = qbf-o
      qbf-l = INDEX(qbf-e,"[")
      qbf-e = SUBSTRING(qbf-e,qbf-l + 1)
      qbf-e = SUBSTRING(qbf-e,1,INDEX(qbf-e,"]") - 1).

    IF RETRY THEN .
    ELSE IF qbf-m     THEN DISPLAY qbf-e WITH FRAME qbf-r-vector.
    ELSE IF NOT qbf-m THEN DISPLAY qbf-e WITH FRAME qbf-d-vector.
    ELSE DISPLAY  INTEGER(qbf-e) @ qbf-j WITH FRAME qbf-w-vector.

    IF  qbf-m = ? THEN SET qbf-j WITH FRAME qbf-w-vector.
    ELSE IF qbf-m THEN SET qbf-e WITH FRAME qbf-r-vector.
    ELSE               SET qbf-e WITH FRAME qbf-d-vector.
    IF qbf-m = ? THEN qbf-e = STRING(qbf-j).

    /* wipe out undesirables */
    DO qbf-j = 1 TO LENGTH(qbf-e):
      IF INDEX("0123456789",SUBSTRING(qbf-e,qbf-j,1)) = 0 THEN
        SUBSTRING(qbf-e,qbf-j,1) = " ".
    END.
    ASSIGN
      qbf-e = TRIM(qbf-e)
      qbf-k = INDEX(qbf-e,"  ").
    DO WHILE qbf-k > 0: /* compress doubled blanks */
      ASSIGN
        SUBSTRING(qbf-e,qbf-k,1) = ""
        qbf-k = INDEX(qbf-e,"  ").
    END.
    /* this leaves qbf-k as 0, which we need for the next block */

    DO qbf-j = 1 TO LENGTH(qbf-e):
      qbf-k = (IF SUBSTRING(qbf-e,qbf-j,1) = " " THEN 0
              ELSE qbf-k * 10 + INTEGER(SUBSTRING(qbf-e,qbf-j,1))).
      IF qbf-k > INTEGER(ENTRY(3,qbf-o)) THEN DO:
        MESSAGE qbf-lang[20] qbf-k qbf-lang[21] ENTRY(3,qbf-o) + ".".
        /* qbf-lang[20,21] = "The value" "is outside the range 1 to" */
        BELL.
        UNDO,RETRY.
      END.
    END.
    ASSIGN
      qbf-t = qbf-o
      qbf-t = SUBSTRING(qbf-o,INDEX(qbf-o,"|"))
      qbf-o = SUBSTRING(qbf-o,1,qbf-l) + qbf-e + "]," + ENTRY(3,qbf-o) + ","
            + SUBSTRING(qbf-t,1,INDEX(qbf-t,"[")) + qbf-e + "]"
      qbf-t = "".
  END.
END.

ELSE

IF qbf-w BEGINS "p" THEN
  DO qbf-j = 1 TO NUM-ENTRIES(qbf-o):
  ASSIGN
    qbf-e = ENTRY(qbf-j,qbf-o)
    qbf-l = 0
    qbf-t = "".
  IF INDEX(qbf-e,"[") = 0 OR INDEX(qbf-e,"[]") > 0 THEN NEXT.
  qbf-e = SUBSTRING(qbf-e,INDEX(qbf-e,"[") + 1).
  DO WHILE TRUE:
    qbf-k = 0.
    IF SUBSTRING(qbf-e,1,1) = "]" THEN LEAVE.
    DO WHILE SUBSTRING(qbf-e,1,1) = " ":
      qbf-e = SUBSTRING(qbf-e,2).
    END.
    DO WHILE INDEX("0123456789",SUBSTRING(qbf-e,1,1)) > 0:
      ASSIGN
        qbf-k = qbf-k * 10 + INTEGER(SUBSTRING(qbf-e,1,1))
        qbf-e = SUBSTRING(qbf-e,2).
    END.
    IF qbf-k = 0 THEN NEXT.
    ASSIGN
      qbf-l = qbf-l + 1
      qbf-t = qbf-t + (IF qbf-t = "" THEN "" ELSE ",")
            + SUBSTRING(ENTRY(qbf-j,qbf-o),1,INDEX(ENTRY(qbf-j,qbf-o),"["))
            + STRING(qbf-k) + "]".
  END.
  ASSIGN
    SUBSTRING(qbf-o,INDEX(qbf-o,ENTRY(qbf-j,qbf-o)),
      LENGTH(ENTRY(qbf-j,qbf-o))) = qbf-t
    qbf-j = qbf-j + qbf-l - 1.
END.

HIDE FRAME qbf-d-vector NO-PAUSE.
HIDE FRAME qbf-r-vector NO-PAUSE.
HIDE FRAME qbf-w-vector NO-PAUSE.
RETURN.
