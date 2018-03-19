/*********************************************************************
* Copyright (C) 2000,2017 by Progress Software Corporation. All      *
* rights reserved. Prior versions of this work may contain portions  *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _trigdlg.p

Description:
   Code for handling the file and field trigger dialog boxes.  The user
   can add, delete and modify triggers.

Input Parameters:
   p_Obj    - Either {&OBJ_TBL} or {&OBJ_FLD} to indicate which kind of 
	      triggers we're working on.
   p_Events - A comma delimited list of the events appropriate for this
	      object type. 
   p_Name   - The widget handle for the name field in the parent dialog or
	      window for the table or field we are adding the trigger to.
   p_Help   - The help context for this dialog box 

Returns: "mod" if user made any changes in here,
	 "" otherwise.

Author: Laura Stern

Date Created: 10/29/92 

tomn     95/08/01   added support for "Event" and "Procedure" combo-box mnemonics
gfs      94/07/14   fixed 94-07-13-005.
gfs      94/07/07   fixed 94-06-14-073.
gfs      94/06/20   fixed 94-06-14-056.
gfs      94/05/24   removed cbdrop and implemented core combo-box widget
		    Bug 94-05-09-078
hutegger 94/02/10   commented LARGE-attribut in editor-widget (BUG:94-02-09-034) 
McMann   98/07/10   Added DBVERSION and _Owner check for _file.
McMann   98/10/08   Added available check for b_file.
McMann   99/10/15   Changed DBVERSION check to use DICTDB
Rohit    9/15/2017  Modified trig_proc to X(255)- PSC00360752
----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared} /* Common UI definitions */

Define INPUT PARAMETER p_Obj     as integer         NO-UNDO.
Define INPUT PARAMETER p_Events  as char            NO-UNDO.
Define INPUT PARAMETER p_Name    as widget-handle   NO-UNDO.
Define INPUT PARAMETER p_Help    as integer         NO-UNDO.

Define shared buffer b_File  for _File.
Define shared buffer b_Field for _Field.
Define        buffer b_ttrig for _File-Trig.
Define        buffer b_ftrig for _Field-Trig.

/* Trigger attributes for form */
Define var trig_event      as char    format "x(18)"                 
				      view-as combo-box sort       NO-UNDO.
Define var trig_proc       as char    format "x(255)"
				      view-as fill-in size 25 by 1 NO-UNDO.
Define var trig_crc        as logical view-as TOGGLE-BOX           NO-UNDO.
Define var trig_override   as logical view-as TOGGLE-BOX           NO-UNDO.

/* Variable containing trigger code being editted */
Define var trig_txt as char NO-UNDO
	 VIEW-AS EDITOR /*LARGE*/ SCROLLBAR-VERTICAL SCROLLBAR-HORIZONTAL 
	 SIZE 74 BY 10. 


/* Defines common buttons etc, used here and by UIB */
{adecomm/trigdlg.i 
   &Insert_Lbl = "&Insert File..." 
   &Insert_Wid = 17
   &Apply_Action = "Save"
}
		  
/* Other Buttons for form.  Don't use standard close or cancel button. 
   If it's auto-endkey, all the changes in the dialog will be undone.
*/
Define button btn_Close   label "Cancel" {&STDPH_OKBTN}.
Define button btn_file    label "Fi&les..." SIZE 9 by 1.125.

/* Miscellaneous */
Define var new_trig     as logical NO-UNDO.          
Define var tmpfile      as char    NO-UNDO.
Define var new_crc_val  as integer NO-UNDO.
Define var old_crc_val  as integer NO-UNDO.
Define var proc_read    as char    NO-UNDO 
			init "" case-sens.  /* last file read in */ 
Define var committed    as logical NO-UNDO. /* Is table/fld committed to DB? */
Define var can_update   as logical NO-UNDO. /* user has privileges */
Define var new_trigfile as logical NO-UNDO. /* TrigFile changed */
DEFINE VAR trig_event_lbl AS CHAR FORMAT "X(7)"  VIEW-AS TEXT INIT "Eve&nt:".
DEFINE VAR trig_proc_lbl  AS CHAR FORMAT "X(11)" VIEW-AS TEXT INIT "Proc&edure:".

FORM
   SKIP({&TFM_WID})

   trig_event_lbl  at  2 NO-LABEL
   trig_proc_lbl   at 27 NO-LABEL
   "Options: "     at 64 view-as TEXT
   trig_crc        at 73 LABEL "Chec&k CRC" 
   SKIP({&VM_WID})
   
   trig_event      at  2 NO-LABEL {&STDPH_FILL} SPACE(0)
   trig_proc       at 27 NO-LABEL {&STDPH_FILL} SPACE(.3)
   btn_File                     
   trig_override   at 73 LABEL "Overrida&ble"
   SKIP ({&VM_WID})
	  
   trig_txt              NO-LABEL {&STDPH_ED4GL}

   {&TRIG_LAYOUT}
   SKIP({&VM_WIDG})

   s_Status        at  2 NO-LABEL format "x(50)" 
			 view-as TEXT
   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = s_btn_OK
      &CANCEL = s_btn_Save /* where cancel btn usually is */
      &OTHER  = "SPACE({&HM_DBTN}) btn_Close"
      &HELP   = s_btn_Help}

   with frame trigedit 
      DEFAULT-BUTTON s_btn_OK CANCEL-BUTTON btn_Close
      THREE-D NO-LABELS SCROLLABLE VIEW-AS DIALOG-BOX.

/* Added to support mnemonics in MS-WINDOWS for combo-box labels (tomn 8/1/95) */      
ASSIGN
  trig_event:SIDE-LABEL-HANDLE IN FRAME trigedit = trig_event_lbl:HANDLE
  trig_proc:SIDE-LABEL-HANDLE  IN FRAME trigedit = trig_proc_lbl:HANDLE
  trig_event:LABEL = trig_event_lbl
  trig_proc:LABEL = trig_proc_lbl.

/*========================Internal Procedures===============================*/

/* These provide editor functionality */
{adecomm/dedit.i}    /* Edit Defines */
{adecomm/dsearch.i}  /* Search Defines */
{adecomm/pedit.i}    /* Edit Procedures */
{adecomm/psearch.i}  /* Search Procedures */


/*--------------------------------------------------------------
   Initialize the widgets for a new trigger.

   Input Parameter:
      p_All - true = initialize all attributes,
	      false = only initialize the trigger code contents.
---------------------------------------------------------------*/
PROCEDURE Init_Trigger:

   Define INPUT PARAMETER p_All as logical NO-UNDO.

   if p_All then 
   do:
      assign
	 trig_proc      = ""
	 trig_override  = no
	 trig_crc       = (if committed then yes else no)
	 tgl_syntax     = (if committed then yes else no).
      display trig_proc trig_override trig_crc tgl_syntax
	      with frame trigedit.
   end.

   /* Set default trigger code in widget and underlying variable. 
      Use the name from the parent dialog or window to get the name
      of the new table or field or the modified name from an existing
      object.
   */
   trig_txt =
      "TRIGGER PROCEDURE FOR " + trig_event + " OF " + 
      (if p_Obj = {&OBJ_FLD} then s_Currtbl + "." + p_Name:screen-value
			     else p_Name:screen-value) + 
      ".".
   trig_txt:screen-value in frame trigedit = trig_txt.

   /* Set the cursor to after predefined portion of text. */
   trig_txt:CURSOR-OFFSET in frame trigedit = LENGTH(trig_txt) + 1. 
end.


/*--------------------------------------------------------------
   Get the trigger for the event currently in the event fill-in,
   if there is one defined, and initialize the dialog widgets 
   with this trigger's attributes.

   Input Parameter:
      p_refresh - true - if we need to show values on the screen
		  and re-read the trigger from the file.
		  false - if we just save the trigger and we
		  just need to reset program variable etc.
---------------------------------------------------------------*/
PROCEDURE Get_Trigger:

Define INPUT PARAMETER refresh as logical NO-UNDO.

Define var fname      as char    NO-UNDO.  /* file name */
Define var read       as logical NO-UNDO.  /* i.e., past tense of read */

   assign
      new_trig = false
      trig_event = trig_event:screen-value in frame trigedit
      old_crc_val = ?.

   if p_Obj = {&OBJ_TBL} then
   do:
      find b_ttrig of b_File where b_ttrig._Event = trig_event NO-ERROR.
      if AVAILABLE b_ttrig then
	 assign
	    trig_proc      = b_ttrig._Proc-Name
	    trig_override  = b_ttrig._Override
	    trig_crc       = (if b_ttrig._Trig-CRC = ? then no else yes)
	    old_crc_val    = b_ttrig._Trig-CRC.
      else
	 new_trig = true.
   end.
   else do:
      find b_ftrig of b_Field where b_ftrig._Event = trig_event NO-ERROR.
      if AVAILABLE b_ftrig then
	 assign
	    trig_proc      = b_ftrig._Proc-Name
	    trig_override  = b_ftrig._Override
	    trig_crc       = (if b_ftrig._Trig-CRC = ? then no else yes)
	    old_crc_val    = b_ftrig._Trig-CRC.
      else
	 new_trig = true.
   end.
   new_crc_val = old_crc_val. 

   if new_trig then
      run Init_Trigger (INPUT true).
   else do:
      tgl_syntax = trig_crc.  /* have to compile to get crc value */
      if refresh then
      do:
	 display trig_proc trig_override trig_crc tgl_syntax
		 with frame trigedit.

	 /* Look for this procedure and load it if it's out there. */
	 fname = SEARCH(trig_proc). /* get the full file name */
	 if fname = ? then 
	 do:
	    read = false.
	    message "Cannot find trigger procedure" trig_proc SKIP
		    "Initializing trigger code for new procedure."
		    view-as ALERT-BOX ERROR buttons OK.
	 end.
	 else 
	    read = trig_txt:read-file(fname) in frame trigedit. 
      end.
      else read = true.
      
      if NOT read then
	 /* Set code to initial default value. */
	 run Init_Trigger (INPUT false).
      else
	 /* Save this original trigger text in the underlying variable for
	    later comparison to editor widget value.
	 */
	 trig_txt = trig_txt:screen-value in frame trigedit.

      /* Set the cursor to start of trigger. */
      /* gfs: added 'if refresh' to keep cursor from moving back
       * to the top after a SAVE
       */
      if refresh then trig_txt:CURSOR-OFFSET in frame trigedit = 1.
   end.
   proc_read = trig_proc.  /* remember which proc was read last */

   /* You can only delete an existing trigger so: */
   btn_delete:sensitive = (if NOT new_trig AND can_update then yes else no).
end.


/*--------------------------------------------------------------
   Check to see if anything attributes for the given event has 
   been changed by the user.

   Output Parameter:
      p_Changed - Set to true if anything changed, 
		  false otherwise.
---------------------------------------------------------------*/
PROCEDURE Trig_Changed:

   Define OUTPUT PARAMETER p_Changed as logical NO-UNDO.

   Define var old_proc as char NO-UNDO case-sens.
   Define var new_proc as char NO-UNDO case-sens.

   /* Case matters in file names on Unix */
   assign
      old_proc = trig_proc
      new_proc = input frame trigedit trig_proc.

   p_Changed = 
      (if old_proc      = new_proc                           AND
	  trig_crc      = input frame trigedit trig_crc      AND
	  trig_override = input frame trigedit trig_override AND
	  trig_txt      = input frame trigedit trig_txt    
      then false else true).

   /* Only if we're going to save crc, check if it's different.  Otherwise
      old value will be ? and new val may be something else because
      user checked syntax - this shouldn't show up as a change.
   */
   if NOT p_Changed AND
      input frame trigedit trig_crc AND 
      old_crc_val <> new_crc_val then
	 p_Changed = true.
end.

   
/*--------------------------------------------------------------
   Save this trigger - which really means create a new one or  
   modify an existing one (by delete and recreate).  
   trig_event is the event of the current trigger we're trying 
   to save.

   Output Parameters:
      p_Save - yes, if save was successful, no otherwise.  
---------------------------------------------------------------*/
PROCEDURE Save_Trigger:

   Define OUTPUT PARAMETER p_Save  as logical NO-UNDO.

   Define var fname        as char    NO-UNDO.
   Define var saved        as logical NO-UNDO.
   Define var tproc        as char    NO-UNDO.
   Define var crc          as logical NO-UNDO.
   
   tproc = input frame trigedit trig_proc.
   p_Save = no.
   if tproc = "" then
   do:
      message "Please enter the name of a file to store" SKIP
	      "the trigger code in."
	       view-as ALERT-BOX ERROR buttons OK.
      apply "entry" to trig_proc in frame trigedit.
      return.         
   end.
   
   run adecomm/_setcurs.p ("WAIT").
   save_block:
   do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
      if NOT new_trig then
      do:
	 /* You can't modify a trigger def, so delete this one and
	    recreate it. 
	 */
	 if p_Obj = {&OBJ_TBL} then
	    delete b_ttrig.
	 else
	    delete b_ftrig.
      end.   

      /* If the trigger code wasn't recompiled, new_crc_val will equal
	 the original value.  So if user wants to check crc save this
	 and we'll either get the new value or reset it to the original.
      */
      crc = input frame trigedit trig_crc.
      if p_Obj = {&OBJ_TBL} then
      do:
	 create b_ttrig.
	 assign
	    b_ttrig._File-Recid = RECID(b_File)
	    b_ttrig._Event = trig_event
	    b_ttrig._Proc-Name = tproc
	    b_ttrig._Override = input frame trigedit trig_override
	    b_ttrig._Trig-CRC = (if NOT crc then ? else new_crc_val).
      end.
      else do:
	 create b_ftrig.
	 assign
	    b_ftrig._File-Recid = s_TblRecId
	    b_ftrig._Field-Recid = RECID(b_Field)
	    b_ftrig._Event = trig_event
	    b_ftrig._Proc-Name = tproc
	    b_ftrig._Override = input frame trigedit trig_override.
	    b_ftrig._Trig-CRC = (if NOT crc then ? else new_crc_val).
      end.

      /* Save the code in the OS file. If we can't find the file, 
	 it will be saved in the current directory */
      fname = SEARCH(tproc).
      if fname = ? then fname = tproc.
      saved = trig_txt:SAVE-FILE(fname) in frame trigedit.
      if NOT saved then 
      do:
	 message "Unable to save trigger code in file."
		 view-as alert-box error buttons ok.
	 UNDO save_block, LEAVE save_block.
      end.

      old_crc_val = new_crc_val. /* Reset old val to match stored value */
      if NOT s_Adding then
	 {adedict/setdirty.i &Dirty = "true"}
      p_Save = yes.
      display "Trigger Saved" @ s_Status with frame trigedit.
      if btn_Close:label in frame trigedit <> "Close" then
	 btn_Close:label in frame trigedit = "Close".
   end.

   run adecomm/_setcurs.p ("").
   return.  
end.


/*--------------------------------------------------------------
   Determine if a syntax check is needed or do it anyway if
   "force" is true.  If the syntax check is done, reposition  
   the cursor to the offending spot of there is an error.

   Input Parameters:
      p_Force - compile unconditionally.  Also, if this is true,
		put up "success" message in an alert box, othewise
		use the status area.

   Output Parameters:
      p_Compiled - yes, if compile was successful, no otherwise.
---------------------------------------------------------------*/
PROCEDURE Check_Syntax:

   Define INPUT  PARAMETER p_Force    as logical NO-UNDO.   
   Define OUTPUT PARAMETER p_Compiled as logical NO-UNDO.

   /* Check syntax 
      if forced, or 
      if it's a new trigger and auto-check is on (which we've forced on 
	 if crc is yes) or
      if it's not a new trigger and crc is yes - user could have modified
	 the trigger code outside the dictionary and just want to reset
	 the crc value, so even if nothing's been modified, recompile - or
      if it's not a new trigger, user changed the trig code and says
	 auto-check (which again must be on if crc is yes)
   */
   p_Compiled = yes.
   if NOT (p_Force OR
	   (new_trig AND input frame trigedit tgl_syntax) OR
	   (NOT new_trig AND input frame trigedit trig_crc) OR
	   (NOT new_trig AND input frame trigedit tgl_syntax AND
	    trig_txt <> trig_txt:screen-value in frame trigedit)) then
      return.

   /* Store trigger code in temporary file and compile it. */
   run adecomm/_setcurs.p ("WAIT").
   run adecomm/_tmpfile.p (INPUT "", INPUT ".dct", OUTPUT tmpfile).
   s_Res = trig_txt:SAVE-FILE(tmpfile) in frame trigedit.

   compile VALUE(tmpfile) NO-ERROR.
   run adecomm/_setcurs.p ("").

   if compiler:error then 
   do:
      message error-status:get-message(1)
	 view-as alert-box error buttons OK.
      assign
	 trig_txt:CURSOR-OFFSET in frame trigedit = 
	    INTEGER(compiler:FILE-OFFSET).
	 p_Compiled = no.
      apply "entry" to trig_txt in frame trigedit.
   end.
   else do:
      rcode-info:filename = tmpfile.
      new_crc_val = rcode-info:crc-value.
      if p_Force then
	 message "Syntax is Correct" view-as alert-box information buttons ok.
      else
	 display "Syntax is Correct" @ s_Status with frame trigedit.
   end.

   OS-DELETE VALUE(tmpfile).
end.


/*--------------------------------------------------------------
   Do OK processing which also happens automatically when the
   user switches to another trigger.

   Input Parameters:
      p_NoSaveMsg - True if we should display no save because of
		    no change message.

   Output Parameters:
      p_Success - Set to yes if we didn't need to do anything
		  or if we did everything went all right.
---------------------------------------------------------------*/
PROCEDURE Do_Ok:

   Define INPUT  PARAMETER p_NoSaveMsg as logical NO-UNDO.
   Define OUTPUT PARAMETER p_Success   as logical NO-UNDO.

   Define var changed  as logical NO-UNDO.

   p_Success = yes.
   run Trig_Changed (OUTPUT changed).  

   /* For existing triggers we will check syntax anyway if crc 
      is yes in case the code was changed outside the dictionary -
      we need the new crc value.
   */
   if (new_trig AND changed) OR
       (NOT new_trig) then
   do:
      run Check_Syntax (INPUT false, OUTPUT p_Success).
      /* Another thing that may be different now is the crc value */
      if input frame trigedit trig_crc AND
	 new_crc_val <> old_crc_val then
	    changed = true.
   end.

   /* Assuming no syntax errors (or we didn't try to compile), try
      to save only if something's changed.
   */
   if p_Success then
      if changed then
	 run Save_Trigger (OUTPUT p_Success).
      else if p_NoSaveMsg then
	 display "Nothing was changed.  No save was done." @ s_Status
	    with frame trigedit.
end.


/*--------------------------------------------------------------
   We've already set a flag (committed) to indicate whether or
   not the table and/or field that the trigger belongs to 
   have been committed to the database or not.  If not, the
   trigger will definitely not compile because we know the
   trigger refers to that object and we know it is not in the schema
   cache yet.  Of course, other un-committed tables, field, indexes
   or sequences may be referenced by the trigger and there's 
   no way for us to know that.

   So at least, if we know, put up a message explaining what
   is going on.
---------------------------------------------------------------*/
PROCEDURE Check_Committed:

   if NOT committed then
   do:
      message "Trigger code that references uncommitted schema objects"  SKIP
	      "(e.g., a table or field that you've just created in"     SKIP
	      "this dictionary session) will not compile successfully." SKIP(1)
	      "This is the case with this trigger."                     SKIP(1)
	      "You can save your trigger code now but if you want"      SKIP
	      "to make sure there are no syntax errors, you must"       SKIP
	      "commit all your changes first (use the menu: "           SKIP
	      "Edit->Commit Transaction)."                              SKIP(1)
	      "NOTE: Choosing ~"Check CRC~" will require that the"      SKIP
	      "trigger code be compiled before it is saved."
	 view-as ALERT-BOX INFORMATION buttons OK.
      return "error".
   end.
   return "".            
end.


/*===============================Triggers=============================*/

/* Text editing triggers */
{adecomm/trigtrig.i &Frame = "frame trigedit"}


/*-----WINDOW-CLOSE-----*/
on window-close of frame trigedit
   apply "END-ERROR" to frame trigedit.


/*----- HELP -----*/
on HELP of frame trigedit OR choose of s_btn_Help in frame trigedit
    RUN "adecomm/_kwhelp.p" (INPUT trig_txt:HANDLE,
                             INPUT "dict"  , 
                             INPUT p_Help ).

/*----- SELECTION of OK BUTTON or GO -----*/
on GO of frame trigedit   /* or OK due to AUTO-GO */
do:

   Define var success as logical NO-UNDO init yes.
   Define var procval as char    NO-UNDO case-sens.

   procval = TRIM(trig_proc:screen-value in frame trigedit).
   trig_proc:screen-value in frame trigedit = procval. 
   if   SEARCH(procval) <> ?
    and new_trigfile = true   /* did user just want to use */
    then do:          /* a different file as trigger-code? */
     assign new_trigfile = false.
     RETURN NO-APPLY. 
     end.

   run Do_Ok (INPUT false, OUTPUT success).
   if NOT success then
      return NO-APPLY.
end.


/*----- SELECTION of SAVE BUTTON -----*/
on choose of s_btn_Save in frame trigedit
do:
   Define var success as logical NO-UNDO init yes.

   /* In case save button was pushed with accelerator */
   {adedict/forceval.i}

   run Do_Ok (INPUT true, OUTPUT success).
   if success then
      run Get_Trigger (false).
end.

/*---- VALUE-CHANGED of EVENT-----*/
on value-changed of trig_event in frame trigedit
do:

   Define var success as logical NO-UNDO init yes.

   /* NOTE: trig_event is the value before it just got
      changed. 
   */

   run Do_Ok (INPUT false, OUTPUT success).

   if success then
   do:
      /* Save new current event in underlying variable */
      trig_event = trig_event:screen-value in frame trigedit.     
   
      /* Get the trigger associated with the new event chosen. */
      Run Get_Trigger (true).
   end.
   else do:
      /* Either there was a syntax error or a save error.
	 Reset the event back to what it was and stay put.
      */
      assign
	 trig_event:screen-value in frame trigedit = trig_event.
      return NO-APPLY.
   end.

   FIND FIRST _file where _file-name eq p_Name:screen-value.
   IF AVAIL _file THEN
   DO:
      IF trig_event = "DELETE" and _File._File-attributes[6] EQ TRUE THEN
         ENABLE 
	     trig_event 
      	     trig_proc   btn_File  
	     trig_crc    trig_override 
	     trig_txt 
	     btn_cut     btn_copy      btn_paste
	     btn_find    btn_prev      btn_next
	     btn_replace btn_insert
	     btn_delete  btn_revert
	     btn_now     tgl_syntax
	     s_btn_OK    s_btn_Save
	     btn_Close   s_btn_Help
	     with frame trigedit.
      ELSE IF _File._File-attributes[6] EQ FALSE and _file._frozen = false THEN
         ENABLE
	     trig_event 
	     trig_proc   btn_File  
	     trig_crc    trig_override 
	     trig_txt 
	     btn_cut     btn_copy      btn_paste
	     btn_find    btn_prev      btn_next
	     btn_replace btn_insert
	     btn_revert
	     btn_now     tgl_syntax
	     s_btn_OK    s_btn_Save
	     btn_Close   s_btn_Help
	     with frame trigedit.
      ELSE
         DISABLE all except trig_event 
	         btn_Close  s_btn_Help
	         with frame trigedit.
   END.
END.


/*---- LEAVE of PROC NAME -----*/
on leave of trig_proc in frame trigedit
do:
   Define var fname   as char    NO-UNDO.
   Define var answer  as logical NO-UNDO.
   Define var procval as char    NO-UNDO case-sens.

   /* proc_read keeps track of the name of last file that was read into
      the editor widget.  If it hasn't changed, don't do anything.
   */
   procval = TRIM(trig_proc:screen-value in frame trigedit).
   trig_proc:screen-value in frame trigedit = procval. 
   if proc_read = procval then
      return.

   /* If this procedure exists already, ask the user what he wants. */
   fname = SEARCH(procval).
   if fname <> ? then 
   do:
      answer = ?.
      message "This file already exists." SKIP
	      "Do you want to read it in?" SKIP
	      "Select:" SKIP
	      "   Yes to use the contents of the existing file" SKIP
	      "   No to overwrite the file's contents" SKIP
	      "   Cancel to enter a different file name."
	      view-as ALERT-BOX QUESTION buttons YES-NO-CANCEL update answer.
      if answer then
      do:
	 s_Res = trig_txt:read-file(fname) in frame trigedit.
	 trig_txt = trig_txt:screen-value in frame trigedit.
      end.
      else if answer = ? then /* user chose Cancel */
      do:
	 s_Valid = no.
	 return NO-APPLY.
      end.
   end.
   assign
     new_trigfile = true
     proc_read    = procval.
end.


/*----- VALUE-CHANGED of CHECK CRC TOGGLE -----*/
on value-changed of trig_crc in frame trigedit
do:
   /* If user wants to check crc and it was not on before
      he must compile before saving.
   */
   if SELF:screen-value = "yes" then
   do:
      run Check_Committed.
      if return-value = "error" then
      do:
	 SELF:screen-value = "no".
	 return.
      end.

      tgl_syntax:screen-value in frame trigedit = "yes".
   end.
end.


/*----- VALUE-CHANGED of TGL_SYNTAX TOGGLE -----*/
on value-changed of tgl_syntax in frame trigedit
do:
   /* If user wants to check crc, he must compile before saving */
   if SELF:screen-value = "no" then
      trig_crc:screen-value in frame trigedit = "no".
   else do:  
      /* User is trying to set auto-check on */
      run Check_Committed.
      if return-value = "error" then
	 SELF:screen-value = "no".
   end.
end.


/*----- CHOOSE of BUTTON INSERT -----*/
on choose of btn_insert in frame trigedit
   run InsertFile (h_Editor).

 
/*---- SELECTION of CHECK SYNTAX BUTTON -----*/
on choose of btn_now in frame trigedit
do:
   Define var err as logical NO-UNDO.

   run Check_Committed.
   if return-value = "error" then
      return NO-APPLY.

   run Check_Syntax (INPUT true, OUTPUT err).
end.


/*---- SELECTION of REVERT BUTTON -----*/
on choose of btn_revert in frame trigedit
do:
   display trig_proc trig_crc trig_override trig_txt 
	   with frame trigedit.   
   
   /* Reset last proc_read and crc value */
   assign
      proc_read = trig_proc
      new_crc_val = old_crc_val.
end.


/*---- SELECTION of DELETE BUTTON -----*/
on choose of btn_delete in frame trigedit
do:
   Define var answer as logical NO-UNDO.

   message "Are you sure you want to delete the" trig_event "trigger?"
      view-as ALERT-BOX QUESTION buttons YES-NO update answer.
   if answer = no then return.

   if NOT new_trig then
   do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
      if p_Obj = {&OBJ_TBL} then
	 delete b_ttrig.
      else
	 delete b_ftrig.
   
      if NOT s_Adding then    /* if not adding table or field */
	 {adedict/setdirty.i &Dirty = "true"}
      if btn_Close:label in frame trigedit <> "Close" then
	 btn_Close:label in frame trigedit = "Close".
   end.
  
   /* Reinitialize widgets */
   run Init_Trigger (INPUT true).
   new_trig = true.
   btn_delete:sensitive in frame trigedit = no.
end.


/*---- SELECTION of FILE BUTTON -----*/
on choose of btn_file in frame trigedit
do:
   Define var pname      as char    NO-UNDO.
   Define var picked_one as logical NO-UNDO.

   pname = trig_proc:screen-value in frame trigedit.
   system-dialog GET-FILE pname 
		 filters            "*.p" "*.p"
		 default-extension  ".p"
		 title              "Find Trigger Procedure" 
		 update             picked_one.
   if picked_one then   
   do:
      trig_proc:screen-value in frame trigedit = pname.
      s_Res = trig_txt:read-file(pname) in frame trigedit.
      trig_txt = trig_txt:screen-value in frame trigedit.
      proc_read = pname.
   end.
end.


/*---- LEAVE of EVENT FILL-IN -----*/
/* Syntax is only checked if they click on Now button or if they
   switch triggers. Saved status is only displayed when you switch
   triggers or hit save button - so we only need to clear status on 
   leave of these two widgets.
*/
on leave of trig_event, btn_now, s_btn_Save in frame trigedit
   display "" @ s_Status with frame trigedit.  /* clear status line */


/*===========================Mainline code==================================*/

/* Deal with privileges  
   To simplify we will do the following.  If the user does not have read
   privileges - he can't do anything.  If he does not have write, create or
   delete privileges than he can see triggers but cannot do anything else.
   To prevent this we will disable everything but the event drop down.
*/
IF NOT AVAILABLE b_File THEN
  FIND b_File WHERE RECID(b_File) = s_TblRecId NO-LOCK.

IF INTEGER(DBVERSION("DICTDB")) > 8 THEN DO:
  if p_Obj = {&OBJ_TBL} then
    find _File WHERE _File._File-name = "_File-Trig"
                 AND _File._Owner = "PUB"
                 NO-LOCK.
  else
    find _File WHERE _File._File-name = "_Field-Trig"
                 AND _File._Owner = "PUB"
                 NO-LOCK.
END.
ELSE DO:
  if p_Obj = {&OBJ_TBL} then
     find _File "_File-Trig".
  else
     find _File "_Field-Trig".
END.

if NOT can-do(_File._Can-read, USERID("DICTDB")) then
do:
   message s_NoPrivMsg "see trigger definitions."
	   view-as ALERT-BOX ERROR buttons Ok.
   return.
end.


if p_Obj = {&OBJ_TBL} then do:
   can_update = NOT s_Tbl_ReadOnly.
end.
else
   can_update = NOT s_Fld_ReadOnly.


if ( NOT can-do(_File._Can-write, USERID("DICTDB")) OR
     NOT can-do(_File._Can-create, USERID("DICTDB")) OR
     NOT can-do(_File._Can-delete, USERID("DICTDB")) ) then 
do:
   message s_NoPrivMsg "either create, update or delete trigger definitions.".
   can_update = no.
end.

/* See if the table or field we are adding/editing is committed to the
   database yet.  This is done by compiling a little program that
   accesses the object and seeing if it compiles. 
   There's no nice way to suppress compile errors from showing
   up on the screen (e.g., NO-ERROR won't do it) so do output to 
   file to redirect them so the user won't see anything.
*/
run adecomm/_tmpfile.p (INPUT "", INPUT ".dct", OUTPUT tmpfile).
output to VALUE(tmpfile).
do ON STOP UNDO, LEAVE:
   if p_Obj = {&OBJ_TBL} then
      run adecomm/_istbl.i VALUE(s_CurrDb) 
			   VALUE(p_Name:screen-value).
   else
      run adecomm/_isfld.i VALUE(s_CurrDb) 
			   VALUE(s_CurrTbl) 
			   VALUE(p_Name:screen-value).
END.
output close.
os-delete VALUE(tmpfile).
committed = NOT compiler:error.

/* Customize the title to reflect table vs. field. */
frame trigedit:title = (if p_Obj = {&OBJ_TBL} then "Table Triggers"
					      else "Field Triggers").

/* Fill the event select list and default the current event to the first
   one in the list.  Set auto-indent on editor widget.
   Set return-insert so Return doesn't hit default button in editor widget.
*/
assign
   trig_event:LIST-ITEMS in frame trigedit = p_Events
   trig_event:INNER-LINES in frame trigedit = 
   trig_event:NUM-ITEMS in frame trigedit
   trig_event = trig_event:ENTRY(1) in frame trigedit
   trig_event:screen-value = trig_event
   
   h_Editor = trig_txt:HANDLE in frame trigedit /* used by trigdlg.i */
   trig_txt:RETURN-INSERT = yes
   trig_txt:AUTO-INDENT in frame trigedit = true.

   
/* Run time layout.  This defines eff_frame_width */
{adecomm/okrun.i  
   &FRAME = "frame trigedit" 
   &BOX   = "s_rect_Btns"
   &OK    = "s_btn_OK" 
   &HELP  = "s_btn_Help"
}

run Adjust_Trig_Layout 
   (INPUT eff_frame_width,
    INPUT tgl_syntax_lbl:HANDLE in frame trigedit,
    INPUT btn_now:HANDLE in frame trigedit,
    INPUT tgl_syntax:HANDLE in frame trigedit,
    INPUT btn_replace:HANDLE IN FRAME trigedit,
    INPUT btn_next:HANDLE IN FRAME trigedit,
    INPUT btn_prev:HANDLE IN FRAME trigedit,
    INPUT btn_find:HANDLE IN FRAME trigedit,
    INPUT btn_insert:HANDLE IN FRAME trigedit,
    INPUT btn_copy:HANDLE IN FRAME trigedit,
    INPUT btn_paste:HANDLE IN FRAME trigedit,
    INPUT btn_delete:HANDLE IN FRAME trigedit,
    INPUT btn_revert:HANDLE IN FRAME trigedit).

/* Initialize the widgets with the trigger defined on the first event
   in the event list - if there is one.
*/
run Get_Trigger (true).

display tgl_syntax_lbl with frame trigedit.
if can_update then
   enable 
	  trig_event 
	  trig_proc   btn_File  
	  trig_crc    trig_override 
	  trig_txt 
	  btn_cut     btn_copy      btn_paste
	  btn_find    btn_prev      btn_next
	  btn_replace btn_insert
	  btn_revert
	  btn_now     tgl_syntax
	  s_btn_OK    s_btn_Save
	  btn_Close   s_btn_Help
	  with frame trigedit.
else
   enable trig_event 
	  btn_Close  s_btn_Help
	  with frame trigedit.

/* Fix up TAB positions for everything not in enable list */
assign
   s_Res        = btn_delete:move-before-tab-item(btn_revert:HANDLE) in frame trigedit
   new_trigfile = false.

do ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE:
   wait-for choose of s_btn_OK in frame trigedit,
		      btn_Close in frame trigedit OR
	    GO of frame trigedit 
	    FOCUS trig_event.
end.

hide frame trigedit.
if btn_Close:label in frame trigedit = "Close" then
   return "mod".
else
   return "".




