&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: rydcuplipp.p

  Description:  Dynamics Configuration Plip

  Purpose:      Contains the internal procedures used by the Dynamics configuration utility
                for installation

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   11/14/2001  Author:     

  Update Notes: Created from Template rytemplipp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rydcyplipp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

{afglobals.i}

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.
DEFINE VARIABLE ghUIUtil            AS HANDLE     NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

DEFINE VARIABLE gcFolderList  AS CHARACTER  NO-UNDO.

DEFINE STREAM sPatchFile.
DEFINE STREAM sLogFile.
DEFINE STREAM sInput.

DEFINE TEMP-TABLE ttConfigFile
    FIELD ConfigType    AS CHARACTER
    FIELD ConfigAction  AS CHARACTER.

DEFINE TEMP-TABLE ttValue NO-UNDO
  FIELD cGroup         AS CHARACTER
  FIELD cVariable      AS CHARACTER
  FIELD cValue         AS CHARACTER
  INDEX pudx IS UNIQUE PRIMARY
    cGroup
    cVariable
  .

DEFINE TEMP-TABLE ttPatchFile
  FIELD ttLine        AS CHARACTER
  FIELD ttAction      AS CHARACTER
  FIELD ttFileName    AS CHARACTER
  FIELD ttDescription AS CHARACTER
  INDEX ttMain AS PRIMARY ttLine.

{install/inc/indcuerr.i}

PROCEDURE SHGetPathFromIDListA EXTERNAL "shell32.dll":
  DEFINE INPUT PARAMETER  pidl       AS  LONG.
  DEFINE OUTPUT PARAMETER pszPath    AS  CHARACTER.
  DEFINE RETURN PARAMETER iResult    AS  LONG. 
END.
       
PROCEDURE SHGetSpecialFolderLocation EXTERNAL "shell32.dll":
  DEFINE INPUT  PARAMETER  hwndOwner  AS  LONG.
  DEFINE INPUT  PARAMETER  nFolder    AS  LONG.
  DEFINE OUTPUT PARAMETER  pidl       AS  LONG.
  DEFINE RETURN PARAMETER  iResult    AS  LONG.
END.

PROCEDURE CoTaskMemFree              EXTERNAL "ole32.dll":
  DEFINE INPUT PARAMETER  pidl       AS  LONG.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-addPath) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addPath Procedure 
FUNCTION addPath RETURNS CHARACTER
  ( INPUT pcPath AS CHARACTER,
    INPUT pcFile AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSpecialFolder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSpecialFolder Procedure 
FUNCTION getSpecialFolder RETURNS CHARACTER
  ( INPUT iFolderType  AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainDBVersionNo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD obtainDBVersionNo Procedure 
FUNCTION obtainDBVersionNo RETURNS CHARACTER
  ( INPUT pclDBName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUIUtilHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setUIUtilHandle Procedure 
FUNCTION setUIUtilHandle RETURNS LOGICAL
  ( INPUT phUIUtil AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateStatus) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD updateStatus Procedure 
FUNCTION updateStatus RETURNS LOGICAL
  ( INPUT pcVerb        AS CHARACTER,
    INPUT pcPatchFile   AS CHARACTER,
    INPUT pcLine        AS CHARACTER,
    INPUT pcDescription AS CHARACTER)  FORWARD.

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
         HEIGHT             = 16.33
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

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
DEFINE INPUT PARAMETER TABLE FOR ttValue.

DEFINE VARIABLE cIcfPath     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDlcPath     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSrcPath     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cWrkPath     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLogFile     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop        AS INTEGER    NO-UNDO.
DEFINE VARIABLE cListValue   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lCreate      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cDBList      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDBsToSetup  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDBsToCreate AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDB          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iCount       AS INTEGER    NO-UNDO.
DEFINE VARIABLE cValue       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cPathDump    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cPathDF      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cPathSeq     AS CHARACTER  NO-UNDO.

DEFINE BUFFER bbValue FOR ttValue.

  /* Set up a comma separated list of database to be created and
     setup. */

  cDBList = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                             "dbs_to_setup":U).

  DO iCount = 1 TO NUM-ENTRIES(cDBList):
    cDB    = ENTRY(iCount, cDBList).
    cValue = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                             "Setup":U + cDB).
    IF cValue = "YES":U THEN
    DO:
      ASSIGN
        cDBsToSetup = cDBsToSetup 
                    + (IF cDBsToSetup = "":U THEN "":U ELSE ",":U)
                    + cDB.
      cValue = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                "create":U + cDB).
      IF cValue = "YES":U THEN
        ASSIGN
          cDBsToCreate = cDBsToCreate 
                      + (IF cDBsToCreate = "":U THEN "":U ELSE ",":U)
                      + cDB.

    END.
  END.

  FIND ttValue NO-LOCK
    WHERE ttValue.cGroup    = "PATH":U 
    AND   ttValue.cVariable = "InstallPath" NO-ERROR.
  IF AVAILABLE ttValue  THEN
      ASSIGN cIcfPath = TRIM(ttValue.cValue).

  FIND ttValue NO-LOCK
    WHERE ttValue.cGroup    = "PATH":U 
    AND   ttValue.cVariable = "SrcPath" NO-ERROR.
  IF AVAILABLE ttValue  THEN
      ASSIGN cSrcPath = TRIM(ttValue.cValue).

  FIND ttValue NO-LOCK
    WHERE ttValue.cGroup    = "PATH":U 
    AND   ttValue.cVariable = "ProgressPath" NO-ERROR.
  IF AVAILABLE ttValue  THEN
      ASSIGN cDlcPath = TRIM(ttValue.cValue).

  FIND ttValue NO-LOCK
    WHERE ttValue.cGroup    = "PATH":U 
    AND   ttValue.cVariable = "WorkPath" NO-ERROR.
  IF AVAILABLE ttValue  THEN
      ASSIGN cWrkPath = TRIM(ttValue.cValue).
  
  REPEAT iCount = 1 TO NUM-ENTRIES(cDBsToSetup):
    cDB = ENTRY(iCount,cDBsToSetup).
    cPathDump = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                 "path_":U + cDB + "_dump":U).
    cPathDF   = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                 "path_":U + cDB + "_dfd":U).
    cPathSeq  = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                 "path_":U + cDB + "_seq":U).

    CREATE ALIAS "DICTDB":U FOR DATABASE VALUE(cDB).
    IF CAN-DO(cDBsToCreate,cDB) THEN
    DO:
      RUN prodict/load_df.p (INPUT addPath(cPathDF,cDB + "full.df":U)) NO-ERROR.
      {install/inc/indcuerr.i &LOGFILE=YES}
      RUN prodict/load_d.p (INPUT "ALL", INPUT cPathDump) NO-ERROR.
      {install/inc/indcuerr.i &LOGFILE=YES}
      RUN setSeqValues(INPUT cDB, INPUT cPathSeq) NO-ERROR.
      {install/inc/indcuerr.i &LOGFILE=YES}

      /*Set Site number*/
      FOR EACH ttValue NO-LOCK
        WHERE ttValue.cGroup = cDB
          AND ttValue.cVariable = "SiteNo":U:
        RUN setSiteNumber(INPUT cDB, INPUT INTEGER(ttValue.cValue)) NO-ERROR.
        {install/inc/indcuerr.i}
      END.
    END.
    ELSE
    DO:
      FOR EACH ttValue NO-LOCK
        WHERE ttValue.cGroup = cDB
          AND ttValue.cVariable BEGINS "PatchList":U:
      
        DO iLoop = 1 TO NUM-ENTRIES(ttValue.cValue,CHR(3)):
      
          ASSIGN
            cListValue = ENTRY(iloop,ttValue.cValue,CHR(3))
            cLogFile   = REPLACE(cListValue,".pfl":U,".log":U)
            lCreate    = CAN-DO(cDBsToCreate,ttValue.cGroup)
          .    
          OUTPUT STREAM sLogFile TO VALUE(cLogFile).
          PUT STREAM sLogFile UNFORMATTED
            SUBSTITUTE("*** Processing patch &1. &2 &3",cListValue,STRING(TODAY,"99/99/9999"),STRING(TIME,"HH:mm:ss")) SKIP.
      
          RUN readPatchFile (INPUT cDB = "ICFDB":U, 
                             INPUT cSrcPath, 
                             INPUT cListValue, 
                             INPUT lCreate) NO-ERROR.
      
          {install/inc/indcuerr.i &LOGFILE=YES}
          PUT STREAM sLogFile UNFORMATTED
            SUBSTITUTE("*** Completed patch &1. &2 &3",cListValue,STRING(TODAY,"99/99/9999"),STRING(TIME,"HH:mm:ss")) SKIP.
          OUTPUT STREAM sLogFile CLOSE.
        END.
      END.
    END.

    DELETE ALIAS "DICTDB":U.
  END.


/*
  /*Create the shortcut*/
  RUN createShortCuts
    (INPUT cDlcPath,
     INPUT cIcfPath,
     INPUT cWrkPath) NO-ERROR.
  {install/inc/indcuerr.i}
  */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createShortCut) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createShortCut Procedure 
PROCEDURE createShortCut :
/*------------------------------------------------------------------------------
  Purpose:     Creates a shortcut in the specified path
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER ipLocation AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER ipTarget   AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER ipArgument AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER ipWorking  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER ipIcon     AS CHARACTER NO-UNDO.

DEFINE VARIABLE lhShell    AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE lhShortcut AS COM-HANDLE NO-UNDO.

IF NOT VALID-HANDLE(lhShell) THEN
DO:

  CREATE "WScript.Shell" lhShell NO-ERROR.
  IF VALID-HANDLE(lhShell) THEN
  DO:
  
    ASSIGN 
      lhShortcut                  = lhShell:CreateShortcut(ipLocation)
      lhShortcut:TargetPath       = lhShell:ExpandEnvironmentStrings(ipTarget)
      lhShortcut:Arguments        = lhShell:ExpandEnvironmentStrings(ipArgument)
      lhShortcut:WorkingDirectory = lhShell:ExpandEnvironmentStrings(ipWorking)
      lhShortcut:IconLocation     = lhShell:ExpandEnvironmentStrings(ipIcon)
      lhShortcut:WindowStyle      = 4.
    
    lhShortcut:SAVE.
  
  END.

END.

RELEASE OBJECT lhShell NO-ERROR.
RELEASE OBJECT lhShortcut NO-ERROR.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createShortCuts) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createShortCuts Procedure 
PROCEDURE createShortCuts :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcDLCPath  AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcICFPath  AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcWrkPath  AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cStartMenuPath AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDynamicsPath  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDynamicsParm  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cStatus        AS CHARACTER  NO-UNDO.

  ASSIGN
    cStartMenuPath = GetSpecialFolder(11)
    cDynamicsPath  = addPath(cStartMenuPath,"Programs\Progress Dynamics")
    cDynamicsParm  = " -p icfstart.p -pf icf.pf -ini " + pcIcfPath + "\bin\icf.ini"
    .

  OS-COMMAND SILENT NO-CONSOLE VALUE('mkdir "' + cDynamicsPath + '"').

  RUN CreateShortCut(
    cDynamicsPath + "\Dynamics Runtime.lnk",
    pcDlcPath + "\bin\prowin32.exe ",
    cDynamicsParm,
    pcWrkPath,
    pcICFPath + "\gui\adeicon\icfrt.ico").

  RUN CreateShortCut(
    cDynamicsPath + "\Dynamics Runtime Appserver.lnk",
    pcDlcPath + "\bin\prowin32.exe ",
    cDynamicsParm + "  -icfparam ICFSESSTYPE=ICFRuntime ",
    pcWrkPath,
    pcICFPath + "\gui\adeicon\icfrt.ico").

  RUN CreateShortCut(
    cDynamicsPath + "\Dynamics Development.lnk",
    pcDlcPath + "\bin\prowin32.exe ",
    cDynamicsParm + "  -icfparam ICFSESSTYPE=ICFDev ",
    pcWrkPath,
    pcICFPath + "\gui\adeicon\icdev.ico").

  RUN CreateShortCut(
    cDynamicsPath + "\Dynamics Development Appserver.lnk",
    pcDlcPath + "\bin\prowin32.exe ",
    cDynamicsParm + "  -icfparam ICFSESSTYPE=ICFDevAS ",
    pcWrkPath,
    pcICFPath + "\gui\adeicon\icfdevas.ico").

  RUN CreateShortCut(
    cDynamicsPath + "\Dynamics Configuration Utility.lnk",
    pcDlcPath + "\bin\prowin32.exe ",
    " -ini " + pcICFPath + "\bin\icf.ini -p icfcfg.w -icfparam DCUSETUPTYPE=POSSESetup ",
    pcWrkPath,
    pcICFPath + "\gui\adeicon\icfrt.ico").

  RUN CreateShortCut(
    cDynamicsPath + "\Dynamics Database Startup.lnk",
    pcICFPath + "\bin\startdbs.bat",
    "",
    pcWrkPath,
    pcICFPath + "\gui\adeicon\startdbs.ico").

  RUN CreateShortCut(
    cDynamicsPath + "\Dynamics Database Shutdown.lnk",
    pcICFPath + "\bin\stopdbs.bat",
    "",
    pcWrkPath,
    pcICFPath + "\gui\adeicon\stopdbs.ico").

  RUN CreateShortCut(
    cDynamicsPath + "\Dynamics Config File.lnk",
    pcICFPath + "\showcfg.exe",
    "",
    pcWrkPath,
    pcICFPath + "\gui\adeicon\progress.ico").

  ASSIGN
    cStatus = SUBSTITUTE("Createded shortcuts in &1":U,cDynamicsPath).

  PUBLISH "updateStatus":U FROM THIS-PROCEDURE (INPUT cStatus).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDlcVersion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDlcVersion Procedure 
PROCEDURE getDlcVersion :
/*------------------------------------------------------------------------------
  Purpose:     Returns the Progress patch version found in the progress version file
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcDlcPath    AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcDlcVersion AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcPrgVersion AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cVersionFile AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cPrgVersion  AS CHARACTER  NO-UNDO.

cVersionFile = addPath(pcDlcPath,"version":U).

IF SEARCH(cVersionFile) = ? THEN
  RETURN ERROR "No Progress version file found in " + pcdlcPath.

INPUT STREAM sInput THROUGH VALUE("quoter ":U + cVersionFile).

  IMPORT STREAM sInput cPrgVersion.

INPUT STREAM sInput CLOSE.

IF LOOKUP("version":U,cPrgVersion," ":U) > 0 THEN
  ASSIGN
    pcDlcVersion = ENTRY(1 + LOOKUP("version":U,cPrgVersion," ":U),cPrgVersion," ":U)
    pcPrgVersion = cPrgVersion.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFolderTree) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFolderTree Procedure 
PROCEDURE getFolderTree :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER pcStartFolder AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cFolderTree AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFolderList AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEntry      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cType       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop       AS INTEGER    NO-UNDO.

INPUT STREAM sInput FROM OS-DIR(pcStartFolder).
REPEAT:
    IMPORT STREAM sInput 
        cEntry
        ^
        cType.
    IF cType = "D":U AND cEntry <> ".":U AND cEntry <> "..":U THEN DO:
      ASSIGN
        cFolderTree = cFolderTree + CHR(3) WHEN cFolderTree <> "":U
        cFolderTree = cFolderTree + addPath(pcStartFolder,cEntry).

    END.
END.
INPUT STREAM sInput CLOSE.

IF cFolderTree <> "":U THEN DO:
    DO iLoop = 1 TO NUM-ENTRIES(cFolderTree,CHR(3)):
      IF ENTRY(iLoop,cFolderTree,CHR(3)) MATCHES "*dfd":U THEN
        ASSIGN 
          gcFolderList = gcFolderList + CHR(3) WHEN gcFolderList <> "":U
          gcFolderList = gcFolderList + ENTRY(iLoop,cFolderTree,CHR(3)).

      RUN getFolderTree(ENTRY(iLoop,cFolderTree,CHR(3))).
    END.               
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPatchFiles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPatchFiles Procedure 
PROCEDURE getPatchFiles :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pclDBName     AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcStartFolder AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcFileList    AS CHARACTER  NO-UNDO.

DEFINE VARIABLE iLoop AS INTEGER    NO-UNDO.
DEFINE VARIABLE cEntry      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFullName   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cType       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cVersion    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFileVersion AS CHARACTER  NO-UNDO.

/* First figure out what the current database version number is */
  cVersion = obtainDBVersionNo(pclDBName).

  INPUT STREAM sInput FROM OS-DIR(pcStartFolder).
  REPEAT:
      IMPORT STREAM sInput 
          cEntry
          cFullName
          cType.
      IF cType = "F" AND cEntry MATCHES "*.pfl" THEN
      DO:
        /* Shorten the file name to only contain the actual file */
        cFileVersion = REPLACE(cFullName,pcStartFolder,"":U).
        IF SUBSTRING(cFileVersion,1,1) = "/":U OR
           SUBSTRING(cFileVersion,1,1) = "~\":U THEN
          cFileVersion = SUBSTRING(cFileVersion,2).

        /* Retrieve the version number of the patch file from the file name.
           We're assuming a format of ldbname + version(6 characters) + whatever */ 
        cFileVersion = SUBSTRING(cFileVersion,LENGTH(pclDBName) + 1,6).

        /* If the version number of the file is less than the version number of 
           the database, ignore it. */
        IF INTEGER(cFileVersion) <= INTEGER(cVersion) THEN
          NEXT.
        
        ASSIGN
          pcFileList = pcFileList + CHR(3) WHEN pcFileList <> "":U
          pcFileList = pcFileList + cFullName
        .
      END.
  END.
  INPUT STREAM sInput CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-killManagers) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE killManagers Procedure 
PROCEDURE killManagers :
/*------------------------------------------------------------------------------
  Purpose:     Shuts down the managers.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
    /* Shutdown the ICF managers */
  IF VALID-HANDLE(gshGenManager)          THEN 
    APPLY "CLOSE":U TO gshGenManager.
  IF VALID-HANDLE(gshTranslationManager)  THEN 
    APPLY "CLOSE":U TO gshTranslationManager.
  IF VALID-HANDLE(gshRepositoryManager)   THEN 
    APPLY "CLOSE":U TO gshRepositoryManager.
  IF VALID-HANDLE(gshProfileManager)      THEN 
    APPLY "CLOSE":U TO gshProfileManager.
  IF VALID-HANDLE(gshSecurityManager)     THEN 
    APPLY "CLOSE":U TO gshSecurityManager.
  IF VALID-HANDLE(gshSessionManager)      THEN 
    APPLY "CLOSE":U TO gshSessionManager.

  DELETE ALIAS AFDB.
  DELETE ALIAS ASDB.
  DELETE ALIAS RYDB.

  ERROR-STATUS:ERROR = NO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-readPatchFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE readPatchFile Procedure 
PROCEDURE readPatchFile :
/*------------------------------------------------------------------------------
  Purpose:     Reads the appropriate patch file and executes the desired behaviour
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER plStartManagers AS LOGICAL    NO-UNDO.
DEFINE INPUT  PARAMETER pcPatchPath AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcPatchFile AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER plCreate    AS LOGICAL    NO-UNDO.

  IF SEARCH(pcPatchFile) = ? THEN
    RETURN ERROR SUBSTITUTE("ERROR: The patch file &1 could not be located",pcPatchFile).
  
  EMPTY TEMP-TABLE ttPatchFile.
  
  INPUT STREAM sPatchFile FROM VALUE(pcPatchFile) NO-ECHO.
    REPEAT:
      CREATE ttPatchFile.
      IMPORT STREAM sPatchFile ttPatchFile.
    END.
  INPUT STREAM sPatchFile CLOSE.

  FOR EACH ttPatchFile NO-LOCK:

    IF TRIM(ttPatchFile.ttAction) > "":U THEN
    DO:
        updateStatus(INPUT "Start",INPUT pcPatchFile,INPUT ttPatchFile.ttLine,INPUT ttPatchFile.ttDescription).
        CASE ttPatchFile.ttAction:
          WHEN "CLI" THEN DO:
            IF plStartManagers THEN
              RUN startManagers.
            RUN VALUE(addPath(pcPatchPath,ttPatchFile.ttFilename)) NO-ERROR.
            RUN killManagers.
            {install/inc/indcuerr.i &LOGFILE=YES}
          END.
          WHEN "SRV" THEN DO:
            IF plStartManagers THEN
              RUN startManagers.
            RUN VALUE(addPath(pcPatchPath,ttPatchFile.ttFilename)) NO-ERROR.
            RUN killManagers.
            {install/inc/indcuerr.i &LOGFILE=YES}
          END.
          WHEN "DFD" THEN DO:
            RUN prodict\load_df.p (INPUT addPath(pcPatchPath,ttPatchFile.ttFilename)) NO-ERROR.
            {install/inc/indcuerr.i &LOGFILE=YES}
          END.
          WHEN "DAT" THEN DO:
            RUN prodict\load_d.p (INPUT "ALL", INPUT addPath(pcPatchPath,ttPatchFile.ttFilename)) NO-ERROR.
            {install/inc/indcuerr.i &LOGFILE=YES}
          END.
          WHEN "NEW" THEN DO:
            IF plCreate THEN DO:
              RUN prodict\load_d.p (INPUT "ALL", INPUT addPath(pcPatchPath,ttPatchFile.ttFilename)) NO-ERROR.
              {install/inc/indcuerr.i &LOGFILE=YES}
            END.
          END.
        END CASE.
        updateStatus(INPUT "Done ",INPUT pcPatchFile,INPUT ttPatchFile.ttLine,INPUT ttPatchFile.ttDescription).
        PROCESS EVENTS.
    END.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSeqValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSeqValues Procedure 
PROCEDURE setSeqValues :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcDBName     AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER cSeqFilename AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cStatus  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSeqFile AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSeqPath AS CHARACTER  NO-UNDO.

ASSIGN
  cSeqFileName = REPLACE(cSeqFileName,"/":U,"~\":U)
  cSeqFile = ENTRY(NUM-ENTRIES(cSeqFileName,"~\":U),cSeqFileName,"~\":U)
  cSeqPath = REPLACE(cSeqFilename,cSeqFile,"":U).

  RUN prodict/load_d.p (INPUT "SOME", INPUT cSeqFileName) NO-ERROR.
  {install/inc/indcuerr.i}

  ASSIGN
    cStatus = SUBSTITUTE("Loaded Sequence values from &1":U,cSeqFilename).

  PUBLISH "updateStatus":U FROM THIS-PROCEDURE (INPUT cStatus).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSiteNumber) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSiteNumber Procedure 
PROCEDURE setSiteNumber :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcDbName     AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER piSiteNumber AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cCalReverseICF  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCalDivisionICF AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop           AS INTEGER    NO-UNDO.
DEFINE VARIABLE cStatus         AS CHARACTER  NO-UNDO.
  
  DO iLoop = LENGTH(STRING(piSiteNumber)) TO 1 BY -1:
    cCalReverseICF = cCalReverseICF + SUBSTRING(STRING(piSiteNumber),iLoop,1).
  END.
  
  ASSIGN
    cCalDivisionICF   = "1":U + FILL("0":U,LENGTH(STRING(piSiteNumber)))
    .

  RUN VALUE("install/prc/in":U + pcDBName + "sitep.p":U)
      (INPUT cCalReverseICF,INPUT cCalDivisionICF) NO-ERROR. 
  
/*  RUN install/prc/indcuseqp.p(INPUT pcDbName, INPUT cCalReverseICF,INPUT cCalDivisionICF) NO-ERROR. */
  {install/inc/indcuerr.i}

  ASSIGN
    cStatus = SUBSTITUTE("Updated Site Numbers in &1 to &2":U,pcDbName,STRING(piSiteNumber)).
  PUBLISH "updateStatus":U FROM THIS-PROCEDURE (INPUT cStatus).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-startManagers) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startManagers Procedure 
PROCEDURE startManagers :
/*------------------------------------------------------------------------------
  Purpose:     Initializes the environment to start the managers.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  CREATE ALIAS AFDB           FOR DATABASE VALUE("ICFDB":U).
  CREATE ALIAS ASDB           FOR DATABASE VALUE("ICFDB":U).
  CREATE ALIAS RYDB           FOR DATABASE VALUE("ICFDB":U).

  RUN af/app/afsessrvrp.p PERSISTENT SET gshSessionManager.
  RUN af/app/afgensrvrp.p PERSISTENT SET gshGenManager.
  RUN af/app/afprosrvrp.p PERSISTENT SET gshProfileManager.
  RUN ry/app/ryrepsrvrp.p PERSISTENT SET gshRepositoryManager. 
  RUN af/app/afsecsrvrp.p PERSISTENT SET gshSecurityManager.
  RUN af/app/aftrnsrvrp.p PERSISTENT SET gshTranslationManager.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-addPath) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addPath Procedure 
FUNCTION addPath RETURNS CHARACTER
  ( INPUT pcPath AS CHARACTER,
    INPUT pcFile AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cReturn AS CHARACTER  NO-UNDO.

    ASSIGN
        pcPath = TRIM(pcPath)
        pcFile = TRIM(pcFile).

    IF NOT CAN-DO("\,/",SUBSTRING(pcPath,LENGTH(pcPath),1)) AND 
       NOT CAN-DO("\,/",SUBSTRING(pcFile,1,1)) THEN
       cReturn = TRIM(pcPath + "\":U + pcFile).
    ELSE
       cReturn = TRIM(pcPath + pcFile).

    RETURN REPLACE(REPLACE(cReturn,"\\":U,"\":U),"//":U,"/":U).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSpecialFolder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSpecialFolder Procedure 
FUNCTION getSpecialFolder RETURNS CHARACTER
  ( INPUT iFolderType  AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE iResult AS INTEGER    NO-UNDO.
DEFINE VARIABLE cPath   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iProcId AS INTEGER    NO-UNDO.
DEFINE VARIABLE hWin    AS WIDGET-HANDLE NO-UNDO.

  CREATE WINDOW hWin.

  /* set the iProcId with the specified folder item */
  RUN SHGetSpecialFolderLocation( INPUT hWin:HWND,
                                  INPUT iFolderType,
                                  OUTPUT iProcId,
                                  OUTPUT iResult).
  ASSIGN
    cPath = fill(' ', 260).

  IF iResult = 0 THEN DO:  
    RUN SHGetPathFromIDListA(INPUT iProcId,
                             OUTPUT cPath,
                             OUTPUT iResult).
                             
    /* free memory back to os */
    RUN CoTaskMemFree(INPUT iProcId).
    IF VALID-HANDLE(hWin) THEN DELETE WIDGET hWin.
    
    /* if successful, iResult will be greater then 0 */
    /* return path with a trailing slash appended */
    IF iResult > 0 THEN 
      RETURN TRIM(cPath) + '\':U.
  END. 

  IF VALID-HANDLE(hWin) THEN DELETE WIDGET hWin.

  /* if we get here we encounterd an error so return nothing for path */
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainDBVersionNo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION obtainDBVersionNo Procedure 
FUNCTION obtainDBVersionNo RETURNS CHARACTER
  ( INPUT pclDBName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Determines the version number from the database sequences.
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hQuery   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hVersion AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cQuery   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cVersion AS CHARACTER  NO-UNDO.

  CREATE BUFFER hBuffer FOR TABLE pclDBName + "._sequence":U.

  hVersion = hBuffer:BUFFER-FIELD("_seq-max":U).

  cQuery = "FOR EACH _Sequence WHERE _Sequence._Seq-name = 'seq_":U 
         + pclDBName 
         + "_DBVersion' NO-LOCK":U.

  CREATE QUERY hQuery.

  hQuery:ADD-BUFFER(hBuffer).
  hQuery:QUERY-PREPARE(cQuery).
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST().

  IF NOT hQuery:QUERY-OFF-END THEN
    cVersion = STRING(hVersion:BUFFER-VALUE,"999999":U).
  ELSE
    cVersion = "000000":U.

  hQuery:QUERY-CLOSE().
  DELETE OBJECT hQuery.
  DELETE OBJECT hBuffer.
 
  RETURN cVersion.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUIUtilHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setUIUtilHandle Procedure 
FUNCTION setUIUtilHandle RETURNS LOGICAL
  ( INPUT phUIUtil AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  ghUIUtil = phUIUtil.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateStatus) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION updateStatus Procedure 
FUNCTION updateStatus RETURNS LOGICAL
  ( INPUT pcVerb        AS CHARACTER,
    INPUT pcPatchFile   AS CHARACTER,
    INPUT pcLine        AS CHARACTER,
    INPUT pcDescription AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Updates the processing status bar and information in the schema
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cLogFile AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cStatus  AS CHARACTER  NO-UNDO.

  IF TRIM(pcLine) <> "":U THEN DO:

    ASSIGN
      cLogFile = REPLACE(pcPatchFile,".pfl":U,".log:U")
      cStatus  = SUBSTITUTE("&1: Line &2 (&3) in &4",pcVerb,pcLine,pcDescription,pcPatchFile).

    PUBLISH "updateStatus":U FROM THIS-PROCEDURE (INPUT cStatus).

    PUT STREAM sLogFile UNFORMATTED
      cStatus SKIP.

  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

