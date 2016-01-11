&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File: _psplus.w

  Description: Tool for post-mortem analysis of application calls.  
               The intent of this tool is to assist in debugging as
               well as education of the call structure of an application.

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: Submitted December 16, 2002
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AB.              */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

&GLOBAL-DEFINE M IN FRAME f-Main
&GLOBAL-DEFINE MB IN MENU MENU-BAR-wWin
&GLOBAL-DEFINE MI MENU-ITEM
&GLOBAL-DEFINE PS STREAM pspystream

&IF "{&OPSYS}" = "WIN32" &THEN
  &GLOBAL-DEFINE A A
  &GLOBAL-DEFINE SHELL "SHELL32"
  &GLOBAL-DEFINE HWND LONG
  &GLOBAL-DEFINE INT LONG
&ELSE
  &GLOBAL-DEFINE A
  &GLOBAL-DEFINE SHELL "SHELL.DLL"
  &GLOBAL-DEFINE HWND SHORT
  &GLOBAL-DEFINE INT SHORT
&ENDIF
  
/* Parameters Definitions ---                                           */

/* Local Definitions ---                                       */

DEFINE STREAM pspystream.

DEFINE TEMP-TABLE tSpyInfo RCODE-INFORMATION
        FIELD tType     AS CHARACTER FORMAT "x(10)" LABEL 'Type'
        FIELD tSource   AS CHAR      FORMAT "x(28)" LABEL 'Source File'
        FIELD tSrcProc  AS CHAR      FORMAT "x(28)" LABEL 'Statement Source'
        FIELD tProcName AS CHAR      FORMAT "x(28)" LABEL 'Proc/Event'
        FIELD tTarget   AS CHAR      FORMAT "x(28)" LABEL 'Target Procedure'
        FIELD tLevel    AS INTEGER
        FIELD tParms    AS CHAR      FORMAT "x(10000)" LABEL 'Parameters'
        FIELD tSpyId    AS INTEGER
        FIELD tParentID AS CHARACTER
        FIELD tDescript AS CHARACTER FORMAT "x(500)"
        FIELD tBatch    AS INTEGER
        INDEX tLvlParIdx tSpyId tProcName tSrcProc tLevel tBatch tSource tType
        INDEX tWrdIdx IS WORD-INDEX tParms.

DEFINE QUERY qSpyInfo FOR tSpyInfo SCROLLING.
DEFINE BUFFER bSpyInfo FOR tSpyInfo.

DEFINE VARIABLE glHideADE      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glHideUIB      AS LOGICAL    NO-UNDO INIT TRUE.
DEFINE VARIABLE glModified     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glResults      AS LOGICAL    NO-UNDO INIT FALSE.

DEFINE VARIABLE iXPos          AS INTEGER    NO-UNDO.
DEFINE VARIABLE iYPos          AS INTEGER    NO-UNDO.
DEFINE VARIABLE iMinXPos       AS INTEGER    NO-UNDO.
DEFINE VARIABLE giCount        AS INTEGER    NO-UNDO.
DEFINE VARIABLE giWinHeight    AS INTEGER    NO-UNDO.
DEFINE VARIABLE giWinWidth     AS INTEGER    NO-UNDO.
DEFINE VARIABLE giLastBatch    AS INTEGER    NO-UNDO.
DEFINE VARIABLE giCurrentBatch AS INTEGER    NO-UNDO.
DEFINE VARIABLE giMinWidth     AS INTEGER    NO-UNDO INIT 679.
DEFINE VARIABLE giMinHeight    AS INTEGER    NO-UNDO INIT 439.

DEFINE VARIABLE gcFilter       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLabels       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cState         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcOpenLog      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcFruList      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcBaseTitle    AS CHARACTER  NO-UNDO INIT 'Progress Pro*Spy Plus'.

DEFINE VARIABLE gchTreeView    AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE gchNodes       AS COM-HANDLE NO-UNDO.

DEFINE VARIABLE rowSelected    AS ROWID      NO-UNDO.

DEFINE VARIABLE ghSelectedFont AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghMenu         AS HANDLE     NO-UNDO EXTENT 6.
DEFINE VARIABLE ghExit         AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghRule         AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghWindow       AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-Main
&Scoped-define BROWSE-NAME filterBrowse

/* Definitions for FRAME f-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btnResults btnStart btnStop btnMark ~
btnFilter edParms filterBrowse fiStatement fiProcEvent fiStLoc fiTarget ~
fiSourceFile txtParms fiStatus detailRect RECT-19 statusRect 
&Scoped-Define DISPLAYED-OBJECTS edParms fiStatement fiProcEvent fiStLoc ~
fiTarget fiSourceFile txtParms fiStatus 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addNode C-Win 
FUNCTION addNode RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD changeFont C-Win 
FUNCTION changeFont RETURNS LOGICAL
  ( INPUT phMenu AS HANDLE,
    INPUT piFont AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD doesExist C-Win 
FUNCTION doesExist RETURNS LOGICAL
  ( INPUT pcFileName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDescription C-Win 
FUNCTION getDescription RETURNS CHARACTER
  ( INPUT pcType     AS CHARACTER,
    INPUT pcProcName AS CHARACTER,
    INPUT pcTarget   AS CHARACTER,
    INPUT pcSource   AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNewId C-Win 
FUNCTION getNewId RETURNS INTEGER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD parseInput C-Win 
FUNCTION parseInput RETURNS LOGICAL
  ( INPUT pcInput AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU m_File 
       MENU-ITEM m_Open_Log     LABEL "Open Log"       ACCELERATOR "F3"
       RULE
       MENU-ITEM m_Save_Log     LABEL "Save Log"       ACCELERATOR "F6"
       MENU-ITEM m_Save_Log_As  LABEL "Save Log &As"   ACCELERATOR "SHIFT-F6"
       RULE
       MENU-ITEM m_Close_Log    LABEL "Close Log"      ACCELERATOR "F8"
       RULE.

DEFINE SUB-MENU m_Tools 
       MENU-ITEM m_Start        LABEL "Start Recording"
       MENU-ITEM m_Stop         LABEL "Stop Recording"
       RULE
       MENU-ITEM m_Filter       LABEL "Filter"        
       RULE
       MENU-ITEM m_Mark         LABEL "Insert Mark"   .

DEFINE SUB-MENU m_Tree_Font 
       MENU-ITEM m_Largest      LABEL "Largest"       
              TOGGLE-BOX
       MENU-ITEM m_Large        LABEL "Large"         
              TOGGLE-BOX
       MENU-ITEM m_Medium       LABEL "Medium"        
              TOGGLE-BOX
       MENU-ITEM m_Smaller      LABEL "Smaller"       
              TOGGLE-BOX
       MENU-ITEM m_Smallest     LABEL "Smallest"      
              TOGGLE-BOX.

DEFINE SUB-MENU m_View 
       MENU-ITEM m_Refresh_List LABEL "Refresh List"   ACCELERATOR "F5"
       RULE
       MENU-ITEM m_Hide_ADE     LABEL "Hide ADE Procedures"
              TOGGLE-BOX
       MENU-ITEM m_Hide_UIB     LABEL "Hide UIB Mode Objects"
              TOGGLE-BOX
       RULE
       SUB-MENU  m_Tree_Font    LABEL "Tree Font"     .

DEFINE SUB-MENU m_Help 
       MENU-ITEM m_Help_Topics  LABEL "Help Topics"   
       MENU-ITEM m_Prospy_Help  LABEL "Pro*Spy Plus Help" ACCELERATOR "F1"
       MENU-ITEM m_About_PROSpy LABEL "About Pro*Spy Plus".

DEFINE MENU MENU-BAR-wWin MENUBAR
       SUB-MENU  m_File         LABEL "File"          
       SUB-MENU  m_Tools        LABEL "Tools"         
       SUB-MENU  m_View         LABEL "View"          
       SUB-MENU  m_Help         LABEL "Help"          .


/* Definitions of handles for OCX Containers                            */
DEFINE VARIABLE CtrlFrame AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chCtrlFrame AS COMPONENT-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnFilter 
     IMAGE-UP FILE "adm2/image/filter.bmp":U
     LABEL "btnfilter" 
     SIZE 6 BY 1.19 TOOLTIP "Filter".

DEFINE BUTTON btnMark 
     IMAGE-UP FILE "adeicon/psmark.bmp":U
     LABEL "Btn 1" 
     SIZE 6 BY 1.19 TOOLTIP "Insert Mark".

DEFINE BUTTON btnResults  NO-FOCUS
     LABEL "Hide Filter Results <<" 
     SIZE 26.4 BY .95.

DEFINE BUTTON btnStart 
     IMAGE-UP FILE "adeicon/psstart.bmp":U
     LABEL "btnstart" 
     SIZE 6 BY 1.19 TOOLTIP "Start Tracing".

DEFINE BUTTON btnStop 
     IMAGE-UP FILE "adeicon/psend.bmp":U
     LABEL "btnstop" 
     SIZE 6 BY 1.19 TOOLTIP "Stop Tracing".

DEFINE VARIABLE edParms AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 65 BY 3.86
     FONT 3 NO-UNDO.

DEFINE VARIABLE fiProcEvent AS CHARACTER FORMAT "X(256)":U 
     LABEL "Proc Name/Event" 
      VIEW-AS TEXT 
     SIZE 48.2 BY .67
     FONT 3 NO-UNDO.

DEFINE VARIABLE fiSourceFile AS CHARACTER FORMAT "X(256)":U 
     LABEL "Source File" 
      VIEW-AS TEXT 
     SIZE 48.2 BY .67
     FONT 3 NO-UNDO.

DEFINE VARIABLE fiStatement AS CHARACTER FORMAT "X(256)":U 
     LABEL "Type" 
      VIEW-AS TEXT 
     SIZE 48.2 BY .67
     FONT 3 NO-UNDO.

DEFINE VARIABLE fiStatus AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 132 BY .62 NO-UNDO.

DEFINE VARIABLE fiStLoc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Statement Source" 
      VIEW-AS TEXT 
     SIZE 48.2 BY .67
     FONT 3 NO-UNDO.

DEFINE VARIABLE fiTarget AS CHARACTER FORMAT "X(256)":U 
     LABEL "Target Procedure" 
      VIEW-AS TEXT 
     SIZE 48.2 BY .67
     FONT 3 NO-UNDO.

DEFINE VARIABLE txtParms AS CHARACTER FORMAT "X(256)":U INITIAL "Parameters:" 
      VIEW-AS TEXT 
     SIZE 12 BY .62 NO-UNDO.

DEFINE RECTANGLE detailRect
     EDGE-PIXELS 2000  
     SIZE 70 BY 11.91
     BGCOLOR 15 FGCOLOR 15 .

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 25 BY 1.38.

DEFINE RECTANGLE statusRect
     EDGE-PIXELS 2000  NO-FILL 
     SIZE 134 BY .86.


/* Browse definitions                                                   */
DEFINE BROWSE filterBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS filterBrowse C-Win _STRUCTURED
  
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 134 BY 5 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-Main
     btnResults AT ROW 14.57 COL 109
     btnStart AT ROW 1.1 COL 2.4
     btnStop AT ROW 1.1 COL 8.4
     btnMark AT ROW 1.1 COL 14.4
     btnFilter AT ROW 1.1 COL 20.4
     edParms AT ROW 9.71 COL 69 NO-LABEL
     filterBrowse AT ROW 15.86 COL 2
     fiStatement AT ROW 3.33 COL 83.8 COLON-ALIGNED
     fiProcEvent AT ROW 4.52 COL 83.8 COLON-ALIGNED
     fiStLoc AT ROW 5.71 COL 83.8 COLON-ALIGNED
     fiTarget AT ROW 6.91 COL 83.8 COLON-ALIGNED
     fiSourceFile AT ROW 8.1 COL 83.8 COLON-ALIGNED
     txtParms AT ROW 9.05 COL 67 COLON-ALIGNED NO-LABEL
     fiStatus AT ROW 21.1 COL 1 COLON-ALIGNED NO-LABEL
     detailRect AT ROW 2.43 COL 66
     RECT-19 AT ROW 1 COL 2
     statusRect AT ROW 21 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 135.8 BY 20.86.


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
         TITLE              = "Progress Pro*Spy Plus"
         HEIGHT             = 20.91
         WIDTH              = 135.8
         MAX-HEIGHT         = 54
         MAX-WIDTH          = 320
         VIRTUAL-HEIGHT     = 54
         VIRTUAL-WIDTH      = 320
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU MENU-BAR-wWin:HANDLE.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT C-Win:LOAD-ICON("adeicon/prospy9.ico":U) THEN
    MESSAGE "Unable to load icon: adeicon/prospy9.ico"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB C-Win 
/* ************************* Included-Libraries *********************** */

{adecomm/_adetool.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-Main
                                                                        */
/* BROWSE-TAB filterBrowse edParms f-Main */
ASSIGN 
       edParms:READ-ONLY IN FRAME f-Main        = TRUE.

ASSIGN 
       filterBrowse:COLUMN-RESIZABLE IN FRAME f-Main       = TRUE.

ASSIGN 
       fiProcEvent:READ-ONLY IN FRAME f-Main        = TRUE.

ASSIGN 
       fiSourceFile:READ-ONLY IN FRAME f-Main        = TRUE.

ASSIGN 
       fiStatement:READ-ONLY IN FRAME f-Main        = TRUE.

ASSIGN 
       fiStLoc:READ-ONLY IN FRAME f-Main        = TRUE.

ASSIGN 
       fiTarget:READ-ONLY IN FRAME f-Main        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

CREATE CONTROL-FRAME CtrlFrame ASSIGN
       FRAME           = FRAME f-Main:HANDLE
       ROW             = 2.43
       COLUMN          = 2
       HEIGHT          = 11.91
       WIDTH           = 63
       HIDDEN          = no
       SENSITIVE       = yes.
      
/* CtrlFrame OCXINFO:CREATE-CONTROL from: {C74190B6-8589-11D1-B16A-00C0F0283628} type: TreeView */
      CtrlFrame:MOVE-AFTER(btnFilter:HANDLE IN FRAME f-Main).

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Progress Pro*Spy Plus */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Progress Pro*Spy Plus */
DO:
  SESSION:EXECUTION-LOG = FALSE.
  RUN closeApp.
  IF RETURN-VALUE EQ 'CANCEL' THEN
    RETURN NO-APPLY.

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    QUIT.

  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-RESIZED OF C-Win /* Progress Pro*Spy Plus */
DO:
  RUN resizeWindow ( INPUT SELF:WIDTH-PIXELS,
                     INPUT SELF:HEIGHT-PIXELS ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnFilter
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnFilter C-Win
ON CHOOSE OF btnFilter IN FRAME f-Main /* btnfilter */
DO:
  DEFINE VARIABLE lApplied AS LOGICAL    NO-UNDO.

  RUN protools/_psfiltwin.w ( INPUT-OUTPUT gcFilter,
                              INPUT-OUTPUT gcLabels,
                              OUTPUT lApplied ).

  IF lApplied THEN DO:
    RUN filterResults ( INPUT gcFilter ).
    /* If the filter was blank or failed for some reason, hide the results browse
       and clear the filter */
    IF CAN-DO('Closed,Error',RETURN-VALUE) THEN DO:
      IF btnResults:LABEL BEGINS 'Hide' THEN
        APPLY 'CHOOSE' TO btnResults.
      btnResults:SENSITIVE = FALSE.
    END.
    ELSE DO:
      btnResults:SENSITIVE = TRUE.
      IF btnResults:LABEL BEGINS 'Show' THEN
        APPLY 'CHOOSE' TO btnResults.
    END.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnMark
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnMark C-Win
ON CHOOSE OF btnMark IN FRAME f-Main /* Btn 1 */
DO:
  RUN insertMark ( INPUT FALSE ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnResults
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnResults C-Win
ON CHOOSE OF btnResults IN FRAME f-Main /* Hide Filter Results << */
DO:
  cState = SELF:LABEL.
  RUN resultsState ( INPUT-OUTPUT cState ).
  SELF:LABEL = cState.
  glResults = (IF cState BEGINS 'Show' THEN FALSE ELSE TRUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnStart
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnStart C-Win
ON CHOOSE OF btnStart IN FRAME f-Main /* btnstart */
DO:
  IF glModified THEN
    RUN logAction ( INPUT gcOpenLog,
                    INPUT 'restartTrace' ).
  RUN toolbarState ( INPUT 'Trace' ).

  SESSION:EXECUTION-LOG = TRUE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnStop
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnStop C-Win
ON CHOOSE OF btnStop IN FRAME f-Main /* btnstop */
DO:
  /* Stop logging. */
  SESSION:EXECUTION-LOG = FALSE.

  RUN logAction ( INPUT 'proexec.log',
                  INPUT 'openNew' ).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CtrlFrame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame C-Win OCX.Collapse
PROCEDURE CtrlFrame.TreeView.Collapse .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  Required for OCX.
    Node
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p-Node AS COM-HANDLE NO-UNDO.

/* This fills in as a sort of VALUE-CHANGED trigger.  If the selected
   row is different from the last selected row, we display the details
   of the new row. */
IF rowSelected EQ TO-ROWID(p-Node:KEY) THEN RETURN.

rowSelected = TO-ROWID(p-Node:KEY).
p-Node:ensureVisible().
RUN displayRow ( INPUT rowSelected ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame C-Win OCX.NodeClick
PROCEDURE CtrlFrame.TreeView.NodeClick .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  Required for OCX.
    Node
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p-Node AS COM-HANDLE NO-UNDO.

/* This fills in as a sort of VALUE-CHANGED trigger.  If the selected
   row is different from the last selected row, we display the details
   of the new row. */
IF rowSelected EQ TO-ROWID(p-Node:KEY) THEN RETURN.

rowSelected = TO-ROWID(p-Node:KEY).
p-Node:ensureVisible().
RUN displayRow ( INPUT rowSelected ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME filterBrowse
&Scoped-define SELF-NAME filterBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL filterBrowse C-Win
ON DEFAULT-ACTION OF filterBrowse IN FRAME f-Main
DO:
  /* This event might have been applied programatically, and in error.
     This check helps to avoid any unwanted errors/behaviour. */
  IF NOT AVAILABLE tSpyInfo THEN
    LEAVE.

  /* Reposition the TreeView to the currently selected row. */
  RUN repositionTreeView ( INPUT STRING(ROWID(tSpyInfo)) ).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_About_PROSpy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_About_PROSpy C-Win
ON CHOOSE OF MENU-ITEM m_About_PROSpy /* About Pro*Spy Plus */
DO:
  RUN adecomm/_about.p ( INPUT 'Pro*Spy Plus',
                         INPUT 'adeicon/prospy9.ico' ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Close_Log
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Close_Log C-Win
ON CHOOSE OF MENU-ITEM m_Close_Log /* Close Log */
DO:
  RUN logAction ( INPUT gcOpenLog,
                  INPUT 'CLOSE' ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_File
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_File C-Win
ON MENU-DROP OF MENU m_File /* File */
DO:
  RUN createFruList.
  {&MI} m_Save_Log:SENSITIVE {&MB} = glModified.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Filter
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Filter C-Win
ON CHOOSE OF MENU-ITEM m_Filter /* Filter */
DO:
  APPLY 'CHOOSE' TO btnFilter {&M}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Help_Topics
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Help_Topics C-Win
ON CHOOSE OF MENU-ITEM m_Help_Topics /* Help Topics */
DO:
  RUN adecomm/_adehelp.p ( INPUT "ptls",
                           INPUT "TOPICS",
                           INPUT ?,
                           INPUT ? ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Hide_ADE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Hide_ADE C-Win
ON VALUE-CHANGED OF MENU-ITEM m_Hide_ADE /* Hide ADE Procedures */
DO:
  glHideADE = SELF:CHECKED.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Hide_UIB
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Hide_UIB C-Win
ON VALUE-CHANGED OF MENU-ITEM m_Hide_UIB /* Hide UIB Mode Objects */
DO:
  glHideUIB = SELF:CHECKED.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Large
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Large C-Win
ON VALUE-CHANGED OF MENU-ITEM m_Large /* Large */
DO:
  changeFont(SELF,11).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Largest
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Largest C-Win
ON VALUE-CHANGED OF MENU-ITEM m_Largest /* Largest */
DO:
  changeFont(SELF,12).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Mark
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Mark C-Win
ON CHOOSE OF MENU-ITEM m_Mark /* Insert Mark */
DO:
  APPLY 'CHOOSE' TO btnMark {&M}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Medium
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Medium C-Win
ON VALUE-CHANGED OF MENU-ITEM m_Medium /* Medium */
DO:
  changeFont(SELF,10).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Open_Log
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Open_Log C-Win
ON CHOOSE OF MENU-ITEM m_Open_Log /* Open Log */
DO:
  RUN logAction ( INPUT '',
                  INPUT 'OPEN' ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Prospy_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Prospy_Help C-Win
ON CHOOSE OF MENU-ITEM m_Prospy_Help /* Pro*Spy Plus Help */
DO:
  RUN prospyHelp.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Refresh_List
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Refresh_List C-Win
ON CHOOSE OF MENU-ITEM m_Refresh_List /* Refresh List */
DO:
  DEFINE VARIABLE cLog AS CHARACTER  NO-UNDO.

  cLog = gcOpenLog.

  RUN clearLog.

  IF cLog NE '' AND
     cLog NE ? THEN
    RUN logAction ( INPUT cLog,
                    INPUT 'OPEN' ).

  APPLY 'CHOOSE' TO btnStop {&M}.
  IF gcFilter NE '' THEN DO:
    RUN filterResults ( INPUT gcFilter ).
    IF btnResults:LABEL BEGINS 'Show' THEN
      APPLY 'CHOOSE' TO btnResults {&M}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Save_Log
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Save_Log C-Win
ON CHOOSE OF MENU-ITEM m_Save_Log /* Save Log */
DO:
  RUN logAction ( INPUT gcOpenLog,
                  INPUT 'SAVE' ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Save_Log_As
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Save_Log_As C-Win
ON CHOOSE OF MENU-ITEM m_Save_Log_As /* Save Log As */
DO:
  RUN logAction ( INPUT '',
                  INPUT 'SAVEAS' ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Smaller
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Smaller C-Win
ON VALUE-CHANGED OF MENU-ITEM m_Smaller /* Smaller */
DO:
  changeFont(SELF,9).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Smallest
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Smallest C-Win
ON VALUE-CHANGED OF MENU-ITEM m_Smallest /* Smallest */
DO:
  changeFont(SELF,8).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Start
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Start C-Win
ON CHOOSE OF MENU-ITEM m_Start /* Start Recording */
DO:
  APPLY 'CHOOSE' TO btnStart {&M}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Stop
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Stop C-Win
ON CHOOSE OF MENU-ITEM m_Stop /* Stop Recording */
DO:
  APPLY 'CHOOSE' TO btnStop {&M}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}
       ghWindow                      = {&WINDOW-NAME}.
    
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
  ASSIGN giWinWidth                     = ghWindow:WIDTH-PIXELS
         giWinHeight                    = ghWindow:HEIGHT-PIXELS
         ghWindow:VIRTUAL-WIDTH-PIXELS  = SESSION:WIDTH-PIXELS
         ghWindow:VIRTUAL-HEIGHT-PIXELS = SESSION:HEIGHT-PIXELS NO-ERROR.
  RUN initObjects.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE appendParams C-Win 
PROCEDURE appendParams :
/*------------------------------------------------------------------------------
  Purpose:     This routine is responsible for appending parameter data for an 
               existing record in the tSpyInfo temp-table.
  Parameters:  INPUT prowRowIdent AS ROWID
               INPUT pcData AS CHARACTER
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER prowRowIdent AS ROWID      NO-UNDO.
  DEFINE INPUT  PARAMETER pcData       AS CHARACTER  NO-UNDO.

  DEFINE BUFFER bSpyInfo FOR tSpyInfo.

  FIND bSpyInfo WHERE ROWID(bSpyInfo) EQ prowRowIdent NO-ERROR.
  IF AVAILABLE bSpyInfo THEN
    bSpyInfo.tParms = bSpyInfo.tParms + pcData.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearLog C-Win 
PROCEDURE clearLog :
/*------------------------------------------------------------------------------
  Purpose:     Clears the interface of all information and empties the temp-table.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  gchNodes:CLEAR().

  CLOSE QUERY qSpyInfo.
  EMPTY TEMP-TABLE tSpyInfo.
  
  CLEAR FRAME FRAME-E.
  CLEAR FRAME f-Main.
  CLEAR FRAME FRAME-C.

  edParms:SCREEN-VALUE {&E} = ''.
  glModified = FALSE.
  gcOpenLog  = ''.
  ghWindow:TITLE = gcBaseTitle.
  giLastBatch = 0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE closeApp C-Win 
PROCEDURE closeApp :
/*------------------------------------------------------------------------------
  Purpose:     Saves current settings to the registry/ini.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFruList AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE iMenu    AS INTEGER    NO-UNDO.

  APPLY 'CHOOSE' TO {&MI} m_close_log {&MB}.

  /* Compile a list of the existing Fru's */
  DO iMenu = 1 TO 6:
    IF VALID-HANDLE(ghMenu[iMenu]) THEN
      cFruList = cFruList + (IF cFruList NE '' THEN ',' ELSE '') + ghMenu[iMenu]:LABEL.
  END.
  
  /* If there is a saved log open, prepend the list with its name, if it's not
     already there */
  IF gcOpenLog NE 'proexec.log' AND gcOpenLog NE '' THEN
    IF ENTRY(1,cFruList) NE gcOpenLog THEN
      cFruList = gcOpenLog + (IF cFruList NE '' THEN ',' ELSE '') + cFruList. 
  
  /* Because of string size considerations, ensure there are no more than 6 entries 
     in the list */
  IF NUM-ENTRIES(cFruList) > 6 THEN
    cFruList = SUBSTRING(cFruList,1,R-INDEX(cFruList,',') - 1).

  IF cFruList NE '' THEN
    PUT-KEY-VALUE SECTION 'ProSpy' KEY 'FruList' VALUE cFruList NO-ERROR.

  PUT-KEY-VALUE SECTION 'ProSpy' KEY 'TreeFont' VALUE ghSelectedFont:LABEL NO-ERROR.
  PUT-KEY-VALUE SECTION 'ProSpy' KEY 'HideADE' VALUE 
      (IF {&MI} m_Hide_ADE:CHECKED {&MB} THEN 'TRUE' ELSE 'FALSE') NO-ERROR.
  PUT-KEY-VALUE SECTION 'ProSpy' KEY 'HideUIB' VALUE 
      (IF {&MI} m_Hide_UIB:CHECKED {&MB} THEN 'TRUE' ELSE 'FALSE') NO-ERROR.
  
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE closeLog C-Win 
PROCEDURE closeLog :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lSave AS LOGICAL    NO-UNDO.

  IF glModified THEN
      MESSAGE 'Closing a Pro*Spy Plus log file will discard changes to the currently displayed data.' SKIP
              'Do you wish to save the current information to a file prior to proceeding?'
          VIEW-AS ALERT-BOX INFO BUTTONS YES-NO-CANCEL UPDATE lSave.
  
  IF lSave EQ ? THEN
    RETURN 'CANCEL'.

  IF lSave THEN
    RUN saveLog ( INPUT gcOpenLog ).

  RUN clearLog.
  RUN toolbarState ( 'endTrace' ).

  ghWindow:TITLE = gcBaseTitle.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE columnResized C-Win 
PROCEDURE columnResized :
/*------------------------------------------------------------------------------
  Purpose:     Modifies the column width in the registry for a specific column
  Parameters:  <none>
  Notes:       Usually called as an END-RESIZE persistent trigger for the 
               browse column
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phColumn AS HANDLE     NO-UNDO.

  DEFINE VARIABLE cColumns AS CHARACTER  NO-UNDO.

  GET-KEY-VALUE SECTION 'ProSpy' KEY 'ColumnWidths' VALUE cColumns.

  IF cColumns EQ ? THEN cColumns = ''.

  IF LOOKUP(phColumn:NAME,cColumns,CHR(2)) > 0 THEN
    ENTRY(LOOKUP(phColumn:NAME,cColumns,CHR(2)) + 1,cColumns,CHR(2)) = 
      STRING(phColumn:WIDTH-CHARS).
  ELSE cColumns = cColumns + (IF cColumns NE '' THEN CHR(2) ELSE '') +
                  phColumn:NAME + CHR(2) + STRING(phColumn:WIDTH-CHARS).
  
  PUT-KEY-VALUE SECTION 'ProSpy' KEY 'ColumnWidths' VALUE cColumns.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE control_load C-Win  _CONTROL-LOAD
PROCEDURE control_load :
/*------------------------------------------------------------------------------
  Purpose:     Load the OCXs    
  Parameters:  <none>
  Notes:       Here we load, initialize and make visible the 
               OCXs in the interface.                        
------------------------------------------------------------------------------*/

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN
DEFINE VARIABLE UIB_S    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE OCXFile  AS CHARACTER  NO-UNDO.

OCXFile = SEARCH( "_psplus.wrx":U ).
IF OCXFile = ? THEN
  OCXFile = SEARCH(SUBSTRING(THIS-PROCEDURE:FILE-NAME, 1,
                     R-INDEX(THIS-PROCEDURE:FILE-NAME, ".":U), "CHARACTER":U) + "wrx":U).

IF OCXFile <> ? THEN
DO:
  ASSIGN
    chCtrlFrame = CtrlFrame:COM-HANDLE
    UIB_S = chCtrlFrame:LoadControls( OCXFile, "CtrlFrame":U)
  .
  CtrlFrame:NAME = "CtrlFrame":U .
  RUN initialize-controls IN THIS-PROCEDURE NO-ERROR.
END.
ELSE MESSAGE "_psplus.wrx":U SKIP(1)
             "The binary control file could not be found. The controls cannot be loaded."
             VIEW-AS ALERT-BOX TITLE "Controls Not Loaded".

&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createFruList C-Win 
PROCEDURE createFruList :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFruList  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTempList AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE iMenu     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iFiles    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iEntry    AS INTEGER    NO-UNDO.
  
  /* FRU (Files Recently Used) section */
  GET-KEY-VALUE SECTION 'ProSpy' KEY 'FruList' VALUE cFruList.

  iFiles = (IF NUM-ENTRIES(cFruList) EQ ? THEN 0 ELSE NUM-ENTRIES(cFruList)).

  DO iMenu = 1 TO 6:
    IF VALID-HANDLE(ghMenu[iMenu]) THEN
      DELETE WIDGET ghMenu[iMenu].
  END.
  IF VALID-HANDLE(ghExit) THEN
    DELETE WIDGET ghExit.

  IF VALID-HANDLE(ghRule) THEN
    DELETE WIDGET ghRule.

  MENU-LOOP:
  DO iMenu = 1 TO MIN(6,NUM-ENTRIES(cFruList)):

    IF NOT doesExist(ENTRY(iMenu,cFruList)) THEN
      cFruList = REPLACE(cFruList,ENTRY(iMenu,cFruList),'DELETED').
    
    IF ENTRY(iMenu,cFruList) EQ 'DELETED' THEN
      NEXT MENU-LOOP.
    ELSE iEntry = iEntry + 1.

    cTempList = cTempList + (IF cTempList NE '' THEN ',' ELSE '') + ENTRY(iMenu,cFruList).

    CREATE MENU-ITEM ghMenu[iEntry]
        ASSIGN PARENT = SUB-MENU m_File:HANDLE {&MB}
               LABEL  = ENTRY(iMenu,cFruList)
        TRIGGERS:
          ON 'CHOOSE' PERSISTENT RUN logAction 
              IN THIS-PROCEDURE ( INPUT ENTRY(iMenu,cFruList),
                                  INPUT 'OPEN' ).
        END TRIGGERS.
  END.

  iFiles = (IF NUM-ENTRIES(cTempList) EQ ? THEN 0 ELSE NUM-ENTRIES(cTempList)).

  /* If there were some Fru's added, add a RULE between them and the next menu-item(s) */
  IF iFiles NE 0 THEN
    CREATE MENU-ITEM ghRule
        ASSIGN SUBTYPE = 'RULE'
               PARENT  = SUB-MENU m_File:HANDLE {&MB}.

  /* Create the exit menu-item */
  CREATE MENU-ITEM ghExit
      ASSIGN LABEL  = 'E&xit'
             PARENT = SUB-MENU m_File:HANDLE {&MB}
      TRIGGERS:
        ON 'CHOOSE' PERSISTENT RUN exitChosen IN THIS-PROCEDURE.
      END TRIGGERS.

  PUT-KEY-VALUE SECTION 'ProSpy' KEY 'FruList' VALUE cTempList NO-ERROR.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayRow C-Win 
PROCEDURE displayRow :
/*------------------------------------------------------------------------------
  Purpose:     Displays the row indicated by pRowSelected
  Parameters:  INPUT pRowSelected AS ROWID
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pRowSelected AS ROWID      NO-UNDO.

  DO WITH FRAME F-Main:
    FIND tSpyInfo WHERE ROWID(tSpyInfo) EQ prowSelected NO-LOCK NO-ERROR.
    IF AVAILABLE tSpyInfo THEN
      ASSIGN edParms:SCREEN-VALUE       = tSpyInfo.tParms
             fiProcEvent:SCREEN-VALUE   = tSpyInfo.tProcName
             fiProcEvent:TOOLTIP        = (IF LENGTH(tSpyInfo.tProcName) >= fiProcEvent:WIDTH-CHARS THEN
                                             tSpyInfo.tProcName ELSE '')
             fiSourceFile:SCREEN-VALUE  = tSpyInfo.tSource
             fiSourceFile:TOOLTIP       = (IF LENGTH(tSpyInfo.tSource) >= fiSourceFile:WIDTH-CHARS THEN
                                             tSpyInfo.tSource ELSE '')
             fiStatement:SCREEN-VALUE   = tSpyInfo.tType
             fiStatement:TOOLTIP        = (IF LENGTH(tSpyInfo.tType) >= fiStatement:WIDTH-CHARS THEN
                                             tSpyInfo.tType ELSE '')
             fiStLoc:SCREEN-VALUE       = tSpyInfo.tSrcProc 
             fiStLoc:TOOLTIP            = (IF LENGTH(tSpyInfo.tSrcProc) >= fiStLoc:WIDTH-CHARS THEN
                                             tSpyInfo.tSrcProc ELSE '')
             fiTarget:SCREEN-VALUE      = tSpyInfo.tTarget
             fiTarget:TOOLTIP           = (IF LENGTH(tSpyInfo.tTarget) >= fiTarget:WIDTH-CHARS THEN
                                             tSpyInfo.tTarget ELSE '')
             fiStatus:SCREEN-VALUE      = tSpyInfo.tDescrip
             fiStatus:TOOLTIP           = (IF LENGTH(tSpyInfo.tDescrip) >= fiStatus:WIDTH-CHARS THEN
                                             tSpyInfo.tDescrip ELSE '') NO-ERROR.
    ELSE
      ASSIGN edParms:SCREEN-VALUE       = ''
             fiProcEvent:SCREEN-VALUE   = ''
             fiProcEvent:TOOLTIP        = ''
             fiSourceFile:SCREEN-VALUE  = ''
             fiSourceFile:TOOLTIP       = ''
             fiStatement:SCREEN-VALUE   = ''
             fiStatement:TOOLTIP        = ''
             fiStLoc:SCREEN-VALUE       = ''
             fiStLoc:TOOLTIP            = ''
             fiTarget:SCREEN-VALUE      = ''
             fiTarget:TOOLTIP           = ''
             fiStatus:SCREEN-VALUE      = ''
             fiStatus:TOOLTIP           = '' NO-ERROR.
  END.

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
  RUN control_load.
  DISPLAY edParms fiStatement fiProcEvent fiStLoc fiTarget fiSourceFile txtParms 
          fiStatus 
      WITH FRAME f-Main IN WINDOW C-Win.
  ENABLE btnResults btnStart btnStop btnMark btnFilter edParms fiStatement 
         fiProcEvent fiStLoc fiTarget fiSourceFile txtParms fiStatus detailRect 
         RECT-19 statusRect 
      WITH FRAME f-Main IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-Main}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitChosen C-Win 
PROCEDURE exitChosen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  APPLY 'WINDOW-CLOSE' TO ghWindow.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE filterResults C-Win 
PROCEDURE filterResults :
/*------------------------------------------------------------------------------
  Purpose:     Reopens/opens the query for the filter browser based on the 
               where clause specified by pcWhere.
  Parameters:  INPUT pcWhere AS CHARACTER
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcWhere AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hQuery  AS HANDLE     NO-UNDO.

  hQuery = QUERY qSpyInfo:HANDLE.
  hQuery:QUERY-CLOSE().
  IF pcWhere EQ '' OR pcWhere EQ ? THEN
    RETURN 'Closed'.
  
  hQuery:QUERY-PREPARE('FOR EACH tSpyInfo NO-LOCK WHERE ' + pcWhere) NO-ERROR.
  hQuery:QUERY-OPEN() NO-ERROR.

  BROWSE {&BROWSE-NAME}:MAX-DATA-GUESS = giCount.
  APPLY 'VALUE-CHANGED' TO BROWSE {&BROWSE-NAME}.
  
  IF NOT ERROR-STATUS:ERROR AND hQuery:IS-OPEN THEN
    RETURN 'success'.
  ELSE RETURN 'Error'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE importLog C-Win 
PROCEDURE importLog :
/*------------------------------------------------------------------------------
  Purpose:     Import the contents of a log file specified by pcLogFile.
  Parameters:  INPUT pcLogFile AS CHARACTER
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcLogFile AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cInput      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFirstRowid AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cReturn     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cStatus     AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE lDelete     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lGoodLog    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lGoodData   AS LOGICAL    NO-UNDO.
                           
  DEFINE VARIABLE iCount      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLogSize    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iBytesRead  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iPercent    AS INTEGER    NO-UNDO.

  DEFINE VARIABLE rowLastRead AS ROWID      NO-UNDO.

  FILE-INFO:FILE-NAME = pcLogFile.
  iLogSize = FILE-INFO:FILE-SIZE.

  fiStatus:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.
  fiStatus:FONT = 6.

  SESSION:SET-WAIT-STATE('GENERAL').
  gchTreeView:VISIBLE = FALSE.

  IF NOT glModified THEN
    giCurrentBatch = 0.

  INPUT FROM VALUE(pcLogFile).
  REP-BLK:
  REPEAT:
    iCount = iCount + 1.
    IMPORT UNFORMATTED cInput.
    iBytesRead = iBytesRead + LENGTH(cInput).
    lGoodData = (cInput BEGINS 'RUN' OR
                 cInput BEGINS 'FUNC' OR
                 cInput BEGINS 'PUBL' OR
                 cInput BEGINS 'SUBS' OR
                 cInput BEGINS 'EXEC' OR
                 cInput BEGINS 'MARK' OR
                 cInput BEGINS 'TRIGGER' OR
                 NUM-ENTRIES(cInput,'|') LT 7).

    iPercent = ABS((iBytesRead / iLogSize) * 100).
    cStatus  = FILL(CHR(1),INT(TRUNC(iPercent / 10,0))) + FILL(' ',10 - INT(TRUNC(iPercent / 10,0))) + ' ' + STRING(iPercent) + '%'.
    fiStatus:SCREEN-VALUE = cStatus.

    IF NOT lGoodData THEN DO:
       
      /* If we've already verified that the log is good then we assume that there
         was a newline character in the parameter data and we append it to the last
         record that was read. */
      IF lGoodLog THEN DO:
        RUN appendParams ( INPUT rowLastRead,
                           INPUT CHR(10) + cInput ).
        NEXT REP-BLK.
      END. /* Good Log */
      ELSE DO:
        RUN clearLog.
        MESSAGE 'Invalid Input Log!' SKIP 
                'Please ensure that you have a minimum of Progress Version 9.1D05 installed!'
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        gcOpenLog = ''.
        cReturn   = 'ERROR'.
        LEAVE REP-BLK.
      END. /* Not a good log */
    END. /* Not good data */
             
    IF TRIM(ENTRY(4,cInput,'|')) EQ '***********************************' THEN
      RUN insertMark ( INPUT TRUE ).
    ELSE DO:
      parseInput(cInput).
      IF AVAILABLE tSpyInfo THEN DO:
        IF iCount = 1 THEN DO: 
          ASSIGN cFirstRowid = STRING(ROWID(tSpyInfo))
                 lGoodLog    = TRUE.
        END.
        rowLastRead = ROWID(tSpyInfo).
        addNode().
      END.
      ELSE iCount = iCount - 1.
    END.
  END. /* REPEAT: */
  INPUT CLOSE.
  gchTreeView:VISIBLE = TRUE.
  SESSION:SET-WAIT-STATE('').
  
  fiStatus:FONT = ?.
  fiStatus:SCREEN-VALUE = ''.

  RUN repositionTreeView ( cFirstRowid ).

  IF NOT CAN-FIND(FIRST tSpyInfo) THEN
    cReturn = 'ERROR'.

  RETURN cReturn.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeMenu C-Win 
PROCEDURE initializeMenu :
/*------------------------------------------------------------------------------
  Purpose:     Creates menu-items and initializes the state of existing
               menu-items with information that was saved from previous
               sessions
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cHideUIB  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cHideADE  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTreeFont AS CHARACTER  NO-UNDO.

  RUN createFruList.

  /* Treeview font section */
  GET-KEY-VALUE SECTION 'ProSpy' KEY 'TreeFont' VALUE cTreeFont. 
  CASE cTreeFont:
    WHEN '' OR WHEN ? OR WHEN 'Medium' THEN DO:
      {&MI} m_Medium:CHECKED {&MB} = TRUE.
      APPLY 'VALUE-CHANGED' TO {&MI} m_Medium {&MB}.
    END.
    WHEN 'Largest' THEN DO:
      {&MI} m_Largest:CHECKED {&MB} = TRUE.
      APPLY 'VALUE-CHANGED' TO {&MI} m_Largest {&MB}.
    END.
    WHEN 'Large' THEN DO:
      {&MI} m_Large:CHECKED {&MB} = TRUE.
      APPLY 'VALUE-CHANGED' TO {&MI} m_Large {&MB}.
    END.
    WHEN 'Smaller' THEN DO:
      {&MI} m_Smaller:CHECKED {&MB} = TRUE.
      APPLY 'VALUE-CHANGED' TO {&MI} m_Smaller {&MB}.
    END.
    WHEN 'Smallest' THEN DO:
      {&MI} m_Smallest:CHECKED {&MB} = TRUE.
      APPLY 'VALUE-CHANGED' TO {&MI} m_Smallest {&MB}.
    END.
  END CASE.
  
  /* Show/Hide Procedures section */
  GET-KEY-VALUE SECTION 'ProSpy' KEY 'HideADE' VALUE cHideADE.
  GET-KEY-VALUE SECTION 'ProSpy' KEY 'HideUIB' VALUE cHideUIB.

  /* Default is FALSE */
  IF cHideADE EQ ? OR cHideADE EQ 'FALSE' OR cHideADE EQ '' THEN
    {&MI} m_Hide_ADE:CHECKED {&MB} = FALSE.
  ELSE
    {&MI} m_Hide_ADE:CHECKED {&MB} = TRUE.

  APPLY 'VALUE-CHANGED' TO {&MI} m_Hide_ADE {&MB}.

  /* Default is TRUE */
  IF cHideUIB EQ ? OR cHideUIB EQ 'TRUE' OR cHideUIB EQ '' THEN
    {&MI} m_Hide_UIB:CHECKED {&MB} = TRUE.
  ELSE
    {&MI} m_Hide_UIB:CHECKED {&MB} = FALSE.
  
  APPLY 'VALUE-CHANGED' TO {&MI} m_Hide_UIB {&MB}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initObjects C-Win 
PROCEDURE initObjects :
/*------------------------------------------------------------------------------
  Purpose:     initObjects
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Standard initialization defaults */
  DO WITH FRAME FRAME-E:
    statusRect:MOVE-TO-BOTTOM() {&M}.
    detailRect:MOVE-TO-BOTTOM().

    ASSIGN gchTreeView               = chCtrlFrame:TreeView
           gchNodes                  = gchTreeView:Nodes  
           gchTreeView:FullRowSelect = TRUE
           gchTreeView:HideSelection = FALSE
           gchTreeView:Indentation   = 1
           gchTreeView:LabelEdit     = 1
           gchTreeView:SingleSel     = FALSE
           gchTreeView:LineStyle     = 1 NO-ERROR.

    RUN setupBrowse( INPUT BROWSE {&BROWSE-NAME}:HANDLE, 
                     INPUT QUERY qSpyInfo:HANDLE,        
                     INPUT 'tSpyInfo.tType,' + 
                           'tSpyInfo.tSource,' +
                           'tSpyInfo.tSrcProc,' +
                           'tSpyInfo.tProcName,' +
                           'tSpyInfo.tTarget,' +
                           'tSpyInfo.tParms' ).       

    APPLY 'CHOOSE' TO btnResults {&M}.
  END.
  RUN toolbarState ( 'endTrace' ).

  /* Initialize defaults from information saved in registry/ini */
  RUN initializeMenu.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE insertMark C-Win 
PROCEDURE insertMark :
/*------------------------------------------------------------------------------
  Purpose:     Responsible for inserting a mark in the treeview.
  Parameters:  INPUT plOpening AS LOGICAL
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER plOpening AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE cMark AS CHARACTER  NO-UNDO.

  DO TRANSACTION:
    CREATE tSpyInfo.
    tSpyInfo.tSpyId    = DYNAMIC-FUNCTION('getNewId':U).
    tSpyInfo.tType     = 'MARK'.
    tSpyInfo.tBatch    = giLastBatch.
    tSpyInfo.tProcName = '***********************************'.
    tSpyInfo.tParentId = ?.
    tSpyInfo.tDescrip  = '***********************************'.
    cMark              = STRING(ROWID(tSpyInfo)).
  END.

  addNode().
  IF NOT plOpening THEN DO:
    RUN repositionTreeView ( INPUT cMark ).
    glModified = TRUE.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE logAction C-Win 
PROCEDURE logAction :
/*------------------------------------------------------------------------------
  Purpose:     Used for handling log file operations...  
               If there is none specified, we ask the user to specify one.
  Parameters:  INPUT pcLogFile AS CHARACTER  -- Logfile name
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcLogFile AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcAction  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE lSave   AS LOGICAL.

  DEFINE VARIABLE cReturn AS CHARACTER.

  IF glModified AND
     CAN-DO('OPEN,CLOSE,restartTrace',pcAction) THEN DO:
    MOD-BLK:
    REPEAT:
      cReturn = ''.
      MESSAGE 'This action will discard changes to the currently displayed data.' SKIP
              'Do you wish to save the current information to a file prior to proceeding?'
            VIEW-AS ALERT-BOX INFO BUTTONS YES-NO-CANCEL UPDATE lSave.
  
      IF lSave EQ ? THEN
        RETURN 'CANCEL'.

      IF lSave THEN DO:
        RUN saveLog ( INPUT gcOpenLog ).
        cReturn = RETURN-VALUE.
      END.

      IF cReturn <> 'Cancelled' THEN
        LEAVE MOD-BLK.
    
    END. /* Repeat */
  END. /* Modified */

  CASE pcAction:
    WHEN 'openNew' THEN DO:
      RUN openLog ( INPUT-OUTPUT pcLogFile ).
      IF gcFilter NE '' AND gcFilter NE ? THEN DO:
        RUN filterResults ( INPUT gcFilter ).
        IF NOT CAN-DO('Closed,Error',RETURN-VALUE) THEN
          btnResults:SENSITIVE {&M} = TRUE.
      END.
    END.
    WHEN 'OPEN' THEN DO:
      RUN clearLog.
      RUN openLog ( INPUT-OUTPUT pcLogFile ).
      cReturn = RETURN-VALUE.

      IF cReturn NE 'ERROR' THEN DO:
        ghWindow:TITLE             = gcBaseTitle + ' -- ' + gcOpenLog.
        RUN updateFruList ( INPUT pcLogFile ).
      END.
      ELSE ghWindow:TITLE             = gcBaseTitle.
    END.
    WHEN 'CLOSE' OR WHEN 'CLEAR' THEN DO:
      RUN clearLog.
      RUN toolbarState ( 'endTrace' ).

      ghWindow:TITLE = gcBaseTitle.
      IF btnResults:LABEL {&M} BEGINS 'Hide' THEN
        APPLY 'CHOOSE' TO btnResults.
    END.
    WHEN 'SAVE' OR WHEN 'SAVEAS' THEN DO:
      RUN saveLog ( INPUT pcLogFile ).
      IF RETURN-VALUE NE 'Cancelled' THEN
        glModified = FALSE.

      ghWindow:TITLE = gcBaseTitle + ' -- ' + gcOpenLog.
    END.
    WHEN 'restartTrace' THEN
      IF NOT lSave THEN RUN clearLog.
  END CASE.
               
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE moveResults C-Win 
PROCEDURE moveResults :
/*------------------------------------------------------------------------------
  Purpose:     Responsible for moving the results browser and the status bar
  Parameters:  INPUT piHeight AS INTEGER
  Notes:       The upper left corner of the browse will always be 127 pixels
               from the bottom of the window.
               
               The upper left corner of the rectangle will always be 19 pixels
               from the bottom of the window.
               
               The upper left corner of the fill-in will always be 17 pixels
               from the bottom of the window.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER piHeight AS INTEGER    NO-UNDO.

  ASSIGN BROWSE {&BROWSE-NAME}:Y = (IF piHeight < giMinHeight THEN 
                                      giMinHeight ELSE piHeight) - 127
         statusRect:Y {&M}       = piHeight - 19
         fiStatus:Y {&M}         = piHeight - 17 NO-ERROR.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE moveResultsButton C-Win 
PROCEDURE moveResultsButton :
/*------------------------------------------------------------------------------
  Purpose:     Responsible for moving the filter button along with a window
               resize action
  Parameters:  INPUT piWidth AS INTEGER
               INPUT piHeight AS INTEGER
  Notes:       When the filter browse is visible, the button is always 154 pixels 
               from the bottom of the window.
               
               When the filter browse is not visible, the button is always 45
               pixels from the bottom of the window.
               
               The button is always 139 pixels from the right handle side of the 
               window.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER piWidth  AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER piHeight AS INTEGER    NO-UNDO.

  ASSIGN btnResults:X {&M} = piWidth - 139
         btnResults:Y {&M} = piHeight - (IF glResults THEN 154 ELSE 45) NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openLog C-Win 
PROCEDURE openLog :
/*------------------------------------------------------------------------------
  Purpose:     Responsible for opening log files as specified by pcLogFile. 
  Parameters:  INPUT-OUTPUT pcLogFile AS CHARACTER
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT PARAMETER pcLogFile AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE lOpen     AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE cReturn   AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE iFileSize AS INTEGER    NO-UNDO.

  IF pcLogFile EQ '' OR pcLogFile EQ ? THEN DO:
    SYSTEM-DIALOG GET-FILE pcLogFile
          FILTERS 'Log Files  (*.log)'    '*.log',
                  'Text Files (*.txt)'    '*.txt',
                  'Data Files (*.dat)'    '*.dat',
                  'All Files  (*.*)'      '*.*'
          INITIAL-FILTER 1
          TITLE 'Open Pro*Spy Plus Log File ...'
          UPDATE lOpen.

    IF NOT lOpen OR pcLogFile EQ '' OR pcLogFile EQ ? THEN
      RETURN.
  END.

  /* Check the file size to make sure that something was logged.
     This may be unnecessary in most cases, but it helps performance
     "just in case". */
  FILE-INFO:FILE-NAME = (IF pcLogFile EQ 'proexec.log' THEN 
                           SESSION:TEMP-DIR 
                         ELSE '') + pcLogFile.
  iFileSize = FILE-INFO:FILE-SIZE.
  IF iFileSize > 0 THEN DO:
    RUN importLog ( INPUT FILE-INFO:FULL-PATHNAME ).
    cReturn = RETURN-VALUE.
  END.
  ELSE DO:
    IF FILE-INFO:FILE-NAME EQ ? THEN DO:
      MESSAGE 'The file you specified ' pcLogFile ' was not found!'
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      cReturn = 'ERROR'.
    END.
  END.
  IF CAN-FIND(FIRST tSpyInfo) THEN
    RUN toolbarState ( INPUT 'endTrace,data' ).
  ELSE RUN toolbarState ( INPUT 'endTrace' ).

  /* If we're reading from the proexec.log file, then glModified is always
     true unless the log file size is equal to zero. */
  IF pcLogFile EQ 'proexec.log' THEN
    glModified = (iFileSize > 0 AND cReturn NE 'ERROR').
  ELSE ASSIGN gcOpenLog = (IF cReturn NE 'ERROR' THEN pcLogFile ELSE '')
              glModified = FALSE.

  RETURN cReturn.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prospyHelp C-Win 
PROCEDURE prospyHelp :
/*------------------------------------------------------------------------------
  Purpose:     Brings up Pro*Spy Plus help utility
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iVersion AS INTEGER    NO-UNDO.

  iVersion = INTEGER(ENTRY(1,PROVERSION,".":U)) NO-ERROR.
  IF iVersion > 9 THEN
    RUN adecomm/_adehelp.p ( INPUT "ptls",
                             INPUT "CONTEXT",
                             INPUT 110,
                             INPUT ? ).
  ELSE
    MESSAGE "No application help available at this time."
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionTreeview C-Win 
PROCEDURE repositionTreeview :
/*------------------------------------------------------------------------------
  Purpose:     Repositions to a specific row in the treeview
  Parameters:  INPUT pcMode AS CHARACTER
  Notes:       The input parameter 'pcMode' is most likely to be a rowid to
               a specific record in the tSpyInfo temp-table.  If it's not EQ to
               'FIRST' or 'LAST' then we attempt to find it in the tt, if it doesn't
               exist we reposition the treeview.
               
               If the record is not found we don't move.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcMode AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE chNode AS COM-HANDLE NO-UNDO.

  CASE pcMode:
    WHEN 'FIRST' THEN
      FIND FIRST tSpyInfo NO-LOCK NO-ERROR.
    WHEN 'LAST' THEN
      FIND LAST tSpyInfo NO-LOCK NO-ERROR.
    OTHERWISE
      FIND tSpyInfo WHERE ROWID(tSpyInfo) EQ TO-ROWID(pcMode) NO-LOCK NO-ERROR.
  END CASE.
  IF AVAILABLE tSpyInfo THEN DO:
    chNode = gchNodes:ITEM(STRING(ROWID(tSpyInfo))) NO-ERROR.
    IF VALID-HANDLE(chNode) THEN
      chNode:SELECTED = TRUE NO-ERROR.
    RUN displayRow ( INPUT ROWID(tSpyInfo) ).
  END.
  chNode:ensureVisible() NO-ERROR.
  gchTreeView:REFRESH() NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeResults C-Win 
PROCEDURE resizeResults :
/*------------------------------------------------------------------------------
  Purpose:     Changes the size of the results browser and status bar 
               proportionally to the size of the window.
  Parameters:  INPUT piWidth AS INTEGER - Width of the current window
  Notes:       The window is always; 9 pixels wider than the browser
                                     9 pixels wider than the rectange
                                     19 pixels wider than the fill-in
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER piWidth AS INTEGER    NO-UNDO.

  ASSIGN BROWSE filterBrowse:WIDTH-PIXELS = piWidth - 9
         fiStatus:WIDTH-PIXELS {&M}       = piWidth - 19
         statusRect:WIDTH-PIXELS {&M}     = piWidth - 9 NO-ERROR.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeTreeview C-Win 
PROCEDURE resizeTreeview :
/*------------------------------------------------------------------------------
  Purpose:     Responsible for resizing the TreeView OCX's Control Frame
  Parameters:  INPUT piWidth AS INTEGER
               INPUT piHeight AS INTEGER
  Notes:       If the filter browser is visible, the Treeview height is always 
               159 pixels less than the window height.
            
               If the filter browser is NOT visible, the Treeview height is 
               always 50 pixels less than the window height.
               
               Treeview width is always 359 pixels less than the window width.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER piWidth    AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER piHeight AS INTEGER    NO-UNDO.

  ASSIGN CtrlFrame:WIDTH-PIXELS  = piWidth - 364
         CtrlFrame:HEIGHT-PIXELS = piHeight - (IF glResults THEN 189 ELSE 80) NO-ERROR.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeViewer C-Win 
PROCEDURE resizeViewer :
/*------------------------------------------------------------------------------
  Purpose:     Responsible for resizing and moving the detail viewer when the 
               window is resized
  Parameters:  INPUT piWidth AS INTEGER 
               INPUT piHeight AS INTEGER
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER piWidth  AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER piHeight AS INTEGER    NO-UNDO.

  DEFINE VARIABLE iLblPosition AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iPosition    AS INTEGER    NO-UNDO.

  DEFINE VARIABLE hLabel       AS HANDLE     NO-UNDO.

  ASSIGN detailRect:X             {&M} = piWidth - 354
         detailRect:HEIGHT-PIXELS {&M} = piHeight - (IF glResults THEN 189 ELSE 80)
         iPosition                     = piWidth - 260
         hLabel                        = fiStatement:SIDE-LABEL-HANDLE {&M}
         iLblPosition                  = iPosition - fiStatement:X
         hLabel:X                      = hLabel:X + iLblPosition
         fiStatement:X            {&M} = iPosition
         hLabel                        = fiProcEvent:SIDE-LABEL-HANDLE {&M}
         iLblPosition                  = iPosition - fiProcEvent:X
         hLabel:X                      = hLabel:X + iLblPosition
         fiProcEvent:X            {&M} = iPosition
         hLabel                        = fiStLoc:SIDE-LABEL-HANDLE {&M}
         iLblPosition                  = iPosition - fiStLoc:X
         hLabel:X                      = hLabel:X + iLblPosition
         fiStLoc:X                {&M} = iPosition
         hLabel                        = fiTarget:SIDE-LABEL-HANDLE {&M}
         iLblPosition                  = iPosition - fiTarget:X
         hLabel:X                      = hLabel:X + iLblPosition
         fiTarget:X               {&M} = iPosition
         hLabel                        = fiSourceFile:SIDE-LABEL-HANDLE {&M}
         iLblPosition                  = iPosition - fiSourceFile:X
         hLabel:X                      = hLabel:X + iLblPosition
         fiSourceFile:X           {&M} = iPosition
         txtParms:X               {&M} = piWidth - 349
         edParms:X                {&M} = piWidth - 339
         edParms:HEIGHT-PIXELS    {&M} = piHeight - (IF glResults THEN 358 ELSE 249) NO-ERROR.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeWindow C-Win 
PROCEDURE resizeWindow :
/*------------------------------------------------------------------------------
  Purpose:     Responsible for overall resizing and replacement of the Pro*Spy
               Plus window and all of it's components
  Parameters:  INPUT piWidth AS INTEGER
               INPUT piHeight AS INTEGER
  Notes:       We use the input parameters for the window dimensions in order to 
               allow routines other than the window-resized trigger to call this.
  
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER piWidth  AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER piHeight AS INTEGER    NO-UNDO.

  IF piWidth < giMinWidth THEN
    ghWindow:WIDTH-PIXELS = giMinWidth.

  IF piHeight < (IF glResults THEN giMinHeight ELSE giMinHeight - 109) THEN
    ghWindow:HEIGHT-PIXELS = (IF glResults THEN giMinHeight ELSE giMinHeight - 109).

  
  ASSIGN giWinWidth                         = ghWindow:WIDTH-PIXELS
         giWinHeight                        = ghWindow:HEIGHT-PIXELS
         FRAME F-Main:WIDTH-PIXELS          = giWinWidth
         FRAME F-Main:VIRTUAL-WIDTH-PIXELS  = giWinWidth
         FRAME F-Main:HEIGHT-PIXELS         = giWinHeight
         FRAME F-Main:VIRTUAL-HEIGHT-PIXELS = giWinHeight.
  
  RUN resizeResults ( INPUT giWinWidth ).

  RUN moveResults ( INPUT giWinHeight ).

  RUN moveResultsButton ( INPUT giWinWidth,
                          INPUT giWinHeight ).

  RUN resizeTreeview ( INPUT giWinWidth,
                       INPUT giWinHeight ).

  RUN resizeViewer ( INPUT giWinWidth,
                     INPUT giWinHeight ).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resultsState C-Win 
PROCEDURE resultsState :
/*------------------------------------------------------------------------------
  Purpose:     This handles resizing the window to show/hide the filter
               results browser.
  Parameters:  INPUT-OUTPUT pcState
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT  PARAMETER pcState  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE lShow AS LOGICAL    NO-UNDO.

  lShow = (pcState BEGINS 'Show').
  IF NOT lShow THEN HIDE BROWSE {&BROWSE-NAME}.
  pcState = (IF lShow THEN 'Hide' ELSE 'Show') + ' Filter Results <<'.

  /* If the window is not maximized, we can resize the window, otherwise we resize 
     the frame and its objects to accomodate the window size */
  IF ghWindow:WINDOW-STATE NE 1 THEN DO:
    giWinHeight = giWinHeight + (IF lShow THEN 109 ELSE -109).

    ASSIGN ghWindow:HEIGHT-PIXELS             = giWinHeight
           giWinHeight                        = giWinHeight
           FRAME f-Main:HEIGHT-PIXELS         = giWinHeight
           FRAME f-Main:VIRTUAL-HEIGHT-PIXELS = giWinHeight
           fiStatus:Y                         = giWinHeight - 17
           statusRect:Y                       = giWinHeight - 19.

    IF lShow THEN VIEW BROWSE {&BROWSE-NAME}.

    RUN moveResults ( INPUT giWinHeight ).
  END.
  ELSE DO:
    glResults = lShow.
    RUN resizeWindow ( INPUT giWinWidth,
                       INPUT giWinHeight ).

    IF lShow THEN VIEW BROWSE {&BROWSE-NAME}.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveLog C-Win 
PROCEDURE saveLog :
/*------------------------------------------------------------------------------
  Purpose:     Saves changes to a log file as specified by pcLogFile.
  Parameters:  INPUT pcLogFile AS CHARACTER
  Notes:       If pcLogFile is blank, unknown or 'proexec.log' the user is
               prompted with the system 'Save As' dialog.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcLogFile AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE  lSaved AS LOGICAL    NO-UNDO.

  IF pcLogFile EQ ? THEN
    pcLogFile = ''.

  IF pcLogFile EQ '' OR
     pcLogFile EQ 'proexec.log' THEN DO:
    SYSTEM-DIALOG GET-FILE pcLogFile
        FILTERS 'Log Files  (*.log)'    '*.log',
                'Text Files (*.txt)'    '*.txt',
                'Data Files (*.dat)'    '*.dat',
                'All Files  (*.*)'      '*.*'
        INITIAL-FILTER 1
        ASK-OVERWRITE
        DEFAULT-EXTENSION '.log'
        INITIAL-DIR SESSION:TEMP-DIRECTORY
        SAVE-AS
        TITLE 'Save Pro*Spy Plus Log File ...'
        UPDATE lSaved.

    IF NOT lSaved OR pcLogFile EQ '' THEN
      RETURN 'Cancelled'.
  END.

  OUTPUT TO VALUE(pcLogFile).
  FOR EACH tSpyInfo NO-LOCK:
    PUT UNFORMATTED tSpyInfo.tType          ',' 
                    STRING(tSpyInfo.tBatch) ' | ' 
                    tSpyInfo.tSource        ' | ' 
                    tSpyInfo.tSrcProc       ' | ' 
                    tSpyInfo.tProcName      ' | '
                    tSpyInfo.tTarget        ' | '
                    tSpyInfo.tLevel         ' | '
                    tSpyInfo.tParms CHR(10).
  END.
  OUTPUT CLOSE.
  gcOpenLog = pcLogFile.
  glModified = FALSE.
  RUN updateFruList ( gcOpenLog ).

  RETURN ''.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setupBrowse C-Win 
PROCEDURE setupBrowse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phBrowse  AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER phQuery   AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER pcColumns AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE iColumn   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iColPos   AS INTEGER    NO-UNDO.

  DEFINE VARIABLE hBuffer   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hColumn   AS HANDLE     NO-UNDO.

  DEFINE VARIABLE cColWdths AS CHARACTER  NO-UNDO.

  GET-KEY-VALUE SECTION 'ProSpy' KEY 'ColumnWidths' VALUE cColWdths.

  ASSIGN hBuffer             = phQuery:GET-BUFFER-HANDLE(1)
         phBrowse:QUERY      = ?
         phBrowse:QUERY      = phQuery
         phBrowse:EXPANDABLE = FALSE NO-ERROR.

  DO iColumn = 1 TO (IF pcColumns EQ '*' THEN hBuffer:NUM-FIELDS 
                     ELSE NUM-ENTRIES(pcColumns)):
    IF pcColumns EQ '*' THEN
      hColumn = phBrowse:ADD-LIKE-COLUMN(hBuffer:BUFFER-FIELD(iColumn)).
    ELSE
      hColumn = phBrowse:ADD-LIKE-COLUMN(ENTRY(iColumn,pcColumns)).

    iColPos = LOOKUP(hColumn:NAME,cColWdths,CHR(2)).
    IF iColPos > 0 THEN
      hColumn:WIDTH-CHARS = DECIMAL(ENTRY(iColPos + 1,cColWdths,CHR(2))) NO-ERROR.

    ON 'END-RESIZE' OF hColumn PERSISTENT RUN columnResized 
                                            IN THIS-PROCEDURE (hColumn).
  END.

  ASSIGN phBrowse:SENSITIVE = TRUE
         phBrowse:READ-ONLY = FALSE NO-ERROR.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE toolbarState C-Win 
PROCEDURE toolbarState :
/*------------------------------------------------------------------------------
  Purpose:     Responsible for handling the state of the toolbar and menu.
  Parameters:  INPUT pcAction AS CHARACTER
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcAction AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cMode AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE iMenu AS INTEGER    NO-UNDO.

  cMode = (IF NUM-ENTRIES(pcAction) > 1 THEN ENTRY(2,pcAction) ELSE '').
  pcAction = ENTRY(1,pcAction).

  CASE pcAction:
    WHEN 'Trace' THEN DO:
      /* We're tracing so disable almost every action from the user. */
      ASSIGN btnStart:SENSITIVE             {&M}  = FALSE
             {&MI} m_Start:SENSITIVE        {&MB} = FALSE
             btnStop:SENSITIVE              {&M}  = TRUE
             {&MI} m_Stop:SENSITIVE         {&MB} = TRUE
             {&MI} m_Open_Log:SENSITIVE     {&MB} = FALSE
             {&MI} m_Close_Log:SENSITIVE    {&MB} = FALSE
             btnFilter:SENSITIVE            {&M}  = FALSE
             {&MI} m_Filter:SENSITIVE       {&MB} = FALSE
             btnResults:SENSITIVE           {&M}  = FALSE
             btnMark:SENSITIVE              {&M}  = FALSE
             {&MI} m_Mark:SENSITIVE         {&MB} = FALSE
             {&MI} m_Refresh_List:SENSITIVE {&MB} = FALSE
             {&MI} m_Save_Log:SENSITIVE     {&MB} = FALSE
             {&MI} m_Save_Log_As:SENSITIVE  {&MB} = FALSE
             CtrlFrame:SENSITIVE                  = FALSE
             {&MI} m_Hide_ADE:SENSITIVE     {&MB} = FALSE
             {&MI} m_Hide_UIB:SENSITIVE     {&MB} = FALSE
             SUB-MENU m_Tree_Font:SENSITIVE {&MB} = FALSE
             {&MI} m_help_topics:SENSITIVE  {&MB} = FALSE
             {&MI} m_PROSpy_Help:SENSITIVE  {&MB} = FALSE
             {&MI} m_About_PROSpy:SENSITIVE {&MB} = FALSE
             fiStatus:SCREEN-VALUE          {&M}  = 'Tracing ...'
             BROWSE {&BROWSE-NAME}:SENSITIVE      = FALSE.
      /* Don't allow the user to access anything from the 
         Files Recently Used (FRU) list. */
      DO iMenu = 1 TO 6:
        IF VALID-HANDLE(ghMenu[iMenu]) THEN
          ghMenu[iMenu]:SENSITIVE = FALSE.
      END.
    END.
    WHEN 'endTrace' THEN DO:
      /* Enable appropriate items depending on whether there is anything
         in the log */
      IF cMode EQ 'data' THEN
        ASSIGN {&MI} m_Close_Log:SENSITIVE    {&MB} = TRUE
               {&MI} m_Save_Log:SENSITIVE     {&MB} = TRUE
               {&MI} m_Save_Log_As:SENSITIVE  {&MB} = TRUE
               btnFilter:SENSITIVE            {&M}  = TRUE
               {&MI} m_Filter:SENSITIVE       {&MB} = TRUE
               BROWSE {&BROWSE-NAME}:SENSITIVE      = TRUE.
      ELSE
        ASSIGN {&MI} m_Close_Log:SENSITIVE    {&MB} = FALSE
               {&MI} m_Save_Log:SENSITIVE     {&MB} = FALSE
               {&MI} m_Save_Log_As:SENSITIVE  {&MB} = FALSE
               btnFilter:SENSITIVE            {&M}  = FALSE
               {&MI} m_Filter:SENSITIVE       {&MB} = FALSE
               btnResults:SENSITIVE           {&M}  = FALSE
               BROWSE {&BROWSE-NAME}:SENSITIVE      = FALSE.

      ASSIGN btnStart:SENSITIVE             {&M}  = TRUE
             {&MI} m_Start:SENSITIVE        {&MB} = TRUE
             btnStop:SENSITIVE              {&M}  = FALSE
             {&MI} m_Stop:SENSITIVE         {&MB} = FALSE
             {&MI} m_Open_Log:SENSITIVE     {&MB} = TRUE
             btnMark:SENSITIVE              {&M}  = TRUE
             {&MI} m_Mark:SENSITIVE         {&MB} = TRUE
             {&MI} m_Refresh_List:SENSITIVE {&MB} = TRUE
             CtrlFrame:SENSITIVE                  = TRUE
             {&MI} m_Hide_ADE:SENSITIVE     {&MB} = TRUE
             {&MI} m_Hide_UIB:SENSITIVE     {&MB} = TRUE
             SUB-MENU m_Tree_Font:SENSITIVE {&MB} = TRUE
             {&MI} m_help_topics:SENSITIVE  {&MB} = TRUE
             {&MI} m_PROSpy_Help:SENSITIVE  {&MB} = TRUE
             {&MI} m_About_PROSpy:SENSITIVE {&MB} = TRUE
             fiStatus:SCREEN-VALUE          {&M}  = (IF fiStatus:SCREEN-VALUE BEGINS 'Tracing' OR
                                                        fiStatus:SCREEN-VALUE BEGINS 'Processing'
                                                     THEN '' ELSE fiStatus:SCREEN-VALUE).
      /* Re-Enable all the FRUs */
      DO iMenu = 1 TO 6:
        IF VALID-HANDLE(ghMenu[iMenu]) THEN
          ghMenu[iMenu]:SENSITIVE = TRUE.
      END.
    END.
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateFruList C-Win 
PROCEDURE updateFruList :
/*------------------------------------------------------------------------------
  Purpose:     Adds the input file to the Files Recently Used list (FruList)
  Parameters:  INPUT pcFileName AS CHARACTER
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcFileName AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cFruList  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTempList AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE iEntry    AS INTEGER    NO-UNDO.

  GET-KEY-VALUE SECTION 'ProSpy' KEY 'FruList' VALUE cFruList.

  IF pcFileName EQ ? OR pcFileName EQ '' OR pcFileName EQ 'proexec.log' THEN
    RETURN 'Invalid FileName'.

  cTempList = pcFileName.

  MENU-LOOP:
  DO iEntry = 1 TO MIN(6,NUM-ENTRIES(cFruList)):
    IF NUM-ENTRIES(cTempList) = 6 THEN
      LEAVE MENU-LOOP.

    IF ENTRY(iEntry,cFruList) EQ pcFileName OR 
       ENTRY(iEntry,cFruList) EQ '' OR
       ENTRY(iEntry,cFruList) EQ ? THEN
      NEXT MENU-LOOP.

    cTempList = cTempList + (IF cTempList NE '' THEN ',' ELSE '') + ENTRY(iEntry,cFruList).
  END.
  
  PUT-KEY-VALUE SECTION 'ProSpy' KEY 'FruList' VALUE cTempList NO-ERROR.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addNode C-Win 
FUNCTION addNode RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE chParent   AS COM-HANDLE NO-UNDO.
  
  DEFINE VARIABLE cKey       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentKey AS CHARACTER  NO-UNDO.

  IF NOT AVAILABLE tSpyInfo THEN
    RETURN FALSE.
  
  IF tSpyInfo.tParentID NE ? THEN
    cParentKey = STRING(tSpyInfo.tParentID).
  ELSE cParentKey = ?.

  chParent = gchTreeView:Nodes:ITEM(cParentKey) NO-ERROR.

  cKey = STRING(ROWID(tSpyInfo)).
  
  gchNodes:ADD(chParent,
               4,
               cKey,
               tSpyInfo.tDescript) NO-ERROR.

  chParent = gchTreeView:Nodes:ITEM(cKey) NO-ERROR.
  chParent = ? NO-ERROR.

  RELEASE tSpyInfo.

  RETURN TRUE.

END FUNCTION.

/* [ Com-Handle-Var = ] <com-handle>: Add (            */
/*       <anytype>-Relative BY-VARIANT-POINTER,        */
/*       <anytype>-Relationship BY-VARIANT-POINTER,    */
/*       <anytype>-Key BY-VARIANT-POINTER,             */
/*       <anytype>-Text BY-VARIANT-POINTER,            */
/*       <anytype>-Image BY-VARIANT-POINTER,           */
/*       <anytype>-SelectedImage BY-VARIANT-POINTER ). */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION changeFont C-Win 
FUNCTION changeFont RETURNS LOGICAL
  ( INPUT phMenu AS HANDLE,
    INPUT piFont AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF phMenu:CHECKED THEN DO:
    IF VALID-HANDLE(ghSelectedFont) THEN
      ghSelectedFont:CHECKED = FALSE.
    ghSelectedFont = phMenu.
    gchTreeView:FONT:SIZE = piFont.

    RETURN TRUE.
  END.
  RETURN FALSE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION doesExist C-Win 
FUNCTION doesExist RETURNS LOGICAL
  ( INPUT pcFileName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Verifies whether a file exists in the operating system. This
            only works with windows.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lExists  AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE cTemp    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOutFile AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cInput   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFile    AS CHARACTER  NO-UNDO.

  ASSIGN pcFileName = REPLACE(pcFileName,'/','\')
         cTemp      = RIGHT-TRIM(SESSION:TEMP-DIRECTORY,'\') + '\'
         cOutFile   = cTemp + 'psfound.dat'
         cFile      = ENTRY(NUM-ENTRIES(pcFileName,'\'),pcFileName,'\').

  OUTPUT {&PS} TO VALUE(cTemp + 'psfindit.bat').
  PUT {&PS} UNFORMATTED ENTRY(1,cTemp,':') ':' CHR(10).
  PUT {&PS} UNFORMATTED 'CD ~"' ENTRY(2,cTemp,':') '~"' CHR(10).
  PUT {&PS} UNFORMATTED 'DIR /B ~"' pcFileName '~" > ~"' cOutFile '~"' CHR(10).
  OUTPUT {&PS} CLOSE.

  OS-COMMAND SILENT VALUE('~"' + cTemp + '\psfindit.bat~"').
  INPUT {&PS} FROM VALUE(cOutFile).
  REP-BLK:
  REPEAT:
    IMPORT {&PS} UNFORMATTED cInput.
    IF cInput EQ cFile OR
       cInput EQ pcFileName THEN DO:
      lExists = TRUE.
      LEAVE REP-BLK.
    END.
    IF cInput EQ 'File Not Found' THEN DO:
      lExists = FALSE.
      LEAVE REP-BLK.
    END.
  END.
  INPUT {&PS} CLOSE.
  
  /* Clean up temp files */
  OS-COMMAND SILENT VALUE('DEL /F /Q ~"' + cTemp + 'psfindit.bat~"') NO-ERROR.
  OS-COMMAND SILENT VALUE('DEL /F /Q ~"' + cOutFile + '~"') NO-ERROR.
  
  RETURN lExists.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDescription C-Win 
FUNCTION getDescription RETURNS CHARACTER
  ( INPUT pcType     AS CHARACTER,
    INPUT pcProcName AS CHARACTER,
    INPUT pcTarget   AS CHARACTER,
    INPUT pcSource   AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDescription AS CHARACTER  NO-UNDO.

  cDescription = pcType + ' ' + 
                 pcProcName + ' IN ' + 
                 pcTarget + 
                 '  (' + pcSource + ')'.

  RETURN cDescription.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNewId C-Win 
FUNCTION getNewId RETURNS INTEGER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  giCount = giCount + 1.

  RETURN giCount.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION parseInput C-Win 
FUNCTION parseInput RETURNS LOGICAL
  ( INPUT pcInput AS CHARACTER ) :
/*------------------------------------------------------------------------------
   Purpose:  Main engine of prospy plus... used to parse the input from a log
             file into the correct data items.
Parameters:  INPUT pcInput AS CHARACTER
     Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cType     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSource   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSrcProc  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProcName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTarget   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParms    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLevel    AS CHARACTER  NO-UNDO.

  /* If this is prospy itself, don't record it */
  IF INDEX(pcInput,'_psplus') > 0 OR 
     INDEX(pcInput,THIS-PROCEDURE:FILE-NAME) > 0 THEN
    RETURN FALSE.
  
  ASSIGN cProcName = TRIM(ENTRY(4,pcInput,'|'))
         cTarget   = TRIM(ENTRY(5,pcInput,'|'))
         cTarget   = (IF NUM-ENTRIES(cProcName,'.') < 2 THEN cTarget ELSE cProcName).

  /* Omit appbuilder calls unless the user has de-selected that option */
  IF glHideUIB AND
     (cTarget BEGINS 'adeuib' OR
      cProcName BEGINS 'adeuib') THEN
    RETURN FALSE.

  /* Omit ade calls if the user has selected that option */
  IF glHideADE AND
     (cTarget BEGINS 'ade' OR
      cProcName BEGINS 'ade') THEN
    RETURN FALSE.

  /* Whittle down the value of pcInput one entry at a time from left to right
     until we get to the parameters section. */
  ASSIGN cType     = TRIM(ENTRY(1,pcInput,'|'))
         cSource   = TRIM(ENTRY(2,pcInput,'|'))
         cSrcProc  = TRIM(ENTRY(3,pcInput,'|'))
         cLevel    = TRIM(ENTRY(6,pcInput,'|'))
         ENTRY(6,pcInput,'|') = CHR(3)
         ENTRY(1,pcInput,CHR(3)) = ''
         cParms    = SUBSTRING(pcInput,3).
  
  IF giCurrentBatch EQ 0 THEN
    giCurrentBatch = (IF NUM-ENTRIES(cType) > 1 THEN INT(ENTRY(2,cType)) ELSE giLastBatch + 1).
  
  ASSIGN cType       = ENTRY(1,cType)
         giLastBatch = giCurrentBatch.

  IF cSrcProc EQ 'USER-INTERFACE-TRIGGER' AND TRIM(cProcName,"~"") EQ '' THEN
      ASSIGN cProcName = cParms
             cParms    = ''
             cType     = 'TRIGGER'.

  DO TRANSACTION:
    CREATE tSpyInfo.
    /* Assign index values separately */
    tSpyInfo.tSpyId   = getNewId().
    tSpyInfo.tSrcProc = cSrcProc.
    tSpyInfo.tLevel   = INTEGER(cLevel).
    tSpyInfo.tSource  = cSource.
    tSpyInfo.tTarget  = cTarget.
    tSpyInfo.tBatch   = giCurrentBatch.

    ASSIGN tSpyInfo.tType     = cType
           tSpyInfo.tProcName = cProcName
           tSpyInfo.tParms    = cParms
           tSpyInfo.tDescript = (IF cProcName EQ 'SUPER' THEN 
                                   cSrcProc + ' (' + cProcName + ')'
                                 ELSE cProcName) + 
                                      (IF cType EQ 'PUBLISH' THEN ' FROM ' 
                                       ELSE ' IN ') + tSpyInfo.tTarget.
    
    FIND LAST bSpyInfo WHERE /* Criteria group 1 -- covers SUPER */
                            (((bSpyInfo.tProcName EQ tSpyInfo.tSrcProc) OR
                              (tSpyInfo.tProcName EQ 'SUPER' AND
                               bSpyInfo.tProcName EQ tSpyInfo.tSrcProc) OR
                              (bSpyInfo.tProcName EQ 'SUPER' AND
                               bSpyInfo.tSrcProc = tSpyInfo.tSrcProc)) OR
                            /* Criteria group 2 -- covers MAIN-BLOCK */
                            (tSpyInfo.tSrcProc EQ 'Main Block' AND
                             bSpyInfo.tProcName EQ tSpyInfo.tSource) OR
                            /* Criteria group 3 -- covers triggers */
                            (tSpyInfo.tSrcProc EQ 'USER-INTERFACE-TRIGGER' AND
                             bSpyInfo.tType EQ 'TRIGGER')) AND
                            (bSpyInfo.tBatch = tSpyInfo.tBatch AND
                             bSpyInfo.tLevel = tSpyInfo.tLevel - 1) OR
                            (tSpyInfo.tType NE 'TRIGGER' AND 
                             bSpyInfo.tType EQ 'PUBLISH' AND
                             bSpyInfo.tLevel EQ tSpyInfo.tLevel - 1)
                            USE-INDEX tLvlParIdx NO-LOCK NO-ERROR.

    IF AVAILABLE bSpyInfo THEN
      tSpyInfo.tParentID = STRING(ROWID(bSpyInfo)).
    ELSE tSpyInfo.tParentID = ?.
  END. /* Transaction Scope End */
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

