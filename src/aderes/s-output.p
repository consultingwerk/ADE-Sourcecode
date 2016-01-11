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
/* Progress Lex Converter 7.1A->7.1C Version 1.26 */

/* s-output.p - selection list of output devices */

&GLOBAL-DEFINE WIN95-BTN YES

{ aderes/s-system.i }
{ aderes/s-output.i }
{ adecomm/adestds.i }

DEFINE OUTPUT PARAMETER qbf-t AS CHARACTER             NO-UNDO. /* dev type */
DEFINE OUTPUT PARAMETER qbf-n AS CHARACTER             NO-UNDO. /* dev name */
DEFINE OUTPUT PARAMETER qbf-o AS LOGICAL INITIAL FALSE NO-UNDO. /* ok? */

DEFINE VARIABLE qbf-a AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-l AS INTEGER   NO-UNDO. /* loop */
DEFINE VARIABLE qbf-s AS CHARACTER NO-UNDO. /* selection-list */

DEFINE BUTTON qbf-ok LABEL "   OK   ":c8 SIZE 10 BY 1 AUTO-GO.
DEFINE BUTTON qbf-ee LABEL " Cancel ":c8 SIZE 10 BY 1 AUTO-ENDKEY.

FORM
  SKIP(.5)
  qbf-s
    VIEW-AS SELECTION-LIST SINGLE INNER-CHARS 40 INNER-LINES 10
  SKIP

  qbf-ok qbf-ee SKIP(.5)

  WITH FRAME qbf-what NO-ATTR-SPACE NO-LABELS THREE-D
  TITLE "Select Output Device":t32 VIEW-AS DIALOG-BOX.

qbf-ee:X IN FRAME qbf-what = FRAME qbf-what:WIDTH-PIXELS
                           - qbf-ee:WIDTH-PIXELS IN FRAME qbf-what - 6.

/*--------------------------------------------------------------------------*/

ON GO OF FRAME qbf-what OR DEFAULT-ACTION OF qbf-s IN FRAME qbf-what
  APPLY "CHOOSE":u TO qbf-ok IN FRAME qbf-what.

ON CHOOSE OF qbf-ok IN FRAME qbf-what DO:
  qbf-s = qbf-s:SCREEN-VALUE IN FRAME qbf-what.
  IF qbf-s = ? OR qbf-s = "" THEN RETURN.
  DO qbf-l = 1 TO qbf-printer#:
    IF qbf-s <> qbf-printer[qbf-l] THEN NEXT.
    qbf-device = qbf-l.
    LEAVE.
  END.
  ASSIGN
    qbf-n = qbf-pr-dev[qbf-device]
    qbf-t = qbf-pr-type[qbf-device]
    qbf-o = TRUE. /* "ok" pressed */
END.

ON WINDOW-CLOSE OF FRAME qbf-what
  APPLY "END-ERROR":u TO SELF.

/*--------------------------------------------------------------------------*/

DO qbf-l = 1 TO qbf-printer#:
  qbf-a = qbf-s:ADD-LAST(qbf-printer[qbf-l]) IN FRAME qbf-what.
END.

qbf-s:SCREEN-VALUE IN FRAME qbf-what = qbf-printer[qbf-device].
IF qbf-device > 10 THEN
  qbf-a = qbf-s:SCROLL-TO-ITEM(qbf-printer[qbf-device - 10]) IN FRAME qbf-what.

DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
  ENABLE qbf-s qbf-ok qbf-ee WITH FRAME qbf-what.
  WAIT-FOR CHOOSE OF qbf-ok IN FRAME qbf-what
    OR SELECTION OF qbf-ee IN FRAME qbf-what.
END.

HIDE FRAME qbf-what NO-PAUSE.
RETURN.

/* s-output.p - end of file */

