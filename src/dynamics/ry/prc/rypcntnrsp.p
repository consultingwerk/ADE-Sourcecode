&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Procedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Procedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*---------------------------------------------------------------------------------
  File: cntainrlip.p

  Description:  Links Container Super Procdure

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   04/14/2002  Author:     Chris Koster

  Update Notes: Created from Template rytemplipp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rypcntnrsp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

{src/adm2/globals.i}

DEFINE VARIABLE ghContainerToolbar  AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghContainerHandle   AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghContainerSource   AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghTargetProcedure   AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghBrowseToolbar     AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghBrowserViewer     AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghPageViewer        AS HANDLE     NO-UNDO.
DEFINE VARIABLE glCloseWindow       AS LOGICAL    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-evaluateActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD evaluateActions Procedure 
FUNCTION evaluateActions RETURNS LOGICAL
  (pcMode AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-evaluateMoveUpDown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD evaluateMoveUpDown Procedure 
FUNCTION evaluateMoveUpDown RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-lockWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD lockWindow Procedure 
FUNCTION lockWindow RETURNS LOGICAL
  (plLockWindow AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 14.33
         WIDTH              = 46.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */

{ry/app/ryplipmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-closeWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE closeWindow Procedure 
PROCEDURE closeWindow :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  glCloseWindow = TRUE.

  RUN destroyObject IN ghTargetProcedure NO-ERROR.

  IF ERROR-STATUS:ERROR   OR
     RETURN-VALUE <> "":U THEN
  DO:
    glCloseWindow = FALSE.

    RETURN ERROR "ERROR":U.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cContainerMode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessage        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAnswer         AS CHARACTER  NO-UNDO.

  cContainerMode = DYNAMIC-FUNCTION("getUserProperty":U IN ghTargetProcedure, "ContainerMode":U).

  IF cContainerMode = "UPDATE":U OR
     cContainerMode = "ADD":U    THEN
  DO:
    ASSIGN
        cAnswer  = "the container's page(s)":U
        cMessage = {af/sup2/aferrortxt.i 'AF' '131' '?' '?' cAnswer}.

    RUN askQuestion IN gshSessionManager (INPUT cMessage,                         /* messages */
                                          INPUT "&Yes,&No,&Cancel":U,             /* button list */
                                          INPUT "&Yes":U,                         /* default */
                                          INPUT "&Cancel":U,                      /* cancel */
                                          INPUT "Save changes before closing":U,  /* title */
                                          INPUT "":U,                             /* datatype */
                                          INPUT "":U,                             /* format */
                                          INPUT-OUTPUT cAnswer,                   /* answer */
                                          OUTPUT cButton).                        /* button pressed */
    
    CASE cButton:
      WHEN "&Cancel":U THEN
        RETURN ERROR "ERROR":U.
    
      WHEN "&Yes":U THEN
      DO:
        RUN toolbar IN ghTargetProcedure (INPUT "Save":U) NO-ERROR.
    
        IF ERROR-STATUS:ERROR THEN
          RETURN ERROR "ERROR":U.
      END.
      
      WHEN "&No":U THEN
      DO:
        RUN toolbar IN ghTargetProcedure (INPUT IF cContainerMode = "ADD":U THEN "cancelRecord":U ELSE "resetRecord":U) NO-ERROR.
    
        IF ERROR-STATUS:ERROR THEN
          RETURN ERROR "ERROR":U.
      END.
    END CASE.
  END.

  IF DYNAMIC-FUNCTION("hideSubTools":U IN ghContainerSource) = FALSE THEN
    glCloseWindow = TRUE.

  IF glCloseWindow = TRUE THEN
  DO:
    RUN SUPER.

    APPLY "CLOSE":U TO THIS-PROCEDURE.
  END.
  ELSE
  DO:
    RUN hideObject IN ghTargetProcedure.

    /* This will check to see if any child windows are open and visible to set the corresponding userProperty for the prompt of the 'child windows open' */
    DYNAMIC-FUNCTION("checkChildWindows":U IN ghContainerSource).

    RETURN ERROR "ERROR":U.
  END.

  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cHiddenBands    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hToolbar        AS HANDLE     NO-UNDO.
  
  {get ContainerSource ghContainerSource}.
  {get ContainerHandle ghContainerHandle ghContainerSource}.
  
  ASSIGN
      ghTargetProcedure  = TARGET-PROCEDURE
      ghBrowserViewer    = DYNAMIC-FUNCTION("linkHandles":U IN ghTargetProcedure, "BrowserViewer-Source":U)
      ghPageViewer       = DYNAMIC-FUNCTION("linkHandles":U IN ghTargetProcedure, "CntPageViewer-Source":U)
      ghContainerToolbar = DYNAMIC-FUNCTION("linkHandles":U IN ghTargetProcedure, "TopToolbar-Source":U)
      ghBrowseToolbar    = DYNAMIC-FUNCTION("linkHandles":U IN ghTargetProcedure, "BottomToolbar-Source":U).

  SUBSCRIBE PROCEDURE THIS-PROCEDURE   TO "refreshData":U IN ghContainerSource.
  SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "toolbar":U     IN ghContainerToolbar.

  RUN SUPER.

  DYNAMIC-FUNCTION("enableActions":U IN ghContainerToolbar, "txtExit,txtHelp":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-killPlip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE killPlip Procedure 
PROCEDURE killPlip :
/*------------------------------------------------------------------------------
  Purpose:     entry point to instantly kill the plip if it should get lost in memory
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipkill.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-objectDescription) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE objectDescription Procedure 
PROCEDURE objectDescription :
/*------------------------------------------------------------------------------
  Purpose:     Pass out a description of the PLIP, used in Plip temp-table
  Parameters:  <none>
  Notes:       This should be changed manually for each plip
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER cDescription AS CHARACTER NO-UNDO.

ASSIGN cDescription = "Dynamics Template PLIP".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipSetup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipSetup Procedure 
PROCEDURE plipSetup :
/*------------------------------------------------------------------------------
  Purpose:    Run by main-block of PLIP at startup of PLIP
  Parameters: <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipsetu.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipShutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown Procedure 
PROCEDURE plipShutdown :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will be run just before the calling program 
               terminates
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipshut.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-refreshData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshData Procedure 
PROCEDURE refreshData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcAction     AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pdObjNumber  AS DECIMAL    NO-UNDO.

  RUN refreshData IN ghPageViewer    (INPUT pcAction, INPUT pdObjNumber).
  RUN refreshData IN ghBrowserViewer (INPUT pcAction, INPUT pdObjNumber).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-toolbar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE toolbar Procedure 
PROCEDURE toolbar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcAction AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cReturnValue  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lErrorStatus  AS LOGICAL    NO-UNDO.

  RUN SUPER( INPUT pcAction).

  /* Transfer browse contents to Excel */
  IF pcAction = "Export":U THEN
    DYNAMIC-FUNCTION("transferToExcel":U IN ghBrowserViewer).
  ELSE
    RUN toolbar IN ghPageViewer (INPUT pcAction) NO-ERROR.

  ASSIGN
      lErrorStatus = ERROR-STATUS:ERROR
      cReturnValue = RETURN-VALUE.

  IF lErrorStatus = TRUE THEN
  DO:
    RUN showMessages IN gshSessionManager (INPUT  cReturnValue,                     /* message to display */
                                           INPUT  "INF":U,                          /* error type         */
                                           INPUT  "&OK":U,                          /* button list        */
                                           INPUT  "&OK":U,                          /* default button     */ 
                                           INPUT  "&OK":U,                          /* cancel button      */
                                           INPUT  "Error saving page information",  /* error window title */
                                           INPUT  YES,                              /* display if empty   */ 
                                           INPUT  ghTargetProcedure,                /* container handle   */ 
                                           OUTPUT cButton).                         /* button pressed     */

    RETURN ERROR.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-viewObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewObject Procedure 
PROCEDURE viewObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN SUPER.

  DYNAMIC-FUNCTION("enableActions":U IN ghContainerToolbar, "txtExit,txtHelp":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-evaluateActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION evaluateActions Procedure 
FUNCTION evaluateActions RETURNS LOGICAL
  (pcMode AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iSequence AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lSuccess  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lHasData  AS LOGICAL    NO-UNDO.
  
  IF LOOKUP(pcMode, "Cancel,Delete,Save,Reset":U) <> 0 THEN
    pcMode = "View":U.

  IF NOT VALID-HANDLE(ghContainerToolbar) OR
     NOT VALID-HANDLE(ghBrowseToolbar)    OR
     NOT VALID-HANDLE(ghPageViewer)       THEN
    RETURN FALSE.
  
  ASSIGN
      lSuccess = {fnarg disableActions 'New,cbCopy,cbModify,cbDelete,cbSave,cbUndo,cbCancel,cbMoveUp,cbMoveDown' ghBrowseToolbar}
      lHasData = {fn    getHasData      ghBrowserViewer}.

  IF lHasData = FALSE AND LOOKUP(pcMode, "Add,Copy":U) = 0 THEN
    pcMode = "NoData":U.

  CASE pcMode:
    WHEN "Add":U THEN
      ASSIGN
          lSuccess = {fnarg enableActions   'txtOk,txtCancel' ghContainerToolbar}
          lSuccess = {fnarg enableActions   'cbSave,cbCancel' ghBrowseToolbar}
          lSuccess = {fnarg setUserProperty "'ContainerMode', 'ADD'"}.

    WHEN "View":U THEN
      ASSIGN
          lSuccess = {fnarg enableActions   'txtOk,txtCancel'         ghContainerToolbar}
          lSuccess = {fnarg enableActions   'New,cbDelete,cbModify' ghBrowseToolbar}
          lSuccess = {fnarg setUserProperty "'ContainerMode', 'VIEW'"}.

    WHEN "Modify":U THEN
      ASSIGN
          lSuccess = {fnarg enableActions   'New,cbCopy,cbDelete' ghBrowseToolbar}
          lSuccess = {fnarg setUserProperty "'ContainerMode', 'MODIFY'"}.

    WHEN "Update":U THEN
      ASSIGN
          lSuccess = {fnarg disableActions  'cbMoveUp,cbMoveDown' ghBrowseToolbar}
          lSuccess = {fnarg enableActions   'cbSave,cbUndo'       ghBrowseToolbar}
          lSuccess = {fnarg setUserProperty "'ContainerMode', 'UPDATE'"}.

    WHEN "NoData":U THEN
    DO:
      IF {fnarg getUserProperty 'ContainerMode' ghContainerSource} <> "FIND":U AND
         {fnarg getUserProperty 'DataContainer' ghContainerSource} <> "yes":U  THEN
      ASSIGN
          lSuccess = {fnarg enableActions 'New' ghBrowseToolbar}.

      {fnarg setFieldSensitivity "FALSE, TRUE" ghPageViewer}.
      {fnarg disableActions      'export'      ghBrowseToolbar}.
    END.
  END CASE.
  
  iSequence = {fn getSelectedPageSequence ghPageViewer}.

  IF iSequence <> ? AND LOOKUP(pcMode, "Modify,View":U) <> 0 THEN
    IF iSequence = 0 THEN
      {fnarg disableActions 'cbDelete,cbModify' ghBrowseToolbar}.
    ELSE
      {fnarg enableActions  'cbDelete' ghBrowseToolbar}.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-evaluateMoveUpDown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION evaluateMoveUpDown Procedure 
FUNCTION evaluateMoveUpDown RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN DYNAMIC-FUNCTIO("evaluateMoveUpDown":U IN ghPageViewer).   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-lockWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION lockWindow Procedure 
FUNCTION lockWindow RETURNS LOGICAL
  (plLockWindow AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iReturnCode AS INTEGER    NO-UNDO.
  
  IF plLockWindow AND ghContainerHandle:HWND EQ ? THEN
       RETURN FALSE.

  IF plLockWindow THEN
    RUN lockWindowUpdate IN gshSessionManager (INPUT ghContainerHandle:HWND, OUTPUT iReturnCode).
  ELSE
    RUN lockWindowUpdate IN gshSessionManager (INPUT 0, OUTPUT iReturnCode).

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

