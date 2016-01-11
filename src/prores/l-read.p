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
/* l-read.p - read in label file header */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/i-define.i }

DEFINE INPUT PARAMETER qbf-f AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-c AS CHARACTER          NO-UNDO.
DEFINE VARIABLE qbf-d AS CHARACTER          NO-UNDO.
DEFINE VARIABLE qbf-h AS CHARACTER          NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER            NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER            NO-UNDO.
DEFINE VARIABLE qbf-m AS CHARACTER EXTENT 6 NO-UNDO.

DEFINE STREAM qbf-io.

RUN prores/s-zap.p.

RUN prores/s-prefix.p (qbf-dir-nam,OUTPUT qbf-c).

INPUT STREAM qbf-io FROM VALUE(SEARCH(qbf-c + qbf-f + ".p")) NO-ECHO NO-MAP.
REPEAT:
  qbf-m = "".
  IMPORT STREAM qbf-io qbf-m.
  IF qbf-m[1] BEGINS "#" THEN NEXT.
  IF qbf-m[1] = "*" + "/" THEN LEAVE.

  IF      qbf-m[1] = "version="       THEN qbf-dir-vrs   = qbf-m[2].
  ELSE IF qbf-m[1] = "name="          THEN qbf-name      = qbf-m[2].
  ELSE IF qbf-m[1] = "left-margin="   THEN qbf-l-attr[1] = INTEGER(qbf-m[2]).
  ELSE IF qbf-m[1] = "label-spacing=" THEN qbf-l-attr[2] = INTEGER(qbf-m[2]).
  ELSE IF qbf-m[1] = "total-height="  THEN qbf-l-attr[3] = INTEGER(qbf-m[2]).
  ELSE IF qbf-m[1] = "top-margin="    THEN qbf-l-attr[4] = INTEGER(qbf-m[2]).
  ELSE IF qbf-m[1] = "number-across=" THEN qbf-l-attr[5] = INTEGER(qbf-m[2]).
  ELSE IF qbf-m[1] = "number-copies=" THEN qbf-l-attr[7] = INTEGER(qbf-m[2]).
  ELSE IF qbf-m[1] = "omit-blank="    THEN
    qbf-l-attr[6] = (IF qbf-m[2] BEGINS "t" THEN 1 ELSE 0).
  ELSE IF qbf-m[1] MATCHES "text*=" THEN
    qbf-l-text[INTEGER(SUBSTRING(qbf-m[1],5,LENGTH(qbf-m[1]) - 5))] = qbf-m[2].
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
END.

INPUT STREAM qbf-io CLOSE.

IF qbf-file[1] = "" THEN
  ASSIGN
    qbf-order  = ""
    qbf-l-text = "".

RETURN.
