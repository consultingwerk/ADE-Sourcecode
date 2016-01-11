/*********************************************************************
* Copyright (C) 2011 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* file-name may be either a specific file or ALL */
/* 
File:   prodict/dmpseqvals.p

Description:
    
    
IN:
    file-name                : "ALL" or "<file-name>"
    dot-d-dir                : directory relativ to working-directory
    code-page                : ?, "", "<code-page>"
    
    
Other-settings:    
    cLob-Dir                 : ?, "", directory
    map-option               : "MAP <name>" or "NO-MAP" OR ""
        
History
    rkumar                   created for dumping sequence values 

*/
using Progress.Lang.*.
routine-level on error undo, throw.


DEFINE /*INPUT PARAMETER */ VARIABLE dot-d-dir AS CHARACTER NO-UNDO.
DEFINE /*INPUT PARAMETER */ VARIABLE code-page AS CHARACTER NO-UNDO.
DEFINE /*INPUT PARAMETER */ VARIABLE file-name AS CHARACTER NO-UNDO.


/* This are new settings that can be set by calling the provided setter
   internal procedures, if this is called persistently. Otherwise, the
   behavior remains the same as previous versions, with the same default
   values.
*/
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
DEFINE VARIABLE gSeqSel         AS CHARACTER NO-UNDO.

DEFINE VARIABLE map-option       AS CHARACTER NO-UNDO INIT "".

{ prodict/dictvar.i NEW }
{ prodict/user/uservar.i NEW }

DEFINE VARIABLE save_ab     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE save_tenant AS char      NO-UNDO.

DEFINE VARIABLE setdmpSilent  AS LOGICAL NO-UNDO.

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

PROCEDURE SetSilent:
    DEFINE INPUT PARAMETER setsilent AS LOGICAL NO-UNDO.
    ASSIGN setdmpSilent = setsilent.
END.

PROCEDURE SetSequenceSelection:
    DEFINE INPUT PARAMETER setseqsel AS CHARACTER NO-UNDO.
    ASSIGN gSeqSel = setseqsel.
END.

/* This is the meat of this procdure */

PROCEDURE doDump:

    /* as of current just let the ABL  deal with error */
    if gtenant > "" then
        set-effective-tenant(gtenant,"dictdb"). 
        
    /* make sure these are clear */
    ASSIGN user_env = "".

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
       fOR EACH DICTDB._Db NO-LOCK:
          assign
           user_env[2] = file-name
           user_env[4] = ""
           user_env[5] = code-page
           user_env[6] = if setdmpSilent then "dump-silent" else "no-alert-boxes"
           user_env[33] = if gseqsel EQ "ALL" THEN "" else gseqsel
           drec_db     = RECID(_Db)
           .
        
        RUN "prodict/dump/_dmpseqs.p". 
    
   end.  /* FOR EACH _DB */

          
    finally:
        /* clean up tenant */
        assign
            user_env[32] = ""
        SESSION:APPL-ALERT-BOXES = save_ab.
        if save_tenant > "" then
            set-effective-tenant(save_tenant,"dictdb").         
    end finally.    


END PROCEDURE.

/*---------------------------  MAIN-CODE  --------------------------*/

/* if not running persistenty, go ahead and dump the definitions */
IF NOT THIS-PROCEDURE:PERSISTENT THEN
   RUN doDump.




