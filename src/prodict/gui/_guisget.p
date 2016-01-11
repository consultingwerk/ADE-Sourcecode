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

File: _guisget.p  ("s" is for schema)
 
Description: Select one of the connected databases (if "dis" or "get")
      	     and switch to it as the current working database.

INPUT:
   user_env[1] = "dis" - this program disconnects a database
   user_env[1] = "new" - user just connected to a database - this may be
      	       	     	 the first database connected.
   user_env[1] = "get" - user wants to choose a database to work with
   user_env[1] = "sys" - dictionary forcing user to pick a database

Author: Tony Lavinio, Laura Stern

History:
    laurief     97/12/18    Made V8 to "generic version" changes
    laurief     97/05/12    Changed 2 messages to alert boxes. (95-09-27-025)
    hutegger    95/09/22    made V7 -> V8 changes
    hutegger    94/05/05    "automatically get select-dialogbox after
                            connecting to an n. db (n > 1)" was switched
                            off; I switched it on again. 
    hutegger    94/05/05    I inserted an extention of user_path in case
                            there are more then 1 db left after disconnect
                            1. commit transaction; 
                            2. call this routine again
    D. McMann   02/21/03    Replaced GATEWAYS with DATASERVERS
----------------------------------------------------------------------------*/
/* This whole file should be used only on GUI, but in case it gets compiled
for TTY mode, let's just turn it into a big empty file */
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN


{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/user/userhue.i }
{ prodict/user/userhdr.f }

DEFINE VARIABLE answer AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE choice AS INTEGER   INITIAL ?     NO-UNDO.
DEFINE VARIABLE dbpick AS CHARACTER               NO-UNDO.
DEFINE VARIABLE i      AS INTEGER                 NO-UNDO.
DEFINE VARIABLE j      AS INTEGER   INITIAL 0     NO-UNDO.
DEFINE VARIABLE is_dis AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE look   AS LOGICAL   INITIAL FALSE NO-UNDO.
/* old_db is index of currently selected database; user_dbname is it's name */
DEFINE VARIABLE old_db AS INTEGER   INITIAL ?     NO-UNDO. 
DEFINE VARIABLE oldbs  AS INTEGER   INITIAL 0     NO-UNDO.
DEFINE VARIABLE olname AS CHARACTER               NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE fast_track AS LOGICAL. /* FT active? */

/* Frame stuff */
DEFINE VARIABLE lsthead	AS CHAR	 NO-UNDO.
DEFINE VARIABLE dlist  	AS CHAR  NO-UNDO.

/* Miscelaneous */
DEFINE VARIABLE ix     	AS INTEGER   NO-UNDO. /* temp loop index */
DEFINE VARIABLE stat   	AS LOGICAL   NO-UNDO.
DEFINE VARIABLE item    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cancel  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE version AS CHARACTER NO-UNDO.


/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 22 NO-UNDO INITIAL [
  /*  1*/ "Are you sure that you want to disconnect database",
  /*  2*/ "Nothing was disconnected.",
  /*  3*/ "Cannot disconnect a database if it is not connected.",
  /*  4*/ "has been disconnected.",
  /*5,6*/ "There are only", "databases connected.  Please use the",
  /*7,8*/ "dictionary from", "Progress to view/edit these databases.",
  /*  9*/ "ERROR! Database type inconsistency in _usrsget.p",
/*10,11*/ "Database", "is not connected.", /* used with 18 */
  /* 12*/ "You must select a current working database at this time.",
  /* 13*/ "is the only database connected - it is already selected.",
  /* 14*/ "You have been automatically switched to database",
/*15,16,17*/ "This", "tool can't be used with a PROGRESS", "database.",
  /* 18*/ "There are no databases connected to select!",
  /* 19*/ "This copy of PROGRESS does not support database type",
  /* 20*/ "There are no databases connected for you to disconnect.",
  /* 21*/ "You have to leave Fast Track before disconnecting a database",
  /* 22*/ "Would you like to connect it?"
].
/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/

&GLOBAL-DEFINE LSTHEAD_AT 2.3

FORM
/*---TTY layout 05/11/93 -------------------------------------------------
  SKIP(1)
  lsthead   AT 4  FORMAT "x(73)"     	      	      SKIP
  dlist     AT 1  VIEW-AS SELECTION-LIST SINGLE 
      	          INNER-CHARS 75 INNER-LINES 3
      	       	  SCROLLBAR-V 	        	      SKIP(1)
-----------------------------------------------------------------------*/
  SKIP({&TFM_WID})
  lsthead   AT {&LSTHEAD_AT}  FORMAT "x(73)" SKIP({&VM_WID})
  dlist     AT 2  VIEW-AS SELECTION-LIST SINGLE 
      	          INNER-CHARS 73 INNER-LINES 3
      	       	  SCROLLBAR-V
  {prodict/user/userbtns.i}
  WITH FRAME schema_stuff USE-TEXT 
       NO-LABELS CENTERED DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
       SCROLLABLE FONT 0  /* use fixed pitch font */
       VIEW-AS DIALOG-BOX 
       TITLE "Select " + 
	      TRIM(STRING(is_dis,"Database to Disconnect/Working Database")).



/*==============================Triggers================================*/

/*----- HELP -----*/
on HELP of frame schema_stuff or CHOOSE of btn_Help in frame schema_stuff
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
      	       	     	     INPUT {&Select_Database_Dlg_Box},
      	       	     	     INPUT ?).


/*----- ON ANY PRINTABLE (ASCII) of DLIST -----*/
/*----- Do 1st letter navigation (only Motif doesn't do it natively -----*/


/*----- GO or OK -----*/
on GO of frame schema_stuff
do:
   if NOT is_dis then
   do:
      item = dlist:screen-value IN FRAME schema_stuff.
      choice = dlist:LOOKUP(item) IN FRAME schema_stuff.
      if  index(cache_db_t[choice],"/V5") <> 0
       or index(cache_db_t[choice],"/V6") <> 0
       or index(cache_db_t[choice],"/V7") <> 0
       or index(cache_db_t[choice],"/V8") <> 0
    /*(CAN-DO("PROGRESS/V5,PROGRESS/V6,PROGRESS/V7,PROGRESS/V8",cache_db_t[choice])*/
      then do:
      	 message new_lang[15] PROVERSION new_lang[16] version new_lang[17] /* cannot use V5/V6/V7/V8 db */
      	    view-as alert-box error buttons ok.
      	 return NO-APPLY.
      end.
   end.
end.


/*----- DEFAULT-ACTION of SELECT LIST-----*/
on default-action of dlist in frame schema_stuff 
   apply "GO" to frame schema_stuff.


/*----- WINDOW-CLOSE -----*/
on WINDOW-CLOSE of frame schema_stuff
    apply "END-ERROR" to frame schema_stuff.


/*=============================Mainline Code=============================*/

is_dis = user_env[1] = "dis".

IF is_dis AND NUM-DBS = 0 THEN DO:
  MESSAGE new_lang[20]  /* ain't nothin' to disconnect */
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  user_path = "".
  RETURN.
END.

RUN "prodict/_dctsget.p".

IF is_dis THEN DO: /* removed unconnected items from list */
  DO i = 1 TO cache_db#:
    IF CONNECTED(cache_db_l[i]) THEN ASSIGN
      j             = j + 1
      cache_db_e[j] = cache_db_e[i]
      cache_db_l[j] = cache_db_l[i]
      cache_db_p[j] = cache_db_p[i]
      cache_db_s[j] = cache_db_s[i]
      cache_db_t[j] = cache_db_t[i].
  END.
  cache_db# = j.
END.

DO i = 1 TO cache_db#:
  IF cache_db_l[i] = user_dbname AND old_db = ? THEN old_db = i.
  IF  index(cache_db_t[i],"/V5") <> 0
   or index(cache_db_t[i],"/V6") <> 0
   or index(cache_db_t[i],"/V7") <> 0
   or index(cache_db_t[i],"/V8") <> 0
   /*CAN-DO("PROGRESS/V5,PROGRESS/V6,PROGRESS/V7,PROGRESS/V8",cache_db_t[i])*/
   THEN oldbs = oldbs + 1.
   version = "V" + DBVERSION(cache_db#).
END.

ASSIGN
  cache_dirty = TRUE.

IF cache_db# = oldbs AND oldbs > 0 THEN DO:
  IF NOT is_dis THEN
    MESSAGE new_lang[5] version new_lang[6] SKIP
      new_lang[7] version new_lang[8] /* only non-V9 dbs connected */
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  look = TRUE.
END.
IF cache_db# = 0 OR cache_db# = oldbs THEN DO:
  ASSIGN
    user_path     = ""
    user_dbname   = ""
    user_dbtype   = ""
    user_filename = "".
  DISPLAY user_dbname user_filename WITH FRAME user_ftr.
  IF CAN-DO("get,new",user_env[1]) AND oldbs = 0 THEN
    MESSAGE new_lang[18] /* no dbs connected */
      VIEW-AS ALERT-BOX ERROR BUTTONS OK. 
  if NOT (look AND is_dis) THEN RETURN.
END.

/* <hutegger> 94/05/05 user should be automatically prompted to select */
/* the current working db, if there are more then 1 db's connected     */
/*
IF old_db <> ? AND user_env[1] = "new" THEN
  choice = old_db.
ELSE
*/
IF cache_db# = 1 AND NOT look THEN DO:
  choice = 1.
  IF user_env[1] = "get" THEN 
    MESSAGE cache_db_l[1] new_lang[13] /* only 1 db to choose */
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  IF cache_db_l[1] <> olname AND
    (user_env[1] = "new"
    OR (user_env[1] = "sys" AND user_dbname <> cache_db_l[1])) THEN
    MESSAGE new_lang[14] '"' + cache_db_l[1] + '"'. /* auto-switch to db... */
END.

IF choice = ? THEN
DO:
    /* Adjust the graphical rectangle and the ok and cancel buttons */
   {adecomm/okrun.i  
      &FRAME  = "FRAME schema_stuff" 
      &BOX    = "rect_Btns"
      &OK     = "btn_OK" 
      {&CAN_BTN}
      {&HLP_BTN}
   }

   /* Setup header line for select list */
   lsthead = STRING("Logical Name",    "x(14)") +
	     STRING("Physical Name",   "x(28)") +
	     STRING("Type",            "x(12)") +
	     STRING("Schema Holder",   "x(15)") +
	     STRING("Conn",            "x(4)").
   
   /* Fill the select list of dbs with values from the cache. */
   DO ix = 1 TO cache_db#:
      item = (STRING(SUBSTR(cache_db_l[ix],1,13,"character"), "x(14)") + 
	      STRING(IF cache_db_p[ix] = ? 
      	       	     	THEN "" 
      	       	        ELSE SUBSTR(cache_db_p[ix],1,27,"character"), "x(28)") +
	      STRING(cache_db_e[ix], "x(12)") +
	      STRING(SUBSTR(cache_db_s[ix],1,14,"character"), "x(15)") +
	      STRING(CONNECTED(cache_db_l[ix]), "yes/no")).
      stat = dlist:ADD-LAST(item) IN FRAME schema_stuff.
      IF cache_db_l[ix] = user_dbname THEN
	 dlist = item.  /* This will be the default choose */
   END.
   if dlist = "" OR dlist = ? then
      dlist = dlist:ENTRY(1) IN FRAME schema_stuff.
   
   DISPLAY lsthead WITH FRAME schema_stuff.
   cancel = yes.
   DO ON ENDKEY UNDO, LEAVE:
      UPDATE dlist btn_OK btn_Cancel btn_Help WITH FRAME schema_stuff.
      choice = dlist:LOOKUP(dlist) IN FRAME schema_stuff.
      cancel = no.
   END.
   IF choice = ? THEN choice = old_db.
END.

IF cancel THEN DO:
   user_path = "".
   HIDE FRAME schema_stuff NO-PAUSE.
   RETURN.
END.
dbpick = cache_db_l[choice].

IF is_dis THEN _discon: DO: /*-----------------------------*/ /* disconnect */
  answer = FALSE.
  MESSAGE new_lang[1] + ' "' + dbpick + '"?' 
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
  IF NOT answer THEN DO:
    MESSAGE new_lang[2] VIEW-AS ALERT-BOX. /* nothing disconnected */
    user_path = "".
    LEAVE _discon.
  END.
  /* If dictionary was started from Fast Track, return here.     */
  /* (Disconnecting within Fast Track doesn't make sense because */
  /* file-caching is done at startup-time when ft.p is run.      */
  IF fast_track THEN DO:
    MESSAGE new_lang[21] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    PAUSE.
    RETURN.
  END.
  DISCONNECT VALUE(dbpick).
  RUN "prodict/_dctsget.p". /* recache list */
  MESSAGE dbpick new_lang[4] VIEW-AS ALERT-BOX. /* disconnected */
  IF  (        user_dbname  = dbpick 
    OR SDBNAME(user_dbname) = dbpick )
    THEN DO:
    ASSIGN
      user_dbname   = ""
      user_dbtype   = ""
      user_filename = "".

    /* recount the residing db's:                                   */
    /* if disconnecting a shemaholder, then don't count NEITHER the */
    /* schemaholder NOR its schemas; else don't count only the      */
    /* disconnected db                                              */
    ASSIGN j = 0.
    DO i = 1 TO cache_db#:
      IF  ( cache_db_l[i] <> dbpick
        OR  cache_db_t[i] <> "PROGRESS" )
        AND cache_db_s[i] <> dbpick       
        THEN j = j + 1.
    END.

    if j > 1 then assign user_path = "*C,1=get,_guisget" + user_path.
    DISPLAY user_dbname user_filename WITH FRAME user_ftr.
  END.
END. /*---------------------------------------------------------------------*/
ELSE
DO: /*---------------------------------------------------------*/ /* select */
  ASSIGN
    user_dbname   = dbpick
    user_dbtype   = cache_db_t[choice]
    cache_dirty   = TRUE
    user_filename = ""
    drec_db       = ?
    drec_file     = ?.
  { prodict/user/usercon.i user_filename }

  CREATE ALIAS "DICTDB" FOR DATABASE VALUE(cache_db_s[choice]) NO-ERROR.
  IF LDBNAME("DICTDBG") <> ? THEN DELETE ALIAS "DICTDBG".
  IF user_dbtype = "PROGRESS" THEN
    dbpick = ?.
  ELSE IF CONNECTED(dbpick) THEN
    CREATE ALIAS "DICTDBG" FOR DATABASE VALUE(dbpick) NO-ERROR.
  RUN "prodict/_dctsset.p" (dbpick).

  IF NOT CONNECTED(user_dbname) AND CAN-DO(DATASERVERS,user_dbtype) THEN DO: 
    answer = TRUE.
    MESSAGE new_lang[10] + ' "' + user_dbname + '"' new_lang[11] SKIP
      	    new_lang[22]
      	    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
    IF answer THEN user_path = "*C,1=usr,_usrscon".
  END.

END. /*---------------------------------------------------------------------*/

HIDE FRAME schema_stuff NO-PAUSE.


&ENDIF /*"{&WINDOW-SYSTEM}" <> "TTY"*/
