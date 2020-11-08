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
       {"ry/obj/rycsoful2o.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/***********************************************************************
* Copyright (C) 2002,2008 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*---------------------------------------------------------------------------------
  File: rytreeattv.w

  Description:  Dynamic TreeView Attribute Viewer

  Purpose:      Dynamic TreeView Attribute Viewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/04/2002  Author:     Mark Davies (MIP)

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

&scop object-name       rytreeattv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{src/adm2/globals.i}
{checkerr.i &define-only = YES}

DEFINE VARIABLE giLastSelectedPage     AS INTEGER    NO-UNDO.
DEFINE VARIABLE ghContainerSource      AS HANDLE     NO-UNDO.
DEFINE VARIABLE glTrackChanges         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE ghDataTable            AS HANDLE     NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS fiWindowName coTreeStyle ToAutoSort ~
ToHideSelection ToShowCheckBoxes ToShowRootLines fiImageHeight fiImageWidth 
&Scoped-Define DISPLAYED-OBJECTS fiWindowName coTreeStyle ToAutoSort ~
ToHideSelection ToShowCheckBoxes ToShowRootLines fiImageHeight fiImageWidth 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataTable vTableWin 
FUNCTION getDataTable RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE hFilterViewer AS HANDLE NO-UNDO.
DEFINE VARIABLE hLayout AS HANDLE NO-UNDO.
DEFINE VARIABLE hRootNodeCode AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE coTreeStyle AS CHARACTER FORMAT "X(256)" 
     LABEL "Tree style" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Text only","0",
                     "Pictures & Text","1",
                     "Text only (Plus/Minus)","2",
                     "Pictures & Text (Plus/Minus)","3",
                     "Text only with tree lines","4",
                     "Pictures & Text with tree lines","5",
                     "Text only with tree lines & plus/minus","6",
                     "Pictures & text with tree lines & plus/minus","7"
     DROP-DOWN-LIST
     SIZE 50 BY 1 TOOLTIP "Select a style in which your TreeView should appear" NO-UNDO.

DEFINE VARIABLE fiImageHeight AS INTEGER FORMAT "->>>>9":U INITIAL 0 
     LABEL "Image height" 
     VIEW-AS FILL-IN 
     SIZE 12.2 BY 1 TOOLTIP "Enter the default image height (Pixels)" NO-UNDO.

DEFINE VARIABLE fiImageWidth AS INTEGER FORMAT "->>>>9":U INITIAL 0 
     LABEL "Image width" 
     VIEW-AS FILL-IN 
     SIZE 12.2 BY 1 TOOLTIP "Enter the default image width (Pixels)" NO-UNDO.

DEFINE VARIABLE fiVisualObjects AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 8 BY .57 NO-UNDO.

DEFINE VARIABLE fiWindowName AS CHARACTER FORMAT "X(35)":U 
     LABEL "Window title" 
     VIEW-AS FILL-IN 
     SIZE 50 BY 1 TOOLTIP "Enter the main window title of your Dynamic TreeView container." NO-UNDO.

DEFINE VARIABLE ToAutoSort AS LOGICAL INITIAL no 
     LABEL "Auto sort" 
     VIEW-AS TOGGLE-BOX
     SIZE 50 BY .81 TOOLTIP "Auto sort the nodes in the TreeView" NO-UNDO.

DEFINE VARIABLE ToHideSelection AS LOGICAL INITIAL no 
     LABEL "Hide selection" 
     VIEW-AS TOGGLE-BOX
     SIZE 50 BY .81 TOOLTIP "Hide the visual block for a selected node" NO-UNDO.

DEFINE VARIABLE ToShowCheckBoxes AS LOGICAL INITIAL no 
     LABEL "Show check boxes" 
     VIEW-AS TOGGLE-BOX
     SIZE 50 BY .81 TOOLTIP "Show a check box next to each node" NO-UNDO.

DEFINE VARIABLE ToShowRootLines AS LOGICAL INITIAL no 
     LABEL "Show root lines" 
     VIEW-AS TOGGLE-BOX
     SIZE 50 BY .81 TOOLTIP "Show root lines on TreeView control" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     fiWindowName AT ROW 1 COL 23 COLON-ALIGNED
     fiVisualObjects AT ROW 3.38 COL 2.6 NO-LABEL
     coTreeStyle AT ROW 5.19 COL 23 COLON-ALIGNED
     ToAutoSort AT ROW 6.43 COL 25
     ToHideSelection AT ROW 7.24 COL 25
     ToShowCheckBoxes AT ROW 8.05 COL 25
     ToShowRootLines AT ROW 8.86 COL 25
     fiImageHeight AT ROW 9.71 COL 23 COLON-ALIGNED
     fiImageWidth AT ROW 10.76 COL 23 COLON-ALIGNED
     SPACE(37.80) SKIP(0.00)
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
         HEIGHT             = 10.81
         WIDTH              = 74.
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

/* SETTINGS FOR FILL-IN fiVisualObjects IN FRAME frMain
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       fiVisualObjects:HIDDEN IN FRAME frMain           = TRUE.

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
ON VALUE-CHANGED OF coTreeStyle IN FRAME frMain /* Tree style */
DO:
  ASSIGN coTreeStyle.
  IF glTrackChanges THEN DO:
    PUBLISH "changesMade":U FROM ghContainerSource.
    PUBLISH "changedAttribute" FROM ghContainerSource (INPUT "TreeStyle":U, coTreeStyle, "integer").
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiImageHeight
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiImageHeight vTableWin
ON LEAVE OF fiImageHeight IN FRAME frMain /* Image height */
DO:
  IF glTrackChanges THEN DO:
    PUBLISH "changesMade":U FROM ghContainerSource.
    PUBLISH "changedAttribute" FROM ghContainerSource (INPUT "ImageHeight":U, fiImageHeight:SCREEN-VALUE,"integer").
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiImageWidth
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiImageWidth vTableWin
ON LEAVE OF fiImageWidth IN FRAME frMain /* Image width */
DO:
  IF glTrackChanges THEN DO:
    PUBLISH "changesMade":U FROM ghContainerSource.
    PUBLISH "changedAttribute" FROM ghContainerSource (INPUT "ImageWidth":U, fiImageWidth:SCREEN-VALUE,"integer").
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiWindowName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiWindowName vTableWin
ON VALUE-CHANGED OF fiWindowName IN FRAME frMain /* Window title */
DO:
  IF glTrackChanges THEN DO:
    PUBLISH "changesMade":U FROM ghContainerSource.
    PUBLISH "changedAttribute" FROM ghContainerSource (INPUT "WindowName":U, SELF:SCREEN-VALUE, INPUT "CHARACTER":U).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ToAutoSort
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ToAutoSort vTableWin
ON VALUE-CHANGED OF ToAutoSort IN FRAME frMain /* Auto sort */
DO:
  IF glTrackChanges THEN DO:
    PUBLISH "changesMade":U FROM ghContainerSource.
    PUBLISH "changedAttribute" FROM ghContainerSource (INPUT "AutoSort":U, toAutoSort:CHECKED,"logical").
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ToHideSelection
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ToHideSelection vTableWin
ON VALUE-CHANGED OF ToHideSelection IN FRAME frMain /* Hide selection */
DO:
  IF glTrackChanges THEN DO:
    PUBLISH "changesMade":U FROM ghContainerSource.
    PUBLISH "changedAttribute" FROM ghContainerSource (INPUT "HideSelection":U, toHideSelection:CHECKED,"logical").
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ToShowCheckBoxes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ToShowCheckBoxes vTableWin
ON VALUE-CHANGED OF ToShowCheckBoxes IN FRAME frMain /* Show check boxes */
DO:
  IF glTrackChanges THEN DO:
    PUBLISH "changesMade":U FROM ghContainerSource.
    PUBLISH "changedAttribute" FROM ghContainerSource (INPUT "ShowCheckBoxes":U, toShowCheckBoxes:CHECKED,"logical").
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ToShowRootLines
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ToShowRootLines vTableWin
ON VALUE-CHANGED OF ToShowRootLines IN FRAME frMain /* Show root lines */
DO:
  IF glTrackChanges THEN DO:
    PUBLISH "changesMade":U FROM ghContainerSource.
    PUBLISH "changedAttribute" FROM ghContainerSource (INPUT "ShowRootLines":U, toShowRootLines:CHECKED,"logical").
  END.
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
             INPUT  'DisplayedFieldgsm_node.node_codeKeyFieldgsm_node.node_codeFieldLabelRoot node codeFieldTooltipPress F4 to Lookup your TreeView~'s Root NodeKeyFormatX(35)KeyDatatypecharacterDisplayFormatX(35)DisplayDatatypecharacterBaseQueryStringFOR EACH gsm_node
                     WHERE gsm_node.parent_node_obj = 0 NO-LOCK
                     BY gsm_node.node_codeQueryTablesgsm_nodeBrowseFieldsgsm_node.node_code,gsm_node.node_description,gsm_node.node_labelBrowseFieldDataTypescharacter,character,characterBrowseFieldFormatsX(35)|X(70)|X(28)RowsToBatch200BrowseTitleLookup Root NodeViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListNO-LOCKQueryBuilderOrderListnode_code^yesQueryBuilderTableOptionListNO-LOCKQueryBuilderTuneOptionsQueryBuilderWhereClausesgsm_node.parent_node_obj = 0PopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoFieldName<Local_RootNodeCode>DisplayFieldyesEnableFieldyesLocalFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hRootNodeCode ).
       RUN repositionObject IN hRootNodeCode ( 2.05 , 25.00 ) NO-ERROR.
       RUN resizeObject IN hRootNodeCode ( 1.00 , 50.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dyncombo.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_layout.layout_nameKeyFieldryc_layout.layout_nameFieldLabelLayoutFieldTooltipSelect a layout from the listKeyFormatX(28)KeyDatatypecharacterDisplayFormatX(256)DisplayDatatypeCHARACTERBaseQueryStringFOR EACH ryc_layout NO-LOCK BY ryc_layout.layout_codeQueryTablesryc_layoutSDFFileNameStatic_DynComboSDFTemplateParentFieldParentFilterQueryDescSubstitute&1ComboDelimiterListItemPairsInnerLines5ComboFlagFlagValueBuildSequence1SecurednoCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesFieldName<Local_Layout>DisplayFieldyesEnableFieldyesLocalFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hLayout ).
       RUN repositionObject IN hLayout ( 3.10 , 25.00 ) NO-ERROR.
       RUN resizeObject IN hLayout ( 1.00 , 50.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.object_filenameFieldLabelFilter viewerFieldTooltipPress F4 to lookup the name of a Filter Viewer to be assigned to your TreeView ContainerKeyFormatX(70)KeyDatatypecharacterDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object_type NO-LOCK,
                     EACH ryc_smartobject NO-LOCK
                     WHERE ryc_smartobject.OBJECT_type_obj = gsc_object_type.OBJECT_type_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj
                     BY ryc_smartobject.OBJECT_filenameQueryTablesgsc_object_type,ryc_smartobject,gsc_product_moduleBrowseFieldsgsc_product_module.product_module_code,ryc_smartobject.object_filename,gsc_object_type.object_type_codeBrowseFieldDataTypescharacter,character,characterBrowseFieldFormatsX(35)|X(70)|X(35)RowsToBatch200BrowseTitleLookup Filter ViewerViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldfiVisualObjectsParentFilterQueryLOOKUP(gsc_object_type.object_type_code, "&1") > 0|MaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoFieldName<Local_FilterViewer>DisplayFieldyesEnableFieldyesLocalFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hFilterViewer ).
       RUN repositionObject IN hFilterViewer ( 4.14 , 25.00 ) NO-ERROR.
       RUN resizeObject IN hFilterViewer ( 1.00 , 50.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( hRootNodeCode ,
             fiWindowName:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( hLayout ,
             hRootNodeCode , 'AFTER':U ).
       RUN adjustTabOrder ( hFilterViewer ,
             fiVisualObjects:HANDLE IN FRAME frMain , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignValues vTableWin 
PROCEDURE assignValues :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will assing the values back to the temp-table to
               save back to the repository.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMaintenanceObject AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMaintenanceSDO    AS CHARACTER  NO-UNDO.
  

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fiWindowName
           coTreeStyle
           toAutoSort
           toHideSelection
           toShowCheckBoxes
           toShowRootLines
           fiImageHeight
           fiImageWidth.
  END.

  ghDataTable:FIND-FIRST() NO-ERROR.
  IF NOT ghDataTable:AVAILABLE THEN
    RETURN "SAVE-FAILED":U.
  
  
  ASSIGN ghDataTable:BUFFER-FIELD("cWindowName":U):BUFFER-VALUE     = fiWindowName 
         ghDataTable:BUFFER-FIELD('cRootNodeCode':U):BUFFER-VALUE   = DYNAMIC-FUNCTION("getDataValue":U IN hRootNodeCode)
         ghDataTable:BUFFER-FIELD('cLayout':U):BUFFER-VALUE         = DYNAMIC-FUNCTION("getDataValue":U IN hLayout)
         ghDataTable:BUFFER-FIELD('cFilterViewer':U):BUFFER-VALUE   = DYNAMIC-FUNCTION("getDataValue":U IN hFilterViewer)
         ghDataTable:BUFFER-FIELD('iTreeStyle':U):BUFFER-VALUE      = coTreeStyle   
         ghDataTable:BUFFER-FIELD('iImageHeight':U):BUFFER-VALUE    = fiImageHeight       
         ghDataTable:BUFFER-FIELD('iImageWidth':U):BUFFER-VALUE     = fiImageWidth       
         ghDataTable:BUFFER-FIELD('lHideSelection':U):BUFFER-VALUE  = toHideSelection    
         ghDataTable:BUFFER-FIELD('lAutoSort':U):BUFFER-VALUE       = toAutoSort
         ghDataTable:BUFFER-FIELD('lShowCheckBoxes':U):BUFFER-VALUE = toShowCheckBoxes
         ghDataTable:BUFFER-FIELD('lShowRootLines':U):BUFFER-VALUE  = toShowRootLines.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changedAttribute vTableWin 
PROCEDURE changedAttribute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcAttributeName  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcAttributeValue AS CHARACTER  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    CASE pcAttributeName:
      WHEN "WindowName":U THEN
        ASSIGN fiWindowName:SCREEN-VALUE = pcAttributeValue.
      WHEN "RootNodeCode":U THEN
        RUN assignNewValue IN hRootNodeCode (INPUT pcAttributeValue, INPUT pcAttributeValue, TRUE).
      WHEN "TreeStyle":U THEN
        ASSIGN coTreeStyle:SCREEN-VALUE = pcAttributeValue.
      WHEN "AutoSort":U THEN
        toAutoSort:CHECKED = pcAttributeValue = "TRUE" OR pcAttributeValue = "YES".
      WHEN "HideSelection":U THEN
        toHideSelection:CHECKED = pcAttributeValue = "TRUE" OR pcAttributeValue = "YES".
      WHEN "ShowCheckBoxes":U THEN
        toShowCheckBoxes:CHECKED = pcAttributeValue = "TRUE" OR pcAttributeValue = "YES".
      WHEN "ShowRootLines":U THEN
        toShowRootLines:CHECKED = pcAttributeValue = "TRUE" OR pcAttributeValue = "YES".
      WHEN "ImageHeight":U THEN
        fiImageHeight:SCREEN-VALUE = pcAttributeValue.
      WHEN "ImageWidth":U THEN
        fiImageWidth:SCREEN-VALUE = pcAttributeValue.
    END CASE.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changesMade vTableWin 
PROCEDURE changesMade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF glTrackChanges THEN
    PUBLISH "changesMade":U FROM ghContainerSource.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearAll vTableWin 
PROCEDURE clearAll :
/*------------------------------------------------------------------------------
  Purpose:     The header viewer will publish this event to clear the screen
               for new data.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Clear the screen and return */
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fiWindowName:SCREEN-VALUE  = "":U
           coTreeStyle:SCREEN-VALUE   = "0":U
           toAutoSort:CHECKED         = FALSE
           toHideSelection:CHECKED    = FALSE
           toShowCheckBoxes:CHECKED   = FALSE
           toShowRootLines:CHECKED    = FALSE
           fiImageHeight:SCREEN-VALUE = "0":U
           fiImageWidth:SCREEN-VALUE  = "0":U.
  
    RUN assignNewValue IN hRootNodeCode (INPUT "":U,INPUT "":U, FALSE).
    RUN assignNewValue IN hFilterViewer (INPUT "":U,INPUT "":U, FALSE).
    {set DataValue 'TreeView' hLayout}.

    DISABLE ALL WITH FRAME {&FRAME-NAME}.

    RUN disableField IN hRootNodeCode.
    RUN disableField IN hLayout.
    RUN disableField IN hFilterViewer.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE comboValueChanged vTableWin 
PROCEDURE comboValueChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcKeyFieldValue  AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcScreenValue    AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER phField          AS HANDLE     NO-UNDO.

  IF glTrackChanges THEN
    PUBLISH "changesMade":U FROM ghContainerSource.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableObject vTableWin 
PROCEDURE disableObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DISABLE ALL WITH FRAME {&FRAME-NAME}.

    RUN disableField IN hRootNodeCode.
    RUN disableField IN hLayout.
    RUN disableField IN hFilterViewer.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject vTableWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainerSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hLookupHandle    AS HANDLE     NO-UNDO.
  /* Code placed here will execute PRIOR to standard behavior. */
  
  ASSIGN fiVisualObjects = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "Viewer,StaticSO":U)
         fiVisualObjects = REPLACE(fiVisualObjects, CHR(3), ",":U)
         fiVisualObjects:SCREEN-VALUE IN FRAME {&FRAME-NAME} = fiVisualObjects.

  {get ContainerSource ghContainerSource}.
  SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "lookupComplete":U         IN THIS-PROCEDURE.
  SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "comboValueChanged":U      IN THIS-PROCEDURE.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN displayFields ("?":U).
  {get ContainerSource hContainerSource}.
  IF VALID-HANDLE(hContainerSource) THEN DO:
    SUBSCRIBE TO "clearAll":U IN hContainerSource.
    SUBSCRIBE TO "disableObject":U IN hContainerSource.
  END.

  SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "ChangedAttribute":U IN hContainerSource.

  {get LookupHandle hLookupHandle hRootNodeCode}.
  ON VALUE-CHANGED OF hLookupHandle PERSISTENT RUN rootNodeChangesMade IN TARGET-PROCEDURE. 
  {get LookupHandle hLookupHandle hFilterViewer}.
  ON VALUE-CHANGED OF hLookupHandle PERSISTENT RUN changesMade IN TARGET-PROCEDURE. 

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
  DEFINE INPUT  PARAMETER pcColumnNames           AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcColumnValues          AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcKeyFieldValue         AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcDisplayedFieldValue   AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcOldFieldValue         AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER plLookup                AS LOGICAL      NO-UNDO.
  DEFINE INPUT  PARAMETER phObject                AS HANDLE       NO-UNDO.

  IF pcDisplayedFieldValue <> pcOldFieldValue AND
     pcDisplayedFieldValue <> "":U THEN DO:
    IF glTrackChanges THEN DO:
      PUBLISH "changesMade":U FROM ghContainerSource.
      IF phObject = hRootNodeCode THEN
        PUBLISH "changedAttribute" FROM ghContainerSource (INPUT "RootNodeCode":U, pcDisplayedFieldValue, "character":U).
    END.
  END.
          
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setInfo vTableWin 
PROCEDURE setInfo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phDataTable AS HANDLE     NO-UNDO.
  
  phDataTable:FIND-FIRST().
  IF NOT phDataTable:AVAILABLE THEN
    RETURN.
  
  ghDataTable = phDataTable.

  DO WITH FRAME {&FRAME-NAME}:
    glTrackChanges = FALSE.
    
    ASSIGN fiWindowName:SCREEN-VALUE  = phDataTable:BUFFER-FIELD("cWindowName":U):BUFFER-VALUE 
           coTreeStyle:SCREEN-VALUE   = STRING(phDataTable:BUFFER-FIELD('iTreeStyle':U):BUFFER-VALUE)
           fiImageHeight:SCREEN-VALUE = STRING(phDataTable:BUFFER-FIELD('iImageHeight':U):BUFFER-VALUE)
           fiImageWidth:SCREEN-VALUE  = STRING(phDataTable:BUFFER-FIELD('iImageWidth':U):BUFFER-VALUE)
           toHideSelection:CHECKED    = phDataTable:BUFFER-FIELD('lHideSelection':U):BUFFER-VALUE
           toAutoSort:CHECKED         = phDataTable:BUFFER-FIELD('lAutoSort':U):BUFFER-VALUE
           toShowCheckBoxes:CHECKED   = phDataTable:BUFFER-FIELD('lShowCheckBoxes':U):BUFFER-VALUE
           toShowRootLines:CHECKED    = phDataTable:BUFFER-FIELD('lShowRootLines':U):BUFFER-VALUE.
    
    RUN assignNewValue IN hRootNodeCode (ghDataTable:BUFFER-FIELD('cRootNodeCode':U):BUFFER-VALUE,ghDataTable:BUFFER-FIELD('cRootNodeCode':U):BUFFER-VALUE,FALSE).
    RUN assignNewValue IN hFilterViewer (ghDataTable:BUFFER-FIELD('cFilterViewer':U):BUFFER-VALUE,ghDataTable:BUFFER-FIELD('cFilterViewer':U):BUFFER-VALUE,FALSE).
    DYNAMIC-FUNCTION("setDataValue":U IN hLayout, ghDataTable:BUFFER-FIELD('cLayout':U):BUFFER-VALUE). 
    RUN valueChanged IN hLayout.
    
    glTrackChanges = TRUE.
    ENABLE ALL EXCEPT fiVisualObjects WITH FRAME {&FRAME-NAME}.
    RUN enableField IN hRootNodeCode.
    RUN enableField IN hLayout.
    RUN enableField IN hFilterViewer.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateData vTableWin 
PROCEDURE validateData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER pcError AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cRootNodeCode AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLayout       AS CHARACTER  NO-UNDO.

  ASSIGN cRootNodeCode = DYNAMIC-FUNCTION("getDataValue":U IN hRootNodeCode)
         cLayout       = DYNAMIC-FUNCTION("getDataValue":U IN hLayout). 
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fiWindowName
           coTreeStyle
           toAutoSort
           toHideSelection
           toShowCheckBoxes
           toShowRootLines
           fiImageHeight
           fiImageWidth.
  END.
  
  IF cLayout = "":U THEN 
    pcError = pcError + (IF NUM-ENTRIES(pcError,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                  {af/sup2/aferrortxt.i 'AF' '1' '' '' '"Layout"'}.

  IF LOOKUP(coTreeStyle,"1,3,5,7":U) > 0 THEN DO:
    IF fiImageHeight = 0 THEN 
      pcError = pcError + (IF NUM-ENTRIES(pcError,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '5' '' '' '"Image Height"' '"The Image height must be more than zero (0)."'}.

   IF fiImageWidth = 0 THEN 
     pcError = pcError + (IF NUM-ENTRIES(pcError,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                   {af/sup2/aferrortxt.i 'AF' '5' '' '' '"Image Width"' '"The Image width must be more than zero (0)."'}.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
 
&IF DEFINED(EXCLUDE-rootNodeChangesMade) = 0 &THEN
		
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rootNodeChangesMade Include
PROCEDURE rootNodeChangesMade:

	/*------------------------------------------------------------------------------
			Purpose:
			Notes:
	------------------------------------------------------------------------------*/
	DEFINE VARIABLE comboValue AS CHARACTER NO-UNDO.

	ASSIGN comboValue = DYNAMIC-FUNCTION("getDataValue":U IN hRootNodeCode).

    PUBLISH "changesMade":U FROM ghContainerSource.
    PUBLISH "changedAttribute" FROM ghContainerSource (INPUT "RootNodeCode":U, comboValue, "character":U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataTable vTableWin 
FUNCTION getDataTable RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN ghDataTable.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


