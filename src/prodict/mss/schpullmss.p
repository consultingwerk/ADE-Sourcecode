/*********************************************************************
* Copyright (C)	2013 by	Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions	     *
* contributed by participants of Possenet.			     *
*								     *
*********************************************************************/

/*
Created:   sdash   27/02/2013	schpullmss is the Batch	PULL Utility which
			      pulls to Progress	database via MS	SQL Server.
*/

&SCOPED-DEFINE DATASERVER YES
&SCOPED-DEFINE FOREIGN_SCHEMA_TEMP_TABLES INCLUDE
{ prodict/user/uservar.i NEW}
{ prodict/dictvar.i NEW}
{ prodict/mss/mssvar.i NEW}
DEFINE VARIABLE	input-db       AS CHARACTER		  NO-UNDO.
DEFINE VARIABLE	olddb	       AS CHARACTER		  NO-UNDO.
DEFINE VARIABLE	batch_mode    AS LOGICAL INITIAL NO	  NO-UNDO.
DEFINE VARIABLE	err-rtn	      AS LOGICAL INITIAL FALSE	  NO-UNDO.
DEFINE VARIABLE	db_exist      AS LOGICAL		  NO-UNDO.
DEFINE VARIABLE	wait	      AS CHARACTER		  NO-UNDO.
DEFINE VARIABLE	tmp_str	      AS CHARACTER		  NO-UNDO.
DEFINE VARIABLE	msg_prefix    AS CHARACTER		  NO-UNDO.
DEFINE VARIABLE	msg_suffix    AS CHARACTER		  NO-UNDO.
DEFINE VARIABLE	mss_prefix    AS CHARACTER		  NO-UNDO.
DEFINE VARIABLE	dlc_utf_edb   AS CHARACTER		  NO-UNDO.
DEFINE VARIABLE	i	      AS INTEGER		  NO-UNDO.
DEFINE VARIABLE	md1_conparms  AS CHARACTER		  NO-UNDO.
DEFINE VARIABLE	casesen	      AS LOGICAL		  NO-UNDO.
DEFINE VARIABLE	output_file   AS CHARACTER		  NO-UNDO.
DEFINE VARIABLE	redo	      AS LOGICAL		  NO-UNDO.
DEFINE VARIABLE	old-dictdb    AS CHARACTER		  NO-UNDO.
DEFINE VARIABLE	createdb      AS CHARACTER		  NO-UNDO.
DEFINE VARIABLE	connection_string      AS CHARACTER	  NO-UNDO.
DEFINE VARIABLE	wrg-ver	      AS LOGICAL INITIAL FALSE	  NO-UNDO.
DEFINE VARIABLE	redoblk	      AS LOGICAL INITIAL FALSE	  NO-UNDO.

output_file= "schpullmss.log".
OUTPUT STREAM logfile TO VALUE(output_file) NO-ECHO NO-MAP UNBUFFERED.
logfile_open = true. 

batch_mode = SESSION:BATCH-MODE.
										
FORM
osh_dbname   FORMAT "x(256)"  view-as fill-in size 32 by 1
    LABEL "Name	of Schema Holder Database" colon 36 SKIP ({&VM_WID}) 
osh_conparms FORMAT "x(256)" view-as fill-in size 32 by	1 
    LABEL "Conn	Params for schema holder" colon	36 SKIP	({&VM_WID})
mss_pdbname  FORMAT "x(32)" VIEW-AS FILL-IN SIZE 32 BY 1	
    LABEL "Logical Database Name" COLON	36 SKIP({&VM_WID}) 
mss_dbname   FORMAT "x(32)"  view-as fill-in size 32 by	1 
    LABEL "ODBC	Data Source Name" colon	36 SKIP	({&VM_WID}) 
mss_username  FORMAT "x(32)" VIEW-AS FILL-IN SIZE 32 BY	1	
    LABEL "Username" COLON 36 SKIP({&VM_WID}) 
mss_password   FORMAT "x(32)" PASSWORD-FIELD view-as fill-in size 32 by	1 
    LABEL "User's Password" colon 36 SKIP ({&VM_WID}) 
mss_conparms FORMAT "x(256)" view-as fill-in size 32 by	1 
    LABEL "Conn	Params for logical database" colon 36 SKIP ({&VM_WID})
mss_codepage FORMAT "x(32)" view-as fill-in size 15 by 1
    LABEL "Codepage" colon 36 SKIP({&VM_WID})
mss_collname FORMAT "x(32)"  view-as fill-in size 15 by	1
    LABEL "Collation"  COLON 36	SKIP({&VM_WID})	 
mss_incasesen  LABEL "Insensitive" COLON 36 SKIP({&VM_WID})
    {prodict/user/userbtns.i}
WITH FRAME x ROW 1 CENTERED SIDE-labels	OVERLAY
  DEFAULT-BUTTON btn_OK	CANCEL-BUTTON btn_Cancel
   &IF "{&WINDOW-SYSTEM}" <> "TTY"
   &THEN VIEW-AS DIALOG-BOX 
   &ENDIF 
   TITLE "{&PRO_DISPLAY_NAME} MS SQL Server Schema Pull".

FORM
  wait FORMAT "x" LABEL
  "Connecting -	Please wait"
  WITH FRAME table-wait	ROW SCREEN-LINES - 2 COLUMN 1 NO-BOX OVERLAY
  &IF "{&WINDOW-SYSTEM}" <> "TTY"
  &THEN	VIEW-AS	DIALOG-BOX &ENDIF.

ON WINDOW-CLOSE	of FRAME x
   APPLY "END-ERROR" to	FRAME x.

/*  TBD:NEW HELP ID FOR	THIS SCREEN  */
&IF "{&WINDOW-SYSTEM}"<> "TTY" &THEN   
on CHOOSE of btn_Help in frame x
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
			     INPUT {&PROGRESS_DB_to_SQL_Dlg_Box},
			     INPUT ?).
&ENDIF

IF LDBNAME ("DICTDB") <> ? THEN
  ASSIGN osh_dbname = LDBNAME ("DICTDB").

IF LDBNAME ("DICTDBG") <> ? THEN
  ASSIGN mss_pdbname = LDBNAME ("DICTDBG").

IF NOT batch_mode THEN DO:
   {adecomm/okrun.i  
       &FRAME  = "FRAME	x" 
       &BOX    = "rect_Btns"
       &OK     = "btn_OK" 
       {&CAN_BTN}
   }
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
   btn_Help:visible IN FRAME x = yes.
  &ENDIF
END.

 IF OS-GETENV("SHDBNAME") <> ? THEN
  osh_dbname   = OS-GETENV("SHDBNAME").

 IF OS-GETENV("SHCONPARMS")   <> ? THEN
  osh_conparms = OS-GETENV("SHCONPARMS").
  ELSE
  ASSIGN osh_conparms = "<schema holder	of current working database>".

  IF OS-GETENV("MSSPDBNAME")   <> ? THEN
  mss_pdbname =	OS-GETENV("MSSPDBNAME").

 IF OS-GETENV("MSSDBNAME")   <>	? THEN
  mss_dbname   = OS-GETENV("MSSDBNAME").

 IF OS-GETENV("MSSUSERNAME") <>	? THEN
  mss_username = OS-GETENV("MSSUSERNAME").

 IF OS-GETENV("MSSPASSWORD") <>	? THEN
  mss_password = OS-GETENV("MSSPASSWORD").

 IF OS-GETENV("MSSCONPARMS") <>	? THEN
  mss_conparms = OS-GETENV("MSSCONPARMS").
 ELSE
  mss_conparms = "<current working database>".

 IF OS-GETENV("MSSCODEPAGE") <>	? THEN 
  mss_codepage = OS-GETENV("MSSCODEPAGE").
 ELSE
  ASSIGN mss_codepage =	session:cpinternal.

 IF OS-GETENV("MSSCOLLNAME") <>	? THEN 
     mss_collname = OS-GETENV("MSSCOLLNAME").
ELSE
     ASSIGN mss_collname = session:CPCOLL.

 IF OS-GETENV("MSSCASESEN") <> ? THEN DO:
     ASSIGN tmp_str = OS-GETENV("MSSCASESEN").
  IF tmp_str BEGINS "Y"	THEN 
     ASSIGN mss_incasesen = FALSE.
  ELSE
     ASSIGN mss_incasesen = TRUE.
END.
 ELSE
     ASSIGN mss_incasesen = TRUE.

/* Make assignments now that use of DICTDB/DICTDBG have	been validated */
IF LDBNAME ("DICTDBG") <> ? THEN DO:
   IF NOT batch_mode THEN DO:
	 &IF "{&WINDOW-SYSTEM}"	= "TTY"	&THEN 
	   ASSIGN mss_pdbname =	LDBNAME("DICTDBG")
		  mss_conparms = "<current working database>"
		  mss_dbname = PDBNAME("DICTDBG")
		  mss_username = ""
		  mss_password = ""
		  osh_dbname = SDBNAME("DICTDBG")
		  osh_conparms = "<schema holder of current working database>".
	 &ENDIF.
    END.
 END.

/* If this is not batch	mode, allow override of	environment variables. */
IF NOT batch_mode THEN DO:
  _updtvar:
  DO WHILE TRUE:
     UPDATE osh_dbname
	osh_conparms
	mss_pdbname
	mss_dbname
	mss_username
	mss_password
	mss_conparms
	mss_codepage
	mss_collname
	mss_incasesen
	btn_OK btn_Cancel 
	&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
	    btn_Help
	&ENDIF
	WITH FRAME x.
    IF osh_dbname = "" OR osh_dbname = ? THEN DO:
	MESSAGE "Schema holder database Name is required." VIEW-AS ALERT-BOX ERROR.
	NEXT _updtvar.
      END.
    IF mss_pdbname = "" OR mss_pdbname = ? THEN DO:
	MESSAGE "Logical Database Name is required." VIEW-AS ALERT-BOX ERROR.
	NEXT _updtvar.
      END.
    IF mss_dbname = "" OR mss_dbname = ? THEN DO:
	MESSAGE "ODBC Data Source Name is required." VIEW-AS ALERT-BOX ERROR.
	NEXT _updtvar.
      END.
    LEAVE _updtvar.
  END.
END.

 ASSIGN input-db = osh_dbname.

/*If no env. var set for logical database*/
IF mss_pdbname = "" OR mss_pdbname = ? THEN DO:
    IF LDBNAME("DICTDBG") <> ? THEN DO:
	
	/* Connected logical db must be MSS database type */ 
	IF DBTYPE("DICTDBG") <> "MSS" THEN DO:
	   IF batch_mode THEN
	     PUT STREAM logfile UNFORMATTED "Database type for Logical Database " mss_pdbname " is not MSS." skip(1).
	   ELSE DO:
	         &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
	              PUT STREAM logfile UNFORMATTED "Database type for Logical Database" mss_pdbname "is not MSS." skip(1).
	         &ELSE
	              MESSAGE "Database type for Logical Database " mss_pdbname "is not MSS." VIEW-AS ALERT-BOX ERROR.
	         &ENDIF.
	   END.
	   UNDO, RETURN error.
	END.
	
	/* set message prefix if there are missing parameters */
	msg_prefix = "Missing Prameter". 
	IF osh_dbname <> "" AND osh_dbname <> ? THEN 
	    msg_suffix = "Schema Holder Database Name.".
	
	IF osh_conparms <> "" AND osh_conparms <> ? THEN DO:
	    IF msg_prefix <> ? THEN msg_prefix = msg_prefix + ", ".
	    mss_prefix = msg_prefix + "Schema Holder Connection	Parameters.".
	END.
	
	IF mss_conparms <> "" AND mss_conparms <> ? THEN DO:
	    IF msg_prefix <> ? THEN msg_prefix = msg_prefix + ", ".
	    mss_prefix = msg_prefix + "Logical Database Connection Parameters.".
	END.
	
	IF mss_username	<> "" AND mss_username <> ? THEN DO:
	    IF msg_prefix <> ? THEN msg_prefix = msg_prefix + ", ".
	    mss_prefix = msg_prefix + "Foreign database user name.".
	END.
	
	IF mss_password	<> "" AND mss_password <> ? THEN DO:
	    IF msg_prefix <> ? THEN msg_prefix = msg_prefix + ", ".
	    mss_prefix = msg_prefix + "Foreign database password.".
	END.
	
	IF mss_dbname <> "" AND mss_dbname <> ? THEN DO:
	    IF msg_prefix <> ? THEN msg_prefix = msg_prefix + ", ".
	    mss_prefix = msg_prefix + "ODBC Data Source Name.".
	END.

	IF batch_mode THEN
	     PUT STREAM logfile UNFORMATTED msg_prefix + ": should not be set without specifying a logical database name." SKIP(1).
	ELSE DO:
	     &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
	         MESSAGE msg_prefix + ": should not be set without specifying a logical database name." SKIP(1).
	     &ELSE
	         MESSAGE msg_prefix + ": should not be set without specifying a logical database name." VIEW-AS ALERT-BOX ERROR.
	     &ENDIF.
	END.
        UNDO, RETURN error.
   END.
   ELSE DO:
	IF batch_mode THEN
	     PUT STREAM logfile UNFORMATTED "Logical database name must be specified if logical database is not the current working database." skip(1).
	ELSE DO:
	     &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
	       MESSAGE "Logical database name must be specified if logical database is not the current working database." skip(1).
	     &ELSE
	       MESSAGE "Logical database name must be specified if logical database is not the current working database." VIEW-AS ALERT-BOX ERROR.
	     &ENDIF.
	END.
        UNDO, RETURN error.
   END.
END.

/* If no env. var. set for schema holder database */
IF osh_dbname = "" OR osh_dbname = ? THEN DO:
    IF LDBNAME("DICTDB") <> ? THEN DO:
      IF osh_conparms <> "" AND osh_conparms <> ? THEN DO:
	/* Accept DICTDB only if no connect parameters are specified */ 
	IF batch_mode THEN
	      PUT STREAM logfile UNFORMATTED "Schema holder connection parameters should not be set without specifying a schema holder database name." skip(1).
	ELSE DO:
	    &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
	      PUT STREAM logfile UNFORMATTED "Schema holder connection parameters should not be set without specifying a schema holder database name." skip(1).
	    &ELSE
	      MESSAGE "Schema holder connection parameters should not be set without specifying a schema holder database name." VIEW-AS ALERT-BOX ERROR.
	    &ENDIF.
	END.
	UNDO, RETURN error.
      END.
    END.
    ELSE DO:
        /*Must have a specified schema holder database name without a DICTDB*/
        IF batch_mode THEN
             PUT STREAM logfile UNFORMATTED "Schema holder database name must be specified if there is no current working database." skip(1).
        ELSE DO:
	   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
	     PUT STREAM logfile UNFORMATTED "Schema holder database name must be specified if there is no current working database." skip(1).
	   &ELSE
	     MESSAGE "Schema holder database name must be specified if there is no current working database." VIEW-AS ALERT-BOX ERROR.
	   &ENDIF.
        END.
        UNDO, RETURN error.
    END.
END.

/* At this point there is no connected schema holder nor can one be chosen from connected dbs */
 IF LDBNAME("DICTDB") = ? THEN DO:
   /* If there are no connected dbs, A schema holder must be specified */
   IF osh_dbname = "" OR osh_dbname = ? THEN DO:
	IF batch_mode THEN
	     PUT STREAM logfile UNFORMATTED "Schema holder datbabase must be specified if no existing connections can be used for it" skip(1).
	ELSE DO:
	   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
	     MESSAGE "Schema holder database must be specified if no existing connections can be used for it" skip(1).
	   &ELSE
	     MESSAGE "Schema holder database must be specified if no existing connections can be used for it" VIEW-AS ALERT-BOX ERROR.
	   &ENDIF.
	END.
	UNDO, RETURN error.
   END.
   ELSE DO:  /* If schema holder if specified, search if there is a database with the specified name */
      /* If name has no .db suffix, add it. Needed for search to work correctly.*/
      IF LENGTH(osh_dbname) < 3 THEN 
          osh_dbname = osh_dbname + ".db".
      ELSE IF SUBSTRING(osh_dbname, LENGTH(osh_dbname) - 2) = ".db" THEN
          osh_dbname = osh_dbname + ".db".
      ELSE 
          osh_dbname = osh_dbname + ".db".

      /* If the database does not exist, create it */
      IF SEARCH(osh_dbname) = ? THEN DO:
      /* Need to define a "dlc_utf_edg" AS CHARACTER */
          IF (TRIM(mss_codepage) = "utf-8") THEN DO:
              IF OPSYS = "Win32":U THEN 
                 GET-KEY-VALUE SECTION "Startup":U KEY "DLC":U VALUE dlc_utf_edb. 
                 IF (dlc_utf_edb = ? or dlc_utf_edb EQ "") THEN 
                    dlc_utf_edb = OS-GETENV("DLC").
                 dlc_utf_edb = dlc_utf_edb + "/prolang/utf/empty".
                 CREATE DATABASE osh_dbname FROM dlc_utf_edb.
                 osh_dbname = input-db.
                 PUT STREAM logfile UNFORMATTED osh_dbname " is the empty UTF-8 type schema holder database created." skip(1).
           END.
           ELSE DO:
               CREATE DATABASE osh_dbname FROM "empty".
               osh_dbname = input-db.
               PUT STREAM logfile UNFORMATTED osh_dbname " is the empty schema holder database created." skip(1).
           END.
      END.
      ELSE
         osh_dbname = input-db.
   END.
END.

/* At this point, if osh_dbname is still empty, its an error */
 IF osh_dbname = "" OR osh_dbname = ? THEN DO:
      PUT STREAM logfile UNFORMATTED SKIP.
      ASSIGN err-rtn = TRUE.
      IF batch_mode THEN
            PUT STREAM logfile UNFORMATTED "Schema holder Database Name is required."skip(1).
      ELSE DO:
         &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
            MESSAGE "Schema holder Database Name is required." skip(1).
         &ELSE
            MESSAGE "Schema holder Database Name is required." VIEW-AS ALERT-BOX ERROR.
         &ENDIF
      END.
      UNDO, RETURN error.
 END.

 /* validity check on schema holder */
 IF DBTYPE(osh_dbname) <> "PROGRESS" THEN DO:
    IF "{&WINDOW-SYSTEM}" = "TTY" THEN 
       MESSAGE "Schema holder database " osh_dbname " should be PROGRESS database type, not " DBTYPE(osh_dbname) VIEW-AS ALERT-BOX ERROR.
 END.

/* Name conflict */
IF mss_pdbname = osh_dbname THEN DO:
   IF batch_mode THEN 
      PUT STREAM logfile UNFORMATTED "Logical Database Name " mss_pdbname " must not be the same as schema holder or {&PRO_DISPLAY_NAME} Database Name" skip(1).
   ELSE DO:
      &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
         MESSAGE "Logical Database Name " mss_pdbname " must not be the same as schema holder or {&PRO_DISPLAY_NAME} Database Name" skip(1).
      &ELSE
         MESSAGE "Logical Database name " mss_pdbname " must not be the same as schema holder or {&PRO_DISPLAY_NAME} Database Name" VIEW-AS ALERT-BOX ERROR.
      &ENDIF
   END.
   UNDO, RETURN error.
END.

IF osh_conparms =  "<schema holder of current working database>" THEN
 ASSIGN osh_conparms = "".

IF mss_conparms = "<current working database>" THEN
 ASSIGN mss_conparms = "".

 IF osh_dbname = "" OR osh_dbname = ? THEN DO:
   PUT STREAM logfile UNFORMATTED osh_dbname " Database name is required." SKIP.
   ASSIGN err-rtn = TRUE.
 END.
 ELSE DO:
   IF NOT CONNECTED(osh_dbname) THEN
     CONNECT VALUE (osh_dbname) VALUE (osh_conparms) VALUE (mss_conparms) NO-ERROR.

   IF ERROR-STATUS:ERROR OR NOT CONNECTED (osh_dbname) THEN DO:
     DO i = 1 TO  ERROR-STATUS:NUM-MESSAGES:
         IF batch_mode THEN
           PUT STREAM logfile UNFORMATTED ERROR-STATUS:GET-MESSAGE(i) skip(1).
         ELSE
           MESSAGE ERROR-STATUS:GET-MESSAGE(i) skip(1).
     END.
     IF batch_mode THEN
           PUT STREAM logfile UNFORMATTED "Unable to connect to " osh_dbname "database" skip(1).
     ELSE DO:
         &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
           MESSAGE "Unable to connect to "osh_dbname "database." skip(1).
         &ELSE
           MESSAGE "Unable to connect to " osh_dbname "database" VIEW-AS ALERT-BOX ERROR.
         &ENDIF
     END.
     ASSIGN err-rtn = TRUE.
   END.
   ELSE 
     CREATE ALIAS DICTDB FOR DATABASE VALUE(osh_dbname) NO-ERROR.
 END.

DISCONNECT VALUE(LDBNAME("DICTDB")).

 IF err-rtn THEN RETURN.
  ASSIGN redo = TRUE.

 RUN prodict/mss/schmsstopro.p.

 IF RETURN-VALUE = "indb" THEN DO:
    ASSIGN redo = FALSE.
    UNDO, RETRY.
 END.
 ELSE IF RETURN-VALUE = "wrg-ver" THEN DO:
    ASSIGN wrg-ver = TRUE.
    UNDO, RETRY.
 END.
 ELSE IF RETURN-VALUE = "undo" THEN DO:
    ASSIGN redoblk = TRUE.
    UNDO, RETRY.
 END.

IF logfile_open
THEN OUTPUT STREAM logfile CLOSE.
