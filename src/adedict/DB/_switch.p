/**********************************************************************
* Copyright (C) 2000,2006,2014 by Progress Software Corporation. All  *
* rights reserved.  Prior versions of this work may contain portions  *
* contributed by participants of Possenet.                            *
*                                                                     *
**********************************************************************/

/*----------------------------------------------------------------------------

File: _switch.p

Description:
   Do what has to be done when the user selects a different database.
   This is also called on startup to set up for the default database selection
   or after connecting a new database since this becomes the selected one
   by default.

Author: Laura Stern

Date Created: 01/31/92 
     History: D. McMann 02/21/03 Replaced GATEWAYS with DATASERVERS
              fernando  06/12/06 Support for int64

----------------------------------------------------------------------------*/
  
{adedict/dictvar.i shared}
{adedict/menu.i shared}
{adedict/brwvar.i shared}

Define var is_progress	as logical init true NO-UNDO.
Define var useable_db   as integer           NO-UNDO.
Define var answer       as logical           NO-UNDO.
Define var l_CurrDB     as character         NO-UNDO.
Define var isMultitenant       as logical           NO-UNDO.
Define var isPartitioned       as logical           NO-UNDO.
Define var isCDCEnabled        as logical           NO-UNDO.

/* Parameters for getting datatype info for gateway. */
Define var io1        as integer NO-UNDO.
Define var io_length  as integer NO-UNDO.
Define var pro_type   as char    NO-UNDO.
Define var gate_type  as char    NO-UNDO.
Define var out1       as char    NO-UNDO.

DEFINE VAR cTemp      AS CHAR    NO-UNDO.

/*-------------------------Mainline Code-------------------------------*/

CURRENT-WINDOW = s_win_Browse.

/* Reset CurrDb and the index into the cache. */
assign
  l_CurrDB     = s_lst_Dbs:screen-value in frame browse
  l_CurrDB     = ( if l_CurrDB = ?
                    then ""
                    else l_CurrDB
                 )
  s_DbCache_ix = ( if l_CurrDB = ""
                    then 0
                    else s_lst_Dbs:LOOKUP(l_CurrDB) in frame browse
                 )
  io_length    = index(l_CurrDB,"(") - 2
  s_CurrDB     = (if io_length < 0
                    then l_CurrDB
                    else substring(l_CurrDB,2,io_length,"character")
                 ).

/* Set the alias DICTDB.  Inside the dictionary, DICTDB is always a
   Progress database - which means it is the schema holder database when
   we are working with a foreign database. 

   Outside of the dictionary, DICTDB may be either a progress database or
   a gateway database.
*/
if s_CurrDB <> "" then
do:
   is_progress = (if {adedict/ispro.i} then true else false).
   s_DictState = {&STATE_NO_OBJ_SELECTED}. /* i.e. no obj selected */
                                           /*        in working db */

   if is_progress then
      create alias "DICTDB" for database VALUE(s_CurrDB) NO-ERROR.
   else 
      create alias "DICTDB" for database 
      	 VALUE(s_DbCache_Holder[s_DbCache_ix]) NO-ERROR.

   /* Determine if the we will be in read-only mode for this database. If
      it is a foreign db that's not connected, we can't the info - so
      assume, it's not read only.
   */
   s_DB_ReadOnly = can-do (DBRESTRICTIONS(s_CurrDB), "Read-Only").
   if s_DB_ReadOnly = ? then s_DB_ReadOnly = no.

   /* Set the record Id for:
      	 1) the _Db record for this database      	 

      Note: This must be done in a separate .p so that it uses the alias
      	    we just set up against the current database.
   */
   run adedict/_setid.p (INPUT {&OBJ_DB}, OUTPUT s_DbRecId).   
   
   /* check if this is a 10.1B db at least, so that we complain about int64 and
      int64 values. If the LARGE_KEYS feature is not known by this db, then this
      is a pre-101.B db 
   */
   ASSIGN is-pre-101b-db = YES
          s_Large_Seq = ?.

   RUN prodict/user/_usrinf3.p 
      (INPUT  LDBNAME("DICTDB"),
       INPUT  "PROGRESS",
       OUTPUT ctemp, 
       OUTPUT ctemp,
       OUTPUT s_Large_Seq,
       OUTPUT answer,
       OUTPUT isMultitenant,
       OUTPUT isPartitioned,
       OUTPUT isCDCEnabled).
      
  /* if large_keys is not known by db, answer will be ? */
  IF answer NE ? THEN
     ASSIGN is-pre-101b-db = NO.

end.
else do:
   s_DictState = {&STATE_NO_DB_SELECTED}.
   delete alias "DICTDB".
end.

/* If this is a foreign db, fill the user_env variable which holds 
   data type and default info for this gateway.  We'll need it everytime
   we add or modify a field - might as well just get it once.
*/
if s_CurrDB <> "" AND NOT is_progress then
do:
   {adedict/gateproc.i &Suffix = "_typ" &Name = "s_Gate_Typ_Proc"} 

   /* This will not fill the in/out parms - instead user_env[11] -
      user_env[15] are filled with stuff.  We tell xxx_typ to do this by
      setting both pro_typ and gate_type to ?.  Also set io_length to
      anything but ? to indicate for rms that we want expanded data 
      type list.
   */
   assign 
      pro_type = ?
      gate_type = ?
      io_length = ?. 
   run VALUE(s_Gate_Typ_Proc) 
     ( INPUT-OUTPUT io1,
       INPUT-OUTPUT io_length,
       INPUT-OUTPUT pro_type,
       INPUT-OUTPUT gate_type,
       OUTPUT       out1
     ). 
end.

/* Now hide/view stuff.  When we select a new database, we clear all
   the info from the old database. This also adjusts menu/browse graying.  
*/
useable_db = if s_CurrDB = "" then 0 else 1.
run adedict/_brwadj.p (INPUT {&OBJ_DB}, INPUT useable_db).

/* You can get at the schema for Foreign databases even if they're not
   connected - but give user the option to connect.
*/
if s_ask_gateconn AND NOT is_progress AND NOT CONNECTED(s_CurrDB) then
do:
   /* los - added 12/27/94 - also see _getrdbs.p */
   if NOT CAN-DO(DATASERVERS, s_DbCache_Type[s_DbCache_ix]) then do:
      s_Browse_Stat = 
      "This module does not support connections to this Data Server type.".
      display s_Browse_Stat with frame browse.
      /* this will get erased as soon as we come back down through
         dcttran and artificially "click" on table icon.  So just pause
         a bit so user can read this.  
      */
      pause(2) no-message.
   end.
   else do:
     message "In order to access user's data in database" s_CurrDB
                                                                {&SKIP}
             "it must be connected.  Do you want to connect now?"
              view-as ALERT-BOX QUESTION buttons YES-NO update answer.
       
     if answer then
        run adedict/DB/_connect.p (INPUT s_CurrDB).
   end.
end.
s_ask_gateconn = yes.  /* reset to default */

/* Menugray doesn't take care of disconnect option - so do that */
assign
   MENU-ITEM mi_Disconnect:sensitive = 
      (if s_CurrDB = "" then false
       else if CONNECTED(s_CurrDB) then true 
       else false).

/* If database is read only make sure user is told so he knows why things
   are grayed out.  If the dictionary is read only for another reason
   we will have already gotten a message so don't bother.
*/
if s_DB_ReadOnly and NOT s_ReadOnly then
   message "Note: This is a read-only database.  You will not be" SKIP
   	   "allowed to modify any schema objects."
      view-as ALERT-BOX INFORMATION buttons OK.

return.







