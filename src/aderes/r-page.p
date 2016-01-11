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
/* r-page.p - break-group page-eject settings */

&GLOBAL-DEFINE WIN95-BTN YES

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/r-define.i }
{ adecomm/adestds.i }
{ aderes/reshlp.i }

DEFINE OUTPUT PARAMETER qbf-chg AS LOGICAL NO-UNDO. /* changed? */

FIND FIRST qbf-rsys WHERE qbf-rsys.qbf-live.

DEFINE VARIABLE qbf-a AS LOGICAL            NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-c AS CHARACTER          NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-i AS INTEGER            NO-UNDO. /* loop */
DEFINE VARIABLE qbf-j AS INTEGER            NO-UNDO. /* loop */
DEFINE VARIABLE qbf-s AS CHARACTER          NO-UNDO. /* selection-list */
DEFINE VARIABLE qbf-v AS CHARACTER          NO-UNDO. /* value */

DEFINE VARIABLE qbf-m AS CHARACTER EXTENT 4 NO-UNDO INITIAL [
  "When  the value of  the selected field",
  "changes, the report will automatically",
  "skip to a new page.",
  "                                 " ].

IF qbf-sortby = "" THEN DO:
  qbf-rsys.qbf-page-eject = "".
  RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u,
    'You must select "Sort" fields before you can use this option.').
  RETURN.
END.

DEFINE BUTTON qbf-ok   LABEL "OK"     {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON qbf-ee   LABEL "Cancel" {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON qbf-help LABEL "&Help"  {&STDPH_OKBTN}.

/* standard button rectangle */
DEFINE RECTANGLE rect_btns {&STDPH_OKBOX}.

FORM 
  SKIP({&TFM_WID})
  SPACE(2) qbf-m[1] FORMAT "x(40)":u VIEW-AS TEXT SPACE(2) SKIP
  SPACE(2) qbf-m[2] FORMAT "x(40)":u VIEW-AS TEXT SPACE(2) SKIP
  SPACE(2) qbf-m[3] FORMAT "x(40)":u VIEW-AS TEXT SPACE(2) SKIP
  SPACE(2) qbf-m[4] FORMAT "x(40)":u VIEW-AS TEXT SPACE(2) 

  SKIP({&VM_WID})
  SPACE(2)

  qbf-s VIEW-AS SELECTION-LIST SINGLE INNER-CHARS 40 INNER-LINES 10
        SCROLLBAR-VERTICAL

  {adecomm/okform.i
    &BOX    = rect_btns
    &STATUS = no
    &OK     = qbf-ok
    &CANCEL = qbf-ee
    &HELP   = qbf-help }

  WITH FRAME qbf-what NO-ATTR-SPACE NO-LABELS THREE-D
  DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee
  TITLE "Page Break":t32 VIEW-AS DIALOG-BOX.

/* Run time layout for button area.  This defines eff_frame_width */
{adecomm/okrun.i  
   &FRAME = "FRAME qbf-what" 
   &BOX   = "rect_btns"
   &OK    = "qbf-ok" 
   &HELP  = "qbf-help"
}
/*--------------------------------------------------------------------------*/

ON HELP OF FRAME qbf-what OR CHOOSE OF qbf-help IN FRAME qbf-what
  RUN adecomm/_adehelp.p ("res":u,"CONTEXT":u,{&Page_Ejects_Dlg_Box},?).

ON DEFAULT-ACTION OF qbf-s IN FRAME qbf-what 
  APPLY "GO":u TO FRAME qbf-what.

ON GO OF FRAME qbf-what
  qbf-rsys.qbf-page-eject = qbf-s:SCREEN-VALUE IN FRAME qbf-what.

ON WINDOW-CLOSE OF FRAME qbf-what
  APPLY "END-ERROR":u TO SELF.             

/*--------------------------------------------------------------------------*/

DO qbf-i = 1 TO NUM-ENTRIES(qbf-sortby):
  ASSIGN
    qbf-c = ENTRY(1,ENTRY(qbf-i, qbf-sortby)," ":u).

  /* is this a calculated field? */
  DO qbf-j = 1 TO qbf-rc#:
    IF ENTRY(1,qbf-rcn[qbf-j]) = qbf-c THEN LEAVE.
  END.
  /* omit calculated field */
  IF qbf-j <= qbf-rc# AND qbf-rcc[qbf-j] > "" THEN NEXT.

  ASSIGN
    qbf-a = qbf-s:ADD-LAST(qbf-c) IN FRAME qbf-what.
END.

IF qbf-s:NUM-ITEMS IN FRAME qbf-what = 0 THEN DO:
  qbf-rsys.qbf-page-eject = "".
  RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u,
    'No valid sort fields were found for setting Page Break.').
  RETURN.
END.

ASSIGN
  qbf-v = qbf-rsys.qbf-page-eject
  qbf-c = "<<":u + "no page break":t32 + ">>":u
  qbf-a = qbf-s:ADD-FIRST(qbf-c) IN FRAME qbf-what
  qbf-s:SCREEN-VALUE IN FRAME qbf-what = qbf-rsys.qbf-page-eject.
  
IF LOOKUP(qbf-rsys.qbf-page-eject, REPLACE(qbf-sortby," DESC":u,"")) > 9 THEN
  qbf-a = qbf-s:SCROLL-TO-ITEM(qbf-c) IN FRAME qbf-what.

DISPLAY qbf-m[1 FOR 4] 
  WITH FRAME qbf-what.
  
ENABLE qbf-s qbf-ok qbf-ee qbf-help 
  WITH FRAME qbf-what.

DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
  WAIT-FOR GO OF FRAME qbf-what FOCUS qbf-s IN FRAME qbf-what.
END.

ASSIGN
  qbf-chg   = (qbf-v <> qbf-rsys.qbf-page-eject)
  qbf-dirty = qbf-chg.

HIDE FRAME qbf-what NO-PAUSE.
RETURN.

/* r-page.p - end of file */

