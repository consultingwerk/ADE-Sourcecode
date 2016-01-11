/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* a-zap.p - blow away files in filesystem */

{ prores/s-system.i }

/* assumes all referenced files exist and are sufficiently */
/* qualified (e.g., no need to SEARCH() for them). */

DEFINE INPUT PARAMETER qbf-f AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-n AS CHARACTER NO-UNDO.

qbf-i = INDEX(qbf-f,",,").
DO WHILE qbf-i > 0:
  ASSIGN
    SUBSTRING(qbf-f,qbf-i,2) = ","
    qbf-i = INDEX(qbf-f,",,").
END.
IF qbf-f BEGINS "," THEN qbf-f = SUBSTRING(qbf-f,2).
IF qbf-f MATCHES "*," THEN qbf-f = SUBSTRING(qbf-f,1,LENGTH(qbf-f) - 1).

IF CAN-DO("UNIX,BTOS",OPSYS) THEN DO:
  qbf-i = INDEX(qbf-f,",").
  DO WHILE qbf-i > 0:
    ASSIGN
      SUBSTRING(qbf-f,qbf-i,1) = " "
      qbf-i = INDEX(qbf-f,",").
  END.
  IF qbf-f = "" THEN .
  ELSE IF OPSYS = "UNIX" THEN 
    UNIX SILENT rm -f VALUE(qbf-f).
  ELSE IF OPSYS = "BTOS" THEN 
    BTOS OS-DELETE VALUE(qbf-f).
END.
ELSE
IF OPSYS = "VMS" THEN DO:
  /*  "in: |" qbf-f "|" skip.*/
  DO qbf-i = 1 TO NUM-ENTRIES(qbf-f):
    qbf-n = ENTRY(qbf-i,qbf-f).
    /*put unformatted "  >" string(qbf-i) ": |" qbf-n "|" skip.*/
    IF qbf-n = "" THEN NEXT.
    IF INDEX(qbf-n,"/") > 0 THEN
      RUN prores/s-extra.p (INPUT-OUTPUT qbf-n).
    qbf-c = qbf-c + (IF qbf-c = "" THEN "" ELSE ",") + qbf-n + "~;*".
  END.
  IF qbf-c <> "" THEN VMS SILENT delete VALUE(qbf-c).
END.
ELSE
IF CAN-DO("OS2,MSDOS",OPSYS) THEN DO:
  DO WHILE qbf-f <> "":
    ASSIGN
      qbf-c = ENTRY(1,qbf-f        ) + " "
            + ENTRY(2,qbf-f + ","  ) + " "
            + ENTRY(3,qbf-f + ",," ) + " "
            + ENTRY(4,qbf-f + ",,,")
      qbf-f = SUBSTRING(qbf-f,LENGTH(qbf-c) + 2).
    IF qbf-c = "" THEN NEXT.
    qbf-c = "for %i in (" + qbf-c + ") do del %i".
    IF qbf-c = "" THEN .
    ELSE IF OPSYS = "MSDOS" THEN DOS SILENT VALUE(qbf-c).
    ELSE IF OPSYS = "OS2"   THEN OS2 SILENT VALUE(qbf-c).
  END.
END.

RETURN.
