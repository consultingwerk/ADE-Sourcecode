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

File: _changed.p

Description: 
   The user is trying to close a property window or replace it's contents.
   Determine if anything has changed that he hasn't saved.  If so, ask him
   if he wants to save stuff.

Input Parameter:
   p_Obj    - The object type of the property window we're dealing with.
   p_Revert - True means: if there were changes and the user does not want to
      	      save, refresh the screen to reflect the old values.  This
      	      looks good but it also makes the widgets and the buffer match
      	      up so that if something else happens which requires checking
      	      for changes we won't think that changes have occurred again.

      	      False means: Don't refresh values on screen because the 
      	      properties are about to be closed or replaced with another
      	      object so don't spend the time and avoid flashing.

Output Parameter:
   p_Error - Set to true if something was modified and the save produced
      	     an error.

Author: Laura Stern

Date Created: 06/06/92 

Last modified on:

08/26/94 by gfs     Added Recid index support.
           Modified to work with PROGRESS/400 Data Dictionary   D. McMann
----------------------------------------------------------------------------*/

{as4dict/dictvar.i shared}
{as4dict/uivar.i   shared}
{adecomm/cbvar.i   shared}

{as4dict/TBL/tblvar.i shared}
{as4dict/SEQ/seqvar.i shared}
{as4dict/FLD/fldvar.i shared}
{as4dict/IDX/idxvar.i shared}

{as4dict/capab.i}


Define INPUT   PARAMETER p_Obj    as integer NO-UNDO.
Define INPUT   PARAMETER p_Revert as logical NO-UNDO.
Define OUTPUT  PARAMETER p_Error  as logical NO-UNDO.


/*--------------------------Mainline Code---------------------------------*/

Define var changed  as logical NO-UNDO.
Define var save_ans as logical NO-UNDO.
Define var junk     as logical NO-UNDO.
Define var for_size as logical NO-UNDO.
Define var for_name as logical NO-UNDO.
Define var capab    as char    NO-UNDO.
Define var name     as char    NO-UNDO case-sensitive.

Define var msg1     as char    NO-UNDO init
   "You have made changes to".
Define var msg2     as char    NO-UNDO init
   "Do you want to save these changes?".

p_Error = no.


case (p_Obj):
   when {&OBJ_TBL} then
   do:
      /* If edit object was just deleted, don't check for changes */
      if NOT AVAILABLE b_File then return.

      if s_Tbl_ReadOnly then return.

      /* For gateway stuff, if the attribute is not supported by the gateway
      	 "n/a" will be displayed there or the attribute will invisible,
      	 meaning the value won't match the buffer but in that case, we
      	 don't care.
      */
      run as4dict/_capab.p (INPUT {&CAPAB_TBL}, OUTPUT capab).
      for_name = INDEX(capab, {&CAPAB_TBL_SIZE}) > 0 AND
      	       	 INDEX(capab, {&CAPAB_CHANGE_TBL_SIZE}) > 0.
      for_size = INDEX(capab, {&CAPAB_FOR_NAME}) > 0 AND
      	       	 INDEX(capab, {&CAPAB_CHANGE_FOR_NAME}) > 0.

      name = b_File._File-Name.
      changed =
      	 input frame tblprops b_File._File-Name  <> name OR
      	 input frame tblprops b_File._Dump-Name  <> b_File._Dump-Name  OR
      	 input frame tblprops s_AS400_File_Name  <> b_File._AS4-File  OR
      	 input frame tblprops s_AS400_Lib_Name   <> b_File._AS4-Library   OR
      	 input frame tblprops s_File_Hidden      <> s_File_Hidden      OR
      	 input frame tblprops b_File._File-label <> b_File._File-label OR
      	 input frame tblprops b_File._Desc       <> b_File._Desc.

      if NOT changed AND for_size then 
      	 changed = input frame tblprops b_File._For-Size <> b_File._For-Size.

      if changed then 
      do:
      	 current-window = s_win_Tbl.
      	 message msg1 "table properties." SKIP msg2
       	    view-as ALERT-BOX QUESTION buttons YES-NO update save_ans
      	    in window s_win_Tbl.

      	 if save_ans then
      	 do:
      	    run as4dict/TBL/_savetbl.p.
      	    if RETURN-VALUE = "error" then p_Error = yes.
      	 end.
      	 else do:
      	    
      	    /* Reset the widgets in the main display to show old values. */
      	    if p_Revert then
      	    do:
      	       display 	b_File._File-Name
      	                                  s_AS400_File_Name
      	                                  s_AS400_Lib_Name
		     	b_File._Dump-Name
			s_File_Hidden
			b_File._Desc
			b_File._For-Size when for_size     
			b_File._For-format
      	       	  with frame tblprops.
      	    end.
      	 end.
      end.
   end.

   when {&OBJ_SEQ} then
   do:                 
      /* If edit object was just deleted, don't check for changes */
      if NOT AVAILABLE b_Sequence then return.

      if s_Seq_ReadOnly then return.

      name = b_Sequence._Seq-Name.
      changed =
      	 input frame seqprops b_Sequence._Seq-Name <> name OR
      	 input frame seqprops b_Sequence._Seq-Init <> b_Sequence._Seq-Init OR
      	 input frame seqprops b_Sequence._Seq-Incr <> b_Sequence._Seq-Incr OR
      	 input frame seqprops s_Seq_Cycle_Ok <> s_Seq_Cycle_Ok OR
      	 input frame seqprops s_Seq_Limit    	   <> s_Seq_Limit.      	 

      if changed then 
      do:
      	 current-window = s_win_Seq.
      	 message msg1 "sequence properties." SKIP msg2 
       	    view-as ALERT-BOX QUESTION buttons YES-NO update save_ans
      	    in window s_win_Seq.
      	 if save_ans then
      	 do:   
      	    run as4dict/SEQ/_saveseq.p
      	       (b_Sequence._Seq-name:HANDLE in frame seqprops,
       	        input frame seqprops b_Sequence._Seq-Incr,
		input frame seqprops s_Seq_Limit,
		b_Sequence._Seq-Init:HANDLE in frame seqprops,
		input frame seqprops s_Seq_Cycle_Ok).
      	    if RETURN-VALUE = "error" then p_Error = yes.
      	 end.
      	 else if p_Revert then
      	 do:
      	    /* Reset the widgets in the main display to show old values. */
      	    display b_Sequence._Seq-Name
	       	    b_Sequence._Seq-Init
      	       	    b_Sequence._Seq-Incr
      	       	    s_Seq_Limit
 	       	    s_Seq_Cycle_Ok
      	       with frame seqprops.

	    if b_Sequence._Seq-Incr < 0 then
	       s_Seq_Limit:label in frame seqprops = "Lower limit:".
	    else
	       s_Seq_Limit:label in frame seqprops = "Upper limit:".
      	 end.
      end.
   end.

   when {&OBJ_FLD} then
   do:
      /* If edit object was just deleted, don't check for changes */
      if NOT AVAILABLE b_Field then return.

      if s_Fld_ReadOnly then return.

      name = b_Field._Field-Name.
      changed =
      	 input frame fldprops b_Field._Field-Name <> name                OR
                  input frame fldprops b_Field._For-Name   <> b_Field._For-Name   OR
      	 input frame fldprops b_Field._Format 	  <> b_Field._Format     OR
      	 input frame fldprops b_Field._Label      <> b_Field._Label      OR
      	 input frame fldprops b_Field._Col-Label  <> b_Field._Col-Label  OR
      	 input frame fldprops b_Field._Initial    <> b_Field._Initial    OR
      	 input frame fldprops s_Fld_Mandatory     <> s_Fld_Mandatory     OR
      	 input frame fldprops s_Fld_Null_Capable  <> s_Fld_Null_Capable  OR
      	 input frame fldprops b_Field._Order      <> b_Field._Order      OR
      	 input frame fldprops b_Field._Desc       <> b_Field._Desc       OR
      	 input frame fldprops b_Field._Help       <> b_Field._Help.

      if NOT changed then
      do:
      	 if b_Field._dtype = {&DTYPE_DECIMAL} then
      	    changed =
      	       input frame fldprops b_Field._Decimal <> b_Field._Decimal.
 
      end.

      if changed then 
      do:
      	 current-window = s_win_Fld.
      	 message msg1 "field properties." SKIP msg2 
       	    view-as ALERT-BOX QUESTION buttons YES-NO update save_ans
      	    in window s_win_Fld.

      	 if save_ans then
      	 do:
      	    run as4dict/FLD/_savefld.p.
      	    if RETURN-VALUE = "error" then p_Error = yes.
      	 end.
      	 else do:
      
      	    /* Reset the widgets in the main display to show old values. */
      	    if p_Revert then
      	    do:
      	       display b_Field._Field-Name 
      	               b_Field._For-Name
      	       	       b_Field._Format
      	       	       b_Field._Label
      	       	       b_Field._Col-Label
      	       	       b_Field._Initial
      	       	       s_Fld_Mandatory   
      	       	       s_Fld_Null_Capable
      	       	       b_Field._Order
      	       	       b_Field._Desc
      	       	       b_Field._Help
      	       	       b_Field._Decimals when b_Field._dtype = {&DTYPE_DECIMAL}   
      	       	  with frame fldprops.
      	    end.
      	 end.
      end.
   end.

   when {&OBJ_IDX} then
   do:
      /* If edit object was just deleted, don't check for changes */
      if NOT AVAILABLE b_Index then return.

      if s_Idx_ReadOnly then return.

      name = b_Index._Index-Name.
      changed =
      	 input frame idxprops b_Index._Index-Name <> name                OR
      	 input frame idxprops s_Idx_Primary       <> s_Idx_Primary       OR
      	 input frame idxprops ActRec              <> ActRec              OR
      	 input frame idxprops b_Index._Desc       <> b_Index._Desc.

      if changed then 
      do:
      	 current-window = s_win_Idx.
      	 message msg1 "index properties." SKIP msg2
       	    view-as ALERT-BOX QUESTION buttons YES-NO update save_ans
      	    in window s_win_Idx.
      	 if save_ans then
      	 do:
      	    run as4dict/IDX/_saveidx.p.
      	    if RETURN-VALUE = "error" then p_Error = yes.
      	 end.
      	 else if p_Revert then
      	    display  b_Index._Index-Name
      	       	     s_Idx_Primary
      	       	     ActRec
      	       	     b_Index._Desc
      	       with frame idxprops.
      end.
   end.
end.
