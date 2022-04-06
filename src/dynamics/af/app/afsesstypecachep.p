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
  File: afsesstypecachep.p

  Description:  Session Type Cache

  Purpose:      Session Type Cache

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   09/19/2003  Author:     Bruce S Gruenbaum

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afsesstypecachep.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


DEFINE VARIABLE ghCFGWriter    AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghQuery        AS HANDLE     NO-UNDO.

/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

{af/sup2/afxmlcfgtt.i
  &session-table = "YES"}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getSessionOverrideInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSessionOverrideInfo Procedure 
FUNCTION getSessionOverrideInfo RETURNS CHARACTER
  ( INPUT pcSessType AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isSessTypeRegistered) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isSessTypeRegistered Procedure 
FUNCTION isSessTypeRegistered RETURNS LOGICAL
  ( INPUT pcSessionType AS CHARACTER )  FORWARD.

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
         HEIGHT             = 23.1
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
ON CLOSE, DELETE OF THIS-PROCEDURE
DO:
  RUN shutdownProc.
END.

  CREATE QUERY ghQuery.
  /* If we're on the server side, we need to cache all the session type information for all the session
     types so that we don't need to calculate this later. */
  RUN startProcedure IN THIS-PROCEDURE
    ("ONCE|af/app/afcfgwritep.p":U,
     OUTPUT ghCFGWriter).

  IF VALID-HANDLE(ghCFGWriter) THEN
  DO:
    RUN buildTempTables IN ghCFGWriter
      ("*":U, /* Get all session types */
       NO     /* We don't want minimum temp-tables */ ).

    RUN getTempTables IN ghCFGWriter
      (OUTPUT TABLE ttSession,
       OUTPUT TABLE ttProperty,
       OUTPUT TABLE ttService,
       OUTPUT TABLE ttManager).
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-getSessTypeOverrideInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSessTypeOverrideInfo Procedure 
PROCEDURE getSessTypeOverrideInfo :
/*------------------------------------------------------------------------------
  ACCESS_LEVEL = PRIVATE
  Purpose:     Gets the session type override information into the Dynamics 
               repository.
  Parameters:  
    plConfigDefault         - Can the session types in the repository be 
                              overridden?
    plAllowUnregistered     - Do we allow users to start sessions with 
                              unregistered session types?
    pcPermittedUnregistered - Comma-separated list of session types that are
                              not defined in the repository that we will allow
                              to access the repository.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT  PARAMETER plConfigDefault         AS LOGICAL    NO-UNDO.
    DEFINE OUTPUT  PARAMETER plAllowUnregistered     AS LOGICAL    NO-UNDO.
    DEFINE OUTPUT  PARAMETER pcPermittedUnregistered AS CHARACTER  NO-UNDO.

    DEFINE BUFFER bgsc_global_default   FOR gsc_global_default.
    DEFINE BUFFER bgsc_security_control FOR gsc_security_control.
    
    FIND FIRST bgsc_security_control NO-LOCK.
    FIND FIRST bgsc_global_default NO-LOCK
      WHERE bgsc_global_default.owning_entity_mnemonic = "GSCSC":U 
        AND bgsc_global_default.owning_obj             = bgsc_security_control.security_control_obj
        AND bgsc_global_default.default_type           = "CFG":U
        AND bgsc_global_default.effective_date         = DATE(01,01,1801)
      NO-ERROR.
    IF NOT AVAILABLE(bgsc_global_default) THEN
      plConfigDefault = ?.
    ELSE
      plConfigDefault = LOGICAL(bgsc_global_default.default_value).

    FIND FIRST bgsc_global_default NO-LOCK
      WHERE bgsc_global_default.owning_entity_mnemonic = "GSCSC":U 
        AND bgsc_global_default.owning_obj             = bgsc_security_control.security_control_obj
        AND bgsc_global_default.default_type           = "AUR":U
        AND bgsc_global_default.effective_date         = DATE(01,01,1801)
      NO-ERROR.
    IF NOT AVAILABLE(bgsc_global_default) THEN
      plAllowUnregistered = ?.
    ELSE
      plAllowUnregistered = LOGICAL(bgsc_global_default.default_value).
    
    FIND FIRST bgsc_global_default NO-LOCK
      WHERE bgsc_global_default.owning_entity_mnemonic = "GSCSC":U 
        AND bgsc_global_default.owning_obj             = bgsc_security_control.security_control_obj
        AND bgsc_global_default.default_type           = "PUR":U
        AND bgsc_global_default.effective_date         = DATE(01,01,1801)
      NO-ERROR.
    IF NOT AVAILABLE(bgsc_global_default) THEN
      pcPermittedUnregistered = ?.
    ELSE
      pcPermittedUnregistered = bgsc_global_default.default_value.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mergeSessTypeData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mergeSessTypeData Procedure 
PROCEDURE mergeSessTypeData :
/*------------------------------------------------------------------------------
  ACCESS_LEVEL = PUBLIC
  Purpose:     Takes the values of the data in the cache and applies them to the
               tables that are passed in.         
  Parameters:  
    pcSessType  - Session Type to update for.
    plOverwrite - Should the contents of the tables that are coming in be 
                  replaced with the contents of the data in the cache?
    phbProperty - Handle to a ttProperty buffer
    phbService  - Handle to a ttService buffer
    phbManager  - Handle to a ttManager buffer
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcSessType  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plOverwrite AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER phbProperty AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER phbService  AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER phbManager  AS HANDLE     NO-UNDO.

  DEFINE VARIABLE lCreate             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lUpdate             AS LOGICAL    NO-UNDO.

  RUN storeCFGOrder(pcSessType, phbService).
  RUN storeCFGOrder(pcSessType, phbManager).
  
  /* Loop through all the properties */
  FOR EACH ttProperty 
    WHERE ttProperty.cSessionType = pcSessType:
    phbProperty:FIND-FIRST("WHERE cSessionType = ":U + QUOTER(pcSessType) +
                           "  AND cProperty = ":U + QUOTER(ttProperty.cProperty))
                NO-ERROR.
    ERROR-STATUS:ERROR = NO.
    IF NOT phbProperty:AVAILABLE THEN
    DO:
      phbProperty:BUFFER-CREATE().
      lCreate = YES.
    END.
    ELSE 
      lCreate = NO.

    IF lCreate OR plOverwrite THEN
    DO:
      lUpdate = NOT phbProperty:BUFFER-COMPARE(BUFFER ttProperty:HANDLE,"BINARY":U,"lDelete,lUpdated":U).
      IF lUpdate OR lCreate THEN
      DO:
        phbProperty:BUFFER-COPY(BUFFER ttProperty:HANDLE,"lDelete,lUpdated":U).
        phbProperty:BUFFER-FIELD("lUpdated":U):BUFFER-VALUE = YES.
      END.
      phbProperty:BUFFER-FIELD("lDelete":U):BUFFER-VALUE = NO.
      phbProperty:BUFFER-RELEASE().
    END.
  END.
  
  /* Loop through all the Services */
  FOR EACH ttService 
    WHERE ttService.cSessionType = pcSessType:
    phbService:FIND-FIRST("WHERE cSessionType = ":U + QUOTER(pcSessType) +
                           "  AND cServiceName = ":U + QUOTER(ttService.cServiceName))
        NO-ERROR.
    ERROR-STATUS:ERROR = NO.
    IF NOT phbService:AVAILABLE THEN
    DO:
      phbService:BUFFER-CREATE().
      phbService:BUFFER-FIELD("iOrder":U):BUFFER-VALUE = ?.
      lCreate = YES.
    END.
    ELSE 
      lCreate = NO.
  
    IF lCreate OR plOverwrite THEN
    DO:
      lUpdate = NOT phbService:BUFFER-COMPARE(BUFFER ttService:HANDLE,"BINARY":U,"iOrder,lDelete,lUpdated,iStartOrder,iCFGOrder,iDBOrder":U).
      IF lUpdate OR lCreate THEN
      DO:
        phbService:BUFFER-COPY(BUFFER ttService:HANDLE,"iOrder,lDelete,lUpdated,iStartOrder,iCFGOrder":U,"iOrder,iDBOrder":U).
        phbService:BUFFER-FIELD("lUpdated":U):BUFFER-VALUE = YES.
      END.
      phbService:BUFFER-FIELD("lDelete":U):BUFFER-VALUE = NO.
      phbService:BUFFER-RELEASE().
    END.
  END.
    
  /* Loop through all the Services */
  FOR EACH ttManager 
    WHERE ttManager.cSessionType = pcSessType:
    phbManager:FIND-FIRST("WHERE cSessionType = ":U + QUOTER(pcSessType) +
                           "  AND cManagerName = ":U + QUOTER(ttManager.cManagerName))
      NO-ERROR.
    ERROR-STATUS:ERROR = NO.

    IF NOT phbManager:AVAILABLE THEN
    DO:
      phbManager:BUFFER-CREATE().
      phbManager:BUFFER-FIELD("iOrder":U):BUFFER-VALUE = ?.
      lCreate = YES.
    END.
    ELSE 
      lCreate = NO.
  
    IF lCreate OR plOverwrite THEN
    DO:
      lUpdate = NOT phbManager:BUFFER-COMPARE(BUFFER ttManager:HANDLE,"BINARY":U,"iOrder,lDelete,lUpdated,hHandle,iUniqueID,iCFGOrder,iDBOrder":U).
      IF lUpdate OR lCreate THEN
      DO:
        phbManager:BUFFER-COPY(BUFFER ttManager:HANDLE,"iOrder,lDelete,lUpdated,hHandle,iUniqueID,iCFGOrder":U,"iOrder,iDBOrder":U).
        phbManager:BUFFER-FIELD("lUpdated":U):BUFFER-VALUE = YES.
      END.
      phbManager:BUFFER-FIELD("lDelete":U):BUFFER-VALUE = NO.
      phbManager:BUFFER-RELEASE().
    END.
  END.

  RUN resetOrder(pcSessType, phbService, plOverwrite).
  RUN resetOrder(pcSessType, phbManager, plOverwrite).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetOrder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetOrder Procedure 
PROCEDURE resetOrder :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcSessType  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER phBuffer    AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER plDBOrder   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cQueryString AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hField       AS HANDLE     NO-UNDO.

  cQueryString = "FOR EACH ":U + phBuffer:NAME + " WHERE cSessionType = ":U + QUOTER(pcSessType)
               + " AND iOrder > 0 AND &1 <> ? BY cSessionType BY &1".
  IF plDBOrder THEN
    ASSIGN
      cQueryString = SUBSTITUTE(cQueryString, "iDBOrder":U)
    .
  ELSE
    ASSIGN
      cQueryString = SUBSTITUTE(cQueryString, "iCFGOrder":U)
    .
  
  /* First loop through all records in the incoming buffer and set their orders 
     to ? after storing it to the iCFGOrder field. */
  ghQuery:SET-BUFFERS(phBuffer).
  ghQuery:QUERY-PREPARE(cQueryString).
  ghQuery:QUERY-OPEN().
  ghQuery:GET-FIRST().
  REPEAT WHILE NOT ghQuery:QUERY-OFF-END:
    iCount = iCount + 10.
    phBuffer:BUFFER-FIELD("iOrder":U):BUFFER-VALUE = iCount.
    ghQuery:GET-NEXT().
  END.
  ghQuery:QUERY-CLOSE().

  cQueryString = "FOR EACH ":U + phBuffer:NAME + " WHERE cSessionType = ":U + QUOTER(pcSessType)
             + " AND iOrder > 0 AND &1 = ? BY cSessionType BY &2".
  IF plDBOrder THEN
    ASSIGN
      cQueryString = SUBSTITUTE(cQueryString, "iDBOrder":U, "iCFGOrder":U)
      hField       = phBuffer:BUFFER-FIELD("iCFGOrder")
    .
  ELSE
    ASSIGN
      cQueryString = SUBSTITUTE(cQueryString, "iCFGOrder":U, "iDBOrder":U)
      hField       = phBuffer:BUFFER-FIELD("iDBOrder")
    .
  ghQuery:SET-BUFFERS(phBuffer).
  ghQuery:QUERY-PREPARE(cQueryString).
  ghQuery:QUERY-OPEN().
  ghQuery:GET-FIRST().
  REPEAT WHILE NOT ghQuery:QUERY-OFF-END:
    iCount = hField:BUFFER-VALUE.
    iCount = iCount * 10 + iCount.
    phBuffer:BUFFER-FIELD("iOrder":U):BUFFER-VALUE = iCount.
    ghQuery:GET-NEXT().
  END.
  ghQuery:QUERY-CLOSE().


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-shutdownProc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE shutdownProc Procedure 
PROCEDURE shutdownProc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF VALID-HANDLE(ghQuery) THEN
    DELETE OBJECT ghQuery.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-storeCFGOrder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE storeCFGOrder Procedure 
PROCEDURE storeCFGOrder :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcSessType  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER phBuffer    AS HANDLE     NO-UNDO.

  /* First loop through all records in the incoming buffer and set their orders 
     to ? after storing it to the iCFGOrder field. */
  ghQuery:SET-BUFFERS(phBuffer).
  ghQuery:QUERY-PREPARE("FOR EACH ":U + phBuffer:NAME + " WHERE cSessionType = ":U + QUOTER(pcSessType)
                        + " AND iOrder > 0":U).
  ghQuery:QUERY-OPEN().
  ghQuery:GET-FIRST().
  REPEAT WHILE NOT ghQuery:QUERY-OFF-END:
    phBuffer:BUFFER-FIELD("iCFGOrder":U):BUFFER-VALUE = phBuffer:BUFFER-FIELD("iOrder":U):BUFFER-VALUE.
    phBuffer:BUFFER-FIELD("iOrder":U):BUFFER-VALUE = ?.
    ghQuery:GET-NEXT().
  END.

  ghQuery:QUERY-CLOSE().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getSessionOverrideInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSessionOverrideInfo Procedure 
FUNCTION getSessionOverrideInfo RETURNS CHARACTER
  ( INPUT pcSessType AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Determines what override information is for a particular session
            type.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cOverrideInfo                 AS CHARACTER    NO-UNDO.

  DEFINE VARIABLE lConfigDefault        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lAllowUnregistered      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cPermittedUnregistered  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lRegistered             AS LOGICAL    NO-UNDO.
  
  cOverrideInfo = ?.
  /* Now we need to check the override information for the session 
     types */
  RUN getSessTypeOverrideInfo IN TARGET-PROCEDURE
    (OUTPUT lConfigDefault,
     OUTPUT lAllowUnregistered,
     OUTPUT cPermittedUnregistered).

  /* Now check if this is a registered session type */
  lRegistered = DYNAMIC-FUNCTION("isSessTypeRegistered":U IN TARGET-PROCEDURE,
                                 pcSessType).
  IF NOT lRegistered THEN
  DO:
    IF (lConfigDefault = ? AND
        lAllowUnregistered = ? AND
        cPermittedUnregistered = ?) THEN
      cOverrideInfo = "CFG":U.
    ELSE IF lAllowUnregistered AND
       CAN-DO(cPermittedUnregistered, pcSessType) THEN
      cOverrideInfo = "CFG":U. 
    ELSE
      cOverrideInfo = ?.
  END.
  ELSE
  DO:
    /* getProperty is a PRIVATE call. Do not change this to a DYNAMIC-FUNCTION call */
    cOverrideInfo = getProperty(pcSessType, "configuration_source":U).
    IF cOverrideInfo = ? OR /* If it is ? the property does not exist for the session type - take the default */
       (NOT CAN-DO(cOverrideInfo,"DB":U) AND
        NOT CAN-DO(cOverrideInfo,"CFG":U)) THEN 
    DO:
      IF (lConfigDefault = ? AND
          lAllowUnregistered = ? AND
          cPermittedUnregistered = ?) THEN
        cOverrideInfo = "CFG":U.
      ELSE IF lConfigDefault THEN
        cOverrideInfo = "CFG":U.
      ELSE
        cOverrideInfo = "DB":U.
    END.
  END.
  
  RETURN cOverrideInfo.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isSessTypeRegistered) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isSessTypeRegistered Procedure 
FUNCTION isSessTypeRegistered RETURNS LOGICAL
  ( INPUT pcSessionType AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Determines whether a session type is registered in the repository.
    Notes:  If you call this on the client, it will always return ?. 
            The reason is that on the server we have a cache of all the session
            types. We do not have that cache on the client side.
------------------------------------------------------------------------------*/
    RETURN CAN-FIND(ttSession WHERE ttSession.cSessionType = pcSessionType).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

