&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
/* Procedure Description
"Super Procedure for Object Instance Replacement Viewer"
*/
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
  File: ryreplinstvp.p

  Description:  Object Instance Replacement Viewer

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   03/24/2003  Author:     

  Update Notes: Created from Template viewv

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       ryreplinstvp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

DEFINE VARIABLE ghWindow                          AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghContainerSource                 AS HANDLE     NO-UNDO.

DEFINE VARIABLE gcAllFieldNames                   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcAllFieldHandles                 AS CHARACTER  NO-UNDO.

/* Handles for each field on DynView */
DEFINE VARIABLE hfcObjectSource                   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hlkObjectSource                   AS HANDLE     NO-UNDO.

DEFINE VARIABLE hfcObjectTarget                   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hlkObjectTarget                   AS HANDLE     NO-UNDO.

DEFINE VARIABLE htoObjectContainer                AS HANDLE     NO-UNDO.
DEFINE VARIABLE hfcObjectContainer                AS HANDLE     NO-UNDO.
DEFINE VARIABLE hlkObjectContainer                AS HANDLE     NO-UNDO.

DEFINE VARIABLE htoObjectInstance                 AS HANDLE     NO-UNDO.
DEFINE VARIABLE hfcObjectInstance                 AS HANDLE     NO-UNDO.
DEFINE VARIABLE hlkObjectInstance                 AS HANDLE     NO-UNDO.

DEFINE VARIABLE htoObjectResult                   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hfcObjectResult                   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hlkObjectResult                   AS HANDLE     NO-UNDO.

DEFINE VARIABLE htoObjectDeleteSource             AS HANDLE     NO-UNDO.
DEFINE VARIABLE hraInstanceAttribute              AS HANDLE     NO-UNDO.

DEFINE VARIABLE hbuReplace                        AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getFieldHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFieldHandle Procedure 
FUNCTION getFieldHandle RETURNS HANDLE
  ( pcFieldName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Compile into: ry/prc
   Allow: Basic,Browse,DB-Fields
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 11.71
         WIDTH              = 48.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/customsuper.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-assignFieldHandles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignFieldHandles Procedure 
PROCEDURE assignFieldHandles :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will assign handles to predefined variables to 
               allow the use of the variables on the viewer to be more accesable
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  ASSIGN
    hlkObjectSource            = getFieldHandle("fcObjectSource":U)
    hlkObjectTarget            = getFieldHandle("fcObjectTarget":U)
    htoObjectContainer         = getFieldHandle("toObjectContainer":U)
    hlkObjectContainer         = getFieldHandle("fcObjectContainer":U)
    htoObjectInstance          = getFieldHandle("toObjectInstance":U)
    hlkObjectInstance          = getFieldHandle("fcObjectInstance":U)
    htoObjectResult            = getFieldHandle("toObjectResult":U)
    hlkObjectResult            = getFieldHandle("fcObjectResultCode":U)
    htoObjectDeleteSource      = getFieldHandle("toObjectDeleteSource":U)
    hraInstanceAttribute       = getFieldHandle("raInstanceAttribute":U)
    hbuReplace                 = getFieldHandle("buReplace":U)
    .    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  RUN SUPER.

  {get containerSource ghContainerSource}.

  gcAllFieldNames   = DYNAMIC-FUNCTION("getAllFieldNames":U   IN TARGET-PROCEDURE).
  gcAllFieldHandles = DYNAMIC-FUNCTION("getAllFieldHandles":U IN TARGET-PROCEDURE).
  
  RUN assignFieldHandles IN TARGET-PROCEDURE.
  
/*
  RUN displayFields IN TARGET-PROCEDURE (?).
*/

  ASSIGN
    htoObjectContainer:CHECKED         = NO
    htoObjectInstance:CHECKED          = NO
    htoObjectResult:CHECKED            = NO
    htoObjectDeleteSource:CHECKED      = NO
    .

  RUN enableField IN hlkObjectSource.
  RUN enableField IN hlkObjectTarget.

  RUN trgtoObjectContainer.
  RUN trgtoObjectInstance.
  RUN trgtoObjectResult.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-trgbuReplace) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trgbuReplace Procedure 
PROCEDURE trgbuReplace :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hDesignManager          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cMessageTitle           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessageError           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessageButton          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cReturnValue            AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cObjectSource           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectTarget           AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE lObjectContainer        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cObjectContainer        AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE lObjectInstance         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cObjectInstance         AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE lObjectResult           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cObjectResult           AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE lObjectDeleteSource     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lAttributeRemoveAll     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lAttributeRemoveUnused  AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE iReplacementCount       AS INTEGER    NO-UNDO.

  ASSIGN
    cMessageTitle = "Object Instance Replacement":U.

  ASSIGN
    hDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).
  IF NOT VALID-HANDLE(hDesignManager)
  THEN
    ASSIGN
      hDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "DesignManager":U).

  IF NOT VALID-HANDLE(hDesignManager) 
  THEN DO:
    ASSIGN
      cMessageError = "Unable to replace Object Instances, the design manager is not running. It should be set up in the current session type under managers as 'RepositoryDesignManager'".
    RUN showMessages IN gshSessionManager (INPUT cMessageError,
                                           INPUT "MES":U,
                                           INPUT "&OK":U,
                                           INPUT "&OK":U,
                                           INPUT "&OK":U,
                                           INPUT cMessageTitle,
                                           INPUT NO,
                                           INPUT THIS-PROCEDURE,
                                           OUTPUT cMessageButton).
    RETURN.
  END.

  ASSIGN
    cMessageError = "":U.

  ASSIGN
    cObjectSource = DYNAMIC-FUNCTION("getDataValue":U IN hlkObjectSource)
    cObjectTarget = DYNAMIC-FUNCTION("getDataValue":U IN hlkObjectTarget)
    .

  IF cObjectSource = "":U
  THEN
    ASSIGN
      cMessageError = cMessageError
                    + (IF cMessageError <> "":U THEN CHR(10) ELSE "":U)
                    + "ERROR: Source Object name must be specified".

  IF cObjectTarget = "":U
  THEN
    ASSIGN
      cMessageError = cMessageError
                    + (IF cMessageError <> "":U THEN CHR(10) ELSE "":U)
                    + "ERROR: Target Object name must be specified".

  ASSIGN
    lObjectDeleteSource     = LOGICAL(htoObjectDeleteSource:CHECKED)
    lObjectContainer        = LOGICAL(htoObjectContainer:CHECKED)
    lObjectInstance         = LOGICAL(htoObjectInstance:CHECKED)
    lObjectResult           = LOGICAL(htoObjectResult:CHECKED)
    .

  IF lObjectContainer
  THEN ASSIGN cObjectContainer  = DYNAMIC-FUNCTION("getDataValue":U IN hlkObjectContainer).
  ELSE ASSIGN cObjectContainer  = "ALL":U.

  IF lObjectContainer
  AND cObjectContainer = "":U
  THEN
    ASSIGN
      cMessageError = cMessageError
                    + (IF cMessageError <> "":U THEN CHR(10) ELSE "":U)
                    + "ERROR: Container Object name must be specified if option is selected".

  IF lObjectInstance
  THEN ASSIGN cObjectInstance   = DYNAMIC-FUNCTION("getDataValue":U IN hlkObjectInstance).
  ELSE ASSIGN cObjectInstance   = "":U.

  IF lObjectInstance
  AND cObjectInstance = "":U
  THEN
    ASSIGN
      cMessageError = cMessageError
                    + (IF cMessageError <> "":U THEN CHR(10) ELSE "":U)
                    + "ERROR: Object Instance name must be specified if option is selected".

  IF lObjectResult
  THEN ASSIGN cObjectResult     = DYNAMIC-FUNCTION("getDataValue":U IN hlkObjectResult).
  ELSE ASSIGN cObjectResult     = "":U.

  IF lObjectResult
  AND cObjectResult = "":U
  THEN
    ASSIGN
      cMessageError = cMessageError
                    + (IF cMessageError <> "":U THEN CHR(10) ELSE "":U)
                    + "ERROR: Result code must be specified if option is selected".

  ASSIGN
    lAttributeRemoveAll     = FALSE
    lAttributeRemoveUnused  = TRUE
    .

  CASE hraInstanceAttribute:SCREEN-VALUE :
    WHEN "REMOVE" THEN lAttributeRemoveAll = TRUE.
    WHEN "RETAIN" THEN lAttributeRemoveAll = FALSE.
  END CASE.

  IF cMessageError <> "":U
  THEN DO:
    RUN showMessages IN gshSessionManager (INPUT cMessageError,
                                           INPUT "MES":U,
                                           INPUT "&OK":U,
                                           INPUT "&OK":U,
                                           INPUT "&OK":U,
                                           INPUT cMessageTitle,
                                           INPUT NO,
                                           INPUT THIS-PROCEDURE,
                                           OUTPUT cMessageButton).
    RETURN.
  END.

  IF VALID-HANDLE(hDesignManager)
  THEN DO:
    RUN changeObjectInstance IN hDesignManager
                            (INPUT cObjectContainer
                            ,INPUT cObjectResult
                            ,INPUT cObjectInstance
                            ,INPUT cObjectSource
                            ,INPUT cObjectTarget
                            ,INPUT lObjectDeleteSource
                            ,INPUT lAttributeRemoveAll
                            ,INPUT lAttributeRemoveUnused
                            ,OUTPUT iReplacementCount
                            ) NO-ERROR.
  END.

  ASSIGN
    cMessageTitle = "Object Instance Replacement":U.

  IF ERROR-STATUS:ERROR
  OR RETURN-VALUE <> "":U
  THEN DO:
    IF RETURN-VALUE <> "":U
    THEN ASSIGN cReturnValue = RETURN-VALUE.
    ELSE ASSIGN cReturnValue = ERROR-STATUS:GET-MESSAGE(1).
  END.

  IF iReplacementCount = ?
  THEN
    ASSIGN
      iReplacementCount = 0.

  ASSIGN
    cMessageError = "* Object Instance Replacement Completed "
                  + (IF cReturnValue <> "":U THEN "With Errors" ELSE "Successfully")
                  .

  IF iReplacementCount = 0
  THEN
    ASSIGN
      cMessageError = cMessageError
                    + (IF cMessageError <> "":U THEN CHR(10) ELSE "":U)
                    + "    ( NO object instances were replaced )"
                    .
  ELSE
    ASSIGN
      cMessageError = cMessageError
                    + (IF cMessageError <> "":U THEN CHR(10) ELSE "":U)
                    + "    ( Replaced "
                    + STRING(iReplacementCount,">>9")
                    + (IF iReplacementCount = 1 THEN " Instance " ELSE " Instances ")
                    + ")"
                    .

  RUN showMessages IN gshSessionManager (INPUT cMessageError,
                                         INPUT "MES":U,
                                         INPUT "&OK":U,
                                         INPUT "&OK":U,
                                         INPUT "&OK":U,
                                         INPUT cMessageTitle,
                                         INPUT NO,
                                         INPUT THIS-PROCEDURE,
                                         OUTPUT cMessageButton).

  IF cReturnValue <> "":U
  THEN DO:
    ASSIGN
      cMessageTitle = cMessageTitle + " * ERROR * ":U.
    RUN showMessages IN gshSessionManager (INPUT cReturnValue,
                                           INPUT "MES":U,
                                           INPUT "&OK":U,
                                           INPUT "&OK":U,
                                           INPUT "&OK":U,
                                           INPUT cMessageTitle,
                                           INPUT NO,
                                           INPUT THIS-PROCEDURE,
                                           OUTPUT cMessageButton).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-trgtoObjectContainer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trgtoObjectContainer Procedure 
PROCEDURE trgtoObjectContainer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF htoObjectContainer:CHECKED
  THEN RUN enableField  IN hlkObjectContainer.
  ELSE RUN disableField IN hlkObjectContainer.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-trgtoObjectInstance) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trgtoObjectInstance Procedure 
PROCEDURE trgtoObjectInstance :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF htoObjectInstance:CHECKED
  THEN RUN enableField  IN hlkObjectInstance.
  ELSE RUN disableField IN hlkObjectInstance.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-trgtoObjectResult) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trgtoObjectResult Procedure 
PROCEDURE trgtoObjectResult :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF htoObjectResult:CHECKED
  THEN RUN enableField  IN hlkObjectResult.
  ELSE RUN disableField IN hlkObjectResult.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getFieldHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldHandle Procedure 
FUNCTION getFieldHandle RETURNS HANDLE
  ( pcFieldName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iEntry        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hFieldHandle  AS HANDLE     NO-UNDO.

  hFieldHandle = ?.

  iEntry = LOOKUP(pcFieldName,gcAllFieldNames).
  IF iEntry <> 0
  THEN
    hFieldHandle = WIDGET-HANDLE(ENTRY(iEntry,gcAllFieldHandles)).

  RETURN hFieldHandle.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

