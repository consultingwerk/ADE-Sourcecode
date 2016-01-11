/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* s-print.p - output printer control codes */

{ prores/s-system.i }
{ prores/s-print.i }

DEFINE INPUT PARAMETER qbf-t AS INTEGER NO-UNDO.
/*
qbf-t = 1 - output initialization string   (qbf-pr-init)
      = 2 - output normal print string     (qbf-pr-norm)
      = 3 - output compressed print string (qbf-pr-comp)
      = 4 - output bold-on print string    (qbf-pr-bon)
      = 5 - output bold-off print string   (qbf-pr-boff)
*/

/* only execute this program for "to", "thru" and "file" device types */
IF CAN-DO("term,view,page,prog",qbf-pr-type[qbf-device]) THEN RETURN.

DEFINE VARIABLE qbf-b AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-l AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-s AS CHARACTER NO-UNDO.

qbf-s = (IF qbf-t = 1 THEN qbf-pr-init[qbf-device]
    ELSE IF qbf-t = 2 THEN qbf-pr-norm[qbf-device]
    ELSE IF qbf-t = 3 THEN qbf-pr-comp[qbf-device]
    ELSE IF qbf-t = 4 THEN qbf-pr-bon[qbf-device]
    ELSE IF qbf-t = 5 THEN qbf-pr-boff[qbf-device]
    ELSE "").

DO qbf-l = 1 TO NUM-ENTRIES(qbf-s):
  IF ENTRY(qbf-l,qbf-s) = "" THEN NEXT.
  qbf-b = INTEGER(ENTRY(qbf-l,qbf-s)).
  IF qbf-b = 0 THEN PUT CONTROL NULL. ELSE PUT CONTROL CHR(qbf-b).
END.

RETURN.
