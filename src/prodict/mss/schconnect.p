/***********************************************************************
* Copyright (C) 2000,2006,2011,2013 by Progress Software Corporation.  *
* All rights reserved.  Prior versions of this work may contain        *
* portions contributed by participants of Possenet.                    *
*                                                                      *
***********************************************************************/

/*
Created:   sdash   27/02/2013   schpullmss is the Batch PULL Utility which
                              pulls to Progress database via MS SQL Server.
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
DEFINE VARIABLE user_env_save36 AS CHARACTER NO-UNDO.
DEFINE VARIABLE batch_mode    AS LOGICAL INITIAL NO       NO-UNDO.
DEFINE VARIABLE connection_string as CHARACTER NO-UNDO.
DEFINE VARIABLE p_obj_name            AS CHARACTER NO-UNDO.
DEFINE VARIABLE p_obj_owner            AS CHARACTER NO-UNDO.
DEFINE VARIABLE p_qual            AS CHARACTER NO-UNDO.
DEFINE VARIABLE tmp_str1          AS CHARACTER NO-UNDO.
DEFINE VARIABLE ClustAsROWID     AS LOGICAL    NO-UNDO INITIAL TRUE.
DEFINE VARIABLE OSchema       AS CHARACTER NO-UNDO.
DEFINE VARIABLE FSchema       AS CHARACTER NO-UNDO.

batch_mode = SESSION:BATCH-MODE.

IF OS-GETENV("MSSOBJNAME") <> ? THEN
    ASSIGN p_obj_name = OS-GETENV("MSSOBJNAME").

IF OS-GETENV("MSSOBJOWNER") <> ? THEN
    ASSIGN p_obj_owner = OS-GETENV("MSSOBJOWNER").

IF OS-GETENV("MSSOBJQUALIFIER") <> ? THEN
    ASSIGN p_qual = OS-GETENV("MSSOBJQUALIFIER").
 
 IF OS-GETENV("MAPOEDATETIME") <> ? THEN DO:
  tmp_str1 = OS-GETENV("MAPOEDATETIME").
   IF ((tmp_str1 <> ?) AND (tmp_str1 BEGINS "Y")) THEN DO:
   s_datetime = TRUE.
   END.
END.

IF OS-GETENV("MAPTOLOB") <> ? THEN DO:
   tmp_str1 = OS-GETENV("MAPTOLOB").
   IF  (tmp_str1 BEGINS "B") THEN DO:
       s_lob = TRUE.
       s_blobtype = TRUE.
       s_clobtype = FALSE.
   END.
   ELSE IF (tmp_str1 BEGINS "C") THEN DO:
       s_lob = TRUE.
       s_blobtype = FALSE.
       s_clobtype = TRUE.
   END.
   ELSE IF ((tmp_str1 <> "L") OR (tmp_str1 BEGINS "Y")) THEN DO:
       s_lob = TRUE.
       s_blobtype = TRUE.
       s_clobtype = TRUE.
   END.
END.
ELSE DO:
       s_lob = FALSE.
       s_blobtype = FALSE.
       s_clobtype = FALSE.
END.

IF OS-GETENV("MAPTOROWID") <> ? THEN DO:
  tmp_str1 = OS-GETENV("MAPTOROWID").
    IF ((tmp_str1 <> ?) AND (tmp_str1 BEGINS "Y")) THEN DO:
    ASSIGN s_primary = TRUE.
    END.
    ELSE
    ASSIGN s_primary = FALSE.
END.

IF OS-GETENV("GETBESTROWID") <> ? THEN DO:
   tmp_str1 = OS-GETENV("GETBESTROWID").
   IF ((tmp_str1 = "1") OR (tmp_str1 BEGINS "Y")) THEN DO:
       ASSIGN ClustAsROWID = TRUE.
       s_best = 1.
   END.
   ELSE IF (tmp_str1 = "2")  THEN DO:
       ASSIGN ClustAsROWID = TRUE.
       s_best = 2.
   END.
   ELSE DO: 
       ASSIGN ClustAsROWID = FALSE.
   END.
END.

 IF osh_conparms = ""  THEN
      ASSIGN osh_conparms = "<schema holder of current working database>".

 IF mss_conparms = "" THEN
      ASSIGN mss_conparms = "<current working database>".

 IF (s_best = 1 ) THEN 
    ASSIGN OSchema = "yes"
           FSchema = "no".
 ELSE
    ASSIGN OSchema = "no"
          FSchema = "yes".

   PUT STREAM logfile UNFORMATTED
       " " skip
       "MSS to Schema Holder Log" skip(2)
       "Name of Schema Holder Database:         " osh_dbname skip
       "Conn. parameters for schema Holder:     " osh_conparms skip
       "Logical Database Name:                  " mss_pdbname SKIP
       "ODBC Data Source Name:                  " mss_dbname SKIP
       "MSS Username:                           " mss_username skip
       "Conn. parameters for logical DB:        " mss_conparms skip
       "Codepage for Schema Image:              " mss_codepage SKIP
       "Collation Name:                         " mss_collname SKIP
       "Insensitive:                            " mss_incasesen SKIP
       "Object Name:                            " p_obj_name SKIP
       "Object Owner:                           " p_obj_owner SKIP
       "Object Qualifier                        " p_qual SKIP
       "Default to OpenEdge DATETIME            " s_datetime SKIP
       "Default to OpenEdge LOB for:            " s_lob SKIP
       "                              CLOB      " s_clobtype SKIP
       "                              BLOB      " s_blobtype SKIP
       "Dsg. Primary/Clustred index as ROWID:   " s_primary SKIP
       "Select 'Best' ROWID Index Using:        " ClustAsROWID SKIP
       "                         OE Schema      " OSchema SKIP
       "                    Foreign schema      " FSchema SKIP.	

 IF osh_conparms =  "<schema holder of current working database>" THEN
      ASSIGN osh_conparms = "".

 IF mss_conparms = "<current working database>" THEN
      ASSIGN mss_conparms = "".

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

/* connect up the database to work with */
CONNECT VALUE (osh_dbname) VALUE (osh_conparms) VALUE (mss_conparms).
CREATE ALIAS "DICTDB" FOR DATABASE VALUE (osh_dbname).

/* create _db record and load MSS definitions */

RUN prodict/mss/_mss_md2.p.

ASSIGN
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
    user_env_save31 = user_env[31]
    user_env_save36 = user_env[36].

IF not stages[mss_create_objects] THEN RETURN.

/* connect to MSS database */
/* disconnect-connect is to reload schema cache */
DISCONNECT VALUE (osh_dbname).
CONNECT VALUE (osh_dbname) VALUE (osh_conparms) VALUE (mss_conparms).
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
CONNECT VALUE (osh_dbname) VALUE (osh_conparms) VALUE (mss_conparms).

/* Reconnect the schema holder */
RUN connect-schdb.

RUN "prodict/mss/_sndinfo.p".

IF SESSION:BATCH-MODE and NOT logfile_open THEN DO:
   OUTPUT STREAM logfile TO VALUE(user_env[2] + ".log") 
       APPEND UNBUFFERED NO-ECHO NO-MAP.
   logfile_open = true.
END.

stages_complete[mss_create_objects] = TRUE.
IF not stages[mss_build_schema] THEN RETURN.

IF SESSION:BATCH-MODE AND logfile_open THEN DO:
   PUT STREAM logfile UNFORMATTED
       " " skip 
       "-- ++ " skip
       "-- Getting List of Objects from foreign DB Schema" skip
       "-- -- " skip(2).
    PUT STREAM logfile UNFORMATTED
      "Object Type" at 14
      "Object Owner" at 28
      "Object Name" at 44 skip(1).
   END.
/*
** Create a list of all the appropriate objects we want from
** the MS Sql Server database.
*/

ASSIGN
  s_name-hlp   = "*"
  /* in case of batch pull s_owner-hlp is not neded */
  /* This is also not used in case of regular pull */
  /* s_owner-hlp  = "%%%" + mss_username */
  s_qual-hlp   = "*"
  s_type-hlp   = "*".

  IF SESSION:BATCH-MODE THEN
    /* Updated 12 Fields in user_env[25] */
             user_env[25] = "AUTO," + p_obj_name + "," + p_obj_owner + "," +  "*," + p_qual + ","
	                                + string(s_datetime) + ","+ string(s_primary) + ","
                                        + string(s_lob) + "," + string(s_blobtype) + "," 
					+ string(s_clobtype) + "," + string(ClustAsROWID) + "," 
					+ string(s_best).
  ELSE
   /* Updated 9 Fields in user_env[25] */
    user_env[25] = p_obj_name + "," + p_obj_owner + "," + p_qual + ","
                    + string(s_datetime) + ","+ string(s_primary) + ","
                    + string(s_lob) + "," + string(s_blobtype) + ","
		    + string(s_clobtype) + "," + string(s_best).  

RUN prodict/mss/_mss_get.p.

/* Pull objects from MSS.*/
RUN prodict/mss/_mss_pul.p.

IF SESSION:BATCH-MODE AND logfile_open THEN 
   PUT STREAM logfile UNFORMATTED
       " " skip 
       "-- ++ " skip
       "-- Importing Objects into the {&PRO_DISPLAY_NAME} Schema Holder." skip
       "-- -- " skip(2).

/* Create objects in the schema holder to match objects in MSS. */
RUN prodict/gate/_gat_cro.p.

RETURN.
