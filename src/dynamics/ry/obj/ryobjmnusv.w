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
       {"ry/obj/ryemptysdo.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin
/**********************************************************************************/
/* Copyright (C) 2005-2006 by Progress Software Corporation. All rights reserved. */
/* Prior versions of this work may contain portions contributed by                */
/* participants of Possenet.                                                      */             
/**********************************************************************************/
/*---------------------------------------------------------------------------------
  File: rygridobjv1.w

  Description:  Object Instance Grid Viewer

  Purpose:      Object Instance Grid Viewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   03/25/2002  Author:     Chris Koster

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

&scop object-name       ryobjmnusv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{src/adm2/globals.i}

DEFINE VARIABLE gcClassesNotAllowed AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcMSLookupValues    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcColumnWidths      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcBaseQuery         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcTitle             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ghContainerSource   AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghParentContainer   AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghContainerHandle   AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghParentCHandle     AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghMenuStructure     AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghToolbar           AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghBrowse            AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghQuery             AS HANDLE     NO-UNDO.

DEFINE VARIABLE cEmptyItemLabel     AS CHARACTER  NO-UNDO INITIAL "< Item has no label >".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "ry/obj/ryemptysdo.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS buAdd toSubMenu fiMenuStructureTitle 
&Scoped-Define DISPLAYED-OBJECTS fiLabel fiDescription toSubMenu ~
fiMenuStructureTitle 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */
&Scoped-define ADM-ASSIGN-FIELDS buTransfer buAdd buCancel buDelete buSave ~
buUndo 
&Scoped-define List-2 buTransfer buAdd buDelete 
&Scoped-define List-3 buCancel buSave 
&Scoped-define List-4 buSave buUndo 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD evaluateActions vTableWin 
FUNCTION evaluateActions RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getContainerType vTableWin 
FUNCTION getContainerType RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD positionButton vTableWin 
FUNCTION positionButton RETURNS LOGICAL
  (phButton AS HANDLE,
   phSource AS HANDLE,
   plBelow  AS LOGICAL) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD reopenBrowseQuery vTableWin 
FUNCTION reopenBrowseQuery RETURNS LOGICAL
    (pdObjectMenuStructureObj AS DECIMAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE hInstanceAttribute AS HANDLE NO-UNDO.
DEFINE VARIABLE hMenuItem AS HANDLE NO-UNDO.
DEFINE VARIABLE hMenuStructure AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buAdd 
     IMAGE-UP FILE "adeicon/new.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "Add" 
     SIZE 4.8 BY 1.14 TOOLTIP "Add"
     BGCOLOR 8 .

DEFINE BUTTON buCancel 
     IMAGE-UP FILE "ry/img/objectcancel.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "Cancel" 
     SIZE 4.8 BY 1.14 TOOLTIP "Cancel"
     BGCOLOR 8 .

DEFINE BUTTON buDelete 
     IMAGE-UP FILE "ry/img/objectdelete.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "Delete" 
     SIZE 4.8 BY 1.14 TOOLTIP "Delete"
     BGCOLOR 8 .

DEFINE BUTTON buMoveDown 
     IMAGE-UP FILE "ry/img/movedown.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "Move Down" 
     SIZE 4.8 BY 1.14 TOOLTIP "Move down"
     BGCOLOR 8 .

DEFINE BUTTON buMoveUp 
     IMAGE-UP FILE "ry/img/moveup.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "Move Up" 
     SIZE 4.8 BY 1.14 TOOLTIP "Move up"
     BGCOLOR 8 .

DEFINE BUTTON buSave 
     IMAGE-UP FILE "adeicon/save.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "Save" 
     SIZE 4.8 BY 1.14 TOOLTIP "Save"
     BGCOLOR 8 .

DEFINE BUTTON buTransfer 
     IMAGE-UP FILE "ry/img/aftoexcel.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "Move Up" 
     SIZE 4.8 BY 1.14 TOOLTIP "Move up"
     BGCOLOR 8 .

DEFINE BUTTON buUndo 
     IMAGE-UP FILE "ry/img/objectundo.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "Undo" 
     SIZE 4.8 BY 1.14 TOOLTIP "Undo"
     BGCOLOR 8 .

DEFINE VARIABLE fiDescription AS CHARACTER FORMAT "X(256)":U 
     LABEL "Description" 
     VIEW-AS FILL-IN 
     SIZE 45.2 BY 1 NO-UNDO.

DEFINE VARIABLE fiLabel AS CHARACTER FORMAT "X(256)":U 
     LABEL "Label" 
     VIEW-AS FILL-IN 
     SIZE 45.2 BY 1 NO-UNDO.

DEFINE VARIABLE fiMenuStructureTitle AS CHARACTER FORMAT "X(256)":U INITIAL " Object menu structures" 
      VIEW-AS TEXT 
     SIZE 23.6 BY .62 NO-UNDO.

DEFINE RECTANGLE rctBorder
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 75.6 BY 10.95.

DEFINE RECTANGLE rctSeperator1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE .4 BY 1.14.

DEFINE RECTANGLE rctSeperator2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE .4 BY 1.14.

DEFINE RECTANGLE rctToolbar
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 75.6 BY 1.33.

DEFINE VARIABLE toSubMenu AS LOGICAL INITIAL no 
     LABEL "Insert submenu" 
     VIEW-AS TOGGLE-BOX
     SIZE 19.2 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     buTransfer AT ROW 4.38 COL 39.4
     buMoveDown AT ROW 4.38 COL 32.6
     buMoveUp AT ROW 4.38 COL 27.8
     fiLabel AT ROW 6.91 COL 21 COLON-ALIGNED
     fiDescription AT ROW 7.95 COL 21 COLON-ALIGNED
     buAdd AT ROW 4.38 COL 1.8
     buCancel AT ROW 4.38 COL 21.2
     buDelete AT ROW 4.38 COL 6.8
     toSubMenu AT ROW 11.19 COL 24
     buSave AT ROW 4.38 COL 11.6
     buUndo AT ROW 4.38 COL 16.4
     fiMenuStructureTitle AT ROW 1 COL 2.2 NO-LABEL
     rctSeperator2 AT ROW 4.29 COL 38
     rctBorder AT ROW 1.29 COL 1
     rctToolbar AT ROW 4.29 COL 1
     rctSeperator1 AT ROW 4.29 COL 26.4
     SPACE(46.20) SKIP(5.62)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "ry/obj/ryemptysdo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {ry/obj/ryemptysdo.i}
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
         WIDTH              = 75.6.
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

/* SETTINGS FOR BUTTON buAdd IN FRAME frMain
   1 2                                                                  */
/* SETTINGS FOR BUTTON buCancel IN FRAME frMain
   NO-ENABLE 1 3                                                        */
/* SETTINGS FOR BUTTON buDelete IN FRAME frMain
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR BUTTON buMoveDown IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON buMoveUp IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON buSave IN FRAME frMain
   NO-ENABLE 1 3 4                                                      */
/* SETTINGS FOR BUTTON buTransfer IN FRAME frMain
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR BUTTON buUndo IN FRAME frMain
   NO-ENABLE 1 4                                                        */
/* SETTINGS FOR FILL-IN fiDescription IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiLabel IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiMenuStructureTitle IN FRAME frMain
   ALIGN-L                                                              */
/* SETTINGS FOR RECTANGLE rctBorder IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rctSeperator1 IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rctSeperator2 IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rctToolbar IN FRAME frMain
   NO-ENABLE                                                            */
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

&Scoped-define SELF-NAME buAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buAdd vTableWin
ON CHOOSE OF buAdd IN FRAME frMain /* Add */
DO:
  RUN addRecord.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buCancel vTableWin
ON CHOOSE OF buCancel IN FRAME frMain /* Cancel */
DO:
  RUN cancelRecord.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDelete vTableWin
ON CHOOSE OF buDelete IN FRAME frMain /* Delete */
DO:
  RUN deleteRecord.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buMoveDown
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buMoveDown vTableWin
ON CHOOSE OF buMoveDown IN FRAME frMain /* Move Down */
DO:
  RUN moveUpDown (INPUT "DOWN":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buMoveUp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buMoveUp vTableWin
ON CHOOSE OF buMoveUp IN FRAME frMain /* Move Up */
DO:
  RUN moveUpDown (INPUT "UP":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSave vTableWin
ON CHOOSE OF buSave IN FRAME frMain /* Save */
DO:
  RUN saveRecord.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buTransfer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buTransfer vTableWin
ON CHOOSE OF buTransfer IN FRAME frMain /* Move Up */
DO:
  RUN transferToExcel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buUndo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buUndo vTableWin
ON CHOOSE OF buUndo IN FRAME frMain /* Undo */
DO:
  RUN undoChanges.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toSubMenu
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toSubMenu vTableWin
ON VALUE-CHANGED OF toSubMenu IN FRAME frMain /* Insert submenu */
DO:
  DEFINE VARIABLE cContainerMode  AS CHARACTER  NO-UNDO.

  cContainerMode = DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ContainerMode":U).
  
  IF cContainerMode <> "UPDATE":U AND
     cContainerMode <> "ADD":U    THEN
  DO:
    DYNAMIC-FUNCTION("setUserProperty":U IN ghContainerSource, "ContainerMode":U, "UPDATE":U).
    DYNAMIC-FUNCTION("evaluateActions":U).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addRecord vTableWin 
PROCEDURE addRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iMenuStructureSequence  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE httObjectMenuStructure  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httSmartObject          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hLookupFillIn           AS HANDLE     NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    DYNAMIC-FUNCTION("setUserProperty":U IN ghContainerSource, "ContainerMode":U, "ADD":U).

    DYNAMIC-FUNCTION("evaluateActions":U).

    ghMenuStructure:BUFFER-CREATE().

    ASSIGN
        dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "CustomizationResultObj":U))
        httObjectMenuStructure  = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttObjectMenuStructure":U))
        httSmartObject          = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttSmartObject":U)).

    httSmartObject:FIND-FIRST("WHERE d_smartobject_obj <> 0 AND d_customization_result_obj = ":U + QUOTER(dCustomizationResultObj)).

    CREATE BUFFER httObjectMenuStructure FOR TABLE httObjectMenuStructure.

    httObjectMenuStructure:FIND-LAST("WHERE d_customization_result_obj = ":U + QUOTER(dCustomizationResultObj)
                                    + " AND c_action                  <> 'D'":U) NO-ERROR.

    IF httObjectMenuStructure:AVAILABLE THEN
      iMenuStructureSequence = httObjectMenuStructure:BUFFER-FIELD("i_menu_structure_sequence":U):BUFFER-VALUE.

    ASSIGN
        gcMSLookupValues = "":U

        ghMenuStructure:BUFFER-FIELD("d_object_menu_structure_obj":U):BUFFER-VALUE = DYNAMIC-FUNCTION("getTemporaryObj":U IN ghParentContainer)
        ghMenuStructure:BUFFER-FIELD("d_customization_result_obj":U):BUFFER-VALUE  = dCustomizationResultObj
        ghMenuStructure:BUFFER-FIELD("c_action":U):BUFFER-VALUE                    = "A":U
        ghMenuStructure:BUFFER-FIELD("l_insert_submenu":U):BUFFER-VALUE            = TRUE
        ghMenuStructure:BUFFER-FIELD("d_object_obj":U):BUFFER-VALUE                = httSmartObject:BUFFER-FIELD("d_smartobject_obj":U):BUFFER-VALUE
        ghMenuStructure:BUFFER-FIELD("i_menu_structure_sequence":U):BUFFER-VALUE   = iMenuStructureSequence + 1.

    RUN refreshData (INPUT "":U, 
                     INPUT ghMenuStructure:BUFFER-FIELD("d_object_menu_structure_obj":U):BUFFER-VALUE).

    DELETE OBJECT httObjectMenuStructure.

    {get LookupHandle hLookupFillIn hMenuStructure}.
    
    APPLY "ENTRY":U TO hLookupFillIn.

    ghBrowse:SENSITIVE = FALSE.
  END.

  RETURN.

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
             INPUT  'DisplayedFieldgsm_menu_structure.menu_structure_codeKeyFieldgsm_menu_structure.menu_structure_objFieldLabelMenu structureFieldTooltipPress F4 For LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(28)DisplayDatatypecharacterBaseQueryStringFOR EACH gsm_menu_structure NO-LOCK
                     WHERE gsm_menu_structure.menu_structure_type = "SubMenu":U,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = gsm_menu_structure.product_module_obj
                     AND [&FilterSet=|&EntityList=GSCPM] OUTER-JOIN,
                     FIRST gsm_menu_item NO-LOCK
                     WHERE gsm_menu_item.menu_item_obj = gsm_menu_structure.menu_item_obj OUTER-JOIN
                     BY gsm_menu_structure.menu_structure_code INDEXED-REPOSITIONQueryTablesgsm_menu_structure,gsc_product_module,gsm_menu_itemBrowseFieldsgsm_menu_structure.menu_structure_code,gsm_menu_structure.menu_structure_description,gsm_menu_structure.menu_structure_hidden,gsc_product_module.product_module_code,gsm_menu_structure.system_owned,gsm_menu_structure.disabled,gsm_menu_item.menu_item_labelBrowseFieldDataTypescharacter,character,logical,character,logical,logical,characterBrowseFieldFormatsX(28)|X(35)|YES/NO|X(35)|YES/NO|YES/NO|X(28)RowsToBatch200BrowseTitleMenu Structure LookupViewerLinkedFieldsgsm_menu_structure.menu_structure_code,gsm_menu_structure.menu_structure_description,gsm_menu_item.menu_item_labelLinkedFieldDataTypescharacter,character,characterLinkedFieldFormatsX(28),X(35),X(28)ViewerLinkedWidgets?,?,?ColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesFieldNamedMenuStructureDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hMenuStructure ).
       RUN repositionObject IN hMenuStructure ( 5.86 , 23.00 ) NO-ERROR.
       RUN resizeObject IN hMenuStructure ( 1.00 , 50.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_instance_attribute.attribute_codeKeyFieldgsc_instance_attribute.instance_attribute_objFieldLabelInstance attributeFieldTooltipPress F4 For LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(35)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_instance_attribute NO-LOCK INDEXED-REPOSITIONQueryTablesgsc_instance_attributeBrowseFieldsgsc_instance_attribute.attribute_code,gsc_instance_attribute.attribute_description,gsc_instance_attribute.attribute_type,gsc_instance_attribute.disabled,gsc_instance_attribute.system_ownedBrowseFieldDataTypescharacter,character,character,logical,logicalBrowseFieldFormatsX(35)|X(500)|X(3)|YES/NO|YES/NORowsToBatch200BrowseTitleInstance Attribute LookupViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListNO-LOCK INDEXED-REPOSITIONQueryBuilderOrderListQueryBuilderTableOptionListNO-LOCKQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesFieldNamedInstanceAttributeDisplayFieldyesEnableFieldnoLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hInstanceAttribute ).
       RUN repositionObject IN hInstanceAttribute ( 9.00 , 23.00 ) NO-ERROR.
       RUN resizeObject IN hInstanceAttribute ( 1.00 , 50.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsm_menu_item.menu_item_labelKeyFieldgsm_menu_item.menu_item_objFieldLabelItem placeholderFieldTooltipPress F4 For LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(28)DisplayDatatypecharacterBaseQueryStringFOR EACH gsm_menu_item NO-LOCK WHERE item_control_type = ~'placeholder~' INDEXED-REPOSITIONQueryTablesgsm_menu_itemBrowseFieldsgsm_menu_item.menu_item_label,gsm_menu_item.menu_item_descriptionBrowseFieldDataTypescharacter,characterBrowseFieldFormatsX(28)|X(35)RowsToBatch200BrowseTitleMenu Item LookupViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesFieldNamecEmptyFieldDisplayFieldyesEnableFieldnoLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hMenuItem ).
       RUN repositionObject IN hMenuItem ( 10.05 , 23.00 ) NO-ERROR.
       RUN resizeObject IN hMenuItem ( 1.00 , 50.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( hMenuItem ,
             hInstanceAttribute , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelRecord vTableWin 
PROCEDURE cancelRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DYNAMIC-FUNCTION("setUserProperty":U IN ghContainerSource, "ContainerMode":U, "MODIFY":U).

  ghMenuStructure:BUFFER-DELETE().

  RUN refreshData (INPUT "":U, INPUT 0.00).

  DYNAMIC-FUNCTION("evaluateActions":U).
  
  ghBrowse:SENSITIVE = TRUE.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE containerTypeChange vTableWin 
PROCEDURE containerTypeChange :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER plDataContainer  AS LOGICAL  NO-UNDO.

  {fn evaluateActions}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createBrowse vTableWin 
PROCEDURE createBrowse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cQueryPrepare     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumnName       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iFieldLoop        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hColumn           AS HANDLE     NO-UNDO EXTENT 6.
  DEFINE VARIABLE hBuffer           AS HANDLE     NO-UNDO.
  
  SESSION:SET-WAIT-STATE("GENERAL":U).

  CREATE QUERY ghQuery.

  ghQuery:SET-BUFFERS(ghMenuStructure).

  CREATE BROWSE ghBrowse
  ASSIGN FRAME            = FRAME {&FRAME-NAME}:HANDLE
         NAME             = "StructureBrowse"
         SEPARATORS       = TRUE
         ROW-MARKERS      = FALSE
         EXPANDABLE       = TRUE
         COLUMN-RESIZABLE = TRUE
         QUERY            = ghQuery
         REFRESHABLE      = YES
  TRIGGERS:            
      ON "VALUE-CHANGED":U  PERSISTENT RUN itemSelected IN THIS-PROCEDURE.
  END TRIGGERS.

  ASSIGN
      hColumn[1] = ghBrowse:ADD-LIKE-COLUMN(ghMenuStructure:BUFFER-FIELD("c_menu_item_label":U))
      hColumn[2] = ghBrowse:ADD-LIKE-COLUMN(ghMenuStructure:BUFFER-FIELD("c_menu_structure_code":U))
      hColumn[3] = ghBrowse:ADD-LIKE-COLUMN(ghMenuStructure:BUFFER-FIELD("c_menu_structure_description":U))
      hColumn[4] = ghBrowse:ADD-LIKE-COLUMN(ghMenuStructure:BUFFER-FIELD("c_attribute_code":U))
      hColumn[5] = ghBrowse:ADD-LIKE-COLUMN(ghMenuStructure:BUFFER-FIELD("c_item_placeholder_label":U))
      hColumn[6] = ghBrowse:ADD-LIKE-COLUMN(ghMenuStructure:BUFFER-FIELD("l_insert_submenu":U)).

  DO iFieldLoop = 1 TO ghBrowse:NUM-COLUMNS:
    cEntry = ENTRY(iFieldLoop, gcColumnWidths, "^":U).

    IF INTEGER(cEntry) <> 0 THEN
      hColumn[iFieldLoop]:WIDTH-PIXELS = INTEGER(cEntry).
  END.

  /* And show the browse to the user */
  ASSIGN
      ghBrowse:SENSITIVE = TRUE
      ghBrowse:VISIBLE   = YES
      gcBaseQuery        = "FOR EACH ttObjectMenuStructure":U
                         + "   WHERE ttObjectMenuStructure.c_action <> 'D'":U
                         + "      BY ttObjectMenuStructure.d_customization_result_obj":U
                         + "      BY ttObjectMenuStructure.i_menu_structure_sequence ":U.

  SESSION:SET-WAIT-STATE("":U).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteRecord vTableWin 
PROCEDURE deleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  ghMenuStructure:BUFFER-FIELD("c_action":U):BUFFER-VALUE = "D":U.

  RUN refreshData (INPUT "":U, 0.00).
  
  IF DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ContainerMode":U) <> "UPDATE":U AND
     DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ContainerMode":U) <> "ADD":U    THEN
  DO:
    DYNAMIC-FUNCTION("setUserProperty":U IN ghParentContainer, "ContainerMode":U, "UPDATE":U).
    DYNAMIC-FUNCTION("evaluateActions":U IN ghParentContainer).
  END.

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

  /* Code placed here will execute PRIOR to standard behavior. */
  DEFINE VARIABLE cPreferences  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iColumn       AS INTEGER    NO-UNDO.

  cPreferences = "ColumnWidths":U  + "|":U.

  DO iColumn = 1 TO ghBrowse:NUM-COLUMNS:
    cPreferences = cPreferences + STRING(ghBrowse:GET-BROWSE-COLUMN(iColumn):WIDTH-PIXELS) + "^":U.
  END.

  cPreferences = TRIM(cPreferences, "^":U).

  IF VALID-HANDLE(gshProfileManager) THEN
    RUN setProfileData IN gshProfileManager (INPUT "Window":U,          /* Profile type code      */
                                             INPUT "CBuilder":U,        /* Profile code           */
                                             INPUT "ObjMSPreferences",  /* Profile data key       */
                                             INPUT ?,                   /* Rowid of profile data  */
                                             INPUT cPreferences,        /* Profile data value     */
                                             INPUT NO,                  /* Delete flag            */
                                             INPUT "PER":U).            /* Save flag (permanent)  */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  IF VALID-HANDLE(ghMenuStructure) THEN
    DELETE OBJECT ghMenuStructure.
  
  IF VALID-HANDLE(ghBrowse) THEN
    DELETE OBJECT ghBrowse.

  IF VALID-HANDLE(ghQuery) THEN
    DELETE OBJECT ghQuery.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getProfileData vTableWin 
PROCEDURE getProfileData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cPrefs  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iEntry  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE rRowId  AS ROWID      NO-UNDO.

  ASSIGN
      gcColumnWidths  = "0^0^0^0^0^0":U.
  
  IF VALID-HANDLE(gshProfileManager) THEN
    RUN getProfileData IN gshProfileManager (INPUT "Window":U,            /* Profile type code     */
                                             INPUT "CBuilder":U,          /* Profile code          */
                                             INPUT "ObjMSPreferences":U,  /* Profile data key      */
                                             INPUT "NO":U,                /* Get next record flag  */
                                             INPUT-OUTPUT rRowid,         /* Rowid of profile data */
                                             OUTPUT cPrefs).              /* Found profile data.   */

  /* --- Preference lookup --------------------- */ /* --- Preference value assignment --------------------------------- */
  iEntry = LOOKUP("ColumnWidths":U, cPrefs, "|":U). IF iEntry <> 0 THEN gcColumnWidths  = ENTRY(iEntry + 1, cPrefs, "|":U).

  RETURN.

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
  {get ContainerSource ghContainerSource}.
  {get ContainerSource ghParentContainer ghContainerSource}.
  {get ContainerHandle ghContainerHandle ghContainerSource}.
  {get ContainerHandle ghParentCHandle   ghParentContainer}.

  SUBSCRIBE TO "containerTypeChange":U  IN ghParentContainer.
  SUBSCRIBE TO "refreshData":U          IN ghParentContainer.
  SUBSCRIBE TO "takeAction":U           IN ghContainerSource.
  SUBSCRIBE TO "lookupComplete":U       IN THIS-PROCEDURE.

  DYNAMIC-FUNCTION("setUserProperty":U IN ghContainerSource, "promptAddition":U, "the container's menu structures").

  /* Setup the browse */
  ghMenuStructure = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttObjectMenuStructure":U)).

  CREATE BUFFER ghMenuStructure FOR TABLE ghMenuStructure.

  RUN getProfileData.
  RUN createBrowse.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  {get ContainerToolbarSource ghToolbar ghContainerSource}.

  gcTitle = ghContainerHandle:TITLE + " - ":U.
  
  RUN resizeObject (INPUT FRAME {&FRAME-NAME}:HEIGHT-CHARS, INPUT FRAME {&FRAME-NAME}:WIDTH-CHARS).

  SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "toolbar":U IN ghToolbar.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE itemSelected vTableWin 
PROCEDURE itemSelected :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cContainerMode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lSuccess        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hMSFillIn       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hIAFillIn       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hMIFillIn       AS HANDLE     NO-UNDO.

  /* The browse was disabled because of add/update mode so no need to continue */
  IF NOT ghBrowse:SENSITIVE THEN
    RETURN.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        cContainerMode = DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ContainerMode":U)
        hMSFillIn      = DYNAMIC-FUNCTION("getLookupHandle":U IN hMenuStructure)
        hIAFillIn      = DYNAMIC-FUNCTION("getLookupHandle":U IN hInstanceAttribute)
        hMIFillIn      = DYNAMIC-FUNCTION("getLookupHandle":U IN hMenuItem).

    IF ghMenuStructure:AVAILABLE THEN
    DO:
      IF ghMenuStructure:BUFFER-FIELD("c_item_placeholder_label":U):BUFFER-VALUE = "":U AND
         ghMenuStructure:BUFFER-FIELD("d_menu_item_obj":U):BUFFER-VALUE         <> 0.00 THEN
        ASSIGN
            ghMenuStructure:BUFFER-FIELD("c_item_placeholder_label":U):BUFFER-VALUE = cEmptyItemLabel.

      ASSIGN
          hMSFillIn:SCREEN-VALUE     = ghMenuStructure:BUFFER-FIELD("c_menu_structure_code":U):BUFFER-VALUE
          hIAFillIn:SCREEN-VALUE     = ghMenuStructure:BUFFER-FIELD("c_attribute_code":U):BUFFER-VALUE
          hMIFillIn:SCREEN-VALUE     = ghMenuStructure:BUFFER-FIELD("c_item_placeholder_label":U):BUFFER-VALUE
          fiDescription:SCREEN-VALUE = ghMenuStructure:BUFFER-FIELD("c_menu_structure_description":U):BUFFER-VALUE
          fiLabel:SCREEN-VALUE       = ghMenuStructure:BUFFER-FIELD("c_menu_item_label":U):BUFFER-VALUE
          toSubMenu:CHECKED          = ghMenuStructure:BUFFER-FIELD("l_insert_submenu":U):BUFFER-VALUE
          toSubMenu:SENSITIVE        = TRUE

          lSuccess = DYNAMIC-FUNCTION("setDataValue":U IN hMenuStructure,     ghMenuStructure:BUFFER-FIELD("d_menu_structure_obj":U):BUFFER-VALUE)
          lSuccess = DYNAMIC-FUNCTION("setDataValue":U IN hInstanceAttribute, ghMenuStructure:BUFFER-FIELD("d_instance_attribute_obj":U):BUFFER-VALUE)
          lSuccess = DYNAMIC-FUNCTION("setDataValue":U IN hMenuItem,          ghMenuStructure:BUFFER-FIELD("d_menu_item_obj":U):BUFFER-VALUE).

      IF cContainerMode <> "ADD":U THEN
        DYNAMIC-FUNCTION("setUserProperty":U IN ghContainerSource, "ContainerMode":U, "MODIFY":U).
    END.
    ELSE
    DO:
      ASSIGN
          hMSFillIn:SCREEN-VALUE     = "":U
          hIAFillIn:SCREEN-VALUE     = "":U
          hMIFillIn:SCREEN-VALUE     = "":U
          fiDescription:SCREEN-VALUE = "":U
          fiLabel:SCREEN-VALUE       = "":U
          toSubMenu:CHECKED          = FALSE
          toSubMenu:SENSITIVE        = TRUE

          lSuccess = DYNAMIC-FUNCTION("setDataValue":U IN hMenuStructure,     0.00)
          lSuccess = DYNAMIC-FUNCTION("setDataValue":U IN hInstanceAttribute, 0.00)
          lSuccess = DYNAMIC-FUNCTION("setDataValue":U IN hMenuItem,          0.00).

      IF ghQuery:NUM-RESULTS <= 0 THEN
        DYNAMIC-FUNCTION("setUserProperty":U IN ghContainerSource, "ContainerMode":U, "NoDATA":U).
    END.
  
    DYNAMIC-FUNCTION("evaluateActions":U).
  END.

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
  DEFINE INPUT  PARAMETER pcColumnNames   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcColumnValues  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcKeyFieldValue AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcNewValue      AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcOldValue      AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plWhere         AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER phLookup        AS HANDLE     NO-UNDO.

  DEFINE VARIABLE cContainerMode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDescription    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabel          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hFillIn         AS HANDLE     NO-UNDO.

  cContainerMode = DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ContainerMode":U).

  IF phLookup = hMenuStructure THEN
  DO:
    IF NUM-ENTRIES(pcColumnValues, CHR(1)) >= 4 THEN
    DO WITH FRAME {&FRAME-NAME}:
    
      cLabel = ENTRY(LOOKUP("gsm_menu_item.menu_item_label":U, pcColumnNames), pcColumnValues, CHR(1)).
  
      IF cLabel = "?":U OR
         cLabel = "":U  THEN
        cLabel = ENTRY(LOOKUP("gsm_menu_structure.menu_structure_code":U, pcColumnNames), pcColumnValues, CHR(1)).
      
      ASSIGN
          cDescription               = ENTRY(LOOKUP("gsm_menu_structure.menu_structure_description":U, pcColumnNames), pcColumnValues, CHR(1))
          fiDescription:SCREEN-VALUE = cDescription
          fiLabel:SCREEN-VALUE       = cLabel.
  
      IF phLookup = hMenuStructure THEN
        gcMSLookupValues = pcColumnNames + CHR(3) + pcColumnValues.
    END.
  END.
  
  IF phLookup = hMenuItem THEN
  DO:
    hFillIn = {fn getLookupHandle hMenuItem}.
    
    IF {fn getDataValue hMenuItem} <> 0.00 AND hFillIn:SCREEN-VALUE = "":U THEN
    DO:
      ASSIGN
          hFillIn:SCREEN-VALUE                                                    = cEmptyItemLabel
          ghMenuStructure:BUFFER-FIELD("c_item_placeholder_label":U):BUFFER-VALUE = hFillIn:SCREEN-VALUE.

      {set SavedScreenValue hFillIn:SCREEN-VALUE hMenuItem}.
    END.
  END.

  IF cContainerMode <> "UPDATE":U AND
     cContainerMode <> "ADD":U    THEN
  DO:
    DYNAMIC-FUNCTION("setUserProperty":U IN ghContainerSource, "ContainerMode":U, "UPDATE":U).
    DYNAMIC-FUNCTION("evaluateActions":U).
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE moveUpDown vTableWin 
PROCEDURE moveUpDown :
/*------------------------------------------------------------------------------
  Purpose:  Swap two adjacent menu structure records' sequence numbers

  Parameters: INPUT pcDirection - Indicator to see in which direction the structure
                                  item should be swapped. 'UP' to move it upward,
                                  'DOWN' to move it downward.

  Notes:  No checking will be done in this procedure for the validity of
          the move. This was done by the function 'evaluateActions' that
          determined the sensitivity of the Up/Down buttons.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcDirection  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE iCurrentSequence        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE httObjectMenuStructure  AS HANDLE     NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        httObjectMenuStructure = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttObjectMenuStructure":U))
        iCurrentSequence       = ghMenuStructure:BUFFER-FIELD("i_menu_structure_sequence":U):BUFFER-VALUE.

    IF pcDirection = "UP":U THEN
      httObjectMenuStructure:FIND-LAST("WHERE d_customization_result_obj = ":U + QUOTER(ghMenuStructure:BUFFER-FIELD("d_customization_result_obj":U):BUFFER-VALUE)
                                      + " AND i_menu_structure_sequence  < ":U + STRING(iCurrentSequence)
                                      + " AND c_action                  <> 'D'":U) NO-ERROR.
    ELSE
      httObjectMenuStructure:FIND-FIRST("WHERE d_customization_result_obj = ":U + QUOTER(ghMenuStructure:BUFFER-FIELD("d_customization_result_obj":U):BUFFER-VALUE)
                                       + " AND i_menu_structure_sequence  > ":U + STRING(iCurrentSequence)
                                       + " AND c_action                  <> 'D'":U) NO-ERROR.

    ASSIGN
        ghMenuStructure:BUFFER-FIELD("i_menu_structure_sequence":U):BUFFER-VALUE        = httObjectMenuStructure:BUFFER-FIELD("i_menu_structure_sequence":U):BUFFER-VALUE
        httObjectMenuStructure:BUFFER-FIELD("i_menu_structure_sequence":U):BUFFER-VALUE = iCurrentSequence.

    IF ghMenuStructure:BUFFER-FIELD("c_action":U):BUFFER-VALUE = "":U THEN
      ghMenuStructure:BUFFER-FIELD("c_action":U):BUFFER-VALUE = "M":U.

    IF httObjectMenuStructure:BUFFER-FIELD("c_action":U):BUFFER-VALUE = "":U THEN
      httObjectMenuStructure:BUFFER-FIELD("c_action":U):BUFFER-VALUE = "M":U.

    RUN refreshData (INPUT "":U, INPUT ghMenuStructure:BUFFER-FIELD("d_object_menu_structure_obj":U):BUFFER-VALUE).
  END.

  IF DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ContainerMode":U) <> "UPDATE":U AND
     DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ContainerMode":U) <> "ADD":U    THEN
  DO:
    DYNAMIC-FUNCTION("setUserProperty":U IN ghParentContainer, "ContainerMode":U, "UPDATE":U).
    DYNAMIC-FUNCTION("evaluateActions":U IN ghParentContainer).
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshData vTableWin 
PROCEDURE refreshData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcAction       AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pdObjectNumber AS DECIMAL    NO-UNDO.

  ghContainerHandle:TITLE = gcTitle + (IF NUM-ENTRIES(ghParentCHandle:TITLE, "-":U) >= 2 THEN TRIM(ENTRY(2, ghParentCHandle:TITLE, "-":U)) ELSE "":U).
  
  DYNAMIC-FUNCTION("reopenBrowseQuery":U, pdObjectNumber).

  IF ghQuery:NUM-RESULTS <= 0 THEN
    DYNAMIC-FUNCTION("setUserProperty":U IN ghContainerSource, "ContainerMode":U, "NoDATA":U).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject vTableWin 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdHeight   AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdWidth    AS DECIMAL    NO-UNDO.
  
  DEFINE VARIABLE lResizedObjects   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE dFrameHeight      AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dFrameWidth       AS DECIMAL    NO-UNDO.

  HIDE FRAME {&FRAME-NAME}.

  ASSIGN
      dFrameHeight = FRAME {&FRAME-NAME}:HEIGHT-CHARS
      dFrameWidth  = FRAME {&FRAME-NAME}:WIDTH-CHARS.
  
  /* If the height OR width of the frame was made smaller */
  IF pdHeight < dFrameHeight OR
     pdWidth  < dFrameWidth  THEN
  DO:
    /* Just in case the window was made longer or wider, allow for the new length or width */
    IF pdHeight > dFrameHeight THEN FRAME {&FRAME-NAME}:HEIGHT-CHARS = pdHeight.
    IF pdWidth  > dFrameWidth  THEN FRAME {&FRAME-NAME}:WIDTH-CHARS  = pdWidth.
    
    lResizedObjects = TRUE.
    
    RUN resizeViewerObjects (INPUT pdHeight, INPUT pdWidth).
  END.
  
  ASSIGN    
      FRAME {&FRAME-NAME}:HEIGHT-CHARS = pdHeight
      FRAME {&FRAME-NAME}:WIDTH-CHARS  = pdWidth.

  IF lResizedObjects = FALSE THEN
    RUN resizeViewerObjects (INPUT pdHeight, INPUT pdWidth).

  VIEW FRAME {&FRAME-NAME}.

  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeViewerObjects vTableWin 
PROCEDURE resizeViewerObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdHeight AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdWidth  AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE dNewWidth AS DECIMAL    NO-UNDO.

  IF NOT DYNAMIC-FUNCTION("getObjectInitialized":U) THEN
    RETURN.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        rctToolbar:WIDTH-CHARS    = pdWidth
        rctBorder:HEIGHT-CHARS    = pdHeight     - rctBorder:ROW    + 1.00
        rctBorder:WIDTH-CHARS     = pdWidth
        toSubMenu:ROW             = pdHeight
        dNewWidth                 = pdWidth      - toSubMenu:COLUMN - 3.00
        fiDescription:WIDTH-CHARS = dNewWidth    - 4.80
        fiDescription:ROW         = pdHeight     - 3.28
        fiLabel:WIDTH-CHARS       = dNewWidth    - 4.80
        fiLabel:ROW               = pdHeight     - 4.33
        rctToolbar:ROW            = pdHeight     - 6.90
        buAdd:X                   = rctToolbar:X + 7
        buAdd:Y                   = rctToolbar:Y + 2
        
        fiDescription:SIDE-LABEL-HANDLE:ROW = pdHeight - 3.28
        fiLabel:SIDE-LABEL-HANDLE:ROW       = pdHeight - 4.33 NO-ERROR.

    IF VALID-HANDLE(ghBrowse) THEN
      ASSIGN
          ghBrowse:ROW          = 1.67
          ghBrowse:COLUMN       = 2.80
          ghBrowse:WIDTH-CHARS  = pdWidth  - ghBrowse:COLUMN - 1.00
          ghBrowse:HEIGHT-CHARS = pdHeight - ghBrowse:ROW    - 7.15 NO-ERROR.

    RUN repositionObject IN hMenuStructure     (INPUT pdHeight - 5.38, INPUT 23.00).
    RUN resizeObject     IN hMenuStructure     (INPUT 1.00,            INPUT dNewWidth).
    RUN repositionObject IN hInstanceAttribute (INPUT pdHeight - 2.24, INPUT 23.00).
    RUN resizeObject     IN hInstanceAttribute (INPUT 1.00,            INPUT dNewWidth).
    RUN repositionObject IN hMenuItem          (INPUT pdHeight - 1.19, INPUT 23.00).
    RUN resizeObject     IN hMenuItem          (INPUT 1.00,            INPUT dNewWidth).

    DYNAMIC-FUNCTION("positionButton":U, buDelete:HANDLE,   buAdd:HANDLE,      FALSE).
    DYNAMIC-FUNCTION("positionButton":U, buSave:HANDLE,     buDelete:HANDLE,   FALSE).
    DYNAMIC-FUNCTION("positionButton":U, buUndo:HANDLE,     buSave:HANDLE,     FALSE).
    DYNAMIC-FUNCTION("positionButton":U, buCancel:HANDLE,   buUndo:HANDLE,     FALSE).
    DYNAMIC-FUNCTION("positionButton":U, buMoveUp:HANDLE,   buCancel:HANDLE,   FALSE).
    DYNAMIC-FUNCTION("positionButton":U, buMoveDown:HANDLE, buMoveUp:HANDLE,   FALSE).
    DYNAMIC-FUNCTION("positionButton":U, buTransfer:HANDLE, buMoveDown:HANDLE, FALSE).

    ASSIGN
        rctSeperator1:Y = rctToolbar:Y + 2
        rctSeperator1:X = buMoveUp:X   - 2
        rctSeperator2:Y = rctToolbar:Y + 2
        rctSeperator2:X = buTransfer:X - 2 NO-ERROR.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveRecord vTableWin 
PROCEDURE saveRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cColumnValues     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumnNames      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessage          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hLookupFillIn     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE dMenuStructureObj AS DECIMAL    NO-UNDO.

  {get DataValue dMenuStructureObj hMenuStructure}.

  IF dMenuStructureObj = 0 OR
     dMenuStructureObj = ? THEN
  DO:
    cMessage = {aferrortxt.i 'AF' '1' '?' '?' "'menu structure'"}.

    RUN showMessages IN gshSessionManager (INPUT  cMessage,                         /* message to display */
                                           INPUT  "ERR":U,                          /* error type         */
                                           INPUT  "&Ok":U,                          /* button list        */
                                           INPUT  "&Ok":U,                          /* default button     */ 
                                           INPUT  "&Ok":U,                          /* cancel button      */
                                           INPUT  "Error saving menu structure":U,  /* error window title */
                                           INPUT  YES,                              /* display if empty   */ 
                                           INPUT  ghContainerSource,                /* container handle   */ 
                                           OUTPUT cButton).                         /* button pressed     */

    RETURN ERROR "ERROR":U.
  END.

  ASSIGN  
      ghMenuStructure:BUFFER-FIELD("d_instance_attribute_obj":U):BUFFER-VALUE = DYNAMIC-FUNCTION("getDataValue":U IN hInstanceAttribute)
      ghMenuStructure:BUFFER-FIELD("d_menu_structure_obj":U):BUFFER-VALUE     = DYNAMIC-FUNCTION("getDataValue":U IN hMenuStructure)
      ghMenuStructure:BUFFER-FIELD("l_insert_submenu":U):BUFFER-VALUE         = toSubMenu:CHECKED IN FRAME {&FRAME-NAME}
      ghMenuStructure:BUFFER-FIELD("d_menu_item_obj":U):BUFFER-VALUE          = DYNAMIC-FUNCTION("getDataValue":U IN hMenuItem).

  IF ghMenuStructure:BUFFER-FIELD("c_action":U):BUFFER-VALUE = "":U THEN
    ghMenuStructure:BUFFER-FIELD("c_action":U):BUFFER-VALUE = "M":U.

  DYNAMIC-FUNCTION("setUserProperty":U IN ghContainerSource, "ContainerMode":U, "MODIFY":U).

  /* Populate the description data in the table. This is done to avoid another AppServer hit when displaying the data */
  /* Menu Structure */
  IF DYNAMIC-FUNCTION("getDataValue":U IN hMenuStructure) <> 0.00 AND
     NUM-ENTRIES(gcMSLookupValues, CHR(3))                >= 2    THEN
    ASSIGN
        cColumnValues = ENTRY(2, gcMSLookupValues, CHR(3))
        cColumnNames  = ENTRY(1, gcMSLookupValues, CHR(3))

        ghMenuStructure:BUFFER-FIELD("c_menu_structure_description":U):BUFFER-VALUE = fiDescription:SCREEN-VALUE
        ghMenuStructure:BUFFER-FIELD("c_menu_structure_code":U):BUFFER-VALUE        = ENTRY(LOOKUP("gsm_menu_structure.menu_structure_code":U, cColumnNames), cColumnValues, CHR(1))
        ghMenuStructure:BUFFER-FIELD("c_menu_item_label":U):BUFFER-VALUE            = fiLabel:SCREEN-VALUE.

  /* Instance Attribute */
  IF DYNAMIC-FUNCTION("getDataValue":U IN hInstanceAttribute) <> 0.00 THEN
    ASSIGN
        hLookupFillIn                                                   = DYNAMIC-FUNCTION("getLookupHandle":U IN hInstanceAttribute)
        ghMenuStructure:BUFFER-FIELD("c_attribute_code":U):BUFFER-VALUE = hLookupFillIn:SCREEN-VALUE.

  /* Item placeholder menu item */
  IF DYNAMIC-FUNCTION("getDataValue":U IN hMenuItem) <> 0.00 THEN
    ASSIGN
        hLookupFillIn                                                           = DYNAMIC-FUNCTION("getLookupHandle":U IN hMenuItem)
        ghMenuStructure:BUFFER-FIELD("c_item_placeholder_label":U):BUFFER-VALUE = hLookupFillIn:SCREEN-VALUE.

  /* Finally reselect the record to see if the data was correctly saved */
  RUN refreshData (INPUT "":U,
                   INPUT ghMenuStructure:BUFFER-FIELD("d_object_menu_structure_obj":U):BUFFER-VALUE).

  IF DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ContainerMode":U) <> "UPDATE":U AND
     DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ContainerMode":U) <> "ADD":U    THEN
  DO:
    DYNAMIC-FUNCTION("setUserProperty":U IN ghParentContainer, "ContainerMode":U, "UPDATE":U).
    DYNAMIC-FUNCTION("evaluateActions":U IN ghParentContainer).
  END.

  DYNAMIC-FUNCTION("evaluateActions":U).

  ghBrowse:SENSITIVE = TRUE.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE takeAction vTableWin 
PROCEDURE takeAction :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcAction      AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER plErrorStatus AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcReturnValue AS CHARACTER  NO-UNDO.

  CASE pcAction:
    WHEN "cancel":U THEN
    DO:
      RUN cancelRecord NO-ERROR.
    
      ASSIGN
          plErrorStatus = ERROR-STATUS:ERROR
          pcReturnValue = (IF RETURN-VALUE = "":U AND ERROR-STATUS:GET-MESSAGE(1) = "":U THEN "":U ELSE "ERROR":U).
    END.

    WHEN "reset":U THEN
    DO:
      RUN undoChanges NO-ERROR.

      ASSIGN
          plErrorStatus = ERROR-STATUS:ERROR
          pcReturnValue = (IF RETURN-VALUE = "":U AND ERROR-STATUS:GET-MESSAGE(1) = "":U THEN "":U ELSE "ERROR":U).
    END.

    WHEN "save":U THEN
    DO:
      RUN saveRecord NO-ERROR.
      
      ASSIGN
          plErrorStatus = ERROR-STATUS:ERROR
          pcReturnValue = (IF RETURN-VALUE = "":U AND ERROR-STATUS:GET-MESSAGE(1) = "":U THEN "":U ELSE "ERROR":U).
    END.
  END CASE.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE toolbar vTableWin 
PROCEDURE toolbar :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcValue AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  /*RUN SUPER( INPUT pcValue).*/

  /* Code placed here will execute AFTER standard behavior.    */
  CASE pcValue:
    WHEN "New":U      THEN RUN addRecord.
    WHEN "Delete":U   THEN RUN deleteRecord.
    WHEN "Save":U     THEN RUN saveRecord.
    WHEN "Undo":U     THEN RUN undoChanges.
    WHEN "Cancel":U   THEN RUN cancelRecord.

    WHEN "moveUp":U   THEN RUN moveUpDown (INPUT "Up":U).
    WHEN "moveDown":U THEN RUN moveUpDown (INPUT "Down":U).
    WHEN "Export":U   THEN RUN transferToExcel.
  END CASE.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE transferToExcel vTableWin 
PROCEDURE transferToExcel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN transferToExcel IN ghParentContainer (INPUT ghBrowse, INPUT ghContainerSource).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE undoChanges vTableWin 
PROCEDURE undoChanges :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DYNAMIC-FUNCTION("setUserProperty":U IN ghContainerSource, "ContainerMode":U, "MODIFY":U).
  /*
  RUN refreshData (INPUT "":U, INPUT 0.00).
  */
  ghBrowse:SENSITIVE = TRUE.

  RUN itemSelected.

  DYNAMIC-FUNCTION("evaluateActions":U).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION evaluateActions vTableWin 
FUNCTION evaluateActions RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cContainerMode          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE httObjectMenuStructure  AS HANDLE     NO-UNDO.

  ASSIGN
      dCustomizationResultObj = DECIMAL({fnarg getUserProperty 'CustomizationResultObj' ghParentContainer})
      httObjectMenuStructure  = WIDGET-HANDLE({fnarg getUserProperty 'ttObjectMenuStructure' ghParentContainer})
      cContainerMode          = {fnarg getUserProperty 'ContainerMode' ghContainerSource}.

  CREATE BUFFER httObjectMenuStructure FOR TABLE httObjectMenuStructure.

  DO WITH FRAME {&FRAME-NAME}:
    DISABLE {&ADM-ASSIGN-FIELDS}.

    {fnarg disableActions 'New,cbDelete,cbSave,cbUndo,cbCancel,Export' ghToolbar}.

    CASE cContainerMode:
      WHEN "ADD":U    THEN
      DO:
        {fnarg enableActions 'cbCancel,cbSave' ghToolbar}.

        ENABLE {&List-3}.
      END.

      WHEN "MODIFY":U THEN
      DO:
        {fnarg enableActions 'New,cbDelete,Export' ghToolbar}.

        ENABLE {&List-2}.
      END.

      WHEN "UPDATE":U THEN
      DO:
        {fnarg enableActions 'cbSave,cbUndo' ghToolbar}.

        ENABLE {&List-4}.
        
        ghBrowse:SENSITIVE = FALSE.
      END.

      WHEN "NoDATA":U THEN
      DO:
        IF {fnarg getUserProperty 'ContainerMode' ghParentContainer} <> "FIND":U AND 
           LOOKUP({fn getContainerType}, gcClassesNotAllowed)         = 0        THEN
        DO:
          {fnarg enableActions 'New' ghToolbar}.
  
          ENABLE buAdd.
        END.
      END.
    END CASE.

    IF cContainerMode                                                           <> "ADD":U                 AND
       ghMenuStructure:AVAILABLE                                                 = TRUE                    AND
       ghMenuStructure:BUFFER-FIELD("d_customization_result_obj":U):BUFFER-VALUE = dCustomizationResultObj THEN
    DO:
      /* Check for the sensitivity of the 'move up' button */
      httObjectMenuStructure:FIND-FIRST("WHERE d_customization_result_obj = ":U + QUOTER(dCustomizationResultObj)
                                       + " AND i_menu_structure_sequence  < ":U + STRING(ghMenuStructure:BUFFER-FIELD("i_menu_structure_sequence":U):BUFFER-VALUE)
                                       + " AND c_action                  <> 'D'":U) NO-ERROR.

      IF httObjectMenuStructure:AVAILABLE THEN
      DO:
        {fnarg enableActions 'cbMoveUp' ghToolbar}.

        ENABLE buMoveUp.
      END.
      ELSE
      DO:
        {fnarg disableActions 'cbMoveUp' ghToolbar}.

        DISABLE buMoveUp.
      END.

      /* Check for the sensitivity of the 'move down' button */
      httObjectMenuStructure:FIND-FIRST("WHERE d_customization_result_obj = ":U + QUOTER(dCustomizationResultObj)
                                       + " AND i_menu_structure_sequence  > ":U + STRING(ghMenuStructure:BUFFER-FIELD("i_menu_structure_sequence":U):BUFFER-VALUE)
                                       + " AND c_action                  <> 'D'":U) NO-ERROR.

      IF httObjectMenuStructure:AVAILABLE THEN
      DO:
        {fnarg enableActions 'cbMoveDown' ghToolbar}.

        ENABLE buMoveDown.
      END.
      ELSE
      DO:
        {fnarg disableActions 'cbMoveDown' ghToolbar}.

        DISABLE buMoveDown.
      END.

      IF NOT {fn getFieldEnabled hMenuStructure} THEN
      DO:
        ENABLE toSubMenu
               buDelete.

        RUN enableField IN hMenuStructure.
        RUN enableField IN hInstanceAttribute.
        RUN enableField IN hMenuItem.
      END.
    END.
    ELSE
    DO:
      {fnarg disableActions 'cbMoveUp,cbMoveDown,cbDelete' ghToolbar}.

      DISABLE buMoveDown
              buMoveUp
              buDelete.

      IF cContainerMode <> "ADD":U THEN
      DO:
        DISABLE toSubMenu.

        IF {fn getFieldEnabled hMenuStructure} THEN
        DO:
          RUN disableField IN hMenuStructure.
          RUN disableField IN hInstanceAttribute.
          RUN disableField IN hMenuItem.
        END.
      END.
      ELSE
      DO:
        IF NOT {fn getFieldEnabled hMenuStructure} THEN
        DO:
          RUN enableField IN hMenuStructure.
          RUN enableField IN hInstanceAttribute.
          RUN enableField IN hMenuItem.
        END.
      END.
    END.
  END.

  DELETE OBJECT httObjectMenuStructure.

  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getContainerType vTableWin 
FUNCTION getContainerType RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE httSmartObject  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE httObjectType   AS HANDLE     NO-UNDO.

  DEFINE VARIABLE cObjectTypeCode AS CHARACTER  NO-UNDO.

  ASSIGN
      httSmartObject = {fnarg getUserProperty 'ttSmartObject' ghParentContainer}
      httObjectType  = {fnarg getUserProperty 'ttObjectType'  ghParentContainer}.

  CREATE BUFFER httSmartObject FOR TABLE httSmartObject.
  CREATE BUFFER httObjectType  FOR TABLE httObjectType.

  httSmartObject:FIND-FIRST("WHERE d_smartobject_obj <> 0 AND d_customization_result_obj = 0":U).

  httObjectType:FIND-FIRST("WHERE d_object_type_obj = DECIMAL(":U + QUOTER(httSmartObject:BUFFER-FIELD("d_object_type_obj":U):BUFFER-VALUE) + ")":U).

  cObjectTypeCode = httObjectType:BUFFER-FIELD("c_object_type_code":U):BUFFER-VALUE.

  IF gcClassesNotAllowed = "":U THEN
    ASSIGN
        gcClassesNotAllowed = "SmartFrame,DynFrame,DynSBO":U
        gcClassesNotAllowed = {fnarg getClassChildrenFromDB gcClassesNotAllowed gshRepositoryManager}
        gcClassesNotAllowed = REPLACE(gcClassesNotAllowed, CHR(3), ",":U).

  DELETE OBJECT httSmartObject.
  DELETE OBJECT httObjectType.

  RETURN cObjectTypeCode.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION positionButton vTableWin 
FUNCTION positionButton RETURNS LOGICAL
  (phButton AS HANDLE,
   phSource AS HANDLE,
   plBelow  AS LOGICAL):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  ASSIGN      
      phButton:X  = (IF plBelow = FALSE THEN phSource:X + 2 + phSource:WIDTH-PIXELS  ELSE phSource:X)
      phButton:Y  = (IF plBelow = TRUE  THEN phSource:Y + 2 + phSource:HEIGHT-PIXELS ELSE phSource:Y) NO-ERROR.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION reopenBrowseQuery vTableWin 
FUNCTION reopenBrowseQuery RETURNS LOGICAL
    (pdObjectMenuStructureObj AS DECIMAL) :
/*------------------------------------------------------------------------------
  Purpose:  Opens the query for the specified browse.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cBaseQuery              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCustomizationResultObj AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lSuccess                AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE httObjectMenuStructure  AS HANDLE     NO-UNDO.

  /* Make the relevant substitutions. */
  ASSIGN
      dCustomizationResultObj = DECIMAL(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "CustomizationResultObj":U))
      httObjectMenuStructure  = WIDGET-HANDLE(DYNAMIC-FUNCTION("getUserProperty":U IN ghParentContainer, "ttObjectMenuStructure":U)).

  CREATE BUFFER httObjectMenuStructure FOR TABLE httObjectMenuStructure.

  cBaseQuery = SUBSTITUTE(gcBaseQuery, QUOTER(dCustomizationResultObj)).

  /* Always reopen, in case the sort has changed. */
  ghQuery:QUERY-PREPARE(cBaseQuery).

  IF ghQuery:IS-OPEN THEN
     ghQuery:QUERY-CLOSE().

  ghQuery:QUERY-OPEN().

  IF ghContainerHandle = CURRENT-WINDOW THEN
    APPLY "ENTRY":U TO ghBrowse.

  IF ghQuery:NUM-RESULTS       > 0 AND
     pdObjectMenuStructureObj <> 0 THEN
  DO:
    httObjectMenuStructure:FIND-FIRST("WHERE d_object_menu_structure_obj = ":U + QUOTER(pdObjectMenuStructureObj)
                                     + " AND c_action                   <> 'D'":U
                                     + " AND d_customization_result_obj  = ":U + QUOTER(dCustomizationResultObj)) NO-ERROR.

    IF httObjectMenuStructure:AVAILABLE THEN
      lSuccess = ghQuery:REPOSITION-TO-ROWID(httObjectMenuStructure:ROWID) NO-ERROR.

    IF lSuccess = FALSE THEN
      ghBrowse:SELECT-ROW(1).
  END.
  
  DELETE OBJECT httObjectMenuStructure.

  RUN itemSelected.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

