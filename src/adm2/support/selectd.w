&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME frmAttributes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS frmAttributes 
/***********************************************************************
* Copyright (C) 2005,2008 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*------------------------------------------------------------------------

  File: statusd.w 

  Description: Instance Attributes Dialog for SmartStatus.
               
               The main strategy in this procedure is that all widgets uses the                
               the actual AppBuilder variables.  
               - Values are ASSIGNED on value-changed.                 
                 This means that some values are ASSIGNED on value-changed of 
                 other fields.                 
                  
               The initialization of sensitivity,read-only is divided into 
               several functions in order to not duplicate start-up and 
               value-changed logic.             
               - None of these functions call each other.  
                 This means some value-changed triggers must call several
                 functions. 
                  
               initSDO    - contains SDO dependent objects
               initViewAs - contains ViewAs dependent objects
               initField  - contains changes depending on displayedfields
                            Is called from several valuechanged triggers 
               initOption - Only optionString logic dependin on option toggle                                              
               initGeometry - Height settings depending on 
                              view-as and view-as option 
        
        NOTE: The browsefields button is set in both initSDO and initViewAs.
                               
  Input Parameters:
     p_hSMO -- Procedure Handle of calling SmartObject.

  Output Parameters:
      <none>
          
          
     Modifed:  18 July, 2000
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p_hSMO  AS HANDLE NO-UNDO.

DEFINE VARIABLE ghFuncLib      AS HANDLE NO-UNDO. 
DEFINE VARIABLE ghSDO          AS HANDLE NO-UNDO.
DEFINE VARIABLE cSDO           AS CHAR   NO-UNDO.
DEFINE VARIABLE lAnswer        AS LOG    NO-UNDO.

DEFINE VARIABLE gcBrowseFields AS CHAR   NO-UNDO.

DEFINE VARIABLE xcNoDataTypes AS CHARACTER  NO-UNDO
    INIT 'clob,blob':U.

/* non supported data-types/view-as really added for datetime/-tz
  (blob,clob,raw should really have been checked everywhere .... ) */
DEFINE VARIABLE xcNoListDataTypes AS CHARACTER  NO-UNDO
     INIT 'datetime,datetime-tz,blob,clob,raw':U.
DEFINE VARIABLE xcNoListViewAs AS CHARACTER  NO-UNDO
     INIT 'combo-box':U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME frmAttributes

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS cChangedEvent lEnable lDisplay lSort cViewAs ~
cDataObject iNumRows cLabel cBrowseTitle cToolTip iHelpId cField dWidth ~
dColumn cDatatype dHeight dRow cFormat cBrowseKeys RECT-15 RECT-16 RECT-18 
&Scoped-Define DISPLAYED-OBJECTS cKeyField cDisplayedField cChangedEvent ~
lEnable lDisplay lSort lExitBrowse lCancelBrowse lOptional cOptionalString ~
cViewAs cDataObject iNumRows cLabel lLabelDataSource cBrowseTitle cToolTip ~
iHelpId cField dWidth dColumn cDatatype dHeight dRow lAnyKey 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFuncLibHandle frmAttributes 
FUNCTION getFuncLibHandle RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initField frmAttributes 
FUNCTION initField RETURNS LOGICAL
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initGeometry frmAttributes 
FUNCTION initGeometry RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initKey frmAttributes 
FUNCTION initKey RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initOptional frmAttributes 
FUNCTION initOptional RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initSDO frmAttributes 
FUNCTION initSDO RETURNS LOGICAL
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initTheme frmAttributes 
FUNCTION initTheme RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initViewAs frmAttributes 
FUNCTION initViewAs RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.
  
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD removeLOBFields Procedure
FUNCTION removeLOBFields RETURNS CHARACTER 
	(INPUT cAllColumns AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD validateBrowseFields frmAttributes 
FUNCTION validateBrowseFields RETURNS LOGICAL
  (  )  FORWARD.
 
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnBrowse 
     LABEL "&Edit Browse Columns..." 
     SIZE 34 BY 1.1.

DEFINE BUTTON btnInst 
     LABEL "Instance &Properties..." 
     SIZE 34 BY 1.1.

DEFINE BUTTON btnKey 
     LABEL "Ke&y..." 
     SIZE 10 BY 1.1.

DEFINE VARIABLE cDisplayedField AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Displayed Field" 
     VIEW-AS COMBO-BOX 
     DROP-DOWN-LIST
     SIZE 34 BY 1 NO-UNDO.

DEFINE VARIABLE cKeyField AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Key Field" 
     VIEW-AS COMBO-BOX 
     DROP-DOWN-LIST
     SIZE 34 BY 1 NO-UNDO.

DEFINE VARIABLE cViewAs AS CHARACTER FORMAT "X(256)":U 
     LABEL "&View as" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Browser","Browser",
                     "Combo-box","Combo-box",
                     "Selection-list","Selection-list",
                     "Radio-set","Radio-set"
     DROP-DOWN-LIST
     SIZE 26 BY 1 NO-UNDO.

DEFINE VARIABLE cBrowseKeys AS CHARACTER FORMAT "X(256)":U 
     LABEL "Bro&wse Keys" 
     VIEW-AS FILL-IN 
     SIZE 41.8 BY 1 NO-UNDO.

DEFINE VARIABLE cBrowseTitle AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Browse Title" 
     VIEW-AS FILL-IN 
     SIZE 53 BY 1 NO-UNDO.

DEFINE VARIABLE cChangedEvent AS CHARACTER FORMAT "X(256)":U 
     LABEL "Event on chan&ge" 
     VIEW-AS FILL-IN 
     SIZE 34 BY 1 NO-UNDO.

DEFINE VARIABLE cDataObject AS CHARACTER FORMAT "X(256)":U 
     LABEL "SmartDataObject" 
     VIEW-AS FILL-IN 
     SIZE 34 BY 1 NO-UNDO.

DEFINE VARIABLE cDataSourceFilter AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Filter" 
     VIEW-AS FILL-IN 
     SIZE 34 BY 1 NO-UNDO.

DEFINE VARIABLE cDatatype AS CHARACTER FORMAT "X(256)":U 
     LABEL "Datatype" 
     VIEW-AS FILL-IN 
     SIZE 19.6 BY 1 NO-UNDO.

DEFINE VARIABLE cField AS CHARACTER FORMAT "X(256)":U 
     LABEL "External Field" 
     VIEW-AS FILL-IN 
     SIZE 34 BY 1 NO-UNDO.

DEFINE VARIABLE cFormat AS CHARACTER FORMAT "X(256)":U 
     LABEL "For&mat" 
     VIEW-AS FILL-IN 
     SIZE 19.6 BY 1 NO-UNDO.

DEFINE VARIABLE cLabel AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Label" 
     VIEW-AS FILL-IN 
     SIZE 34 BY 1 NO-UNDO.

DEFINE VARIABLE cOptionalString AS CHARACTER FORMAT "X(256)":U 
     LABEL "Optional Val&ue" 
     VIEW-AS FILL-IN 
     SIZE 34 BY 1 NO-UNDO.

DEFINE VARIABLE cToolTip AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Tooltip" 
     VIEW-AS FILL-IN 
     SIZE 52.8 BY 1 NO-UNDO.

DEFINE VARIABLE dColumn AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "&Column" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE dHeight AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "&Height" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE dRow AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "&Row" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE dWidth AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "&Width" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE iHelpId AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "&Help ID" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE iNumRows AS INTEGER FORMAT ">>":U INITIAL 0 
     LABEL "&Inner Lines" 
     VIEW-AS FILL-IN 
     SIZE 5.8 BY 1 NO-UNDO.

DEFINE VARIABLE cViewAsOption AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Item 1", "1"
     SIZE 23 BY 2.38 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 56 BY 4.29.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 70 BY 3.05.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 70 BY 7.81.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 56 BY 3.05.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 56 BY 6.67.

DEFINE RECTANGLE rectOptional
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 56 BY 2.14.

DEFINE RECTANGLE rectOptional-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 70 BY 2.14.

DEFINE RECTANGLE rView
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 70 BY 3.1.

DEFINE VARIABLE lAnyKey AS LOGICAL INITIAL no 
     LABEL "Define &Any Key Trigger on Field" 
     VIEW-AS TOGGLE-BOX
     SIZE 35.6 BY .71 NO-UNDO.

DEFINE VARIABLE lCancelBrowse AS LOGICAL INITIAL no 
     LABEL "Cancel on Exit of Browse" 
     VIEW-AS TOGGLE-BOX
     SIZE 35 BY .71 NO-UNDO.

DEFINE VARIABLE lDisplay AS LOGICAL INITIAL no 
     LABEL "Display" 
     VIEW-AS TOGGLE-BOX
     SIZE 12 BY .71 NO-UNDO.

DEFINE VARIABLE lEnable AS LOGICAL INITIAL no 
     LABEL "Enable" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .71 NO-UNDO.

DEFINE VARIABLE lExitBrowse AS LOGICAL INITIAL no 
     LABEL "Exit Browse on Default Action" 
     VIEW-AS TOGGLE-BOX
     SIZE 35 BY .71 NO-UNDO.

DEFINE VARIABLE lFormatDataSource AS LOGICAL INITIAL no 
     LABEL "Data Source" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .81 NO-UNDO.

DEFINE VARIABLE lLabelDataSource AS LOGICAL INITIAL no 
     LABEL "Data Source" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .81 NO-UNDO.

DEFINE VARIABLE lOptional AS LOGICAL INITIAL no 
     LABEL "&Optional" 
     VIEW-AS TOGGLE-BOX
     SIZE 12.6 BY .71 NO-UNDO.

DEFINE VARIABLE lRepositionDataSource AS LOGICAL INITIAL no 
     LABEL "Reposition Data Source" 
     VIEW-AS TOGGLE-BOX
     SIZE 33 BY .71 NO-UNDO.

DEFINE VARIABLE lSort AS LOGICAL INITIAL no 
     LABEL "Sort" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .71 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frmAttributes
     cDataSourceFilter AT ROW 3.24 COL 20 COLON-ALIGNED
     btnInst AT ROW 4.43 COL 22
     cKeyField AT ROW 7.95 COL 20 COLON-ALIGNED
     cDisplayedField AT ROW 9.14 COL 20 COLON-ALIGNED
     cChangedEvent AT ROW 10.29 COL 20 COLON-ALIGNED
     btnBrowse AT ROW 11.52 COL 22.2
     lEnable AT ROW 13.91 COL 4.4
     lDisplay AT ROW 14.71 COL 4.4
     lSort AT ROW 15.52 COL 4.4
     lExitBrowse AT ROW 13.91 COL 22
     lCancelBrowse AT ROW 14.71 COL 22
     lRepositionDataSource AT ROW 15.52 COL 22
     lOptional AT ROW 16.67 COL 4.4
     cOptionalString AT ROW 17.67 COL 20 COLON-ALIGNED
     cViewAs AT ROW 2 COL 73.2 COLON-ALIGNED
     cDataObject AT ROW 2 COL 20 COLON-ALIGNED NO-TAB-STOP 
     cViewAsOption AT ROW 2 COL 104 NO-LABEL
     iNumRows AT ROW 3.24 COL 73 COLON-ALIGNED
     cLabel AT ROW 5.62 COL 73.2 COLON-ALIGNED
     lLabelDataSource AT ROW 5.67 COL 111.2
     cBrowseTitle AT ROW 6.76 COL 73 COLON-ALIGNED
     lFormatDataSource AT ROW 9.19 COL 111
     cToolTip AT ROW 10.33 COL 73 COLON-ALIGNED
     iHelpId AT ROW 11.52 COL 73 COLON-ALIGNED
     cField AT ROW 6.76 COL 8.2 NO-TAB-STOP 
     dWidth AT ROW 13.95 COL 73.2 COLON-ALIGNED
     dColumn AT ROW 13.95 COL 97.6 COLON-ALIGNED
     cDatatype AT ROW 7.95 COL 73 COLON-ALIGNED NO-TAB-STOP 
     dHeight AT ROW 15.14 COL 73.2 COLON-ALIGNED
     dRow AT ROW 15.14 COL 97.6 COLON-ALIGNED
     lAnyKey AT ROW 16.71 COL 62.4
     cFormat AT ROW 9.14 COL 73 COLON-ALIGNED
     cBrowseKeys AT ROW 17.67 COL 73.2 COLON-ALIGNED
     btnKey AT ROW 17.67 COL 118
     "Geometry" VIEW-AS TEXT
          SIZE 11 BY .62 AT ROW 13.14 COL 62.4
     "Data" VIEW-AS TEXT
          SIZE 6 BY .62 AT ROW 5.95 COL 4.2
     "Properties" VIEW-AS TEXT
          SIZE 11 BY .62 AT ROW 13.14 COL 4.4
     "Data Source" VIEW-AS TEXT
          SIZE 13 BY .62 AT ROW 1.19 COL 4.4
     "Visualization" VIEW-AS TEXT
          SIZE 13.4 BY .62 AT ROW 1.19 COL 62.4
     "Field Attributes" VIEW-AS TEXT
          SIZE 15.6 BY .62 AT ROW 4.81 COL 62.4
     RECT-12 AT ROW 1.48 COL 2
     RECT-13 AT ROW 13.43 COL 60
     rectOptional AT ROW 16.95 COL 2
     rectOptional-2 AT ROW 16.95 COL 60.2
     rView AT ROW 1.48 COL 60
     RECT-15 AT ROW 5.1 COL 60
     RECT-16 AT ROW 13.43 COL 2
     RECT-18 AT ROW 6.24 COL 2
     SPACE(72.39) SKIP(6.89)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "SmartSelect Properties":L.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX frmAttributes
   FRAME-NAME Custom                                                    */
ASSIGN 
       FRAME frmAttributes:SCROLLABLE       = FALSE
       FRAME frmAttributes:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON btnBrowse IN FRAME frmAttributes
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btnInst IN FRAME frmAttributes
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btnKey IN FRAME frmAttributes
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cBrowseKeys IN FRAME frmAttributes
   NO-DISPLAY                                                           */
ASSIGN 
       cDataObject:READ-ONLY IN FRAME frmAttributes        = TRUE.

/* SETTINGS FOR FILL-IN cDataSourceFilter IN FRAME frmAttributes
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       cDatatype:READ-ONLY IN FRAME frmAttributes        = TRUE.

/* SETTINGS FOR COMBO-BOX cDisplayedField IN FRAME frmAttributes
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cField IN FRAME frmAttributes
   ALIGN-L                                                              */
ASSIGN 
       cField:READ-ONLY IN FRAME frmAttributes        = TRUE.

/* SETTINGS FOR FILL-IN cFormat IN FRAME frmAttributes
   NO-DISPLAY                                                           */
/* SETTINGS FOR COMBO-BOX cKeyField IN FRAME frmAttributes
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cOptionalString IN FRAME frmAttributes
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET cViewAsOption IN FRAME frmAttributes
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       cViewAsOption:HIDDEN IN FRAME frmAttributes           = TRUE.

/* SETTINGS FOR TOGGLE-BOX lAnyKey IN FRAME frmAttributes
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX lCancelBrowse IN FRAME frmAttributes
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX lExitBrowse IN FRAME frmAttributes
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX lFormatDataSource IN FRAME frmAttributes
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX lLabelDataSource IN FRAME frmAttributes
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX lOptional IN FRAME frmAttributes
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX lRepositionDataSource IN FRAME frmAttributes
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR RECTANGLE RECT-12 IN FRAME frmAttributes
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-13 IN FRAME frmAttributes
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rectOptional IN FRAME frmAttributes
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rectOptional-2 IN FRAME frmAttributes
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rView IN FRAME frmAttributes
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX frmAttributes
/* Query rebuild information for DIALOG-BOX frmAttributes
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX frmAttributes */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME frmAttributes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL frmAttributes frmAttributes
ON GO OF FRAME frmAttributes /* SmartSelect Properties */
DO:     
   DEFINE VARIABLE hFrame       AS HANDLE NO-UNDO.
   DEFINE VARIABLE cDataColumns AS CHAR NO-UNDO.

   /* The SDO was valid when the user entered this dialog so ..??.  */
   ASSIGN 
      cDataObject
      cDataSourceFilter
      
      cViewAs
      cViewAsOption 

      cKeyField
      cDisplayedField
      cChangedEvent
      lSort
      lEnable
      lDisplay

      lExitBrowse
      lCancelBrowse
      lRepositionDataSource
      
      lOptional
      cOptionalString
    /* lOptionalUnknown  */
      
      iNumRows     
      
      cLabel 
      lLabelDataSource
      cLabel = IF lLabelDataSource THEN '?':U ELSE cLabel
      
      cBrowseTitle
      
      cFormat 
      lFormatDataSource
      cFormat = IF lFormatDataSource THEN '?':U ELSE cFormat
      
      cToolTip
      iHelpId
      
      dColumn
      dRow
      dWidth
      dHeight
          
      lAnyKey
      cBrowseKeys
        
      cDataType.
  
  IF VALId-HANDLE(ghSDO) THEN
  DO:    
    cDataColumns = DYNAMIC-FUNC("getDataColumns":U IN ghSDO).
    
    IF cDisplayedField = "":U 
    OR NOT CAN-DO(cDataColumns,cDisplayedField) THEN 
    DO:
       MESSAGE 
       "Displayed Field must be a field in the data-source."
       VIEW-AS ALERT-BOX INFORMATION.

       APPLY "ENTRY":U TO cDisplayedField.
       RETURN NO-APPLY.
    END. /* not valid displayedfield */
  
    IF cKeyField = "":U THEN 
      cKeyField = cDisplayedField. 
  
    IF NOT CAN-DO(cDataColumns,cKeyField) THEN 
    DO:
      MESSAGE 
        "The Key Field must be field in the data-source."
      VIEW-AS ALERT-BOX INFORMATION.

      APPLY "ENTRY":U TO cKeyField.
      RETURN NO-APPLY.
    END. /* not valid keyfield */
    
    IF NOT {fnarg instanceOf 'DataView':U ghSDO} 
    AND LOOKUP(cKeyField,{fn getCalculatedColumns ghSDO}) > 0 THEN
    DO:    
      MESSAGE 
        "The Key Field must be a field that are mapped to a database field." SKIP
        "Calculated fields are currently not supported as Key Fields."
       VIEW-AS ALERT-BOX INFORMATION.

      APPLY "ENTRY":U TO cKeyField.
      RETURN NO-APPLY.
    END.
    
    IF CAN-DO(xcNoListDataTypes,cDataType) AND CAN-DO(xcNoListViewAs,cViewAs) THEN
    DO:
      MESSAGE 
      "The Key Field's " + cdataType + " datatype is not valid in a " + cViewAs + " object." 
      VIEW-AS ALERT-BOX INFORMATION.
      APPLY "ENTRY":U TO cKeyField.
      RETURN NO-APPLY.
    END.

    IF cViewAs = "Browser":U AND NOT validateBrowseFields() THEN 
      RETURN NO-APPLY.

    gcBrowseFields = IF cViewAs <> "Browser":U 
                     THEN "":U
                     ELSE (IF gcBrowseFields = "":U 
                           OR gcBrowseFields = cKeyField 
                           THEN (IF cKeyField <> cDisplayedField 
                                 THEN cDisplayedField + ",":U 
                                 ELSE "":U) + cKeyField                                
                           ELSE gcBrowseFields).
  END. /* valid ghSdo */

  ASSIGN 
    cViewAs = cViewAS + IF cViewAsOption <> "" 
                        THEN ":":U + cViewAsOption
                        ELSE "":U.

  DYNAMIC-FUNCTION("setDataSourceFilter":U  IN p_hSMO, cDataSourceFilter).
  DYNAMIC-FUNCTION("setDisplayedField":U    IN p_hSMO, cDisplayedField).
  DYNAMIC-FUNCTION("setKeyField":U          IN p_hSMO, cKeyField).
  DYNAMIC-FUNCTION("setBrowseFields":U      IN p_hSMO, gcBrowseFields).
  
  DYNAMIC-FUNCTION("setOptional":U          IN p_hSMO, lOptional).
  DYNAMIC-FUNCTION("setOptionalString":U    IN p_hSMO, cOptionalString).

  DYNAMIC-FUNCTION("setLabel":U             IN p_hSMO, cLabel).
  DYNAMIC-FUNCTION("setFormat":U            IN p_hSMO, cFormat).
  DYNAMIC-FUNCTION("setHelpId":U            IN p_hSMO, iHelpId).
  DYNAMIC-FUNCTION("setToolTip":U           IN p_hSMO, cToolTip).
  
  DYNAMIC-FUNCTION("setChangedEvent":U      IN p_hSMO, cChangedEvent).
  
  DYNAMIC-FUNCTION("setViewAs":U            IN p_hSMO, cViewAs).
  DYNAMIC-FUNCTION("setNumRows":U           IN p_hSMO, iNumRows).
  
  DYNAMIC-FUNCTION("setBrowseTitle":U       IN p_hSMO, cBrowseTitle).
  
  DYNAMIC-FUNCTION("setSort":U               IN p_hSMO, lSort).
  DYNAMIC-FUNCTION("setEnableField":U        IN p_hSMO, lEnable).
  DYNAMIC-FUNCTION("setDisplayField":U       IN p_hSMO, lDisplay).
  DYNAMIC-FUNCTION("setExitBrowseOnAction":U IN p_hSMO, lExitBrowse).
  DYNAMIC-FUNCTION("setCancelBrowseOnExit":U IN p_hSMO, lCancelBrowse). 
  DYNAMIC-FUNCTION("setRepositionDataSource":U  IN p_hSMO, lRepositionDataSource). 
  
  DYNAMIC-FUNCTION("setDefineAnyKeyTrigger":U IN p_hSMO, lAnyKey).  
  DYNAMIC-FUNC("setStartBrowseKeys":U IN p_hSMO, cBrowseKeys). 

  RUN repositionObject IN p_hSMO(dRow, dColumn).
  
  ASSIGN
    hFrame        = DYNAMIC-FUNCTION("getContainerHandle" IN p_hSMO)
    hFrame:HEIGHT = dHeight
    hFrame:WIDTH  = dWidth NO-ERROR.  
  
  /* Notify AppBuilder that size or position values has changed.
     The AB will run resizeObject which will run initializeObject */
  APPLY "END-RESIZE" TO hFrame.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL frmAttributes frmAttributes
ON WINDOW-CLOSE OF FRAME frmAttributes /* SmartSelect Properties */
DO:
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnBrowse frmAttributes
ON CHOOSE OF btnBrowse IN FRAME frmAttributes /* Edit Browse Columns... */
DO:
  DEFINE VARIABLE cLOBColumns AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cAllColumns AS CHARACTER NO-UNDO.
  DEFINE VARIABLE i           AS INTEGER NO-UNDO.
  DEFINE VARIABLE cColumn     AS CHARACTER NO-UNDO.

  cAllColumns = DYNAMIC-FUNC("getDataColumns":U IN ghSDO).

  DO i = 1 TO NUM-ENTRIES(cAllColumns):
      cColumn = ENTRY(i,cAllColumns).
      cDataType = DYNAMIC-FUNCTION("columnDataType" in ghSDO, cColumn). 
      IF cDataType EQ "BLOB":U OR cDataType EQ "CLOB":U  THEN
          ASSIGN cLOBColumns = cLOBColumns + "," + cColumn.
    END. /* do i = 1 to num */

    ASSIGN cLOBColumns = TRIM(cLOBColumns, ",").

  IF validateBrowseFields() THEN  
     RUN adecomm/_mfldsel.p
       (INPUT "":U,     /* Use an SDO, not db tables */
        INPUT ghSDO,     /* handle of the SDO */
        INPUT ?,        /* No additional temp-tables */
        INPUT "1":U,    /* No db or table name qualification of fields */
        INPUT ",":U,    /* list delimiter */
        INPUT cLOBColumns,     /* exclude field list */
        INPUT-OUTPUT gcBrowseFields).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnInst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnInst frmAttributes
ON CHOOSE OF btnInst IN FRAME frmAttributes /* Instance Properties... */
DO:
  IF VALID-HANDLE(ghSDO) THEN
     RUN editInstanceProperties IN ghSDO.
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnKey
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnKey frmAttributes
ON CHOOSE OF btnKey IN FRAME frmAttributes /* Key... */
DO:
  DEFINE VARIABLE cKey AS CHAR NO-UNDO.
  RUN adeuib/_selkey.p (OUTPUT cKey).
  IF cKey <> "":U THEN

    ASSIGN    /* if comma last add the new value to the existing one */
      cBrowseKeys:SCREEN-VALUE = 
                 IF NUM-ENTRIES(cBrowseKeys:SCREEN-VALUE) > 1 
                 AND ENTRY(NUM-ENTRIES(cBrowseKeys:SCREEN-VALUE),
                           cBrowseKeys:SCREEN-VALUE) = "":U
                 THEN cBrowseKeys:SCREEN-VALUE + cKey 
                 ELSE cKey 
           cBrowseKeys.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cBrowseKeys
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cBrowseKeys frmAttributes
ON VALUE-CHANGED OF cBrowseKeys IN FRAME frmAttributes /* Browse Keys */
DO:
  ASSIGN cBrowseKeys.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cDataObject
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cDataObject frmAttributes
ON LEAVE OF cDataObject IN FRAME frmAttributes /* SmartDataObject */
DO:
  IF cDataObject <> cDataObject:SCREEN-VALUE IN FRAME {&FRAME-NAME} THEN
  DO:
    ASSIGN cDataObject
           gcBrowseFields = "":U.
    cDisplayedField = "":U.
    cKeyField = "":U.
    
    initSDO().
    lFormatDataSource = TRUE.
    initField().
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cDisplayedField
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cDisplayedField frmAttributes
ON VALUE-CHANGED OF cDisplayedField IN FRAME frmAttributes /* Displayed Field */
DO:
  IF SELF:SCREEN-VALUE <> cDisplayedField THEN
  DO:
    ASSIGN 
      cDisplayedField.
    initViewAs().
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cKeyField
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cKeyField frmAttributes
ON VALUE-CHANGED OF cKeyField IN FRAME frmAttributes /* Key Field */
DO:
  IF SELF:SCREEN-VALUE <> cKeyField THEN
  DO:
    ASSIGN 
      cKeyfield
      lFormatDataSource = TRUE.
    initField().
    initViewAs().
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cViewAs
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cViewAs frmAttributes
ON VALUE-CHANGED OF cViewAs IN FRAME frmAttributes /* View as */
DO:
    
 ASSIGN 
   cViewAs
   lFormatDataSource = (IF CAN-DO("Browser,Combo-box":U,cViewAs) 
                        THEN lFormatDataSource 
                        ELSE TRUE).

 initField().
 initViewAs().
 initGeometry().
 /* The call to initOptional is necessary now because we no longer allow
  * browse to have Optional toggled on
  */
 initOptional().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cViewAsOption
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cViewAsOption frmAttributes
ON VALUE-CHANGED OF cViewAsOption IN FRAME frmAttributes
DO:
   ASSIGN cViewAsOption.
   initGeometry().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lAnyKey
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lAnyKey frmAttributes
ON VALUE-CHANGED OF lAnyKey IN FRAME frmAttributes /* Define Any Key Trigger on Field */
DO:
  ASSIGN lAnyKey.
  initKey().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lCancelBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lCancelBrowse frmAttributes
ON VALUE-CHANGED OF lCancelBrowse IN FRAME frmAttributes /* Cancel on Exit of Browse */
DO:
  ASSIGN lCancelBrowse.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lExitBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lExitBrowse frmAttributes
ON VALUE-CHANGED OF lExitBrowse IN FRAME frmAttributes /* Exit Browse on Default Action */
DO:
  ASSIGN lExitBrowse.
  /* if exit on select it makes sence NOT to save on exit and vice versa */  
  lCancelBrowse:CHECKED = lExitBrowse. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lFormatDataSource
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lFormatDataSource frmAttributes
ON VALUE-CHANGED OF lFormatDataSource IN FRAME frmAttributes /* Data Source */
DO:
  ASSIGN lFormatDataSource.
  initField().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lLabelDataSource
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lLabelDataSource frmAttributes
ON VALUE-CHANGED OF lLabelDataSource IN FRAME frmAttributes /* Data Source */
DO:
  ASSIGN lLabelDataSource.
  initField().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lOptional
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lOptional frmAttributes
ON VALUE-CHANGED OF lOptional IN FRAME frmAttributes /* Optional */
DO:
  ASSIGN lOptional.
  initOptional().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lRepositionDataSource
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lRepositionDataSource frmAttributes
ON VALUE-CHANGED OF lRepositionDataSource IN FRAME frmAttributes /* Reposition Data Source */
DO:
  ASSIGN lRepositionDataSource.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK frmAttributes 


/* **************** Standard Buttons and Help Setup ******************* */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* ***************************  Main Block  *************************** */
/* Define Context ID's for HELP files */
{ src/adm2/support/admhlp.i }    

/* Attach the standard OK/Cancel/Help button bar. */
{ adecomm/okbar.i  &TOOL = "AB"
                   &CONTEXT = {&SmartSelect_Instance_Properties_Dialog_Box} }

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  initTheme().

  ghSDO = DYNAMIC-FUNC("getDataSource":U IN p_hSMO).
  
  IF NOT VALID-HANDLE(ghSDO) THEN 
  DO:
    lAnswer = yes. /* we assume the user knows what he is doing */
    MESSAGE 
   "The SmartSelect needs to be linked to a valid data-source" SKIP
   "before all the Instance Properties can be edited." SKIP(1)
   "Do you still want to continue?"  
    VIEW-AS ALERT-BOX INFORMATION
    BUTTONS YES-NO UPDATE lAnswer.
    IF NOT lAnswer THEN RETURN.
  END. /* if csdo = '' */
  
  ASSIGN cdataObject = ghSDO:FILE-NAME NO-ERROR.

  /* Get the values of the attributes in the SmartObject that can be changed 
     in this dialog-box. */
  RUN get-SmO-attributes.
  /* Enable the interface. */         
  RUN enable_UI.  
  

  ENABLE btn_ok btn_cancel btn_help WITH FRAME {&frame-name}.
  
  /* Set the cursor */
  RUN adecomm/_setcurs.p ("":U).  
 
  WAIT-FOR GO OF FRAME {&FRAME-NAME}. 
   
END.

IF VALID-HANDLE(ghSDO) THEN
  DYNAMIC-FUNCTION("shutdown-sdo":U IN getFuncLibHandle(),THIS-PROCEDURE).

RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI frmAttributes  _DEFAULT-DISABLE
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
  HIDE FRAME frmAttributes.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI frmAttributes  _DEFAULT-ENABLE
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
  DISPLAY cKeyField cDisplayedField cChangedEvent lEnable lDisplay lSort 
          lExitBrowse lCancelBrowse lOptional cOptionalString cViewAs 
          cDataObject iNumRows cLabel lLabelDataSource cBrowseTitle cToolTip 
          iHelpId cField dWidth dColumn cDatatype dHeight dRow lAnyKey 
      WITH FRAME frmAttributes.
  ENABLE cChangedEvent lEnable lDisplay lSort cViewAs cDataObject iNumRows 
         cLabel cBrowseTitle cToolTip iHelpId cField dWidth dColumn cDatatype 
         dHeight dRow cFormat cBrowseKeys RECT-15 RECT-16 RECT-18 
      WITH FRAME frmAttributes.
  VIEW FRAME frmAttributes.
  {&OPEN-BROWSERS-IN-QUERY-frmAttributes}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-SmO-attributes frmAttributes 
PROCEDURE get-SmO-attributes :
/*------------------------------------------------------------------------------
  Purpose:     Ask the "parent" SmartObject for the attributes that can be 
               changed in this dialog.  Save some of the initial-values.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hFRAME AS HANDLE NO-UNDO.
  
  IF VALID-HANDLE(p_hSMO) THEN
    ASSIGN                /* initSDO deals with enable and display 
                            (and the fact that this is not supported for 
                             the DataView */     
      cDataSourceFilter  = DYNAMIC-FUNC("getDataSourceFilter":U IN p_hSMO) 
      
      cField             = DYNAMIC-FUNC("getFieldName":U IN p_hSMO)     
      cDisplayedField    = DYNAMIC-FUNC("getDisplayedField":U IN p_hSMO) 
      cKeyField          = DYNAMIC-FUNC("getKeyField":U IN p_hSMO) 
      cChangedEvent      = DYNAMIC-FUNC("getChangedEvent":U IN p_hSMO) 
      gcBrowseFields      = DYNAMIC-FUNC("getBrowseFields":U IN p_hSMO)
      
      lSort              = DYNAMIC-FUNC("getSort":U IN p_hSMO) 
      lEnable            = DYNAMIC-FUNC("getEnableField":U IN p_hSMO) 
      lDisplay           = DYNAMIC-FUNC("getDisplayField":U IN p_hSMO) 
      lExitBrowse        = DYNAMIC-FUNC("getExitBrowseOnAction":U IN p_hSMO). 
      lCancelBrowse      = DYNAMIC-FUNC("getCancelBrowseOnExit":U IN p_hSMO) .
      lRepositionDataSource = DYNAMIC-FUNC("getRepositionDataSource":U IN p_hSMO). 
      ASSIGN
      lOptional          = DYNAMIC-FUNC("getOptional":U IN p_hSMO) 
      cOptionalString    = DYNAMIC-FUNC("getOptionalString":U IN p_hSMO)      
      /*
      lOptionalUnknown   = DYNAMIC-FUNC("getOptionalUnknown":U IN p_hSMO) 
      */
      cViewAs            = DYNAMIC-FUNC("getViewAs":U IN p_hSMO) 
      iNumRows           = DYNAMIC-FUNC("getNumRows":U IN p_hSMO) 
      
      cLabel             = DYNAMIC-FUNC("getLabel":U IN p_hSMO) 
      cBrowseTitle       = DYNAMIC-FUNC("getBrowseTitle":U IN p_hSMO)
      cFormat            = DYNAMIC-FUNC("getFormat":U IN p_hSMO) 
      cToolTip           = DYNAMIC-FUNC("getToolTip":U IN p_hSMO) 
      iHelpId            = DYNAMIC-FUNC("getHelpId":U IN p_hSMO) 
      
      hFrame             = DYNAMIC-FUNC("getContainerHandle":U IN p_hSMO)
      dColumn            = hFrame:COL
      dRow               = hFrame:ROW
      dWidth             = hFrame:WIDTH
      dHeight            = hFrame:HEIGHT
            . 
      lAnyKey            = DYNAMIC-FUNC("getDefineAnyKeyTrigger":U IN p_hSMO)  .
      cBrowseKeys        = DYNAMIC-FUNC("getStartBrowseKeys":U IN p_hSMO) .
      
    ASSIGN  lFormatDataSource  = cFormat = '?' OR cFormat = ? OR cFormat = '':U
      lLabelDataSource   = cLabel = '?' OR cLabel = ? NO-ERROR.
      
      IF NUM-ENTRIES(cViewAS,":":U) > 1 THEN
        ASSIGN
          cViewAsOption = ENTRY(2,cViewAS,":":U)
          cViewAS       = ENTRY(1,cViewAS,":":U).

    initSDO().
    initField().
    initViewAs().
    initGeometry().
    initOptional().
 END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFuncLibHandle frmAttributes 
FUNCTION getFuncLibHandle RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF NOT VALID-HANDLE(ghFuncLib) THEN 
  DO:
      ghFuncLib = SESSION:FIRST-PROCEDURE.
      DO WHILE VALID-HANDLE(ghFuncLib):
        IF ghFuncLib:FILE-NAME = "adeuib/_abfuncs.w":U THEN LEAVE.
        ghFuncLib = ghFuncLib:NEXT-SIBLING.
      END.
  END.
  RETURN ghFuncLib.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initField frmAttributes 
FUNCTION initField RETURNS LOGICAL
  () :
/*------------------------------------------------------------------------------
  Purpose: Set Field Attributes from data-source  
           Called from value-changed of lFormatDataSource, lLabelDataSource
           and DisplayedField.
    Notes: Fields are assigned on value-changed.
           lFormatDataSource is set to TRUE 
           - on valuechanged of DisplayField   
           - on valuechanged of view-as if not "browse"                                
------------------------------------------------------------------------------*/
 
DO WITH FRAME {&FRAME-NAME}: 
    ASSIGN
        iNumRows:READ-ONLY     = cViewAs =  "Radio-set":U
        cLabel:READ-ONLY       = lLabelDataSource
        cBrowseTitle:READ-ONLY = cViewAs <> "Browser":U
        cFormat:READ-ONLY      = lFormatDataSource
        iNumRows:TAB-STOP      = iNumRows:READ-ONLY = FALSE
        cLabel:TAB-STOP        = cLabel:READ-ONLY = FALSE
        cBrowseTitle:TAB-STOP  = cBrowseTitle:READ-ONLY = FALSE
        cFormat:TAB-STOP       = cFormat:READ-ONLY = FALSE
        lFormatDataSource:SENSITIVE  = cViewAs = "COMBO-BOX":U   
                                       AND VALID-HANDLE(ghSDO)
        lRepositionDataSource:SENSITIVE = cViewAs <> "Browser":U
        lRepositionDataSource:CHECKED   = (IF cViewAs = "Browser":U 
                                        THEN TRUE
                                        ELSE lRepositionDataSource)
        /* when view-as browse, don't enable the optional toggle-box and turn it off
         * and make the Optional string fill-in read-only 
         */
        lOptional:SENSITIVE = cViewAs <> "Browser":U
        lOptional:CHECKED   = (IF cViewAs = "Browser":U 
                                        THEN FALSE
                                        ELSE lOptional)
        cOptionalString:READ-ONLY = cViewAs = "Browser":U
        cOptionalString:TAB-STOP  = cOptionalString:READ-ONLY = FALSE
        
        lCancelBrowse:SENSITIVE = cViewAs = "Browser":U
        lExitBrowse:SENSITIVE = cViewAs = "Browser":U
        btnBrowse:SENSITIVE   = cViewAs =  "Browser":U AND VALID-HANDLE(ghSDO) 
        lAnyKey:SENSITIVE     = cViewAs =  "Browser":U.
        
    
    IF iNumRows:TAB-STOP THEN
      iNumRows:MOVE-AFTER(cViewAsOption:HANDLE).

    IF cLabel:TAB-STOP THEN
      cLabel:MOVE-AFTER(IF iNumRows:TAB-STOP 
                        THEN iNumRows:HANDLE
                        ELSE cViewAsOption:HANDLE).
    
    IF cBrowseTitle:TAB-STOP THEN
      cBrowseTitle:MOVE-AFTER(lLabelDataSource:HANDLE).
    
    IF cFormat:TAB-STOP THEN
      cFormat:MOVE-AFTER(IF cBrowseTitle:TAB-STOP
                         THEN cBrowseTitle:HANDLE
                         ELSE lLabelDataSource:HANDLE).
    
    initKey().

    IF VALID-HANDLE (ghSDO) AND cKeyField <> "":U THEN
    DO:
      ASSIGN
        cDataType    = DYNAMIC-FUNC('columnDataType':U in ghSDO,cKeyField)
        cFormat      = (IF cFormat:READ-ONLY THEN 
                          DYNAMIC-FUNC('columnFormat':U in ghSDO,cKeyField)
                        ELSE cFormat)
        cLabel       = (IF lLabelDataSource 
                        THEN 
                          DYNAMIC-FUNC('columnLabel':U in ghSDO,cKeyField)
                        ELSE cLabel).
    END. /* if valid-handle(ghSDO) and cDisplayedfields = '' */
    ELSE
      ASSIGN
        cDataType = "":U
        cFormat   = "":U
        cLabel    = (IF cLabel = "?":U OR cLabel = ? 
                     THEN "":U 
                     ELSE cLabel).
    DISPLAY 
      cDataType cFormat cLabel lFormatDataSource. 
  END. /* do with frame */   
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initGeometry frmAttributes 
FUNCTION initGeometry RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN 
      dHeight:READ-ONLY    = (cViewAS = "Combo-box":U) 
                              AND 
                             (cViewAsOption <> "Simple":U) 
                              
      dHeight:SCREEN-VALUE = IF dHeight:READ-ONLY 
                             THEN "1":U 
                             ELSE dHeight:SCREEN-VALUE.
  END.  
  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initKey frmAttributes 
FUNCTION initKey RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Set the Key field and button    
    Notes: Called from initField() and value-changed of lAnyKey 
------------------------------------------------------------------------------*/
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      btnKey:SENSITIVE      = cViewAs = "Browser":U AND lAnyKey 
      cBrowseKeys:READ-ONLY = cViewAs <> "Browser":U OR NOT lAnyKey
      cBrowseKeys:TAB-STOP   = NOT cBrowseKeys:READ-ONLY.
    
    IF cBrowseKeys:TAB-STOP THEN
      cBrowseKeys:MOVE-BEFORE(btnKey:HANDLE).
    
    cBrowseKeys:SCREEN-VALUE = IF cBrowseKeys:READ-ONLY 
                               THEN "":U
                               ELSE cBrowseKeys.
  END.

  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initOptional frmAttributes 
FUNCTION initOptional RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  /* when view-as browse, don't enable the optional toggle-box and turn it off
   * and make the Optional string fill-in read-only 
   */
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
     lOptional           = (IF cViewAs = "Browser":U 
                                        THEN FALSE
                                        ELSE lOptional)
     lOptional:SENSITIVE = cViewAs <> "Browser":U
     lOptional:CHECKED   = (IF cViewAs = "Browser":U 
                                        THEN FALSE
                                        ELSE lOptional)
      
      cOptionalString:READ-ONLY = NOT lOptional 
      cOptionalString:SENSITIVE = TRUE 
      cOptionalString:TAB-STOP  = lOptional.

    IF lOptional THEN
      cOptionalString:MOVE-AFTER(lOptional:HANDLE).
    
  END. /* do with frame */
  RETURN TRUE. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initSDO frmAttributes 
FUNCTION initSDO RETURNS LOGICAL
  () :
/*------------------------------------------------------------------------------
  Purpose: Start the SDO persistently and fill combo-boxes with column names  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iLines       AS INTEGER   NO-UNDO.
/*  DEFINE VARIABLE cDataColumns  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cColumn      AS CHARACTER NO-UNDO.
*/

  IF VALID-HANDLE(ghSDO) THEN
  DO WITH FRAME {&FRAME-NAME}:
        
    ASSIGN
       cKeyField:LIST-ITEMS = removeLOBFields(DYNAMIC-FUNCTION("getDataColumns" IN ghSDO))
       iLines = NUM-ENTRIES(cKeyField:LIST-ITEMS)

       cDisplayedField:LIST-ITEMS   = cKeyField:LIST-ITEMS
       cKeyField:INNER-LINES        = IF iLines <> ? THEN MAX(iLines,15) ELSE 1 /*whatever*/
       cDisplayedField:INNER-LINES  = cKeyField:INNER-LINES
       cKeyField:SENSITIVE          = TRUE
       cDisplayedField:SENSITIVE    = TRUE
       lLabelDataSource:SENSITIVE   = TRUE
       btnInst:SENSITIVE            = TRUE 
       /* Not that this is also set in initViewAs() */       
       btnBrowse:SENSITIVE          = cViewAs =  "Browser":U 
       cDataSourcefilter:SENSITIVE  = NOT {fnarg instanceOf 'DataView':U ghSDO}
      /* Try to match with SDV field */  
       cKeyField:SCREEN-VALUE       = IF cKeyField = "":U THEN cField 
                                      ELSE cKeyField NO-ERROR .
       cDisplayedField:SCREEN-VALUE = IF cDisplayedField = "":U THEN cField
                                      ELSE cDisplayedField NO-ERROR .

     /* not supported against dataview (non dbaware) */
    IF NOT cDataSourcefilter:SENSITIVE THEN 
       ASSIGN
         cDataSourcefilter:SCREEN-VALUE = ''
         cDataSourceFilter.
    ELSE 
      ASSIGN
        cDataSourcefilter:SCREEN-VALUE = cDataSourceFilter.

    ASSIGN 
      cDisplayedfield
      cKeyField.
  END. /* valid ghSDO */
  ELSE DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      cKeyField:SENSITIVE        = FALSE
      cDisplayedField:SENSITIVE  = FALSE
      cKeyField:TAB-STOP         = FALSE
      cDisplayedField:TAB-STOP   = FALSE
      lLabelDataSource:SENSITIVE = FALSE
      btnInst:SENSITIVE          = FALSE
      lLabelDataSource           = FALSE /* allow label */
      lFormatDataSource          = TRUE  /* but not format */ 
      gcBrowseFields = "":U
      cKeyField = "":U
      cDisplayedField = "":U.
  END.  /* else (no data-source) */

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initTheme frmAttributes 
FUNCTION initTheme RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hWidget AS HANDLE     NO-UNDO.
  hWidget = FRAME {&FRAME-NAME}:FIRST-CHILD:FIRST-CHILD.
  IF SESSION:WINDOW-SYSTEM = 'MS-WINXP':U THEN
  DO WHILE VALID-HANDLE(hWidget):
    IF hWidget:TYPE = "RECTANGLE":U AND hWidget:EDGE-PIXELS = 2 THEN
      ASSIGN 
        hWidget:GROUP-BOX = TRUE
        hWidget:EDGE-PIXELS = 1.
    hWidget = hWidget:NEXT-SIBLING.
  END.
  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initViewAs frmAttributes 
FUNCTION initViewAs RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Set objects that are depending of view-as  
    Notes:  
------------------------------------------------------------------------------*/
 
DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      cViewAsOption:AUTO-RESIZE = TRUE.
    CASE cViewAs. 
      WHEN "Combo-box":U THEN
      DO:
        ASSIGN 
          cViewAsOption:HIDDEN        = FALSE
          cViewAsOption:RADIO-BUTTONS = 
            "Drop-down-list,drop-down-list,Drop-down,drop-down,Simple,simple":U .
        
        /* editable combo not allowed with disp <> key */ 
        IF cKeyField <> cDisplayedField THEN
        DO: 
          cViewAsOption = "Drop-down-list":U.
          cViewAsOption:DISABLE('Drop-down':U).
          cViewAsOption:DISABLE('Simple':U).
        END.
        ELSE DO:
          cViewAsOption:ENABLE('Drop-down':U).
          cViewAsOption:ENABLE('Simple':U).
        END.
      END.
      WHEN "Radio-set":U THEN
        ASSIGN 
           cViewAsOption:HIDDEN        = FALSE
           cViewAsOption:RADIO-BUTTONS = 
                  "Horizontal,Horizontal,Vertical,Vertical":U .
             
      OTHERWISE
        ASSIGN 
          cViewAsOption:RADIO-BUTTONS = ",":U
          cViewAsOption:HIDDEN = TRUE.
      
    END CASE.
    
    ASSIGN
      cViewASOption:SENSITIVE    = TRUE 
      cViewASOption:SCREEN-VALUE = cViewAsOption NO-ERROR.
    
    /* If screen-value did not match value save the screen-value */
    IF cViewASOption:SCREEN-VALUE <> cViewAsOption THEN
       ASSIGN cViewAsOption.  
  
  END. /* do with frame {&FRAME-NAME}. */
  RETURN TRUE.
END FUNCTION.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION validateBrowseFields frmAttributes 
FUNCTION validateBrowseFields RETURNS LOGICAL
  () :
/*------------------------------------------------------------------------------
  Purpose: Remove non-valid fields from the list 
    Notes: As an extremly friendly gesture we do allow the user to cancel this.            
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDataColumns  AS CHAR NO-UNDO.
  DEFINE VARIABLE cValidColumns AS CHAR NO-UNDO.
  DEFINE VARIABLE cColumn       AS CHAR NO-UNDO.
  DEFINE VARIABLE i             AS INT  NO-UNDO.
  DEFINE VARIABLE lOk           AS LOG  NO-UNDO.
  DEFINE VARIABLE cRemoved      AS CHAR NO-UNDO.
  DEFINE VARIABLE cText         AS CHAR NO-UNDO.

  IF VALID-HANDLE(ghSdo) THEN
  DO:
    cDataColumns = removeLOBFields(DYNAMIC-FUNCTION("getDataColumns":U IN ghSDO)).
    DO i = 1 TO NUM-ENTRIES(gcBrowseFields):
      cColumn = ENTRY(i,gcBrowseFields).
      IF CAN-DO(cDataColumns,cColumn) THEN
        cValidColumns = cValidColumns + "," + cColumn.
      ELSE 
        cRemoved = cRemoved + " " + cColumn.

    END. /* do i = 1 to num */
    IF cRemoved <> "":U THEN
    DO:
      ASSIGN
        cRemoved = TRIM(cRemoved)
        cText    = IF NUM-ENTRIES(cRemoved," ":U) = 1 
                   THEN "field" 
                   ELSE "fields"
        lOk      = YES. 
      MESSAGE 
       "The Browse Columns does not match the SmartDataObject." 
         SKIP
        "The following" ctext "will be removed from the list:" SKIP
        " "  + cRemoved SKIP
        "Press OK to continue."
        VIEW-AS ALERT-BOX QUESTION BUTTONS OK-CANCEL UPDATE lok.
      IF NOT lok THEN RETURN FALSE.
    END.
    gcBrowseFields = TRIM(cValidColumns,",":U).
    RETURN TRUE.
  END. /* valid-handle(ghSdo) */
  ELSE RETURN FALSE.

END FUNCTION.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION removeLOBFields Include
FUNCTION removeLOBFields RETURNS CHARACTER 
	(INPUT cAllColumns AS CHARACTER):
  /*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
  ------------------------------------------------------------------------------*/
  DEFINE VARIABLE i            AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cDataColumns AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDataType    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cColumn      AS CHARACTER NO-UNDO.

  cAllColumns = DYNAMIC-FUNC("getDataColumns":U IN ghSDO).

  DO i = 1 TO NUM-ENTRIES(cAllColumns):
      cColumn = ENTRY(i,cAllColumns).
      cDataType = DYNAMIC-FUNCTION("columnDataType" in ghSDO, cColumn). 
      IF cDataType NE "BLOB":U AND cDataType NE "CLOB":U  THEN
          ASSIGN cDataColumns = cDataColumns + "," + cColumn.
    END. /* do i = 1 to num */

    ASSIGN cDataColumns = TRIM(cDataColumns, ",").

  RETURN cDataColumns.
END FUNCTION.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

