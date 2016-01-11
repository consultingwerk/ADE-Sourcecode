/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* r-short.p - totals-only (summary) option */

&GLOBAL-DEFINE WIN95-BTN YES

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/j-define.i }
{ aderes/reshlp.i }
{ adecomm/adestds.i }

DEFINE OUTPUT PARAMETER lRet AS LOGICAL NO-UNDO. /* all okay? */

DEFINE VARIABLE qbf-a  AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-c  AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-i  AS INTEGER   NO-UNDO. /* loop */
DEFINE VARIABLE qbf-p  AS INTEGER   NO-UNDO. /* position of "$" in qbf-rcg */
DEFINE VARIABLE qbf-s  AS CHARACTER NO-UNDO. /* selection-list */
DEFINE VARIABLE qbf-v  AS CHARACTER NO-UNDO EXTENT 64. /* old aggregates */

DEFINE VARIABLE info   AS CHARACTER NO-UNDO. /* description editor widget */
DEFINE VARIABLE flsort AS CHARACTER NO-UNDO. /* sort field */
DEFINE VARIABLE tbsort AS CHARACTER NO-UNDO. /* table sort field comes from */
DEFINE VARIABLE idsort AS INTEGER   NO-UNDO. /* tbl id for sort table */
DEFINE VARIABLE maxlen AS INTEGER   NO-UNDO. /* max length of field names */
DEFINE VARIABLE flname AS CHARACTER NO-UNDO. /* field name - For macro */

DEFINE BUTTON qbf-ok   LABEL "OK"            {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON qbf-ee   LABEL "Cancel"        {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON qbf-help LABEL "&Help"         {&STDPH_OKBTN}.
DEFINE BUTTON qbf-da   LABEL "&Deselect All" SIZE 15 BY 1.

/* standard button rectangle */
DEFINE RECTANGLE rect_btns {&STDPH_OKBOX}.

/* transforms "demo.cust.cust-num" to 
      	      "cust-num (demo.cust)" OR "cust-num (cust)" 
*/
&GLOBAL-DEFINE INTERNAL_TO_SCREEN ~
   ENTRY(3,flname,".":u) + ~
   FILL(" ":u, maxlen - LENGTH(ENTRY(3,flname,".":u),"RAW":u) + 1) + "(":u + ~
   (IF qbf-hidedb THEN ENTRY(2,flname,".":u) ELSE ~
    SUBSTRING(flname,1,R-INDEX(flname,".":u) - 1,"RAW":u)) + ")":u

/*--------------------------------------------------------------------------*/

FORM 
  SKIP({&TFM_WID})
  info AT 2 
    VIEW-AS EDITOR SCROLLBAR-V INNER-CHARS 50 INNER-LINES 10
  SKIP({&VM_WIDG})

  qbf-s AT 2 
    VIEW-AS SELECTION-LIST MULTIPLE SCROLLBAR-H SCROLLBAR-V
    INNER-CHARS 50 INNER-LINES 8 FONT 0
  SKIP({&VM_WIDG})

  qbf-da AT 2

  {adecomm/okform.i
    &BOX    = rect_btns
    &STATUS = no
    &OK     = qbf-ok
    &CANCEL = qbf-ee
    &HELP   = qbf-help}

  WITH FRAME qbf-summary NO-ATTR-SPACE NO-LABELS THREE-D
  DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee KEEP-TAB-ORDER 
  TITLE "Totals Only Summary":t32 VIEW-AS DIALOG-BOX.

/* Run time layout for button area.  This defines eff_frame_width */
{adecomm/okrun.i  
   &FRAME = "FRAME qbf-summary" 
   &BOX   = "rect_btns"
   &OK    = "qbf-ok" 
   &HELP  = "qbf-help" }

/*--------------------------------------------------------------------------*/

ON HELP OF FRAME qbf-summary OR CHOOSE OF qbf-help IN FRAME qbf-summary
  RUN adecomm/_adehelp.p ("res":u,"CONTEXT":u, 
                          {&Totals_Only_Summary_Dlg_Box}, ?).

ON DEFAULT-ACTION OF qbf-s IN FRAME qbf-summary
  APPLY "GO":u TO FRAME qbf-summary.

ON GO OF FRAME qbf-summary DO:
  ASSIGN
    qbf-s       = qbf-s:SCREEN-VALUE IN FRAME qbf-summary
    qbf-s       = (IF qbf-s = ? THEN "" ELSE qbf-s)
    qbf-summary = (qbf-s <> "").

  IF qbf-summary THEN DO:
    /* Don't allow user to do totals only summary if there is also
       a master-detail split.
    */
    RUN master_detail_and_totals_only(?, true).
    IF RETURN-VALUE = "error" THEN
      RETURN NO-APPLY.
  END.

  DO qbf-i = 1 TO qbf-rc#:
    flname = ENTRY(1,qbf-rcn[qbf-i]).
    IF qbf-rcc[qbf-i] = "" THEN
      flname = {&INTERNAL_TO_SCREEN}.

    ASSIGN
      qbf-a = CAN-DO(qbf-s, flname)
      qbf-p = INDEX(qbf-rcg[qbf-i],"$":u).

    /*was on  and  is on  -> do nothing*/
    /*was off and  is off -> do nothing*/
    /*was off and  is on  -> turn on*/
    IF qbf-a AND qbf-p = 0 THEN 
      qbf-rcg[qbf-i] = qbf-rcg[qbf-i] + "$":u.
    /*was on  and  is off -> turn off*/
    IF NOT qbf-a AND qbf-p > 0 THEN 
      SUBSTRING(qbf-rcg[qbf-i],qbf-p,1,"CHARACTER":u) = "".

    IF qbf-v[qbf-i] <> qbf-rcg[qbf-i] THEN
      ASSIGN
        lRet       = TRUE
        qbf-dirty  = TRUE 
        qbf-redraw = TRUE.
  END.
END.

ON CHOOSE OF qbf-da IN FRAME qbf-summary
  qbf-s:SCREEN-VALUE IN FRAME qbf-summary = "".

ON WINDOW-CLOSE OF FRAME qbf-summary
  APPLY "END-ERROR":u TO SELF.

/*----------------------------- Mainline Code --------------------------------*/

IF qbf-sortby = "" THEN DO:
  RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u,
    'The "Totals Only Summary" option cannot be used until you choose at least one sort field for your query.^^Select Data->Sort Ordering to specify a sort field.').
  RETURN.
END.

ASSIGN
  flsort = ENTRY(NUM-ENTRIES(qbf-sortby),qbf-sortby)
  tbsort = SUBSTRING(flsort,1,R-INDEX(flsort, ".":u) - 1,"CHARACTER":u)
  info:WIDTH IN FRAME qbf-summary     = qbf-s:WIDTH IN FRAME qbf-summary
  info:READ-ONLY IN FRAME qbf-summary = TRUE
  info:SCREEN-VALUE = SUBSTITUTE("Defining a Totals Only Summary collapses the query output to show only summary information.  The summary group is based on the last field in your Sort list, which in this case is &1.  A new line of output will be generated each time that field value changes." 
                    + CHR(10) + CHR(10) 
                    + "The selected numeric fields will be totalled within each summary group.  Deselecting all fields causes this to revert to a regular query.", flsort).
RUN lookup_table (tbsort, OUTPUT idsort).

/* Fill the selection list. Only add integer and decimal fields and only
   add fields that belong to tables which are at or below the table that
   the sort field belongs to.  First find maximum length of field names.
*/
maxlen = 0.
DO qbf-i = 1 TO qbf-rc#:
  RUN include_field(qbf-i).
  IF RETURN-VALUE = "no":u THEN NEXT.

  ASSIGN
    flname = ENTRY(1,qbf-rcn[qbf-i])
    maxlen = (IF qbf-rcc[qbf-i] = "" 
      	       	 THEN MAXIMUM(maxlen, LENGTH(ENTRY(3,flname,".":u),"RAW":u))
      	       	 ELSE MAXIMUM(maxlen, LENGTH(flname,"RAW":u))).
END.
qbf-s = "".

DO qbf-i = 1 TO qbf-rc#:
  /* load up initial aggregate values -dma */
  qbf-v[qbf-i] = qbf-rcg[qbf-i].
  
  RUN include_field (qbf-i).
  IF RETURN-VALUE = "no" THEN NEXT.

  /* qbf-s will be current set of Totals Only Summary fields to
     set initial selection.  */
  flname = ENTRY(1,qbf-rcn[qbf-i]).
  
  IF qbf-rcc[qbf-i] = "" THEN
    flname = {&INTERNAL_TO_SCREEN}.
    
  IF INDEX(qbf-rcg[qbf-i],"$":u) > 0 THEN
    qbf-s = qbf-s + (IF qbf-s = "" THEN "" ELSE ",":u) + flname.

  qbf-a = qbf-s:ADD-LAST(flname) IN FRAME qbf-summary.
END.

/* Highlight existing Totals Only Summary fields */
qbf-s:SCREEN-VALUE = qbf-s.

ENABLE info qbf-s qbf-da qbf-ok qbf-ee qbf-help 
  WITH FRAME qbf-summary.

IF qbf-s:NUM-ITEMS IN FRAME qbf-summary = 0 THEN
  RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"information":u,"ok":u,
    SUBSTITUTE("Note: there are no numeric fields chosen that belong to &1 or any of its related tables.  Therefore, there are no appropriate fields for a Totals Only Summary.",
    tbsort)).

DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  WAIT-FOR GO OF FRAME qbf-summary FOCUS qbf-s IN FRAME qbf-summary.
END.

HIDE MESSAGE NO-PAUSE.
HIDE FRAME qbf-summary NO-PAUSE.

RETURN.

/*------------------------------------------------------------------*/

/* Procedure lookup_table */
{ aderes/p-lookup.i }

/* Procedure master_detail_and_totals_only */
{ aderes/restrict.i }

/*------------------------------------------------------------------*/

/* Determine if field should be included in set of choices for a 
   Totals Only Summary.   Only integer and decimal fields are appropriate
   and the field must belong to a table which is at or below the table that
   the sort field belongs to.

   Return "Yes" to include or "no".
*/
PROCEDURE include_field:
  DEFINE INPUT PARAMETER ix AS INTEGER NO-UNDO. /* index into qbf-rcn */

  DEFINE VARIABLE tbl  AS CHARACTER NO-UNDO.  /* table name (db.tbl) */
  DEFINE VARIABLE tbid AS INTEGER   NO-UNDO.  /* tbl id of tbl */
  DEFINE VARIABLE fx   AS INTEGER   NO-UNDO.  /* index into calc fld list */

  IF (qbf-rct[ix] <> 4 AND qbf-rct[ix] <> 5) THEN 
    RETURN "no":u.
  IF CAN-DO("r,p,c,e":u, SUBSTRING(qbf-rcc[ix],1,1,"CHARACTER":u)) THEN
    RETURN "no":u.

  flname = ENTRY(1,qbf-rcn[ix]).
  IF CAN-DO("s,d,n,l":u, SUBSTRING(qbf-rcc[ix],1,1,"CHARACTER":u)) THEN 
    /* Calculated field - if any of the fields involved are from
       an appropriate table, include the field.
    */
    DO fx = 2 TO NUM-ENTRIES(qbf-rcc[ix]):
      flname = ENTRY(fx,qbf-rcc[ix]).
      tbl = SUBSTRING(flname,1,R-INDEX(flname,".":u) - 1,"CHARACTER":u).
      RUN lookup_table (tbl, OUTPUT tbid).
      IF LOOKUP(STRING(tbid),qbf-tables) >=
         LOOKUP(STRING(idsort),qbf-tables) THEN RETURN "yes":u.
    END.
  ELSE DO:
    IF qbf-rcc[ix] = "" THEN 
      tbl = SUBSTRING(flname,1,R-INDEX(flname, ".") - 1,"CHARACTER":u). 
    ELSE /* lookup field */
      tbl = ENTRY(2, qbf-rcn[ix]).
    RUN lookup_table (tbl, OUTPUT tbid).
    IF LOOKUP(STRING(tbid),qbf-tables) >=
       LOOKUP(STRING(idsort),qbf-tables) THEN RETURN "yes":u.
  END.
  RETURN "no":u.
END PROCEDURE.

/* r-short.p - end of file */

