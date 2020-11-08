&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
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
  File: containerv.w

  Description:  Container Viewer

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   02/25/2002  Author:     

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

&scop object-name       containerv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{src/adm2/globals.i}

&GLOBAL-DEFINE define-only YES
{ry/inc/rycntnerbi.i}

DEFINE VARIABLE gcValidDataContainers   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcTemplateBaseQuery     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSmartFrameClasses     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcValidContainers       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glDoNotDisplayTemplate  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glAppBuilder            AS LOGICAL    NO-UNDO.
DEFINE VARIABLE ghContainerSource       AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghProcLib               AS HANDLE     NO-UNDO.

DEFINE VARIABLE ghSmartObject       AS HANDLE     NO-UNDO.

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
&Scoped-Define DISPLAYED-OBJECTS fiObjectDescription fiContainerTemplate ~
toTemplateObject fiWindowName 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD applyLeaveToLookups vTableWin 
FUNCTION applyLeaveToLookups RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD evaluateActions vTableWin 
FUNCTION evaluateActions RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSDFHandle vTableWin 
FUNCTION getSDFHandle RETURNS HANDLE
  (pcLookupName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isValidOTChange vTableWin 
FUNCTION isValidOTChange RETURNS LOGICAL
  (pdObjectTypeObj  AS DECIMAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD pageOrInstanceExist vTableWin 
FUNCTION pageOrInstanceExist RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAttribute vTableWin 
FUNCTION setAttribute RETURNS LOGICAL
  (pcAttribute AS CHARACTER,
   pcValue     AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD updatePropertyValue vTableWin 
FUNCTION updatePropertyValue RETURNS LOGICAL
  (pcObject         AS CHARACTER,
   pcAttributeLabel AS CHARACTER,
   pcAttributeValue AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE hContainerTemplate AS HANDLE NO-UNDO.
DEFINE VARIABLE hCustomSuperProcedure AS HANDLE NO-UNDO.
DEFINE VARIABLE hDLProcedure AS HANDLE NO-UNDO.
DEFINE VARIABLE hObjectFilename AS HANDLE NO-UNDO.
DEFINE VARIABLE hObjectType AS HANDLE NO-UNDO.
DEFINE VARIABLE hProductModule AS HANDLE NO-UNDO.
DEFINE VARIABLE hResultCode AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buCreate 
     LABEL "Create" 
     SIZE 12.6 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE fiContainerTemplate AS CHARACTER FORMAT "X(256)":U INITIAL "  Create from existing container" 
      VIEW-AS TEXT 
     SIZE 29.8 BY .62 NO-UNDO.

DEFINE VARIABLE fiObjectDescription AS CHARACTER FORMAT "X(35)":U 
     LABEL "Description" 
     VIEW-AS FILL-IN 
     SIZE 44.2 BY 1 NO-UNDO.

DEFINE VARIABLE fiWindowName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Window name" 
     VIEW-AS FILL-IN 
     SIZE 48.4 BY 1 NO-UNDO.

DEFINE RECTANGLE rctContainerTemplate
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 69.2 BY 1.67.

DEFINE VARIABLE toTemplateObject AS LOGICAL INITIAL no 
     LABEL "Template object" 
     VIEW-AS TOGGLE-BOX
     SIZE 19.8 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     fiObjectDescription AT ROW 6.05 COL 18 COLON-ALIGNED
     buCreate AT ROW 1.67 COL 129.8
     fiContainerTemplate AT ROW 1 COL 73.6 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     toTemplateObject AT ROW 5.14 COL 95.8
     fiWindowName AT ROW 6.05 COL 93.8 COLON-ALIGNED
     rctContainerTemplate AT ROW 1.38 COL 74.6
     SPACE(0.40) SKIP(3.00)
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
         HEIGHT             = 6.05
         WIDTH              = 143.2.
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
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON buCreate IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiContainerTemplate IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiObjectDescription IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiWindowName IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rctContainerTemplate IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX toTemplateObject IN FRAME frMain
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
  RUN fetchTemplateData.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiObjectDescription
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiObjectDescription vTableWin
ON VALUE-CHANGED OF fiObjectDescription IN FRAME frMain /* Description */
DO:
  ASSIGN
      fiObjectDescription

      ghSmartObject:BUFFER-FIELD("c_object_description":U):BUFFER-VALUE = fiObjectDescription:SCREEN-VALUE.

  DYNAMIC-FUNCTION("evaluateActions":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiWindowName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiWindowName vTableWin
ON VALUE-CHANGED OF fiWindowName IN FRAME frMain /* Window name */
DO:
  ASSIGN
      fiWindowName.

  DYNAMIC-FUNCTION("setUserProperty":U, "DontDisplay":U, "No":U).

  DYNAMIC-FUNCTION("setAttribute":U, "WindowName":U, fiWindowName:SCREEN-VALUE).
  DYNAMIC-FUNCTION("evaluateActions":U).

  DYNAMIC-FUNCTION("setUserProperty":U, "DontDisplay":U, "Yes":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toTemplateObject
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toTemplateObject vTableWin
ON VALUE-CHANGED OF toTemplateObject IN FRAME frMain /* Template object */
DO:
  ASSIGN
      toTemplateObject

      ghSmartObject:BUFFER-FIELD("l_template_smartobject":U):BUFFER-VALUE   = toTemplateObject:CHECKED.

  DYNAMIC-FUNCTION("evaluateActions":U).
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
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.smartobject_objFieldLabelContainerFieldTooltipPress F4 for LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object_type NO-LOCK
                     WHERE LOOKUP(gsc_object_type.object_type_code, gsc_object_type.object_type_code) <> 0,
                     EACH ryc_smartobject NO-LOCK
                     WHERE ryc_smartobject.object_type_obj      = gsc_object_type.object_type_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj
                     AND [&FilterSet=|&EntityList=GSCPM,RYCSO],
                     FIRST ryc_customization_result NO-LOCK
                     WHERE ryc_customization_result.customization_result_obj = ryc_smartobject.customization_result_obj OUTER-JOIN,
                     FIRST ryc_customization_type NO-LOCK
                     WHERE ryc_customization_type.customization_type_obj = ryc_customization_result.customization_type_obj OUTER-JOIN
                     BY ryc_smartobject.object_filename INDEXED-REPOSITIONQueryTablesgsc_object_type,ryc_smartobject,gsc_product_module,ryc_customization_result,ryc_customization_typeBrowseFieldsryc_smartobject.object_filename,gsc_object_type.object_type_code,ryc_customization_result.customization_result_code,gsc_product_module.product_module_code,ryc_smartobject.object_description,ryc_smartobject.static_object,ryc_smartobject.template_smartobject,ryc_smartobject.container_object,ryc_customization_type.customization_type_codeBrowseFieldDataTypescharacter,character,character,character,character,logical,logical,logical,characterBrowseFieldFormatsX(70)|X(35)|X(70)|X(35)|X(35)|YES/NO|YES/NO|YES/NO|X(15)RowsToBatch200BrowseTitleContainer LookupViewerLinkedFieldsryc_smartobject.customization_result_obj,ryc_customization_result.customization_result_codeLinkedFieldDataTypesdecimal,characterLinkedFieldFormats->>>>>>>>>>>>>>>>>9.999999999,X(70)ViewerLinkedWidgets?,?ColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesFieldName<Local1>DisplayFieldyesEnableFieldyesLocalFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hObjectFilename ).
       RUN repositionObject IN hObjectFilename ( 1.00 , 20.00 ) NO-ERROR.
       RUN resizeObject IN hObjectFilename ( 1.00 , 49.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_customization_result.customization_result_codeKeyFieldryc_customization_result.customization_result_objFieldLabelResult codeFieldTooltipPress F4 For LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH ryc_customization_type NO-LOCK,
                     EACH ryc_customization_result NO-LOCK
                     WHERE ryc_customization_result.customization_type_obj = ryc_customization_type.customization_type_obj INDEXED-REPOSITIONQueryTablesryc_customization_type,ryc_customization_resultBrowseFieldsryc_customization_result.customization_result_code,ryc_customization_result.customization_result_desc,ryc_customization_result.system_owned,ryc_customization_type.customization_type_code,ryc_customization_type.customization_type_desc,ryc_customization_type.api_nameBrowseFieldDataTypescharacter,character,logical,character,character,characterBrowseFieldFormatsX(70)|X(70)|YES/NO|X(15)|X(35)|X(70)RowsToBatch200BrowseTitleResult Code LookupViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesFieldName<Local2>DisplayFieldyesEnableFieldyesLocalFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hResultCode ).
       RUN repositionObject IN hResultCode ( 2.00 , 20.00 ) NO-ERROR.
       RUN resizeObject IN hResultCode ( 1.00 , 49.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dyncombo.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_object_type.object_type_description,gsc_object_type.object_type_codeKeyFieldgsc_object_type.object_type_objFieldLabelTypeFieldTooltipSelect option from listKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(256)DisplayDatatypeCHARACTERBaseQueryStringFOR EACH gsc_object_type NO-LOCK
                     WHERE LOOKUP(gsc_object_type.object_type_code, gsc_object_type.object_type_code) <> 0QueryTablesgsc_object_typeSDFFileNameSDFTemplateParentFieldParentFilterQueryDescSubstitute&2 / &1ComboDelimiterListItemPairsInnerLines5ComboFlagFlagValueBuildSequence1SecurednoCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesUseCacheyesFieldName<Local3>DisplayFieldyesEnableFieldyesLocalFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hObjectType ).
       RUN repositionObject IN hObjectType ( 3.00 , 20.00 ) NO-ERROR.
       RUN resizeObject IN hObjectType ( 1.05 , 44.20 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.smartobject_objFieldLabelSuper procedureFieldTooltipPress F4 for LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object_type NO-LOCK
                     WHERE gsc_object_type.object_type_code = ~'PROCEDURE~':U,
                     EACH ryc_smartobject NO-LOCK
                     WHERE ryc_smartobject.object_type_obj = gsc_object_type.object_type_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj
                     AND [&FilterSet=|&EntityList=GSCPM,RYCSO]
                     INDEXED-REPOSITIONQueryTablesgsc_object_type,ryc_smartobject,gsc_product_moduleBrowseFieldsryc_smartobject.object_filename,ryc_smartobject.object_description,gsc_product_module.product_module_codeBrowseFieldDataTypescharacter,character,characterBrowseFieldFormatsX(70)|X(35)|X(35)RowsToBatch200BrowseTitleCustom Super Procedure LookupViewerLinkedFieldsryc_smartobject.object_extension,ryc_smartobject.object_pathLinkedFieldDataTypescharacter,characterLinkedFieldFormatsX(35),X(70)ViewerLinkedWidgets?,?ColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesFieldName<Local5>DisplayFieldyesEnableFieldnoLocalFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hCustomSuperProcedure ).
       RUN repositionObject IN hCustomSuperProcedure ( 4.05 , 20.00 ) NO-ERROR.
       RUN resizeObject IN hCustomSuperProcedure ( 1.00 , 49.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.object_filenameFieldLabelDL procedureFieldTooltipPress F4 for LookupKeyFormatX(70)KeyDatatypecharacterDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object_type NO-LOCK
                     WHERE gsc_object_type.object_type_code = ~'DLProc~':U,
                     EACH ryc_smartobject NO-LOCK
                     WHERE ryc_smartobject.object_type_obj = gsc_object_type.object_type_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj
                     AND [&FilterSet=|&EntityList=GSCPM,RYCSO]
                     INDEXED-REPOSITIONQueryTablesgsc_object_type,ryc_smartobject,gsc_product_moduleBrowseFieldsryc_smartobject.object_filename,gsc_product_module.product_module_code,ryc_smartobject.object_descriptionBrowseFieldDataTypescharacter,character,characterBrowseFieldFormatsX(70)|X(35)|X(35)RowsToBatch200BrowseTitleDataLogic Procedure LookupViewerLinkedFieldsryc_smartobject.object_path,ryc_smartobject.object_extensionLinkedFieldDataTypescharacter,characterLinkedFieldFormatsX(70),X(35)ViewerLinkedWidgets?,?ColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesFieldNamefiDLProcedureDisplayFieldyesEnableFieldyesLocalFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hDLProcedure ).
       RUN repositionObject IN hDLProcedure ( 5.05 , 20.00 ) NO-ERROR.
       RUN resizeObject IN hDLProcedure ( 1.00 , 49.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.object_filenameFieldLabelContainerFieldTooltipPress F4 for LookupKeyFormatX(70)KeyDatatypecharacterDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object_type NO-LOCK
                     WHERE LOOKUP(gsc_object_type.object_type_code, gsc_object_type.object_type_code) <> 0,
                     EACH ryc_smartobject NO-LOCK
                     WHERE ryc_smartobject.object_type_obj      = gsc_object_type.object_type_obj
                     AND ryc_smartobject.customization_result_obj = 0,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj
                     AND [&FilterSet=|&EntityList=GSCPM,RYCSO]
                     BY ryc_smartobject.object_filename INDEXED-REPOSITIONQueryTablesgsc_object_type,ryc_smartobject,gsc_product_moduleBrowseFieldsryc_smartobject.object_filename,ryc_smartobject.template_smartobject,ryc_smartobject.object_description,ryc_smartobject.static_object,gsc_object_type.object_type_code,ryc_smartobject.container_objectBrowseFieldDataTypescharacter,logical,character,logical,character,logicalBrowseFieldFormatsX(70)|YES/NO|X(35)|YES/NO|X(35)|YES/NORowsToBatch200BrowseTitleContainer LookupViewerLinkedFieldsryc_smartobject.customization_result_obj,ryc_smartobject.object_descriptionLinkedFieldDataTypesdecimal,characterLinkedFieldFormats->>>>>>>>>>>>>>>>>9.999999999,X(35)ViewerLinkedWidgets?,?ColumnLabels,Template,,,,ContainerColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesFieldName<Local6>DisplayFieldyesEnableFieldyesLocalFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hContainerTemplate ).
       RUN repositionObject IN hContainerTemplate ( 1.71 , 86.20 ) NO-ERROR.
       RUN resizeObject IN hContainerTemplate ( 1.00 , 43.20 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dyncombo.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_product_module.product_module_description,gsc_product_module.product_module_codeKeyFieldgsc_product_module.product_module_objFieldLabelProduct moduleFieldTooltipSelect option from listKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(256)DisplayDatatypeCHARACTERBaseQueryStringFOR EACH gsc_product_module NO-LOCK
                     WHERE [&FilterSet=|&EntityList=GSCPM]
                     BY gsc_product_module.product_module_codeQueryTablesgsc_product_moduleSDFFileNameSDFTemplateParentFieldParentFilterQueryDescSubstitute&2 / &1ComboDelimiterListItemPairsInnerLines5ComboFlagFlagValueBuildSequence1SecurednoCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesUseCacheyesFieldName<Local4>DisplayFieldyesEnableFieldyesLocalFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hProductModule ).
       RUN repositionObject IN hProductModule ( 4.00 , 95.80 ) NO-ERROR.
       RUN resizeObject IN hProductModule ( 1.05 , 48.40 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( hObjectFilename ,
             fiObjectDescription:HANDLE IN FRAME frMain , 'BEFORE':U ).
       RUN adjustTabOrder ( hResultCode ,
             hObjectFilename , 'AFTER':U ).
       RUN adjustTabOrder ( hObjectType ,
             hResultCode , 'AFTER':U ).
       RUN adjustTabOrder ( hCustomSuperProcedure ,
             hObjectType , 'AFTER':U ).
       RUN adjustTabOrder ( hDLProcedure ,
             hCustomSuperProcedure , 'AFTER':U ).
       RUN adjustTabOrder ( hContainerTemplate ,
             fiObjectDescription:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( hProductModule ,
             buCreate:HANDLE IN FRAME frMain , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearViewer vTableWin 
PROCEDURE clearViewer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cCurrentProductModule AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyFormat            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEntry                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lSuccess              AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iEntry                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hLookupFillIn         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hCombo                AS HANDLE     NO-UNDO.

  IF VALID-HANDLE(gshRepositoryManager)                                              AND
     LOOKUP("getCurrentProductModule":U, gshRepositoryManager:INTERNAL-ENTRIES) <> 0 THEN
    ASSIGN
        hCombo                = DYNAMIC-FUNCTION("getComboHandle":U IN hProductModule)
        cKeyFormat            = DYNAMIC-FUNCTION("getKeyFormat":U   IN hProductModule)
        cCurrentProductModule = DYNAMIC-FUNCTION("getCurrentProductModule":U IN gshRepositoryManager)
        cCurrentProductModule = REPLACE(cCurrentProductModule, "//":U, "/":U)
        iEntry                = LOOKUP(cCurrentProductModule, hCombo:LIST-ITEM-PAIRS, hCombo:DELIMITER)
        iEntry                = IF iEntry = 0 THEN 1 ELSE iEntry
        cEntry                = ENTRY(iEntry + 1, hCombo:LIST-ITEM-PAIRS, hCombo:DELIMITER)
        lSuccess              = DYNAMIC-FUNCTION("setDataValue":U IN hProductModule, DECIMAL(cEntry))
        hCombo:SCREEN-VALUE   = TRIM(STRING(DECIMAL(cEntry), cKeyFormat)).

  ASSIGN
      hLookupFillIn              = DYNAMIC-FUNCTION("getLookupHandle":U IN hCustomSuperProcedure)
      hLookupFillIn:SCREEN-VALUE = "":U
      lSuccess                   = DYNAMIC-FUNCTION("setDataValue":U    IN hCustomSuperProcedure, "0":U)
      hLookupFillIn              = DYNAMIC-FUNCTION("getLookupHandle":U IN hContainerTemplate)
      hLookupFillIn:SCREEN-VALUE = "":U
      lSuccess                   = DYNAMIC-FUNCTION("setDataValue":U    IN hContainerTemplate, "")
      hLookupFillIn              = DYNAMIC-FUNCTION("getLookupHandle":U IN hResultCode)
      hLookupFillIn:SCREEN-VALUE = "":U
      lSuccess                   = DYNAMIC-FUNCTION("setDataValue":U    IN hResultCode, "0")
      hLookupFillIn              = DYNAMIC-FUNCTION("getLookupHandle":U IN hObjectFilename)
      hLookupFillIn:SCREEN-VALUE = "":U
      lSuccess                   = DYNAMIC-FUNCTION("setDataValue":U    IN hObjectFileName, "0").

  APPLY "ENTRY":U TO hLookupFillIn.

  RETURN.

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

  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE httObjectInstance       AS HANDLE     NO-UNDO.

  DYNAMIC-FUNCTION("evaluateActions":U).

  ASSIGN
      dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "CustomizationResultObj":U))
      httObjectInstance       = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ttObjectInstance":U)).

  IF phField = hProductModule THEN
    ghSmartObject:BUFFER-FIELD("d_product_module_obj":U):BUFFER-VALUE = DYNAMIC-FUNCTION("getDataValue":U IN hProductModule).

  IF phField = hObjectType THEN
    RUN evaluateOTChange (INPUT DECIMAL(pcKeyFieldValue)).

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
  IF VALID-HANDLE(ghSmartObject) THEN
    DELETE OBJECT ghSmartObject.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableSearchLookups vTableWin 
PROCEDURE enableSearchLookups :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER plEnable AS LOGICAL    NO-UNDO.
  
  DEFINE VARIABLE cContainerMode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hLookupFillIn   AS HANDLE     NO-UNDO.

  cContainerMode = DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ContainerMode":U).

  RUN disableField IN hResultCode.

  IF plEnable = TRUE THEN
  DO:
    RUN clearViewer.

    RUN enableField IN hObjectFilename.

    IF cContainerMode = "ADD":U THEN
      RUN disableButton IN hObjectFilename.
    
    ASSIGN
        hLookupFillIn           = DYNAMIC-FUNCTION("getLookupHandle":U IN hObjectFilename)
        hLookupFillIn:SENSITIVE = TRUE.

    APPLY "ENTRY":U TO hLookupFillIn.
  END.
  ELSE
  DO:
    IF cContainerMode = "ADD":U THEN
    DO:
      RUN enableField  IN hObjectFilename.
      RUN disableField IN hResultCode.
      
      RUN disableButton IN hObjectFilename.

      ASSIGN
          hLookupFillIn           = DYNAMIC-FUNCTION("getLookupHandle":U IN hObjectFilename)
          hLookupFillIn:SENSITIVE = TRUE.

      APPLY "ENTRY":U TO hLookupFillIn.
    END.
    ELSE
    IF cContainerMode <> "FIND":U THEN
      RUN disableField IN hObjectFilename.
  END.
  
  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableViewerObjects vTableWin 
PROCEDURE enableViewerObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER plEnable AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE cContainerMode          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE hObject                 AS HANDLE     NO-UNDO.
  
  ASSIGN
      dCustomizationResultObj = DECIMAL({fnarg getUserProperty 'CustomizationResultObj':U ghContainerSource})
      cContainerMode          = {fnarg getUserProperty 'ContainerMode':U ghContainerSource}.

  DO WITH FRAME {&FRAME-NAME}:
    IF plEnable = TRUE THEN
    DO:
      IF cContainerMode <> "FIND":U THEN
      DO WITH FRAME {&FRAME-NAME}:
        ENABLE 
            fiObjectDescription.

        IF {fnarg getUserProperty 'FrameContainer':U ghContainerSource} = "no":U AND
           {fnarg getUserProperty 'DataContainer':U  ghContainerSource} = "no":U THEN
          ENABLE
              fiWindowName.

        IF {fnarg getUserProperty 'DataContainer':U  ghContainerSource} = "yes":U THEN
          RUN enableField IN hDLProcedure.

        RUN enableField IN hCustomSuperProcedure.
        
        IF dCustomizationResultObj = 0.00 THEN
        DO:
          RUN enableField IN hContainerTemplate.

          {fn pageOrInstanceExist}.

          ENABLE toTemplateObject.
        END.
        ELSE
          DISABLE toTemplateObject.

        IF cContainerMode = "ADD":U THEN
        DO:
          RUN enableField IN hProductModule.
          
          IF NOT glAppBuilder THEN
            RUN enableField IN hObjectType.

          ASSIGN
              ghSmartObject:BUFFER-FIELD("d_product_module_obj":U):BUFFER-VALUE = {fn getDataValue hProductModule}
              ghSmartObject:BUFFER-FIELD("d_object_type_obj":U):BUFFER-VALUE    = {fn getDataValue hObjectType}

              hObject              = {fn getLookupHandle hContainerTemplate}
              hObject:SCREEN-VALUE = ghSmartObject:BUFFER-FIELD("c_template_object_name":U):BUFFER-VALUE.
        END.
        ELSE
        DO:
          IF {fnarg getUserProperty 'DataContainer':U  ghContainerSource} = "yes":U THEN
            RUN disableField IN hResultCode.
          ELSE
            RUN enableField  IN hResultCode.

          IF cContainerMode = "MODIFY":U THEN
            RUN disableField IN hProductModule.
        END.
      END.
    END.
    ELSE
    DO:
      DISABLE 
          fiObjectDescription
          fiWindowName
          toTemplateObject
          buCreate.
    
      RUN disableField IN hCustomSuperProcedure.
      RUN disableField IN hContainerTemplate.
      RUN disableField IN hProductModule.
      RUN disableField IN hDLProcedure.
      RUN disableField IN hObjectType.
      RUN disableField IN hResultCode.
    END.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE evaluateOTChange vTableWin 
PROCEDURE evaluateOTChange :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdObjectTypeObj  AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE cNewObjectTypeCode      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOldObjectTypeCode      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBaseQueryString        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessage                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lFrameContainer         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lDataContainer          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lValidChange            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lLogical                AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE httObjectMenuStructure  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httObjectInstance       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httObjectType           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httPage                 AS HANDLE     NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        httObjectMenuStructure  = WIDGET-HANDLE({fnarg getUserProperty 'ttObjectMenuStructure'  ghContainerSource})
        httObjectInstance       = WIDGET-HANDLE({fnarg getUserProperty 'ttObjectInstance'       ghContainerSource})
        httObjectType           = WIDGET-HANDLE({fnarg getUserProperty 'ttObjectType'           ghContainerSource})
        httPage                 = WIDGET-HANDLE({fnarg getUserProperty 'ttPage'                 ghContainerSource})
        fiWindowName:SENSITIVE  = FALSE.

    RUN disableField IN hDLProcedure.

    IF pdObjectTypeObj = 0.00 THEN
      pdObjectTypeObj = ghSmartObject:BUFFER-FIELD("d_object_type_obj":U):BUFFER-VALUE.

    httObjectType:FIND-FIRST("WHERE d_object_type_obj = DECIMAL(":U + QUOTER(pdObjectTypeObj) + ")":U, NO-LOCK).

    /* Check if the passed in Object Type is a DataContainer */
    ASSIGN
        cNewObjectTypeCode = httObjectType:BUFFER-FIELD("c_object_type_code":U):BUFFER-VALUE
        lDataContainer     = LOOKUP(cNewObjectTypeCode, gcValidDataContainers) <> 0.

    IF NOT lDataContainer THEN
      lFrameContainer = LOOKUP(cNewObjectTypeCode, {fnarg getClassChildrenFromDB 'DynFrame' gshRepositoryManager}) <> 0.

    IF lDataContainer THEN
    DO:
      /* See if any components are found that are not allowed on a data container */
      /* Object Menu Structures */
      httObjectMenuStructure:FIND-FIRST("WHERE c_action <> 'D'":U) NO-ERROR.

      /* Visible ObjectInstances */
      httObjectInstance:FIND-FIRST("WHERE d_object_instance_obj <> 0 ":U
                                   + "AND d_smartobject_obj     <> 0 ":U
                                   + "AND c_action              <> 'D' ":U
                                   + "AND l_visible_object       = TRUE":U) NO-ERROR.

      /* Pages */
      httPage:FIND-FIRST("WHERE i_page_sequence <> 0 ":U
                         + "AND c_action        <> 'D'":U) NO-ERROR.

      IF httObjectMenuStructure:AVAILABLE OR
         httObjectInstance:AVAILABLE      OR
         httPage:AVAILABLE                THEN
        lValidChange = FALSE.
      ELSE
        lValidChange = TRUE.
    END.
    ELSE
      IF lFrameContainer THEN
      DO:
        httObjectMenuStructure:FIND-FIRST("WHERE c_action <> 'D'":U) NO-ERROR.

        IF httObjectMenuStructure:AVAILABLE THEN
          lValidChange = FALSE.
        ELSE
          lValidChange = TRUE.
      END.
      ELSE
        /* If we are not creating DataContainers or Frames, the change would be allowed */
        lValidChange = TRUE.

    IF lValidChange THEN
    DO:
      httObjectInstance:FIND-FIRST("WHERE d_object_instance_obj = 0":U).

      ASSIGN
          httObjectInstance:BUFFER-FIELD("d_object_type_obj":U):BUFFER-VALUE = {fn getDataValue hObjectType}
          ghSmartObject:BUFFER-FIELD("d_object_type_obj":U):BUFFER-VALUE     = {fn getDataValue hObjectType}

          cBaseQueryString = REPLACE(gcTemplateBaseQuery, ", gsc_object_type.object_type_code":U, ",'" + (IF lDataContainer THEN gcValidDataContainers
                                                                                                                            ELSE gcValidContainers) + "'":U)
          lLogical         = {fnarg setBaseQueryString cBaseQueryString hContainerTemplate}.

      IF lDataContainer THEN
      DO:
        {fnarg setUserProperty "'FrameContainer', 'no'"  ghContainerSource}.
        {fnarg setUserProperty "'DataContainer',  'yes'" ghContainerSource}.

        IF {fnarg getUserProperty 'ContainerMode':U ghContainerSource} <> "FIND":U THEN
          RUN enableField IN hDLProcedure.
      END.
      ELSE
        IF lFrameContainer THEN
        DO:
          {fnarg setUserProperty "'FrameContainer', 'yes'" ghContainerSource}.
          {fnarg setUserProperty "'DataContainer',  'no'"  ghContainerSource}.
        END.
        ELSE
        DO:
          {fnarg setUserProperty "'FrameContainer', 'no'"  ghContainerSource}.
          {fnarg setUserProperty "'DataContainer',  'no'"  ghContainerSource}.

          IF {fnarg getUserProperty 'ContainerMode':U ghContainerSource} <> "FIND":U THEN
            fiWindowName:SENSITIVE = TRUE.
        END.

      PUBLISH "ContainerTypeChange":U FROM ghContainerSource (INPUT lDataContainer).
    END.
    ELSE
    DO:
      {fnarg setUserProperty "'DataContainer', FALSE" ghContainerSource}.

      httObjectType:FIND-FIRST("WHERE d_object_type_obj = DECIMAL(":U + ghSmartObject:BUFFER-FIELD("d_object_type_obj":U):BUFFER-VALUE + ")":U, NO-LOCK).

      ASSIGN
          cOldObjectTypeCode = httObjectType:BUFFER-FIELD("c_object_type_code":U):BUFFER-VALUE
          cMessage           = {af/sup2/aferrortxt.i 'AF' '132' '?' '?' cOldObjectTypeCode cNewObjectTypeCode}.

      RUN showMessages IN gshSessionManager (INPUT  cMessage,                         /* message to display */
                                             INPUT  "ERR":U,                          /* error type         */
                                             INPUT  "&OK":U,                          /* button list        */
                                             INPUT  "&OK":U,                          /* default button     */ 
                                             INPUT  "&OK":U,                          /* cancel button      */
                                             INPUT  "Change of class not allowed":U,  /* error window title */
                                             INPUT  YES,                              /* display if empty   */ 
                                             INPUT  THIS-PROCEDURE,                   /* container handle   */ 
                                             OUTPUT cButton).                         /* button pressed     */

      {set DataValue "ghSmartObject:BUFFER-FIELD('d_object_type_obj':U):BUFFER-VALUE" hObjectType}.
    END.
  END.

  {fn evaluateActions ghContainerSource}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchTemplateData vTableWin 
PROCEDURE fetchTemplateData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cScreenValue  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldValues  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessage      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObject       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQuery        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lExist        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hLookupFillIn AS HANDLE     NO-UNDO.

  /* Check if any changes have been made to the container */
  ASSIGN
      hLookupFillIn = DYNAMIC-FUNCTION("getLookupHandle":U IN hObjectFilename)
      cObject       = DYNAMIC-FUNCTION("getUserProperty":U IN hContainerTemplate, "ObjectFilename":U) + " - ":U
                    + DYNAMIC-FUNCTION("getUserProperty":U IN hContainerTemplate, "ObjectDescription":U)
      lExist        = DYNAMIC-FUNCTION("pageOrInstanceExist":U).

  cQuery = "FOR EACH ryc_smartobject NO-LOCK":U
         + "   WHERE ryc_smartobject.object_filename          = ":U + QUOTER(DYNAMIC-FUNCTION("getUserProperty":U IN hContainerTemplate, "ObjectFilename":U))
         + "     AND ryc_smartobject.customization_result_obj = 0":U.

  RUN getRecordDetail IN gshGenManager (INPUT  cQuery,
                                        OUTPUT cFieldValues) NO-ERROR.

  IF cFieldValues = "":U THEN
  DO:
    cMessage = {af/sup2/aferrortxt.i 'AF' '5' '?' '?' 'container'}.

    RUN showMessages IN gshSessionManager (INPUT  cMessage,                 /* message to display */
                                           INPUT  "INF":U,                  /* error type         */
                                           INPUT  "&OK":U,                  /* button list        */
                                           INPUT  "&OK":U,                  /* default button     */ 
                                           INPUT  "&OK":U,                  /* cancel button      */
                                           INPUT  "Container not found":U,  /* error window title */
                                           INPUT  YES,                      /* display if empty   */ 
                                           INPUT  THIS-PROCEDURE,           /* container handle   */ 
                                           OUTPUT cButton).                 /* button pressed     */

    RETURN.                                           
  END.

  cQuery = "FOR EACH ryc_smartobject NO-LOCK":U
         + "   WHERE ryc_smartobject.object_filename           = '":U + TRIM(hLookupFillIn:SCREEN-VALUE) + "'":U
         + "     AND ryc_smartobject.customization_result_obj <> 0":U.

  IF cObject <> "":U THEN
  DO:
    hLookupFillIn = DYNAMIC-FUNCTION("getLookupHandle":U IN hContainerTemplate).

    IF lExist = FALSE THEN
      cButton = "&Yes":U.
    ELSE
    DO:
      RUN getRecordDetail IN gshGenManager (INPUT  cQuery,
                                            OUTPUT cFieldValues) NO-ERROR.

      ASSIGN
          cMessage = "You have selected '" + cObject
                   + "' as the template for this container." + CHR(10) + CHR(10)
                   + "To replace the entire contents of your container with the contents of the template, select 'Yes'. "
                   + "Remember to save the container in order to commit the changes." + CHR(10) + CHR(10).

      IF TRIM(cFieldValues) <> "":U THEN
        cMessage = cMessage
                 + "WARNING: Customizations have been made against this container. ALL customizations "
                 + "against it will be lost if you choose to regenerate it." + CHR(10) + CHR(10).

      cMessage = cMessage
               + "Do you want to use '" + cObject + "' as the template to regenerate your container?".

      RUN showMessages IN gshSessionManager (INPUT  cMessage,                     /* message to display */
                                             INPUT  "INF":U,                      /* error type         */
                                             INPUT  "&Yes,&No":U,                 /* button list        */
                                             INPUT  "&No":U,                      /* default button     */ 
                                             INPUT  "&No":U,                      /* cancel button      */
                                             INPUT  "Regenerate the container":U, /* error window title */
                                             INPUT  YES,                          /* display if empty   */ 
                                             INPUT  THIS-PROCEDURE,               /* container handle   */ 
                                             OUTPUT cButton).                     /* button pressed     */
    END.

    IF cButton = "&Yes":U THEN
    DO:
      ASSIGN
          cScreenValue                                                        = hLookupFillIn:SCREEN-VALUE
          ghSmartObject:BUFFER-FIELD("c_template_object_name":U):BUFFER-VALUE = cScreenValue
          glDoNotDisplayTemplate                                              = TRUE.

      /* Set this so that the main container data would be retrieved to do the reconstruction from */
      DYNAMIC-FUNCTION("setUserProperty":U IN ghContainerSource, "CustomizationResultObj":U, "0":U).

      glDoNotDisplayTemplate = FALSE.

      RUN fetchTemplateData IN ghContainerSource (INPUT hLookupFillIn:SCREEN-VALUE).

      DYNAMIC-FUNCTION("setAttribute":U, "TemplateObjectName":U, cScreenValue).

      DYNAMIC-FUNCTION("evaluateActions":U).
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getContainerDetails vTableWin 
PROCEDURE getContainerDetails :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phttSmartObject  AS HANDLE     NO-UNDO.

  DEFINE VARIABLE cContainerMode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyFormat      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lSuccess        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hComboHandle    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hObject         AS HANDLE     NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    IF NOT VALID-HANDLE(ghSmartObject) THEN
      CREATE BUFFER ghSmartObject FOR TABLE phttSmartObject.

    ghSmartObject:FIND-BY-ROWID(phttSmartObject:ROWID).

    cContainerMode  = DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ContainerMode":U).

    IF ghSmartObject:AVAILABLE THEN
    DO:
      ASSIGN
          fiObjectDescription:SCREEN-VALUE = ghSmartObject:BUFFER-FIELD("c_object_description":U):BUFFER-VALUE
          toTemplateObject:CHECKED         = ghSmartObject:BUFFER-FIELD("l_template_smartobject":U):BUFFER-VALUE

          hComboHandle          = DYNAMIC-FUNCTION("getComboHandle":U  IN hObjectType)
          hComboHandle:MODIFIED = FALSE
          hObject               = DYNAMIC-FUNCTION("getLookupHandle":U IN hObjectFilename)
          hObject:SCREEN-VALUE  = ghSmartObject:BUFFER-FIELD("c_object_filename":U):BUFFER-VALUE
          lSuccess              = DYNAMIC-FUNCTION("setDataValue":U IN hObjectFilename, ghSmartObject:BUFFER-FIELD("d_smartobject_obj":U):BUFFER-VALUE)

          /* DL Procedure */
          hObject              = DYNAMIC-FUNCTION("getLookupHandle":U IN hDLProcedure)
          lSuccess             = {fnarg displayAttribute "?, 'DataLogicProcedure':U, hObject" ghContainerSource}
          lSuccess             = DYNAMIC-FUNCTION("setDataValue":U    IN hDLProcedure, hObject:SCREEN-VALUE)
          lSuccess             = DYNAMIC-FUNCTION("setUserProperty":U IN hDLProcedure, "DataValue":U, hObject:SCREEN-VALUE)
          
          /* Super Procedure */
          hObject              = DYNAMIC-FUNCTION("getLookupHandle":U IN hCustomSuperProcedure)
          lSuccess             = {fnarg displayAttribute "?, 'SuperProcedure':U, hObject" ghContainerSource}
          lSuccess             = DYNAMIC-FUNCTION("setDataValue":U    IN hCustomSuperProcedure, hObject:SCREEN-VALUE)
          lSuccess             = DYNAMIC-FUNCTION("setUserProperty":U IN hCustomSuperProcedure, "DataValue":U, hObject:SCREEN-VALUE)
          .

      IF ghSmartObject:BUFFER-FIELD("d_object_type_obj":U):BUFFER-VALUE <> 0.00 THEN
      DO:
        DYNAMIC-FUNCTION("setDataValue":U IN hObjectType, ghSmartObject:BUFFER-FIELD("d_object_type_obj":U):BUFFER-VALUE).

        IF cContainerMode <> "ADD":U OR 
           glAppBuilder    = TRUE    THEN
          RUN disableField IN hObjectType.
      END.
      ELSE
        IF cContainerMode = "ADD":U AND
           glAppBuilder   = FALSE   THEN
          RUN enableField IN hObjectType.

      IF ghSmartObject:BUFFER-FIELD("d_product_module_obj":U):BUFFER-VALUE <> 0.00 THEN
        DYNAMIC-FUNCTION("setDataValue":U IN hProductModule, ghSmartObject:BUFFER-FIELD("d_product_module_obj":U):BUFFER-VALUE).
/*
      IF ghSmartObject:BUFFER-FIELD("d_custom_smartobject_obj":U):BUFFER-VALUE <> 0.00 THEN
        ASSIGN
            hObject              = DYNAMIC-FUNCTION("getLookupHandle":U IN hCustomSuperProcedure)
            hObject:SCREEN-VALUE = ghSmartObject:BUFFER-FIELD("c_custom_super_procedure":U):BUFFER-VALUE
            lSuccess             = DYNAMIC-FUNCTION("setDataValue":U IN hCustomSuperProcedure, ghSmartObject:BUFFER-FIELD("d_custom_smartobject_obj":U):BUFFER-VALUE).
      ELSE
        ASSIGN
            ghSmartObject:BUFFER-FIELD("c_custom_super_procedure":U):BUFFER-VALUE = "":U
            hObject              = DYNAMIC-FUNCTION("getLookupHandle":U IN hCustomSuperProcedure)
            hObject:SCREEN-VALUE = ghSmartObject:BUFFER-FIELD("c_custom_super_procedure":U):BUFFER-VALUE
            lSuccess             = DYNAMIC-FUNCTION("setDataValue":U IN hCustomSuperProcedure, 0.00).
*/
      ASSIGN
          hObject              = DYNAMIC-FUNCTION("getLookupHandle":U IN hContainerTemplate)
          hObject:SCREEN-VALUE = ghSmartObject:BUFFER-FIELD("c_template_object_name":U):BUFFER-VALUE
          lSuccess             = DYNAMIC-FUNCTION("setDataValue":U IN hContainerTemplate, ghSmartObject:BUFFER-FIELD("c_template_object_name":U):BUFFER-VALUE).
    
      {fnarg displayAttribute "?, 'WindowName':U, fiWindowName:HANDLE" ghContainerSource}.
    END.
    ELSE
      ASSIGN
          fiObjectDescription:SCREEN-VALUE  = "":U
          fiWindowName:SCREEN-VALUE         = "":U
          toTemplateObject:CHECKED          = FALSE
          hComboHandle                      = DYNAMIC-FUNCTION("getComboHandle":U  IN hObjectType)
          hComboHandle:MODIFIED             = FALSE
          hObject                           = DYNAMIC-FUNCTION("getLookupHandle":U IN hCustomSuperProcedure)
          hObject:SCREEN-VALUE              = "":U
          hObject                           = DYNAMIC-FUNCTION("getLookupHandle":U IN hContainerTemplate)
          hObject:SCREEN-VALUE              = "":U
          hObject                           = DYNAMIC-FUNCTION("getLookupHandle":U IN hDLProcedure)
          hObject:SCREEN-VALUE              = "":U
          lSuccess                          = DYNAMIC-FUNCTION("setUserProperty":U IN hDLProcedure, "DataValue":U, "":U).

    DYNAMIC-FUNCTION("pageOrInstanceExist":U).

    RUN evaluateOTChange (INPUT 0.00).
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
  DEFINE VARIABLE cAppBuilder AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hHandle     AS HANDLE     NO-UNDO.

  {get ContainerSource ghContainerSource}.
  
  SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "lookupDisplayComplete":U  IN THIS-PROCEDURE.
  SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "enableSearchLookups":U    IN ghContainerSource.
  SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "enableViewerObjects":U    IN ghContainerSource.
  SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "comboValueChanged":U      IN THIS-PROCEDURE.
  SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "lookupComplete":U         IN THIS-PROCEDURE.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN displayFields  IN TARGET-PROCEDURE (?).

  RUN resizeObject (FRAME {&FRAME-NAME}:HEIGHT-CHARS, FRAME {&FRAME-NAME}:WIDTH-CHARS).
  RUN setInitialValues.

  cAppBuilder = DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "AppBuilder":U).

  IF cAppBuilder = "yes":U THEN
    glAppBuilder = TRUE.

  /* Add triggers for lookup fill-ins on tab and return */
  {get lookupHandle hHandle hContainerTemplate}. ON "VALUE-CHANGED":U                OF hHandle PERSISTENT RUN trgLookupValueChanged IN THIS-PROCEDURE (INPUT hContainerTemplate).
                                                 ON "RETURN":U OF hHandle OR "TAB":U OF hHandle PERSISTENT RUN leaveLookup           IN hContainerTemplate.
  {get lookupHandle hHandle hObjectFilename}.    ON "RETURN":U OF hHandle OR "TAB":U OF hHandle PERSISTENT RUN leaveLookup           IN hObjectFilename.


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

  DEFINE VARIABLE cObjectDescription      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectFilename         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSuperProcedure         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewResultCode          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContainerMode          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDLProcedure            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldValues            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cResultCode             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cExtension              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessage                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObject                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQuery                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lHasCustomization       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lContinue               AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lChanges                AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSuccess                AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lExist                  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dNewDataValue           AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dDataValue              AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iRequiredEntries        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hLookupFillIn           AS HANDLE     NO-UNDO.

  {get LookupHandle hLookupFillIn hObjectFileName}.
  cContainerMode = {fnarg getUserProperty 'ContainerMode':U ghContainerSource}.

  CASE phObject:
    /* As a record might not exist in the database, the lookup fill-in will be blanked. This
       is perfectly acceptable, but display the value the user typed in, because it will be
       needed to create the new container with. */
    WHEN hObjectFilename THEN
    DO:
      IF (pcDisplayedFieldValue = "":U OR pcDisplayedFieldValue = ?) AND
         {fnarg getUserProperty 'ContainerMode' ghContainerSource} = "FIND":U THEN
        RETURN.

      IF NUM-ENTRIES(pcColumnValues, CHR(1)) >= LOOKUP("ryc_smartobject.customization_result_obj":U, pcColumnNames) THEN
        dDataValue = DECIMAL(ENTRY(LOOKUP("ryc_smartobject.customization_result_obj":U,  pcColumnNames), pcColumnValues, CHR(1))).

      IF NUM-ENTRIES(pcColumnValues, CHR(1)) >= LOOKUP("ryc_customization_result.customization_result_code":U, pcColumnNames) THEN
        ASSIGN
            cResultCode = ENTRY(LOOKUP("ryc_customization_result.customization_result_code":U, pcColumnNames), pcColumnValues, CHR(1))
            cResultCode = (IF cResultCode = "?":U OR cResultCode = ? THEN "":U ELSE cResultCode).

      ASSIGN
          hLookupFillIn              = DYNAMIC-FUNCTION("getLookupHandle":U IN hObjectFilename)
          hLookupFillIn:SCREEN-VALUE = pcDisplayedFieldValue
          hLookupFillIn              = DYNAMIC-FUNCTION("getLookupHandle":U IN hResultCode)
          hLookupFillIn:SCREEN-VALUE = cResultCode
          lSuccess                   = DYNAMIC-FUNCTION("setDataValue":U IN hResultCode, dDataValue).

      IF VALID-HANDLE(ghSmartObject) AND ghSmartObject:AVAILABLE THEN
        ghSmartObject:BUFFER-FIELD("c_object_filename":U):BUFFER-VALUE = pcDisplayedFieldValue.
          
      DYNAMIC-FUNCTION("setUserProperty":U IN ghContainerSource, "ObjectFilename":U, pcDisplayedFieldValue).
      
      IF DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ContainerMode":U) <> "ADD":U THEN
      DO:
        DYNAMIC-FUNCTION("setUserProperty":U IN ghContainerSource, "CustomizationResultCode":U, cResultCode).
        DYNAMIC-FUNCTION("setUserProperty":U IN ghContainerSource, "CustomizationResultObj":U, STRING(dDataValue)).

        IF {fnarg getUserProperty 'fetchActive':U} <> "yes":U AND DECIMAL(pcKeyFieldValue) <> 0.00 THEN
          RUN publishFetch.
      END.

      DYNAMIC-FUNCTION("setObjectFilename":U IN ghContainerSource).
    END.

    WHEN hResultCode THEN
    DO:
      ASSIGN
          cNewResultCode = pcDisplayedFieldValue
          dNewDataValue  = DYNAMIC-FUNCTION("getDataValue":U    IN hResultCode)
          hLookupFillIn  = DYNAMIC-FUNCTION("getLookupHandle":U IN hResultCode).
      
      ASSIGN
          cResultCode                = DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "CustomizationResultCode":U)
          cResultCode                = (IF cResultCode = ? THEN "":U ELSE cResultCode)
          dDataValue                 = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "CustomizationResultObj":U))
          dDataValue                 = (IF dDataValue = ? THEN 0.00 ELSE dDataValue)
          hLookupFillIn:SCREEN-VALUE = cResultCode
          lSuccess                   = DYNAMIC-FUNCTION("setDataValue":U IN hResultCode, dDataValue).
      
      RUN checkIfSaved IN ghContainerSource (INPUT  TRUE,       /* Prompt if changes found */
                                             INPUT  FALSE,      /* AutoSave */
                                             OUTPUT lChanges,
                                             OUTPUT lContinue).

      IF lContinue = TRUE THEN
      DO:
        ASSIGN
            hLookupFillIn:SCREEN-VALUE = cNewResultCode
            lSuccess                   = DYNAMIC-FUNCTION("setDataValue":U IN hResultCode, dNewDataValue).
        
        DYNAMIC-FUNCTION("setUserProperty":U IN ghContainerSource, "CustomizationResultCode":U, cNewResultCode).
        DYNAMIC-FUNCTION("setUserProperty":U IN ghContainerSource, "CustomizationResultObj":U, STRING(dNewDataValue)).

        RUN publishFetch.
      END.
    END.

    WHEN hCustomSuperProcedure THEN
    DO:
      IF pcColumnValues <> "":U AND
         pcColumnValues <> ?    THEN
      DO:
        ASSIGN
            cExtension                 = TRIM(ENTRY(LOOKUP("ryc_smartobject.object_extension":U, pcColumnNames), pcColumnValues, CHR(1)))
            cSuperProcedure            = ENTRY(LOOKUP("ryc_smartobject.object_path":U, pcColumnNames), pcColumnValues, CHR(1))
            cSuperProcedure            = TRIM(REPLACE(cSuperProcedure, "~\":U, "/"), "/":U) + "/":U
                                       + ENTRY(LOOKUP("ryc_smartobject.object_filename":U,  pcColumnNames), pcColumnValues, CHR(1))
                                       + (IF cExtension <> "":U AND cExtension <> ? THEN ".":U ELSE "":U) + cExtension
            hLookupFillIn              = DYNAMIC-FUNCTION("getLookupHandle":U IN hCustomSuperProcedure)
            hLookupFillIn:SCREEN-VALUE = cSuperProcedure
            lSuccess                   = DYNAMIC-FUNCTION("setDataValue":U    IN hCustomSuperProcedure, cSuperProcedure)
            lSuccess                   = DYNAMIC-FUNCTION("setUserProperty":U IN hCustomSuperProcedure, "DataValue":U, cSuperProcedure)
            lSuccess                   = DYNAMIC-FUNCTION("setAttribute":U, "SuperProcedure":U, cSuperProcedure)
            ghSmartObject:BUFFER-FIELD("c_custom_super_procedure":U):BUFFER-VALUE = cSuperProcedure
            lSuccess                   = (IF cContainerMode = "ADD":U THEN DYNAMIC-FUNCTION("evaluateActions":U IN ghContainerSource) ELSE TRUE).
      END.
      ELSE
        IF pcDisplayedFieldValue <> "":U AND
           pcDisplayedFieldValue <> ?    THEN
        DO:
          ASSIGN
              ghSmartObject:BUFFER-FIELD("c_custom_super_procedure":U):BUFFER-VALUE = "":U
              cSuperProcedure            = pcDisplayedFieldValue
              cSuperProcedure            = REPLACE(cSuperProcedure, "~\":U, "/":U)
              cSuperProcedure            = ENTRY(NUM-ENTRIES(cSuperProcedure, "/":U), cSuperProcedure, "/":U)
              cSuperProcedure            = ENTRY(1, cSuperProcedure, ".":U)
              hLookupFillIn              = DYNAMIC-FUNCTION("getLookupHandle":U IN hCustomSuperProcedure)
              hLookupFillIn:SCREEN-VALUE = cSuperProcedure
              lSuccess                   = DYNAMIC-FUNCTION("setUserProperty":U IN hCustomSuperProcedure, "DataValue":U, "":U)
              lSuccess                   = (IF cContainerMode = "ADD":U THEN DYNAMIC-FUNCTION("evaluateActions":U IN ghContainerSource) ELSE TRUE).

          RUN leaveLookup IN hCustomSuperProcedure.
        END.
        ELSE
        DO:
          ghSmartObject:BUFFER-FIELD("c_custom_super_procedure":U):BUFFER-VALUE = cSuperProcedure.
          DYNAMIC-FUNCTION("setAttribute":U, "SuperProcedure":U, cSuperProcedure).

          IF cContainerMode = "ADD":U THEN
            DYNAMIC-FUNCTION("evaluateActions":U IN ghContainerSource).
        END.

      DYNAMIC-FUNCTION("evaluateActions":U).
    END.

    WHEN hContainerTemplate THEN
    DO:
      iRequiredEntries = MAX(LOOKUP("ryc_smartobject.object_description":U, pcColumnNames), LOOKUP("ryc_smartobject.object_filename":U, pcColumnNames)).

      IF NUM-ENTRIES(pcColumnValues, CHR(1)) >= iRequiredEntries THEN
      DO:
        hLookupFillIn = DYNAMIC-FUNCTION("getLookupHandle":U IN hContainerTemplate).

        IF pcKeyFieldValue <> "":U THEN
          ASSIGN
              cObjectDescription         = TRIM(ENTRY(LOOKUP("ryc_smartobject.object_description":U, pcColumnNames), pcColumnValues, CHR(1)))
              cObjectFilename            = TRIM(ENTRY(LOOKUP("ryc_smartobject.object_filename":U,    pcColumnNames), pcColumnValues, CHR(1)))
              hLookupFillIn:SCREEN-VALUE = cObjectFilename.
        ELSE
          ASSIGN
              cObjectDescription = "":U
              cObjectFilename    = "":U
              hLookupFillIn:SCREEN-VALUE = pcDisplayedFieldValue.

        DYNAMIC-FUNCTION("setUserProperty":U IN hContainerTemplate, "ObjectFilename":U,    cObjectFilename).
        DYNAMIC-FUNCTION("setUserProperty":U IN hContainerTemplate, "ObjectDescription":U, cObjectDescription).
        DYNAMIC-FUNCTION("pageOrInstanceExist":U).
      END.
    END.
    
    WHEN hDLProcedure THEN
    DO:
      IF pcColumnValues <> "":U AND
         pcColumnValues <> ?    THEN
        ASSIGN
            cExtension                 = TRIM(ENTRY(LOOKUP("ryc_smartobject.object_extension":U, pcColumnNames), pcColumnValues, CHR(1)))
            cDLProcedure               = ENTRY(LOOKUP("ryc_smartobject.object_path":U, pcColumnNames), pcColumnValues, CHR(1))
            cDLProcedure               = TRIM(REPLACE(cDLProcedure, "~\":U, "/"), "/":U) + "/":U
                                       + ENTRY(LOOKUP("ryc_smartobject.object_filename":U,  pcColumnNames), pcColumnValues, CHR(1))
                                       + (IF cExtension <> "":U AND cExtension <> ? THEN ".":U ELSE "":U) + cExtension
            hLookupFillIn              = DYNAMIC-FUNCTION("getLookupHandle":U IN hDLProcedure)
            hLookupFillIn:SCREEN-VALUE = cDLProcedure
            lSuccess                   = DYNAMIC-FUNCTION("setDataValue":U    IN hDLProcedure, cDLProcedure)
            lSuccess                   = DYNAMIC-FUNCTION("setUserProperty":U IN hDLProcedure, "DataValue":U, cDLProcedure)
            lSuccess                   = DYNAMIC-FUNCTION("setAttribute":U, "DataLogicProcedure":U, cDLProcedure).
      ELSE
        IF pcDisplayedFieldValue <> "":U AND
           pcDisplayedFieldValue <> ?    THEN
        DO:
          ASSIGN
              cDLProcedure               = pcDisplayedFieldValue
              cDLProcedure               = REPLACE(cDLProcedure, "~\":U, "/":U)
              cDLProcedure               = ENTRY(NUM-ENTRIES(cDLProcedure, "/":U), cDLProcedure, "/":U)
              cDLProcedure               = ENTRY(1, cDLProcedure, ".":U)
              hLookupFillIn              = DYNAMIC-FUNCTION("getLookupHandle":U IN hDLProcedure)
              hLookupFillIn:SCREEN-VALUE = cDLProcedure
              lSuccess                   = DYNAMIC-FUNCTION("setUserProperty":U IN hDLProcedure, "DataValue":U, "":U).
  
          RUN leaveLookup IN hDLProcedure.
        END.
        ELSE
          DYNAMIC-FUNCTION("setAttribute":U, "DataLogicProcedure":U, cDLProcedure).

      DYNAMIC-FUNCTION("evaluateActions":U).      
    END.
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE postCreateObjects vTableWin 
PROCEDURE postCreateObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cBaseQueryString  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lLogical          AS LOGICAL    NO-UNDO.
  
  ASSIGN
      gcValidDataContainers = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "{&VALID-DATA-CONTAINERS}":U)
      gcValidContainers     = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "{&VALID-CONTAINERS}":U)
      gcValidDataContainers = REPLACE(gcValidDataContainers, CHR(3), ",":U)
      gcValidContainers     = REPLACE(gcValidContainers,     CHR(3), ",":U)

      /* Object Filename Lookup */
      cBaseQueryString = {fn getBaseQueryString hObjectFilename}
      cBaseQueryString = REPLACE(cBaseQueryString, ", gsc_object_type.object_type_code":U, ",'" + gcValidContainers + ",":U + gcValidDataContainers + "'":U)
      lLogical         = DYNAMIC-FUNCTION("setBaseQueryString":U IN hObjectFilename, cBaseQueryString)

      /* Object Type Combo */
      cBaseQueryString = {fn getBaseQueryString hObjectType}
      cBaseQueryString = REPLACE(cBaseQueryString, ", gsc_object_type.object_type_code":U, ",'" + gcValidContainers + ",":U + gcValidDataContainers + "'":U)
      lLogical         = DYNAMIC-FUNCTION("setBaseQueryString":U IN hObjectType, cBaseQueryString)

      /* Template SmartObject Lookup */
      gcTemplateBaseQuery = {fn getBaseQueryString hContainerTemplate}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE publishFetch vTableWin 
PROCEDURE publishFetch :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cObjectFilename         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContainerMode          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE hLookupFillIn           AS HANDLE     NO-UNDO.

  IF {fn getObjectInitialized} = FALSE THEN
    RETURN.

  {fnarg setUserProperty "'fetchActive':U, 'yes':U"}.

  ASSIGN
      dCustomizationResultObj = DECIMAL({fnarg getUserProperty 'CustomizationResultObj':U ghContainerSource})
      hLookupFillIn           = {fn getLookupHandle hObjectFilename}
      cObjectFilename         = hLookupFillIn:SCREEN-VALUE
      cContainerMode          = {fnarg getUserProperty 'ContainerMode':U ghContainerSource}.

  RUN "fetchContainerData":U IN ghContainerSource (INPUT cObjectFilename).

  {fn evaluateActions ghContainerSource}.

  IF cContainerMode = "ADD":U THEN
    RUN disableField IN hObjectFilename.
  
  IF dCustomizationResultObj <> 0.00 THEN
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        buCreate:SENSITIVE         = FALSE
        hLookupFillIn              = {fn getLookupHandle hContainerTemplate}
        hLookupFillIn:SCREEN-VALUE = "":U.

    RUN disableField IN hContainerTemplate.
  END.

  hLookupFillIn = {fn getLookupHandle hResultCode}.
  APPLY "ENTRY":U TO hLookupFillIn.

  {fnarg setUserProperty "'fetchActive':U, 'no':U"}.

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
  DEFINE INPUT PARAMETER pdHeight AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdWidth  AS DECIMAL    NO-UNDO.
  
  IF pdWidth < FRAME {&FRAME-NAME}:WIDTH-CHARS THEN
  DO:
    RUN resizeViewerObjects (INPUT pdHeight, INPUT pdWidth).
    
    FRAME {&FRAME-NAME}:WIDTH-CHARS = pdWidth.
  END.
  ELSE
  DO:
    FRAME {&FRAME-NAME}:WIDTH-CHARS = pdWidth.
  
    RUN resizeViewerObjects (INPUT pdHeight, INPUT pdWidth).
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
  DEFINE INPUT PARAMETER pdHeight AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdWidth  AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE dNewColumn      AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dNewWidth       AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lSuccess        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hLabelHandle    AS HANDLE     NO-UNDO.
  
  IF DYNAMIC-FUNCTION("getObjectInitialized":U) = FALSE THEN
    RETURN.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        hLabelHandle  = DYNAMIC-FUNCTION("getLabelHandle":U  IN hCustomSuperProcedure)
        dNewWidth     = pdWidth - (hLabelHandle:WIDTH-CHARS + 0.50) - fiObjectDescription:COLUMN
        dNewWidth     = dNewWidth / 2
        dNewColumn    = fiObjectDescription:COLUMN + hLabelHandle:WIDTH-CHARS + dNewWidth + 0.50
        
        fiObjectDescription:WIDTH-CHARS       = dNewWidth  - 4.80
        toTemplateObject:COLUMN               = dNewColumn
        rctContainerTemplate:COLUMN           = dNewColumn - 15.50
        rctContainerTemplate:WIDTH-CHARS      = dNewWidth  + 15.50
        buCreate:COLUMN                       = rctContainerTemplate:COLUMN + rctContainerTemplate:WIDTH-CHARS - buCreate:WIDTH-CHARS - 1.20
        fiContainerTemplate:COLUMN            = rctContainerTemplate:COLUMN + 0.60
        fiWindowName:SIDE-LABEL-HANDLE:COLUMN = fiWindowName:SIDE-LABEL-HANDLE:COLUMN + (dNewColumn - fiWindowName:COLUMN)
        fiWindowName:WIDTH-CHARS              = dNewWidth  - 4.80
        fiWindowName:COLUMN                   = dNewColumn
        .

    RUN resizeObject      IN hCustomSuperProcedure (1.00, dNewWidth).
    RUN resizeObject      IN hDLProcedure          (1.00, dNewWidth).
    RUN repositionObject  IN hContainerTemplate    ({fn getRow hContainerTemplate}, dNewColumn).
    RUN resizeObject      IN hContainerTemplate    (1.00, dNewWidth - 2.20 - buCreate:WIDTH-CHARS).
    RUN resizeObject      IN hObjectFilename       (1.00, dNewWidth).
    RUN resizeObject      IN hResultCode           (1.00, dNewWidth).
    RUN repositionObject  IN hProductModule        ({fn getRow hProductModule}, dNewColumn).
    RUN resizeObject      IN hProductModule        (1.05, dNewWidth - 4.80).
    RUN resizeObject      IN hObjectType           (1.05, dNewWidth - 4.80).
/*   
    ASSIGN
        hLabelHandle = DYNAMIC-FUNCTION("getLabelHandle":U  IN hCustomSuperProcedure)
        lSuccess     = DYNAMIC-FUNCTION("createLabel":U     IN hCustomSuperProcedure, SUBSTRING(hLabelHandle:SCREEN-VALUE, 1, LENGTH(hLabelHandle:SCREEN-VALUE) - 1))
        hLabelHandle = DYNAMIC-FUNCTION("getLabelHandle":U  IN hContainerTemplate)
        lSuccess     = DYNAMIC-FUNCTION("createLabel":U     IN hContainerTemplate, SUBSTRING(hLabelHandle:SCREEN-VALUE, 1, LENGTH(hLabelHandle:SCREEN-VALUE) - 1))
        .
*/
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

  /* Set the initial values of the object type combo. The object type was already
     supplied when the user selected which object they wanted to create, through
     the AppBuilder */
/*  {get ComboHandle hComboHandle hObjectType}.

  cComboObjValue = ENTRY(LOOKUP("RELATIVE":U, hComboHandle:LIST-ITEM-PAIRS, hComboHandle:DELIMITER) + 1, hComboHandle:LIST-ITEM-PAIRS, hComboHandle:DELIMITER).

  {set DataValue cComboObjValue hObjectType}.*/

  RUN disableButton IN hObjectFilename.
  
  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trgLookupValueChanged vTableWin 
PROCEDURE trgLookupValueChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phLookup AS HANDLE     NO-UNDO.

  DEFINE VARIABLE hLookupFillIn AS HANDLE     NO-UNDO.

  {get LookupHandle hLookupFillIn phLookup}.
  {set DataModified YES phLookup}.
  
  DO WITH FRAME {&FRAME-NAME}:
    IF hLookupFillIn:SCREEN-VALUE = ?     OR
       hLookupFillIn:SCREEN-VALUE = "?":U THEN
      hLookupFillIn:SCREEN-VALUE = "":U.
    
    IF hLookupFillIn:SCREEN-VALUE = "":U THEN
    DO:
      buCreate:SENSITIVE = FALSE.
      
      {set DataValue "":U}.
      
      RUN leaveLookup IN phLookup.
    END.
    ELSE
      ASSIGN
          hLookupFillIn:MODIFIED = TRUE
          buCreate:SENSITIVE     = TRUE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION applyLeaveToLookups vTableWin 
FUNCTION applyLeaveToLookups RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RUN leaveLookup IN hObjectFilename.
  RUN leaveLookup IN hResultCode.
  RUN leaveLookup IN hCustomSuperProcedure.
  RUN leaveLookup IN hDLProcedure.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION evaluateActions vTableWin 
FUNCTION evaluateActions RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  This function will be called whenever the value of any widget is
            changed on the viewer. It will the determine what the container mode
            should be set to and then call evaluateActions in the container
            which would the set the toolbar's state based on the value of the
            container mode
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cContainerMode  AS CHARACTER  NO-UNDO.
  
  cContainerMode = DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ContainerMode":U).

  IF cContainerMode <> "FIND":U AND
     cContainerMode <> "ADD":U  THEN
  DO:
    DYNAMIC-FUNCTION("setUserProperty":U IN ghContainerSource, "ContainerMode":U, "UPDATE":U).
    DYNAMIC-FUNCTION("evaluateActions":U IN ghContainerSource).
  END.

  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSDFHandle vTableWin 
FUNCTION getSDFHandle RETURNS HANDLE
  (pcLookupName AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hReturnValue  AS HANDLE   NO-UNDO.
  
  CASE pcLookupName:
    WHEN "hCustomSuperProcedure":U THEN hReturnValue = hCustomSuperProcedure.
    WHEN "hContainerTemplate":U    THEN hReturnValue = hContainerTemplate.
    WHEN "hObjectFilename":U       THEN hReturnValue = hObjectFilename.
    WHEN "hProductModule":U        THEN hReturnValue = hProductModule.
    WHEN "hDLProcedure":U          THEN hReturnValue = hDLProcedure.
    WHEN "hResultCode":U           THEN hReturnValue = hResultCode.
    WHEN "hObjectType":U           THEN hReturnValue = hObjectType.
  END CASE.

  RETURN hReturnValue.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isValidOTChange vTableWin 
FUNCTION isValidOTChange RETURNS LOGICAL
  (pdObjectTypeObj  AS DECIMAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lDataContainer          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lReturnValue            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE httObjectMenuStructure  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httObjectInstance       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httObjectType           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httPage                 AS HANDLE     NO-UNDO.

  ASSIGN
      httObjectMenuStructure  = WIDGET-HANDLE({fnarg getUserProperty 'ttObjectMenuStructure'  ghContainerSource})
      httObjectInstance       = WIDGET-HANDLE({fnarg getUserProperty 'ttObjectInstance'       ghContainerSource})
      httObjectType           = WIDGET-HANDLE({fnarg getUserProperty 'ttObjectType'           ghContainerSource})
      httPage                 = WIDGET-HANDLE({fnarg getUserProperty 'ttPage'                 ghContainerSource}).

  httObjectType:FIND-FIRST("WHERE d_object_type_obj = DECIMAL(":U + QUOTER(pdObjectTypeObj) + ")":U, NO-LOCK).

  /* Check if the passed in Object Type is a DataContainer */
  lDataContainer = LOOKUP(httObjectType:BUFFER-FIELD("c_object_type_code":U):BUFFER-VALUE, gcValidDataContainers) <> 0.

  IF lDataContainer THEN
  DO:
    /* See if any components are found that are not allowed on a data container */
    /* Object Menu Structures */
    httObjectMenuStructure:FIND-FIRST("WHERE c_action <> 'D'":U) NO-ERROR.

    /* Visible ObjectInstances */
    httObjectInstance:FIND-FIRST("WHERE d_object_instance_obj <> 0 ":U
                                 + "AND d_smartobject_obj     <> 0 ":U
                                 + "AND c_action              <> 'D' ":U
                                 + "AND l_visible_object       = TRUE":U) NO-ERROR.

    /* Pages */
    httPage:FIND-FIRST("WHERE i_page_sequence <> 0 ":U
                       + "AND c_action        <> 'D'":U) NO-ERROR.
    
    IF httObjectMenuStructure:AVAILABLE OR
       httObjectInstance:AVAILABLE      OR
       httPage:AVAILABLE                THEN
      lReturnValue = FALSE.
    ELSE
      lReturnValue = TRUE.
  END.
  ELSE /* If we are not creating a DataContainer, the change would be allowed */
    lReturnValue = TRUE.

  IF lReturnValue = TRUE THEN
    {fnarg setUserProperty "'DataContainer', STRING(lDataContainer)" ghContainerSource}.
  ELSE
    {fnarg setUserProperty "'DataContainer', FALSE" ghContainerSource}.

  RETURN lReturnValue.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION pageOrInstanceExist vTableWin 
FUNCTION pageOrInstanceExist RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lExist            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE httObjectInstance AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hLookupFillIn     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httPage           AS HANDLE     NO-UNDO.

  ASSIGN
      httObjectInstance = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ttObjectInstance":U))
      httPage           = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ttPage":U)).

  CREATE BUFFER httObjectInstance FOR TABLE httObjectInstance.
  CREATE BUFFER httPage           FOR TABLE httPage.

  httObjectInstance:FIND-FIRST("WHERE d_object_instance_obj <> 0 AND d_smartobject_obj <> 0 AND c_action <> 'D'":U) NO-ERROR.
  httPage:FIND-FIRST("WHERE i_page_sequence <> 0 AND c_action <> 'D'":U) NO-ERROR.

  IF httObjectInstance:AVAILABLE OR
     httPage:AVAILABLE           THEN
    lExist = TRUE.

  DO WITH FRAME {&FRAME-NAME}:
    {get LookupHandle hLookupFillIn hContainerTemplate}.

    IF hLookupFillIn:SCREEN-VALUE = "":U THEN
      buCreate:SENSITIVE = FALSE.
    ELSE
      buCreate:SENSITIVE = TRUE.

    buCreate:LABEL = (IF lExist = TRUE THEN "Replace":U ELSE "Create":U).
  END.

  DELETE OBJECT httObjectInstance.
  DELETE OBJECT httPage.

  RETURN lExist.   /* Function return value. */

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
  DEFINE VARIABLE lOverride           AS LOGICAL    NO-UNDO.

  ASSIGN
      cCustomizationCode = DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "CustomizationResultCode":U)
      lOverride          = (IF (pcAttribute = "DataLogicProcedure":U  OR
                                pcAttribute = "SuperProcedure":U)     AND pcValue = "":U THEN FALSE ELSE TRUE).

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

  RUN propertyChangedAttribute IN ghContainerSource (INPUT ghContainerSource,
                                                     INPUT ghSmartObject:BUFFER-FIELD("d_smartobject_obj":U):BUFFER-VALUE,
                                                     INPUT ghSmartObject:BUFFER-FIELD("d_smartobject_obj":U):BUFFER-VALUE,
                                                     INPUT cCustomizationCode,
                                                     INPUT pcAttribute,
                                                     INPUT pcValue,
                                                     INPUT "":U,
                                                     INPUT lOverride).

  RUN assignPropertyValues IN ghProcLib (INPUT ghContainerSource,
                                         INPUT ghSmartObject:BUFFER-FIELD("d_smartobject_obj":U):BUFFER-VALUE,
                                         INPUT ghSmartObject:BUFFER-FIELD("d_smartobject_obj":U):BUFFER-VALUE,
                                         INPUT pcAttribute + CHR(3) + cCustomizationCode + CHR(3) + pcValue,
                                         INPUT "":U,
                                         INPUT TRUE).

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION updatePropertyValue vTableWin 
FUNCTION updatePropertyValue RETURNS LOGICAL
  (pcObject         AS CHARACTER,
   pcAttributeLabel AS CHARACTER,
   pcAttributeValue AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hLookupFillIn AS HANDLE     NO-UNDO.

  IF DECIMAL(pcObject) <> ghSmartObject:BUFFER-FIELD("d_smartobject_obj":U):BUFFER-VALUE THEN
    RETURN TRUE.

  IF {fnarg getUserProperty 'DontDisplay':U} = "No":U THEN
    RETURN TRUE.

  DO WITH FRAME {&FRAME-NAME}:
    CASE pcAttributeLabel:
      WHEN "WindowName":U THEN
        fiWindowName:SCREEN-VALUE = pcAttributeValue.

      WHEN "DataLogicProcedure":U THEN
      DO:
        {get LookupHandle hLookupFillIn hDLProcedure}.

        hLookupFillIn:SCREEN-VALUE = pcAttributeValue.
        
        RUN leaveLookup IN hDLProcedure.
      END.

      WHEN "SuperProcedure":U THEN
      DO:
        {get LookupHandle hLookupFillIn hCustomSuperProcedure}.

        hLookupFillIn:SCREEN-VALUE = pcAttributeValue.
        
        RUN leaveLookup IN hCustomSuperProcedure.
      END.
    END CASE.
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

