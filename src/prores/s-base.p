/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* s-base.p - collect a list of all available _Db-names */

{ prores/s-system.i }

DEFINE INPUT  PARAMETER qbf-a AS LOGICAL              NO-UNDO.
DEFINE OUTPUT PARAMETER qbf-o AS CHARACTER INITIAL "" NO-UNDO.

/*
qbf-a = true for initial caller (false means called itself recursively)
qbf-o = output list of db-names
*/

DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.

IF qbf-a THEN DO:
  DO qbf-i = 1 TO NUM-DBS:
    IF DBTYPE(qbf-i) <> "PROGRESS" THEN NEXT.
    CREATE ALIAS "QBF$0" FOR DATABASE VALUE(LDBNAME(qbf-i)).
    RUN prores/s-base.p (FALSE,OUTPUT qbf-c).
    qbf-o = qbf-o + (IF qbf-o = "" THEN "" ELSE ",") + qbf-c.
  END.
  RUN prores/s-vector.p (TRUE,INPUT-OUTPUT qbf-o).
END.
ELSE DO:
  qbf-o = LDBNAME("QBF$0") + ":PROGRESS".
  FOR EACH QBF$0._Db WHERE QBF$0._Db._Db-type <> "PROGRESS" NO-LOCK:
    qbf-o = qbf-o + "," + QBF$0._Db._Db-name + ":" + QBF$0._Db._Db-type.
  END.
END.

RETURN.
