&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Attribute-Dlg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Attribute-Dlg 
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Attribute-Dlg

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS radFieldList fObjectname fRowsToBatch ~
RebuildOnRepos lToggleDataTargets togPromptOnDelete RECT-1 
&Scoped-Define DISPLAYED-OBJECTS radFieldList fObjectname c_AppPartition ~
fRowsToBatch 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD webStateCheck Attribute-Dlg 
FUNCTION webStateCheck RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnDisplayed 
     LABEL "&Edit Display Field List" 
     SIZE 25 BY 1.14.

DEFINE VARIABLE c_AppPartition AS CHARACTER FORMAT "x(23)" 
     LABEL "&Partition" 
     VIEW-AS COMBO-BOX 
     DROP-DOWN-LIST
     SIZE 27.8 BY 1 NO-UNDO.

DEFINE VARIABLE fObjectname AS CHARACTER FORMAT "X(256)":U 
     LABEL "Instance &Name" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE fRowsToBatch AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
     LABEL "&Rows" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .95 NO-UNDO.

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

DEFINE VARIABLE lOpenOnInit AS LOGICAL INITIAL no 
     LABEL "Open &query on initialization" 
     VIEW-AS TOGGLE-BOX
     SIZE 36.4 BY .81 NO-UNDO.

DEFINE VARIABLE lToggleDataTargets AS LOGICAL INITIAL no 
     LABEL "Activate/deactivate Data&Targets on view/hide" 
     VIEW-AS TOGGLE-BOX
     SIZE 54.4 BY .81 NO-UNDO.

DEFINE VARIABLE lUpdateFromSource AS LOGICAL INITIAL no 
     LABEL "&Update from DataSource (one-to-one)" 
     VIEW-AS TOGGLE-BOX
     SIZE 49.6 BY .81 NO-UNDO.

DEFINE VARIABLE RebuildOnRepos AS LOGICAL INITIAL no 
     LABEL "Rebuild dataset &on reposition" 
     VIEW-AS TOGGLE-BOX
     SIZE 33 BY .81 NO-UNDO.

DEFINE VARIABLE ServerOperatingMode AS LOGICAL INITIAL no 
     LABEL "&Force to stateful operating mode" 
     VIEW-AS TOGGLE-BOX
     SIZE 36 BY .81 NO-UNDO.

DEFINE VARIABLE togPromptOnDelete AS LOGICAL INITIAL no 
     LABEL "&Prompt On Delete" 
     VIEW-AS TOGGLE-BOX
     SIZE 23.6 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Attribute-Dlg
     radFieldList AT ROW 16.29 COL 20 NO-LABEL
     fObjectname AT ROW 1.38 COL 17.4 COLON-ALIGNED
     c_AppPartition AT ROW 2.67 COL 17.4 COLON-ALIGNED
     lBatch AT ROW 4.1 COL 19.4
     fRowsToBatch AT ROW 3.95 COL 46.2 COLON-ALIGNED
     ckCurChanged AT ROW 5.19 COL 19.4
     RebuildOnRepos AT ROW 6.29 COL 19.4
     lOpenOnInit AT ROW 7.38 COL 19.4
     lUpdateFromSource AT ROW 8.43 COL 19.4
     ServerOperatingMode AT ROW 9.52 COL 19.4
     DestroyStateless AT ROW 10.62 COL 19.4
     DisconnectAppServer AT ROW 11.76 COL 19.4
     lToggleDataTargets AT ROW 12.81 COL 19.4
     btnDisplayed AT ROW 18.29 COL 39.4
     togPromptOnDelete AT ROW 14 COL 19.4
     RECT-1 AT ROW 15.52 COL 17
     "Display Fields for Prompt" VIEW-AS TEXT
          SIZE 25 BY .62 AT ROW 15.29 COL 20
     SPACE(32.79) SKIP(3.90)
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
   Custom                                                               */
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
/* SETTINGS FOR TOGGLE-BOX lBatch IN FRAME Attribute-Dlg
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX lOpenOnInit IN FRAME Attribute-Dlg
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX lToggleDataTargets IN FRAME Attribute-Dlg
   NO-DISPLAY                                                           */
/* SETTINGS FOR TOGGLE-BOX lUpdateFromSource IN FRAME Attribute-Dlg
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX RebuildOnRepos IN FRAME Attribute-Dlg
   NO-DISPLAY                                                           */
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
  DYNAMIC-FUNCTION("setToggleDataTargets":U IN p_hSMO,
                    lToggleDataTargets:CHECKED).

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
ON CHOOSE OF btnDisplayed IN FRAME Attribute-Dlg /* Edit Display Field List */
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
  DISPLAY radFieldList fObjectname c_AppPartition fRowsToBatch 
      WITH FRAME Attribute-Dlg.
  ENABLE radFieldList fObjectname fRowsToBatch RebuildOnRepos 
         lToggleDataTargets togPromptOnDelete RECT-1 
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
  DEF VAR cObjType            AS CHARACTER  NO-UNDO.
  DO WITH FRAME Attribute-Dlg:
    
    /* Get desing window procedure type */
    RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "TYPE":U, OUTPUT cObjtype).
    
    /* Get the user property, to show whether or not a SDO is on a SBO or not,
       so that this property sheet can disable/enablefields acordingly       */
    IF {fnarg getUserProperty '"ContainerObject"' p_hSMO} = "SmartBusinessObject":U
    THEN
      ASSIGN cObjtype = "SmartBusinessObject":U.
      
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
    RebuildOnRepos:SCREEN-VALUE = DYNAMIC-FUNCTION("getRebuildOnRepos":U IN p_hSMO).
    ASSIGN RebuildOnRepos:SENSITIVE = TRUE.
    
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
    initRowsToBatch().
    initObjects().    
    ASSIGN lBatch = lBatch:CHECKED.

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
      serverOperatingMode:SENSITIVE = c_AppPartition:SCREEN-VALUE <> noPartition 
      destroyStateless:SENSITIVE    = web
      disconnectAppServer:SENSITIVE = web AND NOT destroyStateless:CHECKED   
                                      AND 
                                      c_AppPartition:SCREEN-VALUE <> noPartition
      lBatch:SENSITIVE              = lUpdateFromSource:CHECKED = FALSE
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
           and this is also called form the trigger     
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
  "Do you want to keep this properties?"
    VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE lOk AS LOG.    
  END.
  ELSE lok = TRUE.
 END. /* do with frame */

 RETURN lok.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

