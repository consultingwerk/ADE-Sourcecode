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
   This shows a list of fields and allows the user to specify the start 
   and end column for each field.  It does NOT work on TTY.
   
   pik_count  - number of elements in list (was pik_chextent)
   pik_list   - list of elements           (was pik_chlist)
   pik_lower  - lower values (start column) for each list element
   pik_upper  - upper values (end column) for each list element
   
   HISTORY:
   
   Modified on 07/08/94 by gfs      Fixed bug 94-06-24-018
                           gfs      Fixed title spelling
               01/07/98 by Mario B  BUG 98-10-21-035 widen frame so start and
	                            end values can be seen.
*/

{prodict/user/uservar.i}


/*input:*/
DEFINE SHARED VARIABLE pik_count AS INTEGER               NO-UNDO.
DEFINE SHARED VARIABLE pik_list  AS CHARACTER EXTENT 2000 NO-UNDO.

/*output:*/
DEFINE SHARED VARIABLE pik_lower AS INTEGER   EXTENT 2000 NO-UNDO.
DEFINE SHARED VARIABLE pik_upper AS INTEGER   EXTENT 2000 NO-UNDO.

&global-define NUM1_COL        34
&global-define NUM2_COL 41
&global-define LIST_WID 66
&global-define LBL_WID  68
&IF "{&WINDOW-SYSTEM}" begins "MS-WIN" &THEN 
   &global-define LBL_COL  2.5
&ELSE
   &global-define LBL_COL  3
&ENDIF

/* Form Variables*/
DEFINE VARIABLE sel_list  AS CHAR                               NO-UNDO 
   VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-V
   INNER-CHARS {&LIST_WID} INNER-LINES 10.

DEFINE VARIABLE start_col AS INTEGER FORMAT ">>>>>" NO-UNDO .
DEFINE VARIABLE end_col   AS INTEGER FORMAT ">>>>>" NO-UNDO.

DEFINE VARIABLE lst_label1 AS CHAR NO-UNDO.
DEFINE VARIABLE lst_label2 AS CHAR NO-UNDO.

DEFINE BUTTON btn_Next LABEL "&Next" {&STDPH_OKBTN}.

/* Miscellaneous */
DEFINE VARIABLE ix        AS INTEGER NO-UNDO.
DEFINE VARIABLE stat      AS LOGICAL NO-UNDO.
DEFINE VARIABLE item      AS CHAR    NO-UNDO.
DEFINE VARIABLE new_item  AS CHAR    NO-UNDO.
DEFINE VARIABLE num1      AS INTEGER NO-UNDO.
DEFINE VARIABLE num2      AS INTEGER NO-UNDO.
DEFINE VARIABLE lst_val   AS CHAR    NO-UNDO.

FORM
  SKIP({&TFM_WID})
  "Use RETURN from End Column for continuous data" 
                              AT 2 VIEW-AS TEXT                           SKIP
  "entry."       AT 2 VIEW-AS TEXT               SKIP({&VM_WIDG})

  start_col      AT {&LBL_COL} 
                                   LABEL "&Start Column"            SPACE({&HM_WIDG})
  end_col             LABEL "&End Column"        SKIP({&VM_WIDG})
  lst_label1     AT {&LBL_COL} NO-LABEL VIEW-AS TEXT 
                              FORMAT "x({&LBL_WID})" FONT fixed_font   SKIP
  lst_label2     AT {&LBL_COL} NO-LABEL VIEW-AS TEXT  
                              FORMAT "x({&LBL_WID})" FONT fixed_font   SKIP({&VM_WID})

  sel_list              AT 2  NO-LABEL FONT fixed_font

  {adecomm/okform.i
      &BOX    = rect_btns
      &STATUS = no
      &OK     = btn_OK
      &CANCEL = btn_Cancel
      &OTHER  = "SPACE({&HM_DBTNG}) btn_Next"
      {&HLP_BTN}
   }

  WITH FRAME fixd 
  ROW 3 CENTERED SIDE-LABELS
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE "Fixed-Length Field Columns".


/*=========================Internal Procedures============================*/

/*--------------------------------------------------
   Outputs: new_item - the new value of the 
                  selection list item after the end col
                  value has been incorporated into it.
---------------------------------------------------*/
PROCEDURE Show_End_Col:
   item = lst_val.
   new_item = SUBSTR(item,1,{&NUM2_COL} - 1) + 
                    STRING(INTEGER(end_col:SCREEN-VALUE IN FRAME fixd),">>>>>").
   stat = sel_list:REPLACE(new_item, item) IN FRAME fixd.
   lst_val = new_item.
END.

/*===============================Triggers=================================*/

/*----- HELP -----*/
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
on HELP of frame fixd OR choose of btn_Help in frame fixd
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                                               INPUT {&Fixed_Length_Field_Columns_Dlg_Box},
                                               INPUT ?).
&ENDIF


/*-----WINDOW-CLOSE-----*/
on window-close of frame fixd
   apply "END-ERROR" to frame fixd.


/*----- VALUE CHANGED of SELECT LIST -----*/
ON VALUE-CHANGED OF sel_list IN FRAME fixd
DO:
   IF (end_col:SCREEN-VALUE = "" AND start_col:SCREEN-VALUE <> "") OR
      (INT(end_col:SCREEN-VALUE) < INT(start_col:SCREEN-VALUE))    THEN 
   DO:
            MESSAGE "You must enter a valid value for the ending column."
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            APPLY "ENTRY" TO end_col.
            RETURN NO-APPLY.
   END.
   assign
     /* This is needed because on Windows, if we are in one of the
        column fill-in fields and click on the select list, when we get
        the leave event, the select list value has already been 
        changed so we would end up setting the column value for the wrong 
        list entry.  So lst_val represents the current select list value 
        more acurately than sel_list:screen-value.
     */
     lst_val = SELF:SCREEN-VALUE
     new_item = lst_val

     /* Show the start/end columns for the selected field */
     start_col = INTEGER(SUBSTR(lst_val,{&NUM1_COL},5))
     end_col   = INTEGER(SUBSTR(lst_val,{&NUM2_COL},5))
     .
   DISPLAY start_col end_col WITH FRAME fixd.
END.

/*----- LEAVE of START COLUMN -----*/
ON LEAVE OF start_col IN FRAME fixd
DO:
   /* Reflect the new value in the select list */
   
   IF INT(end_col:SCREEN-VALUE) > 0 THEN 
        IF start_col:SCREEN-VALUE = "" /*OR 
        INT(start_col:SCREEN-VALUE) > INT(end_col:SCREEN-VALUE)*/ THEN 
        DO:
          MESSAGE "You must enter a valid starting column." 
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
          RETURN NO-APPLY.
        END.
   IF LAST-EVENT:FUNCTION = "GO" THEN
        IF start_col:SCREEN-VALUE <> "" AND
             end_col:SCREEN-VALUE = "" THEN 
           DO:
             MESSAGE "You must enter a valid ending column."
                VIEW-AS ALERT-BOX BUTTONS OK.
             RETURN NO-APPLY.
           END.
   item     = sel_list:SCREEN-VALUE.
   new_item = SUBSTR(item,1,{&NUM1_COL} - 1) + 
                    STRING(INTEGER(SELF:SCREEN-VALUE),">>>>>") +
                    SUBSTR(item,{&NUM2_COL} - 2).
   stat    = sel_list:REPLACE(new_item, item) IN FRAME fixd.
   lst_val = new_item.

   /* REPLACE function removes selection.  Value will be ? unless
      the leave trigger was caused by clicking on select list.
      If it is ?, restore selection.
   */
   IF sel_list:SCREEN-VALUE IN FRAME fixd = ? THEN
      sel_list:SCREEN-VALUE IN FRAME fixd = new_item. 
END.

/*----- ENTRY of END COLUMN -----*/
ON ENTRY OF end_col IN FRAME fixd
   FRAME fixd:DEFAULT-BUTTON = btn_Next:HANDLE IN FRAME fixd.


/*----- LEAVE of END COLUMN -----*/
ON LEAVE OF end_col IN FRAME fixd
DO:
   IF (start_col:SCREEN-VALUE = "" OR start_col:SCREEN-VALUE = ?) AND
     (SELF:SCREEN-VALUE NE "" AND SELF:SCREEN-VALUE NE ?) THEN DO:
     MESSAGE "You must enter a valid starting column." VIEW-AS ALERT-BOX ERROR.
     APPLY "ENTRY" TO start_col.
     RETURN NO-APPLY.
   END.
   IF INT(start_col:SCREEN-VALUE) > INT(end_col:SCREEN-VALUE) THEN
   DO:
        MESSAGE "The starting column cannot be larger than the ending column."
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        ASSIGN sel_list:SCREEN-VALUE = new_item.
        APPLY "ENTRY" TO start_col.
        RETURN NO-APPLY.
   END.
   /* Reflect the new value in the select list */
   RUN Show_End_Col.
   
   /* REPLACE function removes selection.  Value will be ? unless
      the leave trigger was caused by clicking on select list.
      If it is ?, restore selection.
   */
   IF sel_list:SCREEN-VALUE IN FRAME fixd = ? THEN
     sel_list:SCREEN-VALUE IN FRAME fixd = new_item. 

   FRAME fixd:DEFAULT-BUTTON = btn_OK:HANDLE IN FRAME fixd.
END.

/*----- CHOOSE of NEXT BUTTON -----*/
ON CHOOSE of btn_Next IN FRAME fixd
DO:
   /* Reflect the new value in the select list. This will have happened
      already if user clicks on Next.  But if they "push" next by hitting
      RETURN (default button), the leave trigger doesn't fire.
   */

   IF (end_col:SCREEN-VALUE = "" AND start_col:SCREEN-VALUE <> "") OR
      (INT(end_col:SCREEN-VALUE) < INT(start_col:SCREEN-VALUE))    THEN 
   DO:
            MESSAGE "You must enter a valid ending column."
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            APPLY "ENTRY" TO end_col.
            RETURN NO-APPLY.
   END.
   
   IF SELF:HANDLE <> FOCUS:HANDLE THEN
   RUN Show_End_Col. 
   /* move the selection down 1 */
   ix = sel_list:LOOKUP(new_item) IN FRAME fixd.
   IF ix < sel_list:NUM-ITEMS THEN
      ix = ix + 1.
   sel_list:SCREEN-VALUE IN FRAME fixd  = sel_list:ENTRY(ix) IN FRAME fixd.

   /* Reflect values of new selection in fill-ins */
   APPLY "VALUE-CHANGED" TO sel_list IN FRAME fixd.

   /* Set up to modify for next field by putting cursor in start col. */ 
   APPLY "ENTRY" TO start_col IN FRAME fixd.
END.


/*============================Mainline code===============================*/

/* Store the list of fields in the select list */
DO ix = 1 TO pik_count:
   stat = sel_list:ADD-LAST(STRING(pik_list[ix],"x({&LIST_WID})")) 
      IN FRAME fixd.
END.

/* Compose the two list label strings */
ASSIGN
   num1 = {&NUM1_COL} - 1
   num2 = {&NUM2_COL} - {&NUM1_COL}
   lst_label1 = STRING(" ", SUBSTITUTE("x(&1)", num1)) + 
                      STRING("Start", SUBSTITUTE("x(&1)", num2)) +
                      "End"
   lst_label2 = STRING("Field Name", SUBSTITUTE("x(&1)", num1)) + 
                      STRING("Column", SUBSTITUTE("x(&1)", num2)) +
                      "Column".

/* Adjust the graphical rectangle and the ok and cancel buttons */
{adecomm/okrun.i  
   &FRAME = "frame fixd" 
   &BOX   = "rect_Btns"
   &OK    = "btn_OK" 
   {&HLP_BTN}
}

display lst_label1 lst_label2 with frame fixd.

/* initialize 1st selection */
sel_list = STRING(pik_list[1],"x({&LIST_WID})").
lst_val = sel_list.  

DO ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
   UPDATE start_col 
                end_col 
                sel_list
          btn_OK 
                btn_Cancel
          btn_Next
                {&HLP_BTN_NAME}
          WITH FRAME fixd.
   
   /* Set output values */
   DO ix = 1 TO pik_count:
      ASSIGN
               pik_lower[ix] = 
                  INTEGER(SUBSTR(sel_list:ENTRY(ix) IN FRAME fixd,{&NUM1_COL},5))
               pik_upper[ix] = 
                  INTEGER(SUBSTR(sel_list:ENTRY(ix) IN FRAME fixd,{&NUM2_COL},5)).
   END.
END.  

HIDE FRAME fixd NO-PAUSE.
RETURN.



