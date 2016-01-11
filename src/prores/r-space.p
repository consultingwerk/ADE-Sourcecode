/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* r-space.p - get report settings and spacings */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/t-define.i }
{ prores/t-set.i &mod=r &set=2 }

DEFINE VARIABLE qbf-i AS INTEGER NO-UNDO. /* scrap */

DEFINE VARIABLE qbf-b AS INTEGER NO-UNDO. /* spaces between columns */
DEFINE VARIABLE qbf-f AS INTEGER NO-UNDO. /* lines between body and footer */
DEFINE VARIABLE qbf-h AS INTEGER NO-UNDO. /* lines between header and body */
DEFINE VARIABLE qbf-l AS INTEGER NO-UNDO. /* line spacing */
DEFINE VARIABLE qbf-m AS INTEGER NO-UNDO. /* left margin */
DEFINE VARIABLE qbf-p AS INTEGER NO-UNDO. /* lines per page */
DEFINE VARIABLE qbf-t AS INTEGER NO-UNDO. /* starting line */

ASSIGN
  qbf-m = qbf-r-attr[1]
  qbf-p = qbf-r-attr[2]
  qbf-b = qbf-r-attr[3]
  qbf-l = qbf-r-attr[4]
  qbf-t = qbf-r-attr[5]
  qbf-h = qbf-r-attr[6]
  qbf-f = qbf-r-attr[7].

/* alters qbf-lang, but in a non-destructive manner */
DO qbf-i = 2 TO 8:
  IF qbf-lang[qbf-i] MATCHES "*:" THEN
    SUBSTRING(qbf-lang[qbf-i],LENGTH(qbf-lang[qbf-i]),1) = "".
  qbf-lang[qbf-i] = FILL(" ",32 - LENGTH(qbf-lang[qbf-i]))
                  + qbf-lang[qbf-i] + ":".
END.

FORM
  qbf-lang[2] FORMAT "x(32)" NO-ATTR-SPACE qbf-m "1"  SKIP
  qbf-lang[3] FORMAT "x(32)" NO-ATTR-SPACE qbf-b "1"  SKIP(1)
  qbf-lang[4] FORMAT "x(32)" NO-ATTR-SPACE qbf-t "1"  SKIP
  qbf-lang[5] FORMAT "x(32)" NO-ATTR-SPACE qbf-p "66" SKIP
  qbf-lang[6] FORMAT "x(32)" NO-ATTR-SPACE qbf-l "1"  SKIP(1)
  qbf-lang[7] FORMAT "x(32)" NO-ATTR-SPACE qbf-h "0"  SKIP
  qbf-lang[8] FORMAT "x(32)" NO-ATTR-SPACE qbf-f "0"  SKIP
  HEADER SKIP(1)
  qbf-lang[1] FORMAT "x(52)" SKIP
  WITH FRAME r-spacing ROW 5 CENTERED NO-LABELS ATTR-SPACE OVERLAY
  TITLE COLOR NORMAL " " + qbf-lang[9] + " ". /*"Settings - Spacing"*/

FORM
  qbf-m VALIDATE(qbf-m >  0,qbf-lang[12])
  qbf-b VALIDATE(qbf-b >= 0,qbf-lang[13])
  qbf-t VALIDATE(qbf-t >  0,qbf-lang[14])
  qbf-p VALIDATE(qbf-p >= 0,qbf-lang[11])
  qbf-l VALIDATE(qbf-l >  0 AND qbf-l < INPUT qbf-p,qbf-lang[10])
  qbf-h VALIDATE(qbf-h >= 0 AND qbf-h < INPUT qbf-p,qbf-lang[13])
  qbf-f VALIDATE(qbf-f >= 0 AND qbf-f < INPUT qbf-p,qbf-lang[13])
  WITH FRAME r-spacing.

/*
qbf-m "Left margin"           "The left-most the report can go is to column 1"
qbf-b "Spaces between columns"             "Please keep this value reasonable"
qbf-t "Starting Line"            "The top-most the report can go is to line 1"
qbf-p "Lines per page"                      "No negative page lengths, please"
qbf-l "Line spacing"      "Line spacing must be between one and the page size"
qbf-h "Lines Between Header and Body"      "Please keep this value reasonable"
qbf-f "Lines Between Body and Footer"      "Please keep this value reasonable"
*/

PAUSE 0.
DISPLAY qbf-lang[2 FOR 7] WITH FRAME r-spacing.

DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  UPDATE qbf-m qbf-b qbf-t qbf-p qbf-l qbf-h qbf-f WITH FRAME r-spacing.
  ASSIGN
    qbf-r-attr[1] = qbf-m
    qbf-r-attr[2] = qbf-p
    qbf-r-attr[3] = qbf-b
    qbf-r-attr[4] = qbf-l
    qbf-r-attr[5] = qbf-t
    qbf-r-attr[6] = qbf-h
    qbf-r-attr[7] = qbf-f.
END.

HIDE FRAME r-spacing NO-PAUSE.
{ prores/t-reset.i }
RETURN.
