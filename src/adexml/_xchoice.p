&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
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
**********************************************************************

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBulder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT        PARAMETER pcSchema   AS CHARACTER  NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcConsumer AS CHARACTER  NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcProducer AS CHARACTER  NO-UNDO.
DEFINE OUTPUT       PARAMETER pcChoice   AS CHARACTER  NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE gcList AS CHARACTER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rsItems Btn_OK Btn_Cancel Btn_Help IMAGE-1 
&Scoped-Define DISPLAYED-OBJECTS fiLine1 rsItems 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE fiLine1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 52 BY 1 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "adeicon/question.bmp":U
     SIZE-PIXELS 32 BY 32.

DEFINE VARIABLE rsItems AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "&Open Consumer file order.xmc", 1,
"&Create Producer file order.xmp", 2,
"Open &Schema file order.xsd", 3
     SIZE 53 BY 3 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     fiLine1 AT ROW 1.24 COL 8 COLON-ALIGNED NO-LABEL
     rsItems AT ROW 3.86 COL 11 NO-LABEL
     Btn_OK AT ROW 7.67 COL 3
     Btn_Cancel AT ROW 7.67 COL 19
     Btn_Help AT ROW 7.67 COL 49
     IMAGE-1 AT Y 10 X 10
     "What do you want to do?" VIEW-AS TEXT
          SIZE 53 BY 1 AT ROW 2.19 COL 11
     SPACE(1.19) SKIP(5.99)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "XML File Open"
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
                                                                        */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN fiLine1 IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* XML File Open */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help Dialog-Frame
ON CHOOSE OF Btn_Help IN FRAME Dialog-Frame /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  MESSAGE "Help for File: {&FILE-NAME}" VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Dialog-Frame
ON CHOOSE OF Btn_OK IN FRAME Dialog-Frame /* OK */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    pcChoice = ENTRY(INTEGER(rsItems:SCREEN-VALUE), gcList).
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
  RUN enable_UI.
  
  RUN setup.
  
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
  DISPLAY fiLine1 rsItems 
      WITH FRAME Dialog-Frame.
  ENABLE rsItems Btn_OK Btn_Cancel Btn_Help IMAGE-1 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setup Dialog-Frame 
PROCEDURE setup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cBase    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButtons AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iState   AS INTEGER    NO-UNDO.
  
  IF pcConsumer NE ? AND pcProducer EQ ? THEN iState = 1. ELSE
  IF pcConsumer EQ ? AND pcProducer NE ? THEN iState = 2. ELSE 
  IF pcConsumer NE ? AND pcProducer NE ? THEN iState = 3.
  
  DO WITH FRAME {&FRAME-NAME}:
    CASE iState:
      WHEN 1 THEN DO:
        /* consumer file found only */
        ASSIGN
          fiLine1:SCREEN-VALUE  = 
            SUBSTITUTE("Consumer file &1 was found.",pcConsumer)
          cBase                 = 
            SUBSTRING(pcConsumer, 1, R-INDEX(pcConsumer, ".":U), "character":U)
          pcProducer            = cBase + "xmp":U
          rsItems:RADIO-BUTTONS = ""
          cButtons              = 
            SUBSTITUTE("Open &&Consumer file &1,1,Create &&Producer file &2,2,Open &&Schema file &3,3",
              pcConsumer,pcProducer,pcSchema)
          gcList                = "openc,createp,opens":U
          rsItems:RADIO-BUTTONS = cButtons NO-ERROR.
      END.
      WHEN 2 THEN DO:
        /* producer file found only */
        ASSIGN
          fiLine1:SCREEN-VALUE  = 
            SUBSTITUTE("Producer file &1 was found.",pcProducer)
          cBase                 = 
            SUBSTRING(pcProducer, 1, R-INDEX(pcProducer, ".":U), "character":U)
          pcConsumer            = cBase + "xmc":U
          rsItems:RADIO-BUTTONS = ""
          cButtons              = 
            SUBSTITUTE("Open &&Producer file &1,1,Create &&Consumer file &2,2,Open &&Schema file &3,3",
              pcProducer,pcConsumer,pcSchema)
          gcList                = "openp,createc,opens":U
          rsItems:RADIO-BUTTONS = cButtons NO-ERROR.
      END.
      WHEN 3 THEN DO:
        /* consumer and producer files found */
        ASSIGN
          fiLine1:SCREEN-VALUE  = "Consumer and Producer files were found."
          rsItems:RADIO-BUTTONS = ""
          cButtons              = 
            SUBSTITUTE("Open &&Consumer file &1,1,Open &&Producer file &2,2,Open &&Schema file &3,3",
              pcConsumer,pcProducer,pcSchema)
          gcList                = "openc,openp,opens":U
          rsItems:RADIO-BUTTONS = cButtons NO-ERROR.
      END.
    END CASE.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

