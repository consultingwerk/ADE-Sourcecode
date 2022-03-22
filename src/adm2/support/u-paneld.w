&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI
/* Procedure Description
"The Dialog-Box for TableIO SmartPanels

This dialog-box is used to set the TableIO SmartPanel-specific attributes during design time."
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

  File: u-paneld.w

  Description: ADM2 Dialog for getting setable attributes of a TableIO
               SmartPanel.

  Input Parameters:
      Handle of the calling SmartPanel.

  Output Parameters:
      <none>

  Modified:  July 12, 1998
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
DEFINE VARIABLE v-SPtype AS CHARACTER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME SP-attr-dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS v-show v-edge-pixels v-type v-add ~
lDeactivateTargetOnHide v-divider1 
&Scoped-Define DISPLAYED-OBJECTS v-show v-edge-pixels v-type v-add ~
lDeactivateTargetOnHide v-divider1 v-divider2 v-divider-3 v-divider-4 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE VARIABLE v-divider-3 AS CHARACTER FORMAT "X(25)":U INITIAL " Behavior of Add Button" 
      VIEW-AS TEXT 
     SIZE 54.4 BY .57
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE v-divider-4 AS CHARACTER FORMAT "X(50)":U INITIAL "Deactivation of link to hidden target" 
      VIEW-AS TEXT 
     SIZE 54.4 BY .57
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE v-divider1 AS CHARACTER FORMAT "X(75)":U INITIAL " Border" 
      VIEW-AS TEXT 
     SIZE 54.4 BY .57
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE v-divider2 AS CHARACTER FORMAT "X(25)":U INITIAL " TableIO SmartPanel Type" 
      VIEW-AS TEXT 
     SIZE 54.4 BY .57
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE v-edge-pixels AS INTEGER FORMAT ">>9":U INITIAL 2 
     LABEL "&Edge Pixels" 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE lDeactivateTargetOnHide AS LOGICAL 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "When another target is viewed", no,
"Immediately on hide of target", yes
     SIZE 53 BY 1.62 NO-UNDO.

DEFINE VARIABLE v-add AS CHARACTER INITIAL "One-Record" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Add &One Record", "One-Record":U,
"Add &Multiple Records", "Multiple-Records":U
     SIZE 26 BY 1.62 NO-UNDO.

DEFINE VARIABLE v-type AS CHARACTER INITIAL "Save" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "&Save", "Save":U,
"&Update", "Update":U
     SIZE 12 BY 1.62 NO-UNDO.

DEFINE VARIABLE v-show AS LOGICAL INITIAL yes 
     LABEL "&Show Border" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME SP-attr-dialog
     v-show AT ROW 2.52 COL 3.6
     v-edge-pixels AT ROW 3.76 COL 13.8 COLON-ALIGNED
     v-type AT ROW 6.38 COL 3.6 NO-LABEL
     v-add AT ROW 9.57 COL 3.6 NO-LABEL
     lDeactivateTargetOnHide AT ROW 12.81 COL 3.6 NO-LABEL
     v-divider1 AT ROW 1.67 COL 2 NO-LABEL
     v-divider2 AT ROW 5.38 COL 2 NO-LABEL
     v-divider-3 AT ROW 8.52 COL 2 NO-LABEL
     v-divider-4 AT ROW 11.76 COL 2 NO-LABEL
     SPACE(0.20) SKIP(2.10)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "TableIO SmartPanel Attributes".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX SP-attr-dialog
                                                                        */
ASSIGN 
       FRAME SP-attr-dialog:SCROLLABLE       = FALSE
       FRAME SP-attr-dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN v-divider-3 IN FRAME SP-attr-dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN v-divider-4 IN FRAME SP-attr-dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN v-divider1 IN FRAME SP-attr-dialog
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN v-divider2 IN FRAME SP-attr-dialog
   NO-ENABLE ALIGN-L                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME SP-attr-dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SP-attr-dialog SP-attr-dialog
ON WINDOW-CLOSE OF FRAME SP-attr-dialog /* TableIO SmartPanel Attributes */
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
{ src/adm2/support/admhlp.i }    

/* Attach the standard OK/Cancel/Help button bar. */
{ adecomm/okbar.i  &TOOL = "AB"
                   &CONTEXT = {&SmartUpdPanel_Attributes_Dlg_Box} }

/* ***************************  Main Block  *************************** */

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
   attr-list = dynamic-function ("instancePropertyList":U IN p-Parent-Hdl, '':U).
   entries = NUM-ENTRIES (attr-list, CHR(3)).
   DO i = 1 TO entries:
      ASSIGN attr-entry = ENTRY (i, attr-list, CHR(3))
             attr-name  = TRIM (ENTRY(1, attr-entry, CHR(4)))
             attr-value = TRIM (ENTRY(2, attr-entry, CHR(4))).
      CASE attr-name:
        WHEN "PanelType":U THEN
          ASSIGN v-SPtype = attr-value
                 v-type   = attr-value.
        WHEN "AddFunction":U THEN
           v-add = attr-value.
        WHEN "EdgePixels":U THEN
           v-edge-pixels = INTEGER (attr-value).
        WHEN "DeactivateTargetOnHide":U THEN
          lDeactivateTargetOnHide = can-do('yes,true':U,attr-value).
     END CASE.
   END.

  RUN enable_UI.

  /* Set the cursor */
  RUN adecomm/_setcurs.p ("":U).
  
  RUN set-state.

  WAIT-FOR GO OF FRAME {&FRAME-NAME}.

  ASSIGN v-add v-type
         v-SPtype = v-type.
  /* set-label does not exist in the current panel, 
     but we call itr for backwards compatibility with local panels */
  IF v-SPtype = "UPDATE":U THEN
    RUN set-label IN p-Parent-Hdl (INPUT '&Update':U) NO-ERROR.
  ELSE
    RUN set-label IN p-Parent-Hdl (INPUT '&Save':U) NO-ERROR.
       
  ASSIGN v-edge-pixels
         lDeactivateTargetOnHide.
  
  /* Assign the attributes that are common across all panels. */
  
  {set PanelType v-SPtype p-Parent-Hdl}.
  {set EdgePixels v-edge-pixels p-Parent-Hdl}.
  {set AddFunction v-add p-Parent-Hdl}.
  {set DeactivateTargetOnHide lDeactivateTargetOnHide p-Parent-Hdl}.

END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI SP-attr-dialog  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI SP-attr-dialog  _DEFAULT-ENABLE
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
  DISPLAY v-show v-edge-pixels v-type v-add lDeactivateTargetOnHide v-divider1 
          v-divider2 v-divider-3 v-divider-4 
      WITH FRAME SP-attr-dialog.
  ENABLE v-show v-edge-pixels v-type v-add lDeactivateTargetOnHide v-divider1 
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
  
     IF v-edge-pixels:SCREEN-VALUE = STRING (0) THEN DO:
        v-show:CHECKED = NO.
        v-edge-pixels:SENSITIVE = NO.
     END.
        
  END.
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

