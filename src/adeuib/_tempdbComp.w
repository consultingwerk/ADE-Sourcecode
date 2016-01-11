&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
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

  File:             adeuib/_tempdbcomp.w

  Description:      Window used to display compare results. called from
                    adeuib/_tempdb.w

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
DEFINE VARIABLE hParent AS HANDLE     NO-UNDO.

DEFINE VARIABLE glDynamicsRunning AS LOGICAL    NO-UNDO.

{ adeuib/uibhlp.i }          /* Help File Preprocessor Directives       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Ed btnClose btnHelp 
&Scoped-Define DISPLAYED-OBJECTS Ed 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnClose 
     LABEL "Close" 
     CONTEXT-HELP-ID 0
     SIZE 15 BY 1.14.

DEFINE BUTTON btnHelp 
     LABEL "Help" 
     CONTEXT-HELP-ID 0
     SIZE 15 BY 1.14.

DEFINE VARIABLE Ed AS CHARACTER 
     CONTEXT-HELP-ID 0
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 80 BY 11.91 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     Ed AT ROW 1 COL 1 NO-LABEL
     btnClose AT ROW 13.62 COL 33
     btnHelp AT ROW 13.62 COL 65
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80.8 BY 13.95.


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
         TITLE              = "Compare Window"
         HEIGHT             = 13.95
         WIDTH              = 80.8
         MAX-HEIGHT         = 13.95
         MAX-WIDTH          = 80.8
         VIRTUAL-HEIGHT     = 13.95
         VIRTUAL-WIDTH      = 80.8
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
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
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */
ASSIGN 
       Ed:RETURN-INSERTED IN FRAME DEFAULT-FRAME  = TRUE
       Ed:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Compare Window */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Compare Window */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-RESIZED OF C-Win /* Compare Window */
DO:
  DEFINE VARIABLE hFrame  AS HANDLE     NO-UNDO.

  ASSIGN hFrame                = FRAME {&FRAME-NAME}:HANDLE
         hFrame:WIDTH          = MAX(hFrame:WIDTH, {&WINDOW-NAME}:WIDTH - hFrame:COL + 1)
         hFrame:HEIGHT         = MAX(hFrame:HEIGHT, {&WINDOW-NAME}:HEIGHT - hFrame:ROW + 1)
         Ed:WIDTH              = {&WINDOW-NAME}:WIDTH
         Ed:HEIGHT             = {&WINDOW-NAME}:HEIGHT - Ed:ROW - BtnClose:HEIGHT + .5
         BtnClose:ROW          = Ed:ROW + ed:HEIGHT + .25
         BtnClose:COL          = ({&WINDOW-NAME}:WIDTH / 2 ) - (BtnClose:WIDTH / 2)
         BtnHelp:ROW           = Ed:ROW + ed:HEIGHT + .25
         BtnHelp:COL           = {&WINDOW-NAME}:WIDTH - BtnHelp:WIDTH.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DEFAULT-FRAME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DEFAULT-FRAME C-Win
ON HELP OF FRAME DEFAULT-FRAME
ANYWHERE DO:
    RUN runHelp.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnClose
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnClose C-Win
ON CHOOSE OF btnClose IN FRAME DEFAULT-FRAME /* Close */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnHelp C-Win
ON CHOOSE OF btnHelp IN FRAME DEFAULT-FRAME /* Help */
DO:
    RUN runHelp.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

ASSIGN glDynamicsRunning = DYNAMIC-FUNCTION("IsICFRunning":U) NO-ERROR.
IF glDynamicsRunning = ? THEN glDynamicsRunning = NO.

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

  STATUS INPUT OFF.

  ASSIGN {&WINDOW-NAME}:MAX-WIDTH = SESSION:WIDTH 
         {&WINDOW-NAME}:MAX-HEIGHT = SESSION:HEIGHT
         {&WINDOW-NAME}:MIN-HEIGHT = 3
          {&WINDOW-NAME}:MIN-WIDTH = 30.

  /* Load window icons */
  IF glDynamicsRunning THEN
      {&WINDOW-NAME}:LOAD-ICON("adeicon/icfdev.ico":U) NO-ERROR.
  ELSE
      {&WINDOW-NAME}:LOAD-ICON("adeicon/uib%.ico":U) NO-ERROR.

  APPLY "WINDOW-RESIZED":U TO  {&WINDOW-NAME}.

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE centerWindow C-Win 
PROCEDURE centerWindow :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hParent AS HANDLE     NO-UNDO.

ASSIGN hParent = {&WINDOW-NAME}:PARENT NO-ERROR.

IF VALID-HANDLE(hParent) THEN
  ASSIGN 
    {&WINDOW-NAME}:ROW = (hParent:HEIGHT - {&WINDOW-NAME}:HEIGHT  )/ 2 + hParent:ROW
    {&WINDOW-NAME}:COL = (hParent:WIDTH - {&WINDOW-NAME}:WIDTH )/ 2 + hParent:COL
    {&WINDOW-NAME}:VISIBLE   = TRUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ClearEditor C-Win 
PROCEDURE ClearEditor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN Ed:SCREEN-VALUE IN FRAME {&FRAME-NAME}= "".
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
  DISPLAY Ed 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE Ed btnClose btnHelp 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitWindow C-Win 
PROCEDURE exitWindow :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 APPLY "CLOSE":U TO THIS-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getEditorString C-Win 
PROCEDURE getEditorString :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pcString AS CHAR  NO-UNDO.


ASSIGN pcString = Ed:SCREEN-VALUE IN FRAME {&FRAME-NAME} .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE movetotop C-Win 
PROCEDURE movetotop :
/*------------------------------------------------------------------------------
  Purpose:     Move to top, restore if minimized.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{&WINDOW-NAME}:MOVE-TO-TOP().

IF {&WINDOW-NAME}:WINDOW-STATE = WINDOW-MINIMIZED THEN
   {&WINDOW-NAME}:WINDOW-STATE = WINDOW-NORMAL.

ASSIGN  {&WINDOW-NAME}:VISIBLE   = TRUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runHelp C-Win 
PROCEDURE runHelp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF glDynamicsRunning THEN
        RUN adecomm/_adehelp.p ("AB":U,"CONTEXT":U,{&TEMP_DB_Compare_Win_Dyn},?).
    ELSE
        RUN adecomm/_adehelp.p ("AB":U,"CONTEXT":U,{&TEMP_DB_Compare_Win},?).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setParent C-Win 
PROCEDURE setParent :
/*------------------------------------------------------------------------------
  Purpose:     Sets the Parent window.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phParent AS HANDLE     NO-UNDO.

IF VALID-HANDLE(phParent) THEN
      ASSIGN {&WINDOW-NAME}:PARENT = phParent.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE WriteToEditor C-Win 
PROCEDURE WriteToEditor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcMessage AS CHARACTER  NO-UNDO.

ED:SCREEN-VALUE IN FRAME {&FRAME-NAME} = Ed:SCREEN-VALUE + pcMessage.

/*Ed:INSERT-STRING(pcMessage) IN FRAME {&FRAME-NAME}.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

