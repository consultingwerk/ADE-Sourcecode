/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* r-write.i - generate first-page-only or last-page-only frames */

/*
called by r-write.p
f:
  &base=1
  &first="SKIP '    SKIP(1)'"
  &name=qbf-first
  &disp="SKIP '  DISPLAY WITH FRAME qbf-first.'"

l:
  &base=4
  &last="SKIP '    SKIP(1)'"
  &name=qbf-last
*/

IF qbf-w[{&base}] + qbf-w[{&base} + 1] + qbf-w[{&base} + 2] > 0 THEN DO:
  PUT STREAM qbf-io UNFORMATTED '  FORM HEADER' {&last}.
  qbf-j = MAXIMUM(0,(qbf-s
        - { prores/s-max3.i qbf-w[{&base}] "qbf-w[{&base} + 1]" "qbf-w[{&base} + 2]" }
          ) / 2).
  DO qbf-i = {&base} TO {&base} + 2:
    IF qbf-w[qbf-i] = 0 THEN NEXT.
    PUT STREAM qbf-io UNFORMATTED SKIP
      '    SPACE(' STRING(qbf-j) ') ' qbf-m[qbf-i] ' SKIP'.
  END.
  PUT STREAM qbf-io UNFORMATTED {&first} SKIP
    '    WITH FRAME {&name} COLUMN ' qbf-r-attr[1]
    ' WIDTH ' qbf-r-size - 1 + qbf-r-attr[1]
    ' NO-ATTR-SPACE NO-LABELS NO-BOX.'
    {&disp} SKIP(1).
END.
