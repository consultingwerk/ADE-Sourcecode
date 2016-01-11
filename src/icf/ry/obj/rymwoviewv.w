&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          asdb             PROGRESS
          rydb             PROGRESS
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
       {"ry/obj/rymwofullo.i"}.


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
  File: rymwoviewv.w

  Description:  Wizard Object Controller Viewer

  Purpose:      Wizard Object Controller Viewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        6199   UserRef:    
                Date:   04/07/2000  Author:     Anthony Swindells

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

&scop object-name       rymwoviewv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010001

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{af/sup2/afglobals.i}

DEFINE VARIABLE gcSBOName   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE ghSBO       AS HANDLE       NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "ry/obj/rymwofullo.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.object_name ~
RowObject.object_description RowObject.window_title ~
RowObject.window_title_field RowObject.sdo_foreign_fields ~
RowObject.browser_toolbar_parent_menu 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define DISPLAYED-FIELDS RowObject.object_name ~
RowObject.object_description RowObject.window_title ~
RowObject.window_title_field RowObject.sdo_foreign_fields ~
RowObject.browser_toolbar_parent_menu RowObject.generated_date ~
RowObject.generated_time_str 
&Scoped-Define DISPLAYED-OBJECTS fiObjectType 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_browlookup AS HANDLE NO-UNDO.
DEFINE VARIABLE h_contlookup AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gscpmcsdfv AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gscprcsdfv AS HANDLE NO-UNDO.
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
     SIZE 46 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     RowObject.object_name AT ROW 3.19 COL 26.2 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 46 BY 1 TOOLTIP "Specify a unique name for the object (no path or extension)"
     RowObject.object_description AT ROW 4.19 COL 26.2 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 46 BY 1 TOOLTIP "Specify description for object as it should appear on a menu"
     RowObject.window_title AT ROW 5.19 COL 26.2 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 46 BY 1 TOOLTIP "Specify window title for object controller"
     RowObject.window_title_field AT ROW 6.19 COL 26.2 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 46 BY 1 TOOLTIP "Fieldname from SDO to add to window title to identify parent record"
     fiObjectPath AT ROW 7.76 COL 2.6
     fiObjectType AT ROW 8.33 COL 26.2 COLON-ALIGNED
     RowObject.sdo_foreign_fields AT ROW 10.43 COL 26.2 COLON-ALIGNED FORMAT "X(500)"
          VIEW-AS FILL-IN 
          SIZE 46 BY 1 TOOLTIP "Foreign field pairs for SDO - child (dbprefix),parent (no dbprefix), etc."
     RowObject.browser_toolbar_parent_menu AT ROW 13.67 COL 26.2 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 46 BY 1
     RowObject.generated_date AT ROW 16.95 COL 26.2 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19 BY 1
     RowObject.generated_time_str AT ROW 18.05 COL 26.2 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19 BY 1
     SPACE(28.20) SKIP(0.00)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "ry/obj/rymwofullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {ry/obj/rymwofullo.i}
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
         HEIGHT             = 18.24
         WIDTH              = 77.
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

/* SETTINGS FOR FILL-IN fiObjectPath IN FRAME frMain
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       fiObjectPath:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN fiObjectType IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN RowObject.generated_date IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       RowObject.generated_date:READ-ONLY IN FRAME frMain        = TRUE.

/* SETTINGS FOR FILL-IN RowObject.generated_time_str IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       RowObject.generated_time_str:READ-ONLY IN FRAME frMain        = TRUE.

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





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME RowObject.object_description
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.object_description vTableWin
ON LEAVE OF RowObject.object_description IN FRAME frMain /* Object Description */
DO:
  IF RowObject.WINDOW_title:SCREEN-VALUE = "":U THEN
    ASSIGN RowObject.WINDOW_title:SCREEN-VALUE = SELF:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject.window_title
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.window_title vTableWin
ON LEAVE OF RowObject.window_title IN FRAME frMain /* Window Title */
DO:
    IF RowObject.OBJECT_description:SCREEN-VALUE = "":U THEN
    ASSIGN RowObject.OBJECT_description:SCREEN-VALUE = SELF:SCREEN-VALUE.
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

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  IF VALID-HANDLE(h_ryclacsdfv) THEN
  DO:
    DYNAMIC-FUNCTION("setDataValue":U IN h_ryclacsdfv, INPUT "Top/Center/Bottom":U).
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
             INPUT  'ry/obj/gscprcsdfv.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'FieldNameproduct_codeDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_gscprcsdfv ).
       RUN repositionObject IN h_gscprcsdfv ( 1.00 , 19.40 ) NO-ERROR.
       RUN resizeObject IN h_gscprcsdfv ( 1.10 , 56.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'ry/obj/gscpmcsdfv.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'FieldNameproduct_module_codeDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_gscpmcsdfv ).
       RUN repositionObject IN h_gscpmcsdfv ( 2.05 , 11.80 ) NO-ERROR.
       RUN resizeObject IN h_gscpmcsdfv ( 1.10 , 63.60 ) NO-ERROR.

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
                     BY ryc_smartobject.OBJECT_filenameQueryTablesgsc_object_type,ryc_smartobject,gsc_object,gsc_product_moduleBrowseFieldsgsc_product_module.product_module_code,gsc_object_type.object_type_code,ryc_smartobject.object_filename,gsc_object.object_description,gsc_object.object_pathBrowseFieldDataTypescharacter,character,character,character,characterBrowseFieldFormatsX(10),X(15),X(70),X(35),X(70)RowsToBatch200BrowseTitleLookup Data ObjectViewerLinkedFieldsgsc_object_type.object_type_code,gsc_object.object_pathLinkedFieldDataTypescharacter,characterLinkedFieldFormatsX(15),X(70)ViewerLinkedWidgetsfiObjectType,fiObjectPathFieldNamesdo_nameDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_sdolookup ).
       RUN repositionObject IN h_sdolookup ( 7.29 , 28.20 ) NO-ERROR.
       RUN resizeObject IN h_sdolookup ( 1.00 , 46.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'ry/obj/rysbodatfv.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'FieldNamequery_sdo_nameDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_rysbodatfv ).
       RUN repositionObject IN h_rysbodatfv ( 9.38 , 7.60 ) NO-ERROR.
       RUN resizeObject IN h_rysbodatfv ( 1.10 , 67.80 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.object_filenameFieldLabelViewer Object NameFieldTooltipViewer to display above browser if required (no path)KeyFormatX(70)KeyDatatypecharacterDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object_type NO-LOCK
                     WHERE gsc_object_type.object_type_code MATCHES "*SDV*",
                     EACH ryc_smartobject NO-LOCK
                     WHERE ryc_smartobject.OBJECT_type_obj = gsc_object_type.OBJECT_type_obj,
                     FIRST gsc_object NO-LOCK
                     WHERE gsc_object.OBJECT_obj = ryc_smartobject.OBJECT_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj
                     BY ryc_smartobject.OBJECT_filenameQueryTablesgsc_object_type,ryc_smartobject,gsc_object,gsc_product_moduleBrowseFieldsgsc_product_module.product_module_code,ryc_smartobject.object_filename,gsc_object_type.object_type_code,gsc_object.object_descriptionBrowseFieldDataTypescharacter,character,character,characterBrowseFieldFormatsX(10),X(70),X(15),X(35)RowsToBatch200BrowseTitleLookup ViewerViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsFieldNameviewer_nameDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_viewlookup ).
       RUN repositionObject IN h_viewlookup ( 11.48 , 28.20 ) NO-ERROR.
       RUN resizeObject IN h_viewlookup ( 1.00 , 46.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.object_filenameFieldLabelBrowse NameFieldTooltipBrowser to display on object controller (no path)KeyFormatX(70)KeyDatatypecharacterDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object_type NO-LOCK
                     WHERE gsc_object_type.object_type_code = "DynBrow" OR
                     gsc_object_type.object_type_code = "StaticSDB" OR
                     gsc_object_type.object_type_code = "SmartBrowser",
                     EACH ryc_smartobject NO-LOCK
                     WHERE ryc_smartobject.OBJECT_type_obj = gsc_object_type.OBJECT_type_obj,
                     FIRST gsc_object NO-LOCK
                     WHERE gsc_object.OBJECT_obj = ryc_smartobject.OBJECT_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj
                     BY ryc_smartobject.OBJECT_filenameQueryTablesgsc_object_type,ryc_smartobject,gsc_object,gsc_product_moduleBrowseFieldsgsc_product_module.product_module_code,ryc_smartobject.object_filename,gsc_object_type.object_type_code,gsc_object.object_description,gsc_object.object_pathBrowseFieldDataTypescharacter,character,character,character,characterBrowseFieldFormatsX(10),X(70),X(15),X(35),X(70)RowsToBatch200BrowseTitleLookup BrowserViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsFieldNamebrowser_nameDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_browlookup ).
       RUN repositionObject IN h_browlookup ( 12.62 , 28.20 ) NO-ERROR.
       RUN resizeObject IN h_browlookup ( 1.00 , 46.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_object.object_filenameKeyFieldgsc_object.object_filenameFieldLabelLaunch ContainerFieldTooltipContainer to launch for browse actions (no path)KeyFormatX(35)KeyDatatypecharacterDisplayFormatX(35)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object NO-LOCK
                     WHERE gsc_object.runnable_from_menu = YES,
                     FIRST ryc_smartobject NO-LOCK
                     WHERE ryc_smartobject.OBJECT_obj = gsc_object.OBJECT_obj
                     AND ryc_smartobject.OBJECT_type_obj = gsc_object.OBJECT_type_obj,
                     FIRST gsc_object_type NO-LOCK
                     WHERE gsc_object_type.OBJECT_type_obj = ryc_smartobject.OBJECT_type_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj
                     BY ryc_smartobject.OBJECT_filenameQueryTablesgsc_object,ryc_smartobject,gsc_object_type,gsc_product_moduleBrowseFieldsgsc_product_module.product_module_code,gsc_object.object_filename,gsc_object_type.object_type_code,gsc_object.object_description,ryc_smartobject.static_objectBrowseFieldDataTypescharacter,character,character,character,logicalBrowseFieldFormatsX(10),X(35),X(15),X(35),YES/NORowsToBatch200BrowseTitleLookup Launch ContainerViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsFieldNamelaunch_containerDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_contlookup ).
       RUN repositionObject IN h_contlookup ( 14.71 , 28.20 ) NO-ERROR.
       RUN resizeObject IN h_contlookup ( 1.00 , 46.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'ry/obj/ryclacsdfv.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'FieldNamepage_layoutDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_ryclacsdfv ).
       RUN repositionObject IN h_ryclacsdfv ( 15.86 , 19.80 ) NO-ERROR.
       RUN resizeObject IN h_ryclacsdfv ( 1.10 , 55.60 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_gscprcsdfv ,
             RowObject.object_name:HANDLE IN FRAME frMain , 'BEFORE':U ).
       RUN adjustTabOrder ( h_gscpmcsdfv ,
             h_gscprcsdfv , 'AFTER':U ).
       RUN adjustTabOrder ( h_sdolookup ,
             RowObject.window_title_field:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_rysbodatfv ,
             fiObjectType:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_viewlookup ,
             RowObject.sdo_foreign_fields:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_browlookup ,
             h_viewlookup , 'AFTER':U ).
       RUN adjustTabOrder ( h_contlookup ,
             RowObject.browser_toolbar_parent_menu:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_ryclacsdfv ,
             h_contlookup , 'AFTER':U ).
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

  IF VALID-HANDLE(ghSBO) THEN
    RUN destroyObject IN ghSBO.

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
  hContainerSource = DYNAMIC-FUNCTION('getContainerSource':U).
  cMode = DYNAMIC-FUNCTION('getContainerMode':U IN hContainerSource).
  IF fiObjectType:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'SBO':U THEN
  DO:
    IF cMode = 'Modify':U THEN RUN enableField IN h_rysbodatfv.
  END.  /* if SBO */
  ELSE RUN disableField IN h_rysbodatfv.

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

  RUN SUPER.

  /* When the fields are first enabled, we need to enable or disable the 
     Query SDO SmartDataField depending on the Data Object Type */
  IF fiObjectType:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'SBO':U THEN 
    RUN enableField IN h_rysbodatfv.
  ELSE RUN disableField IN h_rysbodatfv.

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
DEFINE INPUT PARAMETER pcFieldNames                 AS CHARACTER   NO-UNDO.
DEFINE INPUT PARAMETER pcFieldValues                AS CHARACTER   NO-UNDO.
DEFINE INPUT PARAMETER pcKeyFieldValue              AS CHARACTER   NO-UNDO.
DEFINE INPUT PARAMETER pcNewScreenValue             AS CHARACTER   NO-UNDO.
DEFINE INPUT PARAMETER pcOldScreenValue             AS CHARACTER   NO-UNDO.
DEFINE INPUT PARAMETER plBrowseUsed                 AS LOGICAL     NO-UNDO.
DEFINE INPUT PARAMETER phLookup                     AS HANDLE      NO-UNDO.

/* Viewer lookup */
IF phLookup = h_viewlookup THEN
DO:
  IF LENGTH(pcNewScreenValue) > 0 AND VALID-HANDLE(h_ryclacsdfv) THEN
  /* If viewer specified, default layout to top/multi/bottom */
  DO:
    DYNAMIC-FUNCTION("setDataValue":U IN h_ryclacsdfv, INPUT "Top/Multi/Bottom":U).
  END.
  ELSE IF pcNewScreenValue <> pcOldScreenValue THEN
  /* If no viewer specified, default layout to top/center/bottom */
  DO:
    DYNAMIC-FUNCTION("setDataValue":U IN h_ryclacsdfv, INPUT "Top/Center/Bottom":U).
  END.
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

DEFINE VARIABLE cType       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iNumFields  AS INTEGER      NO-UNDO.

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
  RUN "ry\obj\ryclacsdfv.w *RTB-SmObj* ".
  RUN "ry\obj\rysbodatfv.w *RTB-SmObj* ".
  RUN "ry\obj\gscprcsdfv.w *RTB-SmObj* ".
  RUN "ry\obj\gscpmcsdfv.w *RTB-SmObj* ".

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

