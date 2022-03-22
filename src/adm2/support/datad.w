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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Attribute-Dlg

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 fRowsToBatch fObjectname ~
lToggleDataTargets togPromptOnDelete radFieldList 
&Scoped-Define DISPLAYED-OBJECTS c_AppPartition lShared lCached ~
fRowsToBatch fObjectname radFieldList 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initObjects Attribute-Dlg 
FUNCTION initObjects RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initRowsToBatch Attribute-Dlg 
FUNCTION initRowsToBatch RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD saveCacheDuration Attribute-Dlg 
FUNCTION saveCacheDuration RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD webStateCheck Attribute-Dlg 
FUNCTION webStateCheck RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnDisplayed 
     LABEL "&Edit display field list" 
     SIZE 25 BY 1.14.

DEFINE VARIABLE c_AppPartition AS CHARACTER FORMAT "x(25)" 
     LABEL "&Partition" 
     VIEW-AS COMBO-BOX 
     DROP-DOWN-LIST
     SIZE 40.4 BY 1 NO-UNDO.

DEFINE VARIABLE fObjectname AS CHARACTER FORMAT "X(256)":U 
     LABEL "Instance &name" 
     VIEW-AS FILL-IN 
     SIZE 31 BY 1 NO-UNDO.

DEFINE VARIABLE fRowsToBatch AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
     LABEL "&Rows" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .95 NO-UNDO.

DEFINE VARIABLE iCacheHours AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Hours" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 4.4 BY 1 NO-UNDO.

DEFINE VARIABLE iCacheMinutes AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 4.4 BY 1 NO-UNDO.

DEFINE VARIABLE radFieldList AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "&None", 1,
"A&ll", 2,
"&Select Fields", 3
     SIZE 18 BY 3.1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 51 BY 4.29.

DEFINE VARIABLE ckCurChanged AS LOGICAL INITIAL no 
     LABEL "&Check current changed" 
     VIEW-AS TOGGLE-BOX
     SIZE 31 BY .81 NO-UNDO.

DEFINE VARIABLE DestroyStateless AS LOGICAL INITIAL no 
     LABEL "&Destroy on each stateless request" 
     VIEW-AS TOGGLE-BOX
     SIZE 43.6 BY .81 NO-UNDO.

DEFINE VARIABLE DisconnectAppServer AS LOGICAL INITIAL no 
     LABEL "Disconnect &AppServer on each Web request" 
     VIEW-AS TOGGLE-BOX
     SIZE 49 BY .81 NO-UNDO.

DEFINE VARIABLE lBatch AS LOGICAL INITIAL no 
     LABEL "Read data in &batches of:" 
     VIEW-AS TOGGLE-BOX
     SIZE 28.6 BY .81 TOOLTIP "Check to read data in batches" NO-UNDO.

DEFINE VARIABLE lCached AS LOGICAL INITIAL no 
     LABEL "Cache data" 
     CONTEXT-HELP-ID 0
     VIEW-AS TOGGLE-BOX
     SIZE 15.2 BY .81 NO-UNDO.

DEFINE VARIABLE lOpenOnInit AS LOGICAL INITIAL no 
     LABEL "Open &query on initialization" 
     VIEW-AS TOGGLE-BOX
     SIZE 36.4 BY .81 NO-UNDO.

DEFINE VARIABLE lShared AS LOGICAL INITIAL no 
     LABEL "Share data" 
     CONTEXT-HELP-ID 0
     VIEW-AS TOGGLE-BOX
     SIZE 16.4 BY .81 NO-UNDO.

DEFINE VARIABLE lTimed AS LOGICAL INITIAL no 
     LABEL "Timed cache" 
     CONTEXT-HELP-ID 0
     VIEW-AS TOGGLE-BOX
     SIZE 16.4 BY .81 NO-UNDO.

DEFINE VARIABLE lToggleDataTargets AS LOGICAL INITIAL no 
     LABEL "Activate/deactivate Data&Targets on view/hide" 
     VIEW-AS TOGGLE-BOX
     SIZE 49.2 BY .81 NO-UNDO.

DEFINE VARIABLE lUpdateFromSource AS LOGICAL INITIAL no 
     LABEL "&Update from DataSource (one-to-one)" 
     VIEW-AS TOGGLE-BOX
     SIZE 39.2 BY .81 NO-UNDO.

DEFINE VARIABLE RebuildOnRepos AS LOGICAL INITIAL no 
     LABEL "Rebuild dataset &on reposition" 
     VIEW-AS TOGGLE-BOX
     SIZE 33 BY .81 NO-UNDO.

DEFINE VARIABLE ServerOperatingMode AS LOGICAL INITIAL no 
     LABEL "&Force to stateful operating mode" 
     VIEW-AS TOGGLE-BOX
     SIZE 36 BY .81 NO-UNDO.

DEFINE VARIABLE togPromptOnDelete AS LOGICAL INITIAL no 
     LABEL "&Prompt on delete" 
     VIEW-AS TOGGLE-BOX
     SIZE 23.6 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Attribute-Dlg
     c_AppPartition AT ROW 1.43 COL 9.6 COLON-ALIGNED
     lBatch AT ROW 2.91 COL 11.6
     RebuildOnRepos AT ROW 3.91 COL 11.6
     lOpenOnInit AT ROW 4.91 COL 11.6
     lShared AT ROW 5.91 COL 11.6
     lCached AT ROW 6.91 COL 11.6
     lTimed AT ROW 7.91 COL 14.6
     ServerOperatingMode AT ROW 8.91 COL 11.6
     DestroyStateless AT ROW 9.91 COL 11.6
     DisconnectAppServer AT ROW 10.91 COL 11.6
     fRowsToBatch AT ROW 2.76 COL 38.6 COLON-ALIGNED
     iCacheHours AT ROW 7.76 COL 38.6 COLON-ALIGNED
     iCacheMinutes AT ROW 7.76 COL 44.8 COLON-ALIGNED
     fObjectname AT ROW 1.43 COL 74.8 COLON-ALIGNED
     ckCurChanged AT ROW 2.91 COL 76.6
     lUpdateFromSource AT ROW 3.91 COL 76.6
     lToggleDataTargets AT ROW 4.91 COL 76.6
     togPromptOnDelete AT ROW 5.91 COL 76.6
     radFieldList AT ROW 8 COL 77.2 NO-LABEL
     btnDisplayed AT ROW 10 COL 96.6
     "Display fields for prompt" VIEW-AS TEXT
          SIZE 23.2 BY .62 AT ROW 6.95 COL 76.6
     RECT-1 AT ROW 7.24 COL 74.2
     SPACE(0.60) SKIP(0.60)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "SmartDataObject Properties":L.


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
   FRAME-NAME L-To-R,COLUMNS                                            */
ASSIGN 
       FRAME Attribute-Dlg:SCROLLABLE       = FALSE
       FRAME Attribute-Dlg:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON btnDisplayed IN FRAME Attribute-Dlg
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX ckCurChanged IN FRAME Attribute-Dlg
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR COMBO-BOX c_AppPartition IN FRAME Attribute-Dlg
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX DestroyStateless IN FRAME Attribute-Dlg
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX DisconnectAppServer IN FRAME Attribute-Dlg
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN iCacheHours IN FRAME Attribute-Dlg
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN iCacheMinutes IN FRAME Attribute-Dlg
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX lBatch IN FRAME Attribute-Dlg
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX lCached IN FRAME Attribute-Dlg
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX lOpenOnInit IN FRAME Attribute-Dlg
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX lShared IN FRAME Attribute-Dlg
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX lTimed IN FRAME Attribute-Dlg
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX lToggleDataTargets IN FRAME Attribute-Dlg
   NO-DISPLAY                                                           */
/* SETTINGS FOR TOGGLE-BOX lUpdateFromSource IN FRAME Attribute-Dlg
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX RebuildOnRepos IN FRAME Attribute-Dlg
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX ServerOperatingMode IN FRAME Attribute-Dlg
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
ON GO OF FRAME Attribute-Dlg /* SmartDataObject Properties */
DO:
    
  ASSIGN
    saveAppPartition = IF c_AppPartition:SCREEN-VALUE = noPartition 
                       THEN "":U
                       ELSE c_AppPartition:SCREEN-VALUE.
  /* Check web properties and give warning about bad (locked) choice */
  IF web AND NOT webStateCheck() THEN
      RETURN NO-APPLY.
  /* Put the attributes back into the SmartObject. */
  DYNAMIC-FUNCTION("setAppService":U IN p_hSMO, 
                            saveAppPartition).
  DYNAMIC-FUNCTION("setRowsToBatch":U IN p_hSMO,
                    INT(fRowsToBatch:SCREEN-VALUE)).
  DYNAMIC-FUNCTION("setCheckCurrentChanged":U IN p_hSMO,
                    ckCurChanged:CHECKED).
  DYNAMIC-FUNCTION("setRebuildOnRepos":U IN p_hSMO,
                    RebuildOnRepos:CHECKED).
  
  /* giCacheduration is assigned in saveCacheDuration() called on 
     valueChanged of iCacheHours and iCacheMinutes, so deal with the
     non-timed cases: 0 if no-cache, else ? if not timed  */
  IF NOT lCached:CHECKED THEN giCacheDuration = 0.
  ELSE IF NOT lTimed:CHECKED OR (lTimed:CHECKED AND giCacheDuration = 0) 
       THEN giCacheduration = -1. 

  DYNAMIC-FUNCTION("setCacheDuration":U IN p_hSMO,giCacheDuration).

  DYNAMIC-FUNCTION("setShareData":U IN p_hSMO,lShared:CHECKED).

  DYNAMIC-FUNCTION("setOpenOnInit":U IN p_hSMO,
                    lOpenOnInit:CHECKED).
  DYNAMIC-FUNCTION("setServerOperatingMode":U IN p_hSMO,
                    IF ServerOperatingMode:CHECKED THEN "STATE-RESET"
                                                   ELSE "NONE").
  DYNAMIC-FUNCTION("setDestroyStateless":U IN p_hSMO,
                    DestroyStateless:CHECKED).
  DYNAMIC-FUNCTION("setDisconnectAppServer":U IN p_hSMO,
                    DisconnectAppServer:CHECKED).
  DYNAMIC-FUNCTION("setObjectname":U IN p_hSMO, fObjectName:SCREEN-VALUE).
  DYNAMIC-FUNCTION("setUpdateFromSource":U IN p_hSMO, lUpdateFromSource:SCREEN-VALUE).
  DYNAMIC-FUNCTION("setToggleDataTargets":U IN p_hSMO,lToggleDataTargets:CHECKED).

  DYNAMIC-FUNCTION("setPromptOnDelete":U IN p_hSMO,
                    togPromptOnDelete:CHECKED).
  gcPromptColumns = (IF radFieldList = 1 THEN
                       '(NONE)':U
                     ELSE IF radFieldList = 2 THEN
                       '(ALL)':U 
                     ELSE
                       gcPromptColumns
                    ).
  DYNAMIC-FUNCTION("setPromptColumns":U IN p_hSMO,
                   gcPromptColumns).


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Attribute-Dlg Attribute-Dlg
ON WINDOW-CLOSE OF FRAME Attribute-Dlg /* SmartDataObject Properties */
DO:
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnDisplayed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnDisplayed Attribute-Dlg
ON CHOOSE OF btnDisplayed IN FRAME Attribute-Dlg /* Edit display field list */
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


&Scoped-define SELF-NAME c_AppPartition
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c_AppPartition Attribute-Dlg
ON VALUE-CHANGED OF c_AppPartition IN FRAME Attribute-Dlg /* Partition */
DO:
  initObjects().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DestroyStateless
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DestroyStateless Attribute-Dlg
ON VALUE-CHANGED OF DestroyStateless IN FRAME Attribute-Dlg /* Destroy on each stateless request */
DO:
  initObjects().       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fRowsToBatch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fRowsToBatch Attribute-Dlg
ON LEAVE OF fRowsToBatch IN FRAME Attribute-Dlg /* Rows */
DO:
  ASSIGN fRowsTobatch.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME iCacheHours
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL iCacheHours Attribute-Dlg
ON VALUE-CHANGED OF iCacheHours IN FRAME Attribute-Dlg /* Hours */
DO:
  saveCacheDuration().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME iCacheMinutes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL iCacheMinutes Attribute-Dlg
ON VALUE-CHANGED OF iCacheMinutes IN FRAME Attribute-Dlg
DO:
  saveCacheDuration().
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
  initObjects().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lCached
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lCached Attribute-Dlg
ON VALUE-CHANGED OF lCached IN FRAME Attribute-Dlg /* Cache data */
DO:
  ASSIGN lCached.
  initObjects().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lOpenOnInit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lOpenOnInit Attribute-Dlg
ON VALUE-CHANGED OF lOpenOnInit IN FRAME Attribute-Dlg /* Open query on initialization */
DO:
   initObjects().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lShared
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lShared Attribute-Dlg
ON VALUE-CHANGED OF lShared IN FRAME Attribute-Dlg /* Share data */
DO:
  ASSIGN lShared. 
  initObjects().       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lTimed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lTimed Attribute-Dlg
ON VALUE-CHANGED OF lTimed IN FRAME Attribute-Dlg /* Timed cache */
DO:
  ASSIGN lTimed.
  initObjects().

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lUpdateFromSource
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lUpdateFromSource Attribute-Dlg
ON VALUE-CHANGED OF lUpdateFromSource IN FRAME Attribute-Dlg /* Update from DataSource (one-to-one) */
DO:
  IF SELF:CHECKED THEN
    lBatch:CHECKED = FALSE.
  ELSE
    lBatch:CHECKED = lbatch.
  
  lBatch:SENSITIVE = NOT SELF:CHECKED.

  initRowsToBatch().
   
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


&Scoped-define SELF-NAME RebuildOnRepos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RebuildOnRepos Attribute-Dlg
ON VALUE-CHANGED OF RebuildOnRepos IN FRAME Attribute-Dlg /* Rebuild dataset on reposition */
DO:
  ASSIGN RebuildOnRepos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ServerOperatingMode
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ServerOperatingMode Attribute-Dlg
ON VALUE-CHANGED OF ServerOperatingMode IN FRAME Attribute-Dlg /* Force to stateful operating mode */
DO:
  ASSIGN serveroperatingMode.
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
                   &CONTEXT = {&SmartDataObject_Attributes_Dlg_Box} }

/* ***************************  Main Block  *************************** */

/* Get procedure type */
RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "TYPE":U, OUTPUT cObjType).
web = cObjType BEGINS "WEB":U.

/* Get the user property, to show whether or not a SDO is on a SBO or not,
   so that this property sheet can disable/enablefields acordingly       */
IF {fnarg getUserProperty '"ContainerObject"' p_hSMO} = "SmartBusinessObject":U THEN
  ASSIGN cObjtype = "SmartBusinessObject":U.

/* disallow ? in time fields */
ON '?':U OF iCacheMinutes, iCachehours
DO:
  BELL.
  RETURN NO-APPLY.
END.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
   
  /* Get the values of the attributes in the SmartObject that can be 
     changed in this dialog-box. */
  RUN get-SmO-attributes.
  /* Enable the interface. */         
  RUN enable_UI.
  
  /* Set the cursor */
  RUN adecomm/_setcurs.p ("":U).
 
  WAIT-FOR GO OF FRAME {&FRAME-NAME} FOCUS c_appPartition.  

END.
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
  DISPLAY c_AppPartition lShared lCached fRowsToBatch fObjectname radFieldList 
      WITH FRAME Attribute-Dlg.
  ENABLE RECT-1 fRowsToBatch fObjectname lToggleDataTargets togPromptOnDelete 
         radFieldList 
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
  
  DO WITH FRAME Attribute-Dlg:
    
    /********* Application Partition *********/
    /* 
     * Get the application Partition from the object, if none defined, set to (None)
     * Get the list of defined application Partitions, add (None) to the list
     * Add the object application Partition to the list if not already there
     * Set the application Partition screen-value to the given app Partition
     */
    ASSIGN c_AppPartition:DELIMITER = CHR(3)
           appPartition = IF cObjType BEGINS "SmartBusinessObject":U 
                          THEN noPartition 
                          ELSE dynamic-function("getAppService" IN p_hSMO) NO-ERROR.
    ASSIGN PartitionChosen = IF ERROR-STATUS:ERROR 
                             OR appPartition = "":U  
                             OR appPartition = ? 
                             THEN noPartition
                             ELSE appPartition.
  
    /* Check to see if adecomm/ad-utils.w is running. If it is then query the
     * it to get the list of defined Application Partitions */
    IF VALID-HANDLE(AppSrvUtils) THEN
    DO:
       ASSIGN 
          definedAppPartition = 
              dynamic-function("definedPartitions" IN AppSrvUtils) NO-ERROR.
          c_AppPartition:LIST-ITEMS  = IF ERROR-STATUS:ERROR    OR 
                                        definedAppPartition = ? OR 
                                        definedAppPartition = "":U
                                       THEN noPartition
                                       ELSE noPartition + CHR(3) + definedAppPartition.
    END.
  
    IF NOT CAN-DO(REPLACE(noPartition + CHR(3) + definedAppPartition,CHR(3),",":U),
                  appPartition) THEN
       ASSIGN c_AppPartition:SORT = TRUE
              ldummy              = c_AppPartition:ADD-FIRST (appPartition).
  
    ASSIGN 
      c_AppPartition:SENSITIVE    = NOT (cObjType BEGINS "SmartBusinessObject":U)
      c_AppPartition:SCREEN-VALUE = PartitionChosen.

    /********* Rows To Batch *********/
    fRowsToBatch:SCREEN-VALUE    = DYNAMIC-FUNCTION("getRowsToBatch":U IN p_hSMO).
    ASSIGN fRowsToBatch           = INTEGER(fRowsToBatch:SCREEN-VALUE)
           fRowsToBatch:SENSITIVE = TRUE
           lBatch:CHECKED         = fRowsToBatch <> 0. /* initRowsToBatch takes care of the rest*/

    /********* Check Current Changed *********/
    ckCurChanged:SCREEN-VALUE = DYNAMIC-FUNCTION("getCheckCurrentChanged":U IN p_hSMO).
    ASSIGN ckCurChanged           = ckCurChanged:CHECKED
           ckCurChanged:SENSITIVE = TRUE.

    /* RebuildOnRepos *******************/
    RebuildOnRepos = DYNAMIC-FUNCTION("getRebuildOnRepos":U IN p_hSMO).
    
    /* OpenOnInit *******************/
    lOpenOnInit:SCREEN-VALUE = DYNAMIC-FUNCTION("getOpenOnInit":U IN p_hSMO).
    ASSIGN lOpenOnInit:SENSITIVE = NOT (cObjType BEGINS "SmartBusinessObject":U).
 
    /* UpdateFromSource *******************/
    lUpdateFromSource:SCREEN-VALUE = DYNAMIC-FUNCTION("getUpdateFromSource":U IN p_hSMO).
    ASSIGN lUpdateFromSource:SENSITIVE = cObjType BEGINS "SmartBusinessObject":U .
          
    /* Server Operating Mode  *******************/
    cOpMode = DYNAMIC-FUNCTION("getServerOperatingMode":U IN p_hSMO). 
    ASSIGN ServerOperatingMode:CHECKED   = cOpMode EQ "STATE-RESET":U
           ServerOperatingMode:SENSITIVE = TRUE.
    /* Destroy Stateless */
    ASSIGN DestroyStateless:CHECKED = DYNAMIC-FUNCTION("getDestroyStateless":U IN p_hSMO).
    
    /* ToggleDataTargets */
    ASSIGN lToggleDataTargets:CHECKED = DYNAMIC-FUNCTION("getToggleDataTargets":U IN p_hSMO).
   
    /* UpdateFromSource *******************/
    lUpdateFromSource:SCREEN-VALUE = DYNAMIC-FUNCTION("getUpdateFromSource":U IN p_hSMO).
    ASSIGN lUpdateFromSource:SENSITIVE = cObjType BEGINS "SmartBusinessObject":U .

     /* ObjectNeme */
    ASSIGN fObjectName = DYNAMIC-FUNCTION('getObjectName':U IN p_hSMO).
   
    /* ShareData Cacheduration (screen updated in initObjects) */ 
    ASSIGN
      glDynamicdata      = {fn getDynamicData p_hSMO}
      glhasForeignFields = {fn getForeignFields p_hSMO} <> ''
      lShared            = {fn getShareData p_hSMO}
      giCacheDuration    = {fn getCacheDuration p_hSMO}
      lTimed             = giCacheDuration > 0 AND giCacheDuration <> ?
      lCached            = giCacheDuration <> 0.
    
    /* Set to 0 in order to display as 0 if check-boxes changes */
    IF giCacheduration = ? OR giCacheduration < 0 THEN giCacheduration = 0. 
    
    initRowsToBatch().
    initObjects().    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initObjects Attribute-Dlg 
FUNCTION initObjects RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: set check boxes sensitivity according to the object type   
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
      ckCurChanged:SENSITIVE        = NOT web
      ckCurChanged:CHECKED          = IF web 
                                      THEN FALSE 
                                      ELSE ckCurChanged:CHECKED 
      destroyStateless:SENSITIVE    = web
      disconnectAppServer:SENSITIVE = web AND NOT destroyStateless:CHECKED   
                                      AND 
                                      c_AppPartition:SCREEN-VALUE <> noPartition
      lBatch:SENSITIVE              = lUpdateFromSource:CHECKED = FALSE
      RebuildOnRepos:SENSITIVE      = lBatch:CHECKED
      RebuildOnRepos:CHECKED        = RebuildOnRepos AND lBatch:CHECKED
      lShared:SENSITIVE             = (c_AppPartition:SCREEN-VALUE <> noPartition
                                       OR cObjType BEGINS "SmartBusinessObject":U)
                                      AND glDynamicData
                                      AND lBatch:CHECKED = FALSE 
                                      AND lUpdateFromSource:CHECKED = FALSE
                                      AND glhasForeignFields = FALSE
                                      AND lOpenOnInit:CHECKED = TRUE
      lShared:CHECKED               = lShared AND lShared:SENSITIVE
      lCached:SENSITIVE             = (c_AppPartition:SCREEN-VALUE <> noPartition
                                       OR cObjType BEGINS "SmartBusinessObject":U)
                                      AND lBatch:CHECKED = FALSE 
                                      AND lUpdateFromSource:CHECKED = FALSE
                                      AND glhasForeignFields = FALSE
      lCached:CHECKED               = lCached AND lCached:SENSITIVE
      lTimed:SENSITIVE              = lCached:SENSITIVE AND lCached:CHECKED 
                                               /* init true if giCacheduration > 0 
                                                  or changed by user */
      lTimed:CHECKED                = lCached:CHECKED AND lTimed:SENSITIVE 
                                      AND lTimed  

      iCachehours:SENSITIVE         = lTimed:SENSITIVE AND lTimed:CHECKED
      iCacheMinutes:SENSITIVE       = iCachehours:SENSITIVE
      iCacheHours:FORMAT            = IF lTimed:CHECKED THEN '99' ELSE 'zz'
      iCacheMinutes:FORMAT          = iCacheHours:FORMAT
      iCacheHours:SCREEN-VALUE      = IF lTimed:CHECKED 
                                      THEN STRING((giCacheduration - giCacheDuration MODULO 3600) / 3600)
                                      ELSE '0'  
      iCacheMinutes:SCREEN-VALUE    = IF lTimed:CHECKED 
                                      THEN STRING((giCacheDuration - (iCacheHours:INPUT-VALUE * 3600)) / 60)
                                      ELSE '0' 
      serverOperatingMode:SENSITIVE = c_AppPartition:SCREEN-VALUE <> noPartition 
                                      AND NOT lshared:CHECKED 
                                      AND NOT lCached:CHECKED
      serverOperatingMode:CHECKED   = serverOperatingMode:SENSITIVE AND serveroperatingMode:CHECKED 
      .
 
  END.
  RETURN TRUE.
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION saveCacheDuration Attribute-Dlg 
FUNCTION saveCacheDuration RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      iCacheHours
      iCacheMinutes
      giCacheDuration = (iCacheHours * 3600) + (iCacheMinutes * 60). 

  END.

  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION webStateCheck Attribute-Dlg 
FUNCTION webStateCheck RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Give warning if user has selected options that locks the AppServer  
    Notes:  
------------------------------------------------------------------------------*/
 DO WITH FRAME {&FRAME-NAME}:
  IF  ServerOperatingMode:CHECKED 
  AND NOT DestroyStateless:CHECKED 
  AND NOT DisconnectAppServer:CHECKED THEN 
  DO:
    MESSAGE 
  "Setting Force to Stateful without setting Disconnect or Destroy on each Web Request" SKIP
  "will lock the AppServer agent to WebSpeed for the whole session." 
             SKIP(1)
  "Do you want to keep these settings?"
    VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE lOk AS LOG.    
  END.
  ELSE lok = TRUE.
 END. /* do with frame */

 RETURN lok.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

