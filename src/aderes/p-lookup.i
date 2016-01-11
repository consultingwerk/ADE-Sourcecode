/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 p-lookup.i - sub-proc to lookup file reference in relation table
 
 requires: { aderes/j-define.i }

 input:    dbname.filename

 output:   table id, or -1 for not found

*/

PROCEDURE lookup_table:
  DEFINE INPUT  PARAMETER qbf_f AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER qbf_p AS INTEGER   NO-UNDO.

  qbf_f = (IF INDEX(qbf_f,".":u) = 0 THEN 
             LDBNAME(1) + ".":u + qbf_f
           ELSE IF NUM-ENTRIES(qbf_f, ".":u) = 3 THEN
             ENTRY(1, qbf_f, ".":u) + ".":u + ENTRY(2, qbf_f, ".":u)
           ELSE qbf_f).

  {&FIND_TABLE_BY_NAME} qbf_f NO-ERROR.
  qbf_p = IF AVAILABLE (qbf-rel-buf) THEN qbf-rel-buf.tid ELSE -1.
END.

/* p-lookup.i - end of file */

