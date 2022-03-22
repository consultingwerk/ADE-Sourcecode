&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
/* Procedure Description
"ADE Wizard signoff screen"
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: _wizend.w

  Description: Last screen of Wizard. 

  Input Parameters:
      hWizard (handle) - handle of Wizard dialog

  Output Parameters:
      <none>

  Author: Gerry Seidl

  Created: 4/5/95

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
DEFINE INPUT PARAMETER hWizard AS WIDGET-HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE gWizardHdl AS HANDLE NO-UNDO.
DEFINE VARIABLE procIdStr  AS CHAR NO-UNDO.
DEFINE VARIABLE objtype    AS CHARACTER NO-UNDO.
DEFINE VARIABLE h          AS HANDLE    NO-UNDO.
DEFINE VARIABLE l          AS LOGICAL   NO-UNDO.



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-4 
&Scoped-Define DISPLAYED-OBJECTS msg msg1 msg2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnPreview 
     LABEL "&Preview" 
     SIZE 11 BY 1.1.

DEFINE VARIABLE fiFileName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Filename" 
     VIEW-AS FILL-IN 
     SIZE 17 BY 1.1 NO-UNDO.

DEFINE VARIABLE msg AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 39 BY 1.05 NO-UNDO.

DEFINE VARIABLE msg-3 AS CHARACTER FORMAT "X(256)":U INITIAL "You may also preview the object." 
      VIEW-AS TEXT 
     SIZE 39 BY 1.05 NO-UNDO.

DEFINE VARIABLE msg1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 39 BY 1.05 NO-UNDO.

DEFINE VARIABLE msg2 AS CHARACTER FORMAT "X(256)":U INITIAL "You may now save and close this object." 
      VIEW-AS TEXT 
     SIZE 39 BY 1.05 NO-UNDO.

DEFINE IMAGE IMAGE-4
     FILENAME "adeicon/wizdone":U CONVERT-3D-COLORS
     SIZE 41 BY 7.67.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 41 BY 7.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     fiFileName AT ROW 7.71 COL 52 COLON-ALIGNED
     btnPreview AT ROW 7.71 COL 72
     msg AT ROW 2.38 COL 44 NO-LABEL
     msg1 AT ROW 3.81 COL 44 NO-LABEL
     msg2 AT ROW 5.24 COL 44 NO-LABEL
     msg-3 AT ROW 6.67 COL 44 NO-LABEL
     IMAGE-4 AT ROW 1.91 COL 2
     RECT-4 AT ROW 1.91 COL 43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 1
         SIZE 83.57 BY 10.12
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: WINDOW
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
         WIDTH              = 96.2
         MAX-HEIGHT         = 20.67
         MAX-WIDTH          = 96.2
         VIRTUAL-HEIGHT     = 20.67
         VIRTUAL-WIDTH      = 96.2
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
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
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   UNDERLINE                                                            */
/* SETTINGS FOR BUTTON btnPreview IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
ASSIGN 
       btnPreview:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

/* SETTINGS FOR FILL-IN fiFileName IN FRAME DEFAULT-FRAME
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       fiFileName:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

/* SETTINGS FOR IMAGE IMAGE-4 IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
ASSIGN 
       IMAGE-4:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

/* SETTINGS FOR FILL-IN msg IN FRAME DEFAULT-FRAME
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN msg-3 IN FRAME DEFAULT-FRAME
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       msg-3:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

/* SETTINGS FOR FILL-IN msg1 IN FRAME DEFAULT-FRAME
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN msg2 IN FRAME DEFAULT-FRAME
   NO-ENABLE ALIGN-L                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME DEFAULT-FRAME
/* Query rebuild information for FRAME DEFAULT-FRAME
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


&Scoped-define SELF-NAME btnPreview
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnPreview C-Win
ON CHOOSE OF btnPreview IN FRAME DEFAULT-FRAME /* Preview */
DO:
  PUBLISH "ab_wizardPreview":U (fiFileName:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

gWizardHdl = SOURCE-PROCEDURE.
/*
ASSIGN
  h          = hwizard:FIRST-CHILD /* field-group */
  gWizardHdl = SOURCE-PROCEDURE.

h = h:FIRST-CHILD. /* first widget */

DO WHILE h <> ?:
    
 IF h:NAME = "b_Finish":U THEN LEAVE. /* find finish button */
  h = h:NEXT-SIBLING.
END.
*/    
/* Get procedure type (Web-Object, SmartBrowser) */
RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "TYPE":U, OUTPUT ObjType).
       
IF not DYNAMIC-FUNCTION('getOkToFinish':U in gWizardHdl) THEN
do:
  ASSIGN msg = "You have not completed this"
         msg1 = objtype + "!"
         msg2 = "Go Back or press Cancel."

         IMAGE-4:HIDDEN = no
         btnPreview:HIDDEN = TRUE
         fifileName:HIDDEN = TRUE
         msg-3:HIDDEN      = TRUE.
   IMAGE-4:LOAD-IMAGE("adeicon/wizndone":U).       
end.               
ELSE DO:
  ASSIGN
    fiFileName  = DYNAMIC-FUNCTION('getPreviewName' in gWizardHdl).
 
  IF fiFilename = "" THEN     
    RUN bestFileName (objtype, OUTPUT fiFileName).
        
  ASSIGN msg = "Congratulations!"
         msg1 = "You completed this " + objtype + "!"
         IMAGE-4:HIDDEN    = no
         btnPreview:HIDDEN = DYNAMIC-FUNCTION('getPreview' in gWizardHdl) = FALSE        
         btnPreview:SENSITIVE = true 
         fiFilename:HIDDEN       = btnPreview:HIDDEN
         msg-3:HIDDEN            = btnPreview:HIDDEN 
         fiFileName:SENSITIVE    = TRUE
         fiFilename:SCREEN-VALUE = fifileName.
END.
ASSIGN FRAME {&FRAME-NAME}:FRAME    = hwizard
       FRAME {&FRAME-NAME}:HIDDEN   = NO
       FRAME {&FRAME-NAME}:HEIGHT-P = FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-P
       FRAME {&FRAME-NAME}:WIDTH-P  = FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-P
       .     
       
DISPLAY UNLESS-HIDDEN Msg-3 WITH FRAME {&FRAME-NAME}.
       
/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
DO:
  /* If Preview then store the PreViewname in case we are going back */
  IF btnPreView:HIDDEN IN FRAME {&FRAME-NAME} = FALSE THEN
  DO: 
    ASSIGN 
      fiFileName.  
    DYNAMIC-FUNCTION('setPreviewName' in gWizardHdl,fiFileName).
  END. 
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
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BestFileName C-Win 
PROCEDURE BestFileName :
/*------------------------------------------------------------------------------
  Purpose: Get a unique filename for a new object to use in preview.  
  Input Parameters:
     pObjType - Procedure type 
  Output Parameters:
     pbestName - Non existing filename  
  
  Notes: Currently used for WebDetail and WebReport  
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pObjType  AS CHAR NO-UNDO.
  DEFINE OUTPUT PARAMETER pBestName AS CHAR NO-UNDO.
     
  DEF VAR lRemote    AS LOG  NO-UNDO.  
  DEF VAR cBrokerURL AS CHAR NO-UNDO.  
  DEF VAR cInfo      AS CHAR NO-UNDO.  
  DEF VAR cFileName  AS CHAR NO-UNDO.  
  DEF VAR cGuessFile AS CHAR NO-UNDO.  
  
  ASSIGN
    cGuessFile = LC(
                    IF pObjType BEGINS "WEB":U 
                    THEN SUBSTR(pObjType,4) + "&1":U + ".html":U
                    ELSE pObjType           + "&1":U + ".w":U
                    ).   
     
  RUN adeuib/_uibinfo.p(?,'SESSION':U,'REMOTE', OUTPUT cinfo).
  
  lRemote = cInfo = "TRUE":U.
  
  IF lRemote THEN   
  DO:
    RUN adeuib/_uibinfo.p(?,'SESSION':U,'BrokerURL':U,OUTPUT cBrokerURL).
  
    /* 'Bestname' runs adecomm/_bstfnam.p on the backend */
    RUN adeweb/_webcom.w (?, 
                          cBrokerURL, 
                          cGuessFile, 
                          'BestName':U, 
                          OUTPUT pBestName, 
                          INPUT-OUTPUT cFilename).
  END. /* if lremote */
  ELSE
    RUN adecomm/_bstfnam.p (cGuessFile,OUTPUT pBestName).                       
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  DISPLAY msg msg1 msg2 
      WITH FRAME DEFAULT-FRAME.
  ENABLE RECT-4 
      WITH FRAME DEFAULT-FRAME.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

