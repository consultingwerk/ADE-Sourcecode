/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _brwbtn.p (push browse button)

Description:
   Do some stuff that is necessary when the user pushes one of the object
   buttons on the browse window (or when the codes needs to select the database
   object because there are no connected databases).
 
Input Parameters:
   p_Obj       	   - The object type of the button pushed.
   p_Icn       	   - The icon widget for this object type.
   p_Lvl2_Remember - If true: if a level 2 button is currently pushed and
      	       	     we switch to a non-level object, remember which level 2
      	       	     object was current.
      	       	     If false: we don't care to remember.  In fact, reset
      	       	     the flag on both buttons.

Author: Laura Stern

Date Created: 09/23/92 

----------------------------------------------------------------------------*/

{adedict/dictvar.i shared}
{adedict/brwvar.i shared}

Define INPUT PARAMETER p_Obj  	       as integer       NO-UNDO.
Define INPUT PARAMETER p_Icn  	       as widget-handle NO-UNDO.
Define INPUT PARAMETER p_Lvl2_Remember as logical     	NO-UNDO.

/* Set to button down icon */
case p_Obj:
   when {&OBJ_DB} then
      s_Res = p_Icn:LOAD-IMAGE("adeicon/db-d").
   when {&OBJ_TBL} then
      s_Res = p_Icn:LOAD-IMAGE("adeicon/table-d").  
   when {&OBJ_SEQ} then
      s_Res = p_Icn:LOAD-IMAGE("adeicon/seq-d").
   when {&OBJ_FLD} then
      s_Res = p_Icn:LOAD-IMAGE("adeicon/flds-d").
   when {&OBJ_IDX} then
      s_Res = p_Icn:LOAD-IMAGE("adeicon/index-d").
end.

/* Un-push whatever button is currently pushed in. */
run adedict/_btnup.p.

/* For level 2 objects, remember which one is pushed. Then if we 
   switch from table to sequence and back again we want to reshow
   (not repush - only table will be pushed in) the list that was 
   selected last. 
*/
if p_Lvl2_Remember then
   if p_Obj <> {&OBJ_FLD} AND p_Obj <> {&OBJ_IDX} then  /* for efficiency */
   do:
      if s_CurrObj = {&OBJ_FLD} then 
	 assign
	    s_icn_Flds:PRIVATE-DATA in frame browse = "curr"
	    s_icn_Idxs:PRIVATE-DATA in frame browse = "notcurr".
      else if s_CurrObj = {&OBJ_IDX} then
	 assign
	    s_icn_Flds:PRIVATE-DATA in frame browse = "notcurr"
	    s_icn_Idxs:PRIVATE-DATA in frame browse = "curr".
   end.
else
   assign
      s_icn_Flds:PRIVATE-DATA in frame browse = ?
      s_icn_Idxs:PRIVATE-DATA in frame browse = ?.

s_CurrObj = p_Obj.

/* Reset labels */
case s_CurrObj:
   when {&OBJ_DB} then
      assign
   	 s_btn_Create:label in frame browse = "C&reate Database..."
   	 s_btn_Props:label in frame browse = "Database &Properties"
   	 s_btn_Delete:hidden in frame browse = yes. /* no such function */
   when {&OBJ_TBL} then
      assign
   	 s_btn_Create:label in frame browse = "C&reate Table..."
   	 s_btn_Props:label in frame browse = "Table &Properties..."
   	 s_btn_Delete:label in frame browse = "De&lete Table"
   	 s_btn_Delete:hidden in frame browse = no.
  
   when {&OBJ_SEQ} then
      assign
   	 s_btn_Create:label in frame browse = "C&reate Sequence..."
   	 s_btn_Props:label in frame browse = "Sequence &Properties..."
   	 s_btn_Delete:label in frame browse = "De&lete Sequence"
   	 s_btn_Delete:hidden in frame browse = no.
   when {&OBJ_FLD} then
      assign
   	 s_btn_Create:label in frame browse = "C&reate Field..."
   	 s_btn_Props:label in frame browse = "Field &Properties..."
   	 s_btn_Delete:label in frame browse = "De&lete Field"
   	 s_btn_Delete:hidden in frame browse = no.
   when {&OBJ_IDX} then
      assign
   	 s_btn_Create:label in frame browse = "C&reate Index..."
   	 s_btn_Props:label in frame browse = "Index &Properties..."
   	 s_btn_Delete:label in frame browse = "De&lete Index"
   	 s_btn_Delete:hidden in frame browse = no.
end.

/* Make sure these are visible.  They should be except for the first time.
   Put this here to make sure the buttons don't appear with the wrong
   label on them at startup.  If already visible, this SHOULD be fast.
*/
assign
   s_btn_Create:hidden in frame browse = no
   s_btn_Props:hidden in frame browse = no.


