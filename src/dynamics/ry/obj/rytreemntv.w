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
  File: rytreemntv.w

  Description:  Dynamic TreeView Maintenance Viewer

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/05/2002  Author: Mark Davies (MIP)

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

&scop object-name       rytreemntv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{src/adm2/globals.i}


&GLOBAL-DEFINE define-only YES
{launch.i }

DEFINE VARIABLE ghContainerSource   AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghContainerHandle   AS HANDLE     NO-UNDO. /* Window Handle */

DEFINE VARIABLE ghToolbar           AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghDataTable         AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghAttrObject        AS HANDLE     NO-UNDO.
DEFINE VARIABLE glNew               AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glNeedToSave        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glAppliedLeave      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE gcWindowTitle       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glTrackChanges      AS LOGICAL    NO-UNDO INIT TRUE.
DEFINE VARIABLE gcAppObjectType     AS CHARACTER  NO-UNDO.

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
&Scoped-Define DISPLAYED-OBJECTS fiObjectDescription fiContainerTemplate 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignObjectType vTableWin 
FUNCTION assignObjectType RETURNS LOGICAL
  ( pcObjectType AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD clearDetails vTableWin 
FUNCTION clearDetails RETURNS LOGICAL
  ( plClearAll AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getChangesMade vTableWin 
FUNCTION getChangesMade RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTreeViewName vTableWin 
FUNCTION getTreeViewName RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setToolbarHandle vTableWin 
FUNCTION setToolbarHandle RETURNS LOGICAL
  ( INPUT phToolbarHandle AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE hContainerTemplate AS HANDLE NO-UNDO.
DEFINE VARIABLE hCustomSuperProcedure AS HANDLE NO-UNDO.
DEFINE VARIABLE hObjectFilename AS HANDLE NO-UNDO.
DEFINE VARIABLE hObjectType AS HANDLE NO-UNDO.
DEFINE VARIABLE hProductModule AS HANDLE NO-UNDO.
DEFINE VARIABLE hResultCode AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buCreate 
     LABEL "&Create" 
     SIZE 12.4 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE fiContainerTemplate AS CHARACTER FORMAT "X(256)":U INITIAL "Create from existing dynamic TreeView" 
      VIEW-AS TEXT 
     SIZE 37.8 BY .62 TOOLTIP "Enter a description of this TreeView container" NO-UNDO.

DEFINE VARIABLE fiObjectDescription AS CHARACTER FORMAT "X(256)":U 
     LABEL "Description" 
     VIEW-AS FILL-IN 
     SIZE 48.8 BY 1 TOOLTIP "Enter a description for this Dynamic TreeView" NO-UNDO.

DEFINE RECTANGLE rctContainerTemplate
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 69.2 BY 1.67.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     fiObjectDescription AT ROW 3.14 COL 17.8 COLON-ALIGNED
     buCreate AT ROW 1.67 COL 130.4
     fiContainerTemplate AT ROW 1 COL 73.6 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     rctContainerTemplate AT ROW 1.38 COL 74.6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1
         SIZE 144.4 BY 4.52.


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
         HEIGHT             = 4.52
         WIDTH              = 144.4.
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
   NOT-VISIBLE Custom                                                   */
ASSIGN 
       FRAME frMain:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON buCreate IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiContainerTemplate IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       fiContainerTemplate:PRIVATE-DATA IN FRAME frMain     = 
                "Create from existing dynamic TreeView".

/* SETTINGS FOR FILL-IN fiObjectDescription IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rctContainerTemplate IN FRAME frMain
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

&Scoped-define SELF-NAME buCreate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buCreate vTableWin
ON CHOOSE OF buCreate IN FRAME frMain /* Create */
DO:
  DEFINE VARIABLE cTemplateObject AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessageList    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton         AS CHARACTER  NO-UNDO.

  RUN leaveLookup IN hContainerTemplate.
  {get DataValue cTemplateObject hContainerTemplate}.

  IF cTemplateObject = "":U THEN DO:
    cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                  {af/sup2/aferrortxt.i 'AF' '11' '' '' '"SmartObject Record"' '"the template name you specified"'}.

    RUN showMessages IN gshSessionManager (INPUT cMessageList,
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Error - Dynamic TreeView Template not found",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cButton).
    DISABLE buCreate WITH FRAME {&FRAME-NAME}.
    RETURN NO-APPLY.
  END.
  clearDetails(FALSE).
  
  IF VALID-HANDLE(ghDataTable) THEN DO:
    ghDataTable:EMPTY-TEMP-TABLE().
    ghDataTable = ?.
  END.
  SESSION:SET-WAIT-STATE("GENERAL":U).
  DYNAMIC-FUNCTION("statusText":U IN ghContainerSource,"Retrieving data from Repository for template Dynamic TreeView. Please Wait...").

  RUN getObjectDetail IN ghContainerSource (INPUT cTemplateObject,
                                            OUTPUT ghDataTable).
  IF VALID-HANDLE(ghDataTable) THEN DO:
    ghDataTable:FIND-FIRST().
    IF ghDataTable:AVAILABLE THEN DO WITH FRAME {&FRAME-NAME}:
      IF VALID-HANDLE(ghAttrObject) THEN
        RUN setInfo IN ghAttrObject (INPUT ghDataTable).
    END.
  END.
  RUN setOtherDetails.
  SESSION:SET-WAIT-STATE("":U).
  DYNAMIC-FUNCTION("statusText":U IN ghContainerSource,"":U).

  ASSIGN glTrackChanges = FALSE.
  RUN assignNewValue IN hContainerTemplate (INPUT "":U, INPUT "":U, FALSE).
  ASSIGN glTrackChanges = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiObjectDescription
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiObjectDescription vTableWin
ON VALUE-CHANGED OF fiObjectDescription IN FRAME frMain /* Description */
DO:
  RUN changesMade.
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
             INPUT  'DisplayedFieldgsc_object_type.object_type_code,gsc_object_type.object_type_descriptionKeyFieldgsc_object_type.object_type_codeFieldLabelTypeFieldTooltipSelect an object type from listKeyFormatX(35)KeyDatatypecharacterDisplayFormatX(35)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object_type
                     WHERE LOOKUP(gsc_object_type.object_type_code, gsc_object_type.object_type_code) > 0 NO-LOCK
                     BY gsc_object_type.object_type_code INDEXED-REPOSITIONQueryTablesgsc_object_typeSDFFileNameSDFTemplateParentFieldParentFilterQueryDescSubstitute&1 / &2ComboDelimiterListItemPairsInnerLines5ComboFlagFlagValueBuildSequence1SecurednoCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesUseCacheyesSuperProcedureFieldNamefiObjectTypeDisplayFieldyesEnableFieldyesLocalFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hObjectType ).
       RUN repositionObject IN hObjectType ( 4.19 , 19.80 ) NO-ERROR.
       RUN resizeObject IN hObjectType ( 1.00 , 49.20 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.object_filenameFieldLabelObject filenameFieldTooltipPress F4 tor Lookup Dynamic TreeViews or enter the name of your new TreeView containerKeyFormatX(70)KeyDatatypecharacterDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object_type WHERE LOOKUP(gsc_object_type.object_type_code, "DynTree":U) > 0 NO-LOCK, EACH ryc_smartobject NO-LOCK
                     WHERE ryc_smartobject.object_type_obj      = gsc_object_type.object_type_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj AND [&FilterSet=|&EntityList=GSCPM,RYCSO],
                     FIRST gsc_product NO-LOCK
                     WHERE gsc_product.product_obj = gsc_product_module.product_obj
                     BY ryc_smartobject.object_filename INDEXED-REPOSITIONQueryTablesgsc_object_type,ryc_smartobject,gsc_product_module,gsc_productBrowseFieldsryc_smartobject.object_filename,gsc_object_type.object_type_code,gsc_product_module.product_module_code,ryc_smartobject.object_description,ryc_smartobject.static_object,ryc_smartobject.template_smartobject,ryc_smartobject.container_objectBrowseFieldDataTypescharacter,character,character,character,logical,logical,logicalBrowseFieldFormatsX(70)|X(35)|X(35)|X(35)|YES/NO|YES/NO|YES/NORowsToBatch200BrowseTitleLookup Dynamic TreeViewViewerLinkedFieldsryc_smartobject.customization_result_obj,gsc_object_type.object_type_code,gsc_product_module.product_module_code,ryc_smartobject.object_descriptionLinkedFieldDataTypesdecimal,character,character,characterLinkedFieldFormats->>>>>>>>>>>>>>>>>9.999999999,X(35),X(35),X(35)ViewerLinkedWidgets?,raObjectType,?,fiObjectDescriptionColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailyesMappedFieldsUseCacheyesSuperProcedureFieldName<Local1>DisplayFieldyesEnableFieldyesLocalFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hObjectFilename ).
       RUN repositionObject IN hObjectFilename ( 1.00 , 19.80 ) NO-ERROR.
       RUN resizeObject IN hObjectFilename ( 1.00 , 49.20 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_customization_result.customization_result_codeKeyFieldryc_customization_result.customization_result_objFieldLabelResult codeFieldTooltipPress F4 For LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH ryc_customization_type NO-LOCK,
                     EACH ryc_customization_result NO-LOCK
                     WHERE ryc_customization_result.customization_type_obj = ryc_customization_type.customization_type_obj INDEXED-REPOSITIONQueryTablesryc_customization_type,ryc_customization_resultBrowseFieldsryc_customization_result.customization_result_code,ryc_customization_result.customization_result_desc,ryc_customization_result.system_owned,ryc_customization_type.customization_type_code,ryc_customization_type.customization_type_desc,ryc_customization_type.api_nameBrowseFieldDataTypescharacter,character,logical,character,character,characterBrowseFieldFormatsX(70)|X(70)|YES/NO|X(15)|X(35)|X(70)RowsToBatch200BrowseTitleResult Code LookupViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesSuperProcedureFieldName<Local2>DisplayFieldyesEnableFieldyesLocalFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hResultCode ).
       RUN repositionObject IN hResultCode ( 3.14 , 19.80 ) NO-ERROR.
       RUN resizeObject IN hResultCode ( 1.00 , 49.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.object_filenameFieldLabelSuper procedureFieldTooltipPress F4 to lookup an existing procedure to use as a Super Procedure for this TreeView containerKeyFormatX(70)KeyDatatypecharacterDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object_type NO-LOCK
                     WHERE gsc_object_type.object_type_code = ~'PROCEDURE~':U,
                     EACH ryc_smartobject NO-LOCK
                     WHERE ryc_smartobject.object_type_obj = gsc_object_type.object_type_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj AND [&FilterSet=|&EntityList=GSCPM,RYCSO],
                     FIRST gsc_product NO-LOCK
                     WHERE gsc_product.product_obj = gsc_product_module.product_obj
                     INDEXED-REPOSITIONQueryTablesgsc_object_type,ryc_smartobject,gsc_product_module,gsc_productBrowseFieldsryc_smartobject.object_filename,ryc_smartobject.object_description,gsc_product_module.product_module_codeBrowseFieldDataTypescharacter,character,characterBrowseFieldFormatsX(70)|X(35)|X(35)RowsToBatch200BrowseTitleCustom SmartObject LookupViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesSuperProcedureFieldName<Local5>DisplayFieldyesEnableFieldnoLocalFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hCustomSuperProcedure ).
       RUN repositionObject IN hCustomSuperProcedure ( 2.05 , 19.80 ) NO-ERROR.
       RUN resizeObject IN hCustomSuperProcedure ( 1.00 , 49.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.object_filenameFieldLabelDynamic TreeViewFieldTooltipPress F4 to lookup an existing Dynamic TreeView to use as a Template for your new TreeView containerKeyFormatX(70)KeyDatatypecharacterDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object_type WHERE gsc_object_type.object_type_code = "DynTree" NO-LOCK,
                     EACH ryc_smartobject NO-LOCK WHERE ryc_smartobject.object_type_obj = gsc_object_type.object_type_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj AND [&FilterSet=|&EntityList=GSCPM,RYCSO],
                     FIRST gsc_product NO-LOCK WHERE gsc_product.product_obj = gsc_product_module.product_obj
                     BY ryc_smartobject.object_filename INDEXED-REPOSITIONQueryTablesgsc_object_type,ryc_smartobject,gsc_product_module,gsc_productBrowseFieldsryc_smartobject.object_filename,gsc_object_type.object_type_code,ryc_smartobject.object_description,ryc_smartobject.static_object,ryc_smartobject.template_smartobject,ryc_smartobject.container_objectBrowseFieldDataTypescharacter,character,character,logical,logical,logicalBrowseFieldFormatsX(70)|X(35)|X(35)|YES/NO|YES/NO|YES/NORowsToBatch200BrowseTitleDynamic TreeView Template LookupViewerLinkedFieldsryc_smartobject.customization_result_objLinkedFieldDataTypesdecimalLinkedFieldFormats->>>>>>>>>>>>>>>>>9.999999999ViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesSuperProcedureFieldName<Local6>DisplayFieldyesEnableFieldyesLocalFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hContainerTemplate ).
       RUN repositionObject IN hContainerTemplate ( 1.67 , 95.80 ) NO-ERROR.
       RUN resizeObject IN hContainerTemplate ( 1.00 , 34.40 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dyncombo.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_product_module.product_module_description,gsc_product_module.product_module_codeKeyFieldgsc_product_module.product_module_codeFieldLabelProduct module codeFieldTooltipChoose a product module that this TreeView container will belong to.KeyFormatX(35)KeyDatatypecharacterDisplayFormatX(256)DisplayDatatypeCHARACTERBaseQueryStringFOR EACH gsc_product_module NO-LOCK WHERE [&FilterSet=|&EntityList=GSCPM],
                     FIRST gsc_product NO-LOCK
                     WHERE gsc_product.product_obj = gsc_product_module.product_obj
                     BY gsc_product_module.product_module_codeQueryTablesgsc_product_module,gsc_productSDFFileNameSDFTemplateParentFieldParentFilterQueryDescSubstitute&2 / &1ComboDelimiterListItemPairsInnerLines5ComboFlagFlagValueBuildSequence1SecurednoCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesUseCacheyesSuperProcedureFieldName<Local4>DisplayFieldyesEnableFieldyesLocalFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hProductModule ).
       RUN repositionObject IN hProductModule ( 3.14 , 95.80 ) NO-ERROR.
       RUN resizeObject IN hProductModule ( 1.00 , 46.80 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( hObjectType ,
             fiObjectDescription:HANDLE IN FRAME frMain , 'BEFORE':U ).
       RUN adjustTabOrder ( hObjectFilename ,
             hObjectType , 'AFTER':U ).
       RUN adjustTabOrder ( hResultCode ,
             hObjectFilename , 'AFTER':U ).
       RUN adjustTabOrder ( hCustomSuperProcedure ,
             hResultCode , 'AFTER':U ).
       RUN adjustTabOrder ( hContainerTemplate ,
             fiObjectDescription:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( hProductModule ,
             buCreate:HANDLE IN FRAME frMain , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changesMade vTableWin 
PROCEDURE changesMade :
/*------------------------------------------------------------------------------
  Purpose:     This event will be published from the maintenance viewer to 
               indicate that we should enable the save and reset buttons.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  IF NOT glNew THEN
    RUN setFields (INPUT "Change":U).
  
  IF FOCUS:NAME <> "fiObjectDescription":U THEN
    RUN disableField IN hContainerTemplate.
  
  DISABLE buCreate WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataChanged vTableWin 
PROCEDURE dataChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMessageList AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAnswer      AS CHARACTER  NO-UNDO.
  
  IF glNeedToSave OR glNew THEN DO:
    cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                  {af/sup2/aferrortxt.i 'AF' '131' '' '' '"this Dynamic TreeView"'}.
    RUN askQuestion IN gshSessionManager (INPUT cMessageList,    /* message to display */
                                          INPUT "&YES,&NO,&Cancel":U,    /* button list */
                                          INPUT "&YES":U,                /* default button */ 
                                          INPUT "&Cancel":U,             /* cancel button */
                                          INPUT "Add new Dynamic TreeViewt":U, /* window title */
                                          INPUT "":U,                    /* data type of question */ 
                                          INPUT "":U,                    /* format mask for question */ 
                                          INPUT-OUTPUT cAnswer,                 /* character value of answer to question */ 
                                                 OUTPUT cButton                  /* button pressed */
                                           ).
    /* Save before we close */
    IF cButton = "&YES":U THEN 
      RETURN "NEED_TO_SAVE":U.
  
    /* Don't save - just leave */
    IF cButton = "&NO":U THEN 
      RETURN.
  
    /* Just return back to screen */
    IF cButton = "&Cancel":U THEN 
      RETURN ERROR "DO_NOTHING":U.
  END.

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
  DEFINE VARIABLE hProcedure AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSuperHandle AS HANDLE     NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */


  hProcedure = SESSION:FIRST-PROCEDURE.
  DO WHILE VALID-HANDLE(hProcedure).
    hSuperHandle = hProcedure.
    hProcedure = hProcedure:NEXT-SIBLING.
    IF VALID-HANDLE(hSuperHandle) AND 
       INDEX(hSuperHandle:FILE-NAME,"rytresuprp") > 0 THEN
      DELETE PROCEDURE hSuperHandle.
  END.
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
  DEFINE VARIABLE hObjectLookup AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTempltLookup AS HANDLE     NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  {get ContainerSource ghContainerSource}.
  {get ContainerHandle ghContainerHandle ghContainerSource}.

  SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "lookupComplete":U         IN THIS-PROCEDURE.
  
  RUN SUPER.

  gcWindowTitle = ghContainerHandle:TITLE.
  
  {set FieldHidden TRUE hResultCode}.
  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    RUN adjustTabOrder (hObjectFilename,       hResultCode,                'BEFORE':U).
    
    RUN resizeObject (FRAME {&FRAME-NAME}:HEIGHT-CHARS, FRAME {&FRAME-NAME}:WIDTH-CHARS).
  END.
  
  ghAttrObject = WIDGET-HANDLE(DYNAMIC-FUNCTION("linkHandles":U,"Attribute-Target":U)).
  
  RUN displayFields  IN TARGET-PROCEDURE (?).
  
  SUBSCRIBE TO "changesMade":U IN ghContainerSource.

  {get LookupHandle hObjectLookup hObjectFileName}.
  {get LookupHandle hTempltLookup hContainerTemplate}.

  ON RETURN OF hObjectLookup OR LEAVE OF hObjectLookup OR TAB OF hObjectLookup PERSISTENT RUN leftLookup IN TARGET-PROCEDURE.
  ON VALUE-CHANGED OF hTempltLookup PERSISTENT RUN templateLookupChange IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leftLookup vTableWin 
PROCEDURE leftLookup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF glNew AND (LASTKEY = KEYCODE("TAB") OR 
                LASTKEY = 609 /* Mouse Click */ OR 
                LASTKEY = 619 OR 
                LASTKEY = -1 OR 
                LASTKEY = 9 OR
                LASTKEY = 13) AND NOT glAppliedLeave THEN DO:
  glAppliedLeave = TRUE.
  RUN leavelookup IN hObjectFileName.
  RETURN.
END.
IF NOT glNew THEN
  RUN leavelookup IN hObjectFileName.

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
  DEFINE INPUT  PARAMETER phObject                AS HANDLE       NO-UNDO.

  DEFINE VARIABLE cMessage           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessageList       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hLookupFillin      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cProductModule     AS CHARACTER  NO-UNDO.

  /* Check if it was a valid object */
  IF phObject = hObjectFileName THEN DO:
    IF pcKeyFieldValue = "":U AND NOT glNew THEN DO:
      cMessage = "Could find details for this Dynamic TreeView " + pcDisplayedFieldValue.
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '11' '' '' '"SmartObject Record"' '"the name you specified"'}.
       
      RUN showMessages IN gshSessionManager (INPUT cMessageList,
                                             INPUT "ERR":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "OK":U,
                                             INPUT "Error - Dynamic TreeView not found",
                                             INPUT YES,
                                             INPUT ?,
                                             OUTPUT cButton).
      RETURN.
    END.
    /* We are adding a new record */
    IF pcDisplayedFieldValue <> "":U AND glNew THEN DO:
      {get LookupHandle hLookupFillin hObjectFileName}.
      hLookupFillin:SCREEN-VALUE = pcDisplayedFieldValue.
      RUN newRecord IN ghContainerSource (INPUT "":U).

      IF VALID-HANDLE(ghDataTable) THEN DO:
        /* Check if we used a template object - if we did - get out */
        ghDataTable:FIND-FIRST().
        IF ghDataTable:AVAILABLE THEN 
          RETURN.
        ghDataTable:EMPTY-TEMP-TABLE().
        ghDataTable = ?.
      END.

      ghDataTable = DYNAMIC-FUNCTION("getTreeTable":U IN ghContainerSource).
      
      ghDataTable = ghDataTable:DEFAULT-BUFFER-HANDLE.
      ghDataTable:BUFFER-CREATE().
      IF VALID-HANDLE(ghAttrObject) THEN DO:
        RUN setInfo IN ghAttrObject (INPUT ghDataTable).
        DYNAMIC-FUNCTION("enableActions":U IN ghToolbar, "Properties":U).
      END.
    END. /*  NEW */
    ELSE DO:
      IF VALID-HANDLE(ghDataTable) THEN DO:
        ghDataTable:EMPTY-TEMP-TABLE().
        ghDataTable = ?.
      END.
      SESSION:SET-WAIT-STATE("GENERAL":U).
      DYNAMIC-FUNCTION("statusText":U IN ghContainerSource,"Retrieving data from Repository. Please Wait...").
  
      RUN getObjectDetail IN ghContainerSource (INPUT pcDisplayedFieldValue,
                                                OUTPUT ghDataTable).
      IF VALID-HANDLE(ghDataTable) THEN DO:
        ghDataTable:FIND-FIRST().
        IF ghDataTable:AVAILABLE THEN DO WITH FRAME {&FRAME-NAME}:
          IF VALID-HANDLE(ghAttrObject) THEN
            RUN setInfo IN ghAttrObject (INPUT ghDataTable).
        END.
      END.
      RUN setOtherDetails.
      SESSION:SET-WAIT-STATE("":U).
      DYNAMIC-FUNCTION("statusText":U IN ghContainerSource,"":U).
    END.
    DO WITH FRAME {&FRAME-NAME}:
      IF NOT glNew THEN DO:
        cProductModule = ENTRY(LOOKUP("gsc_product_module.product_module_code",pcColumnNames),pcColumnValues,CHR(1)) NO-ERROR.
        {set DataValue cProductModule hProductModule }.
      END.
    END.
    IF NOT glNew THEN
      RUN setFields (INPUT "Modify":U).
  END.
  ELSE DO:
    IF pcDisplayedFieldValue <> pcOldFieldValue 
       AND phObject <> hContainerTemplate AND 
      glTrackChanges THEN
      RUN changesMade.
  END.

  IF phObject = hContainerTemplate THEN
    RUN templateLookupChange.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE nodeMaintenance vTableWin 
PROCEDURE nodeMaintenance :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will run the Node Control window and allow the
               user to maintain TreeView Nodes
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hHandle        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cProcedureType AS CHARACTER  NO-UNDO.

  RUN launchContainer IN gshSessionManager (INPUT  "gsmndtreew",    /* pcObjectFileName       */
                                            INPUT  "":U,            /* pcPhysicalName         */
                                            INPUT  "":U,            /* pcLogicalName          */
                                            INPUT  TRUE,            /* plOnceOnly             */
                                            INPUT  "":U,            /* pcInstanceAttributes   */
                                            INPUT  "":U,            /* pcChildDataKey         */
                                            INPUT  "":U,            /* pcRunAttribute         */
                                            INPUT  "":U,            /* container mode         */
                                            INPUT  ?,               /* phParentWindow         */
                                            INPUT  ?,               /* phParentProcedure      */
                                            INPUT  ?,               /* phObjectProcedure      */
                                            OUTPUT hHandle,         /* phProcedureHandle      */
                                            OUTPUT cProcedureType). /* pcProcedureType        */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openTreeView vTableWin 
PROCEDURE openTreeView :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is called from the super procedure when run from
               the AppBuilder.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcObjectFileName AS CHARACTER  NO-UNDO.
  
  RUN assignNewValue IN hObjectFileName (INPUT "", INPUT pcObjectFileName, INPUT FALSE).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE postCreateObjects vTableWin 
PROCEDURE postCreateObjects :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will change the base query string of the Object
               Type combo to only list DynTree class objects 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cBaseQueryString  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValidObjectTypes AS CHARACTER  NO-UNDO.
  cValidObjectTypes = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "DynTree":U).
  
  /* Change Object Type Query */
  ASSIGN cBaseQueryString = {fn getBaseQueryString hObjectType}
         cBaseQueryString = REPLACE(cBaseQueryString, ", gsc_object_type.object_type_code":U, ",'" + cValidObjectTypes + "'":U).
  DYNAMIC-FUNCTION("setBaseQueryString":U IN hObjectType, cBaseQueryString).

  /* Change Object Lookup Query */
  ASSIGN cBaseQueryString = {fn getBaseQueryString hObjectFilename}
         cBaseQueryString = REPLACE(cBaseQueryString, ', "DynTree":U) > 0':U, ",'" + cValidObjectTypes + "') > 0":U).
  DYNAMIC-FUNCTION("setBaseQueryString":U IN hObjectFilename, cBaseQueryString).
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE previewTreeView vTableWin 
PROCEDURE previewTreeView :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hLookup        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hHandle        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cProcedureType AS CHARACTER  NO-UNDO.

  {get LookupHandle hLookup hObjectFileName}.
  
  RUN clearClientCache IN gshRepositoryManager.
  
  RUN launchContainer IN gshSessionManager (INPUT  hLookup:SCREEN-VALUE,       /* pcObjectFileName       */
                                            INPUT  "":U,            /* pcPhysicalName         */
                                            INPUT  "":U,            /* pcLogicalName          */
                                            INPUT  TRUE,            /* plOnceOnly             */
                                            INPUT  "":U,            /* pcInstanceAttributes   */
                                            INPUT  "":U,            /* pcChildDataKey         */
                                            INPUT  "":U,            /* pcRunAttribute         */
                                            INPUT  "":U,            /* container mode         */
                                            INPUT  ?,               /* phParentWindow         */
                                            INPUT  ?,               /* phParentProcedure      */
                                            INPUT  ?,               /* phObjectProcedure      */
                                            OUTPUT hHandle,         /* phProcedureHandle      */
                                            OUTPUT cProcedureType). /* pcProcedureType        */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeSDF vTableWin 
PROCEDURE removeSDF :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSDFFileName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAnswer      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton      AS CHARACTER  NO-UNDO.

  RUN askQuestion IN gshSessionManager (INPUT "Do you wish to delete the current Dynamic TreeView?",      /* messages */
                                        INPUT "&Yes,&No":U,     /* button list */
                                        INPUT "&No":U,          /* default */
                                        INPUT "&No":U,          /* cancel */
                                        INPUT "Delete Dynamic TreeView":U,     /* title */
                                        INPUT "":U,             /* datatype */
                                        INPUT "":U,             /* format */
                                        INPUT-OUTPUT cAnswer,   /* answer */
                                        OUTPUT cButton          /* button pressed */
                                        ).
  IF cButton <> "&YES":U THEN
    RETURN.

  SESSION:SET-WAIT-STATE("GENERAL":U).
  {get DataValue cSDFFileName hObjectFileName}.
  DYNAMIC-FUNCTION("statusText":U IN ghContainerSource,"Removing Dynamic TreeView from repository. Please Wait...").
  
  RUN removeSDF IN ghContainerSource (INPUT cSDFFileName).
  SESSION:SET-WAIT-STATE("":U).

  IF ERROR-STATUS:ERROR OR
     RETURN-VALUE <> "":U THEN DO:
    RUN showMessages IN gshSessionManager (INPUT RETURN-VALUE,
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Error Removing Dynamic TreeView",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cButton).
    RETURN.
  END.
  DYNAMIC-FUNCTION("statusText":U IN ghContainerSource,"").
  clearDetails(TRUE).
  RUN setFields ("Find":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetData vTableWin 
PROCEDURE resetData :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will cancel any changes made without saving and 
               reset the data back to the original state
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTreeObject AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hLookup     AS HANDLE     NO-UNDO.

  IF glNew THEN
    RUN setFields IN TARGET-PROCEDURE ("Cancel":U).

  {get LookupHandle hLookup hObjectFilename}. 
  cTreeObject = hLookup:SCREEN-VALUE.
  IF NOT VALID-HANDLE(ghDataTable) THEN 
    RUN getObjectDetail IN ghContainerSource (INPUT cTreeObject,
                                              OUTPUT ghDataTable).
  ELSE
    RUN newRecord IN ghContainerSource (INPUT cTreeObject).

  IF VALID-HANDLE(ghDataTable) THEN DO:
    clearDetails(FALSE).
    ghDataTable:FIND-FIRST().
    IF ghDataTable:AVAILABLE THEN DO WITH FRAME {&FRAME-NAME}:
      IF VALID-HANDLE(ghAttrObject) THEN
        RUN setInfo IN ghAttrObject (INPUT ghDataTable).
    END.
  END.
  
  RUN setOtherDetails.
  RUN setFields (INPUT "Modify":U).

  glNeedToSave = FALSE.
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
  DEFINE INPUT PARAMETER pdHeight AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdWidth  AS DECIMAL    NO-UNDO.
  
  DEFINE VARIABLE pdOldWidth AS DECIMAL  NO-UNDO.

  pdOldWidth = FRAME {&FRAME-NAME}:WIDTH-CHARS.
  
  IF pdWidth < FRAME {&FRAME-NAME}:WIDTH-CHARS THEN
  DO:
    RUN resizeViewerObjects (INPUT pdHeight, INPUT pdWidth, INPUT pdOldWidth).
    
    FRAME {&FRAME-NAME}:WIDTH-CHARS = pdWidth.
    FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-CHARS = pdWidth.
  END.
  ELSE
  DO:
    FRAME {&FRAME-NAME}:WIDTH-CHARS = pdWidth.
    FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-CHARS = pdWidth.
  
    RUN resizeViewerObjects (INPUT pdHeight, INPUT pdWidth, INPUT pdOldWidth).
  END.
  
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
  DEFINE INPUT PARAMETER pdOldWidth AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE dNewColumn      AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dNewWidth       AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lSuccess        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hLabelHandle    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE dChange         AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dLabelWidth     AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dRColLabelW     AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dLColLabelW     AS DECIMAL    NO-UNDO.
  
  IF DYNAMIC-FUNCTION("getObjectInitialized":U) = FALSE THEN
    RETURN.

  DO WITH FRAME {&FRAME-NAME}:
    
    ASSIGN
        /* First Calc Left Column Max Label Width */
        hLabelHandle  = DYNAMIC-FUNCTION("getLabelHandle":U  IN hObjectFileName)
        dLabelWidth   = hLabelHandle:WIDTH-CHARS
        hLabelHandle  = DYNAMIC-FUNCTION("getLabelHandle":U  IN hCustomSuperProcedure)
        dLabelWidth   = MAX(dLabelWidth,hLabelHandle:WIDTH-CHARS)
        hLabelHandle  = fiObjectDescription:SIDE-LABEL-HANDLE
        dLabelWidth   = MAX(dLabelWidth,hLabelHandle:WIDTH-CHARS)
        dLColLabelW   = dLabelWidth
        /* Now Calc Right Column Max Label Width */
        hLabelHandle  = DYNAMIC-FUNCTION("getLabelHandle":U  IN hContainerTemplate)
        dLabelWidth   = hLabelHandle:WIDTH-CHARS
        hLabelHandle  = DYNAMIC-FUNCTION("getLabelHandle":U  IN hProductModule)
        dLabelWidth   = MAX(dLabelWidth,hLabelHandle:WIDTH-CHARS)
        dRColLabelW   = dLabelWidth
        dNewWidth     = ((pdWidth - dLColLabelW - dRColLabelW) / 2) - 4
        .
    
    ASSIGN fiObjectDescription:WIDTH-CHARS  = dNewWidth
           hLabelHandle                     = DYNAMIC-FUNCTION("getLabelHandle":U  IN hContainerTemplate)
           rctContainerTemplate:COLUMN      = fiObjectDescription:COLUMN + fiObjectDescription:WIDTH-CHARS + 3
           rctContainerTemplate:WIDTH-CHARS = dNewWidth + hLabelHandle:WIDTH-CHARS + 4.50
           fiContainerTemplate:COLUMN       = rctContainerTemplate:COLUMN + 0.60
           buCreate:COLUMN                  = ((rctContainerTemplate:COLUMN + rctContainerTemplate:WIDTH) - buCreate:WIDTH) - 1.
    RUN resizeObject      IN hCustomSuperProcedure (1.00, dNewWidth).
    RUN resizeObject      IN hObjectFilename       (1.00, dNewWidth).
    RUN resizeObject      IN hResultCode           (1.00, dNewWidth).
    RUN resizeObject      IN hContainerTemplate    (1.00, dNewWidth - buCreate:WIDTH).
    RUN repositionObject  IN hContainerTemplate    (1.71, pdWidth - dNewWidth - 2).
    RUN resizeObject      IN hProductModule        (1.00, dNewWidth).
    RUN repositionObject  IN hProductModule        (3.10, pdWidth - dNewWidth - 2).
  END.
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveDetails vTableWin 
PROCEDURE saveDetails :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will save the details back to the temp-table and
               ensure that data is saved back to the repository.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataTable      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hObjectLookup   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cButton         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProductModule  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cError          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectType     AS CHARACTER  NO-UNDO.

  SESSION:SET-WAIT-STATE("GENERAL":U).

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fiObjectDescription.
  END.
  
  {get LookupHandle hObjectLookup hObjectFileName}.
  {get DataValue cProductModule hProductModule}.

  RUN assignValues IN ghAttrObject.
  hDataTable = DYNAMIC-FUNCTION("getDataTable":U IN ghAttrObject).
  cObjectType = DYNAMIC-FUNCTION("getDataValue":U IN hObjectType).
  /* Save to the Repository */
  RUN saveTreeInfo IN ghContainerSource (INPUT hObjectLookup:SCREEN-VALUE,
                                         INPUT hDataTable,
                                         INPUT DYNAMIC-FUNCTION("getDataValue":U IN hCustomSuperProcedure),
                                         INPUT fiObjectDescription,
                                         INPUT cProductModule,
                                         INPUT cObjectType).
  SESSION:SET-WAIT-STATE("":U).
  IF ERROR-STATUS:ERROR OR
     RETURN-VALUE <> "":U THEN DO:
    cError = RETURN-VALUE.
    SESSION:SET-WAIT-STATE("":U).
    RUN showMessages IN gshSessionManager (INPUT RETURN-VALUE,
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Error Saving Dynamic TreeView to the Repository",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cButton).
    RETURN cError.
  END.

  /* If all went okay - we need to refetch the new info */
  RUN getObjectDetail IN ghContainerSource (INPUT hObjectLookup:SCREEN-VALUE,
                                            OUTPUT ghDataTable).

  IF VALID-HANDLE(ghDataTable) THEN DO:
    ghDataTable:FIND-FIRST().
    IF ghDataTable:AVAILABLE THEN DO WITH FRAME {&FRAME-NAME}:
      IF VALID-HANDLE(ghAttrObject) THEN
        RUN setInfo IN ghAttrObject (INPUT ghDataTable).
    END.
  END.

  IF VALID-HANDLE(hDataTable) THEN DO:
    hDataTable = ?.
  END.
  glNeedToSave = FALSE.
  
  SESSION:SET-WAIT-STATE("":U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setFields vTableWin 
PROCEDURE setFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcState AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hLookup       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cRunAttribute AS CHARACTER  NO-UNDO.

  IF NOT VALID-HANDLE(ghToolbar) THEN
    RETURN.

  glNew = FALSE.
  RUN enableButton IN hObjectFilename.
  {get LookupHandle hLookup hObjectFileName}.

  CASE pcState:
    WHEN "Init" THEN DO:
      DYNAMIC-FUNCTION("disableActions":U IN ghToolbar, "cbModify,cbCancel,cbCopy,cbDelete,cbSave,cbFind,cbUndo,CntainerPreview,Properties":U).
    END.
    WHEN "New":U THEN DO:
      glAppliedLeave = FALSE.
      RUN unregisterPSObjects IN ghContainerSource (INPUT "":U).
      IF VALID-HANDLE(ghDataTable) THEN DO:
        ghDataTable:EMPTY-TEMP-TABLE().
        ghDataTable = ?.
      END.
      DYNAMIC-FUNCTION("disableActions":U IN ghToolbar, "New,cbCopy,cbDelete,cbFind,cbUndo,CntainerPreview":U).
      DYNAMIC-FUNCTION("enableActions":U IN ghToolbar, "cbSave,cbCancel,Properties":U).
      RUN enableField IN hObjectFilename.
      RUN enableField IN hProductModule.
      RUN enableField IN hObjectType.
      RUN enableField IN hCustomSuperProcedure.
      RUN enableField IN hContainerTemplate.
      RUN disableButton IN hObjectFilename.
      ENABLE fiObjectDescription WITH FRAME {&FRAME-NAME}.
      PUBLISH "disableObject" FROM ghContainerSource.
      glNew = TRUE.
      DYNAMIC-FUNCTION("statusText":U IN ghContainerSource,"Create new Dynamic TreeView.").
      ghContainerHandle:TITLE = gcWindowTitle + " - New".
      {get RunAttribute cRunAttribute ghContainerSource}.
      IF cRunAttribute BEGINS "AppBuilder":U THEN DO:
        IF TRIM(ENTRY(2,cRunAttribute,CHR(3))) <> "":U THEN
          DYNAMIC-FUNCTION("setDataValue":U IN hProductModule, TRIM(ENTRY(2,cRunAttribute,CHR(3)))).
      END.
      
      IF gcAppObjectType = "":U OR 
         gcAppObjectType = ? THEN
        gcAppObjectType = "DynTree":U.
      
      {set DataValue gcAppObjectType hObjectType}.

      /* Adding new record - create temp-table */
      RUN newRecord IN ghContainerSource (INPUT "":U).

      IF VALID-HANDLE(ghDataTable) THEN DO:
        /* Check if we used a template object - if we did - get out */
        ghDataTable:FIND-FIRST().
        IF ghDataTable:AVAILABLE THEN 
          RETURN.
        ghDataTable:EMPTY-TEMP-TABLE().
        ghDataTable = ?.
      END.

      ghDataTable = DYNAMIC-FUNCTION("getTreeTable":U IN ghContainerSource).
      
      ghDataTable = ghDataTable:DEFAULT-BUFFER-HANDLE.
      ghDataTable:BUFFER-CREATE().
      IF VALID-HANDLE(ghAttrObject) THEN DO:
        RUN setInfo IN ghAttrObject (INPUT ghDataTable).
        DYNAMIC-FUNCTION("enableActions":U IN ghToolbar, "Properties":U).
      END.


      APPLY "ENTRY":U TO hLookup.
    END.
    WHEN "Find":U THEN DO:
      RUN unregisterPSObjects IN ghContainerSource (INPUT "":U).
      DYNAMIC-FUNCTION("disableActions":U IN ghToolbar, "cbCancel,cbCopy,cbDelete,cbSave,cbFind,cbUndo,CntainerPreview,Properties":U).
      DYNAMIC-FUNCTION("enableActions":U IN ghToolbar, "New":U).
      RUN disableField IN hProductModule.
      RUN disableField IN hObjectType.
      RUN disableField IN hCustomSuperProcedure.
      RUN disableField IN hContainerTemplate.
      RUN enableField IN hObjectFilename.
      DISABLE fiObjectDescription buCreate WITH FRAME {&FRAME-NAME}.
      PUBLISH "disableObject" FROM ghContainerSource.
      RUN assignNewValue IN hObjectFilename (INPUT "":U, INPUT "":U, INPUT FALSE).
      DYNAMIC-FUNCTION("statusText":U IN ghContainerSource,"Find an existing Dynamic TreeView.").
      ghContainerHandle:TITLE = gcWindowTitle + " - Open".
      APPLY "ENTRY":U TO hLookup.
    END.
    WHEN "Modify":U THEN DO:
      DYNAMIC-FUNCTION("disableActions":U IN ghToolbar, "cbCancel,cbSave,cbUndo":U).
      DYNAMIC-FUNCTION("enableActions":U IN ghToolbar, "New,cbCopy,cbFind,cbDelete,CntainerPreview,Properties":U).
      RUN disableField IN hObjectFilename.
      RUN disableField IN hProductModule.
      RUN disableField IN hObjectType.
      RUN enableField IN hCustomSuperProcedure.
      ENABLE fiObjectDescription WITH FRAME {&FRAME-NAME}.
      RUN disableField IN hContainerTemplate.
      DISABLE buCreate WITH FRAME {&FRAME-NAME}.
      ghContainerHandle:TITLE = gcWindowTitle + " - " + hLookup:SCREEN-VALUE.
    END.
    WHEN "Cancel":U THEN DO:
      IF VALID-HANDLE(ghDataTable) THEN DO:
        ghDataTable:EMPTY-TEMP-TABLE().
        ghDataTable = ?.
      END.
      glNeedToSave = FALSE.
      RUN disableField IN hProductModule.
      DISABLE WITH FRAME {&FRAME-NAME}.
      DYNAMIC-FUNCTION("disableActions":U IN ghToolbar, "cbCancel,cbSave,Properties":U).
      DYNAMIC-FUNCTION("enableActions":U IN ghToolbar, "New,cbCopy,cbFind,cbDelete,CntainerPreview":U).
      RUN enableField IN hObjectFilename.
      RUN disableField IN hCustomSuperProcedure.
      RUN disableField IN hObjectType.
      RUN disableField IN hContainerTemplate.
      DISABLE buCreate WITH FRAME {&FRAME-NAME}.
      clearDetails(TRUE).
      RUN setFields ("FIND":U).
    END.
    WHEN "Save":U THEN DO:
      glNeedToSave = FALSE.
      DYNAMIC-FUNCTION("disableActions":U IN ghToolbar, "cbCancel,cbSave,cbUndo":U).
      DYNAMIC-FUNCTION("enableActions":U IN ghToolbar, "New,cbCopy,cbFind,cbDelete,CntainerPreview,Properties":U).
      RUN disableField IN hObjectFilename.
      RUN disableField IN hProductModule.
      RUN disableField IN hObjectType.
      RUN enableField IN hCustomSuperProcedure.
      ENABLE fiObjectDescription WITH FRAME {&FRAME-NAME}.
      RUN disableField IN hContainerTemplate.
      DISABLE buCreate WITH FRAME {&FRAME-NAME}.
    END.
    WHEN "Change":U THEN DO:
      glNeedToSave = TRUE.
      DYNAMIC-FUNCTION("disableActions":U IN ghToolbar, "New,cbCopy,cbFind,cbDelete,CntainerPreview":U).
      DYNAMIC-FUNCTION("enableActions":U IN ghToolbar, "cbSave,cbUndo,,Properties":U).
      RUN disableField IN hObjectType.
      DISABLE buCreate WITH FRAME {&FRAME-NAME}.
    END.
  END CASE.

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setOtherDetails vTableWin 
PROCEDURE setOtherDetails :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will assign the Description and super procedure
               name of the opened object.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 IF VALID-HANDLE(ghDataTable) THEN DO:
    ghDataTable:FIND-FIRST().
    IF ghDataTable:AVAILABLE THEN DO WITH FRAME {&FRAME-NAME}:
      ASSIGN glTrackChanges = FALSE.
      ASSIGN fiObjectDescription:SCREEN-VALUE = ghDataTable:BUFFER-FIELD('cObjectDescription':U):BUFFER-VALUE.
      DYNAMIC-FUNCTION("setDataValue":U IN hObjectType, INPUT ghDataTable:BUFFER-FIELD('cObjectTypeCode':U):BUFFER-VALUE).
      RUN assignNewValue IN hCustomSuperProcedure (INPUT ghDataTable:BUFFER-FIELD('cCustomSuperProc':U):BUFFER-VALUE,"":U,INPUT FALSE).
      ASSIGN glTrackChanges = TRUE.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE templateLookupChange vTableWin 
PROCEDURE templateLookupChange :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hLookup AS HANDLE     NO-UNDO.
  {get LookupHandle hLookup hContainerTemplate}.

  IF TRIM(hLookup:SCREEN-VALUE) = "":U THEN
    DISABLE buCreate WITH FRAME {&FRAME-NAME}.
  ELSE
    ENABLE buCreate WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateData vTableWin 
PROCEDURE validateData :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will validate the data on the screen to ensure
               that the data enetered is valid.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cObjectFileName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProductModule    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessage          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessageList      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hFileNameLookup   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cObjectType       AS CHARACTER  NO-UNDO.
  
  SESSION:SET-WAIT-STATE("GENERAL":U).
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fiObjectDescription.
  END.
  
  {get LookupHandle hFileNameLookup hObjectFileName}.
  {get DataValue cProductModule hProductModule}.
  {get DataValue cObjectType hObjectType}.
  
  cObjectFileName = hFileNameLookup:SCREEN-VALUE.

  IF cObjectFileName = "":U THEN
    cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                  {af/sup2/aferrortxt.i 'AF' '1' '' '' '"Object Filename"'}.

  IF cProductModule = "":U THEN
    cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                  {af/sup2/aferrortxt.i 'AF' '1' '' '' '"Product Module"'}.

  IF cObjectType = "":U THEN
    cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                  {af/sup2/aferrortxt.i 'AF' '1' '' '' '"Object Type"'}.

  RUN validateData IN ghAttrObject (OUTPUT cMessage).
  
  cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + cMessage. 
  SESSION:SET-WAIT-STATE("":U).
  IF cMessageList <> "":U THEN DO:
    RUN showMessages IN gshSessionManager (INPUT cMessageList,
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Validation Error",
                                           INPUT YES,
                                           INPUT ?,
                                           OUTPUT cButton).
    RETURN ERROR "VALIDATION-FAILED":U.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignObjectType vTableWin 
FUNCTION assignObjectType RETURNS LOGICAL
  ( pcObjectType AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  gcAppObjectType = pcObjectType.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION clearDetails vTableWin 
FUNCTION clearDetails RETURNS LOGICAL
  ( plClearAll AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF VALID-HANDLE(ghContainerSource) THEN
    PUBLISH "clearAll":U FROM ghContainerSource.
  
  IF plClearAll THEN DO:
    /* Clear old data out of frame */
    DO WITH FRAME {&FRAME-NAME}:
      ASSIGN fiObjectDescription:SCREEN-VALUE = "":U
             .
    END.
    RUN assignNewValue IN hObjectFilename (INPUT "":U, INPUT "":U, INPUT FALSE).
    RUN assignNewValue IN hCustomSuperProcedure (INPUT "":U, INPUT "":U, INPUT FALSE).
    RUN assignNewValue IN hContainerTemplate (INPUT "":U, INPUT "":U, INPUT FALSE).
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getChangesMade vTableWin 
FUNCTION getChangesMade RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF NOT glNew THEN
    RETURN glNeedToSave.   /* Function return value. */
  ELSE 
    RETURN glNew.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTreeViewName vTableWin 
FUNCTION getTreeViewName RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hLookup AS HANDLE     NO-UNDO.
  
  {get LookupHandle hLookup hObjectFileName}.
  
  RETURN hLookup:SCREEN-VALUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setToolbarHandle vTableWin 
FUNCTION setToolbarHandle RETURNS LOGICAL
  ( INPUT phToolbarHandle AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  ASSIGN ghToolbar = phToolbarHandle.
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

