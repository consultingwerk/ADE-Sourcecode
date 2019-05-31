/*
USING System.TEXT.RegularExpressions.*.
*/
USING PROGRESS.Lang.FlagsEnum.
USING OpenEdge.DataAdmin.Util.ExprFlags.

/* OE acct names are tested by $RDLC/utchkuid() function.
   The function accepts anything equal to or above special character <blank> 0x32 that does
   NOT include the list of illegal characters, " #*,!@ ", i.e.,
   pound(#), asterisk(*), comma(,), Bang(!), and ampersand(@).

   NOTE: We need a "rule" about NOT using underscore(_) at the beginning of a acct name
         to avoid conflicts with internal, built-in, system roles.
*/

ROUTINE-LEVEL ON ERROR UNDO, THROW.
FUNCTION RvkChk     RETURNS INTEGER (INPUT inPerm AS CHARACTER) FORWARD.
FUNCTION FullUserId RETURNS CHAR    (id AS CHAR, name AS CHAR)  FORWARD.
FUNCTION ConsolidateWildcards RETURNS CHARACTER (INPUT inExpr AS CHARACTER) FORWARD.
FUNCTION GetDomainType RETURNS CHARACTER (INPUT inDomain AS CHARACTER, INPUT inUser AS CHARACTER) FORWARD.

DEFINE VARIABLE inSubs AS CHARACTER INIT "Cansubs" NO-UNDO.
DEFINE VARIABLE inAccts AS CHARACTER INIT "" NO-UNDO.

DEFINE VARIABLE permNames AS CHARACTER EXTENT 6 NO-UNDO
    INITIAL ["Can-Read", "Can-Write", "Can-Create", "Can-Delete", "Can-Dump", "Can-Load"].

DEFINE STREAM strLog.
DEFINE STREAM strBslExtr.
DEFINE STREAM strBslProc.
DEFINE STREAM strCsvProc.
DEFINE STREAM strBslExec.
/*
DEFINE STREAM strCsvExec.
*/
DEFINE STREAM strSqlGrant.

DEFINE VARIABLE outLog AS CHARACTER INIT "Can_<dbname>_Perm.log" NO-UNDO.
DEFINE VARIABLE fileBslExtr AS CHARACTER INIT "Can_<dbname>_Extract.bsl" NO-UNDO.
DEFINE VARIABLE fileBslProc AS CHARACTER INIT "Can_<dbname>_Process.bsl" NO-UNDO.
DEFINE VARIABLE fileCsvProc AS CHARACTER INIT "Can_<dbname>_Process.csv" NO-UNDO.
DEFINE VARIABLE fileBslExec AS CHARACTER INIT "Can_<dbname>_Execute.bsl" NO-UNDO.
/*
DEFINE VARIABLE fileCsvExec AS CHARACTER INIT "CanExecute.csv" NO-UNDO.
*/
DEFINE VARIABLE fileSqlGrant AS CHARACTER INIT "Can_<dbname>_Grants.sql" NO-UNDO.
DEFINE VARIABLE fileOutClean  AS CHARACTER INIT "Can_<dbname>_Clean.out" NO-UNDO.

DEFINE VARIABLE makeBslExtr AS LOGICAL NO-UNDO.
DEFINE VARIABLE makeBslProc AS LOGICAL INIT NO NO-UNDO.
DEFINE VARIABLE makeCsvProc AS LOGICAL INIT NO NO-UNDO.
DEFINE VARIABLE makeBslExec AS LOGICAL INIT NO NO-UNDO.
/*
DEFINE VARIABLE makeCsvExec AS LOGICAL INIT NO NO-UNDO.
DEFINE VARIABLE makeCsvExec AS LOGICAL INIT NO NO-UNDO.
*/

DEFINE VARIABLE openBslExtr AS LOGICAL NO-UNDO.
DEFINE VARIABLE openBslProc AS LOGICAL INIT NO NO-UNDO.
DEFINE VARIABLE openCsvProc AS LOGICAL INIT NO NO-UNDO.
DEFINE VARIABLE openBslExec AS LOGICAL INIT NO NO-UNDO.
/*
DEFINE VARIABLE openCsvExec AS LOGICAL INIT NO NO-UNDO.
*/

DEFINE VARIABLE fileBslExtrPath AS CHARACTER NO-UNDO.
DEFINE VARIABLE fileCsvProcPath AS CHARACTER NO-UNDO.

DEFINE VARIABLE cnt AS INTEGER NO-UNDO.
DEFINE VARIABLE account AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDir AS CHARACTER NO-UNDO.
DEFINE VARIABLE chgSize AS INT64 INIT 0 NO-UNDO.
DEFINE VARIABLE gtg AS LOGICAL NO-UNDO.
DEFINE VARIABLE redit AS INT64 INIT 0 NO-UNDO.
DEFINE VARIABLE ierr AS INTEGER NO-UNDO.
DEFINE VARIABLE ierrSuff AS CHARACTER NO-UNDO.
DEFINE VARIABLE fldcnt AS INTEGER NO-UNDO.
DEFINE VARIABLE cFilNum AS INTEGER NO-UNDO.
DEFINE VARIABLE errMsg AS CHARACTER NO-UNDO.

DEFINE VARIABLE chkExtr AS CHARACTER EXTENT 18 NO-UNDO.

/* Eval Counters */
DEFINE VARIABLE fileCnt AS INT64.                   /* Number of user files */
DEFINE VARIABLE fieldCnt AS INT64.                  /* Number of fields in user files */
DEFINE VARIABLE subPermTCnt AS INT INIT 0.
DEFINE VARIABLE dfltCnt AS INT INIT 0.    /* Local Default (or Revoke-blank) PUBLIC Counter */
DEFINE VARIABLE fileDfltCnt AS INT64 INIT 0.        /* Files with Dflt Expressions */
DEFINE VARIABLE fieldDfltCnt AS INT64 INIT 0.       /* Fields with Dflt Expressions */
DEFINE VARIABLE fileRdfltCnt AS INT64 INIT 0.       /* Files with revoke-blank Dflt Expressions */
DEFINE VARIABLE fieldRdfltCnt AS INT64 INIT 0.      /* Fields with revoke-blank Dflt Expressions */
DEFINE VARIABLE fileMdfltCnt AS INT64 INIT 0.       /* Files with mixed dflt Expressions */
DEFINE VARIABLE fieldMdfltCnt AS INT64 INIT 0.      /* Fields with mixed dflt Expressions */
DEFINE VARIABLE filePdfltCnt AS INT64 INIT 0.       /* Files with partial dflt Expressions */
DEFINE VARIABLE fieldPdfltCnt AS INT64 INIT 0.      /* Fields with partial dflt Expressions */
DEFINE VARIABLE rvkExprCnt AS INT64 INIT 0.         /* Ignored Revoke Expressions */
DEFINE VARIABLE fileRvkExprCnt AS INT64 INIT 0.     /* Ignored File Revoke Expressions */
DEFINE VARIABLE fieldRvkCnt AS INT64 INIT 0.        /* Ignored Field Revoke Expressions */
DEFINE VARIABLE dumpDfltCnt AS INT64 INIT 0.        /* DUMP Action Dflt Expressions */
DEFINE VARIABLE dumpExprCnt AS INT64 INIT 0.        /* DUMP Action non-Dflt Expressions */
DEFINE VARIABLE loadDfltCnt AS INT64 INIT 0.        /* LOAD Action Dflt Expressions */
DEFINE VARIABLE loadExprCnt AS INT64 INIT 0.        /* LOAD Action non-Dflt Expressions */
DEFINE VARIABLE roleExprCnt AS INT64 INIT 0.        /* ROLE Expression candidate */
DEFINE VARIABLE fileRoleExprCnt AS INT64 INIT 0.    /* file ROLE Expression candidate */
DEFINE VARIABLE listExprCnt AS INT64 INIT 0.        /* LIST Expression candidate */
DEFINE VARIABLE fileListExprCnt AS INT64 INIT 0.    /* file LIST Expression candidate */
DEFINE VARIABLE subPermsCnt AS INT64 INIT 0.        /* subExpression count */
DEFINE VARIABLE subPermsThreshCnt AS INT64 INIT 0.  /* Accumulation of sub-expressoins */
DEFINE VARIABLE blnkPermCnt AS INT64 INIT 0.        /* Blank User Permissions */
DEFINE VARIABLE UnProcCnt AS INT64 INIT 0.          /* UnProcessed Permissions */
DEFINE VARIABLE EditExprCnt AS INT64 INIT 0.        /* Number of Edited Expressions */
DEFINE VARIABLE EditSubExprCnt AS INT64 INIT 0.     /* Number of Edited Sub-Expressions */


/* DEFINE VARIABLE regexp AS CLASS Regex NO-UNDO. */
/* DEFINE VARIABLE match AS Match NO-UNDO. */

/* Tailoring File Variables */
DEFINE VARIABLE subPermThresh AS INT INIT 10 NO-UNDO.           /* Threshold for flagging number of sub-permissions */
DEFINE VARIABLE NDFsThresh AS INT INIT 2 NO-UNDO.               /* Threshold for flagging number of fields with non-dflt expr's */

DEFINE TEMP-TABLE ttPerms
    FIELD Db-Guid AS CHARACTER CASE-SENSITIVE
    FIELD FilNum AS INTEGER
    FIELD FldNum AS INTEGER
    FIELD StateFlag AS INTEGER
    FIELD Can-Code AS INTEGER
    FIELD Cmd-PropSeq AS INTEGER
    FIELD Cmd-CanSeq AS INTEGER
    FIELD Can-SubSeq AS INTEGER
    FIELD FilNam AS CHARACTER
    FIELD FldNam AS CHARACTER
    FIELD Can-Expr AS CHARACTER
    FIELD Can-SubExpr AS CHARACTER
    FIELD Can-Repl AS CHARACTER
    FIELD Can-SubRepl AS CHARACTER
    FIELD ExprAttrs AS INT64
    FIELD Cmd-Can AS CHARACTER
    FIELD Can-Prop AS CHARACTER
    FIELD Cmd-Prop AS CHARACTER
    FIELD Redit AS LOGICAL
    INDEX ICan IS PRIMARY UNIQUE
        DB-Guid FilNum FldNum StateFlag Can-Code
        Cmd-PropSeq Cmd-CanSeq Can-SubSeq
    INDEX IResSubPerm FilNum FldNum Can-Code Can-SubSeq.

DEFINE TEMP-TABLE ttBslExtr LIKE ttPerms.
DEFINE TEMP-TABLE ttBslProc LIKE ttPerms.
DEFINE TEMP-TABLE ttCsvProc LIKE ttPerms.
DEFINE TEMP-TABLE ttBslExec LIKE ttPerms.
/*
DEFINE TEMP-TABLE ttCsvExec LIKE ttPerms.
*/

DEFINE TEMP-TABLE fld LIKE _Field.

DEFINE TEMP-TABLE ttSubs
    FIELD subsId AS INTEGER
    FIELD match AS CHARACTER
    FIELD repl AS CHARACTER
    FIELD subsType AS CHARACTER
    INDEX iSubsId IS PRIMARY UNIQUE subsId.

DEFINE TEMP-TABLE ttAcct
    FIELD account AS CHARACTER
    FIELD userName AS CHARACTER
    FIELD domainName AS CHARACTER
    FIELD domainType AS CHARACTER
    FIELD fromUserTable AS LOGICAL
    INDEX iAcct IS PRIMARY UNIQUE account.
DEFINE TEMP-TABLE ttAcctM LIKE ttAcct.

DEFINE VAR parms AS CHAR.

&SCOPED-DEFINE DO_NONE    -1
&SCOPED-DEFINE DO_EXTRACT 0
&SCOPED-DEFINE DO_PROCESS 1
&SCOPED-DEFINE DO_EXECUTE 2
&SCOPED-DEFINE DO_CLEAN   3
DEFINE VAR iState AS INTEGER NO-UNDO INIT {&DO_EXTRACT}.

DEFINE VARIABLE operations AS CHARACTER EXTENT 4 INITIAL ["Extract", "Process", "Execute", "Clean"]  NO-UNDO.
DEFINE VAR eval AS INTEGER NO-UNDO INIT 0.  /* 0=No-Eval, else "No-Process": 1=Eval, 2=Verbose */
DEFINE VAR owrt AS LOGICAL INIT NO NO-UNDO.

DEFINE VAR cExprFlag AS ExprFlags.
DEFINE VARIABLE chgMask AS ExprFlags. /* Ranges from REPLSWP to OREPLCSV */

DEFINE VARIABLE cExprBufList AS CHARACTER.

DEFINE VARIABLE sCode AS INTEGER.
DEFINE VARIABLE sUser AS CHARACTER INIT "".

DEFINE VAR grtRvk AS CHARACTER INIT "GRANT" NO-UNDO.
/***
DEBUGGER:INITIATE().
DEBUGGER:SET-BREAK().
***/

/* Replace <dbname> with the name of the connected database */
outLog = REPLACE(outLog, "<dbname>", DBNAME).
fileBslExtr = REPLACE(fileBslExtr, "<dbname>", DBNAME).
fileBslProc = REPLACE(fileBslProc, "<dbname>", DBNAME).
fileCsvProc = REPLACE(fileCsvProc, "<dbname>", DBNAME).
fileBslExec = REPLACE(fileBslExec, "<dbname>", DBNAME).
fileSqlGrant = REPLACE(fileSqlGrant, "<dbname>", DBNAME).
fileOutClean = REPLACE(fileOutClean, "<dbname>", DBNAME).

/* Log file */
OUTPUT STREAM strLog TO VALUE(outLog) APPEND.
RUN WriteLogMsg(FILL("-", 78)).
RUN WriteLogMsg("Starting ABL/SQL Permissions Migration Tool").

parms = SESSION:PARAMETER.

IF NUM-ENTRIES(parms) = 0 THEN
    iState = {&DO_PROCESS}.
ELSE DO:
    iState = {&DO_NONE}.

    REPEAT cnt = 1 TO NUM-ENTRIES(parms):
        IF ENTRY(cnt, parms) = "extract" THEN iState = {&DO_EXTRACT}.
        IF ENTRY(cnt, parms) = "process" THEN iState = {&DO_PROCESS}.

        /* These are not implemented or have been removed
        
        IF ENTRY(cnt, parms) = "eval"    THEN eval = 1.
        IF ENTRY(cnt, parms) = "verbose" THEN eval = 2.
        
        IF ENTRY(cnt, parms) = "execute" THEN iState = {&DO_EXECUTE}.
        IF ENTRY(cnt, parms) = "clean"   THEN iState = {&DO_CLEAN}.
        
        IF ENTRY(cnt, parms) = "overwrite" THEN owrt = YES.

        IF SUBSTRING(ENTRY(cnt, parms), 1, 8) = "accounts" THEN DO:
            inAccts = ENTRY(cnt, parms).
            inAccts = ENTRY(2, inAccts, "=").
        END.
        */
    END.
    
    IF iState = {&DO_NONE} THEN
    DO:
        errMsg = "Invalid operation requested: " + SESSION:PARAMETER.
        RUN WriteLogMsg(errMsg).
        UNDO, THROW NEW Progress.Lang.AppError(errMsg).
    END.
END.

RUN WriteLogMsg("Operation: " + operations[iState + 1] + ", Database: " + DBNAME).

/* Process Action Mask - Range is REPLSWP to OREPLCSV */
chgMask = ExprFlags:getEnum(INT64(0x1FE)).

/* Check whether the extract baseline and/or the process csv already exist.
   If neither exists, create them.
   If both exist and we're doing only an extract, there's nothing to do.
   If both exists and we're doing a process, skip the extract.
   If one exists but not both, quit and do nothing.
*/
FILE-INFO:FILE-NAME = fileBslExtr. /* Assume current-working-directory path */
fileBslExtrPath = FILE-INFO:FULL-PATHNAME.
FILE-INFO:FILE-NAME = fileCsvProc. /* Assume current-working-directory path */
fileCsvProcPath = FILE-INFO:FULL-PATHNAME.

IF iState = {&DO_EXTRACT} AND 
   (fileBslExtrPath <> ? AND fileCsvProcPath <> ?) THEN
DO:
    errMsg = "A previous extract was performed for " + DBNAME + ". There is nothing to do.".
    RUN WriteLogMsg(errMsg).
    UNDO, THROW NEW Progress.Lang.AppError(errMsg).
END.

IF (fileBslExtrPath = ? AND fileCsvProcPath <> ?) OR
   (fileCsvProcPath = ? AND fileBslExtrPath <> ?) THEN
DO:
    IF fileBslExtrPath = ? THEN
    DO:
        errMsg = "ERROR: A previous extract was performed for " + DBNAME + " but baseline file (.bsl) is missing".
    END.
    ELSE
    DO:
        errMsg = "ERROR: A previous extract was performed for " + DBNAME + " but process input file (.csv) is missing".
    END.
    
    RUN WriteLogMsg(errMsg).
    UNDO, THROW NEW Progress.Lang.AppError(errMsg).
END.

IF (fileBslExtrPath EQ ? AND iState >= {&DO_EXTRACT}) THEN DO:
    makeBslExtr = yes.
    openBslExtr = yes.
    /*
    IF iState >= {&DO_PROCESS} THEN
    DO:
        openBslProc = yes.
    END.
    */
    RUN WriteLogMsg("Creating Extract baseline " + QUOTER(fileBslExtr)).
END.
IF fileBslExtrPath NE ? THEN DO:
    makeBslExtr = no.

    /* Read the existing baseline if we're doing a process or other non-extract operation. */
    IF iState >= {&DO_PROCESS} THEN
    DO:
        redit = -1.
        INPUT FROM VALUE(fileBslExtrPath). /* Last line should be a dot (.) */
        REPEAT:
            IMPORT DELIMITER ',' chkExtr.
            IF redit < 0 THEN DO:
                redit = 0.
                NEXT.
            END.
            redit = redit + 1.
            CREATE ttBslExtr.
            ASSIGN ttBslExtr.DB-Guid = chkExtr[1]
                   ttBslExtr.FilNum = INTEGER(chkExtr[2])
                   ttBslExtr.FldNum = INTEGER(chkExtr[3])
                   ttBslExtr.StateFlag = INTEGER(chkExtr[4])
                   ttBslExtr.Can-Code = INTEGER(chkExtr[5])
                   ttBslExtr.Cmd-PropSeq = INTEGER(chkExtr[6])
                   ttBslExtr.Cmd-CanSeq = INTEGER(chkExtr[7])
                   ttBslExtr.Can-SubSeq = INTEGER(chkExtr[8])
                   ttBslExtr.FilNam = chkExtr[9]
                   ttBslExtr.FldNam = chkExtr[10]
                   ttBslExtr.Can-Expr = chkExtr[11]
                   ttBslExtr.Can-SubExpr = chkExtr[12]
                   ttBslExtr.Can-Repl = ?
                   ttBslExtr.Can-SubRepl = ?
                   ttBslExtr.ExprAttrs = INT64(chkExtr[15])
                   ttBslExtr.Cmd-Can = ?
                   ttBslExtr.Can-Prop = ?
                   ttBslExtr.Cmd-Prop = ?
                   ttBslExtr.Redit = NO.
        END.
        INPUT CLOSE.

/***********  --- should add this for case where file has nothing but header...
        IF redit <= 0 THEN DO:
            INPUT STREAM strBslExtr CLOSE.
            OS-DELETE VALUE(fileBslExtr)
            OUTPUT STREAM strBslExtr TO VALUE(fileBslExtr).
            makeBslExtr = yes.
        END.
        ELSE
************/
        RUN WriteLogMsg(STRING(redit) +
            " records read from Extract baseline, " + QUOTER(fileBslExtr)).
    END.
END.

IF iState = {&DO_EXTRACT} AND owrt THEN
    openBslExtr = yes.
IF openBslExtr THEN
    OUTPUT STREAM strBslExtr TO VALUE(fileBslExtr). /* Open BSL Extract Stream */

IF (fileCsvProcPath EQ ? AND iState >= {&DO_EXTRACT}) THEN DO:
    makeCsvProc = yes.
    openCsvProc = yes.
    RUN WriteLogMsg("Creating Process CSV " + QUOTER(fileCsvProc)).
END.
IF fileCsvProcPath NE ? THEN DO:
    makeCsvProc = no.
    IF iState >= {&DO_PROCESS} THEN DO:
        /* openCsvProc = yes. */
        redit = -1.
        INPUT FROM VALUE(fileCsvProcPath). /* Last line should be a dot (.) */
        REPEAT:
            IMPORT DELIMITER ',' chkExtr.
            IF redit < 0 THEN DO:
                redit = 0.
                NEXT.
            END.
            redit = redit + 1.
            CREATE ttCsvProc.
            ASSIGN ttCsvProc.DB-Guid = chkExtr[1]
                   ttCsvProc.FilNum = INTEGER(chkExtr[2])
                   ttCsvProc.FldNum = INTEGER(chkExtr[3])
                   ttCsvProc.StateFlag = INTEGER(chkExtr[4])
                   ttCsvProc.Can-Code = INTEGER(chkExtr[5])
                   ttCsvProc.Cmd-PropSeq = INTEGER(chkExtr[6])
                   ttCsvProc.Cmd-CanSeq = INTEGER(chkExtr[7])
                   ttCsvProc.Can-SubSeq = INTEGER(chkExtr[8])
                   ttCsvProc.FilNam = chkExtr[9]
                   ttCsvProc.FldNam = chkExtr[10]
                   ttCsvProc.Can-Expr = chkExtr[11]
                   ttCsvProc.Can-SubExpr = chkExtr[12]
                   ttCsvProc.Can-Repl = chkExtr[13]
                   ttCsvProc.Can-SubRepl = chkExtr[14]
                   ttCsvProc.ExprAttrs = INT64(chkExtr[15])
                   ttCsvProc.Cmd-Can = chkExtr[16]
                   ttCsvProc.Can-Prop = chkExtr[17]
                   ttCsvProc.Cmd-Prop = chkExtr[18]
                   ttCsvProc.Redit = NO.
        END.
        INPUT CLOSE.
        RUN WriteLogMsg(STRING(redit) +
            " records read from Process CSV file " + QUOTER(fileCsvProc)).
    END.
END.

IF openCsvProc THEN
    OUTPUT STREAM strCsvProc TO VALUE(fileCsvProc). /* Make or open CSV Process Stream */

IF iState > {&DO_EXTRACT} THEN
DO:
    RUN WriteLogMsg("Creating SQL GRANTs file " + QUOTER(fileSqlGrant)).
    OUTPUT STREAM strSqlGrant TO VALUE(fileSqlGrant). /* Make or open SQL Output Stream */
END.

/* Input change files */
IF iState >= {&DO_PROCESS} THEN
DO:
    IF inAccts = "" THEN DO: /* If no accounts paramater was passed */
        inAccts = "Accounts".
    END.

    RUN ReadUserTable.
    RUN ReadAccountsFile(inAccts).
    RUN ReadSubstitutionFile.
    
    /*
    FOR EACH ttAcct:
        DISPLAY ttAcct.
    END.
    */
    
END.

Run ExtrFilePerms.

CATCH err AS PROGRESS.Lang.Error:
    REPEAT ierr = 1 TO err:NumMessages:
        CASE ierr: /* Error number */
            WHEN 1 THEN ASSIGN ierrSuff = "st".
            WHEN 2 THEN ASSIGN ierrSuff = "nd".
            WHEN 3 THEN ASSIGN ierrSuff = "rd".
            OTHERWISE ASSIGN ierrSuff = "th".
        END CASE.
        RUN WriteLogMsg(STRING(ierr) + ierrSuff + " caught error, " + "Number: " + STRING(err:GetMessageNum(ierr))).
        RUN WriteLogMsg("Message Info: " + STRING(err:GetMessage(ierr))).
    END.
    DELETE OBJECT err.
    //RUN WriteLogMsg("Errors caused termination").
END CATCH.

FINALLY:
    IF iState >= {&DO_EXTRACT} THEN DO:
        OUTPUT STREAM strBslExtr CLOSE.
        /* OUTPUT STREAM strBslProc CLOSE. */
    END.
    IF iState >= {&DO_PROCESS} THEN DO:
        /* OUTPUT STREAM strCsvProc CLOSE. */
        /* OUTPUT STREAM strBslExec CLOSE. */
        OUTPUT STREAM strSqlGrant CLOSE.
    END.
    /****
    IF iState >= {&DO_EXECUTE} THEN
        OUTPUT STREAM strCsvExec CLOSE.
    ****/

    RUN WriteLogMsg("Exiting ABL/SQL Permissions Migration Tool").
    OUTPUT STREAM strLog CLOSE.

    QUIT.
END FINALLY.


/******************** Procedures **********************/


PROCEDURE ExtrFilePerms:

    /* Local Counters */
    DEFINE VARIABLE pCnt AS INT INIT 0.                 /* Loca CAN sub-expression counter */
    DEFINE VARIABLE canCnt AS INT INIT 0.               /* Local CAN permission CASE Counter */
    DEFINE VARIABLE subPermCnt AS INT INIT 0.

    /* Local Values */
    DEFINE VARIABLE perm AS CHAR.
    DEFINE VARIABLE perms AS CHAR.
    DEFINE VARIABLE canAct AS CHAR.

    DEFINE VARIABLE rCode AS INT.
    DEFINE BUFFER ttPerms0 FOR ttPerms.

    /* Verbose Counters */
    DEFINE VARIABLE mayRoleCnt AS INT64 INIT 0.         /* Potential Candidate */
    DEFINE VARIABLE canRoleCnt AS INT64 INIT 0.         /* Strong Candidate */
    DEFINE VARIABLE canViolCnt AS INT64 INIT 0.          /* Conversion errors */
    DEFINE VARIABLE hdgs AS CHAR.

    IF makeBslExtr OR makeBslProc OR makeBslExec THEN DO:
        ASSIGN hdgs = "DB-Guid, Filnum, FldNum, StateFlag, Can-Code, Can-PropSeq, Cmd-CanSeq, Can-SubSeq, ".
        ASSIGN hdgs = hdgs + "FilNam, FldNam, Can-Expr, Can-SubExpr, Can-Repl, Can-SubRepl, ExprAttrs, Cmd-Can, Can-Prop, Cmd-Prop".
    END.
    IF iState >= {&DO_EXTRACT} THEN DO:
        IF makeBslExtr THEN
            PUT STREAM strBslExtr UNFORMATTED LEFT-TRIM(hdgs, ",") SKIP.
        IF makeBslProc THEN
            PUT STREAM strBslProc UNFORMATTED LEFT-TRIM(hdgs, ",") SKIP.
    END.
    IF iState >= {&DO_EXTRACT} AND makeCsvProc THEN
            PUT STREAM strCsvProc UNFORMATTED LEFT-TRIM(hdgs, ",") SKIP.

    IF iState >= {&DO_PROCESS} AND makeBslExec THEN
            PUT STREAM strBslExec UNFORMATTED LEFT-TRIM(hdgs, ",") SKIP.
/*
    IF iState >= {&DO_EXECUTE} AND makeCsvExec THEN
            PUT STREAM strCsvExec UNFORMATTED LEFT-TRIM(hdgs, ",") SKIP.
*/

    FOR EACH _File WHERE _File._tbl-type = "T" AND _File._Owner = "PUB"
        SHARE-LOCK BY _file._file-name:

        IF fileCnt = 0 THEN DO:  /* Make sure permissions are scoped to the DB */
            FIND _DB where _File._DB-Recid = _Db-Recid NO-ERROR.
            IF NOT AVAILABLE(_DB) THEN DO:
                RUN WriteLogMsg("PROGRAM FAILED: " + "Database record not accessible").
                RETURN.
            END.
        END.
        FileCnt = FileCnt + 1.

        IF NOT makeCsvProc THEN DO:   /* Get existing Process CSV */
            FOR EACH ttCsvProc:
                IF /* UPPER(ttCsvProc.DB-Guid) = UPPER(_DB._Db-Guid) AND */
                   ttCsvProc.FilNum = _File._File-number AND
                   ttCsvProc.FldNum = 0 THEN DO:
                    CREATE ttPerms.
                    BUFFER-COPY ttCsvProc TO ttPerms.
                END.
            END.
        END.
        /*
        ELSE IF NOT makeBslProc THEN DO:   /* Get existing Process Baseline */
            FOR EACH ttBslProc:
                IF UPPER(ttBslProc.DB-Guid) = UPPER(_DB._Db-Guid) AND
                   ttBslProc.FilNum = _File._File-number AND
                   ttBslProc.FldNum = 0 THEN DO:
                    CREATE ttPerms.
                    BUFFER-COPY ttBslProc TO ttPerms.
                END.
            END.
        END.
        */
        ELSE DO:
            canCnt = 0.
            DO WHILE canCnt < 6:
                canCnt = canCnt + 1.
                CASE canCnt: /* Can Permission Type */
                    WHEN 1 THEN ASSIGN perms = _File._Can-Read.
                    WHEN 2 THEN ASSIGN perms = _File._Can-Write.
                    WHEN 3 THEN ASSIGN perms = _File._Can-Create.
                    WHEN 4 THEN ASSIGN perms = _File._Can-Delete.
                    WHEN 5 THEN ASSIGN perms = _File._Can-Dump.
                    WHEN 6 THEN ASSIGN perms = _File._Can-Load.
                END CASE.

                subPermCnt = NUM-ENTRIES(perms).
                DO pCnt = 1 TO subPermCnt:
                    perm = ENTRY(pCnt, perms).
                    CREATE ttPerms.
                    ASSIGN ttPerms.DB-Guid  = _Db._Db-Guid
                           ttPerms.FilNum  = _File._File-number
                           ttPerms.FilNam  = _File._File-name
                           ttPerms.FldNam   = ?                   /* File record, no field */
                           ttPerms.FldNum   = 0                   /* File record uses zero key on field */
                           ttPerms.Can-Code = CanCnt
                           ttPerms.Can-Expr = perms
                           ttPerms.Can-SubExpr = perm
                           ttPerms.Can-Repl = ?
                           ttPerms.Can-SubRepl = ?
                           ttPerms.Can-SubSeq = pCnt
                           ttPerms.ExprAttrs = INT64(ExprFlags:NO_FLAGS)
                           ttPerms.Cmd-Can = ?
                           ttPerms.Cmd-CanSeq = 0
                           ttPerms.Can-Prop = ?
                           ttPerms.Cmd-PropSeq = 0
                           ttPerms.Cmd-Prop = ?
                           ttPerms.StateFlag = 0. /* Extracted */

                    /* Create the 0th "expression" record */
                    IF pCnt = 1 THEN DO:
                        CREATE ttPerms0.
                        BUFFER-COPY ttPerms EXCEPT Can-SubSeq Can-SubExpr TO ttPerms0
                            ASSIGN ttPerms0.Can-SubSeq = 0
                                   ttPerms0.Can-SubExpr = ?.
                    END.

                    IF makeBslExtr OR (iState = {&DO_EXTRACT} AND owrt) THEN DO:
                        EXPORT STREAM strBslExtr DELIMITER "," ttPerms.DB-Guid ttPerms.FilNum ttPerms.FldNum ttPerms.StateFlag
                            ttPerms.Can-Code ttPerms.Cmd-PropSeq ttPerms.Cmd-CanSeq ttPerms.Can-SubSeq ttPerms.FilNam ttPerms.FldNam
                            ttPerms.Can-Expr ttPerms.Can-SubExpr ttPerms.Can-Repl ttPerms.Can-SubRepl ttPerms.ExprAttrs
                            ttPerms.Cmd-Can ttPerms.Can-Prop ttPerms.Cmd-Prop.
                    END.
                END.
            END.
        END.

        IF iState >= {&DO_EXTRACT} THEN DO:
            Run EvalExtr.

            RUN ProcFilPerms (OUTPUT rCode).

            IF iState > {&DO_EXTRACT} THEN
                RUN MakePerms.

            FOR EACH ttPerms EXCLUSIVE-LOCK:
                IF makeBslExec OR (iState > {&DO_EXTRACT} AND owrt) THEN DO:
                    EXPORT STREAM strBslExec DELIMITER "," ttPerms.DB-Guid ttPerms.FilNum ttPerms.FldNum ttPerms.StateFlag
                        ttPerms.Can-Code ttPerms.Cmd-PropSeq ttPerms.Cmd-CanSeq ttPerms.Can-SubSeq ttPerms.FilNam ttPerms.FldNam
                        ttPerms.Can-Expr ttPerms.Can-SubExpr ttPerms.Can-Repl ttPerms.Can-SubRepl ttPerms.ExprAttrs
                        ttPerms.Cmd-Can ttPerms.Can-Prop ttPerms.Cmd-Prop.
                END.
                DELETE ttPerms.
            END.
        END.
        /* RUN DumpCmds. */
    END.

    IF makeBslExtr OR (iState > {&DO_EXTRACT} AND owrt) THEN
    DO:
        RUN OutEval.
    END.
END.


PROCEDURE ProcFilPerms:
    DEFINE OUTPUT PARAMETER rtnCode AS INT NO-UNDO.

    DEFINE VARIABLE rCnt AS INTEGER. /* 0 - processed, 1 - undo */
    DEFINE VARIABLE replPerm AS CHARACTER.
    DEFINE VARIABLE sqlAct AS CHARACTER.
    DEFINE VARIABLE canAct AS CHARACTER.
    DEFINE VARIABLE fok AS INTEGER.
    DEFINE VARIABLE idx AS INTEGER.
    DEFINE VARIABLE tmpStr AS CHARACTER.
    DEFINE VARIABLE attrs AS ExprFlags.
    DEFINE VARIABLE attrs0 AS ExprFlags.
    DEFINE VARIABLE attrsNon0 AS ExprFlags.
    DEFINE VARIABLE chkPerm AS CHARACTER.
    DEFINE VARIABLE permType AS CHARACTER.
    DEFINE VARIABLE hasChgs AS LOGICAL.
    DEFINE VARIABLE rollUpVal AS CHARACTER.
    DEFINE VARIABLE rollUpRid AS ROWID.

    DEFINE BUFFER cCE FOR ttPerms.
    DEFINE BUFFER cFile FOR _File.
    DEFINE BUFFER cCsvProc FOR ttCsvProc.
    DEFINE VARIABLE permCode AS INTEGER.

    /* 0=Extracted, 1=Processed, 2=Executed, 4=Contains Expression */
    FOR EACH ttPerms USE-INDEX IResSubPerm NO-LOCK:
        IF makeBslProc THEN DO:
            hasChgs = NO.
            attrs = ExprFlags:NO_FLAGS.
            attrs0 = ExprFLags:NO_FLAGS.
        END.
        ELSE DO:
            attrs = ExprFlags:getEnum(ttPerms.ExprAttrs).
            hasChgs = LOGICAL(INT64(attrs AND chgMask)). /* 0 = no changes */
        END.

        IF ttPerms.Can-SubSeq = 0 THEN DO:
            FIND cFile WHERE cFile._File-number = ttPerms.FilNum NO-LOCK.

            ASSIGN ttPerms.StateFlag = 1.
            CASE ttPerms.Can-Code:
                WHEN 1 THEN ASSIGN chkPerm = cFile._Can-Read permType = "READ".
                WHEN 2 THEN ASSIGN chkPerm = cFile._Can-Write permType = "WRITE".
                WHEN 3 THEN ASSIGN chkPerm = cFile._Can-Create permType = "CREATE".
                WHEN 4 THEN ASSIGN chkPerm = cFile._Can-Delete permType = "DELETE".
                WHEN 5 THEN ASSIGN chkPerm = cFile._Can-Dump permType = "DUMP".
                WHEN 6 THEN ASSIGN chkPerm = cFile._Can-Load permType = "LOAD".
            END CASE.
            
            IF NOT makeBslProc and eval > 0 THEN DO:
                IF ttPerms.Can-Expr <> chkPerm THEN
                    RUN WriteLogMsg("OUTDATED        - RESOURCE: " + ttPerms.FilNam + " received a replacement " +
                        QUOTER(permType) + "permission expression since the Extract baseline was established.").
                ELSE DO:
                    IF ttPerms.Can-Repl <> ? THEN
                        IF hasChgs THEN
                            RUN WriteLogMsg("UNTRACKED      - RESOURCE: " + ttPerms.FilNam +
                                " received a replacement baseline value from outside of this tool. Cannot properly track.").
                END.
            END.

            /* CSV Edited Expression Modes */
            IF NOT makeCsvProc AND iState > {&DO_EXTRACT} THEN DO:
                FIND cCsvProc WHERE /* cCsvProc.Db-Guid = ttPerms.Db-Guid AND */
                                    cCsvProc.FilNum = ttPerms.FilNum AND
                                    cCsvProc.FldNum = ttPerms.FldNum AND
                                    cCsvProc.Can-Code = ttPerms.Can-Code AND
                                    CCsvProc.Can-SubSeq = ttPerms.Can-SubSeq NO-LOCK.

                IF ttPerms.Can-SubSeq = 0 THEN DO:
                    IF AMBIGUOUS(cCsvProc) THEN
                        RUN WriteLogMsg("AMBIGUOUS      - RESOURCE: " + ttPerms.FilNam +
                        " unexpected expression record exists ").
                    ELSE IF AVAILABLE(cCsvProc) THEN DO:
                        IF ttPerms.Can-Repl = ? OR owrt THEN DO:
                            IF cCsvProc.Can-Repl <> ? THEN DO:
                                IF eval > 0 THEN
                                    EditExprCnt = EditExprCnt + 1.
                                IF eval > 1 THEN DO:
                                    IF hasChgs THEN
                                        RUN WriteLogMsg("OVERWRITE EXPR - RESOURCE: " + QUOTER(ttPerms.FilNam) +
                                            " Permission type: " + QUOTER(permType)).
                                    ELSE
                                        RUN WriteLogMsg("EDITED EXPR    - RESOURCE: " + QUOTER(ttPerms.FilNam) +
                                            " Permission type: " + QUOTER(permType)).
                                END.
                                ELSE DO:
                                    ttPerms.Can-Repl = cCsvProc.Can-Repl.
                                    IF hasChgs THEN
                                        attrs0 = (attrs OR ExprFlags:OREPLCSV).
                                    ELSE
                                        attrs0 = (attrs OR ExprFlags:REPLCSV).
                                    ttPerms.ExprAttrs = INT64(attrs0).
                                END.
                            END.
                        END.
                    END.
                END.
            END.
            IF iState >= {&DO_PROCESS} THEN DO:
                DEFINE VARIABLE origCanExpr AS CHARACTER   NO-UNDO.
                /* Start expression processing swaps */
                
                /*  original code
                FIND ttSubs WHERE ttSubs.match = ttPerms.Can-Expr NO-ERROR.
                IF AVAILABLE(ttSubs) THEN DO: /* Swap Processing */
                    IF ( ttPerms.Can-Repl = ? ) OR owrt THEN DO:
                        IF eval > 0 THEN
                            EditExprCnt = EditExprCnt + 1.
                        IF eval > 1 THEN DO:
                            IF hasChgs THEN
                                RUN WriteLogMsg("SWAP OVER EXPR - RESOURCE: " + QUOTER(ttPerms.FilNam) +
                                    " Permission type: " + QUOTER(permType)).
                            ELSE
                                RUN WriteLogMsg("SWAPPED EXPR   - RESOURCE: " + QUOTER(ttPerms.FilNam) +
                                    " Permission type: " + QUOTER(permType)).
                        END.
                        ELSE DO:
                            ttPerms.Can-Repl = ttSubs.repl.
                            IF hasChgs THEN
                                attrs0 = (attrs OR ExprFlags:OREPLSWP).
                            ELSE
                                attrs0 = (attrs OR ExprFlags:REPLSWP).
                            ttPerms.ExprAttrs = INT64(attrs0).
                        END.
                    END.
                END.
                */
                
                DEFINE VARIABLE canRepl AS CHARACTER   NO-UNDO.
                
                IF ttPerms.Can-Repl <> ? THEN
                    canRepl = ttPerms.Can-Repl.
                ELSE
                    canRepl = ttPerms.Can-Expr.
                    
                FOR EACH ttSubs WHERE subsType = "full" BY subsId:
                    /* Consolidate an expression where there are entries after a *.
                    ** These entries will never be significant since they contradict
                    ** the * which precedes them.
                    */
                    origCanExpr = canRepl.
                    canRepl = ConsolidateWildcards(canRepl).
                    IF canRepl <> origCanExpr THEN
                    DO:
                        RUN WriteLogMsg("Consolidated " + permNames[ttPerms.Can-Code] + " " + QUOTER(origCanExpr) + " of table " + ttPerms.FilNam + " to " + QUOTER(canRepl)).
                    END.
                    
                    IF ttSubs.match = canRepl THEN
                    DO:
                       // IF ( ttPerms.Can-Repl = ? ) OR owrt THEN DO:
                            IF eval > 0 THEN
                                EditExprCnt = EditExprCnt + 1.
                            IF eval > 1 THEN DO:
                                IF hasChgs THEN
                                    RUN WriteLogMsg("SWAP OVER EXPR - RESOURCE: " + QUOTER(ttPerms.FilNam) +
                                        " Permission type: " + QUOTER(permType)).
                                ELSE
                                    RUN WriteLogMsg("SWAPPED EXPR   - RESOURCE: " + QUOTER(ttPerms.FilNam) +
                                        " Permission type: " + QUOTER(permType)).
                            END.
                            ELSE DO:
                                canRepl = ttSubs.repl.
                                IF hasChgs THEN
                                    attrs0 = (attrs OR ExprFlags:OREPLSWP).
                                ELSE
                                    attrs0 = (attrs OR ExprFlags:REPLSWP).
                                ttPerms.ExprAttrs = INT64(attrs0).
                            END.
                      //  END.
                    END.
                END.
                
                IF canRepl <> ttPerms.Can-Expr THEN
                DO:
                    ttPerms.Can-Repl = canRepl.
                END.
            END.
        END. /* End Expression Processing */
        ELSE DO: /* Begin Sub-Expression Processing */
            /* CSV Edited Sub-Expressions */
            ttPerms.Can-Expr = ?. /* Clear non-0th sub-expression record's expression value */
            IF NOT makeCsvProc AND iState > {&DO_EXTRACT} THEN DO:
                FIND cCsvProc WHERE /* cCsvProc.Db-Guid = ttPerms.Db-Guid AND */
                                    cCsvProc.FilNum = ttPerms.FilNum AND
                                    cCsvProc.FldNum = ttPerms.FldNum AND
                                    cCsvProc.Can-Code = ttPerms.Can-Code AND
                                    CCsvProc.Can-SubSeq = ttPerms.Can-SubSeq NO-LOCK.

                IF AMBIGUOUS(cCsvProc) THEN 
                    RUN WriteLogMsg("AMBIGUOUS      - RESOURCE: " + ttPerms.FilNam +
                        " unexpected expression record exists ").
                ELSE IF AVAILABLE(cCsvProc) THEN DO:
                    IF ttPerms.Can-SubRepl <> cCsvProc.Can-SubRepl THEN DO:
                        ttPerms.Can-SubRepl = cCsvProc.Can-SubRepl.
                        IF hasChgs THEN
                            attrs0 = (attrs OR ExprFlags:OREPLCSV).
                        ELSE
                            attrs0 = (attrs OR ExprFlags:REPLCSV).
                        ttPerms.ExprAttrs = INT64(attrs0).
                    END.
                END.
            END.
            IF NOT makeBslProc THEN DO: /* Re-assess flags after CSV edits have been applied */
                attrs = ExprFlags:getEnum(ttPerms.ExprAttrs).
                hasChgs = LOGICAL(INT64(attrs AND chgMask)). /* 0 = no changes */
            END.

            /* Do change sub-expressions */
            IF NOT makeBslProc THEN DO: /* Re-assess flags after CSV edits have been applied */
                attrs = ExprFlags:getEnum(ttPerms.ExprAttrs).
                hasChgs = LOGICAL(INT64(attrs AND chgMask)). /* 0 = no changes */
            END.
            
            /*
            /* Start sub-expression processing changes */
            FIND ttChg WHERE ttChg.match = ttPerms.Can-SubExpr NO-ERROR.
            IF AVAILABLE(ttChg) THEN DO:  /* Chg Processing */
                IF ( ttPerms.Can-SubRepl = ? OR owrt ) THEN DO:
                    IF eval > 0 THEN
                        EditSubExprCnt = EditSubExprCnt + 1.
                    IF eval > 1 THEN DO:
                        IF hasChgs THEN
                            RUN WriteLogMsg("CHG OVRWRT EXPR- RESOURCE: " + ttPerms.FilNam +
                                " Permission type: " + QUOTER(permType)).
                        ELSE
                            RUN WriteLogMsg("CHANGED EXPR   - RESOURCE: " + ttPerms.FilNam +
                                " Permission type: " + QUOTER(permType)).
                    END.
                    ELSE DO:
                        ttPerms.Can-SubRepl = ttChg.repl.
                        IF hasChgs THEN
                            attrsNon0 = (attrs OR ExprFlags:OREPLCHG).
                        ELSE
                            attrsNon0 = (attrs OR ExprFlags:REPLCHG).
                        ttPerms.ExprAttrs = INT64(attrsNon0).
                    END.
                END.
            END.
            /* Do substitution sub-expressions */
            IF NOT makeBslProc THEN DO: /* Re-assess flags after CSV edits have been applied */
                attrs = ExprFlags:getEnum(ttPerms.ExprAttrs).
                hasChgs = LOGICAL(INT64(attrs AND chgMask)). /* 0 = no changes */
            END.
            /* Start sub-expression processing text substitutions */
            FOR EACH ttSub:
                IF ( ttPerms.Can-SubRepl = ? OR owrt ) THEN DO:
                    IF INDEX(ttPerms.Can-SubExpr, ttSub.match) > 0 THEN DO:
                        IF eval > 0 THEN
                            EditSubExprCnt = EditSubExprCnt + 1.
                        IF eval > 1 THEN DO:
                            IF hasChgs THEN
                                RUN WriteLogMsg("SUB OVRWRT EXPR- RESOURCE: " + ttPerms.FilNam +
                                    " Permission type: " + QUOTER(permType)).
                            ELSE
                                RUN WriteLogMsg("SUBSTITUTE EXPR- RESOURCE: " + ttPerms.FilNam +
                                    " Permission type: " + QUOTER(permType)).
                        END.
                        ttPerms.Can-SubRepl = REPLACE(ttPerms.Can-SubExpr, ttSub.match, ttSub.repl).
                        IF hasChgs THEN
                            attrsNon0 = (attrs OR ExprFlags:OREPLSUB).
                        ELSE
                            attrsNon0 = (attrs OR ExprFlags:REPLSUB).
                        ttPerms.ExprAttrs = INT64(attrsNon0).
                    END.
                END.
            END.
            */
            
        END.
    END.

/********** Do roles analysis
    IF eval THEN DO:
        IF LENGTH(perm) = INDEX(perm,"*",1) THEN DO:
            ASSIGN canRoleCnt = canRoleCnt + 1.
            DISPLAY "Entry: " QUOTER(perm) " is a strong role candidate" SKIP.
        END.
        ELSE IF INDEX(perm,"*",1) > 0 THEN DO:
            ASSIGN couldRoleCnt = couldRoleCnt + 1.
            DISPLAY "Entry: " QUOTER(perm) " is a possible role candidate" SKIP.
        END.
    END.
************/
    IF iState >= {&DO_PROCESS} THEN DO:
        permCode = 1.
        FOR EACH ttPerms USE-INDEX IResSubPerm NO-LOCK:
            /* This processes the previous permission */
            IF ( ttPerms.Can-Code <> permCode ) THEN DO: /* Break by CAN-Code */
                IF rollUpRid <> ? THEN DO:
                    FIND cCE WHERE ROWID(cCE) = rollUpRid NO-LOCK.
                    IF AVAILABLE(cCE) THEN DO:
                        IF rollUpVal <> cCE.Can-Expr THEN DO: /* Something changed */
                            IF cCE.Can-Repl = ? THEN
                                ASSIGN cCE.Can-Repl = rollUpVal.
                            ELSE IF owrt AND rollUpVal <> cCE.Can-Repl THEN
                                ASSIGN cCE.Can-Repl = rollUpVal.
                        END.
                        ASSIGN cCE.StateFlag = 1.
                        permCode = ttPerms.Can-Code.
                    END.
                END.
            END.
            permCode = ttPerms.Can-Code.

            /* Save the rollup record for the permission */
            IF ttPerms.Can-SubSeq = 0 THEN DO:
                IF ttPerms.Can-Repl = ? OR owrt THEN DO:    /* Do rollup */
                    rollUpRid = ROWID(ttPerms).
                    rollUpVal = "".
                END.
                ELSE DO:                                    /* Skip rollup */
                    rollUpRid = ?.
                    rollUpVal = "".
                    NEXT.
                END.
            END.

            /* Rollup on any sub-expression changes */
            IF ( ttPerms.Can-SubSeq > 0 ) AND rollUpRid <> ? THEN DO:
                IF ttPerms.Can-SubRepl = ? THEN DO:
                    IF rollUpVal = "" THEN
                        rollUpVal = ttPerms.Can-SubExpr.
                    ELSE
                        rollUpVal = rollUpVal + "," + ttPerms.Can-SubExpr.
                END.
                ELSE DO:
                    IF rollUpVal = "" THEN
                        rollUpVal = ttPerms.Can-SubRepl.
                    ELSE
                        rollUpVal = rollUpVal + "," + ttPerms.Can-SubRepl.
                END.
            END.
        END.
    END.

    FOR EACH ttPerms NO-LOCK:
        IF openBslProc THEN
            EXPORT STREAM strBslProc DELIMITER "," ttPerms.DB-Guid ttPerms.FilNum ttPerms.FldNum
                ttPerms.StateFlag ttPerms.Can-Code ttPerms.Cmd-PropSeq ttPerms.Cmd-CanSeq ttPerms.Can-SubSeq
                ttPerms.FilNam ttPerms.FldNam ttPerms.Can-Expr ttPerms.Can-SubExpr ttPerms.Can-Repl
                ttPerms.Can-SubRepl ttPerms.ExprAttrs ttPerms.Cmd-Can ttPerms.Can-Prop ttPerms.Cmd-Prop.

        IF openCsvProc THEN
            EXPORT STREAM strCsvProc DELIMITER "," ttPerms.DB-Guid ttPerms.FilNum ttPerms.FldNum
                ttPerms.StateFlag ttPerms.Can-Code ttPerms.Cmd-PropSeq ttPerms.Cmd-CanSeq ttPerms.Can-SubSeq
                ttPerms.FilNam ttPerms.FldNam ttPerms.Can-Expr ttPerms.Can-SubExpr ttPerms.Can-Repl
                ttPerms.Can-SubRepl ttPerms.ExprAttrs ttPerms.Cmd-Can ttPerms.Can-Prop ttPerms.Cmd-Prop.
    END.

END PROCEDURE.


PROCEDURE MakePerms:

    DEFINE VARIABLE sqlAct AS CHARACTER INIT ?.
    DEFINE VARIABLE cAct AS CHARACTER.
    DEFINE VARIABLE cTOw AS CHARACTER INIT "".
    DEFINE VARIABLE cTO AS CHARACTER INIT "".
    DEFINE VARIABLE cUser AS CHARACTER INIT "".
    DEFINE VARIABLE noMatches AS LOGICAL INITIAL FALSE NO-UNDO.
    DEFINE VARIABLE cFilNum AS INTEGER.
    DEFINE VARIABLE cFldNum AS INTEGER.
    DEFINE VARIABLE cmd AS CHARACTER.
    DEFINE VARIABLE cmdPlusAccts AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lineLength AS INTEGER     NO-UNDO.
    DEFINE VARIABLE numUsers AS INTEGER     NO-UNDO.
    DEFINE VARIABLE nUser AS INTEGER     NO-UNDO.
    DEFINE VARIABLE cExprBuf AS CHARACTER.
    DEFINE VARIABLE cAddedExprBuf AS CHARACTER.
    DEFINE VARIABLE cAccountName AS CHARACTER.
    DEFINE VARIABLE unresolvedMsg AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE domainName AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE userName AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE domainFullySpecified AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE matchUserTable AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE matchAccountsFile AS LOGICAL     NO-UNDO.
    
    DEFINE VARIABLE cCnt AS INTEGER.
    DEFINE VARIABLE cAddedCnt AS INTEGER.
    DEFINE VARIABLE nextExprBufList AS LOGICAL.
    DEFINE BUFFER cCE FOR ttPerms.
    DEFINE BUFFER cCR FOR ttPerms.
    DEFINE BUFFER cttAcct FOR ttAcct.
    DEFINE VARIABLE foundOne AS LOGICAL     NO-UNDO.
    
    sCode = 0.
    FOR EACH ttPerms WHERE ttPerms.StateFlag = 1 EXCLUSIVE-LOCK:
        IF ttPerms.Can-Code <> sCode THEN DO:
            sCode = ttPerms.Can-Code.
            CASE sCode: /* Find SQL Permission Type */
                WHEN 1 THEN ASSIGN sqlAct = "SELECT".
                WHEN 2 THEN ASSIGN sqlAct = "UPDATE".
                WHEN 3 THEN ASSIGN sqlAct = "INSERT".
                WHEN 4 THEN ASSIGN sqlAct = "DELETE".
                WHEN 5 THEN ASSIGN sqlAct = "LOAD".
                WHEN 6 THEN ASSIGN sqlAct = "DUMP".
            END CASE.
        END.

        IF ttPerms.Can-SubSeq = 0 THEN DO:
            IF ttPerms.Can-Repl <> ? THEN
                cExprBuf = ttPerms.Can-Repl.
            ELSE
                cExprBuf = ttPerms.Can-Expr.
        END.
        ELSE DO:
            IF ttPerms.Can-SubRepl <> ? THEN
                cExprBuf = ttPerms.Can-SubRepl.
            ELSE
                cExprBuf = ttPerms.Can-SubExpr.
        END.

        /* Original code
        FOR EACH ttAcct:                /* Collect accounts matching full expression */
            cUser = RIGHT-TRIM(ttAcct.Account).
            FIND ttAcctM WHERE ttacctM.account = cUser NO-ERROR.
            IF AVAILABLE ttAcctM THEN NEXT.
            /* If not added and CAN-DO resolves, add it */
            IF CAN-DO(cExprBuf, cUser) THEN DO:
                CREATE ttAcctM.
                ASSIGN ttAcctM.account = cUser.
            END.
        END.

        cAddedCnt = NUM-ENTRIES(cExprBuf). /* Collect hardcoded non-expression accounts from list */
        DO cCnt = 1 TO cAddedCnt:
            cAddedExprBuf = ENTRY(cCnt, cExprBuf).
            IF INDEX(cAddedExprBuf, "!", 1) = 1 THEN NEXT.  /* Revoke Accts not added */
            IF INDEX(cAddedExprBuf, "*", 1) > 0 THEN NEXT.  /* Already processed */
            cUser = RIGHT-TRIM(cAddedExprBuf).
            FIND ttAcctM WHERE ttacctM.account = cUser NO-ERROR.
            IF AVAILABLE(ttAcctM) THEN NEXT.
            IF CAN-DO(cExprBuf, cUser) THEN DO:
                CREATE ttAcctM.
                ASSIGN ttAcctM.account = cUser.
            END.
        END.
        */
        
        cAddedCnt = NUM-ENTRIES(cExprBuf).
        DO cCnt = 1 TO cAddedCnt:
            cAddedExprBuf = ENTRY(cCnt, cExprBuf).
            
            matchUserTable = FALSE.
            matchAccountsFile = FALSE.
            
            IF INDEX(cAddedExprBuf, "!", 1) = 1 THEN NEXT.  /* Revoke Accts not added */
            
            IF INDEX(cAddedExprBuf, "*", 1) > 0 THEN
            DO:
                foundOne = FALSE.
                
                /* VALIDATE DOMAINS IN WILDCARD MATCHES */
                IF INDEX(cAddedExprBuf, "@") > 0 THEN
                DO:
                    userName = SUBSTRING(cAddedExprBuf, 1, INDEX(cAddedExprBuf, "@") - 1).
                    domainName = SUBSTRING(cAddedExprBuf, INDEX(cAddedExprBuf, "@") + 1).
                    domainFullySpecified = IF INDEX(domainName, ".") > 0 OR INDEX(domainName, "*") > 0 THEN FALSE ELSE TRUE.
                END.
                ELSE
                DO:
                    /* Blank domain */
                    userName = cAddedExprBuf.
                    domainName = "".
                    domainFullySpecified = TRUE.
                    matchAccountsFile = TRUE.
                END.
                    
                IF domainFullySpecified = TRUE THEN
                DO:
                    FIND _sec-authentication-domain 
                        WHERE _sec-authentication-domain._Domain-name = domainName AND
                              _sec-authentication-domain._Domain-enabled = TRUE AND
                              _sec-authentication-domain._Domain-type = "_oeusertable" NO-ERROR.
                    IF AVAILABLE(_sec-authentication-domain) THEN
                    DO:
                        matchUserTable = TRUE.
                    END.
                    ELSE
                    DO:
                        matchAccountsFile = TRUE.
                    END.
                END.
                ELSE
                DO:
                    matchUserTable = TRUE.
                    matchAccountsFile = TRUE.
                END.
                
                /* Collect accounts matching expression */
                FOR EACH ttAcct:
                    /* If this account is already in the result list skip it */
                    cUser = RIGHT-TRIM(ttAcct.Account).
                    FIND ttAcctM WHERE ttacctM.account = cUser NO-ERROR.
                    IF AVAILABLE ttAcctM THEN NEXT.
                    
                    /* If not added and CAN-DO resolves, add it. We against test both the 
                    ** current wildcard subexpression and the full expression to make sure
                    ** that this account satisfises the wildcard and is not excluded by
                    ** some other part of the expression. For example, mary will satisfy
                    ** "ma*", but if the full expression includes "!mary" we have to
                    ** exclude mary from matching "ma*".
                    */
                    IF ((matchUserTable = TRUE AND ttAcct.fromUserTable = TRUE) OR 
                        (matchAccountsFile = TRUE AND ttAcct.fromUserTable = FALSE)) AND
                       CAN-DO(cAddedExprBuf, cUser) AND CAN-DO(cExprBuf, cUser) THEN 
                    DO:
                        foundOne = TRUE.
                        CREATE ttAcctM.
                        ASSIGN ttAcctM.account = cUser.
                    END.
                END.
                
                IF foundOne = FALSE THEN
                DO:
                    unresolvedMsg = "Unable to resolve account " + cAddedExprBuf + " for " + sqlAct + " permission of table " + ttPerms.FilNam.
                    PUT STREAM strSqlGrant UNFORMATTED "-- " + unresolvedMsg SKIP.
                    RUN WriteLogMsg(unresolvedMsg).
                END.
            END.
            ELSE
            DO:
                /* Collect hardcoded non-expression accounts from list */
                cUser = RIGHT-TRIM(cAddedExprBuf).
                FIND ttAcctM WHERE ttacctM.account = cUser NO-ERROR.
                IF AVAILABLE(ttAcctM) THEN NEXT.
                CREATE ttAcctM.
                ASSIGN ttAcctM.account = cUser.
            END.
        END.

        cTO = "".

        FOR EACH ttAcctM:
            cAccountName = IF ttAcctM.Account = "PUBLIC" THEN ttAcctM.Account ELSE QUOTER(ttAcctM.Account).
            IF cTO = "" THEN 
                ASSIGN cTO = cAccountName.
            ELSE
                cTO = cTO + "," + cAccountName.
            DELETE ttAcctM.
        END.

        /* If we didn't find any matches for the expression log a warning and
        ** put a commented GRANT in the SQL file.
        */
        noMatches = FALSE.

        IF cTO = "" THEN
        DO:
            noMatches = TRUE.
            cTO = "<No valid user accounts>".
        END.
        
        /* For Sequences: GRANT SELECT/UPDATE ON SEQUENCE <pub.seq> TO <users>. */

        IF cTO <> "" THEN DO: /* DUMP and LOAD commented out for SQL */
            /* The command is formatted two ways - once to put into Cmd-Can (cmdPlusAccts)
            ** and once to write to the SQL file (cmd). cmdPlusAccts has the command and
            ** a comma-separated list of accounts. cmd is just the command without the
            ** accounts. The accounts will be written out one-by-one so we can wrap lines.
            */
            cmd = (IF sCode > 4 OR noMatches = TRUE THEN "-- " ELSE "") +
                  "GRANT " +
                  (IF sCode > 4 THEN "SQL-" ELSE "") +
                  SqlAct + " ON PUB." + QUOTER(FilNam) + " TO ".
                  
            cmdPlusAccts = cmd + cTO + ";".
            
            IF sCode < 5 THEN DO:
                ASSIGN ttPerms.Cmd-Can = cmdPlusAccts.
                ASSIGN ttPerms.StateFlag = 2.
            END.
            
            IF ttPerms.Can-SubSeq = 0 THEN
            DO:
                PUT STREAM strSqlGrant UNFORMATTED cmd.
                
                lineLength = LENGTH(cmd).
                numUsers = NUM-ENTRIES(cTO).
                
                DO nUser = 1 TO numUsers:
                    cUser = ENTRY(nUser, cTO).
                    
                    IF lineLength + LENGTH(cUser) > 79 THEN
                    DO:
                        PUT STREAM strSqlGrant UNFORMATTED SKIP "    ".
                        lineLength = 4.
                    END.
                    
                    PUT STREAM strSqlGrant UNFORMATTED cUser (IF nUser < numUsers THEN "," ELSE "").
                    lineLength = lineLength + LENGTH(cUser) + 1. /* + 1 for the comma */
                END.
                
                PUT STREAM strSqlGrant UNFORMATTED ";" SKIP.
            END.
        END.

        IF sCode = 6 THEN
            sCode = 0. /* Reset action */
    END.

END PROCEDURE.

PROCEDURE EvalExtr:
    DEFINE VARIABLE canAct AS CHARACTER.
    DEFINE VARIABLE matchCnt AS INT64 INIT 0.
    DEFINE VARIABLE badRecCnt AS INT64 INIT 0.
    DEFINE VARIABLE addRecCnt AS INT64 INIT 0.
    DEFINE VARIABLE exprCnt AS INT INIT 0.
    DEFINE VARIABLE subExprCnt AS INT INIT 0.
    DEFINE VARIABLE newFlag AS ExprFlags.

    FOR EACH ttPerms WHERE ttPerms.StateFlag = 0 NO-LOCK BREAK BY FilNum
                                                               BY FldNum.
        IF FIRST-OF(FilNum) AND FilNum = 0 THEN DO:

            FIND ttBslExtr WHERE /* ttPerms.DB-Guid = ttBslExtr.DB-Guid AND */ ttPerms.Filnum = ttBslExtr.Filnum
                               AND ttPerms.FldNum = ttBslExtr.FldNum AND ttPerms.StateFlag = ttBslExtr.StateFlag
                               AND ttPerms.Can-Code = ttBslExtr.Can-Code AND ttPerms.Cmd-PropSeq = ttBslExtr.Cmd-PropSeq
                               AND ttPerms.Cmd-CanSeq = ttBslExtr.Cmd-CanSeq AND ttPerms.Can-SubSeq = ttBslExtr.Can-SubSeq.

            CASE ttPerms.Can-Code: /* Can Permission Type */
                WHEN 1 THEN ASSIGN canAct = "READ".
                WHEN 2 THEN ASSIGN canAct = "WRITE".
                WHEN 3 THEN ASSIGN canAct = "CREATE".
                WHEN 4 THEN ASSIGN canAct = "DELETE".
                WHEN 5 THEN ASSIGN canAct = "DUMP".
                WHEN 6 THEN ASSIGN canAct = "LOAD".
            END CASE.

            IF AVAILABLE(ttBslExtr) THEN DO:
                matchCnt = matchCnt + 1.
                newFlag = ExprFlags:getEnum(ttBslExtr.ExprAttrs).
                IF ttPerms.Can-SubSeq = 0 AND ttPerms.Can-Expr <> ttBslExtr.Can-Expr THEN DO:
                    exprCnt = exprCnt + 1. /* Changed Expression */
                    IF owrt THEN DO:
                        newFlag = newFlag OR ExprFlags:RE_EXTR.
                        SET ttBslExtr.ExprAttrs = INT64(newFlag)
                            ttBslExtr.Can-Expr = ttPerms.Can-Expr.
                    END.
                END.
                ELSE IF ttPerms.Can-SubExpr <> ttBslExtr.Can-SubExpr THEN DO:
                    subExprCnt = subExprCnt + 1.
                    IF owrt THEN DO:
                        /* exprFlag = CAST(ttBslExtr.ExprAttrs, ExprFlags). */
                        newFlag = newFlag OR ExprFlags:RE_EXTR.
                        SET ttBslExtr.ExprAttrs = INT64(newFlag)
                            ttBslExtr.Can-SubExpr = ttPerms.Can-SubExpr.
                    END.
                END.
            END.
            ELSE IF AMBIGUOUS(ttBslExtr) THEN DO:
                badRecCnt = badRecCnt + 1.
                IF ttBslExtr.FldNum = 0 THEN
                    IF ttBslExtr.FilNum < 0 THEN
                        RUN WriteLogMsg("Additional " + canAct +
                            " permission records should not exist for sequence resource: " + ttPerms.FilNam).
                    ELSE
                        RUN WriteLogMsg("Additional " + canAct +
                            "permissions records should not exist for table resource: " + ttPerms.FilNam).
                ELSE
                    RUN WriteLogMsg("Additional " + canAct +
                        "permissions records should not exist for field resource: " + ttPerms.FldNam).
            END.
            ELSE DO:
                addRecCnt = addRecCnt + 1.
                IF ttBslExtr.FldNum = 0 THEN
                    IF ttBslExtr.FldNum < 0 THEN
                        RUN WriteLogMsg("New " + canAct + " sub-expression was added to " +
                            "sequence resource: " + ttPerms.FilNam).
                    ELSE
                        RUN WriteLogMsg("New " + canAct + " sub-expression was added to " +
                            "table resource: " + ttPerms.FilNam).
                ELSE
                    RUN WriteLogMsg("New " + canAct + " sub-expression was added to " +
                        "field resource: " + ttPerms.FldNam).
            END.
        END.
    END.


END PROCEDURE.


PROCEDURE EvalPerms:

    DEFINE VARIABLE perms AS CHARACTER.
    DEFINE VARIABLE subPermCnt AS INT INIT 0.
    DEFINE VARIABLE exprIdx AS INT.
    DEFINE VARIABLE rvkIdx AS INT.
    DEFINE VARIABLE cExprFlag AS ExprFlags.


/**** just for reference
DEFINE TEMP-TABLE ttPerms
    FIELD Db-Guid AS CHARACTER
    FIELD FilNum AS INTEGER
    FIELD FldNum AS INTEGER
    FIELD StateFlag AS INTEGER
    FIELD Can-Code AS INTEGER
    FIELD Cmd-PropSeq AS INTEGER
    FIELD Cmd-CanSeq AS INTEGER
    FIELD Can-SubSeq AS INTEGER
    FIELD FilNam AS CHARACTER
    FIELD FldNam AS CHARACTER
    FIELD Can-Expr AS CHARACTER
    FIELD Can-SubExpr AS CHARACTER
    FIELD Can-Repl AS CHARACTER
    FIELD Can-SubRepl AS CHARACTER
    FIELD ExprAttrs AS INT64
    FIELD Cmd-Can AS CHARACTER
    FIELD Can-Prop AS CHARACTER
    FIELD Cmd-Prop AS CHARACTER
    FIELD Redit AS LOGICAL
    FOR EACH ttPerms NO-LOCK:
****/
    IF ttPerms.Can-Code = 0 THEN DO:
        IF ttPerms.Can-Repl = ? THEN
            perms = ttPerms.Can-Expr.
        ELSE
            perms = ttPerms.Can-Repl.
    END.

    /* DISTINGUISH BETWEEN EXPRESSION and SUB-EXPRESSION EVALUATIONS */

    /* Is there a revoke? */
    rvkIdx = INDEX(perms,"!",1).
    /* Is there an non-list expression? */
    exprIdx = INDEX(perms,"*",1).

    IF LENGTH(perms) = 0 THEN
        blnkPermCnt = blnkPermCnt + 1.          /* Blank user permissions (ignored) */

    /* If it is a default permission expression ("*") */
    IF exprIdx = 1 AND LENGTH(perms) = 1 THEN DO:
        ASSIGN cExprFlag = cExprFlag OR ExprFlags:DFLTPUB.
        dfltCnt = dfltCnt + 1.
    END.

    /* If it is a revoke-blank-user default permission expression ("!*") */
    IF rvkIdx = 1 AND exprIdx = 2 AND LENGTH(perms) = 2 THEN DO:
        ASSIGN cExprFlag = cExprFlag OR ExprFlags:RDFLTPUB.
        dfltCnt = dfltCnt + 1.
    END.

    /* DUMP/LOAD counts */
    IF ttPerms.Can-Code > 4 THEN DO:
        CASE ttPerms.Can-Code: /* Can Permission Type */
            WHEN 5 THEN DO:
                IF INT64(cExprFlag) > 0 THEN DumpDfltCnt = DumpDfltCnt + 1.
                ELSE DumpExprCnt = DumpExprCnt + 1.
            END.
            WHEN 6 THEN DO:
                IF INT64(cExprFlag) > 0 THEN LoadDfltCnt = LoadDfltCnt + 1.
                ELSE LoadExprCnt = LoadExprCnt + 1.
            END.
        END CASE.
    END.

    subPermCnt = NUM-ENTRIES(perms).
    subPermTCnt = subPermTCnt + subPermCnt.

    IF INT64(cExprFlag) = 0 THEN DO:  /* ExprFlags:NOFLAGS */
        IF exprIdx > 0 THEN
            roleExprCnt = roleExprCnt + 1.  /* Role Candidate Count */
        ELSE
            listExprCnt = listExprCnt + 1.  /* Account List Count */

        IF rvkIdx > 0 THEN                  /* make ignored revocations */
            rvkExprCnt = rvkExprCnt + 1.

        IF subPermCnt > subPermThresh THEN
            subPermsThreshCnt = subPermsThreshCnt + 1.

        subPermsCnt = subPermsCnt + subPermCnt.  /* Average against file count */
    END.

    IF ttPerms.Can-Code = 6 THEN DO:
        IF dfltCnt < 6 THEN                     /* Some Default permissions */
            filePdfltCnt = filePdfltCnt + 1.    /* Partial Defaults */
        ELSE DO:                                /* All Default permissions */
            IF INT64(cExprFlag) = 1 THEN       /* ExprFlags:DLFTPUB only */
                fileDfltCnt = fileDfltCnt + 1.
            IF INT64(cExprFlag) = 2 THEN       /* ExprFlags:RDFLTPUB only */
                fileRdfltCnt = fileRdfltCnt + 1.
            IF INT64(cExprFlag) = 3 THEN       /* ExprFlags:DFTPUB AND ExprFlags:RDFLTPUB */
                fileMdfltCnt = fileMdfltCnt + 1.
        END.
        IF roleExprCnt = 6 THEN fileRoleExprCnt = fileRoleExprCnt + 1.
        IF rvkExprCnt = 6 THEN fileRvkExprCnt = fileRvkExprCnt + 1.
    END.

END PROCEDURE.



PROCEDURE OutEval:

    DEFINE VARIABLE tmpCnt1 AS INT INIT 0.
    DEFINE VARIABLE tmpCnt2 AS INT INIT 0.

    IF fileCnt = 0 THEN
    DO:
        RUN WriteLogMsg("Summary Statistics about your Permissions: No permissions found").
    END.
    ELSE
    DO:
        RUN WriteLogMsg("Summary Statistics about your Permissions").
        tmpCnt1 = fileDfltCnt + fileRdfltCnt.
        tmpCnt2 = (tmpCnt1 / fileCnt) * 100.
        RUN WriteLogMsg("Tables with all Default Permissions, Total: " + STRING(tmpCnt1) + " (" + STRING(tmpCnt2) +
                   "% of all tables)").
        tmpCnt2 = (fileRdfltCnt / fileCnt) * 100.
        RUN WriteLogMsg("Default Permissions tables that exclude the blank user: " + STRING(fileRdfltCnt) + " (" + STRING(tmpCnt2) +
                   "% of all tables)").
        tmpCnt2 = (filePdfltCnt / fileCnt) * 100.
        RUN WriteLogMsg("Additional tables with partial default permissions: " + STRING(filePdfltCnt) + " (" + STRING(tmpCnt2) +
                   "% of all tables)").
        tmpCnt2 = (roleExprCnt / fileCnt) * 100.
        RUN WriteLogMsg("Tables with permissions that have role potential: " + STRING(roleExprCnt) + " (" + STRING(tmpCnt2) +
                   "% of all tables)").
        tmpCnt2 = (fileRoleExprCnt / fileCnt) * 100.
        RUN WriteLogMsg("Tables with all permissions having role potential: " + STRING(fileRoleExprCnt) + " (" + STRING(tmpCnt2) +
                   "% of all tables)").
        tmpCnt2 = (listExprCnt / fileCnt) * 100.
        RUN WriteLogMsg("Tables with permissions that are account lists only:" + STRING(listExprCnt) + " (" + STRING(tmpCnt2) +
                   "% of all tables)").
        tmpCnt2 = (fileListExprCnt / fileCnt) * 100.
        RUN WriteLogMsg("Tables with all permissions as account lists only:" + STRING(fileListExprCnt) + " (" + STRING(tmpCnt2) +
                   "% of all tables)").
        tmpCnt2 = (rvkExprCnt / fileCnt) * 100.
        RUN WriteLogMsg("Tables with permissions that revoke accounts (ignored):" + STRING(rvkExprCnt) + " (" + STRING(tmpCnt2) +
                   "% of all tables)").
        RUN WriteLogMsg("Dump and Load permissions cannot be processed by SQL").
        tmpCnt1 = (dumpDfltCnt / fileCnt) * 100.
        tmpCnt2 = (dumpExprCnt / fileCnt) * 100.
        RUN WriteLogMsg("Dump Permissions that are Default permissions: " + STRING(tmpCnt1) + " non-Default permissions: " +
                   STRING(tmpCnt2)).
        tmpCnt2 = subPermTCnt / fileCnt.
        RUN WriteLogMsg("Average number of sub-expressions per table: " + STRING(tmpCnt2)).
        tmpCnt2 = (subPermsThreshCnt / fileCnt) * 100.
        RUN WriteLogMsg("Number of tables with more than " + STRING(subPermThresh) + " sub-expressions: " + STRING(subPermsThreshCnt) +
                " (" + STRING(tmpCnt2) + "% of all tables)").
        tmpCnt2 = (blnkPermCnt / fileCnt) * 100.
        RUN WriteLogMsg("Number of blank user permissions ignored: " + STRING(blnkPermCnt) + " sub-expressions: " +
                " (" + STRING(tmpCnt2) + "% of all tables)").

        RUN WriteLogMsg("End of Summary Statistics about your Permissions").

        IF owrt THEN
        DO:
            RUN WriteLogMsg("Summary Evaluation of Overwrite Changes to Extracted Permissions").
            RUN EvalExtr.
        END.
    END.

END PROCEDURE.

/*
    DEFINE VARIABLE sqlAct AS CHARACTER INIT ?.

    FOR EACH ttPerms WHERE Cmd-Can <> ? AND StateFlag < 2 NO-LOCK:
        RUN WriteLogMsg(Cmd-Can + "~;").
        RUN WriteLogMsg("COMMIT WORK~;").
        ASSIGN StateFlag = 2.
    END.
*/

/*********
FUNCTION RvkChk RETURNS INTEGER (INPUT inPerm AS CHARACTER):
    /* DEFINE INPUT PARAMETER inPerm AS CHARACTER NO-UNDO. */
    DEFINE VARIABLE rvkPos AS INTEGER.

    rvkPos = INDEX(inPerm,"!",1).
    IF rvkPos > 0 THEN DO:
        IF rvkPos > 1 THEN
        DO:
            DISPLAY QUOTER(inChg) + " FILE FORMATTING ERROR: (!) should be first character in entry: " inPerm SKIP.
            RETURN 1.
        END.
        ELSE IF rvoke THEN
        DO:
            ASSIGN canRvokeCnt = canRvokeCnt + 1.
            ASSIGN grtRvk = "REVOKE".
            DISPLAY "Entry: " QUOTER(inPerm) " adds a REVOKE to SQL output" SKIP.
            RETURN 0.
        END.
        ELSE IF eval THEN
        DO:
            ASSIGN rvokeIgnCnt = rvokeIgnCnt + 1.
            DISPLAY "Entry: " QUOTER(inPerm) " ignored because " + QUOTER("revoke") + " parameter not set" SKIP.
            RETURN 2.
        END.
    END.
END FUNCTION.

********/

/* GRANT [SELECT | UPDATE] ON SEQUENCE schema.sequence TO user_name[,user_name]...
   select - allows read data from sequence
   update - allows modify data for sequence
   PSC00338158 - Add WITH GRANT OPTION

   GRANT [SELECT | UPDATE | INSERT | DELETE | ALL] ON <tab> TO [<user1,user2, ...> | PUBLIC ] [WITH GRANT OPTION]
   GRANT [INDEX | (<col1,col2, ...>)] ON <tab> TO <user1,user2, ...> | PUBLIC ] [WITH GRANT OPTION]
   GRANT REFERENCES (<col1,col2, ...>)
*/

FUNCTION FullUserId returns CHAR (id AS CHAR, name AS CHAR):
    if name = "" THEN
        return id.
    ELSE
        return id + "@" + name.
END.

PROCEDURE WriteLogMsg:
    DEFINE INPUT PARAMETER msg AS CHARACTER   NO-UNDO.
    
    PUT STREAM strLog UNFORMATTED STRING(NOW) + " " + msg SKIP.
END PROCEDURE.

PROCEDURE ReadUserTable:
    DEFINE VARIABLE domainType AS CHARACTER   NO-UNDO.
    
    cnt = 0.
    FOR EACH _User WHERE _User._sql-only-user = FALSE:
        sUser = TRIM(_User._Userid).
        IF LENGTH(sUser) = 0 THEN   /* NO Blank User allowed */
            RUN WriteLogMsg("NOTICE: " + "Blank User ID ignored and removed from user list").
        ELSE IF sUser = "" OR UPPER(sUser) = "PUB" OR UPPER(sUser) = "SYSPROGRESS" THEN
            RUN WriteLogMsg("NOTICE: " + "Invalid User ID " + QUOTER(sUser) +
                " ignored and removed from user list").
        ELSE DO:
            domainType = GetDomainType(_User._Domain-Name, FullUserId(_User._Userid, _User._Domain-Name)).
            IF domainType = ? THEN
            DO:
                NEXT.
            END.
            
            cnt = cnt + 1.
            CREATE ttAcct.
            ASSIGN
                ttAcct.Account = FullUserId(_User._Userid,_User._Domain-Name)
                ttAcct.fromUserTable = TRUE
                ttAcct.userName = _User._Userid
                ttAcct.domainName = _User._Domain-Name
                ttAcct.domainType = domainType.
        END.
    END.
    
    IF cnt > 0 THEN
        RUN WriteLogMsg(STRING(cnt) + " accounts provided from the _User table").
    ELSE DO:
        RUN WriteLogMsg("NOTICE: " + "No accounts provided by the _User table. Wildcards will not be resolved from here.").
    END.
END PROCEDURE.

PROCEDURE ReadAccountsFile:
    DEFINE INPUT  PARAMETER inAccts AS CHARACTER   NO-UNDO.
    
    DEFINE VARIABLE acctUserName AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE acctDomainName AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE domainType AS CHARACTER   NO-UNDO.
    
    cnt = 0.
    FILE-INFO:FILE-NAME = inAccts. /* Assume current-working-directory path */
    cDir = FILE-INFO:FULL-PATHNAME.
    IF cDir EQ ? THEN DO:
        RUN WriteLogMsg("NOTICE: " + "No accounts file provided. " +
            QUOTER(inAccts) + " not found.").
    END.
    ELSE DO:
        INPUT FROM VALUE(cDir). /* Last line should be a dot (.) */
        DO WHILE TRUE ON ENDKEY  UNDO, LEAVE:
            IMPORT UNFORMATTED account.
            sUser = TRIM(account).
            
            /* Skip blank lines and comments */
            IF LENGTH(sUser) = 0 OR SUBSTRING(sUser, 1, 1) = "#" THEN    
                NEXT.
            ELSE IF UPPER(sUser) = "PUB" OR UPPER(sUser) = "SYSPROGRESS" THEN
                RUN WriteLogMsg("Warning: Invalid account name " + QUOTER(sUser) + " ignored").
            ELSE DO:
                FIND ttAcct WHERE ttAcct.Account = sUser NO-ERROR.
                IF NOT AVAILABLE(ttAcct) THEN DO:
                    IF INDEX(sUser, "@") > 0 THEN
                    DO:
                        ASSIGN
                            acctUserName = SUBSTRING(sUser, 1, INDEX(sUser, "@") - 1)
                            acctDomainName = SUBSTRING(sUser, INDEX(sUser, "@") + 1).
                    END.
                    ELSE
                    DO:
                        acctUserName = sUser.
                        acctDomainName = "".
                    END.
                
                    /* Skip invalid or disabled domains */
                    domainType = GetDomainType(acctDomainName, sUser).
                    IF domainType = ? THEN
                    DO:
                        NEXT.
                    END.
                    ELSE
                    IF acctDomainName <> "" AND domainType = "_oeusertable" THEN
                    DO:
                        RUN WriteLogMsg("Warning: User " + QUOTER(sUser) + " in accounts file ignored due to being a member of an _oeusertable domain").
                        NEXT.
                    END.
                    
                    cnt = cnt + 1.
                    CREATE ttAcct.
                    ASSIGN
                        ttAcct.Account = sUser
                        ttAcct.fromUserTable = FALSE
                        ttAcct.userName = acctUserName
                        ttAcct.domainName = acctDomainName.
                        ttAcct.domainType = domainType.
                END.
                ELSE
                DO:
                    RUN WriteLogMsg("Warning: Redundant account name " +
                        QUOTER(sUser) + " in " + QUOTER(inAccts) + " ignored").
                END.
            END.
        END.
        INPUT CLOSE.
        
        IF cnt > 0 THEN
            RUN WriteLogMsg(STRING(cnt) + " accounts provided from the " +
                QUOTER(inAccts) + " file").
        ELSE DO:
            RUN WriteLogMsg("NOTICE: " + "No accounts provided by the " +
                QUOTER(inAccts) + " file. Wildcards will not be resolved from here.").
        END.
    END.
END PROCEDURE.    

PROCEDURE ReadSubstitutionFile:
    FILE-INFO:FILE-NAME = inSubs. /* Assume current-working-directory path */
    cDir = FILE-INFO:FULL-PATHNAME.
    IF cDir EQ ? THEN
    DO:
        /* Default to *=PUBLIC */
        CREATE ttSubs.
        ASSIGN ttSubs.subsId = 1
               ttSubs.match = "*"
               ttSubs.repl = "PUBLIC"
               ttSubs.subsType = "full".
        CREATE ttSubs.
        ASSIGN ttSubs.subsId = 2
               ttSubs.match = "!,*"
               ttSubs.repl = "PUBLIC"
               ttSubs.subsType = "full".
    END.
    ELSE DO:
        DEFINE VARIABLE subsId AS INTEGER INITIAL 1 NO-UNDO.
        DEFINE VARIABLE replRow AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE replType AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE replMatch AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE replReplace AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE colonIdx AS INTEGER     NO-UNDO.
        DEFINE VARIABLE equalsIdx AS INTEGER     NO-UNDO.

        RUN WriteLogMsg("Substitutions file " + QUOTER(inSubs) + " found. Reading substitutions.").
        
        INPUT FROM VALUE(cDir).
        REPEAT:
            IMPORT UNFORMATTED replRow.
            replRow = TRIM(replRow).
            
            /* Skip blank lines and comments */
            IF LENGTH(replRow) = 0 OR SUBSTRING(replRow, 1, 1) = "#" THEN    
                NEXT.
                
            colonIdx = INDEX(replRow, ":").
            IF colonIdx > 0 THEN
            DO:
                replType = TRIM(SUBSTRING(replRow, 1, colonIdx - 1)).
                
                IF LOOKUP(replType, "full,entry,text") = 0 THEN
                DO:
                    replType = ?.
                END.
            END.
            ELSE
            DO:
                replType = ?.
            END.

            IF replType = ? THEN
            DO:
                RUN WriteLogMsg("Warning: Invalid substitution type for " +
                    QUOTER(replRow) + " in " + QUOTER(inSubs) + " ignored").
                NEXT.
            END.
            
            equalsIdx = INDEX(replRow, "=", colonIdx).
            IF equalsIdx > 0 THEN
            DO:
                replMatch = TRIM(SUBSTRING(replRow, colonIdx + 1, equalsIdx - colonIdx - 1)).
                replReplace = TRIM(SUBSTRING(replRow, equalsIdx + 1)).
            END.
            ELSE
            DO:
                replMatch = ?.
            END.

            IF replMatch = ? THEN
            DO:
                RUN WriteLogMsg("Warning: Invalid substitution " +
                    QUOTER(replRow) + " in " + QUOTER(inSubs) + " ignored (equals sign not found)").
                NEXT.
            END.

            FIND ttSubs WHERE ttSubs.match = replMatch AND ttSubs.subsType = replType NO-ERROR.
            IF NOT AVAILABLE(ttSubs) THEN 
            DO:
                CREATE ttSubs.
                ASSIGN ttSubs.subsId = subsId
                       ttSubs.match = replMatch
                       ttSubs.repl = replReplace
                       ttSubs.subsType = replType.
                subsId = subsId + 1.
            END.
            ELSE DO:
                RUN WriteLogMsg("Warning: Redundant substitution " +
                    QUOTER(replRow) + " in " + QUOTER(inSubs) + " ignored").
            END.
        END.
        INPUT CLOSE.
    END.
END PROCEDURE.

FUNCTION ConsolidateWildcards RETURNS CHARACTER
    (INPUT inExpr AS CHARACTER) :
    
    DEFINE VARIABLE conIndex AS INTEGER     NO-UNDO.
    DEFINE VARIABLE conEntry AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE notPublic AS LOGICAL INITIAL FALSE    NO-UNDO.

    DO conIndex = 1 TO NUM-ENTRIES(inExpr):
        conEntry = trim(ENTRY(conIndex, inExpr)).
        
        IF conEntry = "!" THEN
            NEXT.
            
        IF conEntry MATCHES "!*" THEN
        DO:
            notPublic = TRUE.
        END.
        
        IF conEntry = "*" THEN
        DO:
            IF notPublic = FALSE THEN
            DO:
                inExpr = "*".
            END.
            
            LEAVE.
        END.
    END.
    
    RETURN inExpr.
END FUNCTION.

FUNCTION GetDomainType RETURNS CHARACTER
    (INPUT inDomain AS CHARACTER,
     INPUT inUser AS CHARACTER) :

    DEFINE VARIABLE domainType AS CHARACTER INITIAL ?  NO-UNDO.
    
    FIND _sec-authentication-domain 
        WHERE _sec-authentication-domain._Domain-name = inDomain NO-ERROR.
    IF AVAILABLE(_sec-authentication-domain) THEN
    DO:
        IF _sec-authentication-domain._Domain-enabled = FALSE THEN
        DO:
            RUN WriteLogMsg("Warning: User " + QUOTER(inUser) + " ignored due to disabled domain " + QUOTER(inDomain)).
        END.
        ELSE
        DO:
            domainType = _sec-authentication-domain._Domain-type.
        END.
    END.
    ELSE
    DO:
        RUN WriteLogMsg("Warning: User " + QUOTER(inUser) + " ignored due to invalid domain " + QUOTER(inDomain)).
    END.

    RETURN domainType.
END FUNCTION.
