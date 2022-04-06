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

  File    :    _viewer.w
  Purpose :    Tran Man II Compile Log Viewer.
  Syntax  :    
  Description: 
    Use the Compile Log viewer to view log results
  Input Parameters:
  Output Parameters:
  Author:    
  Created: 
  Updated: 07/97 SLK Bug# 97-02-02-003 Dialog too small
------------------------------------------------------------------------*/
&IF DEFINED(UIB_is_Running) = 0 &THEN
DEFINE INPUT PARAMETER pFile AS CHAR NO-UNDO.
&ELSE
DEFINE VARIABLE pFile AS CHAR NO-UNDO.
SYSTEM-DIALOG GET-FILE pFile.
&ENDIF
DEFINE VARIABLE Read_OK AS LOGICAL NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 BtnOK EDITOR-1 BtnPrint 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnOK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.125
     BGCOLOR 8 .

DEFINE BUTTON BtnPrint 
     LABEL "&Print" 
     SIZE 15 BY 1.125
     BGCOLOR 8 .

DEFINE VARIABLE EDITOR-1 AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL LARGE
     SIZE 56.6 BY 9.57 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 58.4 BY 10.

DEFINE VARIABLE SHIFT-WIDTH AS INTEGER.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     BtnOK AT ROW 1.57 COL 62
     EDITOR-1 AT ROW 1.67 COL 3.6 NO-LABEL
     BtnPrint AT ROW 2.71 COL 62
     RECT-1 AT ROW 1.52 COL 2.6
     SPACE(16.72) SKIP(0.43)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "View"
         DEFAULT-BUTTON BtnOK.

 

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

/* SETTINGS FOR EDITOR EDITOR-1 IN FRAME Dialog-Frame
   NO-DISPLAY                                                           */
ASSIGN 
       EDITOR-1:READ-ONLY IN FRAME Dialog-Frame        = TRUE.

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
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* View */
DO:
 APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnPrint
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnPrint Dialog-Frame
ON CHOOSE OF BtnPrint IN FRAME Dialog-Frame /* Print */
DO:
    DEFINE VARIABLE Printed AS LOGICAL NO-UNDO.
    
    RUN adecomm/_osprint.p ( INPUT {&WINDOW-NAME},
                             INPUT pFile,
                             INPUT EDITOR-1:FONT,
                             INPUT IF SESSION:CPSTREAM = "utf-8":U THEN 512 ELSE 0,
                             INPUT 0,
                             INPUT 0,
                             OUTPUT Printed ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Make the dialog and editor larger if the PPU is small */ 
IF SESSION:PIXELS-PER-COLUMN = 5 THEN 
   ASSIGN
      SHIFT-WIDTH = (EDITOR-1:WIDTH * 1.75) - EDITOR-1:WIDTH
      EDITOR-1:WIDTH = EDITOR-1:WIDTH * 1.75 
      RECT-1:WIDTH = RECT-1:WIDTH * 1.75 
      FRAME {&FRAME-NAME}:WIDTH = FRAME {&FRAME-NAME}:WIDTH * 1.75 
      BTNOK:X = BTNOK:X * 1.75
      BTNPRINT:X = BTNPRINT:X * 1.75
   .


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON STOP    UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  ASSIGN Read_OK = EDITOR-1:READ-FILE(pFile) IN FRAME {&FRAME-NAME} NO-ERROR.
  IF Read_OK = TRUE THEN ASSIGN Read_OK = ERROR-STATUS:ERROR.
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
  ENABLE RECT-1 BtnOK EDITOR-1 BtnPrint 
      WITH FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


