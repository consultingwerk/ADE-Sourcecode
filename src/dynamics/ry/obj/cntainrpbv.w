&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" vTableWin _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" vTableWin _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE RowObject
       {"ry/obj/ryemptysdo.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/*---------------------------------------------------------------------------------
  File: cntainrliv.w

  Description:  Container Links Viewer

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   03/06/2002  Author:     

  Update Notes: Created from Template rysttviewv.w

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       cntainrpbv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{src/adm2/globals.i}

DEFINE VARIABLE gcColumnWidths    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcCurrentSort     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcBaseQuery       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcTitle           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ghContainerSource AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghContainerHandle AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghParentContainer AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghMainBuffer      AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghBrowse          AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghQuery           AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghColumn          AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "ry/obj/ryemptysdo.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getHasData vTableWin 
FUNCTION getHasData RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryHandle vTableWin 
FUNCTION getQueryHandle RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD reopenBrowseQuery vTableWin 
FUNCTION reopenBrowseQuery RETURNS LOGICAL
    (pcSubstituteList AS CHARACTER,
     pdPageObj        AS DECIMAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBrowseSensitive vTableWin 
FUNCTION setBrowseSensitive RETURNS LOGICAL
  (plSensitive AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD transferToExcel vTableWin 
FUNCTION transferToExcel RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1
         SIZE 65 BY 7.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "ry/obj/ryemptysdo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {ry/obj/ryemptysdo.i}
      END-FIELDS.
   END-TABLES.
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW vTableWin ASSIGN
         HEIGHT             = 7
         WIDTH              = 65.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB vTableWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW vTableWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK vTableWin 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects vTableWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE containerTypeChange vTableWin 
PROCEDURE containerTypeChange :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER plDataContainer  AS LOGICAL  NO-UNDO.

  {fnarg evaluateActions 'NoData' ghContainerSource}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createBrowse vTableWin 
PROCEDURE createBrowse :
/*------------------------------------------------------------------------------
  Purpose:     Creates the page browse.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cQueryPrepare AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEntry        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iFieldLoop    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hColumn       AS HANDLE     NO-UNDO EXTENT 3.
  DEFINE VARIABLE hBuffer       AS HANDLE     NO-UNDO.
  
  SESSION:SET-WAIT-STATE("GENERAL":U).

  CREATE QUERY ghQuery.

  ghQuery:SET-BUFFERS(ghMainBuffer).
  
  CREATE BROWSE ghBrowse
  ASSIGN FRAME                  = FRAME {&FRAME-NAME}:HANDLE
         NAME                   = "PageBrowse"
         SEPARATORS             = TRUE
         ROW-MARKERS            = FALSE
         EXPANDABLE             = TRUE
         COLUMN-RESIZABLE       = TRUE
         ALLOW-COLUMN-SEARCHING = TRUE
         QUERY                  = ghQuery
         REFRESHABLE            = YES
  TRIGGERS:            
      ON "VALUE-CHANGED":U  PERSISTENT RUN trgValueChanged  IN THIS-PROCEDURE.
      ON "ROW-DISPLAY":U    PERSISTENT RUN trgRowDisplay    IN THIS-PROCEDURE. 
  END TRIGGERS.

  /*hColumn[1] = ghBrowse:ADD-LIKE-COLUMN(ghMainBuffer:BUFFER-FIELD("i_page_sequence":U)).*/
  hColumn[1] = ghBrowse:ADD-CALC-COLUMN("INTEGER":U, ">9":U , 0, "Page Seq.":U).
  hColumn[2] = ghBrowse:ADD-LIKE-COLUMN(ghMainBuffer:BUFFER-FIELD("c_page_label":U)).
  hColumn[3] = ghBrowse:ADD-LIKE-COLUMN(ghMainBuffer:BUFFER-FIELD("c_security_token":U)).
  hColumn[3]:LABEL = "Security action".
  ghColumn = hColumn[1].
  
  DO iFieldLoop = 1 TO ghBrowse:NUM-COLUMNS:
    cEntry = ENTRY(iFieldLoop, gcColumnWidths, "^":U).

    IF INTEGER(cEntry) <> 0 THEN
      hColumn[iFieldLoop]:WIDTH-PIXELS = INTEGER(cEntry).
  END.

  /* And show the browse to the user */
  ASSIGN
      ghBrowse:SENSITIVE = TRUE
      ghBrowse:VISIBLE   = YES
      gcBaseQuery        = "FOR EACH ttPage":U
                         + "   WHERE ttPage.c_action <> 'D'":U
                         + "     AND ttPage.d_customization_result_obj = '0.00'":U.

  SESSION:SET-WAIT-STATE("":U).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject vTableWin 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEFINE VARIABLE cPreferences  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iColumn       AS INTEGER    NO-UNDO.

  cPreferences = "DefaultSort":U   + "|":U + gcCurrentSort + "|":U
               + "ColumnWidths":U  + "|":U.

  DO iColumn = 1 TO ghBrowse:NUM-COLUMNS:
    cPreferences = cPreferences + STRING(ghBrowse:GET-BROWSE-COLUMN(iColumn):WIDTH-PIXELS) + "^":U.
  END.

  cPreferences = TRIM(cPreferences, "^":U).

  IF VALID-HANDLE(gshProfileManager) THEN
    RUN setProfileData IN gshProfileManager (INPUT "Window":U,        /* Profile type code      */
                                             INPUT "CBuilder":U,      /* Profile code           */
                                             INPUT "PagePreferences", /* Profile data key       */
                                             INPUT ?,                 /* Rowid of profile data  */
                                             INPUT cPreferences,      /* Profile data value     */
                                             INPUT NO,                /* Delete flag            */
                                             INPUT "PER":U).          /* Save flag (permanent)  */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  IF VALID-HANDLE(ghMainBuffer) THEN
    DELETE OBJECT ghMainBuffer.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI vTableWin  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME frMain.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getProfileData vTableWin 
PROCEDURE getProfileData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cPrefs  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iEntry  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE rRowId  AS ROWID      NO-UNDO.

  ASSIGN
      gcColumnWidths  = "0^0^0":U
      gcCurrentSort   = " BY ttPage.i_page_sequence ":U.
  
  IF VALID-HANDLE(gshProfileManager) THEN
    RUN getProfileData IN gshProfileManager (INPUT "Window":U,          /* Profile type code     */
                                             INPUT "CBuilder":U,        /* Profile code          */
                                             INPUT "PagePreferences":U, /* Profile data key      */
                                             INPUT "NO":U,              /* Get next record flag  */
                                             INPUT-OUTPUT rRowid,       /* Rowid of profile data */
                                             OUTPUT cPrefs).            /* Found profile data.   */

  /* --- Preference lookup ---------------------- */ /* --- Preference value assignment ------------------------------------------ */
  iEntry = LOOKUP("ColumnWidths":U,  cPrefs, "|":U). IF iEntry <> 0 THEN gcColumnWidths  = ENTRY(iEntry + 1, cPrefs, "|":U).
  iEntry = LOOKUP("DefaultSort":U,   cPrefs, "|":U). IF iEntry <> 0 THEN gcCurrentSort   = ENTRY(iEntry + 1, cPrefs, "|":U).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject vTableWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {get ContainerSource ghContainerSource}.
  {get ContainerHandle ghContainerHandle ghContainerSource}.
  {get ContainerSource ghParentContainer ghContainerSource}.

  ghMainBuffer = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttPage":U)).

  CREATE BUFFER ghMainBuffer FOR TABLE ghMainBuffer.

  SUBSCRIBE TO "getPageDetails":U      IN ghContainerSource.
  SUBSCRIBE TO "containerTypeChange":U IN ghParentContainer.

  gcTitle = ghContainerHandle:TITLE.

  RUN getProfileData.
  RUN createBrowse.

  RUN SUPER.
  
  /* Code placed here will execute AFTER standard behavior.    */
  RUN resizeObject (INPUT FRAME {&FRAME-NAME}:HEIGHT-CHARS, INPUT FRAME {&FRAME-NAME}:WIDTH-CHARS).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshData vTableWin 
PROCEDURE refreshData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcAction     AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pdObjNumber  AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE cObjectFilename AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE httSmartObject  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httObjectType   AS HANDLE     NO-UNDO.

  ASSIGN
      httSmartObject = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttSmartObject":U))
      httObjectType  = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttObjectType":U)).

  httSmartObject:FIND-FIRST("WHERE d_smartobject_obj <> 0":U).
  httObjectType:FIND-FIRST("WHERE d_object_type_obj = ":U + QUOTER(httSmartObject:BUFFER-FIELD("d_object_type_obj":U):BUFFER-VALUE)) NO-ERROR.
  
  ASSIGN
      cObjectFilename = httSmartObject:BUFFER-FIELD("c_object_filename":U):BUFFER-VALUE
      cObjectFilename = (IF cObjectFilename = "":U OR cObjectFilename = ? THEN "New":U ELSE cObjectFilename)
      cObjectFilename = cObjectFilename + (IF httObjectType:AVAILABLE THEN " (":U + httObjectType:BUFFER-FIELD("c_object_type_code":U):BUFFER-VALUE + ")":U ELSE "":U)

      ghContainerHandle:TITLE = gcTitle + " ":U + cObjectFilename.

  CASE pcAction:
    WHEN "NewData":U THEN
      DYNAMIC-FUNCTION("reopenBrowseQuery":U, "":U, pdObjNumber).

    WHEN "Updated":U THEN
      IF ghQuery:NUM-RESULTS > 0 THEN
        ghBrowse:REFRESH().
  END CASE.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject vTableWin 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdHeight   AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdWidth    AS DECIMAL    NO-UNDO.
  
  DEFINE VARIABLE lResizedObjects   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE dFrameHeight      AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dFrameWidth       AS DECIMAL    NO-UNDO.
  
  HIDE FRAME {&FRAME-NAME}.

  ASSIGN
      dFrameHeight = FRAME {&FRAME-NAME}:HEIGHT-CHARS
      dFrameWidth  = FRAME {&FRAME-NAME}:WIDTH-CHARS.
  
  /* If the height OR width of the frame was made smaller */
  IF pdHeight < dFrameHeight OR
     pdWidth  < dFrameWidth  THEN
  DO:
    /* Just in case the window was made longer or wider, allow for the new length or width */
    IF pdHeight > dFrameHeight THEN FRAME {&FRAME-NAME}:HEIGHT-CHARS = pdHeight.
    IF pdWidth  > dFrameWidth  THEN FRAME {&FRAME-NAME}:WIDTH-CHARS  = pdWidth.
    
    lResizedObjects = TRUE.
    
    RUN resizeViewerObjects (INPUT pdHeight, INPUT pdWidth).
  END.
  
  ASSIGN    
      FRAME {&FRAME-NAME}:HEIGHT-CHARS = pdHeight
      FRAME {&FRAME-NAME}:WIDTH-CHARS  = pdWidth.

  IF lResizedObjects = FALSE THEN
    RUN resizeViewerObjects (INPUT pdHeight, INPUT pdWidth).
  
  VIEW FRAME {&FRAME-NAME}.
  
  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeViewerObjects vTableWin 
PROCEDURE resizeViewerObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdHeight   AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdWidth    AS DECIMAL    NO-UNDO.
  
  IF VALID-HANDLE(ghBrowse) THEN
    ASSIGN
        ghBrowse:ROW          = 1.00
        ghBrowse:COLUMN       = 1.00
        ghBrowse:WIDTH-CHARS  = pdWidth
        ghBrowse:HEIGHT-CHARS = pdHeight - ghBrowse:ROW + 1.00.
  
  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trgRowDisplay vTableWin 
PROCEDURE trgRowDisplay :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  ghColumn:SCREEN-VALUE = STRING(ghQuery:CURRENT-RESULT-ROW - 1).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trgValueChanged vTableWin 
PROCEDURE trgValueChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dPageObj    AS DECIMAL    NO-UNDO.

  IF DYNAMIC-FUNCTION("transferActive":U IN ghParentContainer) = TRUE THEN
    RETURN.

  IF ghMainBuffer:AVAILABLE  = FALSE OR
     ghQuery:NUM-RESULTS    <= 0     THEN
    dPageObj = ?.
  ELSE
  DO:
    ghBrowse:SELECT-FOCUSED-ROW() NO-ERROR.

    dPageObj = ghMainBuffer:BUFFER-FIELD("d_page_obj":U):BUFFER-VALUE.
  END.

  PUBLISH "RowSelected":U FROM THIS-PROCEDURE (INPUT dPageObj, ghQuery:CURRENT-RESULT-ROW - 1).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getHasData vTableWin 
FUNCTION getHasData RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lHasData  AS LOGICAL      NO-UNDO INITIAL FALSE.
  
  IF ghQuery:NUM-RESULTS <> ? AND
     ghQuery:NUM-RESULTS  > 1 THEN
    lHasData = TRUE.
  
  RETURN lHasData.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryHandle vTableWin 
FUNCTION getQueryHandle RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  RETURN ghQuery.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION reopenBrowseQuery vTableWin 
FUNCTION reopenBrowseQuery RETURNS LOGICAL
    (pcSubstituteList AS CHARACTER,
     pdPageObj        AS DECIMAL) :
/*------------------------------------------------------------------------------
  Purpose:  Opens the query for the specified browse.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSubstituteList         AS CHARACTER  NO-UNDO EXTENT 9.
  DEFINE VARIABLE cBaseQuery              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iEntries                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lSuccess                AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE httPage                 AS HANDLE     NO-UNDO.

  /* Make the relevant substitutions. */
  ASSIGN
      dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "CustomizationResultObj":U))
      httPage                 = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttPage":U))
      iEntries                = NUM-ENTRIES(pcSubstituteList, CHR(3)).

  CREATE BUFFER httPage FOR TABLE httPage.

  IF iEntries > 0 THEN ASSIGN cSubstituteList[1] = ENTRY(1, pcSubstituteList, CHR(3)).
  IF iEntries > 1 THEN ASSIGN cSubstituteList[2] = ENTRY(2, pcSubstituteList, CHR(3)).
  IF iEntries > 2 THEN ASSIGN cSubstituteList[3] = ENTRY(3, pcSubstituteList, CHR(3)).
  IF iEntries > 3 THEN ASSIGN cSubstituteList[4] = ENTRY(4, pcSubstituteList, CHR(3)).
  IF iEntries > 4 THEN ASSIGN cSubstituteList[5] = ENTRY(5, pcSubstituteList, CHR(3)).
  IF iEntries > 5 THEN ASSIGN cSubstituteList[6] = ENTRY(6, pcSubstituteList, CHR(3)).
  IF iEntries > 6 THEN ASSIGN cSubstituteList[7] = ENTRY(7, pcSubstituteList, CHR(3)).
  IF iEntries > 7 THEN ASSIGN cSubstituteList[8] = ENTRY(8, pcSubstituteList, CHR(3)).
  IF iEntries > 8 THEN ASSIGN cSubstituteList[9] = ENTRY(9, pcSubstituteList, CHR(3)).

  ASSIGN
    cBaseQuery = SUBSTITUTE(gcBaseQuery,
                            cSubstituteList[1],
                            cSubstituteList[2],
                            cSubstituteList[3],
                            cSubstituteList[4],
                            cSubstituteList[5],
                            cSubstituteList[6],
                            cSubstituteList[7],
                            cSubstituteList[8],
                            cSubstituteList[9])
    cBaseQuery = REPLACE(cBaseQuery, "'0.00'":U, QUOTER(dCustomizationResultObj)).

  /* Always reopen, in case the sort has changed. */
  ghQuery:QUERY-PREPARE(cBaseQuery + gcCurrentSort).

  IF ghQuery:IS-OPEN THEN
     ghQuery:QUERY-CLOSE().

  ghQuery:QUERY-OPEN().

  IF ghContainerHandle = CURRENT-WINDOW THEN
    APPLY "ENTRY":U TO ghBrowse.

  IF ghQuery:NUM-RESULTS > 0 AND
     pdPageObj          <> 0 THEN
  DO:
    httPage:FIND-FIRST("WHERE d_page_obj                 = ":U + QUOTER(pdPageObj)
                      + " AND c_action                  <> 'D'":U
                      + " AND d_customization_result_obj = ":U + QUOTER(dCustomizationResultObj)) NO-ERROR.

    IF httPage:AVAILABLE THEN
      lSuccess = ghQuery:REPOSITION-TO-ROWID(httPage:ROWID) NO-ERROR.

    IF lSuccess = FALSE THEN
      ghBrowse:SELECT-ROW(1).
  END.

  DELETE OBJECT httPage.

  RUN trgValueChanged.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBrowseSensitive vTableWin 
FUNCTION setBrowseSensitive RETURNS LOGICAL
  (plSensitive AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lReturnValue  AS LOGICAL    NO-UNDO INITIAL TRUE.

  IF VALID-HANDLE(ghBrowse) THEN
    ghBrowse:SENSITIVE = plSensitive.
  ELSE
    lReturnValue = FALSE.

  RETURN lReturnValue.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION transferToExcel vTableWin 
FUNCTION transferToExcel RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {fnarg lockWindow TRUE ghContainerSource}.

  RUN transferToExcel IN ghParentContainer (INPUT ghBrowse,
                                            INPUT ghContainerSource).

  {fnarg lockWindow FALSE ghContainerSource}.
  
  ERROR-STATUS:ERROR = FALSE.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

