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
/* s-inc.p - support include file after each for-each */

&GLOBAL-DEFINE WIN95-BTN YES

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/j-define.i }
{ adecomm/adestds.i }
{ aderes/reshlp.i}

DEFINE OUTPUT PARAMETER po_changed AS LOGICAL INITIAL FALSE NO-UNDO.

DEFINE VARIABLE v_editor AS CHARACTER         NO-UNDO.
DEFINE VARIABLE v_table  AS INTEGER           NO-UNDO.
DEFINE VARIABLE sel-st   AS CHARACTER         NO-UNDO. /* 4GL selection */  

DEFINE BUTTON qbf-ok   LABEL "OK"     {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON qbf-ee   LABEL "Cancel" {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON qbf-Help LABEL "&Help"  {&STDPH_OKBTN}.
/* standard button rectangle */
DEFINE RECTANGLE rect_btns            {&STDPH_OKBOX}.

FORM
  SKIP({&TFM_WID})
  "Code to insert after FOR EACH:":t48 AT 2 VIEW-AS TEXT SKIP
  v_editor AT 2 VIEW-AS EDITOR INNER-LINES 8 INNER-CHARS 68 
           NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL {&STDPH_ED4GL_SMALL}
  SKIP({&VM_WID})

  {adecomm/okform.i
     &BOX    = rect_btns
     &STATUS = no
     &OK     = qbf-ok
     &CANCEL = qbf-ee
     &HELP   = qbf-help}

  WITH FRAME fr%inc NO-ATTR-SPACE NO-LABELS THREE-D
  TITLE " ":t20 VIEW-AS DIALOG-BOX.

/* Run time layout for button area.  This defines eff_frame_width */
{adecomm/okrun.i  
   &FRAME = "FRAME fr%inc" 
   &BOX   = "rect_btns"
   &OK    = "qbf-ok" 
   &HELP  = "qbf-help" }

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

ON HELP OF FRAME fr%inc OR CHOOSE OF qbf-help IN FRAME fr%inc
  RUN adecomm/_adehelp.p ("res":u,"CONTEXT":u,
                          {&Insert_Code_After_FOR_EACH_Dlg_Box},?).

ON HELP OF v_editor DO:
  sel-st = "".
  IF (v_editor:SELECTION-START <> v_editor:SELECTION-END ) THEN
    sel-st = TRIM(TRIM(v_editor:SELECTION-TEXT), ",.;:!? ~"~ '[]()").
  RUN adecomm/_adehelp.p ("lgrf":u,"PARTIAL-KEY":u,?,sel-st).
END.

ON WINDOW-CLOSE OF FRAME fr%inc
  APPLY "END-ERROR":u TO SELF.             

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

v_table = INTEGER(ENTRY(1,qbf-tables)).
RUN aderes/j-table1.p (qbf-tables, YES, INPUT-OUTPUT v_table).

IF v_table = 0 THEN RETURN.
{&FIND_TABLE_BY_ID} v_table.
FRAME fr%inc:TITLE = "Insert Code After" + " FOR EACH ":u + qbf-rel-buf.tname.

ON GO OF FRAME fr%inc DO:
  DEFINE VARIABLE good AS LOGICAL NO-UNDO.
  RUN aderes/_scompil.p (0, 0, v_editor:SCREEN-VALUE IN FRAME fr%inc,
      	       	         FALSE, OUTPUT good).
  IF NOT good THEN DO:
    APPLY "ENTRY":u TO v_editor IN FRAME fr%inc.
    RETURN NO-APPLY.
  END.

  FIND FIRST qbf-where WHERE qbf-where.qbf-wtbl = v_table NO-ERROR.
  IF NOT AVAILABLE qbf-where THEN CREATE qbf-where.
  ASSIGN
    po_changed         = TRUE
    qbf-where.qbf-wtbl = v_table
    qbf-where.qbf-winc = v_editor:SCREEN-VALUE IN FRAME fr%inc.
END.

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

FIND FIRST qbf-where WHERE qbf-where.qbf-wtbl = v_table NO-ERROR.
v_editor = (IF AVAILABLE qbf-where THEN qbf-where.qbf-winc ELSE "").

DISPLAY v_editor WITH FRAME fr%inc.
ENABLE v_editor qbf-ok qbf-ee qbf-Help WITH FRAME fr%inc.

DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  WAIT-FOR GO OF FRAME fr%inc FOCUS v_editor IN FRAME fr%inc.
END.

OS-DELETE "qbf_tc.p":u.  /* delete any test compile file */
HIDE FRAME fr%inc NO-PAUSE.
RETURN.

/* s-inc.p - end of file */

