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
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: rydynprf2v.w

  Description:  Preferences Viewer 2

  Purpose:      Preferences Viewer 2

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        6179   UserRef:    
                Date:   28/06/2000  Author:     Anthony Swindells

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

&scop object-name       rydynprf2v.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartObject yes

{af/sup2/afglobals.i}

DEFINE VARIABLE glModified                  AS LOGICAL INITIAL NO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS raSaveSetting raViewingOptions imMulti ~
imSingle 
&Scoped-Define DISPLAYED-OBJECTS raSaveSetting raViewingOptions ~
txMultiWindow txExample1 txSingleWindow txExample2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE txExample1 AS CHARACTER FORMAT "X(256)":U INITIAL "Example:" 
      VIEW-AS TEXT 
     SIZE 15.6 BY .62 NO-UNDO.

DEFINE VARIABLE txExample2 AS CHARACTER FORMAT "X(256)":U INITIAL "Example:" 
      VIEW-AS TEXT 
     SIZE 15.6 BY .62 NO-UNDO.

DEFINE VARIABLE txMultiWindow AS CHARACTER FORMAT "X(256)":U INITIAL "Browse records using a separa&te window for each record" 
      VIEW-AS TEXT 
     SIZE 56.8 BY .62 NO-UNDO.

DEFINE VARIABLE txSingleWindow AS CHARACTER FORMAT "X(256)":U INITIAL "Browse records using a si&ngle window for each record" 
      VIEW-AS TEXT 
     SIZE 56.8 BY .62 NO-UNDO.

DEFINE IMAGE imMulti
     FILENAME "ry/img/afmultwind.gif":U
     SIZE 7.2 BY 1.91.

DEFINE IMAGE imSingle
     FILENAME "ry/img/afsingwind.gif":U
     SIZE 6.8 BY 1.43.

DEFINE VARIABLE raSaveSetting AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Save per &session", "SES",
"Save &permanently", "PER"
     SIZE 53.2 BY .95 NO-UNDO.

DEFINE VARIABLE raViewingOptions AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "&t":U, "NO":U,
"&n", "YES":U
     SIZE 3.2 BY 6.14 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     raSaveSetting AT ROW 1.38 COL 11.4 NO-LABEL
     raViewingOptions AT ROW 2.43 COL 11.2 NO-LABEL
     txMultiWindow AT ROW 3.57 COL 13.2 COLON-ALIGNED NO-LABEL
     txExample1 AT ROW 5.14 COL 24.2 COLON-ALIGNED NO-LABEL
     txSingleWindow AT ROW 6.67 COL 13 COLON-ALIGNED NO-LABEL
     txExample2 AT ROW 7.86 COL 24.2 COLON-ALIGNED NO-LABEL
     imMulti AT ROW 4.67 COL 44.2
     imSingle AT ROW 7.48 COL 44.2
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
         HEIGHT             = 9.76
         WIDTH              = 76.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB sObject 
/* ************************* Included-Libraries *********************** */

{src/adm2/datavis.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW sObject
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN txExample1 IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txExample2 IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txMultiWindow IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txSingleWindow IN FRAME frMain
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

&Scoped-define SELF-NAME raViewingOptions
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL raViewingOptions sObject
ON VALUE-CHANGED OF raViewingOptions IN FRAME frMain
DO:
  RUN valueChanged.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK sObject 


/* ***************************  Main Block  *************************** */

/* If testing in the UIB, initialize the SmartObject. */  
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
  RUN initializeObject.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject sObject 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */


  /* Code placed here will execute AFTER standard behavior.    */
  DEFINE VARIABLE cLinkHandles              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainerSource          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hToolbarSource            AS HANDLE     NO-UNDO.

  /* Get handle of container, then get toolbar source of contaner which will give
     us the containers toolbar.
     We subscribe the container toolbar to update states in this procedure so we
     can change the state of the toolbar into update mode when something is changed
     on the viewer.
  */

  DISPLAY
    txExample1 txExample2 txMultiWindow txSingleWindow
    WITH FRAME {&FRAME-NAME}.

  /* Get current values and display them */
  DEFINE VARIABLE rRowid                AS ROWID      NO-UNDO.
  DEFINE VARIABLE cProfileData          AS CHARACTER  NO-UNDO.

  RUN getProfileData IN gshProfileManager (INPUT "Window":U,
                                           INPUT "OneWindow":U,
                                           INPUT "OneWindow":U,
                                           INPUT NO,
                                           INPUT-OUTPUT rRowid,
                                           OUTPUT cProfileData).
  ASSIGN
    raViewingOptions:SCREEN-VALUE = cProfileData.
    raSaveSetting:SCREEN-VALUE = "SES":U.

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRecord sObject 
PROCEDURE updateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Run when ok pressed in toolbar (from 1st viewer)
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE lOneWindow AS LOGICAL    NO-UNDO.
DEFINE VARIABLE hWindow    AS HANDLE     NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
  RUN setProfileData IN gshProfileManager (INPUT "Window":U,
                                           INPUT "OneWindow":U,
                                           INPUT "OneWindow":U,
                                           INPUT ?,
                                           INPUT raViewingOptions:SCREEN-VALUE,
                                           INPUT NO,
                                           INPUT raSaveSetting:SCREEN-VALUE).
  {set DataModified FALSE}. 

END.

/* Propogate the attribute to all windows */
IF raViewingOptions:SCREEN-VALUE = "YES":U
THEN lOneWindow = NO.
ELSE lOneWindow = YES.
 /* Loop through all procedures and set the attribute */
hWindow = SESSION:FIRST-PROCEDURE.
DO WHILE VALID-HANDLE(hWindow):
  IF hWindow:FILE-NAME <> "adm2/containr.p":U THEN 
   DYNAMIC-FUNCTION("setMultiInstanceActivated":U IN hWindow,lOneWindow) NO-ERROR.
 hWindow = hWindow:NEXT-SIBLING.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valueChanged sObject 
PROCEDURE valueChanged :
/*------------------------------------------------------------------------------
  Purpose:     Procedure fired on value changed of any of the widgets on the viewer
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF NOT glModified THEN
  DO:
      glModified = TRUE.
      {set dataModified TRUE}.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

