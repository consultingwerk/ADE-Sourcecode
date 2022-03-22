/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* s-where.i - update qbf-o (where clause) from qbf-p array (where parts) */

qbf-o = "".
DO qbf-i = 1 TO qbf-p# {*}:
  qbf-o = qbf-o + qbf-p[qbf-i].
END.
DISPLAY qbf-o SUBSTRING(qbf-o,79) @ qbf-f WITH FRAME qbf-select.
