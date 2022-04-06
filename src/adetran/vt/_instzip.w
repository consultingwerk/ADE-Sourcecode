&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Zip-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Zip-Frame 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: adetran/pm/_instzip.w

  Description: Unzips a zip file for a TranMan2 kit. 

  Input Parameters:
      <none>

  Output Parameters:
      ZipFile (char) - zip filename to use
      ZipDir(char)   - Directory to zip into

  Author: Gerry Seidl

  Created: 9/15/95
  Updated: 11/96 SLK Changed for FONT
                OPSYS MS-DOS
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE SHARED VARIABLE _Kit AS CHARACTER NO-UNDO.

/* Parameters Definitions ---                                           */
DEFINE OUTPUT PARAMETER ZipFile  AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER UNZipDir AS CHARACTER NO-UNDO.

/* Local Variable Definitions ---                                       */

{adetran/vt/vthlp.i}   /* Definitions for help context strings          */

&IF LOOKUP("{&OPSYS}","MSDOS,WIN32":U) > 0  &THEN
    &SCOPED-DEFINE SLASH ~~~\
&ELSE
    &SCOPED-DEFINE SLASH /
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Zip-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn_OK RECT-6 ProjDir Btn_Cancel btn_Help ~
RECT-5 btnFiles ZipFileName overwrite 
&Scoped-Define DISPLAYED-OBJECTS ProjDir ZipFileName overwrite 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnFiles 
     LABEL "&Files..." 
     SIZE 15 BY 1.12.

DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.12.

DEFINE BUTTON btn_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.12.

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE ProjDir AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39 BY 1
     FONT 4 NO-UNDO.

DEFINE VARIABLE ZipFileName AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39 BY 1
     FONT 4 NO-UNDO.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 57 BY 2.77.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 57 BY 2.65.

DEFINE VARIABLE overwrite AS LOGICAL INITIAL yes 
     LABEL "&Overwrite Existing Files" 
     VIEW-AS TOGGLE-BOX
     SIZE 37 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Zip-Frame
     ProjDir AT ROW 2.31 COL 2 COLON-ALIGNED NO-LABEL
     ZipFileName AT ROW 5.31 COL 2 COLON-ALIGNED NO-LABEL
     Btn_OK AT ROW 1.38 COL 63
     Btn_Cancel AT ROW 2.69 COL 63
     btn_Help AT ROW 3.96 COL 63
     btnFiles AT ROW 5.19 COL 44
     overwrite AT ROW 6.42 COL 5
     "Project Directory" VIEW-AS TEXT
          SIZE 24 BY .54 AT ROW 1.23 COL 5
     RECT-6 AT ROW 1.46 COL 3
     "Zip Filename" VIEW-AS TEXT
          SIZE 23 BY .54 AT ROW 4.46 COL 5
     RECT-5 AT ROW 4.65 COL 3
     SPACE(18.39) SKIP(0.28)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Install Zip File"
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
/* SETTINGS FOR DIALOG-BOX Zip-Frame
                                                                        */
ASSIGN 
       FRAME Zip-Frame:SCROLLABLE       = FALSE
       FRAME Zip-Frame:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Zip-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Zip-Frame Zip-Frame
ON WINDOW-CLOSE OF FRAME Zip-Frame /* Install Zip File */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnFiles
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnFiles Zip-Frame
ON CHOOSE OF btnFiles IN FRAME Zip-Frame /* Files... */
DO:
  define var OKPressed as logical no-undo.

  SYSTEM-DIALOG GET-FILE ZipFileName
     TITLE      "Zip file"
     FILTERS    "Zip Files (*.zip)" "*.zip":u
     MUST-EXIST
     USE-FILENAME
     UPDATE OKpressed.      

  IF OKpressed = TRUE THEN
    display ZipFileName with frame {&frame-name}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel Zip-Frame
ON CHOOSE OF Btn_Cancel IN FRAME Zip-Frame /* Cancel */
DO:
  ASSIGN ZipFile = ""
         UNZipDir = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_Help Zip-Frame
ON CHOOSE OF btn_Help IN FRAME Zip-Frame /* Help */
OR HELP OF FRAME {&FRAME-NAME} DO:
    RUN adecomm/_adehelp.p ("vt":u, "context":U, {&Install_Zip_File_Dialog_Box}, ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Zip-Frame
ON CHOOSE OF Btn_OK IN FRAME Zip-Frame /* OK */
DO:
    DEFINE VARIABLE ext       AS CHARACTER NO-UNDO. /* file extention */
    DEFINE VARIABLE createit  AS LOGICAL   NO-UNDO INIT YES.
    DEFINE VARIABLE errcode   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE ThisMessage AS CHAR    NO-UNDO.
    
    ASSIGN ProjDir
           ZipFileName
           OverWrite.
           
    IF ProjDir EQ "" THEN DO:
      MESSAGE "The project directory cannot be blank." VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO ProjDir.
      RETURN NO-APPLY.
    END.
    
    IF ZipFileName EQ "" THEN DO:
      MESSAGE "The zip filename cannot be blank." VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO ZipFileName.
      RETURN NO-APPLY.
    END.
    
    RUN adecomm/_osfext.p(ZipFileName, OUTPUT ext).             /* get file extention */
    IF ext EQ "" THEN ZipFileName = ZipFileName + ".zip":U.     /* if no extention, add ".zip" */
    ELSE IF ext NE ".zip" THEN ZipFileName = REPLACE(ZipFileName,ext,".zip":U). /* if ext not ".zip", change to ".zip" */
    
    FILE-INFO:FILE-NAME = ZipFileName.
    IF FILE-INFO:FULL-PATHNAME NE ? THEN ZipFileName = FILE-INFO:FULL-PATHNAME.
    ELSE DO:
      MESSAGE "Zip file does not exist." VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY":U TO ZipFileName IN FRAME {&FRAME-NAME}.
      RETURN NO-APPLY.
    END.
    ASSIGN ZipFile = ZipFileName.

    FILE-INFO:FILE-NAME = ProjDir.
    IF FILE-INFO:FULL-PATHNAME NE ? AND NOT OverWrite THEN DO:
      MESSAGE "This project directory already exists and overwrite was not specified."
        VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO OverWrite In FRAME {&FRAME-NAME}.
      RETURN NO-APPLY.
    END.    
    
    IF FILE-INFO:FULL-PATHNAME EQ ? THEN DO:
      ThisMessage = "Directory " + "'" + ProjDir + "'" + " does not exist." +
                    CHR(10) + "Do you want to create it?".
      message ThisMessage view-as alert-box question button yes-no update createit.
      if createit then
      do:
        RUN adecomm/_oscpath.p (INPUT ProjDir, OUTPUT errcode).
        if errcode NE 0 then
        do:
          message "Directory was not created. Operating System error #"+ STRING(errcode) + "."
            view-as alert-box error.
          apply "entry":u to ProjDir in frame {&FRAME-NAME}.
          return no-apply.
        end.
        else assign FILE-INFO:FILE-NAME = ProjDir
                    UNZipDir            = FILE-INFO:FULL-PATHNAME.
      end.
      else DO:
        apply "entry":U TO ProjDir IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
      END.
    END.
    ELSE ASSIGN UNZipDir = file-info:full-pathname.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Zip-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  WAIT-FOR GO OF FRAME {&FRAME-NAME} FOCUS ProjDir.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Zip-Frame _DEFAULT-DISABLE
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
  HIDE FRAME Zip-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Zip-Frame _DEFAULT-ENABLE
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
  DISPLAY ProjDir ZipFileName overwrite 
      WITH FRAME Zip-Frame.
  ENABLE Btn_OK RECT-6 ProjDir Btn_Cancel btn_Help RECT-5 btnFiles ZipFileName 
         overwrite 
      WITH FRAME Zip-Frame.
  VIEW FRAME Zip-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Zip-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


