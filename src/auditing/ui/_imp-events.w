&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------

  File: _imp-events.w

  Description: Enables user to import .d file

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Fernando de Souza

  Created: Feb 23,2005
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE OUTPUT PARAMETER pcFileName       AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER perrorPercentage AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS importFileName btnBrowse errorPercentage ~
Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS importFileName errorPercentage 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnBrowse 
     LABEL "&Browse" 
     SIZE 15 BY 1.14.

DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE errorPercentage AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Acceptable error percentage" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE importFileName AS CHARACTER FORMAT "X(256)":U INITIAL "_aud-event.ad" 
     LABEL "Import File" 
     VIEW-AS FILL-IN 
     SIZE 50 BY 1.19 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     importFileName AT ROW 1.48 COL 11 COLON-ALIGNED WIDGET-ID 2
     btnBrowse AT ROW 1.48 COL 64 WIDGET-ID 4
     errorPercentage AT ROW 7.19 COL 34 COLON-ALIGNED WIDGET-ID 6
     Btn_OK AT ROW 8.62 COL 23 WIDGET-ID 8
     Btn_Cancel AT ROW 8.62 COL 45 WIDGET-ID 10
     "Specify an acceptable error percentage. When this limit is reached," VIEW-AS TEXT
          SIZE 66 BY .62 AT ROW 3.62 COL 8 WIDGET-ID 12
     "importing will stop. Enter 0 if any error should stop the import~; enter" VIEW-AS TEXT
          SIZE 67 BY .62 AT ROW 4.81 COL 8 WIDGET-ID 14
     "100 if the import should not stop for any error." VIEW-AS TEXT
          SIZE 65 BY .62 AT ROW 6 COL 8 WIDGET-ID 16
     SPACE(9.39) SKIP(3.94)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Import Audit Events..."
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   FRAME-NAME                                                           */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON GO OF FRAME Dialog-Frame /* Import Audit Events... */
DO:

DEFINE VARIABLE cName AS CHAR NO-UNDO.

    /* trim file name value */
    ASSIGN cName = TRIM(importFileName:SCREEN-VALUE).
    
    /* check if file exists and report error if it doesn't */
    FILE-INFO:FILE-NAME = cName.
    IF FILE-INFO:FILE-CREATE-DATE = ? THEN DO:
      MESSAGE "Could not find file " cName 
              VIEW-AS ALERT-BOX ERROR. 
          RETURN NO-APPLY.
    END.
    
    ASSIGN pcFileName = cName
           perrorPercentage = INTEGER(errorPercentage:SCREEN-VALUE).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Import Audit Events... */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnBrowse Dialog-Frame
ON CHOOSE OF btnBrowse IN FRAME Dialog-Frame /* Browse */
DO:
    DEFINE VARIABLE pickedOne   AS LOGICAL                            NO-UNDO.
    DEFINE VARIABLE c-file  AS CHARACTER                          NO-UNDO.

         /* bring up system dialog */
         SYSTEM-DIALOG GET-FILE 
            c-file 
            FILTERS            "*.ad":U              "*.ad":U,
                               "All Files(*.*)":U    "*.*":U
            DEFAULT-EXTENSION  "":U
            TITLE              "Find file to import":U
            UPDATE             pickedOne.

         /* if user selected a file name, assign it to the fill-in */
        IF pickedOne THEN DO:
             importFileName:SCREEN-VALUE = c-file.
        END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel Dialog-Frame
ON CHOOSE OF Btn_Cancel IN FRAME Dialog-Frame /* Cancel */
DO:
    ASSIGN pcFileName = "":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Dialog-Frame
ON CHOOSE OF Btn_OK IN FRAME Dialog-Frame /* OK */
DO:
    /* check if file name is either blank or invalid */
    IF importFileName:SCREEN-VALUE = "":U THEN DO:
        MESSAGE "ERROR: You must specify a file name." VIEW-AS ALERT-BOX ERROR.
        APPLY "entry" TO importFileName.
        RETURN NO-APPLY.
    END.

    IF importFileName:SCREEN-VALUE = "?":U THEN DO:
        MESSAGE "ERROR: You must specify a valid file name." VIEW-AS ALERT-BOX ERROR.
        APPLY "entry" TO importFileName.
        RETURN NO-APPLY.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME importFileName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL importFileName Dialog-Frame
ON LEAVE OF importFileName IN FRAME Dialog-Frame /* Import File */
DO:
  SELF:SCREEN-VALUE = TRIM(SELF:SCREEN-VALUE).
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
  RUN enable_UI.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame  _DEFAULT-ENABLE
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
  DISPLAY importFileName errorPercentage 
      WITH FRAME Dialog-Frame.
  ENABLE importFileName btnBrowse errorPercentage Btn_OK Btn_Cancel 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

