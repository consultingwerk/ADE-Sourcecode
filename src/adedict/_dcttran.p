/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/


/*----------------------------------------------------------------------------

File: _dcttran.p

Description:
   The main dictionary transaction loop.  It also contains the wait-for
   block for when we are in browse mode.  In either case, this is only
   run when the current dictionary database is connected and we can
   therefore look at it's schema.

   This is separated from dictmain.p so that all references to metaschema
   files (i.e., all database references) have a place to be scoped to,
   namely this .p.  This way they can stay around as long as we're  
   dealing with a single database.  When we switch databases, or disconnect
   a database, we have to return to main temporarily so that Progress can
   clean up after itself with respect to that database.  Then this procedure
   can be reentered for a new database.
    
Author: Laura Stern

Date Created: 04/14/92 
    Modified: 05/19/99 Mario B.  Adjust Width Field browser integration.
----------------------------------------------------------------------------*/

&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i  shared}
{adedict/menu.i     shared}
{adedict/uivar.i    shared}
{adedict/brwvar.i   shared}    
{adecomm/cbvar.i    shared}
{adedict/DB/dbvar.i shared}

{adedict/TBL/tblvar.i   "new shared"}
{adedict/SEQ/seqvar.i   "new shared"}
{adedict/FLD/fldvar.i   "new shared"}
{adedict/IDX/idxvar2.i  "shared"}
{adedict/IDX/idxvar.i   "new shared"}
{prodict/gui/widthvar.i "shared"}

/* Local variables */
Define var answer    as logical  NO-UNDO.

/*=============================== Triggers ===================================*/

{adedict/edittrig.i} /* triggers for the edit (properties) windows */


/* include file contains trigger for s_lob_size and s_clob_cp */
{prodict/pro/fldfuncs.i}
{adedict/FLD/lob-misc.i &Frame = "frame fldprops"}

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

tranblk:
repeat transaction ON ERROR UNDO, RETRY:
   /* In case we were undoing or committing stat msg will have text
      in it.  Display that and reset cursor.
   */
   if s_Browse_Stat <> "" then
   do:
      display s_Browse_Stat with frame browse.
      run adecomm/_setcurs.p ("").
   end.

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
      run adedict/_delwins.p (INPUT yes).
      leave tranblk.
   end.
   ELSE IF s_Trans = {&TRANS_UNDO} THEN DO:
       /* need to refresh the data in the DB properties window, if it was up when the user chose to
         undo the transaction.
       */
       if s_win_Db <> ? then
            run adedict/DB/_dbprop.p.
   END.

   /* Open up the tables list by default if no other list is showing.
      This will happen we we've switched to a new database. */
   if s_Lvl1Obj = {&OBJ_NONE} then
      apply "mouse-select-down" to s_icn_Tbls in frame browse.

   /* If index list was showing when user committed, then in case the
      default index is added upon committing we have to refresh the
      index list. */
   if s_Lvl2Obj = {&OBJ_IDX} then
   do:
      {adedict/uncache.i
      	    &List   = "s_lst_Idxs"
      	    &Cached = "s_Idxs_Cached"
      	    &Curr   = "s_CurrIdx"}
      run adedict/_brwlist.p (INPUT {&OBJ_IDX}).
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
         IF user_env[34] <> "Y" AND user_env[34] <> "N" THEN DO:

      	   answer = yes.  /* the default */
      	   message "You have made changes in the current"    SKIP
      	       	 "database, that are not committed."       SKIP(1)
      	       	 "Do you want to commit your changes?" 
      	       	  view-as ALERT-BOX QUESTION
      	          buttons YES-NO
      	       	  update answer in window s_win_Browse.
         END.
         ELSE
             ASSIGN answer = (IF user_env[34] = "Y" THEN TRUE ELSE FALSE).

	   if answer = no THEN DO:
	     display "Transaction Undone" @ s_Browse_Stat with frame browse.
	     if s_Trans = {&TRANS_ASK_AND_DO} then
      	    do:
      	       {adedict/setdirty.i &Dirty = "false"}.
      	 end.
      	 else
      	     s_DictState = {&STATE_DONE}.
      	             
      	    /* Cause return from this .p so we can do the required
      	       action (e.g., switch databases etc.).
      	    */
	     undo tranblk, leave tranblk. 
	   end.
       else if answer = yes then /* Commit and then take action */
      	 do:
   	    /* flag that we're done but let code drop through 
      	       the end of the repeat first. */
	    if s_Trans = {&TRANS_ASK_AND_EXIT} then
      	       s_DictState = {&STATE_DONE}.
      	    s_Trans = {&TRANS_DONE}.
       end.
     end.  /* end of ASK_AND_DO/ASK_AND_EXIT */

     else if s_Trans = {&TRANS_UNDO} then
      do:
      	 {adedict/setdirty.i &Dirty = "false"}.

      	 /* Since anything could have changed, just close up
      	    everything and let the user start again. */
      	 s_DictState = {&STATE_NO_OBJ_SELECTED}.
      	 run adedict/_brwadj.p (INPUT {&OBJ_DB}, INPUT 1).

      	 run adecomm/_setcurs.p ("WAIT"). /* while undoing */
      	 s_Browse_Stat = "Transaction Undone". 	/* to be displayed when done */
	 undo tranblk, next tranblk.
      end.

      /* else s_Trans = {&TRANS_COMMIT} and we'll fall through to
      	 commit the transaction. 
      */
   end.  /* end Dict was dirty */

   else do:
      /* Dict is not dirty, s_Trans is either ASK_AND_EXIT or ASK_AND_DO. */
      if s_Trans = {&TRANS_ASK_AND_EXIT} then
      	 s_DictState = {&STATE_DONE}.
      leave tranblk.
   end.

   /* If we got here, we want to commit the transaction. */

   run adecomm/_setcurs.p ("WAIT"). /* while committing */
   /* CISAM renumbers the field-pos whenever a field gets added, */
   /* deleted or it's name changed. Triggers are referenced also */
   /* by field-pos, so we have to run that program               */
   /* The same goes for RMS             (hutegger 02/95)         */
   if  s_DbCache_type[s_DbCache_ix] = "CISAM"
    or s_DbCache_type[s_DbCache_ix] = "RMS"
    then RUN prodict/gate/_gat_atg.p (s_DbCache_Pname[s_DbCache_ix]).
    
   s_Browse_Stat = "Transaction committed".  /* to be displayed when done */
   {adedict/setdirty.i &Dirty = "false"}.
end. 

return.




