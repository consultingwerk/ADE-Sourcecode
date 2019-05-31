&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" sObject _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" sObject _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE RowObject
       {"ry/obj/rycavful3o.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sObject 
/* Copyright (C) 2000,2007 by Progress Software Corporation. All rights
   reserved.  Prior versions of this work may contain portions
   contributed by participants of Possenet. */
/*---------------------------------------------------------------------------------
  File: rycavupdtv.w

  Description:  Attribute Value Update SmartViewer

  Purpose:      Attribute Value Update SmartViewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   05/14/2002  Author:     

  Update Notes: Created from Template rysttsimpv.w

  (v:010001)    Task:           0   UserRef:    
                Date:   10/30/2001  Author:     Mark Davies (MIP)

  Update Notes: Created from Template rysttsimpv.w

  (v:010002)    Task:           0   UserRef:    
                Date:   02/05/2002  Author:     Mark Davies (MIP)

  Update Notes: Enable dynamic combo and lookup fields on initialization.

  (v:010003)    Task:           0   UserRef:    
                Date:   02/27/2002  Author:     Mark Davies (MIP)

  Update Notes: When RTB is connected - Auto assign Check Out to TRUE and disable.
                This is done by default by the TRIGGERS
-------------------------------------------------------------------------------*/
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

&scop object-name       rycavupdtv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{af/sup2/afglobals.i}

{af/sup2/afrun2.i     &define-only = YES}
{af/app/afdatatypi.i}

DEFINE VARIABLE gdRefreshPressed AS LOGICAL    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "ry/obj/rycavful3o.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS raAction ToOverride EdAttributeValue ~
fiProductObjC ToGenerateADO ToCheckOut fiLogFile buRootDirectory fiADODir ~
buADODir ToScreen ToObjectType fiObjectFileName ToObjectMaster buRefresh ~
ToObjectInstance ToAll 
&Scoped-Define DISPLAYED-OBJECTS raAction ToOverride EdAttributeValue ~
ToGenerateADO ToCheckOut fiLogFile fiADODir ToScreen ToObjectType ~
fiObjectFileName ToObjectMaster ToObjectInstance ToAll 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE hAttributeGroupObj AS HANDLE NO-UNDO.
DEFINE VARIABLE hAttributeLabel AS HANDLE NO-UNDO.
DEFINE VARIABLE hNewAttributeLabel AS HANDLE NO-UNDO.
DEFINE VARIABLE hObjectTypeObj AS HANDLE NO-UNDO.
DEFINE VARIABLE hProductModuleObj AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buADODir 
     LABEL "..." 
     SIZE 3.4 BY 1 TOOLTIP "Directory lookup"
     BGCOLOR 8 .

DEFINE BUTTON buRefresh DEFAULT 
     LABEL "&Refresh" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buRootDirectory 
     LABEL "..." 
     SIZE 3.4 BY 1 TOOLTIP "Directory lookup"
     BGCOLOR 8 .

DEFINE VARIABLE EdAttributeValue AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 47.6 BY 2 NO-UNDO.

DEFINE VARIABLE fiADODir AS CHARACTER FORMAT "X(256)":U 
     LABEL "ADO Export Dir" 
     VIEW-AS FILL-IN 
     SIZE 46.8 BY 1 NO-UNDO.

DEFINE VARIABLE fiAttributeGrp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 1.2 BY 1 NO-UNDO.

DEFINE VARIABLE fiLogFile AS CHARACTER FORMAT "X(256)":U 
     LABEL "Output to Log File" 
     VIEW-AS FILL-IN 
     SIZE 47.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiObjectFileName AS CHARACTER FORMAT "X(70)":U 
     LABEL "Object Name" 
     VIEW-AS FILL-IN 
     SIZE 48 BY 1 NO-UNDO.

DEFINE VARIABLE fiProductObjC AS DECIMAL FORMAT "->>>>>>>>>>>>>>>>>9.999999999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 1.2 BY 1 NO-UNDO.

DEFINE VARIABLE raAction AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Create/Assign Attribute Values", "ASSIGN",
"Rename Attribute Label", "RENAME",
"Delete Attribute Values", "DELETE"
     SIZE 44 BY 2.57 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46 BY 3.05.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 38.8 BY 1.52.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46 BY 2.29.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46 BY 1.43.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46 BY 3.05.

DEFINE VARIABLE ToAll AS LOGICAL INITIAL no 
     LABEL "A&ll Objects" 
     VIEW-AS TOGGLE-BOX
     SIZE 14.6 BY .81 NO-UNDO.

DEFINE VARIABLE ToCheckOut AS LOGICAL INITIAL no 
     LABEL "Check Out Object First (if using SCM Tool)" 
     VIEW-AS TOGGLE-BOX
     SIZE 44.4 BY .81 NO-UNDO.

DEFINE VARIABLE ToGenerateADO AS LOGICAL INITIAL no 
     LABEL "Generate ADO's" 
     VIEW-AS TOGGLE-BOX
     SIZE 43.2 BY .81 NO-UNDO.

DEFINE VARIABLE ToObjectInstance AS LOGICAL INITIAL no 
     LABEL "Update Object Instances" 
     VIEW-AS TOGGLE-BOX
     SIZE 43.2 BY .81 NO-UNDO.

DEFINE VARIABLE ToObjectMaster AS LOGICAL INITIAL no 
     LABEL "Update Object Masters" 
     VIEW-AS TOGGLE-BOX
     SIZE 43.2 BY .81 NO-UNDO.

DEFINE VARIABLE ToObjectType AS LOGICAL INITIAL no 
     LABEL "Update Object Types" 
     VIEW-AS TOGGLE-BOX
     SIZE 43.2 BY .81 NO-UNDO.

DEFINE VARIABLE ToOverride AS LOGICAL INITIAL no 
     LABEL "Overwrite Existing Customizations" 
     VIEW-AS TOGGLE-BOX
     SIZE 36 BY .81 NO-UNDO.

DEFINE VARIABLE ToScreen AS LOGICAL INITIAL no 
     LABEL "Output to Screen Also" 
     VIEW-AS TOGGLE-BOX
     SIZE 43.2 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     raAction AT ROW 1.57 COL 71 NO-LABEL
     fiAttributeGrp AT ROW 1.86 COL 2.2 NO-LABEL
     ToOverride AT ROW 1.86 COL 118.6
     EdAttributeValue AT ROW 4.14 COL 20.8 NO-LABEL
     fiProductObjC AT ROW 4.81 COL 1 NO-LABEL
     ToGenerateADO AT ROW 5.19 COL 71.2
     ToCheckOut AT ROW 6 COL 71.2
     fiLogFile AT ROW 6.19 COL 18.8 COLON-ALIGNED
     buRootDirectory AT ROW 6.19 COL 64.8
     fiADODir AT ROW 7.19 COL 18.8 COLON-ALIGNED
     buADODir AT ROW 7.24 COL 64.8
     ToScreen AT ROW 7.91 COL 71.2
     ToObjectType AT ROW 9.71 COL 71.2
     fiObjectFileName AT ROW 10.33 COL 19 COLON-ALIGNED
     ToObjectMaster AT ROW 10.57 COL 71.2
     buRefresh AT ROW 11.19 COL 140.4
     ToObjectInstance AT ROW 11.43 COL 71.2
     ToAll AT ROW 11.57 COL 118.6
     RECT-3 AT ROW 4.76 COL 70.4
     RECT-4 AT ROW 7.43 COL 70.4
     RECT-1 AT ROW 1.29 COL 70
     RECT-5 AT ROW 9.33 COL 70.4
     RECT-2 AT ROW 1.29 COL 117
     "New Attribute Value:" VIEW-AS TEXT
          SIZE 19.4 BY .62 AT ROW 4.24 COL 1.2
     "Action To Be Taken:" VIEW-AS TEXT
          SIZE 20.8 BY .62 AT ROW 1 COL 72
     "Action Options:" VIEW-AS TEXT
          SIZE 16 BY .62 AT ROW 1.1 COL 119
     "Object Options:" VIEW-AS TEXT
          SIZE 15.2 BY .62 AT ROW 4.48 COL 72
     "Log Options:" VIEW-AS TEXT
          SIZE 12.4 BY .62 AT ROW 7.19 COL 72
     "Change Level:" VIEW-AS TEXT
          SIZE 14.4 BY .62 AT ROW 9.05 COL 72
     SPACE(0.00) SKIP(0.62)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         DEFAULT-BUTTON buRefresh.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "ry/obj/rycavful3o.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {ry/obj/rycavful3o.i}
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
  CREATE WINDOW sObject ASSIGN
         HEIGHT             = 11.38
         WIDTH              = 154.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB sObject 
/* ************************* Included-Libraries *********************** */

{src/adm2/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW sObject
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

ASSIGN 
       EdAttributeValue:RETURN-INSERTED IN FRAME frMain  = TRUE.

/* SETTINGS FOR FILL-IN fiAttributeGrp IN FRAME frMain
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       fiAttributeGrp:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN fiProductObjC IN FRAME frMain
   NO-DISPLAY ALIGN-L                                                   */
ASSIGN 
       fiProductObjC:HIDDEN IN FRAME frMain           = TRUE
       fiProductObjC:PRIVATE-DATA IN FRAME frMain     = 
                "NOLOOKUPS".

/* SETTINGS FOR RECTANGLE RECT-1 IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-2 IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-3 IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-4 IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-5 IN FRAME frMain
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

&Scoped-define SELF-NAME buADODir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buADODir sObject
ON CHOOSE OF buADODir IN FRAME frMain /* ... */
DO:
  RUN getFolder("Directory", OUTPUT fiADODir).
  IF fiADODir <> "":U THEN
    ASSIGN
        fiADODir:SCREEN-VALUE = fiADODir.
  APPLY "ENTRY":U TO fiADODir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRefresh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRefresh sObject
ON CHOOSE OF buRefresh IN FRAME frMain /* Refresh */
DO:
  DEFINE VARIABLE dProductModuleObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dObjectTypeObj    AS DECIMAL    NO-UNDO.

  gdRefreshPressed = TRUE.
  
  ASSIGN fiObjectFileName.
  ASSIGN dProductModuleObj = DYNAMIC-FUNCTION("getDataValue":U IN hProductModuleObj)
         dObjectTypeObj    = DYNAMIC-FUNCTION("getDataValue":U IN hObjectTypeObj).
         
  RUN refreshBrowse (INPUT dObjectTypeObj,
                     INPUT dProductModuleObj,
                     INPUT fiObjectFileName).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRootDirectory
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRootDirectory sObject
ON CHOOSE OF buRootDirectory IN FRAME frMain /* ... */
DO:
  DEFINE VARIABLE cFileName AS CHARACTER  NO-UNDO.
  ASSIGN fiLogFile.
  ASSIGN fiLogFile = REPLACE(fiLogFile,"~\":U,"/":U)
         cFileName = TRIM(SUBSTRING(fiLogFile,R-INDEX(fiLogFile,"/":U) + 1,LENGTH(fiLogFile))).
         
  RUN getFolder("Directory", OUTPUT fiLogFile).
  IF fiLogFile <> "":U THEN
    ASSIGN
        fiLogFile:SCREEN-VALUE = fiLogFile + "/":U + cFileName.
  APPLY "ENTRY":U TO fiLogFile.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiObjectFileName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiObjectFileName sObject
ON VALUE-CHANGED OF fiObjectFileName IN FRAME frMain /* Object Name */
DO:
  IF gdRefreshPressed THEN
    APPLY "CHOOSE":U TO buRefresh.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME raAction
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL raAction sObject
ON VALUE-CHANGED OF raAction IN FRAME frMain
DO:
  ASSIGN raAction.
  CASE raAction:
    WHEN "ASSIGN" THEN DO:
      ASSIGN edAttributeValue:SENSITIVE = TRUE.
      DYNAMIC-FUNCTION("setDataValue":U IN hNewAttributeLabel, "":U).
      RUN disableField IN hNewAttributeLabel.
    END.
    WHEN "RENAME":U THEN DO:
      ASSIGN edAttributeValue:SCREEN-VALUE = "":U
             edAttributeValue:SENSITIVE    = FALSE.
      DYNAMIC-FUNCTION("setDataValue":U IN hNewAttributeLabel, "":U).
      RUN enableField IN hNewAttributeLabel.
    END.
    WHEN "DELETE":U THEN DO:
      ASSIGN edAttributeValue:SCREEN-VALUE = "":U
             edAttributeValue:SENSITIVE    = FALSE.
      DYNAMIC-FUNCTION("setDataValue":U IN hNewAttributeLabel, "":U).
      RUN disableField IN hNewAttributeLabel.
    END.
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ToAll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ToAll sObject
ON VALUE-CHANGED OF ToAll IN FRAME frMain /* All Objects */
DO:
  DEFINE VARIABLE hContainer  AS HANDLE   NO-UNDO.

  ASSIGN toAll.
  {get ContainerSource hContainer}.
  
  IF VALID-HANDLE(hContainer) AND 
     LOOKUP("objectsSelected":U,hContainer:INTERNAL-ENTRIES) > 0 THEN
    RUN objectsSelected IN hContainer (INPUT toAll).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ToGenerateADO
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ToGenerateADO sObject
ON VALUE-CHANGED OF ToGenerateADO IN FRAME frMain /* Generate ADO's */
DO:
  ASSIGN toGenerateADO.
  IF NOT toGenerateADO THEN 
    ASSIGN fiADODir:SCREEN-VALUE = "":U
           fiADODir:SENSITIVE    = FALSE
           buADODir:SENSITIVE    = FALSE.
  ELSE
    ASSIGN fiADODir:SENSITIVE    = TRUE
           buADODir:SENSITIVE    = TRUE
           FILE-INFO:FILE-NAME   = "." /* Current Work Directory */
           fiADODir:SCREEN-VALUE = IF FILE-INFO:FULL-PATHNAME <> ? THEN FILE-INFO:FULL-PATHNAME ELSE SESSION:TEMP-DIR
           fiADODir:SCREEN-VALUE = REPLACE(fiADODir:SCREEN-VALUE,"~\":U,"/":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ToObjectInstance
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ToObjectInstance sObject
ON VALUE-CHANGED OF ToObjectInstance IN FRAME frMain /* Update Object Instances */
DO:
  RUN objectsSelectable.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ToObjectMaster
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ToObjectMaster sObject
ON VALUE-CHANGED OF ToObjectMaster IN FRAME frMain /* Update Object Masters */
DO:
  RUN objectsSelectable.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK sObject 


/* ***************************  Main Block  *************************** */

/* If testing in the UIB, initialize the SmartObject. */  
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
  RUN initializeObject.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects sObject  _ADM-CREATE-OBJECTS
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
             INPUT  'DisplayedFieldryc_attribute_group.attribute_group_nameKeyFieldryc_attribute_group.attribute_group_objFieldLabelAttribute GroupFieldTooltipSelect an Attribute Group from the listKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(28)DisplayDatatypecharacterBaseQueryStringFOR EACH ryc_attribute_group NO-LOCK BY ryc_attribute_group.attribute_group_nameQueryTablesryc_attribute_groupSDFFileNameSDFTemplateParentFieldParentFilterQueryDescSubstitute&1CurrentKeyValueComboDelimiterListItemPairsCurrentDescValueInnerLines5ComboFlagAFlagValue0BuildSequence10SecurednoCustomSuperProcFieldName<Local>DisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hAttributeGroupObj ).
       RUN repositionObject IN hAttributeGroupObj ( 1.00 , 21.00 ) NO-ERROR.
       RUN resizeObject IN hAttributeGroupObj ( 1.05 , 48.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_attribute.attribute_labelKeyFieldryc_attribute.attribute_labelFieldLabelAttribute LabelFieldTooltipPress F4 For Lookup on AttributesKeyFormatX(35)KeyDatatypecharacterDisplayFormatX(35)DisplayDatatypecharacterBaseQueryStringFOR EACH ryc_attribute NO-LOCK BY ryc_attribute.attribute_labelQueryTablesryc_attributeBrowseFieldsryc_attribute.attribute_label,ryc_attribute.attribute_narrative,ryc_attribute.system_ownedBrowseFieldDataTypescharacter,character,logicalBrowseFieldFormatsX(35),X(500),YES/NORowsToBatch200BrowseTitleLookup Attribute LabelViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldfiAttributeGrp,fiAttributeGrpParentFilterQuery(IF DECIMAL(~'&1~') > 0 THEN ryc_attribute.attribute_group_obj = DECIMAL(~'&1~') ELSE TRUE)MaintenanceObjectrycatfoldwMaintenanceSDOrycatfullo.wCustomSuperProcFieldName<Local>DisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hAttributeLabel ).
       RUN repositionObject IN hAttributeLabel ( 2.05 , 20.80 ) NO-ERROR.
       RUN resizeObject IN hAttributeLabel ( 1.00 , 47.80 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_attribute.attribute_labelKeyFieldryc_attribute.attribute_labelFieldLabelNew Attribute LabelFieldTooltipPress F4 for LookupKeyFormatX(35)KeyDatatypecharacterDisplayFormatX(35)DisplayDatatypecharacterBaseQueryStringFOR EACH ryc_attribute NO-LOCK BY ryc_attribute.attribute_labelQueryTablesryc_attributeBrowseFieldsryc_attribute.attribute_label,ryc_attribute.attribute_narrative,ryc_attribute.system_ownedBrowseFieldDataTypescharacter,character,logicalBrowseFieldFormatsX(35),X(500),YES/NORowsToBatch200BrowseTitleLookup New Attribute LabelViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectrycatfoldwMaintenanceSDOrycatfullo.wCustomSuperProcFieldName<Local>DisplayFieldyesEnableFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hNewAttributeLabel ).
       RUN repositionObject IN hNewAttributeLabel ( 3.10 , 20.80 ) NO-ERROR.
       RUN resizeObject IN hNewAttributeLabel ( 1.00 , 47.80 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dyncombo.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_product.product_code,gsc_product_module.product_module_code,gsc_product_module.product_module_descriptionKeyFieldgsc_product_module.product_module_objFieldLabelProduct ModuleFieldTooltipSelect a Product Module from the listKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(256)DisplayDatatypeCHARACTERBaseQueryStringFOR EACH gsc_product NO-LOCK,
                     EACH gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_obj = gsc_product.product_obj
                     BY gsc_product.product_code BY gsc_product_module.product_module_codeQueryTablesgsc_product,gsc_product_moduleSDFFileNameSDFTemplateParentFieldParentFilterQueryDescSubstitute&1 / &2 / &3CurrentKeyValueComboDelimiterListItemPairsCurrentDescValueInnerLines5ComboFlagAFlagValue0BuildSequence2SecurednoCustomSuperProcFieldName<Local>DisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hProductModuleObj ).
       RUN repositionObject IN hProductModuleObj ( 8.24 , 21.00 ) NO-ERROR.
       RUN resizeObject IN hProductModuleObj ( 1.05 , 47.60 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dyncombo.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_object_type.object_type_code,gsc_object_type.object_type_descriptionKeyFieldgsc_object_type.object_type_objFieldLabelObject TypeFieldTooltipSelect an Object Type from the listKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(256)DisplayDatatypeCHARACTERBaseQueryStringFOR EACH gsc_object_type NO-LOCK BY gsc_object_type.object_type_codeQueryTablesgsc_object_typeSDFFileNameSDFTemplateParentFieldParentFilterQueryDescSubstitute&1 / &2CurrentKeyValueComboDelimiterListItemPairsCurrentDescValueInnerLines5ComboFlagAFlagValue0BuildSequence1SecurednoCustomSuperProcFieldName<Local>DisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hObjectTypeObj ).
       RUN repositionObject IN hObjectTypeObj ( 9.29 , 21.00 ) NO-ERROR.
       RUN resizeObject IN hObjectTypeObj ( 1.00 , 47.60 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( hAttributeGroupObj ,
             raAction:HANDLE IN FRAME frMain , 'BEFORE':U ).
       RUN adjustTabOrder ( hAttributeLabel ,
             ToOverride:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( hNewAttributeLabel ,
             hAttributeLabel , 'AFTER':U ).
       RUN adjustTabOrder ( hProductModuleObj ,
             ToScreen:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( hObjectTypeObj ,
             hProductModuleObj , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE comboValueChanged sObject 
PROCEDURE comboValueChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcKeyFieldValue          AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcScreenValue      AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER phCombo            AS HANDLE     NO-UNDO. 

DEFINE VARIABLE dProductObj AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dAttrGrpObj AS DECIMAL    NO-UNDO.

IF phCombo = hAttributeGroupObj THEN DO WITH FRAME {&FRAME-NAME}:
  dAttrGrpObj = DECIMAL(DYNAMIC-FUNCTION("getDataValue":U IN hAttributeGroupObj)).
  ASSIGN fiAttributeGrp:SCREEN-VALUE = STRING(dAttrGrpObj).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI sObject  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getAttributeOptions sObject 
PROCEDURE getAttributeOptions :
/*------------------------------------------------------------------------------
  Purpose:     This procedure returns the value of the actions and options
               specified on screen.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER pcAttributeLabel        AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcNewAttributeLabel     AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcAttributeValue        AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pdObjectTypeObj         AS DECIMAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcAction                AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER plOverrideValues        AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER plGenerateADO           AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER plCheckOutObject        AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER plUpdateTypes           AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER plUpdateObject          AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER plUpdateObjectInstance  AS LOGICAL    NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN EdAttributeValue
           raAction
           ToOverride
           ToGenerateADO
           ToCheckOut
           ToObjectType
           ToObjectMaster
           ToObjectInstance.
  END.
  
  ASSIGN pcAttributeLabel       = DYNAMIC-FUNCTION("getDataValue":U IN hAttributeLabel)
         pcNewAttributeLabel    = DYNAMIC-FUNCTION("getDataValue":U IN hNewAttributeLabel)
         pdObjectTypeObj        = DYNAMIC-FUNCTION("getDataValue":U IN hObjectTypeObj)
         pcAttributeValue       = EdAttributeValue
         pcAction               = raAction
         plOverrideValues       = ToOverride
         plGenerateADO          = ToGenerateADO
         plCheckOutObject       = ToCheckOut
         plUpdateTypes          = ToObjectType
         plUpdateObject         = ToObjectMaster
         plUpdateObjectInstance = ToObjectInstance.
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFolder sObject 
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

  hFrame = FRAME {&FRAME-NAME}:HANDLE.
  hWin   = hFrame:WINDOW.
  
  CREATE 'Shell.Application' lhServer.
  
  ASSIGN
      lhFolder = lhServer:BrowseForFolder(hWin:HWND,ipTitle,0).
  
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
                      opPath = "":U.
                  LEAVE.
              END.
          ELSE
              IF lhParent:Items:Item(lvCount):Name = lvFolder THEN
                  DO:
                      ASSIGN
                          opPath = lhParent:Items:Item(lvCount):Path.
                      LEAVE.
                  END.
          ASSIGN lvCount = lvCount + 1.
      END.
  END.
  ELSE
      ASSIGN
          opPath = "":U.
  
  RELEASE OBJECT lhParent NO-ERROR.
  RELEASE OBJECT lhFolder NO-ERROR.
  RELEASE OBJECT lhServer NO-ERROR.
  
  ASSIGN
    lhParent = ?
    lhFolder = ?
    lhServer = ?
    .
  
  ASSIGN opPath = TRIM(REPLACE(LC(opPath),"~\":U,"/":U),"/":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getOtherDetails sObject 
PROCEDURE getOtherDetails :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER pcLogFile         AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcADODir          AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER plOutputToScreen  AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER pdObjectTypeObj   AS DECIMAL    NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fiLogFile    
           fiADODir
           toScreen.
  END.
  
  ASSIGN pcLogFile        = fiLogFile
         pcADODir         = fiADODir
         plOutputToScreen = toScreen
         pdObjectTypeObj  = DYNAMIC-FUNCTION("getDataValue":U IN hObjectTypeObj).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject sObject 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  SUBSCRIBE TO "comboValueChanged":U IN THIS-PROCEDURE.

  RUN SUPER.
  
  RUN displayFields IN TARGET-PROCEDURE (?).
  RUN enableField IN hAttributeGroupObj.
  RUN enableField IN hAttributeLabel.
  RUN enableField IN hProductModuleObj.
  RUN enableField IN hObjectTypeObj.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN toGenerateADO:CHECKED    = TRUE
           toCheckOut:CHECKED       = TRUE
           toObjectType:CHECKED     = TRUE
           toObjectMaster:CHECKED   = TRUE
           toObjectInstance:CHECKED = TRUE.
    IF NOT CONNECTED("RTB":U) THEN
      ASSIGN toCheckOut:SENSITIVE = FALSE
             toCheckOut:CHECKED   = FALSE.
    ELSE /* CheckOut happens automatically */
      ASSIGN toCheckOut:SENSITIVE = FALSE
             toCheckOut:CHECKED   = TRUE.
    ASSIGN FILE-INFO:FILE-NAME    = "." /* Current Work Directory */
           fiLogFile:SCREEN-VALUE = IF FILE-INFO:FULL-PATHNAME <> ? THEN FILE-INFO:FULL-PATHNAME ELSE SESSION:TEMP-DIR
           fiLogFile:SCREEN-VALUE = REPLACE(fiLogFile:SCREEN-VALUE,"~\":U,"/":U) + "/rycavupdt.log":U
           fiADODir:SCREEN-VALUE  = IF FILE-INFO:FULL-PATHNAME <> ? THEN FILE-INFO:FULL-PATHNAME ELSE SESSION:TEMP-DIR
           fiADODir:SCREEN-VALUE  = REPLACE(fiADODir:SCREEN-VALUE,"~\":U,"/":U).
  END.
  RUN disableField IN hNewAttributeLabel.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE objectsSelectable sObject 
PROCEDURE objectsSelectable :
/*------------------------------------------------------------------------------
  Purpose:     This procedure decided whether the browser listing available objects
               should be enabled.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN toObjectMaster
           toObjectInstance.
    IF NOT toObjectMaster AND
       NOT toObjectInstance THEN DO:
      RUN refreshBrowse (INPUT 999999999999999999,
                         INPUT 999999999999999999,
                         INPUT "???").
      DISABLE buRefresh
              toAll
              WITH FRAME {&FRAME-NAME}.
    END.
    ELSE DO:
      ENABLE buRefresh
             toAll
             WITH FRAME {&FRAME-NAME}.
      APPLY "CHOOSE":U TO buRefresh IN FRAME {&FRAME-NAME}.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshBrowse sObject 
PROCEDURE refreshBrowse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdObjectType       AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pdProductModuleObj AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcObjectFileName   AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE hContainer  AS HANDLE   NO-UNDO.
  
  {get ContainerSource hContainer}.
  
  IF VALID-HANDLE(hContainer) AND 
     LOOKUP("refreshQuery":U,hContainer:INTERNAL-ENTRIES) > 0 THEN DO:
    RUN refreshQuery IN hContainer (INPUT pdObjectType,
                                    INPUT pdProductModuleObj,
                                    INPUT pcObjectFileName).
  
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateData sObject 
PROCEDURE validateData :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will validate the data entered on screen.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER plError  AS LOGICAL    NO-UNDO.
   
  DEFINE VARIABLE cError             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dDecimal           AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iInteger           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE dDate              AS DATE       NO-UNDO.
  DEFINE VARIABLE cString            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAttributeLabel    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewAttributeLabel AS CHARACTER  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
     
    ASSIGN EdAttributeValue 
           fiLogFile 
           fiADODir
           fiObjectFileName 
           raAction 
           ToAll 
           ToCheckOut 
           ToGenerateADO 
           ToObjectInstance 
           ToObjectMaster 
           ToObjectType 
           ToOverride 
           ToScreen.
    ASSIGN cAttributeLabel    = DYNAMIC-FUNCTION("getDataValue":U IN hAttributeLabel)    
           cNewAttributeLabel = DYNAMIC-FUNCTION("getDataValue":U IN hNewAttributeLabel).
    plError = FALSE.
    
    /* Attribute Label */
    IF NOT CAN-FIND(FIRST ryc_attribute
                    WHERE ryc_attribute.attribute_label = cAttributeLabel) THEN DO:
      IF cAttributeLabel = "":U THEN
        cError = {aferrortxt.i 'AF' '1' '' 'cAttributeLabel' "'Attribute Label'"}.
      ELSE
        cError = {aferrortxt.i 'AF' '5' '' 'cAttributeLabel' "'Attribute Label'"}.
      plError = TRUE.
      RUN viewError (INPUT cError).
      RETURN.
    END.
    
    /* New Attribute Label - Only valid if you need to rename an Attribute Label */
    IF raAction = "RENAME":U THEN DO:
      IF NOT CAN-FIND(FIRST ryc_attribute
                      WHERE ryc_attribute.attribute_label = cNewAttributeLabel) THEN DO:
        IF cNewAttributeLabel = "":U THEN 
          cError = {aferrortxt.i 'AF' '1' '' 'cNewAttributeLabel' "'New Attribute Label'"}.
        ELSE
          cError = {aferrortxt.i 'AF' '5' '' 'cNewAttributeLabel' "'New Attribute Label'"}.
      
        plError = TRUE.
        RUN viewError (INPUT cError).
        RETURN.
      END.
    END.
  
    /* Attribute Value - Only valid when you need to ASSIGN a value */
    IF raAction = "ASSIGN":U THEN DO:
      FIND FIRST ryc_attribute
           WHERE ryc_attribute.attribute_label = cAttributeLabel
           NO-LOCK NO-ERROR.
      
      CASE ryc_attribute.data_type:
        WHEN {&DECIMAL-DATA-TYPE}   THEN DO:
          ASSIGN dDecimal = DECIMAL(edAttributeValue) NO-ERROR.
          IF ERROR-STATUS:ERROR THEN
            cError = {aferrortxt.i 'AF' '5' '' 'edAttributeValue' "'Attribute Value'" "'The value specified must be of type DECIMAL.'"}.
          ELSE
            IF TRIM(edAttributeValue) = "":U THEN
              cError = {aferrortxt.i 'AF' '1' '' 'edAttributeValue' "'Attribute Value'" "'You must specify a valid DECIMAL value.'"}.
        END.
        WHEN {&INTEGER-DATA-TYPE}   THEN DO:
          ASSIGN iInteger = INTEGER(edAttributeValue) NO-ERROR.
          IF ERROR-STATUS:ERROR THEN
            cError = {aferrortxt.i 'AF' '5' '' 'edAttributeValue' "'Attribute Value'" "'The value specified must be of type INTEGER.'"}.
          ELSE
            IF TRIM(edAttributeValue) = "":U THEN
              cError = {aferrortxt.i 'AF' '1' '' 'edAttributeValue' "'Attribute Value'" "'You must specify a valid INTEGER value.'"}.
        END.
        WHEN {&DATE-DATA-TYPE}      THEN DO:
          cString = "The value specified must be of type DATE. " + "(":U + CAPS(SESSION:DATE-FORMAT) + ")":U.
          ASSIGN dDate = DATE(edAttributeValue) NO-ERROR.
          IF ERROR-STATUS:ERROR THEN
            cError = {aferrortxt.i 'AF' '5' '' 'edAttributeValue' "'Attribute Value'" "cString"}.
          ELSE
            IF TRIM(edAttributeValue) = "":U THEN
              cError = {aferrortxt.i 'AF' '1' '' 'edAttributeValue' "'Attribute Value'" "'You must specify a valid DATE value.'"}.
        END.
        WHEN {&LOGICAL-DATA-TYPE}   THEN DO:
          IF edAttributeValue <> "TRUE":U  AND
             edAttributeValue <> "FALSE":U AND
             edAttributeValue <> "YES":U   AND
             edAttributeValue <> "NO":U    THEN
          IF ERROR-STATUS:ERROR THEN
            cError = {aferrortxt.i 'AF' '5' '' 'edAttributeValue' "'Attribute Value'" "'The value specified must be of type LOGICAL (YES/NO/TRUE/FALSE).'"}.
          ELSE
            IF TRIM(edAttributeValue) = "":U THEN
              cError = {aferrortxt.i 'AF' '1' '' 'edAttributeValue' "'Attribute Value'" "'You must specify a valid LOGICAL value.'"}.
        END.
      END CASE.
      
      IF cError <> "":U THEN DO:
        plError = TRUE.
        RUN viewError (INPUT cError).
        APPLY "ENTRY":U TO edAttributeValue IN FRAME {&FRAME-NAME}.
        RETURN.
      END.
    END.
    
    /* Log File */
    IF fiLogFile = "":U THEN DO:
      cError = {aferrortxt.i 'AF' '1' '' 'fiLogFile' "'Output Log File'"}.
      plError = TRUE.
      RUN viewError (INPUT cError).
      APPLY "ENTRY":U TO fiLogFile IN FRAME {&FRAME-NAME}.
      RETURN.
    END.
    
    IF toGenerateADO AND
       fiADODir = "":U THEN DO:
      cError = {aferrortxt.i 'AF' '1' '' 'fiADODir' "'ADO Export Directory'"}.
      plError = TRUE.
      RUN viewError (INPUT cError).
      APPLY "ENTRY":U TO fiADODir IN FRAME {&FRAME-NAME}.
      RETURN.
    END.
    /* Change Level */
    IF ToObjectInstance = FALSE AND
       ToObjectMaster   = FALSE AND
       ToObjectType     = FALSE THEN DO:
      cError = {aferrortxt.i 'AF' '15' '' 'ToObjectType' "'you did not specify the Change Level.'" "'Please select one or all of the Change Levels.'"}.
      plError = TRUE.
      RUN viewError (INPUT cError).
      APPLY "ENTRY":U TO ToObjectType IN FRAME {&FRAME-NAME}.
      RETURN.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewError sObject 
PROCEDURE viewError :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will view an Error message with the standard viewing
               method.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcError AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cButton AS CHARACTER  NO-UNDO.
  
  RUN showMessages IN gshSessionManager (INPUT  pcError,         /* message to display */
                                         INPUT  "ERR":U,          /* error type */
                                         INPUT  "&OK,&Cancel":U,    /* button list */
                                         INPUT  "&OK":U,           /* default button */ 
                                         INPUT  "&Cancel":U,       /* cancel button */
                                         INPUT  "Error":U,             /* error window title */
                                         INPUT  YES,              /* display if empty */ 
                                         INPUT  ?,                /* container handle */ 
                                         OUTPUT cButton           /* button pressed */
                                        ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

