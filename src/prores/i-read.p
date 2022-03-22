/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* i-read.p - read in user directory */

{ prores/s-system.i }
{ prores/t-define.i }
{ prores/i-define.i }
{ prores/t-set.i &mod=i &set=0 }

DEFINE VARIABLE qbf-a AS LOGICAL            NO-UNDO.
DEFINE VARIABLE qbf-b AS CHARACTER          NO-UNDO.
DEFINE VARIABLE qbf-c AS CHARACTER          NO-UNDO.
DEFINE VARIABLE qbf-g AS INTEGER            NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER            NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER            NO-UNDO.
DEFINE VARIABLE qbf-l AS CHARACTER EXTENT 3 NO-UNDO.
DEFINE STREAM qbf-io.

/*
export lo/hi in cache: (mode "d")
  DEFINE {1} SHARED VARIABLE qbf-d-lo AS INTEGER NO-UNDO.
  DEFINE {1} SHARED VARIABLE qbf-d-hi AS INTEGER NO-UNDO.

graph lo/hi in cache: (mode "g")
  DEFINE {1} SHARED VARIABLE qbf-g-lo AS INTEGER NO-UNDO.
  DEFINE {1} SHARED VARIABLE qbf-g-hi AS INTEGER NO-UNDO.

label lo/hi in cache: (mode "l")
  DEFINE {1} SHARED VARIABLE qbf-l-lo AS INTEGER NO-UNDO.
  DEFINE {1} SHARED VARIABLE qbf-l-hi AS INTEGER NO-UNDO.

query lo/hi in cache: (mode "q")
  DEFINE {1} SHARED VARIABLE qbf-q-lo AS INTEGER NO-UNDO.
  DEFINE {1} SHARED VARIABLE qbf-q-hi AS INTEGER NO-UNDO.

report lo/hi in cache: (mode "r")
  DEFINE {1} SHARED VARIABLE qbf-r-lo AS INTEGER NO-UNDO.
  DEFINE {1} SHARED VARIABLE qbf-r-hi AS INTEGER NO-UNDO.
*/

HIDE MESSAGE NO-PAUSE.
IF qbf-dir-ent# = 0 THEN MESSAGE qbf-lang[32]. /*"Reading directory..."*/

qbf-b = "".
CREATE ALIAS "QBF$0" FOR DATABASE VALUE(LDBNAME(1)).
RUN prores/s-base.p (TRUE,OUTPUT qbf-c).
DO qbf-i = 1 TO NUM-ENTRIES(qbf-c):
  qbf-b = qbf-b + (IF qbf-i = 1 THEN "" ELSE ",")
        + SUBSTRING(ENTRY(qbf-i,qbf-c),1,INDEX(ENTRY(qbf-i,qbf-c),":") - 1).
END.

ASSIGN
  qbf-c          = SEARCH(qbf-dir-nam)
  qbf-dir-ent    = ""
  qbf-dir-dbs    = ""
  qbf-dir-flg    = FALSE
  qbf-dir-ent[1] = "e0000<<>>" /* not "d" - see below */
  qbf-dir-ent[2] = "g0000<<>>"
  qbf-dir-ent[3] = "l0000<<>>"
  qbf-dir-ent[4] = "q0000<<>>"
  qbf-dir-ent[5] = "r0000<<>>"
  qbf-dir-ent#   = 5
  qbf-d-lo = 0   qbf-d-hi = 0
  qbf-g-lo = 0   qbf-g-hi = 0
  qbf-l-lo = 0   qbf-l-hi = 0
  qbf-q-lo = 0   qbf-q-hi = 0
  qbf-r-lo = 0   qbf-r-hi = 0.

IF qbf-c <> ? THEN DO:
  INPUT STREAM qbf-io FROM VALUE(qbf-c) NO-ECHO.
  REPEAT:
    ASSIGN
      qbf-l    = ?
      qbf-l[3] = "".
    IMPORT STREAM qbf-io qbf-l.
    IF NOT CAN-DO("export*,graph*,label*,query*,report*",qbf-l[1]) THEN NEXT.
    ASSIGN
      qbf-dir-ent# = qbf-dir-ent# + 1
      qbf-dir-ent[qbf-dir-ent#] = SUBSTRING(qbf-l[1],1,1)
                                + STRING(qbf-dir-ent#,"9999") + qbf-l[2]
      qbf-dir-dbs[qbf-dir-ent#] = qbf-l[3].
    IF qbf-l[3] = "" THEN qbf-dir-flg[qbf-dir-ent#] = ?.
    ELSE
    DO qbf-i = 1 TO NUM-ENTRIES(qbf-l[3])
      WHILE CAN-DO(qbf-b,ENTRY(qbf-i,qbf-l[3])):
      IF qbf-i = NUM-ENTRIES(qbf-l[3]) THEN qbf-dir-flg[qbf-dir-ent#] = TRUE.
    END.
  END.
  INPUT STREAM qbf-io CLOSE.

  IF qbf-dir-ent# >= 2 THEN DO: /* shell sort */
    qbf-g = TRUNCATE(qbf-dir-ent# / 2,0).
    DO WHILE qbf-g > 0:
      DO qbf-i = qbf-g TO qbf-dir-ent#:
        qbf-j = qbf-i - qbf-g.
        DO WHILE qbf-j > 0:
          IF qbf-dir-ent[qbf-j] < qbf-dir-ent[qbf-j + qbf-g] THEN LEAVE.
          ASSIGN
            qbf-c                      = qbf-dir-ent[qbf-j]
            qbf-dir-ent[qbf-j]         = qbf-dir-ent[qbf-j + qbf-g]
            qbf-dir-ent[qbf-j + qbf-g] = qbf-c
            qbf-c                      = qbf-dir-dbs[qbf-j]
            qbf-dir-dbs[qbf-j]         = qbf-dir-dbs[qbf-j + qbf-g]
            qbf-dir-dbs[qbf-j + qbf-g] = qbf-c
            qbf-a                      = qbf-dir-flg[qbf-j]
            qbf-dir-flg[qbf-j]         = qbf-dir-flg[qbf-j + qbf-g]
            qbf-dir-flg[qbf-j + qbf-g] = qbf-a
            qbf-j                      = qbf-j - qbf-g.
        END.
      END.
      qbf-g = TRUNCATE(qbf-g / 2,0).
    END.
  END.

END.
/* notice! for this block ONLY, "e" represents data_export, not "d" */
DO qbf-i = 1 TO qbf-dir-ent#:
  ASSIGN
    qbf-c              = SUBSTRING(qbf-dir-ent[qbf-i],1,1)
    qbf-dir-ent[qbf-i] = SUBSTRING(qbf-dir-ent[qbf-i],6).
  IF qbf-d-lo = 0 AND qbf-c = "e" THEN ASSIGN qbf-d-lo = qbf-i qbf-d-hi = qbf-i.
  IF qbf-g-lo = 0 AND qbf-c = "g" THEN ASSIGN qbf-g-lo = qbf-i qbf-g-hi = qbf-i.
  IF qbf-l-lo = 0 AND qbf-c = "l" THEN ASSIGN qbf-l-lo = qbf-i qbf-l-hi = qbf-i.
  IF qbf-q-lo = 0 AND qbf-c = "q" THEN ASSIGN qbf-q-lo = qbf-i qbf-q-hi = qbf-i.
  IF qbf-r-lo = 0 AND qbf-c = "r" THEN ASSIGN qbf-r-lo = qbf-i qbf-r-hi = qbf-i.
  IF qbf-c = "e" AND NOT qbf-dir-ent[qbf-i + 1] BEGINS "e" THEN
    qbf-d-hi = qbf-i.
  IF qbf-c = "g" AND NOT qbf-dir-ent[qbf-i + 1] BEGINS "g" THEN
    qbf-g-hi = qbf-i.
  IF qbf-c = "l" AND NOT qbf-dir-ent[qbf-i + 1] BEGINS "l" THEN
    qbf-l-hi = qbf-i.
  IF qbf-c = "q" AND NOT qbf-dir-ent[qbf-i + 1] BEGINS "q" THEN
    qbf-q-hi = qbf-i.
  IF qbf-c = "r" AND NOT qbf-dir-ent[qbf-i + 1] BEGINS "r" THEN
    qbf-r-hi = qbf-i.
END.

HIDE MESSAGE NO-PAUSE.
{ prores/t-reset.i }
RETURN.
