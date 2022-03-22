/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* q-total.p - generate counting program for query */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/q-define.i }

DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.

qbf-c = (IF qbf-where[qbf-level] = "" THEN
          qbf-of[qbf-level]
        ELSE IF qbf-of[qbf-level] = "" THEN
          "WHERE " + qbf-where[qbf-level]
        ELSE IF qbf-of[qbf-level] BEGINS "OF" THEN
          qbf-of[qbf-level] + " WHERE " + qbf-where[qbf-level]
        ELSE
          "(" + qbf-of[qbf-level] + ") AND (" + qbf-where[qbf-level] + ")"
        ).

IF qbf-level > 1 THEN DO:
  qbf-i = INDEX(qbf-c,qbf-db[qbf-level - 1] + "." + qbf-file[qbf-level - 1]).
  DO WHILE qbf-i > 0:
    ASSIGN
      SUBSTRING(qbf-c,qbf-i,LENGTH(qbf-db[qbf-level - 1]) + 1) = "".
      qbf-i = INDEX(qbf-c,qbf-db[qbf-level - 1]
              + "." + qbf-file[qbf-level - 1]).
  END.
END.

OUTPUT TO VALUE(qbf-tempdir + ".p") NO-ECHO NO-MAP.

IF qbf-level > 1 THEN PUT UNFORMATTED
  'DEFINE SHARED BUFFER ' qbf-file[qbf-level - 1] ' FOR '
    qbf-db[qbf-level - 1] '.' qbf-file[qbf-level - 1] '.' SKIP.

PUT UNFORMATTED
  'DEFINE SHARED VARIABLE qbf-total AS INTEGER NO-UNDO.' SKIP
  'qbf-total = 0.' SKIP
  'READKEY PAUSE 0.' SKIP
  'FOR EACH ' qbf-db[qbf-level] '.' qbf-file[qbf-level]
    ' ' qbf-c ' NO-LOCK' SKIP
    '  qbf-total = 1 TO qbf-total + 1:' SKIP
  '  IF qbf-total MODULO 10 = 0 THEN READKEY PAUSE 0.' SKIP
  '  IF qbf-total MODULO 10 = 0 AND LASTKEY <> -1 THEN LEAVE.' SKIP
  'END.' SKIP
  'RETURN.' SKIP.

OUTPUT CLOSE.
COMPILE VALUE(qbf-tempdir + ".p") ATTR-SPACE.
RETURN.
