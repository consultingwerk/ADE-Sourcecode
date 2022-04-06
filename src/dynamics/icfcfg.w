&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------

  File:               icfcfg.w

  Description:        ICF Configuration Utility

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author:             Bruce Gruenbaum

  Created:            11/10/01
  
  Updates:
    08/07/2003    - Changes to support new XML file configurations.

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
{install/inc/indcuglob.i}
/* Install Windows API constants */
{install/inc/inwinapiconst.i}


DEFINE VARIABLE hConfMan     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hUIUtil      AS HANDLE     NO-UNDO.
DEFINE VARIABLE lICF         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cCFMProc     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSessType    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hStatusWin   AS HANDLE     NO-UNDO.

DEFINE VARIABLE lStartConfMan AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cICFParam    AS CHARACTER  NO-UNDO INITIAL "":U.
DEFINE VARIABLE lQuitOnEnd   AS LOGICAL    INITIAL YES NO-UNDO.
DEFINE VARIABLE cQuitOnEndB4 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cQuitOnEnd   AS CHARACTER  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS IMAGE-1 RECT-1 RECT-2 RECT-3 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMaxUIColors C-Win 
FUNCTION getMaxUIColors RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE IMAGE IMAGE-1
     SIZE 24.4 BY 12.38.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 80 BY 15.14.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 26.8 BY 15.14.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 107.4 BY 1.67.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     IMAGE-1 AT ROW 2.48 COL 3
     RECT-1 AT ROW 1.19 COL 29
     RECT-2 AT ROW 1.19 COL 1.6
     RECT-3 AT ROW 16.52 COL 1.6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 108.8 BY 17.38.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Compile into: 
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17.38
         WIDTH              = 108.8
         MAX-HEIGHT         = 17.38
         MAX-WIDTH          = 108.8
         VIRTUAL-HEIGHT     = 17.38
         VIRTUAL-WIDTH      = 108.8
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
   FRAME-NAME                                                           */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 17.38
       FRAME DEFAULT-FRAME:WIDTH            = 108.8.

ASSIGN 
       IMAGE-1:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win
DO:
  DEFINE VARIABLE iRetVal AS INTEGER    NO-UNDO.
  iRetVal = DYNAMIC-FUNCTION("messageBox":U IN ghUIManager,
                             "MSG_confirm_quit":U, 
                             "":U,
                             "MB_YESNO,MB_ICONQUESTION,MB_TASKMODAL":U) NO-ERROR.

  IF ERROR-STATUS:ERROR OR
     iRetVal = {&IDYES} THEN
  DO:
    ERROR-STATUS:ERROR = NO.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
  END.

  /* This event will close the window and terminate the procedure.  */
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN 
  CURRENT-WINDOW                = {&WINDOW-NAME} 
  THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}
  /* Now center the window in the middle of the display */
  {&WINDOW-NAME}:X              = MAX((SESSION:WORK-AREA-WIDTH-PIXELS - {&WINDOW-NAME}:WIDTH-PIXELS) / 2,1)
  {&WINDOW-NAME}:Y              = MAX((SESSION:WORK-AREA-HEIGHT-PIXELS - {&WINDOW-NAME}:HEIGHT-PIXELS) / 2,1)
  .

SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "DCU_StartStatus":U ANYWHERE.
SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "DCU_SetStatus":U ANYWHERE.
SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "DCU_EndStatus":U ANYWHERE.
SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "DCU_Quit":U ANYWHERE.
SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "DCU_Cancel":U ANYWHERE.
SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "DCU_SetImage":U ANYWHERE RUN-PROCEDURE "loadUIImages":U.

PUBLISH "DCU_StartStatus":U.

PUBLISH "DCU_SetStatus":U ("Initializing Environment...").

/* We don't need to do anything as it all happens automatically after the 
   close. */
ON CLOSE OF THIS-PROCEDURE 
DO:
END.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* This starts the configuration file manager and deals with getting
   all the managers running and set the session parameters. */
RUN initializeEnvironment. 


IF RETURN-VALUE = "":U THEN
DO:
  PUBLISH "DCU_SetStatus":U ("Initializing Installation Library...").
  /* This call results in the UI manager being loaded and all the data parsed
     from the XML file. */
  RUN initializeInstall IN ghUIManager
    (THIS-PROCEDURE, FRAME {&FRAME-NAME}:HANDLE) NO-ERROR.
  IF NOT ERROR-STATUS:ERROR THEN
  DO:
    /* Now enable the interface and wait for the exit condition.            */
    /* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
    MAIN-BLOCK:
    DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
       ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
      RUN enable_UI.
      PUBLISH "DCU_SetStatus":U ("Initializing User Interface...").
      RUN showStartPage IN ghUIManager.
      PUBLISH "DCU_EndStatus":U.
      WAIT-FOR CLOSE OF THIS-PROCEDURE.
      RUN shutdownEnvironment.
    END.
  END.
END.


/* More support for RoundTable */
RUN disableUI.

IF lQuitOnEnd = NO THEN
  RETURN.
ELSE
  QUIT.

PROCEDURE GetDC EXTERNAL "user32":
  DEFINE RETURN PARAMETER hDC AS LONG.
  DEFINE INPUT PARAMETER hWndHdl AS LONG.
END.

PROCEDURE GetDeviceCaps EXTERNAL "gdi32":
  DEFINE RETURN PARAMETER iValue AS LONG.
  DEFINE INPUT PARAMETER hDC AS LONG.
  DEFINE INPUT PARAMETER iIndex AS LONG.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DCU_Cancel C-Win 
PROCEDURE DCU_Cancel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DCU_EndStatus C-Win 
PROCEDURE DCU_EndStatus :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF VALID-HANDLE(hStatusWin) THEN
    APPLY "CLOSE":U TO hStatusWin.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DCU_Quit C-Win 
PROCEDURE DCU_Quit :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DCU_SetStatus C-Win 
PROCEDURE DCU_SetStatus :
/*------------------------------------------------------------------------------
  Purpose:     Sets the status in the status window.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcStatus AS CHARACTER  NO-UNDO.

  PUBLISH "setStatus":U (pcStatus).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DCU_StartStatus C-Win 
PROCEDURE DCU_StartStatus :
/*------------------------------------------------------------------------------
  Purpose:     Starts the status window and displays it.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN install/obj/instatuswin.w PERSISTENT SET hStatusWin.
  RUN initializeObject IN hStatusWin.
  SUBSCRIBE PROCEDURE hStatusWin TO "setStatus":U IN THIS-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableUI C-Win 
PROCEDURE disableUI :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win) THEN 
    DELETE WIDGET C-Win.
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
  ENABLE IMAGE-1 RECT-1 RECT-2 RECT-3 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeEnvironment C-Win 
PROCEDURE initializeEnvironment :
/*------------------------------------------------------------------------------
  Purpose:     This procedure does the work that ICF start does to get
               the environment set up.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hLoopHandle AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCount      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTitle      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lConfFileSet AS LOGICAL    NO-UNDO.

  SESSION:APPL-ALERT-BOXES = TRUE.

  hLoopHandle = SESSION:FIRST-PROCEDURE.
  DO WHILE VALID-HANDLE(hLoopHandle):
    IF R-INDEX(hLoopHandle:FILE-NAME,"afxmlcfgp.p":U) > 0
    OR R-INDEX(hLoopHandle:FILE-NAME,"afxmlcfgp.r":U) > 0 THEN 
    DO:
      hConfMan = hLoopHandle.
      hLoopHandle = ?.
    END.
    ELSE
      hLoopHandle = hLoopHandle:NEXT-SIBLING.
  END. /* VALID-HANDLE(hLoopHandle) */

  cCFMProc = SEARCH("af/app/afxmlcfgp.r":U).
  IF cCFMProc = ? THEN
    cCFMProc = SEARCH("af/app/afxmlcfgp.p":U).

  IF NOT VALID-HANDLE(hConfMan) 
  AND cCFMProc <> ? THEN
  DO:
    RUN VALUE(cCFMProc) PERSISTENT SET hConfMan.
    ASSIGN
      lStartConfMan = YES.
  END.
  ELSE
    ASSIGN
      lStartConfMan = NO.

  IF VALID-HANDLE(hConfMan) THEN
  DO:
    /* Subscribe to all the relevant events in the configuration file manager */
    RUN subscribeAll IN THIS-PROCEDURE (hConfMan, THIS-PROCEDURE).

    lConfFileSet = NO.

    REPEAT iCount = 1 TO NUM-ENTRIES(SESSION:ICFPARAM):
      cSessType = ENTRY(iCount, SESSION:ICFPARAM).
      IF NUM-ENTRIES(cSessType,"=":U) > 1 AND
        ENTRY(1,cSessType,"=":U) = "DCUSETUPTYPE":U THEN
      DO:
        cSessType = ENTRY(2,cSessType,"=":U).
        cICFParam = cICFParam + (IF cICFParam <> "":U THEN ",":U ELSE "":U)
                  + "ICFSESSTYPE=":U + cSessType .
        NEXT.
      END.
      IF NUM-ENTRIES(cSessType,"=":U) > 1 AND
        (ENTRY(1,cSessType,"=":U) = "ICFCONFIG":U OR
         ENTRY(1,cSessType,"=":U) = "ICFSETUP":U OR
         ENTRY(1,cSessType,"=":U) = "DCUSETUP":U) THEN
      DO:
        cSessType = ENTRY(2,cSessType,"=":U).
        cICFParam = cICFParam + (IF cICFParam <> "":U THEN ",":U ELSE "":U)
                  + "ICFCONFIG=":U + cSessType .
        lConfFileSet = YES.
        NEXT.
      END.
      cICFParam = cICFParam + (IF cICFParam <> "":U THEN ",":U ELSE "":U)
                + ENTRY(iCount, SESSION:ICFPARAM) .
    END.

    IF NOT lConfFileSet THEN
      cICFParam = cICFParam + (IF cICFParam <> "":U THEN ",":U ELSE "":U)
                + "ICFCONFIG=icfsetup.xml":U.

    PUBLISH "DCU_SetStatus":U ("Initializing Configuration File Manager...").

    DYNAMIC-FUNCTION ("setSessionParam":U IN THIS-PROCEDURE, "ICFPARAM":U, cICFParam ).

    /* Publish the startup event. This allows other code, such as RoundTable
       to trap this event and set a special -icfparam parameter if they want to. */
    PUBLISH "DCU_BeforeInitialize".

    /* Now we need to see if anyone has set anything in the properties */
    cICFParam = DYNAMIC-FUNCTION("getSessionParam" IN THIS-PROCEDURE, "ICFPARAM":U) NO-ERROR.
    ERROR-STATUS:ERROR = NO.

    /* Users that set this at this point may want control to return to 
       another procedure. */
    cQuitOnEndB4 = DYNAMIC-FUNCTION("getSessionParam" IN THIS-PROCEDURE,
                                    "quit_on_end":U) NO-ERROR.

    ERROR-STATUS:ERROR = NO.

    IF cICFParam = ? THEN 
      cICFParam = "":U.

    /* Initialize the ICF session */
    RUN initializeSession IN THIS-PROCEDURE (cICFParam).
    IF RETURN-VALUE <> "" THEN
    DO:
      MESSAGE 
        "Unable to start the Progress Dynamics environment. The Configuration File Manager returned the following errors:":U
        SKIP
        RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    END.

    cTitle = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                              "window_title":U).
    IF cTitle <> "":U AND
       cTitle <> ? THEN
      {&WINDOW-NAME}:TITLE = cTitle.



    cQuitOnEnd  = DYNAMIC-FUNCTION("getSessionParam" IN THIS-PROCEDURE,
                               "quit_on_end":U) NO-ERROR.
    ERROR-STATUS:ERROR = NO.
    
    IF cQuitOnEnd <> ? THEN
      lQuitOnEnd = (IF cQuitOnEnd   = "NO":U THEN NO ELSE YES).
    ELSE IF cQuitOnEndB4 <> ? THEN
      lQuitOnEnd = (IF cQuitOnEndB4 = "NO":U THEN NO ELSE YES).
    ELSE
      lQuitOnEnd = YES.
  
  END.
  ELSE
  DO:
    MESSAGE 
    "Unable to start Configuration File Manager.":U
    SKIP
    RETURN-VALUE
    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  END.

  /* Assuming everything worked, we now need to load set the global 
     variables. */
  IF RETURN-VALUE = "":U THEN
  DO:
    PUBLISH "DCU_ManagersStarted":U.
    DYNAMIC-FUNCTION ("setSessionParam":U IN THIS-PROCEDURE, 
                      "dcu_managers_started":U, 
                      "YES":U).    
  END.

  RETURN RETURN-VALUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadUIImages C-Win 
PROCEDURE loadUIImages :
/*------------------------------------------------------------------------------
  Purpose:     Loads the image to be displayed at the left of the screen as 
               well as the icon to be displayed when the window is minimized.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iRes        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cImageFile  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iIcon       AS INTEGER    NO-UNDO.

  iRes = getMaxUIColors().

  IF iRes < 256 THEN
    cImageFile = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                  "current_ImageLowRes":U).
  ELSE 
  DO:
    IF iRes = 256 THEN
      cImageFile = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                    "current_Image256Res":U).
    IF cImageFile = "":U OR
       cImageFile = ? THEN
      cImageFile = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                    "current_ImageHiRes":U).
  END.

  IF cImageFile = "":U OR
     cImageFile = ? THEN
    cImageFile = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                  "current_ImageFile":U).

  IF cImageFile <> "":U AND SEARCH(cImageFile) <> ? THEN
  DO WITH FRAME {&FRAME-NAME}:
    IF IMAGE-1:LOAD-IMAGE(cImageFile,1,1,IMAGE-1:WIDTH-PIXELS,IMAGE-1:HEIGHT-PIXELS) THEN 
    DO:
      IMAGE-1:HIDDEN = FALSE.
      ASSIGN
        image-1:Y = (rect-2:HEIGHT-PIXELS + rect-2:Y - image-1:HEIGHT-PIXELS) / 2 + 2
        image-1:X = (rect-2:WIDTH-PIXELS + rect-2:X - image-1:WIDTH-PIXELS) / 2 + 2
      .
    END.
  END.

  /* Now we load the icon. */
  cImageFile = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                "setup_IconFile":U).
  IF cImageFile <> "":U AND SEARCH(cImageFile) <> ? THEN
    {&WINDOW-NAME}:LOAD-ICON(cImageFile).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE shutdownEnvironment C-Win 
PROCEDURE shutdownEnvironment :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF VALID-HANDLE(hConfMan)
  AND lStartConfMan = YES THEN
    APPLY "CLOSE":U TO hConfMan.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMaxUIColors C-Win 
FUNCTION getMaxUIColors RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the screen resolution of the current display.
            The return value is the number of colors available or 
            999999999 if more than a 16 bit display.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDevice AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iPixels AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iPlanes AS INTEGER    NO-UNDO.
  DEFINE VARIABLE dColors AS DECIMAL    NO-UNDO.

  RUN GetDC (OUTPUT hDevice, INPUT CURRENT-WINDOW:HWND).
  RUN GetDeviceCaps(OUTPUT iPixels, hDevice, 12).
  RUN GetDeviceCaps(OUTPUT iPlanes, hDevice, 14).

  dColors = EXP(2,(iPixels * iPlanes)).

  IF dColors > 999999999 THEN
    RETURN 999999999.
  ELSE
    RETURN INTEGER(dColors).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

