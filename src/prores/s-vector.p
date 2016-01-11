/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* s-vector.p - Sort a comma-sep string into order (up to s-limcol.i) */

/*
qbf-o = input-output array
qbf-u = remove duplicate array elements
*/

DEFINE INPUT        PARAMETER qbf-u AS LOGICAL   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER qbf-o AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-e AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-g AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-s AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-t AS CHARACTER EXTENT { prores/s-limcol.i } NO-UNDO.

DO qbf-e = 1 TO MINIMUM({ prores/s-limcol.i },NUM-ENTRIES(qbf-o)):
  qbf-t[qbf-e] = ENTRY(qbf-e,qbf-o).
END.
qbf-e = qbf-e - 1.
IF qbf-e < 2 THEN RETURN.

qbf-g = TRUNCATE(qbf-e / 2,0). /* shell sort array */
DO WHILE qbf-g > 0:
  DO qbf-i = qbf-g TO qbf-e:
    qbf-j = qbf-i - qbf-g.
    DO WHILE qbf-j > 0:
      IF qbf-t[qbf-j] < qbf-t[qbf-j + qbf-g] THEN LEAVE.
      ASSIGN
        qbf-s                = qbf-t[qbf-j]
        qbf-t[qbf-j]         = qbf-t[qbf-j + qbf-g]
        qbf-t[qbf-j + qbf-g] = qbf-s
        qbf-j                = qbf-j - qbf-g.
    END.
  END.
  qbf-g = TRUNCATE(qbf-g / 2,0).
END.

IF qbf-u THEN DO: /* unique-ify */
  ASSIGN
    qbf-i = qbf-e
    qbf-e = 1.
  DO qbf-j = 2 TO qbf-i:
    IF qbf-t[qbf-e] <> qbf-t[qbf-j] THEN
      ASSIGN
        qbf-e        = qbf-e + 1
        qbf-t[qbf-e] = qbf-t[qbf-j].
  END.
END.

qbf-o = qbf-t[1].
DO qbf-i = 2 TO qbf-e:
  qbf-o = qbf-o + "," + qbf-t[qbf-i].
END.

RETURN.
