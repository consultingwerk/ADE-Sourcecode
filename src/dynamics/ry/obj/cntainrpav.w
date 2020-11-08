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
  File: cntainrpav.w

  Description:  Container Pages & Page Instances Viewer

  Purpose:      This viewer will be used to maintain the page information for a
                dynamic container

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   02/25/2002  Author:     Chris Koster

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

&scop object-name       cntainrpav.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{src/adm2/globals.i}
/*{ry/inc/rycntnerbi.i}*/

DEFINE VARIABLE gcObjectDescription       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcObjectFilename          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcPageLabel               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gdCustomizationResultObj  AS DECIMAL    NO-UNDO.
DEFINE VARIABLE giPageSequenceToFetch     AS INTEGER    NO-UNDO.
DEFINE VARIABLE giPageToCopy              AS INTEGER    NO-UNDO INITIAL ?.
DEFINE VARIABLE ghParentContainer         AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghContainerSource         AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghBrowseToolbar           AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghBrowserViewer           AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghPage                    AS HANDLE     NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS fiPageLabel fiSecurityToken toEnableOnCreate ~
toEnableOnModify toEnableOnView 
&Scoped-Define DISPLAYED-OBJECTS fiPageSequence fiPageLabel fiSecurityToken ~
toEnableOnCreate toEnableOnModify fiValidContainers toEnableOnView 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD evaluateMoveUpDown vTableWin 
FUNCTION evaluateMoveUpDown RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNumPages vTableWin 
FUNCTION getNumPages RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPageNumber vTableWin 
FUNCTION getPageNumber RETURNS INTEGER
  (pcPageLabel AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSelectedPageSequence vTableWin 
FUNCTION getSelectedPageSequence RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSwapWithPage vTableWin 
FUNCTION getSwapWithPage RETURNS INTEGER
  (pdCustomizationResultObj AS DECIMAL,
   piSwapPage               AS INTEGER,
   pcAction                 AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFieldSensitivity vTableWin 
FUNCTION setFieldSensitivity RETURNS LOGICAL
  (plSensitive   AS LOGICAL,
   plClearFields AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE hPageLayout AS HANDLE NO-UNDO.
DEFINE VARIABLE hPageObj AS HANDLE NO-UNDO.
DEFINE VARIABLE hPageTemplateObject AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buReplace 
     LABEL "Insert/Replace" 
     SIZE 17.4 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE fiPageLabel AS CHARACTER FORMAT "X(256)":U 
     LABEL "Page label" 
     VIEW-AS FILL-IN 
     SIZE 57.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiPageSequence AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Page sequence" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 5.8 BY 1 NO-UNDO.

DEFINE VARIABLE fiSecurityToken AS CHARACTER FORMAT "X(256)":U 
     LABEL "Security action" 
     VIEW-AS FILL-IN 
     SIZE 57.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiValidContainers AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE RECTANGLE rctOtherSettings
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 77.8 BY 5.43.

DEFINE RECTANGLE rctReplace
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 77.8 BY 2.81.

DEFINE VARIABLE toEnableOnCreate AS LOGICAL INITIAL NO 
     LABEL "Enable on create" 
     VIEW-AS TOGGLE-BOX
     SIZE 21.8 BY .81 NO-UNDO.

DEFINE VARIABLE toEnableOnModify AS LOGICAL INITIAL NO 
     LABEL "Enable on modify" 
     VIEW-AS TOGGLE-BOX
     SIZE 21.8 BY .81 NO-UNDO.

DEFINE VARIABLE toEnableOnView AS LOGICAL INITIAL NO 
     LABEL "Enable on view" 
     VIEW-AS TOGGLE-BOX
     SIZE 21.8 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     fiPageSequence AT ROW 1.19 COL 17.8 COLON-ALIGNED
     fiPageLabel AT ROW 2.24 COL 17.8 COLON-ALIGNED
     fiSecurityToken AT ROW 5.48 COL 17.8 COLON-ALIGNED
     toEnableOnCreate AT ROW 6.57 COL 19.8
     toEnableOnModify AT ROW 7.43 COL 19.8
     fiValidContainers AT ROW 8.05 COL 61.8 COLON-ALIGNED NO-LABEL
     toEnableOnView AT ROW 8.29 COL 19.8
     buReplace AT ROW 11.33 COL 59.8
     rctReplace AT ROW 9.86 COL 1.6
     rctOtherSettings AT ROW 3.91 COL 1.6
     " Insert / replace object instances from existing container" VIEW-AS TEXT
          SIZE 53.8 BY .62 AT ROW 9.48 COL 2.8
     " Other settings" VIEW-AS TEXT
          SIZE 15 BY .62 AT ROW 3.52 COL 2.8
     SPACE(59.60) SKIP(8.19)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


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
         HEIGHT             = 11.67
         WIDTH              = 78.4.
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

/* SETTINGS FOR BUTTON buReplace IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiPageSequence IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       fiPageSequence:READ-ONLY IN FRAME frMain        = TRUE.

/* SETTINGS FOR FILL-IN fiValidContainers IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       fiValidContainers:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR RECTANGLE rctOtherSettings IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rctReplace IN FRAME frMain
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

&Scoped-define SELF-NAME buReplace
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buReplace vTableWin
ON CHOOSE OF buReplace IN FRAME frMain /* Insert/Replace */
DO:
  RUN promptForReplace.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiPageLabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiPageLabel vTableWin
ON VALUE-CHANGED OF fiPageLabel IN FRAME frMain /* Page label */
DO:
  DEFINE VARIABLE cContainerMode  AS CHARACTER  NO-UNDO.
  
  cContainerMode = DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ContainerMode":U).
  
  IF cContainerMode <> "ADD":U    AND
     cContainerMode <> "UPDATE":U THEN
  DO:
    DYNAMIC-FUNCTION("evaluateActions":U IN ghContainerSource, "Update":U).
    
    RUN disableField IN hPageTemplateObject.
    RUN disableField IN hPageObj.
    
    DISABLE buReplace WITH FRAME {&FRAME-NAME}.

    {set BrowseSensitive FALSE ghBrowserViewer}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiPageSequence
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiPageSequence vTableWin
ON VALUE-CHANGED OF fiPageSequence IN FRAME frMain /* Page sequence */
DO:
  IF DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ContainerMode":U) <> "ADD":U THEN
  DO:
    DYNAMIC-FUNCTION("evaluateActions":U IN ghContainerSource, "Update":U).
    
    RUN disableField IN hPageTemplateObject.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiSecurityToken
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiSecurityToken vTableWin
ON VALUE-CHANGED OF fiSecurityToken IN FRAME frMain /* Security token */
DO:
  DEFINE VARIABLE cContainerMode  AS CHARACTER  NO-UNDO.
  
  cContainerMode = DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ContainerMode":U).
  
  IF cContainerMode <> "ADD":U    AND
     cContainerMode <> "UPDATE":U THEN
  DO:
    DYNAMIC-FUNCTION("evaluateActions":U IN ghContainerSource, "Update":U).
    
    RUN disableField IN hPageTemplateObject.
    RUN disableField IN hPageObj.
    
    DISABLE buReplace WITH FRAME {&FRAME-NAME}.

    {set BrowseSensitive FALSE ghBrowserViewer}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toEnableOnCreate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toEnableOnCreate vTableWin
ON VALUE-CHANGED OF toEnableOnCreate IN FRAME frMain /* Enable on create */
DO:
  DEFINE VARIABLE cContainerMode  AS CHARACTER  NO-UNDO.
  
  cContainerMode = DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ContainerMode":U).
  
  IF cContainerMode <> "ADD":U    AND
     cContainerMode <> "UPDATE":U THEN
  DO:
    DYNAMIC-FUNCTION("evaluateActions":U IN ghContainerSource, "Update":U).
    
    RUN disableField IN hPageTemplateObject.
    RUN disableField IN hPageObj.
     
    DISABLE buReplace WITH FRAME {&FRAME-NAME}.

    {set BrowseSensitive FALSE ghBrowserViewer}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toEnableOnModify
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toEnableOnModify vTableWin
ON VALUE-CHANGED OF toEnableOnModify IN FRAME frMain /* Enable on modify */
DO:
  DEFINE VARIABLE cContainerMode  AS CHARACTER  NO-UNDO.
  
  cContainerMode = DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ContainerMode":U).
  
  IF cContainerMode <> "ADD":U    AND
     cContainerMode <> "UPDATE":U THEN
  DO:
    DYNAMIC-FUNCTION("evaluateActions":U IN ghContainerSource, "Update":U).
    
    RUN disableField IN hPageTemplateObject.
    RUN disableField IN hPageObj.
    
    DISABLE buReplace WITH FRAME {&FRAME-NAME}.

    {set BrowseSensitive FALSE ghBrowserViewer}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toEnableOnView
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toEnableOnView vTableWin
ON VALUE-CHANGED OF toEnableOnView IN FRAME frMain /* Enable on view */
DO:
  DEFINE VARIABLE cContainerMode  AS CHARACTER  NO-UNDO.
  
  cContainerMode = DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ContainerMode":U).
  
  IF cContainerMode <> "ADD":U    AND
     cContainerMode <> "UPDATE":U THEN
  DO:
    DYNAMIC-FUNCTION("evaluateActions":U IN ghContainerSource, "Update":U).
    
    RUN disableField IN hPageTemplateObject.
    RUN disableField IN hPageObj.
    
    DISABLE buReplace WITH FRAME {&FRAME-NAME}.

    {set BrowseSensitive FALSE ghBrowserViewer}.
  END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addRecord vTableWin 
PROCEDURE addRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    DYNAMIC-FUNCTION("setUserProperty":U IN ghContainerSource, "ContainerMode":U, "ADD":U).
    DYNAMIC-FUNCTION("setFieldSensitivity":U, TRUE, TRUE).
    DYNAMIC-FUNCTION("evaluateActions":U  IN ghContainerSource, "ADD":U).

    RUN disableField IN hPageTemplateObject.
    RUN disableField IN hPageObj.

    DISABLE buReplace.
    APPLY "ENTRY":U TO fiPageLabel.
    
    {set BrowseSensitive FALSE ghBrowserViewer}.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
             INPUT  'DisplayedFieldryc_layout.layout_nameKeyFieldryc_layout.layout_objFieldLabelPage layoutFieldTooltipSelect option from listKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(256)DisplayDatatypeCHARACTERBaseQueryStringFOR EACH ryc_layout NO-LOCKQueryTablesryc_layoutSDFFileNameSDFTemplateParentFieldParentFilterQueryDescSubstitute&1ComboDelimiterListItemPairsInnerLines5ComboFlagFlagValueBuildSequence1SecurednoCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesUseCacheyesSuperProcedureFieldNamedPageLayoutDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hPageLayout ).
       RUN repositionObject IN hPageLayout ( 4.38 , 19.80 ) NO-ERROR.
       RUN resizeObject IN hPageLayout ( 1.05 , 57.60 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.smartobject_objFieldLabelContainerFieldTooltipPress F4 for LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object_type NO-LOCK,
                     EACH ryc_smartobject NO-LOCK
                     WHERE ryc_smartobject.object_type_obj = gsc_object_type.object_type_obj
                     AND ryc_smartobject.customization_result_obj = 0,
                     FIRST gsc_product_module
                     WHERE [&FilterSet=|&EntityList=GSCPM,RYCSO],
                     FIRST ryc_customization_result NO-LOCK
                     WHERE ryc_customization_result.customization_result_obj = ryc_smartobject.customization_result_obj OUTER-JOIN,
                     FIRST ryc_customization_type NO-LOCK
                     WHERE ryc_customization_type.customization_type_obj = ryc_customization_result.customization_type_obj OUTER-JOIN
                     BY ryc_smartobject.object_filename INDEXED-REPOSITIONQueryTablesgsc_object_type,ryc_smartobject,gsc_product_module,ryc_customization_result,ryc_customization_typeBrowseFieldsryc_smartobject.object_filename,ryc_smartobject.template_smartobject,gsc_object_type.object_type_code,ryc_smartobject.object_description,ryc_smartobject.static_object,ryc_smartobject.container_objectBrowseFieldDataTypescharacter,logical,character,character,logical,logicalBrowseFieldFormatsX(70)|YES/NO|X(35)|X(35)|YES/NO|YES/NORowsToBatch200BrowseTitleContainer LookupViewerLinkedFieldsryc_smartobject.customization_result_obj,ryc_smartobject.object_filename,ryc_smartobject.template_smartobject,ryc_smartobject.object_descriptionLinkedFieldDataTypesdecimal,character,logical,characterLinkedFieldFormats->>>>>>>>>>>>>>>>>9.999999999,X(70),YES/NO,X(35)ViewerLinkedWidgets?,?,?,?ColumnLabels,Template,,,,ContainerColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldfiValidContainersParentFilterQueryLOOKUP(gsc_object_type.object_type_code, "&1":U) > 0|MaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousYESPopupOnUniqueAmbiguousNOPopupOnNotAvailNOBlankOnNotAvailNOMappedFieldsUseCacheYESSuperProcedureFieldNamedSmartObjectObjDisplayFieldYESEnableFieldNOLocalFieldNOHideOnInitNODisableOnInitNOObjectLayout':U ,
             OUTPUT hPageTemplateObject ).
       RUN repositionObject IN hPageTemplateObject ( 10.24 , 13.80 ) NO-ERROR.
       RUN resizeObject IN hPageTemplateObject ( 1.00 , 63.60 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dyncombo.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_page.page_sequence,ryc_page.page_labelKeyFieldryc_page.page_sequenceFieldLabelPageFieldTooltipSelect option from listKeyFormat->9KeyDatatypeintegerDisplayFormatX(256)DisplayDatatypeCHARACTERBaseQueryStringFOR EACH ryc_page NO-LOCK,
                     FIRST ryc_layout NO-LOCK
                     WHERE ryc_layout.layout_obj = ryc_page.layout_obj
                     BY ryc_page.page_sequenceQueryTablesryc_page,ryc_layoutSDFFileNameSDFTemplateParentFielddSmartObjectObjParentFilterQueryryc_page.container_smartobject_obj = DECIMAL("&1")DescSubstitute&1 / &2ComboDelimiterListItemPairsInnerLines5ComboFlagNFlagValue0BuildSequence1SecurednoCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesUseCacheyesSuperProcedureFieldNamedPageObjDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hPageObj ).
       RUN repositionObject IN hPageObj ( 11.33 , 13.80 ) NO-ERROR.
       RUN resizeObject IN hPageObj ( 1.00 , 45.20 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( hPageLayout ,
             fiPageLabel:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( hPageTemplateObject ,
             toEnableOnView:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( hPageObj ,
             hPageTemplateObject , 'AFTER':U ).
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
  DEFINE INPUT PARAMETER phCombo          AS HANDLE     NO-UNDO. 

  IF TRIM(pcKeyFieldValue) <> "":U     AND
     phCombo                = hPageObj THEN
    ASSIGN
        giPageSequenceToFetch = INTEGER(pcKeyFieldValue)
        gcPageLabel           = (IF NUM-ENTRIES(pcScreenValue, "/":U) = 2 THEN TRIM(ENTRY(2, pcScreenValue, "/":U)) ELSE "":U)
        gcPageLabel           = REPLACE(gcPageLabel, "&":U, "":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyRecord vTableWin 
PROCEDURE copyRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  giPageToCopy = INTEGER(fiPageSequence:SCREEN-VALUE IN FRAME {&FRAME-NAME}).

  DYNAMIC-FUNCTION ("setUserProperty":U IN ghContainerSource, "ContainerMode":U, "ADD":U).
  DYNAMIC-FUNCTION("setFieldSensitivity":U, TRUE, FALSE).
  DYNAMIC-FUNCTION("evaluateActions":U  IN ghContainerSource, "ADD":U).

  RUN disableField IN hPageTemplateObject.

  {set BrowseSensitive FALSE ghBrowserViewer}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteRecord vTableWin 
PROCEDURE deleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cObjectFilename         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldList              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessage                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQuery                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iCurrentPage            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iPageNumber             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iNumPages               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iTest                   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE httObjectInstance       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httPage                 AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery                  AS HANDLE     NO-UNDO.

  iNumPages = DYNAMIC-FUNCTION("getNumPages":U).

  ASSIGN
      ghPage:BUFFER-FIELD("c_action":U):BUFFER-VALUE = "D":U
      dCustomizationResultObj                        = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "CustomizationResultObj":U))
      cObjectFilename                                =         DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ObjectFilename":U)

      iCurrentPage      = DYNAMIC-FUNCTION("getCurrentPage":U IN ghParentContainer)
      iTest             = DYNAMIC-FUNCTION("getPageNumber":U, ghPage:BUFFER-FIELD("c_page_label":U):BUFFER-VALUE)
      httObjectInstance = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttObjectInstance":U))
      httPage           = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttPage":U))
      iNumPages         = iNumPages - 1.

  /* Check if any customized pages exist, if so, prompt to find out if the delete should continue */
  IF dCustomizationResultObj = 0.00 THEN
  DO:
    cQuery = "FOR EACH ryc_smartobject NO-LOCK":U
           + "   WHERE ryc_smartobject.object_filename           = ":U + QUOTER(cObjectFilename)
           + "     AND ryc_smartobject.customization_result_obj <> 0,":U
           + "   FIRST ryc_page NO-LOCK":U
           + "   WHERE ryc_page.container_smartobject_obj = ryc_smartobject.smartobject_obj":U
           + "     AND ryc_page.page_reference            = ":U + QUOTER(ghPage:BUFFER-FIELD("c_page_reference":U):BUFFER-VALUE) + " INDEXED-REPOSITION":U.
      
    RUN getRecordDetail IN gshGenManager (INPUT  cQuery,
                                          OUTPUT cFieldList).
    
    IF cFieldList <> "":U AND
       cFieldList <> ?    THEN
    DO:
      cMessage = "Warning: Customizations have been made against this page. If you delete this page, all customizations will be deleted with it."
               + CHR(10) + CHR(10) + "Do you want to delete the page and all its customizations?":U.

      RUN showMessages IN gshSessionManager (INPUT  cMessage,                                   /* message to display */
                                             INPUT  "QUE":U,                                    /* error type         */
                                             INPUT  "&Ok,&Cancel":U,                            /* button list        */
                                             INPUT  "&Cancel":U,                                /* default button     */ 
                                             INPUT  "&Cancel":U,                                /* cancel button      */
                                             INPUT  "Delete page and all its customizations":U, /* error window title */
                                             INPUT  YES,                                        /* display if empty   */ 
                                             INPUT  THIS-PROCEDURE,                             /* container handle   */ 
                                             OUTPUT cButton).                                   /* button pressed     */

      IF cButton = "&Cancel":U THEN
        RETURN.
    END.
  END.
  
  /* -------------------------------- Flag the object instances that was on this page to be deleted -------------------------------- */
  CREATE BUFFER httObjectInstance FOR TABLE httObjectInstance.
  CREATE QUERY hQuery.

  hQuery:SET-BUFFERS(httObjectInstance).
  hQuery:QUERY-PREPARE("FOR EACH ttObjectInstance":U
                       + " WHERE ttObjectInstance.d_customization_result_obj = ":U + QUOTER(ghPage:BUFFER-FIELD("d_customization_result_obj":U):BUFFER-VALUE)
                       + "   AND ttObjectInstance.i_page = ":U + STRING(ghPage:BUFFER-FIELD("i_page_sequence":U):BUFFER-VALUE)).
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST() NO-ERROR.

  DO WHILE NOT hQuery:QUERY-OFF-END:
    httObjectInstance:BUFFER-FIELD("c_action":U):BUFFER-VALUE = "D":U.

    hQuery:GET-NEXT() NO-ERROR.
  END.

  DELETE OBJECT hQuery.
  DELETE OBJECT httObjectInstance.
  
  ASSIGN
      httObjectInstance = ?
      hQuery            = ?.
  /* --------------------------------------------------- End of flagging process --------------------------------------------------- */

  CREATE BUFFER httPage FOR TABLE httPage.

  httPage:FIND-FIRST("WHERE d_customization_result_obj = ":U + QUOTER(ghPage:BUFFER-FIELD("d_customization_result_obj":U):BUFFER-VALUE)
                    + " AND i_page_sequence            > ":U + STRING(ghPage:BUFFER-FIELD("i_page_sequence":U):BUFFER-VALUE)
                    + " AND c_action                  <> 'D'":U) NO-ERROR.

  IF httPage:AVAILABLE THEN
    iPageNumber = DYNAMIC-FUNCTION("getCurrentPage":U IN ghParentContainer).
  ELSE
  DO:
    httPage:FIND-LAST("WHERE d_customization_result_obj = ":U + QUOTER(ghPage:BUFFER-FIELD("d_customization_result_obj":U):BUFFER-VALUE)
                     + " AND i_page_sequence            < ":U + STRING(ghPage:BUFFER-FIELD("i_page_sequence":U):BUFFER-VALUE)
                     + " AND c_action                  <> 'D'":U) NO-ERROR.

    iPageNumber = DYNAMIC-FUNCTION("getPageNumber":U, httPage:BUFFER-FIELD("c_page_label":U):BUFFER-VALUE).
  END.

  {fnarg lockWindow TRUE ghParentContainer}.
  
  RUN getTTPage IN ghParentContainer (INPUT DYNAMIC-FUNCTION("getPageNumber":U, httPage:BUFFER-FIELD("c_page_label":U):BUFFER-VALUE)).

  PUBLISH "refreshData":U FROM ghParentContainer (INPUT "NewData":U, INPUT 0.00).

  RUN refreshData IN ghContainerSource (INPUT "NewData":U,
                                        INPUT httPage:BUFFER-FIELD("d_page_obj":U):BUFFER-VALUE).

  IF iCurrentPage >= iTest THEN
  DO:
    iPageNumber = (IF iPageNumber = 0 THEN 1 ELSE iPageNumber).
    
    IF iPageNumber > iNumPages THEN
      iPageNumber = iNumPages.

    IF iPageNumber <> iCurrentPage THEN
      RUN selectPage IN ghParentContainer (INPUT iPageNumber).
    ELSE
      RUN changeFolderPage IN ghParentContainer.
  END.

  DELETE OBJECT httPage.

  {fnarg lockWindow FALSE ghParentContainer}.

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

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  IF VALID-HANDLE(ghPage) THEN
    DELETE OBJECT ghPage.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject vTableWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEFINE VARIABLE cToolbarTargets AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hComboHandle    AS HANDLE     NO-UNDO.
  
  {get ContainerSource ghContainerSource}.
  {get ContainerSource ghParentContainer ghContainerSource}.

  ASSIGN
      ghBrowserViewer = DYNAMIC-FUNCTION("linkHandles":U IN ghContainerSource, "BrowserViewer-Source":U)
      ghBrowseToolbar = DYNAMIC-FUNCTION("linkHandles":U IN ghContainerSource, "BottomToolbar-Source":U)

      ghPage          = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttPage":U)).
  
  CREATE BUFFER ghPage FOR TABLE ghPage.

  SUBSCRIBE TO "comboValueChanged":U  IN THIS-PROCEDURE.
  SUBSCRIBE TO "lookupComplete":U     IN THIS-PROCEDURE.
  SUBSCRIBE TO "getPageDetails":U     IN ghContainerSource.
  SUBSCRIBE TO "rowSelected":U        IN ghBrowserViewer.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN displayFields IN TARGET-PROCEDURE (?).
  
  fiValidContainers:SCREEN-VALUE IN FRAME {&FRAME-NAME} = REPLACE(DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "DynMenc,DynObjc,DynFold":U), CHR(3), ",":U).

  {get ComboHandle hComboHandle hPageObj}.

  IF CAN-QUERY(hComboHandle, "LIST-ITEM-PAIRS":U) THEN
    hComboHandle:LIST-ITEM-PAIRS = REPLACE(hComboHandle:LIST-ITEM-PAIRS, "<None>":U, "":U).

  RUN setInitialValues.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE lookupComplete vTableWin 
PROCEDURE lookupComplete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcColumnNames           AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcColumnValues          AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcKeyFieldValue         AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcDisplayedFieldValue   AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcOldFieldValue         AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER plLookup                AS LOGICAL      NO-UNDO.
  DEFINE INPUT  PARAMETER phLookup                AS HANDLE       NO-UNDO.

  DEFINE VARIABLE cMessage        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hLookupFillIn   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hComboHandle    AS HANDLE     NO-UNDO.
  
  {get ComboHandle hComboHandle hPageObj}.
  
  IF NOT CAN-QUERY(hComboHandle, "LIST-ITEM-PAIRS":U) THEN
    RETURN.

  ASSIGN
      hComboHandle:LIST-ITEM-PAIRS = REPLACE(hComboHandle:LIST-ITEM-PAIRS, "<None>":U, "Container (Pg. 0)":U)
      gdCustomizationResultObj     = 0.00
      gcObjectDescription          = "":U
      gcObjectFileName             = "":U.
      
  IF NUM-ENTRIES(pcColumnValues, CHR(1)) >= LOOKUP("ryc_smartobject.customization_result_obj":U, pcColumnNames) THEN
    ASSIGN
        gdCustomizationResultObj = DECIMAL(ENTRY(LOOKUP("ryc_smartobject.customization_result_obj":U, pcColumnNames), pcColumnValues, CHR(1)))
        gcObjectDescription      = ENTRY(LOOKUP("ryc_smartobject.object_description":U, pcColumnNames), pcColumnValues, CHR(1))
        gcObjectFilename         = ENTRY(LOOKUP("ryc_smartobject.object_filename":U,    pcColumnNames), pcColumnValues, CHR(1)).

  IF gcObjectFilename = DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ObjectFilename":U) THEN
  DO:
    ASSIGN
        gdCustomizationResultObj   = 0.00
        gcObjectDescription        = "":U
        gcObjectFilename           = "":U
        hLookupFillIn              = DYNAMIC-FUNCTION("getLookupHandle":U IN hPageTemplateObject)
        hLookupFillIn:SCREEN-VALUE = "":U
        cMessage                   = "You cannot use the pages of the container you are currently creating as page templates for itself.":U
        cMessage                   = {af/sup2/aferrortxt.i 'AF' '40' '?' '?' cMessage}.
    
    RUN showMessages IN gshSessionManager (INPUT  cMessage,                             /* message to display */
                                           INPUT  "INF":U,                              /* error type         */
                                           INPUT  "&Ok":U,                              /* button list        */
                                           INPUT  "&Ok":U,                              /* default button     */ 
                                           INPUT  "&Ok":U,                              /* cancel button      */
                                           INPUT  "Cannot replace instances on page":U, /* error window title */
                                           INPUT  YES,                                  /* display if empty   */ 
                                           INPUT  THIS-PROCEDURE,                       /* container handle   */ 
                                           OUTPUT cButton).                             /* button pressed     */
    
    {set SavedScreenValue '' hPageTemplateObject}.
  END.

  IF gcObjectFilename = "":U THEN
  DO:
    {set DataValue '0' hPageObj}.
    
    RUN disableField IN hPageObj.

    DISABLE buReplace WITH FRAME {&FRAME-NAME}.
  
    RETURN.
  END.
  
  IF NUM-ENTRIES(hComboHandle:LIST-ITEM-PAIRS, hComboHandle:DELIMITER) <= 2 THEN
  DO:
    RUN disableField IN hPageObj.
    
    ASSIGN
        giPageSequenceToFetch = 0
        gcPageLabel           = "":U.
    
    {set DataValue '0' hPageObj}.
    
    ENABLE buReplace WITH FRAME {&FRAME-NAME}.
  END.
  ELSE
  DO:
    {set DataValue '0' hPageObj}.
    
    RUN enableField IN hPageObj.

    ENABLE buReplace WITH FRAME {&FRAME-NAME}.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE modifyRecord vTableWin 
PROCEDURE modifyRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  {fnarg setFieldSensitivity "TRUE, FALSE"}.
  {fnarg evaluateActions     'MODIFY':U ghContainerSource}.
  {fn    evaluateMoveUpDown}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE moveUpDown vTableWin 
PROCEDURE moveUpDown :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcAction AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iSwapContainerPage      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iWithContainerPage      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCurrentPage            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iSwapPage               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iWithPage               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE httPage                 AS HANDLE     NO-UNDO.
  
  ASSIGN
      dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "CustomizationResultObj":U))
      iCurrentPage            = DYNAMIC-FUNCTION("getCurrentPage":U IN ghParentContainer)
      iSwapPage               = ghPage:BUFFER-FIELD("i_page_sequence":U):BUFFER-VALUE
      iSwapContainerPage      = DYNAMIC-FUNCTION("getPageNumber":U, ghPage:BUFFER-FIELD("c_page_label":U):BUFFER-VALUE)
      
      httPage = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttPage":U)).

  CREATE BUFFER httPage FOR TABLE httPage.

  IF pcAction = "MoveDown":U THEN
    iWithContainerPage = iSwapContainerPage + 1.
  ELSE
    iWithContainerPage = iSwapContainerPage - 1.

  iWithPage = DYNAMIC-FUNCTION("getSwapWithPage":U, dCustomizationResultObj, iSwapPage, pcAction).

  httPage:FIND-FIRST("WHERE i_page_sequence            = ":U + STRING(iWithPage)
                    + " AND d_customization_result_obj = ":U + QUOTER(dCustomizationResultObj)
                    + " AND c_action                  <> 'D'":U).

  ASSIGN
      ghPage:BUFFER-FIELD("i_page_sequence":U):BUFFER-VALUE  = iWithPage
      ghPage:BUFFER-FIELD("c_action":U):BUFFER-VALUE         = (IF ghPage:BUFFER-FIELD("c_action":U):BUFFER-VALUE = "":U THEN "M":U ELSE ghPage:BUFFER-FIELD("c_action":U):BUFFER-VALUE)
      httPage:BUFFER-FIELD("i_page_sequence":U):BUFFER-VALUE = iSwapPage
      httPage:BUFFER-FIELD("c_action":U):BUFFER-VALUE        = (IF httPage:BUFFER-FIELD("c_action":U):BUFFER-VALUE = "":U THEN "M":U ELSE httPage:BUFFER-FIELD("c_action":U):BUFFER-VALUE).

  DYNAMIC-FUNCTION("setUserProperty":U IN ghParentContainer, "selectPage":U, "No":U).

  RUN swapPageNumbers IN ghParentContainer (INPUT iSwapPage, INPUT iWithPage).

  RUN getTTPage IN ghParentContainer (INPUT DYNAMIC-FUNCTION("getPageNumber":U, ghPage:BUFFER-FIELD("c_page_label":U):BUFFER-VALUE)).

  RUN refreshData IN ghContainerSource (INPUT "NewData":U,
                                        INPUT ghPage:BUFFER-FIELD("d_page_obj":U):BUFFER-VALUE).

  DELETE OBJECT httPage.
  httPage = ?.

  {fnarg lockWindow TRUE  ghParentContainer}.

  IF iSwapContainerPage = iCurrentPage THEN
    RUN selectPage IN ghParentContainer (INPUT iSwapContainerPage + (IF pcAction = "MoveDown":U THEN 1 ELSE -1)).
  ELSE
  DO:
    IF (iCurrentPage = iSwapContainerPage + 1 AND
        pcAction     = "MoveDown":U)          THEN
      RUN selectPage IN ghParentContainer (INPUT iCurrentPage - 1).
    ELSE
      IF (iCurrentPage = iSwapContainerPage - 1 AND
          pcAction     = "MoveUp":U)            THEN
        RUN selectPage IN ghParentContainer (INPUT iCurrentPage + 1).
  END.

  {fnarg lockWindow FALSE  ghParentContainer}.

  DYNAMIC-FUNCTION("setUserProperty":U IN ghParentContainer, "selectPage":U, "Yes":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE promptForReplace vTableWin 
PROCEDURE promptForReplace :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMessage          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObject           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lExist            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE httObjectInstance AS HANDLE     NO-UNDO.

  IF gcObjectFileName <> "":U THEN
  DO:
    httObjectInstance = DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttObjectInstance":U).
    CREATE BUFFER httObjectInstance FOR TABLE httObjectInstance.

    httObjectInstance:FIND-FIRST("WHERE d_object_instance_obj <> 0 AND c_action <> 'D' AND i_page = ":U + STRING(ghPage:BUFFER-FIELD("i_page_sequence":U):BUFFER-VALUE)) NO-ERROR.

    lExist = httObjectInstance:AVAILABLE.

    DELETE OBJECT httObjectInstance.

    ASSIGN
        cObject  = gcObjectFileName + " - ":U + gcObjectDescription
                 + " (Pg. ":U + TRIM(STRING(giPageSequenceToFetch))
                 + (IF gcPageLabel = "":U THEN "":U ELSE " - " + gcPageLabel) + ")":U
        cMessage = "You have selected '" + cObject
                 + "' as the template for this page."
                 + (IF ghPage:BUFFER-FIELD("i_page_sequence":U):BUFFER-VALUE <> 0 AND giPageSequenceToFetch = 0 THEN "If the template contains a SmartFolder, it will not be added to this page."
                                                                                   ELSE "":U)
                 + CHR(10) + CHR(10)
                 + "To replace the entire contents of this page with the contents of the template's page, select 'Yes'. "
                 + "Remember to save the container in order to commit the changes." + CHR(10) + CHR(10)
                 + "Do you want to use the object '" + cObject + "' as the template to regenerate this page from?".

    IF lExist = FALSE THEN
      cButton = "&Yes":U.
    ELSE
      RUN showMessages IN gshSessionManager (INPUT  cMessage,                          /* message to display */
                                             INPUT  "INF":U,                           /* error type         */
                                             INPUT  "&Yes,&No":U,                      /* button list        */
                                             INPUT  "&No":U,                           /* default button     */ 
                                             INPUT  "&No":U,                           /* cancel button      */
                                             INPUT  "Replace page object instances":U, /* error window title */
                                             INPUT  YES,                               /* display if empty   */ 
                                             INPUT  THIS-PROCEDURE,                    /* container handle   */ 
                                             OUTPUT cButton).                          /* button pressed     */

    IF cButton = "&Yes":U THEN
    DO:
      RUN fetchTemplatePageData IN ghParentContainer (INPUT gcObjectFilename,
                                                      INPUT gdCustomizationResultObj,
                                                      INPUT ghPage:BUFFER-FIELD("i_page_sequence":U):BUFFER-VALUE,
                                                      INPUT giPageSequenceToFetch).
    END.
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
  DEFINE INPUT PARAMETER pcAction     AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pdObjNumber  AS DECIMAL    NO-UNDO.
/*
  IF pcAction = "Updated" THEN
    RUN trgValueChanged IN ghBrowserViewer.
*/
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowSelected vTableWin 
PROCEDURE rowSelected :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdPageObj    AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER piResultRow  AS INTEGER    NO-UNDO.

  DEFINE VARIABLE cKeyFormat              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lSuccess                AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hLookupFillIn           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httPage                 AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hCombo                  AS HANDLE     NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    {get LookupHandle hLookupFillIn hPageTemplateObject}.
    {get ComboHandle  hCombo        hPageObj}.

    ASSIGN
        dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "CustomizationResultObj":U))
        
        httPage = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttPage":U)).

    ghPage:FIND-FIRST("WHERE d_page_obj                 = ":U + QUOTER(pdPageObj)
                     + " AND d_customization_result_obj = ":U + QUOTER(dCustomizationResultObj)
                     + " AND c_action                  <> 'D'":U) NO-ERROR.

    IF ghPage:AVAILABLE THEN
    DO:
      ASSIGN
          fiPageSequence:SCREEN-VALUE  = STRING(piResultRow) /* STRING(ghPage:BUFFER-FIELD("i_page_sequence":U):BUFFER-VALUE) */
          fiPageLabel:SCREEN-VALUE     = ghPage:BUFFER-FIELD("c_page_label":U):BUFFER-VALUE
          fiSecurityToken:SCREEN-VALUE = ghPage:BUFFER-FIELD("c_security_token":U):BUFFER-VALUE
          toEnableOnCreate:CHECKED     = ghPage:BUFFER-FIELD("l_enable_on_create":U):BUFFER-VALUE
          toEnableOnModify:CHECKED     = ghPage:BUFFER-FIELD("l_enable_on_modify":U):BUFFER-VALUE
          toEnableOnView:CHECKED       = ghPage:BUFFER-FIELD("l_enable_on_view":U):BUFFER-VALUE.

      IF ghPage:BUFFER-FIELD("d_layout_obj":U):BUFFER-VALUE <> 0 THEN
        DYNAMIC-FUNCTION("setDataValue":U IN hPageLayout, INPUT ghPage:BUFFER-FIELD("d_layout_obj":U):BUFFER-VALUE).
      ELSE
        RUN setInitialValues.

      DYNAMIC-FUNCTION("setFieldSensitivity":U, FALSE, FALSE).
/*
      RUN enableField IN hPageTemplateObject.
*/
      IF hLookupFillIn:SCREEN-VALUE <> "":U THEN
        ENABLE buReplace.

      IF NUM-ENTRIES(hCombo:LIST-ITEM-PAIRS, hCombo:DELIMITER) > 2 THEN
        hCombo:SENSITIVE = TRUE.
    END.
    ELSE
      DYNAMIC-FUNCTION("setFieldSensitivity":U, FALSE, TRUE).

    IF {fnarg getUserProperty 'ContainerMode':U ghContainerSource} <> 'VIEW':U THEN
      DYNAMIC-FUNCTION("evaluateActions":U IN ghContainerSource, "VIEW":U).

    DYNAMIC-FUNCTION("evaluateMoveUpDown":U).

    /* Customization checks */
    IF ghPage:AVAILABLE THEN
    DO:
      IF ghPage:BUFFER-FIELD("i_page_sequence":U):BUFFER-VALUE = 0 THEN
        DYNAMIC-FUNCTION("disableActions":U IN ghBrowseToolbar, "cbDelete,cbModify":U).
      ELSE
      DO:
        IF {fnarg getUserProperty 'ContainerMode':U ghContainerSource} = 'VIEW':U THEN
          DYNAMIC-FUNCTION("enableActions":U IN ghBrowseToolbar, "cbModify":U).

        DYNAMIC-FUNCTION("enableActions":U IN ghBrowseToolbar, "cbDelete":U).
      END.

      IF dCustomizationResultObj <> 0.00 THEN
      DO:
        httPage:FIND-FIRST("WHERE c_page_reference             = ":U + QUOTER(ghPage:BUFFER-FIELD("c_page_reference":U):BUFFER-VALUE)
                          + " AND d_container_smartobject_obj <> ":U + QUOTER(ghPage:BUFFER-FIELD("d_container_smartobject_obj":U):BUFFER-VALUE)
                          + " AND d_customization_result_obj   = 0":U
                          + " AND i_page_sequence             <> 0":U) NO-ERROR.

        IF httPage:AVAILABLE THEN
        DO:
          DYNAMIC-FUNCTION("disableActions":U IN ghBrowseToolbar, "cbDelete":U).
  
          IF dCustomizationResultObj <> 0.00 THEN
          DO:
            RUN disableField IN hPageTemplateObject.
            RUN disableField IN hPageObj.
  
            DISABLE buReplace.
          END.
        END.
      END.
    END.
  END.
  
  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setInitialValues vTableWin 
PROCEDURE setInitialValues :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cComboObjValue  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hComboHandle    AS HANDLE     NO-UNDO.
  
  /* Setup the initial value of the page layout combo - this will always be 'relative', as this is the layout that we encourage to be used */
  {get ComboHandle hComboHandle hPageLayout}.
  
  IF CAN-QUERY(hComboHandle, "LIST-ITEM-PAIRS":U) THEN
    cComboObjValue = ENTRY(LOOKUP("RELATIVE":U, hComboHandle:LIST-ITEM-PAIRS, hComboHandle:DELIMITER) + 1, hComboHandle:LIST-ITEM-PAIRS, hComboHandle:DELIMITER).

  {set DataValue cComboObjValue hPageLayout}.
  
  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE toolbar vTableWin 
PROCEDURE toolbar :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcAction  AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cContainerMode          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE hLookupFillIn           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hCombo                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hbttPage                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httPage                 AS HANDLE     NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    {get LookupHandle hLookupFillIn hPageTemplateObject}.
    {get ComboHandle  hCombo        hPageObj}.

    ASSIGN
        dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "CustomizationResultObj":U))
        pcAction                = TRIM(pcAction).

    CASE pcAction:
      WHEN "MoveDown":U OR
      WHEN "MoveUp":U   THEN RUN moveUpDown (INPUT pcAction).
      WHEN "Cancel":U   OR
      WHEN "Undo":U     THEN RUN undoRecord.
      WHEN "Delete":U   THEN RUN deleteRecord.
      WHEN "Copy":U     THEN RUN copyRecord.
      WHEN "New":U      THEN RUN addRecord.
      WHEN "Modify":U   THEN RUN modifyRecord.
      
      WHEN "Save":U THEN
      DO:
        /* See if one already exists flagged as deleted - if so, change flag... */
        ASSIGN
            cContainerMode = DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ContainerMode":U)
            httPage        = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttPage":U)).

        ASSIGN
            fiPageSequence
            fiPageLabel
            fiSecurityToken
            toEnableOnCreate
            toEnableOnModify
            toEnableOnView.
  
        IF fiPageLabel:SCREEN-VALUE = "":U OR
           fiPageLabel:SCREEN-VALUE = ?    THEN
          RETURN ERROR {aferrortxt.i 'AF' '1' '?' '?' "'page label'"}.

        CREATE BUFFER hbttPage FOR TABLE httPage.
        CREATE BUFFER  httPage FOR TABLE httPage.

        IF cContainerMode = "ADD":U THEN
        DO:
          httPage:FIND-FIRST("WHERE i_page_sequence           <> 0.00":U
                            + " AND c_plain_label              = ":U + QUOTER(REPLACE(fiPageLabel:SCREEN-VALUE, "&":U, "":U))
                            + " AND d_customization_result_obj = ":U + QUOTER(dCustomizationResultObj)) NO-ERROR.

          /* Try to see if the page was deleted */
          IF httPage:AVAILABLE THEN
          DO:
            IF httPage:BUFFER-FIELD("c_action":U):BUFFER-VALUE = "D":U THEN
              httPage:BUFFER-FIELD("c_action":U):BUFFER-VALUE = (IF httPage:BUFFER-FIELD("d_page_obj":U):BUFFER-VALUE <= 0.00 THEN "A":U ELSE "M":U).
            ELSE
            DO:
              DELETE OBJECT hbttPage.
              DELETE OBJECT httPage.
              
              RETURN ERROR {aferrortxt.i 'AF' '8' '?' '?' 'the' '"specified page label"'}.
            END.
          END.
          ELSE
          DO:
            httPage:BUFFER-CREATE().
            ASSIGN httPage:BUFFER-FIELD("d_page_obj":U):BUFFER-VALUE                 = DYNAMIC-FUNCTION("getTemporaryObj":U IN ghParentContainer)
                   httPage:BUFFER-FIELD("d_customization_result_obj":U):BUFFER-VALUE = dCustomizationResultObj
                   httPage:BUFFER-FIELD("i_original_page_sequence":U):BUFFER-VALUE   = INTEGER(fiPageSequence:SCREEN-VALUE).

           IF TRIM(fiSecurityToken:SCREEN-VALUE) = "":U THEN
             ASSIGN
                fiSecurityToken:SCREEN-VALUE = fiPageLabel:SCREEN-VALUE
                fiSecurityToken:SCREEN-VALUE = (IF INDEX(fiSecurityToken:SCREEN-VALUE, "&":U) = 0 THEN fiSecurityToken:SCREEN-VALUE
                                                                                                  ELSE REPLACE(fiSecurityToken:SCREEN-VALUE, "&":U, "":U)).
          END.
        END.
        ELSE
          httPage:FIND-BY-ROWID(ghPage:ROWID).

        hbttPage:FIND-FIRST("WHERE i_page_sequence            = 0":U
                           + " AND d_customization_result_obj = ":U + QUOTER(dCustomizationResultObj)).

        ASSIGN
            httPage:BUFFER-FIELD("d_container_smartobject_obj":U):BUFFER-VALUE = hbttPage:BUFFER-FIELD("d_container_smartobject_obj":U):BUFFER-VALUE
            httPage:BUFFER-FIELD("d_layout_obj":U):BUFFER-VALUE                = DYNAMIC-FUNCTION("getDataValue":U IN hPageLayout)
            httPage:BUFFER-FIELD("i_page_sequence":U):BUFFER-VALUE             = INTEGER(fiPageSequence:SCREEN-VALUE)
            httPage:BUFFER-FIELD("c_page_label":U):BUFFER-VALUE                = TRIM(fiPageLabel:SCREEN-VALUE)
            httPage:BUFFER-FIELD("c_plain_label":U):BUFFER-VALUE               = TRIM(REPLACE(fiPageLabel:SCREEN-VALUE, "&":U, "":U))
            httPage:BUFFER-FIELD("c_security_token":U):BUFFER-VALUE            = fiSecurityToken:SCREEN-VALUE
            httPage:BUFFER-FIELD("l_enable_on_create":U):BUFFER-VALUE          = toEnableOnCreate:CHECKED
            httPage:BUFFER-FIELD("l_enable_on_modify":U):BUFFER-VALUE          = toEnableOnModify:CHECKED
            httPage:BUFFER-FIELD("l_enable_on_view":U):BUFFER-VALUE            = toEnableOnView:CHECKED.

        IF httPage:BUFFER-FIELD("c_action":U):BUFFER-VALUE = "":U THEN
          IF cContainerMode = "Add":U THEN
            httPage:BUFFER-FIELD("c_action":U):BUFFER-VALUE = "A".
          ELSE
            httPage:BUFFER-FIELD("c_action":U):BUFFER-VALUE = "M":U.

        DYNAMIC-FUNCTION("setUserProperty":U IN ghContainerSource, "ContainerMode":U, "MODIFY":U).
        DYNAMIC-FUNCTION("evaluateActions":U IN ghContainerSource, "MODIFY":U).

        RUN refreshData IN ghContainerSource (INPUT "NewData":U,
                                              INPUT httPage:BUFFER-FIELD("d_page_obj":U):BUFFER-VALUE).

        RUN getTTPage IN ghParentContainer (INPUT DYNAMIC-FUNCTION("getPageNumber":U, httPage:BUFFER-FIELD("c_page_label":U):BUFFER-VALUE)).

        /* Check if we need to copy a page, we also need to copy the instances on the page */
        IF giPageToCopy <> ? THEN
        DO:
          RUN copyPageInstances IN ghParentContainer (INPUT giPageToCopy,
                                                      INPUT httPage:BUFFER-FIELD("i_page_sequence":U):BUFFER-VALUE).

          giPageToCopy = ?.
        END.

        RUN enableField IN hPageTemplateObject.

        IF hLookupFillIn:SCREEN-VALUE <> "":U THEN
          ENABLE buReplace.

        IF NUM-ENTRIES(hCombo:LIST-ITEM-PAIRS, hCombo:DELIMITER) > 2 THEN
          hCombo:SENSITIVE = TRUE.

        {set BrowseSensitive TRUE ghBrowserViewer}.

        DELETE OBJECT hbttPage.
        DELETE OBJECT httPage.
      END.

    END CASE.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE undoRecord vTableWin 
PROCEDURE undoRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hLookupFillIn AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hCombo        AS HANDLE     NO-UNDO.
      
  DO WITH FRAME {&FRAME-NAME}:
    {get LookupHandle hLookupFillIn hPageTemplateObject}.
    {get ComboHandle  hCombo        hPageObj}.
    
    DYNAMIC-FUNCTION("setUserProperty":U IN ghContainerSource, "ContainerMode":U, "VIEW":U).
    DYNAMIC-FUNCTION("evaluateActions":U IN ghContainerSource, "VIEW":U).
    DYNAMIC-FUNCTION("evaluateMoveUpDown":U).

    RUN rowSelected (ghPage:BUFFER-FIELD("d_page_obj":U):BUFFER-VALUE,
                     ghPage:BUFFER-FIELD("i_page_sequence":U):BUFFER-VALUE).

    DYNAMIC-FUNCTION("setFieldSensitivity":U, FALSE, FALSE).

    IF hLookupFillIn:SENSITIVE = TRUE THEN
    DO:
      IF hLookupFillIn:SCREEN-VALUE <> "":U THEN
        ENABLE buReplace.
      
      IF NUM-ENTRIES(hCombo:LIST-ITEM-PAIRS, hCombo:DELIMITER) > 2 THEN
        hCombo:SENSITIVE = TRUE.
    END.
  END.

  {set BrowseSensitive TRUE ghBrowserViewer}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION evaluateMoveUpDown vTableWin 
FUNCTION evaluateMoveUpDown RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery  AS HANDLE   NO-UNDO.
  
  hQuery = {fn getQueryHandle ghBrowserViewer}.

  IF NOT VALID-HANDLE(hQuery) THEN
    RETURN FALSE.

  IF hQuery:CURRENT-RESULT-ROW - 1 = 0 THEN
    DYNAMIC-FUNCTION("disableActions":U IN ghBrowseToolbar, "cbMoveUp,cbMoveDown":U).
  ELSE
  DO:
    IF hQuery:CURRENT-RESULT-ROW - 1 > 1 THEN
      DYNAMIC-FUNCTION("enableActions":U IN ghBrowseToolbar, "cbMoveUp":U).
    ELSE
      DYNAMIC-FUNCTION("disableActions":U IN ghBrowseToolbar, "cbMoveUp":U).

    IF hQuery:CURRENT-RESULT-ROW < hQuery:NUM-RESULTS THEN
      DYNAMIC-FUNCTION("enableActions":U IN ghBrowseToolbar, "cbMoveDown":U).
    ELSE
      DYNAMIC-FUNCTION("disableActions":U IN ghBrowseToolbar, "cbMoveDown":U).
  END.

/*
  DEFINE VARIABLE httPage AS HANDLE     NO-UNDO.

  IF NOT ghPage:AVAILABLE THEN
    RETURN FALSE.

  httPage = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttPage":U)).

  CREATE BUFFER httPage FOR TABLE httPage.

  IF ghPage:BUFFER-FIELD("i_page_sequence":U):BUFFER-VALUE = 0 THEN
    DYNAMIC-FUNCTION("disableActions":U IN ghBrowseToolbar, "cbMoveUp,cbMoveDown":U).
  ELSE
  DO:
    IF ghPage:BUFFER-FIELD("i_page_sequence":U):BUFFER-VALUE > 1 THEN
      DYNAMIC-FUNCTION("enableActions":U IN ghBrowseToolbar, "cbMoveUp":U).
    ELSE
      DYNAMIC-FUNCTION("disableActions":U IN ghBrowseToolbar, "cbMoveUp":U).

    httPage:FIND-LAST("WHERE c_action <> 'D'":U).

    IF ghPage:BUFFER-FIELD("i_page_sequence":U):BUFFER-VALUE < httPage:BUFFER-FIELD("i_page_sequence":U):BUFFER-VALUE THEN
      DYNAMIC-FUNCTION("enableActions":U IN ghBrowseToolbar, "cbMoveDown":U).
    ELSE
      DYNAMIC-FUNCTION("disableActions":U IN ghBrowseToolbar, "cbMoveDown":U).
  END.

  DELETE OBJECT httPage.
  httPage = ?.
*/
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNumPages vTableWin 
FUNCTION getNumPages RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iNumPages               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE httPage                 AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery                  AS HANDLE     NO-UNDO.

  ASSIGN
      dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "CustomizationResultObj":U))
      httPage                 = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttPage":U))
      iNumPages               = 0.

  CREATE BUFFER httPage FOR TABLE httPage.
  CREATE QUERY hQuery.

  hQuery:SET-BUFFERS(httPage).
  hQuery:QUERY-PREPARE("FOR EACH ttPage":U
                       + " WHERE ttPage.d_customization_result_obj = ":U + QUOTER(dCustomizationResultObj)
                       + "   AND ttPage.c_action                  <> 'D'":U).
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST().

  DO WHILE NOT hQuery:QUERY-OFF-END:
    iNumPages = iNumPages + 1.

    hQuery:GET-NEXT().
  END.

  DELETE OBJECT httPage.
  DELETE OBJECT hQuery.

  RETURN iNumPages.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPageNumber vTableWin 
FUNCTION getPageNumber RETURNS INTEGER
  (pcPageLabel AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cCurrentEntry AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFolderLabels AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iPageNumber   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCounter      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hPageSource   AS HANDLE     NO-UNDO.

  {get PageSource hPageSource ghParentContainer}.

  cFolderLabels = DYNAMIC-FUNCTION("getFolderLabels":U IN hPageSource).

  DO iCounter = 1 TO NUM-ENTRIES(cFolderLabels, "|":U):
    ASSIGN
        cCurrentEntry = ENTRY(iCounter, cFolderLabels, "|":U)
        cCurrentEntry = TRIM(SUBSTRING(cCurrentEntry, 1, INDEX(cCurrentEntry, "(":U) - 1)).

    IF cCurrentEntry = pcPageLabel THEN
      iPageNumber = iCounter.
  END.

  RETURN iPageNumber.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSelectedPageSequence vTableWin 
FUNCTION getSelectedPageSequence RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF VALID-HANDLE(ghPage) AND
     ghPage:AVAILABLE     THEN
    RETURN ghPage:BUFFER-FIELD("i_page_sequence":U):BUFFER-VALUE.   /* Function return value. */
  ELSE
    RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSwapWithPage vTableWin 
FUNCTION getSwapWithPage RETURNS INTEGER
  (pdCustomizationResultObj AS DECIMAL,
   piSwapPage               AS INTEGER,
   pcAction                 AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iPrevious     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iPVToUse      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iNVToUse      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE httPage       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery        AS HANDLE     NO-UNDO.

  httPage = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttPage":U)).

  CREATE QUERY hQuery.
  CREATE BUFFER httPage FOR TABLE httPage.

  hQuery:SET-BUFFERS(httPage).
  hQuery:QUERY-PREPARE("FOR EACH ttPage":U
                       + " WHERE ttPage.d_customization_result_obj = ":U + QUOTER(pdCustomizationResultObj)
                       + "   AND ttPage.c_action                  <> 'D'":U
                       + "    BY ttPage.i_page_sequence":U).
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST().
  
  DO WHILE NOT hQuery:QUERY-OFF-END:
    /* If the value we are reading currently is the page we want to swap, then it means the previous value read
       was the value of the page we want to swap with if we are moving up */
    IF httPage:BUFFER-FIELD("i_page_sequence":U):BUFFER-VALUE = piSwapPage THEN
      iPVToUse = iPrevious.

    /* If the previous value read was the page we wanted to swap, then it means the current value is the value
       of the page we want to swap with if we are moving down */
    IF iPrevious = piSwapPage THEN
      iNVToUse = httPage:BUFFER-FIELD("i_page_sequence":U):BUFFER-VALUE.

    iPrevious = httPage:BUFFER-FIELD("i_page_sequence":U):BUFFER-VALUE.

    hQuery:GET-NEXT().
  END.
  
  DELETE OBJECT httPage.
  DELETE OBJECT hQuery.
  
  RETURN (IF pcAction = "MoveDown":U THEN iNVToUse ELSE iPVToUse).   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFieldSensitivity vTableWin 
FUNCTION setFieldSensitivity RETURNS LOGICAL
  (plSensitive   AS LOGICAL,
   plClearFields AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cContainerMode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE httPage         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hCombo          AS HANDLE     NO-UNDO.

  ASSIGN
      cContainerMode = DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ContainerMode":U)
      hCombo         = DYNAMIC-FUNCTION("getComboHandle":U  IN hPageLayout)
      
      httPage        = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttPage":U)).

  DO WITH FRAME {&FRAME-NAME}:
    IF (ghPage:AVAILABLE                                                 AND
        ghPage:BUFFER-FIELD("i_page_sequence":U):BUFFER-VALUE <> 0       AND
        plSensitive                                            = TRUE)   OR
        cContainerMode                                         = "Add":U THEN
    DO:
      ASSIGN
          fiPageLabel:SENSITIVE      = TRUE
          fiSecurityToken:SENSITIVE  = TRUE
          toEnableOnCreate:SENSITIVE = TRUE
          toEnableOnModify:SENSITIVE = TRUE
          toEnableOnView:SENSITIVE   = TRUE.
      
      IF cContainerMode <> "Add":U THEN
        RUN enableField IN hPageTemplateObject.
    END.
    ELSE
    DO:
      ASSIGN
          fiPageLabel:SENSITIVE      = FALSE
          fiSecurityToken:SENSITIVE  = FALSE
          toEnableOnCreate:SENSITIVE = FALSE
          toEnableOnModify:SENSITIVE = FALSE
          toEnableOnView:SENSITIVE   = FALSE.

      IF {fnarg getUserProperty 'DataContainer' ghParentContainer} = "yes":U THEN
      DO:
        buReplace:SENSITIVE = FALSE.

        RUN disableField IN hPageTemplateObject.
        RUN disableField IN hPageObj.
      END.
      ELSE
      DO:
        IF {fnarg getUserProperty 'ContainerMode' ghParentContainer} <> "FIND":U THEN
          RUN enableField IN hPageTemplateObject.
        ELSE
          RUN disableField IN hPageTemplateObject.
      END.
    END.

    IF plClearFields  = TRUE    OR
       cContainerMode = "ADD":U THEN
    DO:
      httPage:FIND-LAST("WHERE c_action <> 'D'":U).

      IF httPage:AVAILABLE THEN
      DO:
        fiPageSequence:SCREEN-VALUE = STRING(httPage:BUFFER-FIELD("i_page_sequence":U):BUFFER-VALUE + 1).
  
        IF plClearFields = TRUE THEN
          ASSIGN
              fiPageLabel:SCREEN-VALUE     = "":U
              fiSecurityToken:SCREEN-VALUE = "":U
              toEnableOnCreate:CHECKED     = TRUE
              toEnableOnModify:CHECKED     = TRUE
              toEnableOnView:CHECKED       = TRUE.
      END.
    END.
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

