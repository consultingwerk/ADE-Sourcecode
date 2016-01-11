&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME WINDOW-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS WINDOW-1 
/***********************************************************************
* Copyright (C) 2000,2007 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*------------------------------------------------------------------------

  File:             _prospy.w

  Description:      Pro*Spy utility in Pro*Tools
                    Displays messaging between objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author:           J. Rothermal

  Created:          3/20/95

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

/* Parameters Definitions ---                                           */

/* Global and Shared Variable Definitions ---                           */
{protools/psvar.i &new = new}
{protools/_runonce.i}
{protools/ptlshlp.i} /* PRO*Tools Help include file */
{src/adm2/support/admhlp.i}  /* ADM Help include file */

DEFINE NEW GLOBAL SHARED VARIABLE wfRunning      AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h_ade_tool     AS HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE    NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VAR pFile             AS CHAR             NO-UNDO.

DEFINE VAR sNumFld           AS INT              NO-UNDO.
DEFINE VAR c-msg             AS INT              NO-UNDO.

DEFINE VAR logbuffer         AS HANDLE           NO-UNDO.
DEFINE VAR sFrame            AS HANDLE           NO-UNDO.
DEFINE VAR h_break           AS HANDLE           NO-UNDO.
DEFINE VAR h_filter          AS HANDLE           NO-UNDO.
DEFINE VAR hdl               AS HANDLE           NO-UNDO.
DEFINE VAR prospy_runwin     AS HANDLE           NO-UNDO.

DEFINE VAR Saved_File        AS LOG              NO-UNDO.
DEFINE VAR saved_log         AS LOG   INIT ?     NO-UNDO.
DEFINE VAR fOK               AS LOG              NO-UNDO.
DEFINE VAR Smart_Frame       AS LOG              NO-UNDO.

{adecomm/_adetool.i}   /* Signify PRO*Spy as an ADE Persistent Tool. */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME FRM-MAIN

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS EDITOR-1 RECT-3 btn-break btn-filter ~
btn-mark Btn-help RECT-12 l-step tgl-methods tgl-states 
&Scoped-Define DISPLAYED-OBJECTS EDITOR-1 l-step tgl-methods tgl-states 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR WINDOW-1 AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU mnu_File 
       MENU-ITEM m_Run          LABEL "&Run..."       
       RULE
       MENU-ITEM m_Save_As      LABEL "S&ave As..."   
       RULE
       MENU-ITEM m_Exit         LABEL "E&xit"         .

DEFINE SUB-MENU mnu_Options 
       MENU-ITEM m_Break        LABEL "&Break..."     
       MENU-ITEM m_Filter       LABEL "Fil&ter..."    
       MENU-ITEM m_Mark         LABEL "&Mark"         
       MENU-ITEM m_Clear        LABEL "&Clear"        
              DISABLED
       RULE
       MENU-ITEM m_Log          LABEL "&Log"          
              TOGGLE-BOX
       RULE
       MENU-ITEM m_msgcnt       LABEL "Set Message &Counter...".

DEFINE SUB-MENU mnu_Help 
       MENU-ITEM m_Contents     LABEL "&Help Topics"  
       MENU-ITEM m_Search       LABEL "&PRO*Spy Help"  ACCELERATOR "F1"
       RULE
       MENU-ITEM m_ADM          LABEL "&ADM Help..."  
       RULE
       MENU-ITEM m_About        LABEL "About &PRO*Spy".

DEFINE MENU mnu-bar MENUBAR
       SUB-MENU  mnu_File       LABEL "&File"         
       SUB-MENU  mnu_Options    LABEL "&Options"      
       SUB-MENU  mnu_Help       LABEL "&Help"         .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btn-break 
     LABEL "&Break...":L 
     SIZE 10 BY 1.

DEFINE BUTTON btn-clear 
     LABEL "&Clear":L 
     SIZE 10 BY 1.

DEFINE BUTTON btn-filter 
     LABEL "Fil&ter...":L 
     SIZE 10 BY 1.

DEFINE BUTTON Btn-help 
     LABEL "&Help":L 
     SIZE 10 BY 1.

DEFINE BUTTON btn-mark 
     LABEL "Mar&k":L 
     SIZE 10 BY 1.

DEFINE VARIABLE EDITOR-1 AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL LARGE
     SIZE 53.4 BY 9.38
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL 
     SIZE 54 BY 1.67.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL 
     SIZE 54 BY 2.

DEFINE VARIABLE l-step AS LOGICAL INITIAL no 
     LABEL "Ste&p Messages" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .76 NO-UNDO.

DEFINE VARIABLE tgl-methods AS LOGICAL INITIAL no 
     LABEL "&Methods" 
     VIEW-AS TOGGLE-BOX
     SIZE 11 BY .76 NO-UNDO.

DEFINE VARIABLE tgl-states AS LOGICAL INITIAL no 
     LABEL "&States" 
     VIEW-AS TOGGLE-BOX
     SIZE 10 BY .76 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME FRM-MAIN
     EDITOR-1 AT ROW 1.81 COL 2.6 NO-LABEL
     btn-break AT ROW 12.19 COL 4
     btn-filter AT ROW 12.19 COL 14
     btn-clear AT ROW 12.19 COL 24
     btn-mark AT ROW 12.19 COL 34
     Btn-help AT ROW 12.19 COL 44
     l-step AT ROW 14.33 COL 4
     tgl-methods AT ROW 14.33 COL 34
     tgl-states AT ROW 14.33 COL 45.4
     "SmartObjects" VIEW-AS TEXT
          SIZE 17 BY .67 AT ROW 1 COL 3
     "Methods/States" VIEW-AS TEXT
          SIZE 23 BY .67 AT ROW 1 COL 28
     RECT-3 AT ROW 11.62 COL 2
     RECT-12 AT ROW 13.86 COL 2
     "Display:" VIEW-AS TEXT
          SIZE 8 BY .76 AT ROW 14.33 COL 25
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         NO-LABELS SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: WINDOW
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW WINDOW-1 ASSIGN
         HIDDEN             = YES
         TITLE              = "PRO*Spy"
         COLUMN             = 38.8
         ROW                = 7.57
         HEIGHT             = 15.71
         WIDTH              = 55.8
         MAX-HEIGHT         = 24.14
         MAX-WIDTH          = 107.8
         VIRTUAL-HEIGHT     = 24.14
         VIRTUAL-WIDTH      = 107.8
         MAX-BUTTON         = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mnu-bar:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW WINDOW-1
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME FRM-MAIN
   Size-to-Fit                                                          */
ASSIGN 
       FRAME FRM-MAIN:SCROLLABLE       = FALSE
       FRAME FRM-MAIN:SENSITIVE        = FALSE.

ASSIGN 
       btn-break:PRIVATE-DATA IN FRAME FRM-MAIN     = 
                "Break".

/* SETTINGS FOR BUTTON btn-clear IN FRAME FRM-MAIN
   NO-ENABLE                                                            */
ASSIGN 
       btn-filter:PRIVATE-DATA IN FRAME FRM-MAIN     = 
                "Filter".

ASSIGN 
       Btn-help:MANUAL-HIGHLIGHT IN FRAME FRM-MAIN = TRUE.

ASSIGN 
       EDITOR-1:RETURN-INSERTED IN FRAME FRM-MAIN  = TRUE
       EDITOR-1:READ-ONLY IN FRAME FRM-MAIN        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(WINDOW-1)
THEN WINDOW-1:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Btn-help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-help WINDOW-1
ON CHOOSE OF Btn-help IN FRAME FRM-MAIN /* Help */
DO:
    RUN adecomm/_adehelp.p 
        ( INPUT "ptls", INPUT "CONTEXT" , INPUT {&Pro_Spy_Window}, INPUT "" ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-step
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-step WINDOW-1
ON VALUE-CHANGED OF l-step IN FRAME FRM-MAIN /* Step Messages */
DO:
  
  IF l-step:CHECKED THEN c-msg = 0.
    
END.


&Scoped-define SELF-NAME m_About
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_About WINDOW-1
ON CHOOSE OF MENU-ITEM m_About /* About Pro*Spy */
DO:

    RUN adecomm/_about.p ( "PRO*Spy" , "adeicon/prospy" ).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mnu_File
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mnu_File WINDOW-1
ON MENU-DROP OF MENU mnu_File /* File */
DO:
  IF NOT VALID-HANDLE(app_handle) THEN
  DO:
    FOR EACH pgm-bf:
      DELETE pgm-bf NO-ERROR.
    END.
    
    FOR EACH pp:
      DELETE pp NO-ERROR.
    END.
    
    FOR EACH def-bf:
      DELETE def-bf NO-ERROR.
    END.
    
    FOR EACH adm-methods-bf:
      DELETE adm-methods-bf NO-ERROR.
    END.    
    
    MENU-ITEM m_Run:SENSITIVE IN MENU mnu_File = yes.
    
    RUN adecomm/_statdsp.p
    (INPUT sFrame,
     INPUT 1,
     INPUT "").
  END.     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_ADM
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_ADM WINDOW-1
ON CHOOSE OF MENU-ITEM m_ADM /* ADM Help... */
DO:
  
    RUN adecomm/_adehelp.p 
        ( INPUT "uib", INPUT "CONTEXT" , INPUT {&ADM_Basics}, INPUT "" ).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Break
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Break WINDOW-1
ON CHOOSE OF MENU-ITEM m_Break /* Break... */
, btn-break DO:

  IF VALID-HANDLE(h_break) THEN
     RUN Init_Window IN h_break.
  ELSE
     RUN protools/_break.w PERSISTENT SET h_break (INPUT "Breaks").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Clear
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Clear WINDOW-1
ON CHOOSE OF MENU-ITEM m_Clear /* Clear */
, btn-clear DO:
 
  ASSIGN
    editor-1:SCREEN-VALUE IN FRAME FRM-MAIN = ""
    btn-Clear:SENSITIVE = NO
    MENU-ITEM m_Clear:SENSITIVE IN MENU mnu_Options = NO.
    
  IF VALID-HANDLE(logbuffer) THEN
    logbuffer:SCREEN-VALUE = "".
            
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Contents
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Contents WINDOW-1
ON CHOOSE OF MENU-ITEM m_Contents /* Help Topics */
DO:
  RUN adecomm/_adehelp.p 
      ( INPUT "ptls", INPUT "TOPICS" , INPUT ?, INPUT "" ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Exit WINDOW-1
ON CHOOSE OF MENU-ITEM m_Exit /* Exit */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Filter
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Filter WINDOW-1
ON CHOOSE OF MENU-ITEM m_Filter /* Filter... */
, btn-Filter DO:
  IF VALID-HANDLE(h_filter) THEN
     RUN Init_Window IN h_filter.
  ELSE
     RUN protools/_break.w PERSISTENT SET h_filter (INPUT "Filters").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Log
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Log WINDOW-1
ON VALUE-CHANGED OF MENU-ITEM m_Log /* Log */
DO:
  
  IF MENU-ITEM m_log:CHECKED IN MENU mnu_Options THEN DO:
     CREATE EDITOR logbuffer
     ASSIGN LARGE  = YES
            FRAME  = FRAME frm-main:HANDLE
            HIDDEN = YES.
     saved_log = NO.
  END. 

  RUN adecomm/_statdsp.p                                       
      (INPUT sFrame, 
       INPUT 2, 
       INPUT 'Logging ' + 
             STRING(MENU-ITEM m_log:CHECKED IN MENU mnu_Options,"ON/OFF")).
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Mark
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Mark WINDOW-1
ON CHOOSE OF MENU-ITEM m_Mark /* Mark */
, btn-mark DO:

DEFINE VAR l-dummy    AS LOG NO-UNDO.

ASSIGN
l-dummy = editor-1:INSERT-STRING(CHR(KEYCODE("RETURN")) + FILL(" ",10) +
          "**********************************************************" + 
          CHR(KEYCODE("RETURN")) + CHR(KEYCODE("RETURN")))
         IN FRAME {&frame-name}.

IF MENU-ITEM m_log:CHECKED IN MENU mnu_Options THEN 
  l-dummy = logbuffer:INSERT-STRING(CHR(KEYCODE("RETURN")) + FILL(" ",10) +
            "**********************************************************" + 
            CHR(KEYCODE("RETURN")) + CHR(KEYCODE("RETURN"))).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_msgcnt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_msgcnt WINDOW-1
ON CHOOSE OF MENU-ITEM m_msgcnt /* Set Message Counter... */
DO:
  RUN protools/_msgcnt.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Run
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Run WINDOW-1
ON CHOOSE OF MENU-ITEM m_Run /* Run... */
DO:

   RUN RunFile.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Save_As
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Save_As WINDOW-1
ON CHOOSE OF MENU-ITEM m_Save_As /* Save As... */
DO:
  IF VALID-HANDLE(logbuffer) THEN DO:
      saved_log = YES.
      RUN SaveAsFile (logbuffer:HANDLE).
  END.
  ELSE
      RUN SaveAsFile (editor-1:HANDLE IN FRAME frm-main).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Search
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Search WINDOW-1
ON CHOOSE OF MENU-ITEM m_Search /* PRO*Spy Help */
DO:   
    RUN adecomm/_adehelp.p 
        ( INPUT "ptls", INPUT "CONTEXT" , INPUT {&Pro_Spy_Window}, INPUT "" ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK WINDOW-1 


/* ***************************  Main Block  *************************** */

IF "{&WINDOW-SYSTEM}" = "OSF/MOTIF" THEN
  RUN motif-window.


/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                  = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW   = {&WINDOW-NAME}.

/* Shared var used to parent the Breaks and Filters windows. */
ASSIGN ps_window = {&WINDOW-NAME}.

/* Ensure that the window cannot be resized by the WINDOW-MAXIMIZED event. */
ASSIGN {&WINDOW-NAME}:MAX-WIDTH  = {&WINDOW-NAME}:WIDTH
       {&WINDOW-NAME}:MAX-HEIGHT = {&WINDOW-NAME}:HEIGHT .

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE DO:
    RUN Destroy.
    IF RETURN-VALUE = "NO-APPLY":U THEN
        RETURN NO-APPLY.
END.

/* These events will close the window and terminate the procedure.      */
/* (NOTE: this will override any user-defined triggers previously       */
/*  defined on the window.)                                             */
ON WINDOW-CLOSE OF {&WINDOW-NAME} DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

ON ENDKEY, END-ERROR OF {&WINDOW-NAME} ANYWHERE DO:
  IF MENU-ITEM m_Exit:SENSITIVE IN MENU mnu_File = TRUE THEN
    APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/*
/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.
*/

/* Prevent this procedure from being called twice (by checking FILE-NAME) */
IF THIS-PROCEDURE:PERSISTENT THEN DO:
  /* See if a copy already exists. */
  hdl = SESSION:FIRST-PROCEDURE.
  DO WHILE VALID-HANDLE(hdl):   
    IF hdl ne THIS-PROCEDURE AND hdl:FILE-NAME eq THIS-PROCEDURE:FILE-NAME THEN
    DO ON STOP UNDO, RETRY:
      IF NOT RETRY THEN
        MESSAGE "PRO*Spy is already running."
              VIEW-AS ALERT-BOX WARNING BUTTONS OK IN WINDOW {&WINDOW-NAME}.
      DELETE PROCEDURE THIS-PROCEDURE.
      RETURN.
    END.
    hdl = hdl:NEXT-SIBLING.
  END.
END. 

ASSIGN fOK = {&WINDOW-NAME}:LOAD-ICON("adeicon/prospy").

/* Now enable the interface and wait for the exit condition.            */
MAIN-BLOCK:
DO ON STOP UNDO MAIN-BLOCK, RETRY MAIN-BLOCK:
  IF NOT RETRY THEN
  DO:   
    RUN enable_UI.         
    RUN RunFile.           
  
    IF NOT THIS-PROCEDURE:PERSISTENT THEN 
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
  END.
  ELSE APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Close_RunWin WINDOW-1 
PROCEDURE Close_RunWin :
/*--------------------------------------------------------------------------
    Purpose:        Called by PRO*Spy Run Window when user chooses
                    to close window. Only applies to running SmartFrames.

    Run Syntax:     RUN Close_RunWin.
    
    Parameters:
        
    Description:    Uses RETURN-VALUE "NO-APPLY" to cancel the Exit.

    Notes:
  ---------------------------------------------------------------------------*/
 
  IF VALID-HANDLE(app_handle) THEN
  DO ON STOP UNDO, LEAVE:
    RUN dispatch IN app_handle ("destroy":u).
    IF VALID-HANDLE(app_handle) THEN
        APPLY "CLOSE" TO app_handle.
    IF VALID-HANDLE(app_handle) THEN
      DELETE PROCEDURE app_handle NO-ERROR.
  END.
  
  /* If we needed to create a run window, delete it now. */
  IF VALID-HANDLE(prospy_runwin) THEN DELETE WIDGET prospy_runwin.

  FOR EACH pgm-bf:
    DELETE pgm-bf NO-ERROR.
  END.
    
  FOR EACH pp:
    DELETE pp NO-ERROR.
  END.
    
  FOR EACH def-bf:
    DELETE def-bf NO-ERROR.
  END.
    
  FOR EACH adm-methods-bf:
    DELETE adm-methods-bf NO-ERROR.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Destroy WINDOW-1 
PROCEDURE Destroy :
/*--------------------------------------------------------------------------
    Purpose:        Low-level routine to exit PRO*Spy.

    Run Syntax:     RUN Destroy.
    
    Parameters:
        
    Description:    Uses RETURN-VALUE "NO-APPLY" to cancel the Exit.

    Notes:
  ---------------------------------------------------------------------------*/
 
   DEF VAR save-now AS LOGICAL NO-UNDO.

   RUN Close_RunWin.

   IF MENU-ITEM m_log:CHECKED IN MENU mnu_Options AND
      NOT Saved_File THEN
   DO ON STOP UNDO, RETURN:
      MESSAGE "Messages have been logged but not saved." SKIP
              "Would you like to save them now?" 
              VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
              UPDATE save-now.
      IF save-now THEN RUN SaveAsFile (logbuffer:HANDLE).
   END.

   /* If they are open, remove the Break and Filter windows. */
   IF VALID-HANDLE(h_break) THEN
     RUN disable_UI IN h_break.
   IF VALID-HANDLE(h_filter) THEN
     RUN disable_UI IN h_filter.
     
   RUN disable_UI.            

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI WINDOW-1 _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(WINDOW-1)
  THEN DELETE WIDGET WINDOW-1.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI WINDOW-1 
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
  ASSIGN
  tgl-methods = YES
  tgl-states  = YES.
  
  RUN adecomm/_status.p 
      ({&window-name},
       "30,12",
       False,
       4,
       OUTPUT sFrame,
       OUTPUT sNumFld).

  ASSIGN
  sframe:Y      = {&window-name}:HEIGHT-P - sframe:HEIGHT-P
  sframe:HIDDEN = NO.

  DISPLAY EDITOR-1 tgl-states tgl-methods
      WITH FRAME frm-main IN WINDOW WINDOW-1.
      
  ENABLE EDITOR-1 btn-filter btn-break btn-mark 
        btn-help l-step tgl-methods tgl-states 
        WITH FRAME frm-main IN WINDOW {&window-name}.
  {&OPEN-BROWSERS-IN-QUERY-frm-main}

  VIEW WINDOW-1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FileSave WINDOW-1 
PROCEDURE FileSave :
/*--------------------------------------------------------------------------
    Purpose:        Low-level routine to save buffer contents to os file.
                    Updates Window Title if file name has changed.

    Run Syntax:     RUN FileSave ( INPUT p_Buffer , 
                                   INPUT p_File_Selected ,
                                   OUTPUT p_Saved_File ) .

    Parameters:
        
    Description:

    Notes:
  ---------------------------------------------------------------------------*/
 
  DEFINE INPUT PARAMETER p_Buffer        AS WIDGET-HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p_File_Selected AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER p_Saved_File   AS LOGICAL NO-UNDO.
  
  DEFINE VAR Old_BufName AS CHAR NO-UNDO .
  DEFINE VAR Save_OK     AS LOGICAL NO-UNDO.
   
    ASSIGN p_Saved_File = p_Buffer:SAVE-FILE( p_File_Selected ) NO-ERROR .

    IF ( NOT p_Saved_File )
    THEN DO:
        MESSAGE p_Buffer:PRIVATE-DATA SKIP
          "Cannot save to this file."  SKIP(1)
          "File is read-only or the path specified" SKIP
          "is invalid. Use a different filename."
          VIEW-AS ALERT-BOX WARNING BUTTONS OK.
    END.
    
    IF ( NOT p_Saved_File )
    THEN DO:
        ASSIGN
            p_Buffer:PRIVATE-DATA = Old_BufName
            p_Saved_File      = FALSE
            Saved_File        = FALSE
        .
        RETURN.
    END.
                    
    ASSIGN
    Saved_File   = TRUE  /* Global status var. */
    p_Saved_File = TRUE.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE motif-window WINDOW-1 
PROCEDURE motif-window :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  ASSIGN
      {&window-name}:width = 62
      {&window-name}:max-width = 62
      {&window-name}:virtual-width = 62
      
      FRAME {&frame-name}:width = 62
      
      editor-1:width = 59
      
      rect-12:width = 60
      rect-3:width = 60
      
      btn-break:column = 3
      btn-break:width = 11.50
      
      btn-filter:column = 14.50
      btn-filter:width = 11.50
      
      btn-clear:column = 26
      btn-clear:width = 11.50
      
      btn-mark:column = 37.50
      btn-mark:width = 11.50
      
      btn-help:column = 49.5
      btn-help:width = 11.50
            
      l-step:width = 17
      l-step:height = .80
      
      tgl-methods:column = 32
      tgl-methods:width = 11

      tgl-states:column = 44
      tgl-states:width = 11.
      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE receive-message WINDOW-1 
PROCEDURE receive-message :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  2 parameters passed 
               pc-procedure: handle to the procedure calling this
                             routine.
               pc-type     : message type
               pc-input    : comma-separated list with the
                             method being executed and any parameters              
 Notes:       
-------------------------------------------------------------*/

DEFINE INPUT PARAMETER pc-procedure AS HANDLE NO-UNDO.
DEFINE INPUT PARAMETER pc-type      AS CHAR   NO-UNDO.
DEFINE INPUT PARAMETER pc-input     AS CHAR   NO-UNDO.

        
DEFINE VAR pc-param      AS CHAR   NO-UNDO.
DEFINE VAR pc-method     AS CHAR   NO-UNDO.
DEFINE VAR prefix        AS CHAR   NO-UNDO.
DEFINE VAR msg-text      AS CHAR   NO-UNDO.
DEFINE VAR p-name        AS CHAR   NO-UNDO.

DEFINE VAR l-dummy       AS LOG    NO-UNDO.
DEFINE VAR found-break   AS LOG    NO-UNDO.
DEFINE VAR found-filter  AS LOG    NO-UNDO.
DEFINE VAR filtering     AS LOG    NO-UNDO.   
DEFINE VAR breaking      AS LOG    NO-UNDO.   

DEFINE VAR l-cursor_pos  AS LOG.
DEFINE VAR l-choice      AS LOG.

DEFINE BUFFER spgm-bf    FOR pgm-bf.

DEFINE VAR attr-settings AS CHAR   NO-UNDO.


ASSIGN FRAME FRM-MAIN tgl-methods tgl-states.
ASSIGN                                 
    pc-method    = ENTRY(1,pc-type)       
    pc-param     = pc-type
    pc-param     = REPLACE(pc-param,pc-method + ",","")
    found-break  = NO
    found-filter = NO
    filtering    = CAN-FIND(FIRST pgm-bf WHERE pgm-bf.cType = NO)
    breaking     = CAN-FIND(FIRST pgm-bf WHERE pgm-bf.cType = YES).

IF tgl-methods AND not tgl-states AND
   INDEX(pc-param,"new-state") <> 0 THEN RETURN.
                
IF NOT tgl-methods AND tgl-states AND  
   INDEX(pc-param,"new-state") = 0 THEN RETURN.


/* If filter record found then found-filter = TRUE ELSE FALSE */
IF filtering THEN
DO:
  FIND pgm-bf WHERE pgm-bf.cFileName = pc-procedure:FILE-NAME 
                AND pgm-bf.cType     = NO NO-ERROR.
  IF AVAILABLE pgm-bf THEN 
  DO:
    IF pgm-bf.cMethod = "NONE" THEN found-filter = no.
    ELSE
    DO:
      IF pc-input MATCHES ("notify*") AND pgm-bf.cMethod EQ "notify" 
        AND pc-procedure:FILE-NAME EQ pgm-bf.cFileName THEN
        found-filter = yes.
      ELSE
        found-filter = CAN-DO(pgm-bf.cMethod,pc-input).
    END.
  END.                                        
END.


/* If break record found then found-break = TRUE ELSE FALSE */
IF breaking THEN
DO:
  FIND pgm-bf WHERE pgm-bf.cFileName = pc-procedure:FILE-NAME 
                AND pgm-bf.cType     = YES NO-ERROR.   
  IF AVAILABLE pgm-bf THEN 
  DO:
    IF pgm-bf.cMethod = "NONE" THEN found-break = no.
    ELSE
      DO:
        IF pc-input MATCHES ("notify*") AND pgm-bf.cMethod EQ "notify" 
           AND pc-procedure:FILE-NAME EQ pgm-bf.cFileName THEN
          found-break = yes.
        ELSE
          found-break = CAN-DO(pgm-bf.cMethod,pc-input).
      END.
  END.
END.

/* If filtering and filter record matched current message received then */
/* return to calling procedure else continue and print message out */
IF filtering AND found-filter THEN RETURN.

IF NOT tgl-methods AND NOT tgl-states THEN RETURN.


ASSIGN
   l-cursor_pos = editor-1:MOVE-TO-EOF()
   c-msg        = c-msg + 1                                     
   prefix       = IF found-break THEN "*" ELSE " "
   p-name       = pc-procedure:FILE-NAME
   p-name       = IF INDEX(p-name,"/") > 0 THEN SUBSTR(p-name,R-INDEX(p-name,"/") + 1)
                  ELSE p-name
   p-name       = IF INDEX(p-name,"~\") > 0 THEN SUBSTR(p-name,R-INDEX(p-name,"~\") + 1)
                  ELSE p-name
   msg-text     = ((prefix + lc(p-name)) + " ":U10) + CHR(9) +
                  lc(pc-input) + FILL(" ",12 - LENGTH(pc-input))
   msg-text     = msg-text + CHR(10)     
   l-dummy      = editor-1:INSERT-STRING(msg-text) IN FRAME {&frame-name}
                                
   btn-Clear:SENSITIVE = YES
   MENU-ITEM m_Clear:SENSITIVE IN MENU mnu_Options = YES.


IF MENU-ITEM m_log:CHECKED IN MENU mnu_Options THEN 
  l-dummy = logbuffer:INSERT-STRING(msg-text). 

IF found-break THEN 
DO:
  ASSIGN                                  
    c-msg   = msgcnt.

  IF l-step:CHECKED EQ FALSE THEN
  DO:   
    MESSAGE "Stopped at:  "  pc-input SKIP(1)
            "                in:  "  p-name SKIP(1)
            " Stepping is not on, would you like to turn it on?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
            TITLE "Question" UPDATE l-choice.
       
     IF l-choice EQ TRUE THEN 
     DO:
       ASSIGN l-step = yes.
       DISPLAY l-step WITH FRAME frm-main.
     END.
  END.
  ELSE IF l-step:CHECKED EQ TRUE THEN
  DO:
    MESSAGE "Stopped at:  " pc-input SKIP(1)
            "               in:  " p-name  SKIP(1)
            " Stepping is on, would you like to turn it off?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
            TITLE "Question" UPDATE l-choice.
       
    IF l-choice EQ TRUE THEN
    DO:
      ASSIGN l-step = no.
      DISPLAY l-step WITH FRAME frm-main.
    END.
  END.      
END.

IF l-step:CHECKED THEN  
DO:
  l-dummy = {&window-name}:MOVE-TO-TOP().
  
  IF c-msg = msgcnt THEN 
  DO:
    MESSAGE "Stepping ..." SKIP(1)
            "Would you like to turn stepping off?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
            TITLE "Question" UPDATE l-choice.
     
    IF l-choice EQ TRUE THEN
    DO:
      ASSIGN l-step = no.
      DISPLAY l-step WITH FRAME frm-main.
    END.

    c-msg = 0.
  END. /* msgcnt limit hit */
END.   /* l-step:CHECKED */ 

/* If broker.p adm-destroy, clear the Break and Filter windows. */
IF TRIM(pc-input) = "adm-destroy":U AND p-name = "broker.p":U THEN
DO:
  /* Clear the Break and Filter windows. */
  IF VALID-HANDLE(h_break) THEN
    RUN Reset_Lists IN h_break.
  IF VALID-HANDLE(h_filter) THEN
    RUN Reset_Lists IN h_filter.
    
  /* Enable the Run option. */
  ASSIGN MENU-ITEM m_Run:SENSITIVE IN MENU mnu_File = YES.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RunFile WINDOW-1 
PROCEDURE RunFile :
/*--------------------------------------------------------------------------
    Purpose:        Executes the RUN command, which allows user to select
                    and run an existing file.

    Run Syntax:     RUN RunnFile.

    Parameters:

    Description:

        1. Prompts user for name of file to open.

    Notes:
  ---------------------------------------------------------------------------*/

  DEFINE VARIABLE OF_OK         AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE Valid_BufName AS LOGICAL   NO-UNDO.   
  DEFINE VARIABLE WF_Run        AS LOGICAL   NO-UNDO.
  
  DEFINE VARIABLE File_Selected AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE tBuffer       AS HANDLE    NO-UNDO.       
 

  CREATE EDITOR tBuffer
  ASSIGN large  = yes
         WIDTH  = 25
         HEIGHT = 10
         ROW    = 2
         COL    = 1
         HIDDEN = YES
         FRAME  = FRAME frm-main:HANDLE
         .

  File_Selected = ?.
  OPEN_BLOCK:
  DO WHILE TRUE:
    
    RUN adecomm/_getfile.p (INPUT WINDOW-1 , INPUT "PRO*Spy" , 
                            "OPEN":U , "Run" , "OPEN":U , 
                            INPUT-OUTPUT File_Selected ,
                            OUTPUT OF_OK ).
    IF NOT OF_OK THEN DO:
        DELETE WIDGET tBuffer.  
        RETURN. /* User pressed Cancel. */
    END.

    OF_OK = tBuffer:READ-FILE(File_Selected).
    IF OF_OK THEN DO:
       /* If the file does not have the ADM-CONTAINER preprocessor,
          then tell user its not a SmartContainer and don't let them
          run the procedure. */
       OF_OK = tBuffer:SEARCH("&Scoped-define ADM-CONTAINER":U,
                              FIND-NEXT-OCCURRENCE).
       IF NOT OF_OK THEN
       DO ON STOP UNDO, RETRY:
           IF NOT RETRY THEN
                MESSAGE File_Selected SKIP
                       "Cannot run this procedure." SKIP(1)
                       "PRO*Spy can only run SmartContainers."
                  VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
           NEXT OPEN_BLOCK.
       END. 
    END.
    /* We'll need to know if its a SmartFrame for controlling the window
       a SmartFrame runs in.
    */
    ASSIGN Smart_Frame = tBuffer:SEARCH("Type: SmartFrame":U, FIND-NEXT-OCCURRENCE).
                                  
    /* Scan back up the file to see if the UIB-generated Connected Databases
       line is present. If it is and there are no db's connected, warn
       the user and make them connect to a database. */
    OF_OK = tBuffer:SEARCH("/" + "* Connected Databases":U, FIND-PREV-OCCURRENCE).
    
    IF OF_OK = TRUE AND NUM-DBS = 0 THEN
    DO ON STOP UNDO, RETRY:
       IF NOT RETRY THEN
            RUN adecomm/_dbcnnct.p
                (INPUT "You must have at least one connected database to " +
                       "access database information.",
                 OUTPUT OF_OK).
         IF NOT OF_OK OR RETRY THEN NEXT OPEN_BLOCK.
    END.

    RUN adecomm/_setcurs.p (INPUT "WAIT":U).

    /* Register PRO*Spy running a procedure. */
    RUN adecomm/_wfrun.p (INPUT "PRO*Spy.", OUTPUT WF_Run).
    /* If another tool is already running a procedure, can't proceed */
    IF WF_Run THEN
    DO:
      RUN adecomm/_setcurs.p (INPUT "").
      RETURN.
    END.
    
    RUN adecomm/_runcode.p
           ( INPUT File_Selected,
             INPUT "_PERSISTENT, _KEEP-WIDGETS",
             INPUT ?,
             OUTPUT app_handle ).
    ASSIGN wfrunning = "".
    
    RUN set-watchdog IN adm-broker-hdl (INPUT THIS-PROCEDURE) NO-ERROR.
    
    IF NOT ERROR-STATUS:ERROR THEN 
    DO:
        /* Ensure SmartFrame code does not parent to PRO*Spy's window
           by pointing current-window to PRO*Spy Run Window. */
        IF Smart_Frame THEN
        DO:
          /* We create the run window new each time so it always has
             the default Progress window characteristics. */
          IF VALID-HANDLE(prospy_runwin) THEN DELETE WIDGET prospy_runwin.
          CREATE WINDOW prospy_runwin
              ASSIGN PARENT = WINDOW-1
                     TITLE  = "PRO*Spy - Run"
              TRIGGERS:
                ON WINDOW-CLOSE PERSISTENT
                    RUN Close_RunWin IN THIS-PROCEDURE.
              END TRIGGERS.
          ASSIGN CURRENT-WINDOW = prospy_runwin.
        END.
        
        RUN dispatch IN app_handle ("initialize").

        /* If the Break or Filter windows are open, initialize them. */
        IF VALID-HANDLE(h_break) THEN
            RUN Init_Window IN h_break.
        IF VALID-HANDLE(h_filter) THEN
            RUN Init_Window IN h_filter.

        LEAVE OPEN_BLOCK. 
    END. /* IF NOT ERROR-STATUS */

  END. /* DO OPEN_BLOCK */
                                   
  /* We don't need the edit widget anymore. */
  IF VALID-HANDLE(tBuffer) THEN DELETE WIDGET tBuffer.  

  RUN adecomm/_setcurs.p (INPUT "").

  ASSIGN
    pFile             = File_Selected
    MENU-ITEM m_Run:SENSITIVE IN MENU mnu_File = no.
  
  RUN adecomm/_statdsp.p 
      (INPUT sFrame, 
       INPUT 1, 
       INPUT pFile).

  RUN adecomm/_statdsp.p 
      (INPUT sFrame, 
       INPUT 2, 
       INPUT 'Logging ' + 
             STRING(MENU-ITEM m_log:CHECKED IN MENU mnu_Options,"ON/OFF")).
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SaveAsFile WINDOW-1 
PROCEDURE SaveAsFile :
/*--------------------------------------------------------------------------
    Purpose:        Executes the SAVE AS command, saving contents of logging
                    buffer to a user selected file name.

    Run Syntax:     RUN SaveAsFile ( INPUT p_Buffer ) .

    Parameters:

    Description:

        1. Prompts user for name of file to save current edit buffer
           contents to.
        2. Calls SaveFile procedure to execute actual save.

        Users execute the SAVE AS command to:
            1.  Save an Untitled file.
            2.  Save an existing file to a different file name.

    Notes:
  ---------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO .

  DEFINE VARIABLE File_Selected AS CHAR NO-UNDO.
  DEFINE VARIABLE SA_OK AS LOGICAL NO-UNDO.
  DEFINE VARIABLE Old_Filename AS CHAR NO-UNDO.
  DEFINE VARIABLE Valid_BufName AS LOGICAL NO-UNDO .
  
  SAVE_AS_BLOCK:
  DO WHILE TRUE:

    RUN adecomm/_getfile.p
        ( INPUT {&WINDOW-NAME},
          INPUT "PROSPY",
          INPUT "Save As" ,
          INPUT "Save As",
          INPUT "SAVE",
          INPUT-OUTPUT File_Selected ,
          OUTPUT SA_OK ) .

    IF NOT SA_OK THEN RETURN. /* User pressed Cancel. */  
    
    RUN FileSave ( INPUT p_Buffer , INPUT File_Selected  ,
                   OUTPUT Saved_File ).
    IF ( Saved_File = TRUE ) THEN LEAVE SAVE_AS_BLOCK.

  END. /* DO */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

