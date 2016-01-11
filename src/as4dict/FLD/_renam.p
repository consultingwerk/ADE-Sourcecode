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

File: _renam.p

Description:
   Display and handle the global Progress field rename dialog box.

Author: Laura Stern

Date Created: 03/27/92 
           Modified 03/13/95 D. McMann to work with Progress/400 Data Dictionary 
           Modified 10/27/95 D. McMann fix bug 95-10-19-055

----------------------------------------------------------------------------*/


{as4dict/dictvar.i shared}
{as4dict/brwvar.i shared}
{as4dict/menu.i shared}
{as4dict/uivar.i shared}
{adecomm/cbvar.i shared}
{as4dict/FLD/fldvar.i shared}

Define var Fld_Old_Name    as char     NO-UNDO.
Define var Fld_New_Name    as char     NO-UNDO.

form
   SKIP({&TFM_WID})

   "This changes the Progress name throughout all tables.  "
   	       	     view-as TEXT    	      	    at  2  SKIP
   "The new field name must not already be in use in any "
                     view-as TEXT                   at  2  SKIP
   "table in the database."
                     view-as TEXT                   at  2  SKIP
   SKIP({&VM_WIDG})

   Fld_Old_Name	     label "&Old Field Name"  	    colon 17
      	       	     format "x(32)"  {&STDPH_FILL}         SKIP({&VM_WID})
   Fld_New_Name	     label "&New Field Name"  	    colon 17
      	       	     format "x(32)"  {&STDPH_FILL}

   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = s_btn_OK
      &CANCEL = s_btn_Cancel
      &HELP   = s_btn_Help}

   with frame fld_rename
        view-as DIALOG-BOX TITLE "Globally Rename Fields"
        DEFAULT-BUTTON s_btn_OK CANCEL-BUTTON s_btn_Cancel
        SIDE-LABELS.



/*-------------------------------Triggers------------------------------------*/

/*-----WINDOW-CLOSE-----*/
on window-close of frame fld_rename
   apply "END-ERROR" to frame fld_rename
.

/*----- HIT of OK BUTTON or GO ----- */
on GO of frame fld_rename  /* or GO due to AUTO-GO */
do:
   Define var name   as char    NO-UNDO.
   Define var nname  as char    NO-UNDO.
   Define var num    as integer NO-UNDO.
   Define var isfroz as logical NO-UNDO.
   Define var isview as logical NO-UNDO.
   Define var issql  as logical NO-UNDO.
   Define var msg    as char  	NO-UNDO.
   Define var answer as logical NO-UNDO.

   name = input frame fld_rename Fld_Old_Name.
   if name = "" OR name = ? then
   do:
      message "Please enter the name of a field to rename."
      	       view-as ALERT-BOX ERROR  buttons OK.
      apply "entry" to Fld_Old_Name in frame fld_rename.
      return NO-APPLY.
   end.

   nname = input frame fld_rename Fld_New_Name.
   if nname = "" OR nname = ? then
   do:
      message "Please enter the new name."
      	       view-as ALERT-BOX ERROR  buttons OK.
      apply "entry" to Fld_New_Name in frame fld_rename.
      return NO-APPLY.
   end.

   /* Make sure none of the tables are frozen, views or sql tables.  If 
      this loop completes, num will be the number of tables that we
      found the field name in.
   */
   run adecomm/_setcurs.p ("WAIT").
   for each as4dict.p__File, 
       each as4dict.p__Field WHERE as4dict.p__Field._File-number = as4dict.p__File._File-number
                                                         AND as4dict.p__Field._Field-Name = name
                                                         AND as4dict.p__Field._Fld-Misc2[5] <> "A"
       while NOT (isfroz):

      isfroz = ( IF as4dict.p__File._Frozen = "Y" THEN TRUE ELSE FALSE).
      num = num + 1.      
   end.   
   run adecomm/_setcurs.p ("").

   msg = "".
   if isfroz then
      msg = "One or more of the tables containing this field is frozen.".
  
   if msg <> "" then
   do:
      message msg SKIP "You cannot rename."
      	      view-as ALERT-BOX ERROR
      	      buttons OK.
      return NO-APPLY.
   end.

   if num = 1 then
      message "There is 1 occurrence of this field." SKIP
      	      "Are you sure you want to rename it?"
      	      view-as alert-box question buttons YES-NO update answer.
   else
      message "There are" num "occurrences of this field." SKIP
      	      "Are you sure you want to rename them?"
      	      view-as alert-box question buttons YES-NO update answer.
   if NOT answer then
      return NO-APPLY.
end.


/*----- LEAVE of NEW NAME ----- */
on leave of Fld_Old_Name in frame fld_rename
do:
   Define var name as char    NO-UNDO.

   name = TRIM(Self:SCREEN-VALUE).
   SELF:screen-value = name.  /* redisplay trimmed name */

   if name = "" then return.

   if NOT can-find (FIRST as4dict.p__Field where as4dict.p__Field._Field-name = name
                                     and as4dict.p__Field._Fld-misc2[5] <> "A") then
   do:
      message "The field to rename is not in any table."
      	      view-as ALERT-BOX ERROR
      	      buttons OK.
      return NO-APPLY.
   end.
end.


/*----- LEAVE of NEW NAME ----- */
on leave of Fld_New_Name in frame fld_rename
do:
   Define var okay as logical NO-UNDO.
   Define var name as char    NO-UNDO.

   name = TRIM(Self:SCREEN-VALUE).
   SELF:screen-value = name.  /* redisplay trimmed name */

   if name = "" then return.

   if can-find (FIRST as4dict.p__Field where as4dict.p__Field._Field-name = name) then
   do:
      message "The new name is already in use in some table."
      	      view-as ALERT-BOX ERROR
      	      buttons OK.
      return NO-APPLY.
   end.

   /* Make sure the new name is a valid identifier for Progress. */
   run adecomm/_valname.p (INPUT name, INPUT true, OUTPUT okay).

   if NOT okay then
      return NO-APPLY. 
end.


/*----- HELP -----*/
on HELP of frame fld_rename OR choose of s_btn_Help in frame fld_rename
   RUN "adecomm/_adehelp.p" ("as4d", "CONTEXT", 
      	       	     	     {&AS4_Globally_Rename_Fields_Dlg_Box}, ?).


/*----------------------------Mainline code----------------------------------*/

Define var msg_text as char NO-UNDO.


/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "frame fld_rename" 
   &BOX   = "s_rect_Btns"
   &OK    = "s_btn_OK" 
   &HELP  = "s_btn_Help"
}

do ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE  ON STOP UNDO, LEAVE:
   update Fld_Old_Name 	
      	  Fld_New_Name
      	  s_btn_Ok   	
      	  s_btn_Cancel
      	  s_btn_Help
      	  with frame fld_rename.   

   run adecomm/_setcurs.p ("WAIT").

   for each as4dict.p__File,
       each as4dict.p__Field where as4dict.p__Field._Field-name = Fld_Old_Name
                                                         and as4dict.p__Field._File-number = as4dict.p__File._File-number
                                                          AND as4dict.p__Field._Fld-Misc2[5] <> "A":
   	ASSIGN  as4dict.p__Field._Field-name = Fld_New_Name 
   	                  as4dict.p__File._Fil-Misc1[1] = as4dict.p__File._Fil-Misc1[1] + 1
   	                  as4dict.p__File._Fil-Res1[8] = 1.      
   	 IF as4dict.p__File._Fil-res1[7] < 0 then assign as4dict.p__File._Fil-res1[7] = 0.                   
   end.

   /* Reflect the change in the edit field window if it's up. - Note
      if the user had typed over the name field but hasn't saved yet,
      this will clobber his change - TOO BAD!  Also change the value
      in the field list.
   */
   if s_win_Fld <> ? AND s_CurrFld = Fld_Old_Name then
   do:
      b_Field._Field-name = Fld_New_Name.
      display b_Field._Field-name with frame fldprops.
   end.

   if s_Flds_Cached then
   do:
      /* If there's more than one item in list and order is
      	 alphabetical, remove the entry and re-add to make sure
      	 new name is in alpabetical order.
      */
      if s_Order_By = {&ORDER_ALPHA} AND
         s_lst_Flds:NUM-ITEMS in frame browse > 1 then
      do:
       	 s_Res = s_lst_Flds:delete(Fld_Old_Name) in frame browse.
      	 run as4dict/FLD/_ptinlst.p (INPUT Fld_New_Name, INPUT 0).
      end.
      else do:
      	 /* Just change the name in place. */      	  
	 {as4dict/repname.i
	    &OldName = Fld_Old_Name
	    &NewName = Fld_New_Name
	    &Curr    = s_CurrFld
	    &Fill    = s_FldFill
	    &List    = s_lst_Flds}
      end.
   end.

   {as4dict/setdirty.i &Dirty = "true"}
end.

run adecomm/_setcurs.p ("").
hide frame fld_rename.
return.




