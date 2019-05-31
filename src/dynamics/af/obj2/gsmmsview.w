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
       {"af/obj2/gsmmsfullo.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: gsmmsviewv.w

  Description:  Band/menu structure viewer

  Purpose:      To maintain bands

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   08/21/2001  Author:     Don Buluas

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

&scop object-name       gsmmsview.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
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
&Scoped-define DATA-FIELD-DEFS "af/obj2/gsmmsfullo.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.menu_structure_code ~
RowObject.menu_structure_description RowObject.menu_structure_type ~
RowObject.menu_structure_narrative RowObject.disabled ~
RowObject.menu_structure_hidden RowObject.system_owned ~
RowObject.under_development 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-Define ENABLED-OBJECTS RECT-2 
&Scoped-Define DISPLAYED-FIELDS RowObject.menu_structure_code ~
RowObject.menu_structure_description RowObject.menu_structure_type ~
RowObject.menu_structure_narrative RowObject.disabled ~
RowObject.menu_structure_hidden RowObject.system_owned ~
RowObject.under_development RowObject.menu_structure_obj 
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define DISPLAYED-OBJECTS fiBandsLabel filabel ~
fiDetailedDescriptionLabel fiModule 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setToolbarType vTableWin 
FUNCTION setToolbarType RETURNS LOGICAL
  ( pcType AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_dyncombo AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dynlookup-2 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE fiBandsLabel AS CHARACTER FORMAT "X(15)":U INITIAL "Bands" 
      VIEW-AS TEXT 
     SIZE 6.8 BY .71 NO-UNDO.

DEFINE VARIABLE fiDetailedDescriptionLabel AS CHARACTER FORMAT "X(35)":U INITIAL "Detailed description:" 
      VIEW-AS TEXT 
     SIZE 19.8 BY 1 NO-UNDO.

DEFINE VARIABLE filabel AS CHARACTER FORMAT "X(256)":U 
     LABEL "Item label" 
     VIEW-AS FILL-IN 
     SIZE 35 BY 1 NO-UNDO.

DEFINE VARIABLE fiModule AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .62 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 111 BY 12.05.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     fiBandsLabel AT ROW 1 COL 2.4 NO-LABEL
     filabel AT ROW 7.43 COL 25 COLON-ALIGNED
     fiDetailedDescriptionLabel AT ROW 8.62 COL 3.8 COLON-ALIGNED NO-LABEL
     RowObject.menu_structure_code AT ROW 1.48 COL 25 COLON-ALIGNED
          LABEL "Band code"
          VIEW-AS FILL-IN 
          SIZE 40 BY 1 TOOLTIP "Unique Band Code"
     RowObject.menu_structure_description AT ROW 2.67 COL 25 COLON-ALIGNED
          LABEL "Band description"
          VIEW-AS FILL-IN 
          SIZE 53 BY 1 TOOLTIP "Band Description"
     fiModule AT ROW 1.71 COL 73 COLON-ALIGNED NO-LABEL BLANK 
     RowObject.menu_structure_type AT ROW 5.05 COL 16.2
          LABEL "Band type"
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Menubar","Submenu","Toolbar","Menu&Toolbar" 
          DROP-DOWN-LIST
          SIZE 34 BY 1 TOOLTIP "Menu or Toolbar type"
     RowObject.menu_structure_narrative AT ROW 8.62 COL 27 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 500 SCROLLBAR-VERTICAL
          SIZE 53 BY 4 TOOLTIP "Detailed description of band"
     RowObject.disabled AT ROW 2.81 COL 86.2
          LABEL "Disabled"
          VIEW-AS TOGGLE-BOX
          SIZE 13.2 BY 1
     RowObject.menu_structure_hidden AT ROW 3.86 COL 86.2
          LABEL "Hide band"
          VIEW-AS TOGGLE-BOX
          SIZE 17 BY 1
     RowObject.system_owned AT ROW 4.91 COL 86.2
          LABEL "System owned"
          VIEW-AS TOGGLE-BOX
          SIZE 19.2 BY 1
     RowObject.under_development AT ROW 5.95 COL 86.2
          LABEL "Under development"
          VIEW-AS TOGGLE-BOX
          SIZE 22 BY 1
     RowObject.menu_structure_obj AT ROW 12.24 COL 56.2 COLON-ALIGNED
          LABEL "Menu Structure Obj"
           VIEW-AS TEXT 
          SIZE 7 BY .62
     RECT-2 AT ROW 1.24 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "af/obj2/gsmmsfullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {af/obj2/gsmmsfullo.i}
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
         HEIGHT             = 13.95
         WIDTH              = 115.
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

/* SETTINGS FOR TOGGLE-BOX RowObject.disabled IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN fiBandsLabel IN FRAME frMain
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       fiBandsLabel:PRIVATE-DATA IN FRAME frMain     = 
                "Bands".

/* SETTINGS FOR FILL-IN fiDetailedDescriptionLabel IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       fiDetailedDescriptionLabel:PRIVATE-DATA IN FRAME frMain     = 
                "Detailed Description:".

/* SETTINGS FOR FILL-IN filabel IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiModule IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN RowObject.menu_structure_code IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.menu_structure_description IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.menu_structure_hidden IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR EDITOR RowObject.menu_structure_narrative IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.menu_structure_obj IN FRAME frMain
   NO-ENABLE EXP-LABEL                                                  */
ASSIGN 
       RowObject.menu_structure_obj:HIDDEN IN FRAME frMain           = TRUE
       RowObject.menu_structure_obj:READ-ONLY IN FRAME frMain        = TRUE.

/* SETTINGS FOR COMBO-BOX RowObject.menu_structure_type IN FRAME frMain
   ALIGN-L EXP-LABEL                                                    */
/* SETTINGS FOR TOGGLE-BOX RowObject.system_owned IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.under_development IN FRAME frMain
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
  DEFINE VARIABLE cModuleObj AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSOurce    AS HANDLE     NO-UNDO.
  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
 {get ContainerSource hSource}.
  
  /* Set the Product Module to the current filtdred value*/
  cModuleObj = DYNAMIC-FUNC('getModuleObj':U IN hSource).
  {set DataValue cModuleObj h_dyncombo}.
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
             INPUT  'DisplayedFieldgsc_product_module.product_module_code,gsc_product_module.product_module_descriptionKeyFieldgsc_product_module.product_module_objFieldLabelProduct moduleFieldTooltipSelect module from listKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(35)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_product_module
                     WHERE [&FilterSet=|&EntityList=GSCPM] NO-LOCK BY gsc_product_module.product_module_code INDEXED-REPOSITIONQueryTablesgsc_product_moduleSDFFileNameSDFTemplateParentFieldParentFilterQueryDescSubstitute&1 / &2ComboDelimiterListItemPairsInnerLines5ComboFlagNFlagValue0BuildSequence1SecurednoCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesFieldNameproduct_module_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dyncombo ).
       RUN repositionObject IN h_dyncombo ( 3.86 , 27.00 ) NO-ERROR.
       RUN resizeObject IN h_dyncombo ( 1.05 , 53.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsm_menu_item.menu_item_referenceKeyFieldgsm_menu_item.menu_item_objFieldLabelItem ref. used for labelFieldTooltipPress F4 for LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(15)DisplayDatatypecharacterBaseQueryStringfor each gsm_menu_item NO-LOCK
                     WHERE gsm_menu_item.item_control_type = "Label":U,
                     EACH gsc_product_module of gsm_menu_item WHERE [&FilterSet=|&EntityList=GSCPM] OUTER-JOIN
                     by menu_item_referenceQueryTablesgsm_menu_item,gsc_product_moduleBrowseFieldsgsm_menu_item.menu_item_reference,gsm_menu_item.menu_item_description,gsm_menu_item.menu_item_label,gsc_product_module.product_module_codeBrowseFieldDataTypescharacter,character,character,characterBrowseFieldFormatsX(15)|X(35)|X(28)|X(35)RowsToBatch200BrowseTitleLookupViewerLinkedFieldsgsm_menu_item.menu_item_labelLinkedFieldDataTypescharacterLinkedFieldFormatsX(28)ViewerLinkedWidgetsfiLabelColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoFieldNamemenu_item_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dynlookup-2 ).
       RUN repositionObject IN h_dynlookup-2 ( 6.24 , 27.00 ) NO-ERROR.
       RUN resizeObject IN h_dynlookup-2 ( 1.00 , 53.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_dyncombo ,
             RowObject.menu_structure_description:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_dynlookup-2 ,
             RowObject.menu_structure_type:HANDLE IN FRAME frMain , 'AFTER':U ).
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


  /* Code placed here will execute PRIOR to standard behavior. */
 {get NewRecord cNew}.
  RUN SUPER.
  IF cNew = "Add":U OR cNew = "Copy":U THEN DO:
    {get ContainerSource hSource}.
    IF VALID-HANDLE(hSource) THEN
       RUN treeSynch IN hSource ("BAND":U).
  END.


  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteComplete vTableWin 
PROCEDURE deleteComplete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hSource AS HANDLE     NO-UNDO.

{get ContainerSource hSource}.

IF VALID-HANDLE(hSource) THEN
    RUN deleteNode IN hSource ("Band":U,NO).

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
   
  DEFINE VARIABLE hSource            AS HANDLE     NO-UNDO.
  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcColValues).

  /* Code placed here will execute AFTER standard behavior.    */
  {get ContainerSource hSource}.
  fiModule:SCREEN-VALUE IN FRAME {&FRAME-NAME} = DYNAMIC-FUNC("getModuleObj":U IN hSource).
  
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
  SUBSCRIBE TO "lookupDisplayComplete":U IN THIS-PROCEDURE.


  RUN SUPER.

  
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE lookupDisplayComplete vTableWin 
PROCEDURE lookupDisplayComplete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcnames         AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcValues        AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcKeyFieldValue AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pHandle         AS HANDLE     NO-UNDO.
  
 IF pHandle = h_dynlookup-2 AND pcKeyFieldValue = "" THEN
    {set keyFieldValue "0" h_dynlookup-2}.


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
  DEFINE VARIABLE cNew      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSource   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lModified AS LOGICAL    NO-UNDO.

  {get ContainerSource hSource}.
  {get NewRecord cNew}.
  /* Code placed here will execute PRIOR to standard behavior. */
  
  
  RUN SUPER.
  /* If sucessfull, add node if adding */
  IF RETURN-VALUE <> "ADM-ERROR":U AND VALID-HANDLE(hSource) THEN 
  DO:
    IF cNew = "Add":U OR cNew = "Copy":U THEN 
      RUN addNode IN hSource ("Band":U,
                               RowObject.MENU_structure_Code:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                             + (IF RowObject.MENU_structure_description:SCREEN-VALUE > "" 
                                   AND trim(RowObject.MENU_structure_DESCRIPTION:SCREEN-VALUE) <> trim(RowObject.MENU_structure_Code:SCREEN-VALUE)
                                THEN "  (" + RowObject.MENU_structure_DESCRIPTION:SCREEN-VALUE + ")"
                                ELSE "")  +
                               CHR(1) + RowObject.MENU_structure_type:SCREEN-VALUE ,
                               RowObject.menu_structure_obj:SCREEN-VALUE).
    ELSE
      RUN updateNode IN hSource("Band","",RowObject.MENU_structure_Code:SCREEN-VALUE + 
                                          (IF RowObject.MENU_structure_description:SCREEN-VALUE > "" 
                                              AND trim(RowObject.MENU_structure_DESCRIPTION:SCREEN-VALUE) <> trim(RowObject.MENU_structure_Code:SCREEN-VALUE)
                                           THEN "  (" + RowObject.MENU_structure_DESCRIPTION:SCREEN-VALUE + ")"
                                           ELSE "") ).
  END.

  /* Code placed here will execute AFTER standard behavior.    */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setToolbarType vTableWin 
FUNCTION setToolbarType RETURNS LOGICAL
  ( pcType AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
  ASSIGN RowObject.menu_structure_type:SCREEN-VALUE = pctype NO-ERROR.
  END.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

