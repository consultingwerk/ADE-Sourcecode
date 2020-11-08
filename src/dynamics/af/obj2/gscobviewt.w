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
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: gscobviewt.w

  Description:  Toolbar Object viewer

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   09/25/2001  Author:     Donald Bulua

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

&scop object-name       gscobviewt.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{af/sup2/afglobals.i}

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

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.object_filename ~
RowObject.object_description RowObject.container_object ~
RowObject.static_object RowObject.generic_object ~
RowObject.runnable_from_menu 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-Define ENABLED-OBJECTS RECT-7 
&Scoped-Define DISPLAYED-FIELDS RowObject.object_filename ~
RowObject.object_description RowObject.container_object ~
RowObject.static_object RowObject.generic_object ~
RowObject.runnable_from_menu RowObject.smartobject_obj ~
RowObject.object_type_obj 
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define DISPLAYED-OBJECTS fiModuleDesc fiToolbarObjectLabel 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_dynlookup AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dynlookup-3 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE fiModuleDesc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 78.4 BY 1 NO-UNDO.

DEFINE VARIABLE fiToolbarObjectLabel AS CHARACTER FORMAT "X(35)":U INITIAL "Toolbar Object" 
      VIEW-AS TEXT 
     SIZE 14.4 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 103.2 BY 6.14.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     RowObject.object_filename AT ROW 1.91 COL 23.2 COLON-ALIGNED
          LABEL "Object filename"
          VIEW-AS FILL-IN 
          SIZE 78.4 BY 1
     RowObject.object_description AT ROW 3 COL 23.2 COLON-ALIGNED
          LABEL "Object description"
          VIEW-AS FILL-IN 
          SIZE 78.4 BY 1
     fiModuleDesc AT ROW 6.33 COL 23.2 COLON-ALIGNED NO-LABEL
     RowObject.container_object AT ROW 9.38 COL 25.2
          LABEL "Container object"
          VIEW-AS TOGGLE-BOX
          SIZE 20.8 BY 1
     RowObject.static_object AT ROW 9.38 COL 47.6
          LABEL "Static object"
          VIEW-AS TOGGLE-BOX
          SIZE 18.6 BY 1
     RowObject.generic_object AT ROW 10.43 COL 25.2
          LABEL "Generic object"
          VIEW-AS TOGGLE-BOX
          SIZE 19.2 BY 1
     RowObject.runnable_from_menu AT ROW 10.43 COL 47.2
          LABEL "Runnable from menu"
          VIEW-AS TOGGLE-BOX
          SIZE 25.4 BY 1
     fiToolbarObjectLabel AT ROW 1 COL 1.8 COLON-ALIGNED NO-LABEL
     RowObject.smartobject_obj AT ROW 9.62 COL 88.2 COLON-ALIGNED
          LABEL "SmartObject Obj"
           VIEW-AS TEXT 
          SIZE 11.2 BY .62
     RowObject.object_type_obj AT ROW 10.57 COL 88.2 COLON-ALIGNED
          LABEL "Object Type Obj"
           VIEW-AS TEXT 
          SIZE 10.8 BY .62
     RECT-7 AT ROW 1.43 COL 1.8
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
         HEIGHT             = 10.43
         WIDTH              = 104.
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

/* SETTINGS FOR TOGGLE-BOX RowObject.container_object IN FRAME frMain
   EXP-LABEL                                                            */
ASSIGN 
       RowObject.container_object:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN fiModuleDesc IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiToolbarObjectLabel IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       fiToolbarObjectLabel:PRIVATE-DATA IN FRAME frMain     = 
                "Toolbar Object".

/* SETTINGS FOR TOGGLE-BOX RowObject.generic_object IN FRAME frMain
   EXP-LABEL                                                            */
ASSIGN 
       RowObject.generic_object:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN RowObject.object_description IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.object_filename IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.object_type_obj IN FRAME frMain
   NO-ENABLE EXP-LABEL                                                  */
ASSIGN 
       RowObject.object_type_obj:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR TOGGLE-BOX RowObject.runnable_from_menu IN FRAME frMain
   EXP-LABEL                                                            */
ASSIGN 
       RowObject.runnable_from_menu:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN RowObject.smartobject_obj IN FRAME frMain
   NO-ENABLE EXP-LABEL                                                  */
ASSIGN 
       RowObject.smartobject_obj:HIDDEN IN FRAME frMain           = TRUE
       RowObject.smartobject_obj:READ-ONLY IN FRAME frMain        = TRUE.

/* SETTINGS FOR TOGGLE-BOX RowObject.static_object IN FRAME frMain
   EXP-LABEL                                                            */
ASSIGN 
       RowObject.static_object:HIDDEN IN FRAME frMain           = TRUE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addRecord vTableWin 
PROCEDURE addRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cModuleObj      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSource         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hLookup         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cModuleCode     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cModuleDesc     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hCombo          AS HANDLE     NO-UNDO.
  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  {get ContainerSource hSource}.
  cModuleObj  = DYNAMIC-FUNCTION("getModuleObj":U IN hSource).
  cModuleCode = DYNAMIC-FUNCTION("getModuleCode":U IN hSource).
  cModuleDesc = DYNAMIC-FUNCTION("getModuleDesc":U IN hSource).
  
  IF cModuleObj = "" OR cModuleObj = ? THEN DO:
     cModuleObj  = DYNAMIC-FUNCTION("getPhysicalModuleObj":U IN hSource).
     cModuleCode = DYNAMIC-FUNCTION("getPhysicalModuleCode":U IN hSource).
     cModuleDesc = DYNAMIC-FUNCTION("getPhysicalModuleDesc":U IN hSource).
  END.
  
  {set KeyFieldValue cModuleObj h_dynlookup}.
  {get LookupHandle hLookup  h_dynlookup}.
  IF VALID-HANDLE(hLookup) THEN DO:
    hLookup:SCREEN-VALUE = cModuleCode.
    {set SavedScreenValue hLookup:SCREEN-VALUE h_dynlookup}.
  END.
  fiModuleDesc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cModuleDesc.


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
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_customization_result.customization_result_codeKeyFieldryc_customization_result.customization_result_objFieldLabelCustomization codeFieldTooltipPress F4 For LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH ryc_customization_type NO-LOCK,
                     EACH ryc_customization_result NO-LOCK
                     WHERE ryc_customization_result.customization_type_obj = ryc_customization_type.customization_type_obj INDEXED-REPOSITIONQueryTablesryc_customization_type,ryc_customization_resultBrowseFieldsryc_customization_result.customization_result_code,ryc_customization_result.customization_result_desc,ryc_customization_type.customization_type_code,ryc_customization_type.customization_type_desc,ryc_customization_type.api_name,ryc_customization_result.system_ownedBrowseFieldDataTypescharacter,character,character,character,character,logicalBrowseFieldFormatsX(70)|X(70)|X(15)|X(35)|X(70)|YES/NORowsToBatch200BrowseTitleCustomization Code LookupViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesSuperProcedureDataSourceNameFieldNamecustomization_result_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dynlookup-3 ).
       RUN repositionObject IN h_dynlookup-3 ( 4.10 , 25.20 ) NO-ERROR.
       RUN resizeObject IN h_dynlookup-3 ( 1.00 , 51.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_product_module.product_module_codeKeyFieldgsc_product_module.product_module_objFieldLabelProduct moduleFieldTooltipPress F4 For LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(35)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_product_moduleQueryTablesgsc_product_moduleBrowseFieldsgsc_product_module.product_module_code,gsc_product_module.product_module_descriptionBrowseFieldDataTypescharacter,characterBrowseFieldFormatsX(35)|X(35)RowsToBatch200BrowseTitleLookupViewerLinkedFieldsgsc_product_module.product_module_descriptionLinkedFieldDataTypescharacterLinkedFieldFormatsX(35)ViewerLinkedWidgetsfiModuleDescColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListNO-LOCKQueryBuilderOrderListQueryBuilderTableOptionListNO-LOCKQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesSuperProcedureDataSourceNameFieldNameproduct_module_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dynlookup ).
       RUN repositionObject IN h_dynlookup ( 5.19 , 25.20 ) NO-ERROR.
       RUN resizeObject IN h_dynlookup ( 1.00 , 51.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_dynlookup-3 ,
             RowObject.object_description:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_dynlookup ,
             h_dynlookup-3 , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelRecord vTableWin 
PROCEDURE cancelRecord :
/*------------------------------------------------------------------------------
  Purpose:    If Add or Copy action is cancelled, it may be that the selected tree 
              is not in synch with the current record. This happens if the user 
              selected to add a record from the popup menus
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cNew    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hSource AS HANDLE     NO-UNDO.
DEFINE VARIABLE cKey    AS CHARACTER  NO-UNDO.
  
 {get NewRecord cNew}.

  RUN SUPER.

  IF cNew = "Add":U OR cNew = "Copy":U THEN DO:
    {get ContainerSource hSource}.
    IF VALID-HANDLE(hSource) THEN
       RUN treeSynch IN hSource ("TBAROBJ":U).
  END.


  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteComplete vTableWin 
PROCEDURE deleteComplete :
/*------------------------------------------------------------------------------
  Purpose:     Calls the container which deletes the node from the treeview
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE hSource AS HANDLE     NO-UNDO.

{get ContainerSource hSource}.

IF VALID-HANDLE(hSource) THEN
    RUN deleteNode IN hSource ("TbarObj":U,NO).

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

  DEFINE VARIABLE cNew       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataValue AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hCombo      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFields     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iEntry AS INTEGER    NO-UNDO.
  
  /* Code placed here will execute PRIOR to standard behavior. */
  {get NewRecord cNew}.
  RUN SUPER( INPUT pcColValues).
    
  {get DataValue cDataValue h_dynlookup-3}.

  IF cNew <> "Add":U AND cNew <> "Copy" AND cDataValue = "" THEN
     RUN disableField IN h_dynlookup-3.
  ELSE
     RUN enableField IN h_dynlookup-3.

  /* Code placed here will execute AFTER standard behavior.    */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRecord vTableWin 
PROCEDURE updateRecord :
DEFINE VARIABLE cNew    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cCustom AS CHARACTER  NO-UNDO.

  {get ContainerSource hSource}.
  ASSIGN
    RowObject.object_type_obj:SCREEN-VALUE IN FRAME {&FRAME-NAME}   =  DYNAMIC-FUNC('getObjectTypeObj':U IN hSource) 
    RowObject.container_object:SCREEN-VALUE   = "No":U
    RowObject.generic_object:SCREEN-VALUE     = "No":U
    RowObject.static_object:SCREEN-VALUE      = "No":U
    RowObject.runnable_from_menu:SCREEN-VALUE = "No":U
  NO-ERROR.
  /* Code placed here will execute PRIOR to standard behavior. */
   cCustom    = DYNAMIC-FUNC("getDisplayValue":U IN h_dynlookup-3) .
  
  {get NewRecord cNew}.
  RUN SUPER.
  
  /* If sucessfull, add node if adding */
  IF RETURN-VALUE <> "ADM-ERROR":U THEN 
  DO:
    IF cNew = "Add":U OR cNew = "Copy":U THEN 
    DO:
      IF VALID-HANDLE(hSource) THEN
         RUN addNode IN hSource (INPUT "TbarObj":U,
                                 INPUT RowObject.OBJECT_filename:SCREEN-VALUE IN FRAME {&FRAME-NAME} 
                                    + (IF cCustom <> ? AND cCustom <> "" THEN "[" + cCustom + "]" ELSE "")
                                    + (IF RowObject.OBJECT_description:SCREEN-VALUE > "" 
                                          AND trim(RowObject.OBJECT_Description:SCREEN-VALUE) <> trim(RowObject.OBJECT_filename:SCREEN-VALUE)
                                       THEN "  (":U + RowObject.OBJECT_Description:SCREEN-VALUE + ")"
                                       ELSE ""),
                                 INPUT RowObject.smartobject_obj:SCREEN-VALUE 
                                     + "|" + RowObject.object_filename:SCREEN-VALUE + "|" + cCustom + "|" + cNew).
        
    END.
    ELSE IF  VALID-HANDLE(hSource)  THEN
      RUN updateNode IN hSource(INPUT "TBarOBJ":U,
                                INPUT "",
                                INPUT RowObject.object_filename:SCREEN-VALUE
                                      + (IF cCustom <> ? AND cCustom <> "" THEN "[" + cCustom + "]" ELSE "")  
                                      + (IF RowObject.OBJECT_description:SCREEN-VALUE > "" 
                                          AND trim(RowObject.OBJECT_Description:SCREEN-VALUE) <> trim(RowObject.OBJECT_filename:SCREEN-VALUE)
                                       THEN "  (" + RowObject.OBJECT_Description:SCREEN-VALUE + ")"
                                       ELSE "")).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

