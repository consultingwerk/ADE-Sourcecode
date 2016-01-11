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
/*----------------------------------------------------------------------------

  File: y-total.p

  Description: set aggregate properties for report columns

  Input Parameters:             < none >

  Output Parameters:    qbf-o - value changed?

  Author: Greg O'Connor

  Created: 08/20/93 - 12:17 pm

-----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/j-define.i }
{ adecomm/adestds.i }
{ aderes/reshlp.i }

/*
	   Query Fields            +--------------------------------------+
+--------------------------------+ |            Sort-By Fields            |
|                                | | +----------------------------------+ |
|                                | | |                                  | |
|                                | | |                                  | |
|                                | | |                                  | |
|                                | | |                                  | |
|                                | | |                                  | |
|                                | | |                                  | |
|                                | | +----------------------------------+ |
|                                | | +- Properties ------------+          |
|                                | | | [ ] Total               | +------+ |
|                                | | | [ ] Count               | |  OK  | |
|                                | | | [ ] Minimum             | +------+ |
|                                | | | [ ] Maximum             | +------+ |
|                                | | | [ ] Average             | |Cancel| |
|                                | | +-------------------------+ +------+ |
+--------------------------------+ +--------------------------------------+
*/
&scoped-define testing false

DEFINE OUTPUT PARAMETER qbf-o AS LOGICAL INITIAL FALSE NO-UNDO. /* changed? */

DEFINE VARIABLE qbf-cx  AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-dx  AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-i   AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-ix  AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-j   AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-jx  AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-k   AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-g   LIKE qbf-rcg NO-UNDO.
DEFINE VARIABLE qbf-l   AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-lx  AS LOGICAL   NO-UNDO EXTENT 5. /* scrap */
DEFINE VARIABLE realtbl AS CHARACTER NO-UNDO. /* real tbl name - not alias */

DEFINE VARIABLE qbf-q  AS CHARACTER NO-UNDO. /* query-fields sellist */
DEFINE VARIABLE qbf-q& AS CHARACTER NO-UNDO. /* query-fields labels */
DEFINE VARIABLE qbf-s  AS CHARACTER NO-UNDO. /* sort-by fields sellist */
DEFINE VARIABLE qbf-s& AS CHARACTER NO-UNDO. /* sort-by fields labels */

DEFINE VARIABLE qbf-t  AS LOGICAL   NO-UNDO. /* aggregate props */
DEFINE VARIABLE qbf-c  AS LOGICAL   NO-UNDO. /* aggregate props */
DEFINE VARIABLE qbf-x  AS LOGICAL   NO-UNDO. /* aggregate props */
DEFINE VARIABLE qbf-n  AS LOGICAL   NO-UNDO. /* aggregate props */
DEFINE VARIABLE qbf-a  AS LOGICAL   NO-UNDO. /* aggregate props */

DEFINE VARIABLE qbf-t1 AS CHARACTER VIEW-AS TEXT.
DEFINE VARIABLE qbf-t2 AS CHARACTER VIEW-AS TEXT.
DEFINE VARIABLE qbf-t3 AS CHARACTER VIEW-AS TEXT.

DEFINE BUTTON qbf-ra   LABEL "&Reset All Aggregates":c24.
DEFINE BUTTON qbf-ok   LABEL "OK"     {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON qbf-ee   LABEL "Cancel" {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON qbf-help LABEL "&Help"  {&STDPH_OKBTN}.

/* standard button rectangle */
DEFINE RECTANGLE rect_btns            {&STDPH_OKBOX}.

ASSIGN
  qbf-t1 = "&Query Fields:":t28
  qbf-t2 = "&Break-By Fields:":t28
  qbf-t3 = "Aggregates:":t20.

&SCOPED-DEFINE ATCOL 50

FORM
  SKIP({&TFM_WID})
  qbf-t1 FORMAT "x(26)":u AT 2
    VIEW-AS TEXT
    
  qbf-t2 FORMAT "x(28)":u AT {&ATCOL}
    VIEW-AS TEXT SKIP

  qbf-q& AT 2
    VIEW-AS SELECTION-LIST SINGLE INNER-CHARS 30 INNER-LINES 16
    SCROLLBAR-VERTICAL SCROLLBAR-HORIZONTAL FONT 0

  qbf-q AT ROW-OF qbf-q& COLUMN-OF qbf-q&
    VIEW-AS SELECTION-LIST SINGLE INNER-CHARS 30 INNER-LINES 16
    SCROLLBAR-VERTICAL SCROLLBAR-HORIZONTAL FONT 0

  qbf-toggle1 AT 2
    LABEL "Show Field &Labels"
    VIEW-AS TOGGLE-BOX

  {adecomm/okform.i
     &BOX    = rect_btns
     &STATUS = no
     &OK     = qbf-ok
     &CANCEL = qbf-ee
     &HELP   = qbf-help }

  qbf-s& AT ROW-OF qbf-q COLUMN {&ATCOL}
    VIEW-AS SELECTION-LIST SINGLE INNER-CHARS 31 INNER-LINES 5
    SCROLLBAR-VERTICAL SCROLLBAR-HORIZONTAL FONT 0
									   
  qbf-s AT ROW-OF qbf-s& COLUMN-OF qbf-s&
    VIEW-AS SELECTION-LIST SINGLE INNER-CHARS 31 INNER-LINES 5
    SCROLLBAR-VERTICAL SCROLLBAR-HORIZONTAL FONT 0

  SKIP({&VM_WIDG})

  qbf-t3 FORMAT "x(15)":u AT {&ATCOL} VIEW-AS TEXT SKIP({&VM_WID})

  qbf-t  VIEW-AS TOGGLE-BOX LABEL "&Total"   AT {&ATCOL} SKIP
  qbf-c  VIEW-AS TOGGLE-BOX LABEL "&Count"   AT {&ATCOL} SKIP
  qbf-x  VIEW-AS TOGGLE-BOX LABEL "Ma&ximum" AT {&ATCOL} SKIP
  qbf-n  VIEW-AS TOGGLE-BOX LABEL "Mi&nimum" AT {&ATCOL} SKIP
  qbf-a  VIEW-AS TOGGLE-BOX LABEL "&Average" AT {&ATCOL} SKIP({&VM_WIDG})
  
  qbf-ra AT {&ATCOL}

  WITH FRAME qbf-tagg VIEW-AS DIALOG-BOX  NO-LABELS THREE-D WIDTH 99
  DEFAULT-BUTTON qbf-Ok CANCEL-BUTTON qbf-ee
  TITLE "Field Aggregates".

qbf-t2:FORMAT IN FRAME qbf-tagg = "x(":u 
				+ STRING(LENGTH(qbf-t2,"RAW":u)) 
				+ ")":u.

/* Run time layout for button area.  This defines eff_frame_width */
{adecomm/okrun.i  
   &FRAME = "FRAME qbf-tagg" 
   &BOX   = "rect_btns"
   &OK    = "qbf-ok"
   &HELP  = "qbf-help" }

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

ON HELP OF FRAME qbf-tagg OR CHOOSE OF qbf-help IN FRAME qbf-tagg
  RUN adecomm/_adehelp.p ("res":u,"CONTEXT":u,{&Totals_Dlg_Box},?).

ON VALUE-CHANGED OF qbf-q, qbf-q& IN FRAME qbf-tagg DO:
  RUN fillup.
  RUN update_status.
END.

ON ALT-Q OF FRAME qbf-tagg DO:
   IF qbf-toggle1 THEN
      APPLY "ENTRY":u TO qbf-q& IN FRAME qbf-tagg.
   ELSE
      APPLY "ENTRY":u TO qbf-q  IN FRAME qbf-tagg.
END.

ON ALT-B OF FRAME qbf-tagg DO:
   IF qbf-toggle1 THEN
      APPLY "ENTRY":u TO qbf-s& IN FRAME qbf-tagg.
   ELSE
      APPLY "ENTRY":u TO qbf-s  IN FRAME qbf-tagg.
END.
   
ON VALUE-CHANGED OF qbf-toggle1 IN FRAME qbf-tagg DO:
  DEFINE VARIABLE q_widg AS HANDLE NO-UNDO.
  DEFINE VARIABLE s_widg AS HANDLE NO-UNDO.

  /* pre-assign qbf-toggle1 */
  IF qbf-toggle1 THEN
    ASSIGN
      qbf-i  = qbf-q&:LOOKUP(qbf-q&:SCREEN-VALUE) IN FRAME qbf-tagg
      qbf-j  = qbf-s&:LOOKUP(qbf-s&:SCREEN-VALUE) IN FRAME qbf-tagg.
  ELSE 
    ASSIGN
      qbf-i  = qbf-q:LOOKUP(qbf-q:SCREEN-VALUE) IN FRAME qbf-tagg
      qbf-j  = qbf-s:LOOKUP(qbf-s:SCREEN-VALUE) IN FRAME qbf-tagg.

  ASSIGN
    qbf-toggle1                        = INPUT FRAME qbf-tagg qbf-toggle1
    qbf-q:VISIBLE  IN FRAME qbf-tagg   = NOT qbf-toggle1
    qbf-q&:VISIBLE IN FRAME qbf-tagg   = qbf-toggle1
    qbf-s:VISIBLE  IN FRAME qbf-tagg   = NOT qbf-toggle1
    qbf-s&:VISIBLE IN FRAME qbf-tagg   = qbf-toggle1
    qbf-q:SENSITIVE IN FRAME qbf-tagg  = NOT qbf-toggle1
    qbf-q&:SENSITIVE IN FRAME qbf-tagg = qbf-toggle1
    qbf-s:SENSITIVE IN FRAME qbf-tagg  = NOT qbf-toggle1
    qbf-s&:SENSITIVE IN FRAME qbf-tagg = qbf-toggle1
  .

  IF qbf-toggle1 THEN
    ASSIGN
      q_widg = qbf-q&:HANDLE IN FRAME qbf-tagg
      s_widg = qbf-s&:HANDLE IN FRAME qbf-tagg
      .
  ELSE
    ASSIGN
      q_widg = qbf-q:HANDLE IN FRAME qbf-tagg
      s_widg = qbf-s:HANDLE IN FRAME qbf-tagg
      .

  ASSIGN
    q_widg:SCREEN-VALUE = ENTRY(qbf-i,q_widg:LIST-ITEMS,CHR(3))
    s_widg:SCREEN-VALUE = ENTRY(qbf-j,s_widg:LIST-ITEMS,CHR(3))
    .

  /* scroll list so at least first selected item is in view */
  IF q_widg:SCREEN-VALUE <> ? THEN
    RUN adecomm/_scroll.p (q_widg,ENTRY(qbf-i,q_widg:LIST-ITEMS,CHR(3))).
  IF s_widg:SCREEN-VALUE <> ? THEN
    RUN adecomm/_scroll.p (s_widg,ENTRY(qbf-j,s_widg:LIST-ITEMS,CHR(3))).
END.

ON VALUE-CHANGED OF qbf-s, qbf-s& IN FRAME qbf-tagg
  RUN update_status.

ON VALUE-CHANGED OF qbf-t IN FRAME qbf-tagg
  RUN value_changed ("t":u,qbf-t:SCREEN-VALUE IN FRAME qbf-tagg).

ON VALUE-CHANGED OF qbf-c IN FRAME qbf-tagg
  RUN value_changed ("c":u,qbf-c:SCREEN-VALUE IN FRAME qbf-tagg).

ON VALUE-CHANGED OF qbf-n IN FRAME qbf-tagg
  RUN value_changed ("n":u,qbf-n:SCREEN-VALUE IN FRAME qbf-tagg).

ON VALUE-CHANGED OF qbf-x IN FRAME qbf-tagg
  RUN value_changed ("x":u,qbf-x:SCREEN-VALUE IN FRAME qbf-tagg).

ON VALUE-CHANGED OF qbf-a IN FRAME qbf-tagg
  RUN value_changed ("a":u,qbf-a:SCREEN-VALUE IN FRAME qbf-tagg).

ON GO OF FRAME qbf-tagg DO:
  DO qbf-i = 1 TO qbf-rc#:
    /* note 'totals' turns off 'hide-repeated-values' for field */
    qbf-j = INDEX(qbf-g[qbf-i],"&":u).
    
    IF qbf-j > 0 AND LENGTH(qbf-g[qbf-i],"CHARACTER":u) > 1 THEN
      SUBSTRING(qbf-g[qbf-i],qbf-j,1,"CHARACTER":u) = "".
      
    /* copy changed values from qbf-g[] to qbf-rcg[]. */
    ASSIGN
      qbf-o          = qbf-o OR qbf-g[qbf-i] <> qbf-rcg[qbf-i]
      qbf-dirty      = qbf-dirty OR qbf-o
      qbf-rcg[qbf-i] = qbf-g[qbf-i]
      qbf-redraw     = qbf-o. 
  END.
END.

ON CHOOSE OF qbf-ra IN FRAME qbf-tagg DO:
  DO qbf-i = 1 TO qbf-rc#:
    IF qbf-g[qbf-i] = "&":u THEN NEXT. /* skip hide-repeating-values */
    qbf-g[qbf-i] = IF INDEX(qbf-g[qbf-i],"$":u) > 0 THEN "$":u ELSE "".
  END.
  
  DISPLAY qbf-t qbf-c qbf-x qbf-n qbf-a
    WITH FRAME qbf-tagg.
END.

ON WINDOW-CLOSE OF FRAME qbf-tagg
  APPLY "END-ERROR":u TO SELF. 

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

IF qbf-rc# = 0 THEN RETURN.

ASSIGN
  qbf-q:DELIMITER IN FRAME qbf-tagg  = CHR(3)
  qbf-q&:DELIMITER IN FRAME qbf-tagg = CHR(3)
  qbf-s:DELIMITER IN FRAME qbf-tagg  = CHR(3)
  qbf-s&:DELIMITER IN FRAME qbf-tagg = CHR(3).

/* prescan for widest query field label -dma */
DO qbf-i = 1 TO qbf-rc#:
  qbf-cx = ENTRY(1,qbf-rcn[qbf-i]).
  
  IF qbf-rcc[qbf-i] = "" THEN DO:
    RUN alias_to_tbname (qbf-cx,TRUE,OUTPUT realtbl).
    RUN aderes/s-schema.p (realtbl,"","","FIELD:LABEL":u,OUTPUT qbf-dx).
  END.

  ELSE IF qbf-rcc[qbf-i] > "" AND qbf-rcl[qbf-i] <> ? THEN 
    qbf-dx = qbf-rcl[qbf-i].

  ELSE qbf-dx = qbf-cx.

  qbf-ix = MAXIMUM(qbf-ix,LENGTH(qbf-dx,"RAW":u)).
END.

/* prescan for widest sort field label -dma */
DO qbf-i = 1 TO NUM-ENTRIES(qbf-sortby):
  qbf-cx = ENTRY(1,ENTRY(qbf-i,qbf-sortby)," ":u).

  /* Is sort field part of qbf-rcn field array? */
  DO qbf-j = 1 TO qbf-rc#:
    IF qbf-rcn[qbf-j] = qbf-cx THEN LEAVE.
  END.
  
  IF qbf-j <= qbf-rc# THEN DO:
    IF qbf-rcc[qbf-j] = "" THEN DO:
      RUN alias_to_tbname (qbf-cx,TRUE,OUTPUT realtbl).
      RUN aderes/s-schema.p (realtbl,"","","FIELD:LABEL":u,OUTPUT qbf-dx).
    END.
    ELSE
      qbf-dx = qbf-rcl[qbf-j].
  END.
  ELSE qbf-dx = qbf-cx.
  
  qbf-jx = MAXIMUM(qbf-jx,LENGTH(qbf-dx,"RAW":u)).
END.

/* load up query field selection lists */
DO qbf-i = 1 TO qbf-rc#:
  qbf-cx = ENTRY(1,qbf-rcn[qbf-i]).

  /* skip counters and stacked arrays */ 
  IF CAN-DO("c,e":u,SUBSTRING(qbf-rcc[qbf-i],1,1,"CHARACTER":u)) THEN NEXT.

  IF qbf-rcc[qbf-i] = "" THEN DO:
    RUN alias_to_tbname (qbf-cx,TRUE,OUTPUT realtbl).
    RUN aderes/s-schema.p (realtbl,"","","FIELD:LABEL":u, OUTPUT qbf-dx).
    OVERLAY(qbf-dx,qbf-ix + 2,-1,"RAW":u) = "(":u + qbf-cx + ")":u.
  END.
  ELSE IF qbf-rcc[qbf-i] > "" AND qbf-rcl[qbf-i] <> ? THEN 
    qbf-dx = qbf-rcl[qbf-i].
  ELSE qbf-dx = qbf-cx.

  ASSIGN
    qbf-l        = qbf-q:ADD-LAST(qbf-cx) IN FRAME qbf-tagg
    qbf-l        = qbf-q&:ADD-LAST(qbf-dx) IN FRAME qbf-tagg
    qbf-g[qbf-i] = qbf-rcg[qbf-i].
END.

ASSIGN
  qbf-q                                 = qbf-q:ENTRY(1) IN FRAME qbf-tagg
  qbf-q&                                = qbf-q&:ENTRY(1) IN FRAME qbf-tagg
  qbf-q:SCREEN-VALUE IN FRAME qbf-tagg  = qbf-q:ENTRY(1) IN FRAME qbf-tagg
  qbf-q&:SCREEN-VALUE IN FRAME qbf-tagg = qbf-q&:ENTRY(1) IN FRAME qbf-tagg
  
  &IF "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u &THEN
    /* micro adjustment for MS-Windows - bug 94-07-29-008 */
    qbf-c:Y = qbf-c:Y + 1
    qbf-x:Y = qbf-x:Y + 2
    qbf-n:Y = qbf-n:Y + 3
    qbf-a:Y = qbf-a:Y + 4
  &ENDIF
  .

DISPLAY qbf-q qbf-q& qbf-s qbf-s& qbf-t1 qbf-t2 qbf-t3 
  qbf-toggle1 
  WITH FRAME qbf-tagg.

ENABLE qbf-q qbf-q& qbf-s qbf-s& qbf-t qbf-c qbf-x qbf-n qbf-a qbf-ra
  qbf-toggle1 qbf-ok qbf-ee qbf-help
  WITH FRAME qbf-tagg.

ASSIGN
  qbf-q:VISIBLE  IN FRAME qbf-tagg   = NOT qbf-toggle1
  qbf-q&:VISIBLE IN FRAME qbf-tagg   = qbf-toggle1
  qbf-s:VISIBLE  IN FRAME qbf-tagg   = NOT qbf-toggle1
  qbf-s&:VISIBLE IN FRAME qbf-tagg   = qbf-toggle1

  qbf-q:SENSITIVE IN FRAME qbf-tagg  = TRUE
  qbf-q&:SENSITIVE IN FRAME qbf-tagg = TRUE
  qbf-s:SENSITIVE IN FRAME qbf-tagg  = TRUE
  qbf-s&:SENSITIVE IN FRAME qbf-tagg = TRUE 
  .

RUN fillup.

IF qbf-toggle1 THEN
  APPLY "ENTRY":u TO qbf-q& IN FRAME qbf-tagg.
ELSE
  APPLY "ENTRY":u TO qbf-q IN FRAME qbf-tagg.

RUN update_status.

DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  WAIT-FOR CHOOSE OF qbf-ok IN FRAME qbf-tagg 
    OR SELECTION OF qbf-ee IN FRAME qbf-tagg.
END.

HIDE FRAME qbf-tagg NO-PAUSE.

RETURN.

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

PROCEDURE fillup:
  /* populate sort field selection list */
  DEFINE VARIABLE qbf_l AS CHARACTER NO-UNDO. /* list of calc field tables */
  DEFINE VARIABLE qbf_i AS INTEGER   NO-UNDO. /* scrap */
  DEFINE VARIABLE qbf_q AS INTEGER   NO-UNDO. /* index into query field list */
  DEFINE VARIABLE qbf_k AS INTEGER   NO-UNDO. /* index to qbf-rc[] */
  DEFINE VARIABLE qbf_r AS CHARACTER NO-UNDO. /* query table relationships */
  DEFINE VARIABLE qbf_s AS INTEGER   NO-UNDO. /* sort table ID */
  DEFINE VARIABLE qbf_t AS INTEGER   NO-UNDO. /* table ID */
  DEFINE VARIABLE qbf_v AS INTEGER   NO-UNDO. /* last referenced table ID */
  DEFINE VARIABLE qbf_x AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE old-s AS CHARACTER NO-UNDO. 
  DEFINE VARIABLE fname AS CHARACTER NO-UNDO.

  IF qbf-toggle1 THEN
    ASSIGN
      qbf-j = qbf-s&:LOOKUP(qbf-s&:SCREEN-VALUE) IN FRAME qbf-tagg
      old-s = qbf-s&:LIST-ITEMS IN FRAME qbf-tagg 
      qbf_q = qbf-q&:LOOKUP(qbf-q&:SCREEN-VALUE) IN FRAME qbf-tagg.
  ELSE
    ASSIGN
      qbf-j = qbf-s:LOOKUP(qbf-s:SCREEN-VALUE) IN FRAME qbf-tagg
      old-s = qbf-s:LIST-ITEMS IN FRAME qbf-tagg 
      qbf_q = qbf-q:LOOKUP(qbf-q:SCREEN-VALUE) IN FRAME qbf-tagg.

  /* In case some of the fields (like stacked arrays) aren't in 
     the query field list, map the item chosen to it's index in the
     qbf-rcx arrays.  i.e, the index won't necessarily be the same as qbf_q.
  */
  fname = ENTRY(qbf_q,qbf-q:LIST-ITEMS IN FRAME qbf-tagg,CHR(3)).
							  
  DO qbf_k = 1 TO qbf-rc#:
    IF ENTRY(1,qbf-rcn[qbf_k]) = fname THEN LEAVE.
  END.

  ASSIGN
    qbf-s& = "<<":u + "summary line":t32 + ">>":u 
    qbf-s  = qbf-s&
    qbf_x  = FALSE.

  /*
  IF ENTRY(qbf_q,qbf-q:LIST-ITEMS IN FRAME qbf-tagg,CHR(3)) 
    BEGINS "qbf-":u THEN DO:
  */
  IF qbf-rcc[qbf_k] > "" THEN DO:
    IF NOT CAN-DO("s,d,n,l,r,p":u,
      SUBSTRING(qbf-rcc[qbf_k],1,1,"CHARACTER":u)) THEN 
      qbf_x = TRUE.  /* aggregate on summary only */
    ELSE DO:
      IF CAN-DO("r,p":u,
	SUBSTRING(qbf-rcc[qbf_k],1,1,"CHARACTER":u)) THEN DO:
	RUN alias_to_tbname (ENTRY(2,qbf-rcn[qbf_k]),TRUE,OUTPUT realtbl).
	RUN lookup_table (realtbl,OUTPUT qbf_v).
      END.
      ELSE DO: /* s,d,n,l */
	/* get list of table IDs involved in calculated field */
	DO qbf_i = 2 TO NUM-ENTRIES(qbf-rcc[qbf_k]):
	  RUN alias_to_tbname (ENTRY(qbf_i,qbf-rcc[qbf_k]),TRUE,OUTPUT realtbl).
	  RUN lookup_table (realtbl,OUTPUT qbf_s).
  
	  IF NOT CAN-DO(qbf_l, STRING(qbf_s)) THEN
	    qbf_l = (IF qbf_l > "" THEN qbf_l + ",":u ELSE "") + STRING(qbf_s).
	END.
  
	/* get lowest (i.e., child-most) table ID involved in calc field */
	DO qbf_i = 1 TO NUM-ENTRIES(qbf_l):
	  qbf_v = MAXIMUM(qbf_v,LOOKUP(ENTRY(qbf_i,qbf_l),qbf-tables)). 
	END.

	IF qbf_v > 0 THEN
	  qbf_v = INTEGER(ENTRY(qbf_v,qbf-tables)).
      END.
    END.
  END.

  IF NOT qbf_x THEN DO:
    /* get calculated field table ID */
    /*
    IF ENTRY(qbf_q,qbf-q:LIST-ITEMS IN FRAME qbf-tagg,CHR(3)) 
      BEGINS "qbf-":u 
    */
    IF qbf-rcc[qbf_k] > "" AND qbf_v > 0 THEN 
      qbf_t = qbf_v.

    /* get query field table ID */
    ELSE DO:
      RUN alias_to_tbname 
	(ENTRY(qbf_q,qbf-q:LIST-ITEMS IN FRAME qbf-tagg,CHR(3)),
	 TRUE,OUTPUT realtbl).
      RUN lookup_table (realtbl,OUTPUT qbf_t).
    END.

    IF qbf_t > 0 THEN DO:
      {&FIND_TABLE_BY_ID} qbf_t.
      qbf_r = qbf-rel-buf.rels.
    END.

    /* loop through sections */
    FOR EACH qbf-section WHERE qbf-section.qbf-sout <= ENTRY(1,qbf-rcs[qbf_k])
      WHILE qbf_t > 0
      BY NUM-ENTRIES(qbf-section.qbf-sout,".":u):
      
      DO qbf-i = 1 TO NUM-ENTRIES(qbf-section.qbf-sort):
	qbf-cx = ENTRY(1,ENTRY(qbf-i,qbf-section.qbf-sort)," ":u).
  
	/* Is sort field part of qbf-rcn field array? */
	DO qbf-k = 1 TO qbf-rc#:
	  IF qbf-rcn[qbf-k] = qbf-cx THEN LEAVE.
	END.
  
	/* known database field */
	IF qbf-k <= qbf-rc# AND qbf-rcc[qbf-k] = "" THEN DO:
	  RUN alias_to_tbname (qbf-cx,TRUE,OUTPUT realtbl).
	  RUN lookup_table (realtbl,OUTPUT qbf_s).
  
	  /* Abort if 1:M relation exists between query field and sort field. */
	  IF CAN-DO(qbf_r, "<":u + STRING(qbf_s)) THEN NEXT.
  
	  RUN aderes/s-schema.p (realtbl,"","","FIELD:LABEL":u,OUTPUT qbf-dx).
  
	  OVERLAY(qbf-dx,qbf-jx + 2,-1,"RAW":u) = 
	      "(":u 
	    + SUBSTRING(qbf-cx,INDEX(qbf-cx,".":u) + 1,-1,"CHARACTER":u) 
	    + ")":u.
	END.
	
	/* calculated field */
	ELSE qbf-dx = qbf-cx.
  
	ASSIGN
	  qbf-s& = qbf-s& + CHR(3) + qbf-dx
	  qbf-s  = qbf-s + CHR(3) + qbf-cx.
      END.
    END.
  END. /* NOT qbf_x */

  ASSIGN
    qbf-s:LIST-ITEMS IN FRAME qbf-tagg    = qbf-s
    qbf-s&:LIST-ITEMS IN FRAME qbf-tagg   = qbf-s&
    qbf-s:SCREEN-VALUE IN FRAME qbf-tagg  = ENTRY(1,qbf-s,CHR(3))
    qbf-s&:SCREEN-VALUE IN FRAME qbf-tagg = ENTRY(1,qbf-s&,CHR(3))
   .

  IF qbf-toggle1 THEN DO:
    IF old-s <> qbf-s&:LIST-ITEMS IN FRAME qbf-tagg THEN qbf-j = 1.
    qbf-s& = ENTRY(qbf-j,qbf-s&,CHR(3)).
    DISPLAY qbf-s& WITH FRAME qbf-tagg.
  END.
  ELSE DO:
    IF old-s <> qbf-s:LIST-ITEMS IN FRAME qbf-tagg THEN qbf-j = 1.
    qbf-s = ENTRY(qbf-j,qbf-s,CHR(3)).
    DISPLAY qbf-s WITH FRAME qbf-tagg.
  END.
END PROCEDURE. /* fillup */

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

PROCEDURE value_changed:
  DEFINE INPUT PARAMETER qbf_t AS CHARACTER NO-UNDO. /* type of aggregation */
  DEFINE INPUT PARAMETER qbf_v AS CHARACTER NO-UNDO. /* sort-by value */
  
  DEFINE VARIABLE qbf_p AS INTEGER NO-UNDO. /* position in qbf-rcg[] */
  DEFINE VARIABLE qbf_q AS INTEGER NO-UNDO. /* index into query field list */
  DEFINE VARIABLE qbf_s AS INTEGER NO-UNDO. /* field from sort-by fields */
  DEFINE VARIABLE qbf_k AS INTEGER NO-UNDO. /* index into qbf-rc[] */
  DEFINE VARIABLE fname AS CHARACTER NO-UNDO.
  
  IF qbf-toggle1 THEN
    ASSIGN
      qbf_q = qbf-q&:LOOKUP(qbf-q&:SCREEN-VALUE) IN FRAME qbf-tagg
      qbf_s = qbf-s&:LOOKUP(qbf-s&:SCREEN-VALUE) IN FRAME qbf-tagg - 1.
  ELSE
    ASSIGN
      qbf_q = qbf-q:LOOKUP(qbf-q:SCREEN-VALUE) IN FRAME qbf-tagg
      qbf_s = qbf-s:LOOKUP(qbf-s:SCREEN-VALUE) IN FRAME qbf-tagg - 1.

  /* In case some of the fields (like stacked arrays) aren't in 
     the query field list, map the item chosen to it's index in the
     qbf-rcx arrays.  i.e, the index won't necessarily be the same as qbf_q.
  */
  fname = ENTRY(qbf_q,qbf-q:LIST-ITEMS IN FRAME qbf-tagg,CHR(3)).
  DO qbf_k = 1 TO qbf-rc#:
    IF ENTRY(1,qbf-rcn[qbf_k]) = fname THEN LEAVE.
  END.

  ASSIGN
    qbf_t = qbf_t + STRING(qbf_s)
    qbf_p = INDEX(qbf-g[qbf_k],qbf_t)
    .
  IF qbf_q > 0 AND qbf_s >= 0 THEN DO:
    IF qbf_v = "yes":u AND qbf_p = 0 THEN
      qbf-g[qbf_k] = qbf-g[qbf_k] + qbf_t.
    IF qbf_v <> "yes":u AND qbf_p > 0 THEN
      SUBSTRING(qbf-g[qbf_k],qbf_p,LENGTH(qbf_t,"CHARACTER":u),
		"CHARACTER":u) = "".
  END.
END PROCEDURE. /* value_changed */

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

PROCEDURE update_status:
  DEFINE VARIABLE qbf_q AS INTEGER   NO-UNDO. /* index into query field list */
  DEFINE VARIABLE qbf_k AS INTEGER   NO-UNDO. /* index to qbf-rc[] */
  DEFINE VARIABLE qbf_s AS CHARACTER NO-UNDO.
  DEFINE VARIABLE fname AS CHARACTER NO-UNDO.
 
  IF qbf-toggle1 THEN
    ASSIGN
      qbf-q& = qbf-q&:SCREEN-VALUE IN FRAME qbf-tagg
      qbf_q  = qbf-q&:LOOKUP(qbf-q&) IN FRAME qbf-tagg

      qbf-s& = qbf-s&:SCREEN-VALUE IN FRAME qbf-tagg
      qbf_s  = STRING(qbf-s&:LOOKUP(qbf-s&) IN FRAME qbf-tagg - 1)
      .
  ELSE
    ASSIGN
      qbf-q = qbf-q:SCREEN-VALUE IN FRAME qbf-tagg
      qbf_q = qbf-q:LOOKUP(qbf-q) IN FRAME qbf-tagg

      qbf-s = qbf-s:SCREEN-VALUE IN FRAME qbf-tagg
      qbf_s = STRING(qbf-s:LOOKUP(qbf-s) IN FRAME qbf-tagg - 1)
      .

  /* In case some of the fields (like stacked arrays) aren't in 
     the query field list, map the item chosen to it's index in the
     qbf-rcx arrays.  i.e, the index won't necessarily be the same as qbf_q.
  */
  fname = ENTRY(qbf_q,qbf-q:LIST-ITEMS IN FRAME qbf-tagg,CHR(3)).
  DO qbf_k = 1 TO qbf-rc#:
    IF ENTRY(1,qbf-rcn[qbf_k]) = fname THEN LEAVE.
  END.

  IF qbf_q > 0 AND INTEGER(qbf_s) >= 0 THEN
    ASSIGN
      qbf-t:SENSITIVE IN FRAME qbf-tagg = (qbf-rct[qbf_k] > 3)
      qbf-c:SENSITIVE IN FRAME qbf-tagg = TRUE
      qbf-x:SENSITIVE IN FRAME qbf-tagg = (qbf-rct[qbf_k] <> 3)
      qbf-n:SENSITIVE IN FRAME qbf-tagg = (qbf-rct[qbf_k] <> 3)
      qbf-a:SENSITIVE IN FRAME qbf-tagg = (qbf-rct[qbf_k] > 3)

      qbf-t:SCREEN-VALUE IN FRAME qbf-tagg =
	(IF INDEX(qbf-g[qbf_k],"t":u + qbf_s) > 0 THEN "yes":u ELSE "no":u)
      qbf-c:SCREEN-VALUE IN FRAME qbf-tagg =
	(IF INDEX(qbf-g[qbf_k],"c":u + qbf_s) > 0 THEN "yes":u ELSE "no":u)
      qbf-x:SCREEN-VALUE IN FRAME qbf-tagg =
	(IF INDEX(qbf-g[qbf_k],"x":u + qbf_s) > 0 THEN "yes":u ELSE "no":u)
      qbf-n:SCREEN-VALUE IN FRAME qbf-tagg =
	(IF INDEX(qbf-g[qbf_k],"n":u + qbf_s) > 0 THEN "yes":u ELSE "no":u)
      qbf-a:SCREEN-VALUE IN FRAME qbf-tagg =
	(IF INDEX(qbf-g[qbf_k],"a":u + qbf_s) > 0 THEN "yes":u ELSE "no":u).
  ELSE
    DISABLE qbf-t qbf-c qbf-x qbf-n qbf-a WITH FRAME qbf-tagg.
END PROCEDURE. /* update_status */

/*--------------------------------------------------------------------------*/
/* alias_to_tbname */
{ aderes/s-alias.i }

/*--------------------------------------------------------------------------*/
/* lookup table ID */
{ aderes/p-lookup.i }

/* y-total.p - end of file */

