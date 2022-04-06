/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* ostodir.p - takes its parameter and makes it look like a directory name */

DEFINE INPUT-OUTPUT PARAMETER dirname AS CHARACTER NO-UNDO.
DEFINE VARIABLE i AS INTEGER NO-UNDO.

IF dirname = "" AND OPSYS = "UNIX" THEN dirname = "./".

i = (IF CAN-DO("MSDOS,WIN32,OS2",OPSYS) THEN INDEX(dirname,"~\") ELSE 0).
DO WHILE i > 0:
  ASSIGN
    OVERLAY(dirname,i,1) = "/"
    i = INDEX(dirname,"~\").
END.

IF CAN-DO("MSDOS,WIN32,OS2,UNIX",OPSYS) AND dirname <> ""
  AND NOT dirname MATCHES "*/" THEN dirname = dirname + "/".

RETURN.
