&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI
/* Procedure Description
"SDO Wizard"
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
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
*********************************************************************/
/*------------------------------------------------------------------------

  File: src/adm2/support/_wizlog.w

  Description: SDO business logic procedure page 

  Input Parameters:
      hWizard (handle) - handle of Wizard dialog

  Output Parameters:
      <none>

  Author: Don Bulua

  Created: 12/06/2001
  

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
/* Parameters Definitions ---                                           */
DEFINE INPUT        PARAMETER hWizard   AS WIDGET-HANDLE NO-UNDO.

/* Shared Variable Definitions ---                                      */
DEFINE SHARED VARIABLE fld-list         AS CHARACTER     NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE Variable gWizardHdl   AS HANDLE  NO-UNDO.
DEFINE VARIABLE gcObjectName AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLogicProc  AS CHARACTER  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS ToLog e_msg RECT-3 
&Scoped-Define DISPLAYED-OBJECTS ToLog e_msg fLogicProc 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectName C-Win 
FUNCTION getObjectName RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setobjectName C-Win 
FUNCTION setobjectName RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON b_brws 
     LABEL "B&rowse..." 
     SIZE 13 BY 1.14.

DEFINE VARIABLE e_msg AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 26 BY 6.71
     BGCOLOR 8  NO-UNDO.

DEFINE VARIABLE fLogicProc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 52 BY 6.71.

DEFINE VARIABLE ToLog AS LOGICAL INITIAL no 
     LABEL "Use SDO logic procedure" 
     VIEW-AS TOGGLE-BOX
     SIZE 29 BY .71 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     ToLog AT ROW 1.29 COL 4.8
     e_msg AT ROW 1.62 COL 57 NO-LABEL
     b_brws AT ROW 4 COL 40.2
     fLogicProc AT ROW 4.1 COL 4.8 NO-LABEL
     RECT-3 AT ROW 1.62 COL 3
     "Logic Procedure File Name:" VIEW-AS TEXT
          SIZE 28 BY .62 AT ROW 3.38 COL 4.8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 1
         SIZE 83.57 BY 10.31
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: WINDOW
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* SUPPRESS Window definition (used by the UIB) 
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert title>"
         HEIGHT             = 10.52
         WIDTH              = 83.6
         MAX-HEIGHT         = 16.48
         MAX-WIDTH          = 107.2
         VIRTUAL-HEIGHT     = 16.48
         VIRTUAL-WIDTH      = 107.2
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
                                                                        */
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME
ASSIGN C-Win = CURRENT-WINDOW.




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   UNDERLINE                                                            */
/* SETTINGS FOR BUTTON b_brws IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
ASSIGN 
       e_msg:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

/* SETTINGS FOR FILL-IN fLogicProc IN FRAME DEFAULT-FRAME
   NO-ENABLE ALIGN-L                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME DEFAULT-FRAME
/* Query rebuild information for FRAME DEFAULT-FRAME
     _Options          = ""
     _Query            is NOT OPENED
*/  /* FRAME DEFAULT-FRAME */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* <insert title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* <insert title> */
DO:
  /* These events will close the window and terminate the procedure.      */
  /* (NOTE: this will override any user-defined triggers previously       */
  /*  defined on the window.)                                             */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_brws
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_brws C-Win
ON CHOOSE OF b_brws IN FRAME DEFAULT-FRAME /* Browse... */
DO:
  RUN getFileName.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fLogicProc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fLogicProc C-Win
ON VALUE-CHANGED OF fLogicProc IN FRAME DEFAULT-FRAME
DO: 
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fld-list = "":U.
    APPLY "U2":U TO hWizard. /* not ok to finish */
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ToLog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ToLog C-Win
ON VALUE-CHANGED OF ToLog IN FRAME DEFAULT-FRAME /* Use SDO logic procedure */
DO:
  IF SELF:CHECKED THEN
  DO:
    ASSIGN fLogicProc:SENSITIVE = TRUE
           b_brws:SENSITIVE     = TRUE.
    IF gcLogicProc = ".p":U or gcLogicProc = "" THEN
       fLogicProc:SCREEN-VALUE = ENTRY(1,gcObjectName,".") + "log.p".
    ELSE
       fLogicProc:SCREEN-VALUE = gcLogicproc.
  END.
  ELSE DO:
     ASSIGN fLogicProc:SCREEN-VALUE = ""
            fLogicProc:SENSITIVE    = FALSE
            b_brws:SENSITIVE        = FALSE.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */
ASSIGN FRAME {&FRAME-NAME}:FRAME    = hwizard
       FRAME {&FRAME-NAME}:HIDDEN   = NO
       FRAME {&FRAME-NAME}:HEIGHT-P = FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-P
       FRAME {&FRAME-NAME}:WIDTH-P  = FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-P
       gWizardHdl                   = SOURCE-PROCEDURE.      

/* Get the Objectname and Logic procedure from the definitions section */
getObjectName().
IF gcLogicProc = ".p" OR gcLogicProc = "" THEN
   ToLog = FALSE.
ELSE 
   ASSIGN ToLog      = TRUE
          fLogicProc = gcLogicProc.
ASSIGN e_msg = 
      "Specify this SDO's 'Logic Procedure' that will contain the business logic. "+ CHR(10) + CHR(10)
      + "If the specified procedure does not exist, the logic procedure will be created in the same directoy as the  SDO.".

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE DO:
   RUN disable_UI.
END.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  APPLY "Value-changed":U TO toLog.
 
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
  /* Hide all frames. */
  HIDE FRAME DEFAULT-FRAME.
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
  DISPLAY ToLog e_msg fLogicProc 
      WITH FRAME DEFAULT-FRAME.
  ENABLE ToLog e_msg RECT-3 
      WITH FRAME DEFAULT-FRAME.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFileName C-Win 
PROCEDURE getFileName :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cFileName AS CHAR.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN 
      cFileName = TRIM( fLogicProc:SCREEN-VALUE).
  
    RUN adecomm/_opnfile.w 
                ("Choose a logic procedure",
                 "Logic Files (*.p), All Files (*.*)",
                 INPUT-OUTPUT cFileName).
  
    IF cFileName <> "":U THEN
      ASSIGN
        fLogicProc:SCREEN-VALUE = cFileName.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validate-window C-Win 
PROCEDURE validate-window :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VARIABLE ok          AS LOG    NO-UNDO.
   DEFINE VARIABLE cRelName    AS CHAR   NO-UNDO.  

   DEFINE VARIABLE LastButton AS CHARACTER NO-UNDO.

   LastButton = DYNAMIC-FUNCTION ("GetLastButton" IN gWizardHdl).

   IF LastButton = "CANCEL" THEN RETURN.

   RUN adecomm/_setcurs.p("WAIT":U).

   ASSIGN FRAME {&FRAME-NAME} fLogicProc.   
   
   IF (LastButton = "NEXT":U OR LastButton = "" ) AND ToLog:CHECKED THEN 
   DO: 
     IF fLogicProc = "":U THEN
     DO:  
       MESSAGE 'You need to supply the name of a logic procedure.':U 
          VIEW-AS ALERT-BOX.

       RETURN ERROR.    
     END.
     ELSE DO:
       /* Set the Logical procedure into the definitions section */
       SetObjectName().
     END.
  END. /* if lastbutton = next */

  RUN adecomm/_setcurs.p("":U). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectName C-Win 
FUNCTION getObjectName RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDefCode    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContextID  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iRecID      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iStart      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iEnd        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cLine       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectName AS CHARACTER  NO-UNDO.

  RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "PROCEDURE":U, OUTPUT cContextID).
  
  /* Get the current contents of the definition section */
  RUN adeuib/_accsect.p( "GET":U,
                         INT(cContextID),
                         "DEFINITIONS":U,
                         INPUT-OUTPUT iRecID,
                         INPUT-OUTPUT cDefCode ).
  
  ASSIGN iStart      = INDEX(cDefCode,"&GLOB DATA-LOGIC-PROCEDURE":U)
         iStart      = IF iStart = 0 
                       THEN INDEX(cDefCode,"&GLOBAL-DEFINE DATA-LOGIC-PROCEDURE":U)
                       ELSE iStart
         iEnd        = IF iStart > 0 
                       THEN INDEX(cDefCode,".p":U, iStart)
                       ELSE 0
         iEnd        = IF iEnd = 0  
                       THEN INDEX(cDefCode,CHR(10), iStart)
                       ELSE iEnd
         cLine       = IF iStart > 0 AND iEnd > 0 
                       THEN  TRIM(SUBSTRING(cDefCode, iStart, iEnd - iStart + 2))
                       ELSE ""
         gcLogicProc = IF cLine > ""
                       THEN  TRIM(SUBSTRING(cLine,R-INDEX(cline," ":U)))
                       ELSE "".

/* Find the ObjectName entered in the previous page */
ASSIGN iStart       = INDEX(cDefCode,"File:":U)
       iEnd         = IF iStart > 0 
                      THEN INDEX(cDefCode,CHR(10), iStart)
                      ELSE 0
       cLine        = IF iStart > 0 AND iEnd > 0 
                      THEN  SUBSTRING(cDefCode, iStart, iEnd - iStart + 2)
                      ELSE ""
       gcObjectName = IF iStart > 0 AND iEnd > 0
                      THEN  trim(SUBSTRING(cLine, 6))
                      ELSE "".

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setobjectName C-Win 
FUNCTION setobjectName RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the Data-Logic-Procedure equal to the specified fill-in value
            and writes it to the definitions section. 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDefCode    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContextID  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iRecID      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iStart      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iEnd        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cLine       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE c_Win       AS CHARACTER  NO-UNDO.

  RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "PROCEDURE":U, OUTPUT cContextID).
  
  /* Get the current contents of the definition section */
  RUN adeuib/_accsect.p( "GET":U,
                         INT(cContextID),
                         "DEFINITIONS":U,
                         INPUT-OUTPUT iRecID,
                         INPUT-OUTPUT cDefCode ).
  
  ASSIGN iStart      = INDEX(cDefCode,"&GLOB DATA-LOGIC-PROCEDURE":U)
         iStart      = IF iStart = 0 
                       THEN INDEX(cDefCode,"&GLOBAL-DEFINE DATA-LOGIC-PROCEDURE":U)
                       ELSE iStart
         iEnd        = IF iStart > 0 
                       THEN INDEX(cDefCode,".p":U, iStart)
                       ELSE 0
         iEnd        = IF iEnd = 0  
                       THEN INDEX(cDefCode,CHR(10), iStart)
                       ELSE iEnd
         cLine       = IF iStart > 0 AND iEnd > 0 
                       THEN  TRIM(SUBSTRING(cDefCode, iStart, iEnd - iStart + 2))
                       ELSE ""
         gcLogicProc = IF cLine > ""
                       THEN  TRIM(SUBSTRING(cLine,R-INDEX(cline," ":U)))
                       ELSE "".
IF iStart > 0 AND iEnd > 0  THEN
DO:
  ASSIGN cDefCode = SUBSTRING(cDefCode,1, iStart - 1) +  
                     "&GLOB DATA-LOGIC-PROCEDURE ":U  + 
                       fLogicProc:SCREEN-VALUE IN FRAME {&FRAME-NAME} +
                       IF iEnd + 2 < LENGTH(cDefCode) 
                       THEN SUBSTRING(cDefcode, iEnd + 2)
                       ELSE "".
 
  RUN adeuib/_accsect.p (INPUT "SET":U,
                         INPUT ?,
                         INPUT 'DEFINITIONS':U,
                         INPUT-OUTPUT irecid,
                         INPUT-OUTPUT cDefCode).
                            
 /* Get handle of the window */
  RUN adeuib/_uibinfo.p (?, "WINDOW ?":U, "HANDLE":U, OUTPUT c_win).
  
  /* flag window as 'dirty' (needs to be saved) */
  RUN adeuib/_winsave.p (WIDGET-HANDLE(c_win), FALSE).          
END.

RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

