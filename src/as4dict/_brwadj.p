
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

File: _brwadj.p

Description:
   Adjust the browse window.  This means hide and show things based on
   what the user just selected.
 
Input Parameters:
   p_Obj_Num   - The symbolic object number (e.g., {&OBJ_TBL}) of the 
      	         type of object that was just selected for display or 
      	         which just had an item added or deleted from it's browse
      	         list.  This will be {&OBJ_DB} only when a new database
      	         is selected or we perform an undo on the current database.

      	         When the database toggle icon is selected, no browse
      	         window changes need to occur except for the action button
      	         label change (done in brwtrig.i).

   p_Cnt       - For all object types except database, this should be
      	         the number of items in the select list for this type.
      	       	 If we've just added or deleted an item from the list
      	       	 the list may have become empty or a previously empty
      	       	 list may now have an item in it and we may need to
      	       	 adjust things.  Even if the user has just chosen a object
      	       	 type to display, we have to know if the list has anything
      	         in it or not to know whether to display children etc.

      	         For databases, This should be a 0 to indicate that there
      	         is no useable database. Otherwise it should be set to any
      	       	 non-zero value.

Author: Laura Stern

Date Created: 03/27/92 
     History: 04/20/99 D. McMann Added stored procedure support

----------------------------------------------------------------------------*/

{as4dict/dictvar.i shared}
{as4dict/brwvar.i shared}

Define INPUT PARAMETER p_Obj_Num   as integer NO-UNDO.
Define INPUT PARAMETER p_Cnt 	   as integer NO-UNDO.


/*---------------------------Internal Procedures---------------------------*/

/*-------------------------------------------------------------------
   Hide or make visible the list box and fill-in and label for the 
   specified object type.
   Use the hidden attribute instead of visible to minimize flashing
   on startup.

   Input Parameter:
      p_Obj    - The object type of the list box to hide or view.
      p_Show   - Set to yes to make list visible, no to hide it
-------------------------------------------------------------------*/
PROCEDURE Show_List:

Define INPUT PARAMETER p_Obj  as integer NO-UNDO.
Define INPUT PARAMETER p_Show as logical NO-UNDO.

Define var hide_it as logical NO-UNDO.

   hide_it = NOT p_Show.

   if p_Obj = {&OBJ_FLD} OR p_Obj = {&OBJ_IDX} OR p_Obj = {&OBJ_PARM} then
      s_Lvl2Lbl:hidden in frame browse = hide_it.
   else
      s_Lvl1Lbl:hidden in frame browse = hide_it.

   case (p_Obj):
      when {&OBJ_TBL} then
      do:
      	 assign
            s_lst_Tbls:hidden in frame browse = hide_it
     	    s_TblFill:hidden  in frame browse = hide_it.
      	 if p_Show then 
      	    s_Lvl1Lbl:screen-value in frame browse = " Tables". 
      	 IF s_lst_Parm:hidden in frame browse = NO THEN
      	   ASSIGN s_lst_Parm:hidden in frame browse = YES
      	          s_Lvl2Lbl:hidden in frame browse = YES
      	          s_ParmFill:hidden in frame browse = YES.      	        	               	            
      end.
      when {&OBJ_PROC} then
      do:
      	 assign
            s_lst_Proc:hidden in frame browse = hide_it
     	    s_ProcFill:hidden  in frame browse = hide_it.
      	 if p_Show then 
      	    s_Lvl1Lbl:screen-value in frame browse = " Procedures". 
      	 IF s_lst_Flds:hidden in frame browse = NO THEN
      	   ASSIGN s_lst_Flds:hidden in frame browse = YES
      	          s_Lvl2Lbl:hidden in frame browse = YES
      	          s_FldFill:hidden in frame browse = YES.
      	 IF s_lst_Idxs:hidden in frame browse = NO THEN
      	   ASSIGN s_lst_Idxs:hidden in frame browse = YES
      	          s_Lvl2Lbl:hidden in frame browse = YES
      	          s_IdxFill:hidden in frame browse = YES.            
      end.
      when {&OBJ_SEQ} then
      do:
      	 assign
      	    s_lst_Seqs:hidden in frame browse = hide_it
      	    s_SeqFill:hidden  in frame browse = hide_it.
      	 if p_Show then 
      	    s_Lvl1Lbl:screen-value in frame browse = " Sequences".   
      end.
      when {&OBJ_FLD} then
      do:     
      	 assign
            s_lst_Flds:hidden in frame browse = hide_it
      	    s_FldFill:hidden  in frame browse = hide_it.
      	 if p_Show then 
      	    s_Lvl2Lbl:screen-value in frame browse = " Fields".   
      end.
      when {&OBJ_IDX} then
      do:
      	 assign
            s_lst_Idxs:hidden in frame browse = hide_it
      	    s_IdxFill:hidden  in frame browse = hide_it.
      	 if p_Show then 
      	    s_Lvl2Lbl:screen-value in frame browse = " Indexes". 
      end.
      when {&OBJ_PARM} then
      do:      
      	 assign
            s_lst_Parm:hidden in frame browse = hide_it
      	    s_ParmFill:hidden  in frame browse = hide_it.
      	 if p_Show then 
      	    s_Lvl2Lbl:screen-value in frame browse = " Parameters".   
      end.
   end.
end.


/*------------------------------------------------------------------
   Hide or make visible the toggle icons for the specified level
   (1 - tbl/seq/proc, 2 - fld, idx, 3 - parm).
   Use the hidden attribute instead of visible to minimize flashing
   on startup.

   Input Parameter:
      p_Level - 1, 2 or 3 
      p_Show  - Set to yes to make toggles visible, no to hide them
-------------------------------------------------------------------*/
PROCEDURE Show_Toggles:

Define INPUT PARAMETER p_Level 	  as integer NO-UNDO.
Define INPUT PARAMETER p_Show 	  as logical NO-UNDO.

Define var hide_it  as logical NO-UNDO.
Define var phide-it as logical NO-UNDO.

   hide_it = NOT p_Show.
   IF allow_st_proc THEN 
     phide-it = false.
   ELSE 
     phide-it = TRUE.
     
   if p_Level = 1 then
      assign
      	 s_icn_Tbls:hidden   in frame browse = hide_it
      	 s_TblLbl:hidden     in frame browse = hide_it
      	 s_icn_Proc:hidden   in frame browse = phide-it
      	 s_ProcLbl:hidden    in frame browse = phide-it      	 
      	 s_icn_Seqs:hidden   in frame browse = hide_it
      	 s_SeqLbl:hidden     in frame browse = hide_it.
   else if p_Level = 2 THEN
      assign
      	 s_icn_Flds:hidden   in frame browse = hide_it
      	 s_FldLbl:hidden     in frame browse = hide_it
      	 s_icn_Parm:hidden   in frame browse = YES
      	 s_ParmLbl:hidden    in frame browse = YES
      	 s_icn_Idxs:hidden   in frame browse = hide_it
      	 s_IdxLbl:hidden     in frame browse = hide_it.
   ELSE
      assign
      	 s_icn_Flds:hidden   in frame browse = YES
      	 s_FldLbl:hidden     in frame browse = YES
      	 s_icn_Parm:hidden   in frame browse = hide_it
      	 s_ParmLbl:hidden    in frame browse = hide_it
      	 s_icn_Idxs:hidden   in frame browse = YES
      	 s_IdxLbl:hidden     in frame browse = YES.   
end.


/*-----------------------------Mainline Code------------------------------*/

Define var fill_widget  as widget-handle  NO-UNDO.
Define var lst_widget   as widget-handle  NO-UNDO.
Define var msg          as char           NO-UNDO.

case (p_Obj_Num):
   when {&OBJ_DB} then
   do:
      /* This stuff will be hidden regardless of the db choice. */
      run Show_List (INPUT {&OBJ_PARM}, INPUT no). 
      run Show_List (INPUT {&OBJ_SEQ}, INPUT no).
      run Show_List (INPUT {&OBJ_FLD}, INPUT no).
      run Show_List (INPUT {&OBJ_IDX}, INPUT no).
      
      /* Delete any open edit windows. */
      run as4dict/_delwins.p (INPUT no).

      if p_Cnt <> 0 then
      do: 
	 /* Allow user to choose what object they want to work with */
      	 run Show_Toggles (INPUT 1, INPUT yes).

	 /* Indicate that all the lists need to be refilled if the user
	    chooses to display them. */
      	 {as4dict/uncache.i 
      	    &List   = "s_lst_Tbls"
      	    &Cached = "s_Tbls_Cached"
      	    &Curr   = "s_CurrTbl"}
      	 {as4dict/uncache.i 
      	    &List   = "s_lst_Proc"
      	    &Cached = "s_Proc_Cached"
      	    &Curr   = "s_CurrProc"}      	    
      	 {as4dict/uncache.i 
      	    &List   = "s_lst_Seqs"
      	    &Cached = "s_Seqs_Cached"
      	    &Curr   = "s_CurrSeq"}
      	 {as4dict/uncache.i 
      	    &List   = "s_lst_Flds"
      	    &Cached = "s_Flds_Cached"
      	    &Curr   = "s_CurrFld"}
      	 {as4dict/uncache.i 
      	    &List   = "s_lst_Idxs"
      	    &Cached = "s_Idxs_Cached"
      	    &Curr   = "s_CurrIdx"}
      	 {as4dict/uncache.i 
      	    &List   = "s_lst_Parm"
      	    &Cached = "s_Parm_Cached"
      	    &Curr   = "s_CurrParm"}

      	 /* Unpush whatever object button is down. We could cause db button
      	    to be pushed here, but we know that the tables button is about
      	    to be selected by default so don't bother.
      	 */
      	 run as4dict/_btnup.p.
      
      	 assign
	    s_CurrObj = {&OBJ_NONE}
	    s_Lvl1Obj = {&OBJ_NONE}
	    s_Lvl2Obj = {&OBJ_NONE}
	    s_icn_Flds:PRIVATE-DATA = ?
	    s_icn_Idxs:PRIVATE-DATA = ?
	    s_icn_Parm:PRIVATE-DATA = ?.

      	 /* If database prop window is up from a previous database,
      	    refresh it with props for the current database. */
      	 if s_win_Db <> ? then
      	    run as4dict/DB/_dbprop.p.
      end.
      else do:
      	 /* Don't allow the user to try looking at schema objects - there
      	    is no accessible database chosen. */
      	 run Show_Toggles (INPUT 1, INPUT no).
      	 run Show_List (INPUT {&OBJ_TBL}, INPUT no). 
      	 run Show_Toggles (INPUT 2, INPUT no).  /* hide level 2 toggles */

      	 /* Make sure the current object button is "Database". */
      	 run as4dict/_brwbtn.p (INPUT {&OBJ_DB}, 
      	       	     	         INPUT s_icn_Dbs:HANDLE in frame browse,
      	       	     	      	 INPUT false).
      end.
   end.

   when {&OBJ_PARM} OR
   when {&OBJ_FLD} OR
   when {&OBJ_IDX} then
   do:
      /* Set up for some common "empty list" processing below */
      IF p_Obj_Num = {&OBJ_FLD} OR p_Obj_Num = {&OBJ_IDX} THEN 
        assign fill_widget = (if p_Obj_Num = {&OBJ_FLD}
                              then s_FldFill:HANDLE in frame browse
                              else s_IdxFill:HANDLE in frame browse)
         msg = (if p_Obj_Num = {&OBJ_FLD} 
                then "(no fields)"
                else "(no indexes)").
      ELSE
        assign fill_widget = s_ParmFill:HANDLE in frame browse
               msg         = "(no parameters)".
              
      /* Things to adjust if a different object has been selected */
      if s_Lvl2Obj <> p_Obj_Num then 
      do:
      	 /* Since there is a separate list box for each type (so the values
      	    can be cached), hide the currently displayed list box at the 2nd
      	    level before displaying the one with the type of objects  we want.
      	 */
      	 if s_Lvl2Obj <> {&OBJ_NONE} then
            run Show_List (INPUT s_Lvl2Obj, INPUT no).

      	 run Show_List (INPUT p_Obj_Num, INPUT yes).
	 s_Lvl2Obj = p_Obj_Num.
      end.
   end.  /* end case for level 2 objects */

   otherwise /* {&OBJ_TBL}, {&OBJ_SEQ}, {&OBJ_PROC}*/
   do:
      /* Adjust children of tables if we've just gone from empty to
      	 non-empty table list or vice versa */
      if p_Obj_Num = {&OBJ_TBL} then
      do:
     
	 if p_Cnt = 0 then
	 do:
	    /* Hide toggles and lists of children if table list is empty */
      	    run Show_Toggles (INPUT 2, INPUT no). 
	    run Show_List (INPUT {&OBJ_FLD}, INPUT no).
	    run Show_List (INPUT {&OBJ_IDX}, INPUT no).
      	    s_Lvl2Obj = {&OBJ_NONE}.
	 end.        
	 else 
	    /* Make toggles for children visible if table isn't empty */
      	   run Show_Toggles (INPUT 2, INPUT yes).
      	 
      end.
      ELSE if p_Obj_Num = {&OBJ_PROC} then
      do:
	 if p_Cnt = 0 then
	 do:
	    /* Hide toggles and lists of children if table list is empty */
      	    run Show_Toggles (INPUT 3, INPUT no).
	    run Show_List (INPUT {&OBJ_PARM}, INPUT no). 
      	    s_Lvl2Obj = {&OBJ_NONE}.
	 end.        
	 else 
	    /* Make toggles for children visible if table isn't empty */
      	    run Show_Toggles (INPUT 3, INPUT yes).      
      end.

      /* Set up for some common "empty-list" processing below */
      assign
	 fill_widget =
	    (if p_Obj_Num = {&OBJ_TBL} then
	       s_TblFill:HANDLE in frame browse
	    else if p_Obj_Num = {&OBJ_SEQ} then
	       s_SeqFill:HANDLE in frame browse
	    else if p_Obj_Num = {&OBJ_PROC} then
	       s_ProcFill:HANDLE in frame browse
	    else ?  )
      	 msg = 
	    (if p_Obj_Num = {&OBJ_TBL} then
	       "(no tables)"
	    else if p_Obj_Num = {&OBJ_SEQ} then
	       "(no sequences)"
	    else if p_Obj_Num = {&OBJ_PROC} then
	       "(no procedures)"
	    else "(no indexes)").

      /* Things to adjust if a different object has been selected */
      if s_Lvl1Obj <> p_Obj_Num then 
      do:
      	 /* Since there is a separate list box for each type (so the values
      	    can be cached), hide the currently displayed list box at the first
      	    level before displaying the one with the type of objects  we want.
      	 */
      	 if s_Lvl1Obj <> {&OBJ_NONE} then
      	    run Show_List (INPUT s_Lvl1Obj, INPUT no).
      	 run Show_List (INPUT p_Obj_Num, INPUT yes).

      	 /* If tables was toggled on, show level 2 toggles unless the
      	    table list is empty.  If one of the children lists was displayed
      	    the last time tables were selected then display it again. */
	 if p_Obj_Num = {&OBJ_TBL} AND p_Cnt > 0 then
      	 do:
      	    run Show_Toggles (INPUT 2, INPUT yes).
      	    if s_icn_Flds:PRIVATE-DATA in frame browse = "curr" then
      	    do:
      	       run Show_List (INPUT {&OBJ_FLD}, INPUT yes).
      	       s_Lvl2Obj = {&OBJ_FLD}.
      	    end.
      	    else if s_icn_Idxs:PRIVATE-DATA in frame browse = "curr" then
      	    do:
      	       run Show_List (INPUT {&OBJ_IDX}, INPUT yes).
      	       s_Lvl2Obj = {&OBJ_IDX}.
      	    end.
      	 end.
	 ELSE if p_Obj_Num = {&OBJ_PROC} AND p_Cnt > 0 then
      	 do:
      	    run Show_Toggles (INPUT 3, INPUT yes).
           if s_icn_Parm:PRIVATE-DATA in frame browse = "curr" then 
      	    do:
      	       run Show_List (INPUT {&OBJ_PARM}, INPUT yes).
      	       s_Lvl2Obj = {&OBJ_PARM}.
      	    end.      	    
      	 end.     	 
	 else do:
	 
      	    /* sequences have no associated level 2 items */
      	    run Show_Toggles (INPUT 2, INPUT no).
      	    run Show_Toggles (INPUT 3, INPUT no).
      	    run Show_List (INPUT {&OBJ_FLD}, INPUT no).
      	    run Show_List (INPUT {&OBJ_IDX}, INPUT no).
      	    run SHOW_LIST (INPUT {&OBJ_PARM}, INPUT no).
	    s_Lvl2Obj = {&OBJ_NONE}.
	 end.
      
	 s_Lvl1Obj = p_Obj_Num.
      end.
   end.  /* end case for level 1 objects */
end.  /* end case */


/* If the list is empty, disable it and put a message in the fill-in:
   e.g., (no tables).
*/

if p_Obj_Num <> {&OBJ_DB} then
do:
   if p_Cnt = 0 then 
      assign
      	 fill_widget:screen-value = msg
      	 fill_widget:sensitive = no.
   else 
      assign
      	 fill_widget:sensitive = yes.
end.

/* Gray/ungray menu items based on new selections. For efficiency, don't 
   do this under one circumstance: if we've switched to some database
   we will cause the table list to be displayed by default - that will
   cause this to be re-called and we will gray the menus then based on
   what tables there are etc.
*/
if NOT (p_Obj_Num = {&OBJ_DB} AND p_Cnt <> 0) then
   run as4dict/_brwgray.p (INPUT false).






