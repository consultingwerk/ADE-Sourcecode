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
/* r-expand.p - generates header/footer for reports */

{ prores/s-system.i }

DEFINE INPUT  PARAMETER qbf-i AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER qbf-o AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER qbf-w AS INTEGER   NO-UNDO.

DEFINE VARIABLE qbf-a AS LOGICAL   NO-UNDO.
DEFINE VARIABLE qbf-b AS LOGICAL   NO-UNDO.
DEFINE VARIABLE qbf-f AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-k AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-s AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-x AS INTEGER   NO-UNDO. /* left-edge for index/substr */

DEFINE VARIABLE qbf-l AS CHARACTER NO-UNDO. /* left-brace character */
DEFINE VARIABLE qbf-r AS CHARACTER NO-UNDO. /* right-brace character */

ASSIGN
  qbf-w = LENGTH(qbf-i)
  qbf-o = "".

IF qbf-i = "" THEN RETURN.

qbf-o = '"'.
DO qbf-j = 1 TO LENGTH(qbf-i):
  qbf-o = qbf-o + SUBSTRING(qbf-i,qbf-j,1)
        + (IF SUBSTRING(qbf-i,qbf-j,1) = '"' THEN '"' ELSE "").
END.

/* select the delimiters.  we allow { }, < >, ( ) and [ ] */
DO qbf-j = 1 TO 8:
  qbf-f = ENTRY(qbf-j,"PAGE,DATE,TODAY,COUNT,USER,NOW,TIME,VALUE*").
  IF qbf-i MATCHES "*" + qbf-left + qbf-f + qbf-right + "*" THEN
    ASSIGN qbf-l = qbf-left qbf-r = qbf-right.
  ELSE IF qbf-i MATCHES "*~{" + qbf-f + "~}*" THEN
    ASSIGN qbf-l = "~{" qbf-r = "~}".
  ELSE IF qbf-i MATCHES "*<" + qbf-f + ">*" THEN
    ASSIGN qbf-l = "<" qbf-r = ">".
  ELSE IF qbf-i MATCHES "*(" + qbf-f + ")*" THEN
    ASSIGN qbf-l = "(" qbf-r = ")".
  ELSE IF qbf-i MATCHES "*[" + qbf-f + "]*" THEN
    ASSIGN qbf-l = "[" qbf-r = "]".
END.
IF qbf-l = "" THEN ASSIGN qbf-l = qbf-left qbf-r = qbf-right.
/*message "left=" qbf-l "right=" qbf-r. pause.*/

ASSIGN
  qbf-x = 1
  qbf-o = qbf-o + '"'
  qbf-j = INDEX(qbf-o,qbf-l).

DO WHILE qbf-j > 0:
  ASSIGN
    qbf-k = INDEX(SUBSTRING(qbf-o,qbf-x),qbf-r)
    qbf-k = (IF qbf-k = 0 THEN 0 ELSE qbf-k + qbf-x - 1).
  /*message qbf-j qbf-k qbf-x qbf-o*/
  /*(if qbf-j = 0 then "" else substring(qbf-o,qbf-j,1))*/
  /*(if qbf-k = 0 then "" else substring(qbf-o,qbf-k,1)). pause.*/
  IF qbf-k < qbf-j THEN LEAVE.
  ASSIGN
    qbf-s = SUBSTRING(qbf-o,qbf-j + 1,qbf-k - qbf-j - 1)
    qbf-w = qbf-w - LENGTH(qbf-s) - 2
    qbf-f = "xxxxxxxx".
  IF      qbf-s = "PAGE"  THEN ASSIGN qbf-s = 'PAGE-NUMBER' qbf-f = ">>>>9".
  ELSE IF qbf-s = "DATE"  THEN ASSIGN qbf-s = 'TODAY'       qbf-f = "99/99/99".
  ELSE IF qbf-s = "TODAY" THEN ASSIGN qbf-s = 'TODAY'       qbf-f = "99/99/99".
  ELSE IF qbf-s = "COUNT" THEN ASSIGN qbf-s = 'qbf-total'   qbf-f = ">>>>>>9".
  ELSE IF qbf-s = "USER"  THEN        qbf-s = 'USERID("RESULTSDB")'.
  ELSE IF qbf-s = "NOW"   THEN        qbf-s = 'STRING(TIME,"HH:MM:SS")'.
  ELSE IF qbf-s = "TIME"  THEN        qbf-s = 'STRING(qbf-t,"HH:MM:SS")'.
  ELSE IF qbf-s BEGINS "VALUE " THEN
    ASSIGN
      qbf-f = SUBSTRING(qbf-s,INDEX(qbf-s,";") + 1)
      qbf-s = SUBSTRING(qbf-s,7,INDEX(qbf-s,";") - 7).
  ELSE DO:
    ASSIGN
      /*SUBSTRING(qbf-o,qbf-j,1) = " "
      SUBSTRING(qbf-o,qbf-k,1) = " "*/
      qbf-w = qbf-w + LENGTH(qbf-s) + 2
      qbf-x = qbf-k
      qbf-j = INDEX(SUBSTRING(qbf-o,qbf-x),qbf-l)
      qbf-j = (IF qbf-j = 0 THEN 0 ELSE qbf-j + qbf-x - 1).
    NEXT.
  END.

  /*
  hack - since we don't really know the datatype, we can't fully
	 expand the format using s-size.i.
  */
  IF qbf-f MATCHES ".(*)" AND INDEX("xan9!",SUBSTRING(qbf-f,1,1)) > 0 THEN
    qbf-f = FILL(SUBSTRING(qbf-f,1,1),
            INTEGER(SUBSTRING(qbf-f,3,LENGTH(qbf-f) - 3))).

  ASSIGN
    qbf-b = (qbf-j > 1 AND SUBSTRING(qbf-o,qbf-j - 1,1) = " ")
    qbf-j = qbf-j - (IF qbf-b THEN 1 ELSE 0)
    qbf-a = (qbf-k < LENGTH(qbf-o) AND SUBSTRING(qbf-o,qbf-k + 1,1) = " ")
    qbf-k = qbf-k + (IF qbf-a THEN 1 ELSE 0)
    qbf-w = qbf-w + LENGTH(qbf-f)
    qbf-x = qbf-k - LENGTH(qbf-o)
    SUBSTRING(qbf-o,qbf-j,qbf-k - qbf-j + 1)
          = (IF qbf-b THEN '" ' ELSE '" SPACE(0) ')
          + qbf-s + ' FORMAT "' + qbf-f
          + (IF qbf-a THEN '" "' ELSE '" SPACE(0) "')
    qbf-x = qbf-x + LENGTH(qbf-o)
    qbf-j = INDEX(SUBSTRING(qbf-o,qbf-x),qbf-l)
    qbf-j = (IF qbf-j = 0 THEN 0 ELSE qbf-j + qbf-x - 1).
END.

/* Fixup any remaining curly braces so they don't turn */
/* into include file references and break the compile. */
IF INDEX(qbf-o,"~{") > 0 THEN
  DO qbf-j = 1 TO LENGTH(qbf-o):
    IF SUBSTRING(qbf-o,qbf-j,1) = "~{" THEN
      ASSIGN
        SUBSTRING(qbf-o,qbf-j,1) = "~~~{"
        qbf-j = qbf-j + 1.
  END.

IF qbf-o MATCHES '"" *' THEN qbf-o = SUBSTRING(qbf-o,4).
IF qbf-o MATCHES '* ""' THEN qbf-o = SUBSTRING(qbf-o,1,LENGTH(qbf-o) - 3).
IF qbf-o MATCHES 'SPACE(0) *' THEN qbf-o = SUBSTRING(qbf-o,10).
IF qbf-o MATCHES '* SPACE(0)' THEN qbf-o = SUBSTRING(qbf-o,1,LENGTH(qbf-o) - 9).

RETURN.
