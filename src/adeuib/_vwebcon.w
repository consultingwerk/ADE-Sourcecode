&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*********************************************************************
* Copyright (C) 2000,2013 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
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
{ adeuib/sharvars.i }

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS web-browser Btn_Browse broker Btn_Test ~
Open-Browse 
&Scoped-Define DISPLAYED-OBJECTS web-browser broker Open-Browse 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for OCX Containers                            */
DEFINE VARIABLE CtrlFrame AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chCtrlFrame AS COMPONENT-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Browse 
     LABEL "&Browse..." 
     SIZE 15 BY 1.14 TOOLTIP "Search file-system for a Web browser executable".

DEFINE BUTTON Btn_Test 
     LABEL "&Test" 
     SIZE 15 BY 1.14 TOOLTIP "Run a test to be sure that the broker is properly specified".

DEFINE VARIABLE broker AS CHARACTER FORMAT "X(256)":U 
     LABEL "Broker U&RL" 
     VIEW-AS FILL-IN 
     SIZE 36 BY 1 TOOLTIP "Remote broker URL to be used in this application" NO-UNDO.

DEFINE VARIABLE web-browser AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Web Browser" 
     VIEW-AS FILL-IN 
     SIZE 36 BY 1 TOOLTIP "Default Web Browser executable" NO-UNDO.

DEFINE VARIABLE Open-Browse AS LOGICAL INITIAL no 
     LABEL "&Open new browser window for each Web-based Run" 
     VIEW-AS TOGGLE-BOX
     SIZE 62 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     web-browser AT ROW 1.95 COL 16 COLON-ALIGNED
     Btn_Browse AT ROW 1.95 COL 55
     broker AT ROW 3.38 COL 16 COLON-ALIGNED
     Btn_Test AT ROW 3.38 COL 55
     Open-Browse AT ROW 4.81 COL 5
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 7.52
         WIDTH              = 72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm2/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

/* OCX BINARY:FILENAME is: adeuib\_vwebcon.wrx */

CREATE CONTROL-FRAME CtrlFrame ASSIGN
       FRAME        = FRAME F-Main:HANDLE
       ROW          = 4.5
       COLUMN       = 62
       HEIGHT       = 1
       WIDTH        = 6
       HIDDEN       = no
       SENSITIVE    = yes.

PROCEDURE adm-create-controls:
      CtrlFrame:NAME = "CtrlFrame":U .
/* CtrlFrame OCXINFO:CREATE-CONTROL from: {DE90AEA3-1461-11CF-858F-0080C7973784} type: CIHTTP */
      CtrlFrame:MOVE-AFTER(Open-Browse:HANDLE IN FRAME F-Main).

END PROCEDURE.

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Btn_Browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Browse V-table-Win
ON CHOOSE OF Btn_Browse IN FRAME F-Main /* Browse... */
DO:
  DEFINE VARIABLE f-name AS CHARACTER NO-UNDO.
  DEFINE VARIABLE ans    AS LOGICAL   NO-UNDO.

  f-name = web-browser:SCREEN-VALUE.
  
  /* Select web browser of choice. */
  SYSTEM-DIALOG GET-FILE f-name
     TITLE     "Select Web Browser"
     FILTERS   "Executable(*.exe)"  "*.exe",
               "All Files(*.*)"     "*.*"
     MUST-EXIST USE-FILENAME
     UPDATE ans IN WINDOW ACTIVE-WINDOW.

  IF ans AND f-name <> "" THEN
    web-browser:SCREEN-VALUE = f-name.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Test
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Test V-table-Win
ON CHOOSE OF Btn_Test IN FRAME F-Main /* Test */
DO:
  RUN validate_browser.
  IF RETURN-VALUE eq "Error":U THEN
    RETURN NO-APPLY.
    
  IF broker:SCREEN-VALUE eq "" THEN DO:
    MESSAGE "A Broker URL has not been defined."
      VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  
  DO WITH FRAME {&FRAME-NAME}:
    IF PROCESS-ARCHITECTURE = 32 THEN DO:
        /* If user did not specify full URL, make one. */
        ASSIGN
          chCtrlFrame:CIHTTP:ParseURL = TRUE
          chCtrlFrame:CIHTTP:URL      = broker:SCREEN-VALUE.
      
        RUN adeweb/_runbrws.p (web-browser:SCREEN-VALUE,
                               chCtrlFrame:CIHTTP:URL + "/webutil/ping.p":U,
                               open-browse:CHECKED).
    END.
    ELSE DO:
        /* CIHTTP isn't supported on 64-bit so use the URL as-is. */
        RUN adeweb/_runbrws.p (web-browser:SCREEN-VALUE,
                               broker:SCREEN-VALUE + "/webutil/ping.p":U,
                               open-browse:CHECKED).
    END.

  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assign-new-values V-table-Win 
PROCEDURE assign-new-values :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cBase   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cPath   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lReturn AS LOGICAL   NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN {&DISPLAYED-OBJECTS}.
    
    RUN validate_browser.
    IF RETURN-VALUE eq "Error":U THEN 
      RETURN "Error":U.
    ELSE DO:
      /* Warn user if their browser is Netscape and they have not checked
         "Open new browser for each Web-based Run" */
      RUN adecomm/_osprefx.p (web-browser, OUTPUT cBase, OUTPUT cPath).

      IF cPath eq "netscape.exe":U AND NOT Open-Browse:CHECKED THEN
        RUN adecomm/_s-alert.p (INPUT-OUTPUT lReturn, "warning":U, "ok":U,
          "Active Netscape Navigator windows do not always respond correctly to URL requests from Appbuilder.  If Navigator does not respond, it is recommended that you check the 'Open new browser window...' toggle-box.").
      
      ASSIGN _WebBrowser       = web-browser
             _BrokerURL        = REPLACE(broker,"~\":U,"/":U)
             _open_new_browse  = Open-Browse:CHECKED.
    END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE control_load V-table-Win _CONTROL-LOAD
PROCEDURE control_load :
/*------------------------------------------------------------------------------
  Purpose:     Load the OCXs    
  Parameters:  <none>
  Notes:       Here we load, initialize and make visible the 
               OCXs in the interface.                        
------------------------------------------------------------------------------*/

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN
IF PROCESS-ARCHITECTURE = 32 THEN DO:
  DEFINE VARIABLE UIB_S    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE OCXFile  AS CHARACTER  NO-UNDO.

  OCXFile = SEARCH( "adeuib\_vwebcon.wrx":U ).
  IF OCXFile = ? THEN
    OCXFile = SEARCH(SUBSTRING(THIS-PROCEDURE:FILE-NAME, 1,
                     R-INDEX(THIS-PROCEDURE:FILE-NAME, ".":U), "CHARACTER":U) + "wrx":U).

  IF OCXFile <> ? THEN
  DO:
    ASSIGN
      chCtrlFrame = CtrlFrame:COM-HANDLE
      UIB_S = chCtrlFrame:LoadControls( OCXFile, "CtrlFrame":U)
    .
    RUN DISPATCH IN THIS-PROCEDURE("initialize-controls":U) NO-ERROR.
  END.
  ELSE MESSAGE "adeuib\_vwebcon.wrx":U SKIP(1)
               "The binary control file could not be found. The controls cannot be loaded."
               VIEW-AS ALERT-BOX TITLE "Controls Not Loaded".
END.
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartViewer, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-init V-table-Win 
PROCEDURE set-init :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  ASSIGN web-browser     = _WebBrowser
         broker          = _BrokerUrl
         Open-Browse     = _open_new_browse.
         
  DISPLAY 
    web-browser broker open-browse 
    WITH FRAME {&FRAME-NAME}.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validate_browser V-table-Win 
PROCEDURE validate_browser :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    IF web-browser:SCREEN-VALUE eq "" THEN DO:
      MESSAGE "A Web Browser has not been defined."
        VIEW-AS ALERT-BOX WARNING.
      RETURN.
    END.

    FILE-INFO:FILE-NAME = web-browser:SCREEN-VALUE.
    IF FILE-INFO:FULL-PATHNAME eq ? THEN DO:
      MESSAGE "Web Browser executable does not exist."
        VIEW-AS ALERT-BOX ERROR.
      RETURN "Error":U.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


