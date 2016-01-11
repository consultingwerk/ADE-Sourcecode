/***********************************************************************
* Copyright (C) 2007-2012 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/


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
Multi-tenant Summary:     
Use setEffectiveTenant :
1. Use default location = true (this is default)  
The following subdirectories will be 
used (assuming default Use default location = true):
 - Tenant data will be loaded from subdirs named after tenant 
 - Group data will be loaded from subdir setGroupDirName (default = "groups") 
   with subdirs named after group. 
 - Lobs will be loaded from subdir setLobDirName (default = "lobs") under the root, 
   tenants and groups directories.
2. Set UseDefaultLocation = false  
Loads data from setTenantDir, setLobDir, SetGroupDir and setTenantLobDir. 
Group data will be loaded from setGroupDir with subdirs named after group. 

Not using setEffectiveTenant:
Gives transparent behavior for regular tenants with all data loaded from specified 
work and lob directories with no directory separation of tenant and group data 
just as if the database is non multi-tenant.     
***************************************************************************************/

using OpenEdge.DataAdmin.Binding.ITableDataMonitor from propath .

DEFINE INPUT PARAMETER file-name AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER dot-d-dir AS CHARACTER NO-UNDO.

{ prodict/dictvar.i NEW }
{ prodict/user/uservar.i NEW }
 
DEFINE VARIABLE isCpUndefined AS LOGICAL NO-UNDO.

DEFINE VARIABLE gLobDir         AS CHARACTER NO-UNDO.
DEFINE VARIABLE gLobDirName     AS CHARACTER NO-UNDO init "lobs":U.
DEFINE VARIABLE gTenantDir      AS CHARACTER NO-UNDO.
DEFINE VARIABLE gTenantLobDir   AS CHARACTER NO-UNDO.
DEFINE VARIABLE gTenant         AS CHARACTER NO-UNDO.
define variable gNoLobs         as logical   no-undo.
define variable gUseDefault     as logical   no-undo init ?.
define variable gGroupDir       as CHARACTER no-undo.
DEFINE VARIABLE gSilent         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE gErrorPercent   AS  int      NO-UNDO.
DEFINE VARIABLE gExternalTenant AS char      NO-UNDO.
define variable ghTempTable     as handle    no-undo.
define variable gGroupDirName   as CHARACTER no-undo init "groups":U.
define variable gUseDefaultOut   as character no-undo init "<default>".
define variable gMonitor         as ITableDataMonitor no-undo.

DEFINE TEMP-TABLE ttb_dump
        FIELD db        AS CHARACTER
        FIELD tbl       AS CHARACTER
        INDEX upi IS PRIMARY UNIQUE db tbl.
        

/*---------------------------  MAIN-CODE  --------------------------*/
/* if not running persistenty, go ahead and dump the definitions */
IF SESSION:CPINTERNAL EQ "undefined":U THEN
    isCpUndefined = YES.
    
IF NOT THIS-PROCEDURE:PERSISTENT THEN
   RUN doLoad.

/*--------------------------- INTERNAL PROCS  --------------------------*/

PROCEDURE doLoad:
    
    define variable GroupCount as integer no-undo.
    define variable lFound as logical no-undo.
    define variable iMtcount         as integer no-undo.
    define variable hQ as handle no-undo.
    define variable hBuffer as handle no-undo.
  
    /* for the single table variation */
    define variable l_Dump-name as character no-undo.
    define variable l_Mt        as logical  no-undo.
          
    DEFINE VARIABLE i           AS INTEGER   NO-UNDO.
    DEFINE VARIABLE l_db-name   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE l_for-type  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE l_int       AS INTEGER   NO-UNDO.
    DEFINE VARIABLE l_item      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE l_list      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE save_ab     AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE all_shared  AS LOGICAL   NO-UNDO INITIAL FALSE.
    DEFINE VARIABLE all_multitenant  AS LOGICAL   NO-UNDO INITIAL FALSE.
    define variable cSlash         as character no-undo.    
    
    EMPTY TEMP-TABLE ttb_dump NO-ERROR.
     
    /* as of current just let the ABL  deal with error */
    if gtenant > "" then
        set-effective-tenant(gtenant,"dictdb"). 
    
    IF SESSION:CPINTERNAL EQ "undefined":U THEN
        isCpUndefined = YES.
        
    if file-name = "<shared>" then 
      do: 
        assign all_shared = true
               file-name = "ALL".
    end.
    else if file-name = "<tenant>" then 
     do:
        assign all_multitenant = true
               file-name = "ALL".    
    end.
             
    ASSIGN save_ab                   = SESSION:APPL-ALERT-BOXES
           SESSION:APPL-ALERT-BOXES  = NO
           user_env[3]               = "" /* "MAP <name>" or "NO-MAP" OR "" */
           user_env[4]               = (if gErrorPercent > 0 then string(gErrorPercent) else "0")
           user_env[6]               = "f"  /* log errors to file by default */
           dot-d-dir                 = (IF dot-d-dir MATCHES "*" + "/"   OR 
                                           dot-d-dir MATCHES "*" + ".d"  OR 
                                           dot-d-dir MATCHES "*" + ".ad" OR
                                           dot-d-dir    =    "" THEN  
                                          dot-d-dir ELSE dot-d-dir + "/").
    if gSilent then assign user_env[6] = "load-silent".
    
    /* This allows the bulk load utility of a dataserver to be run */
    IF OS-GETENV("DSTYPE")   <> ? THEN
      user_env[35]  = OS-GETENV("DSTYPE").
    /****** 1. step: create temp-table from input file-list ***********/
    if not valid-handle(ghTempTable) then
    do:   
      IF file-name = "ALL" THEN DO:  /* load ALL files of ALL dbs */
        FOR EACH DICTDB._DB NO-LOCK:
          CREATE ttb_dump.
          ASSIGN ttb_dump.db  = (IF DICTDB._DB._DB-Type = "PROGRESS" THEN 
                                   LDBNAME("DICTDB") ELSE DICTDB._DB._Db-name)
                 ttb_dump.tbl = "ALL".
        END.  
        assign file-name = "ALL".  
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
   end.  
    
    /****** 2. step: prepare user_longchar for this _db-record **********/
      
    FOR EACH DICTDB._Db NO-LOCK:
    
      ASSIGN l_db-name   = (IF DICTDB._DB._DB-Type = "PROGRESS" THEN 
                              LDBNAME("DICTDB") ELSE _DB._DB-name)
             user_env[1] = ""
             user_longchar = (IF isCpUndefined THEN user_longchar ELSE "")
             l_for-type  = (IF CAN-DO("PROGRESS",DICTDB._DB._DB-Type) THEN 
                              ? ELSE "TABLE,VIEW").
                              
     if not valid-handle(ghTempTable) then
     do:                         
      /* to generate the list of tables of this _db-record to be loaded and
       * assign it to user_longchar we
       * a) try to use all tables WITHOUT db-specifyer
       */
        FOR EACH ttb_dump WHERE ttb_dump.db = "" 
                          WHILE user_env[1] <> ",all":
          IF ttb_dump.tbl <> "all" THEN DO: 
            IF INTEGER(DBVERSION("DICTDB")) > 8 THEN
                      find DICTDB._File of DICTDB._Db where DICTDB._File._File-name = ttb_dump.tbl
                                                 AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")
                                                 no-lock no-error.
                  ELSE
                      find DICTDB._File of DICTDB._Db where DICTDB._File._File-name = ttb_dump.tbl
                                                 no-lock no-error.                           
                  if available DICTDB._File and ( can-do(l_for-type,DICTDB._File._For-type) or l_for-type = ? ) then 
                  do:
                      /* these two vars are only for the single table variation */
                      assign
                         l_dump-name = (IF DICTDB._File._dump-name <> ? 
                                        THEN DICTDB._File._dump-name 
                                         ELSE LC(DICTDB._File._file-name))
                         l_mt        =   dictdb._File._file-attributes[1].
                      IF isCpUndefined THEN
                          assign user_env[1] = user_env[1] + "," + ttb_dump.tbl.
                      ELSE
                          assign user_longchar = user_longchar + "," + ttb_dump.tbl.
                      if DICTDB._File._file-attributes[1] then
                         iMtCount = iMtCount + 1.
                  END.
              end.
              else 
                  assign user_env[1] = ",all".
          end.
        
          /* b) try to use all tables WITH db-specifyer */
          for each ttb_dump where ttb_dump.db = l_db-name 
          while user_env[1] <> ",all":
              if ttb_dump.tbl <> "all" then 
              do:
                  IF INTEGER(DBVERSION("DICTDB")) > 8 THEN     
                      find DICTDB._File of DICTDB._Db where DICTDB._File._File-name = ttb_dump.tbl
                                               AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")
                                               no-lock no-error.
                  ELSE
                      find DICTDB._File of DICTDB._Db where DICTDB._File._File-name = ttb_dump.tbl
                                               no-lock no-error.                            
                  if available DICTDB._File
                  and ( can-do(l_for-type,DICTDB._File._For-type)
                  or    l_for-type = ? ) then 
                  do:
                      /* these two vars are only for the single table variation */
                      assign
                         l_dump-name = (IF DICTDB._File._dump-name <> ? 
                                        THEN DICTDB._File._dump-name 
                                         ELSE LC(DICTDB._File._file-name))
                         l_mt        =   dictdb._File._file-attributes[1].
           
                     IF isCpUndefined THEN
                         assign user_env[1] = user_env[1] + "," + ttb_dump.tbl.
                     ELSE
                         assign user_longchar = user_longchar + "," + ttb_dump.tbl.
                     if DICTDB._File._file-attributes[1] then
                         iMtCount = iMtCount + 1.
                  END.
              end.
              else 
                 assign user_env[1] = ",all".
          end.
            
          /* c) if either "all" or "all of this db" then we take every file
           *    of the current _Db
          */
        
          IF user_env[1]  = ",all" then 
          do:  /* all files of this _Db */
    
              assign user_env[1] = "".
              IF NOT isCpUndefined THEN
                  assign user_longchar = "".
            
              /** this for each and the NEXT is duplicated in GetTableList in TableDataCommand */ 
                 
              for each DICTDB._File WHERE DICTDB._File._File-number > 0
                                    AND   DICTDB._File._Db-recid = RECID(_Db)
                                    AND   (if all_multitenant  then _file-attributes[1] = true 
                                           else if all_shared then _file-attributes[1] <> true
                                           else true)
                                     AND   NOT DICTDB._File._Hidden
              BY DICTDB._File._File-name:
                  
                  IF INTEGER(DBVERSION("DICTDB")) > 8 
                  AND DICTDB._File._Tbl-Type <> "V"     
                  AND (DICTDB._File._Owner <> "PUB" AND DICTDB._File._Owner <> "_FOREIGN") THEN 
                      NEXT.
                      
                  if l_for-type = ?
                  or can-do(l_for-type,DICTDB._File._For-type) then 
                  do:
                      /* these two vars are only for the single table variation */
                      assign
                         l_dump-name = (IF DICTDB._File._dump-name <> ? 
                                        THEN DICTDB._File._dump-name 
                                         ELSE LC(DICTDB._File._file-name))
                         l_mt        =   dictdb._File._file-attributes[1].
           
                      IF isCpUndefined THEN
                         assign user_env[1] = user_env[1] + "," + DICTDB._File._File-name.
                      ELSE
                         assign user_longchar = user_longchar + "," + DICTDB._File._File-name.
                      
                      if DICTDB._File._file-attributes[1] then
                         iMtCount = iMtCount + 1.
                  end.
              end. /* for each _file */ 
             
              IF isCpUndefined THEN
                  assign user_env[1] = substring(user_env[1],2,-1,"character").
              ELSE
                  assign user_longchar = substring(user_longchar,2,-1,"character").
          end.     /* all files of this _Db */
          
          else do:
               IF isCpUndefined THEN
                  user_env[1] = substring(user_env[1],2,-1,"character").
               else
                  user_longchar = substring(user_longchar,2,-1,"character").
          END.
      end. /* not valid ghTempTable */
      else do:
          create query hq.
          hBuffer = ghTempTable:default-buffer-handle.
          hq:add-buffer(hBuffer).
          hq:query-prepare("for each " + ghTempTable:name
                           + " where " + ghTempTable:name + ".databasename = " + quoter(l_db-name)
                           + " by " + ghTempTable:name + ".name ").
          hq:query-open().
          hq:get-first ().
          
          do while hBuffer:avail:              
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
              END.
              hq:get-next.
          end.
          delete object Hq.
      end.  
    
       /* is there something to load into this _db? */
      if NOT isCpUndefined AND user_longchar = "" then next.
      if     isCpUndefined AND user_env[1] = ""   then next.
    
      /****** 3. step: prepare user_env[2] and user_env[5] **************/
      /* if one file =>  .d-name otherwise path
         always do this if temp-table is used 
         load_d checks if user_env[2] ends with "/"
         to add filename also for the single table case 
         when the temp-tablee is used   */ 
      IF  NUM-ENTRIES((IF isCpUndefined THEN user_env[1] ELSE user_longchar)) > 1 
      OR  valid-handle(ghTempTable) 
      OR  dot-d-dir MATCHES "*" + ".d" OR
          dot-d-dir MATCHES "*" + ".ad" THEN 
          ASSIGN user_env[2] = dot-d-dir.  /* just path or .d-file-name */
      ELSE  /* full path and name of .d-file */
          ASSIGN user_env[2] = dot-d-dir + 
                             (IF l_Dump-name = ? THEN 
                                          STRING((IF isCpUndefined THEN user_env[1] ELSE user_longchar)) ELSE l_Dump-name) +
                             (IF l_Dump-name BEGINS "_aud" THEN 
                                ".ad" ELSE ".d"). 
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
      assign
         user_env[30] = "" 
         user_env[33] = ""
         /* lobdirname is set if use default */
         user_env[40] = "".
      
      if gTenant <> "" then 
      do:
          assign
              user_env[32] = gTenant
              user_env[34] = "" 
              user_env[37] = "".
          
          if gUseDefault then 
          do:         
              user_env[33] = gUseDefaultOut.
              if gNoLobs = false then 
                  user_env[40] = gLobDirName.     
               /* defaults to groups - can be set to blank to 
                  avoid group load*/
              if gGroupDirName > "" then   
                   user_env[37] = gGroupDirName.
          end.
          else do:
             user_env[33] = gTenantDir.
              if gNoLobs = false then 
              do:
                  assign
                      user_env[30] = gLobDir
                      user_env[34] = gTenantLobDir. 
              end. 
              if gGroupDir > "" then   
                  user_env[37] = gGroupDir.  
          end.
      end.
      else do:
          if gUseDefault then
          do: 
              user_env[33] = gUseDefaultOut.
              if gNoLobs = false then 
                  user_env[40] = gLobDirName.
          end.
          else if gNoLobs = false then 
              user_env[30] = gLobDir. 
      end. 
      if valid-object(gMonitor) then
          dictMonitor = gMonitor. 
      RUN "prodict/dump/_loddata.p".
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
            dictMonitor = ?
            user_env = ""           
            SESSION:APPL-ALERT-BOXES = save_ab.
        if gExternalTenant > "" then
            set-effective-tenant(gExternalTenant,"dictdb").         
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
    ASSIGN file-name = pfile-name.
    ghTempTable = ?.
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

PROCEDURE setLobDirName:
    DEFINE INPUT PARAMETER pcLobName AS CHAR NO-UNDO.
    ASSIGN gLobDirName = pcLobName.
END.

PROCEDURE setUseDefaultLocation:
    DEFINE INPUT PARAMETER pldefault AS logical NO-UNDO.
    ASSIGN gUseDefault = pldefault.
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
    ASSIGN gTenantDir = pcDir.
END.

PROCEDURE setTenantLobDir:
    DEFINE INPUT PARAMETER pcDir AS CHAR NO-UNDO.
    ASSIGN gTenantLobDir = pcDir.
END.

PROCEDURE SetSilent:
    DEFINE INPUT PARAMETER setsilent AS LOGICAL NO-UNDO.
    ASSIGN gSilent = setsilent.
END.

PROCEDURE SetAcceptableErrorPercentage:
    DEFINE INPUT PARAMETER errpercent AS INTEGER NO-UNDO.
    ASSIGN gErrorPercent = errpercent.
END.
 
/** set a temptable handle with lsit of tables to load.
    the table must have databasename with logical name (currently only used with ldbname("dictdb"))
    and a name field with the table name */ 
PROCEDURE SetTable:
    DEFINE INPUT PARAMETER table-handle h.
    ASSIGN ghTempTable = h.
END.

/** set the monitor for status log */
PROCEDURE SetMonitor:
    DEFINE INPUT PARAMETER pmon as ITableDataMonitor.
    ASSIGN gMonitor = pmon.
END.

