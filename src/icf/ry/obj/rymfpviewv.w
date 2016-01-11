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
       {"ry/obj/rymfpfullo.i"}.


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
  File: rymfpviewv.w

  Description:  Folder Page Viewer

  Purpose:      Folder Page Viewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        6478   UserRef:    
                Date:   17/08/2000  Author:     Anthony Swindells

  Update Notes: Created from Template rysttviewv.w
                Created from Template rymfpviewv.w

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

&scop object-name       rymfpviewv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010001

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{af/sup2/afglobals.i}


DEFINE VARIABLE gcDisplayedTables    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE gcSBOName            AS CHARACTER    NO-UNDO.
DEFINE VARIABLE gcViewerName         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE ghSBO                AS HANDLE       NO-UNDO.
DEFINE VARIABLE ghSDV                AS HANDLE       NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "ry/obj/rymfpfullo.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.page_number ~
RowObject.primary_viewer RowObject.page_label ~
RowObject.viewer_toolbar_parent_menu RowObject.link_viewer_to_sdo ~
RowObject.viewer_data_source_names RowObject.viewer_update_target_names ~
RowObject.browser_toolbar_parent_menu RowObject.sdo_foreign_fields ~
RowObject.window_title_field 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define DISPLAYED-FIELDS RowObject.page_number ~
RowObject.primary_viewer RowObject.page_label ~
RowObject.viewer_toolbar_parent_menu RowObject.link_viewer_to_sdo ~
RowObject.viewer_data_source_names RowObject.viewer_update_target_names ~
RowObject.browser_toolbar_parent_menu RowObject.sdo_foreign_fields ~
RowObject.window_title_field 
&Scoped-Define DISPLAYED-OBJECTS fiObjectType 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_browlookup AS HANDLE NO-UNDO.
DEFINE VARIABLE h_parentsdolookup AS HANDLE NO-UNDO.
DEFINE VARIABLE h_ryclacsdfv AS HANDLE NO-UNDO.
DEFINE VARIABLE h_rysbodatfv AS HANDLE NO-UNDO.
DEFINE VARIABLE h_sdolookup AS HANDLE NO-UNDO.
DEFINE VARIABLE h_viewlookup AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE fiObjectPath AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 4 BY 1 NO-UNDO.

DEFINE VARIABLE fiObjectType AS CHARACTER FORMAT "X(256)":U 
     LABEL "Data Object Type" 
     VIEW-AS FILL-IN 
     SIZE 51 BY 1 NO-UNDO.

DEFINE VARIABLE fiViewerPath AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 4 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     RowObject.page_number AT ROW 1 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.6 BY 1 TOOLTIP "Specify number of this page (from 1)"
     RowObject.primary_viewer AT ROW 1.1 COL 65.2
          VIEW-AS TOGGLE-BOX
          SIZE 18.8 BY .81 TOOLTIP "Set to YES for group-assign source viewer - need 1 per SDO"
     RowObject.page_label AT ROW 2.05 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 51 BY 1 TOOLTIP "Label to display on tab folder"
     fiViewerPath AT ROW 2.24 COL 4.2
     RowObject.viewer_toolbar_parent_menu AT ROW 4.24 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 51 BY 1
     RowObject.link_viewer_to_sdo AT ROW 5.38 COL 33
          VIEW-AS TOGGLE-BOX
          SIZE 30.4 BY .81
     RowObject.viewer_data_source_names AT ROW 6.43 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 51 BY 1
     RowObject.viewer_update_target_names AT ROW 7.48 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 51 BY 1
     RowObject.browser_toolbar_parent_menu AT ROW 9.57 COL 31 COLON-ALIGNED
          LABEL "Browser Toolbar Parent Menu"
          VIEW-AS FILL-IN 
          SIZE 51 BY 1 TOOLTIP "Submenu to add browser actions to for toolbars on this page"
     fiObjectPath AT ROW 10.91 COL 2.6
     fiObjectType AT ROW 11.67 COL 31 COLON-ALIGNED
     RowObject.sdo_foreign_fields AT ROW 13.86 COL 31 COLON-ALIGNED FORMAT "X(500)"
          VIEW-AS FILL-IN 
          SIZE 51 BY 1 TOOLTIP "Foreign field pairs for SDO - child (dbprefix),parent (no dbprefix), etc."
     RowObject.window_title_field AT ROW 15.95 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 51 BY 1 TOOLTIP "Fieldname from SDO to add to window title to identify parent record"
     SPACE(1.00) SKIP(1.15)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "ry/obj/rymfpfullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {ry/obj/rymfpfullo.i}
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
         HEIGHT             = 17.24
         WIDTH              = 84.4.
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

/* SETTINGS FOR FILL-IN RowObject.browser_toolbar_parent_menu IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN fiObjectPath IN FRAME frMain
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       fiObjectPath:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN fiObjectType IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiViewerPath IN FRAME frMain
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       fiViewerPath:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN RowObject.sdo_foreign_fields IN FRAME frMain
   EXP-FORMAT                                                           */
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

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  IF VALID-HANDLE(h_ryclacsdfv) THEN
  DO:
    DYNAMIC-FUNCTION("setDataValue":U IN h_ryclacsdfv, INPUT "Top/Center/Bottom":U).
  END.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN RowObject.link_viewer_to_sdo:SCREEN-VALUE = "NO":U.
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
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.object_filenameFieldLabelViewer Object NameFieldTooltipViewer to display on folder page (no path)KeyFormatX(70)KeyDatatypecharacterDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object_type NO-LOCK
                     WHERE gsc_object_type.object_type_code MATCHES "*SDV*",
                     EACH ryc_smartobject NO-LOCK
                     WHERE ryc_smartobject.OBJECT_type_obj = gsc_object_type.OBJECT_type_obj,
                     FIRST gsc_object NO-LOCK
                     WHERE gsc_object.OBJECT_obj = ryc_smartobject.OBJECT_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj
                     BY ryc_smartobject.OBJECT_filenameQueryTablesgsc_object_type,ryc_smartobject,gsc_object,gsc_product_moduleBrowseFieldsgsc_product_module.product_module_code,ryc_smartobject.object_filename,gsc_object_type.object_type_code,gsc_object.object_descriptionBrowseFieldDataTypescharacter,character,character,characterBrowseFieldFormatsX(10),X(70),X(15),X(35)RowsToBatch200BrowseTitleLookup ViewerViewerLinkedFieldsgsc_object.object_pathLinkedFieldDataTypescharacterLinkedFieldFormatsX(70)ViewerLinkedWidgetsfiViewerPathColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOFieldNameviewer_object_nameDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_viewlookup ).
       RUN repositionObject IN h_viewlookup ( 3.10 , 33.00 ) NO-ERROR.
       RUN resizeObject IN h_viewlookup ( 1.00 , 51.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.object_filenameFieldLabelBrowse NameFieldTooltipBrowser to display on folder page (no path)KeyFormatX(70)KeyDatatypecharacterDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object_type NO-LOCK
                     WHERE gsc_object_type.object_type_code = "DynBrow" OR
                     gsc_object_type.object_type_code = "StaticSDB" OR
                     gsc_object_type.object_type_code = "SmartBrowser",
                     EACH ryc_smartobject NO-LOCK
                     WHERE ryc_smartobject.OBJECT_type_obj = gsc_object_type.OBJECT_type_obj,
                     FIRST gsc_object NO-LOCK
                     WHERE gsc_object.OBJECT_obj = ryc_smartobject.OBJECT_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj
                     BY ryc_smartobject.OBJECT_filenameQueryTablesgsc_object_type,ryc_smartobject,gsc_object,gsc_product_moduleBrowseFieldsgsc_product_module.product_module_code,ryc_smartobject.object_filename,gsc_object_type.object_type_code,gsc_object.object_description,gsc_object.object_pathBrowseFieldDataTypescharacter,character,character,character,characterBrowseFieldFormatsX(10),X(70),X(15),X(35),X(70)RowsToBatch200BrowseTitleLookup BrowserViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOFieldNamebrowser_object_nameDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_browlookup ).
       RUN repositionObject IN h_browlookup ( 8.52 , 33.00 ) NO-ERROR.
       RUN resizeObject IN h_browlookup ( 1.00 , 51.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.object_filenameFieldLabelData Object NameFieldTooltipSpecify Data Object for data source of browser (no path)KeyFormatX(70)KeyDatatypecharacterDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object_type NO-LOCK
                     WHERE gsc_object_type.object_type_code = "SDO" OR gsc_object_type.object_type_code = "SBO",
                     EACH ryc_smartobject NO-LOCK
                     WHERE ryc_smartobject.OBJECT_type_obj = gsc_object_type.OBJECT_type_obj,
                     FIRST gsc_object NO-LOCK
                     WHERE gsc_object.OBJECT_obj = ryc_smartobject.OBJECT_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj
                     BY ryc_smartobject.OBJECT_filenameQueryTablesgsc_object_type,ryc_smartobject,gsc_object,gsc_product_moduleBrowseFieldsgsc_product_module.product_module_code,gsc_object_type.object_type_code,ryc_smartobject.object_filename,gsc_object.object_description,gsc_object.object_pathBrowseFieldDataTypescharacter,character,character,character,characterBrowseFieldFormatsX(10),X(15),X(70),X(35),X(70)RowsToBatch200BrowseTitleLookup Data ObjectViewerLinkedFieldsgsc_object_type.object_type_code,gsc_object.object_pathLinkedFieldDataTypescharacter,characterLinkedFieldFormatsX(15),X(70)ViewerLinkedWidgetsfiObjectType,fiObjectPathColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOFieldNamesdo_object_nameDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_sdolookup ).
       RUN repositionObject IN h_sdolookup ( 10.62 , 32.80 ) NO-ERROR.
       RUN resizeObject IN h_sdolookup ( 1.00 , 51.40 ) NO-ERROR.

       RUN constructObject (
             INPUT  'ry/obj/rysbodatfv.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'FieldNamequery_sdo_nameDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_rysbodatfv ).
       RUN repositionObject IN h_rysbodatfv ( 12.76 , 12.20 ) NO-ERROR.
       RUN resizeObject IN h_rysbodatfv ( 1.10 , 72.60 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.object_filenameFieldLabelParent SDO NameFieldTooltipSpecify Parent SDO to link SDO to (no path)KeyFormatX(70)KeyDatatypecharacterDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object_type NO-LOCK
                     WHERE gsc_object_type.object_type_code = "SDO",
                     EACH ryc_smartobject NO-LOCK
                     WHERE ryc_smartobject.OBJECT_type_obj = gsc_object_type.OBJECT_type_obj,
                     FIRST gsc_object NO-LOCK
                     WHERE gsc_object.OBJECT_obj = ryc_smartobject.OBJECT_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj
                     BY ryc_smartobject.OBJECT_filenameQueryTablesgsc_object_type,ryc_smartobject,gsc_object,gsc_product_moduleBrowseFieldsgsc_product_module.product_module_code,ryc_smartobject.object_filename,gsc_object_type.object_type_code,gsc_object.object_descriptionBrowseFieldDataTypescharacter,character,character,characterBrowseFieldFormatsX(10),X(70),X(15),X(35)RowsToBatch200BrowseTitleLookup Parent SDOViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOFieldNameparent_sdo_object_nameDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_parentsdolookup ).
       RUN repositionObject IN h_parentsdolookup ( 14.91 , 33.00 ) NO-ERROR.
       RUN resizeObject IN h_parentsdolookup ( 1.00 , 51.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'ry/obj/ryclacsdfv.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'FieldNamepage_layoutDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_ryclacsdfv ).
       RUN repositionObject IN h_ryclacsdfv ( 17.00 , 24.40 ) NO-ERROR.
       RUN resizeObject IN h_ryclacsdfv ( 1.10 , 60.60 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_viewlookup ,
             fiViewerPath:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_browlookup ,
             RowObject.viewer_update_target_names:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_sdolookup ,
             RowObject.browser_toolbar_parent_menu:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_rysbodatfv ,
             fiObjectType:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_parentsdolookup ,
             RowObject.sdo_foreign_fields:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_ryclacsdfv ,
             RowObject.window_title_field:HANDLE IN FRAME frMain , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

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

  /* Destoy any running SBO and SDV */
  IF VALID-HANDLE(ghSBO) THEN
    RUN destroyObject IN ghSBO.
  IF VALID-HANDLE(ghSDV) THEN
    RUN destroyObject IN ghSDV.

  RUN SUPER.

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

DEFINE VARIABLE cMode               AS CHARACTER    NO-UNDO.
DEFINE VARIABLE hContainerSource    AS HANDLE       NO-UNDO.


  RUN SUPER( INPUT pcColValues).

  /* When the Data Object type is SBO then the Query SDO SmartDataField
     needs to be enabled, otherwise it is disabled */
  IF VALID-HANDLE(h_rysbodatfv) THEN
  DO:
    hContainerSource = DYNAMIC-FUNCTION('getContainerSource':U).
    cMode = DYNAMIC-FUNCTION('getContainerMode':U IN hContainerSource).
    IF fiObjectType:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'SBO':U THEN
    DO:
      IF cMode = 'Modify':U THEN RUN enableField IN h_rysbodatfv.
    END.  /* if SBO */
    ELSE RUN disableField IN h_rysbodatfv.
  END.  /* if valid-handle */

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
DEFINE VARIABLE cViewerName AS CHARACTER    NO-UNDO.

  RUN SUPER.

  /* When the fields are first enabled, we need to enable or disable the 
     Query SDO SmartDataField depending on the Data Object Type */
  IF fiObjectType:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'SBO':U THEN 
    RUN enableField IN h_rysbodatfv.
  ELSE RUN disableField IN h_rysbodatfv.

  /* When the fields are first enabled, we need to run the SDV to get 
     DisplayedTables to determine how to enable the viewer_data_source field */
  cViewerName = DYNAMIC-FUNCTION('getDataValue':U IN h_viewlookup).
  IF cViewerName NE '':U THEN
  DO:
    RUN startSDV.  
    IF gcDisplayedTables NE 'RowObject':U AND 
       gcDisplayedTables NE '':U AND 
       gcDisplayedTables NE ? THEN
      ASSIGN
        RowObject.viewer_data_source_names:SENSITIVE = FALSE.
  END.  /* if Viewer */
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
  SUBSCRIBE TO "lookupDisplayComplete":U IN THIS-PROCEDURE.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE lookupComplete vTableWin 
PROCEDURE lookupComplete :
/*------------------------------------------------------------------------------
  Purpose:     Fired on leave or change of one of the lookups
  Parameters:  See below
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcFieldNames           AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcFieldValues          AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcKeyFieldValue        AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcNewScreenValue       AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcOldScreenValue       AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER plBrowseUsed           AS LOGICAL    NO-UNDO.
DEFINE INPUT PARAMETER phLookup               AS HANDLE     NO-UNDO.

DEFINE VARIABLE cBrowser                      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cViewer                       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cContainerMode                AS CHARACTER    NO-UNDO.
DEFINE VARIABLE hContainerSource              AS HANDLE       NO-UNDO.


/* viewer or browser lookup */
IF (phLookup = h_viewlookup OR phLookup = h_browlookup) THEN
DO:
  cBrowser = DYNAMIC-FUNCTION("getDataValue":U IN h_browlookup). 
  cViewer  = DYNAMIC-FUNCTION("getDataValue":U IN h_viewlookup). 
  IF cBrowser = ? OR cBrowser = "?":U THEN ASSIGN cBrowser = "":U.
  IF cViewer = ? OR cViewer = "?":U THEN ASSIGN cViewer = "":U.

  IF cBrowser <> "":U AND cViewer <> "":U THEN
  DO:
    DYNAMIC-FUNCTION("setDataValue":U IN h_ryclacsdfv, INPUT "Top/Multi/Bottom":U).
  END.
  ELSE
  DO:
    DYNAMIC-FUNCTION("setDataValue":U IN h_ryclacsdfv, INPUT "Top/Center/Bottom":U).
  END.
END.

IF phLookup = h_viewlookup THEN
DO WITH FRAME {&FRAME-NAME}:

  IF cViewer = "":U THEN
    ASSIGN RowObject.link_viewer_to_sdo:SCREEN-VALUE = "NO":U.

  IF pcOldScreenValue <> pcNewScreenValue AND cViewer <> "":U THEN
    ASSIGN RowObject.link_viewer_to_sdo:SCREEN-VALUE = "YES":U.

END.

/* If Data Object Type is SBO then we need to start the SBO to get its SDOs to
   populate the Query SDO SmartDataField combo, and we enabled the SDF.  
   Otherwise (not SBO) we populate the combo with nothing and set data modified
   in the SDF to TRUE. */
IF phLookup = h_sdolookup THEN
DO:
  IF fiObjectType:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'SBO':U THEN
    RUN enableField IN h_rysbodatfv.
  ELSE DO:
    RUN populateCombo IN h_rysbodatfv (INPUT '':U, INPUT '':U).
    DYNAMIC-FUNCTION('setDataModified':U IN h_rysbodatfv, INPUT TRUE).
    RUN disableField IN h_rysbodatfv.
    IF VALID-HANDLE(ghSBO) THEN
      RUN destroyObject IN ghSBO.
    ASSIGN gcSBOName = '':U.
  END.  /* else do */
END.  /* if sdolookup */

/* If a viewer is specified then the viewer is run to get its DisplayedTables */
IF phLookup = h_viewlookup THEN
DO WITH FRAME {&FRAME-NAME}:
  hContainerSource = DYNAMIC-FUNCTION('getContainerSource':U).
  cContainerMode = DYNAMIC-FUNCTION('getContainerMode':U IN hContainerSource).
  IF cContainerMode NE 'View':U THEN
  DO:
    IF pcKeyFieldValue NE '':U THEN
    DO:
      /* startSDV runs the viewer and gets its DisplayedTables and stores it in
         global variable gcDisplayedTables.  

         In the following cases we want to enable the data_source and
         update_target name fields and set them to blank:

         - If gcDisplayedTables is RowObject then the viewer was built against 
           an SDO
         - If gcDisplayedTables is ? or '' 

         If gcDisplayedTables is not RowObject and has a value, the viewer was
         built against an SBO and the data_source_name field is disabled and
         the values of both the data_source and update_target names fields are
         set to gcDisplayedTables */
      RUN startSDV.
      IF gcDisplayedTables NE 'RowObject':U AND
         gcDisplayedTables NE '':U AND
         gcDisplayedTables NE ? THEN
        ASSIGN
          RowObject.viewer_data_source_names:SENSITIVE = FALSE
          RowObject.viewer_data_source_names:SCREEN-VALUE = gcDisplayedTables
          RowObject.viewer_update_target_names:SENSITIVE = TRUE
          RowObject.viewer_update_target_names:SCREEN-VALUE = gcDisplayedTables.
      ELSE DO:
        ASSIGN
          RowObject.viewer_data_source_names:SENSITIVE = TRUE
          RowObject.viewer_update_target_names:SENSITIVE = TRUE
          RowObject.viewer_data_source_names:SCREEN-VALUE = '':U
          RowObject.viewer_update_target_names:SCREEN-VALUE = '':U
          gcDisplayedTables = '':U.
      END.  /* else do */
    END.  /* if viewer not blank */
    /* If a viewer isn't specified then both data_source and update_target
       name fields are disabled and set to blank */
    ELSE
      ASSIGN
        RowObject.viewer_data_source_names:SENSITIVE = FALSE
        RowObject.viewer_update_target_names:SENSITIVE = FALSE
        RowObject.viewer_data_source_names:SCREEN-VALUE = '':U
        RowObject.viewer_update_target_names:SCREEN-VALUE = '':U
        gcDisplayedTables = '':U.
  END.  /* if Modify mode */
END.  /* if viewlookup */

RETURN.
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
DEFINE INPUT PARAMETER pcFieldNames     AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcFieldValues    AS CHARACTER  NO-UNDO.  
DEFINE INPUT PARAMETER pcKeyFieldValue  AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER phLookup         AS HANDLE     NO-UNDO.

DEFINE VARIABLE cType               AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cContainerMode      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE hContainerSource    AS HANDLE       NO-UNDO.
DEFINE VARIABLE iNumFields          AS INTEGER      NO-UNDO.

  /* If a viewer is specified then the viewer is run to get its DisplayedTables */
  IF phLookup = h_viewlookup THEN
  DO:
    hContainerSource = DYNAMIC-FUNCTION('getContainerSource':U).
    cContainerMode = DYNAMIC-FUNCTION('getContainerMode':U IN hContainerSource).
    IF cContainerMode NE 'View':U THEN
    DO WITH FRAME {&FRAME-NAME}:
      IF pcKeyFieldValue NE '':U THEN
      DO:
        /* startSDV runs the viewer and gets its DisplayedTables and stores it in
           global variable gcDisplayedTables.  

           In the following cases we want to enable the data_source and
           update_target name fields:

           - If gcDisplayedTables is RowObject then the viewer was built against 
             an SDO
           - If gcDisplayedTables is ? or '' 

           If gcDisplayedTables is not RowObject and has a value, the viewer was
           built against an SBO and the data_source_name field is disabled */
        RUN startSDV.
        IF gcDisplayedTables NE 'RowObject':U AND
           gcDisplayedTables NE '':U AND
           gcDisplayedTables NE ? THEN
          ASSIGN
            RowObject.viewer_data_source_names:SENSITIVE = FALSE
            RowObject.viewer_update_target_names:SENSITIVE = TRUE.
        ELSE
          ASSIGN
            RowObject.viewer_data_source_names:SENSITIVE = TRUE
            RowObject.viewer_update_target_names:SENSITIVE = TRUE
            gcDisplayedTables = '':U.
      END.  /* if viewer not blank */
      /* If a viewer isn't specified then both data_source and update_target
         name fields are disabled and set to blank */
      ELSE
        ASSIGN
          RowObject.viewer_data_source_names:SENSITIVE = FALSE
          RowObject.viewer_update_target_names:SENSITIVE = FALSE.
    END.  /* if modify */
  END.  /* if viewlookup */

  /* Data Object Lookup */
  IF phLookup = h_sdolookup THEN
  DO:

    /* Determine the type of object this is, object_type is a linked field */
    FieldLoop:
    DO iNumFields = 1 TO NUM-ENTRIES(pcFieldNames):
      IF ENTRY(iNumFields, pcFieldNames) = 'gsc_object_type.object_type_code':U THEN
      DO:
        IF pcFieldValues NE '':U THEN
          cType = ENTRY(iNumFields, pcFieldValues, CHR(1)).
        LEAVE FieldLoop.
      END.  /* if object type */
    END.

    /* If the object type is SBO then start the SBO otherwise populate the combo
       with nothing */
    IF cType = 'SBO':U THEN
      RUN startSBO.
    ELSE DO:
      RUN populateCombo IN h_rysbodatfv (INPUT '':U, INPUT '':U).
      IF VALID-HANDLE(ghSBO) THEN
        RUN destroyObject IN ghSBO.
      ASSIGN gcSBOName = '':U.
    END.  /* else do */
  END.  /* if sdolookup */

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
  RUN "adm2\dynlookup.w *RTB-SmObj* ".
  RUN "ry\obj\rysbodatfv.w *RTB-SmObj* ".
  RUN "ry\obj\ryclacsdfv.w *RTB-SmObj* ".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startSBO vTableWin 
PROCEDURE startSBO :
/*------------------------------------------------------------------------------
  Purpose:     This procedure starts the SBO to get the SDO names for the Query
               SDO SmartDataField.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cSDONames       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cFileName       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cNewSBOName     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cPath           AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cQuerySDOName   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE hDataSource     AS HANDLE       NO-UNDO.

  /* Get info needed to figured out the filename */
  ASSIGN 
    hDataSource = DYNAMIC-FUNCTION('getDataSource':U)
    cPath = fiObjectPath:SCREEN-VALUE IN FRAME {&FRAME-NAME}
    cFileName = DYNAMIC-FUNCTION('getDataValue':U IN h_sdolookup)
    cQuerySDOName = DYNAMIC-FUNCTION('columnStringValue' IN hDataSource,
                                     INPUT 'query_SDO_name':U).

  cNewSBOName = cPath + '/':U + cFileName.

  /* If this SBO is not already running, destroy the one that is running (if 
     there is one running) and start this SBO */
  IF cNewSBOName NE gcSBOName THEN
  DO:
    IF VALID-HANDLE(ghSBO) THEN 
      RUN destroyObject IN ghSBO.

    DO ON STOP UNDO, LEAVE:
      RUN VALUE(cNewSBOName) PERSISTENT SET ghSBO NO-ERROR.
      RUN initializeObject IN ghSBO.
    END.  /* do on stop */

    /* Get the Data Object names from the SBO and populate the SDF combo 
       with them */
    cSDONames = DYNAMIC-FUNCTION('getDataObjectNames':U IN ghSBO).
    PUBLISH 'populateCombo':U (INPUT cSDONames, INPUT cQuerySDOName).
    gcSBOName = cNewSBOName.
  END.  /* if new SBO */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startSDV vTableWin 
PROCEDURE startSDV :
/*------------------------------------------------------------------------------
  Purpose:     This procedure starts the SDV to get the Displayed Tables to 
               default viewer_data_source_names and viewer_update_target_names 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cFileName           AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cNewViewerName      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cPath               AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cQuerySDOName       AS CHARACTER    NO-UNDO.

  /* Get info needed to figured out the filename */
  ASSIGN 
    cPath = fiViewerPath:SCREEN-VALUE IN FRAME {&FRAME-NAME}
    cFileName = DYNAMIC-FUNCTION('getDataValue':U IN h_viewlookup).

  cNewViewerName = cPath + '/':U + cFileName.

  /* If this SDV is not already running, destroy the one that is running (if 
     there is one running) and start this SDV */
  IF cNewViewerName NE gcViewerName THEN
  DO:
    gcDisplayedTables = '':U.
    IF VALID-HANDLE(ghSDV) THEN 
      RUN destroyObject IN ghSDV.

    DO ON STOP UNDO, LEAVE:
      RUN VALUE(cNewViewerName) PERSISTENT SET ghSDV NO-ERROR.
    END.  /* do on stop */

    IF VALID-HANDLE(ghSDV) THEN 
    DO:
      gcDisplayedTables = DYNAMIC-FUNCTION('getDisplayedTables':U IN ghSDV) NO-ERROR.
      gcViewerName = cNewViewerName.
    END.  /* if valid SDV */
  END.  /* if new SDV */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

