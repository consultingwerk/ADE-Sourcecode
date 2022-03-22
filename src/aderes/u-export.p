/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* Progress Lex Converter 7.1A->7.1C Version 1.26 */

/* u-export.p - sample export program */

DEFINE INPUT PARAMETER qbf-s  AS CHARACTER NO-UNDO. /* Prolog, Body, Epilog */
DEFINE INPUT PARAMETER qbf-n  AS CHARACTER NO-UNDO. /* field name */
DEFINE INPUT PARAMETER qbf-l  AS CHARACTER NO-UNDO. /* field label */
DEFINE INPUT PARAMETER qbf-f  AS CHARACTER NO-UNDO. /* field format */
DEFINE INPUT PARAMETER qbf-p  AS INTEGER   NO-UNDO. /* field position */
DEFINE INPUT PARAMETER qbf-t  AS INTEGER   NO-UNDO. /* field datatype */
DEFINE INPUT PARAMETER qbf-m  AS CHARACTER NO-UNDO. /* left margin */
DEFINE INPUT PARAMETER qbf-b  AS LOGICAL   NO-UNDO. /* is first field? */
DEFINE INPUT PARAMETER qbf-e  AS LOGICAL   NO-UNDO. /* is last field? */
DEFINE INPUT PARAMETER lkup   AS LOGICAL   NO-UNDO. /* is it a lookup field? */
DEFINE INPUT PARAMETER nm-val AS CHARACTER NO-UNDO. /* no match value (lookup)*/

CASE qbf-s:
  WHEN "p":u THEN DO:
    /* nothing to do! */
  END.
  WHEN "b":u THEN DO:
    IF qbf-b THEN PUT UNFORMATTED qbf-m 'EXPORT':u.
    PUT UNFORMATTED SKIP qbf-m '  ':u qbf-n.
    IF qbf-e THEN PUT UNFORMATTED '.':u SKIP.
  END.
  WHEN "e":u THEN DO:
    /* nothing to do! */
  END.
END CASE.

RETURN.

/* u-export.p - end of file */

