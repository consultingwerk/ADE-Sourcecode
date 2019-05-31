/*********************************************************************
* Copyright (C) 2016-2017 by Progress Software Corporation. All      *
* rights reserved.  Prior versions of this work may contain portions *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
    File        : _dmpcdcdata.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : mkondra
    Created     : Wed Jun 29 14:21:26 IST 2016
    Notes       :
  ----------------------------------------------------------------------*/
/*
input:
  user_env[1] = comma-sep list of policynames to dump
                or it may be in user_longchar, if list was too big.
  user_env[2] = directory (if >1 file in user_env[1]) or filename to dump into
  user_env[3] = "MAP <name>" or "NO-MAP" OR ""
  user_env[5] = "<internal defaults apply>" or "<target-code-page>"
  user_env[6] = "no-alert-boxes" or something else
*/
/*h-*/

using Progress.Lang.*.
using OpenEdge.DataAdmin.Internal.Util.CdcTablePolicyInstanceEnum.

/* ensure that errors from directory functions are thrown   
   this also allows us to use errorHandler 
   this does not affect _runload.i whihc does not throw, bit handles all error   
*/ 
routine-level on error undo, throw.

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE NEW SHARED STREAM   dump.
DEFINE NEW SHARED VARIABLE recs AS DECIMAL FORMAT ">>>>>>>>>>>>9" NO-UNDO.
DEFINE NEW SHARED STREAM   dumperr.
 
DEFINE VARIABLE cerr        AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cntr        AS INTEGER   NO-UNDO.
DEFINE VARIABLE fil         AS CHARACTER NO-UNDO.
DEFINE VARIABLE fil-e       AS CHARACTER NO-UNDO.
DEFINE VARIABLE loop        AS LOGICAL   NO-UNDO.
DEFINE VARIABLE addfilename AS LOGICAL   NO-UNDO.
DEFINE VARIABLE mdy         AS CHARACTER NO-UNDO.
DEFINE VARIABLE msg         AS CHARACTER NO-UNDO.
DEFINE VARIABLE stamp       AS CHARACTER NO-UNDO.
DEFINE VARIABLE tableexpression       AS CHARACTER NO-UNDO.
define variable exceptfields as character no-undo.
DEFINE VARIABLE yy          AS INTEGER   NO-UNDO.
DEFINE VARIABLE stopped     AS LOGICAL   NO-UNDO init true.
DEFINE VARIABLE CodeOut     AS CHARACTER NO-UNDO.
DEFINE VARIABLE lobdir      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cTemp       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cSlash      AS CHARACTER   NO-UNDO.
 
DEFINE VARIABLE phdbname    AS CHARACTER   NO-UNDO.
define variable derr        as logical no-undo.
DEFINE VARIABLE numCount  AS INTEGER      NO-UNDO.
DEFINE VARIABLE ix        AS INTEGER      NO-UNDO.
DEFINE VARIABLE ilast     AS INTEGER      NO-UNDO.
DEFINE VARIABLE has_lchar AS LOGICAL      NO-UNDO.
DEFINE VARIABLE has_aud   AS LOGICAL      NO-UNDO.
DEFINE VARIABLE isCpUndefined AS LOGICAL  NO-UNDO.
DEFINE VARIABLE cRecords  AS CHARACTER    NO-UNDO.
define variable isSuperTenant as logical no-undo. 
define variable lSkipCodePageValidation  as logical no-undo.
DEFINE VARIABLE cMsg          AS CHARACTER NO-UNDO.
define variable lImmediatedisp as logical no-undo.
define variable xDumpTerminatedMsg as character no-undo init "Dump terminated.".
define variable dumpCollection  as OpenEdge.DataAdmin.IDataAdminCollection no-undo.
DEFINE VARIABLE singlePolicy        AS LOGICAL init yes  NO-UNDO.
define variable trailerFileName as character no-undo.
define variable NonExistPolList as character no-undo.
define variable pCnt   as integer no-undo.
define variable pStr as character no-undo.

FORM
  
  fil            FORMAT "x(32)"  LABEL "Dump File" SPACE(0)
  msg            FORMAT "x(13)"  LABEL "Records" SPACE(1) 
  HEADER 
    " Dumping Data.   Press " + 
    KBLABEL("STOP") + " to terminate the dump process." format "x(75)" SKIP(1)
  WITH FRAME dumpdata NO-ATTR-SPACE USE-TEXT SCROLLABLE
  SCREEN-LINES - 8 DOWN ROW 2 CENTERED &IF "{&WINDOW-SYSTEM}" <> "TTY"
  &THEN THREE-D &ENDIF.

/*--------------------------- FUNCTIONS  --------------------------*/
function validDirectory returns logical ( cValue as char):
  
    IF cValue <> "" THEN 
    DO:
        /* not a propath search - use logic blank is default 
          - the directory is currently used as-is in output to and os-create
          
           */ 
        if not (cValue begins "/" or cvalue begins "~\" or index(cValue,":") <> 0) then
            cValue = "./" + cValue.  
        ASSIGN FILE-INFO:FILE-NAME = cValue. 
        return SUBSTRING(FILE-INFO:FILE-TYPE,1,1) = "D".
    END.
        
    return true.
 
end function. /* validDirectory */

function createDirectoryIf returns logical ( cdirname as char):
    define variable iStat as integer no-undo.
    if not validdirectory(cdirname) then
    do:
        OS-CREATE-DIR VALUE(cdirname). 
        iStat = OS-ERROR. 
        if iStat <> 0 then
            undo, throw new AppError(xDumpTerminatedMsg + " Cannot create directory " + cdirname + ". System error:" + string(iStat),?).
    end.
    return true.
end function. /* createDirectoryIf */

function dumpCollection returns integer (pcTablename as character):
    define variable service as OpenEdge.DataAdmin.IDataAdminService  no-undo.
    define variable collection as OpenEdge.DataAdmin.IDataAdminCollection  no-undo.
    service = new OpenEdge.DataAdmin.DataAdminService (ldbname("dictdb":U)).
    /** Get a datadmin collection realized from the database - remove first _ and -  */
    collection = service:GetCollection(pcTablename).
    collection:Serialize(stream dump:handle).
    return collection:Count.
        
    catch e as Progress.Lang.Error :
        undo, throw e.
    end catch.    
    finally:
        delete object service no-error. 
    end finally.  
end function.

function dumpCDCCollection returns integer (policyName as longchar, usr_dbname as char):
    define variable service         as OpenEdge.DataAdmin.IDataAdminService             no-undo.
    define variable tableCollection as OpenEdge.DataAdmin.IDataAdminCollection          no-undo.
    define variable tableIter       as OpenEdge.DataAdmin.Lang.Collections.IIterator    no-undo.
    define variable tablepolicy     as OpenEdge.DataAdmin.ICdcTablePolicy               no-undo.   
    define variable fieldpolicy     as OpenEdge.DataAdmin.ICdcFieldPolicySet            no-undo.
    define variable i               as int            no-undo.
    define variable polStr          as longchar       no-undo.
    define variable tblName         as char            no-undo.
    define variable tblList         as longchar       no-undo.
    define variable polCnt          as int            no-undo.
    define variable errMsg          as char            no-undo.
    define variable j               as int            no-undo.
    define variable polEntry        as integer        no-undo.

    service = new OpenEdge.DataAdmin.DataAdminService (ldbname(usr_dbname)).
    
    assign 
        fil-e = SUBSTRING(fil,1,LENGTH(fil,"character") - 2,"character") + "e"
        recs = 0.
        
    repeat polEntry = 1 to num-entries(policyName) by 50:
        do i = polEntry to polEntry + 49 :
            if i <= num-entries (policyName) then
                polStr = polStr + " or " + "name = " + quoter(entry(i,string(policyName))).
            else leave.
        end.
        polstr = trim(polstr, " or ").
        
        if policyName eq "all" then
            tableCollection = service:GetCdcTablePolicies("Instance eq ~"0~" ").
        //else if index(policyname,",") > 0 then
        else    tableCollection = service:GetCdcTablePolicies(string(polstr)).
        //else tableCollection = service:GetCdcTablePolicies("Name = " + quoter(string(policyName))).
        
        tableIter = tableCollection:Iterator().
        do while tableIter:HasNext():          
            tablepolicy = cast(tableIter:Next(), OpenEdge.DataAdmin.ICdcTablePolicy).
            //find unique table with schema name for dump process.
            tblName = tablepolicy:Table:name + "@" + if tablepolicy:Table:NonPUBSchemaName <> ? then tablepolicy:Table:NonPUBSchemaName else "PUB".
            if length(tblList) > 0 then
                tblList = left-trim (tblList,",").
            if valid-object(dictMonitor) then 
                dictMonitor:StartTable(tablePolicy:Name,"cdcPolicies","",fil).
            //dump only single policy for a source table 
            if lookup(tblName,tblList) = 0 then
            do: 
                export stream dump    
                    "Table"
                    string(tablepolicy:Name)
                    string(tablepolicy:Description)
                    integer(tablepolicy:State)
                    integer(if tablepolicy:Instance eq CdcTablePolicyInstanceEnum:Previous then CdcTablePolicyInstanceEnum:Pending else tablepolicy:Instance) // dump the previous policy as pending 
                    string(tablepolicy:Table:name)
                    string(if tablepolicy:Table:NonPUBSchemaName <> ? then tablepolicy:Table:NonPUBSchemaName else "PUB") //tablepolicy:Table:SourceTableOwner)
                    string(if valid-object(tablepolicy:DataArea) then tablepolicy:DataArea:Name else ?)
                    string(if valid-object(tablepolicy:IndexArea) then tablepolicy:IndexArea:Name else ?)
                    logical(tablepolicy:IdentifyingField)
                    integer(tablepolicy:Level)
                    string(tablepolicy:ChangeTable)
                    string(tablepolicy:ChangeTableOwner)
                    logical(tablepolicy:EncryptPolicy)        
                    string(tablepolicy:Misc[1])
                    string(tablepolicy:Misc[2])
                    string(tablepolicy:Misc[3])
                    string(tablepolicy:Misc[4])
                    string(tablepolicy:Misc[5])
                    string(tablepolicy:Misc[6])
                    string(tablepolicy:Misc[7])
                    string(tablepolicy:Misc[8])
                    string(tablepolicy:Misc[9])
                    string(tablepolicy:Misc[10])
                    string(tablepolicy:Misc[11])
                    string(tablepolicy:Misc[12])
                    string(tablepolicy:Misc[13])
                    string(tablepolicy:Misc[14])
                    string(tablepolicy:Misc[15])
                    string(tablepolicy:Misc[16])
                    integer(tablepolicy:FieldPolicies:Count)
                    .                
                fieldpolicy = tablepolicy:FieldPolicies.
                fieldpolicy:Serialize(stream dump:handle). 
                assign 
                    tblList = tblList + "," + tblName 
                    polCnt  = polCnt + 1
                    recs    = recs + 1.
                if valid-object(dictMonitor) then                              
                    dictMonitor:EndPolicy(fil,tablepolicy:Name,int64(recs)).        
            end.
            else 
            do:
                derr = true.
                if valid-object(dictMonitor) then 
                    dictMonitor:AddPolicyError(fil,tablepolicy:Name,"Failed to dump " + quoter(tablepolicy:Name) + " policy information for source table " + quoter(tablepolicy:Table:Name) + "." +
                        " You can dump only single policy information for a specific source table into a .cd file.") . 
            
            //fill in the error messages and write them to .e file at a time later after this loop    
                errMsg = errMsg + "Failed to dump " + quoter(tablepolicy:Name) + " policy information for source table " + quoter(tablepolicy:Table:Name) + "." +
                      " You can dump only single policy information for a specific source table into a .cd file.~n".
                output stream dumperr to value(fil-e). 
                put stream dumperr unformatted  errMsg. 
                output stream dumperr close.          
            end. 
            if user_env[6] NE "dump-silent" then 
            do:  
                COLOR DISPLAY NORMAL fil msg WITH FRAME dumpdata.
                DISPLAY fil WITH FRAME dumpdata.
            
                /* make sure value can fit in format */
                msg = STRING(polCnt,">>>>>>>>>>>>9") NO-ERROR.
                IF ERROR-STATUS:NUM-MESSAGES > 0 THEN
                    msg = "**********". /* too big to fit on the screen */    
                DISPLAY msg WITH FRAME dumpdata.
            end.     
        end.
        if polStr > "" then polStr = "".         
    end.
        
    if derr or NonExistPolList > "" then 
    do:
        do j = 1 to num-entries (NonExistPolList):
            derr = true.
            errMsg = "CDC policy with name " + quoter(entry(j,NonExistPolList)) + " does not exist.~n".
        end.        
        errMsg = errMsg + "Found " + string(num-entries(policyName)) + " policy records, but " + string(polCnt) + " policy(s) dumped successfully.~n".          
        output stream dumperr to value(fil-e) append. 
        put stream dumperr unformatted  errMsg. 
        output stream dumperr close.        
    end.
    
    /*
    if INDEX(policyName,",") > 0 then do:
        do i = 1 to num-entries (policyname) :
            polStr = polStr + " or " + "name = " + quoter(ENTRY(i,string(policyName))).
        end.
        polstr = trim(polstr, " or ").    
    end.    
    
    
    if policyName eq "all" then
        tableCollection = service:GetCdcTablePolicies("Instance eq ~"0~" ").
    else if index(policyname,",") > 0 then
         tableCollection = service:GetCdcTablePolicies(string(polstr)).
    else tableCollection = service:GetCdcTablePolicies("Name = " + quoter(string(policyName))).
    
    tableIter = tableCollection:Iterator().
    do while tableIter:HasNext():          
        tablepolicy = cast(tableIter:Next(), OpenEdge.DataAdmin.ICdcTablePolicy).
        tblName = tablepolicy:Table:name + "@" + if valid-object(tablepolicy:Table:Schema) then "PUB" else tablepolicy:Table:NonPUBSchemaName.
        if length(tblList) > 0 then
            tblList = left-trim (tblList,",").
        if valid-object(dictMonitor) then 
            dictMonitor:StartTable(tablePolicy:Name,"cdcPolicies","",fil).
        if index(tblList, tblName) eq 0 then do: 
        export stream dump    
            "Table"
            string(tablepolicy:Name)
            string(tablepolicy:Description)
            integer(tablepolicy:State)
            integer(if tablepolicy:Instance eq CdcTablePolicyInstanceEnum:Previous then CdcTablePolicyInstanceEnum:Pending else tablepolicy:Instance) // dump the previous policy as pending 
            string(tablepolicy:Table:name)
            string(if valid-object(tablepolicy:Table:Schema) then "PUB" else tablepolicy:Table:NonPUBSchemaName) //tablepolicy:Table:SourceTableOwner)
            string(if valid-object(tablepolicy:DataArea) then tablepolicy:DataArea:Name else ?)
            string(if valid-object(tablepolicy:IndexArea) then tablepolicy:IndexArea:Name else ?)
            logical(tablepolicy:IdentifyingField)
            integer(tablepolicy:Level)
            string(tablepolicy:ChangeTable)
            string(tablepolicy:ChangeTableOwner)
            logical(tablepolicy:EncryptPolicy)        
            string(tablepolicy:Misc[1])
            string(tablepolicy:Misc[2])
            string(tablepolicy:Misc[3])
            string(tablepolicy:Misc[4])
            string(tablepolicy:Misc[5])
            string(tablepolicy:Misc[6])
            string(tablepolicy:Misc[7])
            string(tablepolicy:Misc[8])
            string(tablepolicy:Misc[9])
            string(tablepolicy:Misc[10])
            string(tablepolicy:Misc[11])
            string(tablepolicy:Misc[12])
            string(tablepolicy:Misc[13])
            string(tablepolicy:Misc[14])
            string(tablepolicy:Misc[15])
            string(tablepolicy:Misc[16])
            integer(tablepolicy:FieldPolicies:Count)
            .                
            fieldpolicy = tablepolicy:FieldPolicies.
            fieldpolicy:Serialize(stream dump:handle). 
            assign tblList = tblList + "," + tblName 
                   polCnt  = polCnt + 1
                   recs    = recs + 1.
            if valid-object(dictMonitor) then                              
                dictMonitor:EndPolicy(fil,tablepolicy:Name,int64(recs)).        
        end.
        else do:
            derr = true.
            if valid-object(dictMonitor) then 
                dictMonitor:AddPolicyError(fil,tablepolicy:Name,"Failed to dump " + quoter(tablepolicy:Name) + " policy information for source table " + quoter(tablepolicy:Table:Name) + "." +
                " You can dump only single policy information for a specific source table into a .cd file.") . 
            
            //fill in the error messages and write them to .e file at a time later after this loop    
            errMsg = errMsg + "Failed to dump " + quoter(tablepolicy:Name) + " policy information for source table " + quoter(tablepolicy:Table:Name) + "." +
                     " You can dump only single policy information for a specific source table into a .cd file.~n".            
        end.      
    end.
    
    if derr or NonExistPolList > "" then do:
        do j = 1 to num-entries (NonExistPolList):
            derr = true.
            errMsg = errMsg + "CDC policy with name " + quoter(entry(j,NonExistPolList)) + " does not exist.~n".
        end.        
        errMsg = errMsg + "Found " + string(tableCollection:Count + num-entries(NonExistPolList)) + " policy records, but " + string(polCnt) + " policy(s) dumped successfully".         
        output stream dumperr to value(fil-e). 
        put stream dumperr unformatted  errMsg. 
        output stream dumperr close.
    end.*/
    
    return polCnt. 
    catch e as Progress.Lang.Error :
        undo, throw e.
    end catch.    
    finally:
        delete object service no-error. 
        policyName = ?.
    end finally.  
end function.
/*--------------------------- END FUNCTIONS  --------------------------*/

IF SESSION:CPINTERNAL EQ "undefined":U THEN
    isCpUndefined = YES.

&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
  cSlash = "/".
&ELSE 
  cSlash = "~\".
&ENDIF
 
IF NOT isCpUndefined THEN 
DO:
  IF user_longchar <> "" AND user_longchar <> ? THEN
     ASSIGN has_lchar = TRUE.

/* let's use a longchar in case the string is too big, and because
   the code below can be generic 
*/
   IF NOT has_lchar THEN
   do:
      user_longchar = user_env[1].
      has_lchar = true.
   end.   
END.

/* free longchar if we don't need it */
IF NOT isCpUndefined AND NOT has_lchar THEN
   user_longchar = ?.

IF NOT CONNECTED(user_dbname) THEN 
DO:
   cMsg =  "Database " + user_dbname +
        "is not connected!" . 
   if user_env[6] NE "dump-silent" then
      MESSAGE cMsg
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
   else 
      undo, throw new AppError(cMsg).     
    RETURN.
END.     

/* don't display frame */
if user_env[6] NE "dump-silent" then 
do:
  PAUSE 0.
  lImmediatedisp = SESSION:IMMEDIATE-DISPLAY.
  SESSION:IMMEDIATE-DISPLAY = yes.
  VIEW FRAME dumpdata.
  run adecomm/_setcurs.p ("WAIT").
end.

/* check if we are supposed to skip the code page vaidation. 
   this is signaled by adding a skip in front of the actual code page.. 
   hacky, but what can you do with this code.   
   When silent we cannot have the message box appearing, so the code page check 
   throws an error instead of continuing. This setting allows us to bypass the 
   check. Typically set from UI after the error has occured first time . */  
if user_env[5] begins "skip-" then
do:
    lSkipCodePageValidation = true.
    user_env[5] =  substr(user_env[5],6).
    if user_env[5] = '?' then  user_env[5] = ?.
end.    

IF user_env[5] = " " OR user_env[5] = ?  THEN 
    assign user_env[5] = "<internal defaults apply>".

/* Used in numformat output */
CodeOut = IF user_env[5] = "<internal defaults apply>" 
          THEN SESSION:CPINTERNAL
          ELSE user_env[5].

RUN "prodict/_dctyear.p" (OUTPUT mdy,OUTPUT yy).

ASSIGN
  phDbName = PDBNAME("DICTDB") /* for logging audit event */
  cntr = 0
  addfilename = (IF has_lchar THEN INDEX(user_longchar,",") > 0 ELSE INDEX(user_env[1],",") > 0)
                or
                user_env[2] = ""
                or
                user_env[2] = "."
                or
                user_env[2] matches "*/" 
                or 
                user_env[2] matches "*~~~\"
                or (if has_lchar then index(user_longchar,"all") > 0 else index(user_env[1],"all") > 0). 
  
  loop = TRUE. /* use this to mark initial entry into loop */

PAUSE 5 BEFORE-HIDE.


IF has_lchar THEN
   numCount = NUM-ENTRIES(user_longchar).
ELSE
   numCount = NUM-ENTRIES(user_env[1]).
   
if valid-object(dictMonitor) then numCount = 1.

IF user_env[6] = "CDC" THEN addfilename = No.

if addfilename then
do: 
   if not valid-object(dictMonitor) then do:
       if not validDirectory(user_env[2]) then 
       do:
           cMsg = xDumpTerminatedMsg + " Directory " + user_env[2] + " does not exist.".
           if user_env[6] NE "dump-silent" then do:   
               message cMsg
                   view-as alert-box error buttons ok.
                   return.
           end.
           else
               undo, throw new AppError(cMsg).
       end.
   end.
end.
 
DO ON STOP UNDO, LEAVE:
    /* if not specifically skippng this check and not the no-convert case, 
       check utf-8 case  */
    IF not lSkipCodePageValidation 
    and user_env[5] NE "<internal defaults apply>" THEN 
    DO:
        FIND FIRST DICTDB._Db WHERE RECID(DICTDB._Db) = drec_db.
        IF DICTDB._Db._db-xl-name = "UTF-8" 
        AND (SESSION:CHARSET NE "UTF-8" OR TRIM(user_env[5]) NE "utf-8") THEN 
        DO:

            cMsg = "The database codepage is 'UTF-8' but -cpinternal and/or the codepage" + "~n" +
                   "for output is not, which can cause some data not to be dumped properly" + "~n" +
                   "if it cannot be represented in that codepage." + "~n" +
                   "It's recommended that you dump the data from a session with the 'UTF-8'" + "~n" +
                   "codepage to avoid possible data corruption.".
            if user_env[6] = "dump-silent" then 
            do:    
                undo, throw new AppError(cMsg).
            END.
            else if user_env[6] = "no-alert-boxes" then 
            do:  /* output WITHOUT alert-box */
                MESSAGE cMsg.
            END.
            ELSE DO:
                MESSAGE cMsg
                    VIEW-AS ALERT-BOX WARNING.
            END.
        END.
    END.		
    
    DO ix = 1 to numCount ON ERROR UNDO,NEXT:        
        /*if isCpUndefined then do:
           if NUM-ENTRIES(user_env[1]) > 1 or user_env[1] eq "all" then do:
               singlePolicy = no.                
           end.               
        end. 
        else if NUM-ENTRIES(user_longchar) > 1  or user_longchar eq "all" then do:
                 singlePolicy = no.                  
        end.*/
        
        /* Gather the list of non existing policies and write them into .e file */
        if isCpUndefined then do:
            if user_env[1] ne "all" then do:
                do pCnt = 1 to num-entries (user_env[1]):
                    find DICTDB._CDC-Table-Policy where 
                               DICTDB._CDC-Table-Policy._policy-name = entry(pCnt,user_env[1]) no-lock no-error.
                    if not available DICTDB._CDC-Table-Policy then
                        NonExistPolList = NonExistPolList + "," + entry(pCnt,user_env[1]).                
                end.
            end.
        end. 
        else do:
            if user_longchar ne "all" then do:
                do pCnt = 1 to num-entries (user_longchar):
                    pStr = entry(pCnt,user_longchar).
                    find DICTDB._CDC-Table-Policy where 
                               DICTDB._CDC-Table-Policy._policy-name = pStr no-lock no-error.
                    if not available DICTDB._CDC-Table-Policy then
                        NonExistPolList = NonExistPolList + "," + entry(pCnt,user_longchar).                
                end.
            end.
        end.                  
        
        if NonExistPolList > "" then 
            NonExistPolList = left-trim(NonExistPolList,",").        
        
        /* do we need to check dbversion? */       
         
        IF loop THEN .
        ELSE if user_env[6] NE "dump-silent"  then 
        do:
            if FRAME-LINE(dumpdata) = FRAME-DOWN(dumpdata) THEN
                UP FRAME-LINE(dumpdata) - 1 WITH FRAME dumpdata.
            ELSE
                DOWN 1 WITH FRAME dumpdata.
        end.
        
        if index(user_env[2],"/") > 0 then
                cSlash = "/". 
  
        if addfilename then do:
            if valid-object(dictMonitor) then fil = user_env[2].
            else
            fil = (IF user_env[2] EQ "" OR user_env[2] EQ "." 
                   THEN ""
                   ELSE RIGHT-TRIM(user_env[2],cSlash) + cSlash). 
        end.
        else if user_env[2] matches "*" + ".cd" then
            fil = user_env[2].  
        else do:
            if not user_env[2] matches "*" + "/" then  
                user_env[2] = user_env[2] + "/".
                fil = user_env[2] + user_dbname + ".cd".
        end. 
                    
        if addfilename and not valid-object(dictMonitor) then 
            fil = fil + user_dbname + ".cd".

        IF R-INDEX(fil,"/") > 0 THEN do:
            trailerFileName = SUBSTRING(fil,R-INDEX(fil,"/") + 1,R-INDEX(fil,".") - 2 - R-INDEX(fil,"/")  + 1,"character").
            if not validDirectory(SUBSTRING(fil,1,R-INDEX(fil,"/"),"character")) then 
            do:
                cMsg = xDumpTerminatedMsg + " Directory " + SUBSTRING(fil,1,R-INDEX(fil,"/") - 1,"character") + " does not exist.".
                if user_env[6] NE "dump-silent" then do:
                    message cMsg view-as alert-box error buttons ok.
                    return.
                end.
                else undo, throw new AppError(cMsg).
            end.
        end.        
        ELSE do: 
            trailerFileName = SUBSTRING(fil,R-INDEX(fil,"~\") + 1,R-INDEX(fil,".") - 2 - R-INDEX(fil,"~\")  + 1,"character") . 
            if not validDirectory(SUBSTRING(fil,1,R-INDEX(fil,"~\"),"character")) then 
            do:
                cMsg = xDumpTerminatedMsg + " Directory " + SUBSTRING(fil,1,R-INDEX(fil,"~\") - 1,"character") + " does not exist.".
                if user_env[6] NE "dump-silent" then do:
                    message cMsg view-as alert-box error buttons ok.
                    return.
                end.
                else undo, throw new AppError(cMsg).
            end.        
        end. 
            
         
        //if valid-object(dictMonitor) then fil = user_env[2].       
      
        assign
            loop = FALSE
            recs = 0. 
					
   
        /*if user_env[6] NE "dump-silent" then 
        do: 
            if singlePolicy then do:
                DISPLAY fil "Dumping" @ msg  WITH FRAME dumpdata. 				
                COLOR DISPLAY MESSAGES fil msg WITH FRAME dumpdata.				
            end.
            else do:
                DISPLAY fil "Dumping" @ msg WITH FRAME dumpdata. 				
                COLOR DISPLAY MESSAGES fil msg WITH FRAME dumpdata.
            end.
        end.*/
        ASSIGN
            stamp = STRING(YEAR( TODAY),"9999") + "/"
                  + STRING(MONTH(TODAY),"99"  ) + "/"
                  + STRING(DAY(  TODAY),"99"  ) + "-"
                  + STRING(TIME,"HH:MM:SS")
            cerr  = TRUE
            exceptfields = ""
            tableexpression = " NO-LOCK".            
    
        DO ON ERROR UNDO,LEAVE:      /* code-page-stuf <hutegger> 94/02 */
            IF user_env[3] = "" OR user_env[3] = "NO-MAP" THEN 
            DO:
                IF user_env[5] = "<internal defaults apply>" THEN 
                DO:
                    IF lobdir <> "" THEN
                        OUTPUT STREAM dump TO VALUE(fil) LOB-DIR VALUE(lobdir)
                            NO-ECHO NO-MAP NO-CONVERT.
                    ELSE
                        OUTPUT STREAM dump TO VALUE(fil) 
                            NO-ECHO NO-MAP NO-CONVERT.
                END.
                ELSE DO:
                    IF lobdir <> "" THEN
                        OUTPUT STREAM dump TO VALUE(fil) LOB-DIR VALUE(lobdir) NO-ECHO NO-MAP
                            CONVERT SOURCE SESSION:CHARSET TARGET user_env[5].
                    ELSE 
                        OUTPUT STREAM dump TO VALUE(fil) NO-ECHO NO-MAP
                            CONVERT SOURCE SESSION:CHARSET TARGET user_env[5].
                END.
            END.
            ELSE DO:
                IF user_env[5] = "<internal defaults apply>" THEN 
                DO:
                    IF lobdir <> "" THEN 
                        OUTPUT STREAM dump TO VALUE(fil) LOB-DIR VALUE(lobdir) NO-ECHO 
                            MAP VALUE(SUBSTRING(user_env[3],5,-1,"character"))
                            NO-CONVERT.
                    ELSE
                        OUTPUT STREAM dump TO VALUE(fil) NO-ECHO 
                            MAP VALUE(SUBSTRING(user_env[3],5,-1,"character"))
                            NO-CONVERT.
                END.
                ELSE DO:
                    IF lobdir <> "" THEN
                        OUTPUT STREAM dump TO VALUE(fil) LOB-DIR VALUE(lobdir) NO-ECHO 
                            MAP VALUE(SUBSTRING(user_env[3],5,-1,"character"))
                            CONVERT SOURCE SESSION:CHARSET TARGET user_env[5].
                    ELSE 
                        OUTPUT STREAM dump TO VALUE(fil)  NO-ECHO 
                            MAP VALUE(SUBSTRING(user_env[3],5,-1,"character"))
                            CONVERT SOURCE SESSION:CHARSET TARGET user_env[5].
                END.
            END.
            cerr = FALSE.
        END. 
        IF cerr THEN 
        DO:
            if user_env[6] NE "dump-silent" then 
            do:
                DISPLAY "Error!" @ msg WITH FRAME dumpdata.
                COLOR DISPLAY NORMAL fil msg WITH FRAME dumpdata.
            end.
            else 
                undo, throw new AppError ("Error!").
            NEXT.
        END.
      
        CREATE ALIAS "DICTDB2" FOR DATABASE VALUE(user_dbname).        
        
        if has_lchar THEN 
            recs = dumpCDCCollection(user_longchar,user_dbname).
        else recs = dumpCDCCollection(user_env[1],user_dbname).                    
         
        /*------------------ Trailer-INFO ------------------*/
    
        /* if value is too large to fit in format, write it as it is */
        ASSIGN cRecords = STRING(recs,"9999999999999") NO-ERROR.
        IF ERROR-STATUS:NUM-MESSAGES > 0 THEN
            ASSIGN cRecords = STRING(recs).
        
        {prodict/dump/dmptrail.i
            &entries      = "PUT STREAM dump UNFORMATTED
                          ""filename=""   trailerFileName SKIP
                          ""records=""    cRecords SKIP
                          ""ldbname=""    LDBNAME(user_dbname) SKIP
                          ""timestamp=""  stamp SKIP
                          ""numformat=""
                       STRING(ASC(
               SESSION:NUMERIC-SEPARATOR,CodeOut,SESSION:CPINTERNAL))     +
                       "",""                                                      +                   STRING(ASC(
               SESSION:NUMERIC-DECIMAL-POINT,CodeOut,SESSION:CPINTERNAL))
                            SKIP
                            ""dateformat="" mdy STRING(- yy) SKIP.
                        IF user_env[3] = ""NO-MAP"" THEN
                          PUT STREAM dump UNFORMATTED ""map=NO-MAP"" SKIP.
                        ELSE
                        IF user_env[3] <> """" THEN
                          PUT STREAM dump UNFORMATTED ""map=MAP:"" 
                            SUBSTRING(user_env[3],4,-1,""character"") SKIP.
                        "  
            &seek-stream  = "dump"
            &stream       = "STREAM dump"
        }  /* adds trailer with code-page-entrie to end of file */
        
        /*------------------ Trailer-INFO ------------------*/
    
        OUTPUT STREAM dump CLOSE.				
        
        if user_env[6] NE "dump-silent" then 
        do:  
            COLOR DISPLAY NORMAL fil msg WITH FRAME dumpdata.
            DISPLAY fil WITH FRAME dumpdata.
            
            /* make sure value can fit in format */
            msg = STRING(recs,">>>>>>>>>>>>9") NO-ERROR.
            IF ERROR-STATUS:NUM-MESSAGES > 0 THEN
                msg = "**********". /* too big to fit on the screen */    
            DISPLAY msg WITH FRAME dumpdata.
        end. 
		
		IF derr THEN 
        DO:
            if user_env[6] NE "dump-silent" then 
            do:
                message "Dump of database contents completed."  skip
                        "Errors/Warnings listed in .e file placed into same directory as .cd file" skip view-as alert-box information buttons ok.
            end.
            else do:
                if valid-object(dictMonitor) then do:
                    dictMonitor:AnyError = true.
                    dictMonitor:ErrorMessage = "Dump of database contents completed. " + 
                        "Errors/Warnings listed in .e file placed into $wrk_oemgmt/files.dir folder".
                //undo, throw new AppError ("Error!").
                end.
            end.
        END.        
        
        cntr = recs.
        leave.        
               
        /* this block has on error, undo next, so handle error so we can throw in case we are running silent */
        catch e as Progress.Lang.Error :
            run handleError(e). 
        end catch.      
    END. /* DO FOR DICTDB._File ix = 1 to numCount ON ERROR UNDO,NEXT:*/

    stopped = false.
END.  /* on stop */

if user_env[6] NE "dump-silent" then 
do:
    DO WHILE FRAME-LINE(dumpdata) < FRAME-DOWN(dumpdata):
        DOWN 1 WITH FRAME dumpdata.
        CLEAR FRAME dumpdata NO-PAUSE.
    END.
end.

run adecomm/_setcurs.p ("").
 
if user_env[6] = "dump-silent" then 
do:  /* output WITHOUT alert-box */
  IF stopped THEN
      undo, throw new AppError(xDumpTerminatedMsg).
end.      /* output WITHOUT alert-box */

else if user_env[6] = "no-alert-boxes" then 
do:  /* output WITHOUT alert-box */

  IF stopped THEN
    MESSAGE xDumpTerminatedMsg.
  ELSE
    MESSAGE "Dump of database contents completed:" 
                    cntr "CDC policy(s) dumped successfully.".
//HIDE FRAME dumpdata NO-PAUSE.
end.      /* output WITHOUT alert-box */
else if user_env[6] = "CDC" then do: 
  IF stopped THEN
    MESSAGE xDumpTerminatedMsg VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  ELSE 
    MESSAGE "Dump of database contents completed:" 
                    cntr "CDC policy(s) dumped successfully." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
 HIDE FRAME dumpdata NO-PAUSE.
end.    
else do:  /* output WITH alert-box */

  IF stopped THEN
      MESSAGE xDumpTerminatedMsg
                 VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  ELSE
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
      MESSAGE "Dump of database contents completed:" 
                    cntr "table(s) dumped successfully.".
      pause.
   &ELSE
      MESSAGE "Dump of database contents completed:" SKIP
              cntr "CDC policy(s) dumped successfully."
              VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
   &ENDIF
  
end.     /* output WITH alert-box */

RETURN.

catch e as Progress.Lang.Error :
    run handleError(e). 
end catch.

finally:
   IF NOT isCpUndefined THEN
       ASSIGN user_longchar = "".
   if user_env[6] = "dump-silent" or user_env[6] = "CDC" then 
   do:
      HIDE FRAME dumpdata NO-PAUSE.
      SESSION:IMMEDIATE-DISPLAY = if lImmediatedisp <> ? then lImmediatedisp else no.
   end.
end finally.


procedure handleError:
    define input parameter pError as Progress.Lang.Error no-undo.
    define variable i as integer no-undo.
    define variable cMsg as character no-undo.
    
    if pError:NumMessages = 0 and type-of(pError,AppError)then 
        cmsg = cast(perror,AppError):ReturnValue.
    else  
    do i = 1 to pError:NumMessages:
        cmsg = cmsg + pError:GetMessage(i) + "~n".
    end.  
    
    if user_env[6] NE "dump-silent" then
        message cmsg   
            view-as alert-box error.      
    else do:
        undo, throw new AppError(cmsg).
    end.
end.

 

