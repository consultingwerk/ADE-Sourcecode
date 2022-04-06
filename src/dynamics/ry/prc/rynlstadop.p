&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
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
  File: rynlstadop.p

  Description:  NonDB Listed ADOs Procedure

  Purpose:      Super Procedure for rynlstadov

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   12/06/2002  Author:     Chris Koster

  Update Notes: Created from Template rytemplipp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rynlstadop.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

{src/adm2/globals.i}

DEFINE VARIABLE gcAllFieldHandles AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcOutputFilename  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcAllFieldNames   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcScanDirectory   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDumpDirectory   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glDumpModified    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glExcludeDump     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE ghContainerSource AS HANDLE     NO-UNDO.

DEFINE TEMP-TABLE ttFileListing NO-UNDO RCODE-INFORMATION
  FIELD cFullPath         AS CHARACTER
  FIELD cFileName         AS CHARACTER
  FIELD cSmartObject      AS CHARACTER
  INDEX pudx IS UNIQUE PRIMARY cFileName.

DEFINE TEMP-TABLE ttDirectory NO-UNDO
  FIELD cDirPath    AS CHARACTER
  FIELD iStackLevel AS INTEGER
  INDEX pudx IS UNIQUE PRIMARY cDirPath
  INDEX udx  IS UNIQUE         iStackLevel
                               cDirPath.

DEFINE STREAM lsOutput.

&SCOPED-DEFINE dump_suffix db/icf/dump

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getFieldHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFieldHandle Procedure 
FUNCTION getFieldHandle RETURNS HANDLE
  (pcFieldName  AS CHARACTER)  FORWARD.

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
         HEIGHT             = 13.67
         WIDTH              = 49.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/customsuper.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */

{ry/app/ryplipmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-getFolder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFolder Procedure 
PROCEDURE getFolder :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER ipTitle AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER opPath  AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE lhServer AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE lhFolder AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE lhParent AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE lvFolder AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lvCount  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hFrame   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hWin     AS HANDLE     NO-UNDO.

  CREATE 'Shell.Application' lhServer.

  ASSIGN
      hFrame   = DYNAMIC-FUNCTION("getContainerHandle":U IN TARGET-PROCEDURE)
      hWin     = hFrame:WINDOW.
      lhFolder = lhServer:BrowseForFolder(hWin:HWND,ipTitle,0).

  IF VALID-HANDLE(lhFolder) = TRUE THEN
  DO:
    ASSIGN 
        lvFolder = lhFolder:TITLE
        lhParent = lhFolder:ParentFolder
        lvCount  = 0.
      
    REPEAT:
      IF lvCount >= lhParent:Items:COUNT THEN
      DO:
        opPath = "":U.

        LEAVE.
      END.
      ELSE
        IF lhParent:Items:ITEM(lvCount):NAME = lvFolder THEN
        DO:
          opPath = lhParent:Items:ITEM(lvCount):Path.

          LEAVE.
        END.

      lvCount = lvCount + 1.
    END.
  END.
  ELSE
    opPath = "":U.

  RELEASE OBJECT lhParent NO-ERROR.
  RELEASE OBJECT lhFolder NO-ERROR.
  RELEASE OBJECT lhServer NO-ERROR.

  ASSIGN
    lhParent = ?
    lhFolder = ?
    lhServer = ?.

  IF SUBSTRING(opPath,1,2) <> "~\~\":U THEN
    ASSIGN
        opPath = TRIM(REPLACE(LC(opPath),"~\":U,"/":U),"/":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFrameWorkDirectory   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hfiOutputDestination  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hfiDumpDirectory      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hfiScanDirectory      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hchkRecurse           AS HANDLE     NO-UNDO.

  {get ContainerSource ghContainerSource}.
  {get AllFieldHandles gcAllFieldHandles}.
  {get AllFieldNames   gcAllFieldNames}.

  RUN SUPER.

  ASSIGN
      cFrameworkDirectory               = {fnarg getSessionParam '_framework_directory':U gshSessionManager}
      hfiOutputDestination              = DYNAMIC-FUNCTION("getFieldHandle":U IN TARGET-PROCEDURE, "fiOutputDestination":U)
      hfiDumpDirectory                  = DYNAMIC-FUNCTION("getFieldHandle":U IN TARGET-PROCEDURE, "fiDumpDirectory":U)
      hfiScanDirectory                  = DYNAMIC-FUNCTION("getFieldHandle":U IN TARGET-PROCEDURE, "fiScanDirectory":U)
      hchkRecurse                       = DYNAMIC-FUNCTION("getFieldHandle":U IN TARGET-PROCEDURE, "chkRecurse":U)
      hfiOutputDestination:SCREEN-VALUE = REPLACE(cFrameWorkDirectory + "~\temp" + STRING(ETIME) + ".txt":U, "~\":U, "/":U)
      hfiScanDirectory:SCREEN-VALUE     = REPLACE(cFrameWorkDirectory, "~\":U, "/":U)
      hchkRecurse:CHECKED               = TRUE.
  
  RUN trgCheckBoxValueChanged IN TARGET-PROCEDURE ("chkExclude":U).
  RUN trgCheckBoxValueChanged IN TARGET-PROCEDURE ("chkRecurse":U).
  RUN trgFillInValueChanged   IN TARGET-PROCEDURE ("fiOutputDestination":U).
  RUN trgFillInValueChanged   IN TARGET-PROCEDURE ("fiScanDirectory":U).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-killPlip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE killPlip Procedure 
PROCEDURE killPlip :
/*------------------------------------------------------------------------------
  Purpose:     entry point to instantly kill the plip if it should get lost in memory
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipkill.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-objectDescription) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE objectDescription Procedure 
PROCEDURE objectDescription :
/*------------------------------------------------------------------------------
  Purpose:     Pass out a description of the PLIP, used in Plip temp-table
  Parameters:  <none>
  Notes:       This should be changed manually for each plip
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER cDescription AS CHARACTER NO-UNDO.

ASSIGN cDescription = "Dynamics Template PLIP".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipSetup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipSetup Procedure 
PROCEDURE plipSetup :
/*------------------------------------------------------------------------------
  Purpose:    Run by main-block of PLIP at startup of PLIP
  Parameters: <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipsetu.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipShutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown Procedure 
PROCEDURE plipShutdown :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will be run just before the calling program 
               terminates
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipshut.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-recurseDirectory) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recurseDirectory Procedure 
PROCEDURE recurseDirectory :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcDirectory  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plRecurse    AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER piStackLevel AS INTEGER    NO-UNDO.

  DEFINE VARIABLE cSmartObject      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFileName         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRootFile         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFullPath         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFlags            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hfiScanDirectory  AS HANDLE     NO-UNDO.

  DEFINE BUFFER bttFileListing FOR ttFileListing.
  DEFINE BUFFER bttDirectory FOR ttDirectory.

  ASSIGN
      hfiScanDirectory   = DYNAMIC-FUNCTION("getFieldHandle":U IN TARGET-PROCEDURE, "fiScanDirectory":U)
      ERROR-STATUS:ERROR = NO.

  INPUT FROM OS-DIR(pcDirectory).
  IF ERROR-STATUS:ERROR THEN
  DO:
    ERROR-STATUS:ERROR = NO.
    RETURN.
  END.

  REPEAT:
    IMPORT cRootFile
           cFullPath
           cFlags.

    IF cRootFile = ".":U OR
       cRootFile = "..":U THEN
      NEXT.

    IF INDEX(cFlags, "D":U) <> 0 AND
       plRecurse THEN
    DO:
      DO FOR bttDirectory:

        FIND FIRST bttDirectory 
             WHERE bttDirectory.cDirPath = cFullPath NO-ERROR.

        IF NOT AVAILABLE(bttDirectory) THEN
        DO:
          CREATE bttDirectory.
          ASSIGN bttDirectory.cDirPath = cFullPath
                 bttDirectory.iStackLevel = piStackLevel.
        END.
      END.
    END.
    
    IF INDEX(cFlags, "F":U) <> 0 THEN
    DO:
      IF NUM-ENTRIES(cRootFile, ".":U)                          > 1        AND
        (ENTRY(NUM-ENTRIES(cRootFile, ".":U), cRootFile, ".":U) = "ado":U) THEN
      DO:
        DO FOR bttFileListing:
          cFullPath = REPLACE(cFullPath, "~\":U, "/":U).
          
          IF glExcludeDump AND cFullPath BEGINS gcDumpDirectory THEN
            NEXT.
          
          ASSIGN cFileName    = SUBSTRING(cFullPath, R-INDEX(cFullPath, "/":U) + 1)
                 cFullPath    = REPLACE(cFullPath, cFileName, "":U)
                 cSmartObject = SUBSTRING(cFileName, 1, LENGTH(cFilename) - 4).

          FIND FIRST bttFileListing 
               WHERE bttFileListing.cFileName = cFilename NO-ERROR.

          IF NOT AVAILABLE(bttFileListing) THEN
          DO:
            CREATE bttFileListing.
            ASSIGN bttFileListing.cFullPath    = cFullPath
                   bttFileListing.cFileName    = cFileName
                   bttFileListing.cSmartObject = cSmartObject.
          END.
        END.
      END.
    END.
  END.
  INPUT CLOSE.

  IF plRecurse THEN
    FOR EACH bttDirectory
       WHERE bttDirectory.iStackLevel = piStackLevel:
  
      RUN recurseDirectory IN TARGET-PROCEDURE (INPUT bttDirectory.cDirPath,
                                                INPUT YES,
                                                INPUT piStackLevel + 1).

      DELETE bttDirectory.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-trgButtonChoose) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trgButtonChoose Procedure 
PROCEDURE trgButtonChoose :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcButtonName AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cOutputFilename   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cScanDirectory    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDumpDirectory    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDirectoryName    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilename         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDefault          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessage          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButtons          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cString           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCounter          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hfiScanDirectory  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hfiDumpDirectory  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hfiTotalRecords   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hchkRecurse       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hchkExclude       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hedEditor         AS HANDLE     NO-UNDO.

  CASE pcButtonName:
    /* buDump */
    WHEN "buDump":U THEN
    DO:
      IF gcOutputFilename = "":U THEN
        cMessage = {af/sup2/aferrortxt.i 'AF' '5' '?' '?' "'output filename'"}.
      ELSE
        ASSIGN
            cOutputFilename = gcOutputFilename
            cOutputFilename = REPLACE(cOutputFilename, "~\":U, "/":U)
            cFileName       = SUBSTRING(cOutputFilename, R-INDEX(cOutputFilename, "/":U) + 1)
            cDirectoryName  = (IF cFilename = "":U THEN cOutputFilename ELSE REPLACE(cOutputFilename, cFileName, "":U))
            cButtons       = "&OK":U
            cDefault       = "&OK":U.

      /* Check the directory name for validaty */
      IF cMessage = "":U THEN
      DO:
        IF cDirectoryName <> "":U THEN
        DO:
          FILE-INFO:FILE-NAME = cDirectoryName.
  
          IF INDEX(FILE-INFO:FILE-TYPE, "D":U) = 0 OR
             INDEX(FILE-INFO:FILE-TYPE, "D":U) = ? THEN
            cMessage = {af/sup2/aferrortxt.i 'AF' '5' '?' '?' "'directory'"}.
        END.
          ELSE
            cMessage = {af/sup2/aferrortxt.i 'AF' '5' '?' '?' "'directory'"}.
      END.

      /* No errors on the directory name, so check the filename */
      IF cMessage = "":U THEN
      DO:
        IF cFileName <> "":U AND
           cFileName <> ?    THEN
        DO:
          IF INDEX(cFilename, "?":U) <> 0 OR
             INDEX(cFilename, "|":U) <> 0 OR
             INDEX(cFilename, ">":U) <> 0 OR
             INDEX(cFilename, "<":U) <> 0 OR
             INDEX(cFilename, ":":U) <> 0 OR
             INDEX(cFilename, "*":U) <> 0 OR
             INDEX(cFilename, '"':U) <> 0 THEN
            cMessage = {af/sup2/aferrortxt.i 'AF' '5' '?' '?' "'filename'"}.
        END.
        ELSE
          cMessage = {af/sup2/aferrortxt.i 'AF' '5' '?' '?' "'filename'"}.
      END.

      /* Finally check if the file already exists and ask if it should be replaced */
      IF cMessage = "":U THEN
      DO:
        FILE-INFO:FILE-NAME = cOutputFilename.

        IF INDEX(FILE-INFO:FILE-TYPE, "F":U) <> 0 AND
           INDEX(FILE-INFO:FILE-TYPE, "F":U) <> ? THEN
          ASSIGN
              cMessage = "A file already exists with that name (":U + gcOutputFilename + ").":U
                       + CHR(10) + CHR(10) + "Do you want to replace the file contents?":U
              cButtons = "&Yes,&No":U
              cDefault = "&No":U.
      END.

      IF cMessage <> "":U THEN
        RUN showMessages IN gshSessionManager (INPUT  cMessage,                 /* message to display */
                                               INPUT  "INF":U,                  /* error type         */
                                               INPUT  cButtons,                 /* button list        */
                                               INPUT  cDefault,                 /* default button     */ 
                                               INPUT  cDefault,                 /* cancel button      */
                                               INPUT  "Directory not found":U,  /* error window title */
                                               INPUT  YES,                      /* display if empty   */ 
                                               INPUT  TARGET-PROCEDURE,         /* container handle   */ 
                                               OUTPUT cButton).                 /* button pressed     */

      IF cMessage = "":U OR cButton = "&Yes":U THEN
      DO:
        hedEditor = DYNAMIC-FUNCTION("getFieldHandle":U IN TARGET-PROCEDURE, "edEditor":U).
        
        OUTPUT STREAM lsOutput TO VALUE(gcOutputFilename).

        PUT STREAM lsOutput UNFORMATTED hedEditor:SCREEN-VALUE.

        OUTPUT STREAM lsOutput CLOSE.
      END.
    END.
    
    /* buScanDirectory */
    WHEN "buScanDirectory":U THEN
    DO:
      hfiScanDirectory = DYNAMIC-FUNCTION("getFieldHandle":U IN TARGET-PROCEDURE, "fiScanDirectory":U).

      RUN getFolder IN TARGET-PROCEDURE ("Directory", OUTPUT cScanDirectory).

      IF cScanDirectory <> "":U THEN
        ASSIGN
            hfiScanDirectory:SCREEN-VALUE = cScanDirectory.

      APPLY "VALUE-CHANGED":U TO hfiScanDirectory.
      APPLY "ENTRY":U         TO hfiScanDirectory.
    END.

    /* buDumpDirectory */
    WHEN "buDumpDirectory":U THEN
    DO:
      hfiDumpDirectory = DYNAMIC-FUNCTION("getFieldHandle":U IN TARGET-PROCEDURE, "fiDumpDirectory":U).

      RUN getFolder IN TARGET-PROCEDURE ("Directory", OUTPUT cDumpDirectory).

      IF cDumpDirectory <> "":U THEN
        ASSIGN
            hfiDumpDirectory:SCREEN-VALUE = cDumpDirectory.

      APPLY "VALUE-CHANGED":U TO hfiDumpDirectory.
      APPLY "ENTRY":U         TO hfiDumpDirectory.
    END.

    /* buStart */
    WHEN "buStart":U THEN
    DO:
      ASSIGN
          hfiScanDirectory = DYNAMIC-FUNCTION("getFieldHandle":U IN TARGET-PROCEDURE, "fiScanDirectory":U)
          hfiDumpDirectory = DYNAMIC-FUNCTION("getFieldHandle":U IN TARGET-PROCEDURE, "fiDumpDirectory":U)
          hfiTotalRecords  = DYNAMIC-FUNCTION("getFieldHandle":U IN TARGET-PROCEDURE, "fiTotalRecords":U)
          hchkRecurse      = DYNAMIC-FUNCTION("getFieldHandle":U IN TARGET-PROCEDURE, "chkRecurse":U)
          hchkExclude      = DYNAMIC-FUNCTION("getFieldHandle":U IN TARGET-PROCEDURE, "chkExclude":U)
          hedEditor        = DYNAMIC-FUNCTION("getFieldHandle":U IN TARGET-PROCEDURE, "edEditor":U).

      /* Check the Scan Directory Name */
      FILE-INFO:FILE-NAME = hfiScanDirectory:SCREEN-VALUE.
      
      IF INDEX(FILE-INFO:FILE-TYPE, "D":U) = 0 OR 
         INDEX(FILE-INFO:FILE-TYPE, "D":U) = ? THEN
        cMessage = {af/sup2/aferrortxt.i 'AF' '5' '?' '?' "'scan directory'"}.
      
      /* Check the Dump Directory Name */
      IF cMessage = "":U AND glExcludeDump THEN
      DO:
        FILE-INFO:FILE-NAME = hfiDumpDirectory:SCREEN-VALUE.

        IF INDEX(FILE-INFO:FILE-TYPE, "D":U) = 0 OR 
           INDEX(FILE-INFO:FILE-TYPE, "D":U) = ? THEN
          cMessage = {af/sup2/aferrortxt.i 'AF' '5' '?' '?' "'dump directory'"}.
      END.
      
      IF cMessage <> "":U THEN
      DO:
        RUN showMessages IN gshSessionManager (INPUT  cMessage,                 /* message to display */
                                               INPUT  "ERR":U,                  /* error type         */
                                               INPUT  "&OK":U,                  /* button list        */
                                               INPUT  "&OK":U,                  /* default button     */ 
                                               INPUT  "&OK":U,                  /* cancel button      */
                                               INPUT  "Directory not found":U,  /* error window title */
                                               INPUT  YES,                      /* display if empty   */ 
                                               INPUT  TARGET-PROCEDURE,         /* container handle   */ 
                                               OUTPUT cButton).                 /* button pressed     */

        RETURN.
      END.

      ASSIGN
          hedEditor:SCREEN-VALUE       = "":U
          hfiTotalRecords:SCREEN-VALUE = STRING(0).
      
      PROCESS EVENTS.

      SESSION:SET-WAIT-STATE("GENERAL":U).

      EMPTY TEMP-TABLE ttFileListing.
      EMPTY TEMP-TABLE ttDirectory.

      RUN recurseDirectory IN TARGET-PROCEDURE(INPUT hfiScanDirectory:SCREEN-VALUE,
                                               INPUT hchkRecurse:CHECKED,
                                               INPUT 0).

      RUN ry/prc/ryradochkp.p ON gshAstraAppServer (INPUT-OUTPUT TABLE ttFileListing) NO-ERROR.

      IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
      DO:
        RUN showMessages IN gshSessionManager (INPUT  RETURN-VALUE,                       /* message to display */
                                               INPUT  "ERR":U,                            /* error type         */
                                               INPUT  "&OK":U,                            /* button list        */
                                               INPUT  "&OK":U,                            /* default button     */ 
                                               INPUT  "&OK":U,                            /* cancel button      */
                                               INPUT  "Error checking redundant files":U, /* error window title */
                                               INPUT  YES,                                /* display if empty   */ 
                                               INPUT  TARGET-PROCEDURE,                   /* container handle   */ 
                                               OUTPUT cButton).                           /* button pressed     */

        RETURN.
      END.

      FOR EACH ttFileListing:
        ASSIGN
            cString  = cString + (IF cString = "":U THEN "":U ELSE CHR(10))
                     + ttFileListing.cFullPath + ttFileListing.cFilename
            iCounter = iCounter + 1.
      END.

      ASSIGN
          hedEditor:SCREEN-VALUE = cString
          hfiTotalRecords:SCREEN-VALUE = STRING(iCounter).

      SESSION:SET-WAIT-STATE("":U).
    END.
  END CASE.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-trgCheckBoxValueChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trgCheckBoxValueChanged Procedure 
PROCEDURE trgCheckBoxValueChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcCheckBoxName AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hfiScanDirectory  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hfiDumpDirectory  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hbuDumpDirectory  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hCheckBox         AS HANDLE     NO-UNDO.

  ASSIGN
      hfiScanDirectory = DYNAMIC-FUNCTION("getFieldHandle":U IN TARGET-PROCEDURE, "fiScanDirectory":U)
      hfiDumpDirectory = DYNAMIC-FUNCTION("getFieldHandle":U IN TARGET-PROCEDURE, "fiDumpDirectory":U)
      hbuDumpDirectory = DYNAMIC-FUNCTION("getFieldHandle":U IN TARGET-PROCEDURE, "buDumpDirectory":U)
      hCheckBox        = DYNAMIC-FUNCTION("getFieldHandle":U IN TARGET-PROCEDURE, pcCheckBoxName).

  CASE pcCheckBoxName:
    WHEN "chkExclude":U THEN
    DO:
      glExcludeDump = hCheckBox:CHECKED.

      IF NOT glExcludeDump THEN
        ASSIGN
            hfiDumpDirectory:SENSITIVE = FALSE
            hbuDumpDirectory:SENSITIVE = FALSE.
      ELSE
      DO:
        ASSIGN
            hfiDumpDirectory:SENSITIVE = TRUE
            hbuDumpDirectory:SENSITIVE = TRUE.

        IF hfiDumpDirectory:SCREEN-VALUE = "":U THEN
        DO:
          hfiDumpDirectory:SCREEN-VALUE = REPLACE(hfiScanDirectory:SCREEN-VALUE, "~\":U, "/":U).

          IF hfiDumpDirectory:SCREEN-VALUE <> "":U THEN
            hfiDumpDirectory:SCREEN-VALUE = TRIM(hfiDumpDirectory:SCREEN-VALUE)
                                          + (IF SUBSTRING(hfiDumpDirectory:SCREEN-VALUE, LENGTH(hfiDumpDirectory:SCREEN-VALUE), 1) = "/":U THEN "":U ELSE "/":U)
                                          + "{&dump_suffix}":U.

          APPLY "VALUE-CHANGED":U TO hfiDumpDirectory.
        END.
      END.
    END.
  END CASE.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-trgFillInValueChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trgFillInValueChanged Procedure 
PROCEDURE trgFillInValueChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcFieldName  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hfiDumpDirectory  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hfiFieldHandle    AS HANDLE     NO-UNDO.

  ASSIGN
      hfiDumpDirectory = DYNAMIC-FUNCTION("getFieldHandle":U IN TARGET-PROCEDURE, "fiDumpDirectory":U)
      hfiFieldHandle   = DYNAMIC-FUNCTION("getFieldHandle":U IN TARGET-PROCEDURE, pcFieldName).

  CASE pcFieldName:
    WHEN "fiScanDirectory":U THEN
    DO:
      gcScanDirectory = hfiFieldHandle:SCREEN-VALUE.

      IF NOT glDumpModified THEN
      ASSIGN
          hfiDumpDirectory:SCREEN-VALUE = TRIM(REPLACE(gcScanDirectory, "~\":U, "/":U), "/":U) + "/{&dump_suffix}":U
          gcDumpDirectory               = widgetValue('fiDumpDirectory':U).
    END.

    WHEN "fiDumpDirectory":U     THEN
      ASSIGN
          gcDumpDirectory  = hfiFieldHandle:SCREEN-VALUE
          glDumpModified   = TRUE.

    WHEN "fiOutputDestination":U THEN
      gcOutputFilename = hfiFieldHandle:SCREEN-VALUE.
  END CASE.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getFieldHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldHandle Procedure 
FUNCTION getFieldHandle RETURNS HANDLE
  (pcFieldName  AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iEntry        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hFieldHandle  AS HANDLE     NO-UNDO.

  iEntry = LOOKUP(pcFieldName, gcAllFieldNames).
  
  IF iEntry <> 0 THEN
    hFieldHandle = WIDGET-HANDLE(ENTRY(iEntry, gcAllFieldHandles)).

  RETURN hFieldHandle.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

