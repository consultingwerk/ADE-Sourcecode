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
/* q-join.p - handle form joining */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/q-define.i }
{ prores/c-merge.i NEW }
{ prores/c-form.i }
{ prores/reswidg.i }
{ prores/resfunc.i }

DEFINE INPUT  PARAMETER qbf-s AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER qbf-o AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-f AS CHARACTER NO-UNDO. /* already-used files */
DEFINE VARIABLE qbf-h AS INTEGER   NO-UNDO. /* used in binary search */
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-l AS INTEGER   NO-UNDO. /* used in binary search */
DEFINE VARIABLE qbf-t AS CHARACTER NO-UNDO. /* current db.file name */
DEFINE VARIABLE qbf-x AS CHARACTER NO-UNDO. /* pointers into qbf-join */
DEFINE VARIABLE qbf-y AS CHARACTER NO-UNDO. /* pointers into qbf-form */

/*message "[q-join.p]" view-as alert-box.*/

ASSIGN
  qbf-f = qbf-db[1] + "." + qbf-file[1]
        + (IF qbf-level > 1 THEN "," + qbf-db[2] + "." + qbf-file[2] ELSE "")
        + (IF qbf-level > 2 THEN "," + qbf-db[3] + "." + qbf-file[3] ELSE "")
        + (IF qbf-level > 3 THEN "," + qbf-db[4] + "." + qbf-file[4] ELSE "")
        + (IF qbf-level > 4 THEN "," + qbf-db[5] + "." + qbf-file[5] ELSE "")
  qbf-t = qbf-db[qbf-level] + "." + qbf-file[qbf-level]
  qbf-x = ""
  qbf-y = "".
DO qbf-i = 1 TO qbf-join#:
  {&FIND_QBF_JOIN} qbf-i.
  IF qbf-t = ENTRY(1,qbf-join.cValue) THEN
    qbf-c = ENTRY(2,qbf-join.cValue).
  ELSE IF qbf-t = ENTRY(2,qbf-join.cValue) THEN
    qbf-c = ENTRY(1,qbf-join.cValue).
  ELSE NEXT.
  IF CAN-DO(qbf-f,qbf-c) THEN NEXT.

  ASSIGN /* do a binary search */
    qbf-h = qbf-form#
    qbf-l = 1
    qbf-j = 1.
  DO WHILE qbf-j <> -1:
    qbf-j = TRUNCATE((qbf-h + qbf-l) / 2,0).
    {&FIND_QBF_FORM} qbf-j.
    IF qbf-h < 1 OR qbf-l > qbf-form# OR qbf-h < qbf-l THEN 
      qbf-j = -1.
    ELSE IF qbf-c > ENTRY(1,qbf-form.cValue) THEN qbf-l = qbf-j + 1.
    ELSE IF qbf-c < ENTRY(1,qbf-form.cValue) THEN qbf-h = qbf-j - 1.
    ELSE IF qbf-c = ENTRY(1,qbf-form.cValue) THEN LEAVE.
  END.
  /* if qbf-j <= 0 then file joinable, but no form */
  IF qbf-j > 0 THEN
    ASSIGN
      qbf-o = qbf-o + (IF qbf-o = "" THEN "" ELSE ",") + qbf-c
      qbf-x = qbf-x + (IF qbf-x = "" THEN "" ELSE ",") + STRING(qbf-i)
      qbf-y = qbf-y + (IF qbf-y = "" THEN "" ELSE ",") + STRING(qbf-j).
END.

IF qbf-s <> "" THEN 
  qbf-o = qbf-t + (IF qbf-o = "" THEN "" ELSE ",") + qbf-o.
ASSIGN
  qbf-f      = qbf-module
  qbf-module = "q11s".
IF qbf-o <> "" THEN
  RUN prores/c-file.p ("!," + qbf-o,"q",OUTPUT qbf-c).
qbf-module = qbf-f.

IF qbf-c = "" THEN qbf-o = "".
IF qbf-o = "" THEN RETURN.

ASSIGN
  qbf-j                    = LOOKUP(ENTRY(2,qbf-c),qbf-o)
  qbf-o                    = ENTRY(qbf-j,qbf-o)
  qbf-i                    = INTEGER(ENTRY(qbf-j,qbf-x))  /*ptr into qbf-join*/
  qbf-j                    = INTEGER(ENTRY(qbf-j,qbf-y)). /*ptr into qbf-form*/

{&FIND_QBF_FORM} qbf-j.
{&FIND_QBF_JOIN} qbf-i.
ASSIGN
  qbf-c                    = ENTRY(1,qbf-form.cValue)
  qbf-db[qbf-level + 1]    = SUBSTRING(qbf-c,1,INDEX(qbf-c,".") - 1)
  qbf-file[qbf-level + 1]  = SUBSTRING(qbf-c,INDEX(qbf-c,".") + 1)
  qbf-o                    = ENTRY(2,qbf-form.cValue) /* output param */
  qbf-o                    = (IF qbf-o = "" THEN
                               SUBSTRING(qbf-file[qbf-level + 1],1,8)
                              ELSE qbf-o)
  qbf-where[qbf-level + 1] = ""
  qbf-of[qbf-level + 1]    = (IF qbf-join.cWhere = "" THEN "OF " + qbf-t
                              ELSE "WHERE " + qbf-join.cWhere).

RETURN.

/* q-join.p - end of file */
