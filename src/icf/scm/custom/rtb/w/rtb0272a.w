&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME DIALOG-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DIALOG-1 
/*------------------------------------------------------------------------
  File: rtb0272a.w
  Description: Prompt for version notes
  Author: John Green
  Created: 11/22/94 -  2:32 pm
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE SHARED VARIABLE Grtb-userid    AS CHARACTER NO-UNDO.
DEFINE SHARED VARIABLE Grtb-task-num  AS INTEGER   NO-UNDO. 
DEFINE SHARED VARIABLE Grtb-help-file AS CHARACTER NO-UNDO.


/* --- Define parameters --- */
DEFINE INPUT PARAMETER Ppmod     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER Pobj-type AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER Pobject   AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER Pversion  AS INTEGER   NO-UNDO.


/* --- Define shared --- */
DEFINE SHARED VARIABLE Grtb-p-library AS HANDLE NO-UNDO.


/* --- Define locals --- */
DEFINE VARIABLE BT-ok           AS WIDGET-HANDLE             NO-UNDO.
DEFINE VARIABLE BT-cancel       AS WIDGET-HANDLE             NO-UNDO.
DEFINE VARIABLE BT-help         AS WIDGET-HANDLE             NO-UNDO.


DEFINE BUFFER Brtb_ver    FOR rtb.rtb_ver.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DIALOG-1

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS EDITOR-1 
&Scoped-Define DISPLAYED-OBJECTS EDITOR-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE VARIABLE EDITOR-1 AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 58 BY 7.69 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     EDITOR-1 AT ROW 1.94 COL 4 NO-LABEL
     SPACE(3.21) SKIP(3.20)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Dialog Box 1".

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX DIALOG-1
   Default                                                              */
ASSIGN 
       FRAME DIALOG-1:SCROLLABLE       = FALSE.

ASSIGN 
       EDITOR-1:RETURN-INSERTED IN FRAME DIALOG-1  = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME DIALOG-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DIALOG-1 DIALOG-1
ON GO OF FRAME DIALOG-1 /* Dialog Box 1 */
DO:
  ASSIGN Brtb_ver.upd-notes = EDITOR-1:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DIALOG-1 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.


FIND Brtb_ver 
     WHERE Brtb_ver.pmod      = Ppmod
       AND Brtb_ver.obj-type  = Pobj-type
       AND Brtb_ver.object    = Pobject
       AND Brtb_ver.version   = Pversion
       EXCLUSIVE-LOCK NO-WAIT NO-ERROR.

IF NOT AVAILABLE Brtb_ver THEN RETURN.

IF Brtb_ver.obj-status <> "W" THEN RETURN. 


/* --- Set up standard OK/Cancel/Help --- */
RUN make_def_ok_cancel IN Grtb-p-library
    ( INPUT  FRAME dialog-1:HANDLE ,
      OUTPUT BT-ok ,
      OUTPUT BT-Cancel ,
      OUTPUT BT-Help ).


/* --- Help trigger --- */
ON HELP OF FRAME dialog-1
OR CHOOSE OF BT-help
DO:
  SYSTEM-HELP Grtb-help-file CONTEXT 1488.
END.


/* --- Set up the editor widget --- */
ASSIGN
    EDITOR-1 = Brtb_ver.upd-notes.


/* --- Give us a pretty title --- */
ASSIGN FRAME {&FRAME-NAME}:TITLE
         = "Roundtable Version Note for " + Brtb_ver.object.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI DIALOG-1 _DEFAULT-DISABLE
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
  HIDE FRAME DIALOG-1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI DIALOG-1 _DEFAULT-ENABLE
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
  DISPLAY EDITOR-1 
      WITH FRAME DIALOG-1.
  ENABLE EDITOR-1 
      WITH FRAME DIALOG-1.
  {&OPEN-BROWSERS-IN-QUERY-DIALOG-1}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


