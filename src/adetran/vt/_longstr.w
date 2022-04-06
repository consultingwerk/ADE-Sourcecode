&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME LongStrWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS LongStrWin 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
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
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
{adetran/vt/vthlp.i}

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE SHARED VARIABLE MainWindow   AS WIDGET-HANDLE               NO-UNDO.

DEFINE VARIABLE calling-proc AS HANDLE                             NO-UNDO.
DEFINE VARIABLE org-trg      AS CHARACTER                          NO-UNDO.
DEFINE VARIABLE result       AS LOGICAL                            NO-UNDO.
DEFINE VARIABLE ret-code     AS INTEGER                            NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Src-Label RECT-2 BtnOK src BtnClear BtnUndo ~
BtnDone BtnHelp Trg-Label RECT-3 trg 
&Scoped-Define DISPLAYED-OBJECTS Src-Label src Trg-Label trg 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR LongStrWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnClear DEFAULT 
     LABEL "&Clear":L 
     SIZE 15 BY 1.125.

DEFINE BUTTON BtnDone DEFAULT 
     LABEL "&Done":L 
     SIZE 15 BY 1.125.

DEFINE BUTTON BtnHelp 
     LABEL "&Help":L 
     SIZE 15 BY 1.125.

DEFINE BUTTON BtnOK AUTO-GO 
     LABEL "&OK":L 
     SIZE 15 BY 1.125.

DEFINE BUTTON BtnUndo DEFAULT 
     LABEL "&Undo":L 
     SIZE 15 BY 1.125.

DEFINE VARIABLE src AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 33 BY 5.14
     BGCOLOR 8  NO-UNDO.

DEFINE VARIABLE trg AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 33 BY 5.14 NO-UNDO.

DEFINE VARIABLE Src-Label AS CHARACTER FORMAT "X(256)":U INITIAL "Source String:" 
      VIEW-AS TEXT 
     SIZE 15.6 BY .62 NO-UNDO.

DEFINE VARIABLE Trg-Label AS CHARACTER FORMAT "X(256)":U INITIAL "Target String:" 
      VIEW-AS TEXT 
     SIZE 14.6 BY .62 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 35 BY 5.67.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 35 BY 5.62.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     Src-Label AT ROW 1.24 COL 4.4 COLON-ALIGNED NO-LABEL
     BtnOK AT ROW 1.67 COL 42
     src AT ROW 1.81 COL 4 NO-LABEL
     BtnClear AT ROW 3 COL 42
     BtnUndo AT ROW 4.24 COL 42
     BtnDone AT ROW 5.48 COL 42
     BtnHelp AT ROW 6.71 COL 42
     Trg-Label AT ROW 7.48 COL 4.4 COLON-ALIGNED NO-LABEL
     trg AT ROW 8.05 COL 4 NO-LABEL
     RECT-2 AT ROW 1.52 COL 3
     RECT-3 AT ROW 7.76 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 56.8 BY 13
         FONT 4.

 

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
  CREATE WINDOW LongStrWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Long String Translator"
         HEIGHT             = 13
         WIDTH              = 57.2
         MAX-HEIGHT         = 13
         MAX-WIDTH          = 77.2
         VIRTUAL-HEIGHT     = 13
         VIRTUAL-WIDTH      = 77.2
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


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW LongStrWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   L-To-R                                                               */
ASSIGN 
       src:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(LongStrWin)
THEN LongStrWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME LongStrWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LongStrWin LongStrWin
ON END-ERROR OF LongStrWin /* Long String Translator */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit.
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.  */
  {&WINDOW-NAME}:HIDDEN = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LongStrWin LongStrWin
ON WINDOW-CLOSE OF LongStrWin /* Long String Translator */
DO:
  /* This event will close the window and terminate the procedure.  */
  /* APPLY "CLOSE":U TO THIS-PROCEDURE. */
  LongStrWin:HIDDEN = TRUE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnClear
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnClear LongStrWin
ON CHOOSE OF BtnClear IN FRAME DEFAULT-FRAME /* Clear */
DO:
  trg:SCREEN-VALUE = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone LongStrWin
ON CHOOSE OF BtnDone IN FRAME DEFAULT-FRAME /* Done */
DO:
  RUN HideMe.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnHelp LongStrWin
ON CHOOSE OF BtnHelp IN FRAME DEFAULT-FRAME /* Help */
OR help of frame {&frame-name} do:
  run adecomm/_adehelp.p ("VT":U, "CONTEXT":U, {&VTLong_String_Translation_DB},?). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnOK LongStrWin
ON CHOOSE OF BtnOK IN FRAME DEFAULT-FRAME /* OK */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN src trg.
    RUN store-long-string in Calling-Proc (INPUT src, INPUT trg).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnUndo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnUndo LongStrWin
ON CHOOSE OF BtnUndo IN FRAME DEFAULT-FRAME /* Undo */
DO:
  trg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = org-trg.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK LongStrWin 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}
       result         = CURRENT-WINDOW:LOAD-ICON("adetran/images/vt%":U).


/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  ASSIGN LongStrWin:HIDDEN  = TRUE
         LongStrWin:PARENT  = MainWindow:HANDLE.

/*
  RUN adecomm/_topmost.p (INPUT LongStrWin:hWnd, INPUT TRUE, OUTPUT ret-code).
*/  
  ASSIGN LongStrWin  = CURRENT-WINDOW:HANDLE
         Src-Label:WIDTH = 
               FONT-TABLE:GET-TEXT-WIDTH-CHARS(TRIM(Src-Label),4)
         Trg-Label:WIDTH =  
               FONT-TABLE:GET-TEXT-WIDTH-CHARS(TRIM(Trg-Label),4).

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.
{adecomm/_adetool.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI LongStrWin _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(LongStrWin)
  THEN DELETE WIDGET LongStrWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI LongStrWin _DEFAULT-ENABLE
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
  DISPLAY Src-Label src Trg-Label trg 
      WITH FRAME DEFAULT-FRAME IN WINDOW LongStrWin.
  ENABLE Src-Label RECT-2 BtnOK src BtnClear BtnUndo BtnDone BtnHelp Trg-Label 
         RECT-3 trg 
      WITH FRAME DEFAULT-FRAME IN WINDOW LongStrWin.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW LongStrWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HideMe LongStrWin 
PROCEDURE HideMe :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  LongStrWin:HIDDEN = TRUE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Realize LongStrWin 
PROCEDURE Realize :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER src-str AS CHARACTER                          NO-UNDO.
  DEFINE INPUT PARAMETER trg-str AS CHARACTER                          NO-UNDO.
  DEFINE INPUT PARAMETER calling AS HANDLE                             NO-UNDO.
  
  ASSIGN src               = src-str
         trg               = trg-str
         org-trg           = trg
         calling-proc      = calling
         LongStrWin:HIDDEN = TRUE.

  DISPLAY Src-Label src Trg-Label trg
      WITH FRAME DEFAULT-FRAME IN WINDOW LongStrWin.
        
  ENABLE Src-Label RECT-2 BtnOK src BtnClear BtnUndo BtnDone BtnHelp Trg-Label 
         RECT-3 trg 
      WITH FRAME DEFAULT-FRAME IN WINDOW LongStrWin.

  /* Attempt to make the window not completely overlapped by the main window */
  IF MainWindow:X < LongStrWin:X AND MainWindow:Y < LongStrWin:Y AND
     MainWindow:X + MainWindow:WIDTH-PIXELS > 
                LongStrWin:X + LongStrWin:WIDTH-PIXELS AND
     MainWindow:Y + MainWindow:HEIGHT-PIXELS >
                LongStrWin:Y + LongStrWin:HEIGHT-PIXELS THEN DO:
    IF SESSION:HEIGHT-PIXELS - MainWindow:Y < 370 THEN
      LongStrWin:Y = MainWindow:Y - 40.
    ELSE LongStrWin:Y = MainWindow:Y +  100.
  END.
  VIEW LongStrWin.
  LongStrWin:HIDDEN = FALSE.
  RUN adecomm/_setcurs.p ("":U).
  CURRENT-WINDOW = LongStrWin.
  APPLY "ENTRY":U TO trg IN FRAME {&FRAME-NAME}.
  IF LongStrWin:MOVE-TO-TOP() THEN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Refresh LongStrWin 
PROCEDURE Refresh :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER src-str AS CHARACTER                          NO-UNDO.
  DEFINE INPUT PARAMETER trg-str AS CHARACTER                          NO-UNDO.
  DEFINE INPUT PARAMETER calling AS HANDLE                             NO-UNDO.
  
  IF LongStrWin:HIDDEN THEN RETURN.
  ASSIGN src               = src-str
         trg               = trg-str
         org-trg           = trg
         calling-proc      = calling.

  DISPLAY src trg
      WITH FRAME DEFAULT-FRAME IN WINDOW LongStrWin.
        
  RUN adecomm/_setcurs.p ("":U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


