&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v7r11 GUI
/* Procedure Description
"Basic Dialog-Box Template

Use this template to create a new dialog-box. Alter this default template or create new ones to accomodate your needs for different default sizes and/or attributes."
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME Dialog-Frame
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
    File   : adecomm/_winmore.w

    Purpose: More Windows dialog box called when user selectes More Windows...
             option on a Window menu.
             

    Notes  : 

    1.  Window Menu Manager Object takes care of calling this dialog.
        See adecomm/_winmenu.w.

    Author : J. Palazzo
    Created: April, 1995
    Updated:
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/
/* ***************************  Definitions  ************************** */
{adecomm/adestds.i}        /* Standared ADE Preprocessor Directives */
IF NOT initialized_adestds
THEN RUN adecomm/_adeload.p.

{adecomm/commeng.i}          /* Help File Preprocessor Directives       */

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
&IF DEFINED(UIB_is_Running) NE 0 &THEN
DEFINE VAR p_ActiveList    AS CHARACTER
       INIT "/users/devp/jep/7/ade/dialog-1.w,Procedure:2,Proc:3" NO-UNDO.
DEFINE VAR p_WindowName    AS CHARACTER INIT "Procedure:2" NO-UNDO.
&ELSE
DEFINE INPUT        PARAMETER p_ActiveList    AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p_WindowName    AS CHARACTER NO-UNDO.
&ENDIF

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS ActiveWindows 
&Scoped-Define DISPLAYED-OBJECTS ActiveWindows 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */
DEFINE VARIABLE ActiveWindows AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 60 BY 6 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     ActiveWindows AT ROW 2.19 COL 2 NO-LABEL
     "Select Window:" VIEW-AS TEXT
          SIZE 16 BY .54 AT ROW 1.38 COL 2
     SPACE(44.66) SKIP(6.51)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "More Windows".

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
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
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* More Windows */
DO:
 APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ActiveWindows
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ActiveWindows Dialog-Frame
ON DEFAULT-ACTION OF ActiveWindows IN FRAME Dialog-Frame
DO:
  APPLY "GO" TO FRAME {&FRAME-NAME} .
  RETURN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* ADE okbar.i places standard ADE OK-CANCEL-HELP buttons.              */
{adecomm/okbar.i &TOOL = "COMM"
                 &CONTEXT = {&Create_Database} }

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, RETRY MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, RETRY MAIN-BLOCK
   ON STOP    UNDO MAIN-BLOCK, RETRY MAIN-BLOCK :
  
  IF RETRY THEN
  DO:
    ASSIGN p_WindowName = "".
    LEAVE MAIN-BLOCK.
  END.
  
  RUN SetInitValues IN THIS-PROCEDURE.
  RUN enable_UI.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
  
  ASSIGN p_WindowName = ActiveWindows:SCREEN-VALUE IN FRAME {&FRAME-NAME} .
END.

&IF DEFINED(UIB_is_Running) NE 0 &THEN
MESSAGE p_WindowName VIEW-AS ALERT-BOX IN WINDOW ACTIVE-WINDOW.
&ENDIF

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
  DISPLAY ActiveWindows 
      WITH FRAME Dialog-Frame.
  ENABLE ActiveWindows 
      WITH FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetInitValues Dialog-Frame 
PROCEDURE SetInitValues :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR RetValue AS LOGICAL NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN ActiveWindows:LIST-ITEMS = p_ActiveList
           ActiveWindows            = p_WindowName
           . /* END ASSIGN */
           
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


