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
       {"af/obj2/gscemfullo.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/* Copyright (C) 2005,2007 by Progress Software Corporation. All rights
   reserved.  Prior versions of this work may contain portions
   contributed by participants of Possenet. */
/*---------------------------------------------------------------------------------
  File: gscemviewv.w

  Description:  Entity Mnemonic SmartDataViewer

  Purpose:      Entity Mnemonic Static SmartDataViewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000020   UserRef:    posse
                Date:   03/04/2001  Author:     Tammy St Pierre

  Update Notes: Created from Template rysttviewv.w
      Modified: 22/10/2001            Mark Davies
                Remove word Mnemonic.

  (v:010001)    Task:           0   UserRef:    
                Date:   10/24/2001  Author:  Mark Davies   

  Update Notes: Added check in UpdateMode to enable the browser when not in View mode.

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

&scop object-name       gscemviewv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{src/adm2/globals.i}
DEFINE VARIABLE glWarningShown    AS LOGICAL    NO-UNDO.


/* temp-table to maintain entity display fields */
{gscedtable.i}

/* PLIP definitions */
{launch.i &define-only = YES }

/** Contains definitions for all design-time temp-tables. **/
{destdefi.i}

DEFINE VARIABLE ghDesignManager             AS HANDLE                 NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "af/obj2/gscemfullo.i"

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.entity_mnemonic ~
RowObject.entity_narration RowObject.entity_mnemonic_short_desc ~
RowObject.entity_mnemonic_description RowObject.entity_dbname ~
RowObject.table_prefix_length RowObject.entity_mnemonic_label_prefix ~
RowObject.field_name_separator RowObject.table_has_object_field ~
RowObject.auto_properform_strings RowObject.entity_object_field ~
RowObject.auditing_enabled RowObject.entity_key_field RowObject.deploy_data ~
RowObject.version_data RowObject.reuse_deleted_keys ~
RowObject.entity_description_field RowObject.entity_description_procedure ~
RowObject.replicate_key RowObject.scm_field_name ~
RowObject.EntityObjectClass RowObject.AssociateDataFields 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-Define DISPLAYED-FIELDS RowObject.entity_mnemonic ~
RowObject.entity_narration RowObject.entity_mnemonic_short_desc ~
RowObject.entity_mnemonic_description RowObject.entity_dbname ~
RowObject.table_prefix_length RowObject.entity_mnemonic_label_prefix ~
RowObject.field_name_separator RowObject.table_has_object_field ~
RowObject.auto_properform_strings RowObject.entity_object_field ~
RowObject.auditing_enabled RowObject.entity_key_field RowObject.deploy_data ~
RowObject.version_data RowObject.reuse_deleted_keys ~
RowObject.entity_description_field RowObject.entity_description_procedure ~
RowObject.replicate_key RowObject.scm_field_name ~
RowObject.EntityObjectClass RowObject.AssociateDataFields 
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define DISPLAYED-OBJECTS fiEntityNarrationLabel fiKeyFieldLabel 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setWidgetState vTableWin 
FUNCTION setWidgetState RETURNS LOGICAL
    ( INPUT plEnable       AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_dyncombo AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dynlookup AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE fiEntityNarrationLabel AS CHARACTER FORMAT "X(35)":U INITIAL "Entity narration:" 
      VIEW-AS TEXT 
     SIZE 15.2 BY 1 NO-UNDO.

DEFINE VARIABLE fiKeyFieldLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Entity key field:" 
      VIEW-AS TEXT 
     SIZE 15.4 BY .62 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     RowObject.entity_mnemonic AT ROW 1 COL 27.4 COLON-ALIGNED
          LABEL "Entity"
          VIEW-AS FILL-IN 
          SIZE 24.8 BY 1 TOOLTIP "A unique code for the entity - should match entity dump name"
     RowObject.entity_narration AT ROW 1 COL 119.8 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 500 SCROLLBAR-VERTICAL
          SIZE 30.8 BY 3
     RowObject.entity_mnemonic_short_desc AT ROW 2.05 COL 27.4 COLON-ALIGNED
          LABEL "Description"
          VIEW-AS FILL-IN 
          SIZE 70 BY 1 TOOLTIP "A brief description of the entity to help explain its use"
     RowObject.entity_mnemonic_description AT ROW 3.1 COL 27.4 COLON-ALIGNED
          LABEL "Entity tablename"
          VIEW-AS FILL-IN 
          SIZE 70 BY 1 TOOLTIP "The actual table name of the entity as defined in the metaschema"
     RowObject.entity_dbname AT ROW 4.14 COL 27.4 COLON-ALIGNED
          LABEL "Entity db name"
          VIEW-AS FILL-IN 
          SIZE 70 BY 1 TOOLTIP "Teh database logical name that this table belongs to"
     RowObject.table_prefix_length AT ROW 4.14 COL 117.8 COLON-ALIGNED
          LABEL "Table prefix length"
          VIEW-AS FILL-IN 
          SIZE 6.2 BY 1 TOOLTIP "Length of the table prefix appended to all table names as per the standards"
     RowObject.entity_mnemonic_label_prefix AT ROW 5.19 COL 27.4 COLON-ALIGNED
          LABEL "Entity label prefix"
          VIEW-AS FILL-IN 
          SIZE 63.2 BY 1 TOOLTIP "Optional replacement for first word in labels for entity"
     RowObject.field_name_separator AT ROW 5.19 COL 117.8 COLON-ALIGNED
          LABEL "Field name separator"
          VIEW-AS FILL-IN 
          SIZE 24 BY 1 TOOLTIP "The basis of identifying what is used to break up field names into words"
     RowObject.table_has_object_field AT ROW 6.19 COL 29.4
          LABEL "Table has object field"
          VIEW-AS TOGGLE-BOX
          SIZE 26.6 BY 1 TOOLTIP "Set to NO if this table does not have a unique object id field"
     RowObject.auto_properform_strings AT ROW 6.24 COL 119.8
          LABEL "Auto properform strings"
          VIEW-AS TOGGLE-BOX
          SIZE 27.2 BY 1 TOOLTIP "Tidy up case of character fields automatically yes/no"
     RowObject.entity_object_field AT ROW 7.24 COL 27.4 COLON-ALIGNED
          LABEL "Entity object field"
          VIEW-AS FILL-IN 
          SIZE 70 BY 1 TOOLTIP "Optional name of object id field for the entity, if blank assumes ICF standard"
     RowObject.auditing_enabled AT ROW 7.33 COL 119.8
          LABEL "Auditing enabled"
          VIEW-AS TOGGLE-BOX
          SIZE 21 BY 1 TOOLTIP "Set to YES to enable auditing of records in this entity"
     RowObject.entity_key_field AT ROW 8.29 COL 29.4 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 500 SCROLLBAR-VERTICAL
          SIZE 70 BY 2.67
     RowObject.deploy_data AT ROW 8.33 COL 119.8
          LABEL "Deploy data"
          VIEW-AS TOGGLE-BOX
          SIZE 16.8 BY 1 TOOLTIP "Set to YES if data in this table needs to be deployed"
     RowObject.version_data AT ROW 9.38 COL 119.8
          LABEL "Version data"
          VIEW-AS TOGGLE-BOX
          SIZE 17.2 BY 1 TOOLTIP "Set to YES if data in this table needs to be versioned"
     RowObject.reuse_deleted_keys AT ROW 10.43 COL 119.8
          LABEL "Reuse deleted keys"
          VIEW-AS TOGGLE-BOX
          SIZE 24.4 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1
         SIZE 149.6 BY 18.48.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME frMain
     RowObject.entity_description_field AT ROW 11 COL 27.4 COLON-ALIGNED
          LABEL "Entity description field"
          VIEW-AS FILL-IN 
          SIZE 70 BY 1 TOOLTIP "Fieldname for field to use as description field for the entity"
     RowObject.entity_description_procedure AT ROW 12.05 COL 27.4 COLON-ALIGNED
          LABEL "Entity description procedure"
          VIEW-AS FILL-IN 
          SIZE 70 BY 1 TOOLTIP "Optional procedure to use to derive the description field"
     RowObject.replicate_key AT ROW 14.14 COL 27.4 COLON-ALIGNED
          LABEL "Replicate key"
          VIEW-AS FILL-IN 
          SIZE 70 BY 1 TOOLTIP "The join field to the primary replication table being versioned"
     RowObject.scm_field_name AT ROW 15.19 COL 27.4 COLON-ALIGNED
          LABEL "SCM field name"
          VIEW-AS FILL-IN 
          SIZE 70 BY 1 TOOLTIP "The unique field for the data that is also used as the object name for SCM"
     RowObject.EntityObjectClass AT ROW 17.33 COL 27.4 COLON-ALIGNED
          LABEL "Class"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEMS "Item 1" 
          DROP-DOWN-LIST
          SIZE 50 BY 1
     RowObject.AssociateDataFields AT ROW 18.43 COL 29.4
          LABEL "Associate data fields"
          VIEW-AS TOGGLE-BOX
          SIZE 40.4 BY .81
     fiEntityNarrationLabel AT ROW 1 COL 102.2 COLON-ALIGNED NO-LABEL
     fiKeyFieldLabel AT ROW 8.52 COL 28.2 RIGHT-ALIGNED NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1
         SIZE 149.6 BY 18.48.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "af/obj2/gscemfullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {af/obj2/gscemfullo.i}
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
         HEIGHT             = 18.48
         WIDTH              = 149.6.
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
   NOT-VISIBLE FRAME-NAME                                               */
ASSIGN 
       FRAME frMain:HIDDEN           = TRUE.

/* SETTINGS FOR TOGGLE-BOX RowObject.AssociateDataFields IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.auditing_enabled IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.auto_properform_strings IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.deploy_data IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR COMBO-BOX RowObject.EntityObjectClass IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.entity_dbname IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.entity_description_field IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.entity_description_procedure IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR EDITOR RowObject.entity_key_field IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.entity_mnemonic IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.entity_mnemonic_description IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.entity_mnemonic_label_prefix IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.entity_mnemonic_short_desc IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR EDITOR RowObject.entity_narration IN FRAME frMain
   EXP-LABEL                                                            */
ASSIGN 
       RowObject.entity_narration:RETURN-INSERTED IN FRAME frMain  = TRUE.

/* SETTINGS FOR FILL-IN RowObject.entity_object_field IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.field_name_separator IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN fiEntityNarrationLabel IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       fiEntityNarrationLabel:PRIVATE-DATA IN FRAME frMain     = 
                "Entity narration:".

/* SETTINGS FOR FILL-IN fiKeyFieldLabel IN FRAME frMain
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN RowObject.replicate_key IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.reuse_deleted_keys IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.scm_field_name IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.table_has_object_field IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.table_prefix_length IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.version_data IN FRAME frMain
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK vTableWin 


/* ***************************  Main Block  *************************** */
ON VALUE-CHANGED OF 
  RowObject.entity_key_field,
  RowObject.entity_object_field,
  RowObject.reuse_deleted_keys,
  RowObject.table_has_object_field,
  RowObject.version_data
DO:
  IF NOT glWarningShown THEN
    RUN showChangeWarning.
  {set DataModified YES}.
END.

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addRecord vTableWin 
PROCEDURE addRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN SUPER.

    DYNAMIC-FUNCTION("setWidgetState":U IN TARGET-PROCEDURE, INPUT YES).

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* addRecord */

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
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_entity_mnemonic.entity_mnemonicKeyFieldgsc_entity_mnemonic.entity_mnemonicFieldLabelReplicate entityFieldTooltipThe entity code of the primary replication table for data versioning, e.g. RYCSOKeyFormatX(8)KeyDatatypecharacterDisplayFormatX(8)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_entity_mnemonic NO-LOCK
                     BY gsc_entity_mnemonic.entity_mnemonicQueryTablesgsc_entity_mnemonicBrowseFieldsgsc_entity_mnemonic.entity_mnemonic,gsc_entity_mnemonic.entity_mnemonic_short_desc,gsc_entity_mnemonic.entity_mnemonic_descriptionBrowseFieldDataTypescharacter,character,characterBrowseFieldFormatsX(8)|X(35)|X(35)RowsToBatch200BrowseTitleLookup Entity MnemonicsViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListNO-LOCKQueryBuilderOrderListgsc_entity_mnemonic.entity_mnemonic^yesQueryBuilderTableOptionListNO-LOCKQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesSuperProcedureDataSourceNameFieldNamereplicate_entity_mnemonicDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dynlookup ).
       RUN repositionObject IN h_dynlookup ( 13.10 , 29.40 ) NO-ERROR.
       RUN resizeObject IN h_dynlookup ( 1.00 , 50.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dyncombo.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_product_module.product_module_code,gsc_product_module.product_module_descriptionKeyFieldgsc_product_module.product_module_codeFieldLabelProduct moduleFieldTooltipSelect the preferred Product Module for Entity ObjectsKeyFormatX(35)KeyDatatypecharacterDisplayFormatX(35)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_product_module
                     WHERE [&FilterSet=|&EntityList=GSCPM] NO-LOCK BY gsc_product_module.product_module_code INDEXED-REPOSITIONQueryTablesgsc_product_moduleSDFFileNamedcSDOProdModSDFTemplateParentFieldParentFilterQueryDescSubstitute&1 / &2ComboDelimiterListItemPairsInnerLines5SortnoComboFlagFlagValueBuildSequence1SecurednoCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesUseCacheyesSuperProcedureDataSourceNameFieldNameEntityObjectProductModuleDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dyncombo ).
       RUN repositionObject IN h_dyncombo ( 16.24 , 29.40 ) NO-ERROR.
       RUN resizeObject IN h_dyncombo ( 1.00 , 50.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_dynlookup ,
             RowObject.entity_description_procedure:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_dyncombo ,
             RowObject.scm_field_name:HANDLE IN FRAME frMain , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

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
    RUN SUPER.

    DYNAMIC-FUNCTION("setWidgetState":U IN TARGET-PROCEDURE, INPUT YES).

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* copyRecord */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataAvailable vTableWin 
PROCEDURE dataAvailable :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       Publishes populateRelatedData to populate the datafield 
               maintenance SDO with temp table records for the current
               entity's instances.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcRelative AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hContainerSource  AS HANDLE     NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcRelative).

  /* Code placed here will execute AFTER standard behavior.    */
  hContainerSource = DYNAMIC-FUNCTION('getContainerSource':U IN TARGET-PROCEDURE).
  PUBLISH 'populateRelatedData':U FROM hContainerSource.

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

    RUN SUPER( INPUT pcFieldType).

    /* Always disable the Entity stuff here. */
    DYNAMIC-FUNCTION("setWidgetState":U IN TARGET-PROCEDURE, INPUT NO).

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* disableFields */

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
    DEFINE INPUT PARAMETER pcColValues          AS CHARACTER            NO-UNDO.

    DEFINE VARIABLE hEntityClassCombo       AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hDummyTable             AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE cAllFieldNames          AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cAllFieldHandles        AS CHARACTER                NO-UNDO.


    RUN SUPER( INPUT pcColValues).

    glWarningShown = NO.
    
    /** Fetch the Entity object from the Repository.    
     *  ----------------------------------------------------------------------- **/
    IF VALID-HANDLE(ghDesignManager) THEN
            RUN retrieveDesignObject IN ghDesignManager ( INPUT  rowObject.entity_mnemonic_description:INPUT-VALUE IN FRAME {&FRAME-NAME},
                                                          INPUT  "":U,  /* defaults to DEFAULT-RESULT-CODE */
                                                          OUTPUT TABLE ttObject,
                                                          OUTPUT TABLE-HANDLE hDummyTable,
                                                          OUTPUT TABLE-HANDLE hDummyTable,
                                                          OUTPUT TABLE-HANDLE hDummyTable,
                                                          OUTPUT TABLE-HANDLE hDummyTable )  NO-ERROR.
    
    FIND FIRST ttObject WHERE
               ttObject.tLogicalObjectName = rowObject.entity_mnemonic_description:INPUT-VALUE IN FRAME {&FRAME-NAME}
               NO-ERROR.
    
    /* We need to know whether the entity has been created in the Repository or not. */
    DYNAMIC-FUNCTION("setUserProperty":U IN TARGET-PROCEDURE,
                     INPUT "EntityHasObject":U,
                     INPUT STRING(AVAILABLE ttObject) ).

    IF AVAILABLE ttObject THEN
    DO WITH FRAME {&FRAME-NAME}:
        DYNAMIC-FUNCTION("setWidgetState":U IN TARGET-PROCEDURE, INPUT NO).

        ASSIGN rowObject.EntityObjectClass:SCREEN-VALUE = ttObject.tClassName NO-ERROR.
        
        {get AllFieldNames   cAllFieldNames}.
        {get AllFieldHandles cAllFieldHandles}.

        ASSIGN hEntityClassCombo = WIDGET-HANDLE(ENTRY(LOOKUP("EntityObjectProductModule":U, cAllFieldNames), cAllFieldHandles)) NO-ERROR.
        
        IF VALID-HANDLE(hEntityClassCombo) THEN
            DYNAMIC-FUNCTION("setDataValue":U IN hEntityClassCombo,
                             INPUT ttObject.tProductModuleCode      ).
    END.    /* not yet created. */
    ELSE
        DYNAMIC-FUNCTION("setWidgetState":U IN TARGET-PROCEDURE, INPUT YES).    

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* displayFields */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFields vTableWin 
PROCEDURE enableFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cMode               AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cNewRecord          AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE hContainerSource    AS HANDLE       NO-UNDO.

    RUN SUPER.

    {get NewRecord cNewRecord}.

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN RowObject.entity_mnemonic:SENSITIVE = CAN-DO("Add,Copy":U, cNewREcord).

        hContainerSource = DYNAMIC-FUNCTION('getContainerSource':U).

        {get ContainerSource hContainerSource}.
        {get ContainerMode cMode hContainerSource}.

        IF cMode = "Modify":U THEN
        DO:
            IF DYNAMIC-FUNCTION('getDataValue':U IN h_dynlookup) = '':U THEN
                ASSIGN RowObject.replicate_key:SENSITIVE = NO
                       RowObject.scm_field_name:SENSITIVE = NO.
            IF DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, INPUT "EntityHasObject":U ) EQ "YES":U THEN
                DYNAMIC-FUNCTION("setWidgetState":U IN TARGET-PROCEDURE, INPUT NO).
            ELSE
                DYNAMIC-FUNCTION("setWidgetState":U IN TARGET-PROCEDURE, INPUT YES).
        END.  /* if mode is modify */

        IF cMode EQ "View":U THEN
            DYNAMIC-FUNCTION("setWidgetState":U IN TARGET-PROCEDURE, INPUT NO).
    END.  /* do with frame */

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* enableFields */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject vTableWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  <none>
  Notes:       Sets subscriptions to some standard published events.
               Initialises some UI objects.
------------------------------------------------------------------------------*/
    /* Ignore if running in the AppBuilder */
    &IF DEFINED(UIB_IS_RUNNING) = 0 &THEN
    SUBSCRIBE TO 'lookupDisplayComplete':U IN THIS-PROCEDURE.
    &ENDIF  
    
    ASSIGN ghDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U IN TARGET-PROCEDURE,
                                              INPUT "RepositoryDesignManager":U).
    
    RUN SUPER.

    DYNAMIC-FUNCTION("setWidgetState":U IN TARGET-PROCEDURE, INPUT NO).

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN rowObject.EntityObjectClass:LIST-ITEMS   = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "Entity":U)
               rowObject.EntityObjectClass:SCREEN-VALUE = rowObject.EntityObjectClass:ENTRY(1).     
    END.    /* with frame ... */

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* initializeObject */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE lookupDisplayComplete vTableWin 
PROCEDURE lookupDisplayComplete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcFieldNames     AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcFieldValues    AS CHARACTER  NO-UNDO.  
DEFINE INPUT PARAMETER pcKeyFieldValue  AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER phLookup         AS HANDLE     NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    IF pcKeyFieldValue = '':U THEN
      ASSIGN 
        RowObject.replicate_key:SENSITIVE = NO
        RowObject.scm_field_name:SENSITIVE = NO.
    ELSE 
      ASSIGN
          RowObject.replicate_key:SENSITIVE = YES
          RowObject.scm_field_name:SENSITIVE = YES.
  END.  /* do with frame */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showChangeWarning vTableWin 
PROCEDURE showChangeWarning :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainerSource  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataSource       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cMode             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lRVDataExists     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cButton           AS CHARACTER  NO-UNDO.
  {get ContainerSource hContainerSource}.
  {get ContainerMode cMode hContainerSource}.

  IF cMode = "Modify":U THEN
  DO:
    {get DataSource hDataSource}.
    lRVDataExists = LOGICAL(DYNAMIC-FUNCTION("columnValue":U IN hDataSource,
                                              "RVDataExists":U)).
    IF lRVDataExists AND
       NOT glWarningShown THEN
    DO:
      RUN showMessages IN gshSessionManager (INPUT  {aferrortxt.i 'ICF' '7' '?' '?' '' ''},
                                         INPUT  "WAR":U,
                                         INPUT  "OK":U,
                                         INPUT  "OK":U,
                                         INPUT  "OK":U,
                                         INPUT  "Reset Data Version Data",
                                         INPUT  YES,
                                         INPUT  TARGET-PROCEDURE,
                                         OUTPUT cButton               ).
      glWarningShown = YES.
    END.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateVersionData vTableWin 
PROCEDURE updateVersionData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cButton AS CHARACTER  NO-UNDO.

  IF cButton <> "OK":U THEN
    RETURN.

  


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setWidgetState vTableWin 
FUNCTION setWidgetState RETURNS LOGICAL
    ( INPUT plEnable       AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the state of the widgets used to control the Entity Object.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hEntityClassCombo           AS HANDLE               NO-UNDO.
    DEFINE VARIABLE cAllFieldNames              AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cAllFieldHandles            AS CHARACTER            NO-UNDO.

    /* Enable the Class and Product Modules */
    ASSIGN rowObject.EntityObjectClass:SENSITIVE IN FRAME {&FRAME-NAME}                 = plEnable
           rowObject.AssociateDataFields:SENSITIVE IN FRAME {&FRAME-NAME} = plEnable.
    
    {get AllFieldNames   cAllFieldNames}.
    {get AllFieldHandles cAllFieldHandles}.

    ASSIGN hEntityClassCombo = WIDGET-HANDLE(ENTRY(LOOKUP("EntityObjectProductModule":U, cAllFieldNames), cAllFieldHandles)) NO-ERROR.

    IF VALID-HANDLE(hEntityClassCombo) THEN
    DO:
        IF plEnable THEN
            RUN enableField IN hEntityClassCombo.
        ELSE
            RUN disableField IN hEntityClassCombo.
    END.    /* valid entity combo */

    RETURN TRUE.
END FUNCTION.   /* setWidgetState */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

