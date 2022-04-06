/***********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

/* this program assumes that it has an empty progress database.  it
then connects to an odbc database and proceeds to suck over the
definitions for all tables defined to have an owner matching the value
of the variable 'odb_username' 

History:  DLM  09/01/98 Changed Connect not to require a -U parameter
          DLM  09/17/98 Changed how th -U parameter is added when connect parms
                        are present 

*/

&SCOPED-DEFINE DATASERVER                 YES
&SCOPED-DEFINE FOREIGN_SCHEMA_TEMP_TABLES INCLUDE
{ prodict/dictvar.i NEW }
&UNDEFINE FOREIGN_SCHEMA_TEMP_TABLES
&UNDEFINE DATASERVER

{ prodict/user/uservar.i }
{ prodict/user/userhue.i NEW }
{ prodict/user/userhdr.f NEW }
{ prodict/odb/odbvar.i }


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

DEFINE VARIABLE connection_string as CHARACTER NO-UNDO.

PROCEDURE connect-schdb:
  IF connection_string = "" OR connection_string = ? THEN 
    CONNECT  VALUE (odb_pdbname)
       -dt VALUE (user_dbtype)
       -ld VALUE (odb_dbname).

  ELSE IF odb_password = "" or odb_password = ? THEN 
    CONNECT  VALUE (odb_pdbname)
         -dt VALUE (user_dbtype)
         -ld VALUE (odb_dbname)
             VALUE (connection_string).
  ELSE 
    CONNECT  VALUE (odb_pdbname)
      -dt VALUE (user_dbtype)
      -ld VALUE (odb_dbname)
          VALUE (connection_string) 
      -P  VALUE (odb_password).

  CREATE ALIAS "DICTDBG" FOR DATABASE VALUE (odb_dbname) NO-ERROR.
END.

/* connect up the database to work with ------------------------------------*/
CONNECT VALUE (osh_dbname) -1.
CREATE ALIAS "DICTDB" FOR DATABaSE VALUE (osh_dbname).

/* create _db record and load odbc definitions ---------------------------*/

RUN prodict/odb/_odb_md2.p.

ASSIGN
  user_dbname = odb_dbname
  user_dbtype = {adecomm/ds_type.i
                  &direction = "etoi"
                  &from-type = "user_env[22]"
                  }.

md1_conparms = odb_conparms.
IF user_env[22] = "MS SQL Server" THEN DO:
   /* for M/S SQL Server, need to execute commands to create tables in another 
           connection, so we add the PRGRS_PROC_TRAN,1 connection parameter
   */
   IF md1_conparms = "" OR md1_conparms = ? THEN
      md1_conparms = "-Dsrv PRGRS_PROC_TRAN,1".
   ELSE 
      md1_conparms = md1_conparms + " -Dsrv PRGRS_PROC_TRAN,1".
END.

IF md1_conparms <> "" and md1_conparms <> ? THEN DO:
  IF odb_username <> "" AND odb_username <> ? THEN
     ASSIGN connection_string = "-U " + odb_username + " " + md1_conparms.
  ELSE
     ASSIGN connection_string = md1_conparms.
END.        
ELSE DO:
  IF odb_username <> "" AND odb_username <> ? THEN
     connection_string = "-U " + odb_username.
END.     

/* Save the user_env variables we will need later.  _odb_pul.p
     reinitializes user_env 
*/
ASSIGN
    user_env_save22 = user_env[22]
    user_env_save28 = user_env[28]
    user_env_save29 = user_env[29]. 

IF not stages[odb_create_objects] THEN RETURN.

/* connect to odbc database ----------------------------------------------*/
/* disconnect-connect is to reload schema cache -- workaround */
DISCONNECT VALUE (osh_dbname).
CONNECT VALUE (osh_dbname) -1.
RUN connect-schdb.


IF PDBNAME("DICTDBG") = ? THEN
  RETURN "undo".

RUN prodict/odb/_odb_sdb.p.

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

RUN "prodict/odb/_sndinfo.p".

/*
 * Create the schema in the Sybase10 Database.
 */
RUN "prodict/gate/_snd_sql.p"
      ( INPUT user_env[31],
        INPUT l_debug,
        INPUT odb_dbname,
        INPUT user_dbtype,
        INPUT user_env[5],
        INPUT user_env[26],
        INPUT osh_dbname + ".sql"
      ).

IF SESSION:BATCH-MODE and NOT logfile_open THEN DO:
   OUTPUT TO VALUE(user_env[2] + ".log") APPEND UNBUFFERED NO-ECHO NO-MAP.
   logfile_open = true.
END.

stages_complete[odb_create_objects] = TRUE.
IF not stages[odb_build_schema] THEN RETURN.


IF SESSION:BATCH-MODE AND logfile_open THEN 

   PUT UNFORMATTED 
       " " skip 
       "-- ++ " skip
       "-- Getting List of Objects from foreign DB Schema" skip
       "-- -- " skip(2).

/*
** Create a list of all the appropriate objects we want from
** the sybase database.
*/
/*RUN prodict/odb/_odb_md3.p.*/
assign
  s_name-hlp   = "*"
  s_owner-hlp  = odb_username
  s_qual-hlp   = "*"
  s_type-hlp   = "*"
  user_env[25] = "AUTOM".
RUN prodict/odb/_odb_get.p.

IF SESSION:BATCH-MODE AND logfile_open THEN 

   PUT UNFORMATTED 
       " " skip 
       "-- ++ " skip
       "-- Importing Objects into the {&PRO_DISPLAY_NAME} Schema Holder" skip
       "-- -- " skip(2).

/*
** Pull objects from sybase schema.
*/
RUN prodict/odb/_odb_pul.p.

/*
** Create objects in the schema holder to match objects in sybase.
*/
RUN prodict/gate/_gat_cro.p.


stages_complete[odb_build_schema] = TRUE.

IF not stages[odb_fixup_schema] THEN RETURN.

/* destroy time fields, then load up progress database changes --------------*/


ASSIGN
    user_env[22]    = user_env_save22
    user_env[28]    = user_env_save28 
    user_env[29]    = user_env_save29
    user_env_save25 = user_env[25]
    user_env[25]    = "**all**".

IF SESSION:BATCH-MODE and logfile_open THEN
    PUT UNFORMATTED
        " " skip
        "-- ++ " skip
        "-- Fixing schema to resemble original {&PRO_DISPLAY_NAME} database." skip
        "-- -- " skip(2).

RUN prodict/odb/_odb_md5.p (osh_dbname, 
                            pro_dbname, 
                            pro_conparms, 
                            user_env[22]).

ASSIGN
    user_env[25] = user_env_save25
    stages_complete[odb_fixup_schema] = TRUE. 

RETURN.







