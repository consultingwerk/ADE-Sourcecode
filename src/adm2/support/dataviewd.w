&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Attribute-Dlg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Attribute-Dlg 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: datad.w 

  Description: Dialog for getting settable attributes for a SmartData.

  Input Parameters:
     p_hSMO -- Procedure Handle of calling SmartData.

  Output Parameters:
      <none>
  Modified:  February 8, 1999
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&GLOBAL-DEFINE WIN95-Btn YES
/* Starts Application Service tool if not already started 
 * The tool is used to populate the combo box with the Defined Application Service
 */
{adecomm/appserv.i}                 /* AppServer Application Service    */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p_hSMO AS HANDLE NO-UNDO.

&SCOPED-DEFINE maxsort 16
/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cValue            AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE lValue            AS LOGICAL                   NO-UNDO.
DEFINE VARIABLE cObjType          AS CHARACTER                 NO-UNDO.

DEFINE VARIABLE saveAppPartition    AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE appPartition        AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE noPartition         AS CHARACTER INIT "(None)":U NO-UNDO.
DEFINE VARIABLE Web                 AS LOGICAL                   NO-UNDO.
DEFINE VARIABLE gcPromptColumns     AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE giCacheDuration     AS INTEGER                   NO-UNDO.
DEFINE VARIABLE glHasForeignFields  AS LOGICAL                   NO-UNDO.
DEFINE VARIABLE glDynamicData       AS LOGICAL                   NO-UNDO.
DEFINE VARIABLE ghTableList         AS HANDLE     NO-UNDO.

DEFINE VARIABLE gcBeOld AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSetOld AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcTableOld AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ghSourceOld AS HANDLE     NO-UNDO.
DEFINE VARIABLE gcViewTablesOld AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcQueryOld AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glIsChild  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glDataIsFetched AS LOGICAL    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Attribute-Dlg

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS cBusinessEntity cDataSet cDataTable cSort ~
fObjectname fRowsToBatch lToggleDataTargets togPromptOnDelete radFieldList ~
lResortOnSave rRect rRectPrompt rRect-2 RECT-4 
&Scoped-Define DISPLAYED-OBJECTS cSort fObjectname fRowsToBatch ~
radFieldList lResortOnSave 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignBusinessEntity Attribute-Dlg 
FUNCTION assignBusinessEntity RETURNS LOGICAL
  ( pcNewName AS CHAR,
    pcOldName AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignDataTable Attribute-Dlg 
FUNCTION assignDataTable RETURNS LOGICAL
  ( pcNewName AS CHAR,
    pcOldName AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD cancelDataView Attribute-Dlg 
FUNCTION cancelDataView RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD deleteSort Attribute-Dlg 
FUNCTION deleteSort RETURNS LOGICAL
  ( phSortList AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD destroyTableList Attribute-Dlg 
FUNCTION destroyTableList RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD focusHandle Attribute-Dlg 
FUNCTION focusHandle RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryString Attribute-Dlg 
FUNCTION getQueryString RETURNS CHARACTER
  ( phDatasetSource AS HANDLE,
    pcTable AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSortTables Attribute-Dlg 
FUNCTION getSortTables RETURNS CHARACTER
    ( pcTable AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getViewTables Attribute-Dlg 
FUNCTION getViewTables RETURNS CHARACTER
  ( pcTable AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initDataManagement Attribute-Dlg 
FUNCTION initDataManagement RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initDataView Attribute-Dlg 
FUNCTION initDataView RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initRectangle Attribute-Dlg 
FUNCTION initRectangle RETURNS LOGICAL
  ( phRect AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initRectangles Attribute-Dlg 
FUNCTION initRectangles RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initRowsToBatch Attribute-Dlg 
FUNCTION initRowsToBatch RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initSubmitParent Attribute-Dlg 
FUNCTION initSubmitParent RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initTableList Attribute-Dlg 
FUNCTION initTableList RETURNS HANDLE
  ( pdRow AS DEC,
    pdCol AS DEC,
    pdHeight AS DEC,
    pdWidth AS DEC,
    phBefore AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD layoutRowsToBatch Attribute-Dlg 
FUNCTION layoutRowsToBatch RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD showSortOption Attribute-Dlg 
FUNCTION showSortOption RETURNS LOGICAL
  ( phSort AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD sortList Attribute-Dlg 
FUNCTION sortList RETURNS CHARACTER
  ( pcQueryString AS CHAR  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD toggleSort Attribute-Dlg 
FUNCTION toggleSort RETURNS LOGICAL
  ( phSortList AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnDisplayed 
     LABEL "&Edit display field list..." 
     SIZE 29.4 BY 1.14.

DEFINE BUTTON btnSort 
     LABEL "Edit &sort..." 
     CONTEXT-HELP-ID 0
     SIZE 11.6 BY 1.14.

DEFINE VARIABLE cDataTable AS CHARACTER FORMAT "X(32)":U 
     LABEL "&Data table" 
     CONTEXT-HELP-ID 0
     VIEW-AS COMBO-BOX 
     DROP-DOWN-LIST
     SIZE 53.8 BY 1 NO-UNDO.

DEFINE VARIABLE cBusinessEntity AS CHARACTER FORMAT "X(50)":U 
     LABEL "Business &entity" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 44.8 BY 1 NO-UNDO.

DEFINE VARIABLE cDataSet AS CHARACTER FORMAT "X(50)":U 
     LABEL "Instance name" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 44.8 BY 1 NO-UNDO.

DEFINE VARIABLE fObjectname AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Instance name" 
     VIEW-AS FILL-IN 
     SIZE 38 BY 1 NO-UNDO.

DEFINE VARIABLE fRowsToBatch AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
     LABEL "&rows" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .95 NO-UNDO.

DEFINE VARIABLE lSubmitParent AS LOGICAL 
     CONTEXT-HELP-ID 0
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Always submit parent", yes,
"Never submit parent", no
     SIZE 42 BY 1.76 NO-UNDO.

DEFINE VARIABLE radFieldList AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "&None", 1,
"&All", 2,
"Select &fields", 3
     SIZE 18 BY 2.57 NO-UNDO.

DEFINE VARIABLE raSort AS CHARACTER 
     CONTEXT-HELP-ID 0
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Ascending", "ASCENDING",
"Descending", "DESCENDING"
     SIZE 31.2 BY .86 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 53.2 BY 2.48.

DEFINE RECTANGLE rRect
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 64.8 BY 3.05
     FGCOLOR 3 .

DEFINE RECTANGLE rRect-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 53.2 BY 6.76
     FGCOLOR 3 .

DEFINE RECTANGLE rRectPrompt
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 53.2 BY 3.43.

DEFINE VARIABLE cSort AS CHARACTER 
     CONTEXT-HELP-ID 0
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 40.8 BY 2.14 NO-UNDO.

DEFINE VARIABLE lBatch AS LOGICAL INITIAL no 
     LABEL "Read data in &batches of:" 
     VIEW-AS TOGGLE-BOX
     SIZE 30.8 BY .81 TOOLTIP "Check to read data in batches" NO-UNDO.

DEFINE VARIABLE lDataIsNotFetched AS LOGICAL INITIAL no 
     LABEL "&Retrieve and keep data for single parent only" 
     VIEW-AS TOGGLE-BOX
     SIZE 48.4 BY .81 NO-UNDO.

DEFINE VARIABLE lOpenOnInit AS LOGICAL INITIAL no 
     LABEL "Open &query on initialization" 
     VIEW-AS TOGGLE-BOX
     SIZE 36.4 BY .81 NO-UNDO.

DEFINE VARIABLE lOverrideSubmitParent AS LOGICAL INITIAL no 
     LABEL "Override default submit of parent" 
     CONTEXT-HELP-ID 0
     VIEW-AS TOGGLE-BOX
     SIZE 35 BY .81 NO-UNDO.

DEFINE VARIABLE lResortOnSave AS LOGICAL INITIAL no 
     LABEL "Resort &client query on save of row" 
     VIEW-AS TOGGLE-BOX
     SIZE 48.4 BY .81 NO-UNDO.

DEFINE VARIABLE lToggleDataTargets AS LOGICAL INITIAL no 
     LABEL "Activate/deactivate Data&Targets on view/hide" 
     VIEW-AS TOGGLE-BOX
     SIZE 49.2 BY .81 NO-UNDO.

DEFINE VARIABLE RebuildOnRepos AS LOGICAL INITIAL no 
     LABEL "Rebuild resultset &on reposition" 
     VIEW-AS TOGGLE-BOX
     SIZE 33 BY .81 NO-UNDO.

DEFINE VARIABLE togPromptOnDelete AS LOGICAL INITIAL no 
     LABEL "&Prompt on delete" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Attribute-Dlg
     cBusinessEntity AT ROW 2.05 COL 18.6 COLON-ALIGNED
     cDataSet AT ROW 3.19 COL 18.6 COLON-ALIGNED
     cDataTable AT ROW 5.43 COL 12 COLON-ALIGNED
     cSort AT ROW 9.76 COL 14 NO-LABEL WIDGET-ID 2
     raSort AT ROW 12.05 COL 14.6 NO-LABEL WIDGET-ID 8
     btnSort AT ROW 9.67 COL 56.2 WIDGET-ID 4
     fObjectname AT ROW 1.57 COL 83.8 COLON-ALIGNED
     fRowsToBatch AT ROW 3.86 COL 99 COLON-ALIGNED
     lBatch AT ROW 3.95 COL 72.6
     RebuildOnRepos AT ROW 4.95 COL 72.6
     lOpenOnInit AT ROW 5.95 COL 72.6
     lDataIsNotFetched AT ROW 6.95 COL 72.6 WIDGET-ID 20
     lToggleDataTargets AT ROW 7.95 COL 72.6
     lOverrideSubmitParent AT ROW 10.38 COL 72.6 WIDGET-ID 46
     lSubmitParent AT ROW 11.29 COL 75 NO-LABEL WIDGET-ID 36
     togPromptOnDelete AT ROW 13.76 COL 73
     radFieldList AT ROW 15.95 COL 73 NO-LABEL
     btnDisplayed AT ROW 17.38 COL 92.6
     lResortOnSave AT ROW 8.95 COL 72.6 WIDGET-ID 48
     "Dataset" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 1.24 COL 5.4
     "Display fields for prompt" VIEW-AS TEXT
          SIZE 23.2 BY .62 AT ROW 15.1 COL 72.8
     "View:" VIEW-AS TEXT
          SIZE 5.8 BY .62 AT ROW 6.62 COL 8.2 WIDGET-ID 14
     "Sort by:" VIEW-AS TEXT
          SIZE 7 BY .62 AT ROW 9.76 COL 6.4 WIDGET-ID 16
     "Data management" VIEW-AS TEXT
          SIZE 19.2 BY .62 AT ROW 3 COL 72.6 WIDGET-ID 42
     rRect AT ROW 1.57 COL 3
     rRectPrompt AT ROW 15.38 COL 71
     rRect-2 AT ROW 3.29 COL 70.8 WIDGET-ID 18
     RECT-4 AT ROW 10.76 COL 70.8 WIDGET-ID 28
     SPACE(0.20) SKIP(5.57)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "DataView Properties":L.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Attribute-Dlg
   FRAME-NAME Custom                                                    */
ASSIGN 
       FRAME Attribute-Dlg:SCROLLABLE       = FALSE
       FRAME Attribute-Dlg:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON btnDisplayed IN FRAME Attribute-Dlg
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btnSort IN FRAME Attribute-Dlg
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cBusinessEntity IN FRAME Attribute-Dlg
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN cDataSet IN FRAME Attribute-Dlg
   NO-DISPLAY                                                           */
/* SETTINGS FOR COMBO-BOX cDataTable IN FRAME Attribute-Dlg
   NO-DISPLAY                                                           */
/* SETTINGS FOR TOGGLE-BOX lBatch IN FRAME Attribute-Dlg
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX lDataIsNotFetched IN FRAME Attribute-Dlg
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX lOpenOnInit IN FRAME Attribute-Dlg
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX lOverrideSubmitParent IN FRAME Attribute-Dlg
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR RADIO-SET lSubmitParent IN FRAME Attribute-Dlg
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX lToggleDataTargets IN FRAME Attribute-Dlg
   NO-DISPLAY                                                           */
/* SETTINGS FOR RADIO-SET raSort IN FRAME Attribute-Dlg
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX RebuildOnRepos IN FRAME Attribute-Dlg
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX togPromptOnDelete IN FRAME Attribute-Dlg
   NO-DISPLAY                                                           */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX Attribute-Dlg
/* Query rebuild information for DIALOG-BOX Attribute-Dlg
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX Attribute-Dlg */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Attribute-Dlg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Attribute-Dlg Attribute-Dlg
ON GO OF FRAME Attribute-Dlg /* DataView Properties */
DO:
  DEFINE VARIABLE lAnswer    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hSource    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cTables    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQuery     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyFields AS CHARACTER  NO-UNDO.

  ASSIGN 
    cBusinessEntity
    cDataset
    cDatatable
    lOverrideSubmitParent
    lSubmitParent.

  hSource = {fn getDatasetSource p_hSMO}.
  IF cBusinessEntity = '' THEN
  DO:
    MESSAGE 
      "You must specify a Business Entity for the DataView."
      VIEW-AS ALERT-BOX INFORMATION.

      APPLY "ENTRY":U TO cBusinessEntity.
      RETURN NO-APPLY.
  END. 
  IF NOT VALID-HANDLE(hSource) THEN
  DO:
      MESSAGE 
      "The specified Business Entity is not valid."
      VIEW-AS ALERT-BOX WARNING.

      APPLY "ENTRY":U TO cBusinessEntity.
      RETURN NO-APPLY.
  END. 
  IF cDataset = '':U THEN
  DO:
    lanswer = YES. 
    MESSAGE
       "Dataset instance name is blank. It will be set to '" 
        + cBusinessEntity + "' from the Business entity."  
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK-CANCEL UPDATE lanswer.
    IF lanswer THEN
      cDataset = cBusinessEntity. 
    ELSE DO:
      APPLY 'ENTRY':U TO cDataset.
      RETURN NO-APPLY.
    END.
  END.

  IF INDEX(cDataset,'(':U) > 0 THEN
  DO:
    MESSAGE "The Dataset instance name contains an invalid character: (" SKIP
            "Please enter another name."                                                                
      VIEW-AS ALERT-BOX INFORMATION.

     APPLY "ENTRY":U TO cDataset.
     RETURN NO-APPLY.
  END.
  IF cDataTable = '' THEN
  DO:
     MESSAGE 'You need to select a Data Table.':U 
       VIEW-AS ALERT-BOX INFORMATION.

      APPLY "ENTRY":U TO cDataTable.
      RETURN NO-APPLY.

  END. 

  {get KeyFields cKeyFields p_hSMO}.
  IF cKeyFields = '' THEN
  DO:
    MESSAGE "The selected DataTable has no key." SKIP
            "It must have a key defined by a unique primary index to be used in a DataView."                                                                
      VIEW-AS ALERT-BOX INFORMATION.

     APPLY "ENTRY":U TO cDataTable.
     RETURN NO-APPLY.

  END.

  DYNAMIC-FUNCTION("setObjectname":U IN p_hSMO, fObjectName:SCREEN-VALUE).
  DYNAMIC-FUNCTION("setRowsToBatch":U IN p_hSMO,INT(fRowsToBatch:SCREEN-VALUE)).
  DYNAMIC-FUNCTION("setRebuildOnRepos":U IN p_hSMO,RebuildOnRepos:CHECKED).
  
  DYNAMIC-FUNCTION("setDataIsFetched":U IN p_hSMO,
                    IF lDataIsNotFetched:CHECKED THEN FALSE 
                    ELSE IF glDataIsFetched <> FALSE THEN glDataIsFetched
                    ELSE ?).
  DYNAMIC-FUNCTION("setOpenOnInit":U IN p_hSMO,lOpenOnInit:CHECKED).
  
  DYNAMIC-FUNCTION("setSubmitParent":U IN p_hSMO,
                   IF lOverrideSubmitParent THEN lSubmitParent ELSE ?).
  
  DYNAMIC-FUNCTION("setToggleDataTargets":U IN p_hSMO,lToggleDataTargets:CHECKED).
  
  DYNAMIC-FUNCTION("setResortOnSave":U IN p_hSMO,lResortOnSave:CHECKED).

  DYNAMIC-FUNCTION("setPromptOnDelete":U IN p_hSMO,togPromptOnDelete:CHECKED).

  gcPromptColumns = (IF radFieldList = 1 THEN
                       '(NONE)':U
                     ELSE IF radFieldList = 2 THEN
                       '(ALL)':U 
                     ELSE
                       gcPromptColumns
                    ).
  DYNAMIC-FUNCTION("setPromptColumns":U IN p_hSMO,
                   gcPromptColumns).

  /* Businessentity and datatable changes are set immediately on 
     change in initDataView, just reset anyway.. 
     Tables and queryString  are blanked 
     (cancelDataView resets old values if cancel) */
  
  {fnarg setBusinessEntity cBusinessEntity p_hSMO}.
  {fnarg setDataTable cDataTable p_hSMO}.

  ASSIGN
    cQuery = getQueryString(hSource,cDataTable)
    cTables = getViewTables(cDataTable).
 
  {fn destroyView  p_hSMO}.

  {fnarg setDataQueryString cQuery p_hSMO}.
  {fnarg setTables cTables  p_hSMO}.
  {fnarg setDatasetName cDataset p_hSMO}.

  RUN createObjects IN p_hSMO.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Attribute-Dlg Attribute-Dlg
ON WINDOW-CLOSE OF FRAME Attribute-Dlg /* DataView Properties */
DO:
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnDisplayed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnDisplayed Attribute-Dlg
ON CHOOSE OF btnDisplayed IN FRAME Attribute-Dlg /* Edit display field list... */
DO:
  IF NOT VALID-HANDLE(p_hSMO) THEN RETURN.

  IF CAN-DO('(NONE),(ALL)':U, gcPromptColumns) THEN
    gcPromptColumns = '':U.

  RUN adecomm/_mfldsel.p
   (INPUT "":U,     /* Use an SDO, not db tables */
    INPUT p_hSMO,     /* handle of the SDO */
    INPUT ?,        /* No additional temp-tables */
    INPUT "1":U,    /* No db or table name qualification of fields */
    INPUT ",":U,    /* list delimiter */
    INPUT "":U,     /* exclude field list */
    INPUT-OUTPUT gcPromptColumns).
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnSort
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnSort Attribute-Dlg
ON CHOOSE OF btnSort IN FRAME Attribute-Dlg /* Edit sort... */
DO:
  IF NOT VALID-HANDLE(p_hSMO) THEN RETURN.
  
  DEFINE VARIABLE cViewTables  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSortTables  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataColumns AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iColumns     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cColumn      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cExclude     AS CHARACTER  NO-UNDO.

  {get DataColumns cDataColumns p_hsmo}.
  cSortTables = getSortTables(cDataTable).
  DO iColumns = 1 TO NUM-ENTRIES(cDataColumns):
    cColumn = ENTRY(iColumns,cDataColumns).
    IF LOOKUP(ENTRY(1,cColumn,'.'),cSortTables) = 0  THEN
      cExclude = cExclude 
               + (IF cExclude = '' THEN '' ELSE ',')
               + cColumn.

  END.
  
  /* For now we just pass the fields with descending into the picker , 
     but we remove them from the available list.. so nothing bad can happen  */
  DO iColumns = 1 TO NUM-ENTRIES(cSort:LIST-ITEMS):
    cColumn = ENTRY(iColumns,cSort:LIST-ITEMS).
    IF NUM-ENTRIES(cColumn,' ') > 1 THEN
      cExclude = cExclude 
               + (IF cExclude = '' THEN '' ELSE ',')
               + ENTRY(1,cColumn,' ').
  END.

  ASSIGN cSort = cSort:LIST-ITEMS.
  
  RUN adecomm/_mfldsel.p
   (INPUT "":U,     /* Use an SDO, not db tables */
    INPUT p_hSMO,     /* handle of the SDO */
    INPUT ?,        /* No additional temp-tables */
    INPUT "1":U,    /* No db or table name qualification of fields */
    INPUT ",":U,    /* list delimiter */
    INPUT cExclude,     /* exclude field list */
    INPUT-OUTPUT cSort).
  IF NUM-ENTRIES(cSort) > {&maxsort} THEN

  DO:
    MESSAGE 'Cannot sort on more than' {&maxsort} 'fields'
      VIEW-AS ALERT-BOX INFORMATION.   

  END.
  ELSE DO:
    cSort:LIST-ITEMS = cSort.    
    showSortOption(cSort:HANDLE).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cBusinessEntity
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cBusinessEntity Attribute-Dlg
ON LEAVE OF cBusinessEntity IN FRAME Attribute-Dlg /* Business entity */
DO:
  DEFINE VARIABLE lChanged AS LOGICAL    NO-UNDO.
  lChanged = SELF:INPUT-VALUE <> cBusinessEntity.
  assignBusinessEntity(SELF:INPUT-VALUE,cBusinessEntity).
  IF lChanged THEN
    initDataView().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cDataSet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cDataSet Attribute-Dlg
ON VALUE-CHANGED OF cDataSet IN FRAME Attribute-Dlg /* Instance name */
DO:
  ASSIGN cDataset.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cDataTable
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cDataTable Attribute-Dlg
ON VALUE-CHANGED OF cDataTable IN FRAME Attribute-Dlg /* Data table */
DO:
  assignDataTable(SELF:INPUT-VALUE,cDataTable).

  initDataView().
   
  IF glIschild THEN lBatch:CHECKED = FALSE .
  ELSE lBatch:CHECKED = TRUE.   
  initRowsToBatch().
  lDataIsNotFetched = false.
  initDataManagement().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cSort
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cSort Attribute-Dlg
ON DEFAULT-ACTION OF cSort IN FRAME Attribute-Dlg
DO:
  toggleSort(SELF).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cSort Attribute-Dlg
ON DELETE-CHARACTER OF cSort IN FRAME Attribute-Dlg
DO:
  deleteSort(SELF).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cSort Attribute-Dlg
ON VALUE-CHANGED OF cSort IN FRAME Attribute-Dlg
DO:
  showSortoption(cSort:handle).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fObjectname
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fObjectname Attribute-Dlg
ON VALUE-CHANGED OF fObjectname IN FRAME Attribute-Dlg /* Instance name */
DO:
  ASSIGN fObjectname.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fRowsToBatch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fRowsToBatch Attribute-Dlg
ON LEAVE OF fRowsToBatch IN FRAME Attribute-Dlg /* rows */
DO:
  ASSIGN fRowsTobatch.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lBatch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lBatch Attribute-Dlg
ON VALUE-CHANGED OF lBatch IN FRAME Attribute-Dlg /* Read data in batches of: */
DO:
  /* we store the currentvalue if unchecking */
  ASSIGN lBatch. /* for use when update FromSource turns on and off */
  IF NOT SELF:CHECKED THEN 
    ASSIGN fRowsToBatch.   
  initRowsToBatch().
  initDataManagement().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lDataIsNotFetched
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lDataIsNotFetched Attribute-Dlg
ON VALUE-CHANGED OF lDataIsNotFetched IN FRAME Attribute-Dlg /* Retrieve and keep data for single parent only */
DO:
  /* turn off batching and set openoninit true if unchecking retrieve
     (possibly a bit busy... could be replaced by disabling this 
      field in initDataManagement instead) */
  ASSIGN lDataIsNotFetched.
  IF NOT lDataIsNotFetched THEN 
  DO: 
    IF NOT lOpenOnInit:CHECKED THEN
      lOpenOnInit:CHECKED = TRUE.
    IF lBatch:CHECKED THEN
    DO:
      lBatch:CHECKED = FALSE.
      initRowsToBatch().
      initDataManagement().
    END.

  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lOpenOnInit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lOpenOnInit Attribute-Dlg
ON VALUE-CHANGED OF lOpenOnInit IN FRAME Attribute-Dlg /* Open query on initialization */
DO:
  initDataManagement().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lOverrideSubmitParent
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lOverrideSubmitParent Attribute-Dlg
ON VALUE-CHANGED OF lOverrideSubmitParent IN FRAME Attribute-Dlg /* Override default submit of parent */
DO:
  ASSIGN lOverrideSubmitParent.
  initSubmitParent().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME radFieldList
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL radFieldList Attribute-Dlg
ON VALUE-CHANGED OF radFieldList IN FRAME Attribute-Dlg
DO:
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      radFieldList
      btnDisplayed:SENSITIVE = (IF radFieldList = 3 THEN
                                  YES
                                ELSE
                                  NO
                                ). 



    
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME raSort
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL raSort Attribute-Dlg
ON VALUE-CHANGED OF raSort IN FRAME Attribute-Dlg
DO:
  toggleSort(cSort:HANDLE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RebuildOnRepos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RebuildOnRepos Attribute-Dlg
ON VALUE-CHANGED OF RebuildOnRepos IN FRAME Attribute-Dlg /* Rebuild resultset on reposition */
DO:
  ASSIGN RebuildOnRepos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Attribute-Dlg 


/* ************************ Standard Setup **************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Define Context ID's for HELP files */
{ src/adm2/support/admhlp.i }    

/* Attach the standard OK/Cancel/Help button bar. */
{ adecomm/okbar.i  &TOOL = "AB"
                   &CONTEXT = {&DataView_Instance_Properties_Dialog_Box} }

/* ***************************  Main Block  *************************** */
DEFINE VARIABLE hFocus AS HANDLE     NO-UNDO.
DEFINE VARIABLE lGo AS LOGICAL    NO-UNDO.
/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  initRectangles( ).   
  
  initTableList(cDataTable:ROW + 1.14,cDataTable:COL,3.0,cDataTable:WIDTH,cDataTable:HANDLE).

  /* Get the values of the attributes in the SmartObject that can be 
     changed in this dialog-box. */
  RUN get-SmO-attributes.
  /* Enable the interface. */   
  layoutRowsToBatch().
  RUN enable_UI.
  
  /* Set the cursor */
  RUN adecomm/_setcurs.p ("":U).
 
  hFocus = focusHandle().
  WAIT-FOR GO OF FRAME {&FRAME-NAME} FOCUS hFocus.  
  lGo = TRUE.
END.
IF NOT lGo THEN
  cancelDataView().
destroyTableList().
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Attribute-Dlg  _DEFAULT-DISABLE
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
  HIDE FRAME Attribute-Dlg.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Attribute-Dlg  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY cSort fObjectname fRowsToBatch radFieldList lResortOnSave 
      WITH FRAME Attribute-Dlg.
  ENABLE cBusinessEntity cDataSet cDataTable cSort fObjectname fRowsToBatch 
         lToggleDataTargets togPromptOnDelete radFieldList lResortOnSave rRect 
         rRectPrompt rRect-2 RECT-4 
      WITH FRAME Attribute-Dlg.
  VIEW FRAME Attribute-Dlg.
  {&OPEN-BROWSERS-IN-QUERY-Attribute-Dlg}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-SmO-attributes Attribute-Dlg 
PROCEDURE get-SmO-attributes :
/*------------------------------------------------------------------------------
  Purpose:     Ask the "parent" SmartObject for the attributes that can be 
               changed in this dialog.  Save some of the initial-values.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR ldummy              AS LOGICAL                   NO-UNDO.
  DEF VAR definedAppPartition AS CHARACTER                 NO-UNDO.
  DEF VAR PartitionChosen     AS CHARACTER                 NO-UNDO.
  DEF VAR cOpMode             AS CHARACTER                 NO-UNDO.
  DEFINE VARIABLE cSortList   AS CHARACTER                 NO-UNDO.
  
  DO WITH FRAME Attribute-Dlg:
    
    ASSIGN
      cBusinessEntity = {fn getBusinessEntity p_hSMO}
      cDataset    = {fn getDatasetName p_hSMO}
      cDataTable  = {fn getDataTable p_hSMO}
      gcViewTablesOld  = {fn getTables p_hSMO}
      gcQueryOld = {fn getDataQueryString p_hSMO}
      gcBeOld     = cBusinessEntity
      gcSetOld    = cDataset
      gcTableOld  = cDataTable
      ghSourceOld = {fn getDatasetSource p_hSMO}
      cSortList   = sortList(gcQueryOld).
    DISPLAY 
      cBusinessEntity
      cDataset
      cDatatable
      lSubmitParent.
    
    IF cSortList > '' THEN
     cSort:LIST-ITEMS = cSortList.
    
    /* when opened from container buider */
    IF NOT VALID-HANDLE(ghSourceOld) 
    AND cDataTable > '' THEN
    DO:
      RUN createObjects IN p_hSmo. 
      ghSourceOld = {fn getDatasetSource p_hSMO}.
    END.

   
    /********* Rows To Batch *********/
    fRowsToBatch:SCREEN-VALUE    = DYNAMIC-FUNCTION("getRowsToBatch":U IN p_hSMO).
    ASSIGN fRowsToBatch           = INTEGER(fRowsToBatch:SCREEN-VALUE)
           fRowsToBatch:SENSITIVE = TRUE
           lBatch:CHECKED         = fRowsToBatch <> 0. /* initRowsToBatch takes care of the rest*/

    /* RebuildOnRepos *******************/
    RebuildOnRepos = DYNAMIC-FUNCTION("getRebuildOnRepos":U IN p_hSMO).
    
    /* OpenOnInit *******************/
    lOpenOnInit:SCREEN-VALUE = DYNAMIC-FUNCTION("getOpenOnInit":U IN p_hSMO).
    ASSIGN lOpenOnInit:SENSITIVE = NOT (cObjType BEGINS "SmartBusinessObject":U).
    
    /* SubmitParent */
    ASSIGN
      lSubmitParent = {fn getSubmitParent p_hSMO}
      lOverrideSubmitParent:CHECKED = (lSubmitParent <> ?)
      lSubmitParent:SCREEN-VALUE = string(lSubmitParent <> FALSE) 
    . 
    /* Dataisfetched */
    ASSIGN 
      glDataIsFetched = {fn getDataIsFetched p_hSMO}
      lDataIsNotFetched = (glDataIsFetched = FALSE).

     /* ToggleDataTargets */
    ASSIGN lToggleDataTargets:CHECKED = DYNAMIC-FUNCTION("getToggleDataTargets":U IN p_hSMO).
   
        /* ResortOnSave *******************/
    ASSIGN lResortOnSave = DYNAMIC-FUNCTION("getResortOnSave":U IN p_hSMO).

    /* ObjectNeme */
    ASSIGN fObjectName = DYNAMIC-FUNCTION('getObjectName':U IN p_hSMO).
   
    /* ShareData Cacheduration (screen updated in initDataManagement) */ 
    ASSIGN
      glhasForeignFields = {fn getForeignFields p_hSMO} <> ''.
    
    initDataView().
    showSortOption(cSort:HANDLE).

    initRowsToBatch().
    initDataManagement(). 

    ASSIGN 
      lBatch = lBatch:CHECKED.

    /* prompt */
    ASSIGN
      togPromptOnDelete:CHECKED   = DYNAMIC-FUNCTION("getPromptOnDelete":U IN p_hSMO)
      gcPromptColumns             = DYNAMIC-FUNCTION("getPromptColumns":U IN p_hSMO)
      radFieldList                = (IF gcPromptColumns = '(NONE)':U THEN
                                       1
                                     ELSE IF gcPromptColumns = '(ALL)':U THEN
                                       2
                                     ELSE
                                       3
                                     )
      btnDisplayed:SENSITIVE      = (IF radFieldList = 3 THEN
                                       YES
                                     ELSE
                                       NO
                                     )
      .
  END. /* DO WITH FRAME */
END PROCEDURE. /* get-SmO-attributes */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignBusinessEntity Attribute-Dlg 
FUNCTION assignBusinessEntity RETURNS LOGICAL
  ( pcNewName AS CHAR,
    pcOldName AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF cDataset = pcOldName THEN
  DO:
    cDataset = pcNewName.
    DISP cDataset WITH FRAME {&FRAME-NAME}.
  END.
  ASSIGN cBusinessEntity = pcNewName.

  RETURN TRUE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignDataTable Attribute-Dlg 
FUNCTION assignDataTable RETURNS LOGICAL
  ( pcNewName AS CHAR,
    pcOldName AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF  fObjectName = pcOldName + 'dataview'
  OR  (fobjectname = 'dyndataview' AND pcOldname = '')  THEN
  DO:

    fObjectName = pcNewName + 'DataView'.
    DISP fObjectName WITH FRAME {&FRAME-NAME}.
  END.
  cDataTable = pcNewName.
  RETURN TRUE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION cancelDataView Attribute-Dlg 
FUNCTION cancelDataView RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: We're using the dataview directly when changing these props,
           so we must reset on cancel.  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCurrentDataset AS HANDLE     NO-UNDO.
  hCurrentDataset = {fn getDatasetSource p_hSMO}.
  /* call destroyView while datasetsource is valid to destroy buffers */
  {fn destroyView p_hSMO}.  
  IF hCurrentDataset <> ghSourceOld THEN
  DO:
    {set DatasetSource ghSourceOld p_hSMO}.
    IF VALID-HANDLE(hCurrentDataset) THEN
      RUN destroyObject IN hCurrentDataset.  
  END.
  {fnarg setBusinessEntity gcBeOld p_hSMO}.
  {fnarg setDatasetName gcSetOld p_hSMO}.
  {fnarg setDataTable gcTableOld p_hSMO}.
  {fnarg setTables gcViewTablesOld p_hSMO}.
  {fnarg setDataQueryString gcQueryOld p_hSMO}.
  RUN createObjects IN p_hSmo.
  RETURN TRUE.   
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION deleteSort Attribute-Dlg 
FUNCTION deleteSort RETURNS LOGICAL
  ( phSortList AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cList AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iItem AS INTEGER    NO-UNDO.
  cList = phSortList:LIST-ITEMS.
  iItem = phSortList:LOOKUP(phSortList:SCREEN-VALUE).
  ENTRY(iItem,clist) = ''. 
  cList = TRIM(REPLACE("," + cList + ",",",,",","),",").
  phSortList:LIST-ITEMS = clist.
  phSortList:SCREEN-VALUE = phSortList:ENTRY(MIN(iItem,phSortList:NUM-ITEMS)).
  showSortOption(phSortList).
  RETURN TRUE .

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION destroyTableList Attribute-Dlg 
FUNCTION destroyTableList RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DELETE PROCEDURE ghTableList.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION focusHandle Attribute-Dlg 
FUNCTION focusHandle RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:

    IF cBusinessentity:INPUT-VALUE = '' THEN
      RETURN cBusinessentity:HANDLE.
    ELSE IF cDataTable:INPUT-VALUE = '' THEN 
      RETURN cDataTable:HANDLE.
    ELSE
      RETURN fObjectName:HANDLE.
  END.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryString Attribute-Dlg 
FUNCTION getQueryString RETURNS CHARACTER
  ( phDatasetSource AS HANDLE,
    pcTable AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTables    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQuery     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQuerySort AS CHARACTER  NO-UNDO.
  
  cTables = getSortTables(pcTable).
  cQuery = {fnarg dataQueryString cTables phDatasetsource}.
  cSort = REPLACE(cSort:LIST-ITEMS IN FRAME {&FRAME-NAME},',',' BY ':U).
  IF cSort > '' THEN
     cQuery = cQuery + ' BY ':U + csort.
  RETURN cQuery.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSortTables Attribute-Dlg 
FUNCTION getSortTables RETURNS CHARACTER
    ( pcTable AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cItems AS CHARACTER  NO-UNDO.

  cItems = {fn getSecondItems ghTableList}.
  RETURN pcTable +  (IF cItems > '' THEN ',' + cItems ELSE '').

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getViewTables Attribute-Dlg 
FUNCTION getViewTables RETURNS CHARACTER
  ( pcTable AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cItems AS CHARACTER  NO-UNDO.

  cItems = {fn getFirstItems ghTableList}.
  RETURN pcTable +  (IF cItems > '' THEN ',' + cItems ELSE '').


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initDataManagement Attribute-Dlg 
FUNCTION initDataManagement RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: set check boxes sensitivity according to the object type   
    Notes:  
------------------------------------------------------------------------------*/
 
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN  
      lBatch:SENSITIVE              = TRUE 
      RebuildOnRepos:SENSITIVE      = lBatch:CHECKED
      RebuildOnRepos:CHECKED        = RebuildOnRepos AND lBatch:CHECKED
      lDataIsNotFetched:SENSITIVE   =  glIschild   
                                     /*  AND (lOpenOnInit:CHECKED
                                            AND NOT lBatch:CHECKED) */

      lDataIsNotFetched:CHECKED     = glIschild 
                                      AND IF NOT lDataIsNotFetched 
                                      THEN 
                                        (NOT lOpenOnInit:CHECKED
                                         OR 
                                         lBatch:CHECKED)
                                      ELSE lDataIsNotFetched
      .

  END.
  RETURN TRUE.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initDataView Attribute-Dlg 
FUNCTION initDataView RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataContainer       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDatasetSource       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cCurrentTable        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrentEntity       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cViewTables          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSortTables          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iTable               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cKeyFields           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRelatedTables       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTable               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lEntityOk            AS LOGICAL    NO-UNDO.
  
  {get DataTable cCurrentTable p_hSMO}.
  {get BusinessEntity cCurrentEntity p_hSMO}.
  
  IF cBusinessEntity <> cCurrentEntity
  OR cDatatable <> cCurrentTable  THEN
  DO:
    {fn destroyView p_hSMO}.  
    {set BusinessEntity cBusinessEntity p_hSMO}.
    {set DatasetName cDataset p_hSMO}.
    
    IF cDatatable <> cCurrentTable THEN 
      {set DataTable cDataTable p_hSMO}.
    ELSE 
      {set DataTable '' p_hSMO}.

    /* make viewtables return default */
    {set Tables '' p_hSMO}.
    {set DataQueryString '' p_hSMO}.
    lEntityOk = {fn addDatasetSource p_hSMO}.
    
    DO WITH FRAME {&FRAME-NAME}:
      IF radFieldList = 3 THEN
      DO:
        IF {fn getUseRepository p_hSMO} THEN 
           radFieldList = 2.
        ELSE
          radFieldList = 1.
        gcPromptColumns = ''.
        DISPLAY radFieldList.
      END.
    END.
    IF lEntityOk THEN
    DO:
      RUN createObjects IN p_hSmo.
  
      {get KeyFields cKeyFields p_hSMO}.
    END.
    IF cKeyFields > '' THEN
    DO:
      cSort:LIST-ITEMS = cDataTable + '.' + ENTRY(1,cKeyFields).
      btnSort:SENSITIVE = TRUE.
    END.
    ELSE 
      cSort:LIST-ITEMS = ''.
    showSortOption(cSort:HANDLE).
  END.

  {get DatasetSource hDatasetSource p_hSMO}.

  /* if changed or initial display  */
  IF cBusinessEntity <> cCurrentEntity OR cDataTable:LIST-ITEMS = ? THEN
  DO:
    IF lEntityOk THEN
    DO:
      {get DatasetSource hDatasetSource p_hSMO}.
      /* container builder ..*/
      IF cDataTable:LIST-ITEMS = ? AND NOT VALID-HANDLE(hDatasetSource) THEN
      DO:
        RUN createObjects IN p_hSmo.
        {get DatasetSource hDatasetSource p_hSMO}.
      END.
    END.

    IF VALID-HANDLE(hDatasetSource) THEN
    DO WITH FRAME {&FRAME-NAME}:
      cDataTable:LIST-ITEMS = {fn getDataTables hDatasetSource}.
      cDataTable:INNER-LINES = min(10,cDataTable:num-ITEMS).
      btnDisplayed:SENSITIVE = radFieldList = 3.
    END.
    ELSE DO:
      cDataTable:LIST-ITEMS = ?.
      cDataTable:INNER-LINES = 1.
      btnDisplayed:SENSITIVE = NO.
    END.
  END.
 
  {fn deleteItems ghTableList}.
  IF VALID-HANDLE(hDatasetSource) AND cDataTable > '' THEN
  DO:
    glIsChild      = {fnarg isChild cDataTable hDatasetSource}.
    cRelatedTables = {fnarg viewTables cDataTable hDatasetSource}.
    cViewTables    = {fn getViewTables p_hSMO}.
    cSortTables    = {fn getQueryTables p_hSMO}.
    DO iTable = 2 TO NUM-ENTRIES(cRelatedTables):
      cTable = ENTRY(iTable,cRelatedTables).
      DYNAMIC-FUNCTION('addItem' IN ghTableList,
                        cTable,
                        LOOKUP(cTable,cViewTables) > 0,
                        LOOKUP(cTable,cSortTables) > 0).
    END.
    {fn viewItems ghTableList}.
  END.

  ASSIGN 
    lOverrideSubmitParent:SENSITIVE = (glIsChild = TRUE).
  
  initSubmitParent().
  RETURN VALID-HANDLE(hDatasetSource) . 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initRectangle Attribute-Dlg 
FUNCTION initRectangle RETURNS LOGICAL
  ( phRect AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose: convert rect to XP look..  
    Notes:  
------------------------------------------------------------------------------*/
  
  IF SESSION:window-system = 'ms-winxp' THEN
    ASSIGN
      phRect:EDGE-PIXELS = 1
      phRect:GROUP-BOX = TRUE.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initRectangles Attribute-Dlg 
FUNCTION initRectangles RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hWidget AS HANDLE     NO-UNDO.
  hWidget = FRAME {&frame-name}:FIRST-CHILD:FIRST-CHILD.
  DO WHILE VALID-HANDLE(hWidget):
    IF hWidget:TYPE = 'RECTANGLE' THEN
      initRectangle(hWidget).
    hWidget = hWidget:NEXT-SIBLING.
  END.

  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initRowsToBatch Attribute-Dlg 
FUNCTION initRowsToBatch RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: UI adjustments for RowsToBatch 
    Notes: lbatch is set checked if RowsToBatch <> 0 at startup.
           and this is also called from the trigger     
------------------------------------------------------------------------------*/
 DO WITH FRAME {&FRAME-NAME}:
   IF lBatch:CHECKED THEN
   DO:
     ASSIGN 
       fRowsToBatch:READ-ONLY    = FALSE
       fRowsToBatch:TAB-STOP     = TRUE  
       fRowsTOBatch:FORMAT       = ">>>>>>>9"
       fRowsToBatch:SCREEN-VALUE = IF fRowsToBatch <> 0 
                                   THEN STRING(fRowsTOBatch)
                                   ELSE STRING(200) /* ?? */
       .
         
     fRowsToBatch:MOVE-AFTER(lBatch:HANDLE).
   END. /* checked*/
   ELSE DO:
     ASSIGN 
       fRowsToBatch:READ-ONLY    = TRUE
       fRowsToBatch:TAB-STOP     = FALSE 
       fRowsToBatch:SCREEN-VALUE = STRING(0)
       fRowsTOBatch:FORMAT       = "ZZZZZZZ"
       .
   END. /* unchecked */
 END.
 RETURN TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initSubmitParent Attribute-Dlg 
FUNCTION initSubmitParent RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: set submit from override    
    Notes:  
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
   lSubmitParent:SENSITIVE = lOverrideSubmitParent:SENSITIVE 
                             AND lOverrideSubmitParent:CHECKED.  

  END.
  RETURN TRUE.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initTableList Attribute-Dlg 
FUNCTION initTableList RETURNS HANDLE
  ( pdRow AS DEC,
    pdCol AS DEC,
    pdHeight AS DEC,
    pdWidth AS DEC,
    phBefore AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose: View and/or clear the widgets used to update dataobjects for an sbo 
   Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hFrame AS HANDLE NO-UNDO.

  IF NOT VALID-HANDLE(ghTableList)  THEN
  DO:
    RUN adm2/support/toggleframe.w PERSISTENT SET ghTableList.
    hFrame = FRAME {&FRAME-NAME}:HANDLE.
    {fnarg setFrame hframe ghTableList}.
    {fnarg setBeforeTab phBefore ghTableList}.
    {fnarg setRow pdRow ghTableList}.
    {fnarg setCol pdCol ghTableList}.
    {fnarg setHeight pdHeight ghTableList}.
    {fnarg setWidth pdWidth ghTableList}.
    {fnarg setTextWidth 30 ghTableList}.
    {fnarg set3D TRUE ghTableList}.
    {fnarg setFirstLabel 'View' ghTableList}.
    {fnarg setSecondLabel 'Join' ghTableList}.
    RUN initializeObject IN ghTableList.  
  END.

  
  RETURN ghTableList.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION layoutRowsToBatch Attribute-Dlg 
FUNCTION layoutRowsToBatch RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRowsLabel AS HANDLE     NO-UNDO.
  DO WITH FRAME {&FRAME-NAME}:
     VIEW. /* The algorithm for adjusting the label requires realized widgets. */
    ASSIGN
      /* Move the label AFTER the field */  
      hRowsLabel                    = fRowsToBatch:SIDE-LABEL-HANDLE
      hRowsLabel:COL                = fRowsToBatch:COL + fRowsToBatch:WIDTH + 0.5
      /* and remove the colon */
      hRowsLabel:WIDTH              = FONT-TABLE:GET-TEXT-WIDTH-CHARS
                                                  (SUBSTR(hRowsLabel:SCREEN-VALUE,
                                                          1,
                                                          LENGTH(hRowsLabel:SCREEN-VALUE) - 1)) 
      lBatch:WIDTH =  fRowsToBatch:COL - lBatch:COL  
      .
  END.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION showSortOption Attribute-Dlg 
FUNCTION showSortOption RETURNS LOGICAL
  ( phSort AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER  NO-UNDO.
  DO WITH FRAME {&FRAME-NAME}:
    cValue = phSort:SCREEN-VALUE.
    IF cValue > '' THEN
    DO:
      IF num-entries(cValue,' ') > 1 THEN
        raSort:SCREEN-VALUE = ENTRY(2,cValue,' ').
      ELSE 
        rasort:SCREEN-VALUE = 'ASCENDING'.
      ASSIGN
        btnSort:SENSITIVE = TRUE 
        raSort:SENSITIVE = TRUE .
    END.
    ELSE
      ASSIGN
        btnSort:SENSITIVE = IF phSort:LIST-ITEMS > '' THEN TRUE ELSE FALSE
        raSort:SENSITIVE = FALSE
        rasort:SCREEN-VALUE = 'ASCENDING'.
  END.

  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION sortList Attribute-Dlg 
FUNCTION sortList RETURNS CHARACTER
  ( pcQueryString AS CHAR  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  /* Use the dataview's sortExpression function  */
  RETURN TRIM(REPLACE(' ' + {fnarg sortExpression pcQueryString p_hSMo},' BY ',','),',').
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION toggleSort Attribute-Dlg 
FUNCTION toggleSort RETURNS LOGICAL
  ( phSortList AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cList AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iItem AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cEntry AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lDesc AS LOGICAL    NO-UNDO.
  IF phSortList:SCREEN-VALUE > '' THEN
  DO:
    cList = phSortList:LIST-ITEMS.
    iItem = phSortList:LOOKUP(phSortList:SCREEN-VALUE).
    cEntry = ENTRY(iItem,clist).
    lDesc = NUM-ENTRIES(cEntry,' ') > 1.
    cEntry = ENTRY(1,cEntry,' ').
    ENTRY(iItem,clist) = cEntry + IF lDesc THEN '' ELSE 
                           ' DESCENDING'. 
    phSortList:LIST-ITEMS = clist.
    phSortList:SCREEN-VALUE = phSortList:ENTRY(iItem).
    showSortOption(phSortList).
  END.

  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

