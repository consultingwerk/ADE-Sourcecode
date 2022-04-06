/***********************************************************************
* Copyright (C) 2007-2012 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

/* file-name may be either a specific file or ALL */
/* 
File:   prodict/dump_d.p

Description:
    This was changed to that callers can call it persistently, so
    that we provide support for setting other settings that were
    not available before, such as the LOB-DIR. We can't change
    the signature of this for backward compatibility reasons, so
    we are providing another way for setting it. See Other-settings
    for the new settings that can be set. Each one of them can be
    set by calling the corresponding setter internal procedure.
    
    NOTE that this can still be called as a regular procedure, in
    which case we will run it as previously with no change in behavior.
    
IN:
    file-name                : "ALL" or "<file-name>"
    dot-d-dir                : directory relativ to working-directory
    code-page                : ?, "", "<code-page>"
    
    
Other-settings:    
    cLob-Dir                 : ?, "", directory
    map-option              : "MAP <name>" or "NO-MAP" OR ""
        
History
    fernando    12/12/07 Don't need to set user_env[4] anymore    
    fernando    02/27/07 Support for long dump name - OE00146586    
    fernando    10/12/06 Allow this to be called persistently
    fernando    03/16/06 Handle case with too many tables selected - bug 20050930-006.
    mcmann      10/17/03 Add NO-LOCK statement to _Db find in support of on-line schema add
    mcmann      00/08/14 Changed _db-name to DICTDB for dbversion 20000810035
    mcmann      98/07/13 Added _Owner for _File finds
    laurief     97/12    Removed RMS,CISAM code
    kkelley     95/08    Multi-db with multiple tables
    hutegger    95/01    multi-db support
    hutegger    94/02    code-page support

Multi-DB-Support:
    the syntax of file-name is:
           [ <DB>. ] <tbl>             [ <DB>. ] <tbl>
        {  ---------------  }  [ , {  ---------------  } ] ...
             <DB>."ALL"                  <DB>."ALL"
    {   -----------------------------------------------------------  }
                        "ALL"

Code-page - support:
    code-page = ?             : no-conversion
    code-page = ""            : default conversion (SESSION:STREAM)
    code-page = "<code-page>" : convert to <code-page>

    if not convertable to code-page try to convert to SESSION:STREAM
    if still not convertable don't convert at all

Example:

This is an example on how to call this proc persistently to set the
newly added options:

DEF VAR h AS HANDLE NO-UNDO.
RUN prodict/dump_d.p PERSISTENT SET h 
    (INPUT file-name, INPUT dot-d-dir, INPUT code-page).
RUN setLobDir IN h (input cLob-Dir). /* this is optional */
RUN setMap IN h (input "NO-MAP"). /* this is optional */
RUN doDump IN h.
DELETE PROCEDURE h.

super-tenant rules.
Setting set-effective-tenant before calling this will cause tenant data
to be dumped in the (dot-d-dir) standard directory or file-name 

This is an example on how to call this proc persistently to have more control
over multi-tenant options:

    
--- default location - create subdirs if necessary  --
RUN prodict/dump_d.p PERSISTENT SET h 
    (INPUT file-name, INPUT dot-d-dir, INPUT code-page).
RUN setEffectiveTenant IN h (gtenant). 
RUN doDump IN h.

shared data will be dumped in            dot-d-dir
effective tenant data will be dumpbed in dot-d-dir + "/" + gtenant
shared lobs will be dumped in            dot-d-dir + "/lobs"
effective tenant lobs will be dumpbed in dot-d-dir+ "/" + gtenant + "/lobs"

--- default location no-lobs - create subdirs if necessary  --
RUN prodict/dump_d.p PERSISTENT SET h 
    (INPUT file-name, INPUT dot-d-dir, INPUT code-page).
RUN setEffectiveTenant IN h (gtenant). 
RUN setNoLobs IN h (true). 
RUN doDump IN h.

shared data will be dumped in            dot-d-dir
effective tenant data will be dumpbed in dot-d-dir + "/" + gtenant

--- specify location  ---
RUN prodict/dump_d.p PERSISTENT SET h 
    (INPUT file-name, INPUT dot-d-dir, INPUT code-page).
RUN setUseDefaultLocation IN h (false). 
RUN setEffectiveTenant IN h (gtenant). 
RUN setTenantDir IN h (gtenantdir). 
RUN setLobDir IN h (globdir). 
RUN setTenantLobDir IN h (gtenantlobdir). 

RUN doDump IN h.

shared data will be dumped in            dot-d-dir
effective tenant data will be dumpbed in gtenantdir
shared lobs will be dumped in            globdir
effective tenant lobs will be dumpbed in gtenantlobdir

--- all data in current directory  don't use default  ---
RUN prodict/dump_d.p PERSISTENT SET h 
    (INPUT file-name, INPUT dot-d-dir, INPUT code-page).
RUN setEffectiveTenant IN h (gtenant). 
RUN setUseDefaultLocation IN h (false). 
RUN doDump IN h.

all data will be dumped in dot-d-dir
Multi-tenant Summary:     
Use setEffectiveTenant :
1. Use default location = true (this is default)  
The following subdirectories will be created if necessary 
is used (assuming default Use default location = true):
 - Tenant data will be dumped in subdirs named after tenant 
 - Group data will be dumped in subdir setGroupDirName (default = "groups") 
   with subdirs named after group. 
 - Lobs will be dumped in subdir setLobDirName (default = "lobs") under the root, 
   tenants and groups directories.
2. Set UseDefaultLocation = false  
Dumps data in setTenantDir, setLobDir, SetGroupDir and setTenantLobDir. 
Group data will be dumped in setGroupDir with subdirs named after group. 

Not using setEffectiveTenant:
Gives transparent behavior for regular tenants with all data dumped in specified 
work and lob directories with no directory separation of tenant and group data 
just as if the database is non multi-tenant. 
***************************************************************************************/

using OpenEdge.DataAdmin.Binding.ITableDataMonitor from propath .

DEFINE INPUT PARAMETER file-name AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER dot-d-dir AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER code-page AS CHARACTER NO-UNDO.

/* This are new settings that can be set by calling the provided setter
   internal procedures, if this is called persistently. Otherwise, the
   behavior remains the same as previous versions, with the same default
   values.
*/
DEFINE VARIABLE gLobDir         AS CHARACTER NO-UNDO.
DEFINE VARIABLE gLobDirName     AS CHARACTER NO-UNDO init "lobs":U.
DEFINE VARIABLE gTenantDir      AS CHARACTER NO-UNDO.
DEFINE VARIABLE gTenantLobDir   AS CHARACTER NO-UNDO.
DEFINE VARIABLE gTenant         AS CHARACTER NO-UNDO.
define variable gNoLobs          as logical   no-undo.
define variable gUseDefault      as logical   no-undo init ?.
define variable gGroupDir        as CHARACTER no-undo.
define variable gGroupDirName    as CHARACTER no-undo init "groups":U.
DEFINE VARIABLE gMapOption       AS CHARACTER NO-UNDO .
DEFINE VARIABLE gSilent          AS LOGICAL NO-UNDO.
DEFINE VARIABLE gSkipilent       AS LOGICAL NO-UNDO.
DEFINE VARIABLE gExternalTenant  AS char      NO-UNDO.
DEFINE VARIABLE gSkipCodePageValidation  AS logical      NO-UNDO.
DEFINE VARIABLE isCpUndefined    AS LOGICAL NO-UNDO.
define variable ghTempTable      as handle no-undo.
define variable gUseDefaultOut   as character no-undo init "<default>".
define variable gMonitor         as ITableDataMonitor no-undo.



{ prodict/dictvar.i NEW }
{ prodict/user/uservar.i NEW }


define temp-table ttb_dump
        field db        as character
        field tbl       as character
        index upi is primary unique db tbl.

       
/*--------------------------- FUNCTIONS  --------------------------*/
function validDirectory returns logical ( cValue as char):
  
    IF cValue <> "" THEN 
    DO:
        ASSIGN FILE-INFO:FILE-NAME = cValue. 
        return SUBSTRING(FILE-INFO:FILE-TYPE,1,1) = "D".
    END.
        
    return true.
 
end function. /* validateDirectory */

function createDirectoryIf returns logical ( cdirname as char):
    define variable iStat as integer no-undo.
    if not validdirectory(cdirname) then
    do:
        OS-CREATE-DIR VALUE(cdirname). 
        iStat = OS-ERROR. 
        
        if iStat <> 0 then
           MESSAGE "Cannot create directory " + cdirname + ". System error:" iStat
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        return istat = 0.
    end.
    return true.
end function. /* validateDirectory */
        
/*---------------------------  MAIN-CODE  --------------------------*/

IF SESSION:CPINTERNAL EQ "undefined":U THEN
    isCpUndefined = YES.

/* if not running persistenty, go ahead and dump the definitions */
IF NOT THIS-PROCEDURE:PERSISTENT THEN
   RUN doDump.

/*--------------------------- INTERNAL PROCS  --------------------------*/
PROCEDURE setFileName:
    DEFINE INPUT PARAMETER pfile-name AS CHAR NO-UNDO.
    ASSIGN file-name = pfile-name.
    ghTempTable = ?.
END.

PROCEDURE setDirectory:
    DEFINE INPUT PARAMETER pdot-d-dir AS CHAR NO-UNDO.
    ASSIGN dot-d-dir = pdot-d-dir.
END.

PROCEDURE setCodePage:
    DEFINE INPUT PARAMETER pcodepage AS CHAR NO-UNDO.
    ASSIGN code-page = pcodepage.
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

PROCEDURE setMap:
    DEFINE INPUT PARAMETER pcmap-option AS CHAR NO-UNDO.
    ASSIGN gMapOption = pcmap-option.
END.

PROCEDURE SetSilent:
    DEFINE INPUT PARAMETER setsilent AS LOGICAL NO-UNDO.
    ASSIGN gSilent = setsilent.
END.

PROCEDURE SetSkipCodePageValidation:
    DEFINE INPUT PARAMETER plskip as logical NO-UNDO.
    ASSIGN gSkipCodePageValidation = plskip .
END.
/** set a temptable handle with lsit of tables to dump.
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

/* This is the meat of this procdure */

PROCEDURE doDump:
    define variable GroupCount as integer no-undo.
    define variable lFound as logical no-undo.
    define variable iMtcount         as integer no-undo.
    define variable hQ as handle no-undo.
    define variable hBuffer as handle no-undo.
          
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
    
    /* as of current just let the ABL  deal with error */
    if gtenant > "" then
        set-effective-tenant(gtenant,"dictdb"). 
    
    /* make sure table is empty */
    EMPTY TEMP-TABLE ttb_dump NO-ERROR.

    IF gMapOption = ? THEN
        gMapOption = "".
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
                   
    /* make sure these are clear */
    ASSIGN user_env = ""
           user_longchar = (IF isCpUndefined THEN user_longchar ELSE "").
    
    if code-page <> "<internal defaults apply>" then
    do: 
        if code-page = ?  then 
            assign code-page = "<internal defaults apply>".
        else do:
            if code-page = "" then 
                assign code-page = SESSION:STREAM.
            else if codepage-convert("a",code-page,SESSION:CHARSET) = ? then 
                assign code-page = SESSION:STREAM.
            if codepage-convert("a",code-page,SESSION:CHARSET) = ? then 
                assign code-page = "<internal defaults apply>".
        end.
    end.  
    assign
      save_ab                   = SESSION:APPL-ALERT-BOXES
      SESSION:APPL-ALERT-BOXES  = NO.
    
    if not valid-handle(ghTempTable) then
    do:
        /****** 1. step: create temp-table from input file-list ***********/
        if file-name = "ALL" then 
        do:  /* dump ALL files of ALL dbs */
            for each DICTDB._DB NO-LOCK:
                create ttb_dump.
                assign
                   ttb_dump.db  = ( if DICTDB._DB._DB-Type = "PROGRESS" 
                                    THEN LDBNAME("DICTDB")
                                    ELSE DICTDB._DB._Db-name
                             )
                   ttb_dump.tbl = "ALL".
            end.    
         
        end.     /* dump ALL fiels of ALL dbs */        
            
        else do:  /* dump SOME files of SOME dbs */
         
            assign l_list = file-name.
            repeat i = 1 to num-entries(l_list):
                create ttb_dump.
                assign
                    l_item = entry(i,l_list)
                    l_int  = index(l_item,".").
                if l_int = 0 then 
                    assign 
                        ttb_dump.db  = ""
                        ttb_dump.tbl = l_item.
                else 
                    assign
                        ttb_dump.db  = substring(l_item,1,l_int - 1,"character")
                ttb_dump.tbl = substring(l_item,l_int + 1, -1,"character").
            end.
        end.     /* dump SOME files of SOME dbs */
    end.
    
    
    /****** 2. step: load in all files according to temp-table ******/     
    for each DICTDB._Db NO-LOCK:
    
      assign
        l_db-name   = ( if DICTDB._DB._DB-Type = "PROGRESS" 
                         THEN LDBNAME("DICTDB")
                         ELSE _DB._DB-name
                      )
        user_env[1] = ""
        user_longchar = (IF isCpUndefined THEN user_longchar ELSE "")
        l_for-type  = ( if CAN-DO("PROGRESS",DICTDB._DB._DB-Type) 
                         THEN ?
                         ELSE "TABLE,VIEW"
                      ).
      
      if not valid-handle(ghTempTable) then
      do:
        
          /* to generate the list of tables of this _db-record to be dumped and
           * assign it to user_longchar we
           * a) try to use all tables WITHOUT db-specifyer
           */
          for each ttb_dump where ttb_dump.db = "" 
          while user_env[1] <> ",all":
              if ttb_dump.tbl <> "all" then 
              do:
                  IF INTEGER(DBVERSION("DICTDB")) > 8 THEN
                      find first DICTDB._File of DICTDB._Db where DICTDB._File._File-name = ttb_dump.tbl
                                                 AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")
                                                 no-lock no-error.
                  ELSE
                      find first DICTDB._File of DICTDB._Db where DICTDB._File._File-name = ttb_dump.tbl
                                                 no-lock no-error.                           
                  if available DICTDB._File and ( can-do(l_for-type,DICTDB._File._For-type) or l_for-type = ? ) then 
                  do:
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
                      find first DICTDB._File of DICTDB._Db where DICTDB._File._File-name = ttb_dump.tbl
                                               AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")
                                               no-lock no-error.
                  ELSE
                      find first DICTDB._File of DICTDB._Db where DICTDB._File._File-name = ttb_dump.tbl
                                               no-lock no-error.                            
                  if available DICTDB._File
                  and ( can-do(l_for-type,DICTDB._File._For-type)
                  or    l_for-type = ? ) then 
                  do:
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
                  find DICTDB._File of DICTDB._Db where DICTDB._File._File-name = hBuffer::name
                                                        AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")
                                                        no-lock no-error.
              ELSE
                  find DICTDB._File of DICTDB._Db where DICTDB._File._File-name = hBuffer::name
                                                 no-lock no-error.                           
                  
              if avail DICTDB._File then
              do:
                  IF isCpUndefined THEN
                      assign user_env[1] = user_env[1] 
                                         + (if user_env[1] = "" then "" else ",") 
                                         + hBuffer::name .
                  ELSE
                      assign user_longchar = user_longchar 
                                           + (if user_longchar = "" then "" else ",") 
                                           + hBuffer::name.
                      
                  if DICTDB._File._file-attributes[1] then
                      iMtCount = iMtCount + 1.
              end.
              hq:get-next.
         
          end.
         
          delete object Hq.
      end.       
      
      /* is there something to dump in this _db? */
      if NOT isCpUndefined AND user_longchar = "" then next.
      if     isCpUndefined AND user_env[1] = ""   then next.
      
      /* where to put the dump? single table needs file name  */
      
      /* deal with  the single table variation  
         but not if using temp-table - add file in _dmpdata
          */
      if not valid-handle(ghTempTable)                         
      and ((isCpUndefined AND INDEX(user_env[1],",") = 0)
           OR 
           (NOT isCpUndefined AND INDEX(user_longchar,",") = 0))
            then 
      do:  /* ev. get dump-name */
           
          IF NOT isCpUndefined THEN
              ASSIGN user_env[1] = user_longchar.
    
          IF INTEGER(DBVERSION("DICTDB")) > 8 THEN 
              FIND dictdb._File OF dictdb._Db WHERE dictdb._File._File-name = user_env[1]
                              AND (dictdb._File._Owner = "PUB" OR dictdb._File._Owner = "_FOREIGN").
          ELSE
              FIND dictdb._File OF dictdb._Db WHERE dictdb._File._File-name = user_env[1].
         
          assign
              user_env[2] = ( if  dot-d-dir matches "*" + "/"
                              or dot-d-dir = ""
                              then dot-d-dir
                              else dot-d-dir + "/"
                            ) 
                            +          
                            (( if dictdb._file._Dump-name = ?
                                 THEN dictdb._file._File-name 
                                 ELSE dictdb._file._Dump-name) 
                                 + ".d")
                            .
      END.     /* ev. get dump-name */
      else  
          /* NOTE dump_d checks if user_env[2] ends with "/"
             to add filename also for the single table case 
             when the temp-talbe is used   */ 
          assign
              user_env[2] = ( if  dot-d-dir matches "*" + "/"
                              or dot-d-dir = ""
                              then dot-d-dir
                              else dot-d-dir + "/"
                            ).
      
      /* remaining needed assignments */

      assign
        user_env[3] = gMapOption /* "MAP <name>" or "NO-MAP" OR "" */
        user_env[4] = ""
        user_env[5] = if gSkipCodePageValidation 
                      then "skip-" + (if code-page = ? then "?" else code-page)
                      else code-page   
        user_env[6] = if gSilent then "dump-silent" else "no-alert-boxes"
        user_env[31] = if gNoLobs then " NO-LOBS" else ""
        drec_db     = RECID(_Db)
        user_dbname = if _Db._Db-name = ? THEN LDBNAME("DICTDB")
                                          ELSE _Db._Db-Name
        user_dbtype = if _Db._Db-name = ? THEN DBTYPE("DICTDB")
                                          ELSE _Db._Db-Type
        user_env[30] = "" 
        user_env[33] = ""
         /* lobdirname is set if use default */
        user_env[40] = "".
    /*    user_dbname = LDBNAME("DICTDB") */
    /*    user_dbtype = DBTYPE("DICTDB")  */
         .
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
                  avoid group dump*/
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
      end. /* gTenant <> "" */
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
      
      /* Indicate "y"es to disable triggers for dump of all files */
      /* Now we don't have to do this. A blank string will indicate disable
         triggers for all files 
      */
      /*assign
        user_env[4] = substring(fill(",y",
                                     num-entries((IF isCpUndefined THEN user_env[1] ELSE user_longchar)))
                               ,2
                               ,-1
                               ,"character"
                               ).
      */
    
      IF NOT isCpUndefined THEN 
      DO:
          /* see if we can put user_longchar into user_env[1] */
          ASSIGN user_env[1] = user_longchar NO-ERROR.
          IF NOT ERROR-STATUS:ERROR THEN
             /* ok to use user_env[1] */
             ASSIGN user_longchar = "". 
          ELSE
             ASSIGN user_env[1] = "".
      END.
      
      if valid-object(gMonitor) then
          dictMonitor = gMonitor. 
      RUN "prodict/dump/_dmpdata.p".
      catch e as Progress.Lang.Error :
        if gSilent then
            undo, throw e.
        else do i = 1 to e:NumMessages:
            message e:GetMessage(i)
                view-as alert-box error.      
        end.             
      end catch.
      
    
    END.    /* for each  _Db's */
    catch e as Progress.Lang.Error :
	    if gSilent then
            undo, throw e.
        else do i = 1 to e:NumMessages:
            message e:GetMessage(i)
                view-as alert-box error.      
        end.             
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


END PROCEDURE.






