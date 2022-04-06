&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
/* Procedure Description
"Basic Dialog-Box Template

Use this template to create a new dialog-box. Alter this default template or create new ones to accomodate your needs for different default sizes and/or attributes."
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME C-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Dialog 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: _cuelist.w

  Description: Presents a list of 'hidden' cue cards so that they may be
               unhidden.

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Gerry Seidl

  Created: 03/28/95
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN TRUE

{adecomm/adestds.i}             /* Standards for "Sullivan Look"            */
{adeuib/uibhlp.i}               /* Help pre-processor directives            */

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE l     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE wlist AS CHARACTER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME C-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS s_cues 
&Scoped-Define DISPLAYED-OBJECTS s_cues 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE VARIABLE s_cues AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE SCROLLBAR-VERTICAL 
     SIZE 49.4 BY 4.57 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME C-Dialog
     s_cues AT ROW 1.95 COL 2.6 NO-LABEL
     "Select cue cards to redisplay:" VIEW-AS TEXT
          SIZE 31.6 BY .52 AT ROW 1.24 COL 3
     SPACE(18.79) SKIP(4.75)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Active Cue Cards".

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX C-Dialog
   Default                                                              */
ASSIGN 
       FRAME C-Dialog:SCROLLABLE       = FALSE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Dialog C-Dialog
ON GO OF FRAME C-Dialog /* Active Cue Cards */
DO:
  DEFINE VARIABLE i AS INTEGER NO-UNDO.
  DEFINE VARIABLE w AS WIDGET  NO-UNDO.
  
  DO i = 1 TO s_cues:NUM-ITEMS IN FRAME {&FRAME-NAME}:
    IF s_cues:IS-SELECTED(i) THEN DO:
      w = WIDGET-HANDLE(ENTRY(i,wlist)).
      w:HIDDEN = no.
    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Dialog C-Dialog
ON WINDOW-CLOSE OF FRAME C-Dialog /* Active Cue Cards */
DO:
 APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME s_cues
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL s_cues C-Dialog
ON DEFAULT-ACTION OF s_cues IN FRAME C-Dialog
DO:
  APPLY "GO" TO FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Dialog 


/* ***************************  Main Block  *************************** */
RUN Find_Cues.
IF s_cues:NUM-ITEMS = 0 THEN DO:
  MESSAGE "There are no dismissed cue cards." skip "You can only retrieve active cue cards which have been closed."
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  RETURN.
END.
{ adecomm/commeng.i }
{ adecomm/okbar.i &TOOL = "AB"
                  &CONTEXT = {&Active_Cue_Cards_Dlg_Box} }

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Dialog _DEFAULT-DISABLE
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
  HIDE FRAME C-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Dialog _DEFAULT-ENABLE
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
  DISPLAY s_cues 
      WITH FRAME C-Dialog.
  ENABLE s_cues 
      WITH FRAME C-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-C-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Find_Cues C-Dialog 
PROCEDURE Find_Cues :
/*------------------------------------------------------------------------------
  Purpose:     Find hidden Cue Cards and puts them in the list.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE p AS WIDGET NO-UNDO.
  DEFINE VARIABLE w AS WIDGET NO-UNDO.
  
  ASSIGN p = SESSION:FIRST-PROCEDURE.
  DO WHILE VALID-HANDLE(p):
    IF ENTRY(1,p:PRIVATE-DATA) = "CUE-CARD " THEN DO:
      ASSIGN w       = p:CURRENT-WINDOW.
      IF w:HIDDEN = YES THEN 
        ASSIGN l     = s_cues:ADD-LAST(w:TITLE) IN FRAME {&FRAME-NAME}
               wlist = wlist + (IF wlist = "" THEN STRING(w) ELSE "," + STRING(w)).
    END.
    ASSIGN p = p:NEXT-SIBLING.
  END.  
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


