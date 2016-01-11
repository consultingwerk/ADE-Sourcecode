/***********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

/*----------------------------------------------------------------------------

File: _renam.p

Description:
   Display and handle the global field rename dialog box.

Author: Laura Stern

Date Created: 03/27/92 
    Modified: D. McMann 06/29/98 Added _Owner check to find of _File.

----------------------------------------------------------------------------*/


&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/brwvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared}
{adecomm/cbvar.i shared}
{adedict/FLD/fldvar.i shared}

DEFINE VARIABLE Fld_Old_Name    AS CHARACTER     NO-UNDO.
DEFINE VARIABLE Fld_New_Name    AS CHARACTER     NO-UNDO.
DEFINE VARIABLE msgRenam        AS CHARACTER VIEW-AS EDITOR NO-BOX INNER-CHARS 62 INNER-LINES 2 NO-UNDO.

FORM
   SKIP({&TFM_WID})
&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
   msgRenam NO-LABELS AT 2 SKIP
&ELSE
   "This renames a field throughout all tables. The new field name" VIEW-AS TEXT    	      	    AT  2  SKIP
   "must not already be in use in any table in the database." VIEW-AS TEXT AT 2  SKIP
&ENDIF 
   SKIP({&VM_WIDG})

   Fld_Old_Name	     label "&Old Field Name" COLON 18     	       	   
                    format "x(32)"  {&STDPH_FILL}         SKIP({&VM_WID})
   Fld_New_Name	     label "&New Field Name" COLON 18
      	             format "x(32)"  {&STDPH_FILL}

   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = s_btn_OK
      &CANCEL = s_btn_Cancel
      &HELP   = s_btn_Help}

   WITH FRAME fld_rename THREE-D
        VIEW-AS DIALOG-BOX TITLE "Globally Rename Fields"
        DEFAULT-BUTTON s_btn_OK CANCEL-BUTTON s_btn_Cancel
        SIDE-LABELS.

IF SESSION:SCHEMA-CHANGE = "New Objects" THEN DO:
   MESSAGE 'You can not rename fields when SESSION:SCHEMA-CHANGE = "New Objects".'
       VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
  ASSIGN msgRenam:SCREEN-VALUE =
    "This renames a field throughout all tables. The new field name " +
    "must not already be in use in any table in the database.".
    msgRenam:READ-ONLY = yes.

  ENABLE msgRenam WITH FRAME fld_rename.
&ENDIF

/*-------------------------------Triggers------------------------------------*/

/*-----WINDOW-CLOSE-----*/
on window-close of frame fld_rename
   apply "END-ERROR" to frame fld_rename.

/*----- HIT of OK BUTTON or GO ----- */
on GO of frame fld_rename  /* or GO due to AUTO-GO */
do:
   DEFINE VARIABLE name   AS CHARACTER    NO-UNDO.
   DEFINE VARIABLE nname  AS CHARACTER    NO-UNDO.
   DEFINE VARIABLE num    AS INTEGER      NO-UNDO.
   DEFINE VARIABLE isfroz AS LOGICAL      NO-UNDO.
   DEFINE VARIABLE isview AS LOGICAL      NO-UNDO.
   DEFINE VARIABLE issql  AS LOGICAL      NO-UNDO.
   DEFINE VARIABLE msg    AS CHARACTER    NO-UNDO.
   DEFINE VARIABLE answer AS LOGICAL      NO-UNDO.

   name = input frame fld_rename Fld_Old_Name.
   if name = "" OR name = ? then
   do:
      message "Please enter the name of a field to rename."
      	       VIEW-AS ALERT-BOX ERROR  buttons OK.
      apply "entry" to Fld_Old_Name in frame fld_rename.
      return NO-APPLY.
   end.

   nname = input frame fld_rename Fld_New_Name.
   if nname = "" OR nname = ? then
   do:
      message "Please enter the new name."
      	       VIEW-AS ALERT-BOX ERROR  buttons OK.
      apply "entry" to Fld_New_Name in frame fld_rename.
      return NO-APPLY.
   end.

   /* Make sure none of the tables are frozen, views or sql tables.  If 
      this loop completes, num will be the number of tables that we
      found the field name in.
   */
   run adecomm/_setcurs.p ("WAIT").
   for each _File where _File._DB-recid = s_DbRecId
                    AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN"),
       each _Field of _File
       where _Field._Field-Name = name
       while NOT (isfroz OR issql OR isview):

      isfroz = _file._Frozen.
      isview = can-find(FIRST _View-ref where
      	       	     	_View-ref._Ref-Table = _File._File-Name AND
      	       	     	_View-ref._Base-Col = _Field._Field-Name).
      issql = (_File._Db-lang >= {&TBLTYP_SQL}).
      num = num + 1.      
   end.   
   run adecomm/_setcurs.p ("").

   msg = "".
   if isfroz then
      msg = "One or more of the tables containing this field is frozen.".
   else if isview then
      msg = "This field is used in a view.".
   else if issql then
      msg = "This field name is used in a {&PRO_DISPLAY_NAME}/SQL table.".

   if msg <> "" then
   do:
      message msg SKIP "You cannot rename."
      	      VIEW-AS ALERT-BOX ERROR
      	      buttons OK.
      return NO-APPLY.
   end.

   if num = 1 then
      message "There is 1 occurrence of this field." SKIP
      	      "Are you sure you want to rename it?"
      	      VIEW-AS alert-box question buttons YES-NO update answer.
   else
      message "There are" num "occurrences of this field." SKIP
      	      "Are you sure you want to rename them?"
      	      VIEW-AS alert-box question buttons YES-NO update answer.
   if NOT answer then
      return NO-APPLY.
end.


/*----- LEAVE of NEW NAME ----- */
on leave of Fld_Old_Name in frame fld_rename
do:
   DEFINE VARIABLE name AS CHARACTER    NO-UNDO.

   name = TRIM(Self:SCREEN-VALUE).
   SELF:SCREEN-VALUE = name.  /* redisplay trimmed name */

   if name = "" then return.

   if NOT can-find (FIRST _Field where _Field._Field-Name = name) then
   do:
      message "The field to rename is not in any table."
      	      VIEW-AS ALERT-BOX ERROR
      	      buttons OK.
      return NO-APPLY.
   end.
end.


/*----- LEAVE of NEW NAME ----- */
on leave of Fld_New_Name in frame fld_rename
do:
   DEFINE VARIABLE okay AS LOGICAL NO-UNDO.
   DEFINE VARIABLE name AS CHARACTER    NO-UNDO.

   name = TRIM(Self:SCREEN-VALUE).
   SELF:SCREEN-VALUE = name.  /* redisplay trimmed name */

   if name = "" then return.

   if can-find (FIRST _Field where _Field._Field-Name = name) then
   do:
      message "The new name is already in use in some table."
      	      VIEW-AS ALERT-BOX ERROR
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
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", 
      	       	     	     {&Globally_Rename_Fields_Dlg_Box}, ?).


/*----------------------------Mainline code----------------------------------*/

DEFINE VARIABLE msg_text AS CHARACTER NO-UNDO.

find _File WHERE _File._File-name = "_Field"
             AND _File._Owner = "PUB".
if NOT can-do(_File._Can-write, USERID("DICTDB")) then
do:
   message s_NoPrivMsg "modify fields."
      VIEW-AS ALERT-BOX ERROR buttons Ok.
   return.
end.

/* This find's the first non-system table  */
find FIRST _Field where _Field._Field-name < "_" NO-ERROR.
if NOT AVAILABLE _Field then
do:
   message "There are no user-defined fields in this database."
      	    VIEW-AS ALERT-BOX ERROR
      	    buttons OK.
   return.
end.



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

   for each _File where _File._DB-recid = s_DbRecId
                    AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN"),
       each _Field of _File where _Field._Field-Name = Fld_Old_Name:
   	 _Field._Field-Name = Fld_New_Name.
   end.

   /* Reflect the change in the edit field window if it's up. - Note
      if the user had typed over the name field but hasn't saved yet,
      this will clobber his change.  Also change the value in the field list.
   */
   if s_win_Fld <> ? AND s_CurrFld = Fld_Old_Name then
   do:
      b_Field._Field-Name = Fld_New_Name.
      display b_Field._Field-Name with frame fldprops.
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
      	 run adedict/FLD/_ptinlst.p (INPUT Fld_New_Name, INPUT 0).
      end.
      else do:
      	 /* Just change the name in place. */      	  
	 {adedict/repname.i
	    &OldName = Fld_Old_Name
	    &NewName = Fld_New_Name
	    &Curr    = s_CurrFld
	    &Fill    = s_FldFill
	    &List    = s_lst_Flds}
      end.
   end.

   {adedict/setdirty.i &Dirty = "true"}
end.

run adecomm/_setcurs.p ("").
hide frame fld_rename.
return.





