/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* s-where.i - update qbf-o (WHERE clause) from qbf-p array (WHERE parts) */

qbf-o = "".
DO qbf-i = 1 TO qbf-p# {*}:
  qbf-o = qbf-o + qbf-p[qbf-i].
END.
DISPLAY qbf-o SUBSTRING(qbf-o,79,-1,"CHARACTER":u) @ qbf-f 
  WITH FRAME qbf-select.

/* s-where.i - end of file */

