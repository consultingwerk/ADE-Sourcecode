&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Attribute-Dlg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Attribute-Dlg 
/***********************************************************************
* Copyright (C) 2005-2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*------------------------------------------------------------------------

  File: visuald.w 

  Description: Instance Properties Dialog for Visual SmartObjects.

  Input Parameters:
     p_hSMO -- Procedure Handle of calling SmartObject.

  Output Parameters:
      <none>

  History: Modified A D Swindells 27/07/2000. 
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&GLOBAL-DEFINE WIN95-BTN YES

/* use of widget-pool is ok, since this does not create any widgets in 
   the actual viewer */
CREATE WIDGET-POOL.

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p_hSMO AS HANDLE NO-UNDO.

DEFINE TEMP-TABLE ttEnabledObject
   FIELD ObjectName AS CHAR 
   FIELD ToggleHandle AS HANDLE.

DEFINE TEMP-TABLE ttModifyField
   FIELD ObjectName   AS CHAR 
   FIELD ToggleHandle AS HANDLE
   FIELD DataSource   AS LOG  
   FIELD Updatable    AS LOG.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE attr-list                   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE orig-layout                 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcDisableObjects            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcModifyFields             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE xdScrollToggleHeight        AS DECIMAL    NO-UNDO INIT 0.72.

/* Valid choices other than list of objects, used at init and GO   
  (NOTE: radio-set has this hard-coded ) Each choice is also hard-coded in 
   some function(s)  */
DEFINE VARIABLE xcDisableChoices            AS CHARACTER  NO-UNDO
                INIT '(All),(None)':U. 
DEFINE VARIABLE xcModifyChoices             AS CHARACTER  NO-UNDO
                INIT '(All),(None),(EnabledFields),(Updatable)':U.

/* Define the value of the "No Layout Options" supplied. */
&Scoped-define no-layout [default]
{src/adm2/support/admhlp.i}          /* Help File Preprocessor Directives         */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Attribute-Dlg

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-3 RECT-6 l_Enable l_View ~
cDisableObjects cModifyObjects BUTTON-2 BUTTON-3 fiChar fiChar-2 
&Scoped-Define DISPLAYED-OBJECTS c_Logical_Object_Name l_Enable c_Layout ~
l_View cDisableObjects cModifyObjects fiChar fiChar-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createFrameBorder Attribute-Dlg 
FUNCTION createFrameBorder RETURNS LOGICAL
  ( phFrame AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createToggle Attribute-Dlg 
FUNCTION createToggle RETURNS HANDLE
  ( phFrame  AS HANDLE,
    pcLabel  AS CHAR,
    pdRow    AS DEC,
    pdCol    AS DEC)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD disableModifyFrame Attribute-Dlg 
FUNCTION disableModifyFrame RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD disableObjectFrame Attribute-Dlg 
FUNCTION disableObjectFrame RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD enableModifyFrame Attribute-Dlg 
FUNCTION enableModifyFrame RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD enableObjectFrame Attribute-Dlg 
FUNCTION enableObjectFrame RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataSource Attribute-Dlg 
FUNCTION getDataSource RETURNS HANDLE
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initDisableObjects Attribute-Dlg 
FUNCTION initDisableObjects RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initEnabledObjects Attribute-Dlg 
FUNCTION initEnabledObjects RETURNS LOGICAL
  ( pcEnabledObjects AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initModifyFields Attribute-Dlg 
FUNCTION initModifyFields RETURNS LOGICAL
  ( pcEnabledObjects AS CHAR,
    pcEnabledFields AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initModifyObjects Attribute-Dlg 
FUNCTION initModifyObjects RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD toggleDisableObjects Attribute-Dlg 
FUNCTION toggleDisableObjects RETURNS LOGICAL
  ( plON AS LOG  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD toggleModifyObjects Attribute-Dlg 
FUNCTION toggleModifyObjects RETURNS LOGICAL
  ( pcChoice AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-2 AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.14.

DEFINE BUTTON BUTTON-3 AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE c_Layout AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Layout" 
     VIEW-AS COMBO-BOX 
     DROP-DOWN-LIST
     SIZE 27.8 BY 1 NO-UNDO.

DEFINE VARIABLE c_Logical_Object_Name AS CHARACTER FORMAT "X(256)":U 
     LABEL "Object Name" 
     VIEW-AS FILL-IN 
     SIZE 48.2 BY 1 NO-UNDO.

DEFINE VARIABLE fiChar AS CHARACTER FORMAT "X(256)":U INITIAL "Which objects should be disabled with data fields?" 
      VIEW-AS TEXT 
     SIZE 49.2 BY .62 NO-UNDO.

DEFINE VARIABLE fiChar-2 AS CHARACTER FORMAT "X(256)":U INITIAL "Which fields should set DataModified on change?" 
      VIEW-AS TEXT 
     SIZE 48.4 BY .62 NO-UNDO.

DEFINE VARIABLE cDisableObjects AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Some", "",
"All", "(All)",
"None", "(None)"
     SIZE 11.8 BY 2.48 NO-UNDO.

DEFINE VARIABLE cModifyObjects AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Some", "",
"All", "(All)",
"Data Fields", "(EnabledFields)",
"Updatable", "(Updatable)",
"None", "(None)"
     SIZE 14.8 BY 3.95 TOOLTIP "Select some, all, fields from data source, updatable in data source or none" NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 65 BY .1.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 65 BY .1.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 65 BY .1.

DEFINE VARIABLE l_Enable AS LOGICAL INITIAL no 
     LABEL "&Enable" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY 1.1 NO-UNDO.

DEFINE VARIABLE l_View AS LOGICAL INITIAL no 
     LABEL "&View" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .86 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Attribute-Dlg
     c_Logical_Object_Name AT ROW 1.48 COL 4.4
     l_Enable AT ROW 3.91 COL 4.6
     c_Layout AT ROW 3.95 COL 37 COLON-ALIGNED
     l_View AT ROW 4.95 COL 4.6
     cDisableObjects AT ROW 7.05 COL 4.4 NO-LABEL
     cModifyObjects AT ROW 12.29 COL 4.4 NO-LABEL
     BUTTON-2 AT ROW 16.81 COL 35.4
     BUTTON-3 AT ROW 16.81 COL 51.8
     fiChar AT ROW 6.14 COL 2.4 COLON-ALIGNED NO-LABEL
     fiChar-2 AT ROW 11.33 COL 4.4 NO-LABEL
     "Behavior during 'Initialize'" VIEW-AS TEXT
          SIZE 24.8 BY .62 AT ROW 3.1 COL 4.4
     RECT-2 AT ROW 11.62 COL 1.8
     RECT-3 AT ROW 3.43 COL 1.8
     RECT-6 AT ROW 6.48 COL 1.8
     SPACE(0.79) SKIP(11.51)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Viewer Instance Properties":L
         DEFAULT-BUTTON BUTTON-2.

DEFINE FRAME frDisabledObjects
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 19.4 ROW 7.14
         SIZE 46.6 BY 3.67.

DEFINE FRAME frModifyObjects
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 19.4 ROW 12.38
         SIZE 46.6 BY 3.76.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* REPARENT FRAME */
ASSIGN FRAME frDisabledObjects:FRAME = FRAME Attribute-Dlg:HANDLE
       FRAME frModifyObjects:FRAME = FRAME Attribute-Dlg:HANDLE.

/* SETTINGS FOR DIALOG-BOX Attribute-Dlg
   FRAME-NAME L-To-R                                                    */
ASSIGN 
       FRAME Attribute-Dlg:SCROLLABLE       = FALSE
       FRAME Attribute-Dlg:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX c_Layout IN FRAME Attribute-Dlg
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c_Logical_Object_Name IN FRAME Attribute-Dlg
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN fiChar-2 IN FRAME Attribute-Dlg
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME frDisabledObjects
   NOT-VISIBLE                                                          */
/* SETTINGS FOR FRAME frModifyObjects
   NOT-VISIBLE                                                          */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX Attribute-Dlg
/* Query rebuild information for DIALOG-BOX Attribute-Dlg
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX Attribute-Dlg */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frDisabledObjects
/* Query rebuild information for FRAME frDisabledObjects
     _Query            is NOT OPENED
*/  /* FRAME frDisabledObjects */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frModifyObjects
/* Query rebuild information for FRAME frModifyObjects
     _Query            is NOT OPENED
*/  /* FRAME frModifyObjects */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Attribute-Dlg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Attribute-Dlg Attribute-Dlg
ON GO OF FRAME Attribute-Dlg /* Viewer Instance Properties */
DO: 
  DEFINE VARIABLE lAsk AS LOGICAL    NO-UNDO.
  /* Reassign the attribute alues back in the SmartObject. */
  ASSIGN 
    l_Enable 
    l_View
    c_Logical_Object_Name
    c_Layout = c_Layout:SCREEN-VALUE WHEN c_Layout:SENSITIVE.
 
  DYNAMIC-FUNC("setDisableOnInit":U IN p_hSMO, NOT l_Enable) NO-ERROR.
  DYNAMIC-FUNC("setHideOnInit":U IN p_hSMO, NOT l_View) NO-ERROR.
  DYNAMIC-FUNC("setLogicalObjectName":U IN p_hSMO, c_Logical_Object_Name) NO-ERROR.
  
  /* The gcDisabledActions is set from the radio-set if it is changed, and
     will be blank if some is selected, but may have a list of fields if the 
     option did not change */ 
  IF NOT CAN-DO(xcDisableChoices,gcDisableObjects) THEN
  DO:
    gcDisableObjects = '':U. /* ensure old fields is removed */ 
    FOR EACH ttEnabledObject:
      IF ttEnabledObject.toggleHandle:CHECKED THEN
         gcDisableObjects = gcDisableObjects 
                          + (IF gcDisableObjects = '':U THEN '':U ELSE ',':U)
                          + ttEnabledObject.ObjectName.
    END.
  END.

  IF gcDisableObjects = '':U THEN
  DO:
    MESSAGE 
      "You have specified that 'Some' objects should be disabled, but no objects are selected." SKIP
      "'None' of the enabled objects will be disabled with data fields." 
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK-CANCEL UPDATE lAsk. 
    IF lAsk THEN 
      gcDisableObjects = '(None)':U.
    ELSE DO:
      APPLY 'entry':U TO cDisableObjects.
      RETURN NO-APPLY. 
    END.
  END.
   
  DYNAMIC-FUNCTION("setEnabledObjFldsToDisable":U IN p_hSMO, gcDisableObjects) NO-ERROR.   

  /* The gcModifyActions is set from the radio-set if it is changed, and
     will be blank if some is selected, but may have a list of fields if the 
     option did not change */ 
  IF NOT CAN-DO(xcModifyChoices,gcModifyFields) THEN
  DO:
    gcModifyFields = '':U. /* ensure old fields is removed */ 
    FOR EACH ttModifyField:
      IF ttModifyField.toggleHandle:CHECKED THEN
         gcModifyFields = gcModifyFields 
                          + (IF gcModifyFields = '':U THEN '':U ELSE ',':U)
                          + ttModifyField.ObjectName.
    END.
  END.

  IF gcModifyFields = '':U THEN
  DO:
    MESSAGE 
      "You have specifed that 'Some' fields should set DataModified, but no fields are selected." SKIP
      "'None' of the fields will set DataModified on change." 
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK-CANCEL UPDATE lAsk. 
    IF lAsk THEN 
      gcModifyFields = '(None)':U.
    ELSE DO:
      APPLY 'entry':U TO cModifyObjects.
      RETURN NO-APPLY. 
    END.
  END.
   
  DYNAMIC-FUNCTION("setModifyFields":U IN p_hSMO, gcModifyFields) NO-ERROR.   


  /* Only set the layout if it has changed.  Remember that LAYOUT is an
     attribute whose changes must be explicitly applied. */
  IF c_Layout:SENSITIVE AND c_Layout ne orig-layout THEN DO:
    IF c_Layout eq "{&no-layout}":U THEN c_Layout = "":U.
    DYNAMIC-FUNC("setObjectLayout":U IN p_hSMO, INPUT c_Layout) NO-ERROR.
    RUN applyLayout IN p_hSMO.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Attribute-Dlg Attribute-Dlg
ON HELP OF FRAME Attribute-Dlg /* Viewer Instance Properties */
DO:
   RUN adecomm/_adehelp.p 
      ("ICAB", "CONTEXT":U, {&Viewer_Instance_Properties_Dialog_Box},?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Attribute-Dlg Attribute-Dlg
ON WINDOW-CLOSE OF FRAME Attribute-Dlg /* Viewer Instance Properties */
DO:
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cDisableObjects
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cDisableObjects Attribute-Dlg
ON VALUE-CHANGED OF cDisableObjects IN FRAME Attribute-Dlg
DO:
  ASSIGN cDisableObjects.
  initDisableObjects().
  gcDisableObjects = cDisableObjects.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cModifyObjects
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cModifyObjects Attribute-Dlg
ON VALUE-CHANGED OF cModifyObjects IN FRAME Attribute-Dlg
DO:
  ASSIGN cModifyObjects. 
  initModifyObjects().
  gcModifyFields = cModifyObjects.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Attribute-Dlg 


/* **************** Standard Buttons and Help Setup ******************* */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Define Context ID's for HELP files */
{ src/adm2/support/admhlp.i }    

/* Attach the standard OK/Cancel/Help button bar. */
/* { adecomm/okbar.i  &TOOL = "AB"                                         */
/*                    &CONTEXT = {&VisualSmartObject_Attributes_Dlg_Box} } */

/* ***************************  Main Block  *************************** */

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  /* Get the values of the attributes in the SmartObject that can be 
     changed in this dialog-box. */
  RUN get-SmO-attributes.
    
  /* Enable the interface. */   
  createFrameborder(FRAME frDisabledObjects:HANDLE).
  /* avoid errors when objectframe is scrollable */
  FRAME frDisabledObjects:HIDDEN = FALSE NO-ERROR.
  FRAME frDisabledObjects:MOVE-AFTER(cDisableObjects:HANDLE).
  /* Enable the interface. */   
  createFrameborder(FRAME frModifyObjects:HANDLE).
  /* avoid errors when objectframe is scrollable */
  FRAME frModifyObjects:HIDDEN = FALSE NO-ERROR.
  FRAME frModifyObjects:MOVE-AFTER(cModifyObjects:HANDLE).
  
  RUN enable_UI.  
  
  /* Set the cursor */
  RUN adecomm/_setcurs.p ("":U).  
 
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.  
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cursorMove Attribute-Dlg 
PROCEDURE cursorMove :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phToggle AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER pcMove   AS CHARACTER  NO-UNDO.

  FIND ttEnabledObject WHERE ttEnabledObject.ToggleHandle  = phToggle NO-ERROR.
  
  IF AVAIL ttEnabledObject THEN
  DO:
    CASE pcMove:
      WHEN 'DOWN':U THEN
      DO:
       FIND NEXT ttEnabledObject NO-ERROR.
       IF NOT AVAIL ttEnabledObject THEN
          FIND FIRST ttEnabledObject NO-ERROR.
      END.
      WHEN 'UP':U THEN
      DO:
       FIND PREV ttEnabledObject NO-ERROR.
       IF NOT AVAIL ttEnabledObject THEN
          FIND LAST ttEnabledObject NO-ERROR.
      END.
    END.
    IF AVAIL ttEnabledObject THEN
      APPLY 'Entry' TO ttEnabledObject.ToggleHandle.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  HIDE FRAME frDisabledObjects.
  HIDE FRAME frModifyObjects.
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
  DISPLAY c_Logical_Object_Name l_Enable c_Layout l_View cDisableObjects 
          cModifyObjects fiChar fiChar-2 
      WITH FRAME Attribute-Dlg.
  ENABLE RECT-2 RECT-3 RECT-6 l_Enable l_View cDisableObjects cModifyObjects 
         BUTTON-2 BUTTON-3 fiChar fiChar-2 
      WITH FRAME Attribute-Dlg.
  VIEW FRAME Attribute-Dlg.
  {&OPEN-BROWSERS-IN-QUERY-Attribute-Dlg}
  {&OPEN-BROWSERS-IN-QUERY-frDisabledObjects}
  {&OPEN-BROWSERS-IN-QUERY-frModifyObjects}
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
  DEFINE VARIABLE ldummy          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lUseRepository  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cSingleInstance AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEnabledObjects AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEnabledFields  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTableioTarget  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cContext        AS CHARACTER  NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:   
    lUseRepository = DYNAMIC-FUNCTION("getUseRepository":U IN p_hSMO) NO-ERROR.
    cSingleInstance = DYNAMIC-FUNCTION("getUserProperty":U IN p_hSMO, "EditSingleInstance":U).

    /* Get the attributes used in this Instance Attribute dialog-box. */
    l_Enable = NOT DYNAMIC-FUNC("getDisableOnInit":U IN p_hSMO).
    l_View   = NOT DYNAMIC-FUNC("getHideOnInit":U IN p_hSMO).
    cEnabledObjects  = DYNAMIC-FUNCTION("getEnabledObjFlds":U IN p_hSMO).   
    cEnabledFields   = DYNAMIC-FUNCTION("getEnabledFields":U IN p_hSMO).   
    gcDisableObjects = DYNAMIC-FUNCTION("getEnabledObjFldsToDisable":U IN p_hSMO).   
    gcModifyFields  = DYNAMIC-FUNCTION("getModifyFields":U IN p_hSMO).   

    initEnabledObjects(cEnabledObjects).
    
    /* trim comma in case one of the lists are blank */
    initModifyFields(cEnabledObjects,cEnabledFields).

    IF CAN-DO(xcModifyChoices,gcModifyFields) THEN
      cModifyObjects = gcModifyFields.
    ELSE 
      cModifyObjects = '':U. /* This is '(some)' in the radio-set */
    
    IF CAN-DO(xcDisableChoices,gcDisableObjects) THEN
      cDisableObjects = gcDisableObjects.
    ELSE IF gcDisableObjects > '':U THEN 
      cDisableObjects = '':U. /* This is '(some)' in the radio-set */
    ELSE IF lUseRepository THEN
    DO:
      /* Default for repository objects is (all) if tablieosource */                                                 
      ASSIGN
        cContext = STRING(p_hSMO)
        hTableioTarget = p_hSMO. 
      /* loop through potential GA sources */
      DO WHILE TRUE:
        RUN adeuib/_uibinfo (?, "HANDLE ":U + STRING(cContext), 
                                "LINK GROUPASSIGN-SOURCE":U, 
                                OUTPUT cContext). 
        IF cContext > '':U THEN
        DO:
          RUN adeuib/_uibinfo (INT(cContext), ?, "PROCEDURE-HANDLE":U,
                               OUTPUT cContext).      
          hTableioTarget = WIDGET-HANDLE(cContext). 
        END.
        ELSE 
          LEAVE.

      END.
      /* Check for tableiosource */ 
      RUN adeuib/_uibinfo (?, "HANDLE ":U + STRING(hTableioTarget), 
                             "LINK TABLEIO-SOURCE":U, 
                              OUTPUT cContext). 
      IF cContext > '':U THEN 
        cDisableObjects = '(All)':U.
      ELSE 
        cDisableObjects = '(None)':U.
    END.
    ELSE 
      cDisableObjects = '(None)':U.
  
    ASSIGN gcDisableObjects = cDisableObjects.

    initDisableObjects(). 
    initModifyObjects(). 

    /* Choose Layout. */
    /* V8: RUN get-attribute IN p_hSMO ("Layout-Options":U). */
    ASSIGN c_Layout = DYNAMIC-FUNC("getLayoutOptions":U IN p_hSMO) NO-ERROR.
    ASSIGN c_Layout = (IF c_Layout <> ? THEN c_Layout ELSE "":U).
    
    IF lUseRepository THEN
     /* determine logical object name */    
     c_Logical_Object_Name = DYNAMIC-FUNC("getLogicalObjectName":U IN p_hSMO) NO-ERROR.
    ELSE 
     /* use object name */    
     c_Logical_Object_Name = DYNAMIC-FUNC("getObjectName":U IN p_hSMO) NO-ERROR.


    ASSIGN 
      c_Layout:LIST-ITEMS  = c_Layout
      ldummy               = c_Layout:ADD-FIRST ("{&no-layout}":U)
      c_Layout:SENSITIVE   = c_Layout:NUM-ITEMS > 1
      c_Layout:INNER-LINES = MIN(10,MAX(3,c_Layout:NUM-ITEMS + 1)).
    /* Disable the logical object name if this is a single instance, i.e. 
       modifying an object's properties on a container using the Container
       Builder or the Page Layout tool. 
       We just show objectname if not useRepos, but have to disable as it is 
       not currently an instance property */
      c_Logical_Object_Name:SENSITIVE = cSingleInstance <> 'YES':U AND lUseRepository.

  
    /* V8: RUN get-attribute IN p_hSMO ("Layout":U). */
    ASSIGN c_Layout = DYNAMIC-FUNC("getObjectLayout":U IN p_hSMO) NO-ERROR.
    ASSIGN c_Layout    = IF c_Layout = ? OR c_Layout = "":U OR
                            c_Layout = "?":U /* Compatibility with ADM1.0 */
                         THEN "{&no-layout}":U 
                         ELSE c_Layout
           orig-layout = c_Layout.
  END. /* DO WITH FRAME... */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createFrameBorder Attribute-Dlg 
FUNCTION createFrameBorder RETURNS LOGICAL
  ( phFrame AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose: Adds rectangles around the passed frame in order to give it a 3D 
          'sunken' look.  
    Notes:  
------------------------------------------------------------------------------*/
   DEFINE VARIABLE hLeft AS HANDLE     NO-UNDO.
   DEFINE VARIABLE hTop AS HANDLE     NO-UNDO.
   DEFINE VARIABLE hBottom AS HANDLE     NO-UNDO.
   DEFINE VARIABLE hRight AS HANDLE     NO-UNDO.
   
   ASSIGN    
     phframe:Y        = phframe:Y + 2
     phframe:X        = phframe:X + 2.

   CREATE RECTANGLE hleft
       ASSIGN   
       FGCOLOR = 7
          HEIGHT-P = phFrame:HEIGHT-P + 4
          WIDTH-P = 2
          X =  phFrame:X - 2
          Y  = phFrame:y - 2
         FRAME =FRAME {&FRAME-NAME}:HANDLE
         HIDDEN =FALSE.
         
   CREATE RECTANGLE htOP
         ASSIGN   
         FGCOLOR = 7
            width-P = phFrame:width-P + 4
            HEIGHT-P = 2
            X  = phFrame:X - 2
            Y  = phFrame:y - 2
          FRAME =FRAME {&FRAME-NAME}:HANDLE

          HIDDEN =FALSE.
     CREATE RECTANGLE hbOTTOM
         ASSIGN   
         FGCOLOR = 15
            width-P = phFrame:width-P + 3
            HEIGHT-P = 1
            X  = phFrame:X - 2
            Y  = phFrame:y + phFrame:HEIGHT-P + 1
          FRAME =FRAME {&FRAME-NAME}:HANDLE

          HIDDEN =FALSE.
     CREATE RECTANGLE hRight
       ASSIGN   
       FGCOLOR = 15
          HEIGHT-P = phFrame:HEIGHT-P + 3
          X  = phFrame:X + phFrame:width-P + 1
          Y  = phFrame:y - 2
          WIDTH-P = 1
        FRAME =FRAME {&FRAME-NAME}:HANDLE

        HIDDEN =FALSE.
  RETURN true.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createToggle Attribute-Dlg 
FUNCTION createToggle RETURNS HANDLE
  ( phFrame  AS HANDLE,
    pcLabel  AS CHAR,
    pdRow    AS DEC,
    pdCol    AS DEC) :
/*------------------------------------------------------------------------------
  Purpose:  Create toggle boxes on the scrollable frames  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hToggle AS HANDLE     NO-UNDO.
  
  CREATE TOGGLE-BOX hToggle
    ASSIGN 
      FRAME     = phFrame
      LABEL     = pcLabel 
      HIDDEN    = FALSE
      HEIGHT    = xdScrollToggleHeight
    TRIGGERS: 
      ON 'cursor-down':U     
         PERSISTENT RUN cursorMove IN THIS-PROCEDURE (hToggle,'DOWN':U).
      ON 'cursor-right':U    
         PERSISTENT RUN cursorMove IN THIS-PROCEDURE (hToggle,'DOWN':U).
      ON 'cursor-up':U     
         PERSISTENT RUN cursorMove IN THIS-PROCEDURE (hToggle,'UP':U).
      ON 'cursor-left':U     
         PERSISTENT RUN cursorMove IN THIS-PROCEDURE (hToggle,'UP':U).
    END.
    ASSIGN
      hToggle:COL       = pdCol
      hToggle:ROW       = pdRow  NO-ERROR.
    
    RETURN hToggle.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION disableModifyFrame Attribute-Dlg 
FUNCTION disableModifyFrame RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Disable all toggles on the frame that updates ModifyFields 
    Notes:  
------------------------------------------------------------------------------*/
   
  FOR EACH ttModifyField:
     ttModifyField.toggleHandle:SENSITIVE = FALSE.
  END.

  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION disableObjectFrame Attribute-Dlg 
FUNCTION disableObjectFrame RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Disable all toggles on the frame that updates EnabledObjFldsToDisable    
    Notes:  
------------------------------------------------------------------------------*/
  
  FOR EACH ttEnabledObject:
     ttEnabledObject.toggleHandle:SENSITIVE = FALSE.
  END.

  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION enableModifyFrame Attribute-Dlg 
FUNCTION enableModifyFrame RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Enable all toggles on the frame that updates ModifyFields 
    Notes:  
------------------------------------------------------------------------------*/
   
  FOR EACH ttModifyField:
     ttModifyField.toggleHandle:SENSITIVE = TRUE.
  END.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION enableObjectFrame Attribute-Dlg 
FUNCTION enableObjectFrame RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
   Purpose: Enable all toggles on the frame that updates EnabledObjFldsToDisable    
     Notes:  
------------------------------------------------------------------------------*/
   
  FOR EACH ttEnabledObject:
     ttEnabledObject.toggleHandle:SENSITIVE = TRUE.
  END.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataSource Attribute-Dlg 
FUNCTION getDataSource RETURNS HANDLE
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Retrn the datasource (check updateTarget first)
    Notes:  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cContext AS CHARACTER  NO-UNDO.
 
 RUN adeuib/_uibinfo (?, "HANDLE ":U + STRING(p_hSMO), 
                      "LINK UPDATE-TARGET":U, 
                       OUTPUT cContext). 

 IF cContext = ? OR cContext = '':U  THEN
   RUN adeuib/_uibinfo (?, "HANDLE ":U + STRING(p_hSMO), 
                        "LINK DATA-SOURCE":U, 
                         OUTPUT cContext). 

 IF cContext > '':U THEN
 DO:
   RUN adeuib/_uibinfo (INT(cContext), ?, "PROCEDURE-HANDLE":U,
                        OUTPUT cContext).      
   RETURN  WIDGET-HANDLE(cContext). 
END.

RETURN ?.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initDisableObjects Attribute-Dlg 
FUNCTION initDisableObjects RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Init frame and toggles for EnabledObjFldsToDisable    
    Notes: Called at initialization and on value-changed of radio-set 
------------------------------------------------------------------------------*/
  IF cDisableObjects = "":U THEN
     enableObjectFrame().
  ELSE DO:
    toggleDisableObjects(cDisableObjects = '(all)':U).
    disableObjectFrame().
  END.
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initEnabledObjects Attribute-Dlg 
FUNCTION initEnabledObjects RETURNS LOGICAL
  ( pcEnabledObjects AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: build temp-tables and create toggles from EnabledObjFlds in both 
           frames used for the EnabledObjFldsToDisable and ModifyFields
Paramter - pcEnabledObjects - EnabledObjFlds                  
    Notes: Called at initialization  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE i AS INTEGER    NO-UNDO.
  DO i = 1 TO NUM-ENTRIES(pcEnabledObjects):

    CREATE ttEnabledObject.
    ttEnabledObject.ObjectName = ENTRY(i,pcEnabledObjects).
    ttEnabledObject.ToggleHandle = createToggle
                                  (FRAME frDisabledObjects:HANDLE,
                                   ENTRY(i,pcEnabledObjects),
                                   1 + (xdScrollToggleHeight * (i - 1)),
                                   DEC(1.25)).  
    ttEnabledObject.ToggleHandle:CHECKED = IF LOOKUP(ttEnabledObject.ObjectName,gcDisableObjects) > 0 
                                           THEN TRUE
                                           ELSE FALSE.
  END.
  
  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initModifyFields Attribute-Dlg 
FUNCTION initModifyFields RETURNS LOGICAL
  ( pcEnabledObjects AS CHAR,
    pcEnabledFields AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Build toggle box list for all enabled local fields and data fields 
  Paramters:
    pcEnabledObjects  - enabled objects 
                          (also buttons and stuff that do not belong here)
    pcEnabledFields   - enabled data source fields 
    Notes: References gcModifyFields, which has the list of fields if (Some)
           has been selected.                                  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE i               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hObject         AS HANDLE   NO-UNDO.
  DEFINE VARIABLE cObjectName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTargets        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTarget         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFieldName      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDFFrameList   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDFNameList    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iSDF            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cEnabled        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataSource     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cUpdatable      AS CHARACTER  NO-UNDO.

  cEnabled = TRIM(pcEnabledFields + ',':U + pcEnabledObjects,',':U).

  IF cEnabled = '':U THEN
    RETURN FALSE.

  /* build a list of SDF frames handles and names */
  cTargets = DYNAMIC-FUNCTION("getContainerTarget":U IN p_hSMO).
  DO i = 1 TO NUM-ENTRIES(cTargets):
    ASSIGN
      hTarget      = WIDGET-HANDLE(ENTRY(i,cTargets))
      cFieldname   = ?.

    cFieldName   = {fn getFieldName hTarget} NO-ERROR.
    IF LOOKUP(cFieldName,cEnabled) > 0 THEN
    DO:
      ASSIGN 
        cSDFFrameList = cSDFFrameList 
                        + (IF cSDfFrameList = '':U THEN '':U ELSE ',':U)
                        + {fn getContainerHandle hTarget}
        cSDFNameList   = cSDFNameList 
                        + (IF cSDFNameList = '':U THEN '':U ELSE ',':U) 
                        + cFieldname.
    END.
  END.
  
  hDataSource = getDataSource().
  /* find updatable columns in data source, if no datasource then just assume
     all fields are updatable (this is just for fancy display, it will be 
     resolved correctly at run time anyways)  */
  IF VALID-HANDLE(hdataSource) THEN
  DO:
    cUpdatable = DYNAMIC-FUNCTION('getUpdatableColumns' IN hDataSource). 
    /* give up if different qualification (SBO source and SDO viewer) */
    IF  NUM-ENTRIES(ENTRY(1,cUpdatable),'.':U) 
        <> NUM-ENTRIES(ENTRY(1,pcEnabledFields),'.':U) THEN
      cUpdatable = pcEnabledFields.
  END.

  ELSE  
    cUpdatable = pcEnabledFields.

  /* Walk the widget tree to add a toggle for enabled objects that can be modified  */ 
  {get ContainerHandle hObject p_hSMO}.
  IF VALID-HANDLE(hObject) THEN 
  DO:
    i = 0.
    hObject = hObject:FIRST-CHILD.
    hObject = hObject:FIRST-CHILD.
    DO WHILE VALID-HANDLE(hObject):
      cObjectname = ''.
      IF hObject:TYPE = 'FRAME' THEN
      DO:
        ASSIGN 
          iSDF = LOOKUP(STRING(hObject),cSDFFrameList).
      
        IF iSDF > 0  THEN 
          cObjectName = ENTRY(iSDF,cSDFNameList).
      END.
      ELSE IF CAN-QUERY(hObject,'TABLE':U) THEN 
        cObjectName = (IF hObject:TABLE <> 'RowObject':U AND hObject:TABLE <> ?
                       THEN hObject:TABLE + '.':U 
                       ELSE '')
                    +  hObject:NAME.
   
      IF cObjectName > '' 
      AND (iSDF > 0 OR (LOOKUP('MODIFIED':U,LIST-SET-ATTRS(hObject)) > 0) 
      AND LOOKUP(cObjectName,cEnabled) > 0) THEN
      DO:
        i = i + 1.
        CREATE ttModifyField.
        ASSIGN
          ttModifyField.ObjectName = cObjectName
          ttModifyField.ToggleHandle = createToggle
                                      (FRAME frModifyObjects:HANDLE,
                                       cObjectName,
                                       1 + (xdScrollToggleHeight * (i - 1)),
                                       DEC(1.25))  
          ttModifyField.DataSource = IF LOOKUP(ttModifyField.ObjectName,pcEnabledFields) > 0
                                     THEN TRUE
                                     ELSE FALSE
          ttModifyField.Updatable   = IF LOOKUP(ttModifyField.ObjectName,cUpdatable) > 0
                                      THEN TRUE
                                      ELSE FALSE
          ttModifyField.ToggleHandle:CHECKED = IF LOOKUP(ttModifyField.ObjectName,gcModifyFields) > 0 
                                               THEN TRUE
                                               ELSE FALSE.
      END.
      hObject = hObject:NEXT-SIBLING.
    END.
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initModifyObjects Attribute-Dlg 
FUNCTION initModifyObjects RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Init frame and toggles for ModifyFields    
    Notes: Called at initialization and on value-changed of radio-set 
------------------------------------------------------------------------------*/
  IF cModifyObjects = "":U THEN
     enableModifyFrame().
  ELSE DO:
    toggleModifyObjects(cModifyObjects).
    disableModifyFrame().
  END.
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION toggleDisableObjects Attribute-Dlg 
FUNCTION toggleDisableObjects RETURNS LOGICAL
  ( plON AS LOG  ) :
/*------------------------------------------------------------------------------
  Purpose: Toggle check boxes for EnabledObjFldsToDisable 
    Notes:  
------------------------------------------------------------------------------*/
  FOR EACH ttEnabledObject:
    ASSIGN ToggleHandle:CHECKED = plOn.
  END.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION toggleModifyObjects Attribute-Dlg 
FUNCTION toggleModifyObjects RETURNS LOGICAL
  ( pcChoice AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Toggle check boxes for ModifyFields 
    Notes:  
------------------------------------------------------------------------------*/
  

  FOR EACH ttModifyField:
    ASSIGN 
      ttModifyField.ToggleHandle:CHECKED
                  = IF pcChoice = '(All)':U THEN TRUE
                    ELSE IF pcChoice = '(None)':U 
                         THEN FALSE
                         ELSE IF pcChoice = '(EnabledFields)':U 
                              THEN ttModifyField.DataSource
                              ELSE IF pcChoice = '(Updatable)':U 
                                   THEN ttModifyField.Updatable
                                   ELSE FALSE.
  END.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

