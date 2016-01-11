/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* s-zap.p - reset current item */

{ prores/s-system.i }
{ prores/s-define.i }

DEFINE VARIABLE qbf-i AS INTEGER NO-UNDO.

ASSIGN
  qbf-name  = ""   /* <-- file stuff */
  qbf-order = ""
  qbf-db    = ""
  qbf-file  = ""
  qbf-where = ""
  qbf-of    = ""

  qbf-rc#   = 0    /* <-- field stuff */
  qbf-rcn   = ""
  qbf-rcl   = ""
  qbf-rcf   = ""
  qbf-rca   = ""
  qbf-rcc   = ""
  qbf-rcw   = ?
  qbf-rct   = 0

  qbf-time  = ""   /* <-- other stuff */
  qbf-total = 0.

ASSIGN /* data export stuff */
  qbf-d-attr[1] = 'PROGRESS'
  qbf-d-attr[2] = 'no'
  qbf-d-attr[3] = ',,,,,,,,,,,'
  qbf-d-attr[4] = '13,10,,,,,,,,,,'
  qbf-d-attr[5] = '34,,,,,,,,,,,'
  qbf-d-attr[6] = '32,,,,,,,,,,,'.
  qbf-d-attr[7] = '*'.

ASSIGN /* labels stuff */
  qbf-l-attr[1] = 0
  qbf-l-attr[2] = 0
  qbf-l-attr[3] = 6
  qbf-l-attr[4] = 0
  qbf-l-attr[5] = 1
  qbf-l-attr[6] = 1
  qbf-l-attr[7] = 1
  qbf-l-text    = "".

ASSIGN /* report stuff */
  qbf-r-attr[1] = (IF qbf-r-defs[25] = "" THEN  1 ELSE INTEGER(qbf-r-defs[25]))
  qbf-r-attr[2] = (IF qbf-r-defs[26] = "" THEN 66 ELSE INTEGER(qbf-r-defs[26]))
  qbf-r-attr[3] = (IF qbf-r-defs[27] = "" THEN  1 ELSE INTEGER(qbf-r-defs[27]))
  qbf-r-attr[4] = (IF qbf-r-defs[28] = "" THEN  1 ELSE INTEGER(qbf-r-defs[28]))
  qbf-r-attr[5] = (IF qbf-r-defs[29] = "" THEN  1 ELSE INTEGER(qbf-r-defs[29]))
  qbf-r-attr[6] = (IF qbf-r-defs[30] = "" THEN  0 ELSE INTEGER(qbf-r-defs[30]))
  qbf-r-attr[7] = (IF qbf-r-defs[31] = "" THEN  0 ELSE INTEGER(qbf-r-defs[31]))
  qbf-r-attr[8] = 0
  qbf-r-attr[9] = 0
  qbf-r-head    = "".
DO qbf-i = 1 TO 24:
  IF qbf-r-defs[qbf-i] <> "" THEN qbf-r-head[qbf-i] = qbf-r-defs[qbf-i].
END.

RETURN.
