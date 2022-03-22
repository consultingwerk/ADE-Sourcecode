/***********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

/* gate_ini - involved in attaching foreign db and misc initialization */

/*
in:  user_env[1]  = "add" or "upd"
     user_env[2]  = dbname to add/update
     user_env[3]  = dbtype (if user_env[1] = "add") (internal format)
     user_env[25] = "AUTO": return-error if not connected
                    ""    : ask user for confirmation 

out: (if successful)
     user_env[1] = userid   or "" to continue with current connection
     user_env[2] = password or "" to continue with current connection
     user_env[3] = dbtype (internal format)
     no other environment variables changed

out: (if unsuccessful)
     user_env[3] = dbtype (internal format)
     no other environment variables changed
     
History:  D. McMann 10/23/02 Replaced BLANK with PASSWORD-FIELD     
          D. McMann 10/17.03 Add NO-LOCK statement to _Db find in support of on-line schema add
*/


{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/user/userhue.i }
{ prodict/user/userhdr.f }
{ prodict/odb/odbvar.i  }


DEFINE VARIABLE adding  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE answer  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE c       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE edbtyp  AS CHARACTER  NO-UNDO. /* db-type external format */
DEFINE VARIABLE i       AS INTEGER    NO-UNDO.
DEFINE VARIABLE j       AS INTEGER    NO-UNDO.
DEFINE VARIABLE lo      AS INTEGER    NO-UNDO.
DEFINE VARIABLE msg     AS CHARACTER  NO-UNDO EXTENT 6.
DEFINE VARIABLE po      AS INTEGER    NO-UNDO.
DEFINE VARIABLE uidpwd  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE canned  AS LOGICAL    NO-UNDO INIT TRUE.

FORM
  SKIP ({&TFM_WID})
  msg[1] AT 8 FORMAT "x(64)" NO-LABEL VIEW-AS TEXT
  msg[2] AT 8 FORMAT "x(64)" NO-LABEL VIEW-AS TEXT
  msg[3] AT 8 FORMAT "x(64)" NO-LABEL VIEW-AS TEXT
  msg[4] AT 8 FORMAT "x(64)" NO-LABEL VIEW-AS TEXT
  msg[5] AT 8 FORMAT "x(64)" NO-LABEL VIEW-AS TEXT
  msg[6] AT 8 FORMAT "x(64)" NO-LABEL VIEW-AS TEXT
  SKIP ({&VM_WIDG})
  user_env[1] COLON 11 LABEL "User ID"   FORMAT "x(60)" {&STDPH_FILL}
  SKIP ({&VM_WID})
  user_env[2] COLON 11 LABEL "Password"  FORMAT "x(60)" PASSWORD-FIELD {&STDPH_FILL}
  {prodict/user/userbtns.i}
  WITH SIDE-LABELS ATTR-SPACE FRAME msg ROW 3 CENTERED 
      DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
      VIEW-AS DIALOG-BOX TITLE "User ID and Password".

/*================================Triggers=================================*/

/*-----WINDOW-CLOSE-----*/
ON WINDOW-CLOSE OF FRAME msg
   APPLY "END-ERROR" TO FRAME msg.


/*----- HELP -----*/
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
ON HELP OF FRAME msg OR CHOOSE of btn_Help IN FRAME msg
DO:
  RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
         	       	    INPUT {&User_ID_Dlg_Box},
      	       	     	    INPUT ?).
END.
&ENDIF

/*=============================Mainline Code===============================*/

ASSIGN 
  adding      = ( user_env[1] = "add" )
  user_env[3] = ( IF adding 
                    THEN user_env[3] 
                    ELSE user_dbtype
                )
  edbtyp      = {adecomm/ds_type.i
                  &direction = "itoe"
                  &from-type = "user_env[3]"
                  }.

IF dict_rog THEN DO:
  MESSAGE "The dictionary is in read-only mode - alterations not allowed." SKIP
      VIEW-AS ALERT-BOX WARNING BUTTONS OK.
  ASSIGN user_path = "".  
  RETURN.    
END.

RUN "prodict/_dctsget.p".
DO i = 1 TO cache_db#:
  IF cache_db_t[i] = user_env[3] THEN ASSIGN po = i  lo = lo + 1.
END.

IF adding THEN DO:
  FIND DICTDB._Db WHERE DICTDB._Db._Db-name = user_env[2] NO-LOCK.
  ASSIGN
    user_dbname   = user_env[2]
    user_dbtype   = user_env[3]
    cache_dirty   = TRUE
    user_filename = ""
    drec_file     = ?
    drec_db       = RECID(DICTDB._Db).

END.
ELSE
IF user_dbtype <> user_env[3] THEN DO:
  IF lo = 0 THEN DO:
    ASSIGN
      answer = TRUE
      c      = SUBSTITUTE('You have no &1 schema-holder {&PRO_DISPLAY_NAME} databases '
               + 'connected.  Would you like to make the current database '
               + '"&2" a schema-holder for &1?',edbtyp,user_dbname).
    RUN "prodict/user/_usrdbox.p" (INPUT-OUTPUT answer,?,?,c).
    user_path = (IF answer THEN "1=add,_usrschg,_gat_ini," + user_path ELSE "").
    RETURN.
  END.
  ELSE
  IF lo = 1 THEN DO:
    ASSIGN
      answer = TRUE
      c      = SUBSTITUTE('Your current database type is not &1.  Would you '
               + 'like to switch to &1 database "&2" and continue?',
               edbtyp,cache_db_l[po]).
    RUN "prodict/user/_usrdbox.p" (INPUT-OUTPUT answer,?,?,c).
    IF NOT answer THEN DO:
      user_path = "".
      RETURN.
    END.
    DO TRANSACTION:
      CREATE ALIAS "DICTDB"  FOR DATABASE VALUE(cache_db_s[po]) NO-ERROR.
      CREATE ALIAS "DICTDBG" FOR DATABASE VALUE(cache_db_l[po]) NO-ERROR.
      ASSIGN
        user_dbname   = cache_db_l[po]
        user_dbtype   = user_env[3]
        cache_dirty   = TRUE
        user_path     = "*C," + user_path
        user_filename = ""
        drec_file     = ?.
      RUN "prodict/_dctsset.p" (user_dbname).
    END.
  END.
  ELSE DO:
    ASSIGN
      c = SUBSTITUTE("You are not currently in a &1 database.  There are "
        + "more than one &1 schema-holder databases connected.  "
        + "Please select the appropriate one and then choose this "
        + "option again.",edbtyp).
    RUN "prodict/user/_usrebox.p" (c).
    user_path = "".
    RETURN.
  END.
END.

{ prodict/user/usercon.i }

{ prodict/dictgate.i 
  &action=query 
  &dbtype=user_env[3] 
  &dbrec=? 
  &output=c 
  }
uidpwd = ENTRY(1,c) MATCHES "*u*". /* userid/passwd needed */

IF uidpwd AND CONNECTED(user_dbname) THEN
  msg[1] = 'You are currently connected to &1 database "&2" with user ID '
         + '"&4". Does this user ID have the appropriate privileges? '
         + '(For example, select access is needed on some system tables.)  If so, '
         + 'press [&3] or OK. Otherwise, enter a new user ID and password '
         + 'below, and you will be disconnected and reconnected with the '
         + 'new user ID.'.
ELSE IF NOT uidpwd AND CONNECTED(user_dbname) THEN
  msg[1] = 'You are currently connected to &1 database "&2".'.
ELSE IF uidpwd AND NOT CONNECTED(user_dbname) THEN
  msg[1] = 'You have selected, but are not currently connected to, &1 '
         + 'database "&2".  Please enter a user ID and password to use to '
         + 'connect.  The user ID must have the appropriate privileges. '
         + '(For example, select access is needed on some system tables.)'.
ELSE /* NOT uidpwd AND NOT CONNECTED(user_dbname) THEN */
  msg[1] = 'You have selected, but are not currently connected to, &1 '
         + 'database "&2".'.

ASSIGN
  msg[1]      = SUBSTITUTE(msg[1],
                     edbtyp,user_dbname,KBLABEL("GO"),
                     USERID(user_dbname),ENTRY(8,c))
  user_env[1] = ""
  user_env[2] = "".

{adecomm/okrun.i  
  &FRAME  = "FRAME msg" 
  &BOX    = "rect_Btns"
  &OK     = "btn_OK" 
  {&CAN_BTN}
  {&HLP_BTN}
}

{ prodict/dictsplt.i &src=msg[1] &dst=msg &num=6 &len=63 &chr=" " }
DISPLAY msg[1 FOR 6] WITH FRAME msg.

DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  IF NOT user_env[25] begins "AUTO"
    THEN UPDATE user_env[1 FOR 2] when uidpwd
      	 btn_OK 
      	 btn_Cancel 
      	 {&HLP_BTN_NAME} 
      	 WITH FRAME msg.
    ELSE IF NOT CONNECTED(user_dbname)
      THEN RETURN ERROR. /* leave it up to the calling routine to  */  	 
  canned = FALSE.                      /* handle the error itself! */
END.

HIDE FRAME msg NO-PAUSE.
IF canned AND adding THEN DO:
  MESSAGE "You have selected to cancel the Create DataServer Schema option. " SKIP
          "The information you have entered will be deleted. " SKIP
          VIEW-AS ALERT-BOX WARNING.
  /* "wrg-ver" being used not because it is the wrong version but because it is
        alreday implemented for _usrsdel so I am re-using here also */
  ASSIGN user_env[35] = "wrg-ver".
  IF "{&WINDOW-SYSTEM}" = "TTY" THEN
    ASSIGN user_path = "_usrsdel,*N,1=sys,_usrsget".
  ELSE
    ASSIGN user_path = "_usrsdel,*N,1=sys,_guisget".
END.
ELSE IF canned THEN user_path = "".
IF user_env[1] <> "" THEN
  ASSIGN odb_username = user_env[1].
ELSE
  ASSIGN odb_username = "&4".
RETURN.
