/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* Put an escape sequenve in front of meta-characters. */
DEFINE INPUT PARAMETER src AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER trgt AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER mss-escape AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER ret-unknown AS LOGICAL NO-UNDO.

DEFINE VARIABLE strt AS INT INIT 1 NO-UNDO.
DEFINE VARIABLE ind AS INT NO-UNDO.
DEFINE VARIABLE escape-seq AS CHARACTER NO-UNDO.

/* Some drivers don't support % in the search pattern */
IF src = "%" OR ret-unknown THEN src = ?.

IF src = ? OR mss-escape = ? OR mss-escape = "" OR src = "%"
THEN DO:
  trgt = src.
  RETURN.
END.

escape-seq = mss-escape + "_".
REPEAT:
  ind = INDEX (SUBSTRING(src,strt), "_").

  IF ind = 0
    THEN LEAVE.

  SUBSTRING(src, ind + strt - 1, 1) = escape-seq.
  strt = strt + ind  + 1.
END.

escape-seq = mss-escape + "%".
strt = 1.
ind = 0.
REPEAT:
  ind = INDEX (SUBSTRING(src,strt), "%").

  IF ind = 0
    THEN LEAVE.

  SUBSTRING(src, ind + strt - 1, 1) = escape-seq.
  strt = strt + ind  + 1.
END.

trgt = src.

RETURN.



