/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: brwtrig.i

Description:
   Here we have all the trigger definitions for the browse window of the
   dictionary.
 
Author: Laura Stern

Date Created: 02/04/92 
    Modified: 05/19/99 Mario B.  Adjust Width Field browser integration.
----------------------------------------------------------------------------*/


/*========================Internal Procedures===========================*/

/*------------------------------------------------------------------------
   Respond to request for create of an object.  By the time we get here
   s_CurrObj is already set to this object type since we caused the
   browse button for this type to be pushed, if it wasn't already.

   Input Parameters:
      p_Obj  - The object type the user wants to create (e.g., {&OBJ_SEQ})
      p_Win  - Handle to the property window for this object type.
      p_Func - The function to call to bring up create dialog box.
------------------------------------------------------------------------*/
PROCEDURE Do_Create:

Define INPUT PARAMETER p_Obj  as integer       NO-UNDO.
Define INPUT PARAMETER p_Win  as widget-handle NO-UNDO.
Define INPUT PARAMETER p_Func as char  	       NO-UNDO.

Define var err as logical NO-UNDO.

   /* Make sure we're not clobbering changes before adding new obj. If the 
      user saves changes and an error occurs, don't continue. */
   if p_Win <> ? then
   do:
      run adedict/_changed.p (INPUT p_Obj, INPUT yes, OUTPUT err).
      if err then return.
   end.

   s_Adding = true.

   current-window = s_win_Browse.
   run VALUE("adedict/" + p_Func).
   s_Adding = false.
end.


/*-----------------------------------------------------------------------
   This is called to perform the "default-action", e.g., the double
   click or RETURN action from a selection list in the browse window.

   Note: When the user double clicks we get a single click (selection) 
   event first.  So single click processing has already occurred by the
   time we get here.

   Input Parameters:
      p_Obj  - The object type we're dealing with (e.g., {&OBJ_FLD})

-----------------------------------------------------------------------*/
PROCEDURE Do_Dbl_Click:

Define INPUT PARAMETER p_Obj as integer NO-UNDO.

Define var winhdl as widget-handle NO-UNDO.
Define var icnhdl as widget-handle NO-UNDO.
Define var func   as char          NO-UNDO.

   case p_Obj:
      when {&OBJ_DB} then
      	 assign
      	    winhdl = s_win_Db
      	    icnhdl = s_icn_Dbs:HANDLE in frame browse
      	    func   = "adedict/DB/_dbprop.p".
      when {&OBJ_TBL} then
      DO:
         assign
      	    winhdl = s_win_Tbl 
      	    icnhdl = s_icn_Tbls:HANDLE in frame browse
      	    func   = "adedict/TBL/_tblprop.p".
      END.      	    
      when {&OBJ_SEQ} then 
         assign
      	    winhdl = s_win_Seq 
      	    icnhdl = s_icn_Seqs:HANDLE in frame browse
      	    func   = "adedict/SEQ/_seqprop.p".
      when {&OBJ_FLD} then
      DO:
         IF s_win_Width <> ? THEN LEAVE.
         assign
      	    winhdl = s_win_Fld
      	    icnhdl = s_icn_Flds:HANDLE in frame browse
      	    func   = "adedict/FLD/_fldprop.p".
      END.      	    
      when {&OBJ_IDX} then
         assign
      	    winhdl = s_win_Idx
      	    icnhdl = s_icn_Idxs:HANDLE in frame browse
      	    func   = "adedict/IDX/_idxprop.p".
   end.
   if winhdl = ? then /* window isn't open yet */
   do:
      run Push_Obj_Button (p_Obj, icnhdl, true).
      if p_Obj = {&OBJ_DB} then
      	 /* This is done here and not in _dbprop.p because dbprops
      	    is called from elsewhere, when we don't want to call
      	    _openwin.p.  This is not true of the other OBJ types.
      	 */
	 run adedict/_openwin.p
	    (INPUT "Database Properties",
	     INPUT frame dbprops:HANDLE,
      	     INPUT {&OBJ_DB},
	     INPUT-OUTPUT s_win_Db).
      run VALUE(func).
   end.
   else do: 
      winhdl:window-state = WINDOW-NORMAL.  /* un-minimized */
      s_Res = winhdl:move-to-top().
      apply "entry" to winhdl. /* give the window focus */
   end.
end.


/*------------------------------------------------------------------------
   Respond to the user clicking on the "Create" button in the browse
   window.
------------------------------------------------------------------------*/
PROCEDURE Choose_Create:
   Define var err as logical NO-UNDO.

   s_Browse_Stat:screen-value in frame browse = "". /* clear status line */

   case s_CurrObj:
      when {&OBJ_DB} then
      	 run adedict/DB/_newdb.p.

      when {&OBJ_TBL} then
      do:
	 /* Since adding a table will reset table selection which in turn
	    can reset field or index selection, we have to check for changes
	    in the field and index properties windows as well as in the table
	    window (done in Do-Create) before allowing the action to continue.
	 */
	 if s_Lvl2Obj = {&OBJ_FLD} AND s_win_Fld <> ? then
	    run adedict/_changed.p (INPUT {&OBJ_FLD}, INPUT yes, OUTPUT err).
	 else if s_Lvl2Obj = {&OBJ_IDX} AND s_win_Idx <> ? then
	    run adedict/_changed.p (INPUT {&OBJ_IDX}, INPUT yes, OUTPUT err).
      
	 if NOT err then 
      	 do:
	    run Do_Create (INPUT {&OBJ_TBL}, 
      	       	     	   INPUT s_win_Tbl, 
      	       	     	   INPUT "TBL/_newtbl.p").
      	 end.
      end.
      when {&OBJ_SEQ} then 
         run Do_Create (INPUT {&OBJ_SEQ}, 
      	       	     	INPUT s_win_Seq, 
      	       	     	INPUT "SEQ/_newseq.p").

      when {&OBJ_FLD} then 
      	 run Do_Create (INPUT {&OBJ_FLD}, 
      	       	     	INPUT s_win_Fld, 
      	       	     	INPUT "FLD/_newfld.p").

      when {&OBJ_IDX} then
      	 run Do_Create (INPUT {&OBJ_IDX}, 
      	       	     	INPUT s_win_Idx, 
      	       	     	INPUT "IDX/_newidx.p").
   end.
end.


/*------------------------------------------------------------------------
   Respond to the user clicking on the "Properties" button in the browse
   window.

   Do what would happen if the user double clicked - Call routine
   that get's called on single click and then routine that gets
   called on double click (which already knows that single click
   came first). 
------------------------------------------------------------------------*/
PROCEDURE Choose_Properties:

   case s_CurrObj:
      when {&OBJ_DB} then
      do:
      	 run adedict/_objsel.p (INPUT {&OBJ_DB}).
      	 run Do_Dbl_Click (INPUT ({&OBJ_DB})).
      end.
      when {&OBJ_TBL} then
      do:
      	 run adedict/_objsel.p (INPUT {&OBJ_TBL}).
      	 run Do_Dbl_Click (INPUT ({&OBJ_TBL})).
      end.      
      when {&OBJ_SEQ} then
      do:
      	 run adedict/_objsel.p (INPUT {&OBJ_SEQ}).
      	 run Do_Dbl_Click (INPUT ({&OBJ_SEQ})).
      end.
      when {&OBJ_FLD} then
      do:
      	 run adedict/_objsel.p (INPUT {&OBJ_FLD}).
      	 run Do_Dbl_Click (INPUT ({&OBJ_FLD})).
      end.
      when {&OBJ_IDX} then
      do:
      	 run adedict/_objsel.p (INPUT {&OBJ_IDX}).
      	 run Do_Dbl_Click (INPUT ({&OBJ_IDX})).
      end.
   end.
end.


/*-----------------------------------------------------------------------
   The user just clicked on a "Show Object" button.  This won't get
   called if the button is already down.  Otherwise, push it in and 
   unpush whatever other button is currently pushed in.  Reset s_CurrObj 
   and adjust the labels on the Create/Props/Delete buttons to pertain 
   to this object type.

   Input Parameters:
      p_Obj    - The object type we're dealing with (e.g., {&OBJ_FLD})
      p_Btn    - The "down" button for this object type.
      p_Nolist - The select list is already visible and up to date - 
      	       	 don't refresh it.

-----------------------------------------------------------------------*/
PROCEDURE Push_Obj_Button:

Define INPUT   PARAMETER p_Obj    as integer 	   NO-UNDO.
Define INPUT   PARAMETER p_Btn    as widget-handle NO-UNDO.
Define INPUT   PARAMETER p_Nolist as logical       NO-UNDO.

   s_Browse_Stat:screen-value in frame browse = "". /* clear status line */

   if p_Obj = s_CurrObj then
      return.

   if    p_Obj = {&OBJ_SEQ}
     and index(capab,"s") = 0
     then do:
       message
         "This DataServer does not support sequences."
         view-as alert-box.
       RETURN "no seqence supported".
       end. 

   run adedict/_brwbtn.p (INPUT p_Obj, INPUT p_Btn, INPUT true).   

   if   p_Obj = {&OBJ_DB} 
     OR p_Obj = {&OBJ_TBL}
     then run adedict/_capab.p (INPUT {&CAPAB_SEQ}, OUTPUT capab).
       
   /* Display the list (which calls _brwadj.p which calls brwgray) */
   if p_Obj <> {&OBJ_DB} AND NOT p_Nolist
     then run adedict/_brwlist.p (INPUT p_Obj).
     else run adedict/_brwgray.p (INPUT false).

end.


/*=======================================================================
      	       	     	   ENDKEY in Browse Window
=======================================================================*/

/*----- END-ERROR of BROWSE WINDOW-----*/
on END-ERROR of frame browse 
   return NO-APPLY.


/*=======================================================================
     	       	     	HELP for the browse window
=======================================================================*/

/*----- HELP anywhere -----*/
on HELP anywhere
   RUN "adecomm/_adehelp.p" ("dict", "TOPICS", {&Data_Dictionary_Window}, ?).


/*=======================================================================
      	       	     	"Object Mode" Toggle Buttons
=======================================================================*/

/*----- SELECTION of DATABASES BUTTON -----*/
On mouse-select-down of s_icn_Dbs in frame browse
   run Push_Obj_Button (INPUT {&OBJ_DB}, 
      	       	     	INPUT s_icn_Dbs:HANDLE in frame browse,
      	       	     	INPUT false).


/*----- SELECTION of TABLES BUTTON -----*/
On mouse-select-down of s_icn_Tbls in frame browse
   run Push_Obj_Button (INPUT {&OBJ_TBL}, 
      	       	     	INPUT s_icn_Tbls:HANDLE in frame browse,
      	       	     	INPUT false).

/*----- SELECTION of SEQUENCES BUTTON -----*/
On mouse-select-down of s_icn_Seqs in frame browse
   run Push_Obj_Button (INPUT {&OBJ_SEQ}, 
      	       	     	INPUT s_icn_Seqs:HANDLE in frame browse,
      	       	     	INPUT false).


/*----- SELECTION of FIELDS BUTTON -----*/
On mouse-select-down of s_icn_Flds in frame browse
   run Push_Obj_Button (INPUT {&OBJ_FLD}, 
      	       	     	INPUT s_icn_Flds:HANDLE in frame browse,
      	       	     	INPUT false).


/*----- SELECTION of INDEX BUTTON -----*/
On mouse-select-down of s_icn_Idxs in frame browse
   run Push_Obj_Button (INPUT {&OBJ_IDX}, 
      	       	     	INPUT s_icn_Idxs:HANDLE in frame browse,
      	       	     	INPUT false).



/*========================================================================
  	     	    Select List Selection-Change Events

   These VALUE-CHANGED events occurs if the user clicks on an item in a list,
   or when the code sets selection (e.g., after populating the box, after
   adding a new item or after deleting an item).

   For all below - Look for U1.  U1 is applied by combo box code.  We have to 
   get U1 of Fill to signal a value change in select list since value-changed 
   trigger on list widget can't apply U1 to list widget (itself) - the trigger 
   won't fire.  The opposite is also true - when selection changes due to 
   typing into fill-in we have to apply event to select list.  So U1 of either 
   fill or list means value changed and we have to look for both.
========================================================================*/


/*----- SELECTION of a DATABASE -----*/
on U1 of s_DbFill in frame browse, s_lst_Dbs in frame browse
   run adedict/_objsel.p (INPUT {&OBJ_DB}).


/*----- SELECTION of a TABLE -----*/
on U1 of s_TblFill in frame browse, s_lst_Tbls in frame browse
   run adedict/_objsel.p (INPUT {&OBJ_TBL}).


/*----- SELECTION of a SEQUENCE -----*/
on U1 of s_lst_Seqs in frame browse, s_SeqFill in frame browse
   run adedict/_objsel.p (INPUT {&OBJ_SEQ}).


/*----- SELECTION of a FIELD -----*/
on U1 of s_lst_Flds in frame browse, s_FldFill in frame browse
   run adedict/_objsel.p (INPUT {&OBJ_FLD}).


/*----- SELECTION of an INDEX -----*/
on U1 of s_lst_Idxs in frame browse, s_IdxFill in frame browse
   run adedict/_objsel.p (INPUT {&OBJ_IDX}).


/*=======================================================================
      	       	     	Double-Click in a Select List

   Note: When the user double clicks we get a single click (selection) 
   event first.  So single click processing has already occurred by the
   time we get here.
=======================================================================*/

/*----- DBL-CLK of a DATABASE -----*/
on default-action of s_lst_Dbs in frame browse
   run Do_Dbl_Click (INPUT ({&OBJ_DB})).


/*----- DBL-CLK of a TABLE -----*/
on default-action of s_lst_Tbls in frame browse
   run Do_Dbl_Click (INPUT ({&OBJ_TBL})).


/*----- DBL-CLK of a SEQUENCE -----*/
on default-action of s_lst_Seqs in frame browse
   run Do_Dbl_Click (INPUT ({&OBJ_SEQ})).


/*----- DBL-CLK of a FIELD -----*/
on default-action of s_lst_Flds in frame browse
   run Do_Dbl_Click (INPUT ({&OBJ_FLD})).


/*----- DBL-CLK of an INDEX -----*/
on default-action of s_lst_Idxs in frame browse
   run Do_Dbl_Click (INPUT ({&OBJ_IDX})).


/*=======================================================================
     	    Selection of an Action Button (Create/Properties/Delete)
=======================================================================*/

/*----- SELECTION of CREATE BUTTON -----*/
on choose of s_btn_Create in frame browse
   run Choose_Create.


/*----- SELECTION of PROPERTIES BUTTON -----*/
on choose of s_btn_Props in frame browse
   run Choose_Properties.


/*----- SELECTION of DELETE BUTTON ----- */
On choose of s_btn_Delete in frame browse
   run adedict/_delete.p (INPUT s_CurrObj).

