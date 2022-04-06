&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          rtb              PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
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

{getsrclist.i}

DEFINE VARIABLE winfo AS CHARACTER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttfiles

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 ttfiles.FILENAME ttfiles.fullname ttfiles.haslicense ttfiles.appbuilder   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1   
&Scoped-define SELF-NAME BROWSE-1
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY {&SELF-NAME} FOR EACH ttfiles NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 ttfiles
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 ttfiles


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS wdirectory EDITOR-1 wfilter BROWSE-1 ~
EDITOR-2 vhaslicense vnolicense vtotal BUTTON-1 BUTTON-2 BUTTON-3 BUTTON-4 
&Scoped-Define DISPLAYED-OBJECTS wdirectory EDITOR-1 wfilter EDITOR-2 ~
vhaslicense vnolicense vtotal 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "1. Get File List" 
     SIZE 16 BY 1.14.

DEFINE BUTTON BUTTON-2 
     LABEL "2. Check License" 
     SIZE 18 BY 1.14.

DEFINE BUTTON BUTTON-3 
     LABEL "Check Insert" 
     SIZE 18 BY 1.14.

DEFINE BUTTON BUTTON-4 
     LABEL "3. Add License" 
     SIZE 18 BY 1.14.

DEFINE VARIABLE EDITOR-1 AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL LARGE
     SIZE 109 BY 16
     FONT 2 NO-UNDO.

DEFINE VARIABLE EDITOR-2 AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL LARGE
     SIZE 109 BY 16
     FONT 2 NO-UNDO.

DEFINE VARIABLE vhaslicense AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Has License" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE vnolicense AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "No License" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE vtotal AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Total" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE wdirectory AS CHARACTER FORMAT "X(256)":U INITIAL "c:~\progress~\wrk" 
     LABEL "Directory to process" 
     VIEW-AS FILL-IN 
     SIZE 69 BY .95 NO-UNDO.

DEFINE VARIABLE wfilter AS CHARACTER FORMAT "X(256)":U INITIAL "p,w" 
     LABEL "Extensions for filter" 
     VIEW-AS FILL-IN 
     SIZE 69 BY .95 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      ttfiles SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 C-Win _FREEFORM
  QUERY BROWSE-1 NO-LOCK DISPLAY
      ttfiles.FILENAME
ttfiles.fullname
ttfiles.haslicense
ttfiles.appbuilder
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 90 BY 27.38 ROW-HEIGHT-CHARS .75 EXPANDABLE.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     wdirectory AT ROW 1.48 COL 20 COLON-ALIGNED
     EDITOR-1 AT ROW 1.48 COL 93 NO-LABEL
     wfilter AT ROW 2.57 COL 20 COLON-ALIGNED
     BROWSE-1 AT ROW 3.86 COL 1.6
     EDITOR-2 AT ROW 17.76 COL 93 NO-LABEL
     vhaslicense AT ROW 31.71 COL 12.8 COLON-ALIGNED AUTO-RETURN 
     vnolicense AT ROW 31.71 COL 40.6 COLON-ALIGNED AUTO-RETURN 
     vtotal AT ROW 31.71 COL 67 COLON-ALIGNED AUTO-RETURN 
     BUTTON-1 AT ROW 33.19 COL 2
     BUTTON-2 AT ROW 33.19 COL 19.4
     BUTTON-3 AT ROW 33.24 COL 39
     BUTTON-4 AT ROW 33.29 COL 58.8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 202 BY 33.57.


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
         TITLE              = "POSSE License Adder"
         COLUMN             = 1.6
         ROW                = 1.57
         HEIGHT             = 33.57
         WIDTH              = 202
         MAX-HEIGHT         = 35.38
         MAX-WIDTH          = 204.8
         VIRTUAL-HEIGHT     = 35.38
         VIRTUAL-WIDTH      = 204.8
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



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */
/* BROWSE-TAB BROWSE-1 wfilter DEFAULT-FRAME */
ASSIGN 
       EDITOR-1:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       EDITOR-2:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttfiles NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* POSSE License Adder */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* POSSE License Adder */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
&Scoped-define SELF-NAME BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 C-Win
ON VALUE-CHANGED OF BROWSE-1 IN FRAME DEFAULT-FRAME
DO:
  IF NOT AVAILABLE ttfiles THEN RETURN.
  EDITOR-1:READ-FILE(ttfiles.fullname).
  RUN getfileinfo (ttfiles.fullname, OUTPUT winfo).
  EDITOR-2:SCREEN-VALUE = winfo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 C-Win
ON CHOOSE OF BUTTON-1 IN FRAME DEFAULT-FRAME /* 1. Get File List */
OR RETURN OF wdirectory DO:
  SESSION:SET-WAIT-STATE("general").
  RUN readdir(wdirectory:SCREEN-VALUE).
  SESSION:SET-WAIT-STATE("").
  RUN cleantt(wfilter:SCREEN-VALUE).
  {&OPEN-QUERY-{&BROWSE-NAME}}
  APPLY "VALUE-CHANGED" TO BROWSE-1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 C-Win
ON CHOOSE OF BUTTON-2 IN FRAME DEFAULT-FRAME /* 2. Check License */
DO:
  SESSION:SET-WAIT-STATE("general").
  ASSIGN vhaslicense = 0 vnolicense = 0 vtotal = 0.
  FOR EACH ttfiles:
      RUN getfileinfo (ttfiles.fullname, OUTPUT winfo).
      ttfiles.haslicense = ENTRY(2, winfo) = "yes" NO-ERROR.
      IF ERROR-STATUS:ERROR THEN ttfiles.haslicense = ?.

      ttfiles.appbuilder = winfo BEGINS "appbuilder".
      
      /* MESSAGE "Error: " ttfiles.FILENAME winfo. */

      vtotal = vtotal + 1.
      IF ttfiles.haslicense THEN vhaslicense = vhaslicense + 1.
      ELSE vnolicense = vnolicense + 1.
  END.
  DISPLAY vhaslicense vnolicense vtotal WITH FRAME {&FRAME-NAME}.
  SESSION:SET-WAIT-STATE("").
  {&OPEN-QUERY-{&BROWSE-NAME}}
  APPLY "VALUE-CHANGED" TO BROWSE-1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 C-Win
ON CHOOSE OF BUTTON-3 IN FRAME DEFAULT-FRAME /* Check Insert */
DO:
  RUN insertlicense(ttfiles.fullname, ttfiles.appbuilder, ttfiles.haslicense, "test.tmp").
  EDITOR-2:READ-FILE("test.tmp").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 C-Win
ON CHOOSE OF BUTTON-4 IN FRAME DEFAULT-FRAME /* 3. Add License */
DO:
  DEF VAR X AS LOGICAL NO-UNDO INITIAL NO.

  MESSAGE "Are you sure you want to run Add the license file to all the programs?"
  VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE X.
  IF NOT X THEN RETURN.
  SESSION:SET-WAIT-STATE("general").
  FOR EACH ttfiles WHERE NOT haslicense:
      RUN insertlicense(ttfiles.fullname, ttfiles.appbuilder, ttfiles.haslicense, "ttt.tmp").
      OS-COPY "ttt.tmp" VALUE(ttfiles.fullname).
  END.
  SESSION:SET-WAIT-STATE("").
  MESSAGE "Add License complete." SKIP
          "Please re-run 2. Check License, if needed" VIEW-AS ALERT-BOX.
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
  DISPLAY wdirectory EDITOR-1 wfilter EDITOR-2 vhaslicense vnolicense vtotal 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE wdirectory EDITOR-1 wfilter BROWSE-1 EDITOR-2 vhaslicense vnolicense 
         vtotal BUTTON-1 BUTTON-2 BUTTON-3 BUTTON-4 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

