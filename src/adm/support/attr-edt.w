&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*-------------------------------------------------------

  File: attr-edt.w
  Description: A generic Attribute Instance Editor.
  Input Parameters:
      ph_SMO - Handle of a SmartObject Procedure
  Output Parameters:
      <none>
---------------------------------------------------------*/

/* Parameters Definitions ---                            */
DEFINE INPUT PARAMETER ph_SMO AS HANDLE NO-UNDO.

/* Local Definitions ---                                 */
DEFINE VARIABLE ch AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS attr-list Btn_OK Btn_Cancel Btn_Help 
&Scoped-Define DISPLAYED-OBJECTS attr-list 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 12 BY 1.12
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 12 BY 1.12
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 12 BY 1.12
     BGCOLOR 8 .

DEFINE VARIABLE attr-list AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 49 BY 8.54 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     attr-list AT ROW 1.54 COL 2 NO-LABEL
     Btn_OK AT ROW 1.38 COL 52
     Btn_Cancel AT ROW 2.65 COL 52
     Btn_Help AT ROW 4.65 COL 52
     SPACE(1.13) SKIP(4.68)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Instance Attributes"
         CANCEL-BUTTON Btn_Cancel.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Instance Attributes */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help Dialog-Frame
ON CHOOSE OF Btn_Help IN FRAME Dialog-Frame /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  MESSAGE "Help for File: {&FILE-NAME}" VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* *********************  Main Block  ********************* */

/* Parent the dialog-box to the ACTIVE-WINDOW.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND 
   FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Change the dialog-box title to show the TYPE of the SmartObject. */
RUN get-attribute IN ph_SMO ('TYPE':U).
ch = RETURN-VALUE.
IF ch ne "":U AND ch ne ? 
THEN FRAME {&FRAME-NAME}:TITLE = FRAME {&FRAME-NAME}:TITLE + " - ":U + ch.

/* Get the instance attributes from the object. */
RUN get-attribute-list IN ph_SMO (OUTPUT attr-list).

/* Now enable the interface and wait for the exit condition. */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI. 
  RUN adecomm/_setcurs.p ('':U).
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
  
  /* Set the values in the object. NOTE: this will not, 
     by default cause the object to rebuild itself. */
  ASSIGN attr-list = TRIM(attr-list:SCREEN-VALUE).
  RUN set-attribute-list IN ph_SMO (INPUT attr-list).

  /* Reinitialize the object - this will rebuild it based
     on the new attribute values. */
  RUN dispatch IN ph_SMO ('initialize':U).

END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame _DEFAULT-ENABLE
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
  DISPLAY attr-list 
      WITH FRAME Dialog-Frame.
  ENABLE attr-list Btn_OK Btn_Cancel Btn_Help 
      WITH FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


