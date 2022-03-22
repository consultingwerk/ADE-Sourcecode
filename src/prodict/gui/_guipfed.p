/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*------------------------------------------------------------------
   Parameter file Editor

   Output Parameter:
      canned - Return YES if user cancels out, NO otherwise.

   Author: Laura Stern
-------------------------------------------------------------------*/

{prodict/user/uservar.i}
/* arg_nam   - (By the time we get here:) Array of arg name/description 
      	       pairs (e.g., -B   Buffers)
   arg_lst   - All parm names (-B) strung out in a comma delimited list
   arg_typ   - Array of argument data types (l, c, n)
   arg_val   - Array of values
   args#     - Number of arguments 
   arg_comm  - Array of comment lines 
   arg_comm# - # of non-blank comment lines
   pf_file   - The parameter file to edit.
*/
{prodict/user/userpfed.i}

DEFINE OUTPUT PARAMETER p_canned AS LOGICAL NO-UNDO.

/* Form Variables */
DEFINE VARIABLE plist AS CHAR NO-UNDO FONT 0 /* fixed pitch so cols line up */
   VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-V 
   /*Make it roughly same size as editor for comments*/
   INNER-CHARS {&COMM_LEN} INNER-LINES {&COMM#}.

DEFINE VARIABLE arg_chr AS CHAR     FORMAT "x({&VAL_CHARS})"  NO-UNDO.
DEFINE VARIABLE arg_int AS INTEGER  FORMAT ">>>,>>>,>>9"    NO-UNDO.
DEFINE VARIABLE arg_log AS LOGICAL  FORMAT "yes/no"         NO-UNDO.

DEFINE VARIABLE comment AS CHAR     NO-UNDO
   VIEW-AS EDITOR INNER-CHARS {&COMM_LEN} INNER-LINES {&COMM#}
   {&STDPH_EDITOR}.

/* Miscellaneous */
DEFINE VARIABLE ix   	 AS INTEGER    	  NO-UNDO.  /* looping variable */
DEFINE VARIABLE stat 	 AS LOGICAL    	  NO-UNDO.
DEFINE VARIABLE tru_txt	 AS CHARACTER     NO-UNDO.
DEFINE VARIABLE prev_ix  AS INTEGER    	  NO-UNDO.
DEFINE VARIABLE labelstr AS CHAR NO-UNDO FONT 0 /*fixed pitch so cols line up*/.
DEFINE VARIABLE ldummy   AS LOGICAL       NO-UNDO.

/* This is needed because on Windows, if we are in one of the
   argument fields and click on the select list, when we get
   the leave event, the select list value has already been 
   changed so we would end up saving the argument for the wrong 
   parameter.  So lst_val represents the current select list value 
   more acurately than plist:screen-value.
*/
DEFINE VARIABLE lst_val  as CHAR          NO-UNDO.


FORM
   SKIP({&TFM_WID})
   labelstr    AT 2  NO-LABEL       VIEW-AS TEXT SKIP({&VM_WID})
   plist       AT 2  NO-LABEL       SKIP({&VM_WIDG})
   arg_chr     AT 2  {&STDPH_FILL} LABEL "&Character Value" 
	       SKIP({&VM_WIDG})
   arg_int     AT ROW-OF arg_chr COL 2 {&STDPH_FILL} 
	       LABEL "&Integer Value" SKIP({&VM_WIDG})
   arg_log     AT ROW-OF arg_chr COL 2 {&STDPH_FILL} 
	       LABEL "&Logical Value" SKIP({&VM_WIDG})
   "Co&mments: (up to {&COMM#} lines)     "  
      	       AT 2  VIEW-AS TEXT     	     SKIP({&VM_WID})
   comment     AT 2  NO-LABEL
   {prodict/user/userbtns.i}
   WITH FRAME pfedit
   CENTERED ATTR-SPACE SIDE-LABELS 
   DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel SCROLLABLE
   VIEW-AS DIALOG-BOX TITLE ' Edit Parameter File "' + pf_file + '" '.


/*========================Internal Procedures=============================*/

/*---------------------------------------------------
   Save the new value the user just entered for
   a parameter and reflect the value in the choose
   list.  If it didn't change don't do anything.  
   prev_ix is the index of the parameter that the 
   new value corresponds to.

   Input Parameter: 
      p_item - select list entry correpsonding
      	       to this parameter.
---------------------------------------------------*/
PROCEDURE Save_Value:
   DEFINE INPUT PARAMETER p_item AS CHAR NO-UNDO.

   DEFINE VAR val      AS CHAR 	  NO-UNDO.
   DEFINE VAR new_item AS CHAR 	  NO-UNDO.

   /* Get the value from the appropriate input variable */
   IF arg_typ[prev_ix] = "c" THEN 
      val = arg_chr:SCREEN-VALUE IN FRAME pfedit.
   ELSE IF arg_typ[prev_ix] = "n" THEN DO:
      val = STRING(INPUT FRAME pfedit arg_int). /* this strips format chars */
      IF val = ? THEN val = "".
   END.
   ELSE  /* arg_typ[prev_ix] = "l" */
      val = arg_log:SCREEN-VALUE IN FRAME pfedit.

   /* only update if changed, to avoid wasted time and flashing */
   IF val <> arg_val[prev_ix] THEN DO:
      ASSIGN   
	 arg_val[prev_ix] = val
	 new_item = p_item
	 SUBSTR(new_item,{&VAL_START},{&VAL_CHARS}) = val
	 stat = plist:REPLACE(new_item, p_item) IN FRAME pfedit
      	 lst_val = new_item.

      /* REPLACE function removes selection.  Select list value will 
      	 be ? unless this leave trigger was caused by clicking on select 
      	 list.  If it is ?, restore selection.
      */
      if plist:SCREEN-VALUE IN FRAME pfedit = ? THEN
      	 plist:SCREEN-VALUE IN FRAME pfedit = new_item.
   END.
END.


/*===============================Triggers=================================*/

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
/*----- HELP -----*/
on HELP of frame pfedit
   or CHOOSE of btn_Help in frame pfedit
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
      	       	     	     INPUT {&Edit_Parameter_File_Dlg_Box},
      	       	     	     INPUT ?).

&ENDIF

/*----- VALUE CHANGED of PARAM LIST -----*/
ON VALUE-CHANGED OF plist IN FRAME pfedit
DO:
   DEFINE VAR pkey   AS CHAR NO-UNDO.
   DEFINE VAR val    AS CHAR NO-UNDO.

   /* See comment on define of variable */   
   lst_val = SELF:SCREEN-VALUE.

   /* We have a new selection so get new parm key (without the leading 
      "-") and get it's index in the list */
   ASSIGN
      pkey = TRIM(SUBSTR(lst_val, 2, {&PKEY_LEN} - 1))
      ix = LOOKUP(pkey, arg_lst)
      prev_ix = ix.  /* setup for next time around */

   /* Enable the appropriate widget for new choose */
   ASSIGN
      arg_chr:visible IN FRAME pfedit = 
   	    (IF arg_typ[ix] = "c" THEN yes ELSE no)
      arg_int:visible IN FRAME pfedit = 
   	    (IF arg_typ[ix] = "n" THEN yes ELSE no)
      arg_log:visible IN FRAME pfedit = 
   	    (IF arg_typ[ix] = "l" THEN yes ELSE no).

   /* Show current value in editing widget */
   val = TRIM(SUBSTR(lst_val, {&VAL_START}, {&VAL_CHARS})).

   IF arg_typ[ix] = "c" THEN 
      arg_chr:SCREEN-VALUE IN FRAME pfedit = val.
   ELSE IF arg_typ[ix] = "n" THEN DO:
      IF val = "" THEN val = ?.
      DISPLAY INTEGER(val) @ arg_int WITH FRAME pfedit.
   END.
   ELSE /* arg_typ[ix] = "l" */
      DISPLAY (val = tru_txt) @ arg_log WITH FRAME pfedit.
END.


/*----- ON LEAVE of EDITING VARIABLE (arg_xxx) -----*/
ON LEAVE OF arg_chr IN FRAME pfedit,
      	    arg_log IN FRAME pfedit,
      	    arg_int IN FRAME pfedit
   RUN Save_Value (INPUT lst_val).


/*----- ON HIT of OK BUTTON OR GO -----*/
ON CHOOSE OF btn_OK OR GO OF FRAME pfedit
DO:
   DEFINE VAR part AS CHAR    	       	     	NO-UNDO.
   DEFINE VAR temp AS CHAR    EXTENT {&COMM#}	NO-UNDO.
   DEFINE VAR done AS LOGICAL INIT false     	NO-UNDO.
   DEFINE VAR i    AS INTEGER 	       	     	NO-UNDO. /* for dictsplt.i */
   DEFINE VAR j    AS INTEGER 	       	     	NO-UNDO. /* for dictsplt.i */

   RUN Save_Value (INPUT lst_val).

   /* Translate editor widget contents into array elements.  This
      is more complicated than it should be!  We break wrapping
      lines at spaces in {&COMM_LEN} char chunks.  But if the user put in
      an explicit return we want to move to the next array element.
   */ 
   ASSIGN
      INPUT FRAME pfedit comment
      arg_comm# = 1
      arg_comm = "".

   DO WHILE NOT done:
      ix = INDEX(comment, CHR(10)).  /* index of the carriage return */
      IF ix > 0 THEN
      DO:   
      	 /* Set part to the info up to the carriage return.
      	    comment is reset to the remainder.
      	 */
	 IF ix = 1 THEN
	    part = "".
	 else
	    part = SUBSTR(comment, 1, ix - 1).

      	 /* On windows, lines have CR Line feed */
	 IF ix + 1 < LENGTH(comment) THEN
	    comment = SUBSTR(comment, ix + 1).
	 else
	    done = true.
      END.
      else DO:
      	 /* No more carriage returns. part is the rest of the string. */
	 part = comment.
	 done = true.
      END.   
   
      temp = "".  /* re-initialize */
      IF part <> "" THEN
      DO:
      	 /* This breaks part into {&COMM_LEN} char chunks and puts it in 
      	    temp array */
	 {prodict/dictsplt.i
	    &src = part
	    &dst = temp
	    &num = {&COMM#}
	    &len = {&COMM_LEN}
	    &chr = " "}
       END.
       
      /* Move temp into the next available slots in arg_comm. */
      DO ix = 1 TO {&COMM#} while temp[ix] <> "":
	 arg_comm[arg_comm#] = temp[ix].
	 arg_comm# = arg_comm# + 1.
      END.
   END.
END.

ON WINDOW-CLOSE OF FRAME pfedit
   APPLY "END-ERROR" TO FRAME pfedit.


/*============================Mainline code===============================*/

/* the PROGRESS default truth for logicals */
tru_txt = STRING(TRUE).  /* will automatically match language */

/* Adjust the graphical rectangle and the ok and cancel buttons */
{adecomm/okrun.i  
      &FRAME  = "FRAME pfedit" 
      &BOX    = "rect_Btns"
      &OK     = "btn_OK" 
      {&CAN_BTN}
      {&HLP_BTN}
}

/* Fill the choose list with the parameters in the form:
   <Key>   <Desc>  <Value>  e.g., -B    Buffers   <value> 
*/
DO ix = 1 TO args#:
   stat = plist:ADD-LAST(STRING(arg_nam[ix], "x({&PNAME_LEN})") + 
      	       	     	 " " +
       	     	 STRING(arg_val[ix], "x({&VAL_CHARS})")) IN FRAME pfedit.
END.
/* Construct label string for list.  May have to adjust horizontal position
   a few pixels, to take account of the internal margin in the list widget*/
labelstr = STRING("Parameter", "X({&PKEY_LEN})") + " " +
           STRING("Description", "X({&PDESC_LEN})") + " " +
           "Current Value".
labelstr:FORMAT IN FRAME pfedit = "X(" + STRING(LENGTH(labelstr)) + ")".
labelstr:X IN FRAME pfedit = labelstr:X IN FRAME pfedit + 4.

/* Fill the comment editor widget from the arg_comm array. */
comment = "".
DO ix = 1 TO arg_comm#:
   comment = comment + arg_comm[ix] + (IF ix < arg_comm# THEN CHR(10) ELSE "").
END.

/* Position the integer and logical input widgets to where the 
   char widget is.  They will all overlap - only one will be 
   visible at a time.
*/
ASSIGN
   arg_chr:hidden IN FRAME pfedit = (IF arg_typ[1] = "c" THEN no ELSE yes)
   arg_int:hidden IN FRAME pfedit = (IF arg_typ[1] = "n" THEN no ELSE yes)
   arg_log:hidden IN FRAME pfedit = (IF arg_typ[1] = "l" THEN no ELSE yes)
   arg_chr:sensitive IN FRAME pfedit = yes
   arg_int:sensitive IN FRAME pfedit = yes
   arg_log:sensitive IN FRAME pfedit = yes.

ASSIGN
   plist = plist:ENTRY(1) IN FRAME pfedit
   prev_ix = 1.  /* Index of the choose before any value-changed event */

comment:WIDTH IN FRAME pfedit = plist:WIDTH IN FRAME pfedit.
DISPLAY labelstr plist comment WITH FRAME pfedit.
ENABLE plist comment btn_OK btn_Cancel {&HLP_BTN_NAME} WITH FRAME pfedit.

/* Cause 1st value to be reflected in editing widget. */
APPLY "VALUE-CHANGED" TO plist IN FRAME pfedit.

/* Have to reset tab positions manually because of invisible stuff.  
   Everthing after these will be pushed down automatically.
*/
ASSIGN
   ldummy = arg_chr:MOVE-AFTER-TAB-ITEM(plist:HANDLE IN FRAME pfedit).
   ldummy = arg_int:MOVE-AFTER-TAB-ITEM(arg_chr:HANDLE IN FRAME pfedit).
   ldummy = arg_log:MOVE-AFTER-TAB-ITEM(arg_int:HANDLE IN FRAME pfedit).

p_canned = TRUE.
DO ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE:
   WAIT-FOR CHOOSE OF btn_OK IN FRAME pfedit OR GO OF FRAME pfedit.
   p_canned = FALSE.
END.




