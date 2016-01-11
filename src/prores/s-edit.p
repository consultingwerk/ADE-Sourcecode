/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* s-edit.p - general-purpose editor */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/s-edit.i " " 20 }
{ prores/t-define.i }
{ prores/t-set.i &mod=s &set=1 }

DEFINE INPUT  PARAMETER qbf-r AS INTEGER   NO-UNDO. /* starting screen line */
DEFINE INPUT  PARAMETER qbf-t AS CHARACTER NO-UNDO. /* box title */
DEFINE OUTPUT PARAMETER qbf-a AS LOGICAL   NO-UNDO. /* end-error flag */
/* if qbf-r is negative, no box is used */

DEFINE VARIABLE qbf#  AS INTEGER               NO-UNDO. /* action */
DEFINE VARIABLE qbf-c AS CHARACTER             NO-UNDO. /* current line */
DEFINE VARIABLE qbf-f AS CHARACTER             NO-UNDO. /* in c-field.i */
DEFINE VARIABLE qbf-i AS INTEGER               NO-UNDO. /* loop */
DEFINE VARIABLE qbf-j AS INTEGER               NO-UNDO. /* loop */
DEFINE VARIABLE qbf-k AS CHARACTER             NO-UNDO. /* keyboard map */
DEFINE VARIABLE qbf-o AS CHARACTER             NO-UNDO. /* optimization */
DEFINE VARIABLE qbf-s AS INTEGER INITIAL     0 NO-UNDO. /* used with qbf-o */
DEFINE VARIABLE qbf-v AS LOGICAL INITIAL FALSE NO-UNDO. /* overtype flag */
DEFINE VARIABLE qbf-w AS LOGICAL INITIAL  TRUE NO-UNDO. /* redraw flag */
DEFINE VARIABLE qbf-x AS INTEGER INITIAL     1 NO-UNDO. /* x-position */
DEFINE VARIABLE qbf-y AS INTEGER INITIAL     1 NO-UNDO. /* y-position */

FORM
  " "
  WITH FRAME qbf-box DOWN ROW qbf-r COLUMN 1 WIDTH 80
  NO-LABELS OVERLAY NO-ATTR-SPACE
  TITLE COLOR NORMAL (IF qbf-t = "" THEN "" ELSE " " + qbf-t + " ").
FORM
  qbf-y FORMAT ">>>9" SPACE(0)
  qbf-c FORMAT "x(72)" AUTO-RETURN ATTR-SPACE
  WITH FRAME qbf-edit SCREEN-LINES - qbf-r - 1 DOWN ROW qbf-r + 1 COLUMN 2
  NO-LABELS OVERLAY NO-ATTR-SPACE NO-BOX.
COLOR DISPLAY INPUT qbf-c WITH FRAME qbf-edit.

PAUSE 0.
IF qbf-r < 0 THEN
  qbf-r = - qbf-r.
ELSE
  VIEW FRAME qbf-box.
PAUSE 0.

{ prores/c-edit.i
  &wide=  72
  &array =qbf-text
  &extent=qbf-text#
  &col=   4
}

HIDE FRAME qbf-edit NO-PAUSE.
HIDE FRAME qbf-box  NO-PAUSE.
STATUS DEFAULT.
{ prores/t-reset.i }

RETURN.
