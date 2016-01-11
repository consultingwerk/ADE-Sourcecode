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
       {"af/obj2/gscobful2o.i"}.


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
                Added check not to set state to modified for logical_object when in view mode.

  (v:010003)    Task:           0   UserRef:    
                Date:   11/14/2001  Author:     Mark Davies (MIP)

  Update Notes: Disable object_filename when modifying.

------------------------------------------------------------------------------*/
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "af/obj2/gscobful2o.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.object_filename ~
RowObject.object_description RowObject.object_path RowObject.run_when ~
RowObject.logical_object 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define ENABLED-OBJECTS bu_find_object 
&Scoped-Define DISPLAYED-FIELDS RowObject.object_filename ~
RowObject.object_description RowObject.object_path RowObject.run_when ~
RowObject.object_obj RowObject.smartobject_obj RowObject.logical_object 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE hProduct AS HANDLE NO-UNDO.
DEFINE VARIABLE hProductModule AS HANDLE NO-UNDO.
DEFINE VARIABLE h_Layout AS HANDLE NO-UNDO.
DEFINE VARIABLE h_ObjectType AS HANDLE NO-UNDO.
DEFINE VARIABLE h_PhysicalObject AS HANDLE NO-UNDO.
DEFINE VARIABLE h_SDOName AS HANDLE NO-UNDO.
DEFINE VARIABLE h_SecurityObject AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bu_find_object 
     LABEL "Find O&bject..." 
     SIZE 15 BY 1 TOOLTIP "Find an object"
     BGCOLOR 8 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     RowObject.object_filename AT ROW 4.24 COL 18.6 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 53 BY 1
     bu_find_object AT ROW 4.24 COL 73.8 NO-TAB-STOP 
     RowObject.object_description AT ROW 5.24 COL 18.6 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 53 BY 1
     RowObject.object_path AT ROW 6.24 COL 18.6 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 53 BY 1
     RowObject.run_when AT ROW 7.24 COL 18.6 COLON-ALIGNED
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "Item 1","Item 1"
          DROP-DOWN-LIST
          SIZE 53.2 BY 1
     RowObject.object_obj AT ROW 13.1 COL 21.8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 2 BY 1
     RowObject.smartobject_obj AT ROW 13.14 COL 18.6 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 2 BY 1
     RowObject.logical_object AT ROW 12.24 COL 20.6
          VIEW-AS TOGGLE-BOX
          SIZE 18.6 BY .81
     SPACE(34.60) SKIP(0.00)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "af/obj2/gscobful2o.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {af/obj2/gscobful2o.i}
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
         HEIGHT             = 13.14
         WIDTH              = 87.8.
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

/* SETTINGS FOR FILL-IN RowObject.object_obj IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       RowObject.object_obj:HIDDEN IN FRAME frMain           = TRUE
       RowObject.object_obj:READ-ONLY IN FRAME frMain        = TRUE
       RowObject.object_obj:PRIVATE-DATA IN FRAME frMain     = 
                "NOLOOKUPS".

/* SETTINGS FOR FILL-IN RowObject.smartobject_obj IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       RowObject.smartobject_obj:HIDDEN IN FRAME frMain           = TRUE
       RowObject.smartobject_obj:READ-ONLY IN FRAME frMain        = TRUE
       RowObject.smartobject_obj:PRIVATE-DATA IN FRAME frMain     = 
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

&Scoped-define SELF-NAME frMain
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL frMain vTableWin
ON MOUSE-SELECT-DBLCLICK OF FRAME frMain
DO:
  MESSAGE RowObject.LOGICAL_object:MODIFIED.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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

    cRoot = IF  REPLACE(cFilename,"\":U,"/":U) BEGINS REPLACE(ENTRY(2,PROPATH),"\":U,"/":U) THEN
                REPLACE(ENTRY(2,PROPATH),"\":U,"/":U)
                ELSE REPLACE(ENTRY(1,PROPATH),"\":U,"/":U).

    IF  lOk THEN DO:
        ASSIGN
            cFile                                  = REPLACE(REPLACE(TRIM(LC(cFilename)),"\":U,"/":U),cRoot + "/":U,"":U)
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


&Scoped-define SELF-NAME RowObject.logical_object
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.logical_object vTableWin
ON VALUE-CHANGED OF RowObject.logical_object IN FRAME frMain /* Logical Object */
DO:
  DEFINE VARIABLE hGroupAssign  AS HANDLE   NO-UNDO.
  
  hGroupAssign = WIDGET-HANDLE(ENTRY(1,DYNAMIC-FUNCTION("linkHandles", "GroupAssign-Target":U))).
  
  IF gcMode = "View":U THEN
    RETURN NO-APPLY.
  IF NOT RowObject.logical_object:CHECKED THEN DO:
      DYNAMIC-FUNCTION("setDataValue":U IN h_PhysicalObject, INPUT "0").
      {set DataModified TRUE h_PhysicalObject}.
      RUN disableField IN h_PhysicalObject.
  END.
  ELSE
    IF RowObject.logical_object:SENSITIVE THEN
      RUN enableField IN h_PhysicalObject.

  IF RowObject.logical_object:SENSITIVE THEN DO:
    {set DataModified TRUE}.
    IF VALID-HANDLE(hGroupAssign) THEN
      RUN logicalObject IN hGroupAssign (INPUT RowObject.logical_object:CHECKED).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject.run_when
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.run_when vTableWin
ON VALUE-CHANGED OF RowObject.run_when IN FRAME frMain /* Run When */
DO:
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

  glEnableObjectName = TRUE.
  RUN SUPER.
  APPLY "VALUE-CHANGED":U TO RowObject.logical_object IN FRAME {&FRAME-NAME}.
  RUN valueChanged IN hProduct.
  /* Code placed here will execute AFTER standard behavior.    */

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
             INPUT  'DisplayedFieldgsc_product.product_code,gsc_product.product_descriptionKeyFieldgsc_product.product_objFieldLabelProductFieldTooltipSelect a Product from the listKeyFormat>>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(256)DisplayDatatypeCHARACTERBaseQueryStringFOR EACH gsc_product NO-LOCK INDEXED-REPOSITIONQueryTablesgsc_productSDFFileNameSDFTemplateParentFieldParentFilterQueryDescSubstitute&1 / &2CurrentKeyValueComboDelimiterListItemPairsCurrentDescValueInnerLines0ComboFlagFlagValueBuildSequence1SecurednoFieldNamedProductObjDisplayFieldyesEnableFieldyesHideOnInitDisableOnInitnoObjectLayout':U ,
             OUTPUT hProduct ).
       RUN repositionObject IN hProduct ( 1.00 , 20.60 ) NO-ERROR.
       RUN resizeObject IN hProduct ( 1.00 , 53.20 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dyncombo.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_product_module.product_module_code,gsc_product_module.product_module_descriptionKeyFieldgsc_product_module.product_module_objFieldLabelProduct ModuleFieldTooltipSelect a Product Module from the listKeyFormat>>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(256)DisplayDatatypeCHARACTERBaseQueryStringFOR EACH gsc_product_module NO-LOCK INDEXED-REPOSITIONQueryTablesgsc_product_moduleSDFFileNameSDFTemplateParentFielddProductObjParentFilterQuerygsc_product_module.product_obj = DECIMAL(~'&1~')DescSubstitute&1 / &2CurrentKeyValueComboDelimiterListItemPairsCurrentDescValueInnerLines0ComboFlagFlagValueBuildSequence1SecurednoFieldNameproduct_module_objDisplayFieldyesEnableFieldyesHideOnInitDisableOnInitnoObjectLayout':U ,
             OUTPUT hProductModule ).
       RUN repositionObject IN hProductModule ( 2.05 , 20.60 ) NO-ERROR.
       RUN resizeObject IN hProductModule ( 1.00 , 53.20 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dyncombo.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_object_type.object_type_code,gsc_object_type.object_type_descriptionKeyFieldgsc_object_type.object_type_objFieldLabelObject TypeFieldTooltipSelect this object~'s type.KeyFormat>>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(256)DisplayDatatypeCHARACTERBaseQueryStringFOR EACH gsc_object_type NO-LOCK BY gsc_object_type.object_type_code INDEXED-REPOSITIONQueryTablesgsc_object_typeSDFFileNameSDFTemplateParentFieldParentFilterQueryDescSubstitute&1 / &2CurrentKeyValueComboDelimiterListItemPairsCurrentDescValueInnerLines0ComboFlagFlagValueBuildSequence1SecurednoFieldNameobject_type_objDisplayFieldyesEnableFieldyesHideOnInitDisableOnInitnoObjectLayout':U ,
             OUTPUT h_ObjectType ).
       RUN repositionObject IN h_ObjectType ( 3.24 , 20.60 ) NO-ERROR.
       RUN resizeObject IN h_ObjectType ( 1.00 , 53.20 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dyncombo.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_layout.layout_code,ryc_layout.layout_nameKeyFieldryc_layout.layout_objFieldLabelLayoutFieldTooltipSelect the default layout for this object.KeyFormat>>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(256)DisplayDatatypeCHARACTERBaseQueryStringFOR EACH ryc_layout NO-LOCK BY ryc_layout.layout_code INDEXED-REPOSITIONQueryTablesryc_layoutSDFFileNameSDFTemplateParentFieldParentFilterQueryDescSubstitute&2 (&1)CurrentKeyValueComboDelimiterListItemPairsCurrentDescValueInnerLines0ComboFlagFlagValueBuildSequence1SecurednoFieldNamedLayoutObjDisplayFieldyesEnableFieldyesHideOnInitDisableOnInitnoObjectLayout':U ,
             OUTPUT h_Layout ).
       RUN repositionObject IN h_Layout ( 8.24 , 20.60 ) NO-ERROR.
       RUN resizeObject IN h_Layout ( 1.00 , 53.20 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.smartobject_objFieldLabelSDO NameFieldTooltipKeyFormat>>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object_type NO-LOCK
                     WHERE gsc_object_type.OBJECT_type_code = "SDO",
                     EACH ryc_smartobject NO-LOCK
                     WHERE ryc_smartobject.OBJECT_type_obj = gsc_object_type.OBJECT_type_obj INDEXED-REPOSITIONQueryTablesgsc_object_type,ryc_smartobjectBrowseFieldsryc_smartobject.object_filename,ryc_smartobject.template_smartobject,gsc_object_type.object_type_code,gsc_object_type.object_type_descriptionBrowseFieldDataTypescharacter,logical,character,characterBrowseFieldFormatsX(70),YES/NO,X(15),X(35)RowsToBatch200BrowseTitleLookup SDOViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOFieldNamedSDOSmartObjectDisplayFieldyesEnableFieldyesHideOnInitDisableOnInitnoObjectLayout':U ,
             OUTPUT h_SDOName ).
       RUN repositionObject IN h_SDOName ( 9.24 , 20.60 ) NO-ERROR.
       RUN resizeObject IN h_SDOName ( 1.00 , 53.20 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_object.object_filenameKeyFieldgsc_object.object_objFieldLabelPhysical ObjectFieldTooltipKeyFormat>>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(35)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object NO-LOCK
                     WHERE NOT gsc_object.LOGICAL_object,
                     FIRST gsc_object_type NO-LOCK
                     WHERE gsc_object_type.OBJECT_type_obj = gsc_object.OBJECT_type_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = gsc_object.product_module_obj,
                     FIRST gsc_product NO-LOCK
                     WHERE gsc_product.product_obj = gsc_product_module.product_obj INDEXED-REPOSITIONQueryTablesgsc_object,gsc_object_type,gsc_product_module,gsc_productBrowseFieldsgsc_product.product_code,gsc_product_module.product_module_code,gsc_object_type.object_type_code,gsc_object.object_filename,gsc_object.logical_object,gsc_object.object_description,gsc_object.container_objectBrowseFieldDataTypescharacter,character,character,character,logical,character,logicalBrowseFieldFormatsX(10),X(10),X(15),X(35),YES/NO,X(35),YES/NORowsToBatch200BrowseTitleLookup Physical ObjectViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOFieldNamephysical_object_objDisplayFieldyesEnableFieldyesHideOnInitDisableOnInitnoObjectLayout':U ,
             OUTPUT h_PhysicalObject ).
       RUN repositionObject IN h_PhysicalObject ( 10.24 , 20.60 ) NO-ERROR.
       RUN resizeObject IN h_PhysicalObject ( 1.00 , 53.20 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_object.object_filenameKeyFieldgsc_object.object_objFieldLabelSecurity ObjectFieldTooltipPress F4 for LookupKeyFormat>>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(35)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object NO-LOCK,
                     FIRST gsc_object_type NO-LOCK
                     WHERE gsc_object_type.OBJECT_type_obj = gsc_object.OBJECT_type_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = gsc_object.product_module_obj,
                     FIRST gsc_product NO-LOCK
                     WHERE gsc_product.product_obj = gsc_product_module.product_obj INDEXED-REPOSITIONQueryTablesgsc_object,gsc_object_type,gsc_product_module,gsc_productBrowseFieldsgsc_product.product_code,gsc_product_module.product_module_code,gsc_object_type.object_type_code,gsc_object.object_filename,gsc_object.container_object,gsc_object.logical_object,gsc_object.generic_object,gsc_object.disabledBrowseFieldDataTypescharacter,character,character,character,logical,logical,logical,logicalBrowseFieldFormatsX(10),X(10),X(15),X(35),YES/NO,YES/NO,YES/NO,YES/NORowsToBatch200BrowseTitleLookup Security ObjectViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOFieldNamesecurity_object_objDisplayFieldyesEnableFieldyesHideOnInitDisableOnInitnoObjectLayout':U ,
             OUTPUT h_SecurityObject ).
       RUN repositionObject IN h_SecurityObject ( 11.24 , 20.60 ) NO-ERROR.
       RUN resizeObject IN h_SecurityObject ( 1.00 , 53.20 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( hProduct ,
             RowObject.object_filename:HANDLE IN FRAME frMain , 'BEFORE':U ).
       RUN adjustTabOrder ( hProductModule ,
             hProduct , 'AFTER':U ).
       RUN adjustTabOrder ( h_ObjectType ,
             hProductModule , 'AFTER':U ).
       RUN adjustTabOrder ( h_Layout ,
             RowObject.run_when:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_SDOName ,
             h_Layout , 'AFTER':U ).
       RUN adjustTabOrder ( h_PhysicalObject ,
             h_SDOName , 'AFTER':U ).
       RUN adjustTabOrder ( h_SecurityObject ,
             h_PhysicalObject , 'AFTER':U ).
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

  /* Code placed here will execute PRIOR to standard behavior. */
  
  glEnableObjectName = TRUE.

  RUN SUPER.

  APPLY "VALUE-CHANGED":U TO RowObject.logical_object IN FRAME {&FRAME-NAME}.
  /* Code placed here will execute AFTER standard behavior.    */

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

  /* Code placed here will execute PRIOR to standard behavior. */
  
  ASSIGN
      RowObject.run_when:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = gcRunWhen.

  RUN SUPER( INPUT pcColValues).
  glEnableObjectName = FALSE.

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
  RUN disableField IN h_ObjectType.
  IF NOT glEnableObjectName THEN
    DISABLE RowObject.object_filename bu_find_object
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
      IF plGenericObject THEN DO:
        ASSIGN RowObject.logical_object:CHECKED   = FALSE
               RowObject.logical_object:SENSITIVE = FALSE.
        {set DataValue '0' h_PhysicalObject}.
        {set DataModified TRUE h_PhysicalObject}.
        RUN disableField IN h_PhysicalObject.
      END.
      ELSE DO:
        ASSIGN RowObject.logical_object:SENSITIVE = TRUE.
      END.
    END.
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
  RUN "ry\obj\gscpmprdfv.w *RTB-SmObj* ".
  RUN "adm2\dyncombo.w *RTB-SmObj* ".
  RUN "adm2\dynlookup.w *RTB-SmObj* ".

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
  
  IF pcMode = "Modify":U THEN
    APPLY "VALUE-CHANGED":U TO RowObject.logical_object IN FRAME {&FRAME-NAME}.
  gcMode = pcMode.
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

