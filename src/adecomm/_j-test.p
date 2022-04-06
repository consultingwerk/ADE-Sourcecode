/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* j-test.p - check to see if table1 & table2 are OF join-able */

/*
-------------------------- READ THIS!!! --------------------------

Note that code was stolen wholesale from j-find1.p and j-find2.p.
Look there and j-find.i for explanations of the algorithms used.

This code must be called TWICE - once with table1 first and table2,
then again (if the first pass fails) with table2 first and table1.

-------------------------- READ THIS!!! --------------------------
*/

/* pi_table1 and pi_table2 must be in the form dbname.tablename.  */
DEFINE INPUT  PARAMETER pi_table1 AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pi_table2 AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER po_ofok   AS LOGICAL   NO-UNDO.

DEFINE VARIABLE v_joins AS INTEGER   NO-UNDO. /* count of join paths found */
DEFINE VARIABLE v_loop  AS INTEGER   NO-UNDO. /* loop */
DEFINE VARIABLE v_parts AS CHARACTER NO-UNDO. /* index components */

IF   LDBNAME("QBF$1":u) <> SDBNAME(ENTRY(1,pi_table1,".":u)) 
  OR LDBNAME("QBF$2":u) <> SDBNAME(ENTRY(1,pi_table2,".":u)) THEN DO:
  CREATE ALIAS "QBF$1" FOR DATABASE VALUE(SDBNAME(ENTRY(1,pi_table1,".":u))).
  CREATE ALIAS "QBF$2" FOR DATABASE VALUE(SDBNAME(ENTRY(1,pi_table2,".":u))).
  RUN adecomm/_j-test.p (pi_table1,pi_table2,OUTPUT po_ofok).
  RETURN.
END.

FIND FIRST QBF$1._Db
  WHERE QBF$1._Db._Db-name =
    (IF DBTYPE(ENTRY(1,pi_table1,".":u)) = "PROGRESS":u 
      THEN ? ELSE ENTRY(1,pi_table1,".":u))
  NO-LOCK.
FIND QBF$1._File
  OF QBF$1._Db
  WHERE QBF$1._File._File-name = ENTRY(2,pi_table1,".":u)
  NO-LOCK NO-ERROR.
IF NOT AVAILABLE(QBF$1._File) THEN
DO:
  po_ofok = FALSE.
  RETURN.
END.

FIND FIRST QBF$2._Db
  WHERE QBF$2._Db._Db-name =
    (IF DBTYPE(ENTRY(1,pi_table2,".":u)) = "PROGRESS":u 
      THEN ? ELSE ENTRY(1,pi_table2,".":u))
  NO-LOCK.
FIND QBF$2._File
  OF QBF$2._Db
  WHERE QBF$2._File._File-name = ENTRY(2,pi_table2,".":u)
  NO-LOCK NO-ERROR.
IF NOT AVAILABLE(QBF$2._File) THEN
DO:
  po_ofok = FALSE.
  RETURN.
END.

/* For each unique non-word index of the table...
   Added NOT CAN-FIND for non-V7 database cases, i.e. V6 -dma */ 
FOR EACH QBF$1._Index OF QBF$1._File NO-LOCK
  WHERE QBF$1._Index._Unique AND
    ((CAN-FIND (QBF$1._Field WHERE QBF$1._Field._Field-name = "_Wordidx":u) AND
     (QBF$1._Index._Wordidx = ? OR QBF$1._Index._Wordidx = 0)) OR
    NOT CAN-FIND (QBF$1._Field WHERE QBF$1._Field._Field-name = "_Wordidx":u)):

  /* grab the names and types of all the index components... */
  v_parts = "".
  FOR EACH QBF$1._Index-field OF QBF$1._Index NO-LOCK
    BY QBF$1._Index-field._Index-seq:
    FIND QBF$1._Field OF QBF$1._Index-field NO-LOCK.
    v_parts = v_parts
            + (IF QBF$1._Index-field._Index-seq = 1 THEN "" ELSE ",":u)
            + QBF$1._Field._Field-name + ",":u
            + STRING(QBF$1._Field._dtype).
  END.

  /* oops! no index components - must be default index */
  IF v_parts = "" THEN NEXT.

  FIND FIRST QBF$2._Field
    OF QBF$2._File
    WHERE QBF$2._Field._Field-name = ENTRY(1,v_parts)
      AND QBF$2._Field._dtype      = INTEGER(ENTRY(2,v_parts))
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE QBF$2._Field THEN NEXT.

  /* match up rest of components */
  DO v_loop = 2 TO NUM-ENTRIES(v_parts) / 2:
    FIND QBF$2._Field
      OF QBF$2._File
      WHERE QBF$2._Field._Field-name = ENTRY(v_loop * 2 - 1,v_parts)
        AND QBF$2._Field._dtype = INTEGER(ENTRY(v_loop * 2,v_parts))
      NO-LOCK NO-ERROR.
    IF NOT AVAILABLE QBF$2._Field THEN LEAVE.
  END.

  /* succeeded; can match with at least one OF */
  IF v_loop > NUM-ENTRIES(v_parts) / 2 THEN v_joins = v_joins + 1.
END.

/* only correct if exactly one way to perform OF */
po_ofok = (v_joins = 1).

RETURN.

/* j-test.p - end of file */

