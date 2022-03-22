/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* Progress Lex Converter 7.1A->7.1C Version 1.26 */

/* j-same.p - find all files at same or higher level in heirarchy */

{ aderes/s-system.i }
{ aderes/j-define.i }

DEFINE INPUT  PARAMETER qbf-i AS INTEGER NO-UNDO. /* table id in qbf-rel-tt */
DEFINE OUTPUT PARAMETER qbf-o AS CHARACTER NO-UNDO. /* entry list of files */
DEFINE OUTPUT PARAMETER qbf-t AS CHARACTER NO-UNDO. /* entry list of paths */

ASSIGN
  qbf-o = STRING(qbf-i)
  qbf-t = STRING(qbf-i).

RUN do_search (1,qbf-i,qbf-t).

RETURN.

/* get all relationships to this file or its parents recursively */
PROCEDURE do_search:

  DEFINE INPUT PARAMETER qbf-l AS INTEGER   NO-UNDO. /* recursion lvl */
  DEFINE INPUT PARAMETER qbf-b AS INTEGER   NO-UNDO. /* table id */
  DEFINE INPUT PARAMETER qbf-p AS CHARACTER NO-UNDO. /* path */

  DEFINE VARIABLE qbf-e AS INTEGER   NO-UNDO. /* ending size of qbf-o */
  DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO. /* loop */
  DEFINE VARIABLE qbf-j AS CHARACTER NO-UNDO. /* current join */
  DEFINE VARIABLE qbf-s AS INTEGER   NO-UNDO. /* starting size of qbf-o */

  qbf-s = NUM-ENTRIES(qbf-o) + 1.
  {&FIND_TABLE_BY_ID} qbf-b.
  DO qbf-i = 2 TO NUM-ENTRIES(qbf-rel-buf.rels):
    qbf-j = ENTRY(qbf-i,qbf-rel-buf.rels).
    IF INDEX("<*?":u,SUBSTRING(qbf-j,1,1,"CHARACTER":u)) > 0 THEN NEXT.
    qbf-j = ENTRY(1,SUBSTRING(qbf-j,2,-1,"CHARACTER":u),":":u).
    IF NOT CAN-DO(qbf-o,qbf-j) THEN
      ASSIGN
        qbf-o = qbf-o + ",":u + qbf-j
        qbf-t = qbf-t + ",":u + qbf-p + "-":u + qbf-j.
  END.

  IF qbf-l = qbf-depth THEN RETURN.

  qbf-e = NUM-ENTRIES(qbf-o).
  DO qbf-i = qbf-s TO qbf-e:
    RUN do_search (
      qbf-l + 1,
      INTEGER(ENTRY(1,ENTRY(qbf-i,qbf-o),":":u)),
      qbf-p + "-":u + ENTRY(qbf-i,qbf-o)
    ).
  END.

END.

/* j-same.p - end of file */

