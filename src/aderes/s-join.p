/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * s-join.p - optional/required join settings (outer/inner joins)
 */

&GLOBAL-DEFINE WIN95-BTN YES

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/r-define.i }
{ aderes/j-define.i }
{ adecomm/adestds.i }
{ aderes/reshlp.i }

DEFINE OUTPUT PARAMETER qbf-o AS LOGICAL INITIAL FALSE NO-UNDO. /* all ok? */

DEFINE VARIABLE qbf-a  AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-c  AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-i  AS INTEGER   NO-UNDO. /* loop */
DEFINE VARIABLE qbf-k  AS INTEGER   NO-UNDO. /* loop */
DEFINE VARIABLE qbf-j  AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-s  AS CHARACTER NO-UNDO. /* selection-list */
DEFINE VARIABLE qbf-t  AS CHARACTER NO-UNDO. /* sort field list */
DEFINE VARIABLE qbf-v  AS CHARACTER NO-UNDO. /* original list value */
DEFINE VARIABLE tbl-1  AS CHARACTER NO-UNDO INIT "". /* tbl-1 name */
DEFINE VARIABLE tbl-2  AS CHARACTER NO-UNDO INIT "". /* tbl-2 name */
DEFINE VARIABLE join-child  AS CHARACTER NO-UNDO.
DEFINE VARIABLE join-parent AS CHARACTER NO-UNDO.

DEFINE IMAGE i_inner FILENAME "adeicon/y-inner".
DEFINE IMAGE i_outer FILENAME "adeicon/y-outer".

DEFINE BUTTON qbf-ok   LABEL "OK"     {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON qbf-ee   LABEL "Cancel" {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON qbf-Help LABEL "&Help"  {&STDPH_OKBTN}.

/* standard button rectangle */
DEFINE RECTANGLE rect_btns {&STDPH_OKBOX}.

DEFINE VARIABLE i-ex AS CHARACTER NO-UNDO 
   INITIAL "For Example:" FORMAT "X(14)".
DEFINE VARIABLE o-ex AS CHARACTER NO-UNDO 
   INITIAL "For Example:" FORMAT "X(14)".

/* inner join description */
DEFINE VARIABLE itext1 AS CHARACTER
     INITIAL "&1 records are retrieved only if they have related &2s."
     VIEW-AS EDITOR
     SIZE 30 BY 3 NO-BOX  NO-UNDO.

/* outer join description */
DEFINE VARIABLE otext1 LIKE itext1
    INITIAL "&1 records are retrieved whether or not they have related &2s.".

FORM
  SKIP({&TFM_WID})
  "Partial:" VIEW-AS TEXT AT 2 
  SKIP({&VM_WID})

  "table 1" VIEW-AS TEXT AT 4 
  i-ex VIEW-AS TEXT
  SKIP
 
  i_inner AT 4
  SKIP
 
  "table 2" VIEW-AS TEXT AT 6 
  SKIP({&VM_WIDG}) 

  "Complete:" VIEW-AS TEXT AT 2 
  SKIP({&VM_WID})
  
  "table 1" VIEW-AS TEXT AT 4 
  o-ex VIEW-AS TEXT 
  SKIP
 
  i_outer AT 4
  SKIP
 
  "table 2" VIEW-AS TEXT AT 6 
  SKIP({&VM_WIDG})

  "Select the ~"Complete~" Relationships:":t45 AT 2 
    VIEW-AS TEXT 
  SKIP({&VM_WID}) 

  qbf-s AT 2
    VIEW-AS SELECTION-LIST MULTIPLE INNER-CHARS 45 INNER-LINES 7
    SCROLLBAR-V SCROLLBAR-H NO-DRAG
  SKIP({&VM_WID})

  {adecomm/okform.i
     &BOX    = rect_btns
     &STATUS = no
     &OK     = qbf-ok
     &CANCEL = qbf-ee
     &HELP   = qbf-help }

  itext1 AT ROW 1 COL 1
  otext1 AT ROW 1 COL 1

  WITH FRAME qbf%join NO-ATTR-SPACE NO-LABELS THREE-D
  DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee
  TITLE "Relationship Types":t32 VIEW-AS DIALOG-BOX.

/*===============================Triggers=================================*/

ON HELP OF FRAME qbf%join OR CHOOSE OF qbf-help IN FRAME qbf%join
  RUN adecomm/_adehelp.p ("res":u,"CONTEXT":u,{&Outer_Joins_Dlg_Box},?).

ON DEFAULT-ACTION OF qbf-s IN FRAME qbf%join
  APPLY "GO":u TO FRAME qbf%join.

ON GO OF FRAME qbf%join
  qbf-s = qbf-s:SCREEN-VALUE IN FRAME qbf%join.

ON WINDOW-CLOSE OF FRAME qbf%join OR CHOOSE OF qbf-ee IN FRAME qbf%join DO:
  qbf-o = FALSE.
  APPLY "END-ERROR":u TO SELF.
END.

ON ENTRY OF itext1 IN FRAME qbf%join
DO:
  RETURN NO-APPLY.
END.

ON ENTRY OF otext1 IN FRAME qbf%join
DO:
  RETURN NO-APPLY.
END.

/*============================Mainline Code==============================*/

IF NUM-ENTRIES(qbf-tables) < 2 THEN DO:
  RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a, "error":u, "ok":u,
    "You must have at least two tables selected to use this option.").
  RETURN.
END.

/* Run time layout for button area.  This defines eff_frame_width */
{adecomm/okrun.i  
   &FRAME = "FRAME qbf%join" 
   &BOX   = "rect_btns"
   &OK    = "qbf-ok" 
   &HELP  = "qbf-help" }

ASSIGN
  itext1:X = i_inner:X IN FRAME qbf%join + 
             i_inner:WIDTH-PIXELS IN FRAME qbf%join + 8
  otext1:X = itext1:X IN FRAME qbf%join
  i-ex:X   = itext1:X IN FRAME qbf%join
  o-ex:X   = itext1:X IN FRAME qbf%join
  
  itext1:Y = i-ex:Y IN FRAME qbf%join + 
             i-ex:HEIGHT-PIXELS IN FRAME qbf%join
  otext1:Y = o-ex:Y IN FRAME qbf%join +
             o-ex:HEIGHT-PIXELS IN FRAME qbf%join
  /*FRAME qbf%join:THREE-D = SESSION:THREE-D*/
  .

/* This fills the selection list and indirectly sets qbf-v (the initial 
   selected items) and qbf-c (the first select list entry) by calling
   add_to_selected.  */
qbf-c = "".
RUN join_pairs (ENTRY(1, qbf-tables), qbf-s:HANDLE IN FRAME qbf%join,
                "add_to_selected").

/* Customize inner/outer join descriptions with real table names. 
   Format of qbf-c is: between "[db].table" and "[db].table" */
ASSIGN
  /* remove last quote */
  qbf-c  = SUBSTRING(qbf-c,1,LENGTH(qbf-c,"CHARACTER":u) - 1,"CHARACTER":u)

  qbf-j  = INDEX(qbf-c, (IF qbf-hidedb THEN '"' ELSE '.'))
  qbf-k  = INDEX(qbf-c, '" and')

  /* table name */
  tbl-1   = SUBSTRING(qbf-c,qbf-j + 1,qbf-k - qbf-j - 1,"CHARACTER":u) 

  qbf-j   = R-INDEX(qbf-c, (IF qbf-hidedb THEN '"' ELSE '.'))
  tbl-2   = SUBSTRING(qbf-c,qbf-j + 1,LENGTH(qbf-c,"CHARACTER":u) - qbf-j,
                     "CHARACTER":u)
  itext1  = SUBSTITUTE(itext1, tbl-1, tbl-2)
  otext1  = SUBSTITUTE(otext1, tbl-1, tbl-2)
  qbf-s   = qbf-v
  qbf-s:SCREEN-VALUE IN FRAME qbf%join = qbf-s
  .

/* moved above to avoid setting 3D after dialog has been realized 
/* Run time layout for button area.  This defines eff_frame_width */
{adecomm/okrun.i  
   &FRAME = "FRAME qbf%join" 
   &BOX   = "rect_btns"
   &OK    = "qbf-ok" 
   &HELP  = "qbf-help" }
*/

DISPLAY 
  i-ex itext1 o-ex otext1
  WITH FRAME qbf%join.

ENABLE qbf-s qbf-ok qbf-ee qbf-help itext1 otext1 WITH FRAME qbf%join.

DO TRANSACTION ON ERROR UNDO, RETRY ON ENDKEY UNDO, LEAVE:
  WAIT-FOR GO OF FRAME qbf%join FOCUS qbf-s IN FRAME qbf%join.

  qbf-o = (qbf-s <> qbf-v). /* value changed? */

  /* now do fixup for join settings... */
  IF qbf-o THEN DO:
    FOR EACH qbf-where: qbf-where.qbf-wojo = FALSE. END.
    
    qbf-t = REPLACE(qbf-sortby," DESC":u,"").

    DO qbf-i = 1 TO NUM-ENTRIES(qbf-s):
      /* Between "file-1" and "file-2" */
      /* 11111111 222222 33333 444444  */
      ASSIGN
        join-parent = ENTRY(2, ENTRY(qbf-i, qbf-s), '"':u)
        join-child  = ENTRY(4, ENTRY(qbf-i, qbf-s), '"':u).
      
      RUN lookup_table (join-parent, OUTPUT qbf-j).
      RUN lookup_table (join-child, OUTPUT qbf-k).

      FIND FIRST qbf-where WHERE 
        qbf-where.qbf-wtbl = qbf-k AND qbf-where.qbf-wrid = STRING(qbf-j).
      qbf-where.qbf-wojo = TRUE.

      /* Any parent aggregates on child sort fields? */
      DO qbf-j = 1 TO qbf-rc#:
        IF qbf-rcc[qbf-j] > ""
          OR qbf-rcg[qbf-j] = "" 
          OR qbf-rcg[qbf-j] = "&" THEN NEXT.
        
        IF ENTRY(2, ENTRY(1, qbf-rcn[qbf-j]), ".":u) = join-parent THEN DO:
          RUN agg_check (qbf-i, qbf-j, OUTPUT qbf-a).
          IF qbf-a THEN UNDO, RETRY.
        END.
      END.
    END.
  END.
END.

HIDE FRAME qbf%join NO-PAUSE.
RETURN.					  

/*=======================Internal Procedures==============================*/

/* This is called by join_pairs for each item added to the selection list.
   This will add to the list of select list items that will be selected 
   initially based on which join pairs are currently outer joins.

   Input Parameters:
      p_tbl      - table id of base table (parent)
      p_join_tbl - join table id for p_tbl.
      p_lst_item - list item string
*/
PROCEDURE add_to_selected:
  DEFINE INPUT PARAMETER p_tbl      AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p_join_tbl AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p_lst_item AS CHARACTER NO-UNDO.

  IF qbf-c = "" THEN qbf-c = p_lst_item. /* remember the first one */

  FIND qbf-where WHERE
    qbf-where.qbf-wojo AND
    qbf-where.qbf-wtbl = INTEGER(p_join_tbl) AND
    qbf-where.qbf-wrid = p_tbl NO-ERROR.
  IF AVAILABLE qbf-where THEN
    qbf-v = qbf-v + (IF qbf-v = "" THEN "" ELSE ",":u) + p_lst_item.
END.

/*-----------------------------------------------------------------------*/

PROCEDURE agg_check:
  DEFINE INPUT  PARAMETER qbf-i AS INTEGER NO-UNDO. /* index to join list */
  DEFINE INPUT  PARAMETER qbf-j AS INTEGER NO-UNDO. /* index to field */
  DEFINE OUTPUT PARAMETER qbf-l AS LOGICAL NO-UNDO. /* error found */
  
  DEFINE VARIABLE position   AS INTEGER   NO-UNDO.
  DEFINE VARIABLE agg-char   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE token      AS CHARACTER NO-UNDO. /* index to qbf-sortby */
  DEFINE VARIABLE sort-child AS CHARACTER NO-UNDO.

  /* parse rcg, could be something like t1$a5 */
  DO position = 1 TO LENGTH(qbf-rcg[qbf-j],"CHARACTER":u):
    agg-char = SUBSTRING(qbf-rcg[qbf-j],position,1,"CHARACTER":u).

    IF CAN-DO("a,n,x,c,t,$":u,agg-char) THEN DO:
      token = SUBSTRING(qbf-rcg[qbf-j],position + 1,1,"CHARACTER":u).
      IF token = "0" THEN NEXT.
      
      sort-child = ENTRY(2, ENTRY(INTEGER(token), qbf-t),".":u).
      
      IF sort-child = join-child THEN DO:
        qbf-l = TRUE.

        RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a, "error":u, "ok":u,
          SUBSTITUTE("The parent table &1 contains one or more aggregates based on a child table &2 sort field.  Setting the relationship type^^ENTRY(qbf-i, qbf-s)^^will invalidate the aggregate(s).  Clear any aggregates on the parent table and reselect this option.",
          join-parent, join-child)).
          
        LEAVE.
      END.
    END.
  END. 
END.

/*-----------------------------------------------------------------------*/

/* lookup_table */
{ aderes/p-lookup.i }

/* join_pairs */
{ aderes/j-pairs.i }

/* s-join.p - end of file */


