/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * j-field2.p - side-by-side field picker
 */

&GLOBAL-DEFINE WIN95-BTN YES

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/j-define.i }
{ aderes/r-define.i }
{ aderes/j-clump.i NEW }
{ adecomm/adestds.i }
{ aderes/reshlp.i }

/*      Available Fields                               Selected Fields
+------------------------------+  +-----------+  +----------------------------+ 
| Cust-num  (demo.customer)  | |  |   Add>>   |  |                          | |
| Name      (demo.customer)  | |  +-----------+  |                          | | 
| Address   (demo.customer)  | |  +-----------+  |                          | | 
| Address2  (demo.customer)  | |  | <<Remove  |  |                          | |
| City      (demo.customer)  | |  +-----------+  |                          | |
| St        (demo.customer)  | |                 |                          | |
| Zip       (demo.customer)  | |                 |                          | | 
| Phone     (demo.customer)  | |                 |                          | | 
| Contact   (demo.customer)  | |                 |                          | | 
| Sales-rep (demo.customer)  | |  +-----------+  |                          | |
|                            | |  | Move Up   |  |                          | |
|                            | |  +-----------+  |                          | |
|                            | |  | Move Down |  |                          | |
+------------------------------+  +-----------+  +----------------------------+
   
  [ ] SHOW FIELD LABELS                          O Ascending   O Descending
                                               
 +----------+  +----------+                                        +----------+ 
 |    OK    |  |  Cancel  |                                        |   Help   |
 +----------+  +----------+                                        +----------+ 

*/

DEFINE INPUT PARAMETER qbf-t AS CHARACTER NO-UNDO. /* table list */
DEFINE INPUT PARAMETER qbf-p AS CHARACTER NO-UNDO. /* parameter string */
DEFINE INPUT PARAMETER qbf-g AS CHARACTER NO-UNDO. /* title */
DEFINE INPUT-OUTPUT PARAMETER qbf-o   AS CHARACTER.  /* output names */
DEFINE       OUTPUT PARAMETER qbf-chg AS LOGICAL NO-UNDO. /* changed? */

/*
qbf-p is parameter string:
   contains "$" - allow scalar database fields
   contains "#" - allow array database fields
   contains "@" - allow z-array expansion
   contains "!" - needs at least one field for OK to be sensitive
                  r=running_total, p=pct_of_total, c=counter,
                  s=string_exp, d=date_exp, n=numeric_exp, l=logical_exp,
                  e=stacked_array, x=lookup_field

                  The absence of "!" signifies sort mode (see qbf-k).

   contains any of "12345" - allow that dtype:
                  1=char 2=date 3=log 4=int 5=dec
   contains "=" - shorthand for all calc-fields and all database fields
                  same as "rpcsdnlex12345"
*/
&SCOPED-DEFINE Len 32

DEFINE VARIABLE qbf-b AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-h AS LOGICAL   NO-UNDO. /* hide file names? */
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO. /* scrap/loop */
DEFINE VARIABLE qbf-j AS INTEGER   NO-UNDO. /* scrap/help context */
DEFINE VARIABLE qbf-k AS LOGICAL   NO-UNDO. /* yes=sort, no=other */
DEFINE VARIABLE qbf-l AS CHARACTER NO-UNDO. /* original label layout */
DEFINE VARIABLE qbf-m AS LOGICAL   NO-UNDO. /* mode: true=avail, false=select */
DEFINE VARIABLE qbf-r AS CHARACTER NO-UNDO. /* original field list */
DEFINE VARIABLE qbf-x AS INTEGER   NO-UNDO. /* table index */
DEFINE VARIABLE qbf-y AS INTEGER   NO-UNDO. /* field index */
DEFINE VARIABLE qbf-z AS INTEGER   NO-UNDO. /* array(extent) index */

/*=================Frame Layout (Variables & Form)========================*/

DEFINE VARIABLE qbf-a    AS CHARACTER NO-UNDO. /* "available fields" sellist */
DEFINE VARIABLE qbf-a&   AS CHARACTER NO-UNDO. /* "available fields" descs */
DEFINE VARIABLE qbf-s    AS CHARACTER NO-UNDO. /* "selected fields" sellist */
DEFINE VARIABLE qbf-s&   AS CHARACTER NO-UNDO. /* "selected fields" descs */
DEFINE VARIABLE qbf-aa   AS CHARACTER NO-UNDO. /* "available fields" label */
DEFINE VARIABLE qbf-ss   AS CHARACTER NO-UNDO. /* "selected fields" label */

DEFINE VARIABLE qbf-acdc AS CHARACTER NO-UNDO 
  VIEW-AS RADIO-SET HORIZONTAL RADIO-BUTTONS "A&scending", "A":u, 
                                             "Des&cending", "D":u SIZE 30 BY 1.
DEFINE VARIABLE qbf-ord  AS CHARACTER NO-UNDO.

DEFINE BUTTON qbf-up   LABEL "Move &Up"   SIZE 14 BY 1.
DEFINE BUTTON qbf-dn   LABEL "Move &Down" SIZE 14 BY 1.
DEFINE BUTTON qbf-ad   LABEL "&Add >>"    SIZE 14 BY 1.
DEFINE BUTTON qbf-rm   LABEL "<< &Remove" SIZE 14 BY 1.
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
    VIEW-AS SELECTION-LIST MULTIPLE INNER-CHARS 30 INNER-LINES 10
    SCROLLBAR-V SCROLLBAR-H FONT 0 

  qbf-a	 AT ROW-OF qbf-a& COL-OF qbf-a& 
    VIEW-AS SELECTION-LIST MULTIPLE INNER-CHARS 30 INNER-LINES 10
    SCROLLBAR-V SCROLLBAR-H FONT 0

  qbf-ad AT COLUMN 32 ROW 2
  qbf-rm AT COLUMN 32 ROW 3
  qbf-up AT COLUMN 32 ROW 5
  qbf-dn AT COLUMN 32 ROW 6

  qbf-s& AT ROW-OF qbf-a& COL 60
    VIEW-AS SELECTION-LIST MULTIPLE INNER-CHARS 30 INNER-LINES 10
    SCROLLBAR-V SCROLLBAR-H FONT 0

  qbf-s	 AT ROW-OF qbf-s& COL-OF qbf-s&
    VIEW-AS SELECTION-LIST MULTIPLE INNER-CHARS 30 INNER-LINES 10
    SCROLLBAR-V SCROLLBAR-H FONT 0
  SKIP({&VM_WID})
	   
  qbf-toggle1  
    VIEW-AS TOGGLE-BOX LABEL "Show Field &Labels":t32

  qbf-acdc NO-LABEL
  SKIP({&VM_WID})

  {adecomm/okform.i
    &BOX    = rect_btns
    &STATUS = no
    &OK     = qbf-ok
    &CANCEL = qbf-ee
    &HELP   = qbf-help}

  WITH FRAME qbf-fld NO-LABELS THREE-D
  DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee
  TITLE "Select Fields" SCROLLABLE VIEW-AS DIALOG-BOX.

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

ON HELP OF FRAME qbf-fld OR CHOOSE OF qbf-help IN FRAME qbf-fld
  RUN adecomm/_adehelp.p ("res":u,"CONTEXT":u,qbf-j,?).
                          
ON ENTRY OF qbf-a&, qbf-a, qbf-s&, qbf-s IN FRAME qbf-fld
  RUN SetUpDown.

ON ALT-V OF FRAME qbf-fld DO:
  IF qbf-toggle1 THEN
    APPLY "ENTRY":u TO qbf-a& IN FRAME qbf-fld.
  ELSE
    APPLY "ENTRY":u TO qbf-a  IN FRAME qbf-fld.
END.

ON ALT-E OF FRAME qbf-fld DO:
  IF qbf-toggle1 THEN
    APPLY "ENTRY":u TO qbf-s& IN FRAME qbf-fld.
  ELSE
    APPLY "ENTRY":u TO qbf-s  IN FRAME qbf-fld.
END.
  
ON GO OF FRAME qbf-fld DO:
  DEFINE VARIABLE qbf_c	 AS CHARACTER NO-UNDO. /* scrap */
  DEFINE VARIABLE qbf_j	 AS INTEGER   NO-UNDO. /* scrap/loop */
  DEFINE VARIABLE qbf_l  AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE qbf_o	 AS CHARACTER NO-UNDO. /* temp output */
  DEFINE VARIABLE qbf_t  AS CHARACTER NO-UNDO. /* list of table names */
  DEFINE VARIABLE qbf_v	 AS CHARACTER NO-UNDO. /* value */
  DEFINE VARIABLE qbf_x	 AS INTEGER   NO-UNDO. /* table index */
  DEFINE VARIABLE qbf_y	 AS INTEGER   NO-UNDO. /* field index */
  DEFINE VARIABLE qbf_z	 AS INTEGER   NO-UNDO. /* array index */
  DEFINE VARIABLE qbf_xs AS CHARACTER NO-UNDO. /* list of table indexes*/

  IF qbf-k THEN DO:
    IF NUM-ENTRIES(qbf-ord) > 16 THEN DO:
      RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf_l,"error":u,"ok":u, 
        SUBSTITUTE('You have selected &1 sort fields, but the maximum is 16. Suggest you shorten the list by deleting &2 field(s).', 
        NUM-ENTRIES(qbf-ord),NUM-ENTRIES(qbf-ord) - 16)).
      
      RETURN NO-APPLY.
    END.
        
    qbf-o = qbf-ord.
  END.
  ELSE DO:  
    qbf_j = qbf-s:NUM-ITEMS IN FRAME qbf-fld.
    IF qbf_j > EXTENT(qbf-rcn) THEN DO:
      RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf_l,"error":u,"ok":u, 
        SUBSTITUTE('You have selected &1 fields, but the maximum is &2.  Suggest you shorten the list by deleting &3 field(s).', 
        qbf_j,EXTENT(qbf-rcn),qbf_j - EXTENT(qbf-rcn))).
      
      RETURN NO-APPLY.
    END.

    ASSIGN 
      qbf-o  = ""
      qbf_xs = ""
      qbf_v  = (IF qbf-toggle1 THEN
                  qbf-s&:LIST-ITEMS IN FRAME qbf-fld
                ELSE
                  qbf-s:LIST-ITEMS IN FRAME qbf-fld).
  
    RUN adecomm/_setcurs.p ("WAIT":u).
    DO qbf_j = 1 TO NUM-ENTRIES(qbf_v,CHR(3)):
      IF qbf-toggle1 THEN
        RUN xlookup_label
          (ENTRY(qbf_j,qbf_v,CHR(3)),OUTPUT qbf_x,OUTPUT qbf_y,OUTPUT qbf_z).
      ELSE
        RUN xlookup_name
          (ENTRY(qbf_j,qbf_v,CHR(3)),OUTPUT qbf_x,OUTPUT qbf_y,OUTPUT qbf_z).
       
      RUN xreturn_truename (qbf_x,qbf_y,qbf_z,OUTPUT qbf_o).

      /* keep track of table indices for all fields selected */
      IF NOT CAN-DO(qbf_xs,STRING(qbf_x)) THEN
        qbf_xs = qbf_xs + (IF qbf_xs = "" THEN "" ELSE ",":u) + STRING(qbf_x).
  
      qbf-o = qbf-o + (IF qbf-o = "" THEN "" ELSE ",":u) + qbf_o.
    END. /* qbf_j loop */

    /* Before we're happy, see if there's at least one field from each
       table.  If not, ask the user "What's up doc?".  */
    qbf_t = "".
    DO qbf_j = 1 TO NUM-ENTRIES(qbf-tables):
      qbf_c = ENTRY(qbf_j,qbf-tables).
      
      IF NOT CAN-DO(qbf_xs,qbf_c) THEN DO:
        {&FIND_TABLE_BY_ID} INTEGER(qbf_c).
        qbf_t = qbf_t 
              + (IF qbf_t = "" THEN "" ELSE ", ":u)
              + qbf-rel-buf.tname.
      END.
    END.
    IF qbf_t <> "" THEN DO:
      qbf_l = yes.
      RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf_l,"warning":u,"ok-cancel":u, 
        SUBSTITUTE("You have not chosen any fields from the following tables:^^&1^^This may have an undesirable effect on the returned record set (you may get less records than you expect).^^Press OK if these are the fields you want.  You may then want to select 'Add/Remove Tables' to remove the table(s) for which no fields have been selected.^^Press Cancel to choose more fields.",qbf_t)).

      IF qbf_l = ? THEN DO:
        RUN adecomm/_setcurs.p ("").
        RETURN NO-APPLY. 
      END.
    END.
  END. /* not in sort field mode */
  
  IF qbf-o <> qbf-r THEN
    ASSIGN
      qbf-chg    = TRUE
      qbf-dirty  = TRUE 
      qbf-redraw = TRUE.
END. /* ON GO... */

ON CHOOSE OF qbf-up IN FRAME qbf-fld DO:
  DEFINE VARIABLE s_widg  AS HANDLE NO-UNDO.

  {adecomm/2lstdef.i}

  s_widg = IF qbf-toggle1 THEN qbf-s&:HANDLE IN FRAME qbf-fld
                          ELSE qbf-s:HANDLE IN FRAME qbf-fld.

  /* We have to keep two pick lists up to date. */
  IF qbf-toggle1:SCREEN-VALUE IN FRAME qbf-fld = "no" THEN DO:
    {adecomm/2lstup.i &pick_list_w   = qbf-s
                      &shadow_list_w = qbf-s&
                      &frame         = qbf-fld}
  END.
  ELSE DO:
    {adecomm/2lstup.i &pick_list_w   = qbf-s&
                      &shadow_list_w = qbf-s
                      &frame         = qbf-fld}
  END.

  RUN SetUpDown.
  
  IF qbf-k THEN
    RUN fixacdc ("order":u,?,?,?).

  IF s_widg:SCREEN-VALUE <> ? THEN
    RUN adecomm/_scroll.p (s_widg, s_widg:SCREEN-VALUE).
END.

ON CHOOSE OF qbf-dn IN FRAME qbf-fld DO:
  DEFINE VARIABLE s_widg  AS HANDLE NO-UNDO.

  {adecomm/2lstdef.i}
    
  s_widg = IF qbf-toggle1 THEN qbf-s&:HANDLE IN FRAME qbf-fld
                          ELSE qbf-s:HANDLE  IN FRAME qbf-fld.

  /* We have to keep two pick lists up to date. */
  IF qbf-toggle1:SCREEN-VALUE IN FRAME qbf-fld = "no" THEN DO:
    {adecomm/2lstdn.i &pick_list_w   = qbf-s
                      &shadow_list_w = qbf-s&
                      &frame         = qbf-fld}
  END.
  
  /* user showing field labels */
  ELSE DO:
    {adecomm/2lstdn.i &pick_list_w   = qbf-s&
                      &shadow_list_w = qbf-s
                      &frame         = qbf-fld}
  END.       
   
  RUN SetUpDown.

  IF qbf-k THEN
    RUN fixacdc ("order":u,?,?,?).

  IF s_widg:SCREEN-VALUE <> ? THEN
    RUN adecomm/_scroll.p (s_widg, s_widg:SCREEN-VALUE).
END.

/* add field to list */
ON   CHOOSE         OF qbf-ad        IN FRAME qbf-fld
  OR DEFAULT-ACTION OF qbf-a&, qbf-a IN FRAME qbf-fld DO:

  DEFINE VARIABLE qbf_x   AS INTEGER   NO-UNDO. /* table index */
  DEFINE VARIABLE qbf_y   AS INTEGER   NO-UNDO. /* field index */
  DEFINE VARIABLE qbf_z   AS INTEGER   NO-UNDO. /* array index */
  DEFINE VARIABLE ix      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE choices AS CHARACTER NO-UNDO.
  DEFINE VARIABLE choice  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE s_widg  AS HANDLE    NO-UNDO.
  
  IF qbf-a:SCREEN-VALUE IN FRAME qbf-fld <> ? THEN DO:
    RUN adecomm/_setcurs.p ("WAIT").
    /* Retrieve the user's choices. Then loop through all of the
       choices and move each one to the other list.  */
    choices = qbf-a:SCREEN-VALUE IN FRAME qbf-fld.

    DO ix = 1 TO NUM-ENTRIES(choices,CHR(3)):
      choice = ENTRY(ix,choices,CHR(3)).
      RUN xlookup_name (choice,OUTPUT qbf_x,OUTPUT qbf_y,OUTPUT qbf_z).
      RUN left_to_right (qbf_x,qbf_y,qbf_z,qbf-k).
    END.

    ASSIGN
      s_widg = IF qbf-toggle1 THEN qbf-s&:HANDLE IN FRAME qbf-fld
                              ELSE qbf-s:HANDLE IN FRAME qbf-fld
      s_widg:SCREEN-VALUE = ""
      s_widg:SCREEN-VALUE = s_widg:ENTRY(s_widg:NUM-ITEMS)
      qbf-acdc:SENSITIVE IN FRAME qbf-fld = qbf-k AND 
        (IF qbf-toggle1 THEN
           INDEX(qbf-s&:SCREEN-VALUE IN FRAME qbf-fld,CHR(3)) = 0
         ELSE
           INDEX(qbf-s:SCREEN-VALUE IN FRAME qbf-fld,CHR(3)) = 0)
      .

    /* Deal with multiple, discontiguous selects. Only have
       one selection after the move is done.  */

    IF NUM-ENTRIES(qbf-a:SCREEN-VALUE,CHR(3)) > 1 THEN DO:
      /* The extra assignment is to work around a bug with
         multiple selection lists */
      ASSIGN
        qbf-c              = ENTRY(1,qbf-a:SCREEN-VALUE,CHR(3))
        qbf-a:SCREEN-VALUE = ""
        qbf-a:SCREEN-VALUE = qbf-c
        qbf-c               = ENTRY(1,qbf-a&:SCREEN-VALUE,CHR(3))
        qbf-a&:SCREEN-VALUE = ""
        qbf-a&:SCREEN-VALUE = qbf-c
      .
    END.      

    RUN SetUpDown.

    IF s_widg:SCREEN-VALUE <> ? THEN
      RUN adecomm/_scroll.p (s_widg, s_widg:SCREEN-VALUE).
    RUN adecomm/_setcurs.p ("").
  END.
END.
       
/* remove field from list */
ON   CHOOSE         OF qbf-rm        IN FRAME qbf-fld
  OR DEFAULT-ACTION OF qbf-s&, qbf-s IN FRAME qbf-fld
  OR APPEND-LINE    OF                  FRAME qbf-fld
  OR RECALL         OF                  FRAME qbf-fld DO:
     
  DEFINE VARIABLE qbf_o   AS CHARACTER NO-UNDO. /* temp output */
  DEFINE VARIABLE qbf_x   AS INTEGER   NO-UNDO. /* table index */
  DEFINE VARIABLE qbf_y   AS INTEGER   NO-UNDO. /* field index */
  DEFINE VARIABLE qbf_z   AS INTEGER   NO-UNDO. /* array index */
  DEFINE VARIABLE ix      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE choices AS CHARACTER NO-UNDO.
  DEFINE VARIABLE choice  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE s_widg  AS HANDLE    NO-UNDO.

  IF qbf-s:SCREEN-VALUE IN FRAME qbf-fld <> ? THEN DO:
    RUN adecomm/_setcurs.p ("WAIT":u).

    /* Retrieve the user's choices. Then loop through all of the
       choices and move each one to the other list. */
    choices = qbf-s:SCREEN-VALUE IN FRAME qbf-fld.

    FIND FIRST qbf-rsys WHERE qbf-rsys.qbf-live.

    DO ix = 1 TO NUM-ENTRIES(choices,CHR(3)):
      ASSIGN
        qbf-b  = TRUE
        choice = ENTRY(ix,choices,CHR(3)).
      
      RUN xlookup_name (choice,OUTPUT qbf_x,OUTPUT qbf_y,OUTPUT qbf_z).

      RUN xreturn_truename (qbf_x,qbf_y,qbf_z,OUTPUT qbf_o).
      
      IF qbf-k AND qbf-rsys.qbf-page-eject = qbf_o THEN DO:
        RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-b,"warning":u,"ok-cancel":u,
          SUBSTITUTE('You are about to remove the Sort field "&1" on which the Page Break feature depends.^^Do you want to continue?',
          qbf-rsys.qbf-page-eject)).

        IF qbf-b THEN
          qbf-rsys.qbf-page-eject = "".
      END.
 
      IF qbf-b THEN DO:
        RUN right_to_left (qbf_x,qbf_y,qbf_z).

        IF qbf-k THEN
          RUN fixacdc ("remove":u,qbf_x,qbf_y,qbf_z).
      
        IF qbf-s:LIST-ITEMS IN FRAME qbf-fld = ? THEN
          APPLY "ENTRY":u TO qbf-a IN FRAME qbf-fld.
      END.
    END.

    /* reset asc/desc toggle screen value */
    IF qbf-s:LIST-ITEMS IN FRAME qbf-fld <> ? AND qbf-k THEN DO:
      IF qbf-toggle1 THEN
        RUN xlookup_label (qbf-s&:SCREEN-VALUE IN FRAME qbf-fld,
                           OUTPUT qbf_x,OUTPUT qbf_y,OUTPUT qbf_z).
      ELSE
        RUN xlookup_name (qbf-s:SCREEN-VALUE IN FRAME qbf-fld,
                          OUTPUT qbf_x,OUTPUT qbf_y,OUTPUT qbf_z).

      RUN xreturn_truename (qbf_x,qbf_y,qbf_z,OUTPUT qbf_o).

      ASSIGN
        qbf-c = ENTRY(LOOKUP(qbf_o,REPLACE(qbf-ord," DESC":u,"")),qbf-ord)
        qbf-acdc:SCREEN-VALUE IN FRAME qbf-fld = 
          IF qbf-c MATCHES "* DESC":u THEN "D" ELSE "A".
    END.
    
    s_widg = IF qbf-toggle1 THEN qbf-a&:HANDLE IN FRAME qbf-fld
                            ELSE qbf-a:HANDLE  IN FRAME qbf-fld.

    IF s_widg:SCREEN-VALUE = ? THEN 
      s_widg:SCREEN-VALUE = s_widg:ENTRY(1).

    /*
     * Deal with multiple, discontiguous selects. Only have
     * one selection after the move is done.
     */
    IF NUM-ENTRIES(qbf-s:SCREEN-VALUE,CHR(3)) > 1 THEN DO:
      /* The extra assignment is to work around a bug with
         multiple selection lists */
      ASSIGN
        qbf-c               = ENTRY(1,qbf-s:SCREEN-VALUE,CHR(3))
        qbf-s:SCREEN-VALUE  = ""
        qbf-s:SCREEN-VALUE  = qbf-c
        qbf-c               = ENTRY(1,qbf-s&:SCREEN-VALUE,CHR(3))
        qbf-s&:SCREEN-VALUE = ""
        qbf-s&:SCREEN-VALUE = qbf-c
      .
    END.      
  
    RUN SetUpDown.
    RUN adecomm/_setcurs.p ("").
  END.
END.

ON VALUE-CHANGED OF qbf-a&, qbf-a, qbf-s&, qbf-s IN FRAME qbf-fld DO:
  RUN SetUpDown.
  
  IF qbf-k THEN DO:
    IF NUM-ENTRIES(qbf-s:SCREEN-VALUE IN FRAME qbf-fld,CHR(3)) = 1 THEN
      RUN fixacdc ("valchg":u,?,?,?).
    ELSE
      qbf-acdc:SENSITIVE IN FRAME qbf-fld = FALSE.
  END.                                                        
END.
  
ON VALUE-CHANGED OF qbf-toggle1 IN FRAME qbf-fld DO:
  DEFINE VARIABLE a_widg AS HANDLE NO-UNDO.
  DEFINE VARIABLE s_widg AS HANDLE NO-UNDO.

  ASSIGN
    qbf-toggle1                     = INPUT FRAME qbf-fld qbf-toggle1
    qbf-a:VISIBLE  IN FRAME qbf-fld = NOT qbf-toggle1
    qbf-a&:VISIBLE IN FRAME qbf-fld = qbf-toggle1
    qbf-s:VISIBLE  IN FRAME qbf-fld = NOT qbf-toggle1
    qbf-s&:VISIBLE IN FRAME qbf-fld = qbf-toggle1
  .

  /* scroll list so at least first selected item is in view */
  IF qbf-toggle1 THEN 
    ASSIGN
      a_widg = qbf-a&:HANDLE IN FRAME qbf-fld
      s_widg = qbf-s&:HANDLE IN FRAME qbf-fld.
  ELSE
    ASSIGN
      a_widg = qbf-a:HANDLE IN FRAME qbf-fld
      s_widg = qbf-s:HANDLE IN FRAME qbf-fld.

  IF a_widg:SCREEN-VALUE <> ? THEN
    RUN adecomm/_scroll.p (a_widg, ENTRY(1,a_widg:SCREEN-VALUE)).
  IF s_widg:SCREEN-VALUE <> ? THEN
    RUN adecomm/_scroll.p (s_widg, ENTRY(1,s_widg:SCREEN-VALUE)).
END.

ON ALT-S, ALT-C OF FRAME qbf-fld 
  OR VALUE-CHANGED OF qbf-acdc IN FRAME qbf-fld DO:
  ASSIGN qbf-acdc.
  If qbf-k THEN
    RUN fixacdc ("set":u,?,?,?).
END.

ON CHOOSE OF qbf-ee OR WINDOW-CLOSE OF FRAME qbf-fld DO:
  qbf-o = IF qbf-k THEN qbf-l ELSE qbf-r.
  APPLY "END-ERROR":u TO SELF.             
END.

/*==============================Mainline Code==============================*/
  
DO ON ERROR UNDO, LEAVE:
  IF INDEX(qbf-p,"!":u) = 0 THEN qbf-k = TRUE.

  /* Do Frame adjustments (title and layout changes) */
  IF qbf-k THEN 
    ASSIGN
      FRAME qbf-fld:TITLE = "Sort Order Fields"
      qbf-j               = {&Select_Sort_Order_Fields_Dlg_Box}.
  ELSE
    ASSIGN
      FRAME qbf-fld:TITLE = "Add/Remove Fields"
      qbf-j               = {&Add_Remove_Fields_Dlg_Box}.
  
  ASSIGN
    qbf-ord                        = qbf-sortby
    qbf-l                          = qbf-sortby
    qbf-r                          = qbf-o
    qbf-aa                         = " ":u + "A&vailable Fields":t33 + ": ":u
    qbf-ss                         = " ":u + "S&elected Fields":t33 + ": ":u
    qbf-aa:SCREEN-VALUE IN FRAME qbf-fld  = qbf-aa
    qbf-ss:SCREEN-VALUE IN FRAME qbf-fld  = qbf-ss
 
    qbf-a:DELIMITER IN FRAME qbf-fld  = CHR(3)
    qbf-a&:DELIMITER IN FRAME qbf-fld = CHR(3)
    qbf-s:DELIMITER IN FRAME qbf-fld  = CHR(3)
    qbf-s&:DELIMITER IN FRAME qbf-fld = CHR(3)
 
    /* put run-time adjustment for screen resolution & font here, 
       before frame is visible */
    qbf-a:WIDTH IN FRAME qbf-fld  =
      qbf-a:WIDTH IN FRAME qbf-fld - shrink-hor-2
    qbf-a&:WIDTH IN FRAME qbf-fld =
      qbf-a&:WIDTH IN FRAME qbf-fld - shrink-hor-2
    qbf-s:WIDTH IN FRAME qbf-fld  =
      qbf-s:WIDTH IN FRAME qbf-fld - shrink-hor-2
    qbf-s&:WIDTH IN FRAME qbf-fld =
      qbf-s&:WIDTH IN FRAME qbf-fld - shrink-hor-2
  
    qbf-ad:X IN FRAME qbf-fld = qbf-a:X IN FRAME qbf-fld
                              + qbf-a:WIDTH-PIXELS IN FRAME qbf-fld + 4
    qbf-rm:X IN FRAME qbf-fld = qbf-ad:X IN FRAME qbf-fld
    qbf-up:X IN FRAME qbf-fld = qbf-ad:X IN FRAME qbf-fld
    qbf-dn:X IN FRAME qbf-fld = qbf-ad:X IN FRAME qbf-fld
  
    qbf-ad:Y IN FRAME qbf-fld = qbf-a:Y IN FRAME qbf-fld
    qbf-rm:Y IN FRAME qbf-fld = qbf-ad:Y IN FRAME qbf-fld
                              + qbf-ad:HEIGHT-PIXELS IN FRAME qbf-fld + 3
    qbf-dn:Y IN FRAME qbf-fld = qbf-a:Y IN FRAME qbf-fld
	                      + qbf-a:HEIGHT-PIXELS IN FRAME qbf-fld
	                      - qbf-dn:HEIGHT-PIXELS IN FRAME qbf-fld * 2
    qbf-up:Y IN FRAME qbf-fld = qbf-dn:Y IN FRAME qbf-fld
	                      - qbf-up:HEIGHT-PIXELS IN FRAME qbf-fld - 3
  
    qbf-s:X  IN FRAME qbf-fld = qbf-ad:X IN FRAME qbf-fld
	                      + qbf-ad:WIDTH-PIXELS IN FRAME qbf-fld + 4
    qbf-s&:X IN FRAME qbf-fld = qbf-s:X IN FRAME qbf-fld
  
    qbf-aa:X IN FRAME qbf-fld = qbf-a:X IN FRAME qbf-fld
    qbf-ss:X IN FRAME qbf-fld = qbf-s:X IN FRAME qbf-fld
    qbf-toggle1:X IN FRAME qbf-fld       = qbf-a:X IN FRAME qbf-fld
    qbf-acdc:X IN FRAME qbf-fld          = qbf-s:X IN FRAME qbf-fld
    qbf-aa:WIDTH-PIXELS IN FRAME qbf-fld = qbf-a:WIDTH-PIXELS IN FRAME qbf-fld
    qbf-ss:WIDTH-PIXELS IN FRAME qbf-fld = qbf-s:WIDTH-PIXELS IN FRAME qbf-fld 
    qbf-acdc:VISIBLE IN FRAME qbf-fld    = FALSE
  
    FRAME qbf-fld:VIRTUAL-WIDTH-PIXELS   = qbf-s:X IN FRAME qbf-fld + 10
					 + qbf-s:WIDTH-PIXELS IN FRAME qbf-fld
    FRAME qbf-fld:WIDTH-PIXELS           = FRAME qbf-fld:VIRTUAL-WIDTH-PIXELS
    .
  
  /* Manage the watch cursor ourselves */
  &UNDEFINE TURN-OFF-CURSOR

  /* Run time layout for button area.  This defines eff_frame_width */
  {adecomm/okrun.i  
     &FRAME = "FRAME qbf-fld" 
     &BOX   = "rect_btns"
     &OK    = "qbf-ok" 
     &HELP  = "qbf-help"
  }
  /* end of frame adjustments */
  
  /* must sort table-ids for later binary searches to work properly */
  RUN aderes/s-vector.p (FALSE,",":u,INPUT-OUTPUT qbf-t).
  
  /* Set up the qbf-clump temp table with the current set of tables/fields. */
  RUN aderes/j-clump.p (qbf-p, qbf-t).
  PAUSE 0.
  
  qbf-h = qbf-hidedb. /* if db hidden, then maybe table also can be hidden? */
  
  FIND FIRST qbf-clump NO-ERROR.
  IF NOT AVAILABLE qbf-clump THEN RETURN. /* no tables selected */
  IF qbf-clump.qbf-cfil = 0 THEN
    qbf-h = FALSE. /* if calc present, don't */

  FIND NEXT qbf-clump NO-ERROR.
  IF AVAILABLE qbf-clump THEN
    qbf-h = FALSE. /* if >1 table present, don't */
 
  /* Fill up the left side lists */
  FOR EACH qbf-clump:
    ASSIGN
      qbf-z              = 0
      qbf-clump.qbf-cone = 1
      qbf-clump.qbf-ctwo = 1.

    IF qbf-clump.qbf-cfil > 0 THEN DO qbf-i = 1 TO qbf-csiz:
      IF qbf-clump.qbf-cext[qbf-i] > 0 THEN
        ASSIGN
          qbf-z = LENGTH(STRING(qbf-clump.qbf-cext[qbf-i]),"RAW":u) + 2
          qbf-clump.qbf-cnam[qbf-i] = qbf-clump.qbf-cnam[qbf-i] + "[]":u
	  qbf-clump.qbf-clbl[qbf-i] = qbf-clump.qbf-clbl[qbf-i] + "[]":u.
      ASSIGN
       qbf-clump.qbf-cone = MAXIMUM(qbf-clump.qbf-cone,
	                    LENGTH(qbf-clump.qbf-cnam[qbf-i],"RAW":u) + qbf-z)
       qbf-clump.qbf-ctwo = MAXIMUM(qbf-clump.qbf-ctwo,
	                    LENGTH(qbf-clump.qbf-clbl[qbf-i],"RAW":u) + qbf-z)
       qbf-z              = 0.
    END.
  
    DO qbf-i = 1 TO qbf-csiz:
      RUN xreturn_name (qbf-clump.qbf-cfil, qbf-i, 0, OUTPUT qbf-c).
  
      /* If the value is NULL then the field is restricted from the user */
      IF qbf-c <> ? THEN DO:
	qbf-b = qbf-a:ADD-LAST(qbf-c) IN FRAME qbf-fld.
  
        RUN xreturn_label (qbf-clump.qbf-cfil, qbf-i,0, OUTPUT qbf-c).
    
        qbf-b = qbf-a&:ADD-LAST(qbf-c) IN FRAME qbf-fld.
      END.
    END.
  END.
  
  /* Move the selected fields to the right side.  As we go, count the
     number of occurrences for each extent field (ef). If all array 
     entries are moved to the right, we'll remove the xx[] element on 
     the left.
  */
  DO qbf-i = 1 TO NUM-ENTRIES(qbf-o): 
    qbf-c = ENTRY(qbf-i,qbf-o).

    RUN xlookup_truename (qbf-c,OUTPUT qbf-x,OUTPUT qbf-y,OUTPUT qbf-z).

    /* 'array subscript 0 is out of range' error here with calc field? */
    RUN left_to_right (qbf-x,qbf-y,qbf-z, no).

    IF qbf-z > 0 THEN DO:
      FIND qbf-clump WHERE qbf-clump.qbf-cfil = qbf-x.
      qbf-clump.qbf-ccnt[qbf-y] = qbf-clump.qbf-ccnt[qbf-y] + 1.
    END.
  END.
  
  FOR EACH qbf-clump:
    DO qbf-i = 1 TO qbf-clump.qbf-csiz:
      IF qbf-clump.qbf-ccnt[qbf-i] > 0 AND 
	 qbf-clump.qbf-ccnt[qbf-i] = qbf-clump.qbf-cext[qbf-i] THEN DO:

	RUN xreturn_name (qbf-clump.qbf-cfil,qbf-i,0,OUTPUT qbf-c ).
     
	qbf-b = qbf-a:DELETE(qbf-c) IN FRAME qbf-fld.

	RUN xreturn_label (qbf-clump.qbf-cfil,qbf-i,0,OUTPUT qbf-c).

	qbf-b = qbf-a&:DELETE(qbf-c) IN FRAME qbf-fld.
      END.
    END.
  END.

  PAUSE 0.
  IF qbf-g <> "" THEN 
    FRAME qbf-fld:TITLE = qbf-g.
END.  /* end do on error block */
RUN adecomm/_setcurs.p ("").

DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
  DISPLAY qbf-toggle1 WITH FRAME qbf-fld.
  
  ASSIGN
    qbf-ad:SENSITIVE IN FRAME qbf-fld      = TRUE
    qbf-rm:SENSITIVE IN FRAME qbf-fld      = FALSE
    qbf-ee:SENSITIVE IN FRAME qbf-fld      = TRUE
    qbf-help:SENSITIVE IN FRAME qbf-fld    = TRUE
    qbf-toggle1:SENSITIVE IN FRAME qbf-fld = TRUE
    qbf-a:SENSITIVE  IN FRAME qbf-fld      = TRUE
    qbf-a&:SENSITIVE IN FRAME qbf-fld      = TRUE
    qbf-a:VISIBLE  IN FRAME qbf-fld        = NOT qbf-toggle1
    qbf-a&:VISIBLE IN FRAME qbf-fld        = qbf-toggle1
    qbf-s:SENSITIVE  IN FRAME qbf-fld      = TRUE
    qbf-s&:SENSITIVE IN FRAME qbf-fld      = TRUE
    qbf-s:VISIBLE  IN FRAME qbf-fld        = NOT qbf-toggle1
    qbf-s&:VISIBLE IN FRAME qbf-fld        = qbf-toggle1
    qbf-ok:SENSITIVE IN FRAME qbf-fld      = (qbf-k 
                             OR qbf-s:NUM-ITEMS IN FRAME qbf-fld > 0)
  .
  /* The NO-ERROR here is dangerous but will nicely mask the error if ? is
     assigned to screen-value. This error can be ignored with no advers side 
     effects. */
  ASSIGN
    qbf-s:SCREEN-VALUE  IN FRAME qbf-fld = ""
    qbf-s&:SCREEN-VALUE IN FRAME qbf-fld = ""
    qbf-a:SCREEN-VALUE  IN FRAME qbf-fld = ""
    qbf-a&:SCREEN-VALUE IN FRAME qbf-fld = ""
    qbf-s:SCREEN-VALUE  IN FRAME qbf-fld = qbf-s:ENTRY(1)  IN FRAME qbf-fld
    qbf-s&:SCREEN-VALUE IN FRAME qbf-fld = qbf-s&:ENTRY(1) IN FRAME qbf-fld
    qbf-a:SCREEN-VALUE  IN FRAME qbf-fld = qbf-a:ENTRY(1)  IN FRAME qbf-fld
    qbf-a&:SCREEN-VALUE IN FRAME qbf-fld = qbf-a&:ENTRY(1) IN FRAME qbf-fld

    qbf-acdc:VISIBLE   IN FRAME qbf-fld  = qbf-k AND
      (IF qbf-toggle1 THEN
         qbf-s&:SCREEN-VALUE IN FRAME qbf-fld <> ?
       ELSE
         qbf-s:SCREEN-VALUE IN FRAME qbf-fld <> ?)
    qbf-acdc:SENSITIVE IN FRAME qbf-fld  = qbf-acdc:VISIBLE IN FRAME qbf-fld
    NO-ERROR.

  IF qbf-toggle1 THEN
    APPLY "ENTRY":u TO qbf-a& IN FRAME qbf-fld.
  ELSE
    APPLY "ENTRY":u TO qbf-a IN FRAME qbf-fld.
    
  IF qbf-k AND qbf-s:NUM-ITEMS IN FRAME qbf-fld > 0 THEN
    RUN fixacdc ("valchg":u,?,?,?).

  WAIT-FOR GO OF FRAME qbf-fld.
END.

HIDE FRAME qbf-fld NO-PAUSE.
RETURN.

/*==========================Internal Procedures=============================*/

/*---------------------------------------------------------------------
  Purpose: This function sets the add, remove, up, down button status. 
    It also make sure the parallel lists are kept in sync.
  Run Syntax:  RUN SetUpDown.
  Parameters:  
  Notes:       
----------------------------------------------------------------------*/
PROCEDURE SetUpDown:
  DEFINE VARIABLE ix         AS INTEGER  NO-UNDO.
  DEFINE VARIABLE iTop       AS INTEGER  NO-UNDO.
  DEFINE VARIABLE iBottom    AS INTEGER  NO-UNDO.
  DEFINE VARIABLE wCurrent-a AS HANDLE   NO-UNDO.
  DEFINE VARIABLE wCurrent-s AS HANDLE   NO-UNDO.
  DEFINE VARIABLE wOther-a   AS HANDLE   NO-UNDO.
  DEFINE VARIABLE wOther-s   AS HANDLE   NO-UNDO.
  
  DO WITH FRAME qbf-fld:
    /* Set current available and selected list based on who is visible. */
    IF (qbf-a:VISIBLE IN FRAME qbf-fld) THEN
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
    /* Set the Add Remove sensitivity. Figure out what the top and bottom index 
       are for the Selected list and the set Up and Down sensitivity based on 
       those values.
     */
    ASSIGN
      qbf-ad:SENSITIVE      = (wCurrent-a:SCREEN-VALUE NE ?)
      qbf-rm:SENSITIVE      = (wCurrent-s:SCREEN-VALUE NE ?)
      iTop                  =  
        wCurrent-s:LOOKUP(ENTRY(1,wCurrent-s:SCREEN-VALUE,CHR(3)))
      iBottom               =  
        wCurrent-s:LOOKUP(ENTRY(NUM-ENTRIES(wCurrent-s:SCREEN-VALUE,CHR(3)),
                                wCurrent-s:SCREEN-VALUE,CHR(3)))
      qbf-up:SENSITIVE      = (IF iTop > 1 THEN TRUE ELSE FALSE)
      qbf-dn:SENSITIVE      = (IF iBottom < wCurrent-s:NUM-ITEMS 
                                  THEN TRUE ELSE FALSE)
      wOther-a:SCREEN-VALUE = ""
      wOther-s:SCREEN-VALUE = ""
      .
    /* Set the invisible list to match the visible one for Selected. */
  
    DO ix = 1 TO NUM-ENTRIES(wCurrent-s:SCREEN-VALUE,CHR(3)):
      ASSIGN
        iTop                  = 
          wCurrent-s:LOOKUP(ENTRY(ix,wCurrent-s:SCREEN-VALUE,CHR(3)))
        wOther-s:SCREEN-VALUE = wOther-s:ENTRY(iTop)
      .
    END.   
  
    /* Set the invisible list to match the visible one for Available. */
    DO ix = 1 TO NUM-ENTRIES(wCurrent-a:SCREEN-VALUE,CHR(3)):
      ASSIGN
        iTop                  = 
          wCurrent-a:LOOKUP(ENTRY(ix,wCurrent-a:SCREEN-VALUE,CHR(3)))
        wOther-a:SCREEN-VALUE = wOther-a:ENTRY(iTop)
      .
    END.   
  END.
END PROCEDURE.
  
/*---------------------------------------------------------------------------*/

PROCEDURE left_to_right:
  DEFINE INPUT PARAMETER qbf_x	  AS INTEGER NO-UNDO. /* table index */
  DEFINE INPUT PARAMETER qbf_y	  AS INTEGER NO-UNDO. /* field index */
  DEFINE INPUT PARAMETER qbf_z	  AS INTEGER NO-UNDO. /* array(extent) index */
  DEFINE INPUT PARAMETER qbf_sort AS LOGICAL NO-UNDO. /* add to sort list? */

  DEFINE VARIABLE qbf_a  AS CHARACTER NO-UNDO. /* 'available' field name */
  DEFINE VARIABLE qbf_a& AS CHARACTER NO-UNDO. /* 'available' field label */
  DEFINE VARIABLE qbf_s  AS CHARACTER NO-UNDO. /* 'selected'  field name */
  DEFINE VARIABLE qbf_s& AS CHARACTER NO-UNDO. /* 'selected'  field label */

  DEFINE VARIABLE qbf_b AS LOGICAL   NO-UNDO. /* scrap */
  DEFINE VARIABLE qbf_c AS CHARACTER NO-UNDO. /* selected list contents */
  DEFINE VARIABLE cnt   AS INTEGER   NO-UNDO.

  RUN xreturn_name  (  qbf_x,qbf_y,qbf_z,OUTPUT qbf_a ). 
  RUN xreturn_label (  qbf_x,qbf_y,qbf_z,OUTPUT qbf_a&).
  RUN xreturn_name  (- qbf_x,qbf_y,qbf_z,OUTPUT qbf_s ).
  RUN xreturn_label (- qbf_x,qbf_y,qbf_z,OUTPUT qbf_s&).

  /* The value should only not be found if it is a specific array item.
     The left side will contain xx[], not xx[n].  This should only happen
     on startup of dialog.  Leave the xx[] item on left for now.
  */

  IF qbf-a:LOOKUP(qbf_a) IN FRAME qbf-fld > 0 THEN DO:
    /* Remove this name from both left hand lists. */
    RUN adecomm/_delitem.p (qbf-a:HANDLE in FRAME qbf-fld, qbf_a, OUTPUT cnt).
    RUN adecomm/_delitem.p (qbf-a&:HANDLE in FRAME qbf-fld, qbf_a&, OUTPUT cnt).
  END.

  IF qbf_a MATCHES "*[]*":u THEN DO: /* explode array */
    qbf_c = qbf-s:LIST-ITEMS IN FRAME qbf-fld.

    FIND FIRST qbf-clump WHERE qbf-clump.qbf-cfil = qbf_x.

    DO qbf_z = 1 TO qbf-clump.qbf-cext[qbf_y]:
      RUN xreturn_name (- qbf_x,qbf_y,qbf_z,OUTPUT qbf_s).
	
      IF LOOKUP(qbf_s,qbf_c,CHR(3)) > 0 THEN NEXT.

      qbf_b = qbf-s:ADD-LAST(qbf_s) IN FRAME qbf-fld.

      RUN xreturn_label (- qbf_x,qbf_y,qbf_z,OUTPUT qbf_s&).

      qbf_b = qbf-s&:ADD-LAST(qbf_s&) IN FRAME qbf-fld.	 

      IF qbf_sort THEN
        RUN fixacdc ("add":u,qbf_x,qbf_y,qbf_z).
    END.
  END.
  ELSE DO:
    ASSIGN
      qbf_b = qbf-s:ADD-LAST(qbf_s)   IN FRAME qbf-fld
      qbf_b = qbf-s&:ADD-LAST(qbf_s&) IN FRAME qbf-fld.

    IF qbf_sort THEN
      RUN fixacdc ("add":u,qbf_x,qbf_y,qbf_z).
  END.

  qbf-ok:SENSITIVE IN FRAME qbf-fld = TRUE.
END PROCEDURE. /* left_to_right */

/*---------------------------------------------------------------------------*/

PROCEDURE right_to_left:
  DEFINE INPUT PARAMETER qbf_x AS INTEGER NO-UNDO. /* table index */
  DEFINE INPUT PARAMETER qbf_y AS INTEGER NO-UNDO. /* field index */
  DEFINE INPUT PARAMETER qbf_z AS INTEGER NO-UNDO. /* array index */

  DEFINE VARIABLE qbf_a  AS CHARACTER NO-UNDO. /* 'available' field name */
  DEFINE VARIABLE qbf_a& AS CHARACTER NO-UNDO. /* 'available' field label */
  DEFINE VARIABLE qbf_s  AS CHARACTER NO-UNDO. /* 'selected'  field name */
  DEFINE VARIABLE qbf_s& AS CHARACTER NO-UNDO. /* 'selected'  field label */

  DEFINE VARIABLE qbf_1 AS CHARACTER NO-UNDO. /* name insert pos */
  DEFINE VARIABLE qbf_2 AS CHARACTER NO-UNDO. /* label insert pos */
  DEFINE VARIABLE qbf_b AS LOGICAL   NO-UNDO. /* scrap */
  Define var cnt 	   as integer NO-UNDO.

  RUN xreturn_name  (  qbf_x,qbf_y,qbf_z,OUTPUT qbf_a ).
  RUN xreturn_label (  qbf_x,qbf_y,qbf_z,OUTPUT qbf_a&).
  RUN xreturn_name  (- qbf_x,qbf_y,qbf_z,OUTPUT qbf_s ).
  RUN xreturn_label (- qbf_x,qbf_y,qbf_z,OUTPUT qbf_s&).

  /* Remove this name from both "selected" lists */
  RUN adecomm/_delitem.p (qbf-s:HANDLE in FRAME qbf-fld, qbf_s, OUTPUT cnt).
  RUN adecomm/_delitem.p (qbf-s&:HANDLE in FRAME qbf-fld, qbf_s&, OUTPUT cnt).

  IF qbf_z > 0 THEN DO:
    RUN xreturn_name (qbf_x,qbf_y,0,OUTPUT qbf_a).
    RUN xreturn_label (qbf_x,qbf_y,0,OUTPUT qbf_a&).
    IF LOOKUP(qbf_a,qbf-a:LIST-ITEMS IN FRAME qbf-fld,CHR(3)) > 0 THEN 
      qbf_a = ?.
  END.
  IF qbf_a <> ? THEN DO:
    RUN get_next (qbf_x,qbf_y,OUTPUT qbf_1,OUTPUT qbf_2).
    IF qbf_1 = ? THEN
      ASSIGN
        qbf_b = qbf-a:ADD-LAST(qbf_a)   IN FRAME qbf-fld
        qbf_b = qbf-a&:ADD-LAST(qbf_a&) IN FRAME qbf-fld.
    ELSE
      ASSIGN
        qbf_b = qbf-a:INSERT(qbf_a,qbf_1)   IN FRAME qbf-fld
        qbf_b = qbf-a&:INSERT(qbf_a&,qbf_2) IN FRAME qbf-fld.
  END.
  ASSIGN                                 
    qbf-ok:SENSITIVE IN FRAME qbf-fld = 
      (qbf-k OR qbf-s:NUM-ITEMS IN FRAME qbf-fld > 0).
END PROCEDURE. /* right_to_left */

/*---------------------------------------------------------------------------*/

PROCEDURE xlookup_name:
  DEFINE INPUT  PARAMETER qbf_v AS CHARACTER NO-UNDO. /* value from widget */
  DEFINE OUTPUT PARAMETER qbf_x AS INTEGER   NO-UNDO. /* table index */
  DEFINE OUTPUT PARAMETER qbf_y AS INTEGER   NO-UNDO. /* field index */
  DEFINE OUTPUT PARAMETER qbf_z AS INTEGER   NO-UNDO. /* array index */
  /*
  fld                 qbf-h && qbf-hidedb
  fld (file)          qbf-hidedb
  fld (db.file)       -
  cfld (*calc type)   don't care
  */

  DEFINE VARIABLE qbf_h AS INTEGER   NO-UNDO. /* binsearch hi */
  DEFINE VARIABLE qbf_i AS INTEGER   NO-UNDO. /* loop */
  DEFINE VARIABLE qbf_l AS INTEGER   NO-UNDO. /* binsearch lo */
  DEFINE VARIABLE qbf_p AS CHARACTER NO-UNDO. /* part in parens */

  qbf_p = TRIM(SUBSTRING(qbf_v, R-INDEX(qbf_v,"(":u) + 1,
    LENGTH(qbf_v,"CHARACTER":u) - R-INDEX(qbf_v,"(":u) - 1,"CHARACTER":u)).

  IF qbf_p BEGINS "*":u THEN DO:
    FIND FIRST qbf-clump WHERE qbf-clump.qbf-cfil = 0 NO-ERROR.

    ASSIGN
      qbf_v = RIGHT-TRIM(SUBSTRING(qbf_v,1, R-INDEX(qbf_v,"(":u) - 1,
                                   "CHARACTER":u))
      qbf_x = 0
      qbf_y = 0.
    DO qbf_l = 1 TO qbf-clump.qbf-csiz WHILE qbf_y = 0:
      IF qbf-clump.qbf-cnam[qbf_l] = qbf_v THEN qbf_y = qbf_l.
    END.
    RETURN.
  END.

  IF qbf-h AND qbf-hidedb THEN DO:
    FIND FIRST qbf-clump.
    qbf_x = qbf-clump.qbf-cfil.
    /* qbf_v already holds the field-name */
  END.
  ELSE DO:
    qbf_p = (IF qbf-hidedb THEN LDBNAME("QBF$0":u) + ".":u + qbf_p ELSE qbf_p).
    RUN lookup_table (qbf_p,OUTPUT qbf_x).
    
    FIND FIRST qbf-clump WHERE qbf-clump.qbf-cfil = qbf_x.
    qbf_v = RIGHT-TRIM(SUBSTRING(qbf_v,1,R-INDEX(qbf_v,"(":u) - 1,
                                 "CHARACTER":u)).
    /* qbf_v needs to hold the field-name */
  END.

  qbf_h = INDEX(qbf_v,"[":u).
    
  IF qbf_h > 0 AND qbf_h <> INDEX(qbf_v,"]":u) - 1 THEN
    ASSIGN
      qbf_p = SUBSTRING(qbf_v,qbf_h + 1,-1,"CHARACTER":u)
      qbf_z = INTEGER(SUBSTRING(qbf_p,1,INDEX(qbf_p,"]":u) - 1,"CHARACTER":u))
      qbf_v = SUBSTRING(qbf_v,1,qbf_h,"CHARACTER":u) + "]":u.

  ASSIGN /* binsearch */
    qbf_h = qbf-clump.qbf-csiz
    qbf_l = 1
    qbf_y = 0.
    /* qbf_y = 1. */

  DO qbf_i = 1 TO qbf-csiz:
    IF qbf_v = qbf-clump.qbf-cnam[qbf_i] THEN
       qbf_y = qbf_i.
  END.

  /* removed by js
  DO WHILE qbf_y <> -1:
    qbf_y = TRUNCATE((qbf_h + qbf_l + 1) / 2,0).

    IF qbf_h < 1 OR 
       qbf_l > qbf-clump.qbf-csiz OR
       qbf_h < qbf_l THEN
       qbf_y = -1.
    ELSE IF qbf_v = qbf-clump.qbf-cnam[qbf_y] THEN LEAVE.
    ELSE IF qbf_v > qbf-clump.qbf-cnam[qbf_y] THEN qbf_l = qbf_y + 1.
    ELSE IF qbf_v < qbf-clump.qbf-cnam[qbf_y] THEN qbf_h = qbf_y - 1.
 END.
  */
END PROCEDURE. /* xlookup_name */

/*---------------------------------------------------------------------------*/

PROCEDURE xreturn_name:
  DEFINE INPUT  PARAMETER qbf_x AS INTEGER   NO-UNDO. /* table index */
  DEFINE INPUT  PARAMETER qbf_y AS INTEGER   NO-UNDO. /* field index */
  DEFINE INPUT  PARAMETER qbf_z AS INTEGER   NO-UNDO. /* array(extent) index */
  DEFINE OUTPUT PARAMETER qbf_v AS CHARACTER NO-UNDO INITIAL ?.

  /* false=for avail, true=for select*/
  DEFINE VARIABLE qbf_w     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE qbf_l     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE qbf_s     AS LOGICAL   NO-UNDO INITIAL TRUE.
  DEFINE VARIABLE tableName AS CHARACTER NO-UNDO.

  ASSIGN
    qbf_w = qbf_x < 0
    qbf_x = ABSOLUTE (qbf_x)
    qbf_w = FALSE. /* I have no idea what we are doing here GJO */

  FIND FIRST qbf-clump WHERE qbf-clump.qbf-cfil = qbf_x.
  
  IF qbf_x <> 0 THEN
    {&FIND_TABLE_BY_ID} qbf_x.

  IF _fieldCheck <> ? THEN DO:
    hook:
    DO ON STOP UNDO hook, RETRY hook:
      IF RETRY THEN DO:
        RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf_l,"error":u,"ok":u,
          SUBSTITUTE('There is a problem with &1.  &2 will use default field security.',_fieldCheck,qbf-product)).

        _fieldCheck = ?.
        LEAVE hook.
      END.
     
      /* ***Bug here if qbf_x = 0? or does 0 case never happen? */    
      tableName = qbf-rel-buf.tname. 
      RUN VALUE(_fieldCheck) (tableName,qbf-cnam[qbf_y], 
                              USERID(ENTRY(1,tableName,".":u)),OUTPUT qbf_s).
    END.
  END.

  IF qbf_s = FALSE THEN RETURN.
                                                                      
  IF qbf_x = 0 THEN
    qbf_v = qbf-clump.qbf-cnam[qbf_y] + " (*":u
          + TRIM(ENTRY(INDEX("_rpcsdnlex":u,
              SUBSTRING(qbf-clump.qbf-calc,qbf_y,1,"CHARACTER":u)),qbf-etype))
          + ")":u.
  ELSE 
    ASSIGN
      qbf_v = STRING (qbf-rel-buf.tname, "x({&Len})":u)
      qbf_v = qbf-clump.qbf-cnam[qbf_y]
            + (IF qbf-h THEN
                ""
              ELSE
                (IF qbf_w THEN "  ":u ELSE FILL(" ":u, qbf-clump.qbf-cone 
                  - LENGTH(qbf-clump.qbf-cnam[qbf_y],"RAW":u)))
                + " (":u
                + TRIM ((IF qbf-hidedb THEN ENTRY(2,qbf_v,".":u) ELSE qbf_v))
                + ")":u
              ). 
              
  IF qbf_z > 0 THEN
    OVERLAY(qbf_v,R-INDEX(qbf_v,"[":u) + 1,
      LENGTH(STRING(qbf_z),"CHARACTER":u) + 1,"CHARACTER":u) = 
      STRING(qbf_z) + "]":u.

END PROCEDURE. /* xreturn_name */

/*---------------------------------------------------------------------------*/

PROCEDURE xlookup_label:
  DEFINE INPUT  PARAMETER qbf_v AS CHARACTER NO-UNDO. /* value from widget */
  DEFINE OUTPUT PARAMETER qbf_x AS INTEGER   NO-UNDO. /* table index */
  DEFINE OUTPUT PARAMETER qbf_y AS INTEGER   NO-UNDO. /* field index */
  DEFINE OUTPUT PARAMETER qbf_z AS INTEGER   NO-UNDO. /* array index */

  DEFINE VARIABLE qbf_h AS INTEGER   NO-UNDO. /* binsearch hi */
  DEFINE VARIABLE qbf_i AS INTEGER   NO-UNDO. /* loop */
  DEFINE VARIABLE qbf_l AS INTEGER   NO-UNDO. /* binsearch lo */
  DEFINE VARIABLE qbf_p AS CHARACTER NO-UNDO. /* part in parens */

  qbf_p = SUBSTRING(qbf_v,R-INDEX(qbf_v,"(":u) + 1,
            LENGTH(qbf_v,"CHARACTER":u) - R-INDEX(qbf_v,"(":u) - 1,
            "CHARACTER":u).

  IF qbf_p BEGINS "*":u THEN DO:
    FIND FIRST qbf-clump WHERE qbf-clump.qbf-cfil = 0 NO-ERROR.
    ASSIGN
      qbf_v = SUBSTRING(qbf_p,R-INDEX(qbf_p,".":u) + 1,-1,"CHARACTER":u)
      qbf_x = 0
      qbf_y = 0.

    DO qbf_l = 1 TO qbf-clump.qbf-csiz WHILE qbf_y = 0:
      IF qbf-clump.qbf-cnam[qbf_l] = qbf_v THEN qbf_y = qbf_l.
    END.
    RETURN.
  END.

  IF qbf-h AND qbf-hidedb THEN DO:
    FIND FIRST qbf-clump.
    ASSIGN
      qbf_x = qbf-clump.qbf-cfil
      qbf_v = qbf_p. /* qbf_v needs to hold the field-name */
  END.
  ELSE DO:
    qbf_v = (IF qbf-hidedb THEN
              LDBNAME("QBF$0":u) + ".":u + ENTRY(1,qbf_p,".":u)
            ELSE
              ENTRY(1,qbf_p,".":u) + ".":u + ENTRY(2,qbf_p,".":u)
            ).
    RUN lookup_table (qbf_v,OUTPUT qbf_x).

    FIND FIRST qbf-clump WHERE qbf-clump.qbf-cfil = qbf_x.
    qbf_v = ENTRY(NUM-ENTRIES(qbf_p,".":u),qbf_p,".":u).
    /* qbf_v needs to hold the field-name */
  END.

  qbf_h = INDEX(qbf_v,"[":u).
  IF qbf_h > 0 AND qbf_h <> INDEX(qbf_v,"]":u) - 1 THEN
    ASSIGN
      qbf_p = SUBSTRING(qbf_v,qbf_h + 1,-1,"CHARACTER":u)
      qbf_z = INTEGER(SUBSTRING(qbf_p,1,INDEX(qbf_p,"]":u) - 1,"CHARACTER":u))
      qbf_v = SUBSTRING(qbf_v,1,qbf_h,"CHARACTER":u) + "]":u.

  ASSIGN /* binsearch */
    qbf_h = qbf-clump.qbf-csiz
    qbf_l = 1
    qbf_y = 1.
    qbf_y = 0.
    /* qbf_y = 1. */

  DO qbf_i = 1 TO qbf-csiz:
    IF qbf_v = qbf-clump.qbf-cnam[qbf_i] THEN
       qbf_y = qbf_i.
  END.

  /* removed by js 
  DO WHILE qbf_y <> -1:
    qbf_y = TRUNCATE((qbf_h + qbf_l) / 2,0).
    IF qbf_h < 1 OR qbf_l > qbf-clump.qbf-csiz OR qbf_h < qbf_l THEN
      qbf_y = -1.
    ELSE IF qbf_v = qbf-clump.qbf-cnam[qbf_y] THEN LEAVE.
    ELSE IF qbf_v > qbf-clump.qbf-cnam[qbf_y] THEN qbf_l = qbf_y + 1.
    ELSE IF qbf_v < qbf-clump.qbf-cnam[qbf_y] THEN qbf_h = qbf_y - 1.
  END.
  */
  
END PROCEDURE. /* xlookup_label */

/*---------------------------------------------------------------------------*/

PROCEDURE xreturn_label:
  DEFINE INPUT  PARAMETER qbf_x AS INTEGER   NO-UNDO. /* table index */
  DEFINE INPUT  PARAMETER qbf_y AS INTEGER   NO-UNDO. /* field index */
  DEFINE INPUT  PARAMETER qbf_z AS INTEGER   NO-UNDO. /* array(extent) index */
  DEFINE OUTPUT PARAMETER qbf_v AS CHARACTER NO-UNDO. /* value for widget */

  /* false=for avail, true=for select*/
  DEFINE VARIABLE qbf_w AS LOGICAL NO-UNDO.

  ASSIGN
    qbf_w = qbf_x < 0
    qbf_x = ABSOLUTE (qbf_x).

  qbf_w = FALSE. /* I have no idea what we are doing here GJO */
  
  FIND FIRST qbf-clump WHERE qbf-clump.qbf-cfil = qbf_x.

  IF qbf_x = 0 THEN
    qbf_v = STRING (qbf-clump.qbf-clbl[qbf_y], "x({&Len})":u)
          + " (*":u
          + TRIM (ENTRY(INDEX("_rpcsdnlex":u,
              SUBSTRING(qbf-clump.qbf-calc,qbf_y,1,"CHARACTER":u)),qbf-etype))
          + ".":u + qbf-clump.qbf-cnam[qbf_y]
          + ")":u.
  ELSE DO:
    {&FIND_TABLE_BY_ID} qbf_x.
    ASSIGN
      qbf_v = STRING(qbf-rel-buf.tname, "x({&Len})":u)
      qbf_v = qbf-clump.qbf-clbl[qbf_y]
            + (IF qbf_w THEN "  ":u ELSE FILL(" ":u, qbf-clump.qbf-ctwo 
               - LENGTH(qbf-clump.qbf-clbl[qbf_y],"RAW":u)))
            + " (":u
            + (IF qbf-h THEN
                ""
              ELSE
                TRIM ((IF qbf-hidedb THEN ENTRY(2,qbf_v,".":u) 
      	       	     	      	     ELSE qbf_v)) + ".":u
              )
            + qbf-clump.qbf-cnam[qbf_y]
            + ")":u.
  END.
            
  IF qbf_z > 0 THEN
    ASSIGN /* qbf_y value trashed by this routine */
      qbf_y = R-INDEX(qbf_v,"[":u)
      OVERLAY(qbf_v,qbf_y + 1,
        LENGTH(STRING(qbf_z),"CHARACTER":u) + 3,"CHARACTER":u) =
        STRING(qbf_z) + "])":u
      qbf_y = R-INDEX(qbf_v,"[":u,qbf_y - 1)
      OVERLAY(qbf_v,qbf_y + 1,
        LENGTH(STRING(qbf_z),"CHARACTER":u) + 2,"CHARACTER":u) =
        STRING(qbf_z) + "]":u.
END PROCEDURE. /* xreturn_label */

/*---------------------------------------------------------------------------*/

PROCEDURE xlookup_truename:
  DEFINE INPUT  PARAMETER qbf_v AS CHARACTER NO-UNDO. /* real object name  */
  DEFINE OUTPUT PARAMETER qbf_x AS INTEGER   NO-UNDO. /* table index */
  DEFINE OUTPUT PARAMETER qbf_y AS INTEGER   NO-UNDO. /* field index */
  DEFINE OUTPUT PARAMETER qbf_z AS INTEGER   NO-UNDO. /* array(extent) index */
  /* qbf_v is either qbf-### or db.table.field */

  DEFINE VARIABLE qbf_c AS CHARACTER NO-UNDO. /* scrap */
  DEFINE VARIABLE qbf_h AS INTEGER   NO-UNDO. /* binsearch hi */
  DEFINE VARIABLE qbf_i AS INTEGER   NO-UNDO. /* loop */
  DEFINE VARIABLE qbf_l AS INTEGER   NO-UNDO. /* binsearch lo, loop */

  IF INDEX(qbf_v,".":u) = 0 THEN DO:
    FIND FIRST qbf-clump WHERE qbf-clump.qbf-cfil = 0.
    ASSIGN
      qbf_y = 0
      qbf_x = 0.
    DO qbf_l = 1 TO qbf-clump.qbf-csiz WHILE qbf_y = 0:
      IF qbf-clump.qbf-cnam[qbf_l] = qbf_v THEN qbf_y = qbf_l.
    END.
  END.
  ELSE DO:
    ASSIGN
      qbf_c = ENTRY(1,qbf_v,".":u) + ".":u + ENTRY(2,qbf_v,".":u)
      qbf_v = ENTRY(3,qbf_v,".":u)
      qbf_h = INDEX(qbf_v,"[":u).

    RUN lookup_table (qbf_c,OUTPUT qbf_x).

    IF qbf_h > 0 AND qbf_h <> INDEX(qbf_v,"]":u) - 1 THEN
      ASSIGN
        qbf_c = SUBSTRING(qbf_v,qbf_h + 1,-1,"CHARACTER":u)
        qbf_z = INTEGER(SUBSTRING(qbf_c,1,INDEX(qbf_c,"]":u) - 1,"CHARACTER":u))
        qbf_v = SUBSTRING(qbf_v,1,qbf_h,"CHARACTER":u) + "]":u.
    FIND FIRST qbf-clump WHERE qbf-clump.qbf-cfil = qbf_x.

    ASSIGN /* binsearch */
      qbf_h = qbf-clump.qbf-csiz
      qbf_l = 1
      qbf_y = 0.
      /* qbf_y = 1. */

    DO qbf_i = 1 TO qbf-csiz:
      IF qbf_v = qbf-clump.qbf-cnam[qbf_i] THEN
         qbf_y = qbf_i.
    END.
   
    /*                   
    DO WHILE qbf_y <> -1:

      qbf_y = TRUNCATE((qbf_h + qbf_l) / 2,0).

      IF qbf_h < 1 OR qbf_l > qbf-clump.qbf-csiz OR qbf_h < qbf_l THEN
        qbf_y = -1.
      ELSE IF qbf_v = qbf-clump.qbf-cnam[qbf_y] THEN LEAVE.
      ELSE IF qbf_v > qbf-clump.qbf-cnam[qbf_y] THEN qbf_l = qbf_y + 1.
      ELSE IF qbf_v < qbf-clump.qbf-cnam[qbf_y] THEN qbf_h = qbf_y - 1.
    END.
    */
  END.
END PROCEDURE. /* xlookup_truename */

/*---------------------------------------------------------------------------*/

PROCEDURE xreturn_truename:
  DEFINE INPUT  PARAMETER qbf_x AS INTEGER   NO-UNDO. /* table index */
  DEFINE INPUT  PARAMETER qbf_y AS INTEGER   NO-UNDO. /* field index */
  DEFINE INPUT  PARAMETER qbf_z AS INTEGER   NO-UNDO. /* array index */
  DEFINE OUTPUT PARAMETER qbf_v AS CHARACTER NO-UNDO. /* real object name */
  /* qbf_v is either qbf-### or db.table.field */

  /* false=for avail, true=for select*/
  DEFINE VARIABLE qbf_w AS LOGICAL NO-UNDO.

  ASSIGN
    qbf_w = qbf_x < 0
    qbf_x = ABSOLUTE(qbf_x).

  FIND FIRST qbf-clump WHERE qbf-clump.qbf-cfil = qbf_x.
  IF qbf_x <> 0 THEN
    {&FIND_TABLE_BY_ID} qbf_x.

  qbf_v = (IF qbf_x = 0 THEN "" ELSE qbf-rel-buf.tname + ".":u)
        + qbf-clump.qbf-cnam[qbf_y].
  IF qbf_z > 0 THEN
    SUBSTRING(qbf_v,INDEX(qbf_v,"[":u) + 1,0,"CHARACTER":u) = STRING(qbf_z).
END PROCEDURE. /* xreturn_truename */

/*---------------------------------------------------------------------------*/

/*
This procedure returns the name and label of the next item that is
currently in the "available" list.  It return ? and ? if there are no
more items.  This is exactly what is wanted for the second parameter
of the "insert" method for selection-lists.
*/
PROCEDURE get_next:
  DEFINE INPUT  PARAMETER qbf_x AS INTEGER   NO-UNDO. /* table index */
  DEFINE INPUT  PARAMETER qbf_y AS INTEGER   NO-UNDO. /* field index */
  DEFINE OUTPUT PARAMETER qbf_n AS CHARACTER NO-UNDO. /* name */
  DEFINE OUTPUT PARAMETER qbf_l AS CHARACTER NO-UNDO. /* label */

  DEFINE VARIABLE qbf_a AS CHARACTER NO-UNDO. /* contents of avail sellist */

  FIND FIRST qbf-clump WHERE qbf-clump.qbf-cfil = qbf_x.
  qbf_a = qbf-a:LIST-ITEMS IN FRAME qbf-fld.
 
  DO WHILE TRUE:
    RUN xreturn_name (qbf_x,qbf_y,0,OUTPUT qbf_n).
    IF LOOKUP(qbf_n,qbf_a,CHR(3)) > 0 THEN LEAVE.

    IF qbf_y = qbf-clump.qbf-csiz THEN DO:
      /* this will fail if this is the last table or we'll get the first
      	 field in the next table.
      */
      FIND NEXT qbf-clump NO-ERROR.
      IF NOT AVAILABLE qbf-clump THEN DO:
        ASSIGN
          qbf_n = ?
          qbf_l = ?.
        RETURN.
      END.
      ASSIGN
        qbf_x = qbf-clump.qbf-cfil
        qbf_y = 1.
    END.
    ELSE
      qbf_y = qbf_y + 1.
  END.
  RUN xreturn_label (qbf_x,qbf_y,0,OUTPUT qbf_l).
END PROCEDURE. /* get_next */

/*---------------------------------------------------------------------------*/

/* There is a parallel list (qbf-ord) that keeps each field with its
   corresponding ascending or descending setting.
   This keeps that list in sync with the selected fields in terms of which
   fields there are and which order they are in.
   Descending fields are marked with " DESC", ascending fields are unmarked.
*/
PROCEDURE fixacdc:
  /* action = order,add,remove,valchg, or set */
  DEFINE INPUT PARAMETER action AS CHARACTER NO-UNDO. 
  DEFINE INPUT PARAMETER qbf_x  AS INTEGER   NO-UNDO. /* table index */
  DEFINE INPUT PARAMETER qbf_y  AS INTEGER   NO-UNDO. /* field index */
  DEFINE INPUT PARAMETER qbf_z  AS INTEGER   NO-UNDO. /* array index */

  DEFINE VARIABLE qbf-c   AS CHARACTER NO-UNDO. /* scrap */  
  DEFINE VARIABLE qbf-e   AS CHARACTER NO-UNDO. /* entry in sort list */
  DEFINE VARIABLE qbf-l   AS LOGICAL   NO-UNDO. /* scrap */
  DEFINE VARIABLE qbf_o   AS CHARACTER NO-UNDO. /* temp output */

  IF qbf-s:NUM-ITEMS IN FRAME qbf-fld > 0 THEN DO:
    IF CAN-DO("set,valchg":u, action) THEN DO:
    
      /* get ldbname.table.field triplet */
      IF qbf-toggle1 THEN                                                       
        RUN xlookup_label
          (qbf-s&:SCREEN-VALUE IN FRAME qbf-fld,
          OUTPUT qbf_x,OUTPUT qbf_y,OUTPUT qbf_z).
      ELSE
        RUN xlookup_name
          (qbf-s:SCREEN-VALUE IN FRAME qbf-fld,
          OUTPUT qbf_x,OUTPUT qbf_y,OUTPUT qbf_z).
    END.

    IF action <> "order":u THEN
      RUN xreturn_truename (qbf_x,qbf_y,qbf_z,OUTPUT qbf_o).
     
    CASE action:
      WHEN "add":u THEN 
        ASSIGN
          qbf-ord = (IF qbf-ord > "" THEN qbf-ord + ",":u ELSE "") + qbf_o
          qbf-acdc:SCREEN-VALUE IN FRAME qbf-fld = "A":u.

      WHEN "set":u THEN
        ENTRY(LOOKUP(qbf_o,REPLACE(qbf-ord," DESC":u,"")),qbf-ord) = 
          qbf_o + (IF qbf-acdc:SCREEN-VALUE IN FRAME qbf-fld = "A":u 
                   THEN "" ELSE " DESC":u).

      WHEN "valchg":u THEN DO:

        IF INDEX(qbf-s:SCREEN-VALUE IN FRAME qbf-fld,CHR(3)) = 0 THEN
        ASSIGN
          qbf-c = ENTRY(LOOKUP(qbf_o,REPLACE(qbf-ord," DESC":u,"")),qbf-ord)
          qbf-acdc:SCREEN-VALUE IN FRAME qbf-fld = 
            IF qbf-c MATCHES "* DESC":u THEN "D":u ELSE "A":u.
      END.
    
      WHEN "order":u OR WHEN "remove":u OR WHEN "acdc":u THEN DO:
        qbf-c = "".
        DO qbf-i = 1 TO qbf-s:NUM-ITEMS IN FRAME qbf-fld:
                      
          /* get ldbname.table.field triplet */
          IF qbf-toggle1 THEN
            RUN xlookup_label
              (ENTRY(qbf-i,qbf-s&:LIST-ITEMS IN FRAME qbf-fld,CHR(3)),
              OUTPUT qbf_x,OUTPUT qbf_y,OUTPUT qbf_z).
          ELSE
            RUN xlookup_name
              (ENTRY(qbf-i,qbf-s:LIST-ITEMS IN FRAME qbf-fld,CHR(3)),
              OUTPUT qbf_x,OUTPUT qbf_y,OUTPUT qbf_z).
   
          RUN xreturn_truename (qbf_x,qbf_y,qbf_z,OUTPUT qbf_o).
                   
          qbf-c = qbf-c + (IF qbf-c = "" THEN "" ELSE ",":u) 
                + ENTRY(LOOKUP(qbf_o,REPLACE(qbf-ord," DESC":u,"")),qbf-ord). 
        END.
        qbf-ord = qbf-c.

        /* reset asc/desc toggle screen value */
        /* removed by js
        IF action = "remove":u AND qbf-ord > "" THEN
          ASSIGN
            qbf-c = ENTRY(LOOKUP(qbf_o,REPLACE(qbf-ord," DESC":u,"")),qbf-ord)
            qbf-acdc:SCREEN-VALUE IN FRAME qbf-fld = 
              IF qbf-c MATCHES "* DESC":u THEN "D":u ELSE "A":u.

        END.
        */
      END.
    END CASE.

    ASSIGN
      qbf-acdc:VISIBLE IN FRAME qbf-fld   = TRUE
      qbf-acdc:SENSITIVE IN FRAME qbf-fld = 
        (IF qbf-toggle1 THEN
           INDEX(qbf-s&:SCREEN-VALUE IN FRAME qbf-fld,CHR(3)) = 0
         ELSE
           INDEX(qbf-s:SCREEN-VALUE  IN FRAME qbf-fld,CHR(3)) = 0).
  END. /* qbf-s:NUM-ITEMS > 0 */
  ELSE
    ASSIGN
      qbf-ord                             = ""
      qbf-acdc:VISIBLE IN FRAME qbf-fld   = FALSE
      qbf-acdc:SENSITIVE IN FRAME qbf-fld = FALSE.

END PROCEDURE.

/*---------------------------------------------------------------------------*/
/* sub-proc to lookup file reference in relationship table */

/* PROCEDURE lookup_table */
{ aderes/p-lookup.i }

/*---------------------------------------------------------------------------*/

/* j-field2.p - end of file */

