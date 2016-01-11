/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* s-prefix.p - splits the filename prefix from the basename */

DEFINE INPUT  PARAMETER qbf-f AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER qbf-p AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-b AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.
qbf-b = qbf-f.

IF CAN-DO("OS2,MSDOS,UNIX,VMS",OPSYS) THEN DO:
  qbf-i = INDEX(qbf-b,":").
  DO WHILE qbf-i > 0:
    ASSIGN
      qbf-b = SUBSTRING(qbf-b,qbf-i + 1)
      qbf-i = INDEX(qbf-b,":").
  END.
END.

IF CAN-DO("OS2,MSDOS,UNIX",OPSYS) THEN DO:
  qbf-i = MAXIMUM(INDEX(qbf-b,"~\"),INDEX(qbf-b,"/")).
  DO WHILE qbf-i > 0:
    ASSIGN
      qbf-b = SUBSTRING(qbf-b,qbf-i + 1)
      qbf-i = MAXIMUM(INDEX(qbf-b,"~\"),INDEX(qbf-b,"/")).
  END.
END.

IF OPSYS = "BTOS" THEN
  IF qbf-b MATCHES "~{*~}*" THEN
    qbf-b = SUBSTRING(qbf-b,INDEX(qbf-b,"~}") + 1).

IF CAN-DO("VMS,BTOS",OPSYS) THEN
  IF qbf-b MATCHES "[*]*" THEN
    qbf-b = SUBSTRING(qbf-b,INDEX(qbf-b,"]") + 1).

IF OPSYS = "BTOS" THEN
  IF qbf-b MATCHES "<*>*" THEN
    qbf-b = SUBSTRING(qbf-b,INDEX(qbf-b,">") + 1).

qbf-p = SUBSTRING(qbf-f,1,LENGTH(qbf-f) - LENGTH(qbf-b)).
RETURN.
