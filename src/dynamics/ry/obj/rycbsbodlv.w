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
  File: rycbsbodlv.w

  Description:  SBO DataLogicProcedure Generator Viewer

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   03/21/2003  Author:     

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

&scop object-name       rycbsbodlv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{src/adm2/globals.i}
{src/adm2/widgetprto.i}

DEFINE VARIABLE gcObjectFilename  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcRelativePaths   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gdSmartobjectObj  AS DECIMAL    NO-UNDO.
DEFINE VARIABLE ghContainerSource AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghParentContainer AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghDesignManager   AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghProcLib         AS HANDLE     NO-UNDO.

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

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiRootFolder buLookupDirectory ~
toCreateMissing coDataLogicObjectType fiLPRelativePath fiLPSuffix ~
fiLPTemplateName fiDataLogicProcedure buGenerate fiLabel rctBorder 
&Scoped-Define DISPLAYED-OBJECTS fiRootFolder toCreateMissing ~
coDataLogicObjectType fiLPRelativePath fiLPSuffix fiLPTemplateName ~
fiDataLogicProcedure toOnDisk toInRepository fiLabel 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD evaluateButton vTableWin 
FUNCTION evaluateButton RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSBODetails vTableWin 
FUNCTION getSBODetails RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAttribute vTableWin 
FUNCTION setAttribute RETURNS LOGICAL
  (pcAttribute AS CHARACTER,
   pcValue     AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD stripRelativePath vTableWin 
FUNCTION stripRelativePath RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE hProductModule AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buGenerate 
     LABEL "&Generate" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buLookupDirectory 
     IMAGE-UP FILE "ry/img/view.gif":U
     LABEL "..." 
     SIZE 4.4 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE coDataLogicObjectType AS CHARACTER FORMAT "X(256)":U 
     LABEL "Object type" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 59.6 BY 1 TOOLTIP "The class to which the DataLogic Procedure Objects belong." NO-UNDO.

DEFINE VARIABLE fiDataLogicProcedure AS CHARACTER FORMAT "X(256)":U 
     LABEL "Procedure" 
     VIEW-AS FILL-IN 
     SIZE 59.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiLabel AS CHARACTER FORMAT "X(256)":U INITIAL " Data Logic Procedure details" 
      VIEW-AS TEXT 
     SIZE 29.4 BY .62 NO-UNDO.

DEFINE VARIABLE fiLPRelativePath AS CHARACTER FORMAT "X(35)":U 
     LABEL "Relative path" 
     VIEW-AS FILL-IN 
     SIZE 59.6 BY 1 TOOLTIP "The path to the root directory where the Logic procedure is to be stored" NO-UNDO.

DEFINE VARIABLE fiLPSuffix AS CHARACTER FORMAT "X(35)":U 
     LABEL "Name suffix" 
     VIEW-AS FILL-IN 
     SIZE 59.6 BY 1 TOOLTIP "This suffix is used with the table entity to create the Logic Procedure name" NO-UNDO.

DEFINE VARIABLE fiLPTemplateName AS CHARACTER FORMAT "X(35)":U 
     LABEL "Template" 
     VIEW-AS FILL-IN 
     SIZE 59.6 BY 1 TOOLTIP "The name of a data logic procedure to be used as a template." NO-UNDO.

DEFINE VARIABLE fiRootFolder AS CHARACTER FORMAT "X(70)":U 
     LABEL "Root folder" 
     VIEW-AS FILL-IN 
     SIZE 54.8 BY 1 TOOLTIP "The root directory for any static objects to be created on the server." NO-UNDO.

DEFINE RECTANGLE rctBorder
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 80 BY 10.48.

DEFINE VARIABLE toCreateMissing AS LOGICAL INITIAL yes 
     LABEL "Create missing folders relative to the root directory ?" 
     VIEW-AS TOGGLE-BOX
     SIZE 53.6 BY .81 TOOLTIP "Create any folder relative to the root directory?" NO-UNDO.

DEFINE VARIABLE toInRepository AS LOGICAL INITIAL no 
     LABEL "Exists in repository" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .81 TOOLTIP "Indicates if the procedure is registered in the Repository" NO-UNDO.

DEFINE VARIABLE toOnDisk AS LOGICAL INITIAL no 
     LABEL "Exists on disk" 
     VIEW-AS TOGGLE-BOX
     SIZE 28.8 BY .81 TOOLTIP "Indicates if the procedure exists on disk" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     fiRootFolder AT ROW 2.05 COL 17.4 COLON-ALIGNED
     buLookupDirectory AT ROW 2.05 COL 74.6
     toCreateMissing AT ROW 3.19 COL 19.8
     coDataLogicObjectType AT ROW 4.14 COL 17.4 COLON-ALIGNED
     fiLPRelativePath AT ROW 6.24 COL 17.4 COLON-ALIGNED
     fiLPSuffix AT ROW 7.29 COL 17.4 COLON-ALIGNED
     fiLPTemplateName AT ROW 8.33 COL 17.4 COLON-ALIGNED
     fiDataLogicProcedure AT ROW 9.38 COL 17.4 COLON-ALIGNED
     toOnDisk AT ROW 10.62 COL 19.8
     toInRepository AT ROW 10.62 COL 49
     buGenerate AT ROW 12.1 COL 63.8
     fiLabel AT ROW 1 COL 2.8 NO-LABEL
     rctBorder AT ROW 1.29 COL 1.4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Compile into: 
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
         HEIGHT             = 12.24
         WIDTH              = 80.6.
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

ASSIGN 
       coDataLogicObjectType:PRIVATE-DATA IN FRAME frMain     = 
                "LP-OBJECT-TYPE".

ASSIGN 
       fiDataLogicProcedure:READ-ONLY IN FRAME frMain        = TRUE.

/* SETTINGS FOR FILL-IN fiLabel IN FRAME frMain
   ALIGN-L                                                              */
ASSIGN 
       fiLPRelativePath:PRIVATE-DATA IN FRAME frMain     = 
                "LP-PATH".

ASSIGN 
       fiLPSuffix:PRIVATE-DATA IN FRAME frMain     = 
                "LP-SUFFIX".

ASSIGN 
       fiLPTemplateName:PRIVATE-DATA IN FRAME frMain     = 
                "LP-TEMPLATE".

ASSIGN 
       fiRootFolder:PRIVATE-DATA IN FRAME frMain     = 
                "ROOT-FOLDER".

ASSIGN 
       toCreateMissing:PRIVATE-DATA IN FRAME frMain     = 
                "CREATE-MISSING-FOLDER".

/* SETTINGS FOR TOGGLE-BOX toInRepository IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX toOnDisk IN FRAME frMain
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME buGenerate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buGenerate vTableWin
ON CHOOSE OF buGenerate IN FRAME frMain /* Generate */
DO:
  RUN generateProcedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buLookupDirectory
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buLookupDirectory vTableWin
ON CHOOSE OF buLookupDirectory IN FRAME frMain /* ... */
DO:

  DEFINE VARIABLE cFolderName         AS CHARACTER            NO-UNDO.

  ASSIGN
    cFolderName = fiRootFolder:SCREEN-VALUE.

  RUN getFolderName ( INPUT-OUTPUT cFolderName ) NO-ERROR.

  IF ERROR-STATUS:ERROR
  THEN
    ASSIGN
      SELF:SENSITIVE = NO.
  ELSE
    ASSIGN
      fiRootFolder:SCREEN-VALUE = cFolderName.

  APPLY "LEAVE":U TO fiRootFolder.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiLPRelativePath
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiLPRelativePath vTableWin
ON VALUE-CHANGED OF fiLPRelativePath IN FRAME frMain /* Relative path */
DO:
  {fn evaluateButton}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiLPSuffix
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiLPSuffix vTableWin
ON VALUE-CHANGED OF fiLPSuffix IN FRAME frMain /* Name suffix */
DO:
  {fn evaluateButton}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiRootFolder
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiRootFolder vTableWin
ON LEAVE OF fiRootFolder IN FRAME frMain /* Root folder */
DO:
    DEFINE VARIABLE cFileType           AS CHARACTER                    NO-UNDO.

    ASSIGN cFileType = DYNAMIC-FUNCTION("detectFileType":U, INPUT fiRootFOlder:SCREEN-VALUE).

    IF CAN-DO("D,X":U, cFileType) THEN
        ASSIGN fiRootFOlder:SCREEN-VALUE = TRIM(REPLACE(fiRootFOlder:SCREEN-VALUE,"~\":U,"/":U),"/":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

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
  DEFINE VARIABLE currentPage  AS INTEGER NO-UNDO.

  ASSIGN currentPage = getCurrentPage().

  CASE currentPage: 

    WHEN 0 THEN DO:
       RUN constructObject (
             INPUT  'adm2/dyncombo.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_product_module.product_module_code,gsc_product_module.product_module_description,gsc_product_module.relative_pathKeyFieldgsc_product_module.product_module_codeFieldLabelProduct moduleFieldTooltipSelect the preferred Product Module for Data Logic ProceduresKeyFormatX(35)KeyDatatypecharacterDisplayFormatX(256)DisplayDatatypeCHARACTERBaseQueryStringFOR EACH gsc_product_module
                     WHERE [&FilterSet=|&EntityList=GSCPM] NO-LOCK BY gsc_product_module.product_module_code INDEXED-REPOSITIONQueryTablesgsc_product_moduleSDFFileNameSDFTemplateParentFieldParentFilterQueryDescSubstitute&1 ( &2 )|&3ComboDelimiterListItemPairsInnerLines5ComboFlagFlagValueBuildSequence1SecurednoCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesFieldNamefiCharDisplayFieldyesEnableFieldyesLocalFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hProductModule ).
       RUN repositionObject IN hProductModule ( 5.19 , 19.40 ) NO-ERROR.
       RUN resizeObject IN hProductModule ( 1.00 , 59.60 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( hProductModule ,
             coDataLogicObjectType:HANDLE IN FRAME frMain , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE comboValueChanged vTableWin 
PROCEDURE comboValueChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcKeyFieldValue  AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcScreenValue    AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER phField          AS HANDLE     NO-UNDO.

  DEFINE VARIABLE hCombo  AS HANDLE   NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    IF phField = hProductModule THEN
      ASSIGN
          hCombo                        = {fn getComboHandle hProductModule}
          fiLPRelativePath:SCREEN-VALUE = ENTRY(INTEGER(LOOKUP(pcKeyFieldValue, hCombo:LIST-ITEM-PAIRS, hCombo:DELIMITER) / 2), gcRelativePaths).
  END.
  
  {fn evaluateButton}.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateProcedure vTableWin 
PROCEDURE generateProcedure :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cLogicProcedureTemplate AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataLogicRelativePath  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLogicProcedureName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLogicObjectType        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cIncludeFileList        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataObjectNames        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProcedureName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProductModule          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessageType            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cResultCode             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRootFolder             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTableList              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessage                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lCreateMissingFolder    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iCounter                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hSDO                    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSBO                    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDataInstanceNames      AS CHARACTER  NO-UNDO.

  /* This procedure can only be called once the SBO has been saved */

  RUN startDataObject IN gshRepositoryManager (INPUT gcObjectFilename, OUTPUT hSBO).
  
  RUN getSDOInformation (INPUT  hSBO,
                         OUTPUT cTableList,
                         OUTPUT cIncludeFileList).

  cDataInstanceNames = {fn getDataObjectNames hSBO}.
 
 
  RUN destroyObject IN hSBO.
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        cProductModule          = {fn getDataValue hProductModule}
        cResultCode             = "":U
        cLogicProcedureName     = gcObjectFilename + fiLPSuffix:SCREEN-VALUE
        cLogicObjectType        = coDataLogicObjectType:SCREEN-VALUE
        cLogicProcedureTemplate = fiLPTemplateName:SCREEN-VALUE
        cDataLogicRelativePath  = fiLPRelativePath:SCREEN-VALUE
        cRootFolder             = fiRootFolder:SCREEN-VALUE
        lCreateMissingFolder    = toCreateMissing:CHECKED
        cProcedureName          = cDataLogicRelativePath + "/":U + cLogicProcedureName.
  END.

  RUN generateSBODataLogicObject IN ghDesignManager (INPUT "":U,                            /* pcDatabaseName           */
                                                     INPUT cDataInstanceNames,              /* pcTableList - actually instance names  */
                                                     INPUT "":U,                            /* pcDumpName               */
                                                     INPUT {fn getLogicalObjectName hSBO},  /* pcDataObjectName         */
                                                     INPUT cProductModule,                  /* pcProductModule          */
                                                     INPUT cResultCode,                     /* pcResultCode             */
                                                     INPUT cLogicProcedureName,             /* pcLogicProcedureName     */
                                                     INPUT cLogicObjectType,                /* pcLogicObjectType        */
                                                     INPUT cLogicProcedureTemplate,         /* pcLogicProcedureTemplate */
                                                     INPUT cDataLogicRelativePath,          /* pcDataLogicRelativePath  */
                                                     INPUT cRootFolder,                     /* pcRootFolder             */
                                                     INPUT cIncludeFileList,                /* pcIncludeFileList        */
                                                     INPUT lCreateMissingFolder) NO-ERROR.  /* plCreateMissingFolder    */

  IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN DO:
    IF NOT RETURN-VALUE BEGINS "Compiling of DataLogic":U THEN /* A compile error */
      ASSIGN
        cMessageType = "ERR":U
        cMessage     = "The DataLogicProcedure could not be generated successfully. ":U
                     + (IF RETURN-VALUE <> "":U THEN CHR(10) + CHR(10) + RETURN-VALUE
                                                ELSE (IF ERROR-STATUS:GET-MESSAGE(1) <> "":U THEN CHR(10) + CHR(10) + ERROR-STATUS:GET-MESSAGE(1)
                                                                                             ELSE "":U)).
    ELSE /* A compile error ... still create the DLP even though it didn't compile */
      ASSIGN
        cMessageType = "ERR":U
        cMessage     = "The DataLogicProcedure was generated successfully.":U + CHR(10) + 
                       "However, it did not compile." + CHR(10) + CHR(10) + RETURN-VALUE.
  END.  /* If there was an error */
  ELSE
    ASSIGN
        cMessageType = "INF":U
        cMessage     = "The DataLogicProcedure was generated successfully.":U + CHR(10) + CHR(10)
                     + "*** NOTE: Remember to save your container to set the link between the container and the DataLogicProcedure.":U.
  RUN showMessages IN gshSessionManager (INPUT  cMessage,                                 /* message to display */
                                         INPUT  cMessageType,                             /* error type         */
                                         INPUT  "&OK":U,                                  /* button list        */
                                         INPUT  "&OK":U,                                  /* default button     */ 
                                         INPUT  "&OK":U,                                  /* cancel button      */
                                         INPUT  "DataLogicProcedure generation status":U, /* error window title */
                                         INPUT  YES,                                      /* display if empty   */ 
                                         INPUT  THIS-PROCEDURE,                           /* container handle   */ 
                                         OUTPUT cButton).                                 /* button pressed     */

  {fn    evaluateButton}.
  {fnarg setAttribute "'DataLogicProcedure':U, cProcedureName"}.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFolderName vTableWin 
PROCEDURE getFolderName :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT-OUTPUT PARAMETER pcFolderName    AS CHARACTER        NO-UNDO.

  DEFINE VARIABLE cOriginalFolderName           AS CHARACTER        NO-UNDO.
  DEFINE VARIABLE hServer                       AS COM-HANDLE       NO-UNDO.
  DEFINE VARIABLE hFolder                       AS COM-HANDLE       NO-UNDO.
  DEFINE VARIABLE hParent                       AS COM-HANDLE       NO-UNDO.
  DEFINE VARIABLE iErrorCount                   AS INTEGER          NO-UNDO.
  DEFINE VARIABLE cButtonPressed                AS CHARACTER        NO-UNDO.
  DEFINE VARIABLE cErrorText                    AS CHARACTER        NO-UNDO.
  DEFINE VARIABLE cFolder                       AS CHARACTER        NO-UNDO.

  ASSIGN
    cOriginalFolderName = pcFolderName.

  CREATE 'Shell.Application' hServer NO-ERROR.

  IF ERROR-STATUS:ERROR
  THEN
  DO WITH FRAME {&FRAME-NAME}:

    /* Inform user. */
    DO iErrorCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
      ASSIGN
        cErrorText = cErrorText
                   + (IF NUM-ENTRIES(cErrorText, "~n":U) EQ 0 THEN "":U ELSE "~n":U)
                   + ERROR-STATUS:GET-MESSAGE(iErrorCount).
    END.    /* count error messages */
    RUN showMessages IN gshSessionManager
                    (INPUT  {aferrortxt.i 'AF' '40' '?' '?' "cErrorText" }
                    ,INPUT  "ERR"                                /* error type */
                    ,INPUT  "&OK"                                /* button list */
                    ,INPUT  "&OK"                                /* default button */ 
                    ,INPUT  "&OK"                                /* cancel button */
                    ,INPUT  "Error Creating Automation Server"   /* error window title */
                    ,INPUT  YES                                  /* display if empty */
                    ,INPUT  ?                                    /* container handle */ 
                    ,OUTPUT cButtonPressed                       /* button pressed */
                    ).
    RETURN.

  END.  /* Error. */

  ASSIGN
    hFolder = hServer:BrowseForFolder(CURRENT-WINDOW:HWND, "Select a folder to act as the root for any static objects generated", 0).

  IF VALID-HANDLE(hFolder)
  THEN DO:

    ASSIGN
      cFolder    = hFolder:TITLE
      hParent    = hFolder:ParentFolder
      iErrorCount = 0
      .

    REPEAT:
      IF iErrorCount >= hParent:Items:Count
      THEN DO:
        ASSIGN
          pcFolderName = "":U.
        LEAVE.
      END.
      ELSE
      IF hParent:Items:Item(iErrorCount):Name = cFolder
      THEN DO:
        ASSIGN
          pcFolderName = hParent:Items:Item(iErrorCount):Path.
        LEAVE.               
      END.
      ASSIGN
        iErrorCount = iErrorCount + 1.
    END.    /* repeat */

  END.    /* valid folder */
  ELSE
    ASSIGN
      pcFolderName = "":U.


  IF pcFolderName = "":U
  THEN
    ASSIGN
      pcFolderName = cOriginalFolderName.

  RELEASE OBJECT hParent NO-ERROR.
  RELEASE OBJECT hFolder NO-ERROR.
  RELEASE OBJECT hServer NO-ERROR.

  ASSIGN
    hParent = ?
    hFolder = ?
    hServer = ?
    .

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSDOInformation vTableWin 
PROCEDURE getSDOInformation :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phSBO             AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER pcTableList       AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcIncludeFileList AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cContainedSDOs  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldList      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQuery          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPath           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDO            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iSDO            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hSDO            AS HANDLE     NO-UNDO.

  cContainedSDOs = {fn getContainedDataObjects phSBO}.

  DO iSDO = 1 TO NUM-ENTRIES(cContainedSDOs):
    ASSIGN
        hSDO   = WIDGET-HANDLE(ENTRY(iSDO, cContainedSDOs))
        cSDO   = {fn getObjectName hSDO}
        cQuery = "FOR EACH ryc_smartobject NO-LOCK":U
               + "   WHERE ryc_smartobject.object_filename BEGINS '":U + cSDO + "'":U
               + "     AND ryc_smartobject.customization_result_obj = 0,":U
               + "   FIRST gsc_product_module NO-LOCK":U
               + "   WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj INDEXED-REPOSITION":U.

    RUN getRecordDetail IN gshGenManager (INPUT  cQuery,
                                          OUTPUT cFieldList).

    ASSIGN
        cPath = ENTRY(LOOKUP("ryc_smartobject.object_path":U, cFieldList, CHR(3)) + 1, cFieldList, CHR(3))
        cPath = (IF cPath = "":U THEN ENTRY(LOOKUP("gsc_product_module.relative_path":U, cFieldList, CHR(3)) + 1, cFieldList, CHR(3)) ELSE cPath)

        pcIncludeFileList = pcIncludeFileList + (IF pcIncludeFileList = "":U THEN "":U ELSE ",":U) + cPath + "/":U + ENTRY(1, cSDO, ".":U) + ".i":U
        pcTableList       = pcTableList       + (IF pcTableList       = "":U THEN "":U ELSE ",":U) + ENTRY(1, {fn getTables hSDO}).
  END.

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
  DEFINE VARIABLE hCombo  AS HANDLE     NO-UNDO.

  {get ContainerSource ghContainerSource}.
  {get ContainerSource ghParentContainer ghContainerSource}.
  
  ghDesignManager = {fnarg getManagerHandle 'RepositoryDesignManager':U}.

  SUBSCRIBE TO "comboValueChanged":U IN THIS-PROCEDURE.
  SUBSCRIBE TO "refreshData":U       IN ghContainerSource.
  SUBSCRIBE TO "refreshData":U       IN ghParentContainer.

  RUN SUPER.

  RUN displayFields (?).

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    /* Assign the default values */
    ASSIGN
        fiRootFolder:SCREEN-VALUE           = {fn getSessionRootDirectory}
        coDataLogicObjectType:LIST-ITEMS    = REPLACE({fnarg getClassChildrenFromDB 'DlProc':U gshRepositoryManager},CHR(3), ",":U)
        coDataLogicObjectType:SCREEN-VALUE  = coDataLogicObjectType:ENTRY(1)
        fiLPTemplateName:SCREEN-VALUE       = "ry/obj/rytemsbologic.p":U
        fiLPSuffix:SCREEN-VALUE             = "logcp.p":U.

    {fn stripRelativePath}.
    {get ComboHandle hCombo hProductModule}.
    
    APPLY "VALUE-CHANGED":U TO hCombo.

    {fn getSBODetails}.
  END.

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
  DEFINE INPUT PARAMETER pcAction       AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pdObjectNumber AS DECIMAL    NO-UNDO.

  IF pcAction = "NewData":U THEN
  DO WITH FRAME {&FRAME-NAME}:
    {fn getSBODetails}.

    IF gdSmartObjectObj < 0.00 THEN
    DO:
      fiDataLogicProcedure:SCREEN-VALUE = "":U.

      RUN disableField IN hProductModule.

      DISABLE
          fiRootFolder
          buLookupDirectory
          toCreateMissing
          coDataLogicObjectType
          fiLPRelativePath
          fiLPSuffix
          fiLPTemplateName
          buGenerate.
    END.
    ELSE
    DO:
      RUN enableField IN hProductModule.

      ENABLE
          fiRootFolder
          buLookupDirectory
          toCreateMissing
          coDataLogicObjectType
          fiLPRelativePath
          fiLPSuffix
          fiLPTemplateName
          buGenerate.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION evaluateButton vTableWin 
FUNCTION evaluateButton RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFieldList  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQuery      AS CHARACTER  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    fiDataLogicProcedure:SCREEN-VALUE = fiRootFolder:SCREEN-VALUE     + "/":U
                                      + fiLPRelativePath:SCREEN-VALUE + "/":U
                                      + gcObjectFilename
                                      + fiLPSuffix:SCREEN-VALUE.

    IF SEARCH(fiDataLogicProcedure:SCREEN-VALUE) = ? THEN
      ASSIGN
          buGenerate:LABEL = REPLACE(buGenerate:LABEL, "Re-":U, "":U)
          toOnDisk:CHECKED = FALSE.
    ELSE
      ASSIGN
          buGenerate:LABEL = "Re-":U + REPLACE(buGenerate:LABEL, "Re-":U, "":U)
          toOnDisk:CHECKED = TRUE.
  
    cQuery = "FOR EACH ryc_smartobject NO-LOCK":U
             + " WHERE ryc_smartobject.customization_result_obj = 0":U
             + "   AND ryc_smartobject.object_filename          = ":U + QUOTER(ENTRY(1, gcObjectFilename + fiLPSuffix:SCREEN-VALUE, ".":U)) + " INDEXED-REPOSITION":U.

    RUN getRecordDetail IN gshGenManager (INPUT  cQuery,
                                          OUTPUT cFieldList).

    IF cFieldList <> "":U AND
       cFieldList <> ?    THEN
      toInRepository:CHECKED = TRUE.
    ELSE
      toInRepository:CHECKED = FALSE.
  END.
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSBODetails vTableWin 
FUNCTION getSBODetails RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cObjectTypeCode AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProductModule  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProcedureName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRelativePath   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNameSuffix     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldList      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDLProc         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQuery          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomResult   AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE httSmartObject  AS HANDLE     NO-UNDO.

  ASSIGN
      httSmartObject = WIDGET-HANDLE({fnarg getUserProperty 'ttSmartObject':U          ghParentContainer})
      dCustomResult  =       DECIMAL({fnarg getUserProperty 'CustomizationResultObj':U ghParentContainer})
      cDLProc        = {fnarg getAttributeValue "?, 'DataLogicProcedure':U" ghParentContainer}.

  CREATE BUFFER httSmartObject FOR TABLE httSmartObject.

  httSmartObject:FIND-FIRST("WHERE d_smartobject_obj <> 0 AND d_customization_result_obj = ":U + QUOTER(dCustomResult)).

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        gcObjectFilename = httSmartObject:BUFFER-FIELD("c_object_filename":U):BUFFER-VALUE
        gdSmartObjectObj = httSmartObject:BUFFER-FIELD("d_smartobject_obj":U):BUFFER-VALUE.

    IF cDLProc <> "":U AND
       cDLProc <> ?    THEN
    DO:
      IF INDEX(cDLProc, "~\":U) <> 0 THEN
        cDLProc = REPLACE(cDLProc, "~\":U, "/":U).

      ASSIGN
          cProcedureName = ENTRY(NUM-ENTRIES(cDLProc, "/":U), cDLProc, "/":U)
          cRelativePath  = TRIM(REPLACE(cDLProc, cProcedureName, "":U), "/":U)
          cNameSuffix    = REPLACE(cProcedureName, gcObjectFilename, "":U)

          fiLPRelativePath:SCREEN-VALUE = cRelativePath
          fiLPSuffix:SCREEN-VALUE       = cNameSuffix.

      cQuery = "FOR EACH ryc_smartobject NO-LOCK":U
               + " WHERE ryc_smartobject.customization_result_obj = 0":U
               + "   AND ryc_smartobject.object_filename BEGINS ":U + QUOTER(ENTRY(1, cProcedureName, ".":U)) + ",":U
               + " FIRST gsc_product_module NO-LOCK":U
               + " WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj OUTER-JOIN,":U
               + " FIRST gsc_object_type NO-LOCK":U
               + " WHERE gsc_object_type.object_type_obj = ryc_smartobject.object_type_obj OUTER-JOIN INDEXED-REPOSITION":U.

      RUN getRecordDetail IN gshGenManager (INPUT  cQuery,
                                            OUTPUT cFieldList).

      IF cFieldList <> "":U AND
         cFieldList <> ?    THEN
      DO:
        ASSIGN
            cObjectTypeCode = ENTRY(LOOKUP("gsc_object_type.object_type_code":U,       cFieldList, CHR(3)) + 1, cFieldList, CHR(3))
            cProductModule  = ENTRY(LOOKUP("gsc_product_module.product_module_code":U, cFieldList, CHR(3)) + 1, cFieldList, CHR(3))

            coDataLogicObjectType:SCREEN-VALUE = cObjectTypeCode.

        {set DataValue cProductModule hProductModule}.
      END.
    END.
    ELSE
    DO:
      cQuery = "FOR EACH ryc_smartobject NO-LOCK":U
               + " WHERE ryc_smartobject.customization_result_obj = 0":U
               + "   AND ryc_smartobject.object_filename BEGINS ":U + QUOTER(ENTRY(1, gcObjectFilename, ".":U)) + ",":U
               + " FIRST gsc_product_module NO-LOCK":U
               + " WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj OUTER-JOIN INDEXED-REPOSITION":U.

      RUN getRecordDetail IN gshGenManager (INPUT  cQuery,
                                            OUTPUT cFieldList).

      IF cFieldList <> "":U AND
         cFieldList <> ?    THEN
      DO:
        ASSIGN
            fiLPRelativePath:SCREEN-VALUE = ENTRY(LOOKUP("gsc_product_module.relative_path":U,       cFieldList, CHR(3)) + 1, cFieldList, CHR(3))
            cProductModule                = ENTRY(LOOKUP("gsc_product_module.product_module_code":U, cFieldList, CHR(3)) + 1, cFieldList, CHR(3)).

        {set DataValue cProductModule hProductModule}.
      END.
    END.
  END.
  
  {fn evaluateButton}.

  DELETE OBJECT httSmartObject.
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAttribute vTableWin 
FUNCTION setAttribute RETURNS LOGICAL
  (pcAttribute AS CHARACTER,
   pcValue     AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cCustomizationCode  AS CHARACTER  NO-UNDO.

  cCustomizationCode = DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "CustomizationResultCode":U).

  IF cCustomizationCode = "?":U OR
     cCustomizationCode = ?     THEN
    cCustomizationCode = "":U.

  IF NOT VALID-HANDLE(ghProcLib) THEN
  DO:
    /* See if the Property Sheet procedure library is already running */
    ghProcLib = SESSION:FIRST-PROCEDURE.
    DO WHILE VALID-HANDLE(ghProcLib) AND ghProcLib:FILE-NAME NE "ry/prc/ryvobplipp.p":U:
      ghProcLib = ghProcLib:NEXT-SIBLING.
    END.  
  END.

  RUN propertyChangedAttribute IN ghParentContainer (INPUT ghParentContainer,
                                                     INPUT gdSmartObjectObj,
                                                     INPUT gdSmartObjectObj,
                                                     INPUT cCustomizationCode,
                                                     INPUT pcAttribute,
                                                     INPUT pcValue,
                                                     INPUT "":U,
                                                     INPUT TRUE).

  RUN assignPropertyValues IN ghProcLib (INPUT ghParentContainer,
                                         INPUT gdSmartObjectObj,
                                         INPUT gdSmartObjectObj,
                                         INPUT pcAttribute + CHR(3) + cCustomizationCode + CHR(3) + pcValue,
                                         INPUT "":U,
                                         INPUT TRUE).

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION stripRelativePath vTableWin 
FUNCTION stripRelativePath RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cListItemPairs  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEntry          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCounter        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hCombo          AS HANDLE     NO-UNDO.

  {get ComboHandle hCombo hProductModule}.

  DO iCounter = 1 TO NUM-ENTRIES(hCombo:LIST-ITEM-PAIRS, hCombo:DELIMITER) BY 2:
    ASSIGN
        cEntry          = ENTRY(iCounter, hCombo:LIST-ITEM-PAIRS, hCombo:DELIMITER)
        gcRelativePaths = gcRelativePaths + (IF iCounter = 1 THEN "":U ELSE ",":U)
                        + ENTRY(2, cEntry, "|":U)
        cListItemPairs  = cListItemPairs + (IF cListItemPairs = "":U THEN "":U ELSE hCombo:DELIMITER)
                        + ENTRY(1, cEntry, "|":U) + hCombo:DELIMITER
                        + ENTRY(iCounter + 1, hCombo:LIST-ITEM-PAIRS, hCombo:DELIMITER).
  END.
  
  {set ListItemPairs cListItemPairs hProductModule}.
  
  ASSIGN
      hCombo:LIST-ITEM-PAIRS = cListItemPairs
      hCombo:SCREEN-VALUE    = ENTRY(2, hCombo:LIST-ITEM-PAIRS, hCombo:DELIMITER).

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

