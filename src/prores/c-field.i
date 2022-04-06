/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* c-field.i - shared form for s-field.p */

/*forms:*/

DEFINE {&new} SHARED FRAME qbf-pick.
FORM
  qbf-f FORMAT "x(40)"
  WITH FRAME qbf-pick SCROLL 1 OVERLAY NO-LABELS ATTR-SPACE
  /*qbf-d 14*/ {&down} DOWN {&row} {&column}
  COLOR DISPLAY VALUE(qbf-plo) PROMPT VALUE(qbf-phi)
  TITLE COLOR VALUE(qbf-plo) {&title} /*" " + qbf-e + " "*/.
