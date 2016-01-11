/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* d-extra.p - converts format from ".," to ",." and back */

DEFINE INPUT-OUTPUT PARAMETER qbf-f AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-i AS INTEGER NO-UNDO.

DO qbf-i = 1 TO LENGTH(qbf-f):
  IF SUBSTRING(qbf-f,qbf-i,1) = "." THEN SUBSTRING(qbf-f,qbf-i,1) = ",".
  ELSE
  IF SUBSTRING(qbf-f,qbf-i,1) = "," THEN SUBSTRING(qbf-f,qbf-i,1) = ".".
END.

RETURN.
