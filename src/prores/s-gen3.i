/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* s-gen3.i - calc fields prepass code */

/* much of this code is similar to s-gen2.i */

qbf-j = 0. /* 0=none, 1=one, 2=many */
DO qbf-i = 1 TO qbf-rc# WHILE qbf-j < 2:
  IF qbf-rcc[qbf-i] BEGINS "p" THEN qbf-j = qbf-j + 1.
END.

IF {&count} OR qbf-j > 0 THEN DO:
  PUT STREAM qbf-io UNFORMATTED 'FOR '.
  DO qbf-i = 1 TO 5 WHILE qbf-file[qbf-i] <> "":
    qbf-c = (IF qbf-asked[qbf-i] = "" THEN
              qbf-of[qbf-i]
            ELSE IF qbf-of[qbf-i] = "" THEN
              "WHERE " + qbf-asked[qbf-i]
            ELSE IF qbf-of[qbf-i] BEGINS "OF" THEN
              qbf-of[qbf-i] + " WHERE " + qbf-asked[qbf-i]
            ELSE
              "WHERE (" + SUBSTRING (qbf-of[qbf-i],7) + ") AND (" + qbf-asked[qbf-i] + ")"
            ).
    IF qbf-c <> "" THEN qbf-c = " " + qbf-c.
    PUT STREAM qbf-io UNFORMATTED
      'EACH ' qbf-db[qbf-i] '.' qbf-file[qbf-i] qbf-c ' NO-LOCK'.
    IF qbf-i < 5 AND qbf-file[qbf-i + 1] <> "" THEN
      PUT STREAM qbf-io UNFORMATTED ',' SKIP '  '.
  END.

  PUT STREAM qbf-io UNFORMATTED SKIP
    '  qbf-total = 1 TO qbf-total + 1:' SKIP.

  PUT STREAM qbf-io UNFORMATTED
    '  ' (IF qbf-j < 2 THEN '' ELSE 'ASSIGN').
  DO qbf-i = 1 TO qbf-rc#:
    IF NOT qbf-rcc[qbf-i] BEGINS "p" THEN NEXT.
    IF qbf-j > 1 THEN PUT STREAM qbf-io UNFORMATTED SKIP '    '.
    PUT STREAM qbf-io UNFORMATTED
      ENTRY(1,qbf-rcn[qbf-i]) '% = ' ENTRY(1,qbf-rcn[qbf-i]) '% + '
      ENTRY(2,qbf-rcn[qbf-i]).
  END.
  PUT STREAM qbf-io UNFORMATTED '.' SKIP 'END.' SKIP(1).
END.
