/*************************************************************/
/* Copyright (c) 2016 by Progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : _lodcdcdata.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : mkondra
    Created     : Thu Jul 14 17:35:43 IST 2016
    Notes       :
  ----------------------------------------------------------------------*/
/*
  user_env[1] = comma-delim file list
                or it may be in user_longchar, if list was too big.
  user_env[2] = load path (for >1 file) or load filename (for 1 file)
  user_env[3] = "MAP <name>" or "NO-MAP" OR ""
  user_env[4] = error percentage
  user_env[5] = comma separated list of table numbers of tables not to disable
                triggers for. We'll disable triggers for all other tables.
                May bet called by old version of load_d.p with old method:
                comma separated list of "y" (yes) or "n" (no) which
                corresponds to file list in user_env[1], indicating for each,
                whether triggers should be disabled when the dump is done.
  user_env[10] = codepage (set in _usrload.p)
*/
/* ensure that errors from directory functions are thrown   
   this also allows us to use errorHandler 
   this does not affect _runload.i whihc does not throw, bit handles all error   
*/ 
routine-level on error undo, throw.
 
using Progress.Lang.*.

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

/* can only fit 8 digits in the recs value in the form */
&SCOPED-DEFINE MAX_RECS_FORMAT      "ZZZZZZZ9"
&SCOPED-DEFINE MAX_RECS_FORMAT_SIZE 8

DEFINE NEW SHARED STREAM   loaderr.
DEFINE NEW SHARED STREAM   loadread.
DEFINE NEW SHARED VARIABLE errs              AS INTEGER   NO-UNDO.
DEFINE NEW SHARED VARIABLE recs              AS INT64.   /*UNDO*/
DEFINE NEW SHARED VARIABLE xpos              AS INTEGER   NO-UNDO.
DEFINE NEW SHARED VARIABLE ypos              AS INTEGER   NO-UNDO.

DEFINE            VARIABLE cload_size        AS CHARACTER NO-UNDO.
DEFINE            VARIABLE cFile             AS CHARACTER NO-UNDO.
define            variable cChar             as character no-undo.
DEFINE            VARIABLE cImport           AS CHARACTER NO-UNDO.
DEFINE            VARIABLE cerror            AS CHARACTER NO-UNDO.
DEFINE            VARIABLE cerrors           AS INTEGER   INITIAL 0 NO-UNDO.
DEFINE            VARIABLE codepage          AS CHARACTER NO-UNDO init "UNDEFINED".
DEFINE            VARIABLE d-ldbname         AS CHARACTER NO-UNDO.
DEFINE            VARIABLE d-was             AS CHARACTER NO-UNDO.
DEFINE            VARIABLE dsname            AS CHARACTER NO-UNDO.
DEFINE            VARIABLE error%            AS INTEGER   NO-UNDO.
DEFINE new shared VARIABLE fil-d             AS CHARACTER NO-UNDO.
DEFINE            VARIABLE fil-e             AS CHARACTER NO-UNDO.
DEFINE            VARIABLE i                 AS INT64     NO-UNDO.
DEFINE            VARIABLE infinity          AS LOGICAL   NO-UNDO.
DEFINE            VARIABLE irecs             AS INT64     NO-UNDO.
DEFINE            VARIABLE crecs             AS CHARACTER NO-UNDO.
DEFINE            VARIABLE l                 AS LOGICAL   NO-UNDO.
DEFINE            VARIABLE load_size         AS INT64     NO-UNDO.
DEFINE            VARIABLE lvar              AS CHARACTER EXTENT 10 NO-UNDO.
DEFINE            VARIABLE lvar#             AS INTEGER   NO-UNDO.
DEFINE            VARIABLE maptype           AS CHARACTER NO-UNDO.
DEFINE            VARIABLE mdy               AS CHARACTER NO-UNDO.
DEFINE            VARIABLE msg               AS CHARACTER NO-UNDO.
DEFINE            VARIABLE numformat         AS CHARACTER NO-UNDO.
DEFINE            VARIABLE terrors           AS INTEGER   INITIAL 0 NO-UNDO.
DEFINE            VARIABLE addfilename       AS LOGICAL   NO-UNDO.
DEFINE            VARIABLE yy                AS INTEGER   NO-UNDO.
DEFINE            VARIABLE stopped           AS LOGICAL   INIT TRUE NO-UNDO.
DEFINE            VARIABLE NumProcRun        AS LOGICAL   NO-UNDO.
DEFINE            VARIABLE lobdir            AS CHARACTER NO-UNDO.
DEFINE            VARIABLE cTemp             AS CHARACTER NO-UNDO.
DEFINE            VARIABLE newAppCtx         AS LOGICAL   INIT NO NO-UNDO.
DEFINE            VARIABLE dis_trig          AS CHARACTER NO-UNDO.
DEFINE            VARIABLE old_dis_trig      AS LOGICAL   NO-UNDO.

DEFINE            VARIABLE numCount          AS INTEGER   NO-UNDO.
DEFINE            VARIABLE ix                AS INTEGER   NO-UNDO.
DEFINE            VARIABLE ilast             AS INTEGER   NO-UNDO.
DEFINE            VARIABLE has_lchar         AS LOGICAL   NO-UNDO.
DEFINE            VARIABLE has_aud           AS LOGICAL   NO-UNDO.
DEFINE            VARIABLE isCpUndefined     AS LOGICAL   NO-UNDO.
define            variable isSuperTenant     as logical   no-undo. 
DEFINE            VARIABLE cMsg              AS CHARACTER NO-UNDO.
define            variable cGroupName        as char      no-undo.
define            variable cslash            as character no-undo.
define            variable xUseDefault       as character no-undo init "<default>".
define            variable lSuppressWarnings as logical   no-undo.
define            variable lImmediateDisplay as logical   no-undo.
define            variable cSearchFile       as character no-undo.
define            variable cFileType         as character no-undo.
define            variable cFileTypeSubdir   as character no-undo.

DEFINE FRAME loaddata
    fil-d  FORMAT "x(27)"    COLUMN-LABEL "Load file"
    msg    FORMAT "x(8)"     COLUMN-LABEL "Records!Loaded"
    errs   FORMAT "ZZZZZZZ9" COLUMN-LABEL "Total  !Errors " 
    ATTR-SPACE SPACE(0)
    crecs  FORMAT "X({&MAX_RECS_FORMAT_SIZE})" COLUMN-LABEL "Expected! Records" SPACE(1)
    HEADER
    " Loading Data.   Press " +
    KBLABEL("STOP") + " to terminate the load process." format "x(66)" SKIP(1)
    WITH
    NO-ATTR-SPACE
    SCREEN-LINES - 7 DOWN ROW 1 CENTERED USE-TEXT
  &IF "{&WINDOW-SYSTEM}" <> "TTY"
  &THEN VIEW-AS DIALOG-BOX THREE-D SCROLLABLE WIDTH 60 TITLE "Load Change Data Capture Policies"
  &ENDIF.  /* Move this here to scope above the internal procedure */


/* LANGUAGE DEPENDENCIES START */ /*---------------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 15 NO-UNDO INITIAL [
/* 1*/ "Loading",
/* 2*/ "Could not find load file",
/* 3*/ "for CDC policy",
/* 4*/ "Load of database contents completed.",
/* 5*/ "Errors/Warnings listed in .e file placed into same directory as .cd file",
/* 6*/ "ERROR! Trailer indicated",
/* 7*/ "records, but",
/* 8*/ "records were loaded.",
/* 9*/ "ERROR! -d <mdy> or -yy <n> settings of dump were",
/*10*/ "but current settings are",
/*11*/ "May cause load errors.",
/*12*/ "!ERROR!",
/*13*/ "Take a look at .ds file placed in same directory as your database.",
/*14*/ "Expected # of records is unknown.Error % interpreted as absolute #.",
/*15*/ "Load terminated."
    ].

DEFINE VARIABLE no-file  AS CHARACTER FORMAT "x(32)".



/* LANGUAGE DEPENDENCIES END */ /*-----------------------------------------*/

/*--------------------------- FUNCTIONS  --------------------------*/
function validDirectory returns logical ( cValue as char):
  
    IF cValue <> "" THEN 
    DO:
        /* not a propath search - use logic blank is default 
        - the directory is currently used as-is in output to and os-create */
        if not (cValue begins "/" or cvalue begins "~\" or index(cValue,":") <> 0) then
            cValue = "./" + cValue.  
        /*  message cValue 
          view-as alert-box.*/
        ASSIGN 
            FILE-INFO:FILE-NAME = cValue. 
        
        return SUBSTRING(FILE-INFO:FILE-TYPE,1,1) = "D".
    END.
        
    return true.
 
end function. /* validDirectory */

function checkDirectory returns logical ( pDirname as char):
    define variable iStat    as integer   no-undo.
    define variable cMessage as character no-undo.
    if not validdirectory(pDirname) then
    do:
        cMessage =  new_lang[15] + " Directory " + pDirname + " does not exist.". 
        undo, throw new AppError("Directory " + pdirname + " does not exist.",?).
    end.
    return true.
end function. /* checkDirectory */

function loadCDCCollection returns character ():
    DEFINE VARIABLE errbyte    AS INT64                                   NO-UNDO.
    DEFINE VARIABLE errline    AS INTEGER                                 NO-UNDO.
    DEFINE VARIABLE nxtstop    AS INT64                                   NO-UNDO.
    DEFINE VARIABLE err%       AS INTEGER                                 NO-UNDO.
    DEFINE VARIABLE ans999     AS LOGICAL                                 NO-UNDO.
    DEFINE VARIABLE stopped    AS LOGICAL                                 NO-UNDO INIT FALSE.
    DEFINE VARIABLE j          AS INTEGER                                 NO-UNDO.
    define variable iread      as integer                                 no-undo.
    define variable polCnt     as integer                                 no-undo.
    define variable polName    as character                               no-undo.

    DEFINE VARIABLE cDbDetail  AS CHARACTER                               NO-UNDO EXTENT 4.
    DEFINE VARIABLE service    AS OpenEdge.DataAdmin.IDataAdminService    NO-UNDO.
    DEFINE VARIABLE collection AS OpenEdge.DataAdmin.IDataAdminCollection NO-UNDO.

    service = new OpenEdge.DataAdmin.DataAdminService(ldbname("dictdb2")).
   
    collection = service:GetCollection("_cdc-Table-Policy").

    ASSIGN
        recs = 0
        errs = 0
        err% = error%.

    /* Go through all load records.  When IMPORT hits the end of file or 
       ".", ENDKEY will be generated which will kick us out of this "top"
       loop.
    */
    top:
    DO WHILE TRUE TRANSACTION:
        nxtstop = recs + load_size.
        
        bottom:
        REPEAT
            WHILE recs < nxtstop ON ENDKEY UNDO,LEAVE top:
            IF RETRY THEN 
            DO:
                errs = errs + 1.
                IF ERROR-STATUS:NUM-MESSAGES > 0 THEN
                DO j = 1 TO  ERROR-STATUS:NUM-MESSAGES:
                    PUT STREAM loaderr UNFORMATTED
                        ">> ERROR READING LINE #" errline 
                        " (Offset=" errbyte  "): " ERROR-STATUS:GET-MESSAGE(j) SKIP.
                    if irecs <> ? and irecs <> recs then 
                    do:                
                        if valid-object(dictMonitor) then  
                            dictMonitor:AddPolicyError(fil-d,polName,ERROR-STATUS:GET-MESSAGE(j)).  
                    end.
                END.
                IF (err% = 0) OR
                    (err% <> 100 AND errs > ((IF irecs = ? THEN 100 
                else irecs) * err%) / 100) THEN 
                DO:
         
                    if valid-object(dictMonitor) then
                        dictMonitor:SetPolicyBailed(fil-d,polName).
          
                    PUT STREAM loaderr UNFORMATTED
                        "** Tolerable load error rate is: " err% "%." SKIP
                        "** Loading file " cFile " is stopped after " errs " error(s)." SKIP.
                    RETURN "".
                END.
                NEXT.
            END.

            ASSIGN
                errbyte = SEEK(loadread)
                errline = errline + 1
                recs    = recs + 1
                polCnt  = polCnt + 1.
                
            if polCnt le num-entries (IF has_lchar THEN user_longchar ELSE user_env[1]) then
                polName = IF has_lchar THEN ENTRY(polCnt,user_longchar) ELSE ENTRY(polCnt,user_env[1]).
            
            if valid-object(dictMonitor) then 
                dictMonitor:StartTable(polName,"cdcPolicies",cFileTypeSubdir,fil-d). 

            iRead =  collection:deserialize(STREAM loadread:handle,1) no-error.
            /* 0 = endkey */
            if (iRead = 0 or iRead = ? ) and not ERROR-STATUS:ERROR then
            do:
                undo bottom, leave top.
            end.        
    
            IF ERROR-STATUS:ERROR OR ERROR-STATUS:NUM-MESSAGES > 0 THEN 
            DO:
                IF SUBSTRING(ERROR-STATUS:GET-MESSAGE(1), 1, 7) = "WARNING" THEN 
                DO:
                    errs = errs + 1.      
                    DO j = 1 TO  ERROR-STATUS:NUM-MESSAGES:
                        PUT STREAM loaderr UNFORMATTED
                            ERROR-STATUS:GET-MESSAGE(j) SKIP.
                    END.
                END.
                ELSE 
                DO: 
                    IF TERMINAL <> "" AND user_env[6] = "s" THEN 
                    DO:
                        DO j = 1 TO  ERROR-STATUS:NUM-MESSAGES:
                            ans999 = yes.
                            MESSAGE ERROR-STATUS:GET-MESSAGE(j) SKIP(1)
                                "Press OK to continue or Cancel to stop processing."
                                VIEW-AS ALERT-BOX ERROR BUTTONS OK-CANCEL UPDATE ans999.
                            IF NOT ans999 THEN 
                            DO:
                                stopped = TRUE.
                                UNDO top, LEAVE top.
                            END.
                        END.
                    END.
                    UNDO bottom, RETRY bottom.
                END.
            END.   /* ERROR raised */
    
            service:UpdateCollection(collection) no-error .
    
            IF ERROR-STATUS:ERROR OR ERROR-STATUS:NUM-MESSAGES > 0 THEN 
            DO:
                IF TERMINAL <> "" AND user_env[6] = "s" THEN 
                DO:
                    DO j = 1 TO  ERROR-STATUS:NUM-MESSAGES:
                        ans999 = yes.
                        MESSAGE ERROR-STATUS:GET-MESSAGE(j) SKIP(1)
                            "Press OK to continue or Cancel to stop processing."
                            VIEW-AS ALERT-BOX ERROR BUTTONS OK-CANCEL UPDATE ans999.
                        IF NOT ans999 THEN 
                        DO:
                            stopped = TRUE.
                            UNDO top, LEAVE top.
                        END.
                    END.
                END.
                UNDO bottom, RETRY bottom.
            END.   /* ERROR raised */
            else do:
            if valid-object(dictMonitor) then do:
                dictMonitor:CountCDCRow(fil-d,polName).                  
                dictMonitor:EndPolicy(fil-d,polName,int64(recs)).
            end.
            end.
            catch e as Progress.Lang.Error :
            end catch.
    
        END. /* end bottom repeat */    
        catch e as Progress.Lang.Error :
            errs = errs + 1.
            IF TERMINAL <> "" AND user_env[6] = "s" THEN 
            DO:
                DO j = 1 TO e:NumMessages:
                    MESSAGE e:GetMessage(j)
                        VIEW-AS ALERT-BOX ERROR .
                END.
            END.
            DO j = 1 TO e:NumMessages:
                PUT STREAM loaderr UNFORMATTED
                    ">> ERROR LOADING POLICY " cTemp ": " e:GetMessage(j) 
                    SKIP.
            END.
            leave top.     
        end catch.  
    END. /* top transaction */
    delete object service no-error.  
    IF stopped 
        THEN RETURN "stopped".
    ELSE RETURN "".
end function.

&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
cSlash = "/".
&ELSE 
cSlash = "~\".
&ENDIF

IF SESSION:CPINTERNAL EQ "undefined":U THEN
    isCpUndefined = YES.

IF NOT isCpUndefined THEN 
DO:
    IF user_longchar <> "" AND user_longchar <> ? THEN
        ASSIGN has_lchar = TRUE.
    
    /* The only Audit table that can be loaded through this program is the
       _audit-event table, so we remove it from the templist and check for 
       instances of the _aud string in the table list. */
    
    IF NOT has_lchar THEN
    do:
        user_longchar = user_env[1].
        has_lchar = true.   
    end.   
END.

IF (isCpUndefined AND user_env[1] NE "" AND user_env[1] NE ?)
    OR (NOT isCpUndefined AND user_longchar NE "" AND user_longchar NE ?) THEN 
DO:

    ASSIGN 
        ix = (IF isCpUndefined 
                THEN INDEX(user_env[1],",_aud")
                ELSE INDEX(user_longchar,",_aud")).

    IF user_env[9] = "e" THEN 
    DO:

        ASSIGN 
            iLast = (IF isCpUndefined 
                       THEN INDEX(user_env[1],"_aud-event")
                       ELSE INDEX(user_longchar,"_aud-event")).

        /* check if there is another aud table other than _aud-event */
        IF iLast NE 0 AND ix NE 0 AND ix = (iLast - 1) THEN
            ix = (IF isCpUndefined 
                THEN INDEX(user_env[1],",_aud",ix + 1) 
                ELSE INDEX(user_longchar,",_aud",ix + 1)).
    END.
   
    IF ix NE 0 THEN 
    DO:
        IF NOT isCpUndefined AND NOT user_longchar BEGINS "_aud" THEN
            has_aud = TRUE.

        IF isCpUndefined AND NOT user_env[1] BEGINS "_aud" THEN
            has_aud = TRUE.
    END.
END.

/* free longchar if we don't need it */
IF NOT isCpUndefined AND NOT has_lchar THEN
    user_longchar = ?.

IF has_aud THEN 
DO:
    cMsg =  "Load Failed!" + "~n" +
        "You cannot load Audit Policies or Data through this utility!" .  
    if user_env[6] NE "load-silent" then
        MESSAGE cMsg
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    else 
        undo, throw new AppError(cMsg).       
    RETURN.
END.

/* Add the suppress warnings assignment so that when a warning is issued the code can put out into
   the .e file.  Warnings are generally suppressed throughout the dictionary but in this case we
   need to trap */
lSuppressWarnings = SESSION:SUPPRESS-WARNINGS.   
SESSION:SUPPRESS-WARNINGS = NO.
PAUSE 0.
if user_env[6] NE "load-silent" then 
do:
    VIEW FRAME loaddata.
    PAUSE 5 BEFORE-HIDE.
    lImmediateDisplay = SESSION:IMMEDIATE-DISPLAY.
    SESSION:IMMEDIATE-DISPLAY = yes.
    run adecomm/_setcurs.p ("WAIT").
end.

RUN "prodict/_dctyear.p" (OUTPUT mdy,OUTPUT yy).
{ prodict/dictgate.i &action=query &dbtype=user_dbtype &dbrec=? &output=cload_size }


ASSIGN
    load_size   = INTEGER(ENTRY(4,cload_size))
    infinity    = TRUE /* use this to mark initial entry into loop */
    addfilename = (IF has_lchar THEN INDEX(user_longchar,",") > 0 ELSE INDEX(user_env[1],",") > 0)
                or
                user_env[2] = ""
                or
                user_env[2] = "."
                or
                user_env[2] matches "*/" 
                or 
                user_env[2] matches "*~~~\"
   
    error%      = INTEGER(user_env[4])
    dsname      = (IF user_dbtype = "PROGRESS"
                THEN PDBNAME(user_dbname)
                ELSE user_dbname
              )
    cerrors     = 0 - integer(NOT addfilename).

IF has_lchar THEN
    numCount = NUM-ENTRIES(user_longchar).
ELSE
    numCount = NUM-ENTRIES(user_env[1]).
    
if valid-object(dictMonitor) then
    numCount = 1.

/* it user_env[5] has the old format, remember this */
/* this is just in case someone is using an old version of load_d.p */
IF ENTRY(1, user_env[5]) = "y" OR ENTRY(1, user_env[5]) = "n" THEN
    ASSIGN old_dis_trig = YES.

if addfilename then do: 
    if not valid-object(dictMonitor) then
        checkDirectory(user_env[2]).    
end.

stoploop:
DO ON STOP UNDO, LEAVE:
    DO ix = 1 to numCount /*WHILE ENTRY(1,user_env[1]) <> ""*/ :

        ASSIGN 
            cTemp = IF has_lchar THEN ENTRY(ix,user_longchar) ELSE ENTRY(ix,user_env[1]).
       
        //if cTemp ne "all" then
        //    FIND DICTDB._CDC-Table-Policy WHERE DICTDB._CDC-Table-Policy._policy-name = cTemp.
        /*   
        IF INTEGER(DBVERSION("DICTDB")) > 8 THEN
            FIND DICTDB._File WHERE DICTDB._File._File-name = cTemp
                AND DICTDB._File._Db-recid = drec_db
                AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN").
        ELSE    
            FIND DICTDB._File WHERE DICTDB._File._File-name = cTemp
                AND DICTDB._File._Db-recid = drec_db.
        */
        IF infinity THEN .
        ELSE 
        do:
       &IF "{&WINDOW-SYSTEM}" begins "MS-WIN"
       &THEN
            /* Nothing to do */
            if user_env[6] NE "load-silent" then down 1 with Frame loaddata.
       &ELSE
            IF FRAME-LINE(loaddata) = FRAME-DOWN(loaddata) THEN
                UP FRAME-LINE(loaddata) - 1 WITH FRAME loaddata.
            ELSE DOWN 1 WITH FRAME loaddata.
       &ENDIF
        END.
 
        ASSIGN
            infinity        = FALSE
            recs            = 0
            irecs           = ?
            crecs           = STRING(irecs,{&MAX_RECS_FORMAT})
            d-was           = ?
            maptype         = ""
            cFileType       = ""
            cFileTypesubdir = "". 
 
        if index(user_env[2],"/") > 0 then
            cSlash = "/". 
               
        if addfilename then do:
            if valid-object(dictMonitor) then fil-d = user_env[2].
            else
                fil-d = (IF user_env[2] EQ "" OR user_env[2] EQ "." 
                    THEN ""
                    ELSE RIGHT-TRIM(user_env[2],cSlash) + cSlash + cTemp + ".cd").
        end. 
        else
            fil-d = user_env[2].  
            
        IF R-INDEX(fil-d,"/") > 0 THEN do:
            if not validDirectory(SUBSTRING(fil-d,1,R-INDEX(fil-d,"/"),"character")) then 
            do:
                cMsg = new_lang[15] + " Directory " + SUBSTRING(fil-d,1,R-INDEX(fil-d,"/") - 1,"character") + " does not exist.".
                if user_env[6] NE "dump-silent" then do:
                    message cMsg view-as alert-box error buttons ok.
                    return.
                end.
                else undo, throw new AppError(cMsg).
            end.
        end.        
        ELSE do:
            if not validDirectory(SUBSTRING(fil-d,1,R-INDEX(fil-d,"~\"),"character")) then 
            do:
                cMsg = new_lang[15] + " Directory " + SUBSTRING(fil-d,1,R-INDEX(fil-d,"~\") - 1,"character") + " does not exist.".
                if user_env[6] NE "dump-silent" then do:
                    message cMsg view-as alert-box error buttons ok.
                    return.
                end.
                else undo, throw new AppError(cMsg).
            end.        
        end. 
    
        cfileType = "shared".  
    
        cSearchFile = SEARCH(fil-d). 
        IF cSearchFile <> ? THEN fil-d = cSearchFile.
    
        //if valid-object(dictMonitor) then 
        //    dictMonitor:StartTable("",cFileType,cFileTypeSubdir,fil-d).          
         
        fil-e = SUBSTRING(fil-d,1,LENGTH(fil-d,"character") - 2,"character") + "e".

        if user_env[6] NE "load-silent" then 
        do:
            DISPLAY  fil-d new_lang[1] @ msg
                WITH FRAME loaddata. /* loading */
            COLOR DISPLAY MESSAGES  fil-d msg errs crecs
                WITH FRAME loaddata.
        end.
      
        IF cSearchFile  <> ? THEN 
        DO:    
            {prodict/dump/lodtrail.i
        &file    = "fil-d"
        &entries = "IF lvar[i] BEGINS ""records=""
                      THEN irecs     = INT64(SUBSTRING(lvar[i],9,-1,""character"")).
                    IF lvar[i] BEGINS ""ldbname=""    
                      THEN d-ldbname = SUBSTRING(lvar[i],9,-1,""character"").
                    IF lvar[i] BEGINS ""dateformat=""
                      THEN d-was     = SUBSTRING(lvar[i],12,-1,""character"").
                    IF lvar[i] BEGINS ""numformat=""
                      THEN numformat = SUBSTRING(lvar[i],11,-1,""character"").
                    IF lvar[i] BEGINS ""map=""       
                      THEN maptype   = SUBSTRING(lvar[i],5,-1,""character"").
                   "
        }
        END.
        ELSE 
        DO:
            ASSIGN 
                no-file = (IF addfilename 
                            THEN fil-d else cTemp + ".cd").
            if user_env[6] NE "load-silent" then 
                DISPLAY new_lang[12] @ msg WITH FRAME loaddata. /* !ERROR! */
            OUTPUT STREAM loaderr TO VALUE(fil-e). 
            PUT STREAM loaderr UNFORMATTED
                "The file " quoter(trim(no-file)) " cannot be found." SKIP.
            OUTPUT STREAM loaderr CLOSE.
         
            if valid-object(dictMonitor) then      
                dictMonitor:AddPolicyError(fil-d,cTemp,"The file cannot be found.").          
             
            ASSIGN 
                terrors = terrors + 1.
    
            next. /* skip that file */
        END.
        /**  the monitor reads the trail 
        if valid-object(dictMonitor) then      
            dictMonitor:SetTableExpectedNumRows(fil-d,irecs).          
           **/  
        /* if we can't fit the value in the format, display asterisks */
        crecs = STRING(irecs,{&MAX_RECS_FORMAT}) NO-ERROR.
        IF ERROR-STATUS:NUM-MESSAGES > 0 THEN
            crecs = "**********".

        if user_env[6] NE "load-silent" then DISPLAY crecs WITH FRAME loaddata.
   
        /* check if number of records is unknown or known */
        IF irecs = ? AND (error% > 0 AND error% < 100) THEN 
        DO:
            if user_env[6] NE "load-silent" then 
                DISPLAY new_lang[14] @ msg WITH FRAME loaddata. /* !Warning! */
            OUTPUT STREAM loaderr TO VALUE(fil-e) NO-ECHO APPEND. 
            PUT STREAM loaderr
                "Expected # of records is unknown."        SKIP
                "Error percentage will be interpreted"     SKIP   
                "as an absolute number of errors."         SKIP.
            OUTPUT STREAM loaderr CLOSE.
            ASSIGN 
                terrors = terrors + 1.
        END.
           
        IF cerror = ? THEN
        DO:  /* conversion needed but NOT possible */
         
            IF user_env[6] = "f" or user_env[6] = "load-silent" THEN 
                OUTPUT STREAM loaderr TO fil-e NO-ECHO.
        
            if user_env[6] NE "load-silent" then    
                COLOR DISPLAY NORMAL fil-d msg errs crecs
                    WITH FRAME loaddata.
       
            DISPLAY fil-d new_lang[12] @ msg crecs
                WITH FRAME loaddata. /* ERROR! */
        
            IF user_env[6] = "f" or user_env[6] = "load-silent" THEN 
                OUTPUT STREAM loaderr CLOSE.            
       
            /* error-count */
            assign 
                cerrors = cerrors + 1.
       
            /* skip this file */
            NEXT.

        END.     /* conversion needed but NOT possible */

        ELSE 
        DO:  /* conversion not needed OR needed and possible */
            IF cerror = "no-convert" then 
            do:
                IF maptype BEGINS "MAP:" THEN 
                DO:
                    IF lobdir = ""  THEN
                        INPUT STREAM loadread FROM VALUE(fil-d) NO-ECHO 
                            MAP VALUE(SUBSTRING(maptype,5,-1,"character"))
                            NO-CONVERT.
                    ELSE
                        INPUT STREAM loadread FROM VALUE(fil-d) LOB-DIR VALUE(lobdir) NO-ECHO 
                            MAP VALUE(SUBSTRING(maptype,5,-1,"character"))
                            NO-CONVERT.
                END.
                ELSE 
                DO: 
                    IF lobdir = "" THEN
                        INPUT STREAM loadread FROM VALUE(fil-d) NO-ECHO NO-MAP NO-CONVERT.
                    ELSE
                        INPUT STREAM loadread FROM VALUE(fil-d) LOB-DIR VALUE(lobdir)  
                            NO-ECHO NO-MAP NO-CONVERT.
                END.
            end.
            else 
            do:
                IF maptype BEGINS "MAP:" THEN 
                DO:
                    IF lobdir = "" THEN
                        INPUT STREAM loadread FROM VALUE(fil-d) NO-ECHO
                            MAP VALUE(SUBSTRING(maptype,5,-1,"character"))
                            CONVERT SOURCE codepage TARGET SESSION:CHARSET.
                    ELSE
                        INPUT STREAM loadread FROM VALUE(fil-d) LOB-DIR VALUE(lobdir) NO-ECHO
                            MAP VALUE(SUBSTRING(maptype,5,-1,"character"))
                            CONVERT SOURCE codepage TARGET SESSION:CHARSET.
                END.
                ELSE 
                DO: 
                    IF lobdir = "" THEN
                        INPUT STREAM loadread FROM VALUE(fil-d) NO-ECHO 
                            NO-MAP CONVERT SOURCE codepage TARGET SESSION:CHARSET.
                    ELSE
                        INPUT STREAM loadread FROM VALUE(fil-d) LOB-DIR VALUE(lobdir) NO-ECHO 
                            NO-MAP CONVERT SOURCE codepage TARGET SESSION:CHARSET.
                END.
            end.
        END.     /* conversion not needed OR needed and possible */

        /* check for numeric format (-E set or not) and error out if wrong */
        IF numformat <> "" THEN
        DO:
            IF LENGTH(numformat) = 1 THEN
            DO:
                IF index(string(1.5,"9.9"),numformat) = 0 THEN
                DO:  /* sesion-format and .d-format don't match */
                    RUN NumFormatErr IN THIS-PROCEDURE (INPUT "EparmErr").
                    ASSIGN 
                        terrors = terrors + 1.
                    NumProcRun = NO.
                    if valid-object(dictMonitor) then      
                        dictMonitor:AddPolicyError(fil-d,cTemp,"Numeric Format error").          
 
                    NEXT.   /* skip this file */
                END.    /* sesion-format and .d-format don't match */
            END. /* Above deals with the old format, below handles the new */ 
            ELSE
            DO:  /* Test for existence of 2 numeric values, or at least something *
             * translatable to numerics. */
             
                ASSIGN 
                    i = INTEGER(ENTRY(1,numformat)) + INTEGER(ENTRY(2,numformat))
             NO-ERROR.
                IF ERROR-STATUS:ERROR THEN
                DO: 
                    RUN NumFormatErr IN THIS-PROCEDURE (INPUT "FmtErr").
                    ASSIGN 
                        terrors = terrors + 1.
                    NumProcRun = NO.
             
                    if valid-object(dictMonitor) then      
                        dictMonitor:AddPolicyError(fil-d,cTemp,"Numeric Format error").          
             
                    NEXT.
                END.
                IF INTEGER(ENTRY(1,numformat)) + INTEGER(ENTRY(2,numformat)) < 3 THEN
                DO:  /* 0 is not allowed, and the characters must be different. */
                    RUN NumFormatErr IN THIS-PROCEDURE (INPUT "FmtErr").
                    ASSIGN 
                        terrors = terrors + 1.
                    NumProcRun = NO.
                    if valid-object(dictMonitor) then      
                        dictMonitor:AddPolicyError(fil-d,cTemp,"Numeric Format error").          
                    NEXT.
                END.
                IF CHR(INT(ENTRY(1,numformat)),SESSION:CPINTERNAL,codepage) <>
                    SESSION:NUMERIC-SEPARATOR THEN
                DO:
                    RUN NumFormatErr IN THIS-PROCEDURE (INPUT "SepErr").
                    ASSIGN 
                        terrors = terrors + 1.
                END.
                IF CHR(INT(ENTRY(2,numformat)),SESSION:CPINTERNAL,codepage) <>
                    SESSION:NUMERIC-DECIMAL-POINT THEN
                DO:
                    RUN NumFormatErr IN THIS-PROCEDURE (INPUT "DecErr").
                    ASSIGN 
                        terrors = terrors + 1.
                END.
                IF NumProcRun THEN
                DO:
                    NumProcRun = NO.
                    if valid-object(dictMonitor) then      
                        dictMonitor:AddPolicyError(fil-d,cTemp,"Numeric Format error").          
                    NEXT.
                END.
            END.
        END.
    
        ASSIGN
            cFile   = cTemp //DICTDB._File._File-name
            cImport = cFile
      &IF "{&WINDOW-SYSTEM}" begins "MS-WIN"
      &THEN
            .
      &ELSE
        xpos = FRAME-COL(loaddata) + 49
        ypos = FRAME-ROW(loaddata) + FRAME-LINE(loaddata) + 5.
      &ENDIF
    
        CREATE ALIAS "DICTDB2" FOR DATABASE VALUE(user_dbname) NO-ERROR.
        OUTPUT STREAM loaderr TO VALUE(fil-e) NO-ECHO.
     
        IF SEEK(loadread) = ? THEN 
        DO:
            PUT STREAM loaderr UNFORMATTED 
                new_lang[2] ' "' fil-d '" ' new_lang[3] ' "' cFile '".'.
            errs = 1.
        END.
        ELSE 
        DO:

            /* check if we can disable triggers. List now contains just the
              table numbers for tables that we should not disable triggers for.
            */
            ASSIGN 
                dis_trig = ENTRY(1, user_env[5]).

            /*IF NOT old_dis_trig THEN 
            DO:
                IF dis_trig NE "" AND dis_trig = STRING(_File._File-number) THEN
                    dis_trig = "n".
                ELSE
                    dis_trig = "y".
            END.*/
            
            /* call ABL API */
            loadCDCCollection().         
             
            IF RETURN-VALUE = "stopped" THEN 
                UNDO stoploop, LEAVE stoploop.
      
            /* move on to the next one in the list */
            IF old_dis_trig OR (dis_trig = "n") THEN
                user_env[5] = SUBSTRING(user_env[5]
                    ,LENGTH(ENTRY(1,user_env[5]),"character") + 2
                    ,-1
                    ,"character"
                    ).
  
            IF irecs = ? THEN 
            _irecs: 
            DO: /*----------- for reading damaged trailer */
                /* this code is used when a trailer might be present, but not in its
                   proper relative offset from the start of the file.  this can happen
                   if the file is edited or damaged, changing its length. */
                i = SEEK(loadread).
                if i <> ? then
                DO:
                    READKEY STREAM loadread PAUSE 0. 
                    IF LASTKEY <> ASC("P") THEN LEAVE _irecs.
                    READKEY STREAM loadread PAUSE 0. 
                    IF LASTKEY <> ASC("S") THEN LEAVE _irecs.
                    READKEY STREAM loadread PAUSE 0. 
                    IF LASTKEY <> ASC("C") THEN LEAVE _irecs.
                    SEEK STREAM loadread TO i. /* just to get eol right */
                    REPEAT WHILE irecs = ?:
                        IMPORT STREAM loadread cChar.
                        IF cChar BEGINS "records=" THEN irecs = INT64(SUBSTRING(cChar,9,-1,"character")).
                    END.
                END.
            END. /*---------------------------------- end of damaged trailer reader */
  
            INPUT STREAM loadread CLOSE.
        END.
    
        IF irecs <> ? AND irecs <> recs THEN 
        DO:
           // ASSIGN 
            //    errs = errs + 1.
            /* ERROR! Trailer indicated <n> records, but only <n> records loaded. */
            PUT STREAM loaderr UNFORMATTED 
                ">> " new_lang[6] " " irecs " " new_lang[7] " " recs " " 
                new_lang[8] SKIP.        
   
        END.
        IF d-was <> ? AND d-was <> mdy + STRING(- yy) THEN 
        DO:
            ASSIGN 
                errs = errs + 1.
            /* ERROR! -d <mdy> or -yy <n> settings of dump were <mdy>-<nnnn> */
            /* but current settings are <mdy>-<nnnn>. */
            PUT STREAM loaderr UNFORMATTED
                ">> " new_lang[9] " " d-was SKIP
                "** " new_lang[10] " " mdy STRING(- yy) ".  " new_lang[11] SKIP.
        
            if valid-object(dictMonitor) then  
                dictMonitor:AddPolicyError(fil-d,cTemp,
                    new_lang[9] 
                    + " " + d-was + "~n** "
                    + new_lang[10] + " " +  mdy + " " + STRING(- yy) + ".  "
                    + new_lang[11]).          
   
    
        END.
    
        OUTPUT STREAM loaderr CLOSE.
    
        //if valid-object(dictMonitor) then      
        //    dictMonitor:EndTable(fil-d,int64(recs)).          
      
        IF errs = 0 THEN OS-DELETE VALUE(fil-e).
       
        /* if value can't fit into format, display asterisks */
        crecs = STRING(irecs,{&MAX_RECS_FORMAT}) NO-ERROR.
        IF ERROR-STATUS:NUM-MESSAGES > 0 THEN
            crecs = "**********".

        if user_env[6] NE "load-silent" then 
        do:
            COLOR DISPLAY NORMAL fil-d msg errs crecs
                WITH FRAME loaddata.

            DISPLAY fil-d errs crecs WITH FRAME loaddata.
        end.  

        /* if the value is too big to be displayed, display asterisks */
        ASSIGN 
            msg = STRING(recs,"ZZZZZZZ9") NO-ERROR.
        IF ERROR-STATUS:ERROR OR ERROR-STATUS:NUM-MESSAGES > 0 THEN
            msg = "********".

        if user_env[6] NE "load-silent" then 
        do:
            DISPLAY msg WITH FRAME loaddata NO-ERROR.
        END.
    
        terrors = terrors + errs.

    END. /* do num count  */

    stopped = false.
   
END. /* end stop */

/* 20060905-013
   If a stop condition was raised, log the error messages to the .e file 
*/
IF STOPPED THEN 
DO:
    IF ERROR-STATUS:NUM-MESSAGES > 0 THEN
    DO i = 1 TO  ERROR-STATUS:NUM-MESSAGES:
        PUT STREAM loaderr UNFORMATTED
            ">> ERROR READING LINE #" recs + 1
            " " ERROR-STATUS:GET-MESSAGE(i) SKIP.
    END.
END.

&IF "{&WINDOW-SYSTEM}" begins "MS-WIN"
&THEN
   /* Nothing to Do */
&ELSE 

if user_env[6] NE "load-silent" then 
DO WHILE FRAME-LINE(loaddata) < FRAME-DOWN(loaddata):
    DOWN 1 WITH FRAME loaddata.
    CLEAR FRAME loaddata NO-PAUSE.
END.

&ENDIF

run adecomm/_setcurs.p ("").

/* for auditing - clear the application context, if we have set one */
IF newAppCtx THEN
    AUDIT-CONTROL:CLEAR-APPL-CONTEXT.
 
IF stopped THEN 
do:
    if user_env[6] NE "load-silent" then 
        MESSAGE new_lang[15]
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    else 
    do:
        undo, throw new AppError(new_lang[15]).   
    end.   
end.                
ELSE 
DO:
    if valid-object (dictMonitor) then
    do:
        IF cerrors > 0 THEN 
        do:
            dictMonitor:AnyError = true.
            dictMonitor:ErrorMessage = new_lang[13].
        end.
        ELSE IF terrors > 0 THEN
            do:     
                dictMonitor:AnyError = true.
                dictMonitor:ErrorMessage = "Errors/Warnings listed in .e file placed into $wrk_oemgmt/files.dir folder".
            end.
    end. 
    
    if user_env[6] NE "load-silent" then
    do:
      &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
        /* Don't use alert box in TTY because it obscures status report
           and you can't move it out of the away.
        */
        HIDE MESSAGE NO-PAUSE.
        
        IF      cerrors > 0 THEN MESSAGE new_lang[4] skip new_lang[13]. 
        ELSE IF terrors > 0 THEN MESSAGE new_lang[4] skip new_lang[5]. 
            ELSE                     MESSAGE new_lang[4]. 
        pause.
      &ELSE
        IF cerrors > 0 THEN 
            MESSAGE new_lang[4] skip new_lang[13] VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        ELSE IF terrors > 0 THEN  
                MESSAGE new_lang[4] skip new_lang[5]  VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
            ELSE 
                MESSAGE new_lang[4]                   VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      &ENDIF
    end.  
END.

RETURN.

catch e as Progress.Lang.Error :
    run handleError(e).
end catch.

finally:
    /* Make sure to set back the suppress warnings again */
    SESSION:SUPPRESS-WARNINGS = lSuppressWarnings.
    
    IF NOT isCpUndefined THEN
        ASSIGN user_longchar = "".
    
    if user_env[6] NE "load-silent" then 
    do:
        HIDE MESSAGE NO-PAUSE.
        HIDE FRAME loaddata NO-PAUSE.
        SESSION:IMMEDIATE-DISPLAY = lImmediateDisplay.
    end.
end finally.

/*-------------------------- Internal Procedures -------------------------------------------------------*/
procedure handleError:
    define input parameter pError as Progress.Lang.Error no-undo.
    define variable i    as integer   no-undo.
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
    else 
    do:
        undo, throw new AppError(cmsg).
    end.
end.

/*----- Output the error messages for invalid numeric formats -----*/
PROCEDURE NumFormatErr:

    /* Logical Variable NumProcRun is external in order to scope to .p  */
    DEF INPUT PARAM ErrType AS CHAR NO-UNDO.

    OUTPUT STREAM loaderr TO VALUE(fil-e) NO-ECHO APPEND.

    IF NOT NumProcRun THEN
    DO:
        NumProcRun = NOT NumProcRun.
        if user_env[6] NE "load-silent" then 
            DISPLAY new_lang[12] @ msg WITH FRAME loaddata. /* !ERROR! */           
        PUT STREAM loaderr UNFORMATTED
            "The numeric formats of this {&PRO_DISPLAY_NAME}-session"   SKIP
            "and the .cd-file don't match!"                   SKIP   
            "Please exit {&PRO_DISPLAY_NAME} and start a new session"   SKIP.
    END.

    /* What type of error do we want to output this time through? */
    /* One or both of the following could be wrong.               */
    CASE ErrType:
        WHEN "EparmErr" THEN
            DO:
                PUT STREAM loaderr UNFORMATTED
                    (IF numformat = "." THEN "without " ELSE "with " ) + 
                    "the -E startup parameter, or set the"                 SKIP   
                    "-numsep parameter to " +
                    (IF numformat = "." THEN "44 " ELSE "46 ") + "and -numdec to " +
                    (IF numformat = "." THEN "46." ELSE "44.") SKIP.    
            END.
        WHEN "SepErr" THEN
            DO:
                PUT STREAM loaderr UNFORMATTED
                    "with the -numsep startup parameter set to " 
                    ASC(CHR(INT(ENTRY(1,numformat)),SESSION:CPINTERNAL,codepage)) SKIP.
            END.
        WHEN "DecErr" THEN
            DO:
                PUT STREAM loaderr UNFORMATTED
                    "with the -numdec startup parameter set to " 
                    ASC(CHR(INT(ENTRY(2,numformat)),SESSION:CPINTERNAL,codepage)) SKIP.
            END.
        WHEN "FmtErr" THEN
            DO:
                PUT STREAM loaderr UNFORMATTED
                    "with the -numdec and -numsep parameters set to valid values."  SKIP
                    "The current value of " + numformat + " is not valid."
                    SKIP.
            END.
        WHEN "BlnkErr" THEN
            DO:
                PUT STREAM loaderr UNFORMATTED
                    "with valid values in the ~"numformat=~" section of the .d trailer."
                    SKIP.
            END.
    END CASE.
     
    OUTPUT STREAM loaderr CLOSE.  

END PROCEDURE.

