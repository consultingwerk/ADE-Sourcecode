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

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN
DEFINE VARIABLE fnt    AS INTEGER   INITIAL ?                      NO-UNDO.
DEFINE VARIABLE flnm   AS CHARACTER INITIAL "status.txt"           NO-UNDO.
DEFINE VARIABLE lpp    AS INTEGER   INITIAL 66                     NO-UNDO.
DEFINE VARIABLE prflag AS INTEGER   INITIAL 0                      NO-UNDO.
DEFINE VARIABLE mode   AS LOGICAL   INITIAL ?                      NO-UNDO.
&ELSE
DEFINE INPUT-OUTPUT PARAMETER fnt    AS INTEGER                    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER flnm   AS CHARACTER                  NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER lpp    AS INTEGER                    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER prflag AS INTEGER                    NO-UNDO.
DEFINE OUTPUT PARAMETER       mode   AS LOGICAL   INITIAL ?        NO-UNDO.
&ENDIF

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE i        AS INTEGER                                NO-UNDO.
DEFINE VARIABLE fnt-list AS CHARACTER INITIAL "(Default),0":U      NO-UNDO.

{adetran/pm/tranhelp.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 Btn_OK rs-direct MS-print Btn_Cancel ~
Landscape pg-sz cb-font Btn_Help 
&Scoped-Define DISPLAYED-OBJECTS rs-direct MS-print Landscape pg-sz cb-font ~
file-name lns 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.12
     BGCOLOR 8 .

DEFINE BUTTON btn_files 
     LABEL "&Files..." 
     SIZE 15 BY 1.12.

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.12
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.12
     BGCOLOR 8 .

DEFINE VARIABLE cb-font AS CHARACTER FORMAT "X(256)":U INITIAL "(Default)" 
     LABEL "F&ont" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "(Default)","0" 
     SIZE 15 BY 1 NO-UNDO.

DEFINE VARIABLE file-name AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY 1 NO-UNDO.

DEFINE VARIABLE lns AS CHARACTER FORMAT "X(256)":U INITIAL "(Lines)" 
      VIEW-AS TEXT 
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE pg-sz AS INTEGER FORMAT "  >>9":U INITIAL 66 
     LABEL "Page &Size" 
     VIEW-AS FILL-IN 
     SIZE 5 BY 1 NO-UNDO.

DEFINE VARIABLE rs-direct AS LOGICAL 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Output To &Printer", no,
"Output to A &Text File", yes
     SIZE 23 BY 1.62 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 62 BY 5.65.

DEFINE VARIABLE Landscape AS LOGICAL INITIAL no 
     LABEL "&Landscape" 
     VIEW-AS TOGGLE-BOX
     SIZE 29 BY .77 NO-UNDO.

DEFINE VARIABLE MS-print AS LOGICAL INITIAL no 
     LABEL "&MS Print Setup Dialog" 
     VIEW-AS TOGGLE-BOX
     SIZE 29 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     Btn_OK AT ROW 1.65 COL 66
     rs-direct AT ROW 2.12 COL 5 NO-LABEL
     MS-print AT ROW 2.12 COL 32
     Btn_Cancel AT ROW 2.81 COL 66
     Landscape AT ROW 2.85 COL 32
     pg-sz AT ROW 4.23 COL 14 COLON-ALIGNED
     cb-font AT ROW 4.23 COL 40 COLON-ALIGNED
     Btn_Help AT ROW 4.65 COL 66
     file-name AT ROW 5.58 COL 3 COLON-ALIGNED NO-LABEL
     btn_files AT ROW 5.58 COL 48
     lns AT ROW 4.23 COL 19.14 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 1.31 COL 2
     SPACE(17.59) SKIP(0.22)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Statistics Report Print Dialog"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   L-To-R                                                               */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON btn_files IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN file-name IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN lns IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Statistics Report Print Dialog */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_files
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_files Dialog-Frame
ON CHOOSE OF btn_files IN FRAME Dialog-Frame /* Files... */
DO:
  DEFINE VARIABLE OKPressed AS LOGICAL                    NO-UNDO.
  
  SYSTEM-DIALOG GET-FILE file-name
         TITLE   "Statistics Text File"
         FILTERS "Text Files (*.txt)" "*.txt":U,
                 "All Files (*.*)"    "*.*":U
         USE-FILENAME
         UPDATE OKPressed.
  IF OKPressed THEN file-name:SCREEN-VALUE IN FRAME {&FRAME-NAME} = file-name.
  ELSE file-name = file-name:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help Dialog-Frame
ON CHOOSE OF Btn_Help IN FRAME Dialog-Frame /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  run adecomm/_adehelp.p ("tran","context",{&Stats_Report_Print_Dialog_Box}, ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Dialog-Frame
ON CHOOSE OF Btn_OK IN FRAME Dialog-Frame /* OK */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN MODE   = (rs-direct:SCREEN-VALUE = "YES")
           flnm   = file-name:SCREEN-VALUE
           prFlag = (IF MS-print:CHECKED THEN 1 ELSE 0) +
                    (IF Landscape:CHECKED THEN 2 ELSE 0)
           lpp    = INTEGER(pg-sz:SCREEN-VALUE)
           fnt    = IF cb-font:SCREEN-VALUE = "(Default)":U THEN ?
                    ELSE INTEGER(cb-font:SCREEN-VALUE).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-direct
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-direct Dialog-Frame
ON VALUE-CHANGED OF rs-direct IN FRAME Dialog-Frame
DO:
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN file-name:SENSITIVE = (SELF:SCREEN-VALUE = "YES")
           btn_files:SENSITIVE = file-name:SENSITIVE
           MS-print:SENSITIVE  = NOT file-name:SENSITIVE
           cb-font:SENSITIVE   = NOT file-name:SENSITIVE.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  DO i = 1 TO (FONT-TABLE:NUM-ENTRIES - 1):
    fnt-list = fnt-list + ",":U + STRING(i).
  END.
  ASSIGN file-name = flnm
         MS-Print  = IF PrFlag MOD 2 = 1 THEN YES  ELSE NO
         Landscape = IF PrFlag > 1       THEN YES  ELSE NO
         cb-font:LIST-ITEMS = fnt-list
         cb-font   = IF fnt = ? THEN "(Default)":U ELSE STRING(fnt)
         pg-sz     = LPP.
  RUN enable_UI.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame _DEFAULT-ENABLE
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
  DISPLAY rs-direct MS-print Landscape pg-sz cb-font file-name lns 
      WITH FRAME Dialog-Frame.
  ENABLE RECT-1 Btn_OK rs-direct MS-print Btn_Cancel Landscape pg-sz cb-font 
         Btn_Help 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


