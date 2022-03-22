/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
* _calctyp.p
*
*   Returns calculated field datatype for Where Builder
*/

{ aderes/s-define.i }

DEFINE INPUT  PARAMETER qbf-n AS CHARACTER NO-UNDO. /* field name */
DEFINE OUTPUT PARAMETER qbf-d AS CHARACTER NO-UNDO. /* datatype */
DEFINE OUTPUT PARAMETER qbf-f AS CHARACTER NO-UNDO. /* format */

DEFINE VARIABLE qbf-i   AS INTEGER   NO-UNDO.

DO qbf-i = 1 TO qbf-rc#:
  IF ENTRY(1,qbf-rcn[qbf-i]) = TRIM(qbf-n) THEN DO:
    ASSIGN
      qbf-d = STRING(qbf-rct[qbf-i])
      qbf-f = qbf-rcf[qbf-i].
    LEAVE.
  END.
END.

RETURN.

/* _calcfld.p - end of file */

