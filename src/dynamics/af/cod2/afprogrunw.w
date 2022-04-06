&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: afprogrunw.w

  Description: Launch ICF Program from Protools

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

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
{af/sup2/dynhlp.i}          /* Help File Preprocessor Directives         */
{af/sup2/afglobals.i NEW GLOBAL}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS ToConnectAppserver buShutdown buRun buClose 
&Scoped-Define DISPLAYED-OBJECTS ToConnectAppserver ToAppserver ToManagers 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buClose 
     LABEL "&Close":L 
     SIZE 15 BY 1.14 TOOLTIP "Close this window and do nothing".

DEFINE BUTTON buRun AUTO-GO 
     LABEL "S&tart":L 
     SIZE 15 BY 1.14 TOOLTIP "Run specified container (or just managers / Appserver if container blank)".

DEFINE BUTTON buShutdown AUTO-GO 
     LABEL "&Shutdown":L 
     SIZE 15 BY 1.14 TOOLTIP "Shutdown Managers and disconnect Appserver".

DEFINE VARIABLE ToAppserver AS LOGICAL INITIAL no 
     LABEL "Appserver Connected" 
     VIEW-AS TOGGLE-BOX
     SIZE 26.4 BY .81 NO-UNDO.

DEFINE VARIABLE ToConnectAppserver AS LOGICAL INITIAL yes 
     LABEL "Connect to Appserver Partition" 
     VIEW-AS TOGGLE-BOX
     SIZE 34.4 BY .81 NO-UNDO.

DEFINE VARIABLE ToManagers AS LOGICAL INITIAL no 
     LABEL "Managers Running" 
     VIEW-AS TOGGLE-BOX
     SIZE 26.8 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     ToConnectAppserver AT ROW 1.48 COL 3
     ToAppserver AT ROW 1.48 COL 39
     buShutdown AT ROW 2.52 COL 3
     buRun AT ROW 2.52 COL 22.2
     ToManagers AT ROW 2.91 COL 39
     buClose AT ROW 3.86 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 86 BY 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Run Container / Start Managers / Connect to Appserver"
         HEIGHT             = 4
         WIDTH              = 86
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 95.2
         VIRTUAL-HEIGHT     = 16
         VIRTUAL-WIDTH      = 95.2
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
/* SETTINGS FOR TOGGLE-BOX ToAppserver IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX ToManagers IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Run Container / Start Managers / Connect to Appserver */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Run Container / Start Managers / Connect to Appserver */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DEFAULT-FRAME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DEFAULT-FRAME C-Win
ON HELP OF FRAME DEFAULT-FRAME
OR HELP OF FRAME {&FRAME-NAME}
DO: 
  /* Help for this Frame */
  RUN adecomm/_adehelp.p
                ("ICAB":U, "CONTEXT":U, {&Session_Reset_Dialog_Box}  , "":U).


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buClose
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buClose C-Win
ON CHOOSE OF buClose IN FRAME DEFAULT-FRAME /* Close */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRun
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRun C-Win
ON CHOOSE OF buRun IN FRAME DEFAULT-FRAME /* Start */
DO:

  DEFINE VARIABLE lContinue AS LOGICAL INITIAL YES NO-UNDO.
  ASSIGN
    ToConnectAppserver.

  RUN af/sup2/afstartupp.p (INPUT "af/cod2/aftemlognw.w":U,               /* Login window */
                            INPUT "",                                     /* container to run */
                            INPUT NO,                                     /* do not quit on exit */
                            INPUT "":U,                                   /* no library load check */
                            INPUT toConnectAppserver                      /* connect to Appserver */
                           ).
  RUN refreshScreenValues.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buShutdown
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buShutdown C-Win
ON CHOOSE OF buShutdown IN FRAME DEFAULT-FRAME /* Shutdown */
DO:

  DEFINE VARIABLE lContinue AS LOGICAL INITIAL YES NO-UNDO.

  MESSAGE
    "Are you sure you want to shutdown all Manager procedures and disconnect" SKIP
    "from the Appserver if connected?" SKIP(1)
    "You will need to re-connect and re-start the Managers by pressing the" SKIP
    "START button again in order to load / run any further objects." SKIP(1)
    "WARNING" SKIP
    "If you have any objects open, they may become unusable as all super" SKIP
    "procedures will also be shutdown." SKIP(1)
    "Continue?" SKIP(1)
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
    UPDATE lContinue.

  IF lContinue
  THEN DO:
    RUN af/sup2/afshutdwnp.p.
  END.

  RUN refreshScreenValues.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  RUN refreshScreenValues.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adepersistent C-Win 
PROCEDURE adepersistent :
/*------------------------------------------------------------------------------
  Purpose:     to stop this window getting killed when press shutdown
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RETURN "ok".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
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
  DISPLAY ToConnectAppserver ToAppserver ToManagers 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE ToConnectAppserver buShutdown buRun buClose 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshScreenValues C-Win 
PROCEDURE refreshScreenValues :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:

  DEFINE VARIABLE lRemote   AS LOGICAL INITIAL NO NO-UNDO.
  DEFINE VARIABLE cConnid   AS CHARACTER NO-UNDO. /* SESSION:SERVER-CONNECTION-ID */
  DEFINE VARIABLE cOpmode   AS CHARACTER NO-UNDO. /* SESSION:SERVER-OPERATING-MODE */
  DEFINE VARIABLE lConnReq  AS LOGICAL   NO-UNDO. /* SESSION:SERVER-CONNECTION-BOUND-REQUEST */
  DEFINE VARIABLE lConnbnd  AS LOGICAL   NO-UNDO. /* SESSION:SERVER-CONNECTION-BOUND */
  DEFINE VARIABLE cConnctxt AS CHARACTER NO-UNDO. /* SESSION:SERVER-CONNECTION-CONTEXT */
  DEFINE VARIABLE cASppath  AS CHARACTER NO-UNDO. /* PROPATH */
  DEFINE VARIABLE cConndbs  AS CHARACTER NO-UNDO. /* List of Databases */
  DEFINE VARIABLE cCustomisationTypes        AS CHARACTER         NO-UNDO.
  DEFINE VARIABLE cCustomisationReferences   AS CHARACTER         NO-UNDO.
  DEFINE VARIABLE cCustomisationResultCodes  AS CHARACTER         NO-UNDO.
  DEFINE VARIABLE hHandle1            AS HANDLE                   NO-UNDO.
  DEFINE VARIABLE hHandle2            AS HANDLE                   NO-UNDO.
  DEFINE VARIABLE hHandle3            AS HANDLE                   NO-UNDO.
  DEFINE VARIABLE hHandle4            AS HANDLE                   NO-UNDO.
  DEFINE VARIABLE hHandle5            AS HANDLE                   NO-UNDO. /* Temp Table List of Running Persistent Procedures */

  IF VALID-HANDLE(gshAstraAppserver) AND CAN-QUERY(gshAstraAppserver, "connected":U) AND gshAstraAppserver:CONNECTED() THEN
    RUN af/app/afapppingp.p ON gshAstraAppserver
              (OUTPUT lRemote,
               OUTPUT cConnid,
               OUTPUT cOpmode,
               OUTPUT lConnReq,
               OUTPUT lConnbnd,
               OUTPUT cConnctxt,
               OUTPUT cASppath,
               OUTPUT cConndbs,
               OUTPUT cCustomisationTypes,
               OUTPUT cCustomisationReferences,
               OUTPUT cCustomisationResultCodes,
               OUTPUT TABLE-HANDLE hHandle1,
               OUTPUT TABLE-HANDLE hHandle2,
               OUTPUT TABLE-HANDLE hHandle3,
               OUTPUT TABLE-HANDLE hHandle4,
               OUTPUT TABLE-HANDLE hHandle5   ) NO-ERROR.

  DELETE OBJECT hHandle1 NO-ERROR.
  ASSIGN hHandle1 = ?.

  DELETE OBJECT hHandle2 NO-ERROR.
  ASSIGN hHandle2 = ?.

  DELETE OBJECT hHandle3 NO-ERROR.
  ASSIGN hHandle3 = ?.

  DELETE OBJECT hHandle4 NO-ERROR.
  ASSIGN hHandle4 = ?.

  DELETE OBJECT hHandle5 NO-ERROR.
  ASSIGN hHandle5 = ?.

  IF lRemote THEN
    ASSIGN  ToAppserver:SCREEN-VALUE = "yes".
  ELSE
    ASSIGN  ToAppserver:SCREEN-VALUE = "no".

  IF VALID-HANDLE(gshSessionManager) THEN
    ASSIGN  ToManagers:SCREEN-VALUE = "yes".
  ELSE
    ASSIGN  ToManagers:SCREEN-VALUE = "no".

END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

