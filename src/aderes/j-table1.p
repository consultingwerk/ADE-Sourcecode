/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * j-table1.p  - table picker

   qbf-t       - '*' or table list
   qbf-showtgl - 
   qbf-o       - table ID
 */

&GLOBAL-DEFINE WIN95-BTN YES

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/j-define.i }
{ adecomm/adestds.i }
{ aderes/reshlp.i }

DEFINE INPUT        PARAMETER qbf-t       AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER qbf-showtgl AS LOGICAL   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER qbf-o       AS INTEGER   NO-UNDO.

DEFINE VARIABLE qbf-b   AS LOGICAL     NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-c   AS CHARACTER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-i   AS INTEGER     NO-UNDO. /* loop */
DEFINE VARIABLE qbf-a   AS CHARACTER   NO-UNDO. /* selection-list names */
DEFINE VARIABLE qbf-a&  AS CHARACTER   NO-UNDO. /* selection-list descs */
DEFINE VARIABLE max_len AS INTEGER     NO-UNDO. /* max length of table names */
DEFINE VARIABLE tbname  AS CHARACTER   NO-UNDO. /* For macro */
DEFINE VARIABLE qbf-val AS CHARACTER   NO-UNDO. /* sel list value- for macro */
DEFINE VARIABLE lst-ix  AS INTEGER     NO-UNDO INIT 1. /* previous selection */

/* transforms "demo.cust" to "cust (demo)" OR "cust" */
&GLOBAL-DEFINE INTERNAL_TO_SCREEN ~
   ENTRY(2,tbname,".") + ~
   (IF qbf-hidedb THEN "" ELSE ~
      FILL(" ", max_len - LENGTH(ENTRY(2,tbname,".":u),"RAW":u) + 1) + ~
      " (" + ENTRY(1,tbname,".") + ")")

/* transforms "cust (demo)" to "demo.cust" OR "cust" to "demo.cust" */
&GLOBAL-DEFINE SCREEN_TO_INTERNAL ~
   (IF qbf-hidedb THEN LDBNAME(1) + ".":u + qbf-val ELSE ~
     TRIM(ENTRY(2, qbf-val, "("), ")") + "." + TRIM(ENTRY(1, qbf-val, "(")))

/*--------------------------------------------------------------------------*/

DEFINE BUTTON qbf-ok   LABEL "OK"     {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON qbf-ee   LABEL "Cancel" {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON qbf-Help LABEL "&Help"  {&STDPH_OKBTN}.
/* standard button rectangle */
DEFINE RECTANGLE rect_btns {&STDPH_OKBOX}.

FORM
  SKIP({&TFM_WID})
  qbf-a& AT 2
    VIEW-AS SELECTION-LIST SINGLE INNER-CHARS 40 INNER-LINES 10
    SCROLLBAR-H SCROLLBAR-V FONT 0

  qbf-a AT ROW-OF qbf-a& COL-OF qbf-a& 
    VIEW-AS SELECTION-LIST SINGLE INNER-CHARS 40 INNER-LINES 10 
    SCROLLBAR-H SCROLLBAR-V FONT 0
  SKIP({&VM_WID})

  qbf-toggle2 AT 2 LABEL "Show Table &Descriptions":t40
    VIEW-AS TOGGLE-BOX
  SKIP({&VM_WID})

  {adecomm/okform.i
    &BOX    = rect_btns
    &STATUS = no
    &OK     = qbf-ok
    &CANCEL = qbf-ee
    &HELP   = qbf-help}

  WITH FRAME qbf-tbl NO-LABELS THREE-D
  DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee KEEP-TAB-ORDER
  TITLE "Available Tables":t32 VIEW-AS DIALOG-BOX.

/*--------------------------------------------------------------------------*/

ON HELP OF FRAME qbf-tbl OR CHOOSE OF qbf-help IN FRAME qbf-tbl
  RUN adecomm/_adehelp.p ("res":u,"CONTEXT":u,{&Available_Tables_Dlg_Box},?).

ON GO OF FRAME qbf-tbl DO:
  RUN adecomm/_setcurs.p ("WAIT":u).
  qbf-val = qbf-a:ENTRY(lst-ix) IN FRAME qbf-tbl.
  qbf-val = {&SCREEN_TO_INTERNAL}.
  RUN lookup_table (qbf-val, OUTPUT qbf-o).
END.

ON DEFAULT-ACTION OF qbf-a, qbf-a& IN FRAME qbf-tbl
  APPLY "GO":u TO FRAME qbf-tbl.

ON VALUE-CHANGED OF qbf-a, qbf-a& IN FRAME qbf-tbl 
  lst-ix = SELF:LOOKUP(SELF:SCREEN-VALUE) IN FRAME qbf-tbl.

ON VALUE-CHANGED OF qbf-toggle2 IN FRAME qbf-tbl DO:
  DEFINE VAR widg AS HANDLE NO-UNDO.

  ASSIGN
    qbf-toggle2                     = INPUT FRAME qbf-tbl qbf-toggle2
    qbf-a:VISIBLE  IN FRAME qbf-tbl = NOT qbf-toggle2
    qbf-a&:VISIBLE IN FRAME qbf-tbl = qbf-toggle2.

  IF qbf-toggle2 THEN 
    ASSIGN
      qbf-a&:SCREEN-VALUE IN FRAME qbf-tbl =
      	    qbf-a&:ENTRY(lst-ix) IN FRAME qbf-tbl
      widg = qbf-a&:HANDLE IN FRAME qbf-tbl.
  ELSE 
    ASSIGN
      qbf-a:SCREEN-VALUE IN FRAME qbf-tbl  =  
            qbf-a:ENTRY(lst-ix) IN FRAME qbf-tbl
      widg = qbf-a:HANDLE IN FRAME qbf-tbl.

  RUN adecomm/_scroll.p (widg, widg:SCREEN-VALUE).
END.

ON WINDOW-CLOSE OF FRAME qbf-tbl
  APPLY "END-ERROR":u TO SELF.             

/*--------------------------------------------------------------------------*/

RUN adecomm/_setcurs.p ("WAIT":u).

/* Run time layout for button area.  This defines eff_frame_width */
{adecomm/okrun.i  
  &FRAME = "FRAME qbf-tbl" 
  &BOX   = "rect_Btns"
  &OK    = "qbf-OK" 
  &HELP  = "qbf-Help"}

DO ON ERROR UNDO, LEAVE:
  ASSIGN
    qbf-a:DELIMITER IN FRAME qbf-tbl  = CHR(3)
    qbf-a&:DELIMITER IN FRAME qbf-tbl = CHR(3).

  /* Create temp table with table descriptions and fill select lists. */
  max_len = 0.
  IF qbf-t = "*":u THEN DO: /* ALL tables */
    IF NOT qbf-hidedb THEN
      FOR EACH qbf-rel-buf WHERE qbf-rel-buf.cansee USE-INDEX tnameix:
	max_len = MAXIMUM(max_len,
                    LENGTH(ENTRY(2,qbf-rel-buf.tname,".":u),"RAW":u)).
      END.
    FOR EACH qbf-rel-buf WHERE qbf-rel-buf.cansee USE-INDEX tnameix:
      IF qbf-rel-buf.tdesc = "" THEN DO:
      	{ aderes/getdesc.i }
      END.

      RUN fill_table_data.
    END.
  END.
  ELSE DO:
    /* If descriptions aren't set yet in qbf-rel-tt, then do it now for all
       tables - so j-table2 doesn't have a problem later.
    */
    FIND FIRST qbf-rel-buf WHERE qbf-rel-buf.cansee USE-INDEX tnameix.
    IF qbf-rel-buf.tdesc = "" THEN 
      FOR EACH qbf-rel-buf WHERE qbf-rel-buf.cansee USE-INDEX tnameix:
        { aderes/getdesc.i }
      END.

    IF NOT qbf-hidedb THEN
      DO qbf-i = 1 TO NUM-ENTRIES(qbf-t):
	{&FIND_TABLE_BY_ID} INTEGER(ENTRY(qbf-i,qbf-t)).
	max_len = MAXIMUM(max_len,
                    LENGTH(ENTRY(2,qbf-rel-buf.tname,".":u),"RAW":u)).
      END.

    DO qbf-i = 1 TO NUM-ENTRIES(qbf-t):
      {&FIND_TABLE_BY_ID} INTEGER(ENTRY(qbf-i,qbf-t)).

      RUN fill_table_data.
    END.
  END.
  
  IF qbf-o <> 0 THEN DO:
    {&FIND_TABLE_BY_ID} qbf-o.
    ASSIGN
      tbname = qbf-rel-buf.tname
      qbf-a  = {&INTERNAL_TO_SCREEN}
      qbf-a& = qbf-rel-buf.tdesc
      lst-ix = qbf-a:LOOKUP(qbf-a) IN FRAME qbf-tbl.
  END.
  ELSE 
    ASSIGN
      qbf-a  = qbf-a:ENTRY(1) IN FRAME qbf-tbl
      qbf-a& = qbf-a&:ENTRY(1) IN FRAME qbf-tbl
      lst-ix = 1.
 
  ASSIGN 
    qbf-a:SCREEN-VALUE IN FRAME qbf-tbl = qbf-a
    qbf-a&:SCREEN-VALUE IN FRAME qbf-tbl = qbf-a&.

  RUN adecomm/_scroll.p (qbf-a:HANDLE IN FRAME qbf-tbl, qbf-a).   
  RUN adecomm/_scroll.p (qbf-a&:HANDLE IN FRAME qbf-tbl, qbf-a&).   
  
END. /* end do on error block */

RUN adecomm/_setcurs.p ("").

DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
  qbf-o = 0.
  IF qbf-showtgl THEN 
    DISPLAY qbf-toggle2 WITH FRAME qbf-tbl.
  ELSE 
    qbf-toggle2:VISIBLE IN FRAME qbf-tbl = no.

  ASSIGN
    qbf-a:SENSITIVE IN FRAME qbf-tbl  = TRUE
    qbf-a:VISIBLE IN FRAME qbf-tbl    = NOT qbf-toggle2
    qbf-a&:SENSITIVE IN FRAME qbf-tbl = TRUE
    qbf-a&:VISIBLE IN FRAME qbf-tbl   = qbf-toggle2
    .

  ENABLE
    qbf-toggle2 WHEN qbf-showtgl
    qbf-ok qbf-ee qbf-help 
    WITH FRAME qbf-tbl.

  IF qbf-toggle2 THEN
    APPLY "ENTRY":u TO qbf-a& IN FRAME qbf-tbl.
  ELSE
    APPLY "ENTRY":u TO qbf-a IN FRAME qbf-tbl.

  WAIT-FOR CHOOSE OF qbf-ok IN FRAME qbf-tbl OR GO OF FRAME qbf-tbl.
END.

HIDE FRAME qbf-tbl NO-PAUSE.
RETURN.

/*--------------------------------------------------------------------------*/
PROCEDURE fill_table_data:

  tbname = qbf-rel-buf.tname.
  tbname = {&INTERNAL_TO_SCREEN}.
      	  
  ASSIGN
    qbf-b = qbf-a:ADD-LAST(tbname) IN FRAME qbf-tbl
    qbf-b = qbf-a&:ADD-LAST(qbf-rel-buf.tdesc) IN FRAME qbf-tbl.
END. /* fill_table_data */

/*--------------------------------------------------------------------------*/
/* alias_to_tbname */
{ aderes/s-alias.i }

/*--------------------------------------------------------------------------*/
/* sub-proc to lookup table reference in relationship table */
{ aderes/p-lookup.i }

/* j-table1.p - end of file */

