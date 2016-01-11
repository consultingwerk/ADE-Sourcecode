/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
* _sbase.p - collect a list of all available _Db-names.  All databases
*  including non-Progress ones must be connected. The list will be sorted.
*/

{ aderes/s-system.i }
{ aderes/j-define.i }

DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.

DO qbf-i = 1 TO NUM-DBS:
  qbf-dbs = qbf-dbs + (IF qbf-dbs = "" THEN "" ELSE ",":u) + LDBNAME(qbf-i).
END.

/* Sort the list */
RUN aderes/s-vector.p(TRUE, ",":u, INPUT-OUTPUT qbf-dbs).

qbf-hidedb = (NUM-ENTRIES(qbf-dbs) = 1).

RETURN.

/* _sbase.p -  end of file */

