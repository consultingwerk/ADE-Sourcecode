&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
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
  File: rycbgenspp.p

  Description:  Super proc: for containers of the CB

  Purpose:      A super procedure for containers of the container builder that do not have a
                super procedure associated with them, for instance the Menu Structure
                Maintenance, that need to be able to keep track of the destroyObject event
                of the container.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   08/16/2002  Author:     Chris Koster

  Update Notes: Created from Template rytemplipp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rycbgenspp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

{src/adm2/globals.i}

DEFINE VARIABLE ghContainerSource AS HANDLE     NO-UNDO.
DEFINE VARIABLE glCloseWindow     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glSessionShutdown AS LOGICAL    INITIAL FALSE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getTargetProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTargetProcedure Procedure 
FUNCTION getTargetProcedure RETURNS WIDGET-HANDLE
  ( /* parameter-definitions */ )  FORWARD.

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
         HEIGHT             = 14.86
         WIDTH              = 49.8.
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

  RUN destroyObject IN TARGET-PROCEDURE NO-ERROR.

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
  DEFINE VARIABLE cReturnValue    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessage        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAnswer         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lErrorStatus    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hWindow         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hOwner          AS HANDLE     NO-UNDO.

  cContainerMode = DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "ContainerMode":U).

  IF cContainerMode = "UPDATE":U OR
     cContainerMode = "ADD":U    THEN
  DO:
    ASSIGN
        cAnswer  = DYNAMIC-FUNCTION("getUserProperty":U IN TARGET-PROCEDURE, "promptAddition":U)
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
        PUBLISH "takeAction":U FROM TARGET-PROCEDURE (INPUT  "Save":U,
                                                      OUTPUT lErrorStatus,
                                                      OUTPUT cReturnValue).
  
        IF lErrorStatus THEN
          RETURN ERROR cReturnValue.
      END.
  
      WHEN "&No":U THEN
      DO:
        PUBLISH "takeAction":U FROM TARGET-PROCEDURE (INPUT  (IF cContainerMode = "ADD":U THEN "Cancel":U ELSE "Reset":U),
                                                      OUTPUT lErrorStatus,
                                                      OUTPUT cReturnValue).
  
        IF lErrorStatus THEN
          RETURN ERROR cReturnValue.
      END.
    END CASE.
  END.

  hOwner = WIDGET-HANDLE({fnarg getUserProperty 'Owner':U}).

  IF glSessionShutdown OR NOT DYNAMIC-FUNCTION("hideSubTools":U IN ghContainerSource) THEN
    glCloseWindow = TRUE.

  IF glCloseWindow = TRUE THEN
  DO:
    IF VALID-HANDLE(hOwner) THEN
      {set ContainerSource hOwner}.
    
    RUN SUPER.

    APPLY "CLOSE":U TO THIS-PROCEDURE.
  END.
  ELSE
  DO:
    IF VALID-HANDLE(hOwner) THEN
      {get WindowFrameHandle hWindow hOwner}.
    
    RUN hideObject IN TARGET-PROCEDURE.

    IF VALID-HANDLE(hWindow) THEN
      hWindow:PARENT:MOVE-TO-TOP().

    /* This will check to see if any child windows are open and visible to set the corresponding userProperty for the prompt of the 'child windows open' */
    DYNAMIC-FUNCTION("checkChildWindows":U IN ghContainerSource).

    RETURN ERROR "ERROR":U.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ICFCFM_StartSessionShutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ICFCFM_StartSessionShutdown Procedure 
PROCEDURE ICFCFM_StartSessionShutdown :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  glSessionShutdown = TRUE.
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

  RUN SUPER.
  
  SUBSCRIBE "ICFCFM_StartSessionShutdown" ANYWHERE.

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

&IF DEFINED(EXCLUDE-postCreateObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE postCreateObjects Procedure 
PROCEDURE postCreateObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainerHandle  AS HANDLE     NO-UNDO.

  hContainerHandle = DYNAMIC-FUNCTION("getContainerHandle":U IN TARGET-PROCEDURE).

  IF DYNAMIC-FUNCTION("getRunAttribute":U IN TARGET-PROCEDURE) = "actAsDialog":U THEN
    ASSIGN
        hContainerHandle:MAX-BUTTON = FALSE
        hContainerHandle:RESIZE     = FALSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getTargetProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTargetProcedure Procedure 
FUNCTION getTargetProcedure RETURNS WIDGET-HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN TARGET-PROCEDURE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

