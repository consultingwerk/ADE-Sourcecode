/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/* l-edit.p - label-purpose editor */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/t-define.i }
{ prores/t-set.i &mod=s &set=1 }

DEFINE VARIABLE qbf#  AS INTEGER               NO-UNDO. /* action */
DEFINE VARIABLE qbf-a AS LOGICAL               NO-UNDO. /* misc flag */
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

DEFINE VARIABLE qbf-u AS INTEGER               NO-UNDO. /* maximum extent */
qbf-u = { prores/s-limlbl.i }.

FORM
  "|" SPACE(0) qbf-y FORMAT ">>9" SPACE(0) "|" SPACE(0)
  qbf-c FORMAT "x(66)" AUTO-RETURN ATTR-SPACE
  WITH FRAME qbf-edit 8 DOWN ROW 13 COLUMN 2
  NO-LABELS OVERLAY NO-ATTR-SPACE NO-BOX.
COLOR DISPLAY INPUT qbf-c WITH FRAME qbf-edit.

{ prores/c-edit.i
  &wide=  66
  &array= qbf-l-text
  &extent=qbf-u
  &prefix="qbf-left +"
  &suffix="+ qbf-right"
  &col=   5
  &go=    "RUN prores/l-verify.p (OUTPUT qbf-c).
           IF qbf-c <> """" THEN DO:
             RUN prores/s-error.p (qbf-c).
             NEXT.
           END."
}

HIDE FRAME qbf-edit NO-PAUSE.
STATUS DEFAULT.
{ prores/t-reset.i }

RETURN.
