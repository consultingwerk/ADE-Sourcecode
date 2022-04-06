&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME run_win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS run_win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: _runfile.w

  Description: Run a procedure

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Bill Wood

  Created: 11/16/94 -  4:25 pm

  Modified by Gerry Seidl on 11/16/94 - Make it a persistent window/proc.

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* By creating a widget-pool, the ui objects of _runfile.w will not be
   deleted when Protools window is deleted.

   We do run the chance of deleting the ui objects of other persistently
   run procedures that do not create their own widget-pool. Not creating
   their own widget-pool is bad programming practice for persistent
   procedures. Every persistent ADE procedure would have to create all
   ui objects in their own named persistent widget-pool. We won't be doing
   that any time soon.  - jep and pal 8/29/96
*/

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
{ protools/ptlshlp.i } /* help definitions */
{ adecomm/_adetool.i }  
{protools/_runonce.i}

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE NEW GLOBAL SHARED VARIABLE wfRunning     AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h_ade_tool    AS HANDLE    NO-UNDO.

DEFINE VARIABLE h_tool     AS HANDLE    NO-UNDO.
DEFINE VARIABLE wfrun      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE run_flags  AS CHARACTER NO-UNDO.
DEFINE VARIABLE app_handle AS HANDLE   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f_Run

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btn_close run-pgm btn_browse l_persistent ~
btn_Run btn_Help 
&Scoped-Define DISPLAYED-OBJECTS run-pgm l_persistent 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR run_win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btn_browse 
     LABEL "&File...":L 
     SIZE 15 BY 1.14.

DEFINE BUTTON btn_close 
     LABEL "&Close":L 
     SIZE 15 BY 1.14.

DEFINE BUTTON btn_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.14.

DEFINE BUTTON btn_Run AUTO-GO 
     LABEL "&Run":L 
     SIZE 15 BY 1.14.

DEFINE VARIABLE run-pgm AS CHARACTER FORMAT "X(256)" 
     VIEW-AS FILL-IN 
     SIZE 38 BY 1.

DEFINE VARIABLE l_persistent AS LOGICAL INITIAL no 
     LABEL "Run &Persistent":L 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .86.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f_Run
     btn_close AT ROW 1.29 COL 43
     run-pgm AT ROW 2.52 COL 3 HELP
          "Enter the name of the program you wish to run" NO-LABEL
     btn_browse AT ROW 2.52 COL 43
     l_persistent AT ROW 3.76 COL 3
     btn_Run AT ROW 3.76 COL 26
     btn_Help AT ROW 3.76 COL 43
     "&Name of Procedure to Run:" VIEW-AS TEXT
          SIZE 28 BY .62 AT ROW 1.62 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 58.4 BY 4.24
         DEFAULT-BUTTON btn_Run.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: WINDOW
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW run_win ASSIGN
         HIDDEN             = YES
         TITLE              = "Run Procedure"
         HEIGHT             = 4.29
         WIDTH              = 58.4
         MAX-HEIGHT         = 4.29
         MAX-WIDTH          = 58.4
         VIRTUAL-HEIGHT     = 4.29
         VIRTUAL-WIDTH      = 58.4
         MAX-BUTTON         = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = 8
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT run_win:LOAD-ICON("adeicon/run":U) THEN
    MESSAGE "Unable to load icon: adeicon/run"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW run_win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f_Run
                                                                        */
ASSIGN 
       l_persistent:PRIVATE-DATA IN FRAME f_Run     = 
                "l_persistent".

/* SETTINGS FOR FILL-IN run-pgm IN FRAME f_Run
   ALIGN-L                                                              */
ASSIGN 
       run-pgm:PRIVATE-DATA IN FRAME f_Run     = 
                "run-pgm".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(run_win)
THEN run_win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f_Run
/* Query rebuild information for FRAME f_Run
     _Query            is NOT OPENED
*/  /* FRAME f_Run */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME run_win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL run_win run_win
ON WINDOW-CLOSE OF run_win /* Run Procedure */
DO:
  /* Stop the Procedure */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f_Run
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f_Run run_win
ON GO OF FRAME f_Run
DO:
  
  /* Is there a non-blank name? */
  IF TRIM(run-pgm:SCREEN-VALUE) NE "":U THEN DO:
    run-pgm = SEARCH (run-pgm:SCREEN-VALUE) NO-ERROR.
    /* If .p or .w specified, check for a .r and run that instead */
    IF run-pgm EQ ? AND 
       CAN-DO(".w,.p",SUBSTRING(run-pgm:SCREEN-VALUE,LENGTH(run-pgm:SCREEN-VALUE) - 1,2,"CHARACTER":U)) THEN
      run-pgm = SEARCH(SUBSTRING(run-pgm:SCREEN-VALUE,1,LENGTH(run-pgm:SCREEN-VALUE) - 2,"CHARACTER":U) + ".r").
    IF run-pgm EQ ? THEN DO:
       MESSAGE "Cannot find file:" run-pgm:SCREEN-VALUE
            VIEW-AS ALERT-BOX ERROR BUTTONS OK IN WINDOW {&WINDOW-NAME}.
       RETURN NO-APPLY.
    END.
    RUN adecomm/_wfrun.p (INPUT "PRO*Tools.", OUTPUT wfrun). /* register PRO*Tools is running a procedure */
    IF wfrun THEN RETURN NO-APPLY. /* Another tool is already running a procedure, can't proceed */
    
    /* Run a procedure (with the appropriate wrapper for a run). */
    RUN-BLOCK:
    DO ON STOP UNDO, RETRY RUN-BLOCK:
      ASSIGN h_tool = h_ade_tool.
      IF l_persistent:CHECKED AND NOT RETRY THEN
      DO:
        /* If this is run persistent,  KEEP any WIDGETS created by the 
           persistent procedure. */
        ASSIGN run_flags = "_PERSISTENT,_PAUSE,_KEEP-WIDGETS":U.
        RUN adecomm/_runcode.p
            (INPUT run-pgm , INPUT run_flags , INPUT ? /* Stop_Widget */, OUTPUT app_handle ).
      END.
      ELSE DO:
        IF NOT RETRY THEN
        DO:
          ASSIGN run_flags = "_PAUSE":U.
          RUN disable_widgets IN THIS-PROCEDURE.
          RUN disable_widgets IN h_tool NO-ERROR.
          RUN adecomm/_runcode.p
            (INPUT run-pgm , INPUT run_flags , INPUT ? /* Stop_Widget */, OUTPUT app_handle ).
          IF NOT VALID-HANDLE(h_tool) THEN
             UNDO run-block.
        END.
        RUN enable_widgets IN h_tool NO-ERROR.
        RUN enable_widgets IN THIS-PROCEDURE.
      END.
    END.  /* DO ON STOP */
    ASSIGN wfRunning = "".
  END. /* IF run-pgm is not blank */  
  ELSE DO:
    MESSAGE "Enter a procedure to run."
        VIEW-AS ALERT-BOX ERROR BUTTONS OK IN WINDOW {&WINDOW-NAME}.
  END.
  IF VALID-HANDLE({&WINDOW-NAME}) THEN 
  DO:
     {&WINDOW-NAME}:MOVE-TO-TOP() .
     APPLY "ENTRY" TO run-pgm.
  END.

  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_browse run_win
ON CHOOSE OF btn_browse IN FRAME f_Run /* File... */
DO:
  DEFINE VAR l_ok AS LOGICAL NO-UNDO.
  DEFINE VAR filename AS CHAR NO-UNDO.
  DEFINE VAR Filter_NameString AS CHAR EXTENT 5                NO-UNDO.
  DEFINE VAR Filter_FileSpec   LIKE Filter_NameString          NO-UNDO.

  /* Initialize the file filters, for special cases. */
  ASSIGN Filter_NameString[ 1 ] = IF OPSYS = "UNIX":U
                                    THEN "All Source(*.[pw])"
                                    ELSE "All Source(*.p~;*.w)"
         Filter_FileSpec[ 1 ]   = IF OPSYS = "UNIX":U
                                    THEN "*.[pw]"
                                    ELSE "*.p~;*.w"
         Filter_NameString[ 2 ] = "Procedures(*.p)"
         Filter_FileSpec[ 2 ]   = "*.p"
         Filter_NameString[ 3 ] = "Windows(*.w)"
         Filter_FileSpec[ 3 ]   = "*.w"
         Filter_NameString[ 4 ] = "Compiled r-code(*.r)"
         Filter_FileSpec[ 4 ]   = "*.r" 
         Filter_NameString[ 5 ] = IF OPSYS = "UNIX":U
                                    THEN "All Files(*)"
                                    ELSE "All Files(*.*)"
         Filter_FileSpec[ 5 ]   = IF OPSYS = "UNIX":U
                                    THEN "*"
                                    ELSE "*.*".

  /* Ask for a file name. NOTE: File-names to run must exist */                          
  filename = run-pgm:SCREEN-VALUE.
  SYSTEM-DIALOG GET-FILE filename
      TITLE    "Run"
      FILTERS  Filter_NameString[ 1 ]   Filter_FileSpec[ 1 ],
               Filter_NameString[ 2 ]   Filter_FileSpec[ 2 ],
               Filter_NameString[ 3 ]   Filter_FileSpec[ 3 ],
               Filter_NameString[ 4 ]   Filter_FileSpec[ 4 ],
               Filter_NameString[ 5 ]   Filter_FileSpec[ 5 ]             
      MUST-EXIST
      UPDATE   l_ok IN WINDOW {&WINDOW-NAME}.  
  IF l_ok THEN run-pgm:SCREEN-VALUE = filename.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_close
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_close run_win
ON CHOOSE OF btn_close IN FRAME f_Run /* Close */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_Help run_win
ON CHOOSE OF btn_Help IN FRAME f_Run /* Help */
DO:
  RUN adecomm/_adehelp.p ( "ptls", "CONTEXT", {&Run_Procedure}, ? ).    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK run_win 


/* ***************************  Main Block  *************************** */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME}
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.
ON ALT-N OF FRAME f_run ANYWHERE DO:
    APPLY "ENTRY" TO run-pgm IN FRAME {&FRAME-NAME}.
END.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  APPLY "ENTRY" TO run-pgm.
  
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI run_win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(run_win)
  THEN DELETE WIDGET run_win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Disable_Widgets run_win 
PROCEDURE Disable_Widgets :
/*------------------------------------------------------------------------------
  Purpose:     Disables the widgets in this window before a run
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  ASSIGN btn_browse:SENSITIVE    = no
         btn_close:SENSITIVE     = no
         btn_Run:SENSITIVE       = no
         btn_Help:SENSITIVE      = no
         run-pgm:SENSITIVE       = no
         l_persistent:SENSITIVE  = no.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI run_win  _DEFAULT-ENABLE
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
  DISPLAY run-pgm l_persistent 
      WITH FRAME f_Run IN WINDOW run_win.
  ENABLE btn_close run-pgm btn_browse l_persistent btn_Run btn_Help 
      WITH FRAME f_Run IN WINDOW run_win.
  {&OPEN-BROWSERS-IN-QUERY-f_Run}
  VIEW run_win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Enable_Widgets run_win 
PROCEDURE Enable_Widgets :
/*------------------------------------------------------------------------------
  Purpose:     Enables widgets in the window after a run
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  ASSIGN btn_browse:SENSITIVE    = yes
         btn_close:SENSITIVE     = yes
         btn_Run:SENSITIVE       = yes
         btn_Help:SENSITIVE      = yes
         run-pgm:SENSITIVE       = yes
         l_persistent:SENSITIVE  = yes.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

