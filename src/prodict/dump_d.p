/*********************************************************************
* Copyright (C) 2007 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

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
Summary: 
1. tenant and lob directories will be dumped in subdirs named after tenant and 
   be created if necessary if setEffectiveTenant is used

2. setTenantDir, setLobDir and setTenantLobDir is ONLY used if 
   setEffectiveTenant is used together with setUseDefaultLocation in h(false). 

*/

DEFINE INPUT PARAMETER file-name AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER dot-d-dir AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER code-page AS CHARACTER NO-UNDO.

/* This are new settings that can be set by calling the provided setter
   internal procedures, if this is called persistently. Otherwise, the
   behavior remains the same as previous versions, with the same default
   values.
*/
DEFINE VARIABLE gLobDir         AS CHARACTER NO-UNDO.
DEFINE VARIABLE gTenantDir      AS CHARACTER NO-UNDO.
DEFINE VARIABLE gTenantLobDir   AS CHARACTER NO-UNDO.
DEFINE VARIABLE gTenant         AS CHARACTER NO-UNDO.
define variable gNoLobs         as logical   no-undo.
define variable gUseDefault     as logical   no-undo init ?.

DEFINE VARIABLE map-option       AS CHARACTER NO-UNDO INIT "".

{ prodict/dictvar.i NEW }
{ prodict/user/uservar.i NEW }

DEFINE VARIABLE c           AS CHARACTER NO-UNDO INITIAL "".
DEFINE VARIABLE i           AS INTEGER   NO-UNDO.
DEFINE VARIABLE l_db-name   AS CHARACTER NO-UNDO.
DEFINE VARIABLE l_for-type  AS CHARACTER NO-UNDO.
DEFINE VARIABLE l_int       AS INTEGER   NO-UNDO.
DEFINE VARIABLE l_item      AS CHARACTER NO-UNDO.
DEFINE VARIABLE l_list      AS CHARACTER NO-UNDO.
DEFINE VARIABLE save_ab     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE save_tenant AS char      NO-UNDO.

DEFINE VARIABLE isCpUndefined AS LOGICAL NO-UNDO.

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
        

/*--------------------------- INTERNAL PROCS  --------------------------*/
PROCEDURE setFileName:
    DEFINE INPUT PARAMETER pfile-name AS CHAR NO-UNDO.
    ASSIGN file-name = pfile-name.
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

PROCEDURE setMap:
    DEFINE INPUT PARAMETER pcmap-option AS CHAR NO-UNDO.
    ASSIGN map-option = pcmap-option.
END.


/* This is the meat of this procdure */

PROCEDURE doDump:
    
    /* as of current just let the ABL  deal with error */
    if gtenant > "" then
        set-effective-tenant(gtenant,"dictdb"). 
    
    /* make sure table is empty */
    EMPTY TEMP-TABLE ttb_dump NO-ERROR.

    IF map-option = ? THEN
        map-option = "".
    
    /* make sure these are clear */
    ASSIGN user_env = ""
           user_longchar = (IF isCpUndefined THEN user_longchar ELSE "").

    if      code-page = ?  
     then assign code-page = "<internal defaults apply>".
     else do:
      if code-page = "" then assign code-page = SESSION:STREAM.
      else if codepage-convert("a",code-page,SESSION:CHARSET) = ?
                        then assign code-page = SESSION:STREAM.
      if codepage-convert("a",code-page,SESSION:CHARSET) = ?
                        then assign code-page = "<internal defaults apply>".
      end.
      
    assign
      save_ab                   = SESSION:APPL-ALERT-BOXES
      SESSION:APPL-ALERT-BOXES  = NO.
      c                         = "".
    
    
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
        if l_int = 0
         then assign
          ttb_dump.db  = ""
          ttb_dump.tbl = l_item.
         else assign
          ttb_dump.db  = substring(l_item,1,l_int - 1,"character")
          ttb_dump.tbl = substring(l_item,l_int + 1, -1,"character").
      end.
        
    end.     /* dump SOME files of SOME dbs */
    
    
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
    /* to generate the list of tables of this _db-record to be dumped and
     * assign it to user_longchar we
     * a) try to use all tables WITHOUT db-specifyer
     */
      for each ttb_dump
        where ttb_dump.db = ""
        while user_env[1] <> ",all":
        if ttb_dump.tbl <> "all"
         then do:
           IF INTEGER(DBVERSION("DICTDB")) > 8 THEN
              find first DICTDB._File of DICTDB._Db where DICTDB._File._File-name = ttb_dump.tbl
                                         AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")
                                         no-lock no-error.
           ELSE
              find first DICTDB._File of DICTDB._Db where DICTDB._File._File-name = ttb_dump.tbl
                                         no-lock no-error.                           
          if available DICTDB._File
           and ( can-do(l_for-type,DICTDB._File._For-type)
           or    l_for-type = ? )
           then do:
              IF isCpUndefined THEN
                 assign user_env[1] = user_env[1] + "," + ttb_dump.tbl.
              ELSE
                 assign user_longchar = user_longchar + "," + ttb_dump.tbl.
          END.
          end.
         else assign user_env[1] = ",all".
        end.
    
    /* b) try to use all tables WITH db-specifyer */
      for each ttb_dump
        where ttb_dump.db = l_db-name
        while user_env[1] <> ",all":
        if ttb_dump.tbl <> "all"
         then do:
           IF INTEGER(DBVERSION("DICTDB")) > 8 THEN     
              find first DICTDB._File of DICTDB._Db where DICTDB._File._File-name = ttb_dump.tbl
                                        AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")
                                        no-lock no-error.
            ELSE
              find first DICTDB._File of DICTDB._Db where DICTDB._File._File-name = ttb_dump.tbl
                                        no-lock no-error.                            
          if available DICTDB._File
           and ( can-do(l_for-type,DICTDB._File._For-type)
           or    l_for-type = ? )
           then do:
              IF isCpUndefined THEN
                 assign user_env[1] = user_env[1] + "," + ttb_dump.tbl.
              ELSE
                 assign user_longchar = user_longchar + "," + ttb_dump.tbl.
           END.
          end.
         else assign user_env[1] = ",all".
        end.
        
    /* c) if either "all" or "all of this db" then we take every file
     *    of the current _Db
     */
    
      IF user_env[1]  = ",all" then 
      do:  /* all files of this _Db */

        assign user_env[1] = "".
        IF NOT isCpUndefined THEN
           assign user_longchar = "".

        for each DICTDB._File
          WHERE DICTDB._File._File-number > 0
          AND   DICTDB._File._Db-recid = RECID(_Db)
          AND   NOT DICTDB._File._Hidden
          BY    DICTDB._File._File-name:
          
          IF INTEGER(DBVERSION("DICTDB")) > 8 
            AND DICTDB._File._Tbl-Type <> "V"     
            AND (DICTDB._File._Owner <> "PUB" AND DICTDB._File._Owner <> "_FOREIGN") 
               THEN NEXT.
                  
          if l_for-type = ?
           or can-do(l_for-type,DICTDB._File._For-type)
           then do:
              IF isCpUndefined THEN
                 assign user_env[1] = user_env[1] + "," + DICTDB._File._File-name.
              ELSE
                 assign user_longchar = user_longchar + "," + DICTDB._File._File-name.
           END.
          END.
        IF isCpUndefined THEN
           assign user_env[1] = substring(user_env[1],2,-1,"character").
        ELSE
           assign user_longchar = substring(user_longchar,2,-1,"character").
        END.     /* all files of this _Db */
       else do:
           IF isCpUndefined THEN
              user_env[1] = substring(user_env[1],2,-1,"character").
           else
              user_longchar = substring(user_longchar,2,-1,"character").
       END.
       
      /* is there something to dump in this _db? */
       if NOT isCpUndefined AND user_longchar = "" then next.
       if     isCpUndefined AND user_env[1] = ""   then next.
      
      /* where to put the dump? */
      IF (isCpUndefined AND INDEX(user_env[1],",") = 0)
          OR (NOT isCpUndefined AND INDEX(user_longchar,",") = 0)
       then do:  /* ev. get dump-name */
        if  dot-d-dir matches "*/"
         or dot-d-dir = ""
         then user_env[2] = dot-d-dir.
         else user_env[2] = dot-d-dir + "/".
    
       IF NOT isCpUndefined THEN
          ASSIGN user_env[1] = user_longchar.
    
       IF INTEGER(DBVERSION("DICTDB")) > 8 THEN 
          FIND _File OF _Db WHERE _File._File-name = user_env[1]
                              AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN").
       ELSE
          FIND _File OF _Db WHERE _File._File-name = user_env[1].
                              
        assign
          user_env[2] = ( if  dot-d-dir matches "*" + "/"
                           or dot-d-dir = ""
                           then dot-d-dir
                           else dot-d-dir + "/"
                         ) +  ( if _Dump-name = ?
                                      THEN _File-name 
                                      ELSE _Dump-name) + ".d".
        END.     /* ev. get dump-name */
       else assign
        user_env[2] = ( if  dot-d-dir matches "*" + "/"
                         or dot-d-dir = ""
                         then dot-d-dir
                         else dot-d-dir + "/"
                      ).
      
    /* remaining needed assignments */
      assign
        user_env[3] = map-option /* "MAP <name>" or "NO-MAP" OR "" */
        user_env[4] = ""
        user_env[5] = code-page
        user_env[6] = "no-alert-boxes"
        user_env[31] = if gNoLobs then " NO-LOBS" else ""
        drec_db     = RECID(_Db)
        user_dbname = if _Db._Db-name = ? THEN LDBNAME("DICTDB")
                                          ELSE _Db._Db-Name
        user_dbtype = if _Db._Db-name = ? THEN DBTYPE("DICTDB")
                                          ELSE _Db._Db-Type
    /*    user_dbname = LDBNAME("DICTDB") */
    /*    user_dbtype = DBTYPE("DICTDB")  */
         .
      if gTenant <> "" then 
      do:
          user_env[32] = gTenant.
          if gUseDefault then 
          do:         
             assign
                 user_env[33] = user_env[2] + gTenant + "/"
                 user_env[30] = user_env[2] + "lobs/"
                 user_env[34] = user_env[33] + "lobs/".
             
             createDirectoryIf( user_env[33]).    
             createDirectoryIf( user_env[30]).    
             createDirectoryIf( user_env[34]).    
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
      
      RUN "prodict/dump/_dmpdata.p".
    
    END.    /* all _Db's */
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


END PROCEDURE.

/*---------------------------  MAIN-CODE  --------------------------*/

IF SESSION:CPINTERNAL EQ "undefined":U THEN
    isCpUndefined = YES.

/* if not running persistenty, go ahead and dump the definitions */
IF NOT THIS-PROCEDURE:PERSISTENT THEN
   RUN doDump.




