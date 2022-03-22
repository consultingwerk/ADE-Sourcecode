/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* q-find.p - generate find next/prev/first/last for queries */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/q-define.i }

DEFINE INPUT PARAMETER qbf-a AS CHARACTER NO-UNDO.
/*
qbf-a = file-name - create initial define new shared buffer program
qbf-a = ""        - create naviation program
*/

DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-r AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-u AS CHARACTER NO-UNDO.

ASSIGN
  qbf-r = DBRESTRICTIONS(qbf-db[qbf-level])
  qbf-u = qbf-file[qbf-level] + ' '
        + (IF qbf-where[qbf-level] = "" THEN
            qbf-of[qbf-level]
          ELSE IF qbf-of[qbf-level] = "" THEN
            "WHERE " + qbf-where[qbf-level]
          ELSE IF qbf-of[qbf-level] BEGINS "OF" THEN
            qbf-of[qbf-level] + " WHERE " + qbf-where[qbf-level]
          ELSE
            qbf-of[qbf-level] + " AND " + qbf-where[qbf-level]
          )
        + (IF qbf-index[qbf-level] = "" THEN ""
          ELSE " USE-INDEX " + qbf-index[qbf-level]).

DO qbf-j = MAXIMUM(1,qbf-level - 1) TO qbf-level:
  qbf-i = INDEX(qbf-u,qbf-db[qbf-j] + "." + qbf-file[qbf-j]).
  DO WHILE qbf-i > 0:
    ASSIGN
      SUBSTRING(qbf-u,qbf-i,LENGTH(qbf-db[qbf-j]) + 1) = "".
      qbf-i = INDEX(qbf-u,qbf-db[qbf-j] + "." + qbf-file[qbf-j]).
  END.
END.
/* Note that qbf-index will not be set if DBRESTRICTIONS() contains
USE-INDEX.  This is handled in q-init.p by making sure that the "Order"
option is unavailable on the strip menu. */

IF qbf-a = "" THEN
  OUTPUT TO VALUE(qbf-tempdir + STRING(qbf-level) + ".p") NO-MAP.
ELSE
  OUTPUT TO VALUE(qbf-tempdir + ".p") NO-MAP.

IF qbf-level > 1 THEN
  PUT UNFORMATTED 'DEFINE SHARED BUFFER '
    qbf-file[qbf-level - 1] ' FOR '
    qbf-db[qbf-level - 1] '.' qbf-file[qbf-level - 1] '.' SKIP.
PUT UNFORMATTED
  'DEFINE ' (IF qbf-a = "" THEN '' ELSE 'NEW ') 'SHARED BUFFER '
    qbf-file[qbf-level] ' FOR '
    qbf-db[qbf-level] '.' qbf-file[qbf-level] '.' SKIP.

IF qbf-a = "" THEN DO:
  PUT UNFORMATTED
    'DEFINE INPUT PARAMETER qbf-p AS INTEGER NO-UNDO.' SKIP
    'DEFINE SHARED VARIABLE qbf-off AS LOGICAL NO-UNDO.' SKIP
    'IF qbf-p = 1 OR qbf-p = -1 THEN' SKIP
    '  FIND NEXT  ' qbf-u ' NO-LOCK NO-ERROR.' SKIP.
  IF NOT CAN-DO(qbf-r,"PREV") THEN
    PUT UNFORMATTED
      'IF qbf-p = 2 OR qbf-p = -2 THEN' SKIP
      '  FIND PREV  ' qbf-u ' NO-LOCK NO-ERROR.' SKIP.
  PUT UNFORMATTED
    'qbf-off = qbf-p < 3 AND NOT AVAILABLE '
      qbf-file[qbf-level] '.' SKIP
    'IF qbf-p = 3 OR (qbf-p = 2 AND NOT AVAILABLE '
      qbf-file[qbf-level] ') THEN' SKIP
    '  FIND FIRST ' qbf-u ' NO-LOCK NO-ERROR.' SKIP.
  IF NOT CAN-DO(qbf-r,"LAST") THEN
    PUT UNFORMATTED
      'IF qbf-p = 4 OR (qbf-p = 1 AND NOT AVAILABLE '
        qbf-file[qbf-level] ') THEN' SKIP
      '  FIND LAST  ' qbf-u ' NO-LOCK NO-ERROR.' SKIP.
END.
ELSE DO:
  PUT UNFORMATTED
    'IF FALSE THEN FIND NEXT ' qbf-u ' NO-LOCK NO-ERROR.' SKIP
    'RUN ' qbf-a '.p.' SKIP.
END.


PUT UNFORMATTED 'RETURN.' SKIP.

OUTPUT CLOSE.
IF qbf-a = "" THEN
  COMPILE VALUE(qbf-tempdir + STRING(qbf-level) + ".p").
ELSE
  COMPILE VALUE(qbf-tempdir + ".p").

RETURN.
