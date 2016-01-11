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
 
File: _dcttran.p

Description:
   The main dictionary transaction loop.  It also contains the wait-for
   block for when we are in browse mode.  In either case, this is only
   run when the current dictionary database is connected and we can
   therefore look at it's schema.

   This is separated from dictg.p so that all references to metaschema
   files (i.e., all database references) have a place to be scoped to,
   namely this .p.  This way they can stay around as long as we're 
   dealing with a single database.  When we switch databases, or disconnect
   a database, we have to return to main temporarily so that Progress can
   clean up after itself with respect to that database.  Then this procedure
   can be reentered for a new database.
    
Author: Laura Stern

Date Created: 04/14/92 
    Modified: 01/1995 to work with PROGRESS/400 Data Dictionary   D. McMann 
              03/25/96 D. McMann Changed QUESTION to WARNING
              06/17/96 D. McMann Changed process for syncing client.  
              09/30/96 D. McMann Changed how files are verified for having
                                 fields and leaving transaction blook after
                                 sync.
              07/14/97 D. McMann Placed sync outside of transaction loop
                                 97-02-03-004 
              05/19/98 D. McMann Added uptfld.i                   
----------------------------------------------------------------------------*/


{as4dict/dictvar.i  shared}
{as4dict/menu.i     shared}
{as4dict/uivar.i    shared}
{as4dict/brwvar.i   shared}    
{adecomm/cbvar.i    shared}
{as4dict/DB/dbvar.i shared}

{as4dict/TBL/tblvar.i   "new shared"}
{as4dict/SEQ/seqvar.i   "new shared"}
{as4dict/FLD/fldvar.i   "new shared"}
{as4dict/IDX/idxvar.i   "new shared"}
{as4dict/prc/procvar.i  "new shared"}
{as4dict/parm/parmvar.i "new shared"}
{as4dict/FLD/uptfld.i  NEW }

/* Local variables */
Define var answer    as logical  NO-UNDO.
Define var dbnum     as integer  NO-UNDO.
Define var name      as character NO-UNDO.       
 Define var cpassed as logical NO-UNDO.
 
/* This needs to be carried into the PROGRESS/400 Dictionary so that it can be
     used if we have to run sync */
     
DEFINE SHARED VARIABLE USER_PATH AS CHARACTER NO-UNDO.
 

/*=============================== Triggers ===================================*/

{as4dict/edittrig.i} /* triggers for the edit (properties) windows */



/*============================= Mainline code ================================*/

/* Here's our main transaction loop.  Most actions occur within triggers
   generated from within the wait-for state.  However, we must return here
   (by applying "U2" to frame browse) whenever we want to commit or undo
   the transaction.  The transaction is everything that happened since the
   user started working with the current database in the dictionary or
   everything since the last explicit commit - whichever is later.
   s_Trans tells us what transaction action to take.  s_ActionProc can be
   set to an action to perform after we commit or abort.
*/
s_Trans = {&TRANS_NONE}.
s_Browse_Stat = "".
run dict-trans.
return.


Procedure dict-trans.
tranblk:
repeat transaction ON ERROR UNDO, RETRY:   

   /* In case we were undoing or committing stat msg will have text
      in it.  Display that and reset cursor.
   */
   if s_Browse_Stat <> "" then do:
	display s_Browse_Stat with frame browse.
	 run adecomm/_setcurs.p ("").
   end.     
   else if not dba_passed then
       run adecomm/_setcurs.p ("").   
      
   /* If we're done, clearly we get out of here.  But also, if user has
      just committed we have to pop up and come back down so that
      the schema cache gets updated.
   */
   if s_Trans = {&TRANS_DONE} OR s_Trans = {&TRANS_COMMIT} then
   do:
      /* Property window widgets (except DB window) are not scoped above
	 this level.  If we are done, they need to be closed anyway.
	 If we're committing, we'd better close them otherwise when we
	 come back in - they are screwed up. 
      */
	run as4dict/_delwins.p (INPUT yes).
	leave tranblk.
   end.

   /* Open up the tables list by default if no other list is showing.
      This will happen we we've switched to a new database. */
   if s_Lvl1Obj = {&OBJ_NONE} then
      apply "mouse-select-down" to s_icn_Tbls in frame browse.

   /* If index list was showing when user committed, then in case the
      default index is added upon committing we have to refresh the
      index list. */
   if s_Lvl2Obj = {&OBJ_IDX} then
   do:
	{as4dict/uncache.i
	    &List   = "s_lst_Idxs"
	    &Cached = "s_Idxs_Cached"
	    &Curr   = "s_CurrIdx"}
	run as4dict/_brwlist.p (INPUT {&OBJ_IDX}).
   end.

   if s_Browse_Stat <> "" then
   do:
      /* Above processing may have erased status - so re display it */
	display s_Browse_Stat with frame browse.
	s_Browse_Stat = "".  
   end.

   /* In case we're just starting up, get rid of logo window and
      make sure browse window is in view. 
   */
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

   /* If list had the focus from last time, return it there */
   if s_Dblst_Focus then
      Wait-for "U2" of frame browse FOCUS s_lst_Dbs.
   else
      Wait-for "U2" of frame browse.

   current-window = s_win_Browse.  /* to parent alert boxes and msgs */
   
   if s_DictDirty then
   do:
	if s_Trans = {&TRANS_ASK_AND_DO} OR
	    s_Trans = {&TRANS_ASK_AND_EXIT} then
	do:
	     /* The actions to take are either switch database, disconnect, 
	exit or run another ADE tool.
	     */                  
	     
	    IF s_Trans =  {&TRANS_ASK_AND_DO} THEN DO:
		IF user_env[34] <> "Y" and user_env[34] <> "N" then do:
		  answer = yes.  /* the default */                   
		  message "You have made changes in the current"    SKIP
				"database that are not committed.  Answering"    SKIP  
				"YES will commit your changes, NO will undo"   SKIP
		      "them.  In either case, afterwards you will be"  SKIP
		      "returned to read only mode." SKIP (1)
		      "Do you want to commit your changes?" 
		   view-as ALERT-BOX WARNING  buttons YES-NO
		   update answer in window s_win_Browse.      
		  if answer then user_env[34] = "Y" . 
		  else user_env[34] = "N".
	       end.
	     end.          
		      
	    /* user_env[34] is set in menutrig.i  so that if the user wants to cancel
		they can.  With DataServers, if the cancel was here, the client issued
		a commit */
		    
	      assign answer = (if user_env[34] = "Y" then true else false)
		     user_env[34] = "".
						  
	    if answer = no then do:                  
		run adecomm/_setcurs.p ("WAIT").
		ASSIGN dba_cmd = "ROLLBACK".
		RUN as4dict/_dbaocmd.p (INPUT "", INPUT "", INPUT "", INPUT 0, INPUT 0).
	   
		ASSIGN dba_cmd = "END".
		RUN as4dict/_dbaocmd.p (INPUT "", INPUT "", INPUT "", INPUT 0, INPUT 0).
	     
		s_ReadOnly = yes.                  
		ASSIGN s_mod_chg = "Read Only" 
				 s_mod_chg:screen-value in frame browse = "Read Only".   
		s_AskSync = FALSE.                      
		display "Transaction Undone" @ s_Browse_Stat with frame browse.   

		if s_Trans = {&TRANS_ASK_AND_DO} then do:
		    {as4dict/setdirty.i &Dirty = "false"}.
		end.
		else do:
		    {as4dict/setdirty.i &Dirty = "false"}.                
		    s_DictState = {&STATE_DONE}.       
		end.    
		run adecomm/_setcurs.p ("").         
	    /* Cause return from this .p so we can do the required
	       action (e.g., switch databases etc.).
	    */
		undo tranblk, leave tranblk. 
	    end.      
	    else if answer = yes then /* Commit and then take action */
	    do:              
		run adecomm/_setcurs.p ("WAIT").                      
  
		ASSIGN dba_cmd = "COMMIT".
		RUN as4dict/_dbaocmd.p (INPUT "", INPUT "", INPUT "", INPUT 0, INPUT 0).
		ASSIGN cpassed = dba_passed.
		       
		ASSIGN dba_cmd = "END".
		RUN as4dict/_dbaocmd.p (INPUT "", INPUT "", INPUT "", INPUT 0, INPUT 0).

		IF cpassed  THEN        
		    s_AskSync = true.                       
	                           
		s_ReadOnly = yes.                  
		ASSIGN s_mod_chg = "Read Only" 
				 s_mod_chg:screen-value in frame browse = "Read Only".   
		s_DictState = {&STATE_DONE}.                 
	    /* flag that we're done but let code drop through 
	       the end of the repeat first. */
		s_Trans = {&TRANS_DONE}.    
		run adecomm/_setcurs.p ("").
	    end.
	end.  /* end of ASK_AND_DO/ASK_AND_EXIT */

	else if s_Trans = {&TRANS_UNDO} then
	do:                              
	    run adecomm/_setcurs.p ("WAIT").                                                                               
	    ASSIGN dba_cmd = "ROLLBACK".
	    RUN as4dict/_dbaocmd.p (INPUT "", INPUT "", INPUT "", INPUT 0, INPUT 0).
			    
	    {as4dict/setdirty.i &Dirty = "false"}.

	 /* Since anything could have changed, just close up
	    everything and let the user start again. */
	    s_DictState = {&STATE_NO_OBJ_SELECTED}.
	    run as4dict/_brwadj.p (INPUT {&OBJ_DB}, INPUT 1).
	    run adecomm/_setcurs.p ("").            
	    s_AskSync = FALSE.              
	    s_Browse_Stat = "Transaction Undone".       /* to be displayed when done */                  
	    undo tranblk, next tranblk.
	end.

	else  IF s_Trans = {&TRANS_COMMIT}  THEN DO:
	    run adecomm/_setcurs.p ("WAIT").  
	    run as4dict/_chkfld.p.
	    if user_env[34] = "N" THEN DO:        
	       s_ActionProc = "".
	       s_lst_Dbs:screen-value in frame browse = s_Db_Pname. /*s_CurrDb.*/
	       display s_Db_Pname @ s_DbFill with frame browse.      
	       IF  s_Mod_Chg:screen-value = "Read Only" AND s_ReadOnly THEN DO:
	          ASSIGN  s_ReadOnly = FALSE
			  s_mod_chg = "Modify Schema" 
			  s_mod_chg:screen-value in frame browse = "Modify Schema".
		  RUN as4dict/_brwgray.p  (INPUT false).
	       END.                      
	       run adecomm/_Setcurs.p ("").
	       next tranblk.     
	    END.                                      
	    ASSIGN dba_cmd = "COMMIT".
	    RUN as4dict/_dbaocmd.p (INPUT "", INPUT "", INPUT "", INPUT 0, INPUT 0).  
	    assign cpassed = dba_passed.
	    IF  dba_passed THEN DO:
		ASSIGN s_AskSync = TRUE.                                 
		{as4dict/setdirty.i &Dirty = "false"}.
	    END.
	    ELSE  DO:                                              
		/* Switch to the new database (or no database).  
		    This will reset s_CurrDb, fix browse window, menu graying etc.
		     If previously connected db is still connected, alot of this is
		     redundant - but this is the cleanest way to do it.
		*/                
		run as4dict/_delwins.p (INPUT yes).

		 /* Clear the whole cache and start again. */  
		assign
		   s_lst_Dbs:LIST-ITEMS = ""
		   s_DbCache_Cnt        = 0
		   s_DbCache_Pname      = ""
		   s_DbCache_Holder     = ""
		   s_DbCache_Type       = "".
 
		run as4dict/DB/_getdbs.p.   
		/* Reset database selection to whatever as4dict is now or the first
			    entry in the list. */
		if s_lst_Dbs:NUM-ITEMS in frame browse > 0 then
		do:
		    dbnum = s_lst_Dbs:LOOKUP(LDBNAME("as4dict")) in frame browse.
 
		    if dbnum = 0 then dbnum = 1.
		    name = s_lst_Dbs:entry(dbnum) in frame browse.
				    s_lst_Dbs:screen-value in frame browse = name.
		    display name @ s_DbFill with frame browse.
		end.
		else
		    display "" @ s_DbFill with frame browse.
		s_AskSync = FALSE.    
		s_ask_gateconn = no.
		run as4dict/DB/_switch.p.           
		run adecomm/_Setcurs.p ("").                   
	    END.  
	    IF s_ReadOnly THEN DO:            
		ASSIGN dba_cmd = "END".
		RUN as4dict/_dbaocmd.p (INPUT "", INPUT "", INPUT "", INPUT 0, INPUT 0).          
	    END. 
	end.    
    end.  /* end Dict was dirty */

    else do:
      /* Dict is not dirty, s_Trans is either ASK_AND_EXIT or ASK_AND_DO. */
	if  s_Trans = {&TRANS_SYNC} THEN  DO:
	    run as4dict/dictsync.p.
	    leave tranblk.
	end. 
	if s_Trans = {&TRANS_ASK_AND_EXIT} then 
	    s_DictState = {&STATE_DONE}.                                 
	IF NOT s_ReadOnly   THEN DO:          
	    run adecomm/_setcurs.p ("WAIT").
	    ASSIGN dba_cmd = "END".
	    RUN as4dict/_dbaocmd.p (INPUT "", INPUT "", INPUT "", INPUT 0, INPUT 0).         
	    s_ReadOnly = yes.                  
	    ASSIGN s_mod_chg = "Read Only" 
		   s_mod_chg:screen-value in frame browse = "Read Only".   
	    run adecomm/_setcurs.p ("").             
	END.      
	IF s_AskSync THEN DO:	 
	    run as4dict/dictsync.p.     
	    s_AskSync = FALSE.                                   
	END.                                     
	leave tranblk.
    end.

    /* If we got here, we want to commit the transaction. */

    run adecomm/_setcurs.p ("WAIT"). /* while committing */
    if cpassed then
	s_Browse_Stat = "Transaction committed".  /* to be displayed when done */
    {as4dict/setdirty.i &Dirty = "false"}.
end. 

return.
end.




