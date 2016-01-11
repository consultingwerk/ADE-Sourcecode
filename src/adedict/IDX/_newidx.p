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

File: _newidx.p

Description:
   Display and handle the add index dialog box and then add the index
   if the user presses OK.

Author: Laura Stern

Date Created: 04/22/92

History:
	gfs	11/04/94	Fixed problem with sensitive on Asc/Desc
	DLM     03/26/98    Added area support
	DLM     04/20/98    Default _index now has an _index-field associated
	                    with it.  Added code to delete fields when the first
	                    index is added.
	DLM     06/08/98    Changed s_btn_Idx_Area and s_Lst_Idx_Area as being
	                    hidden when adding an index to a dataserver.
	                    98-05-20-038 
	DLM     07/14/98    Added _Owner to _file finds
    Mario B 12/28/98 Add s_In_Schema_Area enabling one time notification.
    DLM     05/15/00    Removed warning message if only Schema Area in DB
----------------------------------------------------------------------------*/


&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/brwvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared}
{adecomm/cbvar.i shared}
{adedict/IDX/idxvar2.i shared}
{adedict/IDX/idxvar.i shared}
{adedict/capab.i}

/* General processing variables */
Define var num_flds  as integer NO-UNDO. /* # of index flds chosen */
Define var max_flds  as integer NO-UNDO.
Define var capab     as char   	NO-UNDO.
Define var all_cnt   as integer NO-UNDO.
Define var added     as logical NO-UNDO INIT no.
Define var num       as integer NO-UNDO.
Define var curr_type as CHARACTER NO-UNDO.

DEFINE VARIABLE ans AS LOGICAL NO-UNDO.


Define buffer x_File for _File.


/*=========================Internal Procedures===============================*/

/*-----------------------------------------------------------------
   Remove the selected field name from one list and add it
   to the other.

   Input Parameters:
      p_lst_Add  - Handle of selection list to add the name to.
      p_lst_Rmv  - Handle of selection list to remove name from.
      p_To_Index - True, if the field is being added to the index or
      	       	   false if field is being removed from the index.
------------------------------------------------------------------*/
PROCEDURE Transfer_Name:

Define INPUT parameter p_lst_Add  as widget-handle NO-UNDO.
Define INPUT parameter p_lst_Rmv  as widget-handle NO-UNDO.
Define INPUT parameter p_To_Index as logical       NO-UNDO.

Define var fldname as char    NO-UNDO.
Define var cnt 	   as integer NO-UNDO.
Define var pos     as integer NO-UNDO.
Define var nxtname as char    NO-UNDO.
Define var ix      as integer NO-UNDO.  /* loop index */

   /* Get the selected name from the "remove list". */
   fldname = p_lst_Rmv:screen-value.

   /* Remove this name from the "remove list" */
   run adecomm/_delitem.p (INPUT p_lst_Rmv, INPUT fldname, OUTPUT cnt).

   if p_To_Index then
   do:
      /* Add ascending/descending marker.  For Word indexes, this 
      	 isn't relevant 
      */
      fldname = (if input frame newidx s_Idx_Word 
      	       	   then STRING("A", "x(3)")
      	       	   else STRING(input frame newidx s_IdxFld_AscDesc, "x(3)"))
      	        + fldname.
      
      /* Index field order is in the order they are added. */
      s_Res = p_lst_Add:ADD-LAST(fldname). 
   end.
   else do:
      /* Remove ascending/descending marker */
      fldname = SUBSTR(fldname, 4, 32).

      /* Insert field back in it's proper place.  Determine the position
      	 this field took in original field list.  Look from this point
      	 down in original list until we find an entry that is still in
      	 the left hand field list.  This is the entry we want to insert
      	 above.
      */
      pos = LOOKUP(fldname, s_lst_IdxFldChoice:private-data in frame newidx).
      do ix = pos + 1 to all_cnt:
      	 nxtname = ENTRY(ix, s_lst_IdxFldChoice:private-data in frame newidx).
      	 if p_lst_Add:LOOKUP(nxtname) <> 0
      	    then leave.
      end.      
      if ix > all_cnt then
      	 s_Res = p_lst_Add:ADD-LAST(fldname). 
      else
      	 s_Res = p_lst_Add:INSERT(fldname, nxtname).
   end.

   /* Select the fldname value, making sure it's in view. */
   p_lst_Add:screen-value = fldname.
   run adecomm/_scroll.p (INPUT p_lst_Add, INPUT fldname).
end.


/*-----------------------------------------------------------------
   Move an entry down or up in the index fields list.

   Input Parameters:
      p_Incr - Amount to add to the list position to get the new
      	       position (either 1 or - 1).
      p_Down - True if moving down, False if moving up.

------------------------------------------------------------------*/
PROCEDURE Move_Entry:

Define INPUT parameter p_Incr as integer       NO-UNDO.
Define INPUT parameter p_Down as logical       NO-UNDO.

Define var lst_flds as widget-handle NO-UNDO.
Define var pos      as integer 	     NO-UNDO.
Define var fldname  as char   	     NO-UNDO.

   lst_flds = s_lst_IdxFlds:HANDLE in frame newidx. /* for convenience */

   /* Get the selected name from the list. */
   fldname = lst_flds:screen-value.
   
   /* Get the position of the item to insert in front of.  If moving down
      this will be +1 - actually, we want to insert in front of the one 2
      slots down but that will be only one slot down once this one is 
      removed.  If moving up, this will be -1.	
   */
   pos = lst_flds:LOOKUP(fldname) + p_Incr.

   /* Delete the item */
   s_Res = lst_flds:DELETE(fldname).

   if p_Down AND pos > num_flds - 1 then /* - 1 'cause of item just deleted */
      s_Res = lst_Flds:ADD-LAST(fldname).
   else if NOT p_Down AND pos = 0 then
      s_Res = lst_Flds:ADD-FIRST(fldname).
   else
      s_Res = lst_Flds:INSERT(fldname, lst_Flds:ENTRY(pos)).

   /* Select the fldname value, making sure it's in view. */
   lst_Flds:screen-value = fldname.
   run adecomm/_scroll.p (INPUT lst_Flds, INPUT fldname).

   /* Move up and down buttons may need enabling/disabling */
   run Adjust_Move_Btns.
end.


/*-----------------------------------------------------------------
   Adjust the sensitive-ness of the "Move Up" and "Move Down" buttons.
   There must be at least 2 items in the list for these to make
   sense.  Also, if the last item is selected, disable Move Down.
   Similarly, if the first item is selected, disable Move Up.

------------------------------------------------------------------*/
PROCEDURE Adjust_Move_Btns:

Define var val as char NO-UNDO.

   val = s_lst_IdxFlds:screen-value in frame newidx.

   s_btn_IdxFldDwn:sensitive in frame newidx = 
      (if num_flds > 1 AND 
       val <> s_lst_IdxFlds:ENTRY(num_flds) in frame newidx then
       yes else no).	 
   s_btn_IdxFldUp:sensitive in frame newidx = 
      (if num_flds > 1 AND 
       val <> s_lst_IdxFlds:ENTRY(1) in frame newidx then
       yes else no).	 
end.


/*-----------------------------------------------------------------
   Add the currently selected field to the list of index fields.
------------------------------------------------------------------*/
PROCEDURE Add_Field:
   Define var val as char NO-UNDO.

   run Transfer_Name (INPUT s_lst_IdxFlds:HANDLE in frame newidx,
      	       	      INPUT s_lst_IdxFldChoice:HANDLE in frame newidx,
      	       	      INPUT true).

   num_flds = num_flds + 1.

   /* Now that we know there's at least one index field, user can
      remove fields or set the asc/desc flag */
   assign
      s_lst_IdxFlds:sensitive in frame newidx = yes
      s_btn_IdxFldRmv:sensitive in frame newidx = yes.

   if NOT input frame newidx s_Idx_Word then
      s_IdxFld_AscDesc:sensitive in frame newidx = yes.

   /* Move-Up and move-down buttons may need enabling/disabling */
   run Adjust_Move_Btns.

   /* Can only support up to max_flds fields in an index.  Also if there's
      no fields left to add, disable add button. */
   if ( num_flds = max_flds OR
        s_lst_IdxFldChoice:NUM-ITEMS in frame newidx = 0) then
      s_btn_IdxFldAdd:sensitive in frame newidx = no.
end.


/*--------------------------------------------------------------------
   Remove the currently selected field from the list of index fields.
---------------------------------------------------------------------*/
PROCEDURE Remove_Field:
   run Transfer_Name (INPUT s_lst_IdxFldChoice:HANDLE in frame newidx,
      	       	      INPUT s_lst_IdxFlds:HANDLE in frame newidx,
      	       	      INPUT false).

   num_flds = num_flds - 1.

   if num_flds = 0 then
      assign
      	 s_lst_IdxFlds:sensitive in frame newidx = no
      	 s_IdxFld_AscDesc:sensitive in frame newidx = no
      	 s_btn_IdxFldRmv:sensitive in frame newidx = no.

   /* Move up and down buttons may need enabling/disabling */
   run Adjust_Move_Btns.
   
   if num_flds < max_flds then
      /* Make sure add button is sensitive now. */
      s_btn_IdxFldAdd:sensitive in frame newidx = yes.
end.


/*===============================Triggers====================================*/

/*-----WINDOW-CLOSE-----*/
on window-close of frame newidx
   apply "END-ERROR" to frame newidx.


/*----- HIT of OK BUTTON -----*/
on choose of s_btn_OK in frame newidx
   s_OK_Hit = yes.
   /* The GO trigger will fire after this. */


/*----- HIT of ADD (Index) BUTTON or GO -----*/
on GO of frame newidx	/* or Create - because it's auto-go */
do:
   Define var fnum   	as integer NO-UNDO.
   Define var flds   	as char    NO-UNDO.
   Define var name   	as char    NO-UNDO.
   Define var id     	as recid   NO-UNDO.
   Define var primary 	as logical NO-UNDO.
   Define var defname   as char    NO-UNDO.
   Define var wordidx   as logical NO-UNDO.
   Define var answer    as logical NO-UNDO.
   Define var no_name   as logical NO-UNDO.
   Define var ins_name  as char    NO-UNDO.
   Define var is_data   as logical NO-UNDO.
   Define var tmpfile   as char    NO-UNDO.
   Define var xnum_proc as char    NO-UNDO.

   run adedict/_blnknam.p
      (INPUT b_Index._Index-name:HANDLE in frame newidx,
       INPUT "index", OUTPUT no_name).
   if no_name then do:
      s_OK_Hit = no.
      return NO-APPLY.
   end.
   
   
   if num_flds = 0 then
   do:
      message "You must specify at least one field" SKIP
      	      "for the index."
      	 view-as ALERT-BOX ERROR  buttons OK.    
      s_OK_Hit = no.
      return NO-APPLY.
   end.
 
   IF NOT s_In_Schema_Area THEN DO:
     APPLY "LEAVE" TO idx-area-name.
     IF NOT ans THEN DO:
        s_OK_Hit = no.  /* in case ok was hit */
        APPLY "ENTRY" TO idx-area-name.
        return NO-APPLY.
     END.
   END.       
  
   flds = s_lst_IdxFlds:LIST-ITEMS in frame newidx. /* Get all fields in list */

   wordidx = input frame newidx s_Idx_Word.
   if wordidx = yes then
   do:
      if num_flds > 1 then
      do:
	 message "An index that is word-indexed" SKIP
		 "can only have one field component" SKIP
		 "(though that may be an array field)."
      	    view-as ALERT-BOX ERROR  buttons OK.    
      	 s_OK_Hit = no.
	 return NO-APPLY.
      end.

      /* Since we don't allow primary, unique or abbreviated to be on
      	 when Word indexed is chosen, or vice versa, we don't need to 
      	 check that.
      */

      name = SUBSTR(flds, 4, 32).  /* We know now there's only 1 fld */
      find _Field of x_File where _Field._Field-Name = name.
      if _Field._Data-Type <> "Character" then
      do:
	 message "You can only specify word-indexed when" SKIP
		 "the index contains a character field."
      	    view-as ALERT-BOX ERROR  buttons OK.    
      	 s_OK_Hit = no.
	 return NO-APPLY.
      end.                  
   end.
   else do: /* Word index was not specified */
      do fnum = 1 to num_flds:
	 name = SUBSTR(ENTRY(fnum, flds), 4, 32).
	 find _Field of x_File where _Field._Field-Name = name.
	 if _Field._Extent > 0 then
	 do:
      	    message "Only a word index can contain an array field."
	       view-as ALERT-BOX ERROR  buttons OK.    
      	    s_OK_Hit = no.
	    return NO-APPLY.
	 end.
      end.

      if input frame newidx s_Idx_Abbrev = yes then
      do:
      	 /* Get last field specified for the index */
      	 assign
      	    name = s_lst_IdxFlds:ENTRY(num_flds) in frame newidx
            name = SUBSTR(name, 4, 32).

      	 find _Field of x_File where _Field._Field-Name = name.
      	 if _Field._Data-Type <> "Character" then
      	 do:
	    message "Abbreviate is an index option that lets you" SKIP
      	       	    "conveniently search for a partial match based" SKIP
      	       	    "on the first few characters of a field (like" SKIP
      	       	    "using BEGINS) in the FIND ...USING statement." SKIP(1)
      	       	    "This option is only available on indexes that" SKIP
      	       	    "have a character field as their last index" SKIP
      	       	    "component."
      	       view-as ALERT-BOX ERROR  buttons OK.    
      	    s_OK_Hit = no.
	    return NO-APPLY.
      	 end.     
      end.

      if input frame newidx b_Index._Unique = yes AND
      	 input frame newidx b_Index._Active = yes then
      do:   
      	 /* Before putting up this horrible message, check to see if
      	    there's data in the table.  If there's no data the user 
      	    shouldn't need to worry.  _isdata.i won't compile unless 
      	    table is committed and in that case, we know there's no data
      	    either.  There's no way to suppress compile errors from showing
      	    up on the screen (e.g., NO-ERROR won't do it) so do output to 
      	    file to redirect them so the user won't see anything.
      	 */
      	 run adecomm/_tmpfile.p (INPUT "", INPUT ".dct", OUTPUT tmpfile).
      	 output to VALUE(tmpfile).
      	 do ON STOP UNDO, LEAVE:
      	    run adedict/_isdata.i (OUTPUT is_data) VALUE(s_CurrTbl).
      	 end.
      	 output close.
      	 os-delete VALUE(tmpfile).
      	 if compiler:error then
      	    is_data = false.  /* table isn't committed yet */
      	 if is_data then
      	 do:
      	    answer = yes.   /* set's yes as default button */
      	    message 
      	       "If PROGRESS finds duplicate values while creating" SKIP
      	       "this new unique index, it will UNDO the entire" SKIP
      	       "transaction, causing you to lose any schema changes" SKIP
      	       "made within the same transaction." SKIP(1)
      	       "Recommendations:" SKIP(1)
      	       "If you are sure there are no duplicate values OR" SKIP
      	       "if you did not make any other schema changes within" SKIP
      	       "this transaction, then select OK to add this new" SKIP
      	       "unique index." SKIP(1)
      	       "Otherwise, select Cancel.  You can then close the" SKIP
      	       "dialog, commit the transaction (Edit/Commit from the menu)" SKIP
      	       "and then add the index." SKIP(1)
      	       "Another alternative is to change the index to inactive," SKIP
      	       "and activate it later by running ~"proutil -C idxbuild ~"."
      	       view-as ALERT-BOX WARNING buttons OK-CANCEL update answer.
      	    if answer = false then
      	    do:
      	       s_OK_Hit = no.
      	       return NO-APPLY.
      	    end.
      	 end.
      end.
   end.

   do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
      run adecomm/_setcurs.p ("WAIT").
   
      assign
	 b_Index._File-recid = s_TblRecId
	 input frame newidx b_Index._Index-name
	 input frame newidx b_Index._Unique
	 input frame newidx b_Index._Active
	 input frame newidx b_Index._Desc.

      IF idx-area-name = "N/A"  THEN
        ASSIGN b_Index._ianum = 6.
      ELSE  DO:
        FIND _Area WHERE _Area._Area-name = INPUT FRAME newidx idx-area-name NO-LOCK.
        ASSIGN b_Index._ianum = _Area._Area-number
               idx-area-name = INPUT FRAME newidx idx-area-name.
      END.
      
      b_Index._Wordidx = (if wordidx then 1 else ?).
      
      if INDEX(capab, {&CAPAB_GATE_IDXNUM}) > 0 then
      do:
      	 /* Call gateway specific routine to get index number */
      	 assign xnum_proc = "prodict/gate/_gatxnum.p".
      	 run VALUE(xnum_proc) 
      	    (INPUT  s_TblRecId, 
      	     OUTPUT b_Index._Idx-num).
      end.

      /* Create a record for each index field. */
      do fnum = 1 to num_flds:
      	 name = SUBSTR(ENTRY(fnum, flds), 4, 32).
      	 find _Field of x_File where _Field._Field-Name = name.

	 create _Index-Field.
      	 assign
      	    _Index-Field._Index-recid = RECID(b_Index)
      	    _Index-Field._Field-recid = RECID(_Field)
      	    _Index-Field._Index-seq   = fnum
      	    _Index-Field._Abbreviate  = 
      	       (if fnum = num_flds then input frame newidx s_Idx_Abbrev else no)
      	    _Index-Field._Ascending =
      	       (if SUBSTR(ENTRY(fnum, flds), 1, 1) = "A" then yes else no).
      end.

      /* We've got a confusing situation here.  Some facts.
      	 1. If the table that this index belongs to has not been committed
      	    to the database then the default index will not have been
      	    created yet. x_File.dft-pk (which indicates if there's a
      	    default index) will be false.
      	 2. x_File._Prime-Index will be ? if the table hasn't been committed
      	    and the user hasn't already created a primary index.  It could
      	    also be ? for some gateways. I don't know what the exact
      	    circumstances of this are but it means there's no primary index.
      	 3. If the table has been committed, there will only be a default
      	    index if no other non-word-index has been created.  If there
      	    is a default, _dft-pk will be true.
      	 4. If we are currently creating a non-word index, we want to
      	    make it primary if there isn't another primary index already
      	    (besides the default).
      	 
      	 So: Set primary to yes if we want to make this index the new
      	 primary index.
      */
      if x_File._Prime-Index = ? AND NOT wordidx then
      	 primary = yes.
      else if x_File._dft-pk AND NOT wordidx then
      do:
      	 /* Delete the default index */
      	 assign
      	    id = x_File._Prime-Index  /* recid of default index */
      	    primary = yes
      	    x_File._dft-pk = false.

      	 find _Index where RECID(_Index) = id.
      	 defname = _Index._Index-Name.
      	 FOR EACH _Index-field WHERE _Index-field._Index-recid = RECID(_Index).
      	   DELETE _Index-field.
      	 end.  
      	 delete _Index.
      	 
      	 /* Remove the default index from the list in the browse window.  
      	    (we don't care about output parm - just use fnum variable) */
      	 run adecomm/_delitem.p (INPUT s_lst_Idxs:HANDLE in frame browse,
      	       	     	        INPUT defname, OUTPUT fnum). 
      end.
      else
      	 primary = no.
      
      /* If there is no primary index, or the the user explicitly wants
      	 this index to be the primary one, set the primary index flag 
      	 in the _File record. 
      */
      if (primary OR
      	  input frame newidx s_Idx_Primary = yes) then
      do:
	 x_File._Prime-Index = RECID(b_Index).
      	 s_Status = " - Made this the primary index".
      end.
      else 
      	 s_Status = "".
         
      /* Add entry to indexes list in alphabetical order */
      find FIRST _Index where _Index._File-recid = s_TblRecId AND
      	     	      	      _Index._Index-Name > b_Index._Index-Name 
         NO-ERROR.

      ins_name = (if AVAILABLE _Index then _Index._Index-name else "").
      run adedict/_newobj.p
         (INPUT s_lst_Idxs:HANDLE in frame browse,
          INPUT b_Index._Index-name,
          INPUT ins_name,
          INPUT s_Idxs_Cached,
          INPUT {&OBJ_IDX}).
   
      {adedict/setdirty.i &Dirty = "true"}.
      display "Index Created" + s_Status @ s_Status with frame newidx.
      added = yes.
      run adecomm/_setcurs.p ("").   
      return.
   end.

   /* Only get here if there's an error.  Leave box up and let the user
      fix the problem or Cancel. */
   run adecomm/_setcurs.p ("").   
   s_OK_Hit = no.
   return NO-APPLY.
end.


/* ------on leave of idx-area-name ----*/
ON LEAVE OF idx-area-name in frame newidx 
do:
  ASSIGN ans = FALSE.
  IF NOT s_In_Schema_Area AND num > 1 THEN DO:
    IF INPUT FRAME newidx idx-area-name = "Schema Area" THEN DO:
      MESSAGE "Progress Software Corporation does not recommend" SKIP
              "creating user indices in the Schema Area."  Skip(1)
              "Should indices be created in this area?" SKIP (1)
              VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE ans .
      IF ans THEN
        ASSIGN s_In_Schema_Area = TRUE.        
      ELSE DO:
        ASSIGN s_In_Schema_Area = TRUE.
        RETURN NO-APPLY.
      END.
    END.
    ELSE
      ASSIGN ans = TRUE.
  END.
  ELSE IF NOT s_In_Schema_Area AND INPUT FRAME newidx idx-area-name = "Schema Area" THEN DO:
    MESSAGE "Progress Software Corporation does not recommend" SKIP
            "creating user indices in the Schema Area. " SKIP (1)
            "See the System Administration Guide on how to" SKIP
            "create other data areas." SKIP (1)
            VIEW-AS ALERT-BOX WARNING.
    ASSIGN s_In_Schema_Area = TRUE
           ans          = TRUE.
  END.  
  ELSE 
    ASSIGN ans = true.      
END.  


/*----- HIT of ADD >> (add field) BUTTON -----*/
on choose of s_btn_IdxFldAdd in frame newidx
   run Add_Field.


/*----- DEFAULT-ACTION (DBL-CLICK or RETURN) of FIELD CHOICE LIST -----*/
on default-action of s_lst_IdxFldChoice in frame newidx
   run Add_Field.


/*----- HIT of REMOVE >> (remove field) BUTTON -----*/
on choose of s_btn_IdxFldRmv in frame newidx 
   run Remove_Field.


/*----- HIT of MOVE DOWN BUTTON -----*/
on choose of s_btn_IdxFldDwn in frame newidx 
   run Move_Entry(1, TRUE).


/*----- HIT of MOVE UP BUTTON -----*/
on choose of s_btn_IdxFldUp in frame newidx 
   run Move_Entry(-1, FALSE).


/*----- DEFAULT-ACTION (DBL-CLICK or RETURN) of INDEX FIELD LIST -----*/
on default-action of s_lst_IdxFlds in frame newidx
   run Remove_Field.


/*----- VALUE-CHANGED of ASC/DESC RADIO SET -----*/
on value-changed of s_IdxFld_AscDesc in frame newidx  
do:
   Define var oldval as char NO-UNDO.
   Define var newval as char NO-UNDO.

   assign
      oldval = s_lst_IdxFlds:screen-value in frame newidx
      newval = STRING(TRIM(SELF:screen-value), "x(3)") + SUBSTR(oldval, 4, 32).

   s_Res = s_lst_IdxFlds:replace(newval, oldval) in frame newidx = no.
   s_lst_IdxFlds:screen-value in frame newidx = newval.  /* reset selection */
end.


/*----- VALUE-CHANGED of INDEX FIELDS LIST -----*/
on value-changed of s_lst_IdxFlds in frame newidx
do:
   /* Reflect ascending/descending value for this entry in radio set. */
   if NOT input frame newidx s_Idx_Word then
      s_IdxFld_AscDesc:screen-value in frame newidx = 
      	 substr(SELF:screen-value, 1, 1).

   /* Move up and down buttons may need enabling/disabling */
   run Adjust_Move_Btns.
end.


/*----- VALUE-CHANGED of WORD INDEX TOGGLE -----*/
on value-changed of s_Idx_Word in frame newidx
do:
   Define var ix     	as integer NO-UNDO.
   Define var sel    	as char    NO-UNDO.
   Define var olditem 	as char    NO-UNDO.
   Define var newitem 	as char    NO-UNDO.

   if SELF:screen-value = "yes" then 
   do:
      /* If user turns word indexing on, turn off primary, unique and
      	 abbreviated and disable ascending/descending. 
      */
      assign
	 s_Idx_Primary:screen-value in frame newidx = "no"
	 b_Index._Unique:screen-value in frame newidx = "no"
	 s_Idx_Abbrev:screen-value in frame newidx = "no"
      	 s_IdxFld_AscDesc:screen-value in frame newidx = "A"
      	 s_IdxFld_AscDesc:sensitive in frame newidx = no.

      /* Also set all the Asc/Desc flags to "A" */
      sel = s_lst_IdxFlds:screen-value in frame newidx.
      do ix = 1 to s_lst_IdxFlds:num-items:
      	 olditem = s_lst_IdxFlds:entry(ix) in frame newidx.
      	 if SUBSTR(olditem, 1, 1) = "D" then
      	 do:
      	    assign
      	       newitem = olditem
      	       SUBSTR(newitem, 1, 1) = "A"
      	       s_Res = s_lst_IdxFlds:replace(newitem, olditem) in frame newidx.
      	    if olditem = sel then
      	       s_lst_IdxFlds:screen-value in frame newidx = newitem.
      	 end.
      end.
   end.
   else
      /* Enable Asc/Desc if there are any fields in the list */
      if s_lst_IdxFlds:num-items > 0 then 
      	 s_IdxFld_AscDesc:sensitive in frame newidx = yes.
end.


/*----- VALUE-CHANGED of PRIMARY TOGGLE -----*/
on value-changed of s_Idx_Primary in frame newidx
do:
   /* Primary and word indexed are incompatible */
   if SELF:screen-value = "yes" then do:
      s_Idx_Word:screen-value in frame newidx = "no".
      s_IdxFld_AscDesc:sensitive in frame newidx = yes.
   end.
end.


/*----- VALUE-CHANGED of UNIQUE TOGGLE -----*/
on value-changed of b_Index._Unique in frame newidx
do:
   /* Unique and word indexed are incompatible */
   if SELF:screen-value = "yes" then do:
      s_Idx_Word:screen-value in frame newidx = "no".
      s_IdxFld_AscDesc:sensitive in frame newidx = yes.
   end.
end.


/*----- VALUE-CHANGED of ABBREVIATED TOGGLE -----*/
on value-changed of s_Idx_Abbrev in frame newidx
do:
   /* Abbreviated and word indexed are incompatible */
   if SELF:screen-value = "yes" then do:
      s_Idx_Word:screen-value in frame newidx = "no".
      s_IdxFld_AscDesc:sensitive in frame newidx = yes.
   end.
end.


/*----- HELP -----*/
on HELP of frame newidx OR choose of s_btn_Help in frame newidx
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&Create_Index_Dlg_Box}, ?).


/*============================Mainline code==================================*/

Define var frstfld  as char    NO-UNDO init "".
Define var char_fld as logical NO-UNDO init yes.
Define var cmax     as char    NO-UNDO.
Define var access   as logical NO-UNDO.

/* Check permissions */
find _File WHERE _File._File-name =  "_Index"
             AND _File._Owner = "PUB" NO-LOCK.
if NOT can-do(_File._Can-create, USERID("DICTDB")) then
do:
   message s_NoPrivMsg "create indexes."
      view-as ALERT-BOX ERROR buttons Ok.
   return.
end.
find _File WHERE _File._FIle-name = "_Index-Field"
             AND _File._Owner = "PUB" NO-LOCK.
if NOT can-do(_File._Can-create, USERID("DICTDB")) then
do:
   message s_NoPrivMsg "create indexes."
      view-as ALERT-BOX ERROR buttons Ok.
   return.
end.
find _File where RECID(_File) = s_TblRecId.
if _File._Frozen then  
do:
   message "This table is frozen and cannot be modified."
      view-as ALERT-BOX ERROR buttons Ok.
   return.
end.

/* Set up for filling the list of all fields from the current table */
find x_File where RECID(x_file) = s_TblRecId.

if x_File._Db-lang >= {&TBLTYP_SQL} then
do:
   message "This is a PROGRESS/SQL table." SKIP
      	   "You must use the CREATE INDEX statement."
	   view-as ALERT-BOX ERROR buttons OK.
   return.
end.
IF x_File._For-type <> ? THEN
  ASSIGN idx-area-name = "N/A"
         s_Lst_Idx_Area:hidden in frame newidx = yes
         s_btn_Idx_Area:HIDDEN in frame newidx = yes.
ELSE DO:
  s_lst_idx_area:list-items in frame newidx = "".
  FIND FIRST DICTDB._Area WHERE DICTDB._Area._Area-num > 6 
                            AND DICTDB._Area._Area-type = 6 NO-LOCK NO-ERROR.
  IF AVAILABLE DICTDB._Area THEN
    ASSIGN idx-area-name = DICTDB._AREA._Area-name.
  ELSE DO:
    FIND DICTDB._Area WHERE DICTDB._Area._Area-num = 6 NO-LOCK.
    ASSIGN idx-area-name = DICTDB._AREA._Area-name
           s_In_Schema_Area = TRUE.
  END.  
  
  for each DICTDB._Area WHERE DICTDB._Area._Area-num > 6 
                        AND DICTDB._Area._Area-type = 6 NO-LOCK:
    s_res = s_lst_idx_Area:add-last(DICTDB._Area._Area-name) in frame newidx.
  END.

  FIND DICTDB._Area WHERE DICTDB._Area._Area-num = 6 NO-LOCK.
  ASSIGN s_res = s_lst_idx_Area:add-last(DICTDB._Area._Area-name) in frame newidx.
  
  num = s_lst_Idx_Area:num-items in frame newidx.
  s_Lst_Idx_Area:inner-lines in frame newidx = (if num <= 5 then num else 5).  
  assign idx-area-name:font  in frame newidx = 0
         s_lst_idx_Area:font in frame newidx = 0
         idx-Area-name:width  in frame newidx = 34
         s_lst_idx_Area:width in frame newidx = 38.

  {adecomm/cbdrop.i &Frame  = "frame newidx"
      	       	  &CBFill = "idx-area-name"
      	       	  &CBList = "s_lst_idx_Area"
      	       	  &CBBtn  = "s_btn_idx_area"
     	       	  &CBInit = """"}


   {adecomm/cbcdrop.i &Frame  = "frame newidx"
		         &CBFill = "idx-area-name"
		         &CBList = "s_lst_idx_Area"
		     	 &CBBtn  = "s_btn_idx_Area"
		     	 &CBInit = "curr_type"}
END.
    
find FIRST _Field of x_File NO-ERROR.
if NOT AVAILABLE _Field then
do:
   message "You must first create fields for this" SKIP
      	   "table before you can create an index."
      view-as ALERT-BOX ERROR  buttons OK.
   return.
end.

/* Get gateway capabilities */
run adedict/_capab.p (INPUT {&CAPAB_IDX}, OUTPUT capab).
if INDEX(capab, {&CAPAB_ADD}) = 0 then
do:
   message "You may not add an index definition for this database type."
      view-as ALERT-BOX ERROR buttons OK.
   return.
end.

/* Set dialog box title to show which table this index will belong to. */
frame newidx:title = "Create Index for Table " + s_CurrTbl.

/* Get the max # of components that can be in the index for this gateway */
run adedict/_capab.p (INPUT {&CAPAB_IDXMAX}, OUTPUT cmax).
max_flds = INTEGER(cmax).

/* Determine if the word indexed and abbreviated fields should be sensitive.
   They will be if there are any character fields in this table. */
find FIRST _Field of x_File where _Field._Data-Type = "Character" NO-ERROR.
if NOT AVAILABLE _Field then
   char_fld = no.

/* Run time layout for button area.  Since this is a shared frame we have 
   to avoid doing this code more than once.
*/
if frame newidx:private-data <> "alive" then
do:
   frame newidx:private-data = "alive".

   {adecomm/okrun.i  
      &FRAME = "frame newidx" 
      &BOX   = "s_rect_Btns"
      &OK    = "s_btn_OK" 
      &HELP  = "s_btn_Help"
   }

   /* So Return doesn't hit default button in editor widget. */
   b_Index._Desc:RETURN-INSERT in frame newidx = yes.
end.

/*
   Explicitly disable based on these conditions in case these were
   sensitive from the last time round.  Then conditionally enable (using
   ENABLE verb) below to make sure the TAB order comes out right.
*/
if NOT (char_fld AND INDEX(capab, {&CAPAB_WORD_INDEX}) > 0) then
   s_Idx_Word:sensitive in frame newidx = no.
if NOT char_fld then
   s_Idx_Abbrev:sensitive in frame newidx = no.

s_Status = "".
display s_Status with frame newidx. /* erases val from the last time */
s_btn_Done:label in frame newidx = "Cancel".

enable b_Index._Index-Name   
       idx-area-name when idx-area-name <> "N/A"
       s_btn_Idx_Area when idx-area-name <> "N/A"
       b_Index._Desc
       s_Idx_Primary
       b_Index._Active
       b_Index._Unique
       s_Idx_Word    	when char_fld AND INDEX(capab, {&CAPAB_WORD_INDEX}) > 0
       s_Idx_Abbrev   when char_fld
       s_lst_IdxFldChoice
       s_btn_IdxFldAdd
       s_btn_OK
       s_btn_Add
       s_btn_Done
       s_btn_Help
       with frame newidx.

/* Since we will be enabling/disabling various widgets as the user adds/deletes
   fields from the index, and since we don't want to ENABLE all widgets up
   front (and then immediately disable them), we can't rely on enable to 
   set the TAB order properly.  Reset the tab position for all un-enabled
   widgets which may become sensitized as user users the frame.
*/
assign
   s_Res = s_lst_Idx_Area:move-after-tab-item
      	       (s_btn_Idx_Area:handle in frame newidx) in frame newidx
   s_Res = s_btn_IdxFldRmv:move-after-tab-item 
      	       (s_btn_IdxFldAdd:handle in frame newidx) in frame newidx
   s_Res = s_btn_IdxFldDwn:move-after-tab-item 
      	       (s_btn_IdxFldRmv:handle in frame newidx) in frame newidx
   s_Res = s_btn_IdxFldUp:move-after-tab-item 
      	       (s_btn_IdxFldDwn:handle in frame newidx) in frame newidx
   s_Res = s_lst_IdxFlds:move-after-tab-item 
      	       (s_btn_IdxFldUp:handle in frame newidx) in frame newidx
   s_Res = s_IdxFld_AscDesc:move-after-tab-item 
      	       (s_lst_IdxFlds:handle in frame newidx) in frame newidx
   .

/* Each add will be a subtransaction */
s_OK_Hit = no.
add_subtran:
repeat ON ERROR UNDO,LEAVE  ON ENDKEY UNDO,LEAVE  ON STOP UNDO, LEAVE:
   /* Do this up top here, to be sure we committed the last create */
   if s_OK_Hit then leave add_subtran.

   if added AND s_btn_Done:label in frame newidx <> "Close" then
      s_btn_Done:label in frame newidx = "Close".

   create b_Index.
   num_flds = 0.

   /* Have to display all fields, so on 2nd or 3rd add, any entered values
      will be cleared. */
   assign
      s_Idx_Primary = no
      b_Index._Active = yes
      b_Index._Unique = no
      s_Idx_Word = no
      s_IdxFld_AscDesc = "A"
      s_Idx_Abbrev = no.

   /* Clear and refill the field list in the appropriate sort order */
   s_lst_IdxFldChoice:LIST-ITEMS in frame newidx = "".
   s_lst_IdxFldChoice:private-data in frame newidx = "".
   run adecomm/_fldlist.p
      (INPUT   s_lst_IdxFldChoice:HANDLE in frame newidx,
       INPUT   s_TblRecId,
       INPUT   (if s_Order_By = {&ORDER_ALPHA} then true else false),
       INPUT   "",
       INPUT   ?,
       INPUT   no,
       INPUT   "",
       OUTPUT  access).
   if NOT access then undo add_subtran, leave add_subtran.

   assign
      /* Keep a comma separated list of the original contents of this list.
      	 Keep it in private data since if we put it in a regular variable
      	 we run out of variable space when the database is very big.  
      	 Private data is in different data space.
      */
      s_lst_IdxFldChoice:private-data in frame newidx = 
      	 s_lst_IdxFldChoice:LIST-ITEMS in frame newidx
      all_cnt = NUM-ENTRIES(s_lst_IdxFldChoice:private-data in frame newidx)
      s_lst_IdxFlds:LIST-ITEMS in frame newidx = "" /* clear the list */
   
      /* Reset sensitiveness of widgets */
      s_lst_IdxFlds:sensitive in frame newidx = false
      s_btn_IdxFldAdd:sensitive in frame newidx = true
      s_btn_IdxFldRmv:sensitive in frame newidx = false
      s_btn_IdxFldDwn:sensitive in frame newidx = false
      s_btn_IdxFldUp:sensitive in frame newidx = false.

   display "" @ b_Index._Index-Name /* blank instead of ? */
           idx-area-name
      	   s_Idx_Primary
       	   b_Index._Active
       	   b_Index._Unique
       	   s_Idx_Word
      	   s_Idx_Abbrev
      	   s_lst_IdxFldChoice
      	   s_lst_IdxFlds
      	   s_IdxFld_AscDesc
       	   b_Index._Desc
       with frame newidx.

   /* Set selection to first item in list of fields */
   s_lst_IdxFldChoice:screen-value in frame newidx =
      s_lst_IdxFldChoice:entry(1) in frame newidx.

   wait-for choose of s_btn_OK in frame newidx,
      	              s_btn_Add in frame newidx OR
      	    GO of frame newidx
      	    FOCUS b_Index._Index-Name in frame newidx.
end.

/* Reset private data to free memory - it could be big */
s_lst_IdxFldChoice:private-data in frame newidx = "".

hide frame newidx.
return.







