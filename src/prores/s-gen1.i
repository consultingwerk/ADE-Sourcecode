/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* s-gen1.i - write out initialization stuff for calc fields */

PUT STREAM qbf-io UNFORMATTED
  'DEFINE SHARED VARIABLE qbf-total AS INTEGER NO-UNDO.' SKIP.
DO qbf-i = 1 TO qbf-rc#:
  IF qbf-rcc[qbf-i] = "" OR qbf-rcc[qbf-i] BEGINS "e" THEN NEXT.
  qbf-c = ENTRY(1,qbf-rcn[qbf-i]).
  IF qbf-rcc[qbf-i] BEGINS "c" THEN
    qbf-j = INTEGER(ENTRY(2,qbf-rcn[qbf-i])) - INTEGER(ENTRY(3,qbf-rcn[qbf-i])).
  IF qbf-rcc[qbf-i] BEGINS "p" THEN
    PUT STREAM qbf-io UNFORMATTED SKIP
      'DEFINE VARIABLE ' ENTRY(1,qbf-rcn[qbf-i]) '  AS DECIMAL NO-UNDO.' SKIP
      'DEFINE VARIABLE ' ENTRY(1,qbf-rcn[qbf-i]) '% AS DECIMAL NO-UNDO.'.
  ELSE
    PUT STREAM qbf-io UNFORMATTED SKIP
      'DEFINE VARIABLE ' ENTRY(1,qbf-rcn[qbf-i]) '  AS '
        CAPS(ENTRY(qbf-rct[qbf-i],qbf-dtype))
        (IF NOT qbf-rcc[qbf-i] BEGINS "c" THEN ''
          ELSE ' INITIAL ' + STRING(qbf-j))
        ' NO-UNDO.'.
END.
PUT STREAM qbf-io UNFORMATTED SKIP(1).
