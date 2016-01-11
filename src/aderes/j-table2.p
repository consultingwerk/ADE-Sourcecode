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
/*
 * j-table2.p - side-by-side table picker

   ****NOTE**** 
   Large portions of this code are commented out.  We used to have
   more robust (fancy) join support and we reverted back to a simpler
   scheme.  There are comments throughout explaining what we used
   to do and what we do now.  We don't want to lose this code
   because it would be hard to redo if we ever put this functionality
   back.
   
   Fancy join support re-installed by Laura Stern -dma 
   ************
*/

&GLOBAL-DEFINE WIN95-BTN YES

{ aderes/s-system.i }
{ aderes/j-define.i }
{ adecomm/adestds.i }
{ aderes/reshlp.i }

/*    Available Tables                  Selected Tables
+------------------------------+ +------------------------------+
| agedar (demo)              | | | item (demo)                | |
| customer (demo)            | | | order-line (demo)          | | +--------+
| monthly (demo)             | | | salesrep (demo)            | | | Remove |
| order (demo)               | | | state (demo)               | | +--------+
| shipping (demo)            | | |                            | | +--------+
| syscontrol (demo)          | | |                            | | |   OK   |
|                            | | |                            | | +--------+
|                            | | |                            | | +--------+
|                            | | |                            | | | Cancel |
+------------------------------+ +------------------------------+ +--------+
*/

DEFINE INPUT-OUTPUT PARAMETER qbf-t   AS CHARACTER NO-UNDO. /* table list */
DEFINE OUTPUT       PARAMETER qbf-chg AS LOGICAL   NO-UNDO. /* ok? */

DEFINE VARIABLE qbf-c        AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-l        AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-m        AS LOGICAL   NO-UNDO. /* true=avail,false=select */
DEFINE VARIABLE qbf-o        AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-val      AS CHARACTER NO-UNDO. /* screen value (for macro) */
DEFINE VARIABLE qbf-ix       AS INTEGER   NO-UNDO. /* index (for macro) */
DEFINE VARIABLE qbf-jp       AS CHARACTER NO-UNDO. /* list of join possibilities */
DEFINE VARIABLE max_len      AS INTEGER   NO-UNDO. /* max length of table names */
DEFINE VARIABLE qbf-tnam     AS CHARACTER NO-UNDO. /* table name (for macro) */
DEFINE VARIABLE changeChoice AS LOGICAL   NO-UNDO INITIAL FALSE.

/* transforms "demo.cust" to "cust (demo)" OR "cust" */
&GLOBAL-DEFINE INTERNAL_TO_SCREEN ~
   ENTRY(2,qbf-tnam,".") + ~
   (IF qbf-hidedb THEN "" ELSE ~
      FILL(" ", max_len - LENGTH(ENTRY(2,qbf-tnam,"."),"RAW":u) + 1) + ~
      " (" + ENTRY(1,qbf-tnam,".") + ")")

/* transforms "cust (demo)" to "demo.cust" OR "cust" to "demo.cust" */
&GLOBAL-DEFINE SCREEN_TO_INTERNAL ~
   (IF qbf-hidedb THEN LDBNAME(1) + ".":u + qbf-val ELSE ~
     TRIM(ENTRY(2, qbf-val, "("), ")") + "." + TRIM(ENTRY(1, qbf-val, "(")))

/* transforms "desc" to "desc (demo)" OR "desc" */
&GLOBAL-DEFINE DESC_INTERNAL_TO_SCREEN ~
   qbf-rel-buf.tdesc + (IF qbf-hidedb THEN "" ~
      ELSE " (":u + ENTRY(1,qbf-tnam,".":u) + ")":u)

/* transforms "order (demo) FOR customer" to "order (demo)" */
&GLOBAL-DEFINE SCREEN_WO_FOR ~
   qbf-ix = INDEX(qbf-val, " FOR "). ~
   IF qbf-ix > 0 THEN qbf-val = SUBSTRING(qbf-val,1,qbf-ix - 1,"CHARACTER":u).

/*================Frame Layout (Variables & Form)========================*/

DEFINE VARIABLE qbf-a  AS CHARACTER NO-UNDO. /* "available tables" sellist */
DEFINE VARIABLE qbf-s  AS CHARACTER NO-UNDO. /* "selected tables" sellist */
DEFINE VARIABLE qbf-a& AS CHARACTER NO-UNDO. /* "available tables" descs */
DEFINE VARIABLE qbf-s& AS CHARACTER NO-UNDO. /* "selected tables" descs */
DEFINE VARIABLE qbf-a% AS CHARACTER NO-UNDO. /* "available tables" tbllist */
DEFINE VARIABLE qbf-s% AS CHARACTER NO-UNDO. /* "selected tables" tbllist */
DEFINE VARIABLE qbf-aa AS CHARACTER NO-UNDO. /* "available tables" label */
DEFINE VARIABLE qbf-ss AS CHARACTER NO-UNDO. /* "selected tables" label */
DEFINE VARIABLE cnt    AS INTEGER   NO-UNDO.

DEFINE BUTTON qbf-ad   LABEL "&Add >>"    SIZE 12 BY 1.
DEFINE BUTTON qbf-rm   LABEL "<< &Remove" SIZE 12 BY 1.
DEFINE BUTTON qbf-sw   LABEL "&Switch Related Table..." SIZE 30 BY 1. 
DEFINE BUTTON qbf-ok   LABEL "OK"         {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON qbf-ee   LABEL "Cancel"     {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON qbf-help LABEL "&Help"      {&STDPH_OKBTN}.

/* standard button rectangle */
DEFINE RECTANGLE rect_btns {&STDPH_OKBOX}.

FORM
  SKIP({&TFM_WID})
  qbf-aa FORMAT "x(33)":u VIEW-AS TEXT 
  qbf-ss FORMAT "x(33)":u VIEW-AS TEXT 
  SKIP({&VM_WID})

  qbf-a& AT 2 
    VIEW-AS SELECTION-LIST SINGLE INNER-CHARS 30
    INNER-LINES 10 SCROLLBAR-V SCROLLBAR-H FONT 0

  qbf-a	 AT ROW-OF qbf-a& COL-OF qbf-a& 
    VIEW-AS SELECTION-LIST SINGLE INNER-CHARS 30
    INNER-LINES 10 SCROLLBAR-V SCROLLBAR-H FONT 0

  qbf-ad AT COLUMN 32 ROW 6 
  qbf-rm AT COLUMN 32 ROW 8 

  qbf-s& AT ROW-OF qbf-a& COL 60
    VIEW-AS SELECTION-LIST SINGLE INNER-CHARS 30
    INNER-LINES 10 SCROLLBAR-V SCROLLBAR-H FONT 0

  qbf-s AT ROW-OF qbf-s& COL-OF qbf-s&
    VIEW-AS SELECTION-LIST SINGLE INNER-CHARS 30
    INNER-LINES 10 SCROLLBAR-V SCROLLBAR-H FONT 0
  SKIP({&VM_WID})

  qbf-toggle2 VIEW-AS TOGGLE-BOX LABEL "Show Table &Descriptions":t30
  qbf-sw AT 47 
  SKIP({&VM_WID})

  {adecomm/okform.i
    &BOX    = rect_btns
    &STATUS = no
    &OK     = qbf-ok
    &CANCEL = qbf-ee
    &HELP   = qbf-help}


  WITH FRAME qbf-tbl NO-LABELS SCROLLABLE KEEP-TAB-ORDER THREE-D
  DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee
  VIEW-AS DIALOG-BOX TITLE "Add/Remove Tables":t20.

/*==============================Triggers==================================*/

ON ALT-V OF FRAME qbf-tbl DO: 
  IF qbf-toggle2 THEN
    APPLY "ENTRY":u TO qbf-a& IN FRAME qbf-tbl.
  ELSE
    APPLY "ENTRY":u TO qbf-a  IN FRAME qbf-tbl.
END.

ON ALT-E OF FRAME qbf-tbl DO: 
  IF qbf-toggle2 THEN
    APPLY "ENTRY":u to qbf-s& IN FRAME qbf-tbl.
  ELSE
    APPLY "ENTRY":u to qbf-s  IN FRAME qbf-tbl.
END.

ON HELP OF FRAME qbf-tbl OR CHOOSE OF qbf-help IN FRAME qbf-tbl
  RUN adecomm/_adehelp.p ("res":u,"CONTEXT":u,{&Select_Tables_Dlg_Box},?).

ON ENTRY OF qbf-a&, qbf-a IN FRAME qbf-tbl
  ASSIGN
    qbf-m                             = TRUE
    qbf-ad:SENSITIVE IN FRAME qbf-tbl = 
      (qbf-a:SCREEN-VALUE IN FRAME qbf-tbl NE ?)
    qbf-rm:SENSITIVE IN FRAME qbf-tbl = 
      (qbf-s:SCREEN-VALUE IN FRAME qbf-tbl NE ?)
  .

ON ENTRY OF qbf-s&, qbf-s IN FRAME qbf-tbl
  ASSIGN
    qbf-m                             = FALSE
    qbf-ad:SENSITIVE IN FRAME qbf-tbl = 
      (qbf-a:SCREEN-VALUE IN FRAME qbf-tbl NE ?)
    qbf-rm:SENSITIVE IN FRAME qbf-tbl = 
      (qbf-s:SCREEN-VALUE IN FRAME qbf-tbl NE ?)
  .

ON CHOOSE OF qbf-ad IN FRAME qbf-tbl
  OR DEFAULT-ACTION OF qbf-a&, qbf-a IN FRAME qbf-tbl DO:
  
  DEFINE VARIABLE qbf_i AS INTEGER   NO-UNDO.
  DEFINE VARIABLE qbf_t AS INTEGER   NO-UNDO.
  DEFINE VARIABLE tbnam AS CHARACTER NO-UNDO.

  RUN adecomm/_setcurs.p ("WAIT":u).

  /* Make sure they don't pick 2 tables with the same name from 
     different databases. */
  IF NOT qbf-hidedb THEN DO:
    tbnam = TRIM(ENTRY(1,qbf-a:SCREEN-VALUE IN FRAME qbf-tbl,"(":u)).
    DO qbf_i = 1 TO qbf-s:NUM-ITEMS IN FRAME qbf-tbl:
      IF tbnam = TRIM(ENTRY(1,
                        qbf-s:ENTRY(qbf_i) IN FRAME qbf-tbl,"(":u)) THEN DO:
      	RUN adecomm/_setcurs.p ("").
        RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"error":u,"ok":u,
      	  "You may not choose two tables with the same name from different databases.^^To use two such tables, create an alias for one of them via Query-> Site Admin-> Table Aliases.").
      	RETURN NO-APPLY.
      END.
    END.
  END.

  IF (qbf-a:VISIBLE IN FRAME qbf-tbl) THEN DO:
    qbf-val = qbf-a:SCREEN-VALUE IN FRAME qbf-tbl.

    RUN lookup_table ({&SCREEN_TO_INTERNAL}, OUTPUT qbf_t).
    RUN select_table (qbf_t).
  END.
  ELSE
  IF (qbf-a&:VISIBLE IN FRAME qbf-tbl) THEN DO:
    FIND FIRST qbf-rel-buf WHERE qbf-rel-buf.cansee  AND
      qbf-rel-buf.tdesc = qbf-a&:SCREEN-VALUE IN FRAME qbf-tbl.
    RUN select_table (qbf-rel-buf.tid).
  END.

  RUN setList.
  RUN adecomm/_setcurs.p ("").
END.

ON CHOOSE OF qbf-rm IN FRAME qbf-tbl
  OR DEFAULT-ACTION OF qbf-s&, qbf-s IN FRAME qbf-tbl DO:
  
  DEFINE VARIABLE qbf_i   AS INTEGER           NO-UNDO.
  DEFINE VARIABLE qbf_t   AS INTEGER INITIAL 0 NO-UNDO.
   
  RUN adecomm/_setcurs.p ("WAIT":u).
  IF (qbf-s:VISIBLE IN FRAME qbf-tbl) THEN DO:
    qbf-val = qbf-s:SCREEN-VALUE IN FRAME qbf-tbl.
    {&SCREEN_WO_FOR}  /* remove the FOR clause */
    RUN lookup_table ({&SCREEN_TO_INTERNAL},OUTPUT qbf_t).
    RUN unselect_table (qbf_t).
    IF qbf-s% = "" THEN 
      APPLY "ENTRY":u TO qbf-a IN FRAME qbf-tbl.
  END.
  ELSE
  IF (qbf-s&:VISIBLE IN FRAME qbf-tbl) THEN DO:
    FIND FIRST qbf-rel-buf WHERE qbf-rel-buf.cansee AND
      qbf-rel-buf.tdesc = qbf-s&:SCREEN-VALUE IN FRAME qbf-tbl.
    RUN unselect_table (qbf-rel-buf.tid).
    IF qbf-s% = "" THEN 
      APPLY "ENTRY":u TO qbf-a& IN FRAME qbf-tbl.
  END.

  RUN setList.
  RUN adecomm/_setcurs.p ("").
END.

/*-----------------------------------------------------------------
   This was to allow users to choose between join partners if there
   was more than one possibility.  We reverted back to being able to
   only join to the last table chosen so that we only support in-line
   joins, i.e., one branch.  Leave here in case we change to support
   this in future.
--------------------------------------*/
ON CHOOSE OF qbf-sw IN FRAME qbf-tbl DO:
  DEFINE VARIABLE qbf_t AS INTEGER   NO-UNDO. /* qbf-rel-tt table id */
  DEFINE VARIABLE qbf_s AS CHARACTER NO-UNDO. /* table id for selected tbl*/
  DEFINE VARIABLE qbf_n AS CHARACTER NO-UNDO. /* tablename (select list item) */
  DEFINE VARIABLE qbf_b AS LOGICAL   NO-UNDO. /* scrap */
  DEFINE VARIABLE qbf_i AS INTEGER   NO-UNDO. /* indexes */
  DEFINE VARIABLE qbf_j AS CHARACTER NO-UNDO. /* join choice index */
  DEFINE VARIABLE qbf_w AS HANDLE    NO-UNDO.

  ASSIGN
    qbf_w   = (IF qbf-toggle2 THEN qbf-s&:HANDLE ELSE qbf-s:HANDLE)
    qbf-val = qbf_w:SCREEN-VALUE
    qbf_i   = qbf_w:LOOKUP(qbf-val)
    qbf_s   = ENTRY(qbf_i,qbf-s%).

  IF qbf-toggle2 THEN /* make sure we have name entry not desc */
    qbf-val = qbf-s:ENTRY(qbf_i) IN FRAME qbf-tbl.
  qbf_n = qbf-val. /* remember original value */

  RUN get_join_choice (qbf_s, OUTPUT qbf_i, OUTPUT qbf_j).
  IF qbf_i > 0 THEN  
    /* Default the qbf_t, to be the current join choice */
    qbf_t = INTEGER(qbf_j).

  qbf-c = STRING(qbf-toggle2:SCREEN-VALUE in FRAME qbf-tbl). 
  RUN aderes/j-table1.p (qbf-jp, yes, INPUT-OUTPUT qbf_t).
  
  IF qbf-c <> STRING(qbf-toggle2) THEN DO:
    qbf-toggle2:SCREEN-VALUE IN FRAME qbf-tbl = STRING(qbf-toggle2).
    APPLY "VALUE-CHANGED":u TO qbf-toggle2 in FRAME qbf-tbl.
  END.

  IF qbf_t > 0 THEN DO: /* a join preference was made */
    /* update FOR phrase in select list */
    {&SCREEN_WO_FOR}
    RUN add_for_phrase (qbf_t, INPUT-OUTPUT qbf-val).
    ASSIGN
      qbf_b = qbf-s:REPLACE(qbf-val, qbf_n) IN FRAME qbf-tbl
      qbf-s:SCREEN-VALUE IN FRAME qbf-tbl = qbf-val
      changeChoice = true
    .
    
    IF qbf_i = 0 THEN /* haven't specified join choice before */
      qbf-rel-choice = qbf-rel-choice + 
      	       	       (IF qbf-rel-choice = "" THEN "" ELSE ",":u) + 
      	       	       qbf_s + ":":u + STRING(qbf_t).
    ELSE /* modify the join choice */
      ENTRY(qbf_i,qbf-rel-choice) = qbf_s + ":":u + STRING(qbf_t).
  END.
END.

ON GO OF FRAME qbf-tbl DO:
  RUN adecomm/_setcurs.p ("WAIT":u).
  ASSIGN
    qbf-chg   = (qbf-t <> qbf-s%)  OR changeChoice
    qbf-t     = qbf-s%
  .

END.

ON VALUE-CHANGED OF qbf-toggle2 IN FRAME qbf-tbl DO:
  DEFINE VARIABLE a_widg AS HANDLE NO-UNDO.
  DEFINE VARIABLE s_widg AS HANDLE NO-UNDO.

  RUN setList.

  /* scroll list so at least first selected item is in view */
  IF qbf-toggle2 THEN 
    ASSIGN
      a_widg = qbf-a&:HANDLE IN FRAME qbf-tbl
      s_widg = qbf-s&:HANDLE IN FRAME qbf-tbl.
  ELSE
    ASSIGN
      a_widg = qbf-a:HANDLE IN FRAME qbf-tbl
      s_widg = qbf-s:HANDLE IN FRAME qbf-tbl.

  IF a_widg:SCREEN-VALUE <> ? THEN
    RUN adecomm/_scroll.p (a_widg,ENTRY(1,a_widg:SCREEN-VALUE,CHR(3))).
  IF s_widg:SCREEN-VALUE <> ? THEN
    RUN adecomm/_scroll.p (s_widg,ENTRY(1,s_widg:SCREEN-VALUE,CHR(3))).
END.

/* - - - - - - - - - - - - -- - - - - - -
   Only need for fancy join support
-- - - - - - - - - - - - - - - - - - -*/
ON VALUE-CHANGED OF qbf-s, qbf-s& IN FRAME qbf-tbl DO:
  DEFINE VARIABLE qbf_i  AS INTEGER   NO-UNDO. /* index */
  DEFINE VARIABLE qbf_l  AS INTEGER   NO-UNDO. /* loop */
  DEFINE VARIABLE qbf_t  AS INTEGER   NO-UNDO. /* qbf-rel-tt table id */
  DEFINE VARIABLE qbf_j  AS CHARACTER NO-UNDO. /* join list (all joins) */

  /* See if there is more than one possible join partner for this entry */
  /* Get all possible joins first */
  ASSIGN
    qbf-val = SELF:SCREEN-VALUE
    qbf_i   = SELF:LOOKUP(SELF:SCREEN-VALUE). /* entry # in select list */

  IF SELF = qbf-s&:HANDLE THEN /* make sure we have table name not desc. */
    qbf-val = qbf-s:ENTRY(qbf_i) IN FRAME qbf-tbl.

  {&SCREEN_WO_FOR}
  {&FIND_TABLE_BY_NAME} {&SCREEN_TO_INTERNAL}.

  RUN get_joins (qbf-rel-buf.rels, OUTPUT qbf_j).

  /* Which of these are in selected set that come before the current item? */
  qbf-jp = "".
  DO qbf_l = 1 TO qbf_i - 1:
    IF CAN-DO(qbf_j,ENTRY(qbf_l,qbf-s%)) THEN
      qbf-jp = qbf-jp + (IF qbf-jp = "" THEN "" ELSE ",":u) 
             + ENTRY(qbf_l,qbf-s%).
  END.
  qbf-sw:SENSITIVE IN FRAME qbf-tbl = (NUM-ENTRIES(qbf-jp) > 1).
END.

ON WINDOW-CLOSE OF FRAME qbf-tbl
  APPLY "END-ERROR":u TO SELF.             

/*==============================Mainline Code==============================*/

DO ON ERROR UNDO, LEAVE:

/* Adjust frame layout */
ASSIGN
  qbf-aa                           = " ":u + "A&vailable Tables":t30 + ": ":u
  qbf-ss                           = " ":u + "S&elected Tables":t30 + ": ":u
  qbf-aa:FORMAT IN FRAME qbf-tbl   = SUBSTITUTE("x(&1)":u,
                                                LENGTH(qbf-aa,"RAW":u))
  qbf-ss:FORMAT IN FRAME qbf-tbl   = SUBSTITUTE("x(&1)":u,
                                                LENGTH(qbf-ss,"RAW":u))
  
  qbf-aa:SCREEN-VALUE IN FRAME qbf-tbl = qbf-aa
  qbf-ss:SCREEN-VALUE IN FRAME qbf-tbl = qbf-ss

  qbf-a:DELIMITER IN FRAME qbf-tbl     = CHR(3)
  qbf-a&:DELIMITER IN FRAME qbf-tbl    = CHR(3)
  qbf-s:DELIMITER IN FRAME qbf-tbl     = CHR(3)
  qbf-s&:DELIMITER IN FRAME qbf-tbl    = CHR(3)

  /* put run-time adjustment for screen resolution & font here, 
     before frame is visible */
  qbf-a:WIDTH IN FRAME qbf-tbl  =
    qbf-a:WIDTH IN FRAME qbf-tbl - shrink-hor-2
  qbf-a&:WIDTH IN FRAME qbf-tbl =
    qbf-a&:WIDTH IN FRAME qbf-tbl - shrink-hor-2
  qbf-s:WIDTH IN FRAME qbf-tbl  =
    qbf-s:WIDTH IN FRAME qbf-tbl - shrink-hor-2
  qbf-s&:WIDTH IN FRAME qbf-tbl =
    qbf-s&:WIDTH IN FRAME qbf-tbl - shrink-hor-2
  
  qbf-ad:X IN FRAME qbf-tbl          = qbf-a:WIDTH-PIXELS IN FRAME qbf-tbl 
                                     + 4 + qbf-a:X IN FRAME qbf-tbl 
  qbf-rm:X IN FRAME qbf-tbl          = qbf-ad:X
  qbf-ix                             = qbf-a:Y IN FRAME qbf-tbl
                                     + qbf-a:HEIGHT-PIXELS IN FRAME qbf-tbl / 2
  qbf-ad:Y IN FRAME qbf-tbl          = qbf-ix
                                     - qbf-ad:HEIGHT-PIXELS IN FRAME qbf-tbl 
                                     - 3
  qbf-rm:Y IN FRAME qbf-tbl          = qbf-ix + 3
  qbf-s:X  IN FRAME qbf-tbl          = qbf-ad:X IN FRAME qbf-tbl
                                     + qbf-ad:WIDTH-PIXELS IN FRAME qbf-tbl 
                                     + 4
  qbf-s&:X IN FRAME qbf-tbl          = qbf-s:X IN FRAME qbf-tbl
  qbf-sw:X IN FRAME qbf-tbl          = qbf-s:X IN FRAME qbf-tbl

  qbf-aa:X IN FRAME qbf-tbl            = qbf-a:X IN FRAME qbf-tbl
  qbf-ss:X IN FRAME qbf-tbl            = qbf-s:X IN FRAME qbf-tbl
  qbf-aa:WIDTH-PIXELS IN FRAME qbf-tbl = qbf-a:WIDTH-PIXELS IN FRAME qbf-tbl
  qbf-ss:WIDTH-PIXELS IN FRAME qbf-tbl = qbf-s:WIDTH-PIXELS IN FRAME qbf-tbl 
  qbf-toggle2:X IN FRAME qbf-tbl       = qbf-a:X IN FRAME qbf-tbl
  
  FRAME qbf-tbl:VIRTUAL-WIDTH          = qbf-s:COL IN FRAME qbf-tbl
                                       + qbf-s:WIDTH IN FRAME qbf-tbl + 1

  FRAME qbf-tbl:WIDTH                  = FRAME qbf-tbl:VIRTUAL-WIDTH
  .

/* Manage the watch cursor ourselves */
&UNDEFINE TURN-OFF-CURSOR

/* Run time layout for button area.  This defines eff_frame_width */
{adecomm/okrun.i  
   &FRAME = "FRAME qbf-tbl" 
   &BOX   = "rect_btns"
   &OK    = "qbf-ok" 
   &HELP  = "qbf-help" }

/* Determine max length of a table. */
IF NOT qbf-hidedb THEN
  FOR EACH qbf-rel-buf WHERE qbf-rel-buf.cansee USE-INDEX tnameix:
    max_len = MAXIMUM(max_len,
                      LENGTH(ENTRY(2,qbf-rel-buf.tname,".":u),"RAW":u)).
  END.

/* Create temp table with table descriptions and fill selection lists. */
FOR EACH qbf-rel-buf WHERE qbf-rel-buf.cansee USE-INDEX tnameix:
  IF qbf-rel-buf.tdesc = "" THEN DO:
    { aderes/getdesc.i }

    ASSIGN
      qbf-tnam          = qbf-rel-buf.tname
      qbf-rel-buf.tdesc = {&DESC_INTERNAL_TO_SCREEN}.
  END.

  RUN plus_left (yes, qbf-rel-buf.tid).
END.

DO qbf-ix = 1 TO NUM-ENTRIES(qbf-t).
  RUN select_table (INTEGER(ENTRY(qbf-ix,qbf-t))).
END.

DISPLAY qbf-toggle2 
  WITH FRAME qbf-tbl.

ENABLE qbf-a qbf-a& qbf-ad qbf-rm qbf-s qbf-s& qbf-toggle2 qbf-ok 
  qbf-ee qbf-help
  WITH FRAME qbf-tbl.

ASSIGN	 
  qbf-ok:SENSITIVE IN FRAME qbf-tbl = qbf-s% <> ""
  qbf-a:VISIBLE IN FRAME qbf-tbl    = NOT qbf-toggle2
  qbf-s:VISIBLE IN FRAME qbf-tbl    = NOT qbf-toggle2
  qbf-a&:VISIBLE IN FRAME qbf-tbl   = qbf-toggle2
  qbf-s&:VISIBLE IN FRAME qbf-tbl   = qbf-toggle2.
  /*
  **  The NO-ERROR here is dangerous but will nicely mask the error
  **  if ? is assigned to screen-value. This error can be ignored with
  **  no adverse side effects 
  */
  ASSIGN
    qbf-s:SCREEN-VALUE  IN FRAME qbf-tbl = ""
    qbf-s&:SCREEN-VALUE IN FRAME qbf-tbl = ""
    qbf-a:SCREEN-VALUE  IN FRAME qbf-tbl = ""
    qbf-a&:SCREEN-VALUE IN FRAME qbf-tbl = ""
    qbf-s:SCREEN-VALUE  IN FRAME qbf-tbl = qbf-s:ENTRY(1)  IN FRAME qbf-tbl
    qbf-s&:SCREEN-VALUE IN FRAME qbf-tbl = qbf-s&:ENTRY(1) IN FRAME qbf-tbl
    qbf-a:SCREEN-VALUE  IN FRAME qbf-tbl = qbf-a:ENTRY(1)  IN FRAME qbf-tbl
    qbf-a&:SCREEN-VALUE IN FRAME qbf-tbl = qbf-a&:ENTRY(1) IN FRAME qbf-tbl
    qbf-ad:SENSITIVE                     = (qbf-a:SCREEN-VALUE NE ?)
    qbf-rm:SENSITIVE                     = (qbf-s:SCREEN-VALUE NE ?)
    NO-ERROR.

END. /* end do on error block */    
RUN adecomm/_setcurs.p ("").

IF qbf-toggle2 THEN
  APPLY "ENTRY":u TO qbf-a& IN FRAME qbf-tbl.
ELSE
  APPLY "ENTRY":u TO qbf-a IN FRAME qbf-tbl.

DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
  WAIT-FOR GO OF FRAME qbf-tbl.
END.

HIDE FRAME qbf-tbl NO-PAUSE.
RETURN.

/*==========================Internal Procedures=============================*/

PROCEDURE setList:

DEFINE VARIABLE ix         AS INTEGER   NO-UNDO.
DEFINE VARIABLE iTop       AS INTEGER   NO-UNDO.
DEFINE VARIABLE iBottom    AS INTEGER   NO-UNDO.
DEFINE VARIABLE wCurrent-a AS HANDLE    NO-UNDO.
DEFINE VARIABLE wCurrent-s AS HANDLE    NO-UNDO.
DEFINE VARIABLE wOther-a   AS HANDLE    NO-UNDO.
DEFINE VARIABLE wOther-s   AS HANDLE    NO-UNDO.

DO with frame qbf-tbl:
  /* Set current available and selected list based on who is visible or not. */
  IF (qbf-a:VISIBLE) THEN
    ASSIGN
      wCurrent-a = qbf-a:HANDLE 
      wCurrent-s = qbf-s:HANDLE 
      wOther-a   = qbf-a&:HANDLE
      wOther-s   = qbf-s&:HANDLE
      .
  ELSE
    ASSIGN
      wCurrent-a = qbf-a&:HANDLE 
      wCurrent-s = qbf-s&:HANDLE 
      wOther-a   = qbf-a:HANDLE  
      wOther-s   = qbf-s:HANDLE  
      .
     
  ASSIGN
    qbf-toggle2           = INPUT qbf-toggle2
    qbf-a:VISIBLE         = NOT qbf-toggle2
    qbf-a&:VISIBLE        = qbf-toggle2
    qbf-s:VISIBLE         = NOT qbf-toggle2
    qbf-s&:VISIBLE        = qbf-toggle2
    wOther-a:SCREEN-VALUE = ""
    wOther-s:SCREEN-VALUE = ""
    .
    
   /* Set the invisible list to match the visible on for Selected */
   DO ix = 1 TO NUM-ENTRIES(wCurrent-s:SCREEN-VALUE,CHR(3)):
    ASSIGN
      iTop = wCurrent-s:LOOKUP(ENTRY(ix,wCurrent-s:SCREEN-VALUE,CHR(3)))
      wOther-s:SCREEN-VALUE = wOther-s:ENTRY(iTop).
   END.   

   /* Set the invisible list to match the visible on for Available */
   DO ix = 1 TO NUM-ENTRIES(wCurrent-a:SCREEN-VALUE,CHR(3)):
    ASSIGN
      iTop = wCurrent-a:LOOKUP(ENTRY(ix,wCurrent-a:SCREEN-VALUE,CHR(3)))
      wOther-a:SCREEN-VALUE = wOther-a:ENTRY(iTop).
   END.   
   
   IF (qbf-a:SCREEN-VALUE = ?) THEN
     ASSIGN
       qbf-a:SCREEN-VALUE  = qbf-a:ENTRY(1) 
       qbf-a&:SCREEN-VALUE = qbf-a&:ENTRY(1)
       NO-ERROR.
     
   IF (qbf-s:SCREEN-VALUE = ?) THEN
     ASSIGN
       qbf-s:SCREEN-VALUE  = qbf-s:ENTRY(1) 
       qbf-s&:SCREEN-VALUE = qbf-s&:ENTRY(1)
       NO-ERROR.
   
   ASSIGN
     qbf-ad:SENSITIVE = (qbf-a:SCREEN-VALUE NE ?)
     qbf-rm:SENSITIVE = (qbf-s:SCREEN-VALUE NE ?)
     .

   /*- - - - - Only needed for fancy join support: - - - - -*/
   /* To make sure "switch" button is enabled appropriately */
   IF qbf-s:NUM-ITEMS IN FRAME qbf-tbl > 0 THEN
     APPLY "VALUE-CHANGED":u TO qbf-s IN FRAME qbf-tbl. 
END.
END PROCEDURE. /* setList */

/*--------------------------------------------------------------------------*/

PROCEDURE select_table:
  DEFINE INPUT PARAMETER qbf_t AS INTEGER NO-UNDO. /* table number */

  /*- - - - - - - - - - - - - - - - - - - - - - - - - - - 
    This is what it does when we allow selecting a table
    that can be joined to any table that is already 
    selected.
  - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
  DEFINE VARIABLE qbf_i AS INTEGER   NO-UNDO. /* loop */
  DEFINE VARIABLE qbf_j AS CHARACTER NO-UNDO. /* join list */
  DEFINE VARIABLE qbf_s AS INTEGER   NO-UNDO. /* specific join */
  DEFINE VARIABLE num_joins AS INTEGER NO-UNDO.
  DEFINE VARIABLE num_avail AS INTEGER NO-UNDO.

  RUN plus_right (qbf_t).
  {&FIND_TABLE_BY_ID} qbf_t.

  RUN get_joins (qbf-rel-buf.rels,OUTPUT qbf_j).

  /* If only 1 table is selected (in fact qbf_t), we want to fill
     available list with only the tables that can be joined with 
     this one (qbf_j). 
  */   
  IF NUM-ENTRIES(qbf-s%) = 1 THEN DO:
     /* Currently the available list has all the tables.
        We can either remove ones that aren't in the qbf_j list or
        just clear the list and add in the ones in qbf_j.  Which
        would be faster?  It is highly unlikely that the # of 
        tables in qbf_j is more than half the # of tables in the 
        database unless the database is very small, in which case 
        we don't care.  So for simplicity let's just to the zap and
        re-add method.
     */
     RUN refill_left_list (qbf_j).
  END.   
  ELSE DO:
    /* More than 1 table is selected.  Everything currently in available
       list is joinable to some table in selected list.  Now we've added
       a new one to selected, so add any new tables to available list that 
       are joinable to this new selected one.
    */
    RUN minus_left (qbf_t).
    DO qbf_i = 1 TO NUM-ENTRIES(qbf_j):
      qbf_s = INTEGER(ENTRY(qbf_i,qbf_j)).
      IF    NOT CAN-DO(qbf-a%,STRING(qbf_s))
        AND NOT CAN-DO(qbf-s%,STRING(qbf_s)) THEN RUN plus_left (no, qbf_s).
    END.
  END.

  /*- - - - - - - - - - - - - - - - - - - - - - - - - - -
  -- For non-fancy joins --  

  DEFINE VARIABLE qbf_j AS CHARACTER NO-UNDO. /* join list */

  /* Allow user to add a table that is a child 
     of the last table in the selected list i.e., qbf_t). 
  */  
  RUN plus_right (qbf_t).
  {&FIND_TABLE_BY_ID} qbf_t.

  RUN get_joins (qbf-rel-buf.rels,OUTPUT qbf_j).
  RUN refill_left_list (qbf_j).
  - - - - - - - - - - - - - - - - - - - - - - -- - - */
END PROCEDURE. /* select_table */

/*--------------------------------------------------------------------------*/
PROCEDURE unselect_table:
  DEFINE INPUT PARAMETER qbf_t AS INTEGER NO-UNDO. /* table number */

  DEFINE VARIABLE qbf_j AS CHARACTER NO-UNDO. /* join list for each table */

  /*- - - - - - - - - - - - - - - - - - - - - - - - - - -
    This is what we do for "awesome" join support.
  - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
  DEFINE VARIABLE qbf_1	 AS INTEGER   NO-UNDO. /* table id */
  DEFINE VARIABLE qbf_2	 AS INTEGER   NO-UNDO. /* 2nd table id */
  DEFINE VARIABLE all_jns AS CHARACTER NO-UNDO. /* new join list for all tables */
  DEFINE VARIABLE qbf_b	 AS LOGICAL   NO-UNDO. /* scrap */
  DEFINE VARIABLE qbf_i	 AS INTEGER   NO-UNDO. /* inner loop */
  DEFINE VARIABLE qbf_o	 AS INTEGER   NO-UNDO. /* outer loop */
  DEFINE VARIABLE qbf_p	 AS INTEGER   NO-UNDO. /* pos in qbf-rel-tt.rels */
  DEFINE VARIABLE qbf_w	 AS INTEGER   NO-UNDO. /* pos in qbf-rel-whr array */
  DEFINE VARIABLE qbf_n	 AS CHARACTER NO-UNDO. /* table name (screen format)*/
  DEFINE VARIABLE qbf_s   AS CHARACTER NO-UNDO. /* entry in qbf-s% */
  DEFINE VARIABLE qbf_k   AS INTEGER   NO-UNDO. /* scrap */
  DEFINE VARIABLE num_av  AS INTEGER   NO-UNDO. /* # tables in available list */
  DEFINE VARIABLE num_jn  AS INTEGER   NO-UNDO. /* # tables in new join list */

  RUN minus_right (qbf_t).
  RUN plus_left (no, qbf_t).

  /* None are left selected. Make sure full list of available tables 
     is restored.
  */
  IF qbf-s% = "" THEN DO: 
    RUN refill_left_list ("ALL").
    RETURN.
  END.

  /* Go through selected list.  The first one will remain
     in here no matter what.  Progressively remove any tables 
     that are not joinable to any other table that is left
     in this selected list.
     Attempt removes from outer to inner 
  */
  DO qbf_o = 2 TO NUM-ENTRIES(qbf-s%):
    qbf_2 = INTEGER(ENTRY(qbf_o,qbf-s%)).

    /* attempt join matches from outer to inner */
    DO qbf_i = 1 TO qbf_o - 1:
      qbf_1 = INTEGER(ENTRY(qbf_i,qbf-s%)).

      RUN lookup_join (qbf_1,qbf_2,OUTPUT qbf_p,OUTPUT qbf_w).
      IF qbf_p > 0 THEN LEAVE. /* join found, exit inner loop */
    END. /* qbf_i, inner loop */

    IF qbf_i = qbf_o THEN DO: /* no match found; find can't be selected */
      RUN minus_right (qbf_2).
      qbf_o = qbf_o - 1. /* fixup loop because qbf-s% changed */
    END.
  END. /* qbf_o, outer loop */

  /* Build new join-candidate list.  The new available
     list will be the list of all tables that can be
     joined to any table that is already selected.  
     Make sure that if it is already selected, we don't
     include it and that there are no duplicates.
  */
  all_jns = "".
  DO qbf_o = 1 TO NUM-ENTRIES(qbf-s%):
    {&FIND_TABLE_BY_ID} INTEGER(ENTRY(qbf_o,qbf-s%)).
    RUN get_joins (qbf-rel-buf.rels, OUTPUT qbf_j).

    DO qbf_i = 1 TO NUM-ENTRIES(qbf_j):
      qbf_p = INTEGER(ENTRY(qbf_i,qbf_j)).
      IF CAN-DO(qbf-s%,STRING(qbf_p)) THEN NEXT.
      IF NOT CAN-DO(all_jns,STRING(qbf_p)) THEN
        all_jns = all_jns + (IF all_jns = "" THEN "" ELSE ",":u) + STRING(qbf_p).
    END.
  END.
  
  /* Now adjust the available list so that only the tables joinable 
     to what is now in the selected list remain there.
     Either remove anything in the available list that's not in the
     join list, or just zap the list and add the join tables, 
     whichever we think will be faster based on the numbers.
  */
  num_av = NUM-ENTRIES(qbf-a%). 
  num_jn = NUM-ENTRIES(all_jns).
  IF (num_av - num_jn) > num_jn THEN DO:
     /* # to remove was > than # to add, so do the add */
     RUN refill_left_list(all_jns).
  END.   
  ELSE DO:   
     /* Do selective removal */
     qbf_i = 1.
     DO WHILE num_av > 0 AND qbf_i <= num_av:
       IF NOT CAN-DO(all_jns,ENTRY(qbf_i,qbf-a%)) THEN DO:
          RUN minus_left (INTEGER(ENTRY(qbf_i,qbf-a%))).
          num_av = num_av - 1. /* num available is now 1 less */
          /* leave qbf_i alone since it will now index to the next one.
             If the last one was just removed, qbf_i will now be > than
             num_av and we'll leave the loop.
          */   
       END.  
       ELSE
         qbf_i = qbf_i + 1. /* move to next one in available list */
     END.
  END.   
     
  /* Now fix up the "FOR" clause on the remaining selected items */
  DO qbf_i = 1 TO NUM-ENTRIES(qbf-s%):
    qbf-val = qbf-s:ENTRY(qbf_i) IN FRAME qbf-tbl.
    qbf_n = qbf-val. /* remember original value */
    qbf_s = ENTRY(qbf_i, qbf-s%).
    /* if this table has a preferred join partner and it is
    	 still in the selected list (qbf-s%) then just leave it. 
    	 Otherwise, find a new join partner.
    */
    RUN get_join_choice (qbf_s, OUTPUT qbf_k, OUTPUT qbf_j).
    IF NOT CAN-DO(qbf-s%, qbf_j) THEN DO:
      {&SCREEN_WO_FOR} /* remove existing FOR clause */
      IF qbf_i > 1 THEN 
        RUN join_partner (qbf_i - 1, INTEGER(qbf_s), 
    	         	  INPUT-OUTPUT qbf-val, OUTPUT qbf_j).
      IF qbf_k > 0 THEN
        RUN unentry (ENTRY(qbf_k,qbf-rel-choice),INPUT-OUTPUT qbf-rel-choice).
    END.
    IF qbf-val <> qbf_n THEN 
      qbf_b = qbf-s:REPLACE(qbf-val, qbf_n) IN FRAME qbf-tbl.
  END.

  /*- - - - - - - - - - - - - - - - - - - - - - - - - - -

  /* Instead: */
  DEFINE VARIABLE qbf_i AS INTEGER   NO-UNDO. /* scrap*/
  DEFINE VARIABLE ix    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE new_j AS CHARACTER NO-UNDO. /* possible new join partner */
  DEFINE VARIABLE qbf_b	AS LOGICAL   NO-UNDO. /* scrap */
  DEFINE VARIABLE done	AS LOGICAL   NO-UNDO INIT FALSE. 
  DEFINE VARIABLE qbf_n	AS CHARACTER NO-UNDO. /* table name (screen format)*/

  /* when qbf_t is removed, ix will point at the next one */ 
  ix = LOOKUP(STRING(qbf_t),qbf-s%). 
  RUN minus_right (qbf_t).

  /* If we removed one from the middle, go through subsequent entries
     and see if they can be joined up with what's left.  Otherwise
     remove them.  Once we find one that is OK, all subsequent ones
     will be OK too.
  */
  DO WHILE ix <= NUM-ENTRIES(qbf-s%) AND NOT done:
    /* If we removed the first one, the new first one is ok - just
       remove the FOR phrase.
    */
    IF ix = 1 THEN DO:
      qbf_n = qbf-s:ENTRY(1) IN FRAME qbf-tbl.
      qbf-val = qbf_n.

      {&SCREEN_WO_FOR}

      ASSIGN
        qbf_b = qbf-s:REPLACE(qbf-val, qbf_n) IN FRAME qbf-tbl
        qbf-s:SCREEN-VALUE IN FRAME qbf-tbl = qbf-val
        done = TRUE. 
    END.
    ELSE DO:
      /* See if we can join up with the one above */
      {&FIND_TABLE_BY_ID} INTEGER(ENTRY(ix, qbf-s%)).

      RUN get_joins (qbf-rel-buf.rels, OUTPUT qbf_j).

      new_j = ENTRY(ix - 1, qbf-s%).

      IF CAN-DO(qbf_j, new_j) THEN DO:
    	/* Change FOR phrase to reflect new join partner */
        qbf-val = qbf-s:ENTRY(ix) IN FRAME qbf-tbl.
        qbf_n = qbf-val. /* remember original */
        {&SCREEN_WO_FOR}
        RUN add_for_phrase (INTEGER(new_j), INPUT-OUTPUT qbf-val).
      	ASSIGN
          qbf_b = qbf-s:REPLACE(qbf-val, qbf_n) IN FRAME qbf-tbl
          qbf-s:SCREEN-VALUE IN FRAME qbf-tbl = qbf-val
    	  done = TRUE.
      END.   
      ELSE 
    	RUN minus_right (INTEGER(ENTRY(ix, qbf-s%))).
    	/* ix will now point at next one */
    END.
  END.

  /* Refresh left list with tables joinable to the last selected 
     table or all tables if none are left selected.
  */
  RUN get_last_tbl (OUTPUT qbf_i).  /* sets qbf-rel-buf */
  IF qbf_i > 0 THEN DO:
    RUN get_joins (qbf-rel-buf.rels, OUTPUT qbf_j).
    RUN refill_left_list (qbf_j).
  END.
  ELSE
    RUN refill_left_list ("ALL":u).
  - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
  
END PROCEDURE. /* unselect_table */

/*--------------------------------------------------------------------------*/
PROCEDURE plus_left:
  DEFINE INPUT PARAMETER always_last AS LOGICAL NO-UNDO.
  DEFINE INPUT PARAMETER qbf_t AS INTEGER NO-UNDO.

  DEFINE VARIABLE qbf_b AS LOGICAL   NO-UNDO. /* scrap */
  DEFINE VARIABLE qbf_i AS INTEGER   NO-UNDO. /* insert position */
  DEFINE VARIABLE qbf_l AS INTEGER   NO-UNDO. /* loop */
  DEFINE VARIABLE qbf_n AS CHARACTER NO-UNDO. /* tablename */
  DEFINE VARIABLE qbf_r AS CHARACTER NO-UNDO. /* replace name */
  DEFINE VARIABLE qbf_desc AS CHARACTER NO-UNDO.

  /* 
  Don't use qbf-rel-buf since this is called by code already
  in a FOR EACH loop on this buffer.  Use buf2.
  */
  {&FIND_TABLE2_BY_ID} qbf_t NO-ERROR.
  IF NOT AVAILABLE qbf-rel-buf2 THEN RETURN. /* table hidden */

  ASSIGN
    qbf_desc = qbf-rel-buf2.tdesc
    qbf-tnam = qbf-rel-buf2.tname.

  /*- - - - - - - - - - - - - - - - - - - - - - - - - - -
    This is what it does for fancy joins since we are 
    sometimes adding entries back into to an existing list
    and this attempts to always keep the left sellist
    (available tables) in the original order.
  - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
  IF always_last THEN /* optimization - always add at end */
    ASSIGN
      qbf_t  = qbf_t
      qbf_n  = {&INTERNAL_TO_SCREEN}
      qbf_b  = qbf-a:ADD-LAST(qbf_n) IN FRAME qbf-tbl
      qbf_b  = qbf-a&:ADD-LAST(qbf_desc) IN FRAME qbf-tbl
      qbf-a% = qbf-a% + (IF qbf-a% = "" THEN "" ELSE ",":u) + STRING(qbf_t).
  ELSE DO:
    ASSIGN
      qbf_n  = {&INTERNAL_TO_SCREEN}
      qbf_i = 0.
    IF qbf-a% <> "" THEN DO:
      /* Find the first available table after this one - place to insert */
      FIND FIRST qbf-rel-buf2 WHERE qbf-rel-buf2.cansee AND
      	         qbf-rel-buf2.tname > qbf-tnam AND
      	 LOOKUP(STRING(qbf-rel-buf2.tid),qbf-a%) > 0 NO-ERROR.
      IF AVAILABLE qbf-rel-buf2 THEN
        ASSIGN
          qbf_l = qbf-rel-buf2.tid
          qbf_i = LOOKUP(STRING(qbf_l),qbf-a%).
    END.
    IF qbf_i = 0 THEN
      ASSIGN
        qbf_b  = qbf-a:ADD-LAST(qbf_n) IN FRAME qbf-tbl
        qbf_b  = qbf-a&:ADD-LAST(qbf_desc) IN FRAME qbf-tbl
        qbf-a% = qbf-a% + (IF qbf-a% = "" THEN "" ELSE ",":u) + STRING(qbf_t).
    ELSE DO:
      {&FIND_TABLE2_BY_ID} qbf_l.  
      qbf-tnam = qbf-rel-buf2.tname. /* needed for internal_to_screen */
      ASSIGN
        qbf_r = {&INTERNAL_TO_SCREEN}
        qbf_b = qbf-a:INSERT(qbf_n,qbf_r) IN FRAME qbf-tbl
        qbf_b = qbf-a&:INSERT(qbf_desc,qbf-rel-buf2.tdesc) IN FRAME qbf-tbl
        ENTRY(qbf_i,qbf-a%) = STRING(qbf_t) + ",":u + ENTRY(qbf_i,qbf-a%).
    END.
  END.

  /*- - - - - - - - - - - - - - - - - - - - - - - - - - -

  /* For non-fancy joins we are always clearing the left 
     list before refilling it so we just need the "always 
     at the bottom" processing.
  */
  ASSIGN
    qbf_t  = qbf_t /* holdover from above, just leave it */
    qbf_n  = {&INTERNAL_TO_SCREEN}
    qbf_b  = qbf-a:ADD-LAST(qbf_n) IN FRAME qbf-tbl
    qbf_b  = qbf-a&:ADD-LAST(qbf_desc) IN FRAME qbf-tbl
    qbf-a% = qbf-a% + (IF qbf-a% = "" THEN "" ELSE ",":u) + STRING(qbf_t).
  - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
END PROCEDURE. /* plus_left */

/*--------------------------------------------------------------------------*/

/*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
  Not used unless we have fancy join support.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
PROCEDURE minus_left:
  DEFINE INPUT PARAMETER qbf_t AS INTEGER NO-UNDO.
  DEFINE VARIABLE qbf_b AS LOGICAL NO-UNDO.   /* scrap */
  DEFINE VARIABLE qbf_n AS CHARACTER NO-UNDO. /* tablename */

  {&FIND_TABLE_BY_ID} qbf_t.

  qbf-tnam = qbf-rel-buf.tname.
  qbf_n  = {&INTERNAL_TO_SCREEN}.
 
  /* Remove this name from the "remove list" */
  IF  (qbf-a:LOOKUP(qbf_n) IN FRAME qbf-tbl > 0) THEN
    qbf_b = qbf-a:DELETE (qbf_n) IN FRAME qbf-tbl.

  /* Remove this name from the "remove list" */
  IF (qbf-a&:LOOKUP(qbf-rel-buf.tdesc) IN FRAME qbf-tbl > 0) THEN
    qbf_b = qbf-a&:DELETE (qbf-rel-buf.tdesc) IN FRAME qbf-tbl.

  RUN unentry (STRING(qbf_t),INPUT-OUTPUT qbf-a%).
END PROCEDURE. /* minus_left */

/*--------------------------------------------------------------------------*/
PROCEDURE plus_right:
  DEFINE INPUT PARAMETER qbf_t AS INTEGER NO-UNDO.

  DEFINE VARIABLE qbf_b AS LOGICAL   NO-UNDO. /* scrap */
  DEFINE VARIABLE qbf_n AS CHARACTER NO-UNDO. /* tablename */
  DEFINE VARIABLE qbf_j AS CHARACTER NO-UNDO. /* join partner */
  DEFINE VARIABLE qbf_i AS INTEGER   NO-UNDO. /* index */
  DEFINE VARIABLE qbf_d AS CHARACTER NO-UNDO. /* description */

  {&FIND_TABLE_BY_ID} qbf_t.
  qbf-tnam = qbf-rel-buf.tname.
  qbf_d = qbf-rel-buf.tdesc.
  qbf_n = {&INTERNAL_TO_SCREEN}.

  /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     This is for fancy join support 
  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
  /* There will only be a join choice if we are are starting up the
     dialog with existing tables.  There won't be a choice
     on a newly selected table.
  */
  RUN get_join_choice (STRING(qbf_t), OUTPUT qbf_i, OUTPUT qbf_j).
  IF qbf_i > 0 THEN
    RUN add_for_phrase (INTEGER(qbf_j), INPUT-OUTPUT qbf_n).
  ELSE
    RUN join_partner (NUM-ENTRIES(qbf-s%),qbf_t, 
      	       	      INPUT-OUTPUT qbf_n,OUTPUT qbf_j).

  /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  /* Instead - they only have 1 choice: join to last table
     selected.
  */
  RUN get_last_tbl (OUTPUT qbf_i).  /* sets qbf-rel-buf */
  IF qbf_i > 0 THEN 
    RUN add_for_phrase (qbf_i, INPUT-OUTPUT qbf_n).

  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  /* This code is needed for both old and new join support */
  ASSIGN
    qbf_b  = qbf-s:ADD-LAST(qbf_n) IN FRAME qbf-tbl
    qbf_b  = qbf-s&:ADD-LAST(qbf_d) IN FRAME qbf-tbl
    qbf-s% = qbf-s% + (IF qbf-s% = "" THEN "" ELSE ",":u) + STRING(qbf_t)
    qbf-ok:SENSITIVE IN FRAME qbf-tbl = TRUE.

END PROCEDURE. /* plus_right */

/*--------------------------------------------------------------------------*/
PROCEDURE minus_right:
  DEFINE INPUT PARAMETER qbf_t AS INTEGER NO-UNDO.
  DEFINE VARIABLE qbf_b AS LOGICAL   NO-UNDO. /* scrap */
  DEFINE VARIABLE qbf_n AS CHARACTER NO-UNDO. /* tablename */
  DEFINE VARIABLE qbf_i AS INTEGER   NO-UNDO. /* loop/index */
  DEFINE VARIABLE qbf_c AS CHARACTER NO-UNDO. /* scrap */

  {&FIND_TABLE_BY_ID} qbf_t.
  qbf-tnam = qbf-rel-buf.tname.
  qbf_n  = {&INTERNAL_TO_SCREEN}.

  /* Remove this name from the "remove list" */
  DO qbf_i = 1 to qbf-s:NUM-ITEMS IN FRAME qbf-tbl:
    qbf_c = qbf-s:ENTRY(qbf_i) IN FRAME qbf-tbl.

    qbf-val = qbf_c.
    {&SCREEN_WO_FOR}  /* qbf-val = just the table name */
    IF qbf-val = qbf_n THEN DO: 
      RUN adecomm/_delitem.p (qbf-s:HANDLE in FRAME qbf-tbl, 
      	       	     	      qbf_c, OUTPUT cnt).
      LEAVE.
    END.
  END.

  /* Remove this description from the "remove list" */
  IF  (qbf-s&:LOOKUP(qbf-rel-buf.tdesc) IN FRAME qbf-tbl > 0) THEN
    RUN adecomm/_delitem.p (qbf-s&:HANDLE IN FRAME qbf-tbl, qbf-rel-buf.tdesc, 
      	       	     	    OUTPUT cnt).
  
  RUN unentry (STRING(qbf_t),INPUT-OUTPUT qbf-s%).

  /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     Only for fancy join support. (till end of routine)
  - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
  /* If user had specified a preferred join partner for qbf_t, remove
     it from the set.
  */
  RUN get_join_choice (STRING(qbf_t), OUTPUT qbf_i, OUTPUT qbf_c).
  
  IF qbf_i > 0 THEN 
    RUN unentry (ENTRY(qbf_i, qbf-rel-choice), INPUT-OUTPUT qbf-rel-choice).

  qbf-ok:SENSITIVE IN FRAME qbf-tbl = qbf-s% <> "".
END PROCEDURE. /* minus_right */

/*--------------------------------------------------------------------------*/
/* remove entry <param 1> from string <param 2> */
PROCEDURE unentry:
  DEFINE INPUT        PARAMETER qbf_t AS CHARACTER NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER qbf_o AS CHARACTER NO-UNDO.

  IF qbf_o = "" OR qbf_o = qbf_t THEN qbf_o = "".
  ELSE
  IF ENTRY(1,qbf_o) = qbf_t THEN
    qbf_o = SUBSTRING(qbf_o,INDEX(qbf_o,",":u) + 1,-1,"CHARACTER":u).
  ELSE
  IF ENTRY(NUM-ENTRIES(qbf_o),qbf_o) = qbf_t THEN
    qbf_o = SUBSTRING(qbf_o,1,R-INDEX(qbf_o,",":u) - 1,"CHARACTER":u).
  ELSE
  IF CAN-DO(qbf_o,qbf_t) THEN
    ASSIGN
      ENTRY(LOOKUP(qbf_t,qbf_o),qbf_o) = ""
      qbf_o = REPLACE(qbf_o,",,":u,",":u).
END PROCEDURE. /* unentry */

/*--------------------------------------------------------------------------*/
PROCEDURE get_joins:
  /* qbf_c = canonical join list, qbf-rel-tt.rels */
  /* qbf_p = purified join list */
  DEFINE INPUT  PARAMETER qbf_c AS CHARACTER            NO-UNDO.
  DEFINE OUTPUT PARAMETER qbf_p AS CHARACTER INITIAL "" NO-UNDO.

  DEFINE VARIABLE qbf_l AS INTEGER NO-UNDO. /* loop */

  DO qbf_l = 2 TO NUM-ENTRIES(qbf_c):
    qbf_p = qbf_p + (IF qbf_l = 2 THEN "" ELSE ",":u)
          + SUBSTRING(ENTRY(1,ENTRY(qbf_l,qbf_c),":":u),2,-1,"CHARACTER":u).
  END.
END PROCEDURE. /* get_joins */

/*--------------------------------------------------------------------------*/

/*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
  Not used unless we have fancy join support.
- - - - - - - - - - - - - - - - - */
/* For the entry corresponding to table id qbf_t 
   find the join partner, if any, and change qbf_n to include the proper
   FOR clause (e.g., "order (demo) for customer")
   
      qbf_s# - Only look through the first qbf_s# entries in qbf-s% since the
      	       join partner must come before the entry itself.
      qbf_t  - table id (from qbf-rel-tt)
      qbf_n  - screen representation w/o the FOR clause for table 
      	       corresponding to qbf_t
      qbf_j  - table id (string form) of the join partner, if one is found, 
      	       else 0.
*/
PROCEDURE join_partner:
  DEFINE INPUT        PARAMETER qbf_s# AS INTEGER   NO-UNDO.
  DEFINE INPUT        PARAMETER qbf_t  AS INTEGER   NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER qbf_n  AS CHARACTER NO-UNDO. 
  DEFINE OUTPUT       PARAMETER qbf_j  AS CHARACTER NO-UNDO INIT 0.

  DEFINE VARIABLE qbf_p AS INTEGER NO-UNDO INIT 0. /* pos in qbf-rel-tt.rels*/
  DEFINE VARIABLE qbf_cand AS INTEGER NO-UNDO. 	   /* join candidate */
  DEFINE VARIABLE qbf_w AS INTEGER NO-UNDO. /* pos in qbf-rel-whr array */
  DEFINE VARIABLE qbf_i AS INTEGER NO-UNDO. /* loop index */

  DO qbf_i = 1 TO qbf_s#:
    qbf_cand = INTEGER(ENTRY(qbf_i, qbf-s%)).
    RUN lookup_join (qbf_cand, qbf_t, OUTPUT qbf_p, OUTPUT qbf_w).
    IF qbf_p > 0 THEN DO:
      RUN add_for_phrase (qbf_cand, INPUT-OUTPUT qbf_n).
      qbf_j = STRING(qbf_cand).
      LEAVE.
    END.
  END.
END PROCEDURE.  /* join_partner */

/*--------------------------------------------------------------------------*/
/* Add the FOR phrase to the end of the table name.
      qbf_t = table id for join partner to specify in FOR phrase
      qbf_n = table name (in screen form) to be added to.
*/
PROCEDURE add_for_phrase:
  DEFINE INPUT        PARAMETER qbf_t AS INTEGER   NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER qbf_n AS CHARACTER NO-UNDO.

  DEFINE VARIABLE qbf_b AS LOGICAL NO-UNDO.   /* scrap */

  {&FIND_TABLE_BY_ID} qbf_t.
  qbf-tnam = qbf-rel-buf.tname.
  ASSIGN
    qbf_b = qbf-hidedb  /* save current value */
    qbf-hidedb = yes    /* don't need db name twice */
    qbf_n = qbf_n + " FOR " + {&INTERNAL_TO_SCREEN}
    qbf-hidedb = qbf_b. /* restore */
END. /* add_for_phrase */

/*--------------------------------------------------------------------------*/
/* Clear the left (available list) and refill it with the tables
   from the specified list.  If p_tbls is "ALL" THEN refill with all
   tables.
*/
PROCEDURE refill_left_list:
  DEFINE INPUT PARAMETER p_tbls AS CHARACTER NO-UNDO. /* list of join tables */
  
  DEFINE VARIABLE qbf_i AS INTEGER NO-UNDO. /* loop */ 
  DEFINE VARIABLE qbf_s AS INTEGER NO-UNDO. /* specific join table */

  ASSIGN
    qbf-a% = ""
    qbf-a:LIST-ITEMS IN FRAME qbf-tbl = ""
    qbf-a&:LIST-ITEMS IN FRAME qbf-tbl = "".

  IF p_tbls = "ALL":u THEN 
    FOR EACH qbf-rel-buf WHERE qbf-rel-buf.cansee USE-INDEX tnameix:
      RUN plus_left(yes, qbf-rel-buf.tid).
    END.
  ELSE
    DO qbf_i = 1 TO NUM-ENTRIES(p_tbls):
      qbf_s = INTEGER(ENTRY(qbf_i, p_tbls)).
      IF NOT CAN-DO(qbf-s%, STRING(qbf_s)) THEN 
	     RUN plus_left(yes, qbf_s).
    END.
END.

/*--------------------------------------------------------------------------*/
/*- - - - - - - - - - - - - - -
/* 
   Get the table (get qbf-rel-buf buffer) and the id of the last table 
   selected so far.  If there is no selected table left, return 0.
   (-- not used if we support fancy joins--)
*/
PROCEDURE get_last_tbl:
  DEFINE OUTPUT PARAMETER p_lastid AS INTEGER NO-UNDO.
  DEFINE VARIABLE qbf_i AS INTEGER NO-UNDO. 

  qbf_i = NUM-ENTRIES(qbf-s%).
  IF qbf_i = 0 THEN 
    p_lastid = 0.
  ELSE DO:
    p_lastid = INTEGER(ENTRY(qbf_i,qbf-s%)).
    {&FIND_TABLE_BY_ID} p_lastid.
  END.
END.
- - - - - - - - - - - - - - - -*/

/*--------------------------------------------------------------------------*/
/* alias_to_tbname */
{ aderes/s-alias.i }

/*--------------------------------------------------------------------------*/
/* lookup_table */
{ aderes/p-lookup.i }

/*--------------------------------------------------------------------------*/
/* lookup_join and get_join_choice */
{ aderes/p-join.i }

/* j-table2.p - end of file */
