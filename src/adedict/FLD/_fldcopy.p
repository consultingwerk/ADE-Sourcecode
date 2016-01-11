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

File: _fldcopy.p

Description:
   Display and handle the field copy dialog box.

Input-Output Parameters:
   p_Order -  This is set to the last order# assigned to a copied field
      	      If no field is successfully copied, or the user chooses
      	      copy-modify first, the input value is left as is.

Output Parameters:
   p_Tbl   - The name of the table chosen if user hit Copy with Modify,
      	     otherwise it is set to "".
   p_Fld   - The name of the field chosen if user hit Copy with Modify.
      	     otherwise it is set to "".
   p_Copied- Set to yes if any field was copied successfully.

Author: Laura Stern

Date Created: 06/15/92 

History:
     tomn    12/05/95    Remove "choose of s_btn_Help" from the WAIT-FOR so 
                        you don't exit the program when you press HELP
     D. McMann 06/29/98  Added WHERE (_owner = "PUB" or _owner = "_FOREIGN")
                         to _File Find.

----------------------------------------------------------------------------*/


&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/brwvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared}
{adedict/FLD/fldvar.i shared}

Define INPUT-OUTPUT PARAMETER p_Order  as integer  NO-UNDO.
Define OUTPUT  	    PARAMETER p_Tbl    as char     NO-UNDO.
Define OUTPUT  	    PARAMETER p_Fld    as char     NO-UNDO.
Define OUTPUT       PARAMETER p_Copied as logical  NO-UNDO init no.


Define var cpy_lst_Tbls as char NO-UNDO
   view-as SELECTION-LIST SINGLE INNER-CHARS 28 INNER-LINES 8 
   SCROLLBAR-V SCROLLBAR-H.
Define var cpy_lst_Flds as char NO-UNDO
   view-as SELECTION-LIST MULTIPLE INNER-CHARS 28 INNER-LINES 8 
   SCROLLBAR-V SCROLLBAR-H.

Define button btn_Copy_AsIs label "&Copy As Is" 	      	
   SIZE 15 by {&H_OKBTN} MARGIN-EXTRA DEFAULT AUTO-GO.
Define button btn_Copy_Mod  label "&Modify First" 
   SIZE 15 by {&H_OKBTN} MARGIN-EXTRA DEFAULT AUTO-GO.
Define button btn_Cancel    label "Cancel"	
   SIZE 15 by {&H_OKBTN} MARGIN-EXTRA DEFAULT AUTO-ENDKEY.
Define button btn_Skip 	    label "&Skip" {&STDPH_OKBTN} AUTO-GO.

/* Id of the table selected in this dialog box.  Note s_TblRecId is the
   recid of the table we're adding fields to. */
Define var cpy_Recid as RECID NO-UNDO.

Define var cpy_Name     as char    NO-UNDO.
Define var cpy_Order    as integer NO-UNDO.
Define var cpy_Skipped  as logical NO-UNDO init false.
Define var stat         as char    NO-UNDO.


/*===============================Forms===================================*/

FORM 
   skip({&TFM_WID})
      "Select the fields to copy from the field list.             " at 2 view-as TEXT 
   skip({&VM_WIDG})

      "Tables:"      at 2  view-as text
      "Fields:"      at 37 view-as text
   skip({&VM_WID})
      cpy_lst_Tbls   at 2  NO-LABEL 
      cpy_lst_Flds   at 37 NO-LABEL 

   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = btn_Copy_AsIs
      &CANCEL = btn_Copy_Mod  /* in place of where cancel btn usually is */
      &OTHER  = btn_Cancel
      &HELP   = s_btn_Help}

   with frame fldcopy 
      DEFAULT-BUTTON btn_Copy_AsIs CANCEL-BUTTON btn_Cancel
      TITLE "Copy Field(s)" view-as DIALOG-BOX.


/* Form which allows user to rename if there is a name conflict. */
FORM
   skip({&TFM_WID})
   "A field with this name already exists in the      "      at 2
       view-as TEXT 
   "destination table.  If you still want to copy it,      " at 2 
       view-as TEXT 
   "enter a unique name and press OK.  Otherwise      "      at 2
       view-as TEXT
   "press the Skip button.      "                            at 2
       view-as TEXT
   skip({&VM_WIDG})

   cpy_Name label "&Field name"  format "x(32)"        at 2 {&STDPH_FILL}

   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = s_btn_OK
      &CANCEL = s_btn_Cancel
      &OTHER  = "SPACE({&HM_DBTNG}) btn_Skip"
      &HELP   = s_btn_Help}

   with frame rename 
        DEFAULT-BUTTON s_btn_OK  CANCEL-BUTTON btn_Skip
        title "Rename Field" view-as DIALOG-BOX 
        SIDE-LABELS.


/* Status frame */
FORM
   SKIP(1)
   SPACE(3) stat format "x(32)" LABEL "Copying" SPACE
   SKIP(1)
   with frame copying SIDE-LABELS view-as dialog-box.


/*=========================Internal Procedures===============================*/

/*------------------------------------------------------------------
   Fill the field list with fields for the currently selected
   table.
------------------------------------------------------------------*/
PROCEDURE Fill_Field_List:
   Define var access  as logical NO-UNDO.

   /* Refresh the field list to show fields for the selected table. */
   find _File where 
      	 _File._File-Name = cpy_lst_Tbls:screen-value in frame fldcopy AND
        _File._DB-recid = s_DbRecId AND
        (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN").
   cpy_Recid = RECID(_File).

   if NOT cpy_lst_Flds:visible in frame fldcopy then
      cpy_lst_Flds:visible in frame fldcopy = yes.

   /* Fill the field list for the selected table. */
   cpy_lst_Flds:list-items in frame fldcopy = "".  /* clear the list first */
   run adecomm/_fldlist.p
      (INPUT   cpy_lst_Flds:HANDLE in frame fldcopy,
       INPUT   cpy_Recid,
       INPUT   (if s_Order_By = {&ORDER_ALPHA} then true else false),
       INPUT   "",
       INPUT   ?,
       INPUT   no,
       INPUT   "",
       OUTPUT  access).
   if NOT access then return.  /* no read permission on fields */

   /* Set selection to the first item. */
   cpy_lst_Flds:screen-value in frame fldcopy = 
      cpy_lst_Flds:entry(1) in frame fldcopy.
end.


/*========================Frame rename Triggers==============================*/

/*-----WINDOW-CLOSE (frame rename)-----*/
on window-close of frame rename
   apply "END-ERROR" to frame rename.


/*----- HIT of OK BUTTON or GO (frame rename) ----- */
on GO of frame rename	/* or OK due to AUTO-GO */
do:
   Define var name as char NO-UNDO.

   name = input frame rename cpy_Name.
   if name = "" OR name = ? then
   do:
      message "Please enter a new name for this field" SKIP
              "or press the Skip button to not copy this field."
               view-as ALERT-BOX ERROR  buttons OK.
      return NO-APPLY.
   end.
end.


/*----- LEAVE of NAME (frame rename) -----*/
on leave of cpy_Name in frame rename
do:
   Define var okay as logical NO-UNDO.

   /* Make sure the name is a valid identifier for Progress. */
   run adecomm/_valname.p (INPUT SELF:screen-value, INPUT true, OUTPUT okay).
   if NOT okay then
      return NO-APPLY.
end.


/*----- HIT of SKIP button (frame rename) -----*/
on choose of btn_Skip in frame rename
   cpy_Skipped = true.


/*----- HELP -----*/
on HELP of frame rename OR choose of s_btn_Help in frame rename
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&Rename_Field_Dlg_Box}, ?).

      	 
/*========================Frame fldcopy Triggers==============================*/

/*----- HIT of COPY AS IS BUTTON -----*/

/*-----WINDOW-CLOSE (frame fldcopy)-----*/
on window-close of frame fldcopy
   apply "END-ERROR" to frame fldcopy.

/*----- CHOOSE of COPY AS IS -----*/
on choose of btn_Copy_AsIs in frame fldcopy
do:
   Define var num       as integer  NO-UNDO.
   Define var flds      as char     NO-UNDO.
   Define var fld#      as integer  NO-UNDO.
   Define var newname   as char     NO-UNDO.
   Define var ins_name  as char     NO-UNDO.
   Define var success   as logical  NO-UNDO init false.
   Define var canned    as logical  NO-UNDO.
   
   Define buffer cpy_Field for _Field.

   run adecomm/_setcurs.p ("WAIT").
   assign
      session:immediate-display = yes
      flds = cpy_lst_Flds:screen-value in frame fldcopy
      num = NUM-ENTRIES(flds).

   /* If the table we're copying to is empty, copy the order #s from the
      source fields.  Otherwise, generate new unique order #s and start
      by finding the highest one used in the existing table that we're
      copying to.  cpy_Order = ? flags that we'll copy orders from
      the source fields.
   */
   find LAST _Field USE-INDEX _Field-Position 
      where _Field._File-recid = s_TblRecId NO-ERROR.
   cpy_Order = (if AVAILABLE _Field then _Field._Order + 10 else ?).

   all_flds:
   do ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE ON STOP UNDO, LEAVE:
      cpy_loop:
      do fld# = 1 to num:
      	 cpy_Name = ENTRY(fld#, flds).
         find cpy_Field where cpy_Field._Field-Name = cpy_Name AND 
              cpy_Field._File-recid = cpy_Recid.
   
         /* Make sure there's no other field with this name in the 
            destination table.  If there is, give the user the chance
            to rename the field he is about to copy.
         */
         do while CAN-FIND (_Field where _Field._File-recid = s_TblRecId AND
                            _Field._Field-Name = cpy_Name):
      	    /* Turn off WAIT while in dlg */
      	    run adecomm/_setcurs.p ("").
      	    canned = true.
      	    do ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
	       update cpy_Name 
		      s_btn_Ok 
      	       	      s_btn_Cancel
		      btn_Skip 
		      s_btn_Help
		      with frame rename.
      	       canned = false.
      	    end.
      	    /* fields already copied are NOT undone */
      	    if canned then leave cpy_loop.

      	    run adecomm/_setcurs.p ("WAIT"). 
            if cpy_Skipped then 
            do:
               hide frame rename.
               cpy_Skipped = false.  /* reset flag */
               next cpy_loop.
            end.
         end.
         hide frame rename.

      	 display cpy_Field._Field-Name @ stat with frame copying.

         create b_Field.
      	 assign
            b_Field._File-recid = s_TblRecId
      	    b_Field._Field-name = cpy_Name
      	    b_Field._Data-type  = cpy_Field._Data-type
      	    b_Field._Format     = cpy_Field._Format
      	    b_Field._Initial    = cpy_Field._Initial
      	    b_Field._Order      = (if cpy_Order = ? then cpy_Field._Order
      	       	     	      	       	     	    else cpy_Order).
      	 {prodict/dump/copy_fld.i &from=cpy_Field &to=b_Field &all=false}

      	 /* Reset offset as if it was a new field to put at the end. */
      	 b_Field._Fld-stoff = ?.
      	 RUN adedict/FLD/_dfltgat.p (TRUE).
      	 find _File where RECID(_File) = s_TblRecId.
      	 if b_Field._Fld-stoff + b_Field._Fld-stlen > _File._For-Size then 
         do:
	    message "If this field is added, the record" SKIP
		    "size will be exceeded." SKIP
      	       	    "No more fields will be copied."
		    view-as ALERT-BOX ERROR buttons OK.
      	    undo all_flds, leave all_flds.
      	 end.

         /* Update the browse window to show this field in the
            field list. */
      	 run adedict/FLD/_ptinlst.p (INPUT b_Field._Field-Name,
      	       	     	      	     INPUT b_Field._Order).
         p_Copied = yes.

         if cpy_Order <> ? then
            cpy_Order = cpy_Order + 10.
      end.  /* cpy_loop */

      if p_Copied then 
      do:
         {adedict/setdirty.i &Dirty = "true"}
      	 p_Order = b_Field._Order.  /* Set to last order# used */
      end.
      success = true.
   end.  /* do on error block */

   hide frame copying no-pause.
   run adecomm/_setcurs.p ("").
   session:immediate-display = no.

   if success then
      return.
   else
      return NO-APPLY.  /* dialog will remain up if error. */
end.


/*----- HIT of COPY w/ MODIFICATION BUTTON -----*/
on choose of btn_Copy_Mod in frame fldcopy
do:
   /* Set the output parameters so newfld can fill
      field dialog with info from this field. */

   assign
      p_Fld = cpy_lst_Flds:screen-value in frame fldcopy
      p_Tbl = cpy_lst_Tbls:screen-value in frame fldcopy.
end.


/*----- VALUE-CHANGED of TBL LIST ----- */
on value-changed of cpy_lst_Tbls in frame fldcopy
   run Fill_Field_List.


/*----- VALUE-CHANGED of FLD LIST ----- */
on value-changed of cpy_lst_Flds in frame fldcopy
do:
   Define var num as integer NO-UNDO.

   assign
      num = NUM-ENTRIES(cpy_lst_Flds:screen-value in frame fldcopy)
      btn_Copy_Mod:sensitive in frame fldcopy = (if num = 1 then yes else no)
      btn_Copy_AsIs:sensitive in frame fldcopy = (if num = ? then no else yes).
end.


/*----- HELP -----*/
on HELP of frame fldcopy OR choose of s_btn_Help in frame fldcopy
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&Copy_Fields_Dlg_Box}, ?).


/*============================Mainline code==================================*/

Define var access as logical NO-UNDO.


/* Make the field list invisible until the user makes a table choice. */
cpy_lst_Flds:visible in frame fldcopy = no.
cpy_lst_Flds:sensitive in frame fldcopy = yes.

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "frame fldcopy" 
   &BOX   = "s_rect_Btns"
   &OK    = "btn_Copy_AsIs" 
   &HELP  = "s_btn_Help"
}

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "frame rename" 
   &BOX   = "s_rect_Btns"
   &OK    = "s_btn_OK" 
   &HELP  = "s_btn_Help"
}

enable cpy_lst_Tbls
       btn_Copy_AsIs
       btn_Copy_Mod
       btn_Cancel
       s_btn_Help
   with frame fldcopy.

/* Fill the table list */
run adecomm/_tbllist.p
   (INPUT  cpy_lst_Tbls:HANDLE in frame fldcopy,
    INPUT  s_Show_Hidden_Tbls,
    INPUT  s_DbRecId,
    INPUT  "",
    INPUT "BUFFER,FUNCTION,PACKAGE,PROCEDURE,SEQUENCE,VIEW",
    OUTPUT access).
if NOT access then return.  /* no read permission on tables */

/* Set selection to first item */
cpy_lst_Tbls:screen-value in frame fldcopy = 
   cpy_lst_Tbls:entry(1) in frame fldcopy.

/* Forced display of field list here */
run Fill_Field_List.

/* Default output parameters */
assign
   p_Tbl = ""
   p_Fld = "".

do ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE:
   wait-for choose of btn_Cancel    in frame fldcopy,
      	       	      btn_Copy_AsIs in frame fldcopy,
      	       	      btn_Copy_Mod  in frame fldcopy.
end.

hide frame fldcopy.
return.

