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

File: _switch.p

Description:
   Do what has to be done when the user selects a different database.
   This is also called on startup to set up for the default database selection
   or after connecting a new database since this becomes the selected one
   by default.

Author: Laura Stern

Date Created: 01/31/92  
Modified:     01/04/95 DMcMann - changed for PROGRESS/400 dictionary     
              03/25/96 D. McMann Changed QUESTION to WARNING in messages 
              06/19/96 D. McMann changed for support of logical name 
              03/12/97 D. McMann removed code looking for _DB since the DB2/400
                                 must be connected and s_Currdb can be used.
                                 Also if mult schema holders are connected
                                 the _db is not available 97-03-13-047.
              06/26/97 D. McMann Changed for logical name problem 97-06-06-029
              02/07/00 D. McMann Added QRYSRVCAP so when switch is done, so proper processing is done.
              10/25/00 D. McMann Added QRYSRVCAP allow_raw and allow_ench plus
                                       changed to as4dict/_as4_typ.p
----------------------------------------------------------------------------*/
 
{as4dict/dictvar.i shared}
{as4dict/menu.i shared}
{as4dict/brwvar.i shared}

Define var is_progress  as logical init true NO-UNDO.
Define var useable_db   as integer           NO-UNDO.
Define var answer       as logical           NO-UNDO.
Define var i            as integer           NO-UNDO.

/* Parameters for getting datatype info for gateway. */
Define var io1        as integer NO-UNDO.
Define var io_length  as integer NO-UNDO.
Define var pro_type   as char    NO-UNDO.
Define var gate_type  as char    NO-UNDO.
Define var out1       as char    NO-UNDO.


/*-------------------------Mainline Code-----------------------------------*/

CURRENT-WINDOW = s_win_Browse.

/* Reset CurrDb and the index into the cache. */
s_CurrDb = s_lst_Dbs:screen-value in frame browse.
if s_CurrDb = ? then     
   s_CurrDb = "". 
else
   s_DbCache_ix = s_lst_Dbs:LOOKUP(s_CurrDb) in frame browse.

/* Set the alias as4dict for the AS400 database just selected.   */
do i = 1 to num-dbs:
  if PDBNAME(i) = s_Currdb then do:
    if LDBNAME(i) = PDBNAME(i) then
      create alias as4dict for database value(s_Currdb).
    else 
      create alias as4dict for database value(ldbname(i)).
   end.
end.        
/* Set the alias DICTDB.  Inside the dictionary, DICTDB is always a
   Progress database - which means it is the schema holder database when
   we are working with a foreign database. 

   Outside of the dictionary, DICTDB may be either a progress database or
   a gateway database.
*/

if s_CurrDb <> "" then
do:
   is_progress = (if {as4dict/ispro.i} then true else false).
   s_DictState = {&STATE_NO_OBJ_SELECTED}. /*i.e. no obj selected in working db*/

   if is_progress then
      create alias "DICTDB" for database VALUE(s_CurrDb) NO-ERROR.
   else 
      create alias "DICTDB" for database 
      	 VALUE(s_DbCache_Holder[s_DbCache_ix]) NO-ERROR.
   
   /* Determine if the we will be in read-only mode for this database. If
      it is a foreign db that's not connected, we can't the info - so
      assume, it's not read only.
   */

   if s_DB_ReadOnly = ? then s_DB_ReadOnly = no.
    
   /* Set the record Id for:
      	 1) the _Db record for this database
      	 2) the table that domains are associated with in this db.

      Note: This must be done in a separate .p so that it uses the alias
      	    we just set up against the current database.
   */
   
   
   run as4dict/_setid.p (INPUT {&OBJ_DB}, OUTPUT s_DbRecId).   
 
end.
else do:
   s_DictState = {&STATE_NO_DB_SELECTED}.
   delete alias "DICTDB".
end.

/* Check for server capabilities for replications triggers and stored procedures 
    word indexing and chgpf are done in change mode only 
 */
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
  RUN as4dict/_dbaocmd.p (INPUT "RAW", INPUT "", INPUT "", INPUT 0, INPUT 0).      
  IF dba_return = 1 THEN
    ASSIGN allow_raw = TRUE.
  ELSE
    ASSIGN allow_raw = FALSE. 

  ASSIGN dba_cmd = "QRYSRVCAP".
  RUN as4dict/_dbaocmd.p (INPUT "WRDIDX", INPUT "", INPUT "", INPUT 0, INPUT 0).      
  IF dba_return = 1 THEN
    ASSIGN allow_word_idx = TRUE.
  ELSE
    ASSIGN allow_word_idx = FALSE. 

  ASSIGN dba_cmd = "QRYSRVCAP".
  RUN as4dict/_dbaocmd.p (INPUT "ENHDBA", INPUT "", INPUT "", INPUT 0, INPUT 0).      
  IF dba_return = 1 THEN
    ASSIGN allow_enhdba = TRUE.
  ELSE
    ASSIGN allow_enhdba = FALSE. 

if s_CurrDb <> "" THEN DO:
   /* This will not fill the in/out parms - instead user_env[11] -
      user_env[15] are filled with stuff.  We tell _as4_typ to do this by
      setting both pro_typ and gate_type to ?.  
   */
   assign 
      pro_type = ?
      gate_type = ?
      io_length = 1
      s_Gate_Typ_Proc = "as4dict/_as4_typ.p". 

   run VALUE(s_Gate_Typ_Proc) (INPUT-OUTPUT io1, INPUT-OUTPUT io_length,
   	       	     	       INPUT-OUTPUT pro_type, INPUT-OUTPUT gate_type,
   	       	     	       OUTPUT out1). 
end.
 
/* Now hide/view stuff.  When we select a new database, we clear all
   the info from the old database. This also adjusts menu/browse graying.  
*/
useable_db = if s_CurrDb = "" then 0 else 1.
run as4dict/_brwadj.p (INPUT {&OBJ_DB}, INPUT useable_db).

s_ask_gateconn = yes.  /* reset to default */

/* If database is read only make sure user is told so he knows why things
   are grayed out.  If the dictionary is read only for another reason
   we will have already gotten a message so don't bother.
*/
if s_DB_ReadOnly and NOT s_ReadOnly then
   message "Note: This is a read-only database.  You will not be" SKIP
   	   "allowed to modify any schema objects."
      view-as ALERT-BOX INFORMATION buttons OK.
      


return.







