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
  File: gsmrlxprts.p

  Description:  Release Export Viewer Super Procedure

  Purpose:      Release Export Viewer Super Procedure

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   09/30/2003  Author:     Bruce S Gruenbaum

  Update Notes: Created from Template rytemcustomsuper.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       gsmrlxprts.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

{dynlaunch.i &define-only = YES}

DEFINE VARIABLE ghStatus  AS HANDLE     NO-UNDO.
DEFINE VARIABLE glCurrent AS LOGICAL    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



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
         HEIGHT             = 18.05
         WIDTH              = 58.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/customsuper.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-DSAPI_StatusUpdate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DSAPI_StatusUpdate Procedure 
PROCEDURE DSAPI_StatusUpdate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcString AS CHARACTER  NO-UNDO.

  SESSION:SET-WAIT-STATE("":U).
  IF VALID-HANDLE(ghStatus) THEN
    ghStatus:SCREEN-VALUE = pcString.
  SESSION:SET-WAIT-STATE("GENERAL":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hideObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE hideObject Procedure 
PROCEDURE hideObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  RUN SUPER.
  
  /* We publish updateState here to reenable the toolbars. */
  PUBLISH "updateState":U FROM TARGET-PROCEDURE ("UPDATECOMPLETE":U).
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
  RUN SUPER.

  SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "DSAPI_StatusUpdate":U ANYWHERE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-OnChoosebtnADOPatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OnChoosebtnADOPatch Procedure 
PROCEDURE OnChoosebtnADOPatch :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFileName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAns      AS LOGICAL    NO-UNDO.

    cFileName = widgetValue("fiADOPatch":U).

    IF SEARCH(cFileName) = ? THEN
      cFileName = "patchlist.xml":U.

    SYSTEM-DIALOG GET-FILE cFileName  
      FILTERS "XML Files (*.xml)":U "*.xml":U,
              "All Files (*.*)":U "*.*":U
      ASK-OVERWRITE
      CREATE-TEST-FILE
      INITIAL-DIR ".":U
      RETURN-TO-START-DIR
      SAVE-AS
      USE-FILENAME
      UPDATE lAns.

    IF lAns THEN
    DO:
      assignWidgetValue("fiADOPatch":U, cFileName).
      assignFocusedWidget("fiADOPatch":U).
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-OnChoosebtnGenerate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OnChoosebtnGenerate Procedure 
PROCEDURE OnChoosebtnGenerate :
/*------------------------------------------------------------------------------
  Purpose:     Invokes the Deployment API to do the release versioning work.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE lGenXML       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lGenADO       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iPatchLevel   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cFromRelease  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cXMLPatch     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOutputDir    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUnspec       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessageList  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lFullDS       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lResetMod     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lGenData      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hFromRelease  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTrash        AS HANDLE     NO-UNDO.

  RUN showMessages IN gshSessionManager (INPUT  {aferrortxt.i 'ICF' '8' '?' '?' '' ''},
                                       INPUT  "QUE":U,
                                       INPUT  "OK,Cancel":U,
                                       INPUT  "OK":U,
                                       INPUT  "OK":U,
                                       INPUT  "Generate Release",
                                       INPUT  YES,
                                       INPUT  TARGET-PROCEDURE,
                                       OUTPUT cButton               ).

  IF cButton <> "OK":U THEN
    RETURN.

  lGenData     = LOGICAL(widgetValue("lVersionData":U)).
  lGenXML      = LOGICAL(widgetValue("lGenXML":U)).
  lGenADO      = LOGICAL(widgetValue("lGenADO":U)).
  lResetMod    = LOGICAL(widgetValue("lResetModified":U)).
  lFullDS      = LOGICAL(widgetValue("lFullDS":U)).
  cOutputDir   = widgetValue("fiOutputDir":U).
  cUnspec      = widgetValue("fiUnspec":U).


  RUN locateWidget IN TARGET-PROCEDURE
    (INPUT "FromRelease":U, OUTPUT hFromRelease, OUTPUT hTrash).
  cFromRelease = DYNAMIC-FUNCTION("getDataValue":U IN hFromRelease).


  IF lGenXML THEN
  DO:
    cXMLPatch    = widgetValue("fiADOPatch":U).
    iPatchLevel  = INTEGER(widgetValue("fiDBPatchLevel":U)).
  END.


  SESSION:SET-WAIT-STATE("GENERAL":U).
  viewWidget("fiStatus":U).
  ghStatus = widgetHandle("fiStatus":U).

  {dynlaunch.i &PLIP     = "'af/app/gscddxmlp.p'"
               &iProc    = "'exportReleaseVersion'"
               &OnApp    = YES
               &AutoKill = YES   
               &mode1  = INPUT  &parm1  = cFromRelease    &dataType1  = CHARACTER
               &mode2  = INPUT  &parm2  = lGenData        &dataType2  = LOGICAL
               &mode3  = INPUT  &parm3  = lResetMod       &dataType3  = LOGICAL
               &mode4  = INPUT  &parm4  = lGenXML         &dataType4  = LOGICAL
               &mode5  = INPUT  &parm5  = lGenADO         &dataType5  = LOGICAL
               &mode6  = INPUT  &parm6  = lFullDS         &dataType6  = LOGICAL
               &mode7  = INPUT  &parm7  = cOutputDir      &dataType7  = CHARACTER
               &mode8  = INPUT  &parm8  = cUnspec         &dataType8  = CHARACTER
               &mode9  = INPUT  &parm9  = cXMLPatch       &dataType9  = CHARACTER
               &mode10 = INPUT  &parm10 = iPatchLevel     &dataType10 = INTEGER
  }
  
  SESSION:SET-WAIT-STATE("":U).
  hideWidget("fiStatus":U).
  ghStatus = ?.
  IF ERROR-STATUS:ERROR 
  OR RETURN-VALUE <> "":U 
  THEN DO:
      ASSIGN cMessageList = RETURN-VALUE.
      IF cMessageList <> "":U THEN
          RUN showMessages IN gshSessionManager (INPUT cMessageList,
                                                 INPUT "ERR":U,
                                                 INPUT "OK":U,
                                                 INPUT "OK":U,
                                                 INPUT "OK":U,
                                                 INPUT "Error",
                                                 INPUT YES,
                                                 INPUT ?,
                                                 OUTPUT cButton).
      RETURN.
  END.
  ELSE
  DO:
    RUN showMessages IN gshSessionManager (INPUT  {aferrortxt.i 'ICF' '9' '?' '?' '' ''},
                                         INPUT  "MES":U,
                                         INPUT  "OK":U,
                                         INPUT  "OK":U,
                                         INPUT  "OK":U,
                                         INPUT  "Release Generation complete",
                                         INPUT  YES,
                                         INPUT  TARGET-PROCEDURE,
                                         OUTPUT cButton               ).
    RETURN.
  END.




END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-OnChoosebtnOutputDir) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OnChoosebtnOutputDir Procedure 
PROCEDURE OnChoosebtnOutputDir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN selectDirectory IN TARGET-PROCEDURE (INPUT "fiOutputDir":U).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-OnChoosebtnUnspec) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OnChoosebtnUnspec Procedure 
PROCEDURE OnChoosebtnUnspec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN selectDirectory IN TARGET-PROCEDURE (INPUT "fiUnspec":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rowDisplay) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowDisplay Procedure 
PROCEDURE rowDisplay :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRootDir            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRelativeSourceDir  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataSource         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cLatestRelease      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dLatestRelease      AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dRowRelObj          AS DECIMAL    NO-UNDO.

  cRootDir = DYNAMIC-FUNCTION("getSessionRootDirectory":U IN THIS-PROCEDURE) NO-ERROR.
  
  /* Get the relative source directory if one is set */
  cRelativeSourceDir = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                              "_scm_relative_source_directory":U) NO-ERROR.                            
  
  ERROR-STATUS:ERROR = NO.
  
  /* If we managed to get a root path from the scm session parameter */
  IF cRootDir <> ? AND 
     cRelativeSourceDir <> ? THEN
  ASSIGN 
    cRootDir = TRIM(cRootDir + "/":U + TRIM(cRelativeSourceDir, "/":U), "/":U)
    . 
  ELSE 
  IF cRootDir <> ? THEN
    ASSIGN 
      FILE-INFO:FILE-NAME = cRootdir
      cRootDir = FILE-INFO:FULL-PATHNAME. 
  
  IF cRootDir = ? THEN
  DO:
    FILE-INFO:FILE-NAME = ".":U.
    cRootDir = FILE-INFO:FULL-PATHNAME.
  END.
  
  cRootDir = REPLACE(cRootDir,"~\":U,"/":U).
  cRootDir = cRootDir + "/":U + LC(widgetValue("release_number":U)).
  
  IF cRootDir <> ? THEN
  DO:
    assignWidgetValue("fiOutputDir":U, cRootDir).
    assignWidgetValue("fiUnspec":U, cRootDir + "/db/icf/dump":U).
    assignWidgetValue("fiADOPatch":U, cRootDir + "/patchlist.xml":U).
  END.

  hDataSource  = DYNAMIC-FUNCTION("getDataSource":U IN TARGET-PROCEDURE).

  dRowRelObj = DECIMAL(DYNAMIC-FUNCTION("columnValue":U IN hDataSource,
                                        "release_obj":U)).
  {dynlaunch.i
    &PLIP     = "'af/app/gscddxmlp.p'"
    &iProc    = "'currentRelease'"
    &OnApp    = YES
    &AutoKill = YES   
    &mode1  = OUTPUT  &parm1  = dLatestRelease    &dataType1  = DECIMAL
    &mode2  = OUTPUT  &parm2  = cLatestRelease    &dataType2  = CHARACTER
    }

  IF dLatestRelease <> 0.0 AND
     dLatestRelease = dRowRelObj THEN
    glCurrent = YES.
  ELSE
    glCurrent = NO.


  RUN setFieldStates IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-selectDirectory) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectDirectory Procedure 
PROCEDURE selectDirectory :
/*------------------------------------------------------------------------------
  Purpose:     Retrieves a directory using the directory lookup dialog and
               writes the value to the widget that is specified in pcWidget.
  Parameters:  
    pcWidget - Widget to apply entry to.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcWidget AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cPath    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lhServer AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE lhFolder AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE lhParent AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE lvFolder AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lvCount  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hContainer   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hWin     AS HANDLE     NO-UNDO.

  hContainer = DYNAMIC-FUNCTION("getContainerSource":U IN TARGET-PROCEDURE).
  hWin       = DYNAMIC-FUNCTION("getWindowFrameHandle":U IN TARGET-PROCEDURE).
  
  CREATE 'Shell.Application' lhServer.
  
  ASSIGN
      lhFolder = lhServer:BrowseForFolder(hWin:HWND,"Directory":U,0).
  
  IF VALID-HANDLE(lhFolder) = True 
  THEN DO:
      ASSIGN 
          lvFolder = lhFolder:Title
          lhParent = lhFolder:ParentFolder
          lvCount  = 0.
      REPEAT:
          IF lvCount >= lhParent:Items:Count THEN
              DO:
                  ASSIGN
                      cPath = "":U.
                  LEAVE.
              END.
          ELSE
              IF lhParent:Items:Item(lvCount):Name = lvFolder THEN
                  DO:
                      ASSIGN
                          cPath = lhParent:Items:Item(lvCount):Path.
                      LEAVE.
                  END.
          ASSIGN lvCount = lvCount + 1.
      END.
  END.
  ELSE
      ASSIGN
          cPath = "":U.
  
  RELEASE OBJECT lhParent NO-ERROR.
  RELEASE OBJECT lhFolder NO-ERROR.
  RELEASE OBJECT lhServer NO-ERROR.
  
  ASSIGN
    lhParent = ?
    lhFolder = ?
    lhServer = ?
    .
  
  ASSIGN cPath = TRIM(REPLACE(LC(cPath),"~\":U,"/":U),"/":U).

  assignWidgetValue(pcWidget, cPath).
  assignFocusedWidget(pcWidget).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldStates) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setFieldStates Procedure 
PROCEDURE setFieldStates :
/*------------------------------------------------------------------------------
  Purpose:     Enables and disables fields on the screen based on the values
               of other fields.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataSource   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCount        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cFieldList    AS CHARACTER  
    INITIAL "lVersionData,lGenXML,lGenADO,FromRelease,lResetModified,lFullDS,fiADOPatch,btnADOPatch,fiDBPatchLevel,fiOutputDir,btnOutputDir,fiUnspec,btnUnspec,btnGenerate":U
    NO-UNDO.
  DEFINE VARIABLE cEnableList   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisableList  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEntry        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hFromRelease  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lVersionData  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lGenXML       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lGenADO       AS LOGICAL    NO-UNDO.
  
  IF glCurrent = ? THEN 
    glCurrent = NO.

  IF NOT glCurrent THEN
  DO:
    cDisableList = cFieldList.
    cEnableList  = "":U.
  END.
  ELSE
  DO:
    cDisableList = "":U.
    cEnableList  = "lGenXML,lGenADO":U.
    lGenXML      = LOGICAL(widgetValue("lGenXML":U)).
    lGenADO      = LOGICAL(widgetValue("lGenADO":U)).

    IF lGenADO OR 
       lGenXML THEN
    DO:
      assignWidgetValue("lVersionData":U, "YES":U).
      lVersionData = YES.
      cDisableList = "lVersionData":U.
    END.
    ELSE
    DO:
      lVersionData = LOGICAL(widgetValue("lVersionData":U)).
      cEnableList = cEnableList + ",lVersionData":U.
    END.

    /* Iterate through the list of the fields that need to be set. */
    DO iCount = 3 TO NUM-ENTRIES(cFieldList):
      cEntry = ENTRY(iCount,cFieldList).
      CASE cEntry:
        WHEN "lResetModified":U THEN
        DO:
          IF lVersionData THEN
            cEnableList = cEnableList + "," + cEntry.
          ELSE
            cDisableList = cDisableList + MIN(cDisableList,",":U) + cEntry.
        END.
        WHEN "lFullDS":U THEN
        DO:
          IF lGenADO THEN
            cEnableList = cEnableList + "," + cEntry.
          ELSE
            cDisableList = cDisableList + MIN(cDisableList,",":U) + cEntry.
        END.
        WHEN "fiADOPatch":U OR 
        WHEN "btnADOPatch":U OR
        WHEN "fiDBPatchLevel":U THEN
        DO:
          IF lGenXML THEN
            cEnableList = cEnableList + "," + cEntry.
          ELSE
            cDisableList = cDisableList + MIN(cDisableList,",":U) + cEntry.
        END.
        WHEN "fiOutputDir":U OR
        WHEN "btnOutputDir":U OR
        WHEN "fiUnspec":U OR
        WHEN "btnUnspec":U OR
        WHEN "FromRelease":U THEN
        DO:
          IF lGenADO OR
             lGenXML THEN
            cEnableList = cEnableList + "," + cEntry.
          ELSE
            cDisableList = cDisableList + MIN(cDisableList,",":U) + cEntry.
        END.
        WHEN "btnGenerate":U THEN
        DO:
          IF lVersionData OR
             lGenXML OR
             lGenADO THEN
            cEnableList = cEnableList + "," + cEntry.
          ELSE
            cDisableList = cDisableList + MIN(cDisableList,",":U) + cEntry.
        END.
      END CASE.
    END.
  END.


  IF cDisableList <> "":U THEN
    disableWidget(cDisableList).
  IF cEnableList <> "":U THEN
    enableWidget(cEnableList).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-viewObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewObject Procedure 
PROCEDURE viewObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  RUN SUPER.

  /* We publish updateState to disable the toolbars. */
  PUBLISH "updateState":U FROM TARGET-PROCEDURE ("UPDATE":U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

