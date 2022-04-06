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

&SCOPED-DEFINE UNICODE-MSG-1 "You have chosen to use Unicode data types but the DataServer schema codepage is not 'utf-8'"
&SCOPED-DEFINE UNICODE-MSG-2 "It is recommended that you set the codepage to utf-8 in this case to avoid data loss!"
&SCOPED-DEFINE UNICODE-MSG-3 "You have chosen to use Unicode data types but the schema holder database codepage is not 'utf-8'"
&SCOPED-DEFINE UNICODE-MSG-4 "You must build your schema holder database with a 'utf-8' code page"

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
DEFINE VARIABLE dlc_utf_edb   AS CHARACTER           NO-UNDO.
DEFINE VARIABLE schdbcp       AS CHARACTER           NO-UNDO.
DEFINE STREAM strm.

ASSIGN
     batch_mode    = SESSION:BATCH-MODE
     run_time      = TIME.

ASSIGN loadsql = TRUE.

IF loadsql THEN 
ASSIGN stages[mss_create_sql] = TRUE
         stages[mss_build_schema] = TRUE
         stages[mss_fixup_schema] = TRUE
         stages[mss_create_objects] = TRUE.

ASSIGN create_h = TRUE
       rmvobj   = TRUE.

ASSIGN user_dbname  = mss_dbname
       user_env[1]  = "ALL"
       user_env[2]  = osh_dbname
       user_env[22] = "MSS"
       user_env[26] = mss_username
       user_env[37] = "IP"
       user_env[32] = "MSSQLSRV7".
	
IF loadsql THEN DO:
  /* check if unicode types and non utf-8 codepage and give warning */
  IF unicodeTypes AND TRIM(mss_codepage) NE "utf-8" THEN DO:
     IF batch_mode THEN
        PUT STREAM logfile UNFORMATTED {&UNICODE-MSG-1} SKIP {&UNICODE-MSG-2} SKIP.
     ELSE
        MESSAGE {&UNICODE-MSG-1} SKIP {&UNICODE-MSG-2} VIEW-AS ALERT-BOX INFO BUTTONS OK.
  END.

  IF NOT batch_mode THEN
    HIDE FRAME table-wait NO-PAUSE.
  
  ASSIGN stages_complete[mss_create_sh] = TRUE
         stages[mss_create_objects]     = TRUE.
    
  /* consider for computed columns */
  IF pcompatible AND iRecidOption = 2 THEN
     ASSIGN user_env[32] = "MSSQLSRV9" .

  /* let's set the mss version based on unicodeTypes so _mss_md1 checks the correct version
     for Unicode data types. Do the same for 2008 types (that also checks the driver).
  */
  IF mapMSSDatetime THEN
     ASSIGN user_env[32] = (IF unicodeTypes THEN "MSSQLSRV9" ELSE "MSSQLSRV7").
  ELSE
     ASSIGN user_env[32] = "MSSQLSRV10".

  RUN "prodict/mss/schconnect.p".

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

PUT STREAM logfile UNFORMATTED
       " "           skip
       "-- ++ "      skip
       "-- Schema Pull Complete in " STRING(TIME - run_time,"HH:MM:SS")  skip
       "-- -- "      skip(2).

IF NOT logfile_open THEN DO:
      OUTPUT STREAM logfile TO VALUE(output_file) APPEND UNBUFFERED NO-ECHO NO-MAP.
      logfile_open = true.
   END.
   