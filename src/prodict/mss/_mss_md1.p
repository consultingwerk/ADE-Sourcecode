/***********************************************************************
* Copyright (C) 2000,2006,2011 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

/* Procedure created  from odb/_odb_md1.p for MS SQL Server 7 Database
   Donna L. McMann
   
   History:  Added logic not to support old versions D. McMann
             Added -Dsrv switch to connection parameter
             Output messages in batch mode to stream
*/

&SCOPED-DEFINE DATASERVER                 YES
&SCOPED-DEFINE FOREIGN_SCHEMA_TEMP_TABLES INCLUDE
{ prodict/dictvar.i NEW }
&UNDEFINE FOREIGN_SCHEMA_TEMP_TABLES
&UNDEFINE DATASERVER

{ prodict/user/uservar.i }
{ prodict/user/userhue.i NEW }
{ prodict/user/userhdr.f NEW }
{ prodict/mss/mssvar.i }


DEFINE VARIABLE c            AS CHARACTER NO-UNDO.
DEFINE VARIABLE i            AS INTEGER   NO-UNDO.
DEFINE VARIABLE j            AS INTEGER   NO-UNDO.
DEFINE VARIABLE l_debug      AS logical   NO-UNDO INIT FALSE.
DEFINE VARIABLE md1_conparms AS CHARACTER NO-UNDO. 
DEFINE VARIABLE conp1        AS CHARACTER NO-UNDO.
DEFINE VARIABLE conp2        AS CHARACTER NO-UNDO.
DEFINE VARIABLE conp3        AS CHARACTER NO-UNDO. 
DEFINE VARIABLE user_env_save22 AS CHARACTER NO-UNDO.
DEFINE VARIABLE user_env_save25 AS CHARACTER NO-UNDO.
DEFINE VARIABLE user_env_save28 AS CHARACTER NO-UNDO.
DEFINE VARIABLE user_env_save29 AS CHARACTER NO-UNDO.
DEFINE VARIABLE user_env_save5 AS CHARACTER NO-UNDO.
DEFINE VARIABLE user_env_save26 AS CHARACTER NO-UNDO.
DEFINE VARIABLE user_env_save31 AS CHARACTER NO-UNDO.

DEFINE VARIABLE connection_string as CHARACTER NO-UNDO.

DEFINE STREAM code.
OUTPUT STREAM code TO VALUE("enable.sql") NO-ECHO NO-MAP.

PROCEDURE connect-schdb:

  IF connection_string = "" OR connection_string = ? THEN 
    CONNECT  VALUE (mss_dbname)
       -dt VALUE (user_dbtype)
       -ld VALUE (mss_pdbname).

  ELSE IF mss_password = "" or mss_password = ? THEN 
    CONNECT  VALUE (mss_dbname)
         -dt VALUE (user_dbtype)
         -ld VALUE (mss_pdbname)
             VALUE (connection_string).
  ELSE 
    CONNECT  VALUE (mss_dbname)
      -dt VALUE (user_dbtype)
      -ld VALUE (mss_pdbname)
          VALUE (connection_string) 
      -P  VALUE (mss_password).

  CREATE ALIAS "DICTDBG" FOR DATABASE VALUE (mss_pdbname) NO-ERROR.
END.

/* connect up the database to work with ------------------------------------*/

CONNECT VALUE (osh_dbname) -1.
CREATE ALIAS "DICTDB" FOR DATABaSE VALUE (osh_dbname).

/* create _db record and load MSS definitions ---------------------------*/

RUN prodict/mss/_mss_md2.p.

ASSIGN
 /* user_dbname = mss_pdbname */
  user_dbtype = "MSS".

md1_conparms = mss_conparms.

IF md1_conparms = "" OR md1_conparms = ? THEN
  md1_conparms = "-Dsrv PRGRS_PROC_TRAN,1".
ELSE 
  md1_conparms = md1_conparms + " -Dsrv PRGRS_PROC_TRAN,1".

IF md1_conparms <> "" and md1_conparms <> ? THEN DO:
  IF mss_username <> "" AND mss_username <> ? THEN
     ASSIGN connection_string = "-U " + mss_username + " " + md1_conparms.
  ELSE
     ASSIGN connection_string = md1_conparms.
END.        
ELSE DO:
  IF mss_username <> "" AND mss_username <> ? THEN
     connection_string = "-U " + mss_username.
END.     

/* Save the user_env variables we will need later.  _mss_pul.p
     reinitializes user_env 
*/
ASSIGN
    user_env_save22 = user_env[22]
    user_env_save28 = user_env[28]
    user_env_save29 = user_env[29]
    user_env_save5  = user_env[5]
    user_env_save26 = user_env[26]
    user_env_save31 = user_env[31].
        
IF not stages[mss_create_objects] THEN RETURN.

/* connect to MSS database ----------------------------------------------*/
/* disconnect-connect is to reload schema cache -- workaround */
DISCONNECT VALUE (osh_dbname).
CONNECT VALUE (osh_dbname) -1.
RUN connect-schdb.
IF PDBNAME("DICTDBG") = ? THEN
  RETURN "undo".

RUN prodict/mss/_mss_sdb.p.

IF RETURN-VALUE = "wrg-ver" THEN DO:
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
    ASSIGN user_path = "*N,1=sys,_usrsget".
  &ELSE
    ASSIGN user_path = "*N,1=sys,_guisget".
  &ENDIF   
  RETURN "wrg-ver".
END.
/* Discconnect again so _db updates are available */
DISCONNECT VALUE (osh_dbname).
CONNECT VALUE (osh_dbname) -1.
/* Reconnect the schema holder */

RUN connect-schdb.

RUN "prodict/mss/_sndinfo.p".

/*
 * Create the schema in Database.
 */
RUN "prodict/gate/_snd_sql.p"
      ( INPUT user_env[31],
        INPUT l_debug,
        INPUT mss_pdbname,
        INPUT user_dbtype,
        INPUT user_env[5],
        INPUT user_env[26],
        INPUT osh_dbname + ".sql"
      ).

IF SESSION:BATCH-MODE and NOT logfile_open THEN DO:
   OUTPUT STREAM logfile TO VALUE(user_env[2] + ".log") 
       APPEND UNBUFFERED NO-ECHO NO-MAP.
   logfile_open = true.
END.

stages_complete[mss_create_objects] = TRUE.
IF not stages[mss_build_schema] THEN RETURN.

IF SESSION:BATCH-MODE AND logfile_open THEN 

   PUT STREAM logfile UNFORMATTED
       " " skip 
       "-- ++ " skip
       "-- Getting List of Objects from foreign DB Schema" skip
       "-- -- " skip(2).

/*
** Create a list of all the appropriate objects we want from
** the MS Sql Server database.
*/

assign
  s_name-hlp   = "*"
  s_owner-hlp  = "%%%" + mss_username
  s_qual-hlp   = "*"
  s_type-hlp   = "*"
  user_env[25] = "AUTO".
RUN prodict/mss/_mss_get.p.

IF SESSION:BATCH-MODE AND logfile_open THEN 

   PUT STREAM logfile UNFORMATTED
       " " skip 
       "-- ++ " skip
       "-- Importing Objects into the {&PRO_DISPLAY_NAME} Schema Holder" skip
       "-- -- " skip(2).


/* 
** Create a procedure for pulling constraints
*/
RUN prodict/mss/procbfrpul.p.

/*
** Pull objects from sybase schema.
*/
RUN prodict/mss/_mss_pul.p.

/*
** Create objects in the schema holder to match objects in sybase.
*/
RUN prodict/gate/_gat_cro.p.

stages_complete[mss_build_schema] = TRUE.

IF not stages[mss_fixup_schema] THEN RETURN.

/* destroy time fields, then load up progress database changes --------------*/


ASSIGN
    user_env[22]    = user_env_save22
    user_env[28]    = user_env_save28 
    user_env[29]    = user_env_save29
    user_env_save25 = user_env[25]
    user_env[25]    = "**all**"
    user_env[5]     = user_env_save5  
    user_env[26]    = user_env_save26 
    user_env[31]    = user_env_save31.
    
    
IF movedata THEN DO:
   FOR EACH s_ttb_tbl WHERE s_ttb_tbl.ds_type = "TABLE":
        PUT STREAM code UNFORMATTED "ALTER TABLE " + s_ttb_tbl.ds_name + " CHECK CONSTRAINT ALL" SKIP. 
        PUT STREAM code UNFORMATTED user_env[5] SKIP.
   END.
END.

IF SESSION:BATCH-MODE and logfile_open THEN
    PUT STREAM logfile UNFORMATTED
        " " skip
        "-- ++ " skip
        "-- Fixing schema to resemble original {&PRO_DISPLAY_NAME} database." skip
        "-- -- " skip(2).

RUN prodict/mss/_mss_md5.p (osh_dbname, 
                            pro_dbname, 
                            pro_conparms, 
                            user_env[22]).

ASSIGN
    user_env[25] = user_env_save25
    stages_complete[mss_fixup_schema] = TRUE. 

RETURN.







