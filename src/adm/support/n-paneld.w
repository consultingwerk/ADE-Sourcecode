&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
/* Procedure Description
"The Dialog-Box for navigation SmartPanels

This dialog-box is used to set the navigation SmartPanel-specific attributes during design time."
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME SP-attr-dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS SP-attr-dialog 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: n-paneld.w

  Description: Dialog for getting setable attributes of a navigation
               SmartPanel.

  Input Parameters:
      Handle of the calling SmartPanel.

  Output Parameters:
      <none>

  Author: Patrick Leach

  Created: 5/30/95
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

&GLOBAL-DEFINE WIN95-BTN  YES

DEFINE INPUT PARAMETER p-Parent-Hdl AS HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE attr-list AS CHARACTER NO-UNDO.
DEFINE VARIABLE attr-name AS CHARACTER NO-UNDO.
DEFINE VARIABLE attr-value AS CHARACTER NO-UNDO.
DEFINE VARIABLE attr-entry AS CHARACTER NO-UNDO.
DEFINE VARIABLE i AS INTEGER NO-UNDO.
DEFINE VARIABLE entries AS INTEGER NO-UNDO.
DEFINE VARIABLE v-type AS CHARACTER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME SP-attr-dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS v-divider1 v-show v-edge-pixels v-rtl 
&Scoped-Define DISPLAYED-OBJECTS v-divider1 v-show v-edge-pixels v-divider2 ~
v-rtl 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE VARIABLE v-divider1 AS CHARACTER FORMAT "X(75)":U INITIAL " Border" 
      VIEW-AS TEXT 
     SIZE 51.4 BY .57
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE v-divider2 AS CHARACTER FORMAT "X(25)":U INITIAL " Internationalization" 
      VIEW-AS TEXT 
     SIZE 51.4 BY .57
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE v-edge-pixels AS INTEGER FORMAT ">>9":U INITIAL 2 
     LABEL "&Edge Pixels" 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE v-rtl AS CHARACTER INITIAL "First-On-Left" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "'First' on &Left", "First-On-Left":U,
"'First' on &Right", "First-On-Right":U
     SIZE 23 BY 2.29 NO-UNDO.

DEFINE VARIABLE v-show AS LOGICAL INITIAL yes 
     LABEL "&Show Border" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME SP-attr-dialog
     v-divider1 AT ROW 1.62 COL 2.6 NO-LABEL
     v-show AT ROW 2.67 COL 20
     v-edge-pixels AT ROW 3.86 COL 29 COLON-ALIGNED
     v-divider2 AT ROW 5.81 COL 2.6 NO-LABEL
     v-rtl AT ROW 6.71 COL 18 NO-LABEL
     SPACE(12.99) SKIP(0.15)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Navigation SmartPanel Attributes".

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX SP-attr-dialog
   Default                                                              */
ASSIGN 
       FRAME SP-attr-dialog:SCROLLABLE       = FALSE
       FRAME SP-attr-dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN v-divider1 IN FRAME SP-attr-dialog
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN v-divider2 IN FRAME SP-attr-dialog
   NO-ENABLE ALIGN-L                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME SP-attr-dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SP-attr-dialog SP-attr-dialog
ON WINDOW-CLOSE OF FRAME SP-attr-dialog /* Navigation SmartPanel Attributes */
DO:
 APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-edge-pixels
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-edge-pixels SP-attr-dialog
ON LEAVE OF v-edge-pixels IN FRAME SP-attr-dialog /* Edge Pixels */
DO:
  RUN set-state.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-show
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-show SP-attr-dialog
ON VALUE-CHANGED OF v-show IN FRAME SP-attr-dialog /* Show Border */
DO:
  IF v-show:CHECKED = NO THEN DO:
     v-edge-pixels:SCREEN-VALUE = STRING (0).
     v-edge-pixels:SENSITIVE = NO.
  END.
  ELSE DO:
     v-edge-pixels:SENSITIVE = YES.
     IF v-edge-pixels:SCREEN-VALUE = STRING (0) THEN
        v-edge-pixels:SCREEN-VALUE = STRING (2).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK SP-attr-dialog 


/* ****************** Standard Buttons and ADM Help ******************* */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Define Context ID's for HELP files */
{ adm/support/admhlp.i }    

/* Attach the standard OK/Cancel/Help button bar. */
{ adecomm/okbar.i  &TOOL = "AB"
                   &CONTEXT = {&SmartNavPanel_Attributes_Dlg_Box} }

/* ***************************  Main Block  *************************** */

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
   RUN get-attribute-list IN p-Parent-Hdl (OUTPUT attr-list).
   entries = NUM-ENTRIES (attr-list).
   DO i = 1 TO entries:
      ASSIGN attr-entry = ENTRY (i, attr-list)
             attr-name  = TRIM (SUBSTR (attr-entry, 1, INDEX (attr-entry, "=":U) - 1,
                                        "CHARACTER":U))
             attr-value = TRIM (SUBSTR (attr-entry, INDEX (attr-entry, "=":U) + 1, -1,
                                        "CHARACTER":U)).
      CASE attr-name:
        WHEN "SmartPanelType":U THEN
           v-type = attr-value.
        WHEN "Right-To-Left":U THEN
           v-rtl = attr-value.
        WHEN "Edge-Pixels":U THEN
           v-edge-pixels = INTEGER (attr-value).
     END CASE.
   END.

  v-rtl:SCREEN-VALUE = v-rtl.

  RUN enable_UI.

  /* Set the cursor */
  RUN adecomm/_setcurs.p ("":U).
  
  RUN set-state.

  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
  
  ASSIGN v-rtl
         v-edge-pixels.
  
  attr-list = "SmartPanelType = ":U + v-type + 
              ",Edge-Pixels = ":U + STRING (v-edge-pixels) +
              ",RIGHT-TO-LEFT = ":U + STRING (v-rtl).

  RUN set-attribute-list IN p-Parent-Hdl (INPUT attr-list).
  
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI SP-attr-dialog _DEFAULT-DISABLE
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
  HIDE FRAME SP-attr-dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI SP-attr-dialog _DEFAULT-ENABLE
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
  DISPLAY v-divider1 v-show v-edge-pixels v-divider2 v-rtl 
      WITH FRAME SP-attr-dialog.
  ENABLE v-divider1 v-show v-edge-pixels v-rtl 
      WITH FRAME SP-attr-dialog.
  VIEW FRAME SP-attr-dialog.
  {&OPEN-BROWSERS-IN-QUERY-SP-attr-dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-state SP-attr-dialog 
PROCEDURE set-state :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:
  
    IF v-type = "NAV-LABEL":U THEN
      v-rtl:SENSITIVE = NO.
   
    IF v-edge-pixels:SCREEN-VALUE = STRING (0) THEN DO:
       v-show:CHECKED = NO.
       v-edge-pixels:SENSITIVE = NO.
    END.
        
  END.
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


