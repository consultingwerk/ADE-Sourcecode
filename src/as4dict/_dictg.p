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

File: _dictg.p

Description:   
   This is the mainline code for the GUI version of the dictionary.
 
Author: Laura Stern

Date Created: 01/28/92 
    Modified: 12/20/94 D. McMann NHorn had started in 11/94    
              12/26/95 D. McMann  added cancel logic to run tool to close bug
                           95-10-20-014
              03/25/96 D. McMann Changed QUESTION to WARNING in messages  
              06/19/96 D. McMann Changed s_CurrDb so Dictionary Library
                                 displayed instead of logical db name   
              09/30/96 D. McMann Changed how files are checked to verify
                                 all have at least 1 field defined.   
              12/03/96 D. McMann Changed size of logo frame for change in font
                                 in 82  
              07/14/97 D. McMann Placed sync outside of transaction loop
                                 97-02-03-004 
              05/25/99 D. McMann Added stored procedure and replication trigger
                                 support
              10/25/00  D. McMann Added allow_raw and allow_ench
                                                                                                                         
----------------------------------------------------------------------------*/
&IF "{&WINDOW-SYSTEM}" BEGINS "MS-Win" &THEN

{as4dict/dictvar.i      "new shared"}
{as4dict/brwvar.i       "new shared"}
{as4dict/capab.i}
{as4dict/uivar.i        "new shared"}
{as4dict/menu.i         "new shared"}
{adecomm/cbvar.i      	"new shared"}
{as4dict/DB/dbvar.i     "new shared"}    



Define var capab     as char     NO-UNDO.
Define var dbnum     as integer  NO-UNDO.
Define var dbcnt     as integer	 NO-UNDO.
Define var istrans   as logical  initial TRUE. /* not no-undo! */
Define var wid       as decimal  NO-UNDO.
Define var ht        as decimal  NO-UNDO.
Define var ade_tool  as char     NO-UNDO.
Define var supw_sav  as logical  NO-UNDO.

/* For keeping track of disabled widgets on running another ADE tool. */
Define temp-table widg_list
   field h_widget as widget-handle.

/*===========================Startup Frame Defs==============================*/

/* This is the frame for the logo window that comes up to show the
   user that something's happening on startup so we can delay viewing
   of window till the last minute and avoid flashing.
*/
Define image dict_icon FILE "adeicon/dict%".
Define var loading as char NO-UNDO init "Loading..." format "x(10)". 

FORM
   SKIP({&TFM_WID})
   SPACE(20) dict_icon SPACE({&HM_WIDG}) loading SPACE(20) SKIP (1)
   with frame logo no-labels.     



/*================= Triggers (and Related Internal Procedures)===============*/
 
{as4dict/brwtrig.i}   /* browse window triggers */
{as4dict/menutrig.i}  /* menu triggers */

/*===========================Internal Procedures=============================*/

/*------------------------------------------------------------------------ 
   The user has chosen a tool from the tool menu.  Before running it
   we have to make sure any transaction is completed and get out of
   the transaction block.  
------------------------------------------------------------------------*/
PROCEDURE Prepare_For_ADE_Tool_Run:

Define INPUT PARAMETER p_ProgName as char NO-UNDO.           


run Check_For_Changes.
if RETURN-VALUE = "error" then return.
if s_DictDirty then do:
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
    end.     
    else assign user_env[34] = "N".	                                            
end.

   assign
      ade_tool = p_ProgName  /* Set a variable scoped to .p */
      s_ActionProc = "Run_ADE_Tool".

      s_Trans = {&TRANS_ASK_AND_DO}.
      apply "U2" to frame browse.
  /* end. */
end.


/*------------------------------------------------------------------------ 
   Disable the dictionary, run another ADE tool and then reenable
   myself.
------------------------------------------------------------------------*/
PROCEDURE Run_ADE_Tool:

   Define var widg   	as widget-handle NO-UNDO.
   Define var num    	as integer       NO-UNDO.  /* # dbs connected */
   Define var name 	as char          NO-UNDO.
   Define var all_conn  as logical       NO-UNDO init yes.
   Define var ix     	as integer       NO-UNDO.

   /*----- Disable the dictionary -----*/

   /* Delete property windows */
    run as4dict/_delwins.p (INPUT yes).

   /* Disable menu bar.  This only does top level menu items */
   menu s_mnu_Dict:sensitive = no.

   /* Reset this to what it was when dict started */
   session:suppress-warnings = supw_sav.
   
   /* Disable any visible and enabled widgets. Keep track of the widget handles,
      so we can reenable them later.
   */
   widg = frame browse:first-child.  /* this will be a field group */
   widg = widg:first-child.
   
   /* First clear the list */
   for each widg_list:
      delete widg_list.
   end.
   
   do while widg <> ?:
      if widg:visible = yes AND widg:sensitive = yes then
      do:
	 widg:sensitive = no.
	 create widg_list.   
	 widg_list.h_widget = widg.
      end.
      widg = widg:next-sibling.
   end.


   /*----- Run the tool -----*/
   num = NUM-DBS.  /* remember this */
   run VALUE(ade_tool).


   /*---- Reenable Dictionary -----*/

   /* Reenable menu bar */
   current-window = s_win_Browse.
   menu s_mnu_Dict:sensitive = yes.  
 
   /* Reenable any disabled widgets */
   for each widg_list:
      widg_list.h_widget:sensitive = yes.
   end.
   
   /* Reset session attribute, in case the other tool clobbered it. */
   assign
      session:system-alert-boxes = yes
      session:suppress-warnings = yes.

  
   /* We are going to act as if the user just reconnected to this 
      database in case anyone made schema changes while we were out
      to lunch.  Also, if any of the databases that were connected 
      before are no longer connected or there are new ones connected, 
      we need to refresh things.
   */
   
    /* Clear the whole cache and start again. */  
    assign
	 s_lst_Dbs:LIST-ITEMS = ""
	 s_DbCache_Cnt        = 0
	 s_DbCache_Pname      = ""
	 s_DbCache_Holder     = ""
	 s_DbCache_Type       = "".
 
   run as4dict/DB/_getdbs.p.

   /* Reset database selection to whatever AS4DICT is now or the first
      entry in the list. */
   if s_lst_Dbs:NUM-ITEMS in frame browse > 0 then
   do:
     dbnum = s_lst_Dbs:LOOKUP(PDBNAME("as4dict")) in frame browse.
 
      if dbnum = 0 then dbnum = 1.
      name = s_lst_Dbs:entry(dbnum) in frame browse.
      s_lst_Dbs:screen-value in frame browse = name.
      display name @ s_DbFill with frame browse.
   end.
   else
      display "" @ s_DbFill with frame browse.
  
   /* Switch to the new database (or no database).  
      This will reset s_CurrDb, fix browse window, menu graying etc.
      If previously connected db is still connected, alot of this is
      redundant - but this is the cleanest way to do it.
   */
   s_ask_gateconn = no.
   run as4dict/DB/_switch.p.
end.


/*============================= Mainline code ================================*/

do ON STOP UNDO, LEAVE:
   /* Set up triggers or gray pieces of standard tool menu.  It also checks
      to see if Dictionary is already running.
   */
   {adecomm/toolrun.i &MENUBAR               = "s_mnu_Dict"
		      &EXCLUDE_DICT          = yes 
		      &DISABLE_WIDGETS_PROC  = Prepare_For_ADE_Tool_Run
		      &DISABLE_ONLY          = yes
   }
   if tool_bomb then return.  /* Dictionary is already running so quit */
 
   pause 0 before-hide.
   assign
      supw_sav = session:suppress-warnings /* save current value */
      session:suppress-warnings = yes /*no warnings on platform specific funcs*/
      session:system-alert-boxes = yes.
   use "" NO-ERROR.  /* resets to startup default file directory */
   
   /* Create the dictionary browse window */
   create window s_win_Browse 
      assign
	 x = 0
	 y = 20
	 scroll-bars = no
	 title = "PROGRESS/400 Data Dictionary"
	 menubar = MENU s_mnu_Dict:HANDLE
	 status-area = no
	 message-area = no
   
      triggers:
	 on window-close do:
	    run Do_Exit.      /* in menutrig.i */
	    return no-apply.  /* to avoid beep */
	 end.
      end triggers.    
  
   assign
      frame browse:parent = s_win_Browse
      s_Res = s_win_Browse:load-icon("adeicon/dict%").
   
   /* Resize the window to fit the browse frame */
   assign
      ht = frame browse:height-chars
      wid = frame browse:width-chars
      s_win_Browse:height-chars = ht
      s_win_Browse:width-chars = wid
      s_win_Browse:max-height = ht
      s_win_Browse:max-width = wid.
   
   create window s_win_Logo
      assign
	 x = 150
	 y = 100
	 scroll-bars = no
	 title = "PROGRESS/400 Data Dictionary"
	 status-area = no
	 message-area = no.
   
   /* Resize the window to fit the logo frame */
   assign
      ht = frame logo:height-chars
      wid = frame logo:width-chars
      s_win_Logo:height-chars = ht
      s_win_Logo:width-chars = wid
      s_win_Logo:max-height = ht
      s_win_Logo:max-width = wid.
   
   current-window = s_win_Logo.
   session:immediate-display = yes.
   if user_env[2] <> "sync" then display dict_icon loading with frame logo.
   run adecomm/_setcurs.p ("WAIT").
   
      /* Determine if we are in read-only mode  */
   do ON ERROR UNDO:   /* do the little istrans trick */
      istrans = false.
      undo, leave.
   end.
   
   /* When the Progress/400 Data Dictionary is initially we are in read-only mode 
        if user wants to modify schema, the modify schema button is selected and
        the DBA Maint call is issued to the server.  This is being implemented so 
        a user can review the schema without locking the database unless actual
        modifications will be performed.   Therefore a second variable will be used
        to determine if we are in a transaction and can't leave read only */          
        
   s_InTran_ReadOnly = (istrans OR (PROGRESS = "Query") OR (PROGRESS = "Run-Time")).
        
   s_ReadOnly = TRUE.

   /* Set up the browse combo boxes. This enables the fill-ins and lists. */
   {adecomm/cbdown.i &Frame  = "frame browse"
		     &CBFill = "s_DbFill"
		     &CBList = "s_lst_Dbs"
		     &CBInit = """"}
   
   {adecomm/cbdown.i &Frame  = "frame browse"
		     &CBFill = "s_TblFill"
		     &CBList = "s_lst_Tbls"
		     &CBInit = """"}
   
   {adecomm/cbdown.i &Frame  = "frame browse"
		     &CBFill = "s_SeqFill"
		     &CBList = "s_lst_Seqs"
		     &CBInit = """"}
   
   {adecomm/cbdown.i &Frame  = "frame browse"
		     &CBFill = "s_FldFill"
		     &CBList = "s_lst_Flds"
		     &CBInit = """"}
   
   {adecomm/cbdown.i &Frame  = "frame browse"
		     &CBFill = "s_IdxFill"
		     &CBList = "s_lst_Idxs"
		     &CBInit = """"}
   
   {adecomm/cbdown.i &Frame  = "frame browse"
		     &CBFill = "s_ProcFill"
		     &CBList = "s_lst_Proc"
		     &CBInit = """"}
 
   {adecomm/cbdown.i &Frame  = "frame browse"
		     &CBFill = "s_ParmFill"
		     &CBList = "s_lst_Parm"
		     &CBInit = """"} 

 
  /* Check for server capabilities for word indexes, replications triggers and stored procedures */
  ASSIGN dba_cmd = "QRYSRVCAP".
  RUN as4dict/_dbaocmd.p (INPUT "ALWRPLTRG", INPUT "", INPUT "", INPUT 0, INPUT 0).      
  IF dba_return = 1 THEN
    ASSIGN allow_rep_trig = TRUE.
  ELSE
    ASSIGN allow_rep_trig = FALSE.          
 
  ASSIGN dba_cmd = "QRYSRVCAP".
  RUN as4dict/_dbaocmd.p (INPUT "ALWSTPROC", INPUT "", INPUT "", INPUT 0, INPUT 0).      
  IF dba_return = 1 THEN
    ASSIGN allow_st_proc = TRUE.
  ELSE
    ASSIGN allow_st_proc = FALSE.          

  ASSIGN dba_cmd = "QRYSRVCAP".
  RUN as4dict/_dbaocmd.p (INPUT "WRDIDX", INPUT "", INPUT "", INPUT 0, INPUT 0).      
  IF dba_return = 1 THEN
    ASSIGN allow_word_idx = TRUE.
  ELSE
    ASSIGN allow_word_idx = FALSE. 

  ASSIGN dba_cmd = "QRYSRVCAP".
  RUN as4dict/_dbaocmd.p (INPUT "RAW", INPUT "", INPUT "", INPUT 0, INPUT 0).      
  IF dba_return = 1 THEN
    ASSIGN allow_raw = TRUE.
  ELSE
    ASSIGN allow_raw = FALSE. 

  ASSIGN dba_cmd = "QRYSRVCAP".
  RUN as4dict/_dbaocmd.p (INPUT "ENHDBA", INPUT "", INPUT "", INPUT 0, INPUT 0).      
  IF dba_return = 1 THEN
    ASSIGN allow_enhdba = TRUE.
  ELSE
    ASSIGN allow_enhdba = FALSE. 
  
   assign
      /* Activate remaining widgets (i.e., buttons) in the browse window. All 
	 are active even though, depending on what`s selected, some may be 
      	 hidden.
      */                 
      s_mod_chg:sensitive in frame browse = yes     
      s_icn_Dbs:sensitive  in frame browse = yes
      s_icn_Tbls:sensitive in frame browse = yes
      s_icn_Seqs:sensitive in frame browse = yes
      s_icn_Flds:sensitive in frame browse = yes
      s_icn_Idxs:sensitive in frame browse = yes    
      s_icn_Proc:sensitive in frame browse = yes
      s_icn_Parm:sensitive in frame browse = yes 
   
      /* Make most of things invisible to avoid flashing on startup. Leave
	 table stuff visible for now until we see if we've got a database
	 or not. 
      */

      s_SeqLbl:hidden     in frame browse = yes
      s_SeqFill:hidden    in frame browse = yes
      s_lst_Seqs:hidden   in frame browse = yes
      s_icn_Flds:hidden   in frame browse = yes
      s_FldLbl:hidden     in frame browse = yes
      s_FldFill:hidden    in frame browse = yes
      s_lst_Flds:hidden   in frame browse = yes
      s_icn_Idxs:hidden   in frame browse = yes
      s_IdxLbl:hidden     in frame browse = yes
      s_IdxFill:hidden    in frame browse = yes
      s_lst_Idxs:hidden   in frame browse = yes
      s_ProcLbl:hidden    in frame browse = yes
      s_ProcFill:hidden   in frame browse = yes
      s_lst_Proc:hidden   in frame browse = yes
      s_ParmLbl:hidden    in frame browse = yes
      s_ParmFill:hidden   in frame browse = yes
      s_lst_Parm:hidden   in frame browse = yes
      s_btn_Create:hidden in frame browse = yes
      s_btn_Props:hidden  in frame browse = yes
      s_btn_Delete:hidden in frame browse = yes.
   
   assign
      /* We don't want to DISPLAY these values because it will flash. 
	 So just move the variable value into the widget ourselves. 
      */
      s_DbLbl:screen-value  in frame browse = s_DbLbl
      s_DbLbl2:screen-value in frame browse = s_DbLbl2
      s_TblLbl:screen-value in frame browse = s_TblLbl
      s_SeqLbl:screen-value in frame browse = s_SeqLbl
      s_FldLbl:screen-value in frame browse = s_FldLbl
      s_IdxLbl:screen-value in frame browse = s_IdxLbl
      s_ProcLbl:screen-value in frame browse = s_ProcLbl
      s_ParmLbl:screen-value in frame browse = s_ParmLbl.

  
   /* Set up the menu/button graying tables. */
   run as4dict/_brwgray.p (INPUT true).
 
   /* Fills the browse select list and set s_CurrDb. */
 
   run as4dict/DB/_getdbs.p.

   dbcnt = s_lst_Dbs:NUM-ITEMS in frame browse.    

   if dbcnt > 0 then
   do:
      dbnum = s_lst_Dbs:LOOKUP(PDBNAME("as4dict")) in frame browse.
      if dbnum = 0 then dbnum = 1.
     
      if   dbnum + 1 <= dbcnt
        AND s_dbcache_type[dbnum]      = "PROGRESS"
        AND s_dbcache_type[dbnum + 1] <> "PROGRESS"
        then RUN as4dict/_dictfdb.p (INPUT-OUTPUT dbnum).
                                 /* ev. select schema of foreign db */  

      assign
	 s_CurrDb = (IF s_Currdb = "" THEN PDBNAME("as4dict") ELSE
	       s_lst_Dbs:ENTRY(dbnum) in frame browse)
	 s_lst_Dbs:screen-value in frame browse = s_CurrDb.
   end.
   else 
      assign
	 s_icn_Tbls:hidden in frame browse = yes
	 s_TblLbl:hidden   in frame browse = yes
	 s_TblFill:hidden  in frame browse = yes
	 s_lst_tbls:hidden in frame browse = yes
	 s_icn_Seqs:hidden in frame browse = yes
	 s_icn_Proc:hidden in frame browse = yes.
   
   s_DbFill:screen-value in frame browse = s_CurrDb.
   
   /* Initialize dirty flag */
   {as4dict/setdirty.i &Dirty = "false"}.


   /* This causes all kinds of work to be done based on the currently
      selected database (or no database).  s_DictState will be set. */

   run as4dict/DB/_switch.p.         

   s_ActionProc = "".
   
   mainloop: 
   repeat:          

      if s_DictState = {&STATE_DONE} then
	 leave mainloop.
  
      if s_DictState = {&STATE_NO_DB_SELECTED} then
      do:
	 if s_win_Logo <> ? then 
	 do:
	    /* We're in start up mode */
	    run adecomm/_setcurs.p ("").
	    session:immediate-display = no.
	    delete widget s_win_Logo.
	    s_win_Logo = ?.
	    current-window = s_win_Browse.
	    view frame browse.
	 end.
	 wait-for "U1" of frame browse.   
      end.
      else 
	 run as4dict/_dcttran.p.

      /* ActionProc may switch databases or disconnect a database. 
	 Either way, our state may change. */
      if s_ActionProc <> "" then
      do:
	 run VALUE(s_ActionProc).
	 s_ActionProc = "".
      end.
   end.	 /* end repeat */
  IF s_AskSync THEN
    run as4dict/dictsync.p.     
end.  /* end do ON STOP */

/* Delete all dictionary windows and help window if it's up. */
if s_win_Logo <> ? then /* this means user hit STOP before we even begun */
do:
   run adecomm/_setcurs.p ("").
   session:immediate-display = no.
   delete widget s_win_Logo.
end.

run as4dict/_delwins.p (INPUT yes).
run adecomm/_adehelp.p ("dict", "QUIT", ?, ?).
if s_win_Browse <> ? then
   delete widget s_win_Browse.
session:suppress-warnings = supw_sav.  /* reset to saved value */                    
&ENDIF



