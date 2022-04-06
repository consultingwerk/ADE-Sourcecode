&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File: _psfiltwin.w

  Description: Filter dialog used with Pro*Spy Plus

  Parameters:
  INPUT-OUTPUT pcFilter AS CHARACTER -- Filter criteria; This is the actual 
                                        query string that is passed to the query 
  INPUT-OUTPUT pcLabels AS CHARACTER -- This is the query for display purposes,
                                        with the fields' labels rather than the
                                        field names
  Author: Kenneth S. McIntosh

  History: Submitted December 16, 2002

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

DEFINE INPUT-OUTPUT PARAMETER pcFilter  AS CHARACTER  NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcLabels  AS CHARACTER  NO-UNDO.
DEFINE OUTPUT       PARAMETER plApplied AS LOGICAL    NO-UNDO.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE cValue       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cChoice      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcResults    AS CHARACTER  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS slOptions btnEqual btnNE btnGT btnLT btnGTEQ ~
btnLTEQ btnBegins btnMatches btnContains btnAnd btnOr btnUndo btnClear ~
edResults BtnHelp BtnClose BtnApply RECT-1 
&Scoped-Define DISPLAYED-OBJECTS slOptions lblOptions edResults 

/* Custom List Definitions                                              */
/* OPERATOR-BTNS,TERMS-BTNS,List-3,List-4,List-5,List-6                 */
&Scoped-define OPERATOR-BTNS btnEqual btnNE btnGT btnLT btnGTEQ btnLTEQ ~
btnBegins btnMatches btnContains 
&Scoped-define TERMS-BTNS btnAnd btnOr 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnAnd 
     LABEL "A&ND" 
     SIZE 15 BY 1.14.

DEFINE BUTTON BtnApply DEFAULT 
     LABEL "&Apply" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON btnBegins 
     LABEL "BEGINS" 
     SIZE 12 BY 1.43 TOOLTIP "BEGINS".

DEFINE BUTTON btnClear 
     LABEL "C&lear All" 
     SIZE 15 BY 1.14.

DEFINE BUTTON BtnClose DEFAULT 
     LABEL "&Cancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON btnContains 
     LABEL "CONTAINS" 
     SIZE 12 BY 1.43 TOOLTIP "CONTAINS".

DEFINE BUTTON btnEqual 
     LABEL "=" 
     SIZE 6 BY 1.43 TOOLTIP "Equal To".

DEFINE BUTTON btnGT 
     LABEL ">" 
     SIZE 6 BY 1.43 TOOLTIP "Greater Than".

DEFINE BUTTON btnGTEQ 
     LABEL ">=" 
     SIZE 6 BY 1.43 TOOLTIP "Greater Than or Equal To".

DEFINE BUTTON BtnHelp DEFAULT 
     LABEL "&Help" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON btnLT 
     LABEL "<" 
     SIZE 6 BY 1.43 TOOLTIP "Less Than".

DEFINE BUTTON btnLTEQ 
     LABEL "<=" 
     SIZE 6 BY 1.43 TOOLTIP "Less Than or Equal To".

DEFINE BUTTON btnMatches 
     LABEL "MATCHES" 
     SIZE 12 BY 1.43 TOOLTIP "MATCHES".

DEFINE BUTTON btnNE 
     LABEL "<>" 
     SIZE 6 BY 1.43 TOOLTIP "Not Equal To".

DEFINE BUTTON btnOr 
     LABEL "&OR" 
     SIZE 15 BY 1.14.

DEFINE BUTTON btnUndo 
     LABEL "&UNDO" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE edResults AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 86 BY 4.76
     FONT 0 NO-UNDO.

DEFINE VARIABLE lblOptions AS CHARACTER FORMAT "X(256)":U INITIAL "Options:" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .71 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2000  NO-FILL 
     SIZE 28 BY 5.24.

DEFINE VARIABLE slOptions AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     LIST-ITEM-PAIRS "Target Procedure","tTarget",
                     "Statement Source","tSrcProc",
                     "Procedure Name/Event","tProcName",
                     "Source File","tSource",
                     "Event Type","tType",
                     "Parameters","tParms" 
     SIZE 36.6 BY 5.76
     FONT 0 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     slOptions AT ROW 2.19 COL 2.4 NO-LABEL
     lblOptions AT ROW 1.24 COL 2 NO-LABEL NO-TAB-STOP 
     btnEqual AT ROW 2.91 COL 41.8
     btnNE AT ROW 2.91 COL 47.8
     btnGT AT ROW 2.91 COL 53.8
     btnLT AT ROW 2.91 COL 59.8
     btnGTEQ AT ROW 4.33 COL 41.8
     btnLTEQ AT ROW 4.33 COL 47.8
     btnBegins AT ROW 4.33 COL 53.8
     btnMatches AT ROW 5.76 COL 41.8
     btnContains AT ROW 5.76 COL 53.8
     btnAnd AT ROW 2.43 COL 72
     btnOr AT ROW 3.62 COL 72
     btnUndo AT ROW 5.29 COL 72
     btnClear AT ROW 6.48 COL 72
     edResults AT ROW 8.38 COL 2 NO-LABEL
     BtnHelp AT ROW 14.1 COL 2
     BtnClose AT ROW 14.1 COL 57
     BtnApply AT ROW 14.1 COL 73
     RECT-1 AT ROW 2.43 COL 40
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 88.8 BY 14.33.


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
         TITLE              = "Pro*Spy Plus Filter"
         HEIGHT             = 14.33
         WIDTH              = 88.8
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 118.4
         VIRTUAL-HEIGHT     = 16
         VIRTUAL-WIDTH      = 118.4
         SHOW-IN-TASKBAR    = no
         MIN-BUTTON         = no
         MAX-BUTTON         = no
         ALWAYS-ON-TOP      = yes
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT C-Win:LOAD-SMALL-ICON("adeicon/prospy9.ico":U) THEN
    MESSAGE "Unable to load small icon: adeicon/prospy9.ico"
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
/* SETTINGS FOR FRAME DEFAULT-FRAME
   Custom                                                               */
/* SETTINGS FOR BUTTON btnAnd IN FRAME DEFAULT-FRAME
   2                                                                    */
/* SETTINGS FOR BUTTON btnBegins IN FRAME DEFAULT-FRAME
   1                                                                    */
/* SETTINGS FOR BUTTON btnContains IN FRAME DEFAULT-FRAME
   1                                                                    */
/* SETTINGS FOR BUTTON btnEqual IN FRAME DEFAULT-FRAME
   1                                                                    */
/* SETTINGS FOR BUTTON btnGT IN FRAME DEFAULT-FRAME
   1                                                                    */
/* SETTINGS FOR BUTTON btnGTEQ IN FRAME DEFAULT-FRAME
   1                                                                    */
/* SETTINGS FOR BUTTON btnLT IN FRAME DEFAULT-FRAME
   1                                                                    */
/* SETTINGS FOR BUTTON btnLTEQ IN FRAME DEFAULT-FRAME
   1                                                                    */
/* SETTINGS FOR BUTTON btnMatches IN FRAME DEFAULT-FRAME
   1                                                                    */
/* SETTINGS FOR BUTTON btnNE IN FRAME DEFAULT-FRAME
   1                                                                    */
/* SETTINGS FOR BUTTON btnOr IN FRAME DEFAULT-FRAME
   2                                                                    */
ASSIGN 
       edResults:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

/* SETTINGS FOR FILL-IN lblOptions IN FRAME DEFAULT-FRAME
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Pro*Spy Plus Filter */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Pro*Spy Plus Filter */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnAnd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnAnd C-Win
ON CHOOSE OF btnAnd IN FRAME DEFAULT-FRAME /* AND */
DO:
  ASSIGN gcResults              = edResults:SCREEN-VALUE 
         btnUndo:SENSITIVE      = TRUE
         edResults:SCREEN-VALUE = edResults:SCREEN-VALUE + ' ' + 
                                  REPLACE(SELF:LABEL,'&','')
         slOptions:SENSITIVE    = TRUE.
  DISABLE {&TERMS-BTNS} btnApply WITH FRAME {&FRAME-NAME}.
  APPLY 'ENTRY' TO slOptions.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnApply
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnApply C-Win
ON CHOOSE OF BtnApply IN FRAME DEFAULT-FRAME /* Apply */
DO:
  ASSIGN gcResults = edResults:SCREEN-VALUE 
         gcResults = REPLACE(gcResults,'Target Procedure','tTarget')
         gcResults = REPLACE(gcResults,'Statement Source','tSrcProc')
         gcResults = REPLACE(gcResults,'Procedure Name/Event','tProcName')
         gcResults = REPLACE(gcResults,'Source File','tSource')
         gcResults = REPLACE(gcResults,'Event Type','tType')
         gcResults = REPLACE(gcResults,'Parameters','tParms')
         pcFilter  = gcResults
         pcLabels  = edResults:SCREEN-VALUE
         plApplied = TRUE.

  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnClear
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnClear C-Win
ON CHOOSE OF btnClear IN FRAME DEFAULT-FRAME /* Clear All */
DO:
  ASSIGN gcResults              = ''
         edResults:SCREEN-VALUE = ''
         slOptions:SENSITIVE    = TRUE
         btnAnd:SENSITIVE       = FALSE
         btnOr:SENSITIVE        = FALSE
         btnApply:SENSITIVE     = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnClose
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnClose C-Win
ON CHOOSE OF BtnClose IN FRAME DEFAULT-FRAME /* Cancel */
DO:
  &IF "{&PROCEDURE-TYPE}" EQ "SmartPanel" &THEN
    &IF "{&ADM-VERSION}" EQ "ADM1.1" &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
    &ELSE
      RUN exitObject.
    &ENDIF
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnHelp C-Win
ON CHOOSE OF BtnHelp IN FRAME DEFAULT-FRAME /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: 
  DEFINE VARIABLE iVersion AS INTEGER    NO-UNDO.

  iVersion = INTEGER(ENTRY(1,PROVERSION,".":U)) NO-ERROR.

  IF iVersion > 9 THEN
    RUN adecomm/_adehelp.p ( INPUT "ptls",
                             INPUT "CONTEXT",
                             INPUT 81,
                             INPUT ? ).
  ELSE
    MESSAGE "No application help available at this time."
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnOr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnOr C-Win
ON CHOOSE OF btnOr IN FRAME DEFAULT-FRAME /* OR */
DO:
  ASSIGN gcResults              = edResults:SCREEN-VALUE 
         btnUndo:SENSITIVE      = TRUE
         edResults:SCREEN-VALUE = edResults:SCREEN-VALUE + ' ' + 
                                  REPLACE(SELF:LABEL,'&','')
         slOptions:SENSITIVE    = TRUE.
  DISABLE {&TERMS-BTNS} btnApply WITH FRAME {&FRAME-NAME}.
  APPLY 'ENTRY' TO slOptions.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnUndo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnUndo C-Win
ON CHOOSE OF btnUndo IN FRAME DEFAULT-FRAME /* UNDO */
DO:
  edResults:SCREEN-VALUE = gcResults.
  IF gcResults = '' OR gcResults = ? THEN
    slOptions:SENSITIVE = TRUE.
  ELSE ENABLE {&TERMS-BTNS} btnApply WITH FRAME {&FRAME-NAME}.

  RUN setOperators ( INPUT 'DISABLE' ).
  SELF:SENSITIVE = FALSE.

  IF edResults:SCREEN-VALUE EQ '' OR edResults:SCREEN-VALUE EQ ? THEN
    DISABLE {&TERMS-BTNS} WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME slOptions
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL slOptions C-Win
ON DEFAULT-ACTION OF slOptions IN FRAME DEFAULT-FRAME
DO:
  btnUndo:SENSITIVE = TRUE.
  btnApply:SENSITIVE = FALSE.
  edResults:SCREEN-VALUE = edResults:SCREEN-VALUE + 
                           (IF edResults:SCREEN-VALUE NE '' THEN ' '
                            ELSE '') + cChoice.
  slOptions:SENSITIVE = FALSE.

  RUN setOperators ( INPUT 'ENABLE' ).
  APPLY 'ENTRY' TO btnEqual.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL slOptions C-Win
ON VALUE-CHANGED OF slOptions IN FRAME DEFAULT-FRAME
DO:
  cChoice = ENTRY(LOOKUP(slOptions:SCREEN-VALUE,
                         slOptions:LIST-ITEM-PAIRS) - 1,
                  slOptions:LIST-ITEM-PAIRS).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

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
  RUN loadOptions.

  /* Setup generic trigger for operator buttons to reduce code size. */
  ON 'CHOOSE':U OF btnBegins, 
                   btnContains, 
                   btnEqual, 
                   btnGT, 
                   btnGTEQ, 
                   btnLT, 
                   btnLTEQ, 
                   btnMatches, 
                   btnNE            
            IN FRAME {&FRAME-NAME} DO:

    RUN protools/_psvaldlg.w ( INPUT cChoice,
                               INPUT SELF:LABEL,
                               OUTPUT cValue ).
    IF cValue NE ? THEN DO:
      edResults:SCREEN-VALUE = edResults:SCREEN-VALUE + ' ' + 
                               SELF:LABEL + ' ~'' + cValue + '~''.
      RUN setOperators ( INPUT 'DISABLE' ).
      ENABLE {&TERMS-BTNS} btnApply WITH FRAME {&FRAME-NAME}.
      APPLY 'ENTRY' TO btnApply IN FRAME {&FRAME-NAME}.
    END.
  END.

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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
  DISPLAY slOptions lblOptions edResults 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE slOptions btnEqual btnNE btnGT btnLT btnGTEQ btnLTEQ btnBegins 
         btnMatches btnContains btnAnd btnOr btnUndo btnClear edResults BtnHelp 
         BtnClose BtnApply RECT-1 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadOptions C-Win 
PROCEDURE loadOptions :
/*------------------------------------------------------------------------------
  Purpose:     Loads up the options in the Options Selection List and initializes
               it's state
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    APPLY 'VALUE-CHANGED' TO slOptions.
    RUN setOperators ( INPUT 'DISABLE' ).

    IF pcFilter EQ '' OR pcFilter EQ ? THEN
      DISABLE {&TERMS-BTNS}.

    ELSE DO:
      ENABLE {&TERMS-BTNS}.
      ASSIGN edResults:SCREEN-VALUE = pcLabels
             slOptions:SENSITIVE    = FALSE.
    END.
    btnUndo:SENSITIVE = FALSE.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setOperators C-Win 
PROCEDURE setOperators :
/*------------------------------------------------------------------------------
  Purpose:     Resets the state of the operator buttons according to pcState
  Parameters:  INPUT pcState AS CHARACTER
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcState AS CHARACTER  NO-UNDO.

  IF pcState EQ 'ENABLE' THEN DO:
    ENABLE {&OPERATOR-BTNS} WITH FRAME {&FRAME-NAME}.
    IF cChoice NE 'Parameters' THEN
      btnContains:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.
  END.
  ELSE
    DISABLE  {&OPERATOR-BTNS} WITH FRAME {&FRAME-NAME}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

