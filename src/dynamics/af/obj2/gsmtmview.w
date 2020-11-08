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
       {"af/obj2/gsmtmfullo.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: gsmtmview.w.w

  Description:  ToolbarMENU structure viewer

  Purpose:      Used for populating gsm_toolbar_menu-structure

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   08/30/2001  Author:     Donald Bulua

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

&scop object-name       gsmtmview.w
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
&Scoped-define DATA-FIELD-DEFS "af/obj2/gsmtmfullo.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.menu_structure_sequence ~
RowObject.menu_structure_spacing RowObject.menu_structure_alignment ~
RowObject.insert_rule 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-Define ENABLED-OBJECTS RECT-7 
&Scoped-Define DISPLAYED-FIELDS RowObject.menu_structure_sequence ~
RowObject.menu_structure_spacing RowObject.menu_structure_alignment ~
RowObject.insert_rule RowObject.toolbar_menu_structure_obj 
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define DISPLAYED-OBJECTS fiMenuType fiBandDesc fiToolbarBandsLabel ~
fiModule 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_dynlookup AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE fiBandDesc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 79 BY 1 NO-UNDO.

DEFINE VARIABLE fiMenuType AS CHARACTER FORMAT "X(256)":U 
     LABEL "Type" 
     VIEW-AS FILL-IN 
     SIZE 28 BY 1 NO-UNDO.

DEFINE VARIABLE fiModule AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .62 NO-UNDO.

DEFINE VARIABLE fiToolbarBandsLabel AS CHARACTER FORMAT "X(15)":U INITIAL "Toolbar Bands" 
      VIEW-AS TEXT 
     SIZE 13.8 BY .62 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 101 BY 7.43.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     fiMenuType AT ROW 2.1 COL 69.8 COLON-ALIGNED
     fiBandDesc AT ROW 3.19 COL 18.8 COLON-ALIGNED NO-LABEL
     RowObject.menu_structure_sequence AT ROW 4.29 COL 18.8 COLON-ALIGNED
          LABEL "Band sequence"
          VIEW-AS FILL-IN 
          SIZE 9 BY 1
     RowObject.menu_structure_spacing AT ROW 5.38 COL 18.8 COLON-ALIGNED
          LABEL "Band spacing"
          VIEW-AS FILL-IN 
          SIZE 9 BY 1
     RowObject.menu_structure_alignment AT ROW 6.48 COL 5
          LABEL "Band alignment"
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "LEFT","RIGHT","CENTER" 
          DROP-DOWN-LIST
          SIZE 17 BY 1
     RowObject.insert_rule AT ROW 7.52 COL 20.6
          LABEL "Insert separator before band"
          VIEW-AS TOGGLE-BOX
          SIZE 32 BY 1
     fiToolbarBandsLabel AT ROW 1.14 COL 1 COLON-ALIGNED NO-LABEL
     fiModule AT ROW 4.24 COL 78.2 COLON-ALIGNED NO-LABEL BLANK 
     RowObject.toolbar_menu_structure_obj AT ROW 4.91 COL 79.2 COLON-ALIGNED NO-LABEL
           VIEW-AS TEXT 
          SIZE 11.2 BY .62
     RECT-7 AT ROW 1.43 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "af/obj2/gsmtmfullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {af/obj2/gsmtmfullo.i}
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
         HEIGHT             = 11.24
         WIDTH              = 113.4.
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

/* SETTINGS FOR FILL-IN fiBandDesc IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiMenuType IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiModule IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       fiModule:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN fiToolbarBandsLabel IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       fiToolbarBandsLabel:PRIVATE-DATA IN FRAME frMain     = 
                "Toolbar Bands".

/* SETTINGS FOR TOGGLE-BOX RowObject.insert_rule IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR COMBO-BOX RowObject.menu_structure_alignment IN FRAME frMain
   ALIGN-L EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN RowObject.menu_structure_sequence IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.menu_structure_spacing IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.toolbar_menu_structure_obj IN FRAME frMain
   NO-ENABLE EXP-LABEL                                                  */
ASSIGN 
       RowObject.toolbar_menu_structure_obj:HIDDEN IN FRAME frMain           = TRUE
       RowObject.toolbar_menu_structure_obj:READ-ONLY IN FRAME frMain        = TRUE.

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
  DEFINE VARIABLE hSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSeq    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iSeq    AS INTEGER    NO-UNDO.
  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  RowObject.MENU_structure_alignment:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "LEFT".
  
  {get ContainerSource hSource}.
  IF VALID-HANDLE(hSource) THEN 
  DO WITH FRAME {&FRAME-NAME}:
    cSeq = DYNAMIC-FUNCTION("getSequence":U IN hSource).
    IF cSeq = "" OR cSeq = ? THEN
       cSeq = "0".

    ASSIGN iseq           = INT(cSeq)
           iSeq           = iSeq + 1
           RowObject.MENU_structure_sequence:SCREEN-VALUE = STRING(iseq)
           NO-ERROR.
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
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsm_menu_structure.menu_structure_codeKeyFieldgsm_menu_structure.menu_structure_objFieldLabelBand codeFieldTooltippress F4 for LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(28)DisplayDatatypecharacterBaseQueryStringFOR EACH gsm_menu_structure no-lock
                     WHERE  (gsm_menu_structure.menu_structure_type <> "SubMenu":U)QueryTablesgsm_menu_structureBrowseFieldsgsm_menu_structure.menu_structure_code,gsm_menu_structure.menu_structure_description,gsm_menu_structure.menu_structure_typeBrowseFieldDataTypescharacter,character,characterBrowseFieldFormatsX(28)|X(35)|X(15)RowsToBatch200BrowseTitleBand LookupViewerLinkedFieldsgsm_menu_structure.menu_structure_description,gsm_menu_structure.menu_structure_typeLinkedFieldDataTypescharacter,characterLinkedFieldFormatsX(35),X(15)ViewerLinkedWidgetsfibanddesc,fimenutypeColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldfiModule,fiModule,fiModuleParentFilterQuerygsm_menu_structure.product_module_obj =  (IF  ~'&1~' <> ~'~' THEN decimal(~'&1~') ELSE gsm_menu_structure.product_module_obj )  OR   gsm_menu_structure.product_module_obj  =   (IF  ~'&1~' <> ~'~' THEN 0 ELSE gsm_menu_structure.product_module_obj )MaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesSuperProcedureDataSourceNameFieldNamemenu_structure_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dynlookup ).
       RUN repositionObject IN h_dynlookup ( 2.10 , 20.80 ) NO-ERROR.
       RUN resizeObject IN h_dynlookup ( 1.00 , 42.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_dynlookup ,
             fiMenuType:HANDLE IN FRAME frMain , 'BEFORE':U ).
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
       RUN treeSynch IN hSource ("TBARBAND":U).
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
    RUN deleteNode IN hSource ("TBARBand":U,NO).

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

  DEFINE VARIABLE hSource AS HANDLE     NO-UNDO.
  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcColValues).

  /* Code placed here will execute AFTER standard behavior.    */
  {get ContainerSource hSource}.
  fiModule:SCREEN-VALUE IN FRAME {&FRAME-NAME} = DYNAMIC-FUNC("getModuleObj":U IN hSource).
 IF fiMenuType:SCREEN-VALUE = "ToolBar":U OR 
      fiMenuType:SCREEN-VALUE = "Menu&Toolbar":U THEN 
  ASSIGN RowObject.insert_rule:SENSITIVE = TRUE
          RowObject.menu_structure_alignment:SENSITIVE = TRUE 
          RowObject.menu_structure_sequence:SENSITIVE = TRUE 
          RowObject.menu_structure_spacing:SENSITIVE = TRUE.
 ELSE
   ASSIGN RowObject.insert_rule:SENSITIVE = FALSE
          RowObject.menu_structure_alignment:SENSITIVE = FALSE 
          RowObject.menu_structure_sequence:SENSITIVE = FALSE 
          RowObject.menu_structure_spacing:SENSITIVE = FALSE.
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
IF fiMenuType:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "ToolBar":U OR 
      fiMenuType:SCREEN-VALUE = "Menu&Toolbar":U THEN 
  ASSIGN RowObject.insert_rule:SENSITIVE = TRUE
          RowObject.menu_structure_alignment:SENSITIVE = TRUE 
          RowObject.menu_structure_sequence:SENSITIVE = TRUE 
          RowObject.menu_structure_spacing:SENSITIVE = TRUE.
 ELSE
   ASSIGN RowObject.insert_rule:SENSITIVE = FALSE
          RowObject.menu_structure_alignment:SENSITIVE = FALSE 
          RowObject.menu_structure_sequence:SENSITIVE = FALSE 
          RowObject.menu_structure_spacing:SENSITIVE = FALSE.
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
  SUBSCRIBE TO "lookupComplete":U IN THIS-PROCEDURE.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LookupComplete vTableWin 
PROCEDURE LookupComplete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcnames    AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcValues   AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcNewKey   AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcNewValue AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcOldValue AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER plWhere    AS LOGICAL    NO-UNDO.
DEFINE INPUT  PARAMETER pHandle    AS HANDLE     NO-UNDO.

IF fiMenuType:SCREEN-VALUE IN FRAME {&Frame-name} = "ToolBar":U  OR 
      fiMenuType:SCREEN-VALUE = "Menu&Toolbar":U THEN 
  ASSIGN RowObject.insert_rule:SENSITIVE = TRUE
          RowObject.menu_structure_alignment:SENSITIVE = TRUE 
          RowObject.menu_structure_sequence:SENSITIVE = TRUE 
          RowObject.menu_structure_spacing:SENSITIVE = TRUE.
 ELSE
   ASSIGN RowObject.insert_rule:SENSITIVE = FALSE
          RowObject.menu_structure_alignment:SENSITIVE = FALSE 
          RowObject.menu_structure_sequence:SENSITIVE = FALSE 
          RowObject.menu_structure_spacing:SENSITIVE = FALSE.

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
  DEFINE VARIABLE cNew AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSource AS HANDLE     NO-UNDO.
  
  /* Code placed here will execute PRIOR to standard behavior. */
  {get NewRecord cNew}.
  RUN SUPER.
  /* If sucessfull, add node if adding */
  IF RETURN-VALUE <> "ADM-ERROR":U THEN 
  DO:
    {get ContainerSource hSource}.
    IF cNew = "Add":U OR cNew = "Copy":U AND VALID-HANDLE(hSource)  THEN 
    DO:
      RUN addNode IN hSource ("TBARBand":U,
                                 fiBandDesc:SCREEN-VALUE IN FRAME {&FRAME-NAME} + 
                                      CHR(1) + fiMenuType:SCREEN-VALUE,
                                 RowObject.toolbar_menu_structure_obj:SCREEN-VALUE).
        
     END.
     ELSE IF VALID-HANDLE(hSource)  THEN 
         RUN updateNode IN hSource ("TBARBand":U,"",rowObject.MENU_structure_sequence:SCREEN-VALUE).
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

