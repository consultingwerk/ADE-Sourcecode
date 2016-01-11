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

File: _objsel.p

Description: 
   Code to run when we are switching to a different object -
   e.g., because the user clicked on a browse select list entry or
   because the code has changed the selection (because of delete or Next
   etc.)

Input Parameter: 
   p_Obj - The object type of the object selected (e.g., OBJ_TBL)
      
Author: Laura Stern

Date Created: 05/03/92 
    Modified: 06/30/98 D. McMann Added  (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")
                                 to find of _File
              10/14/03 D. McMann Add check for LOB support
----------------------------------------------------------------------------*/

{adedict/dictvar.i shared}
{adedict/brwvar.i shared}


Define INPUT PARAMETER p_Obj as integer NO-UNDO.

Define var save_name as char NO-UNDO.


/*========================Internal Procedures===========================*/

/*-----------------------------------------------------------------------
   The user has single clicked on a select list item.  Do some initial
   processing for this action.

   Input Parameters:
      p_Lst  - The list widget for this object
      p_Win  - The window widget for this object

   Input/Output Parameters:
      p_Curr - The name for the current object of the type clicked on

  Returns: "done" if not further processing should occur.  
      	   Otherwise "".

-----------------------------------------------------------------------*/
PROCEDURE Init_Object_Selection:

Define INPUT PARAMETER 	      p_Lst  as widget-handle NO-UNDO.
Define INPUT PARAMETER 	      p_Win  as widget-handle NO-UNDO.
Define INPUT-OUTPUT PARAMETER p_Curr as char 	      NO-UNDO.

   /* If this is the value already selected don't do anything. */
   if p_Curr = p_Lst:screen-value then
      return "done".
 
   /* Save the current value and reset it based on the current selection */
   save_name = p_Curr.
   p_Curr = p_Lst:screen-value.
   if p_Curr = ? then p_Curr = "".

   return "".
end.


/*-----------------------------------------------------------------------
   Refresh properties in the appropriate edit window if a new object
   of the same type is chosen and the edit window is already open.

   Input Parameters:
      p_Obj  - The object type we're dealing with (e.g., {&OBJ_FLD})
      p_Curr - The current value for selected object of this type.
      p_Func - The name of the function to call to display properties

   Input-Output Parameters:
      p_Win - Handle of the properties window

   Output Parameters:
      p_Err  - Set to true if properties window is up and user wants
      	       tries to save before switching objects and an error occurs.
      	       We don't really want to switch when this happens or we've 
      	       got a big mess.
-----------------------------------------------------------------------*/
PROCEDURE Refresh_Props:

Define INPUT   	     PARAMETER p_Obj   as integer     	NO-UNDO.
Define INPUT   	     PARAMETER p_Curr  as char  	NO-UNDO.
Define INPUT   	     PARAMETER p_Func  as char  	NO-UNDO.
Define INPUT-OUTPUT  PARAMETER p_Win   as widget-handle NO-UNDO.
Define OUTPUT  	     PARAMETER p_Err   as logical       NO-UNDO.

Define var saveobj as integer NO-UNDO.

   p_Err = no.
   if p_Win <> ? then
   do:
      /* Make sure there is an object to show.  There may not be if we
      	 just switched to a table with no fields, if we just toggled to
      	 not showing hidden tables and there are no other tables in the 
      	 database, etc.
      */
      if p_Curr <> "" then
      do:
      	 /* Make sure we're not clobbering changes before switching. If 
      	    we're in add mode, don't check - we already did that before
      	    bringing up add dialog.  Also, if changes were made and an
      	    error occurs while saving, don't continue.
      	 */
      	 if NOT s_Adding then
      	 do:
      	    run adedict/_changed.p (INPUT p_Obj, INPUT no, OUTPUT p_Err).
      	    if p_Err then return.
      	 end.

      	 /* The field properties routine depends on s_CurrObj being set to
      	    know what to do (since field props routine currently deals with
      	    fields and domains).  However, we're not necessarily in field 
      	    mode just because we're showing field properties.  e.g., While 
      	    field props window is up, user may be in table mode and when 
      	    he clicks on a different table, the fields for that table are
      	    shown and the field props window is refreshed.  But the user
      	    wants to remain in table mode.  So save the current object
      	    change it temporarily for property set up and then restore it.
      	 */
      	 saveobj = s_CurrObj.
      	 s_CurrObj = p_Obj.
      	 run VALUE("adedict/" + p_Func).  /* call properties routine */
      	 s_CurrObj = saveobj.
      end.
      else do:
      	 {adedict/delwin.i &Win = p_Win &Obj = p_Obj}
      end.
   end.
end.
   

/*============================Mainline Code===============================*/

Define var save_id as recid NO-UNDO.
Define var err     as logical NO-UNDO.

s_Browse_Stat:screen-value in frame browse = "". /* clear status line */

case p_Obj:
   when {&OBJ_DB} then
   do:
      /* If user clicked again on database that's already the current
      	 one, don't do anything.
      */
     if s_lst_Dbs:screen-value in frame browse = s_CurrDb
      then return.
   
      /* Cause whichever wait-for we're in to break so we can switch 
      	 databases (see _dictg.p and _dcttran.p).
	 s_CurrDb isn't reset till switchdb since the the user may decide to
	 continue using the current database after all (may decide not to 
      	 commit).

         If user switched Dbs by using cursor in Db list, we want to
      	 return focus to the list instead of defaulting to the fill-in.
      	 So remember if list has the focus.
      	 focus should never be ? here (I don't think) but the
      	 GUI focus model is a bit wierd so sometimes it is.  
      */
      s_ActionProc = "adedict/DB/_switch.p".
      if focus <> ? then
      	 s_Dblst_Focus = (if s_lst_Dbs:handle in frame browse = 
      	       	     	  focus:handle then yes else no).

      /* When the wait-for breaks and if we are in the database fill-in,
      	 we will get a leave trigger for it.  If the user just got here
      	 because he typed the first letter of a db name, the leave
      	 trigger will cause the full name to be displayed in the fill-in.
      	 We don't want this.  So define another leave trigger that will
      	 supercede the real one.  This will then go out of scope and won't
      	 interfere with the real one when a normal leave event happens -
      	 e.g., due to TAB.
      */
      on leave of s_DbFill in frame browse do:
      end.

      if s_DictDirty then
      do:
	 s_Trans = {&TRANS_ASK_AND_DO}.
	 apply "U2" to frame browse.
      end.
      else 
	 if s_DictState = {&STATE_NO_DB_SELECTED} then
	    apply "U1" to frame browse.
	 else
	    apply "U2" to frame browse.
   end.

   when {&OBJ_TBL} then	
   do:
      run Init_Object_Selection 
      	 (INPUT s_lst_Tbls:HANDLE in frame browse,
	  INPUT s_win_Tbl,
	  INPUT-OUTPUT s_CurrTbl).
      if RETURN-VALUE = "done" then return.
   
      save_id = s_TblRecId.
      if s_CurrTbl = "" then 
      do:
	 s_TblRecId = 0.
      	 if s_win_Tbl <> ? then
      	 do:
      	    {adedict/delwin.i &Win = s_win_Tbl &Obj = {&OBJ_TBL}}
      	 end.
      	 if s_win_Fld <> ? then
      	 do:
      	    {adedict/delwin.i &Win = s_win_Fld &Obj = {&OBJ_FLD}}
      	 end.
      	 if s_win_Idx <> ? then
      	 do:
      	    {adedict/delwin.i &Win = s_win_Idx &Obj = {&OBJ_IDX}}
      	 end.
      	 IF s_win_Width <> ? THEN
      	 DO:
      	    {adedict/delwin.i &Win = s_win_Width &Obj = {&OBJ_TBL}}
      	 END.
      end.
      else do:
	 run adedict/_setid.p (INPUT {&OBJ_TBL}, OUTPUT s_TblRecId).
   
	 /* Since resetting table selection can in turn reset field or index
	    selection, we have to check for changes in the field and index
	    properties windows as well as in the table window (done in 
	    Refresh_Props) before allowing the action to continue.
	 */
	 if s_win_Fld <> ? then
	    run adedict/_changed.p (INPUT {&OBJ_FLD}, INPUT yes, OUTPUT err).
      	 if NOT err AND s_win_Idx <> ? then
  	    run adedict/_changed.p (INPUT {&OBJ_IDX}, INPUT yes, OUTPUT err).
        
	 if NOT err then
	    run Refresh_Props (INPUT {&OBJ_TBL}, s_CurrTbl, "TBL/_tblprop.p", 
			       INPUT-OUTPUT s_win_Tbl,
			       OUTPUT err).
       
       /* If the Adjust SQL Width window is already up, refresh properties */
       IF NOT err AND s_win_Tbl = ? THEN
       run Refresh_Props (INPUT {&OBJ_TBL}, s_CurrTbl, "FLD/_sqlwptr.p",
                         INPUT-OUTPUT s_win_Width, OUTPUT err). 

	 if err then 
	 do:
	    /* Reset everything as if the user never changed the selection. */
	    s_CurrTbl = save_name.
	    s_TblRecId = save_id.
	    s_TblFill:screen-value in frame browse = s_CurrTbl.
	    s_lst_Tbls:screen-value = s_CurrTbl.
	    return.
	 end.
      end.
   
      /* Regardless of which child list is displayed (if any), make sure the
	 next time they are displayed, they are refreshed based on the new
	 table selection. */
      {adedict/uncache.i 
	 &List   = "s_lst_Flds"
	 &Cached = "s_Flds_Cached"
	 &Curr   = "s_CurrFld"}
      {adedict/uncache.i 
	 &List   = "s_lst_Idxs"
	 &Cached = "s_Idxs_Cached"
	 &Curr   = "s_CurrIdx"}
   
      /* Cause whichever list is showing to be redisplayed now. If there's no
	 table (e.g., the last table was just deleted) these lists will become 
	 invisible so don't bother. 
      */
      if s_CurrTbl <> "" then
      do:
	 if s_Lvl2Obj = {&OBJ_FLD} then
      	 do:
      	    /* This will eventually cause refresh of prop window if it's up */
	    run adedict/_brwlist.p (INPUT {&OBJ_FLD}).

      	    /* What I want is to refresh index window with first index for 
      	       this table.  This is a first attempt - but objsel doesn't
      	       work because it assumes browse list is up-to-date for
      	       current table and it isn't so just close the window.
      	    */
      	    if s_win_Idx <> ? then
      	    do:      	       
      	       {adedict/delwin.i &Win = s_win_Idx &Obj = {&OBJ_IDX}}
      	    end.
      	 end.
	 else if s_Lvl2Obj = {&OBJ_IDX} then
      	 do:
      	    /* This will eventually cause refresh of prop window if it's up */
	    run adedict/_brwlist.p (INPUT {&OBJ_IDX}).

      	    /* What I want is to refresh field window with first field for 
      	       this table.  This is a first attempt - but objsel doesn't
      	       work because it assumes browse list is up-to-date for
      	       current table and it isn't so just close the window.
      	    */
      	    if s_win_Fld <> ? then
      	    do:      	       
      	       {adedict/delwin.i &Win = s_win_Fld &Obj = {&OBJ_FLD}}
      	    end.
      	 end.
      end.
   end.

   when {&OBJ_SEQ} then
   do:	 
      run Init_Object_Selection 
      	 (INPUT s_lst_Seqs:HANDLE in frame browse,
	  INPUT s_win_Seq,
	  INPUT-OUTPUT s_CurrSeq).
      if RETURN-VALUE = "done" then return.
   
      /* If the edit window is already up, refresh properties */
      run Refresh_Props (INPUT {&OBJ_SEQ}, s_CurrSeq, "SEQ/_seqprop.p",
			 INPUT-OUTPUT s_win_Seq,
			 OUTPUT err).
   
      if err then
      do:
	 /* Reset everything as if the user never changed the selection. */
	 s_CurrSeq = save_name.
	 s_SeqFill:screen-value in frame browse = s_CurrSeq.
	 s_lst_Seqs:screen-value = s_CurrSeq.
	 return.
      end.
   end.

   when {&OBJ_FLD} then
   do:	 
      run Init_Object_Selection 
      	 (INPUT s_lst_Flds:HANDLE in frame browse,
      	  INPUT s_win_Fld,
	  INPUT-OUTPUT s_CurrFld).
      if RETURN-VALUE = "done" then return.

      /* LOBs do not need to have the fld properties screen refreshed so just
         return as being done */
      IF user_env[35] = "lob" THEN DO:
        ASSIGN user_env[35] = "".
        RETURN "done".
      END.

      /* If the edit window is already up, refresh properties */
      run Refresh_Props (INPUT {&OBJ_FLD}, s_CurrFld, "FLD/_fldprop.p",
			 INPUT-OUTPUT s_win_Fld,
			 OUTPUT err).
   
      if err then
      do:
	 /* Reset everything as if the user never changed the selection. */
	 s_CurrFld = save_name.
	 s_FldFill:screen-value in frame browse = s_CurrFld.
	 s_lst_Flds:screen-value = s_CurrFld.
	 return.
      end.
   end.

   when {&OBJ_IDX} then
   do:	 
      run Init_Object_Selection 
      	 (INPUT s_lst_Idxs:HANDLE in frame browse,
	  INPUT s_win_Idx,
	  INPUT-OUTPUT s_CurrIdx).
      if RETURN-VALUE = "done" then return.
   
      /* If the edit window is already up, refresh properties */
      run Refresh_Props (INPUT {&OBJ_IDX}, s_CurrIdx, "IDX/_idxprop.p",
			 INPUT-OUTPUT s_win_Idx,
			 OUTPUT err).
   
      if err then
      do:
	 /* Reset everything as if the user never changed the selection. */
	 s_CurrIdx = save_name.
	 s_IdxFill:screen-value in frame browse = s_CurrIdx.
	 s_lst_Idxs:screen-value = s_CurrIdx.
	 return.
      end.
   end.
end.





