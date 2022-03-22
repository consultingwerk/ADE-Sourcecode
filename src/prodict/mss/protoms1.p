/*********************************************************************
* Copyright (C) 2006-2011 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* Procedure prodict/mss/protoms1.p

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
       user_env[25] = create sequences,new sequence generator
       user_env[30] = write exit at end of SQL.
       user_env[33] = Use _Field._Width for size of field.
       user_env[34] = Create descending indices
      
       * = When the datatype is decimals and no decimals are present
      ** = Name of character field when max for regular char is exceeded
     *** = Logical fields which are key componets

   Created: 03/31/00 Used prodict/odb/protood1.p as model D. McMann
   History: 08/18/00 Incresed size of identifier max length
            08/29/00 Changed to alert-box for tty end message DLM
            10/25/05 Fixed X8OVERRIDE functionality 20051018-006. 
            04/14/06 Unicode support
            07/19/06 Unicode support - support only MSS 2005
            08/24/06 Add warning about non utf-8 codepage and unicode columns - 20060802-024
            03/21/07 Unicode requirements for schema holder database - added for CR#OE00147991
            04/11/08 Support for new seq generator
            02/12/09 Fix output for batch log file
            09/22/09 Computed column implementation - Nagaraju
            11/12/09 Remove numbers for radio-set options in MSSDS - Nagaraju
            06/21/11 Added screen variable for constraint migration - kmayur
            04/03/12 Fixed issue with DLC not getting set- rkumar 
*/    

&SCOPED-DEFINE UNICODE-MSG-1 "You have chosen to use Unicode data types but the DataServer schema codepage is not 'utf-8'"
&SCOPED-DEFINE UNICODE-MSG-2 "It is recommended that you set the codepage to utf-8 in this case to avoid data loss!"
&SCOPED-DEFINE UNICODE-MSG-3 "You have chosen to use Unicode data types but the schema holder database codepage is not 'utf-8'"
&SCOPED-DEFINE UNICODE-MSG-4 "You must build your schema holder database with a 'utf-8' code page"

/*h-*/
&SCOPED-DEFINE NOTTCACHE 1
&SCOPED-DEFINE xxDS_DEBUG                   DEBUG
&SCOPED-DEFINE DATASERVER                 YES
&SCOPED-DEFINE FOREIGN_SCHEMA_TEMP_TABLES INCLUDE
{ prodict/dictvar.i NEW }
&UNDEFINE DATASERVER
&UNDEFINE FOREIGN_SCHEMA_TEMP_TABLES
&UNDEFINE NOTTCACHE

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
DEFINE VARIABLE ClustAsROWID  AS LOGICAL             NO-UNDO INITIAL TRUE.
DEFINE VARIABLE mdrec_db      AS RECID               NO-UNDO.    
DEFINE VARIABLE lcompatible   AS LOGICAL             NO-UNDO.
DEFINE VARIABLE useLegacyRanking    AS LOGICAL    NO-UNDO INITIAL TRUE.
DEFINE  VARIABLE rank_rep     AS CHARACTER    NO-UNDO INITIAL "dsmssrank.lg".

DEFINE STREAM strm.

/* PROCEDURE: prgs-ranking
 */
PROCEDURE prgs-ranking:

FIND FIRST DICTDB._Db WHERE _Db-local NO-LOCK.
ASSIGN mdrec_db      = RECID(DICTDB._Db).

/* Logic to decide whether to use legacy or new ranking logic */
if  user_env[27] = ?  OR user_env[27] = ""
  THEN ASSIGN lcompatible = true.
else if num-entries(user_env[27]) > 1
     then assign  /* more than one value in user_env[27] */
           lcompatible = ( entry(1,user_env[27]) BEGINS "y"
              or entry(1,user_env[27]) = ""
              ).
     else assign
            lcompatible = (user_env[27] BEGINS "y"). /* create recid fields/indexes */
IF (ENTRY(1,user_env[36]) = "y") OR (ENTRY(2,user_env[36]) = "y")  OR (UPPER(ENTRY(3,user_env[36])) = "Y") OR       
   (lcompatible AND ((NUM-ENTRIES(user_env[27]) >= 3) AND  /* U = For ROWID uniqueness, P = Prime ROWID */
                    ((ENTRY(3,user_env[27]) EQ "U") OR (ENTRY(3,user_env[27]) EQ "P")))
   )  
THEN  ASSIGN useLegacyRanking = FALSE.

ASSIGN user_env[42] = STRING(genreplvl) +   /* Generate ranking report level */
                      (IF useLegacyRanking THEN ',L' ELSE ',N').

FOR EACH DICTDB._File  WHERE DICTDB._File._Db-recid = mdrec_db
                       AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")
                       AND (IF user_env[1] = "ALL"  THEN
                            NOT DICTDB._File._Hidden AND
                           (CAN-DO(_File._Can-read, user_env[9]) OR user_env[9] = "ALL")
                             ELSE
                               DICTDB._File._File-name = user_filename
                            ):
    IF useLegacyRanking AND lcompatible THEN
       ASSIGN DICTDB._FILE._Fil-misc1[1] = 1. /* assign positive to indicate PROGRESS_RECID as ROWID */
    ELSE
       RUN prodict/mss/_rankpdb.p ( INPUT RECID(DICTDB._File),
                               INPUT ClustAsROWID).
END.
IF OS-GETENV("_RANKLOGNAME") <> ?
THEN DO:
   tmp_str = OS-GETENV("_RANKLOGNAME").
   IF trim(tmp_str) <> "" THEN
      ASSIGN rank_rep = tmp_str.
END.
RUN prodict/mss/_ctestr.p(INPUT rank_rep).

END PROCEDURE.

/*------------------------------------------------------------------*/

assign batch_mode    = SESSION:BATCH-MODE
       run_time      = TIME.

IF batch_mode THEN DO:
   PUT STREAM logfile UNFORMATTED
       " " skip
       "{&PRO_DISPLAY_NAME} to MSS Log" skip(2)
       "Original {&PRO_DISPLAY_NAME} Database:            " pro_dbname skip
       "Other {&PRO_DISPLAY_NAME} DB Connect Parameters : " pro_conparms  skip
       "Logical Database Name:                 " mss_pdbname SKIP
       "ODBC Data Source Name:                 " mss_dbname SKIP
       "{&PRO_DISPLAY_NAME} Schema Holder Name:           " osh_dbname skip
       "MSS Username:                         " mss_username skip
       "Maximum Varchar Length:               " long-length SKIP       
       "Codepage for Schema Image:            " mss_codepage SKIP
       "Collation Name:                       " mss_collname SKIP    
       "Insensitive:                          " mss_incasesen SKIP   
       "Create RECID Field :                  " pcompatible skip
       "Create RECID using             :      " (IF iRecidOption = 2 THEN
                                                    "Computed Column"
                                                 ELSE  "Trigger")
                                                  SKIP

       "Field Width Calculation Based on:      " (IF iFmtOption = 1 THEN
                                                    "_Field._Width field"
                                                  ELSE IF (lFormat = FALSE) THEN
                                                    "Calculation"
                                                  ELSE "_Field._Format field")
                                                  SKIP
       "Create Objects in MSS:                " loadsql skip
       "Moved Data to MSS:                    " movedata SKIP
       "Create Shadow Columns:                " shadowcol SKIP       
       "Include Defaults:                     " dflt SKIP       
       "Use Revised Sequence Generator:       " newseq SKIP
       "Use Native Sequence Generator:        " nativeseq SKIP
       "Cache Size:                           " cachesize SKIP
       "Map to MSS Datetime Type:             " mapMSSDatetime SKIP.

        IF OS-GETENV("UNICODETYPES") NE ? THEN
            PUT STREAM logfile UNFORMATTED
        "Unicode Types:                        " unicodeTypes skip
        "Expand Width (utf-8):                 " lUniExpand skip(2).
END.

IF loadsql THEN DO:
  ASSIGN stages[mss_create_sql] = TRUE
         stages[mss_build_schema] = TRUE
         stages[mss_fixup_schema] = TRUE
         stages[mss_create_objects] = TRUE.
  
  IF not batch_mode THEN
     HIDE MESSAGE NO-PAUSE.
  ASSIGN schname = osh_dbname + ".db".
  IF search (schname) <> ? THEN do:
    connect VALUE(osh_dbname) -1 no-error.
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
               " must not be the same as schema holder or {&PRO_DISPLAY_NAME} Database Name"
                skip(2).
    ELSE DO:
      &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
           MESSAGE "Logical Database Name " mss_pdbname 
             " must not be the same as schema holder or {&PRO_DISPLAY_NAME} Database Name".
      &ELSE
           MESSAGE "Logical Database name " mss_pdbname 
             " must not be the same as schema holder or {&PRO_DISPLAY_NAME} Database Name"
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
       user_env[11] = (IF unicodeTypes THEN "nvarchar" ELSE "varchar" )
       user_env[12] = (IF mapMSSDatetime THEN "datetime" ELSE "date")
       user_env[13] = "tinyint"
       user_env[14] = "integer"
       user_env[15] = "decimal(18,5)"
       user_env[16] = "decimal"
       user_env[17] = "integer"
       user_env[18] = (IF unicodeTypes THEN "nvarchar(max)" ELSE "text")
       user_env[19] = "tinyint"
       user_env[20] = "##"  
       user_env[21] = (IF shadowcol THEN "y" ELSE "n")
       user_env[22] = "MSS"
       user_env[23] = "30"
       user_env[24] = "15"
       /* first y is for sequence support.
          second entry is for new sequence generator 
          third entry is for use newer datatime types 
       */
       user_env[25] = "y" + (IF newseq THEN ",y" ELSE ",n") + 
                      (IF mapMSSDatetime THEN ',n' ELSE ',y') + 
		      (IF nativeseq THEN ",y" ELSE ",n" ) +
		      (IF cachesize <> ? THEN "," + string(cachesize) ELSE " ")
       user_env[26] = mss_username
       user_env[28] = "128"
       user_env[29] = "128"            
       user_env[30] = "y"
       user_env[31] = "-- ** "
       user_env[32] = "MSSQLSRV7".
       user_env[37] = "PP". /* PP - Pull as part of Push *
                             * IP - Independent PULL operation */
       user_env[38] = choiceUniquness . /* 195067 */
       user_env[39] = choiceDefault . /* 195067 */       


IF pcompatible THEN 
   ASSIGN user_env[27] = "y" + "," + STRING(iRecidOption) +
         (IF forRowidUniq THEN ',U' ELSE IF choiceRowid = 1 THEN ',D' ELSE ',P').
/* D -> Default functionality "ROWID" ,P -> Prime ROWID ,U -> ROWID uniqueness */
ELSE
   ASSIGN user_env[27] = "no".

IF (iFmtOption = 1) THEN 
  ASSIGN user_env[33] = "y".
ELSE IF (lFormat = FALSE) THEN
  ASSIGN user_env[33] = "n".
ELSE
  ASSIGN user_env[33] = "?".

IF descidx THEN 
   ASSIGN user_env[34] = "y".
ELSE
   ASSIGN user_env[34] = "n".
        
IF lUniExpand THEN 
   ASSIGN user_env[35] = "y".
ELSE
   ASSIGN user_env[35] = "n".

 /* first y is for Migrate Constraints.
   second entry is Try Primary for ROWID.
   third entry is RECID compatibility.
   fourth entry is Select 'BEST' ROWID index.
 */
ASSIGN user_env[36] = (IF migConstraint THEN "y" ELSE "n") +
               (IF tryPimaryForRowid THEN ",y" ELSE ",n") +
               (IF recidCompat THEN ",y" ELSE ",n"). 
IF selBestRowidIdx THEN 
    ASSIGN user_env[36] = user_env[36] + ",y" + "," + STRING(choiceSchema).
ELSE ASSIGN user_env[36] = user_env[36] + ",n".
IF movedata THEN ASSIGN user_env[36] = user_env[36] + ",y".
            ELSE ASSIGN user_env[36] = user_env[36] + ",n".

RUN prgs-ranking. 
IF movedata THEN
  ASSIGN stages[mss_dump_data] = TRUE
         stages[mss_load_data] = TRUE.

    /* md0: creates SQL */
RUN "prodict/mss/_mss_md0.p".

/*
IF not stages[mss_create_sh] THEN LEAVE.
*/
IF loadsql THEN DO:

  /* check if unicode types and non utf-8 codepage and give warning */
  IF unicodeTypes AND TRIM(mss_codepage) NE "utf-8" THEN DO:
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

    IF unicodeTypes OR TRIM(mss_codepage) = "utf-8" THEN DO:
        if OPSYS = "Win32":U then 
           GET-KEY-VALUE SECTION "Startup":U KEY "DLC":U VALUE dlc_utf_edb. 
        if (dlc_utf_edb = ? or dlc_utf_edb EQ "") then
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
  
  ASSIGN stages_complete[mss_create_sh] = TRUE
         stages[mss_create_objects]     = TRUE.
    
  /* md1: creates SI and MSS-Schema using send-sql.p
   *      pulls schema into SI
   *      beautifies SI by comparing it and matching it up with 
   *            the original progress-db
   */

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

