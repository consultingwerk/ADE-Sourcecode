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
/* r-read.p - read in report file header */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/i-define.i }

DEFINE INPUT PARAMETER qbf-f AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-c AS CHARACTER          NO-UNDO.
DEFINE VARIABLE qbf-d AS CHARACTER          NO-UNDO.
DEFINE VARIABLE qbf-h AS CHARACTER          NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER            NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER            NO-UNDO.
DEFINE VARIABLE qbf-m AS CHARACTER EXTENT 7 NO-UNDO.
DEFINE VARIABLE qbf-t AS CHARACTER          NO-UNDO.

DEFINE STREAM qbf-io.

RUN prores/s-zap.p.

RUN prores/s-prefix.p (qbf-dir-nam,OUTPUT qbf-c).
ASSIGN
  qbf-h = "first-only=,last-only=,top-left=,top-center=,top-right=,"
        + "bottom-left=,bottom-center=,bottom-right="
  qbf-t = "left-margin=,page-size=,column-spacing=,line-spacing=,"
        + "top-margin=,before-body=,after-body=,,page-eject=".

INPUT STREAM qbf-io FROM VALUE(SEARCH(qbf-c + qbf-f + ".p")) NO-ECHO NO-MAP.
REPEAT:
  qbf-m = "".
  IMPORT STREAM qbf-io qbf-m.
  IF qbf-m[1] BEGINS "#" THEN NEXT.
  IF qbf-m[1] = "*" + "/" THEN LEAVE.

  IF      qbf-m[1] BEGINS "version" THEN qbf-dir-vrs   = qbf-m[2].
  ELSE IF qbf-m[1] BEGINS "name"    THEN qbf-name      = qbf-m[2].
  ELSE IF CAN-DO(qbf-t,qbf-m[1]) THEN
    qbf-r-attr[LOOKUP(qbf-m[1],qbf-t)] = INTEGER(qbf-m[2]).
  ELSE IF qbf-m[1] BEGINS "summary" THEN
    qbf-r-attr[8] = (IF qbf-m[2] BEGINS "t" THEN 1 ELSE 0).
  ELSE
  IF qbf-m[1] MATCHES "file*=" THEN
    ASSIGN
      qbf-i            = INTEGER(SUBSTRING(qbf-m[1],5,LENGTH(qbf-m[1]) - 5))
      qbf-j            = INDEX(qbf-m[2],".")
      qbf-file[qbf-i]  = SUBSTRING(qbf-m[2],qbf-j + 1)
      qbf-db[qbf-i]    = SUBSTRING(qbf-m[2],1,MAXIMUM(qbf-j - 1,0))
      qbf-db[qbf-i]    = (IF qbf-db[qbf-i] = "" THEN LDBNAME("RESULTSDB")
                         ELSE qbf-db[qbf-i])
      qbf-of[qbf-i]    = qbf-m[3]
      qbf-where[qbf-i] = qbf-m[4].
  ELSE
  IF qbf-m[1] MATCHES "file*+" THEN
    ASSIGN
      qbf-i            = INTEGER(SUBSTRING(qbf-m[1],5,LENGTH(qbf-m[1]) - 5))
      qbf-of[qbf-i]    = qbf-of[qbf-i]    + qbf-m[3]
      qbf-where[qbf-i] = qbf-where[qbf-i] + qbf-m[4].
  ELSE
  IF qbf-m[1] MATCHES "order*=" THEN
    ASSIGN
      qbf-i            = INTEGER(SUBSTRING(qbf-m[1],6,LENGTH(qbf-m[1]) - 6))
      qbf-order[qbf-i] = qbf-m[2]
                       + (IF qbf-m[3] BEGINS "d" THEN " DESC" ELSE "").
  ELSE
  IF qbf-m[1] MATCHES "field*=" THEN
    ASSIGN
      qbf-i          = INTEGER(SUBSTRING(qbf-m[1],6,LENGTH(qbf-m[1]) - 6))
      qbf-rc#        = MAXIMUM(qbf-rc#,qbf-i)
      qbf-j          = INDEX(qbf-m[5],"*")
      qbf-rcn[qbf-i] = qbf-m[2]
      qbf-rcl[qbf-i] = qbf-m[3]
      qbf-rcf[qbf-i] = qbf-m[4]
      qbf-rca[qbf-i] = (IF qbf-j = 0 THEN qbf-m[5]
                       ELSE SUBSTRING(qbf-m[5],1,qbf-j - 1))
      qbf-rct[qbf-i] = LOOKUP(qbf-m[6],qbf-dtype)
      qbf-rcc[qbf-i] = (IF qbf-j = 0 THEN qbf-m[7]
                       ELSE SUBSTRING(qbf-m[5],qbf-j + 1)).
  ELSE
  IF CAN-DO(qbf-h,qbf-m[1]) THEN
    ASSIGN
      qbf-i                 = LOOKUP(qbf-m[1],qbf-h) * 3 - 2
      qbf-r-head[qbf-i    ] = qbf-m[2]
      qbf-r-head[qbf-i + 1] = qbf-m[3]
      qbf-r-head[qbf-i + 2] = qbf-m[4].

END.

INPUT STREAM qbf-io CLOSE.

RETURN.
