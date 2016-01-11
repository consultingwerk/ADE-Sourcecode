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
/* r-level.p - master-detail settings */

&GLOBAL-DEFINE WIN95-BTN YES

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/j-define.i }
{ adecomm/adestds.i }
{ aderes/reshlp.i }

DEFINE OUTPUT PARAMETER qbf-o AS LOGICAL NO-UNDO. /* all ok? */

DEFINE VARIABLE qbf-a AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO. /* loop */
DEFINE VARIABLE qbf-k AS INTEGER   NO-UNDO. /* loop */
DEFINE VARIABLE qbf-s AS CHARACTER NO-UNDO. /* selection-list */
DEFINE VARIABLE qbf-v AS INTEGER   NO-UNDO. /* value */

/* message text */
DEFINE VARIABLE qbf-m AS CHARACTER EXTENT 4 NO-UNDO.

DEFINE BUTTON qbf-ok   LABEL "OK"     {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON qbf-ee   LABEL "Cancel" {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON qbf-Help LABEL "&Help"  {&STDPH_OKBTN}.

/* standard button rectangle */
DEFINE RECTANGLE rect_btns            {&STDPH_OKBOX}.

FORM
  SKIP({&TFM_WID})
  SPACE(2) qbf-m[1] FORMAT "x(40)":u VIEW-AS TEXT SPACE(1) SKIP
  SPACE(2) qbf-m[2] FORMAT "x(40)":u VIEW-AS TEXT SKIP
  SPACE(2) qbf-m[3] FORMAT "x(40)":u VIEW-AS TEXT SKIP
  SPACE(2) qbf-m[4] FORMAT "x(40)":u VIEW-AS TEXT 
  SKIP({&VM_WID})

  qbf-s AT 2 VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-V SCROLLBAR-H
      	     INNER-CHARS 40 INNER-LINES 6 SKIP

  {adecomm/okform.i
     &BOX    = rect_btns
     &STATUS = no
     &OK     = qbf-ok
     &CANCEL = qbf-ee
     &HELP   = qbf-help }

  WITH FRAME qbf-mast-det NO-ATTR-SPACE NO-LABELS THREE-D
  DEFAULT-BUTTON qbf-Ok CANCEL-BUTTON qbf-ee
  TITLE "Master-Detail" VIEW-AS DIALOG-BOX.

/* Run time layout for button area.  This defines eff_frame_width */
{adecomm/okrun.i  
   &FRAME = "FRAME qbf-mast-det" 
   &BOX   = "rect_btns"
   &OK    = "qbf-ok" 
   &HELP  = "qbf-help" }

/*------------------------------Triggers--------------------------------*/

ON HELP OF FRAME qbf-mast-det OR CHOOSE OF qbf-help IN FRAME qbf-mast-det
  RUN adecomm/_adehelp.p ("res":u,"CONTEXT":u,{&Master_Detail_Dlg_Box},?).

ON DEFAULT-ACTION OF qbf-s IN FRAME qbf-mast-det
  APPLY "GO":u TO FRAME qbf-mast-det.

ON GO OF FRAME qbf-mast-det DO:
  qbf-s = qbf-s:SCREEN-VALUE IN FRAME qbf-mast-det.

  /* qbf-detail is the table id of the child - i.e., the parent for
     the child section.
  */
  IF qbf-s <> qbf-s:ENTRY(1) IN FRAME qbf-mast-det THEN DO:
    /* Don't allow user to split into master-detail if they also
       want a Totals Only Summary.
    */
    RUN master_detail_and_totals_only (TRUE, ?).
    IF RETURN-VALUE = "error":u THEN
      RETURN NO-APPLY.

    /* Between "file-1" and "file-2" */
    /* 11111111 222222 33333 444444  */
    RUN lookup_table (ENTRY(4,qbf-s,'"':u), OUTPUT qbf-detail).
  END.
  ELSE
    qbf-detail = 0.

  ASSIGN
    qbf-o      = (qbf-v <> qbf-detail) /* value changed? */
    qbf-dirty  = qbf-dirty OR qbf-o
    qbf-redraw = qbf-o.
END.

ON WINDOW-CLOSE OF FRAME qbf-mast-det
  APPLY "END-ERROR":u TO SELF.             

/*-----------------------------Mainline Code-----------------------------*/

ASSIGN
  qbf-m[1] = 'This sets the "break" point between the':t40
  qbf-m[2] = 'tables used in the "master" and in the':t40
  qbf-m[3] = '"detail" sections of the query.':t40
  qbf-m[4] = " ":u.

IF NUM-ENTRIES(qbf-tables) < 2 THEN DO:
  qbf-detail = 0.  
  RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u,
    "You must have at least two tables defined to use this option.").
  RETURN.
END.

/* join_pairs fills the selection list and indirectly sets qbf-c (the 
   initial selected items) by calling add_to_selected.
*/
ASSIGN
  qbf-c = '<<':u + 'one section' + '>>':u.
  qbf-a = qbf-s:ADD-LAST(qbf-c) IN FRAME qbf-mast-det.

RUN join_pairs (ENTRY(1, qbf-tables), qbf-s:HANDLE IN FRAME qbf-mast-det,
      	        "get_selected":u).

/* Remember current qbf-detail, set initial selection and make sure it's
   in view in the select list.
*/
ASSIGN
  qbf-v                                    = qbf-detail
  qbf-s:SCREEN-VALUE IN FRAME qbf-mast-det = qbf-c.
  
RUN adecomm/_scroll.p (qbf-s:HANDLE IN FRAME qbf-mast-det, qbf-c).

DISPLAY qbf-m WITH FRAME qbf-mast-det.

ENABLE qbf-s qbf-ok qbf-ee qbf-Help WITH FRAME qbf-mast-det.

DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
  WAIT-FOR GO OF FRAME qbf-mast-det FOCUS qbf-s IN FRAME qbf-mast-det.
END.

HIDE FRAME qbf-mast-det NO-PAUSE.
RETURN.

/*-------------------------Internal Procedures----------------------------*/

/* This is called by join_pairs for each item added to the selection list.
   This will add to the list of select list items that will be selected 
   initially based on which join pairs are currently outer joins.

   Input Parameters:
      p_tbl      - table id of base table (parent)
      p_join_tbl - join table id for p_tbl.
      p_lst_item - list item string
*/
PROCEDURE get_selected:
  DEFINE INPUT PARAMETER p_tbl      AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p_join_tbl AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p_lst_item AS CHARACTER NO-UNDO.

  IF qbf-detail = INTEGER(p_join_tbl) THEN 
    qbf-c = p_lst_item.
END.

/*---------------------------------------------------------------*/

/* join_pairs */
{ aderes/j-pairs.i }

/* lookup_table */
{ aderes/p-lookup.i }

/* Procedure master_detail_and_totals_only */
{ aderes/restrict.i }

/* r-level.p - end of file */

