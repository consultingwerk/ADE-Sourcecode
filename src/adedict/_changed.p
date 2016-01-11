/*********************************************************************
* Copyright (C) 2006 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
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

08/26/94 by gfs       Added Recid index support.
05/19/99 by Mario B.  Adjust Width Field browser integration.
09/19/02 by D. McMann Changed SQL Width to Max Width
06/08/06    fernando  Added support for int64
----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/uivar.i   shared}
{adecomm/cbvar.i   shared}

{adedict/TBL/tblvar.i   shared}
{adedict/SEQ/seqvar.i   shared}
{adedict/FLD/fldvar.i   shared}
{adedict/IDX/idxvar2.i  shared}
{adedict/IDX/idxvar.i   shared}
{prodict/gui/widthvar.i shared}

{adedict/capab.i}

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
      /* For reasons too lengthy to explain here, this is done this way   *
       * so that s_CurrObj stays at {&OBJ_TBL}.  {&OBJ_WIDTH} has limited *
       * use and is not a real object, but a window.  Still, it needed to *
       * be defined for other tools.  5/22/99 - Mario B.                  */
      IF s_win_Width <> ? THEN
      DO:
         changed = no.
         chg-loop: FOR EACH w_Field NO-LOCK:  
            FIND _Field WHERE _Field._File-Recid = w_Field._File-Recid AND
                              _Field._Field-Name = w_Field._Field-Name 
            NO-LOCK NO-ERROR.
            IF AVAIL _Field THEN 
            DO:
               changed = w_Field._Width <> _Field._Width.  
               IF changed THEN LEAVE chg-loop.
            END.
         END.
         IF changed THEN
         DO:
            current-window = s_win_Width.
            MESSAGE msg1 "Max Width Values." SKIP msg2
                    view-as ALERT-BOX QUESTION buttons YES-NO update save_ans
                    in window s_win_Width.
         	    
            IF save_ans THEN
            DO:
               run prodict/gui/_savwidt.p.
               IF RETURN-VALUE = "error" THEN p_Error = YES.
               run prodict/gui/_guisqlw.p.
            END.
            ELSE
               RUN prodict/gui/_guisqlw.p.
	 END. 
      ELSE 
         RUN prodict/gui/_guisqlw.p.
      END.

      /* If the Table Properties window is not open, no need to check for *
       * changes.                                                         */
      IF s_win_Tbl = ? THEN RETURN.
      
      /* If edit object was just deleted, don't check for changes  */
      if NOT AVAILABLE b_File THEN
         RETURN.

      if s_Tbl_ReadOnly then return.

      /* For gateway stuff, if the attribute is not supported by the gateway
      	 "n/a" will be displayed there or the attribute will invisible,
      	 meaning the value won't match the buffer but in that case, we
      	 don't care.
      */
      run adedict/_capab.p (INPUT {&CAPAB_TBL}, OUTPUT capab).
      for_name = INDEX(capab, {&CAPAB_TBL_SIZE}) > 0 AND
      	       	 INDEX(capab, {&CAPAB_CHANGE_TBL_SIZE}) > 0.
      for_size = INDEX(capab, {&CAPAB_FOR_NAME}) > 0 AND
      	       	 INDEX(capab, {&CAPAB_CHANGE_FOR_NAME}) > 0.

      name = b_File._File-Name.
      changed =
      	 input frame tblprops b_File._File-Name  <> name OR
      	 input frame tblprops b_File._Dump-Name  <> b_File._Dump-Name  OR
      	 input frame tblprops b_File._Hidden     <> b_File._Hidden     OR
      	 input frame tblprops b_File._File-label <> b_File._File-label OR
      	 input frame tblprops b_File._Desc       <> b_File._Desc.

      if NOT changed AND for_name then
      	 changed = input frame tblprops b_File._For-Name <> b_File._For-Name.

      if NOT changed AND for_size then 
      	 changed = input frame tblprops b_File._For-Size <> b_File._For-Size.

      /*--- Save policy has been changed --------------------------------
      	 this is obsolete but leave in case we change our minds!

      if NOT changed then
      	 /* Check if changes were made in validation or trigger sub-dialogs */
      	 run adedict/TBL/tblworkf.p (INPUT {&CMP_WORK}, OUTPUT changed).
      -----------------------------------------------------------------*/
      if changed then 
      do:
      	 current-window = s_win_Tbl.
      	 message msg1 "table properties." SKIP msg2
       	    view-as ALERT-BOX QUESTION buttons YES-NO update save_ans
      	    in window s_win_Tbl.

      	 if save_ans then
      	 do:
      	    run adedict/TBL/_savetbl.p. 
      	    if RETURN-VALUE = "error" then p_Error = yes.
      	 end.
      	 else do:
      	    /*--- Save policy has been changed --------------------------------
      	       this is obsolete but leave in case we change our minds!

      	    /* Undo validation and trigger changes.  Main property changes
      	       haven't been saved yet (still in widgets). */
      	    run adedict/TBL/tblworkf.p (INPUT {&ALL_FROM_WORK}, OUTPUT junk).
      	    ----------------------------------------------------------------*/
      	    
      	    /* Reset the widgets in the main display to show old values. */
      	    if p_Revert then
      	    do:
      	       display 	b_File._File-Name
		     	b_File._Dump-Name
			b_File._Hidden
			b_File._Desc
      	       	     	b_File._For-Name when for_name
			b_File._For-Size when for_size
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
      	 input frame seqprops b_Sequence._Cycle-Ok <> b_Sequence._Cycle-Ok OR
      	 input frame seqprops s_Seq_Limit    	   <> s_Seq_Limit.      	 

      if changed then 
      do:
      	 current-window = s_win_Seq.
      	 message msg1 "sequence properties." SKIP msg2 
       	    view-as ALERT-BOX QUESTION buttons YES-NO update save_ans
      	    in window s_win_Seq.
      	 if save_ans then
      	 do:   
      	    run adedict/SEQ/_saveseq.p
      	       (b_Sequence._Seq-name:HANDLE in frame seqprops,
       	        input frame seqprops b_Sequence._Seq-Incr,
		input frame seqprops s_Seq_Limit,
		b_Sequence._Seq-Init:HANDLE in frame seqprops,
		input frame seqprops b_Sequence._Cycle-Ok).
      	    if RETURN-VALUE = "error" then p_Error = yes.
      	 end.
      	 else if p_Revert then
      	 do:
      	    /* Reset the widgets in the main display to show old values. */
      	    display b_Sequence._Seq-Name
	       	    b_Sequence._Seq-Init
      	       	    b_Sequence._Seq-Incr
      	       	    s_Seq_Limit
 	       	    b_Sequence._Cycle-Ok
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
      	 input frame fldprops b_Field._Order      <> b_Field._Order      OR
      	 input frame fldprops b_Field._Desc       <> b_Field._Desc.

      /* for a Progress db, check if the user changed an integer field to
         int64 
      */
      IF {adedict/ispro.i} AND b_Field._Data-type <> s_Fld_Protype AND
          b_field._dtype = {&DTYPE_INTEGER} AND s_Fld_Protype = "int64" THEN
          changed = YES.

      IF NOT changed THEN DO:

          /* For a Progress db, most fields are not valid for CLOB/BLOB fields */
          IF {adedict/ispro.i} AND (b_field._dtype = {&DTYPE_BLOB} OR  b_field._dtype = {&DTYPE_CLOB}) THEN DO:
             changed = input frame fldprops s_lob_size <> b_Field._Fld-Misc2[1].
          END.
          ELSE  
              changed =  input frame fldprops b_Field._Format 	  <> b_Field._Format     OR
                         input frame fldprops b_Field._Label      <> b_Field._Label      OR
                         input frame fldprops b_Field._Col-Label  <> b_Field._Col-Label  OR
                         input frame fldprops b_Field._Initial    <> b_Field._Initial    OR
                         input frame fldprops b_Field._Mandatory  <> b_Field._Mandatory  OR
                         input frame fldprops b_Field._Help       <> b_Field._Help.
      END.

      if NOT changed then
      do:
      	 if b_Field._dtype = {&DTYPE_DECIMAL} then
      	    changed =
      	       input frame fldprops b_Field._Decimal <> b_Field._Decimal.
      	 else if b_Field._dtype = {&DTYPE_CHARACTER} OR b_Field._dtype = {&DTYPE_CLOB} then
      	    changed = 
      	       input frame fldprops b_Field._Fld-case <> b_Field._Fld-case.
      end.

      /*--- Save policy has been changed --------------------------------
        this is obsolete but leave in case we change our minds!

      if NOT changed then
      	 /* Check if changes were made in validation, trigger or gateway
      	    sub-dialogs */
      	 run adedict/FLD/fldworkf.p (INPUT {&CMP_WORK}, OUTPUT changed).
      -------------------------------------------------------------------*/

      if changed then 
      do:
      	 current-window = s_win_Fld.
      	 message msg1 "field properties." SKIP msg2 
       	    view-as ALERT-BOX QUESTION buttons YES-NO update save_ans
      	    in window s_win_Fld.

      	 if save_ans then
      	 do:
      	    run adedict/FLD/_savefld.p.
      	    if RETURN-VALUE = "error" then p_Error = yes.
      	 end.
      	 else do:
      	    /*--- Save policy has been changed --------------------------------
               this is obsolete but leave in case we change our minds!

      	    /* Undo validation, trigger and gateway changes.  Main
      	       property changes haven't been saved yet (still in widgets). */
      	    run adedict/FLD/fldworkf.p (INPUT {&ALL_FROM_WORK}, OUTPUT junk).
      	    -----------------------------------------------------------------*/

      	    /* Reset the widgets in the main display to show old values. */
      	    if p_Revert then
      	    do:
      	       display b_Field._Field-Name 
      	       	       b_Field._Format
      	       	       b_Field._Label
      	       	       b_Field._Col-Label
      	       	       b_Field._Initial
      	       	       b_Field._Mandatory
      	       	       b_Field._Order
      	       	       b_Field._Desc
      	       	       b_Field._Help
      	       	       b_Field._Decimals when b_Field._dtype = {&DTYPE_DECIMAL}
      	       	       b_Field._Fld-case when b_Field._dtype = {&DTYPE_CHARACTER}
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
      	    run adedict/IDX/_saveidx.p.
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

   when {&OBJ_DOM} then
   do:
      /* Add this when we support domain.  Domains and field will have
      	 to use different buffers and work files.  This needs fixing!
      */
   end.
end.

