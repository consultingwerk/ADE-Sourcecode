/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* i-verify.p - check can-read for file and field definitions */

{ prores/s-system.i }
{ prores/s-define.i }

DEFINE VARIABLE qbf-c AS CHARACTER             NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER               NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER               NO-UNDO.
DEFINE VARIABLE qbf-o AS CHARACTER             NO-UNDO.
DEFINE VARIABLE qbf-u AS LOGICAL INITIAL FALSE NO-UNDO. /* changed? */

qbf-j = 0.
DO qbf-i = 1 TO 5 WHILE qbf-file[qbf-i] <> "":
  RUN prores/s-lookup.p
    (qbf-db[qbf-i],qbf-file[qbf-i],"","FILE:CAN-READ",OUTPUT qbf-o).
  IF CAN-DO(qbf-o,USERID("RESULTSDB")) THEN
    ASSIGN
      qbf-j            = qbf-j + 1
      qbf-db[qbf-j]    = qbf-db[qbf-i]
      qbf-file[qbf-j]  = qbf-file[qbf-i]
      qbf-where[qbf-j] = qbf-where[qbf-i]
      qbf-of[qbf-j]    = qbf-of[qbf-i].
END.
DO qbf-i = qbf-j + 1 TO 5:
  ASSIGN
    qbf-u            = qbf-u OR qbf-file[qbf-i] <> ""
    qbf-db[qbf-i]    = ""
    qbf-file[qbf-i]  = ""
    qbf-where[qbf-i] = ""
    qbf-of[qbf-i]    = "".
END.
qbf-j = 0.
DO qbf-i = 1 TO qbf-rc#:
  qbf-c = ENTRY(IF INDEX(qbf-rcn[qbf-i],",") > 0 THEN 2 ELSE 1,qbf-rcn[qbf-i]).
  IF INDEX("sdln",SUBSTRING(qbf-rcc[qbf-i],1,1)) > 0 THEN .
  ELSE
  IF INDEX(qbf-c,".") > 0 THEN DO:
    RUN prores/s-lookup.p (qbf-c,"","","FIELD:TYP&FMT",OUTPUT qbf-o).
    IF qbf-rct[qbf-i] <> INTEGER(ENTRY(1,qbf-o)) THEN NEXT.
    RUN prores/s-lookup.p (qbf-c,"","","FIELD:CAN-READ",OUTPUT qbf-o).
    IF NOT CAN-DO(qbf-o,USERID("RESULTSDB")) THEN NEXT.
  END.
  ASSIGN
    qbf-j          = qbf-j + 1
    qbf-rcn[qbf-j] = qbf-rcn[qbf-i]
    qbf-rcl[qbf-j] = qbf-rcl[qbf-i]
    qbf-rcf[qbf-j] = qbf-rcf[qbf-i]
    qbf-rca[qbf-j] = qbf-rca[qbf-i]
    qbf-rcc[qbf-j] = qbf-rcc[qbf-i]
    qbf-rcw[qbf-j] = qbf-rcw[qbf-i]
    qbf-rct[qbf-j] = qbf-rct[qbf-i].
END.
ASSIGN
  qbf-u   = qbf-u OR (qbf-j <> qbf-rc#)
  qbf-rc# = qbf-j.

IF qbf-u THEN 
  RUN prores/s-error.p ("#3").
/*
Some of the files and/or fields have
been omitted because of one of the
following reasons:
1) original databases not connected
2) database definition changes
3) insufficient permissions
*/

RETURN.
