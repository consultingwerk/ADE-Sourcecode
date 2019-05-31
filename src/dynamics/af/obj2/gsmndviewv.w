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
       {"af/obj2/gsmndfullo.i"}.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/***********************************************************************
* Copyright (C) 2005-2007 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*---------------------------------------------------------------------------------
  File: gsmndviewv.w

  Description:  Tree Node SmartDataViewer

  Purpose:      Tree Node SmartDataViewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000165   UserRef:    
                Date:   03/07/2001  Author:     Mark Davies

  Update Notes: Created from Template rysttviewv.w
                Tree Node SmartDataViewer

      Modified: 10/16/2001      Mark Davies (MIP)
                For some reason a GPF occurs at random when you viewed
                a record. This seems to be a problem in applyEntry in smart.p.
                To get around this problem I had to add a fill-in field that
                is sensitive when all the other fields are disabled and disabled
                when the other fields are enabled. This is probably not the correct
                way of fixing this, but I traced the GPF to the 'APPLY "ENTRY" TO'
                statement in applyEntry (smart.p).

      Modified: 02/22/2002      Mark Davies (MIP)
                Disable the Launch Container lookup field when the data source type
                is Plain Text and Menu structure.
                Fix for issue #3838 - Treeview fails to display text node data
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

&scop object-name       gsmndviewv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{src/adm2/globals.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "af/obj2/gsmndfullo.i"

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.node_code ~
RowObject.node_description RowObject.node_label RowObject.node_checked ~
RowObject.data_source_type RowObject.data_source RowObject.run_attribute ~
RowObject.node_text_label_expression ~
RowObject.label_text_substitution_fields RowObject.foreign_fields 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-Define ENABLED-OBJECTS coDataSourceType fiChar 
&Scoped-Define DISPLAYED-FIELDS RowObject.node_code ~
RowObject.node_description RowObject.node_label RowObject.node_checked ~
RowObject.data_source_type RowObject.data_source RowObject.run_attribute ~
RowObject.node_text_label_expression ~
RowObject.label_text_substitution_fields RowObject.foreign_fields 
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define DISPLAYED-OBJECTS coDataSourceType fiSDOChildren fiChar ~
fiLabelTextSubsLabel fiForeignFieldsLabel 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_DataSource AS HANDLE NO-UNDO.
DEFINE VARIABLE h_ImageFileName AS HANDLE NO-UNDO.
DEFINE VARIABLE h_LogicalObject AS HANDLE NO-UNDO.
DEFINE VARIABLE h_MenuCode AS HANDLE NO-UNDO.
DEFINE VARIABLE h_ParentNodeCode AS HANDLE NO-UNDO.
DEFINE VARIABLE h_primarySDO AS HANDLE NO-UNDO.
DEFINE VARIABLE h_SelectedImageFileName AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buFindPhysical 
     IMAGE-UP FILE "ry/img/view.gif":U
     LABEL "..." 
     SIZE 4.2 BY .91 TOOLTIP "Find an object"
     BGCOLOR 8 .

DEFINE VARIABLE coDataSourceType AS CHARACTER FORMAT "X(256)" INITIAL "SDO" 
     LABEL "Data source type" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "SDO/SBO/DataView","SDO",
                     "Extract Program","PRG",
                     "Menu Structure","MNU",
                     "Plain Text","TXT"
     DROP-DOWN-LIST
     SIZE 50 BY 1 TOOLTIP "Select the data source type to populate this node." NO-UNDO.

DEFINE VARIABLE cExtractProgram AS CHARACTER FORMAT "x(70)" 
     LABEL "Extract Program" 
     VIEW-AS FILL-IN 
     SIZE 78.4 BY 1.

DEFINE VARIABLE cPlainText AS CHARACTER FORMAT "x(70)" 
     LABEL "Plain Text" 
     VIEW-AS FILL-IN 
     SIZE 78.4 BY 1.

DEFINE VARIABLE fiChar AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE .2 BY .1 TOOLTIP "Used to get rid of GPF errors" NO-UNDO.

DEFINE VARIABLE fiForeignFieldsLabel AS CHARACTER FORMAT "X(35)":U INITIAL "Foreign fields:" 
      VIEW-AS TEXT 
     SIZE 13.8 BY 1 NO-UNDO.

DEFINE VARIABLE fiLabelTextSubsLabel AS CHARACTER FORMAT "X(35)":U INITIAL "Label text substitution:" 
      VIEW-AS TEXT 
     SIZE 21.4 BY 1 NO-UNDO.

DEFINE VARIABLE fiSDOChildren AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 3.6 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     RowObject.node_code AT ROW 1 COL 28.2 COLON-ALIGNED
          LABEL "Node code"
          VIEW-AS FILL-IN 
          SIZE 63.2 BY 1
     RowObject.node_description AT ROW 2.05 COL 28.2 COLON-ALIGNED
          LABEL "Node description"
          VIEW-AS FILL-IN 
          SIZE 78.4 BY 1
     RowObject.node_label AT ROW 4.14 COL 28.2 COLON-ALIGNED
          LABEL "Node label"
          VIEW-AS FILL-IN 
          SIZE 63.2 BY 1
     RowObject.node_checked AT ROW 5.19 COL 30.2
          LABEL "Node checked"
          VIEW-AS TOGGLE-BOX
          SIZE 19.4 BY 1
     coDataSourceType AT ROW 6.24 COL 28.2 COLON-ALIGNED
     RowObject.data_source_type AT ROW 6.24 COL 28.2 COLON-ALIGNED
          LABEL "Data source type"
          VIEW-AS FILL-IN 
          SIZE 8.6 BY 1
     RowObject.data_source AT ROW 7.29 COL 28.2 COLON-ALIGNED
          LABEL "Data source"
          VIEW-AS FILL-IN 
          SIZE 78.4 BY 1
     cExtractProgram AT ROW 7.29 COL 28.2 COLON-ALIGNED
     cPlainText AT ROW 7.29 COL 28.2 COLON-ALIGNED
     buFindPhysical AT ROW 7.33 COL 104.2
     fiSDOChildren AT ROW 8.81 COL 103 COLON-ALIGNED NO-LABEL
     fiChar AT ROW 9.76 COL 80.2 NO-LABEL
     RowObject.run_attribute AT ROW 10.43 COL 28.2 COLON-ALIGNED
          LABEL "Run attribute"
          VIEW-AS FILL-IN 
          SIZE 78.4 BY 1
     RowObject.node_text_label_expression AT ROW 11.48 COL 28.2 COLON-ALIGNED
          LABEL "Node text label expression"
          VIEW-AS FILL-IN 
          SIZE 78.4 BY 1
     RowObject.label_text_substitution_fields AT ROW 12.52 COL 30.2 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 256 SCROLLBAR-VERTICAL
          SIZE 78.4 BY 3
     RowObject.foreign_fields AT ROW 15.57 COL 30.2 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 256 SCROLLBAR-VERTICAL
          SIZE 78.4 BY 3
     fiLabelTextSubsLabel AT ROW 12.52 COL 6.2 COLON-ALIGNED NO-LABEL
     fiForeignFieldsLabel AT ROW 15.57 COL 14.2 COLON-ALIGNED NO-LABEL
     SPACE(78.60) SKIP(4.10)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "af/obj2/gsmndfullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {af/obj2/gsmndfullo.i}
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
         HEIGHT             = 19.67
         WIDTH              = 107.6.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON buFindPhysical IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       buFindPhysical:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN cExtractProgram IN FRAME frMain
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       cExtractProgram:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN cPlainText IN FRAME frMain
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       cPlainText:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN RowObject.data_source IN FRAME frMain
   EXP-LABEL                                                            */
ASSIGN 
       RowObject.data_source:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN RowObject.data_source_type IN FRAME frMain
   EXP-LABEL                                                            */
ASSIGN 
       RowObject.data_source_type:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN fiChar IN FRAME frMain
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiForeignFieldsLabel IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       fiForeignFieldsLabel:PRIVATE-DATA IN FRAME frMain     = 
                "Foreign fields:".

/* SETTINGS FOR FILL-IN fiLabelTextSubsLabel IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       fiLabelTextSubsLabel:PRIVATE-DATA IN FRAME frMain     = 
                "Label text substitution:".

/* SETTINGS FOR FILL-IN fiSDOChildren IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       fiSDOChildren:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR EDITOR RowObject.foreign_fields IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR EDITOR RowObject.label_text_substitution_fields IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.node_checked IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.node_code IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.node_description IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.node_label IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.node_text_label_expression IN FRAME frMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN RowObject.run_attribute IN FRAME frMain
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME buFindPhysical
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buFindPhysical vTableWin
ON CHOOSE OF buFindPhysical IN FRAME frMain /* ... */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    DEFINE VARIABLE lOk                 AS   LOGICAL                NO-UNDO.
    DEFINE VARIABLE cRoot               AS   CHARACTER              NO-UNDO.
    DEFINE VARIABLE cFilename           AS   CHARACTER              NO-UNDO.
    DEFINE VARIABLE cFilterNamestring   AS   CHARACTER EXTENT 5     NO-UNDO.
    DEFINE VARIABLE cFilterFilespec     LIKE cFilterNamestring      NO-UNDO.
    DEFINE VARIABLE cFile               AS   CHARACTER              NO-UNDO.
    DEFINE VARIABLE cNewFile            AS   CHARACTER              NO-UNDO.

    /* Initialize the file filters, for special cases. */

    ASSIGN  cFilterNamestring[1] = "All Files(*.*)"
            cFilterFilespec[1] = "*.*"
            cFilterNamestring[2] = "All windows(?????????w.w)"
            cFilterFilespec[2] = "?????????w.w".

    /*  Ask for a file name. NOTE: File-names to run must exist.
        --------------------------------------------------------
    */

    cFilename = DYNAMIC-FUNCTION("getDataValue":U IN h_DataSource).

    SYSTEM-DIALOG GET-FILE cFilename
        TITLE    "Lookup Physical Object"
        FILTERS  cFilterNamestring[ 1 ]   cFilterFilespec[ 1 ],
                 cFilterNamestring[ 2 ]   cFilterFilespec[ 2 ]
        MUST-EXIST
        UPDATE   lOk IN WINDOW {&WINDOW-NAME}.  
    
    IF NOT lOk THEN
      RETURN NO-APPLY.

    cFileName = REPLACE(cFileName,"~\":U,"/":U).
    cRoot = SUBSTRING(cFileName,1,R-INDEX(cFileName,"/":U,R-INDEX(cFileName,"/":U,R-INDEX(cFileName,"/":U) - 1) - 1)).
    
    IF  lOk THEN DO:
      ASSIGN
          cFile           = REPLACE(cFilename,cRoot,"":U)
          lOk             = DYNAMIC-FUNCTION("setDataValue":U IN h_DataSource, INPUT cFile)
          cExtractProgram = cFile
          cExtractProgram = REPLACE(cExtractProgram,"\":U,"/":U).
      
      IF SEARCH(cExtractProgram) = ? THEN DO:
        /* Get correct relative path */
        cNewFile = cExtractProgram.
  
        FIND_REL_PATH:
        DO WHILE INDEX(cNewFile,"/":U) <> 0:
          cNewFile = SUBSTRING(cNewFile,INDEX(cNewFile,"/":U) + 1).
          IF SEARCH(cNewFile) <> ? THEN
            LEAVE FIND_REL_PATH.
        END.
  
        cExtractProgram = cNewFile.
      END.


      DISPLAY cExtractProgram WITH FRAME {&FRAME-NAME}.
      ASSIGN RowObject.data_source:SCREEN-VALUE = cExtractProgram
             RowObject.data_source:MODIFIED     = TRUE.
      {set DataModified TRUE}.
    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cExtractProgram
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cExtractProgram vTableWin
ON VALUE-CHANGED OF cExtractProgram IN FRAME frMain /* Extract Program */
DO:
  ASSIGN cExtractProgram.
  ASSIGN RowObject.data_source:SCREEN-VALUE = cExtractProgram
         RowObject.data_source:MODIFIED     = TRUE.
  {set DataModified TRUE}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coDataSourceType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coDataSourceType vTableWin
ON VALUE-CHANGED OF coDataSourceType IN FRAME frMain /* Data source type */
DO:
  RUN changeFieldStates.
  RowObject.data_source_type:MODIFIED = TRUE.
  {set DataModified TRUE}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cPlainText
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cPlainText vTableWin
ON VALUE-CHANGED OF cPlainText IN FRAME frMain /* Plain Text */
DO:
  ASSIGN cPlainText.
  
  ASSIGN RowObject.data_source:SCREEN-VALUE = cPlainText
         RowObject.data_source:MODIFIED     = TRUE.
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

  RUN SUPER.
  APPLY "VALUE-CHANGED":U TO coDataSourceType IN FRAME {&FRAME-NAME}.

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
             INPUT  'DisplayedFieldgsm_node.node_codeKeyFieldgsm_node.node_objFieldLabelParent node codeFieldTooltipSelect the parent for this nodeKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(35)DisplayDatatypecharacterBaseQueryStringFOR EACH gsm_node NO-LOCK BY gsm_node.node_codeQueryTablesgsm_nodeBrowseFieldsgsm_node.node_code,gsm_node.node_description,gsm_node.node_labelBrowseFieldDataTypescharacter,character,characterBrowseFieldFormatsX(35)|X(35)|X(28)RowsToBatch200BrowseTitleParent Node LookupViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListNO-LOCKQueryBuilderOrderListgsm_node.node_code^yesQueryBuilderTableOptionListNO-LOCKQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesSuperProcedureDataSourceNameFieldNameparent_node_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_ParentNodeCode ).
       RUN repositionObject IN h_ParentNodeCode ( 3.10 , 30.20 ) NO-ERROR.
       RUN resizeObject IN h_ParentNodeCode ( 1.00 , 50.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.object_filenameFieldLabelData SourceFieldTooltipSelect Data Source SDO/SBO nameKeyFormatX(70)KeyDatatypecharacterDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object_type NO-LOCK,
                     EACH ryc_smartobject NO-LOCK
                     WHERE ryc_smartobject.OBJECT_type_obj = gsc_object_type.object_type_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj
                     AND [&FilterSet=|&EntityList=GSCPM,RYCSO]
                     BY ryc_smartobject.object_filenameQueryTablesgsc_object_type,ryc_smartobject,gsc_product_moduleBrowseFieldsgsc_product_module.product_module_code,ryc_smartobject.object_filename,ryc_smartobject.object_description,ryc_smartobject.object_pathBrowseFieldDataTypescharacter,character,character,characterBrowseFieldFormatsX(35)|X(70)|X(35)|X(70)RowsToBatch200BrowseTitleData Source LookupViewerLinkedFieldsryc_smartobject.object_pathLinkedFieldDataTypescharacterLinkedFieldFormatsX(70)ViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldfiSDOChildrenParentFilterQueryLOOKUP(gsc_object_type.object_type_code, "&1") > 0MaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesSuperProcedureDataSourceNameFieldNamecSDODataSourceDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_DataSource ).
       RUN repositionObject IN h_DataSource ( 7.29 , 30.20 ) NO-ERROR.
       RUN resizeObject IN h_DataSource ( 1.00 , 50.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsm_menu_structure.menu_structure_codeKeyFieldgsm_menu_structure.menu_structure_codeFieldLabelMenu structure codeFieldTooltipSelect the menu structure to be used for this node.KeyFormatX(28)KeyDatatypecharacterDisplayFormatX(28)DisplayDatatypecharacterBaseQueryStringFOR EACH gsm_menu_structure NO-LOCK
                     WHERE gsm_menu_structure.menu_structure_type = "SubMenu",
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = gsm_menu_structure.product_module_obj
                     AND [&FilterSet=|&EntityList=GSCPM] OUTER-JOIN INDEXED-REPOSITIONQueryTablesgsm_menu_structure,gsc_product_moduleBrowseFieldsgsm_menu_structure.menu_structure_code,gsm_menu_structure.menu_structure_description,gsm_menu_structure.menu_structure_hidden,gsm_menu_structure.menu_structure_type,gsm_menu_structure.disabledBrowseFieldDataTypescharacter,character,logical,character,logicalBrowseFieldFormatsX(28)|X(35)|YES/NO|X(15)|YES/NORowsToBatch200BrowseTitleLookup Menu StructureViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesSuperProcedureDataSourceNameFieldNamecMenuStructureCodeDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_MenuCode ).
       RUN repositionObject IN h_MenuCode ( 7.29 , 30.20 ) NO-ERROR.
       RUN resizeObject IN h_MenuCode ( 1.00 , 50.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.object_filenameFieldLabelPrimary data objectFieldTooltipSelect the primary SDO/SBO nameKeyFormatX(70)KeyDatatypecharacterDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object_type NO-LOCK,
                     EACH ryc_smartobject NO-LOCK
                     WHERE ryc_smartobject.OBJECT_type_obj = gsc_object_type.object_type_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj
                     AND [&FilterSet=|&EntityList=GSCPM,RYCSO]
                     BY ryc_smartobject.object_filename INDEXED-REPOSITIONQueryTablesgsc_object_type,ryc_smartobject,gsc_product_moduleBrowseFieldsgsc_product_module.product_module_code,ryc_smartobject.object_filename,ryc_smartobject.object_description,ryc_smartobject.object_pathBrowseFieldDataTypescharacter,character,character,characterBrowseFieldFormatsX(35)|X(70)|X(35)|X(70)RowsToBatch200BrowseTitlePrimary SDO LookupViewerLinkedFieldsryc_smartobject.object_pathLinkedFieldDataTypescharacterLinkedFieldFormatsX(70)ViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldfiSDOChildrenParentFilterQueryLOOKUP(gsc_object_type.object_type_code, "&1") > 0MaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesSuperProcedureDataSourceNameFieldNameprimary_sdoDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_primarySDO ).
       RUN repositionObject IN h_primarySDO ( 8.33 , 30.20 ) NO-ERROR.
       RUN resizeObject IN h_primarySDO ( 1.00 , 50.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.object_filenameFieldLabelLaunch containerFieldTooltipSelect the object to be launched when this node is selected.KeyFormatX(70)KeyDatatypecharacterDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH ryc_smartobject NO-LOCK
                     WHERE ryc_smartobject.runnable_from_menu = YES,
                     FIRST gsc_object_type NO-LOCK
                     WHERE gsc_object_type.OBJECT_type_obj = ryc_smartobject.OBJECT_type_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj
                     AND [&FilterSet=|&EntityList=GSCPM,RYCSO]
                     BY ryc_smartobject.OBJECT_filename INDEXED-REPOSITIONQueryTablesryc_smartobject,gsc_object_type,gsc_product_moduleBrowseFieldsgsc_product_module.product_module_code,ryc_smartobject.object_filename,gsc_object_type.object_type_code,ryc_smartobject.object_description,ryc_smartobject.static_objectBrowseFieldDataTypescharacter,character,character,character,logicalBrowseFieldFormatsX(35)|X(70)|X(35)|X(35)|YES/NORowsToBatch200BrowseTitleLogical Object LookupViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesSuperProcedureDataSourceNameFieldNamelogical_objectDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_LogicalObject ).
       RUN repositionObject IN h_LogicalObject ( 9.38 , 30.20 ) NO-ERROR.
       RUN resizeObject IN h_LogicalObject ( 1.00 , 50.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsm_multi_media.physical_file_nameKeyFieldgsm_multi_media.physical_file_nameFieldLabelImage file nameFieldTooltipSelect the image file name for the icon to be displayed for this node.KeyFormatX(70)KeyDatatypecharacterDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH gsm_multi_media,
                     FIRST gsc_multi_media_type
                     WHERE gsc_multi_media_type.multi_media_type_obj = gsm_multi_media.multi_media_type_obj
                     AND gsc_multi_media_type.multi_media_type_code = ~'TVIMG~':U,
                     FIRST gsm_category
                     WHERE gsm_category.category_obj = gsm_multi_media.category_obj
                     AND gsm_category.related_entity_mnemonic = ~'GSMMM~':U
                     AND gsm_category.category_type = ~'IMG~':U
                     AND gsm_category.category_group = ~'TRE~':U
                     AND gsm_category.category_subgroup = ~'ANY~':U
                     AND gsm_category.category_active = TRUEQueryTablesgsm_multi_media,gsc_multi_media_type,gsm_categoryBrowseFieldsgsm_multi_media.multi_media_description,gsm_multi_media.physical_file_nameBrowseFieldDataTypescharacter,characterBrowseFieldFormatsX(35)|X(70)RowsToBatch200BrowseTitleImage File Name LookupViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesSuperProcedureDataSourceNameFieldNameimage_file_nameDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_ImageFileName ).
       RUN repositionObject IN h_ImageFileName ( 18.62 , 30.20 ) NO-ERROR.
       RUN resizeObject IN h_ImageFileName ( 1.00 , 78.40 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsm_multi_media.physical_file_nameKeyFieldgsm_multi_media.physical_file_nameFieldLabelSelected image file nameFieldTooltipSelect the image file name for the icon to be displayed for this node when selected.KeyFormatX(70)KeyDatatypecharacterDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH gsm_multi_media,
                     FIRST gsc_multi_media_type
                     WHERE gsc_multi_media_type.multi_media_type_obj = gsm_multi_media.multi_media_type_obj
                     AND gsc_multi_media_type.multi_media_type_code = ~'TVIMG~':U,
                     FIRST gsm_category
                     WHERE gsm_category.category_obj = gsm_multi_media.category_obj
                     AND gsm_category.related_entity_mnemonic = ~'GSMMM~':U
                     AND gsm_category.category_type = ~'IMG~':U
                     AND gsm_category.category_group = ~'TRE~':U
                     AND gsm_category.category_subgroup = ~'ANY~':U
                     AND gsm_category.category_active = TRUEQueryTablesgsm_multi_media,gsc_multi_media_type,gsm_categoryBrowseFieldsgsm_multi_media.multi_media_description,gsm_multi_media.physical_file_nameBrowseFieldDataTypescharacter,characterBrowseFieldFormatsX(35)|X(70)RowsToBatch200BrowseTitleImage File Name LookupViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesSuperProcedureDataSourceNameFieldNameselected_image_file_nameDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_SelectedImageFileName ).
       RUN repositionObject IN h_SelectedImageFileName ( 19.67 , 30.20 ) NO-ERROR.
       RUN resizeObject IN h_SelectedImageFileName ( 1.00 , 78.40 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_ParentNodeCode ,
             RowObject.node_description:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_DataSource ,
             cPlainText:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_MenuCode ,
             h_DataSource , 'AFTER':U ).
       RUN adjustTabOrder ( h_primarySDO ,
             buFindPhysical:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_LogicalObject ,
             fiSDOChildren:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_ImageFileName ,
             RowObject.foreign_fields:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_SelectedImageFileName ,
             h_ImageFileName , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeFieldStates vTableWin 
PROCEDURE changeFieldStates :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN coDataSourceType.
    ASSIGN RowObject.data_source_type:SCREEN-VALUE = coDataSourceType.
  END.
  
  ASSIGN buFindPhysical:HIDDEN     = TRUE
         buFindPhysical:SENSITIVE  = FALSE
         cPlainText:HIDDEN         = TRUE
         cPlainText:SENSITIVE      = FALSE
         cExtractProgram:HIDDEN    = TRUE
         cExtractProgram:SENSITIVE = FALSE.
  
  {set FieldHidden TRUE h_MenuCode}.
  {set FieldHidden TRUE h_DataSource}.
  
  CASE coDataSourceType:
    WHEN "PRG" THEN DO:
      {set FieldHidden TRUE h_DataSource}.
      IF RowObject.node_code:SENSITIVE THEN DO:
        RUN enableField IN h_DataSource.
        RUN enableField IN h_primarySDO.
        RUN enableField IN h_LogicalObject.
        assign RowObject.run_attribute:sensitive = yes
               RowObject.node_text_label_expression:sensitive = yes
               RowObject.label_text_substitution_fields:sensitive = yes
               RowObject.foreign_fields:sensitive = yes.                
      END.
      ASSIGN cExtractProgram:HIDDEN    = FALSE
             cExtractProgram:SENSITIVE = RowObject.node_code:SENSITIVE
             buFindPhysical:HIDDEN     = FALSE
             buFindPhysical:SENSITIVE  = RowObject.node_code:SENSITIVE.
    END.
    WHEN "MNU" THEN DO:
      IF RowObject.node_code:SENSITIVE THEN DO:
        RUN disableField IN h_LogicalObject.
        RUN disableField IN h_primarySDO.
        RUN disableField IN h_DataSource.
        assign RowObject.run_attribute:sensitive = no
               RowObject.node_text_label_expression:sensitive = no
               RowObject.label_text_substitution_fields:sensitive = no
               RowObject.foreign_fields:sensitive = no.                
      END.
      {set FieldHidden FALSE h_MenuCode}.
      
      RUN assignNewValue IN h_LogicalObject ("":U,"":U,FALSE).
    END.
    WHEN "TXT":U THEN DO:
      ASSIGN cPlainText:HIDDEN    = FALSE
             cPlainText:SENSITIVE = RowObject.node_code:SENSITIVE.
      IF RowObject.node_code:SENSITIVE THEN DO:
        RUN enableField IN h_primarySDO.
        RUN enableField IN h_LogicalObject.
        assign RowObject.node_text_label_expression:sensitive = no
               RowObject.label_text_substitution_fields:sensitive = no
               RowObject.foreign_fields:sensitive = no.
                
      END.
    END.
    WHEN "SDO":U THEN DO:
      {set FieldHidden FALSE h_DataSource}.
      IF RowObject.node_code:SENSITIVE THEN DO:
        RUN enableField IN h_DataSource.
        RUN enableField IN h_primarySDO.
        RUN enableField IN h_LogicalObject.
        assign RowObject.run_attribute:sensitive = yes
               RowObject.node_text_label_expression:sensitive = yes
               RowObject.label_text_substitution_fields:sensitive = yes
               RowObject.foreign_fields:sensitive = yes.
      END.
    END.
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableFields vTableWin 
PROCEDURE disableFields :
/*----------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcFieldType AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcFieldType).

  /* This was added to get rid of a GPF error that occured
     due to the Editor being selected Mark Davies (MIP) 10/16/2001 */
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fiChar:SENSITIVE = TRUE
           fiChar:TAB-STOP  = TRUE
           fiChar:HIDDEN    = FALSE.
  END.
  
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

  DEFINE VARIABLE hContainerSource  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cMode             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataSource       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataSource       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hMenuCode         AS HANDLE     NO-UNDO.
  
  /* Code placed here will execute PRIOR to standard behavior. */
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN buFindPhysical:HIDDEN     = TRUE
           buFindPhysical:SENSITIVE  = FALSE
           cPlainText:HIDDEN         = TRUE
           cPlainText:SENSITIVE      = FALSE
           cExtractProgram:HIDDEN    = TRUE
           cExtractProgram:SENSITIVE = FALSE.
  END.

  RUN SUPER( INPUT pcColValues).
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN coDataSourceType:SCREEN-VALUE = ENTRY(6,pcColValues,CHR(1)) NO-ERROR.
    RUN changeFieldStates.
    
    ASSIGN coDataSourceType:MODIFIED           = FALSE
           RowObject.data_source_type:MODIFIED = FALSE
           cDataSource                         = ENTRY(14,pcColValues,CHR(1))
           NO-ERROR.
    
    ASSIGN coDataSourceType.
    
    CASE coDataSourceType:
      WHEN "PRG":U THEN
        ASSIGN cExtractProgram:SCREEN-VALUE = cDataSource
               cExtractProgram:MODIFIED     = FALSE.
      WHEN "TXT":U THEN
        ASSIGN cPlainText:SCREEN-VALUE = cDataSource
               cPlainText:MODIFIED     = FALSE.
    END CASE.
  END.
  
  /* With all the setting of dataValues we must make sure that 
     we set the DataSource and menuCode field's modified
     value to false and also change the state back to normal */
  ASSIGN hDataSource = DYNAMIC-FUNCTION("getLookupHandle" IN h_datasource)
         hMenuCode   = DYNAMIC-FUNCTION("getLookupHandle" IN h_menucode).
  ASSIGN hDataSource:MODIFIED = FALSE
         hMenuCode:MODIFIED   = FALSE.
         
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

  /* For use in TreeView window - disable parent node field lookup */
  RUN disableField IN h_ParentNodeCode.

  /* Needed to do this since the standard code does not do this 
     if you viewed a record and then decided to modify it */
  APPLY "ENTRY":U TO RowObject.node_code IN FRAME {&FRAME-NAME}.
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fiChar:SENSITIVE = FALSE
           fiChar:HIDDEN    = TRUE.
  END. 
     
  /* Code placed here will execute AFTER standard behavior.    */

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
DEFINE VARIABLE hDesignManager AS HANDLE      NO-UNDO.

  ASSIGN hDesignManager = DYNAMIC-FUNCTION('getManagerHandle':U IN TARGET-PROCEDURE, INPUT "RepositoryDesignManager":U)
         fiSDOChildren:SCREEN-VALUE IN FRAME {&FRAME-NAME} = DYNAMIC-FUNCTION("getDataSourceClasses":U IN hDesignManager)
         fiSDOChildren.
  /* Code placed here will execute PRIOR to standard behavior. */
  
  SUBSCRIBE TO "lookupComplete":U IN THIS-PROCEDURE.
  
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
DEFINE INPUT PARAMETER pcFieldNames     AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcFieldValues    AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcKeyFieldValue  AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcNewScreenValue AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcOldScreenValue AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER plBrowseUsed     AS LOGICAL    NO-UNDO.
DEFINE INPUT PARAMETER phLookup         AS HANDLE     NO-UNDO. 
           
DO WITH FRAME {&FRAME-NAME}:
  IF (phLookup = h_DataSource OR
      phLookup = h_MenuCode) THEN DO:
    IF LOOKUP(rowObject.data_source_type:SCREEN-VALUE,"SDO") > 0 THEN DO:
      DYNAMIC-FUNCTION("setDataValue" IN h_primarySDO, pcNewScreenValue).
      {set DataModified TRUE h_primarySDO}.
    END.
    ASSIGN RowObject.data_source:SCREEN-VALUE = pcNewScreenValue
           RowObject.data_source:MODIFIED     = TRUE.
  END.
END.
             
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

  RUN changeFieldStates.
  /* Code placed here will execute AFTER standard behavior.    */

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
  /* Code placed here will execute PRIOR to standard behavior. */
  
  /* To ensure that we LEAVE the Parent Node Code lookup when 
     Save is pressed and the focus is still in the lookup - 
     This fixes issue #8061 */
  RUN leaveLookup IN h_ParentNodeCode.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

