/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* s-gen4.i - calc field code for main loop */

qbf-j = 0. /* 0=none, 1=one, 2=many */
DO qbf-i = 1 TO qbf-rc# WHILE qbf-j < 2:
  IF CAN-DO("r*,p*,c*,s*,d*,n*,l*",qbf-rcc[qbf-i]) THEN qbf-j = qbf-j + 1.
END.

IF qbf-j > 1 THEN PUT STREAM qbf-io UNFORMATTED '  ASSIGN'.

IF qbf-j > 0 THEN
  DO qbf-i = 1 TO qbf-rc#:
    qbf-c = (IF qbf-rcc[qbf-i] BEGINS "r" THEN
              ENTRY(1,qbf-rcn[qbf-i]) + ' + ' + ENTRY(2,qbf-rcn[qbf-i])
            ELSE IF qbf-rcc[qbf-i] BEGINS "p" THEN
              ENTRY(2,qbf-rcn[qbf-i]) + ' * 100 / '
                + ENTRY(1,qbf-rcn[qbf-i]) + '%'
            ELSE IF qbf-rcc[qbf-i] BEGINS "c" THEN
              ENTRY(1,qbf-rcn[qbf-i]) + ' + ' + ENTRY(3,qbf-rcn[qbf-i])
            ELSE IF CAN-DO("s*,d*,n*,l*",qbf-rcc[qbf-i]) THEN
              SUBSTRING(qbf-rcn[qbf-i],INDEX(qbf-rcn[qbf-i],",") + 1)
            ELSE
              ''
            ).
    IF qbf-c <> "" THEN
      PUT STREAM qbf-io UNFORMATTED SKIP
        '  ' (IF qbf-j = 1 THEN '' ELSE '  ')
        ENTRY(1,qbf-rcn[qbf-i]) ' = ' qbf-c.
  END.

IF qbf-j > 0 THEN PUT STREAM qbf-io UNFORMATTED '.' SKIP.
