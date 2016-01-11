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
/* r-draw.p - does redraw logic for r-main.p */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/r-define.i }

DEFINE VARIABLE qbf-a AS LOGICAL            NO-UNDO.
DEFINE VARIABLE qbf-b AS LOGICAL            NO-UNDO.
DEFINE VARIABLE qbf-c AS CHARACTER          NO-UNDO.
DEFINE VARIABLE qbf-e AS CHARACTER          NO-UNDO.
DEFINE VARIABLE qbf-f AS CHARACTER          NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER            NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER            NO-UNDO.
DEFINE VARIABLE qbf-l AS INTEGER            NO-UNDO.
DEFINE VARIABLE qbf-m AS CHARACTER EXTENT 3 NO-UNDO.
DEFINE VARIABLE qbf-t AS CHARACTER          NO-UNDO.

ASSIGN
  qbf-a = FALSE /* any stacked column labels? */
  qbf-b = FALSE /* looking for any aggregate fields */
  qbf-l = qbf-r-attr[1] - 1.
DO qbf-i = 1 TO qbf-rc#:
  RUN prores/r-label.p
    (qbf-rcl[qbf-i],qbf-rcf[qbf-i],qbf-rct[qbf-i],
    OUTPUT qbf-rcw[qbf-i],OUTPUT qbf-j).
  ASSIGN
    qbf-a = qbf-a OR qbf-j > 1
    qbf-b = qbf-b OR LENGTH(qbf-rca[qbf-i]) > 1
    qbf-l = qbf-l + qbf-rcw[qbf-i]
          + (IF qbf-i = qbf-rc# THEN 0 ELSE qbf-r-attr[3]).
END.

ASSIGN
  qbf-l      = qbf-l + (IF qbf-b THEN 6 ELSE 0)
  qbf-r-size = qbf-l
  /* strategy: build top in qbf-layout[1..3], bottom in qbf-m[1..3], */
  /* then move bottom to end of qbf-layout array later */
  qbf-layout = ""
  qbf-m      = ""
  /* top left */
  qbf-layout[1] = FILL(" ",qbf-r-attr[1] - 1) + qbf-r-head[ 7]
  qbf-layout[2] = FILL(" ",qbf-r-attr[1] - 1) + qbf-r-head[ 8]
  qbf-layout[3] = FILL(" ",qbf-r-attr[1] - 1) + qbf-r-head[ 9]
  /* bottom left */
  qbf-m[1] = FILL(" ",qbf-r-attr[1] - 1) + qbf-r-head[16]
  qbf-m[2] = FILL(" ",qbf-r-attr[1] - 1) + qbf-r-head[17]
  qbf-m[3] = FILL(" ",qbf-r-attr[1] - 1) + qbf-r-head[18]
  /* top right */
  qbf-l = MAXIMUM(LENGTH(qbf-r-head[13]),MAXIMUM(
          LENGTH(qbf-r-head[14]),LENGTH(qbf-r-head[15])))
  qbf-i = MAXIMUM(qbf-r-size - qbf-l + 1,qbf-r-attr[1])
  OVERLAY(qbf-layout[1],qbf-i,qbf-l) = qbf-r-head[13]
  OVERLAY(qbf-layout[2],qbf-i,qbf-l) = qbf-r-head[14]
  OVERLAY(qbf-layout[3],qbf-i,qbf-l) = qbf-r-head[15]
  /* bottom right */
  qbf-l = MAXIMUM(LENGTH(qbf-r-head[22]),MAXIMUM(
          LENGTH(qbf-r-head[23]),LENGTH(qbf-r-head[24])))
  qbf-i = MAXIMUM(qbf-r-size - qbf-l + 1,qbf-r-attr[1])
  OVERLAY(qbf-m[1],qbf-i,qbf-l) = qbf-r-head[22]
  OVERLAY(qbf-m[2],qbf-i,qbf-l) = qbf-r-head[23]
  OVERLAY(qbf-m[3],qbf-i,qbf-l) = qbf-r-head[24]
  /* top center */
  qbf-l = MAXIMUM(LENGTH(qbf-r-head[10]),MAXIMUM(
          LENGTH(qbf-r-head[11]),LENGTH(qbf-r-head[12])))
  qbf-i = MAXIMUM(0,TRUNCATE(
          (qbf-r-size - qbf-r-attr[1] - qbf-l + 1) / 2,0))
        + qbf-r-attr[1]
  OVERLAY(qbf-layout[1],qbf-i,qbf-l) = qbf-r-head[10]
  OVERLAY(qbf-layout[2],qbf-i,qbf-l) = qbf-r-head[11]
  OVERLAY(qbf-layout[3],qbf-i,qbf-l) = qbf-r-head[12]
  /* bottom center */
  qbf-l = MAXIMUM(LENGTH(qbf-r-head[19]),MAXIMUM(
          LENGTH(qbf-r-head[20]),LENGTH(qbf-r-head[21])))
  qbf-i = MAXIMUM(0,TRUNCATE(
          (qbf-r-size - qbf-r-attr[1] - qbf-l + 1) / 2,0))
        + qbf-r-attr[1]
  OVERLAY(qbf-m[1],qbf-i,qbf-l) = qbf-r-head[19]
  OVERLAY(qbf-m[2],qbf-i,qbf-l) = qbf-r-head[20]
  OVERLAY(qbf-m[3],qbf-i,qbf-l) = qbf-r-head[21]

  qbf-l                 = (IF qbf-layout[4] <> "" THEN 5 ELSE
                          (IF qbf-layout[3] <> "" THEN 4 ELSE
                          (IF qbf-layout[2] <> "" THEN 3 ELSE
                          (IF qbf-layout[1] <> "" THEN 2 ELSE 1))))
/*qbf-p                 = qbf-l*/
  qbf-l                 = qbf-l + (IF qbf-a THEN 1 ELSE 0)
  qbf-c                 = FILL(" ",qbf-r-attr[3])
  qbf-layout[qbf-l    ] = FILL(" ",qbf-r-attr[1] - 1)
  qbf-layout[qbf-l + 1] = qbf-layout[qbf-l]
  qbf-layout[qbf-l + 2] = qbf-layout[qbf-l]
  qbf-layout[qbf-l + 3] = qbf-layout[qbf-l]
  qbf-layout[qbf-l + 4] = qbf-layout[qbf-l].
IF qbf-a THEN qbf-layout[qbf-l - 1] = qbf-layout[qbf-l].

DO qbf-i = 1 TO qbf-rc#:
  ASSIGN
    qbf-c = (IF qbf-i = qbf-rc# THEN "" ELSE qbf-c)
    qbf-f = "x(" + STRING(qbf-rcw[qbf-i]) + ")"
    qbf-t = qbf-rcl[qbf-i]
    qbf-j = INDEX(qbf-t,"!").
  IF qbf-j > 0 AND qbf-j = INDEX(qbf-t,"!!") THEN ASSIGN
    SUBSTRING(qbf-t,qbf-j,2) = "!"
    qbf-j = 0.
  IF qbf-a AND qbf-j = 0 THEN
    qbf-layout[qbf-l - 1] = qbf-layout[qbf-l - 1] + STRING("",qbf-f) + qbf-c.
  IF qbf-j > 0 THEN ASSIGN
    qbf-layout[qbf-l - 1] = qbf-layout[qbf-l - 1]
                          + STRING(SUBSTRING(qbf-t,1,qbf-j - 1),qbf-f) + qbf-c
    qbf-t                 = SUBSTRING(qbf-t,qbf-j + 1).
  IF qbf-j > 0 AND INDEX(qbf-t,"!") > 0 THEN ASSIGN
    qbf-t = STRING(SUBSTRING(qbf-t,1,INDEX(qbf-t,"!") - 1),qbf-f)
    SUBSTRING(qbf-t,MAXIMUM(LENGTH(qbf-t) - 2,1),3) = "...".
  qbf-e = qbf-rcf[qbf-i].
  IF STRING(0,"9.") = "0," THEN
    RUN prores/d-extra.p (INPUT-OUTPUT qbf-e).
  ASSIGN
    qbf-layout[qbf-l    ] = qbf-layout[qbf-l] + STRING(qbf-t,qbf-f) + qbf-c
    qbf-layout[qbf-l + 1] = qbf-layout[qbf-l + 1]
                          + FILL("-",qbf-rcw[qbf-i]) + qbf-c
    qbf-layout[qbf-l + 2] = qbf-layout[qbf-l + 2]
                          + STRING(qbf-e,qbf-f) + qbf-c
    qbf-layout[qbf-l + 3] = qbf-layout[qbf-l + 3]
                          + STRING((IF qbf-rcc[qbf-i] = "" THEN "" ELSE "*")
                          + qbf-rcc[qbf-i],qbf-f) + qbf-c
    qbf-layout[qbf-l + 4] = qbf-layout[qbf-l + 4]
                          + STRING(qbf-rca[qbf-i],qbf-f) + qbf-c.
END.

qbf-i = 10.
IF qbf-m[3] <> "" THEN ASSIGN qbf-layout[qbf-i] = qbf-m[3]  qbf-i = qbf-i - 1.
IF qbf-m[2] <> "" THEN ASSIGN qbf-layout[qbf-i] = qbf-m[2]  qbf-i = qbf-i - 1.
IF qbf-m[1] <> "" THEN        qbf-layout[qbf-i] = qbf-m[1].

RETURN.
