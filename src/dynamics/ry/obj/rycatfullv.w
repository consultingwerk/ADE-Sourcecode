&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE RowObject
       {"ry/obj/rycatfullo.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File:

  Description: from viewer.w - Template for SmartDataViewer objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE glSetValueChanged AS LOGICAL    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "ry/obj/rycatfullo.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.attribute_label ~
RowObject.override_type RowObject.attribute_narrative RowObject.data_type ~
RowObject.ObjectTypes RowObject.constant_level RowObject.is_private ~
RowObject.runtime_only RowObject.system_owned RowObject.derived_value ~
RowObject.design_only RowObject.lookup_type RowObject.lookup_value 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-Define ENABLED-OBJECTS cOverride RECT-1 RECT-2 RECT-3 
&Scoped-Define DISPLAYED-FIELDS RowObject.attribute_label ~
RowObject.override_type RowObject.attribute_narrative RowObject.data_type ~
RowObject.ObjectTypes RowObject.constant_level RowObject.is_private ~
RowObject.runtime_only RowObject.system_owned RowObject.derived_value ~
RowObject.design_only RowObject.lookup_type RowObject.lookup_value 
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define DISPLAYED-OBJECTS cOverride fiNarLabel fiObjetTypeText ~
fiRuntimeRealizationLabel fiOverrideTypeLabel fiPropertySettingsLabel ~
fiLookupText 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */
&Scoped-define ADM-ASSIGN-FIELDS RowObject.attribute_label 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD disableRadioButton vTableWin 
FUNCTION disableRadioButton RETURNS LOGICAL
  ( pcName AS CHAR,
    pcNum  AS int)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD disableWidget vTableWin 
FUNCTION disableWidget RETURNS LOGICAL
  ( pcName AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD enableRadioButton vTableWin 
FUNCTION enableRadioButton RETURNS LOGICAL
  ( pcName AS CHAR,
    pcNum  AS int)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD enableWidget vTableWin 
FUNCTION enableWidget RETURNS LOGICAL
  ( pcName AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD resetWidgetValue vTableWin 
FUNCTION resetWidgetValue RETURNS LOGICAL
  ( pcName AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD sensitizeRadioButton vTableWin 
FUNCTION sensitizeRadioButton RETURNS LOGICAL
  ( pcName   AS CHAR,
    piNum    AS INT,
    plEnable AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setWidgetBGcolor vTableWin 
FUNCTION setWidgetBGcolor RETURNS LOGICAL
  ( pcName AS CHAR,
    piValue AS int )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setWidgetValue vTableWin 
FUNCTION setWidgetValue RETURNS LOGICAL
  ( pcName AS CHAR,
    pcValue AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD widgetChecked vTableWin 
FUNCTION widgetChecked RETURNS LOGICAL
  ( pcName AS char)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD widgetHandle vTableWin 
FUNCTION widgetHandle RETURNS HANDLE
  ( pcName AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD widgetValue vTableWin 
FUNCTION widgetValue RETURNS CHAR
  ( pcName AS char)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_dyncombo AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE fiLookupText AS CHARACTER FORMAT "X(35)":U INITIAL "Lookup value:" 
      VIEW-AS TEXT 
     SIZE 14.2 BY 1 NO-UNDO.

DEFINE VARIABLE fiNarLabel AS CHARACTER FORMAT "X(35)":U INITIAL "Narrative:" 
      VIEW-AS TEXT 
     SIZE 9.2 BY 1 NO-UNDO.

DEFINE VARIABLE fiObjetTypeText AS CHARACTER FORMAT "X(35)":U INITIAL "Object types:" 
      VIEW-AS TEXT 
     SIZE 13.2 BY 1 NO-UNDO.

DEFINE VARIABLE fiOverrideTypeLabel AS CHARACTER FORMAT "X(35)":U INITIAL "Override type" 
      VIEW-AS TEXT 
     SIZE 14 BY .62 NO-UNDO.

DEFINE VARIABLE fiPropertySettingsLabel AS CHARACTER FORMAT "X(35)":U INITIAL "Property List Settings" 
      VIEW-AS TEXT 
     SIZE 20.8 BY .62 NO-UNDO.

DEFINE VARIABLE fiRuntimeRealizationLabel AS CHARACTER FORMAT "X(35)":U INITIAL "Runtime and Realization Settings" 
      VIEW-AS TEXT 
     SIZE 32 BY .62 NO-UNDO.

DEFINE VARIABLE cOverride AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "None", ""
     SIZE 59.6 BY 3.24 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 68.8 BY 4.05.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 87.8 BY .1.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 87.8 BY .1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RowObject.attribute_label AT ROW 2.05 COL 18.6 COLON-ALIGNED
          LABEL "Attribute label"
          VIEW-AS FILL-IN 
          SIZE 74.8 BY 1
     RowObject.override_type AT ROW 2.24 COL 1 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 1.6 BY 1
     RowObject.attribute_narrative AT ROW 3.1 COL 20.6 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 500 SCROLLBAR-VERTICAL
          SIZE 74.8 BY 3
     RowObject.data_type AT ROW 6.14 COL 18.6 COLON-ALIGNED
          LABEL "Data type"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "Character",1,
                     "Date",2,
                     "Logical",3,
                     "Integer",4,
                     "Decimal",5,
                     "Recid",7,
                     "Raw",8,
                     "Rowid",9,
                     "Handle",10,
                     "Memptr",11,
                     "Com-handle",14
          DROP-DOWN-LIST
          SIZE 20.6 BY 1 TOOLTIP "Select the data type of this attribute."
          FONT 4
     RowObject.ObjectTypes AT ROW 6.14 COL 57.4 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 38.4 BY 2
          FONT 3
     RowObject.constant_level AT ROW 8.81 COL 18.6 COLON-ALIGNED
          LABEL "Constant level"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "Instance Level","",
                     "Class Level","Class",
                     "Master Level","Master"
          DROP-DOWN-LIST
          SIZE 24 BY 1 TOOLTIP "Lowest level where the value can be stored and changed (also through instances)"
     RowObject.is_private AT ROW 8.81 COL 57.4
          LABEL "Private"
          VIEW-AS TOGGLE-BOX
          SIZE 13.6 BY 1
     RowObject.runtime_only AT ROW 9.86 COL 20.6
          LABEL "Runtime only"
          VIEW-AS TOGGLE-BOX
          SIZE 17.6 BY 1 TOOLTIP "Check if the value is set by runtime logic and not stored in the Repository"
     RowObject.system_owned AT ROW 9.86 COL 57.4
          LABEL "System owned"
          VIEW-AS TOGGLE-BOX
          SIZE 19.2 BY 1
     RowObject.derived_value AT ROW 10.91 COL 20.6
          LABEL "Derived value"
          VIEW-AS TOGGLE-BOX
          SIZE 18.4 BY 1 TOOLTIP "Check if the value is derived from other data and/or attributes"
     RowObject.design_only AT ROW 10.91 COL 57.4
          LABEL "Design only"
          VIEW-AS TOGGLE-BOX
          SIZE 16.4 BY 1
     cOverride AT ROW 12.62 COL 21.8 HELP
          "Override type" NO-LABEL
     RowObject.lookup_type AT ROW 17.14 COL 18.6 COLON-ALIGNED
          LABEL "Lookup type"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "Free Text","",
                     "List Item Pairs","LIST",
                     "Dialog","DIALOG",
                     "Dialog (Read Only) ","DIALOG-R",
                     "Procedure","PROC"
          DROP-DOWN-LIST
          SIZE 30.6 BY 1
     RowObject.lookup_value AT ROW 18.19 COL 20.6 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 500 SCROLLBAR-VERTICAL
          SIZE 74.8 BY 3.14
     fiNarLabel AT ROW 3.1 COL 11.2 NO-LABEL
     fiObjetTypeText AT ROW 6.14 COL 43.4 NO-LABEL
     fiRuntimeRealizationLabel AT ROW 7.95 COL 1 NO-LABEL
     fiOverrideTypeLabel AT ROW 11.86 COL 18.6 COLON-ALIGNED NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     fiPropertySettingsLabel AT ROW 16.33 COL 1 NO-LABEL
     fiLookupText AT ROW 18.19 COL 6.4 NO-LABEL
     RECT-1 AT ROW 12.1 COL 18.6
     RECT-2 AT ROW 8.33 COL 8
     RECT-3 AT ROW 16.62 COL 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "ry/obj/rycatfullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {ry/obj/rycatfullo.i}
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
         HEIGHT             = 20.57
         WIDTH              = 94.8.
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
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit L-To-R                                       */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN RowObject.attribute_label IN FRAME F-Main
   1 EXP-LABEL                                                          */
/* SETTINGS FOR EDITOR RowObject.attribute_narrative IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR COMBO-BOX RowObject.constant_level IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR COMBO-BOX RowObject.data_type IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.derived_value IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.design_only IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN fiLookupText IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       fiLookupText:PRIVATE-DATA IN FRAME F-Main     = 
                "Lookup value:".

/* SETTINGS FOR FILL-IN fiNarLabel IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       fiNarLabel:PRIVATE-DATA IN FRAME F-Main     = 
                "Narrative:".

/* SETTINGS FOR FILL-IN fiObjetTypeText IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN fiOverrideTypeLabel IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       fiOverrideTypeLabel:PRIVATE-DATA IN FRAME F-Main     = 
                "Override type".

/* SETTINGS FOR FILL-IN fiPropertySettingsLabel IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       fiPropertySettingsLabel:PRIVATE-DATA IN FRAME F-Main     = 
                "Property List Settings".

/* SETTINGS FOR FILL-IN fiRuntimeRealizationLabel IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       fiRuntimeRealizationLabel:PRIVATE-DATA IN FRAME F-Main     = 
                "Runtime and Realization Settings".

/* SETTINGS FOR TOGGLE-BOX RowObject.is_private IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR COMBO-BOX RowObject.lookup_type IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR EDITOR RowObject.lookup_value IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR EDITOR RowObject.ObjectTypes IN FRAME F-Main
   EXP-LABEL                                                            */
ASSIGN 
       RowObject.ObjectTypes:READ-ONLY IN FRAME F-Main        = TRUE.

/* SETTINGS FOR FILL-IN RowObject.override_type IN FRAME F-Main
   ALIGN-L EXP-LABEL                                                    */
ASSIGN 
       RowObject.override_type:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX RowObject.runtime_only IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX RowObject.system_owned IN FRAME F-Main
   EXP-LABEL                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME cOverride
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cOverride vTableWin
ON VALUE-CHANGED OF cOverride IN FRAME F-Main
DO:
 
  ASSIGN RowObject.OVERRIDE_type:SCREEN-VALUE = SELF:SCREEN-VALUE.  
  {set DataModified glSetValueChanged}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject.derived_value
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.derived_value vTableWin
ON VALUE-CHANGED OF RowObject.derived_value IN FRAME F-Main /* Derived value */
DO:
  RUN rowDisplay.
  {set DataModified TRUE}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject.lookup_type
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.lookup_type vTableWin
ON VALUE-CHANGED OF RowObject.lookup_type IN FRAME F-Main /* Lookup type */
DO:
  RUN rowdisplay.
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
  DEFINE VARIABLE hDataSource             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cAttributeGroupObj      AS CHARACTER  NO-UNDO.
     
  /* Code placed here will execute PRIOR to standard behavior. */
  
  RUN SUPER.
  
  {get DataSource hDataSource}.  
  ASSIGN 
    cAttributeGroupObj = {fnarg getUserProperty 'AttributeGroupObj' hDataSource}.
    
  IF cAttributeGroupObj <> "":U THEN
    {set DataValue DECIMAL(cAttributeGroupObj) h_dyncombo}.

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
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'DisplayedFieldryc_attribute_group.attribute_group_nameKeyFieldryc_attribute_group.attribute_group_objFieldLabelAttribute groupFieldTooltipSelect an attribute group from the listKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(256)DisplayDatatypeCHARACTERBaseQueryStringFOR EACH ryc_attribute_group NO-LOCK BY ryc_attribute_group.attribute_group_nameQueryTablesryc_attribute_groupSDFFileNameSDFTemplateParentFieldParentFilterQueryDescSubstitute&1ComboDelimiterListItemPairsInnerLines5ComboFlagFlagValueBuildSequence1SecurednoCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesFieldNameattribute_group_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dyncombo ).
       RUN repositionObject IN h_dyncombo ( 1.00 , 20.60 ) NO-ERROR.
       RUN resizeObject IN h_dyncombo ( 1.05 , 74.80 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_dyncombo ,
             RowObject.attribute_label:HANDLE IN FRAME F-Main , 'BEFORE':U ).
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
  HIDE FRAME F-Main.
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

  RUN SUPER( INPUT pcColValues).

 
  resetWidgetValue('constant_level').
  resetWidgetValue('lookup_type').  
  resetWidgetValue('cOverride'). 
  glSetValueChanged = TRUE.

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
  
  RUN rowDisplay.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject vTableWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hDataSource AS HANDLE     NO-UNDO.

 DO WITH FRAME {&FRAME-NAME}:
   ASSIGN 
    cOverride:DELIMITER = CHR(1)  
    cOverride:RADIO-BUTTONS =
         "None - Allow direct access to attribute value" + CHR(1) + '':U + CHR(1)
       + "Get  - Force value to be retrieved using get function" + CHR(1) + "GET" + CHR(1)
       + "Set  - Force value to be saved using set function" + CHR(1) + "SET" + CHR(1)
       + "Both - Force use of both set and get functions" + CHR(1) + "GET,SET".
 END.

 RUN SUPER.

 {get DataSource hDataSource}.

 RUN dataAvailable IN hDataSource (INPUT "?":U).
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowDisplay vTableWin 
PROCEDURE rowDisplay :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cObjectMode AS CHARACTER  NO-UNDO.
  
  {get ObjectMode cObjectMode}.
  IF cObjectMode <> 'View' THEN
  DO WITH FRAME {&FRAME-NAME}:
    IF widgetChecked('derived_value') THEN 
    DO:
      disableRadioButton('coverride',1).
      glSetValueChanged = FALSE.
      APPLY "VALUE-CHANGED":U TO cOverride.
      /*
      IF setWidgetValue('coverride','get').
      */
    END.
    ELSE DO WITH FRAME {&FRAME-NAME}:
      enableRadioButton('coverride',1).
      resetWidgetValue('coverride').
    END.
    IF widgetValue('Lookup_type') = "" THEN
    DO WITH FRAME {&FRAME-NAME}:
      disableWidget('LOOKUP_value').
      setWidgetValue('LOOKUP_value','').
    END.
    ELSE DO WITH FRAME {&FRAME-NAME}:
      enableWidget('LOOKUP_value').
      resetWidgetValue('LOOKUP_value').
    END.
    ObjectTypes:READ-ONLY =TRUE.
  END.
  


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
  setWidgetValue('LOOKUP_value',REPLACE(widgetValue('LOOKUP_value'),",",CHR(3))).
  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION disableRadioButton vTableWin 
FUNCTION disableRadioButton RETURNS LOGICAL
  ( pcName AS CHAR,
    pcNum  AS int) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN sensitizeRadioButton(pcName,pcNum,NO).   
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION disableWidget vTableWin 
FUNCTION disableWidget RETURNS LOGICAL
  ( pcName AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hWidget AS HANDLE     NO-UNDO.
  hWidget = widgetHandle(pcName).
  IF CAN-QUERY(hWidget,'sensitive') THEN
  DO:
    hWidget:SENSITIVE = false.
    RETURN TRUE.
  END.
  RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION enableRadioButton vTableWin 
FUNCTION enableRadioButton RETURNS LOGICAL
  ( pcName AS CHAR,
    pcNum  AS int) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN sensitizeRadioButton(pcName,pcNum,YES).   
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION enableWidget vTableWin 
FUNCTION enableWidget RETURNS LOGICAL
  ( pcName AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hWidget AS HANDLE     NO-UNDO.
  hWidget = widgetHandle(pcName).
  IF CAN-QUERY(hWidget,'sensitive') THEN
  DO:
    hWidget:SENSITIVE = true.
    RETURN TRUE.
  END.
  RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION resetWidgetValue vTableWin 
FUNCTION resetWidgetValue RETURNS LOGICAL
  ( pcName AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hWidget     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSourceName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue      AS CHARACTER  NO-UNDO.
  hWidget = widgetHandle(pcName).
  IF CAN-QUERY(hWidget,'screen-value') THEN
  DO:
    IF pcName = 'coverride' THEN
       cSourceName = 'override_type'.
    ELSE cSourceName = pcname.
    {get DataSource hDataSource}.
    IF VALID-HANDLE(hDataSource) THEN
    DO:
      cValue = {fnarg columnValue cSourceName hdataSource}.
      IF cValue = ? THEN ASSIGN cValue = "".
      IF pcName = 'lookup_value' THEN
         cValue = REPLACE(cValue,CHR(3),",":U).   
     
      RETURN setWidgetValue(pcName,cValue).    
    END.
  END.
  RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION sensitizeRadioButton vTableWin 
FUNCTION sensitizeRadioButton RETURNS LOGICAL
  ( pcName   AS CHAR,
    piNum    AS INT,
    plEnable AS LOG ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hWidget AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cLabel  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lok     AS LOGICAL    NO-UNDO.

  DO iLoop = 1 TO NUM-ENTRIES(pcName):
    cName =ENTRY(iLoop,pcname).
    hWidget = widgetHandle(cName).
    IF CAN-QUERY(hWidget,'radio-buttons') THEN
    DO:
      cLabel = entry((piNum * 2) - 1, hWidget:radio-buttons,hWidget:DELIMITER).
      IF plEnable THEN
        hWidget:enable(cLabel).
      ELSE 
        hWidget:disable(cLabel).
      lok = IF lok THEN lok ELSE  TRUE.
    END.  
  END.
  
  RETURN lok.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setWidgetBGcolor vTableWin 
FUNCTION setWidgetBGcolor RETURNS LOGICAL
  ( pcName AS CHAR,
    piValue AS int ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hWidget AS HANDLE     NO-UNDO.
  hWidget = widgetHandle(pcName).
  IF CAN-QUERY(hWidget,'bgcolor') THEN
  DO:
    hWidget:BGCOLOR = piValue.
    RETURN TRUE.
  END.
  RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setWidgetValue vTableWin 
FUNCTION setWidgetValue RETURNS LOGICAL
  ( pcName AS CHAR,
    pcValue AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hWidget AS HANDLE     NO-UNDO.
  hWidget = widgetHandle(pcName).
  IF CAN-QUERY(hWidget,'screen-value') THEN
  DO:
    IF pcValue = '':U AND CAN-QUERY(hWidget,'list-item-pairs') 
    AND LOOKUP('',hWidget:LIST-ITEM-PAIRS) > 0 THEN
      hWidget:SCREEN-VALUE = ' ':U.
    ELSE
      hWidget:SCREEN-VALUE = pcValue.
    RETURN TRUE.
  END.
  RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION widgetChecked vTableWin 
FUNCTION widgetChecked RETURNS LOGICAL
  ( pcName AS char) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hWidget AS HANDLE     NO-UNDO.
  hWidget = widgetHandle(pcName).
 
  IF CAN-QUERY(hWidget,'checked') THEN
    RETURN hWidget:checked.
  ELSE 
    RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION widgetHandle vTableWin 
FUNCTION widgetHandle RETURNS HANDLE
  ( pcName AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAllFieldHandles AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAllFieldNames AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ilookup AS INTEGER    NO-UNDO.
  
  {get AllfieldHandles cAllFieldHandles}.
  {get AllfieldNames cAllFieldNames}.
  iLookup = LOOKUP(pcName,cAllFieldNames).
  IF iLookup > 0 THEN
     RETURN WIDGET-HANDLE(ENTRY(iLookup,cAllFieldHandles)).
  ELSE 
    RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION widgetValue vTableWin 
FUNCTION widgetValue RETURNS CHAR
  ( pcName AS char) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hWidget AS HANDLE     NO-UNDO.
  hWidget = widgetHandle(pcName).
 
  IF CAN-QUERY(hWidget,'input-value') THEN
    RETURN hWidget:INPUT-VALUE.
  ELSE 
    RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

