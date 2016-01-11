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
       {"ry/obj/rymwtfullo.i"}.


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
  File: rymwtviewv.w

  Description:  Tree Wizard SmartDataViewer

  Purpose:      Tree Wizard SmartDataViewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000164   UserRef:    
                Date:   19/07/2001  Author:     Mark Davies

  Update Notes: Created from Template rysttviewv.w
                Tree Wizard SmartDataViewer

  (v:010001)    Task:   101000019   UserRef:    
                Date:   08/23/2001  Author:     Mark Davies

  Update Notes: Remove comboEntry subscribe and procedure.

--------------------------------------------------------------------------------*/
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

&scop object-name       rymwtviewv.w
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
&Scoped-define DATA-FIELD-DEFS "ry/obj/rymwtfullo.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.object_name ~
RowObject.object_description RowObject.window_title ~
RowObject.window_title_field RowObject.root_node_sdo_name ~
RowObject.sdo_foreign_fields RowObject.custom_super_procedure ~
RowObject.tree_style RowObject.auto_sort RowObject.hide_selection ~
RowObject.show_check_boxes RowObject.show_root_lines RowObject.image_height ~
RowObject.image_width 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-Define ENABLED-OBJECTS coTreeStyle 
&Scoped-Define DISPLAYED-FIELDS RowObject.object_name ~
RowObject.object_description RowObject.window_title ~
RowObject.window_title_field RowObject.root_node_sdo_name ~
RowObject.sdo_foreign_fields RowObject.custom_super_procedure ~
RowObject.tree_style RowObject.auto_sort RowObject.hide_selection ~
RowObject.show_check_boxes RowObject.show_root_lines RowObject.image_height ~
RowObject.image_width RowObject.generated_date RowObject.generated_time 
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define DISPLAYED-OBJECTS coTreeStyle fiGeneratedTimeStr 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_dynlookup AS HANDLE NO-UNDO.
DEFINE VARIABLE h_product AS HANDLE NO-UNDO.
DEFINE VARIABLE h_product_module AS HANDLE NO-UNDO.
DEFINE VARIABLE h_RootNodeCode AS HANDLE NO-UNDO.
DEFINE VARIABLE h_ryclacsdfv AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE coTreeStyle AS CHARACTER 
     LABEL "Tree Style" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Text only","0",
                     "Pictures & Text","1",
                     "Text only (Plus/Minus)","2",
                     "Pictures & Text (Plus/Minus)","3",
                     "Text only with tree lines","4",
                     "Pictures & Text with tree lines","5",
                     "Text only with tree lines & plus/minus","6",
                     "Pictures & text with tree lines & plus/minus","7"
     DROP-DOWN
     SIZE 45 BY 1 NO-UNDO.

DEFINE VARIABLE fiGeneratedTimeStr AS CHARACTER FORMAT "X(10)":U 
     LABEL "Generated Time" 
     VIEW-AS FILL-IN 
     SIZE 19 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     RowObject.object_name AT ROW 3.1 COL 25.8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 45 BY 1
     RowObject.object_description AT ROW 4.14 COL 25.8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 45 BY 1
     RowObject.window_title AT ROW 5.19 COL 25.8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 45 BY 1
     RowObject.window_title_field AT ROW 6.24 COL 25.8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 45 BY 1
     RowObject.root_node_sdo_name AT ROW 8.33 COL 27.8 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 70 SCROLLBAR-VERTICAL
          SIZE 44.8 BY 1
     RowObject.sdo_foreign_fields AT ROW 9.38 COL 27.8 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 70 SCROLLBAR-VERTICAL
          SIZE 44.8 BY 2
     RowObject.custom_super_procedure AT ROW 11.43 COL 25.8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 45 BY 1
     coTreeStyle AT ROW 14.57 COL 25.8 COLON-ALIGNED
     RowObject.tree_style AT ROW 15.57 COL 63 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.6 BY 1
     RowObject.auto_sort AT ROW 15.67 COL 27.8
          VIEW-AS TOGGLE-BOX
          SIZE 13.8 BY .81
     RowObject.hide_selection AT ROW 16.38 COL 27.8
          VIEW-AS TOGGLE-BOX
          SIZE 18.8 BY .81
     RowObject.show_check_boxes AT ROW 17.14 COL 27.8
          VIEW-AS TOGGLE-BOX
          SIZE 23.6 BY .81
     RowObject.show_root_lines AT ROW 17.86 COL 27.8
          VIEW-AS TOGGLE-BOX
          SIZE 21.2 BY .81
     RowObject.image_height AT ROW 18.71 COL 25.8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY 1
     RowObject.image_width AT ROW 19.76 COL 25.8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY 1
     RowObject.generated_date AT ROW 20.91 COL 25.8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19 BY 1
     RowObject.generated_time AT ROW 21.91 COL 25.8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19 BY 1
     fiGeneratedTimeStr AT ROW 21.91 COL 25.8 COLON-ALIGNED
     "Root Node SDO/SBO:" VIEW-AS TEXT
          SIZE 22 BY .62 AT ROW 8.52 COL 5.8
     "Foreign Fields:" VIEW-AS TEXT
          SIZE 13.6 BY .62 AT ROW 9.48 COL 14.2
     SPACE(50.00) SKIP(4.42)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "ry/obj/rymwtfullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {ry/obj/rymwtfullo.i}
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
         HEIGHT             = 22.29
         WIDTH              = 76.8.
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

/* SETTINGS FOR FILL-IN fiGeneratedTimeStr IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN RowObject.generated_date IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       RowObject.generated_date:PRIVATE-DATA IN FRAME frMain     = 
                "NOLOOKUPS".

/* SETTINGS FOR FILL-IN RowObject.generated_time IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       RowObject.generated_time:HIDDEN IN FRAME frMain           = TRUE
       RowObject.generated_time:PRIVATE-DATA IN FRAME frMain     = 
                "NOLOOKUPS".

ASSIGN 
       RowObject.tree_style:HIDDEN IN FRAME frMain           = TRUE
       RowObject.tree_style:PRIVATE-DATA IN FRAME frMain     = 
                "NOLOOKUPS".

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

&Scoped-define SELF-NAME coTreeStyle
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coTreeStyle vTableWin
ON VALUE-CHANGED OF coTreeStyle IN FRAME frMain /* Tree Style */
DO:
  ASSIGN coTreeStyle.
  ASSIGN RowObject.tree_style:SCREEN-VALUE = coTreeStyle.
  RowObject.tree_style:MODIFIED = TRUE.
  {set DataModified TRUE}.
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
  
  IF VALID-HANDLE(h_ryclacsdfv) THEN
  DO:
    DYNAMIC-FUNCTION("setDataValue":U IN h_ryclacsdfv, INPUT "TreeView":U).
  END.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN RowObject.image_height:SCREEN-VALUE   = "16":U
           RowObject.image_width:SCREEN-VALUE    = "16":U
           RowObject.show_root_lines:CHECKED     = TRUE
           RowObject.generated_date:SCREEN-VALUE = STRING(TODAY,RowObject.generated_date:FORMAT)
           Rowobject.generated_time:SCREEN-VALUE = STRING(TIME).
  END.

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    fiGeneratedTimeStr:SCREEN-VALUE = STRING(INTEGER(RowObject.generated_time:SCREEN-VALUE),"HH:MM:SS":U).
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
             INPUT  'DisplayedFieldgsc_product.product_code,gsc_product.product_descriptionKeyFieldgsc_product.product_codeFieldLabelProduct CodeFieldTooltipSelect option from listKeyFormatX(10)KeyDatatypecharacterDisplayFormatX(10)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_product
                           WHERE [EXCLUDE_REPOSITORY_PRODUCTS] NO-LOCK
                         BY ICFDB.gsc_product.product_codeQueryTablesgsc_productSDFFileNameSDFTemplateParentFieldParentFilterQueryDescSubstitute&1 / &2CurrentKeyValueComboDelimiterListItemPairsCurrentDescValueInnerLines5ComboFlagFlagValueBuildSequence1SecurednoCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesFieldNameproduct_codeDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_product ).
       RUN repositionObject IN h_product ( 1.00 , 27.80 ) NO-ERROR.
       RUN resizeObject IN h_product ( 1.00 , 50.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dyncombo.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_product_module.product_module_code,gsc_product_module.product_module_descriptionKeyFieldgsc_product_module.product_module_codeFieldLabelProduct Module CodeFieldTooltipSelect a Product ModuleKeyFormatX(10)KeyDatatypecharacterDisplayFormatX(256)DisplayDatatypeCHARACTERBaseQueryStringFOR EACH gsc_product NO-LOCK,
                     EACH gsc_product_module NO-LOCK WHERE gsc_product_module.product_obj = gsc_product.product_obj
                     BY gsc_product_module.product_module_codeQueryTablesgsc_product,gsc_product_moduleSDFFileNameSDFTemplateParentFieldproduct_codeParentFilterQuerygsc_product.product_code = ~'&1~'DescSubstitute&1 / &2CurrentKeyValueComboDelimiterListItemPairsCurrentDescValueInnerLines0ComboFlagFlagValueBuildSequence1SecurednoCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesFieldNameproduct_module_codeDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_product_module ).
       RUN repositionObject IN h_product_module ( 2.05 , 27.80 ) NO-ERROR.
       RUN resizeObject IN h_product_module ( 1.00 , 50.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsm_node.node_codeKeyFieldgsm_node.node_codeFieldLabelNode CodeFieldTooltipSelect the node that will serve as the root node for this TreeView objectKeyFormatX(10)KeyDatatypecharacterDisplayFormatX(10)DisplayDatatypecharacterBaseQueryStringFOR EACH gsm_node WHERE gsm_node.parent_node_obj = 0QueryTablesgsm_nodeBrowseFieldsgsm_node.node_code,gsm_node.node_description,gsm_node.node_labelBrowseFieldDataTypescharacter,character,characterBrowseFieldFormatsX(10),X(35),X(28)RowsToBatch200BrowseTitleRoot Node Code LookupViewerLinkedFieldsgsm_node.primary_sdoLinkedFieldDataTypescharacterLinkedFieldFormatsX(35)ViewerLinkedWidgetsRowObject.root_node_sdo_nameColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesFieldNameroot_node_codeDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_RootNodeCode ).
       RUN repositionObject IN h_RootNodeCode ( 7.29 , 27.80 ) NO-ERROR.
       RUN resizeObject IN h_RootNodeCode ( 1.00 , 50.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'ry/obj/ryclacsdfv.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'FieldNamepage_layoutDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_ryclacsdfv ).
       RUN repositionObject IN h_ryclacsdfv ( 12.48 , 19.20 ) NO-ERROR.
       RUN resizeObject IN h_ryclacsdfv ( 1.10 , 54.60 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.object_filenameFieldLabelFilter ViewerFieldTooltipEnter the name of the Root Node filter viewer objectKeyFormatX(70)KeyDatatypecharacterDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object_type NO-LOCK,
                     EACH ryc_smartobject NO-LOCK
                     WHERE ryc_smartobject.OBJECT_type_obj = gsc_object_type.OBJECT_type_obj
                     AND ryc_smartobject.container_object = FALSE,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj
                     BY ryc_smartobject.OBJECT_filenameQueryTablesgsc_object_type,ryc_smartobject,gsc_product_moduleBrowseFieldsgsc_product_module.product_module_code,ryc_smartobject.object_filename,gsc_object_type.object_type_codeBrowseFieldDataTypescharacter,character,characterBrowseFieldFormatsX(10),X(70),X(15)RowsToBatch200BrowseTitleFilter Viewer LookupViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesFieldNamefilter_viewerDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dynlookup ).
       RUN repositionObject IN h_dynlookup ( 13.52 , 27.80 ) NO-ERROR.
       RUN resizeObject IN h_dynlookup ( 1.00 , 50.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_product ,
             RowObject.object_name:HANDLE IN FRAME frMain , 'BEFORE':U ).
       RUN adjustTabOrder ( h_product_module ,
             h_product , 'AFTER':U ).
       RUN adjustTabOrder ( h_RootNodeCode ,
             RowObject.window_title_field:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_ryclacsdfv ,
             RowObject.custom_super_procedure:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_dynlookup ,
             h_ryclacsdfv , 'AFTER':U ).
    END. /* Page 0 */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayFields vTableWin 
PROCEDURE displayFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcColValues AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN coTreeStyle:SCREEN-VALUE = ENTRY(9,pcColValues,CHR(1))
           coTreeStyle:MODIFIED     = FALSE.
    fiGeneratedTimeStr:SCREEN-VALUE = STRING(INTEGER(RowObject.generated_time:SCREEN-VALUE),"HH:MM:SS":U).
  END.
  
  RUN SUPER( INPUT pcColValues).

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    fiGeneratedTimeStr:SCREEN-VALUE = STRING(INTEGER(RowObject.generated_time:SCREEN-VALUE),"HH:MM:SS":U).
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
  DO WITH FRAME {&FRAME-NAME}:
    RowObject.root_node_sdo_name:SCROLLBAR-VERTICAL = FALSE.
  END.
  
  SUBSCRIBE TO "lookupComplete" IN THIS-PROCEDURE.
  
  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

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
DEFINE INPUT PARAMETER pcFieldNames             AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER pcFieldValues            AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER pcKeyFieldValue  AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER pcNewScreenValue AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER pcOldScreenValue AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER plBrowseUsed             AS LOGICAL      NO-UNDO.
DEFINE INPUT PARAMETER phLookup         AS HANDLE       NO-UNDO. 

IF phLookup = h_RootNodeCode THEN DO WITH FRAME {&FRAME-NAME}:
  ASSIGN RowObject.root_node_sdo_name:SCREEN-VALUE = ENTRY(LOOKUP("gsm_node.primary_sdo",pcFieldNames),pcFieldValues,CHR(1)).
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
  RUN "adm2\dyncombo.w *RTB-SmObj* ".
  RUN "adm2\dynlookup.w *RTB-SmObj* ".
  RUN "ry\obj\ryclacsdfv.w *RTB-SmObj* ".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

