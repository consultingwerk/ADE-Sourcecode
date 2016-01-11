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

/* Procedure prodict/mss/protoms1.p

    Created: 03/31/00 Used prodict/odb/protood1.p as model D. McMann
   History: 08/18/00 Incresed size of identifier max length
             08/29/00 Changed to alert-box for tty end message DLM
    
       user_env[5] = statement terminator
       user_env[10] = Maximum length of varchar
       user_env[11..18] = a string of how to convert PROGRESS datatypes:
               [11] = character  -> varchar, long varchar, text, memo, Sql_Varchar, Sql_Longvar
               [12] = date       -> date, datetime, Sql_Date
               [13] = logical    -> logical, bit
               [14] = integer    -> smallint, logical, tinyint, Sql_bit 
               [15] = decimal    -> money, decimal, currency, Sql_decimal
               [16] = decimal*   -> decimal, integer, number
               [17] = recid      -> recid, rowid
               [18] = char**     -> long varchar, memo, Sql_Longvar
               [19] = logical*** -> logical, tinyint              
       user_env[20] = character to use for unique name creation
       user_env[21] = create shawdow columns
       user_env[25] = create sequences
       user_env[30] = write exit at end of SQL.
       user_env[33] = Use _Field._Width for size of field.
       user_env[34] = Create descending indices
      
       
       * = When the datatype is decimals and no decimals are present
      ** = Name of character field when max for regular char is exceeded
     *** = Logical fields which are key componets
   
*/    

{ prodict/user/uservar.i }
{ prodict/mss/mssvar.i }

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
       "Progress to MSS Log" skip(2)
       "Original Progress Database:            " pro_dbname skip
       "Other Progress db connect parameters : " pro_conparms  skip
       "Logical Database Name:                 " mss_pdbname SKIP
       "ODBC Data Source Name:                 " mss_dbname SKIP
       "Progress Schema Holder name:           " osh_dbname skip
       "MSS Username:                         " mss_username skip
       "Compatible structure:                  " pcompatible skip
       "Use Width field for Size of field:    " sqlwidth skip
       "Create objects in MSS:                " loadsql skip
       "Moved data to MSS:                    " movedata skip(2).
END.

IF loadsql THEN DO:
  ASSIGN stages[mss_create_sql] = TRUE
         stages[mss_build_schema] = TRUE
         stages[mss_fixup_schema] = TRUE
         stages[mss_create_objects] = TRUE.
  
  IF not batch_mode THEN
     HIDE MESSAGE NO-PAUSE.
  ASSIGN schname = osh_dbname + ".db".
  IF search (osh_dbname) <> ? THEN do:
    connect osh_dbname -1 no-error.
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
           create_h = FALSE
           stages[mss_create_sh] = FALSE.
           
    CREATE ALIAS DICTDB2 FOR DATABASE value(osh_dbname).
    ASSIGN db_exist = FALSE.
    RUN "prodict/misc/_tstsh.p" (INPUT mss_pdbname, OUTPUT db_exist).
    IF db_exist THEN DO:
      IF not batch_mode THEN DO:
        &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
           MESSAGE "Logical Database name " mss_pdbname " already exists in schema holder " 
                  osh_dbname.
        &ELSE 
           MESSAGE "Logical Database name " mss_pdbname " already exists in schema holder " 
      	               osh_dbname VIEW-AS ALERT-BOX ERROR.
        &ENDIF
      END. 	                  	           
      ELSE 
         PUT STREAM logfile UNFORMATTED 
            "Logical Database name " mss_pdbname " already exists in schema holder " 
            osh_dbname skip(2).
      DISCONNECT VALUE(osh_dbname).
      UNDO, RETURN "indb".
    END. 
    DISCONNECT VALUE (osh_dbname).
    
  END. 
  ELSE
    ASSIGN create_h = TRUE
           rmvobj   = TRUE.
           
  IF mss_dbname = pro_dbname OR mss_pdbname = osh_dbname THEN DO:
    IF batch_mode THEN 
       PUT STREAM logfile UNFORMATTED 
               "Logical Database Name " mss_pdbname 
               " must not be the same as schema holder or PROGRESS Database Name"
                skip(2).
    ELSE DO:
      &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
           MESSAGE "Logical Database Name " mss_pdbname 
             " must not be the same as schema holder or PROGRESS Database Name".
      &ELSE
           MESSAGE "Logical Database name " mss_pdbname 
             " must not be the same as schema holder or PROGRESS Database Name"
             VIEW-AS ALERT-BOX ERROR.
      &ENDIF
    END.             
    UNDO, RETURN error.
  END.
END.

ASSIGN user_dbname  = mss_dbname
     /*  mss_pdbname  = mss_dbname */
       user_env[1]  = "ALL"
       user_env[2]  = osh_dbname
       user_env[3]  = ""
       user_env[4]  = "n"
       user_env[5]  = "go"
       user_env[6]  = "y"
       user_env[7]  = (IF dflt THEN "y" ELSE "n")
       user_env[8]  = "y"
       user_env[9]  = "ALL"
       user_env[10] = string(long-length)
       user_env[11] = "varchar" 
       user_env[12] = "datetime"
       user_env[13] = "tinyint"
       user_env[14] = "integer"
       user_env[15] = "decimal(18,5)"
       user_env[16] = "decimal"
       user_env[17] = "integer"
       user_env[18] = "text"
       user_env[19] = "tinyint"
       user_env[20] = "##"  
       user_env[21] = (IF shadowcol THEN "y" ELSE "n")
       user_env[22] = "MSS"
       user_env[23] = "30"
       user_env[24] = "15"
       user_env[25] = "y" 
       user_env[26] = mss_username
       user_env[28] = "128"
       user_env[29] = "128"            
       user_env[30] = "y"
       user_env[31] = "-- ** "
       user_env[32] = "MSSQLSRV7".


IF pcompatible THEN 
   ASSIGN user_env[27] = "y".
ELSE
   ASSIGN user_env[27] = "no".

IF sqlwidth THEN 
   ASSIGN user_env[33] = "y".
ELSE
   ASSIGN user_env[33] = "n".

IF descidx THEN 
   ASSIGN user_env[34] = "y".
ELSE
   ASSIGN user_env[34] = "n".
        

IF movedata THEN
  ASSIGN stages[mss_dump_data] = TRUE
         stages[mss_load_data] = TRUE.

    /* md0: creates SQL */
RUN "prodict/mss/_mss_md0.p".

/*
IF not stages[mss_create_sh] THEN LEAVE.
*/
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
  
  ASSIGN stages_complete[mss_create_sh] = TRUE
         stages[mss_create_objects]     = TRUE.
    
  /* md1: creates SI and MSS-Schema using send-sql.p
   *      pulls schema into SI
   *      beautifies SI by comparing it and matching it up with 
   *            the original progress-db
   */

  RUN "prodict/mss/_mss_md1.p".

  IF RETURN-VALUE = "wrg-ver" THEN
    RETURN "wrg-ver".
  
  ELSE IF RETURN-VALUE = "undo" THEN
    RETURN "undo".

  IF batch_mode and NOT logfile_open THEN DO:
    OUTPUT TO VALUE(output_file) APPEND UNBUFFERED NO-ECHO NO-MAP.
    logfile_open = true.
  END.

  /* See if we were successful. */

  IF NOT CONNECTED (mss_pdbname) THEN DO:
    cmd = "Error creating MSS Database - Check logfile " + osh_dbname + 
      	  ".log".
    IF NOT Batch_mode THEN
      MESSAGE cmd.
    ELSE
      PUT STREAM logfile UNFORMATTED  cmd.  
    UNDO, RETURN error.
  END.

  ASSIGN cmd = "c" + mss_pdbname + ".p".

  OUTPUT STREAM strm TO VALUE (cmd) NO-MAP.

  PUT STREAM strm UNFORMATTED "CONNECT " osh_dbname " -1." SKIP.

  IF mss_conparms <> ? THEN DO:
    IF INDEX(mss_conparms,"@") <> 0 THEN 
         mss_username = mss_username + mss_conparms. 
  END. 
  
  IF mss_username = "" or mss_username = ? THEN
     PUT STREAM strm UNFORMATTED " CONNECT " mss_dbname " -ld " mss_pdbname
        " -dt MSS" .
  ELSE IF mss_password = "" or mss_password = ? THEN
     PUT STREAM strm UNFORMATTED "CONNECT " mss_dbname " -ld ~"" mss_pdbname
        "~" -dt MSS -U ~"" mss_username "~"".
  ELSE 
     PUT STREAM strm UNFORMATTED "CONNECT " mss_dbname " -ld ~"" mss_pdbname
        "~" -dt MSS -U ~"" mss_username "~" -P ~"" mss_password "~"".
 
  IF mss_conparms <> ? THEN DO:
    IF INDEX(mss_conparms,"@") = 0 THEN 
         PUT STREAM strm UNFORMATTED " " mss_conparms.
  END.

  PUT STREAM strm UNFORMATTED "." SKIP.

  OUTPUT STREAM strm CLOSE.

  IF movedata THEN 
  _mvdt:
  DO:
    IF NOT CONNECTED(mss_pdbname) THEN DO:
      IF batch_mode THEN
        PUT STREAM logfile UNFORMATTED
          "Database" mss_dbname " not connected.  Unable to load data."  SKIP.
       ELSE
         MESSAGE "Database" mss_dbname " NOT connected.  Unable to load data." SKIP
           VIEW-AS ALERT-BOX.
       LEAVE _mvdt.    
    END.        
    IF batch_mode THEN
       PUT STREAM logfile UNFORMATTED
           "-- ++ " skip
           "-- Loading data into the MSS database. " skip
           "-- -- " skip(2).
    ELSE
      DISPLAY  " " SKIP 
               "   Loading data into the MSS Database.  " SKIP(2)
        WITH FRAME ld-dt NO-LABELS THREE-D CENTERED ROW 5 
          TITLE "Moving Data".

    RUN "prodict/mss/_mss_md9.p".

    DISCONNECT VALUE (osh_dbname).
  END.  
end.
IF NOT batch_mode and loadsql THEN 
      MESSAGE "Run pro -p " cmd " to connect to new MSS database."
            VIEW-AS ALERT-BOX INFORMATION.
  
ELSE IF batch_mode THEN DO:

   IF NOT logfile_open THEN DO:
      OUTPUT STREAM logfile TO VALUE(output_file) APPEND UNBUFFERED NO-ECHO NO-MAP.
      logfile_open = true.
   END.

   PUT STREAM logfile UNFORMATTED
       " "           skip
       "-- ++ "      skip
       "-- ProToMSS Complete in " STRING(TIME - run_time,"HH:MM:SS")  skip
       "-- -- "      skip(2).
   if loadsql then
       PUT STREAM logfile UNFORMATTED
          " "                                   skip 
          "Run pro -p " cmd
          " to connect to new MSS database." skip.
END.

/*------------------------------------------------------------------*/











