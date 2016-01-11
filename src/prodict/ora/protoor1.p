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

/* Procedure prodict/ora/protoor1.p

    Modified 11/12/97 DLM Removed disconnect of Progress Database,
                          input parameters since shared variable were
                          available and added logic not to load sql. 
             01/13/98 DLM Added check for ORACLE version > 7 so that
                          longs will be assigned correctly.  
             08/31/99 DLM Made final message about running .p for TTY
                          the same as for GUI, an alert-box.  
             09/01/99 DLM Assigned user_env[7] = "n" so DEFAULT value
                          will not be put into the Oracle SQL Script.   
             12/6/99  DLM Added assignment to rmvobj to know if this fails
                          if I can delete schema holder or need just to remove
                          database from existing schema holder. 
             02/01/00 DLM Added handling of sqlwidth parameter.        
*/    

{ prodict/user/uservar.i }
{ prodict/ora/oravar.i }

DEFINE VARIABLE cmd           AS CHARACTER           NO-UNDO.
DEFINE VARIABLE wait          AS CHARACTER           NO-UNDO.
DEFINE VARIABLE create_h      AS LOGICAL             NO-UNDO.
DEFINE VARIABLE db_exist      AS LOGICAL             NO-UNDO.
DEFINE VARIABLE batch_mode    AS LOGICAL INITIAL NO  NO-UNDO. 
DEFINE VARIABLE output_file   AS CHARACTER           NO-UNDO.
DEFINE VARIABLE tmp_str       AS CHARACTER           NO-UNDO.
DEFINE VARIABLE l_i           AS INTEGER             NO-UNDO.
DEFINE VARIABLE run_time      AS INTEGER             NO-UNDO.
DEFINE VARIABLE schname       AS CHARACTER           NO-UNDO.

DEFINE STREAM strm.

/*------------------------------------------------------------------*/

assign batch_mode    = SESSION:BATCH-MODE
       run_time      = TIME.

IF batch_mode THEN DO:
   PUT STREAM logfile UNFORMATTED
       " " skip
       "Progress to Oracle Log" skip(2)
       "Original Progress Database:    " pro_dbname skip
       "Other Progress db connect parameters : " pro_conparms  skip
       "Oracle Logical Database:       " ora_dbname skip
       "Version of Oracle:             " ora_version skip
       "Progress Schema Holder name:   " osh_dbname skip
       "Oracle Username:               " ora_username skip
       "Oracle Tablespace for tables:  " ora_tspace skip
       "Oracle Tablespace for indexes: " ora_ispace skip
       "Compatible structure:          " compatible skip
       "Using Sql Width:               " sqlwidth SKIP
       "Create objects in Oracle:      " loadsql skip
       "Moved data to Oracle:          " movedata skip(2).
END.

IF loadsql THEN DO:
 
  IF not batch_mode THEN
     HIDE MESSAGE NO-PAUSE.
  ASSIGN schname = osh_dbname + ".db".
  IF search(schname) <> ? THEN DO:
    CONNECT VALUE(osh_dbname) -1 NO-ERROR.

    if ERROR-STATUS:ERROR then do:
      IF not batch_mode THEN DO:
        &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
            MESSAGE "Can't connect to Database " osh_dbname.
        &ELSE
            MESSAGE "Can't connect to Database " osh_dbname
              VIEW-AS ALERT-BOX ERROR.
        &ENDIF.
      END.       
      ELSE 
          PUT STREAM logfile UNFORMATTED 
               "Can't connect to Database " osh_dbname skip(2).
      UNDO, RETURN error.
    end.
  end.

  IF CONNECTED (osh_dbname) THEN DO:
    ASSIGN rmvobj   = FALSE
           create_h = FALSE.

    CREATE ALIAS DICTDB2 FOR DATABASE VALUE (osh_dbname).
    ASSIGN db_exist = FALSE.
    RUN "prodict/misc/_tstsh.p" (INPUT ora_dbname, OUTPUT db_exist).
    IF db_exist THEN DO:
      IF not batch_mode THEN DO:
        &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
           MESSAGE "Database " ora_dbname " already exists in schema holder " 
                  osh_dbname.
        &ELSE 
           MESSAGE "Database " ora_dbname " already exists in schema holder " 
      	               osh_dbname VIEW-AS ALERT-BOX ERROR.
        &ENDIF
        DISCONNECT VALUE (osh_dbname).
        UNDO, RETURN "indb".
      END. 	                  	           
      ELSE 
         PUT STREAM logfile UNFORMATTED 
            "Database " ora_dbname " already exists in schema holder " 
            osh_dbname skip(2).
          UNDO, RETURN ERROR.
    END. 
    DISCONNECT VALUE (osh_dbname).   
  END. 
  ELSE
    ASSIGN rmvobj = TRUE
           create_h = TRUE.

  IF ora_dbname = pro_dbname OR ora_dbname = osh_dbname THEN DO:
    IF batch_mode THEN 
       PUT STREAM logfile UNFORMATTED 
               "Database " ora_dbname 
               " must not be the same as schema holder or PROGRESS Database"
                skip(2).
    ELSE DO:
      &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
           MESSAGE "Database " ora_dbname 
             " must not be the same as schema holder or PROGRESS Database".
      &ELSE
           MESSAGE "Database " ora_dbname 
             " must not be the same as schema holder or PROGRESS Database"
             VIEW-AS ALERT-BOX ERROR.
      &ENDIF
    END.             
    UNDO, RETURN error.
  END.
END.

IF ora_version > 7 THEN
  ASSIGN user_env[18] = "VARCHAR2".
ELSE
  ASSIGN user_env[18] = "long".
  

ASSIGN user_env[1]  = "ALL"
       user_env[2]  = osh_dbname
       user_env[3]  = ""
       user_env[4]  = "n"
       user_env[5]  = ";"
       user_env[6]  = "y"
       user_env[7]  = "n"
       user_env[8]  = "y"
       user_env[9]  = "ALL"
       user_env[11] = "char" 
       user_env[12] = "date"
       user_env[13] = "number"
       user_env[14] = "number"
       user_env[15] = "number"
       user_env[16] = "number"
       user_env[17] = "number"
       user_env[19] = "number"
       user_env[20] = "##"
       user_env[21] = "y"
       user_env[22] = "ORACLE"
       user_env[23] = "30"
       user_env[24] = "15"
       user_env[25] = "y"
       user_env[26] = ora_username
       user_env[28] = "30"
       user_env[29] = "26"
       user_env[31] = "-- ** "
       user_env[34] = ora_tspace
       user_env[35] = ora_ispace.
    
IF compatible THEN 
   ASSIGN user_env[27] = "y".
ELSE
   ASSIGN user_env[27] = "no".

IF sqlwidth THEN 
   ASSIGN user_env[33] = "y".
ELSE
   ASSIGN user_env[33] = "no".

    /* md0: creates SQL and .d-files */
RUN "prodict/ora/_ora_md0.p".

IF loadsql THEN DO:
  IF create_h THEN DO:
    IF batch_mode THEN DO:
      PUT STREAM logfile UNFORMATTED
              " " skip
              "-- ++ " skip
              "-- Creating empty schema holder " skip
              "-- -- " skip(2).
    END.

    CREATE DATABASE osh_dbname FROM "EMPTY".
  END.

  IF NOT batch_mode THEN
    HIDE FRAME table-wait NO-PAUSE.

  /* md1: creates SI and ORACLE-Schema using send-sql.p
   *      pulls schema into SI
   *      beautifies SI by comparing it and matching it up with 
   *            the original progress-db
   */

  RUN "prodict/ora/_ora_md1.p".
  IF RETURN-VALUE = "1" THEN DO:
    cmd = "Error creating ORACLE Database - Check logfile " + osh_dbname + 
      	  ".log".
    IF NOT Batch_mode THEN
      MESSAGE cmd view-as alert-box.
    ELSE
      PUT STREAM logfile UNFORMATTED  cmd.  
    UNDO, RETURN error.
  END.  

  IF batch_mode and NOT logfile_open THEN DO:
    OUTPUT TO VALUE(output_file) APPEND UNBUFFERED NO-ECHO NO-MAP.
    logfile_open = true.
  END.

  /* See if we were successful. */

  IF NOT CONNECTED (ora_dbname) THEN DO:
    cmd = "Error creating ORACLE Database - Check logfile " + osh_dbname + 
      	  ".log".
    IF NOT Batch_mode THEN
      MESSAGE cmd.
    ELSE
      PUT STREAM logfile UNFORMATTED  cmd.  
    UNDO, RETURN error.
  END.

  ASSIGN cmd = "c" + ora_dbname + ".p".

  OUTPUT STREAM strm TO VALUE (cmd) NO-MAP.

  PUT STREAM strm UNFORMATTED "CONNECT " osh_dbname " -1." SKIP.

  IF ora_conparms <> ? THEN DO:
    IF INDEX(ora_conparms,"@") <> 0 THEN 
         ora_username = ora_username + ora_conparms. 
  END. 

  IF ora_password = "" or ora_password = ? THEN
     PUT STREAM strm UNFORMATTED "CONNECT " ora_dbname " -ld ~"" ora_dbname
        "~" -dt ORACLE -U ~"" ora_username "~"".
  ELSE 
     PUT STREAM strm UNFORMATTED "CONNECT " ora_dbname " -ld ~"" ora_dbname
        "~" -dt ORACLE -U ~"" ora_username "~" -P ~"" ora_password "~"".
 
  IF ora_conparms <> ? THEN DO:
    IF INDEX(ora_conparms,"@") = 0 THEN 
         PUT STREAM strm UNFORMATTED " " ora_conparms.
  END.

  PUT STREAM strm UNFORMATTED "." SKIP.

  OUTPUT STREAM strm CLOSE.

  IF movedata THEN 
  _mvdt:
  DO:
    IF NOT CONNECTED(ora_dbname) THEN DO:
      IF batch_mode THEN
        PUT STREAM logfile UNFORMATTED
          "Database" ora_dbname " not connected.  Unable to load data."  SKIP.
       ELSE
         MESSAGE "Database" ora_dbname " NOT connected.  Unable to load data." SKIP
           VIEW-AS ALERT-BOX.
       LEAVE _mvdt.    
    END.        
    IF batch_mode THEN
       PUT STREAM logfile UNFORMATTED
           "-- ++ " skip
           "-- Loading data into the Oracle database. " skip
           "-- -- " skip(2).
    ELSE
      DISPLAY  " " SKIP 
               "   Loading data into the Oracle Database.  " SKIP(2)
        WITH FRAME ld-dt NO-LABELS THREE-D CENTERED ROW 5 
          TITLE "Moving Data".

    RUN "prodict/ora/_ora_md9.p".
    HIDE FRAME ld-dt NO-PAUSE.

    DISCONNECT VALUE (ora_dbname).
    DISCONNECT VALUE (osh_dbname).
  END.  
end.
IF NOT batch_mode and loadsql THEN 
      MESSAGE "Run pro -p " cmd " to connect to new Oracle database."
            VIEW-AS ALERT-BOX INFORMATION.

ELSE IF batch_mode THEN DO:

   IF NOT logfile_open THEN DO:
      OUTPUT STREAM logfile TO VALUE(output_file) APPEND UNBUFFERED NO-ECHO NO-MAP.
      logfile_open = true.
   END.

   PUT STREAM logfile UNFORMATTED
       " "           skip
       "-- ++ "      skip
       "-- PROTOORA Complete in " STRING(TIME - run_time,"HH:MM:SS")  skip
       "-- -- "      skip(2).
   if loadsql then
       PUT STREAM logfile UNFORMATTED
          " "                                   skip 
          "Run pro -p " cmd
          " to connect to new Oracle database." skip.
END.

/*------------------------------------------------------------------*/


