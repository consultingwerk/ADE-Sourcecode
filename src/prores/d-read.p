/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* d-read.p - read in data export file header */

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

DEFINE STREAM qbf-io.

RUN prores/s-zap.p.

RUN prores/s-prefix.p (qbf-dir-nam,OUTPUT qbf-c).

INPUT STREAM qbf-io FROM VALUE(SEARCH(qbf-c + qbf-f + ".p")) NO-ECHO NO-MAP.

/* fix 93-01-20-001 - wasn't blanking out attrs before loading */
ASSIGN
  qbf-d-attr[3] = ""
  qbf-d-attr[4] = ""
  qbf-d-attr[5] = ""
  qbf-d-attr[6] = "".

REPEAT:
  qbf-m = "".
  IMPORT STREAM qbf-io qbf-m.
  IF qbf-m[1] BEGINS "#" THEN NEXT.
  IF qbf-m[1] = "*" + "/" THEN LEAVE.

  IF      qbf-m[1] = "version="          THEN qbf-dir-vrs   = qbf-m[2].
  ELSE IF qbf-m[1] = "name="             THEN qbf-name      = qbf-m[2].
  ELSE IF qbf-m[1] = "type="             THEN qbf-d-attr[1] = qbf-m[2].
  ELSE IF qbf-m[1] = "use-headings="     THEN qbf-d-attr[2] = qbf-m[2].
  ELSE IF qbf-m[1] = "record-delimiter=" THEN qbf-d-attr[3] = qbf-m[2].
  ELSE IF qbf-m[1] = "record-separator=" THEN qbf-d-attr[4] = qbf-m[2].
  ELSE IF qbf-m[1] = "field-delimiter="  THEN qbf-d-attr[5] = qbf-m[2].
  ELSE IF qbf-m[1] = "field-separator="  THEN qbf-d-attr[6] = qbf-m[2].
  ELSE IF qbf-m[1] MATCHES "file*=" THEN
    ASSIGN
      qbf-i            = INTEGER(SUBSTRING(qbf-m[1],5,LENGTH(qbf-m[1]) - 5))
      qbf-j            = INDEX(qbf-m[2],".")
      qbf-file[qbf-i]  = SUBSTRING(qbf-m[2],qbf-j + 1)
      qbf-db[qbf-i]    = SUBSTRING(qbf-m[2],1,MAXIMUM(qbf-j - 1,0))
      qbf-db[qbf-i]    = (IF qbf-db[qbf-i] = "" THEN LDBNAME("RESULTSDB")
                         ELSE qbf-db[qbf-i])
      qbf-of[qbf-i]    = qbf-m[3]
      qbf-where[qbf-i] = qbf-m[4].
  ELSE IF qbf-m[1] MATCHES "file*+" THEN
    ASSIGN
      qbf-i            = INTEGER(SUBSTRING(qbf-m[1],5,LENGTH(qbf-m[1]) - 5))
      qbf-of[qbf-i]    = qbf-of[qbf-i]    + qbf-m[3]
      qbf-where[qbf-i] = qbf-where[qbf-i] + qbf-m[4].
  ELSE IF qbf-m[1] MATCHES "order*=" THEN
    ASSIGN
      qbf-i            = INTEGER(SUBSTRING(qbf-m[1],6,LENGTH(qbf-m[1]) - 6))
      qbf-order[qbf-i] = qbf-m[2]
                       + (IF qbf-m[3] BEGINS "d" THEN " DESC" ELSE "").
  ELSE IF qbf-m[1] MATCHES "field*=" THEN
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
END.

INPUT STREAM qbf-io CLOSE.

DO qbf-i = 3 TO 6:
  ASSIGN
    qbf-c = qbf-d-attr[qbf-i]
    qbf-j = 0.
  DO WHILE INDEX(qbf-c,",") > 0:
    ASSIGN
      SUBSTRING(qbf-c,INDEX(qbf-c,",")) = " "
      qbf-j                             = qbf-j + 1.
  END.
  qbf-d-attr[qbf-i] = qbf-d-attr[qbf-i] + FILL(",",MAXIMUM(0,11 - qbf-j)).
END.

RETURN.
