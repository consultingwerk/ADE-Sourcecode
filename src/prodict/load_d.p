/*********************************************************************
* Copyright (C) 2007 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/


/* file-name may be either a specific file or ALL */
/* 
File:   prodict/load_d.p

IN:
    file-name                : "ALL" or "<file-name>"
    dot-d-dir                : directory relativ to working-directory
    
History
    mcmann     10/17/03 Add NO-LOCK statement to _Db find in support of on-line schema add
    mcmann     07/13/01 Added check for environmental variable DSTYPE
    mcmann     98/07/13 Added _Owner check for V9
    laurief     97/12   Removed RMS,CISAM code
    hutegger    95/06   multi-db support
    kmcintos   10/19/05 Added error handling for not connected dbs and 
                        unavailable tables.  Also fixed dump-name logic to
                        use _file-name when blank and generally made the
                        procedure more readable 20050930-008. 
    fernando   03/16/06 Handle case with too many tables selected - bug 20050930-006.    
    fernando   02/27/07 Support for long dump name - OE00146586

Multi-DB-Support:
    the syntax of file-name is:
           [ <DB>. ] <tbl>             [ <DB>. ] <tbl>
        {  ---------------  }  [ , {  ---------------  } ] ...
             <DB>."ALL"                  <DB>."ALL"
    {   -----------------------------------------------------------  }
                        "ALL"

*/
DEFINE INPUT PARAMETER file-name AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER dot-d-dir AS CHARACTER NO-UNDO.

{ prodict/dictvar.i NEW }
{ prodict/user/uservar.i NEW }

DEFINE VARIABLE c           AS CHARACTER NO-UNDO INITIAL "".
DEFINE VARIABLE i           AS INTEGER   NO-UNDO.
DEFINE VARIABLE l_db-name   AS CHARACTER NO-UNDO.
DEFINE VARIABLE l_dump-name AS CHARACTER NO-UNDO.
DEFINE VARIABLE l_for-type  AS CHARACTER NO-UNDO.
DEFINE VARIABLE l_int       AS INTEGER   NO-UNDO.
DEFINE VARIABLE l_item      AS CHARACTER NO-UNDO.
DEFINE VARIABLE l_list      AS CHARACTER NO-UNDO.
DEFINE VARIABLE save_ab     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE isCpUndefined AS LOGICAL NO-UNDO.

DEFINE TEMP-TABLE ttb_dump
        FIELD db        AS CHARACTER
        FIELD tbl       AS CHARACTER
        INDEX upi IS PRIMARY UNIQUE db tbl.
        

/****** general initialisations ***********************************/

IF SESSION:CPINTERNAL EQ "undefined":U THEN
    isCpUndefined = YES.

ASSIGN save_ab                   = SESSION:APPL-ALERT-BOXES
       SESSION:APPL-ALERT-BOXES  = NO
       user_env[3]               = "" /* "MAP <name>" or "NO-MAP" OR "" */
       user_env[4]               = "0"
       user_env[6]               = "f"  /* log errors to file by default */
       dot-d-dir                 = (IF dot-d-dir MATCHES "*" + "/"   OR 
                                       dot-d-dir MATCHES "*" + ".d"  OR 
                                       dot-d-dir MATCHES "*" + ".ad" OR
                                       dot-d-dir    =    "" THEN  
                                      dot-d-dir ELSE dot-d-dir + "/").

/* This allows the bulk load utility of a dataserver to be run */
IF OS-GETENV("DSTYPE")   <> ? THEN
  user_env[35]  = OS-GETENV("DSTYPE").
/****** 1. step: create temp-table from input file-list ***********/

IF file-name = "ALL" THEN DO:  /* load ALL files of ALL dbs */
  FOR EACH DICTDB._DB NO-LOCK:
    CREATE ttb_dump.
    ASSIGN ttb_dump.db  = (IF DICTDB._DB._DB-Type = "PROGRESS" THEN 
                             LDBNAME("DICTDB") ELSE DICTDB._DB._Db-name)
           ttb_dump.tbl = "ALL".
  END.    
END.     /* load ALL fiels of ALL dbs */
ELSE DO:  /* load SOME files of SOME dbs */
 
  ASSIGN l_list = file-name.
  REPEAT i = 1 TO NUM-ENTRIES(l_list):
    CREATE ttb_dump.
    ASSIGN l_item = ENTRY(i,l_list)
           l_int  = INDEX(l_item,".").
    IF l_int = 0 THEN  
      ASSIGN ttb_dump.db  = ""
             ttb_dump.tbl = l_item.
    ELSE 
      ASSIGN ttb_dump.db  = SUBSTRING(l_item,1,l_int - 1,"character")
             ttb_dump.tbl = SUBSTRING(l_item,l_int + 1, -1,"character").

    IF ttb_dump.db > '' AND
       NOT CONNECTED(ttb_dump.db) THEN 
      MESSAGE "Database " + ttb_dump.db + " not connected!".
  END.
END.     /* dump SOME files of SOME dbs */

/****** 2. step: prepare user_longchar for this _db-record **********/
  
FOR EACH DICTDB._Db NO-LOCK:

  ASSIGN l_db-name   = (IF DICTDB._DB._DB-Type = "PROGRESS" THEN 
                          LDBNAME("DICTDB") ELSE _DB._DB-name)
         user_env[1] = ""
         user_longchar = (IF isCpUndefined THEN user_longchar ELSE "")
         l_for-type  = (IF CAN-DO("PROGRESS",DICTDB._DB._DB-Type) THEN 
                          ? ELSE "TABLE,VIEW").
/* to generate the list of tables of this _db-record to be loaded and
 * assign it to user_longchar we
 * a) try to use all tables WITHOUT db-specifyer
 */
  FOR EACH ttb_dump WHERE ttb_dump.db = "" 
                    WHILE user_env[1] <> ",all":
    IF ttb_dump.tbl <> "all" THEN DO:
      IF INTEGER(DBVERSION("DICTDB")) > 8 THEN
        FIND FIRST DICTDB._File OF DICTDB._Db 
            WHERE DICTDB._File._File-name = ttb_dump.tbl AND 
                  (DICTDB._File._Owner = "PUB" OR 
                   DICTDB._File._Owner = "_FOREIGN") NO-LOCK NO-ERROR.
      ELSE
        FIND FIRST DICTDB._File OF DICTDB._Db 
            WHERE DICTDB._File._File-name = ttb_dump.tbl NO-LOCK NO-ERROR. 

      IF AVAILABLE DICTDB._File THEN DO: 
        IF CAN-DO(l_for-type,DICTDB._File._For-type) OR
           l_for-type = ? THEN DO:
        
          ASSIGN l_dump-name = (IF DICTDB._File._dump-name <> ? THEN
                                  DICTDB._File._dump-name 
                                ELSE LC(DICTDB._File._file-name)).
          IF isCpUndefined THEN
              user_env[1] = user_env[1] + "," + ttb_dump.tbl.
          ELSE
              user_longchar = user_longchar + "," + ttb_dump.tbl.
        END.
      END.
      ELSE
        MESSAGE "Table " + ttb_dump.tbl + " does not exist in this database!".
    END.
    ELSE 
      ASSIGN user_env[1] = ",all".
  END.

/* b) try to use all tables WITH db-specifyer */
  FOR EACH ttb_dump WHERE ttb_dump.db = l_db-name
                    WHILE user_env[1] <> ",all":
    IF ttb_dump.tbl <> "all" THEN DO:
      IF INTEGER(DBVERSION("DICTDB")) > 8 THEN
        FIND FIRST DICTDB._File OF DICTDB._Db 
              WHERE DICTDB._File._File-name = ttb_dump.tbl AND 
                    (DICTDB._File._Owner = "PUB" OR 
                     DICTDB._File._Owner = "_FOREIGN") NO-LOCK NO-ERROR.
        ELSE
          FIND FIRST DICTDB._File OF DICTDB._Db 
                WHERE DICTDB._File._File-name = ttb_dump.tbl NO-LOCK NO-ERROR.                                         
      IF AVAILABLE DICTDB._File THEN DO: 
        IF CAN-DO(l_for-type,DICTDB._File._For-type) OR
           l_for-type = ? THEN DO:
        
          ASSIGN l_dump-name = (IF DICTDB._File._dump-name <> ? THEN
                                  DICTDB._File._dump-name 
                                ELSE LC(DICTDB._File._file-name)).
          IF isCpUndefined THEN
              user_env[1] = user_env[1] + "," + ttb_dump.tbl.
          ELSE
              user_longchar = user_longchar + "," + ttb_dump.tbl.
        END.
      END.
      ELSE
        MESSAGE "Table " + ttb_dump.tbl + " does not exist in this database!".
    END.
    ELSE 
      ASSIGN user_env[1] = ",all".
  END.
    
/* c) if either "all" or "all of this db" then we take every file
 *    of the current _Db
 */
  IF user_env[1] = ",all" THEN DO:  /* all files of this _Db */

    assign user_env[1] = "".
    IF NOT isCpUndefined THEN
       assign user_longchar = "".

    FOR EACH DICTDB._File WHERE DICTDB._File._File-number > 0 AND   
                                DICTDB._File._Db-recid    = RECID(_Db) AND   
                                NOT DICTDB._File._Hidden
                          BY    DICTDB._File._File-name:
      IF INTEGER(DBVERSION("DICTDB")) > 8 AND 
         (DICTDB._File._Owner <> "PUB" AND 
          DICTDB._File._Owner <> "_FOREIGN") THEN NEXT.
      
      IF l_for-type = ? OR 
         CAN-DO(l_for-type,DICTDB._File._For-type) THEN   DO:
      
        ASSIGN l_dump-name = (IF DICTDB._File._dump-name <> ? THEN
                                DICTDB._File._dump-name 
                              ELSE LC(DICTDB._File._file-name)).
        IF isCpUndefined THEN
            user_env[1] = user_env[1] + "," + DICTDB._File._File-name.
        ELSE
            user_longchar = user_longchar + "," + DICTDB._File._File-name.
      END.
    END.
    IF isCpUndefined THEN
        ASSIGN user_env[1] = SUBSTRING(user_env[1],2,-1,"character").
    ELSE 
        ASSIGN user_longchar = SUBSTRING(user_longchar,2,-1,"character").
  END.     /* all files of this _Db */
  ELSE DO:
    IF isCpUndefined THEN
        ASSIGN user_env[1] = SUBSTRING(user_env[1],2,-1,"character").
    ELSE
        ASSIGN user_longchar = SUBSTRING(user_longchar,2,-1,"character").
  END.

  /* is there something to load into this _db? */
  if NOT isCpUndefined AND user_longchar = "" then next.
  if     isCpUndefined AND user_env[1] = ""   then next.

    

/****** 3. step: prepare user_env[2] and user_env[5] **************/
  
  /* if one file => .d-name otherwise path */
  IF NUM-ENTRIES((IF isCpUndefined THEN user_env[1] ELSE user_longchar)) > 1 OR 
     dot-d-dir MATCHES "*" + ".d" OR
     dot-d-dir MATCHES "*" + ".ad" THEN 
    ASSIGN user_env[2] = dot-d-dir.  /* just path or .d-file-name */
  ELSE 
    ASSIGN user_env[2] = dot-d-dir + 
                         (IF l_Dump-name = ? THEN 
                                      STRING((IF isCpUndefined THEN user_env[1] ELSE user_longchar)) ELSE l_Dump-name) + 
                         (IF l_Dump-name BEGINS "_aud" THEN 
                            ".ad" ELSE ".d"). 
                         /* full path and name of .d-file */

  /* Indicate "y"es to disable triggers for dump of all files */
  ASSIGN user_env[5] = "y".
  DO i = 2 TO NUM-ENTRIES((IF isCpUndefined THEN user_env[1] ELSE user_longchar)):
    ASSIGN user_env[5] = user_env[5] + ",y".
  END.

  /* other needed assignments */
  ASSIGN drec_db     = RECID(_Db)
         user_dbname = (IF _Db._Db-name = ? THEN 
                          LDBNAME("DICTDB") ELSE _Db._Db-Name)
         user_dbtype = (IF _Db._Db-name = ? THEN 
                          DBTYPE("DICTDB") ELSE _Db._Db-Type).

/****** 4. step: the actual loading-process ***********************/

  IF NOT isCpUndefined THEN DO:
      /* see if we can put user_longchar into user_env[1] */
      ASSIGN user_env[1] = user_longchar NO-ERROR.
      IF NOT ERROR-STATUS:ERROR THEN
         /* ok to use user_env[1] */
         ASSIGN user_longchar = "". 
      ELSE
         ASSIGN user_env[1] = "".
  END.

  RUN "prodict/dump/_loddata.p".

END.    /* all _Db's */

SESSION:APPL-ALERT-BOXES = save_ab.
RETURN.
