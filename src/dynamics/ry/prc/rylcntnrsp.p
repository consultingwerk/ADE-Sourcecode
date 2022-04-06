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

&scop object-name       rylcntnrsp.p
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
DEFINE VARIABLE ghFilterViewer      AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghLinkViewer        AS HANDLE     NO-UNDO.
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
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isFilterShowing) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isFilterShowing Procedure 
FUNCTION isFilterShowing RETURNS LOGICAL
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
         HEIGHT             = 15.62
         WIDTH              = 43.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */

{ry/app/ryplipmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-addToolbarLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addToolbarLinks Procedure 
PROCEDURE addToolbarLinks :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-closeWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE closeWindow Procedure 
PROCEDURE closeWindow :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  glCloseWindow = TRUE.
  
  RUN destroyObject IN ghTargetProcedure.

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
        cAnswer  = "the container's link(s)":U
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
        RUN toolbar IN ghTargetProcedure (INPUT "save":U) NO-ERROR.

        IF ERROR-STATUS:ERROR THEN
          RETURN ERROR "ERROR":U.
      END.

      WHEN "&No":U THEN
      DO:
        RUN toolbar IN ghTargetProcedure (INPUT IF cContainerMode = "ADD":U THEN "cancel":U ELSE "undo":U) NO-ERROR.

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
  {get ContainerSource ghContainerSource}.
  {get ContainerHandle ghContainerHandle ghContainerSource}.

  ASSIGN
      ghTargetProcedure  = TARGET-PROCEDURE
      ghLinkViewer       = DYNAMIC-FUNCTION("linkHandles":U IN ghTargetProcedure, "LinkViewer-Source":U)
      ghFilterViewer     = DYNAMIC-FUNCTION("linkHandles":U IN ghTargetProcedure, "FilterViewer-Source":U)
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

  RUN refreshData IN ghLinkViewer   (INPUT pcAction, INPUT pdObjNumber).
  RUN refreshData IN ghFilterViewer (INPUT pcAction, INPUT pdObjNumber).

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

  DEFINE VARIABLE cContainerMode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cReturnValue    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lErrorStatus    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lShowFilter     AS LOGICAL    NO-UNDO.

  RUN SUPER( INPUT pcAction).

  CASE pcAction:
    WHEN "showFilter":U THEN
    DO:
      ASSIGN
          lShowFilter    = DYNAMIC-FUNCTION("getShowFilter":U IN ghFilterViewer)
          lShowFilter    = (IF lShowFilter THEN FALSE ELSE TRUE).
  
      DYNAMIC-FUNCTION("setShowFilter":U IN ghFilterViewer, lShowFilter).
  
      RUN resetTargetActions IN ghBrowseToolbar (INPUT "BottomToolbar":U).
    END.

    /* Transfer browse contents to Excel */
    WHEN "Export":U THEN DYNAMIC-FUNCTION("transferToExcel":U IN ghFilterViewer).

    OTHERWISE
    DO:
      RUN toolbarOverride IN ghLinkViewer (INPUT pcAction) NO-ERROR.
  
      ASSIGN
          lErrorStatus = ERROR-STATUS:ERROR
          cReturnValue = RETURN-VALUE.
  
      IF pcAction = "DELETE":U THEN
      DO:
        IF DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ContainerMode":U) = "UPDATE":U AND
           DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerSource, "ContainerMode":U) = "ADD":U    THEN
        DO:
          DYNAMIC-FUNCTION("setUserProperty":U IN ghContainerSource, "ContainerMode":U, "UPDATE":U).
          DYNAMIC-FUNCTION("evaluateActions":U IN ghContainerSource).
        END.
      END.
    END.
  END CASE.
  
  IF lErrorStatus = TRUE THEN
  DO:
    RUN showMessages IN gshSessionManager (INPUT  cReturnValue,                     /* message to display */
                                           INPUT  "INF":U,                          /* error type         */
                                           INPUT  "&OK":U,                          /* button list        */
                                           INPUT  "&OK":U,                          /* default button     */
                                           INPUT  "&OK":U,                          /* cancel button      */
                                           INPUT  "Error saving link information",  /* error window title */
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
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cEnabledActions AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContainerMode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lSuccess        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lHasData        AS LOGICAL    NO-UNDO.

  IF NOT VALID-HANDLE(ghContainerToolbar) OR
     NOT VALID-HANDLE(ghBrowseToolbar)    OR 
     NOT VALID-HANDLE(ghLinkViewer)       THEN
    RETURN FALSE.
  
  ASSIGN
      cContainerMode = DYNAMIC-FUNCTION("getUserProperty":U IN ghTargetProcedure, "ContainerMode":U)
      lSuccess       = DYNAMIC-FUNCTION("disableActions":U  IN ghBrowseToolbar, "New,cbCopy,cbDelete,cbModify,cbSave,cbUndo,cbCancel,cbExport":U)
      lHasData       = DYNAMIC-FUNCTION("getHasData":U      IN ghFilterViewer).

  IF LOOKUP(cContainerMode, "CANCEL,DELETE,SAVE,RESET":U) <> 0 THEN
    cContainerMode = "MODIFY":U.

  IF lHasData = FALSE AND LOOKUP(cContainerMode, "ADD,COPY":U) = 0 THEN
    cContainerMode = "NoDATA":U.

  CASE cContainerMode:
    WHEN "ADD":U    THEN cEnabledActions = "cbSave,cbCancel":U.
    WHEN "MODIFY":U THEN cEnabledActions = "New,cbCopy,cbDelete,cbModify":U.
    WHEN "UPDATE":U THEN cEnabledActions = "cbSave,cbUndo":U.

    WHEN "NoDATA":U THEN
    DO:
      cEnabledActions = IF {fnarg getUserProperty '"ContainerMode"' ghContainerSource} <> "FIND":U THEN "New":U ELSE "":U.

      RUN toolbarOverride IN ghLinkViewer (INPUT "NoDATA":U) NO-ERROR.
    END.
  END CASE.

  cEnabledActions = cEnabledActions  + (IF cEnabledActions = "":U THEN "":U ELSE ",":U)
                  + "cbShowFilter":U + (IF lHasData THEN ",cbExport":U ELSE "":U).

  DYNAMIC-FUNCTION("enableActions":U IN ghBrowseToolbar, cEnabledActions).

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isFilterShowing) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isFilterShowing Procedure 
FUNCTION isFilterShowing RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lShowFilter AS LOGICAL    NO-UNDO INITIAL FALSE.
  
  IF VALID-HANDLE(ghFilterViewer) THEN
    lShowFilter = DYNAMIC-FUNCTION("getShowFilter":U IN ghFilterViewer).

  RETURN lShowFilter.   /* Function return value. */

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

