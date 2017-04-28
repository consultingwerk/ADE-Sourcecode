/******************************************************************
* Copyright (C) 2016-2017 by Progress Software Corporation. All   *
* rights reserved.  Prior versions of this work may contain       *
* portions contributed by participants of Possenet.               *
*                                                                 *
******************************************************************/
/*------------------------------------------------------------------------
    File        : load_cdc.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : mkondra
    Created     : Thu Jul 07 18:25:31 IST 2016
    Notes       :
  ----------------------------------------------------------------------*/
/* file-name may be either a specific file*/
/* 
File:   prodict/load_cdc.p

IN:
    file-name                : "<file-name>"
    dot-d-dir                : directory relativ to working-directory
    
Multi-DB-Support:
    the syntax of file-name is:
           [ <DB>. ] <tbl>             [ <DB>. ] <tbl>
        {  ---------------  }  [ , {  ---------------  } ] ...            
Example:

This is an example on how to call this proc persistently to set the
newly added options:

DEF VAR h AS HANDLE NO-UNDO.
RUN prodict/load_cdc.p PERSISTENT SET h 
    (INPUT file-name, INPUT dot-d-dir).
RUN doLoad IN h.
DELETE PROCEDURE h.
  
***************************************************************************************/

using OpenEdge.DataAdmin.Binding.ITableDataMonitor from propath .

DEFINE INPUT PARAMETER file-name AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER dot-d-dir AS CHARACTER NO-UNDO.

{ prodict/dictvar.i NEW }
{ prodict/user/uservar.i NEW }
 
DEFINE VARIABLE isCpUndefined   AS LOGICAL           NO-UNDO.

DEFINE VARIABLE gLobDir         AS CHARACTER         NO-UNDO.
DEFINE VARIABLE gLobDirName     AS CHARACTER         NO-UNDO init "lobs":U.
DEFINE VARIABLE gTenantDir      AS CHARACTER         NO-UNDO.
DEFINE VARIABLE gTenantLobDir   AS CHARACTER         NO-UNDO.
DEFINE VARIABLE gTenant         AS CHARACTER         NO-UNDO.
define variable gNoLobs         as logical           no-undo.
define variable gUseDefault     as logical           no-undo init ?.
define variable gGroupDir       as CHARACTER         no-undo.
DEFINE VARIABLE gSilent         AS LOGICAL           NO-UNDO.
DEFINE VARIABLE gErrorPercent   AS int               NO-UNDO.
DEFINE VARIABLE gExternalTenant AS char              NO-UNDO.
define variable ghTempTable     as handle            no-undo.
define variable gGroupDirName   as CHARACTER         no-undo init "groups":U.
define variable gUseDefaultOut  as character         no-undo init "<default>".
define variable gMonitor        as ITableDataMonitor no-undo.

DEFINE TEMP-TABLE ttb_dump
    FIELD db  AS CHARACTER
    FIELD tbl AS CHARACTER
    INDEX upi IS PRIMARY UNIQUE db tbl.
        

/*---------------------------  MAIN-CODE  --------------------------*/
/* if not running persistenty, go ahead and dump the definitions */
IF SESSION:CPINTERNAL EQ "undefined":U THEN
    isCpUndefined = YES.
    
IF NOT THIS-PROCEDURE:PERSISTENT THEN
    RUN doLoad.

/*--------------------------- INTERNAL PROCS  --------------------------*/

PROCEDURE doLoad:
    
    define variable GroupCount      as integer   no-undo.
    define variable lFound          as logical   no-undo.
    define variable iMtcount        as integer   no-undo.
    define variable hQ              as handle    no-undo.
    define variable hBuffer         as handle    no-undo.
  
    /* for the single table variation */
    define variable l_Dump-name     as character no-undo.
    define variable l_Mt            as logical   no-undo.
          
    DEFINE VARIABLE i               AS INTEGER   NO-UNDO.
    DEFINE VARIABLE l_db-name       AS CHARACTER NO-UNDO.
    DEFINE VARIABLE l_for-type      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE l_int           AS INTEGER   NO-UNDO.
    DEFINE VARIABLE l_item          AS CHARACTER NO-UNDO.
    DEFINE VARIABLE l_list          AS CHARACTER NO-UNDO.
    DEFINE VARIABLE save_ab         AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE all_shared      AS LOGICAL   NO-UNDO INITIAL FALSE.
    DEFINE VARIABLE all_multitenant AS LOGICAL   NO-UNDO INITIAL FALSE.
    define variable cSlash          as character no-undo.    
    
    EMPTY TEMP-TABLE ttb_dump NO-ERROR.
    
    IF SESSION:CPINTERNAL EQ "undefined":U THEN
        isCpUndefined = YES.
        
    if file-name = "<shared>" then 
    do: 
        assign 
            all_shared = true
            file-name  = "ALL".
    end.    
             
    ASSIGN 
        save_ab                  = SESSION:APPL-ALERT-BOXES
        SESSION:APPL-ALERT-BOXES = NO
        user_env[3]              = "" /* "MAP <name>" or "NO-MAP" OR "" */
        user_env[4]              = (if gErrorPercent > 0 then string(gErrorPercent) else "0")
        user_env[6]              = "f"  /* log errors to file by default */
        dot-d-dir                = (IF dot-d-dir MATCHES "*" + "/"   OR 
                                           dot-d-dir MATCHES "*" + ".cd" OR
                                           dot-d-dir    =    "" THEN  
                                          dot-d-dir ELSE dot-d-dir + "/").
    if gSilent then assign user_env[6] = "load-silent".
    
    /****** 1. step: create temp-table from input file-list ***********/
    if not valid-handle(ghTempTable) then
    do:        
        ASSIGN 
            l_list = file-name.
        REPEAT i = 1 TO NUM-ENTRIES(l_list):
            CREATE ttb_dump.
            ASSIGN 
                l_item = ENTRY(i,l_list)
                l_int  = INDEX(l_item,".").
            IF l_int = 0 THEN  
                ASSIGN ttb_dump.db  = ""
                    ttb_dump.tbl = l_item.
            ELSE if SUBSTRING(l_item,l_int, -1,"character") eq ".cd" then do:
                //to handle input for file-name with .cd extention and DB name is not provided
                //e.g. <filename>.cd
                ASSIGN ttb_dump.db  = ""
                    ttb_dump.tbl = SUBSTRING(l_item,1,l_int - 1,"character").
            end.
            else if SUBSTRING(l_item,r-INDEX(l_item,"."), -1,"character") eq ".cd" and num-entries (l_item,".") eq 3 then do:
                //to handle input for file-name with .cd extention and DB name
                //e.g. <databasename>.<filename>.cd
                ASSIGN ttb_dump.db  = SUBSTRING(l_item,1,l_int - 1,"character")
                    ttb_dump.tbl = SUBSTRING(l_item,INDEX(l_item,".") + 1, R-INDEX(l_item,".") - 1 - INDEX(l_item,"."),"character").
            end.
            else do: 
                if entry(2,l_item,".") <> "cd" then 
                do:
                    MESSAGE "You must Provide a valid .cd file!" view-as alert-box error.
                    return.
                end.
                ASSIGN ttb_dump.db  = SUBSTRING(l_item,1,l_int - 1,"character")
                       ttb_dump.tbl = SUBSTRING(l_item,l_int + 1, -1,"character").
            end.
    
            IF ttb_dump.db > '' AND
                NOT CONNECTED(ttb_dump.db) THEN do:
                MESSAGE "Database " + ttb_dump.db + " not connected!".
                return.
            end.
        END.        
    end.  
    
    /****** 2. step: prepare user_longchar for this _db-record **********/
      
    FOR EACH DICTDB._Db NO-LOCK:
    
        ASSIGN 
            l_db-name     = (IF DICTDB._DB._DB-Type = "PROGRESS" THEN 
                              LDBNAME("DICTDB") ELSE _DB._DB-name)
            user_env[1]   = ""
            user_longchar = (IF isCpUndefined THEN user_longchar ELSE "")
            l_for-type    = (IF CAN-DO("PROGRESS",DICTDB._DB._DB-Type) THEN 
                              ? ELSE "TABLE,VIEW").
                              
        if not valid-handle(ghTempTable) then
        do:                         
            /* to generate the list of tables of this _db-record to be loaded and
             * assign it to user_longchar we
             * a) try to use all tables WITHOUT db-specifyer
             */
            FOR EACH ttb_dump WHERE ttb_dump.db = "":                
                /*
                find dictdb._Database-feature where dictdb._Database-feature._DBFeature_Name = "Change Data Capture" no-lock no-error.
                   isCDCEnabled = avail dictdb._Database-feature and dictdb._Database-feature._dbfeature_enabled = "1".   */
                IF INTEGER(DBVERSION("DICTDB")) >= 11 THEN
                    find DICTDB._File of DICTDB._Db where DICTDB._File._File-name = "_Cdc-Table-Policy"
                        AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")
                        no-lock no-error.
                ELSE MESSAGE "Database " + ttb_dump.db + " is not supported for Change Data Capture".
                            
                if not avail DICTDB._File then 
                    MESSAGE "Database " + ttb_dump.db + " is not enabled for Change Data Capture".  
                    
                    //find DICTDB._CDC-Table-Policy where DICTDB._CDC-Table-Policy._policy-name = ttb_dump.tbl no-lock no-error.                           
                    //if available DICTDB._CDC-Table-Policy  then 
                    //do:
                IF isCpUndefined THEN
                    assign user_env[1] = user_env[1] + "," + ttb_dump.tbl.
                ELSE
                    assign user_longchar = user_longchar + "," + ttb_dump.tbl.                      
                    //end.                 
            end.
        
            /* b) try to use all tables WITH db-specifyer */
            for each ttb_dump where ttb_dump.db = l_db-name :
                
                IF INTEGER(DBVERSION("DICTDB")) >= 11 THEN
                    find DICTDB._File of DICTDB._Db where DICTDB._File._File-name = "_Cdc-Table-Policy"
                        AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")
                        no-lock no-error.
                ELSE MESSAGE "Database " + ttb_dump.db + " is not supported for Change Data Capture".
                            
                if not avail DICTDB._File then 
                    MESSAGE "Database " + ttb_dump.db + " is not enabled for Change Data Capture".                          
                    
                IF isCpUndefined THEN
                    assign user_env[1] = user_env[1] + "," + ttb_dump.tbl.
                ELSE
                    assign user_longchar = user_longchar + "," + ttb_dump.tbl.                  
            end.
            IF isCpUndefined THEN
                user_env[1] = substring(user_env[1],2,-1,"character").
            else
                user_longchar = substring(user_longchar,2,-1,"character").
        end. /* not valid ghTempTable */
        else 
        do:
            create query hq.
            hBuffer = ghTempTable:default-buffer-handle.
            hq:add-buffer(hBuffer).
            /* add the policy list to user_env[1]/user_longchar in the sequence order, the way its written in the .cd file.
               Using policySequence to find the order of the policies */ 
            hq:query-prepare("for each " + ghTempTable:name
                + " where " + ghTempTable:name + ".databasename = " + quoter(l_db-name)
                + " by " + ghTempTable:name + ".policySequence").
            hq:query-open().
            hq:get-first ().
          
            do while hBuffer:avail:              
                if isCpUndefined then
                    user_env[1] = user_env[1] 
                                + (if user_env[1] = "" then "" else ",") 
                                + hBuffer::name .
                else user_longchar = user_longchar 
                                +  (if user_longchar = "" then "" else ",") 
                                + hBuffer::name.
                //file-name = hbuffer::dumpName.
               /* 
                IF INTEGER(DBVERSION("DICTDB")) > 8 THEN
                    FIND DICTDB._File OF DICTDB._Db 
                        WHERE DICTDB._File._File-name = hBuffer::name AND 
                        (DICTDB._File._Owner = "PUB" OR 
                        DICTDB._File._Owner = "_FOREIGN") NO-LOCK NO-ERROR.
                ELSE
                    FIND DICTDB._File OF DICTDB._Db 
                        WHERE DICTDB._File._File-name = hBuffer::name NO-LOCK NO-ERROR. 
     
                IF AVAILABLE DICTDB._File THEN 
                DO: 
                    IF CAN-DO(l_for-type,DICTDB._File._For-type) 
                        OR l_for-type = ? THEN 
                    DO:
              
                        l_dump-name = (IF DICTDB._File._dump-name <> ? 
                            THEN DICTDB._File._dump-name 
                            ELSE LC(DICTDB._File._file-name)).
                        IF isCpUndefined THEN
                            user_env[1] = user_env[1] 
                                + (if user_env[1] = "" then "" else ",") 
                                + hBuffer::name .
                        ELSE
                            user_longchar = user_longchar 
                                +  (if user_longchar = "" then "" else ",") 
                                + hBuffer::name.
          
                        if DICTDB._File._file-attributes[1] then
                            iMtCount = iMtCount + 1.
                    END.    
                END. */
                hq:get-next.
            end.
            delete object Hq.
        end.  
    
        /* is there something to load into this _db? */
        //if NOT isCpUndefined AND user_longchar = "" then next.
        //if     isCpUndefined AND user_env[1] = ""   then next.
    
        /****** 3. step: prepare user_env[2] and user_env[5] **************/
        /* if one file =>  .d-name otherwise path
           always do this if temp-table is used 
           load_d checks if user_env[2] ends with "/"
           to add filename also for the single table case 
           when the temp-tablee is used   */ 
        IF  NUM-ENTRIES((IF isCpUndefined THEN user_env[1] 
        ELSE user_longchar)) > 1              
            OR  dot-d-dir MATCHES "*" + ".cd" THEN 
            ASSIGN user_env[2] = dot-d-dir.  /* just path or .d-file-name */       
        else  /* full path and name of .d-file */
            ASSIGN user_env[2] = dot-d-dir + 
                             (STRING(IF isCpUndefined THEN user_env[1] ELSE user_longchar)) +
                             ".cd".     
        if valid-handle(ghTempTable) then 
            assign user_env[2] = dot-d-dir + if file-name matches "*" + ".cd" 
                                         then file-name else file-name + ".cd".
        /* other needed assignments */
        ASSIGN 
            drec_db     = RECID(_Db)
            user_dbname = (IF _Db._Db-name = ? THEN 
                              LDBNAME("DICTDB") ELSE _Db._Db-Name)
            user_dbtype = (IF _Db._Db-name = ? THEN 
                              DBTYPE("DICTDB") ELSE _Db._Db-Type).
    
        /****** 4. step: the actual loading-process ***********************/
    
        IF NOT isCpUndefined THEN 
        DO:
            /* see if we can put user_longchar into user_env[1] */
            ASSIGN 
                user_env[1] = user_longchar NO-ERROR.
            IF NOT ERROR-STATUS:ERROR THEN
                /* ok to use user_env[1] */
                ASSIGN user_longchar = "". 
            ELSE
                ASSIGN user_env[1] = "".
        END.

        if valid-object(gMonitor) then
            dictMonitor = gMonitor. 
        RUN "prodict/dump/_lodcdcdata.p".
        catch e as Progress.Lang.Error :
            if gSilent then
                undo, throw e.
            else 
                run showError(e).       
        end catch.
    
    END.    /* for each  _Db's */
    
    RETURN.
    catch e as Progress.Lang.Error :
        if gSilent then
            undo, throw e.
        else 
            run showError(e).     
    end catch.
    
    finally:
        /* clean up tenant and globals - keep properties */
        assign
            dictMonitor              = ?
            user_env                 = ""           
            SESSION:APPL-ALERT-BOXES = save_ab.             
    end finally.      
END. /* doLoad*/

procedure showError:
    define input  parameter pError as Progress.Lang.Error no-undo.
    define variable i as integer no-undo.
    do i = 1 to pError:NumMessages:
        message pError:GetMessage(i)
            view-as alert-box error.      
    end.        
end.    

PROCEDURE setFileName:
    DEFINE INPUT PARAMETER pfile-name AS CHAR NO-UNDO.
    ASSIGN 
        file-name = pfile-name.
    ghTempTable = ?.
END.

PROCEDURE setDirectory:
    DEFINE INPUT PARAMETER pdot-d-dir AS CHAR NO-UNDO.
    ASSIGN 
        dot-d-dir = pdot-d-dir.
END.

PROCEDURE setNoLobs:
    DEFINE INPUT PARAMETER pNoLobs AS logical NO-UNDO.
    ASSIGN 
        gNoLobs = pNoLobs.
END.

PROCEDURE setLobDir:
    DEFINE INPUT PARAMETER pcLob-Dir AS CHAR NO-UNDO.
    ASSIGN 
        gLobDir = pcLob-Dir.
END.

PROCEDURE setLobDirName:
    DEFINE INPUT PARAMETER pcLobName AS CHAR NO-UNDO.
    ASSIGN 
        gLobDirName = pcLobName.
END.

PROCEDURE setUseDefaultLocation:
    DEFINE INPUT PARAMETER pldefault AS logical NO-UNDO.
    ASSIGN 
        gUseDefault = pldefault.
END.

PROCEDURE setEffectiveTenant:
    DEFINE INPUT PARAMETER pcTenant AS CHAR NO-UNDO.
    if gExternalTenant = "" then
        gExternalTenant = get-effective-tenant-name("dictdb").
  
    gTenant = pctenant.
    if gUseDefault = ? then 
        gUseDefault = true.
END.

PROCEDURE setGroupDir:
    DEFINE INPUT PARAMETER pcDir AS CHAR NO-UNDO.
    gGroupDir = pcDir.
END.

PROCEDURE setGroupDirName:
    DEFINE INPUT PARAMETER pcDir AS CHAR NO-UNDO.
    gGroupDirName = pcDir.
END.

PROCEDURE setTenantDir:
    DEFINE INPUT PARAMETER pcDir AS CHAR NO-UNDO.
    ASSIGN 
        gTenantDir = pcDir.
END.

PROCEDURE setTenantLobDir:
    DEFINE INPUT PARAMETER pcDir AS CHAR NO-UNDO.
    ASSIGN 
        gTenantLobDir = pcDir.
END.

PROCEDURE SetSilent:
    DEFINE INPUT PARAMETER setsilent AS LOGICAL NO-UNDO.
    ASSIGN 
        gSilent = setsilent.
END.

PROCEDURE SetAcceptableErrorPercentage:
    DEFINE INPUT PARAMETER errpercent AS INTEGER NO-UNDO.
    ASSIGN 
        gErrorPercent = errpercent.
END.
 
/** set a temptable handle with lsit of tables to load.
    the table must have databasename with logical name (currently only used with ldbname("dictdb"))
    and a name field with the table name */ 
PROCEDURE SetTable:
    DEFINE INPUT PARAMETER table-handle h.
    ASSIGN 
        ghTempTable = h.
END.

/** set the monitor for status log */
PROCEDURE SetMonitor:
    DEFINE INPUT PARAMETER pmon as ITableDataMonitor.
    ASSIGN 
        gMonitor = pmon.
END.


