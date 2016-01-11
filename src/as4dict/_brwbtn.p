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
           Modified for PROGRESS/400 Data Dictionary  D. McMann
           04/01/99 Added Stored Procedures Support   D. McMann
           
          
----------------------------------------------------------------------------*/

{as4dict/dictvar.i shared}
{as4dict/brwvar.i shared}

Define INPUT PARAMETER p_Obj  	       as integer       NO-UNDO.
Define INPUT PARAMETER p_Icn  	       as widget-handle NO-UNDO.
Define INPUT PARAMETER p_Lvl2_Remember as logical     	NO-UNDO.

/* Set to button down icon */
case p_Obj:
   when {&OBJ_DB} then
      s_Res = p_Icn:LOAD-IMAGE("adeicon/db-d").
   when {&OBJ_TBL} then
      s_Res = p_Icn:LOAD-IMAGE("adeicon/table-d").
  
   when {&OBJ_PROC} then
      s_Res = p_Icn:LOAD-IMAGE("adeicon/asproc-d").
   when {&OBJ_SEQ} then
      s_Res = p_Icn:LOAD-IMAGE("adeicon/seq-d").
   when {&OBJ_FLD} then
      s_Res = p_Icn:LOAD-IMAGE("adeicon/flds-d").
   when {&OBJ_IDX} then
      s_Res = p_Icn:LOAD-IMAGE("adeicon/index-d").
   when {&OBJ_PARM} then
      s_Res = p_Icn:LOAD-IMAGE("adeicon/asparm-d").
   
end.

/* Un-push whatever button is currently pushed in. */
run as4dict/_btnup.p.

/* For level 2 objects, remember which one is pushed. Then if we 
   switch from table to sequence and back again we want to reshow
   (not repush - only table will be pushed in) the list that was 
   selected last. 
*/
if p_Lvl2_Remember then
   if p_Obj <> {&OBJ_FLD} AND p_Obj <> {&OBJ_IDX} AND p_Obj <> {&OBJ_PARM}
    then  /* for efficiency */
   do:
      if s_CurrObj = {&OBJ_FLD} then 
	 assign
	    s_icn_Flds:PRIVATE-DATA in frame browse = "curr"
	    s_icn_Parm:PRIVATE-DATA in frame browse = "notcurr"
	    s_icn_Idxs:PRIVATE-DATA in frame browse = "notcurr".
      else if s_CurrObj = {&OBJ_IDX} then
	 assign
	    s_icn_Flds:PRIVATE-DATA in frame browse = "notcurr"
	    s_icn_Parm:PRIVATE-DATA in frame browse = "notcurr"
	    s_icn_Idxs:PRIVATE-DATA in frame browse = "curr".
      else if s_CurrObj = {&OBJ_PARM} then
	 assign
	    s_icn_Flds:PRIVATE-DATA in frame browse = "notcurr"
	    s_icn_Idxs:PRIVATE-DATA in frame browse = "notcurr"
	    s_icn_Parm:PRIVATE-DATA in frame browse = "curr".
	    
   end.
else
   assign
      s_icn_Flds:PRIVATE-DATA in frame browse = ?
      s_icn_Idxs:PRIVATE-DATA in frame browse = ?
      s_icn_Parm:PRIVATE-DATA in frame browse = ?.

s_CurrObj = p_Obj.

/* Reset labels */
case s_CurrObj:
   when {&OBJ_DB} then
      assign
   	 s_btn_Create:hidden in frame browse = yes  /*no such function */
                   s_btn_Props:label in frame browse = "Database &Properties"
   	  s_btn_Delete:hidden in frame browse = yes. /* no such function */
   when {&OBJ_TBL} then
      assign
   	 s_btn_Create:label in frame browse = "C&reate Table..."
   	 s_btn_Props:label in frame browse = "Table &Properties..."
   	 s_btn_Delete:label in frame browse = "De&lete Table"    
   	 s_btn_Create:hidden in frame browse = no
   	 s_btn_Delete:hidden in frame browse = no.
   when {&OBJ_PROC} then
      assign
   	 s_btn_Create:label in frame browse = "C&reate Procedure"
   	 s_btn_Props:label in frame browse = "Procedure &Properties..."
   	 s_btn_Delete:label in frame browse = "De&lete Procedure"    
   	 s_btn_Create:hidden in frame browse = no
   	 s_btn_Delete:hidden in frame browse = no.   	 
   when {&OBJ_SEQ} then
      assign
   	 s_btn_Create:label in frame browse = "C&reate Sequence..."
   	 s_btn_Props:label in frame browse = "Sequence &Properties..."
   	 s_btn_Delete:label in frame browse = "De&lete Sequence"    
     	 s_btn_Create:hidden in frame browse = no
   	 s_btn_Delete:hidden in frame browse = no.
   when {&OBJ_FLD} then
      assign
   	 s_btn_Create:label in frame browse = "C&reate Field..."
   	 s_btn_Props:label in frame browse = "Field &Properties..."
   	 s_btn_Delete:label in frame browse = "De&lete Field"     
      	 s_btn_Create:hidden in frame browse = no
   	 s_btn_Delete:hidden in frame browse = no.
   when {&OBJ_PARM} then
      assign
   	 s_btn_Create:label in frame browse = "C&reate Parameter..."
   	 s_btn_Props:label in frame browse = "Parameter &Properties..."
   	 s_btn_Delete:label in frame browse = "De&lete Parameter"     
      	 s_btn_Create:hidden in frame browse = no
   	 s_btn_Delete:hidden in frame browse = no.
   	 
   when {&OBJ_IDX} then
      assign
   	 s_btn_Create:label in frame browse = "C&reate Index..."
   	 s_btn_Props:label in frame browse = "Index &Properties..."
   	 s_btn_Delete:label in frame browse = "De&lete Index" 
   	 s_btn_Create:hidden in frame browse = no   	 
   	 s_btn_Delete:hidden in frame browse = no.
end.

/* Make sure these are visible.  They should be except for the first time.
   Put this here to make sure the buttons don't appear with the wrong
   label on them at startup.  If already visible, this SHOULD be fast.
*/
assign
   s_btn_Props:hidden in frame browse = no.



