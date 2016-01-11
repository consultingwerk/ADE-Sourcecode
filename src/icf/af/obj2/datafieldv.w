&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" sObject _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" sObject _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sObject 
/*---------------------------------------------------------------------------------
  File: datafieldv.w

  Description:  Entity Data Field Maintenance

  Purpose:      Entity Data Field Maintenance

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   03/12/2003  Author:     

  Update Notes: Created from Template rysttsimpv.w

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

&scop object-name       datafieldv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartObject yes

{src/adm2/globals.i}

/* Global Definitions we're going to need */
{ry/app/ryobjretri.i}

DEFINE VARIABLE gcContainerName       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcFilterField         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gdContainerObj        AS DECIMAL    NO-UNDO.
DEFINE VARIABLE gcStoreContainerName  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSessionResultCodes  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ghQuery               AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghBrowser             AS HANDLE     NO-UNDO.
DEFINE VARIABLE gcAllFieldHandles     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcAllFieldNames       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcOperation           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gdCancelToRecordID    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE gdSaveToRecordID      AS DECIMAL    NO-UNDO.
DEFINE VARIABLE ghLastWidgetUpdated   AS HANDLE     NO-UNDO.
DEFINE VARIABLE glInitialising        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE gdStoreWidth          AS DECIMAL    NO-UNDO.
DEFINE VARIABLE gdStoreHeight         AS DECIMAL    NO-UNDO.
DEFINE VARIABLE glSkipGetParentDetail AS LOGICAL    NO-UNDO.
DEFINE VARIABLE ghPropSheet           AS HANDLE     NO-UNDO.

/* This is the list of dataField attributes the user is allowed to update.  Name and data-type are only enabled for add */
DEFINE VARIABLE gcValidAttributes AS CHARACTER  NO-UNDO INITIAL "Data-Type,TableName,Name,Label,Format,ColumnLabel,Name,SCHEMA-VALIDATE-MESSAGE,SCHEMA-VALIDATE-EXPRESSION,SCHEMA-VIEW-AS,SCHEMA-COLUMN-LABEL,SCHEMA-FORMAT,SCHEMA-HELP,SCHEMA-INITIAL,SCHEMA-LABEL,IncludeInDefaultView,IncludeInDefaultListView,DefaultValue".
DEFINE VARIABLE gcAttributeTypes  AS CHARACTER  NO-UNDO INITIAL "CHARACTER,CHARACTER,CHARACTER,CHARACTER,CHARACTER,CHARACTER,CHARACTER,CHARACTER,CHARACTER,CHARACTER,CHARACTER,CHARACTER,CHARACTER,CHARACTER,CHARACTER,LOGICAL,LOGICAL,CHARACTER".

DEFINE TEMP-TABLE ttDataField NO-UNDO RCODE-INFO
       FIELD tRecordIdentifier         LIKE cache_object.tRecordIdentifier
       FIELD container_smartobject_obj AS DECIMAL /* No formatting needed */
       FIELD container_object_filename AS CHARACTER FORMAT "x(50)":U LABEL "Entity Name"
       FIELD smartobject_obj           AS DECIMAL /* No formatting needed */
       FIELD object_filename           AS CHARACTER FORMAT "x(100)":U LABEL "DataField Name"
       FIELD object_type_code          AS CHARACTER FORMAT "x(30)":U LABEL "Class"
       FIELD product_module            AS CHARACTER FORMAT "x(30)":U LABEL "Product Module"
       FIELD instance_order            AS INTEGER FORMAT ">>>9" LABEL "Order".

DEFINE TEMP-TABLE ttDataFieldAttr NO-UNDO
       FIELD tRecordIdentifier    LIKE cache_object.tRecordIdentifier
       FIELD attr_name            AS CHARACTER FORMAT "x(35)" LABEL "Attribute Name"
       FIELD updated_attr_value   AS CHARACTER FORMAT "x(50)" LABEL "Updated Attribute Value"
       INDEX idxOne attr_name.

DEFINE TEMP-TABLE ttPropSheetInitialValues
       FIELD tRecordIdentifier  AS DECIMAL
       FIELD attr_name          AS CHARACTER
       FIELD updated_attr_value AS CHARACTER.

DEFINE TEMP-TABLE ttUpdatedPropSheetAttrs NO-UNDO
       FIELD attribute_name            AS CHARACTER
       FIELD data_type                 AS CHARACTER
       FIELD character_attribute_value AS CHARACTER
       FIELD decimal_attribute_value   AS DECIMAL
       FIELD integer_attribute_value   AS INTEGER
       FIELD logical_attribute_value   AS LOGICAL
       FIELD date_attribute_value      AS DATE
       INDEX idxOne attribute_name.

{ry/inc/ryrepatset.i} /* Defines the store attribute table */
{af/sup2/afttcombo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btnProp fiProductModule btnCancel fiClass ~
fiData-Type fiFormat fiLabel fiColumnLabel toIncludeInDefaultListView ~
fiDefaultValue fiOrder toIncludeInDefaultView fiSchema-Format ~
fiSchema-Label fiSchema-Column-Label fiSchema-Initial fiSchema-Help ~
fiSchema-view-as fiSchema-Validate-Expression fiSchema-Validate-Message ~
btnReset btnAdd btnDel btnSave fiLabelIncludeInDefaultListView ~
fiViewAsEdLabel fiValExprEdLabel fiHelpEdLabel fiValMsgEdLabel RECT-1 ~
RECT-2 
&Scoped-Define DISPLAYED-OBJECTS fiName fiProductModule fiClass fiData-Type ~
fiFormat fiLabel fiColumnLabel toIncludeInDefaultListView fiDefaultValue ~
fiOrder toIncludeInDefaultView fiSchema-Format fiSchema-Label ~
fiSchema-Column-Label fiSchema-Initial fiSchema-Help fiSchema-view-as ~
fiSchema-Validate-Expression fiSchema-Validate-Message fiLabelRender ~
fiLabelIncludeInDefaultListView fiLabelSchema fiViewAsEdLabel ~
fiValExprEdLabel fiHelpEdLabel fiValMsgEdLabel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON btnAdd 
     IMAGE-UP FILE "ry/img/add.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "&Add" 
     CONTEXT-HELP-ID 0
     SIZE 5 BY 1 TOOLTIP "Add a data field".

DEFINE BUTTON btnCancel 
     IMAGE-UP FILE "ry/img/objectcancel.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "&Cancel" 
     CONTEXT-HELP-ID 0
     SIZE 5 BY 1 TOOLTIP "Cancel the last action".

DEFINE BUTTON btnDel 
     IMAGE-UP FILE "ry/img/delete.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "&Delete" 
     CONTEXT-HELP-ID 0
     SIZE 5 BY 1 TOOLTIP "Delete a data field".

DEFINE BUTTON btnProp 
     IMAGE-UP FILE "ry/img/properties.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "&Properties" 
     CONTEXT-HELP-ID 0
     SIZE 5 BY 1 TOOLTIP "Update data field properties not settable on this viewer".

DEFINE BUTTON btnReset 
     IMAGE-UP FILE "ry/img/objectundo.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "&Reset" 
     CONTEXT-HELP-ID 0
     SIZE 5 BY 1 TOOLTIP "Reset the dataField record".

DEFINE BUTTON btnSave 
     IMAGE-UP FILE "src/adeicon/save.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "&Save" 
     CONTEXT-HELP-ID 0
     SIZE 5 BY 1 TOOLTIP "Save the updated data field information".

DEFINE VARIABLE fiClass AS CHARACTER FORMAT "X(256)":U 
     LABEL "Class" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE fiData-Type AS CHARACTER FORMAT "X(256)":U 
     LABEL "Data Type" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE fiProductModule AS CHARACTER FORMAT "X(256)":U 
     LABEL "Product Module" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE fiSchema-Help AS CHARACTER 
     CONTEXT-HELP-ID 0
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 40 BY 1.52 TOOLTIP "Help for the data field" NO-UNDO.

DEFINE VARIABLE fiSchema-Validate-Expression AS CHARACTER 
     CONTEXT-HELP-ID 0
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 40 BY 1.52 TOOLTIP "The validation expression for the data field" NO-UNDO.

DEFINE VARIABLE fiSchema-Validate-Message AS CHARACTER 
     CONTEXT-HELP-ID 0
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 40 BY 1.52 TOOLTIP "The data field validation message" NO-UNDO.

DEFINE VARIABLE fiSchema-view-as AS CHARACTER 
     CONTEXT-HELP-ID 0
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 40 BY 1.52 TOOLTIP "Help for the data field" NO-UNDO.

DEFINE VARIABLE fiColumnLabel AS CHARACTER FORMAT "X(60)":U 
     LABEL "Column Label" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 40 BY 1 TOOLTIP "The column label of the data field" NO-UNDO.

DEFINE VARIABLE fiDefaultValue AS CHARACTER FORMAT "X(60)":U 
     LABEL "Default Value" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 40 BY 1 TOOLTIP "Specifies the default value for a new record." NO-UNDO.

DEFINE VARIABLE fiFormat AS CHARACTER FORMAT "X(30)":U 
     LABEL "Format" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 30 BY 1 TOOLTIP "The display format of the data field" NO-UNDO.

DEFINE VARIABLE fiHelpEdLabel AS CHARACTER FORMAT "X(60)":U INITIAL "Help:" 
     CONTEXT-HELP-ID 0
      VIEW-AS TEXT 
     SIZE 5 BY .62 NO-UNDO.

DEFINE VARIABLE fiLabel AS CHARACTER FORMAT "X(60)":U 
     LABEL "Label" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 40 BY 1 TOOLTIP "The label of the data field" NO-UNDO.

DEFINE VARIABLE fiLabelIncludeInDefaultListView AS CHARACTER FORMAT "X(256)":U INITIAL "Include In Default List View" 
      VIEW-AS TEXT 
     SIZE 26.4 BY .62.

DEFINE VARIABLE fiLabelRender AS CHARACTER FORMAT "X(100)":U INITIAL "Default Settings used when rendering Data Fields:" 
     CONTEXT-HELP-ID 0
      VIEW-AS TEXT 
     SIZE 98 BY .62
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiLabelSchema AS CHARACTER FORMAT "X(20)":U INITIAL "Schema Settings:" 
     CONTEXT-HELP-ID 0
      VIEW-AS TEXT 
     SIZE 98 BY .62
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiName AS CHARACTER FORMAT "X(60)":U 
     LABEL "Field Name" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 40 BY 1 TOOLTIP "The name of the data field" NO-UNDO.

DEFINE VARIABLE fiOrder AS INTEGER FORMAT ">>>9":U INITIAL ? 
     LABEL "Order" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 TOOLTIP "The order of the data field" NO-UNDO.

DEFINE VARIABLE fiSchema-Column-Label AS CHARACTER FORMAT "X(60)":U 
     LABEL "Column Label" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 40 BY 1 TOOLTIP "The column label of the data field" NO-UNDO.

DEFINE VARIABLE fiSchema-Format AS CHARACTER FORMAT "X(30)":U 
     LABEL "Format" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 30 BY 1 TOOLTIP "The display format of the data field" NO-UNDO.

DEFINE VARIABLE fiSchema-Initial AS CHARACTER FORMAT "X(60)":U 
     LABEL "Initial Value" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 40 BY 1 TOOLTIP "The initial value of the data field" NO-UNDO.

DEFINE VARIABLE fiSchema-Label AS CHARACTER FORMAT "X(60)":U 
     LABEL "Label" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 40 BY 1 TOOLTIP "The label of the data field" NO-UNDO.

DEFINE VARIABLE fiValExprEdLabel AS CHARACTER FORMAT "X(60)":U INITIAL "Val Expression:" 
     CONTEXT-HELP-ID 0
      VIEW-AS TEXT 
     SIZE 14.6 BY .62 NO-UNDO.

DEFINE VARIABLE fiValMsgEdLabel AS CHARACTER FORMAT "X(60)":U INITIAL "Val Message:" 
     CONTEXT-HELP-ID 0
      VIEW-AS TEXT 
     SIZE 12.6 BY .62 NO-UNDO.

DEFINE VARIABLE fiViewAsEdLabel AS CHARACTER FORMAT "X(60)":U INITIAL "VIEW-AS:" 
     CONTEXT-HELP-ID 0
      VIEW-AS TEXT 
     SIZE 9.6 BY .62 NO-UNDO.

DEFINE VARIABLE toIncludeInDefaultListView AS LOGICAL 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Yes", yes,
"No", no,
"Use Default", ?
     SIZE 32 BY 2 TOOLTIP "Select Yes to ensure that this field is included in a visual list object" NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 145 BY .1.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 145 BY .1.

DEFINE VARIABLE toIncludeInDefaultView AS LOGICAL INITIAL no 
     LABEL "Include In Default View" 
     VIEW-AS TOGGLE-BOX
     SIZE 40 BY .81 TOOLTIP "Check to ensure that this field is included in a visual object when generated" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     fiName AT ROW 1 COL 53.8 COLON-ALIGNED
     btnProp AT ROW 18.76 COL 29
     fiProductModule AT ROW 1 COL 111.8 COLON-ALIGNED
     btnCancel AT ROW 18.76 COL 23.6
     fiClass AT ROW 2 COL 111.8 COLON-ALIGNED
     fiData-Type AT ROW 4.24 COL 53.8 COLON-ALIGNED
     fiFormat AT ROW 5.24 COL 53.8 COLON-ALIGNED
     fiLabel AT ROW 6.24 COL 53.8 COLON-ALIGNED
     fiColumnLabel AT ROW 7.24 COL 53.8 COLON-ALIGNED
     toIncludeInDefaultListView AT ROW 9.05 COL 56 NO-LABEL
     fiDefaultValue AT ROW 4.14 COL 111.8 COLON-ALIGNED
     fiOrder AT ROW 5.14 COL 111.8 COLON-ALIGNED
     toIncludeInDefaultView AT ROW 6.24 COL 113.8
     fiSchema-Format AT ROW 12.48 COL 53.8 COLON-ALIGNED
     fiSchema-Label AT ROW 13.48 COL 53.8 COLON-ALIGNED
     fiSchema-Column-Label AT ROW 14.48 COL 53.8 COLON-ALIGNED
     fiSchema-Initial AT ROW 15.48 COL 53.8 COLON-ALIGNED
     fiSchema-Help AT ROW 16.48 COL 55.8 NO-LABEL
     fiSchema-view-as AT ROW 13.48 COL 113.8 NO-LABEL
     fiSchema-Validate-Expression AT ROW 15 COL 113.8 NO-LABEL
     fiSchema-Validate-Message AT ROW 16.52 COL 113.8 NO-LABEL
     btnReset AT ROW 18.76 COL 18.2
     btnAdd AT ROW 18.76 COL 2
     btnDel AT ROW 18.76 COL 7.4
     btnSave AT ROW 18.76 COL 12.8
     fiLabelRender AT ROW 3.48 COL 53.8 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     fiLabelIncludeInDefaultListView AT ROW 8.38 COL 55.8 NO-LABEL
     fiLabelSchema AT ROW 11.76 COL 53.8 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     fiViewAsEdLabel AT ROW 13.67 COL 101.4 COLON-ALIGNED NO-LABEL
     fiValExprEdLabel AT ROW 15.19 COL 96.6 COLON-ALIGNED NO-LABEL
     fiHelpEdLabel AT ROW 16.62 COL 48.2 COLON-ALIGNED NO-LABEL
     fiValMsgEdLabel AT ROW 16.71 COL 98.2 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 18.62 COL 1.8
     RECT-2 AT ROW 19.81 COL 1.8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartObject
   Allow: Basic
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
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
  CREATE WINDOW sObject ASSIGN
         HEIGHT             = 18.91
         WIDTH              = 152.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB sObject 
/* ************************* Included-Libraries *********************** */

{src/adm2/visual.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW sObject
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN fiLabelIncludeInDefaultListView IN FRAME frMain
   ALIGN-L                                                              */
ASSIGN 
       fiLabelIncludeInDefaultListView:PRIVATE-DATA IN FRAME frMain     = 
                "Include In Default List View".

/* SETTINGS FOR FILL-IN fiLabelRender IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiLabelSchema IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiName IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       fiSchema-Help:RETURN-INSERTED IN FRAME frMain  = TRUE.

ASSIGN 
       fiSchema-Validate-Expression:RETURN-INSERTED IN FRAME frMain  = TRUE.

ASSIGN 
       fiSchema-Validate-Message:RETURN-INSERTED IN FRAME frMain  = TRUE.

ASSIGN 
       fiSchema-view-as:RETURN-INSERTED IN FRAME frMain  = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK sObject 


/* ***************************  Main Block  *************************** */

/* If testing in the UIB, initialize the SmartObject. */  
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
  RUN initializeObject.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE btnAdd sObject 
PROCEDURE btnAdd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hWidget  AS HANDLE     NO-UNDO.
DEFINE VARIABLE cMessage AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cButton  AS CHARACTER  NO-UNDO.

/* Clear the viewer and enable the fields */
RUN clearAllFields IN TARGET-PROCEDURE.
RUN enableAllFields IN TARGET-PROCEDURE.

/* If the user cancels the add, store which row we were on */
IF AVAILABLE ttDataField THEN
    ASSIGN gdCancelToRecordID = ttDataField.tRecordIdentifier
           gdSaveToRecordID   = 0.

/* Make sure we don't have a row selected in the browse.  We don't want to avoid confusing the user. */
ghBrowser:DESELECT-FOCUSED-ROW() NO-ERROR.
ghBrowser:SENSITIVE = FALSE.

/* Disable/enable the appropriate buttons and fields */
ASSIGN gcOperation       = "ADD":U
       hWidget           = WIDGET-HANDLE(ENTRY(LOOKUP("btnAdd":U, gcAllFieldNames), gcAllFieldHandles))
       hWidget:SENSITIVE = FALSE
       hWidget           = WIDGET-HANDLE(ENTRY(LOOKUP("btnDel":U, gcAllFieldNames), gcAllFieldHandles))
       hWidget:SENSITIVE = FALSE
       hWidget           = WIDGET-HANDLE(ENTRY(LOOKUP("btnSave":U, gcAllFieldNames), gcAllFieldHandles))
       hWidget:SENSITIVE = TRUE
       hWidget           = WIDGET-HANDLE(ENTRY(LOOKUP("btnReset":U, gcAllFieldNames), gcAllFieldHandles))
       hWidget:SENSITIVE = FALSE
       hWidget           = WIDGET-HANDLE(ENTRY(LOOKUP("btnProp":U, gcAllFieldNames), gcAllFieldHandles))
       hWidget:SENSITIVE = FALSE
       hWidget           = WIDGET-HANDLE(ENTRY(LOOKUP("btnCancel":U, gcAllFieldNames), gcAllFieldHandles))
       hWidget:SENSITIVE = TRUE
       hWidget           = WIDGET-HANDLE(ENTRY(LOOKUP("fiProductModule":U, gcAllFieldNames), gcAllFieldHandles))
       hWidget:SENSITIVE = TRUE
       hWidget           = WIDGET-HANDLE(ENTRY(LOOKUP("fiClass":U, gcAllFieldNames), gcAllFieldHandles))
       hWidget:SENSITIVE = TRUE
       hWidget           = WIDGET-HANDLE(ENTRY(LOOKUP("fiName":U, gcAllFieldNames), gcAllFieldHandles))
       hWidget:SENSITIVE = TRUE.

APPLY "ENTRY":U TO hWidget.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE btnCancel sObject 
PROCEDURE btnCancel :
/*------------------------------------------------------------------------------
  Purpose:     No matter what we were doing, cancel will always rebuild the viewer
               to ensure we have the latest data.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE dRecordIdentifier AS DECIMAL NO-UNDO.
DEFINE VARIABLE rRowid            AS ROWID   NO-UNDO.

/* We're going to rebuild with the latest data.  Refresh the whole viewer. */
ASSIGN gcOperation          = "":U
       gcStoreContainerName = "":U.

RUN rebuildViewer IN TARGET-PROCEDURE.

/* Check if the record the user was on has been stored so we can reposition to it */
FIND ttDataField
     WHERE ttDataField.tRecordIdentifier = gdCancelToRecordID
     NO-ERROR.

IF AVAILABLE ttDataField
THEN DO:
    ASSIGN rRowid = ROWID(ttDataField).
    ghQuery:REPOSITION-TO-ROWID(rRowid).
    APPLY "value-changed":U TO ghBrowser.
END.
ELSE DO:
    IF ghQuery:NUM-RESULTS > 0 
    THEN DO:
        ghQuery:REPOSITION-TO-ROW(1).
        APPLY "value-changed":U TO ghBrowser.
    END.
    ELSE
        RUN clearAllFields IN TARGET-PROCEDURE.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE btnDelete sObject 
PROCEDURE btnDelete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hDesignManager AS HANDLE     NO-UNDO.
DEFINE VARIABLE cMessage       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cButton        AS CHARACTER  NO-UNDO.

ASSIGN cMessage = "Do you wish to delete the selected data field record?".
RUN showMessages IN gshSessionManager (INPUT cMessage,
                                       INPUT "MES":U,
                                       INPUT "&Yes,&No":U,
                                       INPUT "&No":U,
                                       INPUT "&No":U,
                                       INPUT "Data Field Deletion":U,
                                       INPUT NO,
                                       INPUT THIS-PROCEDURE,
                                       OUTPUT cButton).
IF cButton <> "&YES":U THEN
    RETURN.

IF NOT AVAILABLE ttDataField 
THEN DO:
    ASSIGN cMessage = "No data field available for deletion.  Please reselect a valid datafield to delete.".
    RUN dispErrMessage IN TARGET-PROCEDURE (INPUT cMessage).
    RETURN.
END.

ASSIGN hDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).
IF NOT VALID-HANDLE(hDesignManager) THEN
    ASSIGN hDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "DesignManager":U).

IF NOT VALID-HANDLE(hDesignManager) 
THEN DO:
    ASSIGN cMessage = "Unable to delete data field, the design manager is not running.  It should be set up in the current session type under managers as 'RepositoryDesignManager'".
    RUN dispErrMessage IN TARGET-PROCEDURE (INPUT cMessage).
    RETURN.
END.

ASSIGN gcOperation = "DELETE":U.

/* Run the procedure in the design manager to delete the record */
ASSIGN ERROR-STATUS:ERROR = NO
       cMessage           = "":U.
trn-blk:
DO TRANSACTION ON ERROR UNDO trn-blk, LEAVE trn-blk:
    IF VALID-HANDLE(hDesignManager) 
    THEN DO:
        /* Remove the datafield instance from its container */
        RUN removeObjectInstance IN hDesignManager (INPUT ttDataField.container_object_filename,
                                                    INPUT "":U,  /* Container result Code */
                                                    INPUT ttDataField.object_filename,
                                                    INPUT "":U, 
                                                    INPUT "":U)  /* Instance result code */
                                                    NO-ERROR.
        IF RETURN-VALUE <> "":U
        THEN DO:
            ASSIGN cMessage = RETURN-VALUE.
            UNDO trn-blk, LEAVE trn-blk.
        END.
        IF ERROR-STATUS:ERROR 
        THEN DO:
            ASSIGN cMessage = "An unspecified error occured while attempting to delete the data field.".
            UNDO trn-blk, LEAVE trn-blk.
        END.

        /* Now remove the datafield object */
        RUN removeObject IN hDesignManager (INPUT ttDataField.object_filename,
                                            INPUT "":U) 
                                            NO-ERROR.
        IF RETURN-VALUE <> "":U 
        THEN DO:
            ASSIGN cMessage = RETURN-VALUE.
            UNDO trn-blk, LEAVE trn-blk.
        END.
        IF ERROR-STATUS:ERROR 
        THEN DO:
            ASSIGN cMessage = "An unspecified error occured while attempting to delete the data field.".
            UNDO trn-blk, LEAVE trn-blk.
        END.
    END.
END.

IF cMessage <> "":U 
THEN DO:
    ASSIGN gdCancelToRecordID = ttDataField.tRecordIdentifier.
    RUN dispErrMessage IN TARGET-PROCEDURE (INPUT cMessage).
END.

RUN btnCancel. /* Will refresh the viewer */

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE btnModify sObject 
PROCEDURE btnModify :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       There is no button modify, but if the user updates anything in a field, we *
               change to modify mode.  This proc will be run from fieldValueChanged.
------------------------------------------------------------------------------*/
DEFINE VARIABLE hWidget AS HANDLE     NO-UNDO.
DEFINE VARIABLE iOffset AS INTEGER    NO-UNDO.

/* If we're in ADD mode, or already in MODIFY mode, just return */
IF gcOperation = "ADD":U 
OR gcOperation = "MODIFY":U 
OR gcOperation = "PROP":U THEN
    RETURN.

/* Enable the fields */
IF VALID-HANDLE(SELF) 
AND CAN-SET(SELF, "CURSOR-OFFSET":U) THEN
    ASSIGN iOffset = SELF:CURSOR-OFFSET.

RUN enableAllFields IN TARGET-PROCEDURE.

IF VALID-HANDLE(SELF) 
AND CAN-SET(SELF, "CURSOR-OFFSET":U) THEN
    ASSIGN SELF:CURSOR-OFFSET= iOffset.

/* If the user cancels the add or saves, store which row we were on */
IF AVAILABLE ttDataField THEN
    ASSIGN gdCancelToRecordID = ttDataField.tRecordIdentifier
           gdSaveToRecordID   = ttDataField.tRecordIdentifier.

/* Make sure we don't have a row selected in the browse.  We don't want to avoid confusing the user. */
ghBrowser:SENSITIVE = FALSE.

/* Disable the Add and delete buttons, the user can Save, Reset or Cancel */
ASSIGN gcOperation       = "MODIFY":U
       hWidget           = WIDGET-HANDLE(ENTRY(LOOKUP("btnAdd":U, gcAllFieldNames), gcAllFieldHandles))
       hWidget:SENSITIVE = FALSE
       hWidget           = WIDGET-HANDLE(ENTRY(LOOKUP("btnDel":U, gcAllFieldNames), gcAllFieldHandles))
       hWidget:SENSITIVE = FALSE
       hWidget           = WIDGET-HANDLE(ENTRY(LOOKUP("btnSave":U, gcAllFieldNames), gcAllFieldHandles))
       hWidget:SENSITIVE = TRUE
       hWidget           = WIDGET-HANDLE(ENTRY(LOOKUP("btnReset":U, gcAllFieldNames), gcAllFieldHandles))
       hWidget:SENSITIVE = TRUE
       hWidget           = WIDGET-HANDLE(ENTRY(LOOKUP("btnCancel":U, gcAllFieldNames), gcAllFieldHandles))
       hWidget:SENSITIVE = TRUE
       hWidget           = WIDGET-HANDLE(ENTRY(LOOKUP("btnProp":U, gcAllFieldNames), gcAllFieldHandles))
       hWidget:SENSITIVE = FALSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE btnProp sObject 
PROCEDURE btnProp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cProcType       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hProcLib        AS HANDLE     NO-UNDO.
DEFINE VARIABLE iFieldCnt       AS INTEGER    NO-UNDO.
DEFINE VARIABLE hWidgetHandle   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hWidget         AS HANDLE     NO-UNDO.
DEFINE VARIABLE cAttributeList  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAttributeLabel AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAttributeValue AS CHARACTER  NO-UNDO.

IF NOT AVAILABLE ttDataField 
THEN DO:
    RUN dispErrMessage IN TARGET-PROCEDURE (INPUT "No data field record selected.  Please reselect a datafield record.").
    RETURN.
END.

RUN launchContainer IN gshSessionManager
    (INPUT "ryvobpropw":U,
     INPUT "",
     INPUT "ryvobpropw":U,
     INPUT NO,
     INPUT "",
     INPUT "",
     INPUT "",
     INPUT "",
     INPUT ?,
     INPUT ?,
     INPUT THIS-PROCEDURE,
     OUTPUT ghPropSheet,
     OUTPUT cProcType).

IF VALID-HANDLE(ghPropSheet) 
THEN DO:
    DEFINE VARIABLE hWindow AS HANDLE     NO-UNDO.
    {get containerHandle hWindow ghPropSheet}.

    /* We need to know when the propSheet is closed */
    ON 'WINDOW-CLOSE':U OF hWindow PERSISTENT RUN propSheetClose IN TARGET-PROCEDURE (INPUT ghPropSheet).

    ASSIGN hProcLib = DYNAMIC-FUNCTION("getProcLib":U IN ghPropSheet).

    SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "PropertyChangedAttribute":U IN hProcLib.

    /* Refresh the property sheet */
    EMPTY TEMP-TABLE ttUpdatedPropSheetAttrs.

    /* Build a list of attribute values */

    DO iFieldCnt = 1 TO NUM-ENTRIES(gcValidAttributes):
        ASSIGN cAttributeLabel = ENTRY(iFieldCnt, gcValidAttributes) NO-ERROR.

        IF cAttributeLabel = "TableName":U THEN
            ASSIGN cAttributeValue = gcContainerName.
        ELSE DO:
            /* If we can find an attribute that corresponds to the field name, assign the attribute value */
            IF LOOKUP("fi":U + cAttributeLabel, gcAllFieldNames) > 0 THEN
                ASSIGN hWidgetHandle = WIDGET-HANDLE(ENTRY(LOOKUP("fi":U + cAttributeLabel, gcAllFieldNames), gcAllFieldHandles)).
            ELSE
                ASSIGN hWidgetHandle = WIDGET-HANDLE(ENTRY(LOOKUP("to":U + cAttributeLabel, gcAllFieldNames), gcAllFieldHandles)).
    
            ASSIGN cAttributeValue = hWidgetHandle:SCREEN-VALUE.
        END.
        IF cAttributeValue = ? THEN ASSIGN cAttributeValue = "?":U.

        ASSIGN cAttributeList = cAttributeList + cAttributeLabel + CHR(3) + "":U + CHR(3) + cAttributeValue + CHR(3).
    END.

    /* And then add all the property sheet attributes to the list */
    FOR EACH ttPropSheetInitialValues
       WHERE ttPropSheetInitialValues.tRecordIdentifier = ttDataField.tRecordIdentifier:
        ASSIGN cAttributeList = cAttributeList + ttPropSheetInitialValues.attr_name + CHR(3) + "":U + CHR(3) + ttPropSheetInitialValues.updated_attr_value + CHR(3).
    END.
    ASSIGN cAttributeList = RIGHT-TRIM(cAttributeList, CHR(3)) NO-ERROR.

    /* Make sure it's not registered already */
    RUN unRegisterObject IN hProcLib (INPUT THIS-PROCEDURE,
                                      INPUT ttDataField.container_object_filename,
                                      INPUT ttDataField.object_filename).

    /* Register the data field */
    RUN registerObject IN hProcLib (INPUT THIS-PROCEDURE,
                                    INPUT ttDataField.container_object_filename,
                                    INPUT ttDataField.container_object_filename,
                                    INPUT ttDataField.object_filename,
                                    INPUT ttDataField.object_filename,
                                    INPUT ttDataField.object_type_code,
                                    INPUT ttDataField.object_type_code,
                                    INPUT "MASTER":U,
                                    INPUT cAttributeList,
                                    INPUT "":U,
                                    INPUT "":U,
                                    INPUT "":U,
                                    INPUT "":U).

    /* Display the object */
    RUN displayProperties IN hProcLib (INPUT THIS-PROCEDURE,
                                       INPUT ttDataField.container_object_filename,
                                       INPUT ttDataField.object_filename,
                                       INPUT "":U, /* Result Code */
                                       INPUT NO,
                                       INPUT 1).

    /* Make sure we don't have a row selected in the browse.  We don't want to avoid confusing the user. */
    RUN disableAllFields IN TARGET-PROCEDURE.
    ghBrowser:SENSITIVE = FALSE.
    
    /* Disable the Add and delete buttons, the user can Save, Reset or Cancel */
    ASSIGN gcOperation       = "Prop":U
           hWidget           = WIDGET-HANDLE(ENTRY(LOOKUP("btnAdd":U, gcAllFieldNames), gcAllFieldHandles))
           hWidget:SENSITIVE = FALSE
           hWidget           = WIDGET-HANDLE(ENTRY(LOOKUP("btnDel":U, gcAllFieldNames), gcAllFieldHandles))
           hWidget:SENSITIVE = FALSE
           hWidget           = WIDGET-HANDLE(ENTRY(LOOKUP("btnSave":U, gcAllFieldNames), gcAllFieldHandles))
           hWidget:SENSITIVE = FALSE
           hWidget           = WIDGET-HANDLE(ENTRY(LOOKUP("btnReset":U, gcAllFieldNames), gcAllFieldHandles))
           hWidget:SENSITIVE = FALSE
           hWidget           = WIDGET-HANDLE(ENTRY(LOOKUP("btnCancel":U, gcAllFieldNames), gcAllFieldHandles))
           hWidget:SENSITIVE = FALSE
           hWidget           = WIDGET-HANDLE(ENTRY(LOOKUP("btnProp":U, gcAllFieldNames), gcAllFieldHandles))
           hWidget:SENSITIVE = FALSE.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE btnReset sObject 
PROCEDURE btnReset :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN displayRecord IN TARGET-PROCEDURE.

IF VALID-HANDLE(ghLastWidgetUpdated) THEN
    APPLY "ENTRY":U TO ghLastWidgetUpdated.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE btnSave sObject 
PROCEDURE btnSave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cMessage              AS CHARACTER NO-UNDO.
DEFINE VARIABLE rRowid                AS ROWID     NO-UNDO.
DEFINE VARIABLE hStoreAttributeBuffer AS HANDLE    NO-UNDO.
DEFINE VARIABLE iFieldCnt             AS INTEGER   NO-UNDO.
DEFINE VARIABLE hWidgetHandle         AS HANDLE    NO-UNDO.
DEFINE VARIABLE dDataFieldObj         AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dInstanceObj          AS DECIMAL   NO-UNDO.
DEFINE VARIABLE hDesignManager        AS HANDLE    NO-UNDO.
DEFINE VARIABLE cAttributeName        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cAttributeType        AS CHARACTER NO-UNDO.
DEFINE VARIABLE hFieldHandle          AS HANDLE    NO-UNDO.
DEFINE VARIABLE hFieldHandle2         AS HANDLE    NO-UNDO.
DEFINE VARIABLE cValue                AS CHARACTER  NO-UNDO.

DEFINE BUFFER bttStoreAttribute FOR ttStoreAttribute.

/* Make sure we have all the detail we need */
IF gcContainerName = "":U 
THEN DO:
    RUN dispErrMessage IN TARGET-PROCEDURE (INPUT "Can not determine what the container for this data field is.  Please select a valid entity or container.").
    RETURN.
END.

do-blk:
DO ON ERROR UNDO, LEAVE:

    IF gcOperation = "MODIFY":U 
    THEN DO:
        IF NOT AVAILABLE ttDataField 
        THEN DO:
            RUN dispErrMessage IN TARGET-PROCEDURE (INPUT "No data field record selected.  Please cancel and reselect a data field record to modify.").
            RETURN.
        END.
    END.
    ELSE DO: /* ADD */
        CREATE ttDataField.
        ASSIGN ttDataField.tRecordIdentifier         = ?
               ttDataField.container_smartobject_obj = gdContainerObj
               ttDataField.container_object_filename = gcContainerName
               ttDataField.smartobject_obj           = ?
               hFieldHandle                          = WIDGET-HANDLE(ENTRY(LOOKUP("fiName":U, gcAllFieldNames), gcAllFieldHandles))
               ttDataField.object_filename           = gcContainerName + ".":U + hFieldHandle:SCREEN-VALUE
               hFieldHandle                          = WIDGET-HANDLE(ENTRY(LOOKUP("fiClass":U, gcAllFieldNames), gcAllFieldHandles))
               ttDataField.object_type_code          = hFieldHandle:SCREEN-VALUE
               hFieldHandle                          = WIDGET-HANDLE(ENTRY(LOOKUP("fiProductModule":U, gcAllFieldNames), gcAllFieldHandles))
               ttDataField.product_module            = hFieldHandle:SCREEN-VALUE.
    END.
    ASSIGN hFieldHandle               = WIDGET-HANDLE(ENTRY(LOOKUP("fiOrder":U, gcAllFieldNames), gcAllFieldHandles)).
           ttDataField.instance_order = INTEGER(hFieldHandle:SCREEN-VALUE).

    /* Create a store attribute record for each attribute that needs to be updated */
    EMPTY TEMP-TABLE ttStoreAttribute.

    DO iFieldCnt = 1 TO NUM-ENTRIES(gcValidAttributes):
        ASSIGN cAttributeName = ENTRY(iFieldCnt, gcValidAttributes)
               cAttributeType = ENTRY(iFieldCnt, gcAttributeTypes)
               NO-ERROR.

        IF cAttributeName = "TableName":U 
        THEN DO:
            CREATE ttStoreAttribute.
            ASSIGN ttStoreAttribute.tAttributeParent = "MASTER":U
                   ttStoreAttribute.tAttributeLabel  = cAttributeName
                   ttStoreAttribute.tCharacterValue  = gcContainerName.
        END.
        ELSE DO:
            /* If we can find an attribute that corresponds to the field name, assign the attribute value */
            IF LOOKUP("fi":U + cAttributeName, gcAllFieldNames) > 0 THEN
              ASSIGN hWidgetHandle = WIDGET-HANDLE(ENTRY(LOOKUP("fi":U + cAttributeName, gcAllFieldNames), gcAllFieldHandles)).
            ELSE
              ASSIGN hWidgetHandle = WIDGET-HANDLE(ENTRY(LOOKUP("to":U + cAttributeName, gcAllFieldNames), gcAllFieldHandles)).
    
            /* Create an attribute record for the master */
            CREATE ttStoreAttribute.
            ASSIGN ttStoreAttribute.tAttributeParent = "MASTER":U
                   ttStoreAttribute.tAttributeLabel  = cAttributeName.
            IF VALID-HANDLE(hWidgetHandle) THEN
               ASSIGN cValue   = IF hWidgetHandle:SCREEN-VALUE ="?":U 
                                 THEN ? 
                                 ELSE hWidgetHandle:SCREEN-VALUE.

            CASE cAttributeType:
                WHEN "CHARACTER":U THEN ASSIGN ttStoreAttribute.tCharacterValue = cValue.
                WHEN "DECIMAL":U   THEN ASSIGN ttStoreAttribute.tDecimalValue   = DECIMAL(cValue).
                WHEN "INTEGER":U   THEN ASSIGN ttStoreAttribute.tIntegerValue   = INTEGER(cValue).
                WHEN "DATE":U      THEN ASSIGN ttStoreAttribute.tDateValue      = DATE(cValue).
                WHEN "LOGICAL":U   THEN ASSIGN ttStoreAttribute.tLogicalValue   = LOGICAL(cValue).
                OTHERWISE ASSIGN ttStoreAttribute.tCharacterValue = cValue.
            END CASE.
        END.
    END.

    /* Create temp-table recs for any additional attributes set in the property sheet. *
     * Ignore attributes set on the viewer as we know their values will be correct.    */ 
    FOR EACH ttUpdatedPropSheetAttrs:
        IF NOT CAN-FIND(FIRST ttStoreAttribute
                        WHERE ttStoreAttribute.tAttributeLabel = ttUpdatedPropSheetAttrs.attribute_name) 
        THEN DO:
            CREATE ttStoreAttribute.
            ASSIGN ttStoreAttribute.tAttributeParent = "MASTER":U
                   ttStoreAttribute.tAttributeLabel  = ttUpdatedPropSheetAttrs.attribute_name.

            CASE ttUpdatedPropSheetAttrs.data_type:
                WHEN "CHARACTER":U THEN ASSIGN ttStoreAttribute.tCharacterValue = 
                                                   IF ttUpdatedPropSheetAttrs.character_attribute_value = "?" 
                                                   THEN ?
                                                   ELSE ttUpdatedPropSheetAttrs.character_attribute_value.
                WHEN "DECIMAL":U   THEN ASSIGN ttStoreAttribute.tDecimalValue   = ttUpdatedPropSheetAttrs.decimal_attribute_value.
                WHEN "INTEGER":U   THEN ASSIGN ttStoreAttribute.tIntegerValue   = ttUpdatedPropSheetAttrs.integer_attribute_value.
                WHEN "DATE":U      THEN ASSIGN ttStoreAttribute.tDateValue      = ttUpdatedPropSheetAttrs.date_attribute_value.
                WHEN "LOGICAL":U   THEN ASSIGN ttStoreAttribute.tLogicalValue   = ttUpdatedPropSheetAttrs.logical_attribute_value.
                OTHERWISE ASSIGN ttStoreAttribute.tCharacterValue = ttUpdatedPropSheetAttrs.character_attribute_value.
            END CASE.
        END.
    END.

    /* Make sure we know what the repository design managers handle is */
    ASSIGN hDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).
    IF NOT VALID-HANDLE(hDesignManager) THEN
        ASSIGN hDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "DesignManager":U).

    IF NOT VALID-HANDLE(hDesignManager) 
    THEN DO:
        RUN dispErrMessage IN TARGET-PROCEDURE (INPUT "Unable to delete data field, the design manager is not running.  It should be set up in the current session type under managers as 'RepositoryDesignManager'").
        RETURN.
    END.

    /* And write the information to the database... */
    ASSIGN cMessage           = "":U
           ERROR-STATUS:ERROR = NO.
    trn-blk:
    DO TRANSACTION ON ERROR UNDO trn-blk, LEAVE trn-blk:

        ASSIGN hStoreAttributeBuffer = TEMP-TABLE ttStoreAttribute:HANDLE.

        IF gcOperation <> "ADD":U 
        THEN DO:
            /* First remove existing Attribute Values for the Master Object, if the object exists */
            IF ttDataField.smartobject_obj <> ? AND
               ttDataField.smartobject_obj <> 0 THEN
              RUN removeAttributeValues IN hDesignManager (INPUT (TEMP-TABLE ttStoreAttribute:DEFAULT-BUFFER-HANDLE),
                                                           INPUT TABLE-HANDLE hStoreAttributeBuffer).
        END.

        /* Update the master */
        RUN insertObjectMaster IN hDesignManager (INPUT ttDataField.object_filename,
                                                  INPUT "":U, /* Result Code */
                                                  INPUT ttDataField.product_module,
                                                  INPUT "DataField":U,
                                                  INPUT "Data field " + ttDataField.object_filename,
                                                  INPUT "":U, /* Object path */
                                                  INPUT "":U, /* SDO name */
                                                  INPUT "":U, /* Super proc */
                                                  INPUT NO,   /* Template */
                                                  INPUT YES,  /* Static   */
                                                  INPUT "":U, /* Physical Object name */
                                                  INPUT NO,   /* Run persistent */
                                                  INPUT "Data field " + ttDataField.object_filename, /* Tooltip */
                                                  INPUT "":U, /* Required db list */
                                                  INPUT "":U, /* Layout code */
                                                  INPUT ?,
                                                  INPUT TABLE-HANDLE hStoreAttributeBuffer,    /* Attribute table handle */
                                                  OUTPUT dDataFieldObj
                                                  ) /* NO-ERROR */.
        IF RETURN-VALUE <> "":U 
        THEN DO:
            ASSIGN cMessage = RETURN-VALUE.
            UNDO trn-blk, LEAVE trn-blk.
        END.
        IF ERROR-STATUS:ERROR 
        THEN DO:
            ASSIGN cMessage = "An unspecified error occured while updating the data field master.".
            UNDO trn-blk, LEAVE trn-blk.
        END.

        /* Update the container instance */
        ASSIGN hFieldHandle = WIDGET-HANDLE(ENTRY(LOOKUP("fiName":U, gcAllFieldNames), gcAllFieldHandles)).
        RUN insertObjectInstance IN hDesignManager (INPUT ttDataField.container_smartobject_obj,
                                                    INPUT ttDataField.object_filename,
                                                    INPUT "":U, /* Result Code */
                                                    INPUT hFieldHandle:SCREEN-VALUE, /* Instance Name */
                                                    INPUT "Data field " + ttDataField.object_filename, /* Description */
                                                    INPUT STRING(ttDataField.instance_order), /* Layout */
                                                    INPUT NO,   /* Force create new */
                                                    INPUT ?,
                                                    INPUT TABLE-HANDLE hStoreAttributeBuffer, /* Attribute table handle */
                                                    OUTPUT dDataFieldObj,
                                                    OUTPUT dInstanceObj
                                                    ) NO-ERROR.
        IF RETURN-VALUE <> "":U 
        THEN DO:
            ASSIGN cMessage = RETURN-VALUE.
            UNDO trn-blk, LEAVE trn-blk.
        END.
        IF ERROR-STATUS:ERROR 
        THEN DO:
            ASSIGN cMessage = "An unspecified error occured while updating the data field instance.".
            UNDO trn-blk, LEAVE trn-blk.
        END.
    END.
    IF cMessage <> "":U 
    THEN DO:
        RUN dispErrMessage IN TARGET-PROCEDURE (INPUT cMessage).
        UNDO do-blk, RETURN.
    END.
END.

/* Clear the temp table */
EMPTY TEMP-TABLE ttStoreAttribute.

/* We're going to rebuild with the latest data.  Refresh the whole viewer. */
ASSIGN gcOperation          = "":U
       gcStoreContainerName = "":U.

RUN rebuildViewer IN TARGET-PROCEDURE.

/* Check if the record the user was on has been stored so we can reposition to it */
FIND ttDataField
     WHERE ttDataField.tRecordIdentifier = gdSaveToRecordID
     NO-ERROR.

IF AVAILABLE ttDataField
THEN DO:
    ASSIGN rRowid = ROWID(ttDataField).
    ghQuery:REPOSITION-TO-ROWID(rRowid).
    APPLY "value-changed":U TO ghBrowser.
END.
ELSE DO:
    IF ghQuery:NUM-RESULTS > 0 
    THEN DO:
        ghQuery:REPOSITION-TO-ROW(1).
        APPLY "value-changed":U TO ghBrowser.
    END.
    ELSE
        RUN clearAllFields IN TARGET-PROCEDURE.
END.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildBrowser sObject 
PROCEDURE buildBrowser :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hFrame AS HANDLE NO-UNDO.

/* Make sure to clean up if objects already exist */
IF VALID-HANDLE(ghQuery) 
THEN DO:
    ghQuery:QUERY-CLOSE NO-ERROR.
    DELETE OBJECT ghQuery NO-ERROR.
    ASSIGN ghQuery = ?.
END.

IF VALID-HANDLE(ghBrowser) 
THEN DO:
    DELETE OBJECT ghBrowser NO-ERROR.
    ASSIGN ghBrowser = ?.
END.

/* Create our query */
CREATE QUERY ghQuery.
ghQuery:SET-BUFFERS(BUFFER ttDataField:HANDLE).
ghQuery:QUERY-PREPARE("FOR EACH ttDataField BY ttDataField.instance_order":U).

/* Create the browser */
{get ContainerHandle hFrame}.

CREATE BROWSE ghBrowser
    ASSIGN FRAME                  = hFrame
           NAME                   = "DataFields":U
           QUERY                  = ghQuery
           ROW                    = 1
           COLUMN                 = 1
           ROW-MARKERS            = NO
           SEPARATORS             = YES
           COLUMN-RESIZABLE       = YES
           ALLOW-COLUMN-SEARCHING = YES
           READ-ONLY              = YES
           EXPANDABLE             = YES
           TOOLTIP                = "Select a datafield for the selected entity"
           PRIVATE-DATA           = "FOR EACH ttDataField BY ttDataField.instance_order":U
    TRIGGERS:
        ON VALUE-CHANGED PERSISTENT RUN displayRecord IN TARGET-PROCEDURE.
        ON START-SEARCH  PERSISTENT RUN startSearch   IN TARGET-PROCEDURE (INPUT ghBrowser).
    END TRIGGERS.

IF gcFilterField = ?
OR gcFilterField = "":U THEN
    ghBrowser:ADD-LIKE-COLUMN("ttDataField.instance_order":U).
ghBrowser:ADD-LIKE-COLUMN("ttDataField.object_filename":U).
ghQuery:QUERY-OPEN().

IF ghQuery:NUM-RESULTS > 0 
THEN DO:
    ghQuery:REPOSITION-TO-ROW(1) NO-ERROR.
    APPLY "value-changed":U TO ghBrowser.
END.

ASSIGN ghBrowser:VISIBLE   = YES
       ghBrowser:SENSITIVE = YES.

/* Make sure the browser is sized correctly */
RUN resizeObject IN TARGET-PROCEDURE (INPUT MAX(hFrame:HEIGHT, gdStoreHeight),
                                      INPUT MAX(hFrame:WIDTH, gdStoreWidth)
                                     ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearAllFields sObject 
PROCEDURE clearAllFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hField    AS HANDLE     NO-UNDO.
DEFINE VARIABLE iFieldCnt AS INTEGER    NO-UNDO.

DO iFieldCnt = 1 TO NUM-ENTRIES(gcAllFieldHandles):
    ASSIGN hField = WIDGET-HANDLE(ENTRY(iFieldCnt, gcAllFieldHandles)).

    CASE hField:TYPE:
        WHEN "FILL-IN":U
        OR WHEN "EDITOR":U THEN
            ASSIGN hField:SCREEN-VALUE = "":U.

        WHEN "COMBO-BOX":U THEN
            ASSIGN hField:SCREEN-VALUE = hField:ENTRY(1) NO-ERROR.
    END CASE.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createDataFieldRecs sObject 
PROCEDURE createDataFieldRecs :
/*------------------------------------------------------------------------------
  Purpose:     Move all the information for our dataFields into local buffers.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE BUFFER dataField_object FOR cache_object.
DEFINE BUFFER container_object FOR cache_object.

DEFINE VARIABLE dRecordIdentifier AS DECIMAL NO-UNDO.
DEFINE VARIABLE ghObjectBuffer    AS HANDLE  NO-UNDO.
DEFINE VARIABLE ghAttrBuffer      AS HANDLE  NO-UNDO.
DEFINE VARIABLE hField            AS HANDLE  NO-UNDO.
DEFINE VARIABLE iFieldCnt         AS INTEGER NO-UNDO.
DEFINE VARIABLE hObjectTable      AS HANDLE  NO-UNDO.

EMPTY TEMP-TABLE cache_object. /* The local one, not the rep manager one */
EMPTY TEMP-TABLE ttDataField.
EMPTY TEMP-TABLE ttDataFieldAttr.

IF VALID-HANDLE(gshSessionManager) THEN
    ASSIGN gcSessionResultCodes = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager, 
                                                   INPUT "clientSessionResultCodes":U, 
                                                   INPUT NO).

IF VALID-HANDLE(gshRepositoryManager)
AND DYNAMIC-FUNCTION("cacheObjectOnClient":U IN gshRepositoryManager,
                     INPUT gcContainerName,
                     INPUT gcSessionResultCodes,
                     INPUT "":U, /* Run attribute */
                     INPUT YES)  /*  Design mode  */
THEN DO:
    /* The dataFields have been retrieved and cached.  Move them into local buffers now */
    ASSIGN ghObjectBuffer    = DYNAMIC-FUNCTION("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT ?)
           dRecordIdentifier = ghObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE
           gdContainerObj    = ghObjectBuffer:BUFFER-FIELD("tSmartObjectObj":U):BUFFER-VALUE
           NO-ERROR.

    IF ERROR-STATUS:ERROR
    OR dRecordIdentifier = ? THEN
        RETURN "ERROR":U.

    /* We've got the master container now, we need to find all its dataField instances.          * 
     * First, we make the table-handle a static TT. It makes our code faster and easier to read. */
    ASSIGN hObjectTable = IF ghObjectBuffer:TYPE = "BUFFER":U 
                          THEN ghObjectBuffer:TABLE-HANDLE
                          ELSE ghObjectBuffer.

    RUN makeObjectTTHandleStatic IN TARGET-PROCEDURE (INPUT TABLE-HANDLE hObjectTable).

    FIND container_object
         WHERE container_object.tRecordIdentifier = dRecordIdentifier
         NO-ERROR.

    fe-blk:
    FOR EACH dataField_object 
       WHERE dataField_object.tContainerRecordIdentifier = container_object.tRecordIdentifier:

        IF LOOKUP("dataField":U, dataField_object.tInheritsFromClasses) > 0
        THEN DO:
            IF gcFilterField = ?
            OR gcFilterField = "":U THEN. /* do nothing */
            ELSE
                IF dataField_object.tLogicalObjectName <> gcFilterField THEN
                    NEXT fe-blk.

            /* Create our dataField record */
            CREATE ttDataField.
            ASSIGN ttDataField.tRecordIdentifier         = dataField_object.tRecordIdentifier
                   ttDataField.container_smartobject_obj = container_object.tSmartObjectObj
                   ttDataField.container_object_filename = container_object.tLogicalObjectName
                   ttDataField.smartobject_obj           = dataField_object.tSmartObjectObj
                   ttDataField.object_filename           = dataField_object.tLogicalObjectName
                   ttDataField.object_type_code          = datafield_object.tClassName
                   ttDataField.product_module            = datafield_object.tProductModuleCode
                   ttDataField.instance_order            = INTEGER(datafield_object.tLayoutPosition)
                   NO-ERROR.

            /* Create a record for each of the dataField attributes we're interested in */
            ASSIGN ghAttrBuffer = dataField_object.tClassBufferHandle.
            ghAttrBuffer:FIND-FIRST("WHERE tRecordIdentifier = " + QUOTER(dataField_object.tRecordIdentifier)) NO-ERROR.

            IF ghAttrBuffer:AVAILABLE THEN
               do-blk:
               DO iFieldCnt = 1 TO ghAttrBuffer:NUM-FIELDS:
                   ASSIGN hField = ghAttrBuffer:BUFFER-FIELD(iFieldCnt).

                   /* We're only going to allow the user to update certain attributes from this viewer. *
                    * The rest have to be updated using the Dynamics property sheet.                    */
                   IF LOOKUP(hField:NAME, gcValidAttributes) = 0
                   OR LOOKUP(hField:NAME, gcValidAttributes) = ? 
                   THEN DO:
                       IF hField:BUFFER-VALUE <> hField:INITIAL 
                       THEN DO:
                           CREATE ttPropSheetInitialValues.
                           ASSIGN ttPropSheetInitialValues.tRecordIdentifier  = dataField_object.tRecordIdentifier
                                  ttPropSheetInitialValues.attr_name          = hField:NAME
                                  ttPropSheetInitialValues.updated_attr_value = IF hField:BUFFER-VALUE <> ?
                                                                                THEN hField:BUFFER-VALUE
                                                                                ELSE "?":U.
                       END.
                   END.
                   ELSE DO:
                       CREATE ttDataFieldAttr.
                       ASSIGN ttDataFieldAttr.tRecordIdentifier  = dataField_object.tRecordIdentifier
                              ttDataFieldAttr.attr_name          = hField:NAME
                              ttDataFieldAttr.updated_attr_value = hField:BUFFER-VALUE.
                   END.
               END.
        END.
    END.
END.
ELSE
    RETURN "ERROR":U.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataAvailable sObject 
PROCEDURE dataAvailable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       We're assuming we have a link to our parent SDO here.
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcAction AS CHARACTER  NO-UNDO.

RUN rebuildViewer IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject sObject 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF VALID-HANDLE(ghPropSheet) THEN
    APPLY "CLOSE":U TO ghPropSheet.

RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableAllFields sObject 
PROCEDURE disableAllFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cAllFieldHandles AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iFieldCnt        AS INTEGER    NO-UNDO.
DEFINE VARIABLE hField           AS HANDLE     NO-UNDO.

DO iFieldCnt = 1 TO NUM-ENTRIES(gcAllFieldHandles):
    ASSIGN hField = WIDGET-HANDLE(ENTRY(iFieldCnt, gcAllFieldHandles)).
    IF VALID-HANDLE(hField)
    AND CAN-SET(hField, "SENSITIVE":U) THEN
        ASSIGN hField:SENSITIVE = NO.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI sObject  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dispErrMessage sObject 
PROCEDURE dispErrMessage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER ipMessage AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cButton AS CHARACTER  NO-UNDO.

RUN showMessages IN gshSessionManager (INPUT ipMessage,
                                       INPUT "ERR":U,
                                       INPUT "OK":U,
                                       INPUT "OK":U,
                                       INPUT "OK":U,
                                       INPUT "Data Fields":U,
                                       INPUT NO,
                                       INPUT THIS-PROCEDURE,
                                       OUTPUT cButton).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayRecord sObject 
PROCEDURE displayRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hField           AS HANDLE     NO-UNDO.
DEFINE VARIABLE cFieldName       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iFieldCnt        AS INTEGER    NO-UNDO.
DEFINE VARIABLE cMessage         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cButton          AS CHARACTER  NO-UNDO.

IF NOT AVAILABLE ttDataField THEN
    RUN clearAllFields IN TARGET-PROCEDURE.
ELSE
    DO iFieldCnt = 1 TO NUM-ENTRIES(gcAllFieldNames):
        ASSIGN hField     = WIDGET-HANDLE(ENTRY(iFieldCnt, gcAllFieldHandles))
               cFieldName = ENTRY(iFieldCnt, gcAllFieldNames).
    
        CASE cFieldName:
            WHEN "fiProductModule":U THEN
                ASSIGN hField:SCREEN-VALUE = ttDataField.product_module.

            WHEN "fiClass":U THEN
                ASSIGN hField:SCREEN-VALUE = ttDataField.object_type_code.

            WHEN "fiOrder":U THEN
                ASSIGN hField:SCREEN-VALUE = STRING(ttDataField.instance_order).

            OTHERWISE DO:
                /* The fill-in name corresponds to the attribute name.  All we have to do is strip the first two characters (fi or ed usually) */
                FIND FIRST ttDataFieldAttr
                     WHERE ttDataFieldAttr.tRecordIdentifier = ttDataField.tRecordIdentifier
                       AND ttDataFieldAttr.attr_name         = SUBSTRING(cFieldName,3)
                     NO-ERROR.

                IF AVAILABLE ttDataFieldAttr 
                AND VALID-HANDLE(hField) THEN
                  IF hField:TYPE <> "TOGGLE-BOX":U THEN
                    ASSIGN hField:SCREEN-VALUE = ttDataFieldAttr.updated_attr_value.
                  ELSE
                    ASSIGN hField:CHECKED = LOGICAL(ttDataFieldAttr.updated_attr_value) NO-ERROR.
            END.
        END CASE.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableAllFields sObject 
PROCEDURE enableAllFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE iFieldCnt        AS INTEGER    NO-UNDO.
DEFINE VARIABLE hField           AS HANDLE     NO-UNDO.

DO iFieldCnt = 1 TO NUM-ENTRIES(gcAllFieldHandles):
    ASSIGN hField = WIDGET-HANDLE(ENTRY(iFieldCnt, gcAllFieldHandles)).
    IF VALID-HANDLE(hField) 
    AND CAN-SET(hField, "SENSITIVE":U) 
    THEN DO:
        IF hField:NAME = "fiName":U 
        OR hField:NAME = "fiProductModule":U
        OR hField:NAME = "fiClass":U 
        OR hField:NAME BEGINS "fiSchema":U THEN
            ASSIGN hField:SENSITIVE = NO.
        ELSE
            ASSIGN hField:SENSITIVE = YES.
    END.        
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fieldLeave sObject 
PROCEDURE fieldLeave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hFieldHandle AS HANDLE     NO-UNDO.

/* SCHEMA fields are not updatable any more, they may be again later
IF gcOperation = "ADD":U THEN
    CASE SELF:NAME:
        WHEN "fiFormat":U 
        THEN DO:
            ASSIGN hFieldHandle = WIDGET-HANDLE(ENTRY(LOOKUP("fiSchema-Format":U, gcAllFieldNames), gcAllFieldHandles)) NO-ERROR.
            IF VALID-HANDLE(hFieldHandle) 
            AND hFieldHandle:SCREEN-VALUE = "":U THEN
                ASSIGN hFieldHandle:SCREEN-VALUE = SELF:SCREEN-VALUE.    
        END.
        
        WHEN "fiSchema-Format":U 
        THEN DO:
            ASSIGN hFieldHandle = WIDGET-HANDLE(ENTRY(LOOKUP("fiFormat":U, gcAllFieldNames), gcAllFieldHandles)) NO-ERROR.
            IF VALID-HANDLE(hFieldHandle) 
            AND hFieldHandle:SCREEN-VALUE = "":U THEN
                ASSIGN hFieldHandle:SCREEN-VALUE = SELF:SCREEN-VALUE.    
        END.

        WHEN "fiLabel":U 
        THEN DO:
            ASSIGN hFieldHandle = WIDGET-HANDLE(ENTRY(LOOKUP("fiSchema-Label":U, gcAllFieldNames), gcAllFieldHandles)) NO-ERROR.
            IF VALID-HANDLE(hFieldHandle) 
            AND hFieldHandle:SCREEN-VALUE = "":U THEN
                ASSIGN hFieldHandle:SCREEN-VALUE = SELF:SCREEN-VALUE.    
        END.

        WHEN "fiSchema-Label":U 
        THEN DO:
            ASSIGN hFieldHandle = WIDGET-HANDLE(ENTRY(LOOKUP("fiLabel":U, gcAllFieldNames), gcAllFieldHandles)) NO-ERROR.
            IF VALID-HANDLE(hFieldHandle) 
            AND hFieldHandle:SCREEN-VALUE = "":U THEN
                ASSIGN hFieldHandle:SCREEN-VALUE = SELF:SCREEN-VALUE.    
        END.

        WHEN "fiColumnLabel":U 
        THEN DO:
            ASSIGN hFieldHandle = WIDGET-HANDLE(ENTRY(LOOKUP("fiSchema-Column-Label":U, gcAllFieldNames), gcAllFieldHandles)) NO-ERROR.
            IF VALID-HANDLE(hFieldHandle) 
            AND hFieldHandle:SCREEN-VALUE = "":U THEN
                ASSIGN hFieldHandle:SCREEN-VALUE = SELF:SCREEN-VALUE.    
        END.

        WHEN "fiSchema-Column-Label":U 
        THEN DO:
            ASSIGN hFieldHandle = WIDGET-HANDLE(ENTRY(LOOKUP("fiColumnLabel":U, gcAllFieldNames), gcAllFieldHandles)) NO-ERROR.
            IF VALID-HANDLE(hFieldHandle) 
            AND hFieldHandle:SCREEN-VALUE = "":U THEN
                ASSIGN hFieldHandle:SCREEN-VALUE = SELF:SCREEN-VALUE.    
        END.

        WHEN "fiInitialValue":U 
        THEN DO:
            ASSIGN hFieldHandle = WIDGET-HANDLE(ENTRY(LOOKUP("fiSchema-Initial":U, gcAllFieldNames), gcAllFieldHandles)) NO-ERROR.
            IF VALID-HANDLE(hFieldHandle) 
            AND hFieldHandle:SCREEN-VALUE = "":U THEN
                ASSIGN hFieldHandle:SCREEN-VALUE = SELF:SCREEN-VALUE.    
        END.

        WHEN "fiSchema-Initial":U 
        THEN DO:
            ASSIGN hFieldHandle = WIDGET-HANDLE(ENTRY(LOOKUP("fiInitialValue":U, gcAllFieldNames), gcAllFieldHandles)) NO-ERROR.            
            IF VALID-HANDLE(hFieldHandle) 
            AND hFieldHandle:SCREEN-VALUE = "":U THEN
                ASSIGN hFieldHandle:SCREEN-VALUE = SELF:SCREEN-VALUE.    
        END.

        WHEN "fiViewAs":U 
        THEN DO:
            ASSIGN hFieldHandle = WIDGET-HANDLE(ENTRY(LOOKUP("fiSchema-View-As":U, gcAllFieldNames), gcAllFieldHandles)) NO-ERROR.
            IF VALID-HANDLE(hFieldHandle) 
            AND hFieldHandle:SCREEN-VALUE = "":U THEN
                ASSIGN hFieldHandle:SCREEN-VALUE = SELF:SCREEN-VALUE.    
        END.

        WHEN "fiSchema-View-As":U 
        THEN DO:
            ASSIGN hFieldHandle = WIDGET-HANDLE(ENTRY(LOOKUP("fiViewAs":U, gcAllFieldNames), gcAllFieldHandles)) NO-ERROR.
            IF VALID-HANDLE(hFieldHandle) 
            AND hFieldHandle:SCREEN-VALUE = "":U THEN
                ASSIGN hFieldHandle:SCREEN-VALUE = SELF:SCREEN-VALUE.    
        END.
    END CASE.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fieldValueChanged sObject 
PROCEDURE fieldValueChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* We don't want to go into MODIFY mode if this trigger is firing due to *
 * fields being initialised.                                             */
IF glInitialising THEN
    RETURN.

ASSIGN ghLastWidgetUpdated = SELF.

RUN btnModify IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getParentInfo sObject 
PROCEDURE getParentInfo :
/*------------------------------------------------------------------------------
  Purpose:     Used to determine which container we're displaying dataFields for.
               It could be the entity itself if we're dealing with master dataFields, 
               or else the name of an SDO, viewer etc.      
  Parameters:  <none>
  Notes:       If we change this program to launch from other places than entity 
               mnemonic maintenance, the only change should be to get the owning
               info differently here.
------------------------------------------------------------------------------*/
DEFINE VARIABLE hSDO AS HANDLE     NO-UNDO.
/* We're going to check if we have a data link to the parent SDO.               *
 * If we do, look for a entity_mnemonic value, or a repository object_filename. */
ASSIGN gcContainerName = "":U.

{get dataSource hSDO}.

IF VALID-HANDLE(hSdo) 
THEN DO:
    ASSIGN gcContainerName = {fnarg columnValue "'entity_mnemonic_description'" hSDO}.

    IF gcContainerName = ? 
    OR gcContainerName = "":U THEN
        ASSIGN gcContainerName = {fnarg columnValue "'object_filename'" hSDO}.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject sObject 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super 0.Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hFieldHandle  AS HANDLE     NO-UNDO.
DEFINE VARIABLE iFieldCnt     AS INTEGER    NO-UNDO.

IF NUM-ENTRIES(gcAllFieldHandles) = 0 
THEN DO:
    {get allFieldNames gcAllFieldNames}.
    {get allFieldHandles gcAllFieldHandles}.
END.

RUN SUPER.

/* Set up our fill-in type labels */
ASSIGN hFieldHandle = WIDGET-HANDLE(ENTRY(LOOKUP("fiLabelRender":U, gcAllFieldNames), gcAllFieldHandles)) NO-ERROR.
IF VALID-HANDLE(hFieldHandle) THEN
    ASSIGN hFieldHandle:SCREEN-VALUE = "Default Settings used when rendering Data Fields:":U.

ASSIGN hFieldHandle = WIDGET-HANDLE(ENTRY(LOOKUP("fiLabelSchema":U, gcAllFieldNames), gcAllFieldHandles)) NO-ERROR.
IF VALID-HANDLE(hFieldHandle) THEN
    ASSIGN hFieldHandle:SCREEN-VALUE = "Schema Settings:":U.

ASSIGN hFieldHandle = WIDGET-HANDLE(ENTRY(LOOKUP("fiViewAsEdLabel":U, gcAllFieldNames), gcAllFieldHandles)) NO-ERROR.
IF VALID-HANDLE(hFieldHandle) THEN
    ASSIGN hFieldHandle:SCREEN-VALUE = "VIEW-AS:":U.

ASSIGN hFieldHandle = WIDGET-HANDLE(ENTRY(LOOKUP("fiViewAsEdLabel-2":U, gcAllFieldNames), gcAllFieldHandles)) NO-ERROR.
IF VALID-HANDLE(hFieldHandle) THEN
    ASSIGN hFieldHandle:SCREEN-VALUE = "VIEW-AS:":U.

ASSIGN hFieldHandle = WIDGET-HANDLE(ENTRY(LOOKUP("fiValExprEdLabel":U, gcAllFieldNames), gcAllFieldHandles)) NO-ERROR.
IF VALID-HANDLE(hFieldHandle) THEN
    ASSIGN hFieldHandle:SCREEN-VALUE = "Val Expression:":U.

ASSIGN hFieldHandle = WIDGET-HANDLE(ENTRY(LOOKUP("fiValMsgEdLabel":U, gcAllFieldNames), gcAllFieldHandles)) NO-ERROR.
IF VALID-HANDLE(hFieldHandle) THEN
    ASSIGN hFieldHandle:SCREEN-VALUE = "Val Message:":U.

ASSIGN hFieldHandle = WIDGET-HANDLE(ENTRY(LOOKUP("fiHelpEdLabel":U, gcAllFieldNames), gcAllFieldHandles)) NO-ERROR.
IF VALID-HANDLE(hFieldHandle) THEN
    ASSIGN hFieldHandle:SCREEN-VALUE = "Help:":U.

ASSIGN hFieldHandle = WIDGET-HANDLE(ENTRY(LOOKUP("fiLabelIncludeInDefaultListView":U, gcAllFieldNames), gcAllFieldHandles)) NO-ERROR.
IF VALID-HANDLE(hFieldHandle) THEN
    ASSIGN hFieldHandle:SCREEN-VALUE = hFieldHandle:PRIVATE-DATA.

/* Add triggers */
ASSIGN hFieldHandle = WIDGET-HANDLE(ENTRY(LOOKUP("btnAdd":U, gcAllFieldNames), gcAllFieldHandles)) NO-ERROR.
IF VALID-HANDLE(hFieldHandle) THEN
    ON CHOOSE OF hFieldHandle PERSISTENT RUN btnAdd IN TARGET-PROCEDURE.

ASSIGN hFieldHandle = WIDGET-HANDLE(ENTRY(LOOKUP("btnDel":U, gcAllFieldNames), gcAllFieldHandles)) NO-ERROR.
IF VALID-HANDLE(hFieldHandle) THEN
    ON CHOOSE OF hFieldHandle PERSISTENT RUN btnDelete IN TARGET-PROCEDURE.

ASSIGN hFieldHandle = WIDGET-HANDLE(ENTRY(LOOKUP("btnCancel":U, gcAllFieldNames), gcAllFieldHandles)) NO-ERROR.
IF VALID-HANDLE(hFieldHandle) THEN
    ON CHOOSE OF hFieldHandle PERSISTENT RUN btnCancel IN TARGET-PROCEDURE.

ASSIGN hFieldHandle = WIDGET-HANDLE(ENTRY(LOOKUP("btnSave":U, gcAllFieldNames), gcAllFieldHandles)) NO-ERROR.
IF VALID-HANDLE(hFieldHandle) THEN
    ON CHOOSE OF hFieldHandle PERSISTENT RUN btnSave IN TARGET-PROCEDURE.

ASSIGN hFieldHandle = WIDGET-HANDLE(ENTRY(LOOKUP("btnReset":U, gcAllFieldNames), gcAllFieldHandles)) NO-ERROR.
IF VALID-HANDLE(hFieldHandle) THEN
    ON CHOOSE OF hFieldHandle PERSISTENT RUN btnReset IN TARGET-PROCEDURE.

ASSIGN hFieldHandle = WIDGET-HANDLE(ENTRY(LOOKUP("btnProp":U, gcAllFieldNames), gcAllFieldHandles)) NO-ERROR.
IF VALID-HANDLE(hFieldHandle) THEN
    ON CHOOSE OF hFieldHandle PERSISTENT RUN btnProp IN TARGET-PROCEDURE.

/* On update of any field, we go into modify mode */
DO iFieldCnt = 1 TO NUM-ENTRIES(gcAllFieldHandles):
    ASSIGN hFieldHandle = WIDGET-HANDLE(ENTRY(iFieldCnt, gcAllFieldHandles)) NO-ERROR.

    IF VALID-HANDLE(hFieldHandle) 
    AND (hFieldHandle:TYPE = "FILL-IN":U
      OR hFieldHandle:TYPE = "EDITOR":U
      OR hFieldHandle:TYPE = "COMBO-BOX":U
      OR hFieldHandle:TYPE = "TOGGLE-BOX":U
      OR hFieldHandle:TYPE = "RADIO-SET":U) 
    THEN DO:
        ON VALUE-CHANGED OF hFieldHandle PERSISTENT RUN fieldValueChanged IN TARGET-PROCEDURE.
        ON LEAVE OF hFieldHandle PERSISTENT RUN fieldLeave IN TARGET-PROCEDURE.
    END.        
END.

/* Populate the viewer with data */
RUN rebuildViewer IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE makeObjectTTHandleStatic sObject 
PROCEDURE makeObjectTTHandleStatic :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER TABLE FOR cache_object.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateCombos sObject 
PROCEDURE populateCombos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hComboHandle AS HANDLE     NO-UNDO.

EMPTY TEMP-TABLE ttComboData.

/* Product Module */
CREATE ttComboData.
ASSIGN ttComboData.cWidgetName = "fiProductModule":U
       ttComboData.hWidget = WIDGET-HANDLE(ENTRY(LOOKUP("fiProductModule":U, gcAllFieldNames), gcAllFieldHandles))
       ttComboData.cForEach = "FOR EACH gsc_product_module NO-LOCK BY gsc_product_module.product_module_code":U
       ttComboData.cBufferList = "gsc_product_module":U
       ttComboData.cKeyFieldName = "gsc_product_module.product_module_code":U
       ttComboData.cDescFieldNames = "gsc_product_module.product_module_code,gsc_product_module.product_module_description":U
       ttComboData.cDescSubstitute = "&1 (&2)":U
       ttComboData.cCurrentKeyValue = "":U
       ttComboData.cListItemDelimiter = CHR(3)
       ttComboData.cListItemPairs = "":U
       ttComboData.cCurrentDescValue = "":U.

RUN af/app/afcobuildp.p ON gshAstraAppserver (INPUT-OUTPUT TABLE ttComboData).

FIND FIRST ttComboData.
ASSIGN ttComboData.hWidget:DELIMITER       = CHR(3)
       ttComboData.hWidget:LIST-ITEM-PAIRS = ttComboData.cListItemPairs.

/* Classes */
ASSIGN hComboHandle            = WIDGET-HANDLE(ENTRY(LOOKUP("fiClass":U, gcAllFieldNames), gcAllFieldHandles))
       hComboHandle:LIST-ITEMS = DYNAMIC-FUNCTION("getClassChildren":U IN gshRepositoryManager, INPUT "DataField").

/* Data Types */
ASSIGN hComboHandle            = WIDGET-HANDLE(ENTRY(LOOKUP("fiData-Type":U, gcAllFieldNames), gcAllFieldHandles))
       hComboHandle:LIST-ITEMS = "Character,Decimal,Integer,Date,Logical":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE propertyChangedAttribute sObject 
PROCEDURE propertyChangedAttribute :
/*------------------------------------------------------------------------------
  Purpose:     Fires when an attribute value is updated in the dynamic property sheet.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phHandle     AS HANDLE    NO-UNDO.
DEFINE INPUT  PARAMETER pcContainer  AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcObject     AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcResultCode AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcAttrLabel  AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcAttrValue  AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcDataType   AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER plLogValue   AS LOGICAL   NO-UNDO.

DEFINE VARIABLE hField     AS HANDLE     NO-UNDO.
DEFINE VARIABLE cFieldName AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iFieldCnt  AS INTEGER    NO-UNDO.

/* First thing, create a propsheet attr temp-table record */
FIND ttUpdatedPropSheetAttrs 
     WHERE ttUpdatedPropSheetAttrs.attribute_name = pcAttrLabel
     NO-ERROR.

IF NOT AVAILABLE ttUpdatedPropSheetAttrs 
THEN DO:
    CREATE ttUpdatedPropSheetAttrs.
    ASSIGN ttUpdatedPropSheetAttrs.attribute_name = pcAttrLabel
           ttUpdatedPropSheetAttrs.data_type      = pcDataType.
END.

CASE pcDataType:
    WHEN "CHARACTER":U THEN ASSIGN ttUpdatedPropSheetAttrs.character_attribute_value = pcAttrValue.
    WHEN "DECIMAL":U   THEN ASSIGN ttUpdatedPropSheetAttrs.decimal_attribute_value   = DECIMAL(pcAttrValue).
    WHEN "INTEGER":U   THEN ASSIGN ttUpdatedPropSheetAttrs.integer_attribute_value   = INTEGER(pcAttrValue).
    WHEN "LOGICAL":U   THEN ASSIGN ttUpdatedPropSheetAttrs.logical_attribute_value   = LOGICAL(pcAttrValue).
    WHEN "DATE":U      THEN ASSIGN ttUpdatedPropSheetAttrs.date_attribute_value      = DATE(pcAttrValue).
    OTHERWISE ASSIGN ttUpdatedPropSheetAttrs.character_attribute_value = pcAttrValue.
END CASE.

/* Now check if this is one of the attributes displayed on the viewer *
 * If so, update its value on the viewer.                             */
do-blk:
DO iFieldCnt = 1 TO NUM-ENTRIES(gcAllFieldNames):
    ASSIGN hField     = WIDGET-HANDLE(ENTRY(iFieldCnt, gcAllFieldHandles))
           cFieldName = ENTRY(iFieldCnt, gcAllFieldNames).

    IF SUBSTRING(cFieldName,3) = pcAttrLabel 
    THEN DO:
        FIND ttDataFieldAttr 
             WHERE ttDataFieldAttr.tRecordIdentifier = ttDataField.tRecordIdentifier
               AND ttDataFieldAttr.attr_name         = pcAttrLabel
             NO-ERROR.

        IF AVAILABLE ttDataFieldAttr THEN
            ASSIGN ttDataFieldAttr.updated_attr_value = pcAttrValue.

        ASSIGN hField:SCREEN-VALUE = pcAttrValue.
        LEAVE do-blk.
    END.
END.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE propSheetClose sObject 
PROCEDURE propSheetClose :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phPropSheet AS HANDLE     NO-UNDO.

DEFINE VARIABLE hWidget    AS HANDLE     NO-UNDO.
DEFINE VARIABLE lUpdated   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE hContainer AS HANDLE     NO-UNDO.
DEFINE VARIABLE hWindow    AS HANDLE     NO-UNDO.

ASSIGN gcOperation = "":U.

IF CAN-FIND(FIRST ttUpdatedPropSheetAttrs) 
THEN DO:    
    RUN btnModify.
    ASSIGN hWidget           = WIDGET-HANDLE(ENTRY(LOOKUP("btnReset":U, gcAllFieldNames), gcAllFieldHandles))
           hWidget:SENSITIVE = FALSE.
END.
ELSE DO:
    /* If nothing was updated, go into standard ADD,DEL,MOD */
    RUN enableAllFields IN TARGET-PROCEDURE.

    ghBrowser:SENSITIVE = YES.

    /* Make sure Save, Reset and Cancel have been disabled */
    ASSIGN hWidget           = WIDGET-HANDLE(ENTRY(LOOKUP("btnSave":U, gcAllFieldNames), gcAllFieldHandles))
           hWidget:SENSITIVE = FALSE
           hWidget           = WIDGET-HANDLE(ENTRY(LOOKUP("btnReset":U, gcAllFieldNames), gcAllFieldHandles))
           hWidget:SENSITIVE = FALSE
           hWidget           = WIDGET-HANDLE(ENTRY(LOOKUP("btnCancel":U, gcAllFieldNames), gcAllFieldHandles))
           hWidget:SENSITIVE = FALSE
           hWidget           = WIDGET-HANDLE(ENTRY(LOOKUP("btnAdd":U, gcAllFieldNames), gcAllFieldHandles))
           hWidget:SENSITIVE = gcFilterField = "":U OR
                               gcFilterField = ? /* We only enable if we're not displaying one specific field */
           hWidget           = WIDGET-HANDLE(ENTRY(LOOKUP("btnDel":U, gcAllFieldNames), gcAllFieldHandles))
           hWidget:SENSITIVE = gcFilterField = "":U OR
                               gcFilterField = ?. /* We only enable if we're not displaying one specific field */
END.

IF VALID-HANDLE(phPropSheet) 
THEN DO:
    APPLY "CLOSE":U TO phPropSheet.
    ASSIGN ghPropSheet = ?.
END.

{get ContainerSource hContainer}.
{get ContainerHandle hWindow hContainer}.
hWindow:MOVE-TO-TOP().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rebuildViewer sObject 
PROCEDURE rebuildViewer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cMessage AS CHARACTER  NO-UNDO.
DEFINE VARIABLE pcButton AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lError   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE hWidget  AS HANDLE     NO-UNDO.
DEFINE VARIABLE hFrame   AS HANDLE     NO-UNDO.

/* We need to do this mainly to prevent our field value change triggers from going wonky. */
ASSIGN glInitialising = YES.

EMPTY TEMP-TABLE ttDataField.
EMPTY TEMP-TABLE ttDataFieldAttr.
EMPTY TEMP-TABLE ttUpdatedPropSheetAttrs.
EMPTY TEMP-TABLE ttPropSheetInitialValues.

/* Determine what our container is. */
IF glSkipGetParentDetail = NO THEN
    RUN getParentInfo IN TARGET-PROCEDURE.

IF gcContainerName = ?
OR gcContainerName = "":U
THEN DO:
    {get ContainerHandle hFrame}.
    IF VALID-HANDLE(hFrame) THEN
        ASSIGN hFrame:VISIBLE = FALSE.
    RETURN.
END.

/* Build our combos */
RUN populateCombos.

/* Get the dataFields applicable to our container */
RUN createDataFieldRecs IN TARGET-PROCEDURE.
IF RETURN-VALUE = "ERROR"
THEN DO:
    ASSIGN lError = YES.
    RUN clearAllFields IN TARGET-PROCEDURE.

    IF gcContainerName <> gcStoreContainerName
    THEN DO:
        ASSIGN cMessage = "Dynamics is unable to determine which entity/object you wish to view datafields for." + CHR(10) + CHR(10)
                        + "1) If you wish to view datafields for a database entity, please ensure a repository object of class 'Entity' "
                        + "has been created with the same name as the entity you wish to view.  Datafields will be linked to this entity "
                        + "repository object." + CHR(10)
                        + "2) If you wish to view datafield instances for a container, please make sure the container specified is valid.".
        RUN dispErrMessage IN TARGET-PROCEDURE (INPUT cMessage).
    END.
END.

ASSIGN gcStoreContainerName = gcContainerName.

/* We now have our temp-tables, build our browser */
RUN buildBrowser IN TARGET-PROCEDURE.

IF lError = YES
THEN DO:
    RUN clearAllFields IN TARGET-PROCEDURE.
    RUN disableAllFields IN TARGET-PROCEDURE.
END.
ELSE DO:
    /* If we don't have a record available, disable all our fill-in fields */
    IF NOT AVAILABLE ttDataField 
    THEN DO:
        RUN clearAllFields IN TARGET-PROCEDURE.
        RUN disableAllFields IN TARGET-PROCEDURE.

        /* Enable the add button */
        ASSIGN hWidget           = WIDGET-HANDLE(ENTRY(LOOKUP("btnAdd":U, gcAllFieldNames), gcAllFieldHandles))
               hWidget:SENSITIVE = gcFilterField = "":U OR
                                   gcFilterField = "":U. /* We only enable if we're not displaying one specific field */
    END.
    ELSE DO:
        RUN enableAllFields IN TARGET-PROCEDURE.

        /* Make sure Save, Reset and Cancel have been disabled */
        ASSIGN hWidget           = WIDGET-HANDLE(ENTRY(LOOKUP("btnSave":U, gcAllFieldNames), gcAllFieldHandles))
               hWidget:SENSITIVE = FALSE
               hWidget           = WIDGET-HANDLE(ENTRY(LOOKUP("btnReset":U, gcAllFieldNames), gcAllFieldHandles))
               hWidget:SENSITIVE = FALSE
               hWidget           = WIDGET-HANDLE(ENTRY(LOOKUP("btnCancel":U, gcAllFieldNames), gcAllFieldHandles))
               hWidget:SENSITIVE = FALSE
               hWidget           = WIDGET-HANDLE(ENTRY(LOOKUP("btnAdd":U, gcAllFieldNames), gcAllFieldHandles))
               hWidget:SENSITIVE = gcFilterField = "":U OR
                                   gcFilterField = "":U /* We only enable if we're not displaying one specific field */
               hWidget           = WIDGET-HANDLE(ENTRY(LOOKUP("btnDel":U, gcAllFieldNames), gcAllFieldHandles))
               hWidget:SENSITIVE = gcFilterField = "":U OR
                                   gcFilterField = "":U. /* We only enable if we're not displaying one specific field */
    END.
END.

/* We're finished */
ASSIGN gcOperation    = "":U
       glInitialising = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject sObject 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pdHeight AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER pdWidth  AS DECIMAL    NO-UNDO.

DEFINE VARIABLE hFrame      AS HANDLE     NO-UNDO.
DEFINE VARIABLE dStoreWidth AS DECIMAL    NO-UNDO.
DEFINE VARIABLE iHandleCnt  AS INTEGER    NO-UNDO.
DEFINE VARIABLE hField      AS HANDLE     NO-UNDO.

{get containerHandle hFrame}.
    
IF pdHeight > SESSION:HEIGHT-CHARS THEN
    ASSIGN pdHeight = SESSION:HEIGHT-CHARS.

IF pdWidth > SESSION:WIDTH-CHARS THEN
    ASSIGN pdWidth = SESSION:WIDTH-CHARS.

IF NOT VALID-HANDLE(ghBrowser) 
THEN DO:
    ASSIGN gdStoreWidth  = pdWidth
           gdStoreHeight = pdHeight.
    RETURN.
END.
    
ASSIGN hFrame:VISIBLE = FALSE
       dStoreWidth    = hFrame:WIDTH
       hFrame:SCROLLABLE     = TRUE
       hFrame:VIRTUAL-HEIGHT = SESSION:HEIGHT-CHARS
       hFrame:HEIGHT         = SESSION:HEIGHT-CHARS
       hFrame:VIRTUAL-WIDTH  = SESSION:WIDTH-CHARS
       hFrame:WIDTH          = SESSION:WIDTH-CHARS
       NO-ERROR.

/* Resize.  If the browser exists, we're ready to go... */
IF VALID-HANDLE(ghBrowser) 
THEN then-blk: DO:
    ASSIGN ghBrowser:HEIGHT = pdHeight - 1.5
           ghBrowser:WIDTH  = pdWidth - 114
           NO-ERROR.

    /* Now move all the fill-in fields */    
    IF NUM-ENTRIES(gcAllFieldHandles) > 0 THEN
        do-blk:
        DO iHandleCnt = 1 TO NUM-ENTRIES(gcAllFieldHandles):
            ASSIGN hField = WIDGET-HANDLE(ENTRY(iHandleCnt, gcAllFieldHandles)) NO-ERROR.

            IF NOT VALID-HANDLE(hField) THEN
                NEXT do-blk.

            CASE hField:TYPE:
                WHEN "button":U THEN
                    ASSIGN hField:ROW = pdHeight - .1.

                WHEN "rectangle":U 
                THEN DO:
                  IF hField:NAME <> "rect-3":U THEN
                    ASSIGN hField:COLUMN = 1
                           hField:WIDTH  = 1.

                    IF hField:NAME = "rect-1":U THEN
                        ASSIGN hField:ROW = pdHeight - .2.
                    IF hField:NAME = "rect-2":U THEN
                        ASSIGN hField:ROW = pdHeight + .9.

                    IF hField:NAME = "rect-1":U OR 
                       hField:NAME = "rect-2":U THEN
                      ASSIGN hField:WIDTH  = pdWidth - 1.
                    
                    IF hField:NAME = "rect-3":U THEN
                      ASSIGN hField:ROW    = 17.38
                             hField:COLUMN = pdWidth - hField:WIDTH.

                END.

                OTHERWISE
                    ASSIGN hField:COLUMN = hField:COLUMN + (pdWidth - dStoreWidth).
            END CASE.
        END.
END.

ASSIGN hFrame:HEIGHT         = pdHeight
       hFrame:VIRTUAL-HEIGHT = pdHeight
       hframe:WIDTH          = pdWidth
       hFrame:VIRTUAL-WIDTH  = pdWidth
       hFrame:SCROLLABLE     = FALSE
       hFrame:VISIBLE        = TRUE
       ERROR-STATUS:ERROR    = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setParentInfo sObject 
PROCEDURE setParentInfo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcTableName AS CHARACTER  NO-UNDO. /* table */
DEFINE INPUT  PARAMETER pcFieldName AS CHARACTER  NO-UNDO. /* Optional - table.field */

ASSIGN glSkipGetParentDetail = YES
       gcContainerName       = pcTableName
       gcStoreContainerName  = pcTableName
       gcFilterField         = pcFieldName.

RUN rebuildViewer.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startSearch sObject 
PROCEDURE startSearch :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phBrowseHandle AS HANDLE     NO-UNDO.

DEFINE VARIABLE hQuery  AS HANDLE     NO-UNDO.
DEFINE VARIABLE hBuffer AS HANDLE     NO-UNDO.
DEFINE VARIABLE cQuery  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iIndex  AS INTEGER    NO-UNDO.
DEFINE VARIABLE rRowid  AS ROWID      NO-UNDO.

ASSIGN hQuery  = phBrowseHandle:QUERY
       hBuffer = hQuery:GET-BUFFER-HANDLE(1)
       rRowid  = IF hBuffer:AVAILABLE
                 THEN hBuffer:ROWID
                 ELSE ?
       cQuery  = phBrowseHandle:PRIVATE-DATA /* The query open statement has been stored in here */
       iIndex  = INDEX(cQuery, "BY ")
       cQuery  = SUBSTRING(cQuery, 1, iIndex - 1)
       cQuery  = cQuery + " BY " + phBrowseHandle:CURRENT-COLUMN:BUFFER-FIELD:BUFFER-HANDLE:NAME + "." + phBrowseHandle:CURRENT-COLUMN:BUFFER-FIELD:NAME.

hQuery:QUERY-CLOSE().
hQuery:QUERY-PREPARE(cQuery).
hQuery:QUERY-OPEN().

IF rRowid <> ? THEN
    hQuery:REPOSITION-TO-ROWID(rRowid).
ELSE
    hQuery:REPOSITION-TO-ROW(1).

APPLY "value-changed":U TO phBrowseHandle.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewObject sObject 
PROCEDURE viewObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  IF NUM-ENTRIES(gcAllFieldHandles) = 0 
  THEN DO:
      {get allFieldNames gcAllFieldNames}.
      {get allFieldHandles gcAllFieldHandles}.
  END.

  RUN rebuildViewer IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

