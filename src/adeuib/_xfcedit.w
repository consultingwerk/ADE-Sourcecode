&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v7r10 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME    f_edit
&Scoped-define FRAME-NAME     f_edit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS f_edit 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: _xfcedit.p

  Description: XFTR Code Editor

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Gerry Seidl

  Created: 09/19/94 -  8:51 am

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT-OUTPUT PARAMETER tCode AS CHAR NO-UNDO.

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



/* ********************  Preprocessor Definitions  ******************** */

/* Name of first Frame and/or Browse (alphabetically)                   */
&Scoped-define FRAME-NAME  f_edit

/* Custom List Definitions                                              */
&Scoped-define LIST-1 
&Scoped-define LIST-2 
&Scoped-define LIST-3 

/* Definitions for DIALOG-BOX f_edit                                    */
&Scoped-define FIELDS-IN-QUERY-f_edit 

/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel":L 
     SIZE 12 BY 1.17
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK":L 
     SIZE 12 BY 1.17
     BGCOLOR 8 .

DEFINE VARIABLE code-editor AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL LARGE
     SIZE 82 BY 11.75 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f_edit
     code-editor AT ROW 1 COL 1 NO-LABEL
     Btn_OK AT ROW 13 COL 28
     Btn_Cancel AT ROW 13 COL 44
     SPACE(27.01) SKIP(0.30)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         TITLE "XFTR Default Editor":L
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.

 


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX f_edit
  VISIBLE,L                                                             */
ASSIGN 
       FRAME f_edit:SCROLLABLE       = FALSE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME f_edit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f_edit f_edit
ON GO OF FRAME f_edit /* XFTR Default Editor */
DO:
  ASSIGN 
      code-editor = code-editor:SCREEN-VALUE
      tCode       = code-editor.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK f_edit 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

ASSIGN code-editor = tCode.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI f_edit _DEFAULT-DISABLE
PROCEDURE disable_UI :
/* --------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
   -------------------------------------------------------------------- */
  /* Hide all frames. */
  HIDE FRAME f_edit.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI f_edit _DEFAULT-ENABLE
PROCEDURE enable_UI :
/* --------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
   -------------------------------------------------------------------- */
  DISPLAY code-editor 
      WITH FRAME f_edit.
  ENABLE code-editor Btn_OK Btn_Cancel 
      WITH FRAME f_edit.
  {&OPEN-BROWSERS-IN-QUERY-f_edit}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE FRAME-NAME 
&UNDEFINE WINDOW-NAME
