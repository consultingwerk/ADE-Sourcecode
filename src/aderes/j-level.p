/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* Progress Lex Converter 7.1A->7.1C Version 1.26 */

/* j-level.p - adjust scoping of fields to for-each blocks */

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/j-define.i }

DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO. /* loop */
DEFINE VARIABLE qbf-j AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-n AS CHARACTER NO-UNDO. /* field name */
DEFINE VARIABLE qbf-s AS CHARACTER NO-UNDO. /* section */
DEFINE VARIABLE qbf-t AS INTEGER   NO-UNDO. /* table index */

DO qbf-i = 1 TO qbf-rc#:
  ASSIGN
    qbf-n = ENTRY(NUM-ENTRIES(qbf-rcn[qbf-i]),qbf-rcn[qbf-i])
    qbf-t = 0
    qbf-j = R-INDEX(qbf-n,".":u).
  IF qbf-j > 0 THEN
    RUN lookup_table (SUBSTRING(qbf-n,1,qbf-j - 1,"CHARACTER":u),OUTPUT qbf-t).
  RELEASE qbf-section.
  IF qbf-t > 0 THEN
    FIND FIRST qbf-section
      WHERE CAN-DO(qbf-section.qbf-stbl,STRING(qbf-t)) NO-ERROR.
  IF AVAILABLE qbf-section THEN qbf-rcs[qbf-i] = qbf-section.qbf-sout.
END.

RETURN.

{ aderes/p-lookup.i }

/* j-level.p - end of file */

