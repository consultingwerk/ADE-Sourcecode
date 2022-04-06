&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File    :    _rundlg.w
  Purpose :    Tran Man II Run Dialog Box.
  Syntax  :    
            RUN adetran/pm/_rundlg.w (INPUT p_hProc).
  
  Description: 
    Use the Run dialog box to run application code and view a translated
    application.

  Input Parameters:
    
  Output Parameters:

  Author:    J. Palazzo

  Created: May, 1995
  Updated: 11/96 SLK ported to win95 WINDOW-SYSTEM
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
&IF DEFINED(UIB_is_Running) <> 0 &THEN
DEFINE VAR p_hProc     AS HANDLE   NO-UNDO.
&ELSE
DEFINE INPUT  PARAMETER p_hProc     AS HANDLE   NO-UNDO.
&ENDIF

/* Local Variable Definitions ---                                       */
{adetran/pm/tranhelp.i}
DEFINE SHARED VARIABLE RunFile AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 Btn_OK run-pgm btn_browse Btn_Cancel ~
Btn_Help RunLanguage 
&Scoped-Define DISPLAYED-OBJECTS run-pgm RunLanguage 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON btn_browse 
     LABEL "&File...":L 
     SIZE 15 BY 1.125.

DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "&Close" 
     SIZE 15 BY 1.125.

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.125.

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "&Run" 
     SIZE 15 BY 1.125.

DEFINE VARIABLE RunLanguage AS CHARACTER FORMAT "X(15)":U INITIAL "<unnamed>" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "<unnamed>" 
     SIZE 39.6 BY 1 NO-UNDO.

DEFINE VARIABLE LangLabel AS CHARACTER FORMAT "X(256)":U INITIAL "&Language:" 
      VIEW-AS TEXT 
     SIZE 38 BY .67 NO-UNDO.

DEFINE VARIABLE NameLabel AS CHARACTER FORMAT "X(256)":U INITIAL "&Name of Procedure to Run:" 
      VIEW-AS TEXT 
     SIZE 38 BY .67 NO-UNDO.

DEFINE VARIABLE run-pgm AS CHARACTER FORMAT "X(256)" 
     VIEW-AS FILL-IN 
     SIZE 39.6 BY 1.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 59.4 BY 4.62.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     Btn_OK AT ROW 1.67 COL 63
     NameLabel AT ROW 1.81 COL 4.4 NO-LABEL
     run-pgm AT ROW 2.67 COL 4.4 HELP
          "Enter the name of the program you wish to run" NO-LABEL
     btn_browse AT ROW 2.71 COL 45
     Btn_Cancel AT ROW 3 COL 63
     LangLabel AT ROW 3.95 COL 4.4 NO-LABEL
     Btn_Help AT ROW 4.33 COL 63
     RunLanguage AT ROW 4.76 COL 4.4 NO-LABEL
     RECT-2 AT ROW 1.52 COL 2.6
     SPACE(16.19) SKIP(0.52)
    WITH VIEW-AS DIALOG-BOX 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Run"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic,Browse,DB-Fields,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
                                                                        */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN LangLabel IN FRAME Dialog-Frame
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR FILL-IN NameLabel IN FRAME Dialog-Frame
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR FILL-IN run-pgm IN FRAME Dialog-Frame
   ALIGN-L                                                              */
ASSIGN 
       run-pgm:PRIVATE-DATA IN FRAME Dialog-Frame     = 
                "run-pgm".

/* SETTINGS FOR COMBO-BOX RunLanguage IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX Dialog-Frame
/* Query rebuild information for DIALOG-BOX Dialog-Frame
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX Dialog-Frame */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON ALT-L OF FRAME Dialog-Frame /* Run */
ANYWHERE
DO:
  IF SESSION:WINDOW-SYSTEM BEGINS "MS-WIN":U THEN
    APPLY "ENTRY":U TO RunLanguage.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON ALT-N OF FRAME Dialog-Frame /* Run */
ANYWHERE
DO:
  IF SESSION:WINDOW-SYSTEM BEGINS "MS-WIN":U THEN
    APPLY "ENTRY":U TO run-pgm.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON GO OF FRAME Dialog-Frame /* Run */
DO:
  DEFINE VARIABLE CurLang AS CHARACTER NO-UNDO.  
  DEFINE VARIABLE hProc   AS HANDLE NO-UNDO.
  
  /* Is their a non-blank name? */
  ASSIGN run-pgm:SCREEN-VALUE = TRIM(run-pgm:SCREEN-VALUE)
         run-pgm              = run-pgm:SCREEN-VALUE
         RunLanguage          = RunLanguage:SCREEN-VALUE
         NO-ERROR.
  IF run-pgm:SCREEN-VALUE <> "":U THEN
  DO:
    ASSIGN run-pgm = SEARCH(run-pgm:SCREEN-VALUE) no-error.
    IF run-pgm eq ? THEN
    DO:
       DO ON STOP UNDO, LEAVE:
       MESSAGE run-pgm:SCREEN-VALUE SKIP
               "Cannot find file to run."
            VIEW-AS ALERT-BOX INFORMATION IN WINDOW {&WINDOW-NAME}.
       END.
       APPLY "ENTRY" TO run-pgm.
       RETURN NO-APPLY.
    END.
    
    ASSIGN CurLang = CURRENT-LANGUAGE.
    /* Run a procedure (with the appropriate wrapper for a UIB run). */
    RUN-BLOCK:
    DO ON QUIT       , RETRY RUN-BLOCK 
       ON ERROR  UNDO, RETRY RUN-BLOCK 
       ON STOP   UNDO, RETRY RUN-BLOCK
       ON ENDKEY UNDO, RETRY RUN-BLOCK:
      IF NOT RETRY THEN
      DO:
        IF RunLanguage <> "<unnamed>" THEN
            ASSIGN CURRENT-LANGUAGE = RunLanguage:SCREEN-VALUE.
        RUN disable_widgets IN p_hProc NO-ERROR.
        ASSIGN FRAME {&FRAME-NAME}:VISIBLE = FALSE.
        RUN adecomm/_runcode.p ( INPUT run-pgm     ,
                                 INPUT "_PAUSE" /* Run Flags   */ ,
                                 INPUT ?        /* Stop_Widget */ ,
                                 OUTPUT hProc   /* Procedure handle */) .
        RunFile = run-pgm:screen-value.
      END.

      DISPLAY {&DISPLAYED-OBJECTS} WITH FRAME {&FRAME-NAME}.
      IF CURRENT-LANGUAGE <> CurLang THEN
        ASSIGN CURRENT-LANGUAGE = CurLang.
      ASSIGN CURRENT-WINDOW = DEFAULT-WINDOW.
      RETURN NO-APPLY.
    END.  /* Block to trap quit */
  END. /* IF run-pgm is not blank */  
  ELSE
  DO:
    DO ON STOP UNDO, LEAVE:
        MESSAGE "Enter a procedure to run."
            VIEW-AS ALERT-BOX INFORMATION IN WINDOW {&WINDOW-NAME}.
    END.
    APPLY "ENTRY" TO run-pgm.
    RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Run */
DO:
 APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_browse Dialog-Frame
ON CHOOSE OF btn_browse IN FRAME Dialog-Frame /* File... */
DO:
  DEFINE VAR l_ok AS LOGICAL NO-UNDO.
  DEFINE VAR filename AS CHAR NO-UNDO.
  DEFINE VAR Filter_NameString AS CHAR EXTENT 5                NO-UNDO.
  DEFINE VAR Filter_FileSpec   LIKE Filter_NameString          NO-UNDO.

  /* Initialize the file filters, for special cases. */
  ASSIGN Filter_NameString[ 1 ] = "Compiled r-code(*.r)"
         Filter_FileSpec[ 1 ]   = "*.r" 

  
         Filter_NameString[ 2 ] = IF OPSYS = "UNIX":U
                                    THEN "All Source(*.[pw])"
                                    ELSE "All Source(*.p~;*.w)"
         Filter_FileSpec[ 2 ]   = IF OPSYS = "UNIX":U
                                    THEN "*.[pw]"
                                    ELSE "*.p~;*.w"
         Filter_NameString[ 3 ] = "Procedures(*.p)"
         Filter_FileSpec[ 3 ]   = "*.p"
         Filter_NameString[ 4 ] = "Windows(*.w)"
         Filter_FileSpec[ 4 ]   = "*.w"
         Filter_NameString[ 5 ] = IF OPSYS = "UNIX":U
                                    THEN "All Files(*)"
                                    ELSE "All Files(*.*)"
         Filter_FileSpec[ 5 ]   = IF OPSYS = "UNIX":U
                                    THEN "*"
                                    ELSE "*.*".

  /* Ask for a file name. NOTE: File-names to run must exist */                          
  filename = TRIM(run-pgm:SCREEN-VALUE).
  SYSTEM-DIALOG GET-FILE filename
      TITLE    "Run"
      FILTERS  Filter_NameString[ 1 ]   Filter_FileSpec[ 1 ],
               Filter_NameString[ 2 ]   Filter_FileSpec[ 2 ],
               Filter_NameString[ 3 ]   Filter_FileSpec[ 3 ],
               Filter_NameString[ 4 ]   Filter_FileSpec[ 4 ],
               Filter_NameString[ 5 ]   Filter_FileSpec[ 5 ]             
      MUST-EXIST
      UPDATE   l_ok.  
  IF l_ok THEN run-pgm:SCREEN-VALUE = filename.
  apply "leave" to run-pgm.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help Dialog-Frame
ON CHOOSE OF Btn_Help IN FRAME Dialog-Frame /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  RUN adecomm/_adehelp.p ( "tran", "CONTEXT", {&Run_Dlgbx}, ? ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME run-pgm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL run-pgm Dialog-Frame
ON LEAVE OF run-pgm IN FRAME Dialog-Frame
DO:
  RUN set-lang. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) /* AND FRAME {&FRAME-NAME}:PARENT eq ? */
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON STOP    UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
   
  /* Label values are from define statement initial option. */
  assign
    NameLabel:screen-value = NameLabel
    LangLabel:screen-value = LangLabel.
    
  RUN init-values.
  RUN enable_me.       
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME Dialog-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_me Dialog-Frame 
PROCEDURE enable_me :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY run-pgm RunLanguage 
      WITH FRAME Dialog-Frame.
  ENABLE run-pgm btn_browse RunLanguage Btn_OK Btn_Cancel  Btn_Help 
      WITH FRAME Dialog-Frame.   
  if run-pgm:screen-value = "" and RunFile <> "" then do:
    assign
      run-pgm:screen-value = RunFile
      run-pgm:auto-zap     = true.    
  end.

  RUN ADECOMM/_SETCURS.P (""). /* Bob 6/5/95 */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-values Dialog-Frame 
PROCEDURE init-values :
do with frame {&frame-name}:
    RUN set-lang.           
end.   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-lang Dialog-Frame 
PROCEDURE set-lang :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR file_name AS CHARACTER NO-UNDO.
  DEFINE VAR file_ext  AS CHARACTER NO-UNDO.
  DEFINE VAR rfile     AS CHARACTER NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN run-pgm:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
                TRIM(run-pgm:SCREEN-VALUE IN FRAME {&FRAME-NAME})
           file_name = run-pgm:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-ERROR.
    IF file_name <> "":U and file_name <> ? THEN DO:
      RUN adecomm/_osfext.p (INPUT file_name , OUTPUT file_ext).
      IF file_ext = "" THEN ASSIGN rfile = file_name + ".r":U.
      ELSE  ASSIGN rfile = SUBSTRING(file_name, 1,
                             LENGTH(file_name, "CHARACTER") - 2, "CHARACTER") + ".r":U.
      ASSIGN rfile = SEARCH( rfile ) NO-ERROR.
      IF (rfile <> ?) THEN DO:
        current-language = current-language.
        IF rfile <> run-pgm THEN
          ASSIGN RCODE-INFO:FILE-NAME     = rfile
                 RunLanguage:LIST-ITEMS   = IF RCODE-INFO:LANGUAGES = ? OR RCODE-INFO:LANGUAGES = "":U
                                            THEN "<unnamed>" ELSE RCODE-INFO:LANGUAGES
                 RunLanguage:SCREEN-VALUE = if RunLanguage:num-items > 1 
                                            then RunLanguage:entry(2)
                                            else RunLanguage:entry(1)
                 RunLanguage              = RunLanguage:SCREEN-VALUE
                 RunLanguage:SENSITIVE    = RunLanguage:NUM-ITEMS > 1.
      END. /* If rfile <> ? */
      ELSE ASSIGN RunLanguage = "<unnamed>":U
                  RunLanguage:LIST-ITEMS   = RunLanguage
                  RunLanguage:SCREEN-VALUE = RunLanguage.

    END.  
  END. /* DO WITH FRAME */
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


