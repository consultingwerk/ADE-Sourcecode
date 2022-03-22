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

/* JEP WIN32 7/11/97 3:56PM */
IF CAN-DO("OS2,MSDOS,WIN32,UNIX,VMS":u,OPSYS) THEN DO:
  qbf-i = INDEX(qbf-b,":":u).
  DO WHILE qbf-i > 0:
    ASSIGN
      qbf-b = SUBSTRING(qbf-b,qbf-i + 1,-1,"CHARACTER":u)
      qbf-i = INDEX(qbf-b,":":u).
  END.
END.

IF CAN-DO("OS2,MSDOS,WIN32,UNIX":u,OPSYS) THEN DO:
  qbf-i = MAXIMUM(INDEX(qbf-b,"~\":u),INDEX(qbf-b,"/":u)).
  DO WHILE qbf-i > 0:
    ASSIGN
      qbf-b = SUBSTRING(qbf-b,qbf-i + 1,-1,"CHARACTER":u)
      qbf-i = MAXIMUM(INDEX(qbf-b,"~\":u),INDEX(qbf-b,"/":u)).
  END.
END.

IF OPSYS = "BTOS":u THEN
  IF qbf-b MATCHES "~{*~}*":u THEN
    qbf-b = SUBSTRING(qbf-b,INDEX(qbf-b,"~}":u) + 1,-1,"CHARACTER":u).

IF CAN-DO("VMS,BTOS":u,OPSYS) THEN
  IF qbf-b MATCHES "[*]*":u THEN
    qbf-b = SUBSTRING(qbf-b,INDEX(qbf-b,"]":u) + 1,-1,"CHARACTER":u).

IF CAN-DO("VMS,BTOS":u,OPSYS) THEN
  IF qbf-b MATCHES "<*>*":u THEN
    qbf-b = SUBSTRING(qbf-b,INDEX(qbf-b,">":u) + 1,-1,"CHARACTER":u).

qbf-p = SUBSTRING(qbf-f,1,LENGTH(qbf-f,"CHARACTER":u)
                            - LENGTH(qbf-b,"CHARACTER":u),"CHARACTER":u).
RETURN.

/* s-prefix.p - end of file */

