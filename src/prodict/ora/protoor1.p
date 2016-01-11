/*********************************************************************
* Copyright (C) 2007 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
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
             10/12/01 DLM Added logic to handle dumping DEFAULTs     
             06/04/02 DLM Added logic to handle error on creating hidden files 
             06/25/02 DLM Added logic for function based indexes
             10/17/05 KSM Fixed X8OVERRIDE funcionality. 
             06/11/07 fernando   Unicode support
*/    

&SCOPED-DEFINE UNICODE-MSG-1 "You have chosen to use Unicode data types but the DataServer schema codepage is not 'utf-8'"
&SCOPED-DEFINE UNICODE-MSG-2 "If your ORACLE client NLS setting is set to a Unicode character set, you should set the" + chr(10) + "codepage to utf-8 in this case to avoid data loss"
&SCOPED-DEFINE UNICODE-MSG-3 "You have chosen to use Unicode data types but the schema holder database codepage is not 'utf-8'"
&SCOPED-DEFINE UNICODE-MSG-4 "You must build your schema holder database with a 'utf-8' code page"

            
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
DEFINE VARIABLE dlc_utf_edb   AS CHARACTER           NO-UNDO.
DEFINE VARIABLE schdbcp       AS CHARACTER           NO-UNDO.

DEFINE STREAM strm.

/*------------------------------------------------------------------*/

assign batch_mode    = SESSION:BATCH-MODE
       run_time      = TIME.

IF batch_mode THEN DO:
   PUT STREAM logfile UNFORMATTED
       " " skip
       "{&PRO_DISPLAY_NAME} to Oracle Log" skip(2)
       "Original {&PRO_DISPLAY_NAME} Database:    " pro_dbname skip
       "Other {&PRO_DISPLAY_NAME} db connect parameters : " pro_conparms  skip
       "Oracle Logical Database:       " ora_dbname skip
       "Version of Oracle:             " ora_version skip
       "{&PRO_DISPLAY_NAME} Schema Holder name:   " osh_dbname skip
       "Oracle Username:               " ora_username skip
       "Oracle Tablespace for tables:  " ora_tspace skip
       "Oracle Tablespace for indexes: " ora_ispace skip
       "Compatible structure:          " pcompatible skip
       "Create shadow columns:         " shadowcol skip
       "Field width calculation based on:      " (IF iFmtOption = 1 THEN
                                                    "_Field._Width field"
                                                  ELSE IF (lFormat = FALSE) THEN
                                                    "Calculation"
                                                  ELSE "_Field._Format field")
                                                  SKIP
       "Create objects in Oracle:      " loadsql skip
       "Moved data to Oracle:          " movedata skip
       "Codepage for Schema Image:     " ora_codepage SKIP
       "Collation Name:                " ora_collname SKIP
       "Unicode Types:                 " unicodeTypes skip
       "Maximum char length:           " ora_varlen SKIP
       "Expand to CLOB:                " lExpandClob SKIP
       "Char semantics:                " lCharSemantics SKIP. 
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

    /* Get the physical schema holder database codepage */
    REPEAT l_i = 1 TO NUM-DBS:

      IF LDBNAME(l_i) = osh_dbname THEN
          schdbcp = UPPER(TRIM(DBCODEPAGE(l_i))).
    END.

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
               " must not be the same as schema holder or {&PRO_DISPLAY_NAME} Database"
                skip(2).
    ELSE DO:
      &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
           MESSAGE "Database " ora_dbname 
             " must not be the same as schema holder or {&PRO_DISPLAY_NAME} Database".
      &ELSE
           MESSAGE "Database " ora_dbname 
             " must not be the same as schema holder or {&PRO_DISPLAY_NAME} Database"
             VIEW-AS ALERT-BOX ERROR.
      &ENDIF
    END.             
    UNDO, RETURN error.
  END.
END.

IF ora_version > 7 THEN DO:
    IF unicodeTypes THEN
       ASSIGN user_env[18] = "NVARCHAR2".
    ELSE
       ASSIGN user_env[18] = "VARCHAR2".
END.
ELSE
  ASSIGN user_env[18] = "long".
  
ASSIGN user_env[1]  = "ALL"
       user_env[2]  = osh_dbname
       user_env[3]  = ""
       user_env[4]  = "n"
       user_env[5]  = ";"
       user_env[6]  = "y"
       user_env[7]  = (IF crtdefault THEN "y" ELSE "n")
       user_env[8]  = "y"
       user_env[9]  = "ALL"
       user_env[10] = string(ora_varlen) /* maximum char column length */
                             + "," + STRING(lExpandClob)  /* expand to clob */
                             + "," + STRING(lCharSemantics) /* use char semantics */
       user_env[11] = "char"
       user_env[12] = "date"
       user_env[13] = "number"
       user_env[14] = "number"
       user_env[15] = "number"
       user_env[16] = "number"
       user_env[17] = "number"
       user_env[19] = "number"
       user_env[20] = "##"
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
    
IF pcompatible THEN 
   ASSIGN user_env[27] = "y".
ELSE
   ASSIGN user_env[27] = "no".

IF iFmtOption = 1 THEN 
  ASSIGN user_env[33] = "y".
ELSE IF (lFormat = FALSE) THEN
  ASSIGN user_env[33] = "no".
ELSE
  ASSIGN user_env[33] = "?".

/* Create shadow columns */
IF shadowcol THEN
  ASSIGN user_env[21] = "y".
ELSE
  ASSIGN user_env[21] = "n".

    /* md0: creates SQL and .d-files */
RUN "prodict/ora/_ora_md0.p".

IF loadsql THEN DO:

  /* check if unicode types and non utf-8 codepage and give warning */
  IF unicodeTypes AND TRIM(ora_codepage) NE "utf-8" THEN DO:
     IF batch_mode THEN
        PUT STREAM logfile UNFORMATTED {&UNICODE-MSG-1} SKIP {&UNICODE-MSG-2} SKIP.
     ELSE
        MESSAGE {&UNICODE-MSG-1} SKIP {&UNICODE-MSG-2} VIEW-AS ALERT-BOX INFO BUTTONS OK.
  END.

  IF create_h THEN DO:
    IF batch_mode THEN DO:
      PUT STREAM logfile UNFORMATTED
              " " skip
              "-- ++ " skip
              "-- Creating empty schema holder " skip
              "-- -- " skip(2).
    END.

    IF unicodeTypes THEN DO:
        dlc_utf_edb = OS-GETENV("DLC").
        dlc_utf_edb = dlc_utf_edb + "/prolang/utf/empty".
        CREATE DATABASE osh_dbname FROM dlc_utf_edb. 
    END.
    ELSE
       CREATE DATABASE osh_dbname FROM "EMPTY".
  END.
  ELSE DO:
    IF unicodeTypes THEN DO:
      IF ( schdbcp <> "UTF-8" ) THEN DO:
        IF batch_mode THEN
          PUT STREAM logfile UNFORMATTED {&UNICODE-MSG-3} SKIP {&UNICODE-MSG-4} SKIP.
        ELSE
          MESSAGE {&UNICODE-MSG-3} SKIP {&UNICODE-MSG-4} VIEW-AS ALERT-BOX INFO BUTTONS OK.
        UNDO, RETURN "undo".
      END.
    END.
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
  ELSE IF RETURN-VALUE = "2" THEN
    UNDO, RETURN ERROR.
  ELSE IF RETURN-VALUE = "3" THEN
    UNDO, RETURN "wrg-ver".

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

    IF NOT batch_mode THEN
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


