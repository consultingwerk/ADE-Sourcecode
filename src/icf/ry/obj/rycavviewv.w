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
       {"ry/obj/rycavfullo.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: rycavviewv.w

  Description:  Attribute Value Maintenance

  Purpose:      Attribute Value Maintenance

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        7754   UserRef:    
                Date:   31/01/2001  Author:     Anthony Swindells

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

&scop object-name       rycavviewv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{af/sup2/afglobals.i}

DEFINE VARIABLE gcUIBMode               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSaveLabel             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glInitialize            AS LOGICAL    NO-UNDO.

DEFINE VARIABLE gdObjectTypeObj         AS DECIMAL    INITIAL 0 NO-UNDO.
DEFINE VARIABLE gdContainerObj          AS DECIMAL    INITIAL 0 NO-UNDO.
DEFINE VARIABLE gdInstanceObj           AS DECIMAL    INITIAL 0 NO-UNDO.
DEFINE VARIABLE gcInstanceQueryString   AS CHARACTER  NO-UNDO.

ASSIGN
  glInitialize = NO.

/* Astra 2 Lookup temp-table */
{src/adm2/ttlookup.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "ry/obj/rycavfullo.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.inheritted_value ~
RowObject.constant_value RowObject.attribute_type_tla ~
RowObject.attribute_value 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define ENABLED-OBJECTS fiValue 
&Scoped-Define DISPLAYED-FIELDS RowObject.inheritted_value ~
RowObject.constant_value RowObject.attribute_type_tla ~
RowObject.attribute_value 
&Scoped-Define DISPLAYED-OBJECTS fiLayoutPosition fiValue 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBaseQueryString vTableWin 
FUNCTION setBaseQueryString RETURNS LOGICAL
  (pcFieldName AS CHARACTER,
   phLookup    AS HANDLE) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_container AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gscotcmsfv AS HANDLE NO-UNDO.
DEFINE VARIABLE h_instance AS HANDLE NO-UNDO.
DEFINE VARIABLE h_rycagdcsfv AS HANDLE NO-UNDO.
DEFINE VARIABLE h_rycatccsfv AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE fiLayoutPosition AS CHARACTER FORMAT "X(256)":U 
     LABEL "Layout Position" 
     VIEW-AS FILL-IN 
     SIZE 45.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiValue AS CHARACTER FORMAT "X(256)":U INITIAL "Attribute Value:" 
      VIEW-AS TEXT 
     SIZE 15.2 BY .62 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     fiLayoutPosition AT ROW 4.43 COL 27.4 COLON-ALIGNED
     RowObject.inheritted_value AT ROW 5.57 COL 29.4
          VIEW-AS TOGGLE-BOX
          SIZE 19.8 BY .81
     RowObject.constant_value AT ROW 6.52 COL 29.4
          VIEW-AS TOGGLE-BOX
          SIZE 19.4 BY .81
     RowObject.attribute_type_tla AT ROW 9.76 COL 27.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.6 BY 1
     RowObject.attribute_value AT ROW 10.95 COL 29.4 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 500 SCROLLBAR-VERTICAL
          SIZE 45.2 BY 2.38
     fiValue AT ROW 11.1 COL 13.8 NO-LABEL
     SPACE(46.40) SKIP(0.00)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "ry/obj/rycavfullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {ry/obj/rycavfullo.i}
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
         HEIGHT             = 12.91
         WIDTH              = 77.2.
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

/* SETTINGS FOR FILL-IN fiLayoutPosition IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiValue IN FRAME frMain
   ALIGN-L                                                              */
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
  DEFINE VARIABLE currentPage  AS INTEGER NO-UNDO.

  ASSIGN currentPage = getCurrentPage().

  CASE currentPage: 

    WHEN 0 THEN DO:
       RUN constructObject (
             INPUT  'ry/obj/gscotcmsfv.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'FieldNameobject_type_objDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_gscotcmsfv ).
       RUN repositionObject IN h_gscotcmsfv ( 1.00 , 16.60 ) NO-ERROR.
       RUN resizeObject IN h_gscotcmsfv ( 1.19 , 58.80 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.smartobject_objFieldLabelContainer ObjectFieldTooltipSpecify container object or leave blank for none (F4 to search)KeyFormat>>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object NO-LOCK
                     WHERE gsc_object.container_object = YES,
                     FIRST ryc_smartobject NO-LOCK
                     WHERE ryc_smartobject.OBJECT_obj = gsc_object.OBJECT_obj
                     AND ryc_smartobject.OBJECT_type_obj = gsc_object.OBJECT_type_obj,
                     FIRST gsc_object_type NO-LOCK
                     WHERE gsc_object_type.OBJECT_type_obj = ryc_smartobject.OBJECT_type_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj
                     BY ryc_smartobject.OBJECT_filenameQueryTablesgsc_object,ryc_smartobject,gsc_object_type,gsc_product_moduleBrowseFieldsgsc_product_module.product_module_code,ryc_smartobject.object_filename,gsc_object.object_description,gsc_object_type.object_type_code,ryc_smartobject.static_objectBrowseFieldDataTypescharacter,character,character,character,logicalBrowseFieldFormatsX(10),X(70),X(35),X(15),YES/NORowsToBatch200BrowseTitleLookup Container ObjectViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOFieldNamecontainer_smartobject_objDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_container ).
       RUN repositionObject IN h_container ( 2.14 , 29.40 ) NO-ERROR.
       RUN resizeObject IN h_container ( 1.00 , 45.40 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.smartobject_objFieldLabelContained Object NameFieldTooltipSpecify contained object name or leave blank for noneKeyFormat>>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH ryc_object_instance NO-LOCK
                     WHERE ryc_object_instance.container_smartobject_obj = "ContainerSmartobjectObj",
                     EACH ryc_smartobject NO-LOCK
                     WHERE ryc_smartobject.smartobject_obj = ryc_object_instance.smartobject_obj
                     AND ryc_smartobject.object_type_obj = "ObjectTypeObj"
                     BY ryc_smartobject.OBJECT_filenameQueryTablesryc_object_instance,ryc_smartobjectBrowseFieldsryc_smartobject.object_filename,ryc_object_instance.layout_positionBrowseFieldDataTypescharacter,characterBrowseFieldFormatsX(70),X(15)RowsToBatch200BrowseTitleLookup Contained ObjectViewerLinkedFieldsryc_object_instance.layout_positionLinkedFieldDataTypescharacterLinkedFieldFormatsX(15)ViewerLinkedWidgetsfiLayoutPositionColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOFieldNamesmartobject_objDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_instance ).
       RUN repositionObject IN h_instance ( 3.29 , 29.40 ) NO-ERROR.
       RUN resizeObject IN h_instance ( 1.00 , 45.40 ) NO-ERROR.

       RUN constructObject (
             INPUT  'ry/obj/rycagdcsfv.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'FieldNameattribute_group_objDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_rycagdcsfv ).
       RUN repositionObject IN h_rycagdcsfv ( 7.48 , 9.00 ) NO-ERROR.
       RUN resizeObject IN h_rycagdcsfv ( 1.10 , 66.40 ) NO-ERROR.

       RUN constructObject (
             INPUT  'ry/obj/rycatccsfv.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'FieldNameattribute_labelDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_rycatccsfv ).
       RUN repositionObject IN h_rycatccsfv ( 8.62 , 9.40 ) NO-ERROR.
       RUN resizeObject IN h_rycatccsfv ( 1.10 , 66.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_gscotcmsfv ,
             fiLayoutPosition:HANDLE IN FRAME frMain , 'BEFORE':U ).
       RUN adjustTabOrder ( h_container ,
             h_gscotcmsfv , 'AFTER':U ).
       RUN adjustTabOrder ( h_instance ,
             h_container , 'AFTER':U ).
       RUN adjustTabOrder ( h_rycagdcsfv ,
             RowObject.constant_value:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_rycatccsfv ,
             h_rycagdcsfv , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE constructObject vTableWin 
PROCEDURE constructObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pcProcName AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER phParent   AS HANDLE NO-UNDO.
  DEFINE INPUT  PARAMETER pcPropList AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER phObject   AS HANDLE NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcProcName, INPUT phParent, INPUT pcPropList, OUTPUT phObject).

  /* Code placed here will execute AFTER standard behavior.    */

  DEFINE VARIABLE cFieldName         AS CHARACTER NO-UNDO.

  IF VALID-HANDLE(gshGenManager) AND
     LOOKUP("getPropertyFromList":U, gshGenManager:INTERNAL-ENTRIES) <> 0 THEN
    ASSIGN cFieldName = DYNAMIC-FUNCTION("getPropertyFromList":U IN gshGenManager, INPUT pcPropList, INPUT "FieldName":U).

  CASE cFieldname:

    /* Instance lookup */
    WHEN "smartobject_obj":U THEN
    DO:
      gcInstanceQueryString = {fn getBaseQueryString phObject}.
      DYNAMIC-FUNCTION("setBaseQueryString":U, cFieldName, phObject).
    END.

  END CASE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFields vTableWin 
PROCEDURE enableFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  /* Ensure fields stay disabled if not meant to ne enabled */
  DO WITH FRAME {&FRAME-NAME}:
    DISABLE RowObject.attribute_type_tla.

    IF gdObjectTypeObj = 0 THEN
    DO:
      RUN disableField IN h_container.
      RUN disableField IN h_instance.
    END.
    ELSE IF gdContainerObj = 0 THEN
      RUN disableField IN h_instance.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE filterContainedObject vTableWin 
PROCEDURE filterContainedObject :
/*------------------------------------------------------------------------------
  Purpose:     Run whenever object type combo is changed.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pdObjectTypeObj              AS DECIMAL    NO-UNDO.

DEFINE VARIABLE dSaveObjectTypeObj                  AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cNewRecord                          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hContainerSource                    AS HANDLE     NO-UNDO.
DEFINE VARIABLE cContainerMode                      AS CHARACTER  NO-UNDO.

ASSIGN
  dSaveObjectTypeObj = gdObjectTypeObj
  gdObjectTypeObj = pdObjectTypeObj
  .

/* See if really changed first */
IF gdObjectTypeObj <> 0 AND dSaveObjectTypeObj = gdObjectTypeObj THEN RETURN.

/* changed */
IF gdObjectTypeObj = 0 AND NOT glInitialize THEN
DO WITH FRAME {&FRAME-NAME}:
  RUN disableField IN h_container.
  RUN disableField IN h_instance.
  ASSIGN
    gdInstanceObj = 0
    gdContainerObj = 0
    .
  {set DataValue 0 h_container}.
  {set DataValue 0 h_instance}.
  fiLayoutPosition:SCREEN-VALUE = "":U.    
END.
ELSE IF gdObjectTypeObj <> 0 THEN
DO WITH FRAME {&FRAME-NAME}:
  RUN enableField IN h_container.

  IF NOT glInitialize THEN
  DO:
    RUN disableField IN h_instance.

    ASSIGN
      gdInstanceObj = 0
      gdContainerObj = 0
      .
    {set DataValue 0 h_container}.
    {set DataValue 0 h_instance}.
    fiLayoutPosition:SCREEN-VALUE = "":U.    
  END.

  DYNAMIC-FUNCTION("setBaseQueryString":U, INPUT "smartobject_obj":U, INPUT h_instance).

END.

/* Ensure correct value displayed in modify and view modes */
IF glInitialize AND gdObjectTypeObj <> 0 THEN
DO:
  /* refresh other combo details */
  {get ContainerSource hContainerSource}.
  IF VALID-HANDLE(hContainerSource) THEN
    {get ContainerMode cContainerMode hContainerSource}.

  IF cContainerMode <> "add":U  THEN
  DO:
    {get datavalue gdContainerObj h_container}.
    DYNAMIC-FUNCTION("setBaseQueryString":U, INPUT "smartobject_obj":U, INPUT h_instance).

    EMPTY TEMP-TABLE ttLookup.
    RUN "getLookupQuery":U IN h_instance (INPUT-OUTPUT TABLE ttLookup).
    IF CAN-FIND(FIRST ttLookup) THEN
      RUN adm2/lookupqp.p ON gshAstraAppserver (INPUT-OUTPUT TABLE ttLookup).
    RUN "displayLookup":U IN h_instance (INPUT TABLE ttLookup).

    IF gdContainerObj = 0 THEN
    DO WITH FRAME {&FRAME-NAME}:
      RUN disableField IN h_instance.
      ASSIGN
        gdInstanceObj = 0
        .
      {set DataValue 0 h_instance}.
      fiLayoutPosition:SCREEN-VALUE = "":U.    
    END.
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

  /* Code placed here will execute PRIOR to standard behavior. */
  {get UIBMode gcUIBMode}.    

  ASSIGN
    glInitialize = YES.

  /* subscribe to containing viewer to events that will populate the combo */
  IF NOT (gcUIBMode BEGINS "DESIGN":U) THEN DO:
    SUBSCRIBE TO "filterContainedObject":U IN THIS-PROCEDURE.
    SUBSCRIBE TO "populateAttributeType":U IN THIS-PROCEDURE.
    SUBSCRIBE TO "lookupComplete":U IN THIS-PROCEDURE.
  END.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  DO WITH FRAME {&FRAME-NAME}:
    DISABLE RowObject.attribute_type_tla.
  END.

  ASSIGN
    glInitialize = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE lookupComplete vTableWin 
PROCEDURE lookupComplete :
/*------------------------------------------------------------------------------
  Purpose:     Lookup complete hook - whenever combos changed
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

DEFINE VARIABLE dPrevContainerObj               AS DECIMAL      NO-UNDO.

/* Container combo changed */
IF phObject = h_container THEN
DO:
  ASSIGN
    dPrevContainerObj = gdContainerObj NO-ERROR.
  ASSIGN  
    gdContainerObj = DECIMAL(pcKeyFieldValue) NO-ERROR.
  IF gdContainerObj = 0 OR gdContainerObj = ? OR ERROR-STATUS:ERROR = TRUE THEN
  DO WITH FRAME {&FRAME-NAME}:
    ERROR-STATUS:ERROR = FALSE.
    RUN disableField IN h_instance.
    ASSIGN
      gdInstanceObj = 0
      .
    {set DataValue 0 h_instance}.    
    fiLayoutPosition:SCREEN-VALUE = "":U.    
  END.
  ELSE
  DO:
    RUN enableField IN h_instance.
    IF dPrevContainerObj <> DECIMAL(pcKeyFieldValue) THEN
    DO WITH FRAME {&FRAME-NAME}:
      ASSIGN gdInstanceObj = 0.
      {set DataValue 0 h_instance}.
      fiLayoutPosition:SCREEN-VALUE = "":U.    
    END.
  END.

  IF phObject = h_instance  THEN
    ASSIGN gdInstanceObj = DECIMAL(pcKeyFieldValue) NO-ERROR.

END.

/* instance combo changed */
IF phObject = h_instance THEN
DO:
  ASSIGN  
    gdInstanceObj = DECIMAL(pcKeyFieldValue) NO-ERROR.
END.

ERROR-STATUS:ERROR = NO.
RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateAttributeType vTableWin 
PROCEDURE populateAttributeType :
/*------------------------------------------------------------------------------
  Purpose:     To populate attribute label field from attribute type
  Parameters:  input attribute label
  Notes:       Published from viewer when attribute changes
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pcLabel                  AS CHARACTER  NO-UNDO.

DEFINE VARIABLE dGroupObj                       AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cTypeTla                        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNarrative                      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lSystemOwned                    AS LOGICAL    NO-UNDO.

/* If value not changed, do nothing */
IF gcSaveLabel <> "":U AND gcSaveLabel = pcLabel THEN RETURN.

ASSIGN gcSaveLabel = pcLabel.

IF pcLabel = "":U THEN
DO WITH FRAME {&FRAME-NAME}:
  RowObject.attribute_type_tla:SCREEN-VALUE = "":U.
  RowObject.attribute_type_tla:MODIFIED = TRUE.
END.
ELSE
DO WITH FRAME {&FRAME-NAME}:
  RUN ry/app/rycatgetdp.p ON gshAstraAppserver (INPUT pcLabel,
                                                OUTPUT dGroupObj,
                                                OUTPUT cTypeTla,
                                                OUTPUT cNarrative,
                                                OUTPUT lSystemOwned).

  RowObject.attribute_type_tla:SCREEN-VALUE = cTypeTla.
  RowObject.attribute_type_tla:MODIFIED = TRUE.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RTB_xref_generator vTableWin 
PROCEDURE RTB_xref_generator :
/* -----------------------------------------------------------
Purpose:    Generate RTB xrefs for SMARTOBJECTS.
Parameters: <none>
Notes:      This code is generated by the UIB.  DO NOT modify it.
            It is included for Roundtable Xref generation. Without
            it, Xrefs for SMARTOBJECTS could not be maintained by
            RTB.  It will in no way affect the operation of this
            program as it never gets executed.
-------------------------------------------------------------*/
  RUN "ry\obj\rycagdcsfv.w *RTB-SmObj* ".
  RUN "adm2\dynlookup.w *RTB-SmObj* ".
  RUN "ry\obj\gscotcmsfv.w *RTB-SmObj* ".
  RUN "ry\obj\rycatccsfv.w *RTB-SmObj* ".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBaseQueryString vTableWin 
FUNCTION setBaseQueryString RETURNS LOGICAL
  (pcFieldName AS CHARACTER,
   phLookup    AS HANDLE):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cBaseQueryString  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iIndex            AS INTEGER    NO-UNDO.

  CASE pcFieldName:
    WHEN "smartobject_obj":U THEN cBaseQueryString = gcInstanceQueryString.
  END CASE.

  IF VALID-HANDLE(phLookup) THEN
  DO:
    IF pcFieldName = "smartobject_obj":U THEN
    DO:
      ASSIGN
          iIndex = INDEX(cBaseQueryString, "ContainerSmartobjectObj":U).

      IF iIndex <> 0 AND
         iIndex <> ? THEN
        ASSIGN
            cBaseQueryString = REPLACE(cBaseQueryString, '"ContainerSmartobjectObj"':U, STRING(gdContainerObj)).

      ASSIGN
          iIndex = INDEX(cBaseQueryString, "ObjectTypeObj":U).

      IF iIndex <> 0 AND
         iIndex <> ? THEN
        ASSIGN
            cBaseQueryString = REPLACE(cBaseQueryString, '"ObjectTypeObj"':U, STRING(gdObjectTypeObj)).
    END.

    /* Set the query string in the lookup */
    {fnarg setBaseQueryString cBaseQueryString phLookup}.

    RETURN TRUE.    /* Function return value. */
  END.
  ELSE
    RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

