/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* Progress Lex Converter 7.1A->7.1C Version 1.26 */

/* a-zap.p - blow away files in filesystem */

{ aderes/s-system.i }

/* assumes all referenced files exist and are sufficiently */
/* qualified (e.g., no need to SEARCH() for them). */

DEFINE INPUT PARAMETER qbf-f AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-n AS CHARACTER NO-UNDO.

DO qbf-i = 1 TO NUM-ENTRIES(qbf-f):
  qbf-c = ENTRY(qbf-i,qbf-f).
  IF qbf-c = ? THEN NEXT.
  IF OPSYS = "VMS":u AND INDEX(qbf-c,"/":u) > 0 THEN
    RUN aderes/s-vms.p (INPUT-OUTPUT qbf-c).
  OS-DELETE VALUE(qbf-c).
END.

RETURN.

/* a-zap.p - end of file */

