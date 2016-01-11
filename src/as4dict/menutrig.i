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

File: menutrig.i

Description:
   Here we have all the trigger definitions for the selection of menu items.
 
Author: Laura Stern

Date Created: 02/17/92  
    Modified: 01/1995  D. McMann to work with PROGRESS/400 Data Dictionary
              03/25/96 D. McMann changed QUESTION to WARNING in messages
              06/17/96 D. McMann changed how sync is run from dictionary
              09/30/96 D. McMann changed how files are checked for fields
              10/25/96 D. McMann Added logic for Freeze/Unfreeze 
              06/05/97 D. McMann Added Incremental Dump
              05/08/00 D. McMann Changed check for dumping df's
              05/31/00 D. McMann Added U2 to frame when loading data
              08/22/00 D. McMann Removed U2 client now is handling cache OK
              01/31/01 D. McMann Added load of AS/400 Incremental
              
----------------------------------------------------------------------------*/
DEFINE SHARED VARIABLE USER_PATH AS CHARACTER NO-UNDO.

/*===========================Internal Procedures=========================*/

/*----------------------------------------------------------------
   See if the user made any changes in a property window 
   that he hasn't saved.  This (_changed.p) will ask if he wants 
   to save and do the save if he says yes. 

   Returns: "error" if an error occurs when the user tries to 
	    save, otherwise, "".
---------------------------------------------------------------*/
Procedure Check_For_Changes:

   Define var err as logical NO-UNDO.

   err = no.
   if s_win_Tbl <> ? then
      run as4dict/_changed.p (INPUT {&OBJ_TBL}, yes, OUTPUT err).
   if NOT err AND s_win_Seq <> ? then
      run as4dict/_changed.p (INPUT {&OBJ_SEQ}, yes, OUTPUT err).   
   if NOT err AND s_win_Fld <> ? then
      run as4dict/_changed.p (INPUT {&OBJ_FLD}, yes, OUTPUT err).
   if NOT err AND s_win_Idx <> ? then
      run as4dict/_changed.p (INPUT {&OBJ_IDX}, yes, OUTPUT err).

   if err then 
      return "error".
   else
      return "".
End.


/*------------------------------------------------------------------------ 
   Do Exit processing.

------------------------------------------------------------------------*/
PROCEDURE Do_Exit:
   s_Trans = {&TRANS_ASK_AND_EXIT}.
   if s_DictState = {&STATE_NO_DB_SELECTED} then
   do:
      /* There's nothing to ask, since there can be no transaction
	 so we're done */
      s_DictState = {&STATE_DONE}.
      apply "U1" to frame browse.
   end.
   else do:
      /* Check to see if user has made any changes in open property windows
	 that he hasn't saved.  If there are, and he saves now, and an error
	 occurs, don't continue with exit.
      */             
  
      run Check_For_Changes.
      if RETURN-VALUE = "error" then return.
       if s_DictDirty then
        do:
       def var answer as logical.
      
       assign answer =  yes.
       message "You have made changes in the current"    SKIP
               "database that are not committed.  Answering"    SKIP  
               "YES will commit your changes, NO will undo them."   SKIP (1)
      	       "Do you want to commit your changes?" 
      	     view-as ALERT-BOX WARNING  buttons YES-NO-CANCEL
      	     update answer in window s_win_Browse.                                  
      	         
      IF answer = ? then return.
      else if answer = yes then DO:          
        /* make sure each file as one field else apply will fail.  iF altseq is used then each file must have
            at least one index.*/
         run as4dict/_chkfld.p.   
         IF user_env[34] = "N" then return.  
       end.     
      else assign user_env[34] = "N".	    
                                        
      end.
      /* Here, we have to ask commit or undo (if dict is dirty) and in
	 any event, get out of the transaction loop. */
      apply "U2" to frame browse.
   end.
end.


/*=========================DATABASE menu=================================*/


/*----- EXIT ----- */
On choose of MENU-ITEM mi_Exit in MENU s_mnu_Database
   run Do_Exit.

/*----------------------------- REPORTS sub-menu---------------------------*/

Define var which_tbl as char init "t" NO-UNDO
   view-as RADIO-SET
   radio-buttons "Selected Table", "t", "ALL Tables", "a".

Form 
   SKIP(.5)
   "Report on:" at 4 view-as TEXT SKIP
   which_tbl    at 4              SKIP(1)
   s_btn_Ok     at 2 SPACE(2)
   s_btn_Cancel      SPACE(1)
   SKIP(.5)
   with frame tbl_select no-labels
	      view-as DIALOG-BOX TITLE "Report Table Options".


/*----- DETAILED TABLE REPORT -----*/
On choose of MENU-ITEM mi_DetailedTbl in MENU s_mnu_Reports
do:
   current-window = s_win_Browse.
   if s_CurrTbl = "" then
   do:
      message "There are no tables in this database to look at."
	  view-as ALERT-BOX ERROR buttons OK.
      return.
   end.

   run as4dict/_dtblrpt.p
      (INPUT s_DbRecId,
       INPUT (if s_DbCache_Pname[s_DbCache_ix] = ? 
	       then s_CurrDb else s_DbCache_Pname[s_DbCache_ix]),
       INPUT s_DbCache_Type[s_DbCache_ix],
       INPUT (if s_Order_By = {&ORDER_ORDER#} then "o" else "a"),
       INPUT (if which_tbl = "a" then "ALL" else s_CurrTbl),
       INPUT yes).
end.


/*----- QUICK TABLE REPORT -----*/
On choose of MENU-ITEM mi_QuickTbl in MENU s_mnu_Reports
do:
   current-window = s_win_Browse.
   run as4dict/_qtblrpt.p
      (INPUT s_DbRecId,    
       INPUT (if s_DbCache_Pname[s_DbCache_ix] = ? 
	       then s_CurrDb else s_DbCache_Pname[s_DbCache_ix]),
       INPUT s_DbCache_Type[s_DbCache_ix]).
end.


/*----- QUICK FIELD REPORT -----*/
On choose of MENU-ITEM mi_f_CurrTbl in MENU s_mnu_QuickFld
do:
   current-window = s_win_Browse.
   run as4dict/_qfldrpt.p
      (INPUT s_DbRecId,
       INPUT (if s_DbCache_Pname[s_DbCache_ix] = ? 
	       then s_CurrDb else s_DbCache_Pname[s_DbCache_ix]),
       INPUT s_DbCache_Type[s_DbCache_ix],
       INPUT s_CurrTbl,
       INPUT (if s_Order_By = {&ORDER_ORDER#} then "o" else "a")).
end.

On choose of MENU-ITEM mi_f_AllTbls in MENU s_mnu_QuickFld
do:
   current-window = s_win_Browse.
   if s_CurrTbl = "" then
   do:
      message "There are no fields in this database to look at."
	  view-as ALERT-BOX ERROR buttons OK.
      return.
   end.

   run as4dict/_qfldrpt.p
      (INPUT s_DbRecId,
       INPUT (if s_DbCache_Pname[s_DbCache_ix] = ? 
	       then s_CurrDb else s_DbCache_Pname[s_DbCache_ix]),
       INPUT s_DbCache_Type[s_DbCache_ix],
       INPUT "ALL",
       INPUT (if s_Order_By = {&ORDER_ORDER#} then "o" else "a")).
end.

/*----- QUICK INDEX REPORT -----*/
On choose of MENU-ITEM mi_i_CurrTbl in MENU s_mnu_QuickIdx
do:
   current-window = s_win_Browse.
   run as4dict/_qidxrpt.p
      (INPUT s_DbRecId,
       INPUT (if s_DbCache_Pname[s_DbCache_ix] = ? 
	       then s_CurrDb else s_DbCache_Pname[s_DbCache_ix]),
       INPUT s_DbCache_Type[s_DbCache_ix],
       INPUT s_CurrTbl,
       INPUT "").
end.

On choose of MENU-ITEM mi_i_AllTbls in MENU s_mnu_QuickIdx
do:
   current-window = s_win_Browse.
   if s_CurrTbl = "" then
   do:
      message "There are no indexes in this database to look at."
	  view-as ALERT-BOX ERROR buttons OK.
      return.
   end.

   run as4dict/_qidxrpt.p
      (INPUT s_DbRecId,
       INPUT (if s_DbCache_Pname[s_DbCache_ix] = ? 
	       then s_CurrDb else s_DbCache_Pname[s_DbCache_ix]),
       INPUT s_DbCache_Type[s_DbCache_ix],
       INPUT "ALL",
       INPUT "").
end.

/*----- DETAILED PROCEDURE REPORT -----*/
On choose of MENU-ITEM mi_DetailedPrc in MENU s_mnu_Reports
do:
   current-window = s_win_Browse.
  
   run as4dict/_dprcrpt.p
      (INPUT s_DbRecId,
       INPUT (if s_DbCache_Pname[s_DbCache_ix] = ? 
	       then s_CurrDb else s_DbCache_Pname[s_DbCache_ix]),
       INPUT s_DbCache_Type[s_DbCache_ix],
       INPUT "a",
       INPUT (if which_tbl = "a" then "ALL" else s_CurrProc),
       INPUT yes).
end.

/*----- QUICK SEQUENCE REPORT -----*/
On choose of MENU-ITEM mi_QuickSeq in MENU s_mnu_Reports
do:
   current-window = s_win_Browse.
   run as4dict/_qseqrpt.p
      (INPUT s_DbRecId,    
       INPUT (if s_DbCache_Pname[s_DbCache_ix] = ? 
	       then s_CurrDb else s_DbCache_Pname[s_DbCache_ix]),
       INPUT s_DbCache_Type[s_DbCache_ix]).
end.


/*----- TRIGGER REPORT -----*/
On choose of MENU-ITEM mi_Trigger in MENU s_mnu_Reports
do:
   current-window = s_win_Browse.
   run as4dict/_trigrpt.p
      (INPUT s_DbRecId,    
       INPUT (if s_DbCache_Pname[s_DbCache_ix] = ? 
	       then s_CurrDb else s_DbCache_Pname[s_DbCache_ix]),
       INPUT s_DbCache_Type[s_DbCache_ix]).
end.


/*----- QUICK USER REPORT -----*/
On choose of MENU-ITEM mi_QuickUsr in MENU s_mnu_Reports
do:
   current-window = s_win_Browse.
   run as4dict/_qusrrpt.p
      (INPUT s_DbRecId,    
       INPUT (if s_DbCache_Pname[s_DbCache_ix] = ? 
	       then s_CurrDb else s_DbCache_Pname[s_DbCache_ix]),
       INPUT s_DbCache_Type[s_DbCache_ix]).
end.


/*----- FILE RELATIONS REPORT -----*/
On choose of MENU-ITEM mi_r_CurrTbl in MENU s_mnu_TblRel
do:
   current-window = s_win_Browse.
   if s_CurrTbl = "" then
   do:
      message "There are no tables in this database to look at."
	  view-as ALERT-BOX ERROR buttons OK.
      return.
   end.

   run as4dict/_trelrpt.p
      (INPUT s_DbRecId,
       INPUT (if s_DbCache_Pname[s_DbCache_ix] = ? 
	       then s_CurrDb else s_DbCache_Pname[s_DbCache_ix]),
       INPUT s_DbCache_Type[s_DbCache_ix],
       INPUT s_CurrTbl,
       INPUT "").
end.

On choose of MENU-ITEM mi_r_AllTbls in MENU s_mnu_TblRel
do:
   current-window = s_win_Browse.
   if s_CurrTbl = "" then
   do:
      message "There are no tables in this database to look at."
	  view-as ALERT-BOX ERROR buttons OK.
      return.
   end.

   run as4dict/_trelrpt.p
      (INPUT s_DbRecId,
       INPUT (if s_DbCache_Pname[s_DbCache_ix] = ? 
	       then s_CurrDb else s_DbCache_Pname[s_DbCache_ix]),
       INPUT s_DbCache_Type[s_DbCache_ix],
       INPUT "ALL",
       INPUT "").                          
 end.      
/*===========================Admin Menu=================================*/
/*-----DUMP DF---*/
On choose of Menu-item mi_dump_Defs in MENU mnu_Dump
do:
 current-window = s_win_Browse.
 IF s_CurrTbl = "" AND s_CurrProc = "" THEN do:
    message " There are no tables or procedures in this database to dump."
            view-as ALERT-BOX ERROR buttons OK.
    return.
  end.
  
  run as4dict/dump/_a4dmpdf.p.
end.                

/*------DUMP .D-----*/
On choose of Menu-item mi_Dump_Contents in MENU mnu_Dump
do:
    current-window = s_win_Browse.
    if s_CurrTbl = "" then
    do:
        message " There are no tables in this database to dump."
            view-as ALERT-BOX ERROR button OK.
         return.
      end.            
      
      run as4dict/dump/_a4dmpd.p.
end.                

/*--------------DUMP SEQUENCE DEF --------------------------- */
On choose of Menu-item mi_Dump_SeqDefs
 do:
    current-window = s_win_Browse.
    run as4dict/dump/_a4dmpsq.p.
 end.

/*--------------DUMP SEQUENCE CURRENT VALUES ---------------------- */

On choose of Menu-item mi_Dump_SeqVals
 do:
    current-window = s_win_Browse.
    run as4dict/dump/_a4dmpsv.p.
end.

/*--------------DUMP INCREMENTAL DF --------------------------- */
On choose of Menu-item mi_Dump_Inc
 do:
    current-window = s_win_Browse.
    ASSIGN user_env[33] = "pro".
    run as4dict/dump/_a4dmpin.p.
 end.

 /*--------------DUMP INCREMENTAL DF --------------------------- */
 On choose of Menu-item mi_Ench_Inc
  do:
     current-window = s_win_Browse.
     ASSIGN user_env[33] = "as4".
     run as4dict/dump/_a4dmpin.p.
  end.

/*-----LOAD DF---*/
On choose of Menu-item mi_Load_Defs in MENU mnu_Load OR
   CHOOSE OF MENU-ITEM mi_load_inc IN MENU mnu_load
do:
  current-window = s_win_Browse.
  IF SELF:NAME = "mi_load_inc" THEN
    ASSIGN user_env[33] = "as4inc".

  run as4dict/load/_a4loddf.p.      
 /* Return to table mode and refresh the list of tables */
     {as4dict/uncache.i 
      &List   = "s_lst_Tbls"
      &Cached = "s_Tbls_Cached"
      &Curr   = "s_CurrTbl"}

     run as4dict/_brwbtn.p (INPUT {&OBJ_TBL}, 
	   		 INPUT s_icn_Tbls:HANDLE in frame browse, 
			 INPUT false).     
  run as4dict/_brwlist.p (INPUT s_CurrObj).

  /* If we added sequences - that should be refreshed too. */
    {as4dict/uncache.i 
      &List   = "s_lst_Seqs"
      &Cached = "s_Seqs_Cached"
      &Curr   = "s_CurrSeq"}

      run as4dict/_brwbtn.p (INPUT {&OBJ_SEQ}, 
	   		 INPUT s_icn_Seqs:HANDLE in frame browse, 
			 INPUT false).     

   /* return to table mode  */ 
  apply "mouse-select-down" to s_icn_Tbls in frame browse.       
end.  
   

/*------LOAD .D-----*/
On choose of Menu-item mi_load_Contents in MENU mnu_load
do:
    current-window = s_win_Browse.

      run as4dict/load/_a4lodd.p.
 /* Return to table mode and refresh the list of tables */
     {as4dict/uncache.i 
      &List   = "s_lst_Tbls"
      &Cached = "s_Tbls_Cached"
      &Curr   = "s_CurrTbl"}
 

     run as4dict/_brwbtn.p (INPUT {&OBJ_TBL}, 
	   		 INPUT s_icn_Tbls:HANDLE in frame browse, 
			 INPUT false).   
  
     run as4dict/_brwlist.p (INPUT {&OBJ_TBL}).
     apply "mouse-select-down" to s_icn_Tbls in frame browse.      
end.                 

/*--------------LOAD SEQUENCE CURRENT VALUES ---------------------- */
On choose of Menu-item mi_Load_SeqVals in MENU mnu_load
do:
    current-window = s_win_Browse.
    run as4dict/load/_a4lodsv.p.
end.

/*-------------- RECONSTRUCT BAD LOAD RECORDS ---------------------- */
On choose of Menu-item mi_Load_BadRecs in MENU mnu_load
do:                
    user_path = "*N".
    current-window = s_win_Browse.
    run prodict/user/_usrlrec.p.
    if user_path <> "" then run prodict/_dctlrec.p.
end.

 /*--------------Synchronize PROGRESS/400 Client -----------------------------*/
 On choose of Menu-item mi_Sync in MENU mnu_Admin
 do:   
      DEFINE VARIABLE namenow AS CHARACTER FORMAT "x(15)" NO-UNDO.   
      DEFINE VARIABLE answer  AS LOGICAL INITIAL FALSE NO-UNDO.  
      current-window = s_win_Browse.      

    IF s_DictDirty THEN DO:
        MESSAGE "You must commit your changes before"
                         "running a synchronization. " SKIP
           VIEW-AS ALERT-BOX ERROR  BUTTON OK.
    END.                 
    ELSE DO:
       s_AskSync = FALSE.           
       s_Trans = {&TRANS_SYNC}.
       apply "U2" to frame browse.               
    end.
 end.           
 
 /*-------------------Freeze/Unfreeze Files -----------------------------*/
 On choose of Menu-item mi_Frozen in MENU mnu_Admin   
 do:
    current-window = s_win_Browse.        
    run as4dict/_freeze.p.     
    
    if s_DictDirty THEN DO:
      { as4dict/setdirty.i &Dirty = "true"}
    END.  
      

end. 
  
/*=============================Edit menu=================================*/

/*----- UNDO ----- */
On choose of MENU-ITEM mi_Undo in MENU s_mnu_Edit
do:
   Define var answer as logical init yes NO-UNDO.

   current-window = s_win_Browse.
   message "Are you sure you want to undo your changes?"
	    view-as ALERT-BOX WARNING
	    buttons YES-NO
	    update answer in window s_win_Browse.

   if answer then
   do:
      /* If focus is in Db list, we want it to remain there instead
	 of defaulting to fill-in.  So remember if list has the focus.
	 focus should never be ? here (I don't think) but the
	 GUI focus model is a bit wierd so sometimes it is.  
      */
      if focus <> ? then
	 s_Dblst_Focus = (if s_lst_Dbs:handle in frame browse = 
			  focus:handle then yes else no).

      s_Trans = {&TRANS_UNDO}.
      apply "U2" to frame browse.
   end.
end.


/*----- COMMIT ----- */
On choose of MENU-ITEM mi_Commit in MENU s_mnu_Edit
do:
   Define var answer as logical NO-UNDO init yes.

   /* Check to see if user has made any changes in open property windows
      that he hasn't saved.  If there are, and he saves now, and an error
      occurs, don't continue.  
   */
   run Check_For_Changes.
   if RETURN-VALUE = "error" then return.

   current-window = s_win_Browse.
   message "Commiting your changes may potentially take a long time." SKIP
	   "Are you sure you want to commit your changes?"
	    view-as ALERT-BOX WARNING  buttons YES-NO  update answer
	   in window s_win_Browse.

   if answer then
   do:                     
        /* make sure each file as one field else apply will fail. */
     run as4dict/_chkfld.p.
     IF user_env[34] = "N" then return. 
      /* If focus is in Db list, we want it to remain there instead
	 of defaulting to fill-in.  So remember if list has the focus.
	 focus should never be ? here (I don't think) but the
	 GUI focus model is a bit wierd so sometimes it is.  
      */
      if focus <> ? then
	 s_Dblst_Focus = (if s_lst_Dbs:handle in frame browse = 
			  focus:handle then yes else no).

      s_Trans = {&TRANS_COMMIT}.
      apply "U2" to frame browse.
   end.
end.


/*----- DELETE ----- */
On choose of MENU-ITEM mi_Delete in MENU s_mnu_Edit
   run as4dict/_delete.p (INPUT s_CurrObj).


/*----- PROPERTIES ----- */
On choose of MENU-ITEM mi_Properties in MENU s_mnu_Edit
   run Choose_Properties.


/*===========================Create menu=================================*/

/*----- TABLE -----*/
On choose of MENU-ITEM mi_Crt_Table in MENU s_mnu_Create
do:
   if s_CurrObj <> {&OBJ_TBL} then
      run Push_Obj_Button (INPUT {&OBJ_TBL}, 
			   INPUT s_icn_Tbls:HANDLE in frame browse,
			   INPUT  false).
   run Choose_Create.
end.


/*----- SEQUENCE -----*/
On choose of MENU-ITEM mi_Crt_Sequence in MENU s_mnu_Create
do:
   if s_CurrObj <> {&OBJ_SEQ} then
      run Push_Obj_Button (INPUT {&OBJ_SEQ}, 
			   INPUT s_icn_Seqs:HANDLE in frame browse,
			   INPUT  false).
   run Choose_Create.
end.

/*----- Procedure -----*/
On choose of MENU-ITEM mi_Crt_Proc in MENU s_mnu_Create
do:
   if s_CurrObj <> {&OBJ_PROC} then
      run Push_Obj_Button (INPUT {&OBJ_PROC}, 
			   INPUT s_icn_Proc:HANDLE in frame browse,
			   INPUT  false).
   run Choose_Create.
end.


/*----- FIELD -----*/
On choose of MENU-ITEM mi_Crt_Field in MENU s_mnu_Create
do:
   if s_CurrObj <> {&OBJ_FLD} then
      run Push_Obj_Button (INPUT {&OBJ_FLD}, 
			   INPUT s_icn_Flds:HANDLE in frame browse,
			   INPUT  false).
   run Choose_Create.
end.


/*----- INDEX -----*/
On choose of MENU-ITEM mi_Crt_Index in MENU s_mnu_Create
do:
   if s_CurrObj <> {&OBJ_IDX} then
      run Push_Obj_Button (INPUT {&OBJ_IDX}, 
			   INPUT s_icn_Idxs:HANDLE in frame browse,
			   INPUT  false).
   run Choose_Create.
end.

/*----- Parameters -----*/
On choose of MENU-ITEM mi_Crt_Parm in MENU s_mnu_Create
do:
   if s_CurrObj <> {&OBJ_PARM} then
      run Push_Obj_Button (INPUT {&OBJ_PARM}, 
			   INPUT s_icn_Parm:HANDLE in frame browse,
			   INPUT  false).
   run Choose_Create.
end.


/*=============================View menu=================================*/

/*----- SHOW HIDDEN TABLES ----- */
On value-changed of MENU-ITEM mi_Show_Hidden in MENU s_mnu_View
do:
   /* Toggle the flag */
   s_Show_Hidden_Tbls = NOT s_Show_Hidden_Tbls.

   /* redisplay the table list if it is currently visible */
   {as4dict/uncache.i 
      &List   = "s_lst_Tbls"
      &Cached = "s_Tbls_Cached"
      &Curr   = "s_CurrTbl"}

   if s_Lvl1Obj = {&OBJ_TBL} then
   do:
      if s_CurrObj <> {&OBJ_TBL} then
	 run as4dict/_brwbtn.p (INPUT {&OBJ_TBL}, 
				 INPUT s_icn_Tbls:HANDLE in frame browse, 
				 INPUT false).   
	 
      run as4dict/_brwlist.p (INPUT {&OBJ_TBL}).
   end.
end.


/*----- ORDER FIELDS ----- */
On choose of MENU-ITEM mi_Order_Fields in MENU s_mnu_View
do:
   /* Change the menu label to indicate what the user will change to
      if he picks that option. 
   */
   if s_Order_By = {&ORDER_ALPHA} then
      assign
	 s_Order_By = {&ORDER_ORDER#}
	 SELF:label = "Order Fields Alphabetically".
   else
      assign
	 s_Order_By = {&ORDER_ALPHA}
	 SELF:label = "Order Fields by Order Number".

   /* redisplay the field list if it is currently visible */
   {as4dict/uncache.i 
      &List   = "s_lst_Flds"
      &Cached = "s_Flds_Cached"
      &Curr   = "s_CurrFld"}

   if s_Lvl2Obj = {&OBJ_FLD} then
      run as4dict/_brwlist.p (INPUT {&OBJ_FLD}).
end.


/*==========================Options menu=================================*/

/*----- RENAME FIELDS ----- */
On choose of MENU-ITEM mi_Field_Rename in MENU s_mnu_Options
do:
   current-window = s_win_Browse. /* parents dialog to browse window */
   run as4dict/FLD/_renam.p.
end.

/*----- DATABASE MODE -----*/
On choose of MENU-ITEM mi_Mode_Db in MENU s_mnu_Options
   apply "mouse-select-down" to s_icn_Dbs in frame browse.

/*----- TABLES MODE -----*/
On choose of MENU-ITEM mi_Mode_Tbl in MENU s_mnu_Options
   apply "mouse-select-down" to s_icn_Tbls in frame browse.

/*----- PROCEDURE MODE -----*/
On choose of MENU-ITEM mi_Mode_Proc in MENU s_mnu_Options
   apply "mouse-select-down" to s_icn_Proc in frame browse.



/*----- SEQUENCES MODE -----*/
On choose of MENU-ITEM mi_Mode_Seq in MENU s_mnu_Options
   apply "mouse-select-down" to s_icn_Seqs in frame browse.

/*----- FIELD MODE -----*/
On choose of MENU-ITEM mi_Mode_Fld in MENU s_mnu_Options
   apply "mouse-select-down" to s_icn_Flds in frame browse.

/*----- INDEX MODE -----*/
On choose of MENU-ITEM mi_Mode_Idx in MENU s_mnu_Options
   apply "mouse-select-down" to s_icn_Idxs in frame browse.

/*----- PARAMETER MODE -----*/
On choose of MENU-ITEM mi_Mode_Parm in MENU s_mnu_Options
   apply "mouse-select-down" to s_icn_Parm in frame browse.

/*===========================Help menu==================================*/

on choose of MENU-ITEM mi_Contents in MENU s_mnu_Help
   RUN "adecomm/_adehelp.p" ("as4d", "TOPICS", ?, ?).

on choose of MENU-ITEM mi_messages in MENU s_mnu_Help
  RUN prohelp/_msgs.p.

on choose of MENU-ITEM mi_recent in MENU s_mnu_Help
  RUN prohelp/_rcntmsg.p.

on choose of MENU-ITEM mi_About in MENU s_mnu_Help
do:
   current-window = s_win_browse.
   run adecomm/_about.p ("/400 Data Dictionary", "adeicon/dict%").
end.

