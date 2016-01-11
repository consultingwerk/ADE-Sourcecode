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
    fernando   12/12/07 Don't need to set user_env[5] anymore
    
Multi-DB-Support:
    the syntax of file-name is:
           [ <DB>. ] <tbl>             [ <DB>. ] <tbl>
        {  ---------------  }  [ , {  ---------------  } ] ...
             <DB>."ALL"                  <DB>."ALL"
    {   -----------------------------------------------------------  }
                        "ALL"
Example:

This is an example on how to call this proc persistently to set the
newly added options:

DEF VAR h AS HANDLE NO-UNDO.
RUN prodict/load_d.p PERSISTENT SET h 
    (INPUT file-name, INPUT dot-d-dir).
RUN setLobDir IN h (input cLob-Dir). /* this is optional */ 
RUN doLoad IN h.
DELETE PROCEDURE h.

super-tenant rules.
Setting set-effective-tenant before calling this will cause tenant data
to be dumped in the (dot-d-dir) standard directory or file-name 

This is an example on how to call this proc persistently to have more control
over multi-tenant options:

    
--- default location - create subdirs if necessary  --
RUN prodict/load_d.p PERSISTENT SET h 
    (INPUT file-name, INPUT dot-d-dir).
RUN setEffectiveTenant IN h (gtenant). 
RUN doLoad IN h.
DELETE PROCEDURE h.

shared data will be loaded from            dot-d-dir
effective tenant data will be loaded from  dot-d-dir + "/" + gtenant
shared lobs will be loaded from            dot-d-dir + "/lobs"
effective tenant lobs will be loaded from  dot-d-dir+ "/" + gtenant + "/lobs"

--- default location no-lobs - create subdirs if necessary  --
RUN prodict/load_d.p PERSISTENT SET h 
    (INPUT file-name, INPUT dot-d-dir).
RUN setEffectiveTenant IN h (gtenant). 
RUN setNoLobs IN h (true). 
RUN doLoad IN h.
DELETE PROCEDURE h.

shared data will be loaded from           dot-d-dir
effective tenant data will be loaded from dot-d-dir + "/" + gtenant

--- specify location  ---
RUN prodict/load_d.p PERSISTENT SET h 
    (INPUT file-name, INPUT dot-d-dir).
RUN setUseDefaultLocation IN h (false). 
RUN setEffectiveTenant IN h (gtenant). 
RUN setTenantDir IN h (gtenantdir). 
RUN setLobDir IN h (globdir). 
RUN setTenantLobDir IN h (gtenantlobdir). 

RUN doLoad IN h.
DELETE PROCEDURE h.

shared data will be loaded from            dot-d-dir
effective tenant data will be loaded from gtenantdir
shared lobs will be loaded from            globdir
effective tenant lobs will be loaded from gtenantlobdir

--- all data in current directory  don't use default  ---
RUN prodict/load_d.p PERSISTENT SET h 
    (INPUT file-name, INPUT dot-d-dir).
RUN setEffectiveTenant IN h (gtenant). 
RUN setUseDefaultLocation IN h (false). 
RUN doLoad IN h.
DELETE PROCEDURE h.

all data will be loaded from dot-d-dir
--
Summary: 
1. tenant and lob directories will be loaded from subdirs named after tenant  

2. setTenantDir, setLobDir and setTenantLobDir is ONLY used if 
   setEffectiveTenant is used together with setUseDefaultLocation in h(false). 


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

DEFINE VARIABLE gLobDir         AS CHARACTER NO-UNDO.
DEFINE VARIABLE gTenantDir      AS CHARACTER NO-UNDO.
DEFINE VARIABLE gTenantLobDir   AS CHARACTER NO-UNDO.
DEFINE VARIABLE gTenant         AS CHARACTER NO-UNDO.
define variable gNoLobs         as logical   no-undo.
define variable gUseDefault     as logical   no-undo init ?.
define variable save_tenant     as character no-undo.

DEFINE TEMP-TABLE ttb_dump
        FIELD db        AS CHARACTER
        FIELD tbl       AS CHARACTER
        INDEX upi IS PRIMARY UNIQUE db tbl.
        

/*---------------------------  MAIN-CODE  --------------------------*/
/* if not running persistenty, go ahead and dump the definitions */
IF NOT THIS-PROCEDURE:PERSISTENT THEN
   RUN doLoad.

/*--------------------------- INTERNAL PROCS  --------------------------*/

PROCEDURE doLoad:
    /****** general initialisations ***********************************/
    
    /* as of current just let the ABL  deal with error */
    if gtenant > "" then
        set-effective-tenant(gtenant,"dictdb"). 
    
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
      /* Now we don't have do this. A blank string will indicate disable triggers
         for all files.
      */
      /*
      ASSIGN user_env[5] = "y".
      DO i = 2 TO NUM-ENTRIES((IF isCpUndefined THEN user_env[1] ELSE user_longchar)):
        ASSIGN user_env[5] = user_env[5] + ",y".
      END.
      */
    
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
      
      if gTenant <> "" then 
      do:
          user_env[32] = gTenant.
          if gUseDefault then 
          do:         
             assign
                 user_env[33] = user_env[2] + gTenant + "/"
                 user_env[30] = user_env[2] + "lobs/"
                 user_env[34] = user_env[33] + "lobs/".
       
          end.
          else do:
             assign
                 user_env[33] = gTenantDir
                 user_env[30] = gLobDir
                 user_env[34] = gTenantLobDir. 
          end.
      end.
      else 
         user_env[30] = gLobDir.
       
      
      RUN "prodict/dump/_loddata.p".
    
    END.    /* all _Db's */
    
    RETURN.
    finally:
        /* clean up tenant and lob globals */
        assign
            user_env[32] = ""
            user_env[33] = ""
            user_env[30] = ""
            user_env[34] = "". 
          
        SESSION:APPL-ALERT-BOXES = save_ab.
        if save_tenant > "" then
            set-effective-tenant(save_tenant,"dictdb").         
    end finally.      
END. /* doLoad*/

PROCEDURE setFileName:
    DEFINE INPUT PARAMETER pfile-name AS CHAR NO-UNDO.
    ASSIGN file-name = pfile-name.
END.

PROCEDURE setDirectory:
    DEFINE INPUT PARAMETER pdot-d-dir AS CHAR NO-UNDO.
    ASSIGN dot-d-dir = pdot-d-dir.
END.

PROCEDURE setNoLobs:
    DEFINE INPUT PARAMETER pNoLobs AS logical NO-UNDO.
    ASSIGN gNoLobs = pNoLobs.
END.

PROCEDURE setLobDir:
    DEFINE INPUT PARAMETER pcLob-Dir AS CHAR NO-UNDO.
    ASSIGN gLobDir = pcLob-Dir.
END.

PROCEDURE setUseDefaultLocation:
    DEFINE INPUT PARAMETER pldefault AS logical NO-UNDO.
    ASSIGN gUseDefault = pldefault.
END.

PROCEDURE setEffectiveTenant:
    DEFINE INPUT PARAMETER pcTenant AS CHAR NO-UNDO.
    if save_tenant = "" then
        save_tenant = get-effective-tenant-name("dictdb").
  
    gTenant = pctenant.
    if gUseDefault = ? then 
       gUseDefault = true.
END.

PROCEDURE setTenantDir:
    DEFINE INPUT PARAMETER pcDir AS CHAR NO-UNDO.
    ASSIGN gTenantDir = pcDir.
END.

PROCEDURE setTenantLobDir:
    DEFINE INPUT PARAMETER pcDir AS CHAR NO-UNDO.
    ASSIGN gTenantLobDir = pcDir.
END.

 


