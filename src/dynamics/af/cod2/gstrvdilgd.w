&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{src/adm2/globals.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS edMessage buCancel buProceed buHelp 
&Scoped-Define DISPLAYED-OBJECTS edMessage 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getContainerSource Dialog-Frame 
FUNCTION getContainerSource RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLogicalObjectName Dialog-Frame 
FUNCTION getLogicalObjectName RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON buCancel AUTO-END-KEY DEFAULT 
     LABEL "Cancel" 
     SIZE 15 BY 1.14.

DEFINE BUTTON buHelp 
     LABEL "&Help" 
     SIZE 15 BY 1.14.

DEFINE BUTTON buProceed 
     LABEL "Proceed" 
     CONTEXT-HELP-ID 0
     SIZE 15 BY 1.14.

DEFINE VARIABLE edMessage AS CHARACTER 
     CONTEXT-HELP-ID 0
     VIEW-AS EDITOR LARGE
     SIZE 46.8 BY 12 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     edMessage AT ROW 1.48 COL 3.4 NO-LABEL
     buCancel AT ROW 1.48 COL 52.2
     buProceed AT ROW 2.76 COL 52.2
     buHelp AT ROW 4.67 COL 52.2
     SPACE(0.39) SKIP(7.99)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Reset Data Modified Status".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
                                                                        */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

ASSIGN 
       edMessage:RETURN-INSERTED IN FRAME Dialog-Frame  = TRUE
       edMessage:READ-ONLY IN FRAME Dialog-Frame        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Reset Data Modified Status */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buCancel Dialog-Frame
ON CHOOSE OF buCancel IN FRAME Dialog-Frame /* Cancel */
DO:
  APPLY "END-ERROR":U TO FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buHelp Dialog-Frame
ON CHOOSE OF buHelp IN FRAME Dialog-Frame /* Help */
DO: /* Call Help Function (or a simple message). */
  APPLY "HELP" TO FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buProceed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buProceed Dialog-Frame
ON CHOOSE OF buProceed IN FRAME Dialog-Frame /* Proceed */
DO:
  RUN resetStatus.
  APPLY "GO":U TO FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

ON HELP OF FRAME {&FRAME-NAME} ANYWHERE
DO:
  IF VALID-HANDLE(gshSessionManager) THEN
  DO:
    RUN contextHelp IN gshSessionManager
      (INPUT THIS-PROCEDURE, INPUT FOCUS).
  END.
END.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN initializeDialog.
  RUN enable_UI.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

IF THIS-PROCEDURE:PERSISTENT THEN
  DELETE PROCEDURE THIS-PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame  _DEFAULT-DISABLE
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
  HIDE FRAME Dialog-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame  _DEFAULT-ENABLE
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
  DISPLAY edMessage 
      WITH FRAME Dialog-Frame.
  ENABLE edMessage buCancel buProceed buHelp 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDialog Dialog-Frame 
PROCEDURE initializeDialog :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       This procedure simply sets the text of the editor.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lAns AS LOGICAL    NO-UNDO.

  lAns = DYNAMIC-FUNCTION("isConnected":U IN THIS-PROCEDURE,
                          "ICFDB":U) NO-ERROR.

  IF lAns = NO OR 
     lAns = ? THEN
  DO:
    MESSAGE "This procedure requires a connection to at least the ICFDB database to work. It cannot be run across an AppServer."
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN ERROR.
  END.

  edMessage = "Selecting the 'Proceed' button will reset the Data Modified Status "
            + "for all the data in the repository." + CHR(13) + CHR(13)
            + "This means that it will no longer "
            + "be possible to determine what data has been modfied since the last "
            + "time the Data Modified Status was reset." + CHR(13) + CHR(13)
            + "It is recommended that a backup be taken before proceeding as this "
            + "action cannot be undone." + CHR(13) + CHR(13)
            + "Choose the 'Proceed' button to continue and perform this action." + CHR(13) + CHR(13)
            + "Choose the 'Cancel' button to close this dialog without performing any action.".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetStatus Dialog-Frame 
PROCEDURE resetStatus :
/*------------------------------------------------------------------------------
  Purpose:     Invokes the API call in gscddxmlp.p that will actually reset the 
               modified status.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDSAPI AS HANDLE     NO-UNDO.

  SESSION:SET-WAIT-STATE("GENERAL":U).

  /* Start the Dataset API procedure */
  RUN startProcedure IN THIS-PROCEDURE ("ONCE|af/app/gscddxmlp.p":U, 
                                        OUTPUT hDSAPI).

  RUN resetAllModifiedStatus IN hDSAPI.

  SESSION:SET-WAIT-STATE("":U).

  MESSAGE "The Data Modified Status has now been successfully reset for all objects."
    VIEW-AS ALERT-BOX INFO BUTTONS OK
    TITLE "Reset Data Modified Status Successful".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getContainerSource Dialog-Frame 
FUNCTION getContainerSource RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN THIS-PROCEDURE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLogicalObjectName Dialog-Frame 
FUNCTION getLogicalObjectName RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN "gstrvdilgd.w".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

