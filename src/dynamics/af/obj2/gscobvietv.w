&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
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
       {"ry/obj/rycsoful2o.i"}.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/* Copyright (C) 2005,2007 by Progress Software Corporation. All rights
   reserved.  Prior versions of this work may contain portions
   contributed by participants of Possenet. */
/*---------------------------------------------------------------------------------
  File: gscobvietv.w

  Description:  Smart Object SmartDataViewer

  Purpose:      Smart Object SmartDataViewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:   101000026   UserRef:    
                Date:   09/06/2001  Author:     Mark Davies

  Update Notes: Smart Object SmartDataViewer
                Created from Template gscobviewv.w

  (v:010001)    Task:           0   UserRef:    
                Date:   10/29/2001  Author:     Mark Davies (MIP)

  Update Notes: Replace Static Combo with two dynamic combo boxes for product and product module.

  (v:010002)    Task:           0   UserRef:    
                Date:   11/07/2001  Author:     Mark Davies (MIP)

  Update Notes: Set state to MODIFIED when user selected a file using the Find Object options.
                Added check not to set state to modified for logical objects when in view mode.

  (v:010003)    Task:           0   UserRef:    
                Date:   11/14/2001  Author:     Mark Davies (MIP)

  Update Notes: Disable object_filename when modifying.

  (v:010004)    Task:           0   UserRef:    
                Date:   12/03/2001  Author:     Mark Davies (MIP)

  Update Notes: Fix for issue #3372 - A debug message is left in the code in Repository Maint. tool

  (v:010005)    Task:           0   UserRef:    
                Date:   12/12/2001  Author:     Mark Davies (MIP)

  Update Notes: Fixed issue #2925 - Repository Object Maintenance Tool - Toolbar error
                
                Added checks to cancel a record when adding and pressing the reset button.

  (v:010006)    Task:           0   UserRef:    
                Date:   05/30/2002  Author:     Mark Davies (MIP)

  Update Notes: Default to correct object type when adding a new smartobject - fix for issue #4636

---------------------------------------------------------------------------*/
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

&scop object-name       gscobvietv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{af/sup2/afglobals.i}

DEFINE VARIABLE gcRunWhen           AS CHARACTER  NO-UNDO INITIAL "Anytime,ANY,When no other running,NOR,With only one instance,ONE":U.
DEFINE VARIABLE gcMode              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glEnableObjectName  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glAddRecord         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glCopyRecord        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE gcOldObjectName     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcOldProdModCode    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcObjectTypeCode    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gdCustomResultObj   AS DECIMAL    NO-UNDO.

{ry/inc/rycntnerbi.i}

DEFINE TEMP-TABLE ttTmpltObjectMenuStructure  LIKE ttObjectMenuStructure.
DEFINE TEMP-TABLE ttTmpltObjectInstance       LIKE ttObjectInstance.
DEFINE TEMP-TABLE ttTmpltAttributeValue       LIKE ttAttributeValue.
DEFINE TEMP-TABLE ttTmpltSmartObject          LIKE ttSmartObject.
DEFINE TEMP-TABLE ttTmpltPageObject           LIKE ttPageObject.
DEFINE TEMP-TABLE ttTmpltSmartLink            LIKE ttSmartLink.
DEFINE TEMP-TABLE ttTmpltUiEvent              LIKE ttUiEvent.
DEFINE TEMP-TABLE ttTmpltPage                 LIKE ttPage.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "ry/obj/rycsoful2o.i"

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.object_filename ~
RowObject.object_description RowObject.object_path RowObject.static_object ~
RowObject.run_when RowObject.object_is_runnable 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-Define ENABLED-OBJECTS bu_find_object co_run_when 
&Scoped-Define DISPLAYED-FIELDS RowObject.object_filename ~
RowObject.object_extension RowObject.object_description ~
RowObject.object_path RowObject.static_object RowObject.run_when ~
RowObject.object_is_runnable 
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define DISPLAYED-OBJECTS fiSDOClasses co_run_when 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE hCustomizationResultCode AS HANDLE NO-UNDO.
DEFINE VARIABLE hExtendsSmartObject AS HANDLE NO-UNDO.
DEFINE VARIABLE hProduct AS HANDLE NO-UNDO.
DEFINE VARIABLE hProductModule AS HANDLE NO-UNDO.
DEFINE VARIABLE h_Layout AS HANDLE NO-UNDO.
DEFINE VARIABLE h_ObjectType AS HANDLE NO-UNDO.
DEFINE VARIABLE h_SDOName AS HANDLE NO-UNDO.
DEFINE VARIABLE h_SecurityObject AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bu_find_object 
     IMAGE-UP FILE "ry/img/view.gif":U
     LABEL "Find O&bject..." 
     SIZE 4.8 BY 1 TOOLTIP "Find an object"
     BGCOLOR 8 .

DEFINE VARIABLE co_run_when AS CHARACTER FORMAT "X(3)" 
     LABEL "Run when" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 53.2 BY 1.

DEFINE VARIABLE fiSDOClasses AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 7.6 BY 1 TOOLTIP "SDO classes for SDO lookup, this field is hidden" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     fiSDOClasses AT ROW 15.05 COL 88.6 COLON-ALIGNED NO-LABEL
     RowObject.object_filename AT ROW 4.33 COL 28.2 COLON-ALIGNED
          LABEL "Object filename"
          VIEW-AS FILL-IN 
          SIZE 53 BY 1
     bu_find_object AT ROW 4.33 COL 83.4
     RowObject.object_extension AT ROW 6.52 COL 28.2 COLON-ALIGNED
          LABEL "Object extension"
          VIEW-AS FILL-IN 
          SIZE 37 BY 1
     RowObject.object_description AT ROW 7.62 COL 28.2 COLON-ALIGNED
          LABEL "Object description"
          VIEW-AS FILL-IN 
          SIZE 53 BY 1
     RowObject.object_path AT ROW 8.71 COL 28.2 COLON-ALIGNED
          LABEL "Object path"
          VIEW-AS FILL-IN 
          SIZE 53 BY 1
     co_run_when AT ROW 9.81 COL 28.2 COLON-ALIGNED HELP
          "Run when"
     RowObject.static_object AT ROW 14.14 COL 30.2
          LABEL "Static object"
          VIEW-AS TOGGLE-BOX
          SIZE 18.6 BY .81
     RowObject.run_when AT ROW 13.67 COL 95 COLON-ALIGNED
          LABEL "Run when"
          VIEW-AS FILL-IN 
          SIZE 1.4 BY 1
     RowObject.object_is_runnable AT ROW 16.05 COL 30.2
          LABEL "Object is runnable"
          VIEW-AS TOGGLE-BOX
          SIZE 22 BY .81
     SPACE(31.20) SKIP(0.00)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "ry/obj/rycsoful2o.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {ry/obj/rycsoful2o.i}
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
         HEIGHT             = 17.1
         WIDTH              = 97.4.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN fiSDOClasses IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       fiSDOClasses:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN RowObject.object_description IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.object_extension IN FRAME frMain
   NO-ENABLE EXP-LABEL                                                  */
ASSIGN 
       RowObject.object_extension:READ-ONLY IN FRAME frMain        = TRUE.

/* SETTINGS FOR FILL-IN RowObject.object_filename IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.object_is_runnable IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.object_path IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.run_when IN FRAME frMain
   EXP-LABEL                                                            */
ASSIGN 
       RowObject.run_when:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR TOGGLE-BOX RowObject.static_object IN FRAME frMain
   EXP-LABEL                                                            */
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

&Scoped-define SELF-NAME bu_find_object
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bu_find_object vTableWin
ON CHOOSE OF bu_find_object IN FRAME frMain /* Find Object... */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    DEFINE VARIABLE lOk                   AS   LOGICAL                NO-UNDO.
    DEFINE VARIABLE cRoot                 AS   CHARACTER              NO-UNDO.
    DEFINE VARIABLE cFilename             AS   CHARACTER              NO-UNDO.
    DEFINE VARIABLE cFilterNamestring    AS   CHARACTER EXTENT 5     NO-UNDO.
    DEFINE VARIABLE cFilterFilespec      LIKE cFilterNamestring   NO-UNDO.
    DEFINE VARIABLE cFile                 AS   CHARACTER              NO-UNDO.
    DEFINE VARIABLE cPath                 AS   CHARACTER              NO-UNDO.

    /* Initialize the file filters, for special cases. */

    ASSIGN  cFilterNamestring[1] = "All Files(*.*)"
            cFilterFilespec[1] = "*.*"
            cFilterNamestring[2] = "All windows(?????????w.w)"
            cFilterFilespec[2] = "?????????w.w".

    /*  Ask for a file name. NOTE: File-names to run must exist.
        --------------------------------------------------------
    */

    cFilename = RowObject.object_filename:SCREEN-VALUE.

    SYSTEM-DIALOG GET-FILE cFilename
                  TITLE    "Lookup Program"
                  FILTERS  cFilterNamestring[ 1 ]   cFilterFilespec[ 1 ],
                           cFilterNamestring[ 2 ]   cFilterFilespec[ 2 ]
                  MUST-EXIST
                  UPDATE   lOk IN WINDOW {&WINDOW-NAME}.  

    cRoot = IF  REPLACE(cFilename,"~\":U,"/":U) BEGINS REPLACE(ENTRY(2,PROPATH),"~\":U,"/":U) THEN
                REPLACE(ENTRY(2,PROPATH),"~\":U,"/":U)
                ELSE REPLACE(ENTRY(1,PROPATH),"~\":U,"/":U).

    IF  lOk THEN DO:
        ASSIGN
            cFile                                  = REPLACE(REPLACE(TRIM(LC(cFilename)),"~\":U,"/":U),cRoot + "/":U,"":U)
            RowObject.object_filename:SCREEN-VALUE = SUBSTRING(cFile,R-INDEX(cFile,"/":U) + 1)
            cPath                                  = SUBSTRING(cFile,1,R-INDEX(cFile,"/":U))
            RowObject.object_filename:MODIFIED     = TRUE.

        ASSIGN
            RowObject.object_path:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cPath.
        {set DataModified TRUE}.
    
        APPLY "ENTRY":U TO RowObject.object_filename.
    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME co_run_when
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL co_run_when vTableWin
ON VALUE-CHANGED OF co_run_when IN FRAME frMain /* Run when */
DO:
  {set DataModified TRUE}.  
  ASSIGN co_run_when.
  ASSIGN rowObject.run_when:SCREEN-VALUE = co_run_when
         rowObject.run_when:MODIFIED     = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject.static_object
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.static_object vTableWin
ON VALUE-CHANGED OF RowObject.static_object IN FRAME frMain /* Static object */
DO:
  DEFINE VARIABLE hGroupAssign  AS HANDLE   NO-UNDO.
  
  hGroupAssign = WIDGET-HANDLE(ENTRY(1,DYNAMIC-FUNCTION("linkHandles", "GroupAssign-Target":U))).
  
  IF RowObject.static_object:SENSITIVE AND 
     VALID-HANDLE(hGroupAssign) THEN DO:
    {set DataModified TRUE}.
    RUN logicalObject IN hGroupAssign (NOT INPUT RowObject.static_object:CHECKED).
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
  DEFINE VARIABLE hDataSource       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hParentDataSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE dObjType          AS DECIMAL    NO-UNDO.

  glAddRecord = TRUE.
  glEnableObjectName = TRUE.
  
  /* Code placed here will execute PRIOR to standard behavior. */
  
  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  APPLY "VALUE-CHANGED":U TO RowObject.static_object IN FRAME {&FRAME-NAME}.
  RUN valueChanged IN hProduct.
  RUN valueChanged IN hProductModule.

  /* Set the correct object type in the combo */
  {get DataSource hDataSource}.
  IF VALID-HANDLE(hDataSource) THEN DO:
    {get DataSource hParentDataSource hDataSource}.
    IF VALID-HANDLE(hParentDataSource) THEN DO:
      dObjType = DECIMAL(DYNAMIC-FUNCTION("columnStringValue" IN hParentDataSource,"object_type_obj")).
      RUN assignNewValue IN h_ObjectType (INPUT STRING(dObjType), "":U, TRUE).
    END.
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
             INPUT  'DisplayedFieldgsc_product.product_code,gsc_product.product_descriptionKeyFieldgsc_product.product_objFieldLabelProductFieldTooltipSelect a Product from the listKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(10)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_product NO-LOCK WHERE [&FilterSet=|&EntityList=GSCPR] INDEXED-REPOSITIONQueryTablesgsc_productSDFFileNameSDFTemplateParentFieldParentFilterQueryDescSubstitute&1 / &2ComboDelimiterListItemPairsInnerLines5SortnoComboFlagFlagValueBuildSequence1SecurednoCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesUseCacheyesSuperProcedureDataSourceNameFieldNamedProductObjDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hProduct ).
       RUN repositionObject IN hProduct ( 1.00 , 30.20 ) NO-ERROR.
       RUN resizeObject IN hProduct ( 1.05 , 53.20 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dyncombo.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_product_module.product_module_code,gsc_product_module.product_module_descriptionKeyFieldgsc_product_module.product_module_objFieldLabelProduct moduleFieldTooltipSelect a Product Module from the listKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(35)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_product_module NO-LOCK WHERE [&FilterSet=|&EntityList=GSCPM] INDEXED-REPOSITIONQueryTablesgsc_product_moduleSDFFileNameSDFTemplateParentFielddProductObjParentFilterQuerygsc_product_module.product_obj = DECIMAL(~'&1~')DescSubstitute&1 / &2ComboDelimiterListItemPairsInnerLines5SortnoComboFlagFlagValueBuildSequence1SecurednoCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesUseCacheyesSuperProcedureDataSourceNameFieldNameproduct_module_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hProductModule ).
       RUN repositionObject IN hProductModule ( 2.10 , 30.20 ) NO-ERROR.
       RUN resizeObject IN hProductModule ( 1.05 , 53.20 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_object_type.object_type_codeKeyFieldgsc_object_type.object_type_objFieldLabelObject type codeFieldTooltipPress F4 for LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatx(30)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object_type NO-LOCK
                     BY gsc_object_type.object_type_code INDEXED-REPOSITIONQueryTablesgsc_object_typeBrowseFieldsgsc_object_type.object_type_code,gsc_object_type.object_type_description,gsc_object_type.static_object,gsc_object_type.disabledBrowseFieldDataTypescharacter,character,logical,logicalBrowseFieldFormatsX(35)|X(35)|YES/NO|YES/NORowsToBatch200BrowseTitleLookupViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatx(30)SDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListNO-LOCK INDEXED-REPOSITIONQueryBuilderOrderListobject_type_code^yesQueryBuilderTableOptionListNO-LOCKQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesSuperProcedureDataSourceNameFieldNameobject_type_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_ObjectType ).
       RUN repositionObject IN h_ObjectType ( 3.19 , 30.20 ) NO-ERROR.
       RUN resizeObject IN h_ObjectType ( 1.00 , 53.20 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_customization_result.customization_result_codeKeyFieldryc_customization_result.customization_result_objFieldLabelCustomization result codeFieldTooltipSelect a customization result code or leave blank for the default object.KeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH ryc_customization_result NO-LOCK,
                     EACH ryc_customization_type
                     WHERE ryc_customization_type.customization_type_obj = ryc_customization_result.customization_type_obj BY ryc_customization_result.customization_result_codeQueryTablesryc_customization_result,ryc_customization_typeBrowseFieldsryc_customization_result.customization_result_code,ryc_customization_result.customization_result_desc,ryc_customization_type.customization_type_code,ryc_customization_type.customization_type_descBrowseFieldDataTypescharacter,character,character,characterBrowseFieldFormatsX(70)|X(70)|X(15)|X(35)RowsToBatch200BrowseTitleCustomization Result Code LookupViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesSuperProcedureDataSourceNameFieldNamecustomization_result_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hCustomizationResultCode ).
       RUN repositionObject IN hCustomizationResultCode ( 5.43 , 30.20 ) NO-ERROR.
       RUN resizeObject IN hCustomizationResultCode ( 1.00 , 53.20 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dyncombo.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_layout.layout_code,ryc_layout.layout_nameKeyFieldryc_layout.layout_objFieldLabelLayoutFieldTooltipSelect the default layout for this object.KeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(256)DisplayDatatypeCHARACTERBaseQueryStringFOR EACH ryc_layout NO-LOCK BY ryc_layout.layout_code INDEXED-REPOSITIONQueryTablesryc_layoutSDFFileNameSDFTemplateParentFieldParentFilterQueryDescSubstitute&2 (&1)ComboDelimiterListItemPairsInnerLines0SortnoComboFlagFlagValueBuildSequence1SecurednoCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesUseCacheyesSuperProcedureDataSourceNameFieldNamelayout_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_Layout ).
       RUN repositionObject IN h_Layout ( 10.91 , 30.20 ) NO-ERROR.
       RUN resizeObject IN h_Layout ( 1.05 , 53.20 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.smartobject_objFieldLabelData source nameFieldTooltipPress F4 For LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object_type NO-LOCK,
                     EACH ryc_smartobject NO-LOCK
                     WHERE ryc_smartobject.OBJECT_type_obj = gsc_object_type.OBJECT_type_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj
                     AND [&FilterSet=|&EntityList=GSCPM,RYCSO] INDEXED-REPOSITIONQueryTablesgsc_object_type,ryc_smartobject,gsc_product_moduleBrowseFieldsryc_smartobject.object_filename,ryc_smartobject.template_smartobject,gsc_object_type.object_type_code,gsc_object_type.object_type_descriptionBrowseFieldDataTypescharacter,logical,character,characterBrowseFieldFormatsX(70)|YES/NO|X(35)|X(35)RowsToBatch200BrowseTitleLookup SDOViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldfiSDOClassesParentFilterQueryLOOKUP(gsc_object_type.object_type_code, "&1") > 0MaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesSuperProcedureDataSourceNameFieldNamesdo_smartobject_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_SDOName ).
       RUN repositionObject IN h_SDOName ( 12.00 , 30.20 ) NO-ERROR.
       RUN resizeObject IN h_SDOName ( 1.00 , 53.20 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.smartobject_objFieldLabelSecurity objectFieldTooltipPress F4 for LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH ryc_smartobject NO-LOCK,
                     FIRST gsc_object_type NO-LOCK
                     WHERE gsc_object_type.OBJECT_type_obj = ryc_smartobject.OBJECT_type_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj
                     AND [&FilterSet=|&EntityList=GSCPM,RYCSO],
                     FIRST gsc_product NO-LOCK
                     WHERE gsc_product.product_obj = gsc_product_module.product_obj INDEXED-REPOSITIONQueryTablesryc_smartobject,gsc_object_type,gsc_product_module,gsc_productBrowseFieldsgsc_product.product_code,gsc_product_module.product_module_code,gsc_object_type.object_type_code,ryc_smartobject.object_filename,ryc_smartobject.container_object,ryc_smartobject.static_object,ryc_smartobject.generic_object,ryc_smartobject.disabledBrowseFieldDataTypescharacter,character,character,character,logical,logical,logical,logicalBrowseFieldFormatsX(10)|X(35)|X(35)|X(70)|YES/NO|YES/NO|YES/NO|YES/NORowsToBatch200BrowseTitleLookup Security ObjectViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesSuperProcedureDataSourceNameFieldNamesecurity_smartobject_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_SecurityObject ).
       RUN repositionObject IN h_SecurityObject ( 13.10 , 30.20 ) NO-ERROR.
       RUN resizeObject IN h_SecurityObject ( 1.00 , 53.20 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.smartobject_objFieldLabelExtends smartobjectFieldTooltipPress F4 For LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH ryc_smartobject NO-LOCK BY ryc_smartobject.object_filenameQueryTablesryc_smartobjectBrowseFieldsryc_smartobject.object_filename,ryc_smartobject.object_description,ryc_smartobject.object_extensionBrowseFieldDataTypescharacter,character,characterBrowseFieldFormatsX(70)|X(35)|X(35)RowsToBatch200BrowseTitleExtends SmartObject LookupViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListNO-LOCKQueryBuilderOrderListryc_smartobject.object_filename^yesQueryBuilderTableOptionListNO-LOCKQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesSuperProcedureDataSourceNameFieldNameextends_smartobject_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hExtendsSmartObject ).
       RUN repositionObject IN hExtendsSmartObject ( 15.00 , 30.20 ) NO-ERROR.
       RUN resizeObject IN hExtendsSmartObject ( 1.00 , 52.80 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( hProduct ,
             fiSDOClasses:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( hProductModule ,
             hProduct , 'AFTER':U ).
       RUN adjustTabOrder ( h_ObjectType ,
             hProductModule , 'AFTER':U ).
       RUN adjustTabOrder ( hCustomizationResultCode ,
             bu_find_object:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_Layout ,
             co_run_when:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_SDOName ,
             h_Layout , 'AFTER':U ).
       RUN adjustTabOrder ( h_SecurityObject ,
             h_SDOName , 'AFTER':U ).
       RUN adjustTabOrder ( hExtendsSmartObject ,
             RowObject.static_object:HANDLE IN FRAME frMain , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelRecord vTableWin 
PROCEDURE cancelRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  ASSIGN glAddRecord  = FALSE.
         glCopyRecord = FALSE.
  
  DISABLE bu_find_object RowObject.object_filename
          WITH FRAME {&FRAME-NAME}.
  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE collectChanges vTableWin 
PROCEDURE collectChanges :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT-OUTPUT PARAMETER pcChanges AS CHARACTER NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcInfo    AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT-OUTPUT pcChanges, INPUT-OUTPUT pcInfo).

  ASSIGN glAddRecord  = FALSE.
  /* Code placed here will execute AFTER standard behavior.    */

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
  DEFINE INPUT PARAMETER pcScreenValue          AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER phCombo                AS HANDLE     NO-UNDO. 

  DEFINE VARIABLE hDataSource             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE dProductObj             AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dProductModuleObj       AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cObjectPath             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOldRelPath             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewRelPath             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataset                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hLookup                 AS HANDLE     NO-UNDO.
  
  IF phCombo = hProduct THEN
    RUN valueChanged IN hProductModule.
  
  IF phCombo = hProductModule THEN DO:
    {get DataSource hDataSource}.
    IF NOT VALID-HANDLE(hDataSource) THEN
      RETURN.
    ASSIGN dProductModuleObj = DECIMAL(DYNAMIC-FUNCTION("columnValue":U IN hDataSource,"product_module_obj":U))
           cObjectPath       = DYNAMIC-FUNCTION("columnValue":U IN hDataSource,"object_path":U).
    /* If the object did have a path - check if we need to change it */
    IF cObjectPath <> "":U THEN DO:
      /* If the old path was equal to the product module's relative path
         then we need to change the object_path to that of the product module.
         If not, we should leave it up to the user to change */
  
      /* First get the old Product Module's relative path */
      RUN getRecordDetail IN gshGenManager ( INPUT "FOR EACH gsc_product_module 
                                                    WHERE gsc_product_module.product_module_obj = " + TRIM(QUOTER(dProductModuleObj)) + " NO-LOCK ":U,
                                             OUTPUT cDataset ).
      ASSIGN cOldRelPath = "":U.
      IF cDataset <> "":U AND cDataset <> ? THEN 
        ASSIGN cOldRelPath = ENTRY(LOOKUP("gsc_product_module.relative_path":U, cDataSet, CHR(3)) + 1 , cDataSet, CHR(3)) 
               dProductObj = DECIMAL(ENTRY(LOOKUP("gsc_product_module.product_obj":U, cDataSet, CHR(3)) + 1 , cDataSet, CHR(3)))
               NO-ERROR.
  
      /* Now get the new Product Module's relative path */
      RUN getRecordDetail IN gshGenManager ( INPUT "FOR EACH gsc_product_module 
                                                    WHERE gsc_product_module.product_module_obj = " + TRIM(QUOTER(DECIMAL(pcKeyFieldValue))) + " NO-LOCK ":U,
                                             OUTPUT cDataset ).
      ASSIGN cNewRelPath = "":U.
      IF cDataset <> "":U AND cDataset <> ? THEN 
        ASSIGN cNewRelPath = ENTRY(LOOKUP("gsc_product_module.relative_path":U, cDataSet, CHR(3)) + 1 , cDataSet, CHR(3)) 
               NO-ERROR.
  
      /* If the Object's Path was the same as the Product Module relative path,
         then we can change it */
      IF cOldRelPath = cObjectPath THEN
        ASSIGN RowObject.object_path:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cNewRelPath.
  
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyObject vTableWin 
PROCEDURE copyObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cCustomizationResultCode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewRecordValues          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataSource               AS HANDLE     NO-UNDO.

  DEFINE BUFFER ttTmpltObjectInstance FOR ttTmpltObjectInstance.
  DEFINE BUFFER ttTmpltAttributeValue FOR ttTmpltAttributeValue.
  DEFINE BUFFER ttTmpltSmartObject    FOR ttTmpltSmartObject.
  DEFINE BUFFER ttTmpltPageObject     FOR ttTmpltPageObject.
  DEFINE BUFFER ttTmpltSmartLink      FOR ttTmpltSmartLink.
  DEFINE BUFFER ttTmpltPage           FOR ttTmpltPage.
  DEFINE BUFFER ttObjectInstance      FOR ttObjectInstance.
  DEFINE BUFFER ttAttributeValue      FOR ttAttributeValue.
  DEFINE BUFFER ttSmartObject         FOR ttSmartObject.
  DEFINE BUFFER ttPageObject          FOR ttPageObject.
  DEFINE BUFFER ttSmartLink           FOR ttSmartLink.
  DEFINE BUFFER ttPage                FOR ttPage.

  EMPTY TEMP-TABLE ttTmpltObjectMenuStructure.
  EMPTY TEMP-TABLE ttTmpltObjectInstance.
  EMPTY TEMP-TABLE ttTmpltAttributeValue.
  EMPTY TEMP-TABLE ttTmpltSmartObject.
  EMPTY TEMP-TABLE ttTmpltPageObject.
  EMPTY TEMP-TABLE ttTmpltSmartLink.
  EMPTY TEMP-TABLE ttTmpltUiEvent.
  EMPTY TEMP-TABLE ttTmpltPage.

  SESSION:SET-WAIT-STATE("GENERAL":U).

  {launch.i &PLIP     = 'ry/app/rycntbplip.p'
            &IProc    = 'getContainerDetails'
            &PList    = "(INPUT  gcOldObjectName,
                          INPUT  gcOldProdModCode,
                          INPUT  gcObjectTypeCode,
                          INPUT  gdCustomResultObj,
                          OUTPUT TABLE ttTmpltSmartObject,
                          OUTPUT TABLE ttTmpltPage,
                          OUTPUT TABLE ttTmpltPageObject,
                          OUTPUT TABLE ttTmpltObjectInstance,
                          OUTPUT TABLE ttTmpltAttributeValue,
                          OUTPUT TABLE ttTmpltUiEvent,
                          OUTPUT TABLE ttTmpltSmartLink,
                          OUTPUT TABLE ttTmpltObjectMenuStructure)"
            &OnApp    = 'YES'
            &AutoKill = YES}

  /* ------------------------------------------------------ SmartObject ------------------------------------------------------ */
  
  FIND FIRST ttTmpltSmartObject
       WHERE ttTmpltSmartObject.d_smartobject_obj <> 0.00.
  
  CREATE ttSmartObject.

  BUFFER-COPY ttTmpltSmartObject
       EXCEPT ttTmpltSmartObject.d_smartobject_obj
              ttTmpltSmartObject.l_template
              ttTmpltSmartObject.d_product_module_obj
              ttTmpltSmartObject.d_customization_result_obj
              ttTmpltSmartObject.c_object_description
              ttTmpltSmartObject.c_object_filename
              ttTmpltSmartObject.d_layout_obj
              ttTmpltSmartObject.d_object_obj
              ttTmpltSmartObject.c_action
           TO ttSmartObject.

  IF ttSmartObject.c_object_description = "":U OR
     ttSmartObject.c_object_description = ?    THEN
    ttSmartObject.c_object_description = ttTmpltSmartObject.c_object_description.

  /* Assign SmartObject values from SDO */
  {get DataSource hDataSource}.
  cNewRecordValues = DYNAMIC-FUNCTION("colValues" IN hDataSource,"smartobject_obj,object_filename,customization_result_obj,object_type_obj,product_module_obj,layout_obj,object_description,static_object,template_smartobject,system_owned,shutdown_message_text,sdo_smartobject_obj").
  ASSIGN ttSmartObject.c_object_description       = ENTRY(8,cNewRecordValues,CHR(1))
         ttSmartObject.d_smartobject_obj          = DECIMAL(ENTRY(2,cNewRecordValues,CHR(1)))
         ttSmartObject.d_customization_result_obj = DECIMAL(ENTRY(4,cNewRecordValues,CHR(1)))
         ttSmartObject.d_layout_obj               = DECIMAL(ENTRY(7,cNewRecordValues,CHR(1)))
         ttSmartObject.d_object_type_obj          = DECIMAL(ENTRY(5,cNewRecordValues,CHR(1)))
         ttSmartObject.c_object_filename          = ENTRY(3,cNewRecordValues,CHR(1))
         ttSmartObject.d_product_module_obj       = DECIMAL(ENTRY(6,cNewRecordValues,CHR(1)))
         ttSmartObject.l_static_object            = LOGICAL(ENTRY(9,cNewRecordValues,CHR(1)))
         ttSmartObject.l_system_owned             = LOGICAL(ENTRY(11,cNewRecordValues,CHR(1)))
         ttSmartObject.c_shutdown_message_text    = ENTRY(12,cNewRecordValues,CHR(1))
         ttSmartObject.d_sdo_smartobject_obj      = DECIMAL(ENTRY(13,cNewRecordValues,CHR(1)))
         ttSmartObject.l_template_smartobject     = LOGICAL(ENTRY(10,cNewRecordValues,CHR(1)))
         ttSmartObject.c_action                   = "M":U.

/* ------------------------------------ Page, PageObject, ObjectInstance and SmartLink ------------------------------------- */
  /* DELETING*/
  /* --------- Page --------- */
  FOR EACH ttPage:
    ttPage.c_action = "D":U.
    
    IF ttPage.d_page_obj <= 0.00 THEN
      DELETE ttPage.
  END.
    
  /* --------- PageObject --------- */
  FOR EACH ttPageObject:
    ttPageObject.c_action = "D":U.
    
    IF ttPageObject.d_page_object_obj <= 0.00 THEN
      DELETE ttPageObject.
  END.
      
  /* --------- ObjectInstance --------- */
  FOR EACH ttObjectInstance
     WHERE ttObjectInstance.d_smartobject_obj <> 0.00:

    ttObjectInstance.c_action = "D":U.
  
    IF ttObjectInstance.d_object_instance_obj <= 0.00 THEN
      DELETE ttObjectInstance.
  END.
      
  /* --------- SmartLink --------- */
  FOR EACH ttSmartLink:
    ttSmartLink.c_action = "D":U.

    IF ttSmartLink.d_smartlink_obj <= 0.00 THEN
      DELETE ttSmartLink.
  END.
  
  /* --------- AttributeValue --------- */
  FOR EACH ttAttributeValue:
    ttAttributeValue.c_action = "D":U.

    IF ttAttributeValue.d_attribute_value_obj <= 0.00 THEN
      DELETE ttAttributeValue.
  END.
  
  /* --------- UiEvent --------- */
  FOR EACH ttUiEvent:
    ttUiEvent.c_action = "D":U.

    IF ttUiEvent.d_ui_event_obj <= 0.00 THEN
      DELETE ttUiEvent.
  END.
  
  /* --------- ObjectMenuStructure --------- */
  FOR EACH ttObjectMenuStructure:
     ttObjectMenuStructure.c_action = "D":U.

    IF ttObjectMenuStructure.d_object_menu_structure_obj <= 0.00 THEN
      DELETE ttObjectMenuStructure.
  END.

  /* CREATING*/
  /* --------- Page --------- */
  FOR EACH ttTmpltPage:

    CREATE ttPage.
    
    BUFFER-COPY ttTmpltPage
             TO ttPage.
         ASSIGN ttPage.d_container_smartobject_obj = ttSmartObject.d_smartobject_obj
                ttPage.d_page_obj                  = DYNAMIC-FUNCTION("getTemporaryObj":U IN TARGET-PROCEDURE)
                ttPage.c_action                    = "A":U.

    /* --------- PageObject --------- */
    FOR EACH ttTmpltPageObject
       WHERE ttTmpltPageObject.d_page_obj = ttTmpltPage.d_page_obj:
      
      CREATE ttPageObject.
      
      BUFFER-COPY ttTmpltPageObject
               TO ttPageObject.
           ASSIGN ttPageObject.d_container_smartobject_obj = ttSmartObject.d_smartobject_obj
                  ttPageObject.d_page_object_obj           = DYNAMIC-FUNCTION("getTemporaryObj":U IN TARGET-PROCEDURE)
                  ttPageObject.d_page_obj                  = ttPage.d_page_obj
                  ttPageObject.c_action                    = "A":U.
    END.
  END.

  /* --------- ObjectMenuStructure --------- */
  FOR EACH ttTmpltObjectMenuStructure:
    CREATE ttObjectMenuStructure.
    
    BUFFER-COPY ttTmpltObjectMenuStructure
             TO ttObjectMenuStructure
         ASSIGN ttObjectMenuStructure.d_object_menu_structure_obj = DYNAMIC-FUNCTION("getTemporaryObj":U IN TARGET-PROCEDURE)
                ttObjectMenuStructure.d_object_obj                = ttSmartObject.d_smartobject_obj
                ttObjectMenuStructure.c_action                    = "A":U.
  END.
  
  /* --------- SmartLink --------- */
  FOR EACH ttTmpltSmartLink:
    
    CREATE ttSmartLink.
    
    BUFFER-COPY ttTmpltSmartLink
             TO ttSmartLink.
         ASSIGN ttSmartLink.d_container_smartobject_obj = ttSmartObject.d_smartobject_obj
                ttSmartLink.d_smartlink_obj             = DYNAMIC-FUNCTION("getTemporaryObj":U IN TARGET-PROCEDURE)
                ttSmartLink.c_action                    = "A":U.
  END.
  
  /* --------- AttributeValue --------- */
  FOR EACH ttTmpltAttributeValue:

    CREATE ttAttributeValue.

    BUFFER-COPY ttTmpltAttributeValue
             TO ttAttributeValue
         ASSIGN ttAttributeValue.d_container_smartobject_obj = (IF ttTmpltAttributeValue.d_container_smartobject_obj = 0.00 THEN 0.00 ELSE ttSmartObject.d_smartobject_obj)
                ttAttributeValue.d_primary_smartobject_obj   = ttSmartObject.d_smartobject_obj
                ttAttributeValue.d_customization_result_obj  = 0.00
                ttAttributeValue.d_attribute_value_obj       = DYNAMIC-FUNCTION("getTemporaryObj":U IN TARGET-PROCEDURE)
                /* Check if it is a container property - if so, point it at the new container, else it was a property for an object instance, so point it at the correct smartobject */
                ttAttributeValue.d_smartobject_obj           = (IF ttTmpltAttributeValue.d_smartobject_obj = 0.00 THEN
                                                                  0.00
                                                                ELSE
                                                                  IF ttTmpltAttributeValue.d_smartobject_obj = ttTmpltSmartObject.d_smartobject_obj THEN
                                                                    ttSmartObject.d_smartobject_obj
                                                                  ELSE
                                                                    ttTmpltAttributeValue.d_smartobject_obj)
                ttAttributeValue.c_action                    = "A":U.
  END.

  /* --------- AttributeValue --------- */
  FOR EACH ttTmpltUiEvent:

    CREATE ttUiEvent.

    BUFFER-COPY ttTmpltUiEvent
             TO ttUiEvent
         ASSIGN ttUiEvent.d_container_smartobject_obj = (IF ttTmpltUiEvent.d_container_smartobject_obj = 0.00 THEN 0.00 ELSE ttSmartObject.d_smartobject_obj)
                ttUiEvent.d_primary_smartobject_obj   = ttSmartObject.d_smartobject_obj
                ttUiEvent.d_customization_result_obj  = gdCustomResultObj
                ttUiEvent.d_ui_event_obj              = DYNAMIC-FUNCTION("getTemporaryObj":U IN TARGET-PROCEDURE)
                /* Check if it is a container ui event - if so, point it at the new container, else it was a ui event for an object instance, so point it at the correct smartobject */
                ttUiEvent.d_smartobject_obj           = (IF ttTmpltUiEvent.d_smartobject_obj = 0.00 THEN
                                                           0.00
                                                         ELSE
                                                           IF ttTmpltUiEvent.d_smartobject_obj = ttTmpltSmartObject.d_smartobject_obj THEN
                                                             ttSmartObject.d_smartobject_obj
                                                           ELSE
                                                             ttTmpltUiEvent.d_smartobject_obj)
                ttUiEvent.c_action                    = "A":U.
  END.

  /* --------- ObjectInstance --------- */
  FOR EACH ttTmpltObjectInstance
     WHERE ttTmpltObjectInstance.d_smartobject_obj <> 0.00:
    
    CREATE ttObjectInstance.

    BUFFER-COPY ttTmpltObjectInstance
             TO ttObjectInstance.
         ASSIGN ttObjectInstance.d_container_smartobject_obj = ttSmartObject.d_smartobject_obj
                ttObjectInstance.d_object_instance_obj       = DYNAMIC-FUNCTION("getTemporaryObj":U IN TARGET-PROCEDURE)
                ttObjectInstance.c_action                    = "A":U.
    
    /* Make sure the PageObjects point to the newly created object instances */
    FOR EACH ttPageObject
       WHERE ttPageObject.d_object_instance_obj = ttTmpltObjectInstance.d_object_instance_obj
         AND ttPageObject.c_action             <> "D":U:
      
      ttPageObject.d_object_instance_obj = ttObjectInstance.d_object_instance_obj.
    END.
    
    /* Make sure the SmartLinks point to the newly created object instances */
    FOR EACH  ttSmartLink
       WHERE  ttSmartLink.d_container_smartobject_obj  = ttSmartObject.d_smartobject_obj
         AND (ttSmartLink.d_source_object_instance_obj = ttTmpltObjectInstance.d_object_instance_obj
          OR  ttSmartLink.d_target_object_instance_obj = ttTmpltObjectInstance.d_object_instance_obj)
         AND  ttSmartLink.c_action                     <> "D":U:
      
      IF ttSmartLink.d_source_object_instance_obj = ttTmpltObjectInstance.d_object_instance_obj THEN
        ttSmartLink.d_source_object_instance_obj = ttObjectInstance.d_object_instance_obj.
        
      IF ttSmartLink.d_target_object_instance_obj = ttTmpltObjectInstance.d_object_instance_obj THEN
        ttSmartLink.d_target_object_instance_obj = ttObjectInstance.d_object_instance_obj.
    END.

    /* Make sure the attributes of the object instance point to the new object instance record */
    FOR EACH ttAttributeValue
       WHERE ttAttributeValue.d_primary_smartobject_obj = ttSmartObject.d_smartobject_obj
         AND ttAttributeValue.d_object_instance_obj     = ttTmpltObjectInstance.d_object_instance_obj:

      ttAttributeValue.d_object_instance_obj = (IF ttAttributeValue.d_object_instance_obj = 0.00 THEN 0.00 ELSE ttObjectInstance.d_object_instance_obj).
    END.

    /* Make sure the ui events of the object instance point to the new object instance record */
    FOR EACH ttUiEvent
       WHERE ttUiEvent.d_primary_smartobject_obj = ttSmartObject.d_smartobject_obj
         AND ttUiEvent.d_object_instance_obj     = ttTmpltObjectInstance.d_object_instance_obj:

      ttUiEvent.d_object_instance_obj = (IF ttUiEvent.d_object_instance_obj = 0.00 THEN 0.00 ELSE ttObjectInstance.d_object_instance_obj).
    END.

  END.
  
  {launch.i &PLIP     = 'ry/app/rycntbplip.p'
            &IProc    = 'setContainerDetails'
            &PList    = "(INPUT  DYNAMIC-FUNCTION('getDataValue':U IN hCustomizationResultCode),
                          INPUT-OUTPUT TABLE ttSmartObject,
                          INPUT-OUTPUT TABLE ttPage,
                          INPUT-OUTPUT TABLE ttPageObject,
                          INPUT-OUTPUT TABLE ttObjectInstance,
                          INPUT-OUTPUT TABLE ttAttributeValue,
                          INPUT-OUTPUT TABLE ttUiEvent,
                          INPUT-OUTPUT TABLE ttSmartLink,
                          INPUT-OUTPUT TABLE ttObjectMenuStructure)"
            &OnApp    = 'YES'
            &AutoKill = YES}
  
  EMPTY TEMP-TABLE ttTmpltObjectMenuStructure.
  EMPTY TEMP-TABLE ttTmpltObjectInstance.
  EMPTY TEMP-TABLE ttTmpltAttributeValue.
  EMPTY TEMP-TABLE ttTmpltSmartObject.
  EMPTY TEMP-TABLE ttTmpltPageObject.
  EMPTY TEMP-TABLE ttTmpltSmartLink.
  EMPTY TEMP-TABLE ttTmpltUiEvent.
  EMPTY TEMP-TABLE ttTmpltPage.
  SESSION:SET-WAIT-STATE("":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyRecord vTableWin 
PROCEDURE copyRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hComboHandle AS HANDLE     NO-UNDO.
  /* Code placed here will execute PRIOR to standard behavior. */
  
  ASSIGN glAddRecord = TRUE
         glCopyRecord = TRUE.
  glEnableObjectName = TRUE.

  RUN SUPER.

  {get ComboHandle hComboHandle hProductModule}.
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN gcOldObjectName   = RowObject.object_filename:SCREEN-VALUE
           gcOldProdModCode  = TRIM(ENTRY(1,ENTRY(LOOKUP(STRING(DECIMAL(DYNAMIC-FUNCTION("getDataValue":U IN hProductModule)),DYNAMIC-FUNCTION("getKeyFormat":U IN hProductModule)),hComboHandle:LIST-ITEM-PAIRS,hComboHandle:DELIMITER) - 1,hComboHandle:LIST-ITEM-PAIRS,hComboHandle:DELIMITER),"/":U))
           gcObjectTypeCode  = DYNAMIC-FUNCTION("getDisplayValue":U IN h_ObjectType)
           gdCustomResultObj = DYNAMIC-FUNCTION("getDataValue":U IN hCustomizationResultCode).
  END.

  APPLY "VALUE-CHANGED":U TO RowObject.static_object IN FRAME {&FRAME-NAME}.
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableFields vTableWin 
PROCEDURE disableFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcFieldType AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcFieldType).

  /* Code placed here will execute AFTER standard behavior.    */
  DISABLE bu_find_object WITH FRAME {&FRAME-NAME}.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayFields vTableWin 
PROCEDURE displayFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcColValues AS CHARACTER NO-UNDO.

  DEFINE VARIABLE hContainer      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cContainerMode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hGroupAssign    AS HANDLE     NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  
  ASSIGN
      co_run_when:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = gcRunWhen.
  
  RUN SUPER( INPUT pcColValues).
  
  ASSIGN co_run_when:SCREEN-VALUE IN FRAME {&FRAME-NAME} = RowObject.run_when:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-ERROR.
  
  glEnableObjectName = FALSE.

  hGroupAssign = WIDGET-HANDLE(ENTRY(1,DYNAMIC-FUNCTION("linkHandles", "GroupAssign-Target":U))).
  
  DO WITH FRAME {&FRAME-NAME}:
    IF RowObject.static_object:SENSITIVE AND 
       VALID-HANDLE(hGroupAssign) THEN
      RUN logicalObject IN hGroupAssign (NOT INPUT RowObject.static_object:CHECKED).
  END.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFields vTableWin 
PROCEDURE enableFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* The object type is defaulted to the selected object type from
     the parent node. The user should not be able to change this */
  
  IF NOT glEnableObjectName THEN DO:
    DISABLE bu_find_object RowObject.object_filename
            WITH FRAME {&FRAME-NAME}.
  END.
  ELSE
    ENABLE bu_find_object RowObject.object_filename
            WITH FRAME {&FRAME-NAME}.
  
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE genericObject vTableWin 
PROCEDURE genericObject :
/*------------------------------------------------------------------------------
  Purpose:     If user select the object to be generic - disable the 
               logical object and physical object fields.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER plGenericObject AS LOGICAL    NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    IF RowObject.object_filename:SENSITIVE THEN DO:
      IF plGenericObject THEN
        ASSIGN RowObject.static_object:CHECKED    = TRUE
               RowObject.static_object:SENSITIVE = FALSE.
     
      ELSE
        ASSIGN RowObject.static_object:SENSITIVE = TRUE.      
    END.
  END.
  
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
  /*getClassChildrenFromDB returns data with a CHR(3) delimiter between the children of each requested class. */
  ASSIGN fiSDOClasses:SCREEN-VALUE IN FRAME {&FRAME-NAME} = replace(DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "data,SBO":U), chr(3), ',':u)
         fiSDOClasses.

  /* Code placed here will execute PRIOR to standard behavior. */
  SUBSCRIBE TO "comboValueChanged":U IN THIS-PROCEDURE.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetRecord vTableWin 
PROCEDURE resetRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF glAddRecord THEN DO:
    ASSIGN glAddRecord  = FALSE
           glCopyRecord = FALSE.
    RUN cancelRecord.
    RETURN.
  END.
  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateMode vTableWin 
PROCEDURE updateMode :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcMode AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcMode).
  
  gcMode = pcMode.
/*
  IF pcMode = "Modify":U THEN
    APPLY "VALUE-CHANGED":U TO RowObject.static_object IN FRAME {&FRAME-NAME}.
  */
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRecord vTableWin 
PROCEDURE updateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataSource       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE dObjType          AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cAnswer           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessage          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lRefresh          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hContainer        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cObjectName       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dProductModuleObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dProductObj       AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cMessageList      AS CHARACTER  NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  IF NOT glAddRecord THEN DO:
    {get DataSource hDataSource}.
    IF VALID-HANDLE(hDataSource) THEN
      ASSIGN dObjType          = DECIMAL(DYNAMIC-FUNCTION("columnStringValue" IN hDataSource,"object_type_obj"))
             cObjectName       = DYNAMIC-FUNCTION("columnStringValue" IN hDataSource,"object_filename")
             dProductModuleObj = DECIMAL(DYNAMIC-FUNCTION("columnValue":U IN hDataSource,"product_module_obj":U)).

    /* They are Changing the Object Type - Warn them */
    IF dObjType <> DYNAMIC-FUNCTION("getDataValue":U IN h_ObjectType) THEN DO:
      cMessage = "WARNING - PLEASE READ:~n" + 
                 "You are about to change the Object Type and this could have serious consequences.~n~n" +
                 "Please make sure of the following before continuing:~n" +
                 "1. Ensure you have a reliable backup~n" +
                 "2. Ensure that the object type you are changing to is relevant to this object~n" +
                 "3. Ensure that you know what you are doing.~n~n" +
                 "When this change has taken place it cannot be undone.~n~n" +
                 "You should be aware that " +
                 "any Attributes or UI Events on this object that is not a valid for the new class selected " +
                 "will be removed.~n~n" +
                 "Are you sure you want to continue with this change?".
      RUN askQuestion IN gshSessionManager (INPUT         cMessage,    /* message to display */
                                             INPUT        "&YES,&NO,&Cancel":U,    /* button list */
                                             INPUT        "&YES":U,                /* default button */ 
                                             INPUT        "&Cancel":U,             /* cancel button */
                                             INPUT        "Are you sure you want to change the Object Type":U, /* window title */
                                             INPUT        "":U,                    /* data type of question */ 
                                             INPUT        "":U,                    /* format mask for question */ 
                                             INPUT-OUTPUT cAnswer,                 /* character value of answer to question */ 
                                                   OUTPUT cButton                  /* button pressed */
                                             ).
      IF cButton <> "&YES":U THEN 
        RETURN ERROR "ADM-ERROR":U.
      lRefresh = TRUE.
    END. /* Change Object Type */

    /* User is changing the Product Module - Show WARNING MESSAGE */
    IF dProductModuleObj <> DECIMAL(DYNAMIC-FUNCTION("getDataValue":U IN hProductModule)) THEN DO:
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '44'}.
      RUN showMessages IN gshSessionManager (INPUT cMessageList,
                                             INPUT "WAR":U,
                                             INPUT "&Yes,&No,&Cancel":U,
                                             INPUT "&Yes":U,
                                             INPUT "&Yes":U,
                                             INPUT "Confirm Product Module Change",
                                             INPUT YES,
                                             INPUT ?,
                                             OUTPUT cButton).
      IF cButton <> "&YES":U THEN DO:
        /* Reset back to old Product Module */
        IF VALID-HANDLE(hDataSource) THEN
          ASSIGN dProductObj       = DECIMAL(DYNAMIC-FUNCTION("columnValue":U IN hDataSource,"product_obj":U))
                 dProductModuleObj = DECIMAL(DYNAMIC-FUNCTION("columnValue":U IN hDataSource,"product_module_obj":U))
                 RowObject.object_path:SCREEN-VALUE IN FRAME {&FRAME-NAME} = DYNAMIC-FUNCTION("columnValue":U IN hDataSource,"object_path":U).

        {set DataValue dProductObj hProduct}.
        RUN refreshChildDependancies IN hProductModule (INPUT "dProductObj").
        {set DataValue dProductModuleObj hProductModule}.
        RETURN ERROR "ADM-ERROR":U.
      END.
    END. /* Change Product Module */
  END.
  
  ASSIGN glAddRecord  = FALSE.

  RUN SUPER.


  IF lRefresh THEN DO:
    {get ContainerSource hContainer}.
    PUBLISH "refreshFilter" FROM hContainer (INPUT cObjectName).
  END.


  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateState vTableWin 
PROCEDURE updateState :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcState AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcState).

  /* Code placed here will execute AFTER standard behavior.    */
  
  /* If we copied an object we need to copy all it's pages, instances etc too */
  IF pcState = "UpdateComplete":U AND
     glCopyRecord = TRUE THEN DO:
    /* I'm using the PLIP used for the Container Builder to copy
       all the other components of the object */
    /* Before copying all the data, check if the user is copying the
       object record and making it a customization of the original object.
       If the user just want's to add a customization then just copy the
       object record and none of the other data */
    IF gcOldObjectName <> RowObject.object_filename:SCREEN-VALUE IN FRAME {&FRAME-NAME} AND 
       gdCustomResultObj = DECIMAL(DYNAMIC-FUNCTION("getDataValue":U IN hCustomizationResultCode)) THEN
      RUN copyObject.

    glCopyRecord = FALSE.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

