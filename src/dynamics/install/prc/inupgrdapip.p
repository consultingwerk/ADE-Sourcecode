&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Procedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Procedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*---------------------------------------------------------------------------------
  File: inupgrdapip.p

  Description:  DCU Upgrade API

  Purpose:      DCU Upgrade API

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   08/21/2003  Author:     Bruce S Gruenbaum

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       inupgrdapip.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

DEFINE STREAM sLogFile.

{install/inc/indcuglob.i}
{install/inc/inupgrdtt.i}
{install/inc/inttpatchlist.i}

DEFINE VARIABLE gcLogFile        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glStreamOpen     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE ghSaxParser      AS HANDLE     NO-UNDO.
DEFINE VARIABLE giSeq            AS INTEGER    NO-UNDO.
DEFINE VARIABLE gcSourcePath     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcObjectPath     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSourceDynamics AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcObjectDynamics AS CHARACTER  NO-UNDO.

DEFINE TEMP-TABLE ttPatchLevel RCODE-INFORMATION
  FIELD dPatchLevelObj  AS DECIMAL      LABEL "dNodeNo":U
  FIELD iPatchLevel     AS INTEGER      LABEL "PatchLevel":U
  FIELD dParentObj      AS DECIMAL      LABEL "dParent":U
  INDEX pudx  IS UNIQUE PRIMARY
    dPatchLevelObj
  INDEX udx
    dParentObj
    iPatchLevel
  .

DEFINE TEMP-TABLE ttPatchStage RCODE-INFORMATION
  FIELD dPatchStageObj  AS DECIMAL      LABEL "dNodeNo":U
  FIELD iPatchStage     AS INTEGER   
  FIELD cPatchStage     AS CHARACTER    LABEL "Stage":U
  FIELD dParentObj      AS DECIMAL      LABEL "dParent":U
  INDEX pudx  IS UNIQUE PRIMARY
    dPatchStageObj
  INDEX udx
    dParentObj
    iPatchStage
  .

DEFINE TEMP-TABLE ttPatchProgram RCODE-INFORMATION
  FIELD dPatchProgramObj  AS DECIMAL      LABEL "dNodeNo":U
  FIELD cFileType         AS CHARACTER    LABEL "FileType":U
  FIELD cFileName         AS CHARACTER    FORMAT "X(50)" LABEL "FileName":U
  FIELD cFileDesc         AS CHARACTER    LABEL "Description":U
  FIELD lRerun            AS LOGICAL      LABEL "Rerunnable":U
  FIELD lNewDB            AS LOGICAL      LABEL "NewDB":U
  FIELD lExistingDB       AS LOGICAL      LABEL "ExistingDB":U
  FIELD lMandatory        AS LOGICAL      LABEL "UpdateMandatory":U
  FIELD dParentObj        AS DECIMAL      LABEL "dParent":U
  INDEX pudx  IS UNIQUE PRIMARY
    dPatchProgramObj
  INDEX dx01
    lMandatory
  INDEX udx01
    dParentObj
    dPatchProgramObj
  .

DEFINE TEMP-TABLE ttSiteValue RCODE-INFORMATION
  FIELD cGroup         AS CHARACTER    LABEL "Group":U
  FIELD cVariable      AS CHARACTER    LABEL "Variable":U
  FIELD cValue         AS CHARACTER    LABEL "Value":U
  INDEX pudx IS PRIMARY
    cGroup
    cVariable
  .


DEFINE TEMP-TABLE ttSiteDatabase RCODE-INFORMATION
  FIELD cDBName         AS CHARACTER    LABEL "DBName":U
  FIELD cDBDir          AS CHARACTER    LABEL "DBDir":U
  FIELD cConnectParams  AS CHARACTER    LABEL "ConnectParams":U
  INDEX pudx IS PRIMARY 
    cDBName
  .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-findFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findFile Procedure 
FUNCTION findFile RETURNS CHARACTER
  ( INPUT pcFileName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFieldValue Procedure 
FUNCTION getFieldValue RETURNS CHARACTER
  (INPUT pcGroup    AS CHARACTER,
   INPUT pcVariable AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 26.29
         WIDTH              = 48.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "DCU_SetStatus":U ANYWHERE 
  RUN-PROCEDURE "writeLog":U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-applyPatches) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyPatches Procedure 
PROCEDURE applyPatches :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE BUFFER bttDatabase FOR ttDatabase.
DEFINE BUFFER bttPatch    FOR ttPatch.
DEFINE BUFFER bttPatchList FOR ttPatchList.
DEFINE BUFFER bttService   FOR ttService.

DEFINE VARIABLE cDBPath     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDBFileName AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lOK         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE iResult     AS INTEGER    NO-UNDO.
DEFINE VARIABLE cError      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iCount      AS INTEGER    NO-UNDO.
DEFINE VARIABLE cResponse   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cConnParm   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cPathDelim  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cOtherDelim AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cOutDir     AS CHARACTER  NO-UNDO.
define variable cMigrationSourceBranch as character no-undo.

    /* Get the migration source branch, for migrations */
    cMigrationSourceBranch = {fnarg getSessionParam 'Migration_Source_Branch'}.
    if cMigrationSourceBranch eq ? then cMigrationSourceBranch = "".
    
  /* Now we need to loop through all the databases and apply the updates
     for each of the databases. We need to deal with them in the order
     in which they were listed in the setup.xml file which will be the 
     dDatabaseObj no order. */

  FOR EACH bttDatabase
    BY bttDatabase.dDatabaseObj:
    EMPTY TEMP-TABLE ttPatchLevel.
    EMPTY TEMP-TABLE ttPatchStage.
    EMPTY TEMP-TABLE ttPatchProgram.
    EMPTY TEMP-TABLE ttPatchList.
  
    FOR EACH bttPatch
      WHERE bttPatch.dParentObj = bttDatabase.dDatabaseObj
      BY bttPatch.dParentObj
      BY bttPatch.iPatchLevel:
  
      PUBLISH "DCU_SetStatus":U
        ("Reading patch file " + bttPatch.cNodeURL + "...").
  
      /* Reset the SAX parser */
      RUN resetParser IN ghSaxParser.
    
      /* Associate the buffers with the appropriate nodes */
      /* Patch = ttPatchLevel */
      DYNAMIC-FUNCTION("associateBuffer":U IN ghSaxParser,
                       "Patch":U,                          
                       INPUT BUFFER ttPatchLevel:HANDLE).
    
      /* PatchStage = ttPatchStage */
      DYNAMIC-FUNCTION("associateBuffer":U IN ghSaxParser,
                       "PatchStage":U,                          
                       INPUT BUFFER ttPatchStage:HANDLE).
    
      /* PatchStage = ttPatchStage */
      DYNAMIC-FUNCTION("associateBuffer":U IN ghSaxParser,
                       "Program":U,                          
                       INPUT BUFFER ttPatchProgram:HANDLE).
    
      /* Now read the XML file for this patch */
        /* Now make the parser parse the document into the temp-tables that we
         associated with each node above. */
      RUN parseDocument IN ghSaxParser
        (bttPatch.cNodeURL) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN
        RETURN ERROR RETURN-VALUE.
    END.
  
    PUBLISH "DCU_SetStatus":U
      ("Preparing patch list...").
    /* Now we need to populate the temp-tables in ttPatchList from the data that
       came in through the parse. */
    ASSIGN 
      giSeq = 0
    .
    FOR EACH ttPatchLevel
      BY ttPatchLevel.iPatchLevel:
  
      FOR EACH ttPatchStage
        WHERE ttPatchStage.dParentObj = ttPatchLevel.dPatchLevelObj:
        
        ASSIGN
          ttPatchStage.iPatchStage = LOOKUP(ttPatchStage.cPatchStage,
          "PreDelta,Delta,PostDelta,PreDataLoad,DataLoad,PostDataLoad,PreADOLoad,ADOLoad,PostADOLoad":U)
        .
      END.

      FOR EACH ttPatchStage
        WHERE ttPatchStage.dParentObj = ttPatchLevel.dPatchLevelObj
        BY ttPatchStage.dParentObj
        BY ttPatchStage.iPatchStage
        BY ttPatchStage.dPatchStageObj:
        
        FOR EACH ttPatchProgram
          WHERE ttPatchProgram.dParentObj = ttPatchStage.dPatchStageObj
            AND ttPatchProgram.lNewDB     = bttDatabase.lDBBuild
          BY ttPatchProgram.dParentObj
          BY ttPatchProgram.dPatchProgramObj: 
          
          CREATE bttPatchList.
          ASSIGN
            giSeq                             = giSeq + 1
            bttPatchList.iSeq                 = giSeq
            bttPatchList.cPatchDB             = bttDatabase.cDBName
            bttPatchList.cPatchLevel          = STRING(ttPatchLevel.iPatchLevel,"999999")
            bttPatchList.cStage               = ttPatchStage.cPatchStage
            bttPatchList.iUpdateWhen          = ttPatchStage.iPatchStage
            bttPatchList.cFileType            = ttPatchProgram.cFileType
            bttPatchList.cDescription         = ttPatchProgram.cFileDesc
            bttPatchList.lRerunnable          = ttPatchProgram.lRerun
            bttPatchList.lNewDB               = ttPatchProgram.lNewDB
            bttPatchList.lExistingDB          = ttPatchProgram.lExistingDB
            bttPatchList.lUpdateMandatory     = ttPatchProgram.lMandatory
            bttPatchList.lApplied             = NO
          .
          
          /* Replace #migration_source# token for migration */
          if cMigrationSourceBranch ne "" and index(ttPatchProgram.cFileName, "#":U) gt 0 then
              bttPatchList.cFileName = replace(ttPatchProgram.cFileName,
                                               '#migration_source#', cMigrationSourceBranch ).
          else
              bttPatchList.cFileName = ttPatchProgram.cFileName.
        END. /* FOR EACH ttPatchProgram */
      END. /* FOR EACH ttPatchStage */
    END.  /* FOR EACH ttPatchLevel */

    IF NOT DYNAMIC-FUNCTION("isConnected":U IN THIS-PROCEDURE,
                            bttDatabase.cDBName) THEN
    DO:
      EMPTY TEMP-TABLE bttService. /* There should be nothing in it anyway */
      
      cConnParm = bttDatabase.cConnectParam.

      IF LOOKUP("-db":U, cConnParm, " ":U) = 0 AND
         LOOKUP("-pf":U, cConnParm, " ":U) = 0 THEN
        cConnParm = '-db "':U + bttDatabase.cDBDir + '" ':U + cConnParm.

      CREATE bttService.
      ASSIGN
        bttService.cServiceName = bttDatabase.cDBName
        bttService.cServiceType = "Database":U 
        bttService.cConnectParams = cConnParm
      .
      
      ERROR-STATUS:ERROR = NO.
      
      IF bttDatabase.lDBCreate THEN
      DO:
        PUBLISH "DCU_SetStatus":U
          ("Creating database " + bttDatabase.cDBDir + " ...").

        IF OPSYS = "UNIX":U THEN
          ASSIGN 
            cPathDelim  = "/":U
            cOtherDelim = "~\":U
          .
        ELSE
          ASSIGN 
            cPathDelim  = "~\":U
            cOtherDelim = "/":U
          .

        /*Check that the directory for the db exists. if not create it*/  
        ASSIGN
          cDbFilename = REPLACE(bttDatabase.cDBDir,cOtherDelim,cPathDelim)
          cDbPAth     = SUBSTRING(cDbFilename,1,R-INDEX(cDbFilename,cPathDelim) - 1)
          FILE-INFO:FILE-NAME = cDbPath
          lOk         = TRUE
        .
      
        IF FILE-INFO:FULL-PATHNAME = ? THEN
        DO:
          cOutDir = "":U.
          DO iCount = 1 TO NUM-ENTRIES(cDBPath,cPathDelim):
            cOutDir = cOutDir + (IF cOutDir = "":U THEN "":U ELSE cPathDelim)
                    + ENTRY(iCount,cDBPath,cPathDelim).
            FILE-INFO:FILE-NAME = cOutDir.
            IF FILE-INFO:FULL-PATHNAME = ? THEN
            DO:
              OS-CREATE-DIR VALUE(cOutDir).
              IF OS-ERROR <> 0 THEN
                RETURN ERROR "MSG_cannot_create_path,":U +  cDBPath + "," + STRING(OS-ERROR).
            END.
          END.
        END.
      
        IF SEARCH (cDbFilename) <> ? THEN 
          PUBLISH "DCU_SetStatus":U
            ("Overwriting database " + bttDatabase.cDBDir + " ...").
      
        CREATE DATABASE cDbFileName FROM "EMPTY" REPLACE NO-ERROR.
      
        IF ERROR-STATUS:ERROR THEN
        DO:
          cError = "":U.
          DO iCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
            cError = cError 
                   + (IF cError = "":U THEN "":U ELSE CHR(13))
                   + ERROR-STATUS:GET-MESSAGE(iCount).
          END.
          RETURN ERROR "MSG_DB_creation_failed," + cError.
        END.
      END.
      
      RUN registerService IN THIS-PROCEDURE (INPUT BUFFER bttService:HANDLE)
        NO-ERROR.
      IF ERROR-STATUS:ERROR OR 
        (RETURN-VALUE <> "":U AND
         RETURN-VALUE <> ?) THEN
        RETURN ERROR "MSG_register_service,":U + RETURN-VALUE.
      
      RUN connectService IN THIS-PROCEDURE 
        (bttService.cServiceName, OUTPUT cResponse) NO-ERROR.
      IF ERROR-STATUS:ERROR OR 
        (RETURN-VALUE <> "":U AND
         RETURN-VALUE <> ?) THEN
        RETURN ERROR "MSG_DB_connect_failed,":U + RETURN-VALUE.
    END.

    RUN applyPatchList (bttDatabase.cPathDump) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN
      RETURN ERROR RETURN-VALUE.
    ELSE
    DO:
      /* Now write the contents of the patch list to the user's repository */
      RUN install/prc/inrytupdstatp.p (INPUT TABLE ttPatchList).
    END.

  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-applyPatchList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyPatchList Procedure 
PROCEDURE applyPatchList :
/*------------------------------------------------------------------------------
  Purpose:     This procedure loops through all the records in the ttPatchList
               table and applies the change that the patch requires to the
               database it affects.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcPathDump AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cSiteNo      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCalReverse  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCalDivision AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cFile        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDBTable     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lError       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cMessage     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hICFDBMngr   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSourcePath  AS CHARACTER  NO-UNDO.
  define variable iPatchLevel  as integer no-undo.

  DEFINE BUFFER bttPatchList FOR ttPatchList.


  /* We need to decide what to do with the log file. */
  cSourcePath = getFieldValue("Path":U, "LogFile":U).
  
  hICFDBMngr = DYNAMIC-FUNCTION("getManagerHandle":U IN THIS-PROCEDURE,
                                "ICFDBInstallManager":U).

  /* Loop through all the patches in the patch list.     
     If the update stage > 6 we can't run these updates now. These  are reserved
     for the "In Session" patch runner */
  FOR EACH bttPatchList
    WHERE bttPatchList.iUpdateWhen < 7 
    BREAK BY bttPatchList.cPatchDB
          BY bttPatchList.cPatchLevel
          BY bttPatchList.iUpdateWhen
          BY bttPatchList.iSeq
    ON ERROR UNDO, LEAVE:


    IF FIRST-OF(bttPatchList.cPatchDB) THEN
    DO:
      DELETE ALIAS VALUE("DICTDB":U).
      CREATE ALIAS VALUE("DICTDB":U) FOR DATABASE VALUE(bttPatchList.cPatchDB).
    END.

    IF FIRST-OF(bttPatchList.cPatchLevel) THEN
    do:
      PUBLISH "DCU_SetStatus":U
        (SUBSTITUTE("Updating database &1 to level &2",bttPatchList.cPatchDB,bttPatchList.cPatchLevel)).
        
        iPatchLevel = integer(bttPatchList.cPatchLevel) no-error.
        
        if iPatchLevel gt 0 then
        do:
            run install/prc/inicfdbsqp.p (bttPatchList.cPatchDB, iPatchLevel) /*no-error*/ .
            if error-status:error or return-value ne '':u then
                cMessage = 'Unable to update DB to patch level ' + bttPatchList.cPatchLevel.
        end.    /* patchlevel not 0 */
    end.    /* first of patch level */    

    PUBLISH "DCU_SetStatus":U
      (bttPatchList.cDescription).


    /* If this is not a site number record, there is a file name that we need to find
       in one of the directories. Use the API in the configuration file manager that
       will find the file */
    IF bttPatchList.cFileType <> "s":U THEN
    DO:
      IF bttPatchList.cFileType = "d":U THEN
        cFile = DYNAMIC-FUNCTION("findFile":U IN THIS-PROCEDURE,
                                 bttPatchList.cFileName + "/.":U).
    END.
    
    IF NOT lError THEN
    DO:
      /* Now figure out what to do with this record. */
      CASE bttPatchList.cFileType:
        WHEN "d":U THEN  /* Data load */
        DO:
          RUN prodict/load_d.p (INPUT "ALL":U, pcPathDump) NO-ERROR. 
        END.
        WHEN "df":U THEN /* DF file for database schema */
        DO:
          cFile = DYNAMIC-FUNCTION("findFile":U IN THIS-PROCEDURE,
                                   bttPatchList.cFileName).
          IF SEARCH(cFile) = ? THEN
          DO:
            cMessage = "MSG_file_not_found,":U + bttPatchList.cFileName.
            lError = YES.
          END.
          ELSE
            RUN prodict/load_df.p (INPUT cFile) NO-ERROR.
        END.
        WHEN "p":U THEN /* Procedure to run */
        DO:
          cFile = DYNAMIC-FUNCTION("findFile":U IN THIS-PROCEDURE,
                                   bttPatchList.cFileName).

          IF cFile = ? THEN
          DO:
            cMessage = "MSG_file_not_found,":U + bttPatchList.cFileName.
            lError = YES.
          END.
          ELSE
            RUN VALUE(cFile) NO-ERROR.
        END.
        WHEN "s":U THEN  /* Set the site number */
        DO:
          cFile = ?.
          RUN setSiteNumber IN hICFDBMngr
            (INPUT THIS-PROCEDURE:HANDLE).
        END.                                                  
      END.
      IF ERROR-STATUS:ERROR THEN 
      DO:
        ERROR-STATUS:ERROR = NO.
        lError = YES.
        IF RETURN-VALUE <> ? AND
           RETURN-VALUE <> "":U THEN
          cMessage = RETURN-VALUE.

      END.
      ELSE IF cFile <> ? THEN
      DO:
        PUBLISH "DCU_SetStatus":U
          ("    Full path: " + cFile).
      END.
      IF LAST-OF(bttPatchList.cPatchLevel) THEN
        PUBLISH "DCU_SetStatus":U
          (SUBSTITUTE("Completed updating database &1 to level &2",bttPatchList.cPatchDB,bttPatchList.cPatchLevel)).
    END.

    IF lError THEN
    DO:
      IF NOT bttPatchList.lUpdateMandatory THEN
        PUBLISH "DCU_SetStatus":U
          ("WARNING: " + cMessage).
      ELSE
        RETURN ERROR cMessage.
    END.

    ASSIGN
      bttPatchList.lApplied = YES
    .
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-applyUpgrade) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyUpgrade Procedure 
PROCEDURE applyUpgrade :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is responsible for actually processing the
               parameters that have been received and applies the upgrade to
               the database.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE lError   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cMessage AS CHARACTER  NO-UNDO.

/* We need to decide what to do with the log file. */
gcLogFile = getFieldValue("Path":U, "LogFile":U).
IF gcLogFile = "":U OR 
   gcLogFile = ? THEN
  ASSIGN
    gcLogFile = "dcu.log":U
  .
gcSourcePath = REPLACE(getFieldValue("Path":U, "SrcPath":U),"~\":U,"/":U).
gcObjectPath = REPLACE(getFieldValue("Path":U, "GUIPath":U),"~\":U,"/":U).
IF gcSourcePath = ? THEN
  gcSourcePath = "":U.
IF gcObjectPath = ? THEN
  gcObjectPath = "":U.
RUN findDynamicsSub(gcSourcePath, OUTPUT gcSourceDynamics).
RUN findDynamicsSub(gcObjectPath, OUTPUT gcObjectDynamics).

OUTPUT STREAM sLogFile TO VALUE(gcLogFile) UNBUFFERED KEEP-MESSAGES.  
glStreamOpen = YES.
PUBLISH "DCU_StartStatus":U.
SESSION:SET-WAIT-STATE("GENERAL":U).

RUN writeLog("Starting upgrade.").
RUN writeLog("   Source Path: " + gcSourcePath).
RUN writeLog("   Dynamics Source Path: " + gcSourceDynamics).
RUN writeLog("   Object Path: " + gcObjectPath).
RUN writeLog("   Dynamics Object Path: " + gcObjectDynamics).
RUN writeLog("Starting SAX parser.").

/* Make sure that the SAX parser has been started. */
RUN startProcedure
  ("ONCE|install/prc/insaxparserp.p":U, 
   OUTPUT ghSaxParser) NO-ERROR.

/* We have to return a special message here because we have not loaded the
   message codes from the XML file yet */
IF ERROR-STATUS:ERROR THEN
DO:
  cMessage = "DCUSTARTUPERROR: COULD NOT START SAX PARSER":U.
  lError = YES. 
END.

IF NOT lError THEN
DO:
  RUN applyPatches NO-ERROR.
  IF ERROR-STATUS:ERROR THEN
  DO:
    lError = YES.
    cMessage = RETURN-VALUE.
  END.
END.

SESSION:SET-WAIT-STATE("":U).
PUBLISH "DCU_EndStatus":U.
IF lError THEN
  RUN writeLog("Upgrade failed with error: " + cMessage).
ELSE
  RUN writeLog("Upgrade completed.").

glStreamOpen = NO.
OUTPUT STREAM sLogFile CLOSE.
IF lError THEN
  RETURN ERROR cMessage.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findDynamicsSub) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findDynamicsSub Procedure 
PROCEDURE findDynamicsSub :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcPath   AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcRetVal AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cFile    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAbsPath AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTokens  AS CHARACTER  NO-UNDO.

  pcRetVal = "":U.
  pcPath = REPLACE(pcPath,"~\":U,"/":U).
  IF SUBSTRING(pcPath,LENGTH(pcPath),1) <> "/":U THEN
    pcPath = pcPath + "/":U.

  INPUT FROM OS-DIR(pcPath).
  IF ERROR-STATUS:ERROR THEN
    ERROR-STATUS:ERROR = NO.
  ELSE
  DO:
    REPEAT:
      IMPORT
        cFile
        cAbsPath
        cTokens
      .
      CASE cFile:
        WHEN "dynamics":U OR
        WHEN "icf":U THEN
        DO:
          IF INDEX(cTokens,"D":U) <> 0 THEN
            pcRetVal = pcPath + cFile.
          LEAVE.
        END.
      END CASE.
    END.
    INPUT CLOSE.
  END.

  IF pcRetVal <> "":U AND
     SUBSTRING(pcRetVal,LENGTH(pcRetVal),1) <> "/":U THEN
    pcRetVal = pcRetVal + "/":U.

  RETURN "".   /* Function return value. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pushTempTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pushTempTables Procedure 
PROCEDURE pushTempTables :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is used to pass in the temp-tables so that it is 
               not necessary to write out an XML file and read it in.
               
  Parameters:  <none>
  
  Notes:       This procedure does nothing but return. In so doing the 
               temp-tables are actually copied in here.
               
               Once this procedure has been run, the applyUpgrade procedure
               needs to be run to apply the upgrade.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER TABLE FOR ttValue.
  DEFINE INPUT PARAMETER TABLE FOR ttDatabase.
  DEFINE INPUT PARAMETER TABLE FOR ttPatch.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-readSiteDataXML) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE readSiteDataXML Procedure 
PROCEDURE readSiteDataXML :
/*------------------------------------------------------------------------------
  Purpose:     This code loads the data from the specific SiteDate file and 
               overwrites the contents of the corresponding data in the
               appropriate tables in the upgrade tables.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcSiteDataFile AS CHARACTER  NO-UNDO.

/* First off, make sure that the SAX parser has been started. */
RUN startProcedure
  ("ONCE|install/prc/insaxparserp.p":U, 
   OUTPUT ghSaxParser) NO-ERROR.

IF ERROR-STATUS:ERROR THEN
  RETURN ERROR "DCUSTARTUPERROR: COULD NOT START SAX PARSER":U.

/* Reset the SAX parser */
RUN resetParser IN ghSaxParser.

/* Associate the buffers with the appropriate nodes */
/* TableVariable = ttSiteValue */
DYNAMIC-FUNCTION("associateBuffer":U IN ghSaxParser,
                 "TableVariable":U,                          
                 INPUT BUFFER ttSiteValue:HANDLE).

/* Database = ttSiteDatabase */
DYNAMIC-FUNCTION("associateBuffer":U IN ghSaxParser,
                 "Database":U,                          
                 INPUT BUFFER ttSiteDatabase:HANDLE).


/* Now read the XML file for this patch */
  /* Now make the parser parse the document into the temp-tables that we
   associated with each node above. */
RUN parseDocument IN ghSaxParser
  (pcSiteDataFile) NO-ERROR.
IF ERROR-STATUS:ERROR THEN
  RETURN ERROR RETURN-VALUE.

FOR EACH ttSiteValue:
  FIND FIRST ttValue
    WHERE ttValue.cGroup    = ttSiteValue.cGroup
      AND ttValue.cVariable = ttSiteValue.cVariable 
    NO-ERROR.

  IF NOT AVAILABLE(ttValue) THEN
  DO:
    CREATE ttValue.
    ASSIGN
      ttValue.cGroup    = ttSiteValue.cGroup   
      ttValue.cVariable = ttSiteValue.cVariable
    .
  END.

  ttValue.cValue = ttSiteValue.cValue.
END.

FOR EACH ttSiteDatabase:
  FIND FIRST ttDatabase
    WHERE ttDatabase.cDBName = ttSiteDatabase.cDBName
    NO-ERROR.
  IF AVAILABLE(ttDatabase) THEN
    ASSIGN
      ttDatabase.cDBDir = ttSiteDatabase.cDBDir
      ttDatabase.cConnectParams = ttSiteDatabase.cConnectParams
    .
END.

/* 
OUTPUT TO checkReadSite.txt.
FOR EACH ttSiteValue:
  EXPORT ttSiteValue.
END.
FOR EACH ttSiteDatabase:
  EXPORT ttSiteDatabase.
END.
FOR EACH ttValue:
  EXPORT ttValue.
END.
FOR EACH ttDatabase:
  EXPORT ttDatabase.
END.
FOR EACH ttPatch:
  EXPORT ttPatch.
END.
OUTPUT CLOSE.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-readXMLScript) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE readXMLScript Procedure 
PROCEDURE readXMLScript :
/*------------------------------------------------------------------------------
  Purpose:     This code reads the data written to the XML script file and 
               loads it into the three upgrade temp-tables. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcScriptFile AS CHARACTER  NO-UNDO.

/* First off, make sure that the SAX parser has been started. */
RUN startProcedure
  ("ONCE|install/prc/insaxparserp.p":U, 
   OUTPUT ghSaxParser) NO-ERROR.

IF ERROR-STATUS:ERROR THEN
  RETURN ERROR "DCUSTARTUPERROR: COULD NOT START SAX PARSER":U.

/* Reset the SAX parser */
RUN resetParser IN ghSaxParser.

/* Associate the buffers with the appropriate nodes */
/* TableVariable = ttValue */
DYNAMIC-FUNCTION("associateBuffer":U IN ghSaxParser,
                 "TableVariable":U,                          
                 INPUT BUFFER ttValue:HANDLE).

/* Database = ttDatabase */
DYNAMIC-FUNCTION("associateBuffer":U IN ghSaxParser,
                 "Database":U,                          
                 INPUT BUFFER ttDatabase:HANDLE).

/* Patch = ttPatch */
DYNAMIC-FUNCTION("associateBuffer":U IN ghSaxParser,
                 "Patch":U,                          
                 INPUT BUFFER ttPatch:HANDLE).

/* Now read the XML file for this patch */
  /* Now make the parser parse the document into the temp-tables that we
   associated with each node above. */
RUN parseDocument IN ghSaxParser
  (pcScriptFile) NO-ERROR.
IF ERROR-STATUS:ERROR THEN
  RETURN ERROR RETURN-VALUE.

/*
OUTPUT TO checkReadScript.txt.
FOR EACH ttValue:
  EXPORT ttValue.
END.
FOR EACH ttDatabase:
  EXPORT ttDatabase.
END.
FOR EACH ttPatch:
  EXPORT ttPatch.
END.
OUTPUT CLOSE.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeLog) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE writeLog Procedure 
PROCEDURE writeLog :
/*------------------------------------------------------------------------------
  Purpose:     Writes data to the log file.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcStatus AS CHARACTER  NO-UNDO.

  IF glStreamOpen THEN
  DO:
    pcStatus = "[":U + STRING(TODAY,"99/99/9999":U) + " ":U + STRING(TIME,"HH:MM:SS":U) + "]  ":U
            + pcStatus.
    PUT STREAM sLogFile UNFORMATTED
      pcStatus SKIP.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-zzdbg_showPatches) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE zzdbg_showPatches Procedure 
PROCEDURE zzdbg_showPatches :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcLogFile AS CHARACTER  NO-UNDO.

  OUTPUT TO VALUE(pcLogFile).
  FOR EACH ttPatchLevel:
    DISPLAY
      "*PatchLevel".
    DISPLAY 
      ttPatchLevel
      WITH WIDTH 254 DOWN NO-LABEL NO-BOX STREAM-IO.
    DOWN.
    FOR EACH ttPatchStage
      WHERE ttPatchStage.dParentObj = ttPatchLevel.dPatchLevelObj:
      DISPLAY
        "**PatchStage".
      DISPLAY 
        ttPatchStage
        WITH WIDTH 254 DOWN NO-LABEL NO-BOX STREAM-IO.
      DOWN.
      FOR EACH ttPatchProgram
        WHERE ttPatchProgram.dParentObj = ttPatchStage.dPatchStageObj:
        DISPLAY
          "**PatchProgram".
        DISPLAY 
          ttPatchProgram
          WITH WIDTH 254 DOWN NO-LABEL NO-BOX STREAM-IO.
        DOWN.
      END.
    END.
  END.
  FOR EACH ttPatchList:
    DISPLAY
      "*PatchList".
    DISPLAY 
      ttPatchList
      WITH WIDTH 254 DOWN NO-LABEL NO-BOX STREAM-IO.
    DOWN.
  END.
  OUTPUT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-findFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findFile Procedure 
FUNCTION findFile RETURNS CHARACTER
  ( INPUT pcFileName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a file name and searches for it in the following order:
            1) Search the propath
            2) Look for it in gcObjectPath, gcObjectDynamics
            3) Look for it in gcSourcePath, gcSourceDynamics
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRetVal     AS CHARACTER  INITIAL ? NO-UNDO.
  DEFINE VARIABLE cCheckExt   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPaths      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSearchPath AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cEntry      AS CHARACTER  NO-UNDO.

  cPaths = gcObjectPath + CHR(3) + gcObjectDynamics + CHR(3) + gcSourcePath + CHR(3) + gcSourceDynamics.

  /* Make sure all paths end with a "/" */
  DO iCount = 1 TO NUM-ENTRIES(cPaths,CHR(3)):
    cEntry = ENTRY(iCount,cPaths,CHR(3)).
    cEntry = REPLACE(cEntry,"~\":U,"/":U).
    IF SUBSTRING(cEntry,LENGTH(cEntry)) <> "/":U THEN
      cEntry = cEntry + "/":U.
    cSearchPath = cSearchPath + (IF cSearchPath = "":U THEN "":U ELSE CHR(3))
                + cEntry.
  END.

  /* If this is a .p, see if we can find the r-code first. */
  cCheckExt = SUBSTRING(pcFileName,LENGTH(pcFileName) - 1).
  IF cCheckExt  = ".p":U OR
     cCheckExt  = ".w":U THEN
  DO:
    cCheckExt = SUBSTRING(pcFileName,1,LENGTH(pcFileName) - 2) + ".r":U.
    IF cRetVal = ? THEN
      cRetVal = SEARCH(cCheckExt).
    DO iCount = 1 TO NUM-ENTRIES(cSearchPath,CHR(3)) 
       WHILE cRetVal = ?:
      cRetVal = SEARCH(ENTRY(iCount,cSearchPath,CHR(3)) + cCheckExt).
    END.
  END.

  IF cRetVal = ? THEN
  DO iCount = 1 TO NUM-ENTRIES(cSearchPath,CHR(3)) 
     WHILE cRetVal = ?:
    cRetVal = SEARCH(ENTRY(iCount,cSearchPath,CHR(3)) + pcFileName).
  END.
    
  RETURN cRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldValue Procedure 
FUNCTION getFieldValue RETURNS CHARACTER
  (INPUT pcGroup    AS CHARACTER,
   INPUT pcVariable AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Finds the ttValue record that contains the appropriate value.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttValue FOR ttValue.
      
  FIND FIRST bttValue 
    WHERE bttValue.cGroup    = pcGroup
      AND bttValue.cVariable = pcVariable
    NO-ERROR.
  IF NOT AVAILABLE(bttValue) THEN
    RETURN ?.
  ELSE
    RETURN bttValue.cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

