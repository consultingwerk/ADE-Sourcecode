&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          temp-db          PROGRESS
*/
&Scoped-define WINDOW-NAME WINDOW-1

/* Temp-Table and Buffer definitions                                    */
&IF DEFINED(UIB_is_Running) NE 0 &THEN
    DEFINE TEMP-TABLE tSpyInfo NO-UNDO LIKE tSpyInfo.

&ELSE
    
    {protools/prospy.i}
&ENDIF

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS WINDOW-1 
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

  File:             _prospy9.w
  WARNING!!!!! If you save this in the appbuilder, you will lose the temp-table
  definition which is needed for the build in order to compile successfully. 
  Please put the following code back in after saving in appbuilder:

&IF DEFINED(UIB_is_Running) NE 0 &THEN
    DEFINE TEMP-TABLE tSpyInfo NO-UNDO LIKE tSpyInfo.

&ELSE
    
    {protools/prospy.i}
&ENDIF

  
  
  Description:      PRO*Spy for version 9 utility in Pro*Tools
                    Displays execution path information  for debugging
                    an ADM2 smartObject application

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  
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
{adm2/support/admhlp.i}  /* ADM Help include file */
 
DEFINE NEW GLOBAL SHARED VARIABLE wfRunning      AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h_ade_tool     AS HANDLE    NO-UNDO.


/* Local Variable Definitions ---                                       */
DEFINE  VARIABLE      iCount            AS INT INIT 0 NO-UNDO. /* temp-table record count */
DEFINE  VARIABLE      start-log-now     AS LOGICAL NO-UNDO INIT FALSE. /* whether we start logging at beginning or later */
DEFINE  VARIABLE      File_Selected     AS CHARACTER NO-UNDO. /* name of file we are debugging */
DEFINE  VARIABLE      iCountMark        AS INTEGER INIT 0 no-undo.
DEFINE  VARIABLE      hdl               AS HANDLE NO-UNDO.
DEFINE  VARIABLE      prospy_runwin     AS HANDLE NO-UNDO.

DEFINE  VARIABLE      fOK               AS LOGICAL NO-UNDO.
DEFINE  VARIABLE      Smart_Frame       AS LOGICAL NO-UNDO.
DEFINE  VARIABLE      Saved_File        AS LOGICAL NO-UNDO.

{adecomm/_adetool.i}   /* Signify PRO*Spy as an ADE Persistent Tool. */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME FRM-MAIN
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tSpyInfo

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 tSpyInfo.tSrcProc ~
tSpyInfo.tProcName tSpyInfo.tType tSpyInfo.tParms tSpyInfo.tTarget ~
tSpyInfo.tSource 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 tSpyInfo.tParms 
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-1 tSpyInfo
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-1 tSpyInfo
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH tSpyInfo NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 tSpyInfo
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 tSpyInfo


/* Definitions for FRAME FRM-MAIN                                       */
&Scoped-define OPEN-BROWSERS-IN-QUERY-FRM-MAIN ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btn-clear btn-mark btn-endLog btn-startLog ~
RECT-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToken WINDOW-1 
FUNCTION getToken RETURNS CHARACTER
  ( INPUT-OUTPUT txt AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD parseIt WINDOW-1 
FUNCTION parseIt RETURNS LOGICAL
  ( INPUT-OUTPUT txt AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD spyFunc WINDOW-1 
FUNCTION spyFunc RETURNS LOGICAL
  ( INPUT src AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR WINDOW-1 AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU mnu_File 
       MENU-ITEM m_Run          LABEL "&Run..."       
       RULE
       MENU-ITEM m_Save         LABEL "&Save"         
       RULE
       MENU-ITEM m_Exit         LABEL "E&xit"         .

DEFINE SUB-MENU mnu_Help 
       MENU-ITEM m_Contents     LABEL "&Help Topics"  
       MENU-ITEM m_Search       LABEL "&PRO*Spy Help"  ACCELERATOR "F1"
       RULE
       MENU-ITEM m_About        LABEL "About &PRO*Spy".

DEFINE MENU mnu-bar MENUBAR
       SUB-MENU  mnu_File       LABEL "&File"         
       SUB-MENU  mnu_Help       LABEL "&Help"         .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btn-clear 
     IMAGE-UP FILE "adeicon/psclear.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "&Clear" 
     SIZE 4.8 BY 1.1 TOOLTIP "Clear Browse".

DEFINE BUTTON btn-endLog 
     IMAGE-UP FILE "adeicon/psend.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "&End Log" 
     SIZE 4.8 BY 1.1 TOOLTIP "End Logging".

DEFINE BUTTON btn-mark 
     IMAGE-UP FILE "adeicon/psmark.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "&Mark" 
     SIZE 4.8 BY 1.1 TOOLTIP "Mark Browse".

DEFINE BUTTON btn-startLog 
     IMAGE-UP FILE "adeicon/psstart.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "&Start Log" 
     SIZE 4.8 BY 1.1 TOOLTIP "Start Logging".

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 22 BY 1.43.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      tSpyInfo SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 WINDOW-1 _STRUCTURED
  QUERY BROWSE-1 NO-LOCK DISPLAY
      tSpyInfo.tSrcProc COLUMN-LABEL "Stmt Location" FORMAT "X(28)":U
            WIDTH 19
      tSpyInfo.tProcName COLUMN-LABEL "ProcName/Event" FORMAT "X(28)":U
            WIDTH 19
      tSpyInfo.tType COLUMN-LABEL "Statement" FORMAT "X(10)":U
            WIDTH 12.2
      tSpyInfo.tParms COLUMN-LABEL "Parameters" FORMAT "X(320)":U
            WIDTH 17
      tSpyInfo.tTarget COLUMN-LABEL "Target Proc" FORMAT "X(28)":U
            WIDTH 15.4
      tSpyInfo.tSource COLUMN-LABEL "Source File" FORMAT "X(28)":U
            WIDTH 26
  ENABLE
      tSpyInfo.tParms
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 118 BY 8.1
         FONT 4 EXPANDABLE.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME FRM-MAIN
     BROWSE-1 AT ROW 2.67 COL 3
     btn-clear AT ROW 1.48 COL 14
     btn-mark AT ROW 1.48 COL 19
     btn-endLog AT ROW 1.48 COL 9
     btn-startLog AT ROW 1.48 COL 4
     RECT-1 AT ROW 1.24 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         NO-LABELS SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 122 BY 10
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: WINDOW
   Temp-Tables and Buffers:
      TABLE: tSpyInfo T "?" NO-UNDO TEMP-DB tSpyInfo
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW WINDOW-1 ASSIGN
         HIDDEN             = YES
         TITLE              = "PRO*Spy"
         COLUMN             = 21.4
         ROW                = 9.33
         HEIGHT             = 10.52
         WIDTH              = 126
         MAX-HEIGHT         = 24.14
         MAX-WIDTH          = 168.2
         VIRTUAL-HEIGHT     = 24.14
         VIRTUAL-WIDTH      = 168.2
         MAX-BUTTON         = no
         RESIZE             = yes
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



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW WINDOW-1
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME FRM-MAIN
                                                                        */
/* BROWSE-TAB BROWSE-1 1 FRM-MAIN */
ASSIGN 
       FRAME FRM-MAIN:SENSITIVE        = FALSE.

/* SETTINGS FOR BROWSE BROWSE-1 IN FRAME FRM-MAIN
   NO-ENABLE                                                            */
ASSIGN 
       BROWSE-1:ALLOW-COLUMN-SEARCHING IN FRAME FRM-MAIN = TRUE
       BROWSE-1:COLUMN-RESIZABLE IN FRAME FRM-MAIN       = TRUE
       BROWSE-1:COLUMN-MOVABLE IN FRAME FRM-MAIN         = TRUE.

ASSIGN 
       tSpyInfo.tParms:COLUMN-READ-ONLY IN BROWSE BROWSE-1 = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(WINDOW-1)
THEN WINDOW-1:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "TEMP-DB.tSpyInfo"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.tSpyInfo.tSrcProc
"tSpyInfo.tSrcProc" "Stmt Location" ? "character" ? ? ? ? ? ? no ? no no "19" yes no no "U" "" ""
     _FldNameList[2]   > Temp-Tables.tSpyInfo.tProcName
"tSpyInfo.tProcName" "ProcName/Event" ? "character" ? ? ? ? ? ? no ? no no "19" yes no no "U" "" ""
     _FldNameList[3]   > Temp-Tables.tSpyInfo.tType
"tSpyInfo.tType" "Statement" ? "character" ? ? ? ? ? ? no ? no no "12.2" yes no no "U" "" ""
     _FldNameList[4]   > Temp-Tables.tSpyInfo.tParms
"tSpyInfo.tParms" "Parameters" "X(320)" "character" ? ? ? ? ? ? yes ? no no "17" yes no yes "U" "" ""
     _FldNameList[5]   > Temp-Tables.tSpyInfo.tTarget
"tSpyInfo.tTarget" "Target Proc" ? "character" ? ? ? ? ? ? no ? no no "15.4" yes no no "U" "" ""
     _FldNameList[6]   > Temp-Tables.tSpyInfo.tSource
"tSpyInfo.tSource" "Source File" ? "character" ? ? ? ? ? ? no ? no no "26" yes no no "U" "" ""
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME WINDOW-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL WINDOW-1 WINDOW-1
ON WINDOW-CLOSE OF WINDOW-1 /* PRO*Spy */
DO:
  /* These events will close the window and terminate the procedure.      */
/* (NOTE: this will override any user-defined triggers previously       */
/*  defined on the window.)                                             */
  
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL WINDOW-1 WINDOW-1
ON WINDOW-RESIZED OF WINDOW-1 /* PRO*Spy */
DO:
   /* Resize the frame and browse widget to the window */
  ASSIGN 
         FRAME {&frame-name}:HIDDEN         = TRUE
         FRAME {&frame-name}:WIDTH-P        = SELF:WIDTH-P
         FRAME {&frame-name}:HEIGHT-P       = SELF:HEIGHT-P
         BROWSE {&browse-name}:WIDTH-P      = FRAME {&frame-name}:WIDTH-P - 
           (FRAME {&frame-name}:BORDER-LEFT-P + 
            FRAME {&frame-name}:BORDER-RIGHT-P) - 20
         BROWSE {&browse-name}:HEIGHT-P     = FRAME {&frame-name}:HEIGHT-P - 
           (FRAME {&frame-name}:BORDER-TOP-P + 
            FRAME {&frame-name}:BORDER-BOTTOM-P) - 
             (btn-startLog:HEIGHT-P + 40)
         
         FRAME {&frame-name}:SCROLLABLE     = FALSE
         FRAME {&frame-name}:HIDDEN         = FALSE NO-ERROR.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
&Scoped-define SELF-NAME BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 WINDOW-1
ON CTRL-N OF BROWSE-1 IN FRAME FRM-MAIN
DO:
 
    /* Find the next marked entry in the browse and reposition to it */
    /* If there are no more marked entries, then put up a message saying that */
   RUN findMark("next":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 WINDOW-1
ON CTRL-P OF BROWSE-1 IN FRAME FRM-MAIN
DO:
    
    /* Find the previous marked entry in the browse and reposition to it */
    /* If there are no previous marked entries, then put up a message saying that */
    RUN findMark("Prev":U).   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-clear
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-clear WINDOW-1
ON CHOOSE OF btn-clear IN FRAME FRM-MAIN /* Clear */
DO:
    /* Clear the browse of any records -- leave it completely empty */
    RUN clearBrowse.
    RETURN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-endLog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-endLog WINDOW-1
ON CHOOSE OF btn-endLog IN FRAME FRM-MAIN /* End Log */
DO:
    /* Run the routines that will turn off the logging process and read the
     * operating system file. Parse the info in the file and display it in the 
     * PRO*Spy browse object. Put up hourglass as this can take time 
     */
    SESSION:SET-WAIT-STATE("General":U).
    RUN endLog.
    SESSION:SET-WAIT-STATE("").
    RETURN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-mark
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-mark WINDOW-1
ON CHOOSE OF btn-mark IN FRAME FRM-MAIN /* Mark */
DO: 
    /* Mark the browse by creating a new record at the end of the browse that
     * has asterisks in it. Reposition to this new record.
     */
    RUN markFile.
    RETURN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-startLog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-startLog WINDOW-1
ON CHOOSE OF btn-startLog IN FRAME FRM-MAIN /* Start Log */
DO:
    /* Turn on logging */
    RUN startLog.
    RETURN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mnu_File
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mnu_File WINDOW-1
ON MENU-DROP OF MENU mnu_File /* File */
DO:
    /* If there is no application running right now, then enable the RUN
     * menu item so user can run a new application in prospy. Also, disable
     * the logging buttons since nothing is running and take any previous 
     * application's name out of the window title bar.
     */
  IF NOT VALID-HANDLE(app_handle) THEN
  DO:
    MENU-ITEM m_Run:SENSITIVE IN MENU mnu_File = YES.
    ASSIGN
        {&WINDOW-NAME}:NAME                         = "PRO*Spy"
        btn-startLog:SENSITIVE IN FRAME frm-main    = NO
        btn-endLog:SENSITIVE IN FRAME frm-main      = NO.
    
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_About
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_About WINDOW-1
ON CHOOSE OF MENU-ITEM m_About /* About PRO*Spy */
DO:
   /* Put up version info about PRO*Spy */
   RUN adecomm/_about.p (INPUT "PRO*Spy for Version 9", INPUT "adeicon/prospy9":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Contents
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Contents WINDOW-1
ON CHOOSE OF MENU-ITEM m_Contents /* Help Topics */
DO:
    /* Put up General Protools help */
  RUN adecomm/_adehelp.p 
      ( INPUT "ptls":U, INPUT "TOPICS":U , INPUT ?, INPUT "" ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Exit WINDOW-1
ON CHOOSE OF MENU-ITEM m_Exit /* Exit */
DO:
    /* close the application and prospy window*/
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Run
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Run WINDOW-1
ON CHOOSE OF MENU-ITEM m_Run /* Run... */
DO:
    /* Prompt user for the name of the application to run and then run it */
   RUN RunFile.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Save
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Save WINDOW-1
ON CHOOSE OF MENU-ITEM m_Save /* Save */
DO:
    /* if there is are any records in the browse, then prompt user to see if 
     * they want to save the info to a file
     */
  FIND FIRST tspyinfo NO-LOCK NO-ERROR.
    IF AVAILABLE tspyinfo THEN
        RUN SaveAsFile.
    ELSE MESSAGE "There is nothing to save." VIEW-AS ALERT-BOX.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Search
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Search WINDOW-1
ON CHOOSE OF MENU-ITEM m_Search /* PRO*Spy Help */
DO:
    /* Put up PRO*Spy specific help */
  RUN adecomm/_adehelp.p ( "ptls":U, "context":U, 57, ? ). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK WINDOW-1 


/* ***************************  Main Block  *************************** */



/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                   = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW    = {&WINDOW-NAME}.


/* Ensure that the window cannot be resized by the WINDOW-MAXIMIZED event. 
ASSIGN {&WINDOW-NAME}:MAX-WIDTH  = {&WINDOW-NAME}:WIDTH
       {&WINDOW-NAME}:MAX-HEIGHT = {&WINDOW-NAME}:HEIGHT .
*/
/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE DO: 
    FIND FIRST tspyinfo NO-LOCK NO-ERROR.
    IF AVAILABLE tspyinfo THEN
        RUN SaveAsFile.
    
    RUN Destroy.
    IF RETURN-VALUE = "NO-APPLY":U THEN
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

ASSIGN fOK = {&WINDOW-NAME}:LOAD-ICON("adeicon/prospy9":U).

/* Now enable the interface and wait for the exit condition.            */
MAIN-BLOCK:

DO ON STOP UNDO MAIN-BLOCK, RETRY MAIN-BLOCK:
  IF NOT RETRY THEN
  DO:  
    
    {&browse-name}:MAX-DATA-GUESS = 0.
    
    RUN enable_UI.     
    ASSIGN btn-startLog:SENSITIVE   = FALSE
           btn-endLog:SENSITIVE     = FALSE.
      
    IF NOT THIS-PROCEDURE:PERSISTENT THEN 
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
  END.
  ELSE APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearBrowse WINDOW-1 
PROCEDURE clearBrowse :
/*------------------------------------------------------------------------------
  Purpose:   Clear the browse widget  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 
    
    FOR EACH tSpyInfo:
        DELETE tSpyInfo.   
    END.
    
    {&browse-name}:MAX-DATA-GUESS IN FRAME {&FRAME-NAME} = 0.
    ASSIGN iCount           = 0
           iCountMark       = 0.
    {&open-query-browse-1}
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
    RUN  destroyObject IN app_handle.
    
    IF VALID-HANDLE(app_handle) THEN
        APPLY "CLOSE":U TO app_handle.
    IF VALID-HANDLE(app_handle) THEN
      DELETE PROCEDURE app_handle NO-ERROR.
    
  END.
  
  /* If we needed to create a run window, delete it now. */
  IF VALID-HANDLE(prospy_runwin) THEN DELETE WIDGET prospy_runwin.

 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createTspyInfo WINDOW-1 
PROCEDURE createTspyInfo :
/*------------------------------------------------------------------------------
  Purpose:    Since there aren't triggers or sequences for temp tables, this
    routine assures that each time we create a tspyInfo record, a unique value is
    assigned to tspyinfo.tspid. Also, icount is updated for max-data-guess.
  Run Syntax:  run createtspyinfo. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
CREATE tSpyInfo.
ASSIGN iCount           = iCount + 1.
ASSIGN tSpyInfo.tSpyId  = iCount.
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
 
   

   RUN Close_RunWin.
   RUN disable_UI.            

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI WINDOW-1  _DEFAULT-DISABLE
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
 
 

  

  DISPLAY browse-1 
      WITH FRAME frm-main IN WINDOW WINDOW-1.
      
  ENABLE browse-1 
         btn-mark
         btn-clear
         btn-startLog
         btn-endLog
        WITH FRAME frm-main IN WINDOW {&window-name}.
  {&OPEN-BROWSERS-IN-QUERY-frm-main}

  VIEW WINDOW-1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE endLog WINDOW-1 
PROCEDURE endLog :
/*------------------------------------------------------------------------------
  Purpose:   Ends execution-path logging to op sys file by turning off
            session:execution-log.  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE mystat AS LOG.
    SESSION:execution-log = NO.     
    btn-endLog:SENSITIVE IN FRAME frm-main = NO.
    btn-startLog:SENSITIVE IN FRAME frm-main = YES.
    
    RUN formatData.
    {&open-query-browse-1}
    RUN repositionBrowse.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FileSave WINDOW-1 
PROCEDURE FileSave :
/*--------------------------------------------------------------------------
    Purpose:        Low-level routine to save buffer contents to os file.
                    Updates Window Title if file name has changed.

    Run Syntax:     RUN FileSave ( 
                                   INPUT p_File_Selected ,
                                   OUTPUT p_Saved_File ) .

    Parameters:
        
    Description:

    Notes:
  ---------------------------------------------------------------------------*/
 
  
  DEFINE INPUT PARAMETER p_File_Selected AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER p_Saved_File   AS LOGICAL NO-UNDO.
  
  DEFINE VAR Old_BufName AS CHAR NO-UNDO .
  DEFINE VAR Save_OK     AS LOGICAL NO-UNDO.
  DEFINE VAR outBuf      AS CHAR NO-UNDO. 
 
 p_saved_file = TRUE.
 OUTPUT TO value(p_file_selected).  
   FOR EACH tSpyInfo BY tspyid:
        DISPLAY                
               tsrcproc  COLUMN-LABEL "Source" FORMAT "x(18)"  
               tprocname COLUMN-LABEL "Proc/event"  FORMAT "x(18)"
               substr(ttype,1,4) COLUMN-LABEL "Type" FORMAT "x(4)"             
               ttarget COLUMN-LABEL "Target"   FORMAT "x(18)"
               tsource COLUMN-LABEL "Src file " FORMAT "x(18)"          
               tparms COLUMN-LABEL "Parms" VIEW-AS EDITOR SIZE 20 BY 1 WITH WIDTH 132.     
   END.
 OUTPUT CLOSE.  
 
    IF ( NOT p_Saved_File )
    THEN DO:
        MESSAGE browse-1:PRIVATE-DATA IN FRAME {&frame-name} SKIP
          "Cannot save to this file."  SKIP(1)
          "File is read-only or the path specified" SKIP
          "is invalid. Use a different filename."
          VIEW-AS ALERT-BOX WARNING BUTTONS OK.
    END.
    
    IF ( NOT p_Saved_File )
    THEN DO:
        ASSIGN
            browse-1:PRIVATE-DATA   = Old_BufName
            p_Saved_File            = FALSE
            Saved_File              = FALSE
        .
        RETURN.
    END.
                    
    ASSIGN
     Saved_File   = TRUE  /* Global status var. */
     p_Saved_File = TRUE.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findMark WINDOW-1 
PROCEDURE findMark :
/*------------------------------------------------------------------------------
  Purpose:     Finds previous or next marked record in the browse and 
            repositions to that record. Direction depends on parameter
            findDirection.  
  Parameters:  findDirection has char value either 'prev' or 'next'
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER findDirection AS CHAR.
DEFINE VARIABLE curid AS INT.
FIND CURRENT tSpyInfo NO-LOCK NO-ERROR.
    IF AVAILABLE tSpyINfo THEN DO:
        ASSIGN curid = tspyinfo.tspyid.
        IF findDirection = "Prev":U THEN
        FIND PREV tspyInfo  
            WHERE tspyInfo.tType BEGINS "****" AND tspyinfo.tspyid NE curid
            NO-LOCK NO-ERROR .
        ELSE FIND NEXT tspyInfo  
            WHERE tspyInfo.tType BEGINS "****" AND tspyinfo.tspyid NE curid
             NO-LOCK NO-ERROR .

          IF AVAILABLE tspyInfo THEN
                    REPOSITION {&browse-name} TO ROWID ROWID(tSpyInfo).
                ELSE MESSAGE "No more marks" VIEW-AS ALERT-BOX.

    END.
   APPLY "entry":U TO tSource IN BROWSE {&browse-name}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE formatData WINDOW-1 
PROCEDURE formatData :
/*------------------------------------------------------------------------------
  Purpose:     Opens the opsys file, imports from it and calls routines to
            parse the data, displays info in the browse.
  Parameters:  <none>
  Notes:       Later we will get op sys file from environment variable
------------------------------------------------------------------------------*/
DEFINE VARIABLE text-string AS CHARACTER FORMAT "x(76)" NO-UNDO.
DEFINE VARIABLE fullname    AS CHARACTER FORMAT "x(55)".
DEFINE VARIABLE FILENAME    AS CHARACTER FORMAT "x(20)"  INIT "proexec.log":U.

fullname = OS-GETENV("PROEXLOG":U).

IF fullname = ? THEN 
    fullname = SESSION:TEMP-DIRECTORY + FILENAME.

INPUT FROM value(fullname).


DO WHILE TRUE :
    IMPORT UNFORMATTED text-string.
    parseIt(INPUT-OUTPUT text-string) .
END.
INPUT CLOSE.
ASSIGN {&browse-name}:MAX-DATA-GUESS IN FRAME {&FRAME-NAME} = iCount.
RUN repositionBrowse.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE markFile WINDOW-1 
PROCEDURE markFile :
/*------------------------------------------------------------------------------
  Purpose:     Insert a record at the end of the browse that contains asterisks
               in order to mark place in the browse information  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


/* create a new record in the browse that has asterisks in it */
RUN createTspyInfo.


ASSIGN tSpyInfo.tType       = "********" /*+ STRING(iCountMark)*/
       tSpyInfo.tSource     = "********"
       tSpyInfo.tSrcProc    = "********"
       tSpyInfo.tProcName   = "********"
       tSpyInfo.tTarget     = "********"
       tSpyInfo.tParms      = "********".
ASSIGN iCountMark = iCountMark + 1.
{&browse-name}:REFRESHABLE IN FRAME {&FRAME-NAME} = FALSE.
{&open-query-browse-1} 
RUN repositionBrowse.
{&browse-name}:REFRESHABLE = TRUE.
{&browse-name}:REFRESH().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionBrowse WINDOW-1 
PROCEDURE repositionBrowse :
/*------------------------------------------------------------------------------
  Purpose:    repositions browse to the last record in the browse 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE l-dummy AS LOG NO-UNDO.

    FIND LAST tSpyInfo NO-LOCK NO-ERROR.
    IF AVAILABLE tSpyInfo THEN DO:
   
              
        /* if you just apply entry to browse, you'll get stuck
         in parms field  which is enabled */
        APPLY "END":U TO BROWSE {&browse-name}.
        APPLY "entry":U TO tSource IN BROWSE {&browse-name}.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runFile WINDOW-1 
PROCEDURE runFile :
/*--------------------------------------------------------------------------
    Purpose:        Executes the RUN command, which allows user to select
                    and run an existing file.

    Run Syntax:     RUN RunFile.

    Parameters:

    Description:

        1. Prompts user for name of file to open.
        2. opens the file and runs it
        3. prompts user to find out if they want to start logging before 
            running file or to wait.

    Notes:
  ---------------------------------------------------------------------------*/

  DEFINE VARIABLE OF_OK         AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE Valid_BufName AS LOGICAL   NO-UNDO.   
  DEFINE VARIABLE WF_Run        AS LOGICAL   NO-UNDO.
  
  
  
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
 ASSIGN start-log-now = FALSE
        File_Selected = ?.
  OPEN_BLOCK:
  DO WHILE TRUE:
   
    RUN adecomm/_getfile.p (INPUT WINDOW-1 , INPUT "PRO*Spy":U , 
                            "OPEN":U , "Run":U , "OPEN":U , 
                            INPUT-OUTPUT File_Selected ,
                            OUTPUT OF_OK ).
    IF NOT OF_OK THEN DO:
        DELETE WIDGET tBuffer.  
        btn-endlog:SENSITIVE = FALSE.
        btn-startlog:SENSITIVE = FALSE.
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
                                  
    /* See if any db-references. If there are and there are no db's connected, warn
       the user and make them connect to a database. */
                                       
    RCODE-INFO:FILE-NAME = FILE_selected.
    IF RCODE-INFO:DB-REFERENCES NE "" AND NUM-DBS = 0
        OR
        NUM-DBS = 1 AND LDBNAME(1) = "temp-db":U THEN         
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
    RUN adecomm/_wfrun.p (INPUT "PRO*Spy.":U, OUTPUT WF_Run).
    /* If another tool is already running a procedure, can't proceed */
    IF WF_Run THEN
    DO:
      RUN adecomm/_setcurs.p (INPUT "").
      RETURN.
    END.
 DO ON STOP UNDO, RETURN:
      MESSAGE 
              "Would you like to start logging now?" 
              VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
              UPDATE start-log-now.
      IF start-log-now THEN APPLY "choose":U TO btn-startLog.
      END.    
    RUN adecomm/_runcode.p
           ( INPUT File_Selected,
             INPUT "_PERSISTENT, _KEEP-WIDGETS":U,
             INPUT ?,
             OUTPUT app_handle ).
    ASSIGN wfrunning = "".


   /* RUN set-watchdog IN adm-broker-hdl (INPUT THIS-PROCEDURE) NO-ERROR.*/
    
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

 
    RUN initializeobject IN app_handle.
        


        LEAVE OPEN_BLOCK. 
    END. /* IF NOT ERROR-STATUS */
      END. /* DO OPEN_BLOCK */
                                   
 
  /* We don't need the edit widget anymore. */
  IF VALID-HANDLE(tBuffer) THEN DELETE WIDGET tBuffer.  

  RUN adecomm/_setcurs.p (INPUT "").

  ASSIGN
    
    MENU-ITEM m_Run:SENSITIVE IN MENU mnu_File  = NO
    {&WINDOW-NAME}:TITLE                        =   "PRO*Spy - " + FILE_selected.

  IF NOT start-log-now 
   THEN ASSIGN   
         btn-startLog:SENSITIVE = YES
         btn-endLog:SENSITIVE   = NO.

                     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SaveAsFile WINDOW-1 
PROCEDURE SaveAsFile :
/*--------------------------------------------------------------------------
    Purpose:        Executes the SAVE AS command, saving contents of logging
                    buffer to a user selected file name.

    Run Syntax:     RUN SaveAsFile (  ) .

    Parameters:

    Description:

        1. Prompts user for name of file to save current edit buffer
           contents to.
        2. Calls SaveFile procedure to execute actual save.

        

    Notes:
  ---------------------------------------------------------------------------*/

  DEFINE VARIABLE outFileSelected   AS CHAR NO-UNDO.
  DEFINE VARIABLE SA_OK             AS LOGICAL NO-UNDO.
  DEFINE VARIABLE Old_Filename      AS CHAR NO-UNDO.
  DEFINE VARIABLE Valid_BufName     AS LOGICAL NO-UNDO .

  DO ON STOP UNDO, RETURN:
      MESSAGE 
              "Would you like to save your current session output?" 
              VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
              UPDATE sa_ok.
      IF sa_ok THEN DO:
      
  
  SAVE_AS_BLOCK:
  DO WHILE TRUE:

    RUN adecomm/_getfile.p
        ( INPUT {&WINDOW-NAME},
          INPUT "PROSPY":U,
          INPUT "Save As":U ,
          INPUT "Save As":U,
          INPUT "SAVE":U,
          INPUT-OUTPUT outFileSelected ,
          OUTPUT SA_OK ) .

    IF NOT SA_OK THEN RETURN. /* User pressed Cancel. */  
    
    RUN FileSave (  INPUT outFileSelected  ,
                   OUTPUT Saved_File ).
    IF ( Saved_File = TRUE ) THEN LEAVE SAVE_AS_BLOCK.

  END. /* DO */
      END. /* end of would you like to save */
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startLog WINDOW-1 
PROCEDURE startLog :
/*------------------------------------------------------------------------------
  Purpose:   Starts logging execution path info to op sys file by setting
        session:execution-log to YES  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   SESSION:execution-log = YES.  
    btn-endLog:SENSITIVE IN FRAME frm-main = YES.
    btn-startLog:SENSITIVE IN FRAME frm-main = NO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToken WINDOW-1 
FUNCTION getToken RETURNS CHARACTER
  ( INPUT-OUTPUT txt AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Used for parsing the op sys file information, this function returns
  the first token from a string 
   
    Notes:   Function retrieves a substring of another string up until the first
  space character is encountered. It also alters the input txt string
  to begin at the start of next token.
  
  ex... The word "this" is the first token from the string "this is my friend".
  ex... ttoken = getToken("this is my friend").
------------------------------------------------------------------------------*/
    DEFINE VARIABLE idx            AS INT INIT 0.
    DEFINE VARIABLE idxendquote    AS INT INIT 0.
    DEFINE VARIABLE outstring      AS CHARACTER.
    
     /* if first char is a double quote, then look for end quote to get
      * token
      */
     IF SUBSTR(txt,1,1) = '"' THEN DO:
         idxendquote = INDEX(SUBSTR(txt,2),'"').
         IF idxendquote > 0 THEN do:
             outstring = SUBSTR(txt,1,idxendquote + 1).
             txt = SUBSTR(txt,idxendquote + 3).
         END.
         ELSE outstring = txt.
     END.
     /* else search for next space to get token */
     ELSE DO:
     
        idx = INDEX(txt," ").     
        IF idx > 0 THEN DO:
            outstring = SUBSTR(txt,1,idx - 1).
            txt = SUBSTR(txt,idx + 1).       
        END.
     /* else if neither quote nor space found, return orig string.
      * This will be the last token
      */
     ELSE outstring =  txt.
     END. /* else do */

RETURN outstring.
 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION parseIt WINDOW-1 
FUNCTION parseIt RETURNS LOGICAL
  ( INPUT-OUTPUT txt AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  Parses a line from the op sys file and puts it into format
  that can be displayed in the browse. 
    Notes:  
------------------------------------------------------------------------------*/
   
    DEFINE VARIABLE i          AS INTEGER NO-UNDO.
    DEFINE VARIABLE idx        AS INTEGER NO-UNDO.
    DEFINE VARIABLE outstring  AS CHARACTER INIT "" NO-UNDO.  
    DEFINE VARIABLE ttype      AS CHAR. 
    DEFINE VARIABLE srcproc    AS CHAR.


        
        ttype = getToken(INPUT-OUTPUT txt).
        CASE ttype:
        
        WHEN "Run":U OR WHEN "Func":U OR 
            WHEN "Publish":U OR WHEN "Subscribe":U /*OR WHEN "exec" */THEN DO:
          
            
            srcProc = getToken(txt).
               
             /* see if the source is _prospy.w, if it is then throw out this
              * line.
              */
             IF NOT spyfunc(srcProc) THEN DO:
               
                RUN createTspyInfo.
              
                tSpyInfo.tSource = srcProc.
                tSpyInfo.tType = ttype.
                tSpyInfo.tSrcProc = getToken(txt).
                tSpyInfo.tProcname = getToken( txt).
                tSpyInfo.tTARGET = getToken(txt).
                tSpyInfo.tParms = txt.
                IF tSpyInfo.tparms = '""' THEN tSpyInfo.tparms = "<no parms>".
               
                outstring = txt.

             END.
             ELSE RETURN FALSE. /* if not spyfunc */

        END. /* when r */
        OTHERWISE DO:
            RETURN FALSE.
           
        END.
    END CASE.
    
 RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION spyFunc WINDOW-1 
FUNCTION spyFunc RETURNS LOGICAL
  ( INPUT src AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  checks to see if an entry 'src' in the op sys file is
            part of the execution path of PROSPY 2 OR of the application
          input parms: src -- char string
          returns TRUE if src is part of prospy's execution path
          returns false if the string is part of application's execution path
  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE idx AS INT NO-UNDO.
    DEFINE VARIABLE txt AS CHAR NO-UNDO.

/* if logging from beginning of window then throw out anything where src 
isn't file selected */
   
   
    IF start-log-now AND src NE File_selected THEN RETURN TRUE.

    /* else if logging from beginning and src is equal to file selected
     * then it turn off the flag that says logging from beginning and 
     * return valid src
     */
        IF start-log-now THEN do:
            
            start-log-now = FALSE.
            RETURN FALSE.
        END.
        /* if not logging from beginning or if we are done with that, then
        look to see if valid src */
        ELSE IF INDEX(src, "prospy":U) > 0 THEN
                RETURN TRUE.
             ELSE RETURN FALSE.
            
         

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

