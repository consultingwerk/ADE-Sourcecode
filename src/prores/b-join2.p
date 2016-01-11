/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* b-join2.p - inner loop for b-join.p */

{ prores/b-join.i }
{ prores/reswidg.i }
{ prores/resfunc.i }

DEFINE SHARED BUFFER qbf-1a-index FOR QBF$1._Index.       /*$1._Index*/
DEFINE SHARED BUFFER qbf-1a-ixfld FOR QBF$1._Index-field. /*$1._Idx-field*/
DEFINE        BUFFER qbf-1b-ixfld FOR QBF$1._Index-field. /*$1.qbf-idxfld*/
DEFINE        BUFFER qbf-1b-field FOR QBF$1._Field.       /*$1.qbf-xfield*/
DEFINE        BUFFER qbf-2a-field FOR QBF$2._Field.       /*$2._Field*/
DEFINE        BUFFER qbf-2b-field FOR QBF$2._Field.       /*$2.qbf-yfield*/

DEFINE VARIABLE lReturn AS LOGICAL  NO-UNDO.
DEFINE VARIABLE qbf-k   AS INTEGER  NO-UNDO.
DEFINE VARIABLE qbf-l   AS INTEGER  NO-UNDO.

/*message "[b-join2.p]" view-as alert-box.*/

FOR EACH qbf-2a-field
  WHERE qbf-2a-field._Field-name = qbf-f
    AND qbf-2a-field._dtype      = qbf-t NO-LOCK:
  ASSIGN
    qbf-k = LOOKUP(SDBNAME("QBF$1"),qbf-p)
    qbf-l = LOOKUP(SDBNAME("QBF$2"),qbf-p).
  IF qbf-k = qbf-l AND
    RECID(qbf-2a-field) = qbf-1a-ixfld._Field-recid THEN NEXT.

  ASSIGN
    qbf-x#        = qbf-x# + 1
    lReturn       = getRecord("qbf-a":U, qbf-x#)
    qbf-a.aValue  = qbf-k
    qbf-a.xValue  = qbf-1a-index._File-recid
    qbf-a.bValue  = qbf-l
    qbf-a.yValue  = qbf-2a-field._File-recid.

  FOR EACH qbf-1b-ixfld OF qbf-1a-index
    WHERE qbf-1b-ixfld._Index-seq > 1 NO-LOCK:
    FIND qbf-1b-field OF qbf-1b-ixfld NO-LOCK.
    IF CAN-FIND(qbf-2b-field
      WHERE qbf-2b-field._File-recid = qbf-2a-field._File-recid
        AND qbf-2b-field._Field-name = qbf-1b-field._Field-name)
      THEN NEXT.
    qbf-x# = qbf-x# - 1.
    LEAVE.
  END.
END.

RETURN.

/* b-join2.p - end of file */
