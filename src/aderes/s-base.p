/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* s-base.p - collect a list of all available _Db-names.  All databases
   including non-Progress ones must be connected. The list will be sorted.
*/

{ aderes/j-define.i }

DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.

DO qbf-i = 1 TO NUM-DBS:
  qbf-dbs = qbf-dbs + (IF qbf-dbs = "" THEN "" ELSE ",":u) + LDBNAME(qbf-i).
END.
RUN aderes/s-vector.p (TRUE,",":u,INPUT-OUTPUT qbf-dbs). /* sort the list */

RETURN.

/* s-base.p - end of file */

