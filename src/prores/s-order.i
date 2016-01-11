/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* s-order.i - handle blown-away subtotal groups */

/* this mess removes any references to levels of subtotals that are no
longer in existence.  for example, if a two-level subtotal is changed
to a one-level subtotal, any totals, counts, etc. on that second level
are obliterated. */
DO qbf-i = 1 TO qbf-rc#:
  qbf-c = qbf-rca[qbf-i].
  IF qbf-c = "" THEN NEXT.
  DO qbf-j = 1 TO 5:
    qbf-k = (IF qbf-order[qbf-j] = "" THEN INDEX(qbf-c,STRING(qbf-j)) ELSE 0).
    DO WHILE qbf-k > 0:
      ASSIGN
        SUBSTRING(qbf-c,qbf-k - 1,2) = ""
        qbf-k = INDEX(qbf-c,STRING(qbf-j)).
    END.
  END.
  qbf-rca[qbf-i] = qbf-c.
END.

ASSIGN
  qbf-c = STRING(qbf-order[1] = "", "/x")
        + STRING(qbf-order[2] = "","/,x")
        + STRING(qbf-order[3] = "","/,x")
        + STRING(qbf-order[4] = "","/,x")
        + STRING(qbf-order[5] = "","/,x")
  qbf-r-attr[9] = MINIMUM(qbf-r-attr[9],NUM-ENTRIES(TRIM(qbf-c))).
