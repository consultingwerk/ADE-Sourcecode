&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
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

  File      : adm2/askquestion.w
  Purpose   : Question Message dialog with one prompt value
  Parameters: pcMessage  - The message (question) 
              pcButtons  - Comma delimited string of button labels
                          - 3 entries  Yes,No,Cancel 
                          - 2 entries  Yes,No
                          - 1 entry    Yes 
             pcFieldInfo - Comma separated list of field info
                          - 1st entry = label             
                          - 2nd entry = datatype (optional; default 'char')
                            Supports char, int and dec. 
                          - 3rd entry = alignment, L,R,C (optional; default L)
                          - 4th entry = format commas allowed (optional)
             pcTitle     - Message Title
        I-O  pcValue     - Character Value of field  
        OUT  plOk        - Chosen action (Yes no cancel) button
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF DEFINED(UIB_is_Running) NE 0  &THEN
   &SCOPED-DEFINE invar  VARIABLE 
   &SCOPED-DEFINE iovar  VARIABLE 
   &SCOPED-DEFINE outvar VARIABLE    
&ELSE
   &SCOPED-DEFINE invar   INPUT PARAMETER      
   &SCOPED-DEFINE iovar   INPUT-OUTPUT PARAMETER      
   &SCOPED-DEFINE outvar  OUTPUT PARAMETER
&ENDIF
                   
DEFINE {&invar}  pcMessage     AS CHARACTER  NO-UNDO.
DEFINE {&invar}  pcButtons     AS CHARACTER  NO-UNDO.
DEFINE {&invar}  pcFieldInfo   AS CHARACTER  NO-UNDO.
DEFINE {&invar}  pcTitle       AS CHARACTER  NO-UNDO.

DEFINE {&iovar}  pcValue       AS CHARACTER  NO-UNDO.
DEFINE {&outvar} plOk          AS LOGICAL    NO-UNDO INIT ?.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS EdMessage BtnYes 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnCancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON BtnNo AUTO-GO 
     LABEL "&No" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON BtnYes AUTO-GO 
     LABEL "&Yes" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE EdMessage AS CHARACTER 
     CONTEXT-HELP-ID 0
     VIEW-AS EDITOR NO-BOX
     SIZE 75 BY 3.52 NO-UNDO.

DEFINE VARIABLE cAnswer AS CHARACTER FORMAT "X(30)":U 
     LABEL "Response" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE dAnswer AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Response" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE iAnswer AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "Response" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE IMAGE imgQuestion
     FILENAME "adm2/image/msgquestion.bmp":U CONVERT-3D-COLORS
     SIZE 6.4 BY 1.52.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     EdMessage AT ROW 1.52 COL 14 NO-LABEL NO-TAB-STOP 
     dAnswer AT ROW 5.05 COL 11.8 COLON-ALIGNED
     iAnswer AT ROW 5.05 COL 30 COLON-ALIGNED
     cAnswer AT ROW 5.05 COL 55.8 COLON-ALIGNED
     BtnYes AT ROW 6.52 COL 42
     BtnNo AT ROW 6.52 COL 58.4
     BtnCancel AT ROW 6.52 COL 74.8
     imgQuestion AT ROW 1.52 COL 3
     SPACE(82.19) SKIP(4.62)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Question"
         DEFAULT-BUTTON BtnYes CANCEL-BUTTON BtnCancel.


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

/* SETTINGS FOR BUTTON BtnCancel IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON BtnNo IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cAnswer IN FRAME Dialog-Frame
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       cAnswer:AUTO-RESIZE IN FRAME Dialog-Frame      = TRUE.

/* SETTINGS FOR FILL-IN dAnswer IN FRAME Dialog-Frame
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       dAnswer:AUTO-RESIZE IN FRAME Dialog-Frame      = TRUE.

/* SETTINGS FOR EDITOR EdMessage IN FRAME Dialog-Frame
   NO-DISPLAY                                                           */
ASSIGN 
       EdMessage:AUTO-RESIZE IN FRAME Dialog-Frame      = TRUE
       EdMessage:READ-ONLY IN FRAME Dialog-Frame        = TRUE.

/* SETTINGS FOR FILL-IN iAnswer IN FRAME Dialog-Frame
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       iAnswer:AUTO-RESIZE IN FRAME Dialog-Frame      = TRUE.

/* SETTINGS FOR IMAGE imgQuestion IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
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
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Question */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnNo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnNo Dialog-Frame
ON CHOOSE OF BtnNo IN FRAME Dialog-Frame /* No */
DO:
  plOk = FALSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnYes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnYes Dialog-Frame
ON CHOOSE OF BtnYes IN FRAME Dialog-Frame /* Yes */
DO:
  plOk = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */
/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ? THEN 
  FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.
 

DO ON ERROR   UNDO, LEAVE
   ON END-KEY UNDO, LEAVE:
  RUN initializeObject.
  RUN enable_UI.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
  
  pcValue = IF NOT iAnswer:HIDDEN THEN iAnswer:SCREEN-VALUE
            ELSE 
            IF NOT dAnswer:HIDDEN THEN dAnswer:SCREEN-VALUE
            ELSE cAnswer:SCREEN-VALUE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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
  ENABLE EdMessage BtnYes 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Dialog-Frame 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VARIABLE lYesNoCancel  AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE lOkCancel     AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE lOk           AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE iNumButtons   AS INTEGER    NO-UNDO.
   DEFINE VARIABLE dMargin       AS DECIMAL    NO-UNDO.
   DEFINE VARIABLE iVertMargin   AS INTEGER    NO-UNDO.
   DEFINE VARIABLE cDataType     AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cFormat       AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cAlign        AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cLabel        AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE hValue        AS HANDLE     NO-UNDO.
   DEFINE VARIABLE hLabel        AS HANDLE     NO-UNDO.
   DEFINE VARIABLE iLoop         AS INTEGER    NO-UNDO.
   DEFINE VARIABLE cYesLabel     AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cNoLabel      AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cCancelLabel  AS CHARACTER  NO-UNDO.

   DO WITH FRAME {&FRAME-NAME}:
     iNumButtons  = NUM-ENTRIES(pcButtons).   
     IF pcButtons = '':U THEN pcButtons = 'OK':U.

     IF pcFieldInfo <> '':U THEN
     DO:
       ASSIGN 
         cLabel     = ENTRY(1,pcFieldInfo)
         cDataType  = IF NUM-ENTRIES(pcFieldInfo) = 1 
                      THEN 'CHARACTER':U 
                      ELSE ENTRY(2,pcFieldInfo)
         cAlign     = IF NUM-ENTRIES(pcFieldInfo) < 3 
                      THEN 'LEFT':U 
                      ELSE ENTRY(3,pcFieldInfo).
       /* Last entry is format, which may have commas in it.. */ 
       IF NUM-ENTRIES(pcFieldInfo) > 3 THEN
       DO:
         cFormat = pcFieldInfo.
         DO iLoop = 1 TO 3:
           cFormat = SUBSTR(cFormat,INDEX(cFormat,',':U) + 1). 
         END.
       END.
     END.
     ASSIGN            
      FRAME {&FRAME-NAME}:TITLE  = IF pcTitle > '':U 
                                   THEN pcTitle 
                                   ELSE FRAME {&FRAME-NAME}:TITLE 
      edMessage:SCREEN-VALUE     = RIGHT-TRIM(pcMessage,CHR(10))
      edMessage:INNER-LINES      = edMessage:NUM-LINES
      dMargin        = imgQuestion:COL
      /* Use the editor Y as margin template */
      iVertMargin    = edMessage:Y 
      iAnswer:HIDDEN = TRUE
      cAnswer:HIDDEN = TRUE
      dAnswer:HIDDEN = TRUE
      hValue         = IF cDataType BEGINS 'DEC':U THEN dAnswer:HANDLE
                       ELSE IF cDataType BEGINS 'INT':U THEN iAnswer:HANDLE
                       ELSE cAnswer:HANDLE
      hValue:LABEL   = (IF cLabel > "":U  THEN cLabel  ELSE hValue:LABEL)
      hValue:FORMAT  = (IF cFormat > "":U THEN cFormat ELSE hValue:FORMAT)
      hValue:SENSITIVE = TRUE                                              
      hValue:SCREEN-VALUE = pcValue                                         
      hLabel         = hValue:SIDE-LABEL-HANDLE                              
      hValue:Y       = edMessage:Y + edMessage:HEIGHT-P
      hLabel:Y       = hValue:Y
      btnYes:Y       = hValue:Y + hValue:HEIGHT-P + iVertMargin
      btnNo:Y        = btnYes:Y 
      btnCancel:Y  = btnYes:Y 
      /* Add border top and bottom to ensure min heigth  */
      FRAME {&FRAME-NAME}:HEIGHT-P = btnYes:Y + btnYes:HEIGHT-P   
                                   + FRAME {&FRAME-NAME}:BORDER-TOP-P 
                                   + FRAME {&FRAME-NAME}:BORDER-BOTTOM-P
                                   /* the border bottom is bigger than the visual
                                      edge, so using vertmargin as-is is too much */
                                   + INT(iVertMargin / 2)
      NO-ERROR.
           
    
    
    /* Adjust field position Left, right or center (center is wide) */
    IF cAlign BEGINS 'L':U OR cAlign BEGINS 'C':U THEN
      ASSIGN
        hLabel:COL  = edMessage:COL
        hValue:COL  = hLabel:COL + hLabel:WIDTH.
    ELSE 
      ASSIGN
        hValue:COL  = edMessage:COL + edMessage:WIDTH - hValue:WIDTH
        hLabel:COL  = hValue:COL - hLabel:WIDTH . 

        
             /*
             
      hValue:SIDE-LABEL-HANDLE:COL = edEditor:COL 
      
      hValue:COL = hValue:SIDE-LABEL-HANDLE:WIDTH + hValue:SIDE-LABEL-HANDLE:COL
      
      hValue:WIDTH  = edEditor:WIDTH - hValue:SIDE-LABEL-HANDLE:WIDTH   
        */
      
     ASSIGN 
      hValue:WIDTH     = IF cAlign BEGINS 'C':U 
                         THEN edMessage:COL + edMessage:WIDTH - hValue:COL  
                         ELSE MIN(hValue:WIDTH,edMessage:COL + edMessage:WIDTH - hValue:COL)
      hValue:HIDDEN    = FALSE
      btnNo:HIDDEN     = iNumButtons < 2
      btnCancel:HIDDEN = iNumButtons < 3
      btnNo:SENSITIVE  = NOT btnNo:HIDDEN
      btnCancel:SENSITIVE = NOT btnCancel:HIDDEN
      cYesLabel        = ENTRY(1,pcButtons)
      cNoLabel         = ENTRY(2,pcButtons) WHEN iNumButtons >= 2
      cCancelLabel     = ENTRY(3,pcButtons) WHEN iNumButtons >= 3
      btnYes:LABEL     = IF cYesLabel > '':U THEN cYesLabel 
                         ELSE IF iNumButtons = 1 THEN 'OK' ELSE btnYes:LABEL
      btnNo:LABEL      = IF cNoLabel > '':U THEN cNoLabel ELSE btnNo:LABEL
      btnCancel:LABEL  = IF cCancelLabel > '':U THEN cCancelLabel ELSE btnCancel:LABEL
      btnYes:WIDTH     = MAX(btnYes:WIDTH,FONT-TABLE:GET-TEXT-WIDTH(btnYes:LABEL) + 1.5) 
      btnNo:WIDTH      = MAX(btnNo:WIDTH,FONT-TABLE:GET-TEXT-WIDTH(btnNo:LABEL) + 1.5) 
      btnCancel:WIDTH  = MAX(btnCancel:WIDTH,FONT-TABLE:GET-TEXT-WIDTH(btnCancel:LABEL) + 1.5) 
      btnCancel:COL    = FRAME {&FRAME-NAME}:WIDTH - (btnCancel:WIDTH + dMargin)
      btnNo:COL        = IF btnCancel:HIDDEN  
                         THEN FRAME {&FRAME-NAME}:WIDTH - (btnNo:WIDTH + dMargin) 
                         ELSE btnCancel:COL - (btnNo:WIDTH + (dMargin / 2))
      btnYes:COL       = MAX(1,
                         IF btnNo:HIDDEN  
                         THEN FRAME {&FRAME-NAME}:WIDTH - (btnYes:WIDTH + dMargin) 
                         ELSE btnNo:COL - (btnYes:WIDTH + (dMargin / 2))
                         ).
   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

