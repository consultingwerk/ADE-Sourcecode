&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File:        protools/df9to8.w

  Description: ERwin only supports PROGRESS features found in V8.  
               Therefore, to reverse engineer a V9 database into ERwin, 
               it is necessary to strip all lines from a V9 dictionary 
               schema dump file (a .df file) that specify features 
               unknown to Erwin.
               
               This utility reads in a valid V9 style .df file, and 
               generates a second .df file that ERwin can load without 
               error.


  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author:     Ross Hunter
              ross@progress.com
  Created:    22 March 2001

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS V9df btn_browse V8df btn_browse-2 BtnOK ~
BtnCancel BtnHelp 
&Scoped-Define DISPLAYED-OBJECTS V9df V8df 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnCancel AUTO-END-KEY DEFAULT 
     LABEL "Cancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON BtnHelp DEFAULT 
     LABEL "&Help" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON BtnOK AUTO-GO DEFAULT 
     LABEL "OK" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON btn_browse 
     LABEL "&File...":L 
     SIZE 15 BY 1.14.

DEFINE BUTTON btn_browse-2 
     LABEL "&File...":L 
     SIZE 15 BY 1.14.

DEFINE VARIABLE V8df AS CHARACTER FORMAT "X(256)":U 
     LABEL "V8 .df File" 
     VIEW-AS FILL-IN 
     SIZE 39 BY 1 TOOLTIP "Enter the name of a file to generate or press ~"Files...~" to select." NO-UNDO.

DEFINE VARIABLE V9df AS CHARACTER FORMAT "X(256)":U 
     LABEL "V9 .df File" 
     VIEW-AS FILL-IN 
     SIZE 39 BY 1 TOOLTIP "Enter the filename of a V9 style .df file or press ~"Files...~" to select." NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     V9df AT ROW 2.19 COL 15 COLON-ALIGNED
     btn_browse AT ROW 2.19 COL 57
     V8df AT ROW 4.1 COL 15 COLON-ALIGNED
     btn_browse-2 AT ROW 4.1 COL 57
     BtnOK AT ROW 6.95 COL 11
     BtnCancel AT ROW 6.95 COL 31
     BtnHelp AT ROW 6.95 COL 57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 75 BY 8.14
         CANCEL-BUTTON BtnCancel.


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
         TITLE              = "Convert a V9 .df File to a V8 .df File"
         HEIGHT             = 8.14
         WIDTH              = 75
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 16
         VIRTUAL-WIDTH      = 80
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Convert a V9 .df File to a V8 .df File */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Convert a V9 .df File to a V8 .df File */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnCancel C-Win
ON CHOOSE OF BtnCancel IN FRAME DEFAULT-FRAME /* Cancel */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnHelp C-Win
ON CHOOSE OF BtnHelp IN FRAME DEFAULT-FRAME /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  MESSAGE "ERwin(R) only supports PROGRESS features found in V8.  Therefore," SKIP
          "to reverse engineer a V9 database into ERwin, it is necessary to strip" SKIP
          "all lines from a V9 dictionary schema dump file (a .df file) that" SKIP
          "specify features unknown to Erwin." SKIP (1)
          "This utility reads in a valid V9 style .df file, and generates a second" SKIP
          ".df file that ERwin can load without error." SKIP (2)
          "ERwin is a registered trademark of PLATINUM technologies, inc."
        VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnOK C-Win
ON CHOOSE OF BtnOK IN FRAME DEFAULT-FRAME /* OK */
DO:
  
    DEFINE VARIABLE LINE     AS CHARACTER FORMAT "x(256)" NO-UNDO.
    DEFINE VARIABLE LINE2    AS CHARACTER FORMAT "x(256)" NO-UNDO.
    DEFINE VARIABLE Token    AS CHARACTER                 NO-UNDO.
    DEFINE VARIABLE ninput   AS INTEGER                   NO-UNDO.
    DEFINE VARIABLE ndel     AS INTEGER                   NO-UNDO.
    DEFINE VARIABLE npassed  AS INTEGER                   NO-UNDO.
    DEFINE VARIABLE maxLnth  AS INTEGER                   NO-UNDO.
    DEFINE VARIABLE fullname AS CHARACTER                 NO-UNDO.


    ASSIGN v9df v8df.  /* Copy filenames from screen buffer */

    /* Check to see if valid filenames have been entered */
    fullname = SEARCH(v9df).
    IF fullname = ? THEN DO:
      MESSAGE "You must enter a valid filename for the V9 style .df" SKIP
              "file to convert."
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
      RETURN NO-APPLY.
    END.


    IF v8df = "" THEN DO:
        MESSAGE "You must enter a valid filename for the V8 style .df" SKIP
                "file that you are attempting to generate."
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN NO-APPLY.
    END.

    INPUT FROM VALUE(fullname).
    OUTPUT TO VALUE(v8df).

    Convert-Loop:
    REPEAT:
      /* Read a line */
      IMPORT UNFORMATTED LINE.

      /* Determine the first token of the line */
      ASSIGN LINE2  = LEFT-TRIM(LINE)
             token  = ENTRY(1,LINE2," ":U)
             ninput = ninput + 1.

      /* Stop if found a cpstream instruction as ERWin doesn't 
         use anymore information */
      IF ENTRY(1,token,"=":U) = "cpstream":U THEN DO:
        ndel = ndel + 1.
        LEAVE Convert-Loop.
      END.

      /* Only write the line if it is a V8 feature */

			IF LOOKUP(token,"UPDATE,AREA,POSITION,SQL-WIDTH,COLUMN-LABEL-SA,LABEL-SA,HELP-SA") = 0 THEN DO:
        npassed = npassed + 1.
        PUT UNFORMATTED LINE SKIP.
      END.
      ELSE ndel = ndel + 1.
    END.  /* End of convert-loop repeat */

    /* maxLnth IS used to align numbers in the MESSAGE statement */
    maxLnth = LENGTH(STRING(ninput),"CHARACTER").

    MESSAGE v8df "has been created from " fullname + "." SKIP (1)
            "        " + STRING(ninput) "lines were processed." SKIP
            "        " + fill("  ",(maxLnth -
                                LENGTH(STRING(ndel),"CHARACTER"))) +
                   STRING(ndel) "lines were removed." SKIP
            "        " + fill("  ",(maxLnth -
                               LENGTH(STRING(npassed),"CHARACTER"))) +
                   STRING(npassed) "line were passed through."
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

    APPLY "CLOSE":U TO THIS-PROCEDURE.
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_browse C-Win
ON CHOOSE OF btn_browse IN FRAME DEFAULT-FRAME /* File... */
DO:
  DEFINE VAR l_ok AS LOGICAL NO-UNDO.
  DEFINE VAR filename AS CHAR NO-UNDO.
  DEFINE VAR Filter_NameString AS CHAR EXTENT 2                NO-UNDO.
  DEFINE VAR Filter_FileSpec   LIKE Filter_NameString          NO-UNDO.

  /* Initialize the file filters, for special cases. */
  ASSIGN Filter_NameString[ 1 ] = IF OPSYS = "UNIX":U
                                    THEN "Dump Files(*.df)"
                                    ELSE "Dump Files(*.df)"
         Filter_FileSpec[ 1 ]   = IF OPSYS = "UNIX":U
                                    THEN "*.df"
                                    ELSE "*.df"
         Filter_NameString[ 2 ] = IF OPSYS = "UNIX":U
                                    THEN "All Files(*)"
                                    ELSE "All Files(*.*)"
         Filter_FileSpec[ 2 ]   = IF OPSYS = "UNIX":U
                                    THEN "*"
                                    ELSE "*.*".

  /* Ask for a file name. NOTE: File-name to convert must exist */                          
  filename = v9df:SCREEN-VALUE.
  SYSTEM-DIALOG GET-FILE filename
      TITLE    "Select the V9 .df file to convert"
      FILTERS  Filter_NameString[ 1 ]   Filter_FileSpec[ 1 ],
               Filter_NameString[ 2 ]   Filter_FileSpec[ 2 ]   
      ASK-OVERWRITE
      MUST-EXIST
      UPDATE   l_ok IN WINDOW {&WINDOW-NAME}.  
  IF l_ok THEN v9df:SCREEN-VALUE = filename.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_browse-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_browse-2 C-Win
ON CHOOSE OF btn_browse-2 IN FRAME DEFAULT-FRAME /* File... */
DO:
  DEFINE VAR l_ok AS LOGICAL NO-UNDO.
  DEFINE VAR filename AS CHAR NO-UNDO.
  DEFINE VAR Filter_NameString AS CHAR EXTENT 2                NO-UNDO.
  DEFINE VAR Filter_FileSpec   LIKE Filter_NameString          NO-UNDO.

  /* Initialize the file filters, for special cases. */
  ASSIGN Filter_NameString[ 1 ] = IF OPSYS = "UNIX":U
                                    THEN "Dump Files(*.df)"
                                    ELSE "Dump Files(*.df)"
         Filter_FileSpec[ 1 ]   = IF OPSYS = "UNIX":U
                                    THEN "*.df"
                                    ELSE "*.df"
         Filter_NameString[ 2 ] = IF OPSYS = "UNIX":U
                                    THEN "All Files(*)"
                                    ELSE "All Files(*.*)"
         Filter_FileSpec[ 2 ]   = IF OPSYS = "UNIX":U
                                    THEN "*"
                                    ELSE "*.*".

  /* Ask for a file name. */                          
  filename = v8df:SCREEN-VALUE.
  SYSTEM-DIALOG GET-FILE filename
      TITLE    "Choose a file to create"
      USE-FILENAME
      ASK-OVERWRITE
      FILTERS  Filter_NameString[ 1 ]   Filter_FileSpec[ 1 ],
               Filter_NameString[ 2 ]   Filter_FileSpec[ 2 ]           
      UPDATE   l_ok IN WINDOW {&WINDOW-NAME}.  
  IF l_ok THEN v8df:SCREEN-VALUE = filename.
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
  DISPLAY V9df V8df 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE V9df btn_browse V8df btn_browse-2 BtnOK BtnCancel BtnHelp 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

