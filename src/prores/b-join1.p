/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* b-join1.p - middle loop for b-join.p */

{ prores/s-system.i }
{ prores/t-define.i }
{ prores/b-join.i }

DEFINE            BUFFER qbf-1a-field FOR QBF$1._Field.       /*$1._Field*/
DEFINE NEW SHARED BUFFER qbf-1a-index FOR QBF$1._Index.       /*$1._Index*/
DEFINE NEW SHARED BUFFER qbf-1a-ixfld FOR QBF$1._Index-field. /*$1._Idx-field*/

DEFINE VARIABLE qbf-i AS INTEGER NO-UNDO.
qbf-i = { prores/s-etime.i }.

FOR EACH qbf-1a-index
  WHERE qbf-1a-index._Unique
    AND qbf-1a-index._Index-name < "_" NO-LOCK:
  FIND qbf-1a-ixfld OF qbf-1a-index
    WHERE qbf-1a-ixfld._Index-seq = 1 NO-LOCK NO-ERROR.
  IF NOT AVAILABLE qbf-1a-ixfld THEN NEXT.
  FIND qbf-1a-field OF qbf-1a-ixfld NO-LOCK.
  ASSIGN
    qbf-f = qbf-1a-field._Field-name
    qbf-t = qbf-1a-field._dtype.

  DO qbf-i = 1 TO NUM-ENTRIES(qbf-p):
    CREATE ALIAS "QBF$2" FOR DATABASE VALUE(ENTRY(qbf-i,qbf-p)).
    RUN prores/b-join2.p.
  END.

  /* display msg every 10 seconds */
  IF qbf-x# > 0 AND { prores/s-etime.i } - qbf-i > 10000 THEN DO:
    /* qbf-lang[11] = "Finding implied OF-relations." */
    STATUS DEFAULT qbf-lang[11] + " (" + STRING(qbf-x#) + ").".
    qbf-i = { prores/s-etime.i }.
  END.

END.

RETURN.
