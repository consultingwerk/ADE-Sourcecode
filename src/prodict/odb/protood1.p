/*********************************************************************
* Copyright (C) 2006,2009 by Progress Software Corporation. All      *
* rights reserved.  Prior versions of this work may contain portions *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* Procedure prodict/odb/protood1.p

    Created 06/23/98 Used prodict/ora/protoor1.p as model D. McMann
    
    Each ODBC Foreign Database must have the following user_env parameters
    created specific for the data source:
       user_env[5] = statement terminator
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
       user_env[25] = create sequences
       user_env[30] = write exit at end of SQL.
       user_env[33] = Use _Field._Width for size of field.
       user_env[34] = DB2 db type or the unknown value.
       
       * = When the datatype is decimals and no decimals are present
      ** = Name of character field when max for regular char is exceeded
     *** = Logical fields which are key componets
     
     History:  D. McMann  09/03/98 Added statement terminator for MS Access
               D. McMann  09/17/98 Changed Informix index name length to 18
                                   and statement terminator to ;
               D. McMann  02/08/99 Removed disconnect of original database 
               D. McMann  02/24/99 Added TTY check for all data sources 
               D. McMann  03/03/99 Removed On-line from Informix 
               D. McMann  03/16/98 Made sure sequences were not being created 
                                   for Informix  
               D. McMann  10/08/02 Added support for shadow column selection
               D. McMann  10/31/02 Changed Informix Char to VarChar
               D. McMann  09/17/03 Put CHAR back
               K. McIntosh  04/13/04 Added support for DB2/400 libraries 
                                   (user_library)  
               D. Slutz  08/10/05 Set dft ext char to __ for DB2 20050531-001
               K. McIntosh  10/25/05 Fixed x8override functionality 20051018-006
               fernando     01/04/06 Handle decimals for DB2/400 20051214-009
               fernando     02/12/08 Adding missing entries to log file in batch
	       rkumar       02/13/08 OE00177724- default values support for DB2/400
               rkumar       05/05/09 OE00177721- RECID support for DB2/400

*/           

{ prodict/user/uservar.i }
{ prodict/odb/odbvar.i }

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
DEFINE VARIABLE clctn_output  AS CHARACTER           NO-UNDO.

DEFINE STREAM strm.

/*------------------------------------------------------------------*/

assign batch_mode    = SESSION:BATCH-MODE
       run_time      = TIME
       odb_library  = (IF odb_library EQ ? THEN "" ELSE odb_library)
       clctn_output  = (IF odb_library NE "" THEN
                          "DB2/400 Library:                    " + 
                          odb_library + CHR(10)
                        ELSE "").

IF batch_mode THEN DO:
   PUT STREAM logfile UNFORMATTED
       " " skip
       "{&PRO_DISPLAY_NAME} to ODBC Log" skip(2)
       "Original {&PRO_DISPLAY_NAME} Database:            " pro_dbname skip
       "Other {&PRO_DISPLAY_NAME} db connect parameters : " pro_conparms  skip
       "ODBC Data Source Name:                 " odb_dbname skip
       "Foreign DBMS Type:                     " odb_type skip
       "{&PRO_DISPLAY_NAME} Schema Holder name:           " osh_dbname skip
       "ODBC Username:                         " odb_username SKIP
       clctn_output
       "Codepage for Schema Image:             " odb_codepage SKIP
       "Collation Name:                        " odb_collname SKIP           
       "Field width calculation based on:      " (IF iFmtOption = 1 THEN
                                                    "_Field._Width field"
                                                  ELSE IF (lFormat = FALSE) THEN
                                                    "Calculation"
                                                  ELSE "_Field._Format field")
                                                  SKIP
       "Compatible structure:                  " pcompatible skip
       "Create RECID for:                      " (IF odb_type EQ "DB2/400" AND iRidOption = 1 THEN 
                                                        "All Tables" 
                                                  ELSE IF odb_type EQ "DB2/400" AND iRidOption = 2 THEN
                                                        "Tables Without Unique Key"
                                                  ELSE  "All Tables")
                                                  skip 
       "Create objects in ODBC:                " loadsql skip
       "Moved data to ODBC:                    " movedata skip
       "Include Defaults:                      " odbdef skip
       "Create shadow columns:                 " shadowcol skip(2).
END.

IF loadsql THEN DO:
  ASSIGN stages[odb_create_sql] = TRUE
         stages[odb_build_schema] = TRUE
         stages[odb_fixup_schema] = TRUE
         stages[odb_create_objects] = TRUE.
  
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
           stages[odb_create_sh] = FALSE.
           
    CREATE ALIAS DICTDB2 FOR DATABASE value(osh_dbname).
    ASSIGN db_exist = FALSE.
    RUN "prodict/misc/_tstsh.p" (INPUT odb_dbname, OUTPUT db_exist).
    IF db_exist THEN DO:
      IF not batch_mode THEN DO:
        &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
           MESSAGE "Data Source " odb_dbname " already exists in schema holder " 
                  osh_dbname.
        &ELSE 
           MESSAGE "Data Source " odb_dbname " already exists in schema holder " 
                             osh_dbname VIEW-AS ALERT-BOX ERROR.
        &ENDIF
      END.                                              
      ELSE 
         PUT STREAM logfile UNFORMATTED 
            "Data Source " odb_dbname " already exists in schema holder " 
            osh_dbname skip(2).
      DISCONNECT VALUE(osh_dbname).
      UNDO, RETURN "indb".
    END. 
    DISCONNECT VALUE (osh_dbname).
    
  END. 
  ELSE
    ASSIGN create_h = TRUE
           rmvobj   = TRUE.
           
  IF odb_dbname = pro_dbname OR odb_dbname = osh_dbname THEN DO:
    IF batch_mode THEN 
       PUT STREAM logfile UNFORMATTED 
               "Data Source Name " odb_dbname 
               " must not be the same as schema holder or {&PRO_DISPLAY_NAME} Database Name"
                skip(2).
    ELSE DO:
      &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
           MESSAGE "Data Source Name " odb_dbname 
             " must not be the same as schema holder or {&PRO_DISPLAY_NAME} Database Name".
      &ELSE
           MESSAGE "Data Source name " odb_dbname 
             " must not be the same as schema holder or {&PRO_DISPLAY_NAME} Database Name"
             VIEW-AS ALERT-BOX ERROR.
      &ENDIF
    END.             
    UNDO, RETURN error.
  END.
END.

ASSIGN user_env[1]   = "ALL"
       user_env[2]   = osh_dbname
       user_env[3]   = ""
       user_env[4]   = "n"
       user_env[6]   = "y"
       user_env[7]   = (IF odbdef then "y" else "n")
       user_env[8]   = "y"
       user_env[9]   = "ALL"
       user_env[22]  = "ODBC"
       user_env[23]  = "30"
       user_env[24]  = "15"
       user_env[26]  = odb_username
       user_env[31]  = "-- ** "
       user_env[34]  = ?
       user_library = odb_library
       user_dbname   = odb_dbname
       odb_pdbname   = odb_dbname.

IF iFmtOption = 1 THEN 
  user_env[33]  = "y".
ELSE IF (lFormat = FALSE) THEN 
  user_env[33] = "no".
ELSE user_env[33] = "?".

CASE odb_type:
  WHEN "Informix" THEN
    ASSIGN user_env[5]  = ";"
           user_env[11] = "char" 
           user_env[12] = "date"
           user_env[13] = "smallint"
           user_env[14] = "integer"
           user_env[15] = "money"
           user_env[16] = "decimal"
           user_env[17] = "integer"
           user_env[18] = "char"
           user_env[19] = "smallint"
           user_env[20] = "_"
           user_env[21] = (IF shadowcol THEN "y" ELSE "n")  /* should shadow colunms be produced */
           user_env[25] = "n" 
           user_env[28] = "18"
           user_env[29] = "18"           
           user_env[30] = "n"
           user_env[32] = "Informix".
       
  WHEN "DB2/MVS"    OR 
  WHEN "DB2/6000"   OR 
  WHEN "DB2/NT"     OR 
  WHEN "DB2/400"    OR 
  WHEN "DB2" 		OR 
  WHEN "DB2(Other)" THEN
    ASSIGN user_env[5]  = ";"
           user_env[11] = "varchar" 
           user_env[12] = "date"
           user_env[13] = "smallint"
           user_env[14] = "integer"
           user_env[15] = "decimal(18,5)"
           user_env[16] = "decimal"
           user_env[17] = "integer"
           user_env[18] = "long varchar"
           user_env[19] = "smallint"
           user_env[20] = "__"
           user_env[21] = (IF shadowcol THEN "y" ELSE "n")  /* should shadow colunms be produced */           
           user_env[25] = "n"  
           user_env[28] = (IF odb_type = "DB2/400" THEN "30" ELSE "18")
           user_env[29] = (IF odb_type = "DB2/400" THEN "30" ELSE "18")
           user_env[30] = "no"
           user_env[32] = "DB2"
           user_env[34] = odb_type.
           
  WHEN "MS Access" OR WHEN "MSAccess" THEN
    ASSIGN user_env[5]  = ";"
           user_env[11] = "text" 
           user_env[12] = "datetime"
           user_env[13] = "logical"
           user_env[14] = "number"
           user_env[15] = "number"
           user_env[16] = "number"
           user_env[17] = "integer"
           user_env[18] = "memo"
           user_env[19] = "logical"
           user_env[20] = "_"
           user_env[21] = (IF shadowcol THEN "y" ELSE "n")  /* should shadow colunms be produced */           
           user_env[25] = "n" 
           user_env[28] = "33"
           user_env[29] = "33"            
           user_env[30] = "no"
           user_env[32] = odb_type.

 WHEN "SQL Server 6"  THEN
    ASSIGN user_env[5]  = "go"
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
           user_env[21] = (IF shadowcol THEN "y" ELSE "n")  /* should shadow colunms be produced */           
           user_env[25] = "y" 
           user_env[28] = "30"
           user_env[29] = "24"            
           user_env[30] = "y"
           user_env[32] = "MS SQL Server".
  
  WHEN "Sybase" THEN
    ASSIGN user_env[5]  = "go"
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
           user_env[21] = (IF shadowcol THEN "y" ELSE "n")  /* should shadow colunms be produced */           
           user_env[25] = "y"
           user_env[28] = "30"
           user_env[29] = "24"            
           user_env[30] = "y"
           user_env[32] = odb_type.
  
  WHEN "Other" THEN
    ASSIGN user_env[5]  = ";"
           user_env[11] = "varchar" 
           user_env[12] = "date"
           user_env[13] = "smallint"
           user_env[14] = "integer"
           user_env[15] = "decimal"
           user_env[16] = "decimal"
           user_env[17] = "integer"
           user_env[18] = "longvar"
           user_env[19] = "smallint"
           user_env[20] = ""
           user_env[21] = "n"  /* should shadow colunms be produced */           
           user_env[25] = "n"  
           user_env[28] = "30"
           user_env[29] = "24"            
           user_env[30] = "y"
           user_env[32] = odb_type.
END CASE.
           
IF pcompatible THEN 
   ASSIGN user_env[27] = "y".
ELSE
   ASSIGN user_env[27] = "no".

IF (odb_type = "DB2/400" and pcompatible) THEN 
     ASSIGN user_env[27] = user_env[27] + "," + STRING(iRidOption).

ASSIGN user_env[36] = "n,n,n,n,n"
       user_env[38] = "1"
       user_env[39] = "1".
IF movedata THEN
  ASSIGN stages[odb_dump_data] = TRUE
         stages[odb_load_data] = TRUE.

    /* md0: creates SQL */
RUN "prodict/odb/_odb_md0.p".


/*
IF not stages[odb_create_sh] THEN LEAVE.
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
  
  ASSIGN stages_complete[odb_create_sh] = TRUE
         stages[odb_create_objects]     = TRUE.
    
  /* md1: creates SI and ODBC-Schema using send-sql.p
   *      pulls schema into SI
   *      beautifies SI by comparing it and matching it up with 
   *            the original progress-db
   */
  RUN "prodict/odb/_odb_md1.p".

  IF RETURN-VALUE = "wrg-ver" THEN
    RETURN "wrg-ver".

  IF RETURN-VALUE = "undo" THEN
    RETURN "undo".

  IF batch_mode and NOT logfile_open THEN DO:
    OUTPUT TO VALUE(output_file) APPEND UNBUFFERED NO-ECHO NO-MAP.
    logfile_open = true.
  END.

  /* See if we were successful. */

  IF NOT CONNECTED (odb_dbname) THEN DO:
    cmd = "Error creating ODBC Database - Check logfile " + osh_dbname + 
                ".log".
    IF NOT Batch_mode THEN
      MESSAGE cmd.
    ELSE
      PUT STREAM logfile UNFORMATTED  cmd.  
    UNDO, RETURN error.
  END.

  ASSIGN cmd = "c" + odb_dbname + ".p".

  OUTPUT STREAM strm TO VALUE (cmd) NO-MAP.

  PUT STREAM strm UNFORMATTED "CONNECT " osh_dbname " -1." SKIP.

  IF odb_conparms <> ? THEN DO:
    IF INDEX(odb_conparms,"@") <> 0 THEN 
         odb_username = odb_username + odb_conparms. 
  END. 
  
  IF odb_username = "" or odb_username = ? THEN
     PUT STREAM strm UNFORMATTED " CONNECT " odb_dbname " -ld " odb_dbname
        " -dt ODBC" .
  ELSE IF odb_password = "" or odb_password = ? THEN
     PUT STREAM strm UNFORMATTED "CONNECT " odb_dbname " -ld ~"" odb_dbname
        "~" -dt ODBC -U ~"" odb_username "~"".
  ELSE 
     PUT STREAM strm UNFORMATTED "CONNECT " odb_dbname " -ld ~"" odb_dbname
        "~" -dt ODBC -U ~"" odb_username "~" -P ~"" odb_password "~"".
 
  IF odb_conparms <> ? THEN DO:
    IF INDEX(odb_conparms,"@") = 0 THEN 
         PUT STREAM strm UNFORMATTED " " odb_conparms.
  END.

  PUT STREAM strm UNFORMATTED "." SKIP.

  OUTPUT STREAM strm CLOSE.

  IF movedata THEN 
  _mvdt:
  DO:
    IF NOT CONNECTED(odb_dbname) THEN DO:
      IF batch_mode THEN
        PUT STREAM logfile UNFORMATTED
          "Database" odb_dbname " not connected.  Unable to load data."  SKIP.
       ELSE
         MESSAGE "Database" odb_dbname " NOT connected.  Unable to load data." SKIP
           VIEW-AS ALERT-BOX.
       LEAVE _mvdt.    
    END.        
    IF batch_mode THEN
       PUT STREAM logfile UNFORMATTED
           "-- ++ " skip
           "-- Loading data into the ODBC database. " skip
           "-- -- " skip(2).
    ELSE
      DISPLAY  " " SKIP 
               "   Loading data into the ODBC Database.  " SKIP(2)
        WITH FRAME ld-dt NO-LABELS THREE-D CENTERED ROW 5 
          TITLE "Moving Data".

    RUN "prodict/odb/_odb_md9.p".

    DISCONNECT VALUE (odb_dbname).
    DISCONNECT VALUE (osh_dbname).
  END.  
end.
IF NOT batch_mode and loadsql THEN DO:
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
      MESSAGE "Run pro -p " cmd " to connect to new ODBC database.".
  &ELSE
      MESSAGE "Run pro -p " cmd " to connect to new ODBC database."
            VIEW-AS ALERT-BOX INFORMATION.
  &ENDIF
END.
ELSE IF batch_mode THEN DO:

   IF NOT logfile_open THEN DO:
      OUTPUT STREAM logfile TO VALUE(output_file) APPEND UNBUFFERED NO-ECHO NO-MAP.
      logfile_open = true.
   END.

   PUT STREAM logfile UNFORMATTED
       " "           skip
       "-- ++ "      skip
       "-- PROTOodb Complete in " STRING(TIME - run_time,"HH:MM:SS")  skip
       "-- -- "      skip(2).
   if loadsql then
       PUT STREAM logfile UNFORMATTED
          " "                                   skip 
          "Run pro -p " cmd
          " to connect to new ODBC database." skip.
END.

/*------------------------------------------------------------------*/

