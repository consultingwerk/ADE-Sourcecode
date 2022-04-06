/**********************************************************************
* Copyright (C) 2000-2010,2020 by Progress Software Corporation. All rights*
* reserved.  Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                            *
*                                                                     *
**********************************************************************/

/*----------------------------------------------------------------------------

File: _saveseq.p

Description:
   Save any changes the user made in the new sequence or sequence property 
   window.

Input Parameters:
   p_NameHdl - Widget handle of sequence name field in frame
   p_Incr    - New frame value of increment
   p_Limit   - New frame value of limit
   p_Init    - Widget handle of initial value in frame
   p_Cycle   - New frame value of cycle

Returns: "error" if the save is not complete for any reason, otherwise "".

Author: Laura Stern

Date Created: 10/19/92
History:  D. McMann 08/08/02 Eliminated any sequences whose name begins "$" 
- Peer Direct
          fernando  05/25/06 Added support for large sequences

----------------------------------------------------------------------------*/

&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/brwvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared}
{adedict/SEQ/seqvar.i shared}

Define INPUT PARAMETER p_NameHdl     as widget-handle NO-UNDO.
Define INPUT PARAMETER p_Incr 	     as int64  	  NO-UNDO.
Define INPUT PARAMETER p_Limit       as int64       NO-UNDO.
Define INPUT PARAMETER p_Init        as widget-handle NO-UNDO.
Define INPUT PARAMETER p_Cycle       as logical   	  NO-UNDO.
Define INPUT PARAMETER p_Multitenant as logical       NO-UNDO.

Define var incr     as INT64 NO-UNDO.
Define var limit    as INT64 NO-UNDO.
Define var initval  as INT64 NO-UNDO.
Define var cycle    as logical NO-UNDO.
Define var oldname  as char    NO-UNDO CASE-SENSITIVE.
Define var newname  as char    NO-UNDO CASE-SENSITIVE.
Define var no_name  as logical NO-UNDO.
Define var stat     as char    NO-UNDO init "error".

/*=============================Internal Procedures=========================*/

/* Add the new or renamed sequence to the browse window list */
PROCEDURE Add_to_List:
   Define INPUT PARAMETER p_name   as char NO-UNDO.  /* name to insert */
   Define var  	     	  ins_name as char NO-UNDO.
   DEFINE BUFFER b_Sequence FOR dictdb._Sequence.
   
   
   /* OCTA-21469 - Do a dynamic find on _Sequence due to different schema for index
      between OE 11 and OE 12 */
   /* find FIRST dictdb._Sequence where dictdb._Sequence._Db-recid = s_DbRecId AND
                          NOT dictdb._Sequence._Seq-name BEGINS "$"  AND
     	     	      	      dictdb._Sequence._Seq-Name > p_name 
      NO-ERROR. */
      BUFFER b_Sequence:FIND-FIRST("where dictdb._Sequence._Db-recid = " + STRING(s_DbRecId) + 
                                   " AND NOT dictdb._Sequence._Seq-name BEGINS '$'  AND 
     	     	      	           dictdb._Sequence._Seq-Name > '" + p_name + "'") NO-ERROR.

   ins_name = (if AVAILABLE dictdb._Sequence then dictdb._Sequence._Seq-name else "").
   run adedict/_newobj.p
      (INPUT s_lst_Seqs:HANDLE in frame browse,
       INPUT p_name,
       INPUT ins_name,
       INPUT s_Seqs_Cached,
       INPUT {&OBJ_SEQ}).
end.


/*==============================Mainline Code=============================*/

if NOT s_Adding then current-window = s_win_Seq.
run adedict/_blnknam.p (INPUT p_NameHdl, INPUT "sequence", OUTPUT no_name).
if no_name then return "error".

initval = INT64(P_Init:screen-value).

if p_Incr > 0 then
do:
   if p_Limit <= initval then
   do:
      message "The upper limit must be greater than the initial value."
   	      view-as ALERT-BOX ERROR buttons OK.
      apply "entry" to p_Init.
      return "error".
   end.
end.
else /* p_Incr < 0 */
do:
   if p_Limit >= initval then
   do:
      message "The lower limit must be less than the initial value."
   	       view-as ALERT-BOX ERROR buttons OK.
      apply "entry" to p_Init.
      return "error".
   end.
end.

if NOT s_Adding then
do with frame tblprops:
    oldname = b_Sequence._Seq-Name.
    /** cannot currently change existing sequence to be multi-tenant 
    if input b_Sequence._Seq-Attributes[1] and not b_Sequence._Seq-Attributes[1] then
    do:
        run adedict/SEQ/_okmtseq.p. 
        if return-value = "error" then
        do:
            return return-value.
        end.    
    end.
    **/     
end.
newname = p_NameHdl:screen-value.

do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
   run adecomm/_setcurs.p ("WAIT").
   if s_Adding then 
      assign
      	 b_Sequence._Db-recid = s_DbRecId
         b_Sequence._Seq-Attributes[1] = p_Multitenant.
    
   assign
      b_Sequence._Seq-Name = newname  
      b_Sequence._Seq-Init = initval
      b_Sequence._Seq-Incr = p_Incr
      b_Sequence._Cycle-Ok = p_Cycle
      s_Seq_Limit = p_Limit.

   if p_Incr > 0 then
      assign
   	 b_Sequence._Seq-Min = initval
   	 b_Sequence._Seq-Min = ?
   	 b_Sequence._Seq-Max = p_Limit.
   else  
      assign
   	 b_Sequence._Seq-Min = p_Limit
   	 b_Sequence._Seq-Max = ?
   	 b_Sequence._Seq-Max = initval.

   /* Make adjustments to browse and edit windows. */
   if s_Adding then
      run Add_to_List (INPUT b_Sequence._Seq-Name).
   else do:
      if oldname <> newname then
      do:
	 /* If name was changed change the name in the browse list.
	    If there's more than one sequence, delete and re-insert to
	    make sure the new name is in alphabetical order.
	 */
	 if s_lst_Seqs:NUM-ITEMS in frame browse > 1 then
	 do:
	    s_Res = s_lst_Seqs:delete(oldname) in frame browse.
      	    run Add_to_List (INPUT newname).
      	 end.
      	 else do:
	    /* Change name in place in browse window list. */
	    {adedict/repname.i
	       &OldName = oldname
	       &NewName = newname
	       &Curr    = s_CurrSeq
	       &Fill    = s_SeqFill
	       &List    = s_lst_Seqs}  
      	 end.
      end.  
   end.
   
   /* This assures that the record buffer will be flushed.  Without
      this, Progress can't find current value of sequence (which currently 
      we don't access in the dictionary but we might.)
   */
   if s_Adding then
      release b_Sequence.

   {adedict/setdirty.i &Dirty = "true"}.
   
   if s_Adding then
      display "Sequence Created" @ s_Status with frame newseq. 
   else do with frame seqprops:
      /*
      if b_Sequence._Seq-Attributes[1]:sensitive and b_Sequence._Seq-Attributes[1] then
      do:
          b_Sequence._Seq-Attributes[1]:sensitive = false.
          s_Seq_Current_Value = "n/a".
          display s_Seq_Current_Value.
      end.
      */  
      display "Sequence Modified" @ s_Status.
   end.   
   stat = "".  /* success (not "error") */
end.

run adecomm/_setcurs.p ("").
return stat.





