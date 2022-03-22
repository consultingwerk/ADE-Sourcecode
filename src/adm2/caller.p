&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************
* Copyright (C) 2000,2008 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
***********************************************************************/
/*---------------------------------------------------------------------------------
  File:         caller.p

  Description:  Dynamic Call Wrapper

  Purpose:      This procedure wraps all the functionality that is required to perform a
                Dynamic Call.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   02/23/2002  Author:     Bruce S Gruenbaum

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
&SCOPED-DEFINE ADMSuper caller.p

/* Custom exclude file */
{src/adm2/custom/callerexclcustom.i}

{src/adm2/globals.i}

DEFINE VARIABLE glICF            AS LOGICAL    NO-UNDO.
DEFINE VARIABLE giCallNo AS INTEGER    NO-UNDO.

DEFINE TEMP-TABLE ttCall NO-UNDO
  FIELD iCallNo        AS INTEGER
  FIELD cCallName      AS CHARACTER
  FIELD iCallType      AS INTEGER
  FIELD lPersistent    AS LOGICAL
  FIELD hInHandle      AS HANDLE
  FIELD hServer        AS HANDLE
  FIELD cReturnValue   AS CHARACTER
  FIELD lAsynch        AS LOGICAL
  FIELD cEventProc     AS CHARACTER
  FIELD hEventProcCtxt AS HANDLE
  FIELD hAsyncReqHndl  AS HANDLE
  FIELD hParamTbl      AS HANDLE
  FIELD hCallHandle    AS HANDLE
  INDEX pudx IS UNIQUE PRIMARY
    iCallNo
  .


/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       caller.p
&scop object-version    000000

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-addExtraFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addExtraFields Procedure 
FUNCTION addExtraFields RETURNS LOGICAL
  ( INPUT phTempTable AS HANDLE,
    INPUT pcRetValDT  AS CHARACTER,
    INPUT pcRetValLabel AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-determineTableType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD determineTableType Procedure 
FUNCTION determineTableType RETURNS INTEGER
  ( INPUT phBuff AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getProcHndl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getProcHndl Procedure 
FUNCTION getProcHndl RETURNS HANDLE
  (INPUT pcFileName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-killProc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD killProc Procedure 
FUNCTION killProc RETURNS LOGICAL
  ( INPUT phProc AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainCallInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD obtainCallInfo Procedure 
FUNCTION obtainCallInfo RETURNS HANDLE
  ( INPUT  piCallNo        AS INTEGER,
    OUTPUT pcReturnValue   AS CHARACTER,
    OUTPUT phParamTbl      AS HANDLE
    )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainInitialValueField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD obtainInitialValueField Procedure 
FUNCTION obtainInitialValueField RETURNS LOGICAL
  ( INPUT pcDataType  AS CHARACTER,
    OUTPUT pcFieldName AS CHARACTER,
    OUTPUT pcParamDT AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainParamPropValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD obtainParamPropValue Procedure 
FUNCTION obtainParamPropValue RETURNS CHARACTER
  ( INPUT-OUTPUT pcProperty AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setupTTFromSig) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setupTTFromSig Procedure 
FUNCTION setupTTFromSig RETURNS HANDLE
  ( INPUT phPersProc    AS HANDLE,
    INPUT pcIntEntry    AS CHARACTER,
    INPUT pcSignature   AS CHARACTER,
    INPUT phInitValueTT AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setupTTFromString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setupTTFromString Procedure 
FUNCTION setupTTFromString RETURNS HANDLE
  ( INPUT pcTableName   AS CHARACTER,
    INPUT pcRetValDT    AS CHARACTER,
    INPUT pcParamString AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setupTTFromTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setupTTFromTable Procedure 
FUNCTION setupTTFromTable RETURNS HANDLE
  ( INPUT pcTableName  AS CHARACTER,
    INPUT pcRetValDT   AS CHARACTER,
    INPUT phParamTable AS HANDLE )  FORWARD.

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
         HEIGHT             = 27.1
         WIDTH              = 49.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/callprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* Make sure there is code here to cleanup. Check with Haavard if I should
   maybe change this. */
ON CLOSE OF THIS-PROCEDURE
DO:
  RUN cleanupProc.
END.

glICF = DYNAMIC-FUNCTION('isICFRunning':U IN THIS-PROCEDURE) NO-ERROR.
IF glICF = ? THEN
  glICF = NO.
ERROR-STATUS:ERROR = NO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-cleanupCall) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cleanupCall Procedure 
PROCEDURE cleanupCall :
/*------------------------------------------------------------------------------
  Purpose:     Deletes a call handle, the associated temp-table, and all data
               in the ttCall temp-table.
  Parameters:  
    piCall    - Integer value containing the number of a call that is contained
                in the ttCall temp-table. This record has previously been
                created by the user using other API calls.

  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER piCall       AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcHandles    AS CHARACTER  NO-UNDO.

  /* If the caller did not provide a list of handles, then assume
     we delete them all */
  IF pcHandles = "":U THEN
    pcHandles = "*":U.
  
  DEFINE VARIABLE hCall AS HANDLE     NO-UNDO.

  DEFINE BUFFER bttCall FOR ttCall.

  DO TRANSACTION:

    FIND FIRST bttCall 
      WHERE bttCall.iCallNo = piCall
      NO-ERROR.
    IF NOT AVAILABLE(bttCall) THEN
      RETURN.
  
    IF CAN-DO(pcHandles,"A":U) AND
       VALID-HANDLE(bttCall.hAsyncReqHndl) THEN
      DELETE OBJECT bttCall.hAsyncReqHndl.

    IF CAN-DO(pcHandles,"T":U) AND
       VALID-HANDLE(bttCall.hParamTbl) THEN
      DELETE OBJECT bttCall.hParamTbl.
  
    IF CAN-DO(pcHandles,"H":U) AND
       VALID-HANDLE(bttCall.hCallHandle) THEN
      DELETE OBJECT bttCall.hCallHandle.
  
    DELETE bttCall.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cleanupProc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cleanupProc Procedure 
PROCEDURE cleanupProc :
/*------------------------------------------------------------------------------
  Purpose:     Cleans up any leftover handles and deletes any unused objects
               and then destroys itself.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Delete this procedure */
  DELETE PROCEDURE THIS-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-invokeCall) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE invokeCall Procedure 
PROCEDURE invokeCall :
/*------------------------------------------------------------------------------
  Purpose:     This procedure actually makes the call to the procedure that
               has been requested.
  Parameters:  
    piCall    - Integer value containing the number of a call that is contained
                in the ttCall temp-table. This record has previously been
                created by the user using other API calls.
                
    phOutTT   - Handle to the temp-table that contains the parameter values
                after the call has executed.
                                
  Notes:
      This procedure assumes that a call has already been setup in the ttCall
      temp-table and that the dynamic temp-table required to make the call was
      previously set up.       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcProc          AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER phInHandle      AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER piType          AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER phParamTable    AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER plPersistent    AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER phServer        AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER plAsynch        AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcEventProc     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER phEventProcCtxt AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER piCall          AS INTEGER    NO-UNDO.

  DEFINE VARIABLE hCall     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTTBuff   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCount    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lSuccess  AS LOGICAL    NO-UNDO.

  DEFINE BUFFER bttCall FOR ttCall.

  giCallNo = giCallNo + 1.

  /* Set up the call record */
  DO TRANSACTION:
    CREATE bttCall.
    ASSIGN 
      bttCall.iCallNo         = giCallNo 
      bttCall.cCallName       = pcProc
      bttCall.hInHandle       = phInHandle
      bttCall.iCallType       = piType
      bttCall.hParamTbl       = phParamTable
      bttCall.lPersistent     = plPersistent   
      bttCall.hServer         = phServer       
      bttCall.lAsynch         = plAsynch       
      bttCall.cEventProc      = pcEventProc    
      bttCall.hEventProcCtxt  = phEventProcCtxt
      piCall                  = giCallNo
    .
  END.

  /* Create a call object and set all the attributes */
  CREATE CALL hCall.
  hCall:CALL-NAME = bttCall.cCallName.
  hCall:CALL-TYPE = bttCall.iCallType.

  /* Do we need to invoke this procedure persistently? */
  IF bttCall.lPersistent = YES THEN
    hCall:PERSISTENT = YES.

  /* If the hInHandle property is a valid handle, we need to run this
     call in a persistent procedure */
  IF VALID-HANDLE(bttCall.hInHandle) THEN
    hCall:IN-HANDLE = bttCall.hInHandle.

  /* If the server handle is set, we need to run this call on the appropriate
     server. */
  IF VALID-HANDLE(bttCall.hServer) THEN
    hCall:SERVER = bttCall.hServer.

  /* The rest of the attributes only apply when an asynch call is made */
  IF bttCall.lAsynch = YES THEN
  DO:
    /* Set the ASYNCH attribute */
    hCall:ASYNCHRONOUS = YES.
    IF bttCall.cEventProc <> ? AND 
       bttCall.cEventProc <> "" THEN
    DO:
      /* Set the event procedure to be invoked and the appropriate handle
         to invoke it in. */
      hCall:EVENT-PROCEDURE = bttCall.cEventProc.
      IF VALID-HANDLE(bttCall.hEventProcCtxt) THEN
        hCall:EVENT-PROCEDURE-CONTEXT = bttCall.hEventProcCtxt.
    END.
  END.

  /* Set up the parameters. If the parameter temp-table handle is invalid, there
     are no parameters. */
  hTTBuff = ?.
  IF VALID-HANDLE(bttCall.hParamTbl) THEN
  DO:
    /* Obtain the handle to the default buffer for the temp-table */
    hTTBuff = bttCall.hParamTbl:DEFAULT-BUFFER-HANDLE.

    /* If the users used setupTempTable to create the temp-table, and they then
       populated the temp-table parameters with something other than the defaults,
       we may have a record in the temp-table already. If we don't, we can just
       create one here because the initial value of the temp-table field will
       give us the appropriate values. There should only ever be one record in
       the temp-table. */

    /* Find the first (and only) record in the temp-table */
    hTTBuff:FIND-FIRST() NO-ERROR.
    ERROR-STATUS:ERROR = NO.

    /* If we don't have a record in the temp-table, create one */
    IF NOT hTTBuff:AVAILABLE THEN
      hTTBuff:BUFFER-CREATE().

    /* For both of the next two statements, we only go to the second last field
       because the last field contains the return value. */
    hCall:NUM-PARAMETERS = hTTBuff:NUM-FIELDS - 2.

    /* Loop through the fields in the temp-table buffer and set the parameter
       for each of them. */
    IF hCall:NUM-PARAMETERS > 0 THEN
    DO iCount = 1 TO hTTBuff:NUM-FIELDS - 2:

      /* Get a handle to the field. */ 
      hField    = hTTBuff:BUFFER-FIELD(iCount).

      /* Now set the parameter using this field */
      hCall:SET-PARAMETER(iCount,                             /* Parameter number */
                          ENTRY(1,hField:COLUMN-LABEL,"|":U), /* Data type */
                          ENTRY(2,hField:COLUMN-LABEL,"|":U), /* IOMode    */
                          hField:BUFFER-VALUE).               /* Field containing value */

    END. /* DO iCount = 1 TO hTTBuff:NUM-FIELDS - 2 */
  END.   /*   IF VALID-HANDLE(bttCall.hParamTbl) */

  /* Reset the error status and return values */
  ERROR-STATUS:ERROR = NO.
  RETURN-VALUE = "":U.
  lSuccess = YES.

  /* Now invoke the call */
  DO ON STOP UNDO, LEAVE:
  hCall:INVOKE NO-ERROR.
  END.

  /* If there is an error, build up a string containing the error and
     put it in the bttCall.cReturnValue and errReturnValue field on the
     dynamic temp-table */
  IF ERROR-STATUS:ERROR THEN
  DO:
    ASSIGN
      bttCall.cReturnValue  = "RETURN-VALUE=" + RETURN-VALUE
    .
    DO iCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
      bttCall.cReturnValue = bttCall.cReturnValue + CHR(10)
                           + ERROR-STATUS:GET-MESSAGE(iCount).
    END.

    IF VALID-HANDLE(hTTBuff) AND
       hTTBuff:AVAILABLE THEN
    DO:
      hField = hTTBuff:BUFFER-FIELD("errReturnValue":U).
      hField:BUFFER-VALUE = bttCall.cReturnValue.
    END.

    DELETE OBJECT hCall.

    RETURN.

  END. /* IF ERROR-STATUS:ERROR */

  IF VALID-HANDLE(hTTBuff) AND
     hTTBuff:AVAILABLE THEN
  DO:
    hField = hTTBuff:BUFFER-FIELD("callReturnValue":U).
    IF hCall:CALL-TYPE = PROCEDURE-CALL-TYPE THEN
      hField:BUFFER-VALUE = RETURN-VALUE.
    ELSE
      hField:BUFFER-VALUE = hCall:RETURN-VALUE.
    hTTBuff:BUFFER-RELEASE().
  END.

  DO TRANSACTION:
    ASSIGN
      bttCall.hAsyncReqHndl = hCall:ASYNC-REQUEST-HANDLE
      bttCall.hCallHandle   = hCall
    .
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainProcHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtainProcHandle Procedure 
PROCEDURE obtainProcHandle :
/*------------------------------------------------------------------------------
  Purpose:     Obtains the handle to the procedure that something should be 
               run in.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcTarget      AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcTargetFlags AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER phProc        AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER plKill        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lExisting             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lNewInst              AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lADM2                 AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hAppServer            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cError                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount                AS INTEGER    NO-UNDO.

  DEFINE VARIABLE hPreProc              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hPostProc             AS HANDLE     NO-UNDO.

  DEFINE VARIABLE hProc AS HANDLE     NO-UNDO.

  lExisting = INDEX(pcTargetFlags, "S":U) > 0.
  lNewInst  = INDEX(pcTargetFlags, "P":U) > 0.
  lADM2     = INDEX(pcTargetFlags, "A":U) > 0.

  /* lExisting and lNewInst are mutually exclusive, but they use different input parameters.
     lExisting is the only one we will use below so we need to make sure it is set properly.
     The only case that causes a conflict is if lExisting and lNewInst are both set to yes.
     If they are, we set lExisting to no which means that we will launch a new instance 
     In all other cases, lExisting will be set appropriately:
     lExisting    lNewInst
     NO           YES       Launch new instance
     YES          NO        Run existing
     NO           NO        Launch new ADM2 instance */
  IF lExisting AND
     lNewInst THEN
    ASSIGN
      lExisting = NO
    .
 
  /* Make sure we know whether we need to kill this procedure or not */
  plKill = INDEX(pcTargetFlags, "K":U) > 0.
  pcTargetFlags = REPLACE(pcTargetFlags, "K":U, "":U).

  /* Check whether Dynamics is running. This is here for Dynamics performance.
     The possibility exists that the caller.p procedure was initialized before
     the Dynamics session had been properly started. If that is the case,
     the Dynamics session may now be initialized and we need to verify that. */
  IF NOT glICF THEN
  DO:
    glICF = DYNAMIC-FUNCTION('isICFRunning':U IN THIS-PROCEDURE) NO-ERROR.
    IF glICF = ? THEN
      glICF = NO.
    ERROR-STATUS:ERROR = NO.
  END.


  /* If Dynamics is running, use the dynamics algorithms to start this procedure */
  IF glICF THEN
  DO:
    
    /* First lets try and get a manager handle */
    phProc = DYNAMIC-FUNCTION("getManagerHandle":U IN THIS-PROCEDURE,
                             pcTarget).

    
    /* If the handle is unknown, this is not a manager.
       Let's try and launch this procedure via the Session Manager. */
    IF NOT VALID-HANDLE(phProc) THEN
    DO:
      /* Try and get a handle to the procedure before calling launchProcedure */
      hPreProc = DYNAMIC-FUNCTION("getProcedureHandle":U IN THIS-PROCEDURE,
                                  pcTarget).
      RETURN-VALUE = "":U.
      ERROR-STATUS:ERROR = NO.
      RUN launchProcedure IN gshSessionManager
        (pcTarget,
         lExisting,
         "NO":U,
         "":U,
         NOT plKill,
         OUTPUT phProc).
      IF RETURN-VALUE <> "":U AND
         RETURN-VALUE <> ? THEN
        RETURN RETURN-VALUE.
      
      /* Try and get a handle to the procedure after calling launchProcedure */
      hPostProc = DYNAMIC-FUNCTION("getProcedureHandle":U IN THIS-PROCEDURE,
                                   pcTarget).

      /* If we need to use an existing procedure, and the handle that we have
         in pre and post proc handles match, we need to prevent the call wrapper
         from shutting this down. */
      IF lExisting AND
         hPreProc <> ? AND
         hPostProc <> ? AND
         hPreProc = hPostProc THEN
        plKill = NO.
    END.
    ELSE
      IF lExisting THEN
        plKill = NO.

  END.

  /* This is here in case Dynamics is not running. If Dynamics is running,
     the procedure should already be running. */
  IF NOT VALID-HANDLE(phProc) THEN
  DO:
    /* Try an obtain a handle to the procedure */
    IF lExisting THEN
      phProc = getProcHndl(pcTarget).

    /* Kill must be switched off the procedure was already running */
    IF VALID-HANDLE(phProc) THEN
      plKill = NO.

    /* If the procedure is still not running, try and run it. */
    IF NOT VALID-HANDLE(phProc) THEN
    DO:
      ERROR-STATUS:ERROR = NO.
      RETURN-VALUE = "":U.
      RUN VALUE(pcTarget) PERSISTENT SET phProc NO-ERROR.
      IF NOT VALID-HANDLE(phProc) OR
         ERROR-STATUS:ERROR OR 
         RETURN-VALUE <> "":U THEN
      DO:
        cError = SUBSTITUTE("UNABLE TO START PROCEDURE &1.", pcTarget).
        IF RETURN-VALUE <> "":U AND
           RETURN-VALUE <> ? THEN
          cError = cError + CHR(10) + RETURN-VALUE.
        IF ERROR-STATUS:NUM-MESSAGES > 0 THEN
        DO iCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
          cError = cError + CHR(10) + ERROR-STATUS:GET-MESSAGE(iCount).
        END.
        RETURN cError.
      END.

       /* At this point we have started a new persistent procedure. We now
          need to initialize the procedure if it is an ADM2 procedure */
      IF lADM2 THEN
        RUN initializeObject IN phProc.

    END.  /* IF NOT VALID-HANDLE(phProc) */
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPropertiesFromTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setPropertiesFromTable Procedure 
PROCEDURE setPropertiesFromTable :
/*------------------------------------------------------------------------------
  Purpose:     Takes a temp-table and finds all the parameters that are 
               properties and sets either properties, or session parameters
               from them as appropriate.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phTable AS HANDLE     NO-UNDO.

  DEFINE VARIABLE hBuffer         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCount          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cPrefix         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProperty       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMode           AS CHARACTER  NO-UNDO.

  hBuffer = phTable:DEFAULT-BUFFER-HANDLE.

  /* If there are no records in the temp-table there's no point trying
     to set anything */
  IF NOT phTable:HAS-RECORDS THEN
    RETURN.

  hBuffer:FIND-FIRST().

  /* Loop through all the fields in the table */
  DO iCount = 1 TO hBuffer:NUM-FIELDS:
    hField = hBuffer:BUFFER-FIELD(iCount).
    IF NUM-ENTRIES(hField:COLUMN-LABEL,"|":U) > 1 THEN
      cMode  = ENTRY(2,hField:COLUMN-LABEL,"|":U).
    IF CAN-DO("INPUT-OUTPUT,OUTPUT,OUTPUT-APPEND,RETURN":U, cMode) AND
       hField:LABEL <> hField:NAME THEN
    DO:
      cPrefix = SUBSTRING(hField:LABEL,1,2).
      cProperty = SUBSTRING(hField:LABEL,3).
      CASE cPrefix:
        WHEN "S:":U THEN
        DO:
          DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                           cProperty,
                           STRING(hField:BUFFER-VALUE)) NO-ERROR.
          ERROR-STATUS:ERROR = NO.
        END.
        WHEN "P:":U THEN
        DO:
          DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
                           cProperty,
                           STRING(hField:BUFFER-VALUE),
                           NO) NO-ERROR.
          ERROR-STATUS:ERROR = NO.
        END.
      END CASE.
    END /* IF hField:LABEL <> hField:NAME */.
  END. /* DO iCount = 1 TO hBuffer:NUM-FIELDS */

  hBuffer:BUFFER-RELEASE().


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setupCallProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setupCallProcedure Procedure 
PROCEDURE setupCallProcedure :
/*------------------------------------------------------------------------------
  Purpose:     Sets up the persistent procedure that we will be calling into 
               for a particular call.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcCallName      AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcTarget        AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcTargetFlags   AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER phProc          AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER plKill          AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER piCallType      AS INTEGER    NO-UNDO.

  DEFINE VARIABLE cSignature AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessage   AS CHARACTER  NO-UNDO.

  /* obtainProcHandle will run the procedure persistently if it is not
     running */
  RUN obtainProcHandle(pcTarget, pcTargetFlags, OUTPUT phProc, OUTPUT plKill).

  /* If the handle is invalid after obtainProcHandle there's a problem */
  IF NOT VALID-HANDLE(phProc) THEN
    RETURN RETURN-VALUE.

  /* If the internal entries do not contain the call we're planning to make, 
     return an error */
  IF NOT CAN-DO(phProc:INTERNAL-ENTRIES, pcCallName)  THEN
  DO:
    cMessage = SUBSTITUTE("INVALID PROCEDURE CALL IN &1", phProc:FILE-NAME).
    IF plKill THEN
      killProc(phProc).
    RETURN cMessage.
  END.

  /* Determine the call type from the signature */
  cSignature = ENTRY(1,phProc:GET-SIGNATURE(pcCallName)).
  CASE cSignature:
    WHEN "PROCEDURE":U THEN
      piCallType = PROCEDURE-CALL-TYPE.
    WHEN "FUNCTION":U THEN
      piCallType = FUNCTION-CALL-TYPE.
    OTHERWISE
    DO:
      cMessage = SUBSTITUTE("INVALID PROCEDURE CALL TYPE &1 IN &2" ,cSignature, phProc:FILE-NAME).
      IF plKill THEN
        killProc(phProc).
      RETURN cMessage.
    END.
  END CASE.
    
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setValuesInTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setValuesInTable Procedure 
PROCEDURE setValuesInTable :
/*------------------------------------------------------------------------------
  Purpose:     This procedure loops through a table of type 1 thru 4 and
               scans the constructed temp-table record for the value of the
               field and assigns it to the return value.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phCallTable  AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER phInputTable AS HANDLE     NO-UNDO.

  DEFINE VARIABLE hCallBuff       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hInputBuff      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iTableType      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hField          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cMode           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataType       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWhereClause    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cStorageDT      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cStorageField   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount          AS INTEGER    NO-UNDO.

  hCallBuff  = phCallTable:DEFAULT-BUFFER-HANDLE.
  hInputBuff = phInputTable:DEFAULT-BUFFER-HANDLE.

  /* How we process from here depends on the type of table that the caller 
     sent in */
  iTableType = determineTableType(phInputTable).

  IF iTableType = ? OR
     (iTableType < 1 AND
      iTableType > 4) THEN
    RETURN. /* Table type of caller not valid for this procedure */

  /* Find the first record in the call table. */
  IF phCallTable:HAS-RECORDS THEN
    hCallBuff:FIND-FIRST().

  /* Now we need to loop through all the fields in the buffer */
  DO iCount = 1 TO hCallBuff:NUM-FIELDS:

    /* Get a handle to the field */
    hField = hCallBuff:BUFFER-FIELD(iCount).

    /* If this is a BUFFER or a TABLE-HANDLE that has to be mapped
       to something one of the TABLE-HANDLEs in the array, skip it */
    IF hField:NAME <> hField:LABEL AND
       (SUBSTRING(hField:LABEL,1,2) = "T:":U OR
        SUBSTRING(hField:LABEL,1,2) = "B:":U) THEN
      NEXT.

    /* Determine what the mode of the parameter is */
    IF NUM-ENTRIES(hField:COLUMN-LABEL,"|":U) > 1 THEN
      cMode  = ENTRY(2,hField:COLUMN-LABEL,"|":U).

    /* If this parameter is one that has to go back to the client, 
       we need to assign the value to the appropriate field in the 
       appropriate record in the temp-table */
    IF CAN-DO("INPUT-OUTPUT,OUTPUT,OUTPUT-APPEND,RETURN":U, cMode) THEN
    DO:
      /* Build up the find statement where clause that will find a
         record in the temp-table that we can assign the value to */
      cWhereClause = "":U.
      CASE iTableType:
        WHEN 1 OR
        WHEN 2 THEN
          cWhereClause = "WHERE iParamNo = ":U + STRING(iCount).
        WHEN 3 OR
        WHEN 4 THEN
          cWhereClause = "WHERE cParamName = ":U + TRIM(QUOTER(hField:NAME)).
      END CASE.

      /* Try and find a record in the temp table that matches the where 
         criteria */
      hInputBuff:FIND-UNIQUE(cWhereClause) NO-ERROR.
      ERROR-STATUS:ERROR = NO.

      /* It's possible that there is no record in the temp-table for,
         for example, the errReturnValue or callReturnValue records */
      IF NOT hInputBuff:AVAILABLE THEN
      DO:
        /* Create a record if it does not exist */
        hInputBuff:BUFFER-CREATE().

        /* cParamName exists on all table types */
        hInputBuff:BUFFER-FIELD("cParamName":U):BUFFER-VALUE = hField:NAME.

        /* If the table type is 1 or 2 there are three extra fields that
           exist in both */
        IF iTableType = 1 OR 
           iTableType = 2 THEN
        DO:
          hInputBuff:BUFFER-FIELD("iParamNo":U):BUFFER-VALUE = iCount.
          hInputBuff:BUFFER-FIELD("cDataType":U):BUFFER-VALUE = ENTRY(1,hField:COLUMN-LABEL,"|":U).
          hInputBuff:BUFFER-FIELD("cIOMode":U):BUFFER-VALUE = ENTRY(2,hField:COLUMN-LABEL,"|":U).
        END.
      END.

      /* Now we need to deal with assigning the value in the temp-table to the
         appropriate field on the record */
      CASE iTableType:
        WHEN 1 OR
        WHEN 3 THEN
        DO:
          obtainInitialValueField(ENTRY(1,hField:COLUMN-LABEL,"|":U), OUTPUT cStorageField, OUTPUT cStorageDT).
          hInputBuff:BUFFER-FIELD(cStorageField):BUFFER-VALUE = hField:BUFFER-VALUE.
        END.
        WHEN 2 OR
        WHEN 4 THEN
        DO:
          hInputBuff:BUFFER-FIELD("cValue":U):BUFFER-VALUE = hField:BUFFER-VALUE.
        END.
      END CASE.

      /* Release the buffer for the record in the user table */
      hInputBuff:BUFFER-RELEASE().

    END. /* IF CAN-DO("INPUT-OUTPUT,OUTPUT,OUTPUT-APPEND":U, cMode) */
  END. /* DO iCount = 1 TO hCallBuff:NUM-FIELDS */

  hCallBuff:BUFFER-RELEASE().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-addExtraFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addExtraFields Procedure 
FUNCTION addExtraFields RETURNS LOGICAL
  ( INPUT phTempTable AS HANDLE,
    INPUT pcRetValDT  AS CHARACTER,
    INPUT pcRetValLabel AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Adds the extra fields into the temp-table for the call and error
            return values.
    Notes:  
------------------------------------------------------------------------------*/

  IF pcRetValLabel = "":U THEN
    pcRetValLabel = "callReturnValue":U.

  IF pcRetValDT = ? OR
     pcRetValDT = "":U THEN
    pcRetValDT = "CHARACTER":U.

  /* Now we need to add a field for the return value. */
  phTempTable:ADD-NEW-FIELD("callReturnValue":U,         /* field name */
                             pcRetValDT,                 /* data type */
                             0,                           /* extent */
                             ?,                           /* format */
                             ?,                           /* initial value */
                             pcRetValLabel,               /* label */
                             pcRetValDT + "|RETURN":U ).  /* column-label */

  /* Now we need to add a field for the error return value. */
  phTempTable:ADD-NEW-FIELD("errReturnValue":U,         /* field name */
                             "CHARACTER":U,             /* data type */
                             0,                         /* extent */
                             ?,                         /* format */
                             ?,                         /* initial value */
                             "errReturnValue":U,        /* label */
                             "CHARACTER|RETURN":U ).    /* column-label */


  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-determineTableType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION determineTableType Procedure 
FUNCTION determineTableType RETURNS INTEGER
  ( INPUT phBuff AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose:  Determines if the type of the table that is received as an input 
            parameter. This type is matched to one of the types in 
            src/adm2/calltables.i
    Notes:  
      If the handle is invalid, we assume that there are no parameters and
      zero is returned. We also return zero if the table is empty.
      
      If the table type is not recognized, the unknown value is returned.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hField1 AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField2 AS HANDLE     NO-UNDO.

  /* If the handle is invalid, assume there are no parameters and return 0 */
  IF NOT VALID-HANDLE(phBuff) THEN
    RETURN ?.

  /* If we were given the handle to the temp-table instead of the handle
     to the buffer, just get the handle to the buffer */
  IF phBuff:TYPE = "TEMP-TABLE":U THEN
     phBuff = phBuff:DEFAULT-BUFFER-HANDLE.

  /* Sanity check. There must be a field in here otherwise it's an unrecognized
     temp-table */
  IF phBuff:NUM-FIELDS < 1 THEN
    RETURN ?.

  /* This may be a temp-table that has previously been created using one of
     the setupTTFrom... functions. */
  IF phBuff:BUFFER-FIELD(phBuff:NUM-FIELDS):NAME = "":U AND
     phBuff:NUM-FIELDS > 2 AND
     phBuff:BUFFER-FIELD(phBuff:NUM-FIELDS - 1):NAME = "":U THEN
    RETURN 99. /* 99 indicates a table that has already been formatted */
  ELSE IF NOT phBuff:TABLE-HANDLE:HAS-RECORDS THEN
    RETURN 0. /* If the temp-table is empty then return 0 */


  CASE phBuff:BUFFER-FIELD(1):NAME:
    WHEN "iParamNo":U THEN   /* If the first field is iParamNo it's type 1 or 2 */
    DO:
      IF phBuff:NUM-FIELDS >= 5 THEN   /* We need to check the name of the 5th field */
      CASE phBuff:BUFFER-FIELD(5):NAME:
        WHEN "cCharacter":U THEN
          RETURN 1.
        WHEN "cValue":U THEN
          RETURN 2.
      END.
    END.
    WHEN "cParamName":U THEN /* If the first field is cParamName it's type 3 or 4 */
    DO:
      IF phBuff:NUM-FIELDS >= 2 THEN    /* We need to check the name of the 2nd field */
      CASE phBuff:BUFFER-FIELD(2):NAME: 
        WHEN "cCharacter":U THEN
          RETURN 3.
        WHEN "cValue":U THEN
          RETURN 4.
      END.
    END.
  END.

  /* If we have not returned by this point, we will return
     the unknown value because we do not know the type of the table. */
  RETURN ?.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getProcHndl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getProcHndl Procedure 
FUNCTION getProcHndl RETURNS HANDLE
  (INPUT pcFileName AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Determines the handle to a running procedure (if it is running) and 
            returns the handle or ? if the handle cannot be determined.
    Notes:  This function assumes that there is only one running copy of the
            procedure.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hProc     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFullPath AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRCode    AS CHARACTER  NO-UNDO.
  
  cFullPath = SEARCH(pcFileName).

  IF SUBSTRING(pcFileName,LENGTH(pcFileName) - 2,1) = ".":U THEN
    cRCode = SUBSTRING(pcFileName,1,LENGTH(pcFileName) - 2).
  ELSE
    cRCode = pcFileName.
   
  cRCode = SEARCH(cRCode + ".r":U).

  IF cFullPath = ? THEN
    cFullPath = "":U.
  IF cRCode = ? THEN
    cRCode = "":U.

  hProc = SESSION:FIRST-PROCEDURE.

  DO WHILE VALID-HANDLE(hProc):
    IF hProc:FILE-NAME = pcFileName OR
       hProc:FILE-NAME = cFullPath OR
       hProc:FILE-NAME = cRCode THEN
      RETURN hProc.
    hProc = hProc:NEXT-SIBLING.
  END.

  RETURN ?.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-killProc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION killProc Procedure 
FUNCTION killProc RETURNS LOGICAL
  ( INPUT phProc AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Gets rid of a persistent procedure in a clean way if possible,
            otherwise just deletes it.
    Notes:  
------------------------------------------------------------------------------*/
  
  /* All well behaved persistent procedures have an CLOSE event trap */
  APPLY "CLOSE":U TO phProc.

  /* For ADM2, if ON CLOSE was deleted, run destroyObject */
  IF VALID-HANDLE(phProc) AND
    CAN-DO(phProc:INTERNAL-ENTRIES, "destroyObject":U) THEN
   RUN destroyObject IN phProc NO-ERROR.

  /* If it is a PLIP, try and run plipShutdown */
  IF VALID-HANDLE(phProc) AND
     CAN-DO(phProc:INTERNAL-ENTRIES, "plipShutdown":U) THEN
    RUN plipShutDown IN phProc NO-ERROR.

  /* Last resort -- delete the procedure */
  IF VALID-HANDLE(phProc) THEN
    DELETE PROCEDURE phProc.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainCallInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION obtainCallInfo Procedure 
FUNCTION obtainCallInfo RETURNS HANDLE
  ( INPUT  piCallNo        AS INTEGER,
    OUTPUT pcReturnValue   AS CHARACTER,
    OUTPUT phParamTbl      AS HANDLE
    ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns information about a call
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCall AS HANDLE     NO-UNDO.

  DEFINE BUFFER bttCall FOR ttCall.

  /* Find the call in question */
  FIND FIRST bttCall NO-LOCK
    WHERE bttCall.iCallNo = piCallNo
    NO-ERROR.

  /* If the call record is not available, set the values to blank and unknown,
     otherwise set them to their appropriate values. */
  IF NOT AVAILABLE(bttCall) THEN
    ASSIGN
      pcReturnValue = "":U
      phParamTbl    = ?
      hCall         = ?
    .
  ELSE
    ASSIGN
      pcReturnValue = bttCall.cReturnValue
      phParamTbl    = bttCall.hParamTbl
      hCall         = bttCall.hCallHandle
    .

  RETURN hCall.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainInitialValueField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION obtainInitialValueField Procedure 
FUNCTION obtainInitialValueField RETURNS LOGICAL
  ( INPUT pcDataType  AS CHARACTER,
    OUTPUT pcFieldName AS CHARACTER,
    OUTPUT pcParamDT AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Accepts a data type and returns the name of the field that should 
            be used to derive the initial value, and the data type that should 
            be used to store the input and output values.
    Notes:  
------------------------------------------------------------------------------*/
  CASE pcDataType:
    WHEN "CHARACTER":U THEN
      ASSIGN
        pcParamDT   = pcDataType
        pcFieldName = "cCharacter":U
      .
    WHEN "DATE":U THEN
      ASSIGN
        pcParamDT   = pcDataType
        pcFieldName = "tDate":U
      .
    WHEN "LOGICAL":U THEN
      ASSIGN
        pcParamDT   = pcDataType
        pcFieldName = "lLogical":U
      .
    WHEN "INTEGER":U THEN
      ASSIGN
        pcParamDT   = pcDataType
        pcFieldName = "iInteger":U
      .
    WHEN "DECIMAL":U THEN
      ASSIGN
        pcParamDT   = pcDataType
        pcFieldName = "dDecimal":U
      .
    WHEN "HANDLE":U THEN
      ASSIGN
        pcParamDT   = pcDataType
        pcFieldName = "hHandle":U
      .
    WHEN "TABLE-HANDLE":U THEN
      ASSIGN
        pcParamDT   = "HANDLE":U
        pcFieldName = "hHandle":U
      .
  END.
    
  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainParamPropValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION obtainParamPropValue Procedure 
FUNCTION obtainParamPropValue RETURNS CHARACTER
  ( INPUT-OUTPUT pcProperty AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  This field obtains the value of a session parameter or property
            to invoke the call.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRetVal AS CHARACTER  NO-UNDO.

  IF NOT glICF THEN
    RETURN ?.

  cRetVal = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                             pcProperty,
                             NO).
  IF cRetVal = ? THEN
  DO:
    cRetVal = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                               pcProperty).
    IF cRetVal <> ? THEN
       pcProperty = "S:":U + pcProperty.
  END.
  ELSE
    pcProperty = "P:":U + pcProperty.

  IF cRetVal = ? THEN
     pcProperty = "P:":U + pcProperty.

  RETURN cRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setupTTFromSig) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setupTTFromSig Procedure 
FUNCTION setupTTFromSig RETURNS HANDLE
  ( INPUT phPersProc    AS HANDLE,
    INPUT pcIntEntry    AS CHARACTER,
    INPUT pcSignature   AS CHARACTER,
    INPUT phInitValueTT AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose:  Creates the dynamic temp-table from the signature  of the procedure 
            being called.
    Notes:  This function accepts a table type 3 or 4. The table is optional.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hTempTable   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cTTDataType  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cField       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hField       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTTCallParam AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCount       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCount2      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iTableType   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cFieldName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTableName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRetValDT    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParamString AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParamLabel  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParamMode   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParamName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParamDT     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEntry2      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lFail        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cInitValue   AS CHARACTER  NO-UNDO.

  /* If nothing was specified in pcSignature, we need to get the signature from
     the internal entries */
  IF pcSignature = "":U OR
     pcSignature = ? THEN
  DO:
    IF VALID-HANDLE(phPersProc) AND
       CAN-DO(phPersProc:INTERNAL-ENTRIES, pcIntEntry) THEN
      pcSignature = phPersProc:GET-SIGNATURE(pcIntEntry).
    ELSE
      /* If we don't have a procedure there's nothing we can do */
      RETURN ?.
  END.

  /* We can only support procedures and functions here. The problem is that 
     there are data types that we will not do conversions for at this point. */
  CASE ENTRY(1,pcSignature): 
    WHEN "PROCEDURE":U THEN
      cTableName = "P_":U + pcIntEntry.
    WHEN "FUNCTION":U THEN
      cTableName = "F_":U + pcIntEntry.
    OTHERWISE 
      RETURN ?.
  END.

  /* Set up the return value data type. */
  cRetValDT = ENTRY(2,pcSignature).
  IF cRetValDT = "":U OR /* in the case of a procedure */
     cRetValDT = ? THEN 
    cRetValDT = "CHARACTER":U.

  /* Make sure that the table that was passed in is a valid table type
     if there is one. */
  IF VALID-HANDLE(phInitValueTT) THEN
  DO:
    /* Figure out what type of table we have */
    iTableType = determineTableType(phInitValueTT).
  
    /* If the table type is not valid for this function call, return the 
       unknown value */
    IF iTableType <> ? AND
       iTableType <> 3 AND
       iTableType <> 4 THEN
      RETURN ?.

    /* phInitValueTT is valid and could be either a TEMP-TABLE or a BUFFER.
       If not, the call to determineTableType would have failed earlier */
    IF VALID-HANDLE(phInitValueTT) AND
       phInitValueTT:TYPE = "TEMP-TABLE":U THEN
      hBuffer = phInitValueTT:DEFAULT-BUFFER-HANDLE.
    ELSE
      hBuffer = phInitValueTT.
  END.

  /* First we create a temp-table object */
  CREATE TEMP-TABLE hTempTable.

  /* Now we loop through all the parameters in the signature */
  IF NUM-ENTRIES(pcSignature) > 2 THEN
  REPEAT iCount = 3 TO NUM-ENTRIES(pcSignature):
    cParamName  = "":U.
    cParamLabel = "":U.

    /* get the next parameter set */
    cParamString  = ENTRY(iCount, pcSignature).

    /* First item in the space delimited list should be the mode. */
    cParamMode    = ENTRY(1, cParamString, " ":U).

    /* If we have a buffer here, we can't deal with it. BUFFERs don't 
       work with Dynamic Call */
    IF cParamMode = "BUFFER":U THEN
    DO:
      lFail = YES.
      LEAVE.
    END.

    /* Let's check entry 2 */
    cEntry2 = ENTRY(2, cParamString, " ":U).

    IF cEntry2 = "TABLE":U OR              
       cEntry2 = "TABLE-HANDLE":U THEN  /* Make the data type TABLE-HANDLE */
      ASSIGN
        cParamName    = ENTRY(3, cParamString, " ":U)
        cParamDT      = "TABLE-HANDLE":U
      .
    ELSE 
      ASSIGN
        cParamName    = ENTRY(2, cParamString, " ":U)
        cParamDT      = ENTRY(3, cParamString, " ":U)
      .

    /* We can't deal with MEMPTRs either */
    IF cParamDT = "MEMPTR":U THEN
    DO:
      lFail = YES.
      LEAVE.
    END.

    /* Make sure that we derive initial values from the correct field */
    obtainInitialValueField(cParamDT, OUTPUT cField, OUTPUT cTTDataType).

    /* If the table type is 4 then the only field to contain the value is cValue. */
    IF iTableType = 4 THEN
      cField = "cValue":U.

    /* Now we need to get the value of the parameter from the temp-table
       if it was provided. */
    IF VALID-HANDLE(hBuffer) THEN
    DO:
      hBuffer:FIND-UNIQUE("WHERE cParamName = '" + cParamName + "'", NO-LOCK) NO-ERROR.
      IF ERROR-STATUS:ERROR OR
         ERROR-STATUS:NUM-MESSAGES <> 0 THEN
        ERROR-STATUS:ERROR = NO.

      IF hBuffer:AVAILABLE THEN
      DO:
        /* Get the handle to the field that contains the initial value */
        cInitValue = STRING(hBuffer:HANDLE:BUFFER-FIELD(cField):BUFFER-VALUE).
      END.
    END.
    ELSE
    DO:
      cInitValue = "":U.
    END.

    /* This caters for getting the value of a handle from the caller where the
       expression contains the handle to a temp-table or buffer that was passed
       in for temp-table call */
    IF cTTDataType = "HANDLE":U AND
       LENGTH(cInitValue) = 4 AND
       NUM-ENTRIES(cInitValue, ":") = 2 AND
       (ENTRY(1,cInitValue, ":") = "T":U OR
        ENTRY(1,cInitValue, ":") = "B":U) THEN
    DO:
      cParamLabel = cInitValue.
      cInitValue = STRING(DYNAMIC-FUNCTION("getHandleParam":U IN TARGET-PROCEDURE,
                                           ENTRY(1,cInitValue,":":U),
                                           INTEGER(ENTRY(2,cInitValue,":":U)))).
    END.

    /* Parameter label contains parameter name unless param name is either a session
       property or a pointer to a table handle */
    IF cParamLabel = "":U THEN
      cParamLabel = cParamName.


    hTempTable:ADD-NEW-FIELD(cParamName,   /* field name */
                             cTTDataType,               /* data type */
                             0,                         /* extent */
                             ?,                         /* format */
                             cInitValue,       /* initial value */
                             cParamLabel,   /* label */

    /* contatenate the data type and iomode with a separating | into the column-label
       so that we don't need the signature of the procedure that we're calling during 
       the invoke */
                             cParamDT
                             + "|":U 
                             + cParamMode).     /* column-label */


  END.

  IF lFail THEN
  DO:
    DELETE OBJECT hTempTable.
    hTempTable = ?.
    RETURN ?.
  END.

  /* Now add the extra fields that we need for return values */
  addExtraFields(hTempTable, cRetValDT, "":U).

  /* Now prepare the temp-table */
  hTempTable:TEMP-TABLE-PREPARE(cTableName).

  /* Return a handle to the temp-table. */
  RETURN hTempTable.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setupTTFromString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setupTTFromString Procedure 
FUNCTION setupTTFromString RETURNS HANDLE
  ( INPUT pcTableName   AS CHARACTER,
    INPUT pcRetValDT    AS CHARACTER,
    INPUT pcParamString AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets up a temp-table from a string in the format 
            <mode> <data type> <parameter>, <mode> <data type> <parameter>
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hTempTable   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cParamMode   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParamDT     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParamValue  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParamName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCurrParam   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iEndPos      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cParamString AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTTDataType  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTTField     AS CHARACTER  NO-UNDO. /* ignored */
  DEFINE VARIABLE cParamLabel  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRetValLabel AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQuote       AS CHARACTER  NO-UNDO.

  cParamString = pcParamString.

  IF pcRetValDT = "":U THEN
    pcRetValDT = "CHARACTER":U.

  /* Create the temp-table object */
  CREATE TEMP-TABLE hTempTable.

  /* Stay in this loop until the whole string has been parsed */
  REPEAT WHILE cParamString <> "":U:
    iCurrParam = iCurrParam + 1.
    cParamName = "":U.
    cParamLabel = "":U.


    /* First get the mode */
    cParamMode = ENTRY(1, cParamString, " ":U).
    cParamString = TRIM(SUBSTRING(cParamString,LENGTH(cParamMode) + 1)).

    /* Now get the data type */
    cParamDT = ENTRY(1, cParamString, " ":U).
    cParamString = TRIM(SUBSTRING(cParamString,LENGTH(cParamDT) + 1)).

    IF NOT CAN-DO("CHARACTER,INTEGER,DATE,HANDLE,DECIMAL,LOGICAL":U, cParamDT) THEN
    DO:
      DELETE OBJECT hTempTable.
      RETURN ?.
    END.

    /* The next piece of the string is the parameter */
    cQuote = SUBSTRING(cParamString,1,1).
    IF cQuote = "~"":U OR
       cQuote = "'":U  THEN
    DO:
      /* Search for the end of the string -- should end with ', or ", */
      iEndPos = INDEX(cParamString, cQuote + ",":U,2).  
      
      /* If we don't find the end of the string, take the rest of the string */
      IF iEndPos = 0 THEN  
      DO:
        /* Set the parameter value to everything but the quotes */
        cParamValue = SUBSTRING(cParamString,2,LENGTH(cParamString) - 2).
        cParamString = "":U.
      END.
      ELSE
      DO:
        /* Set the parameter value to everything but the quotes */
        cParamValue = TRIM(SUBSTRING(cParamString,2,iEndPos - 2)).
        cParamString = TRIM(SUBSTRING(cParamString,iEndPos + 2)).
      END.
      IF LENGTH(cParamValue) = 4 AND
         NUM-ENTRIES(cParamValue, ":") = 2 AND
         (ENTRY(1,cParamValue, ":") = "T":U OR
          ENTRY(1,cParamValue, ":") = "B":U) THEN
      DO:
        cParamLabel = cParamValue.
        cParamValue = STRING(DYNAMIC-FUNCTION("getHandleParam":U IN TARGET-PROCEDURE,
                                              ENTRY(1,cParamValue,":":U),
                                              INTEGER(ENTRY(2,cParamValue,":":U)))).
      END.
    END.
    ELSE
    DO:
      /* Otherwise we have either a property/param or a buffer/table index */
      cParamValue = ENTRY(1,cParamString,",":U).
      cParamString = TRIM(SUBSTRING(cParamString,LENGTH(cParamValue) + 2)).
      IF LENGTH(cParamValue) = 4 AND
         NUM-ENTRIES(cParamValue, ":") = 2 AND
         (ENTRY(1,cParamValue, ":") = "T":U OR
          ENTRY(1,cParamValue, ":") = "B":U) THEN
      DO:
        cParamLabel = cParamValue.
        cParamValue = STRING(DYNAMIC-FUNCTION("getHandleParam":U IN TARGET-PROCEDURE,
                                              ENTRY(1,cParamValue,":":U),
                                              INTEGER(ENTRY(2,cParamValue,":":U)))).
      END.
      ELSE
      DO:
        cParamLabel = cParamValue.
        cParamValue = obtainParamPropValue(INPUT-OUTPUT cParamLabel).
      END.
    END.
    
    /* If the mode is return, this is the return parameter.
       Return parameter always goes to callReturnValue which will be added in with
       the addExtraFields at the end. */
    IF cParamMode = "RETURN":U THEN
    DO:
      pcRetValDT = cParamDT.
      cRetValLabel = cParamLabel.
      NEXT.
    END.


    /* Make sure that we derive initial values from the correct field */
    obtainInitialValueField(cParamDT, OUTPUT cTTField, OUTPUT cTTDataType).

    cParamName = "CallGenParam":U + STRING(iCurrParam, "999":U).

    /* Parameter label contains parameter name unless param name is either a session
       property or a pointer to a table handle */
    IF cParamLabel = "":U THEN
      cParamLabel = cParamName.
    hTempTable:ADD-NEW-FIELD(cParamName,   /* field name */
                             cTTDataType,               /* data type */
                             0,                         /* extent */
                             ?,                         /* format */
                             cParamValue,       /* initial value */
                             cParamLabel,   /* label */
    
    /* concatenate the data type and iomode with a separating | into the column-label
     so that we don't need the signature of the procedure that we're calling during 
     the invoke */
                             cParamDT
                             + "|":U 
                             + cParamMode).     /* column-label */


  END. /* REPEAT WHILE cParamString <> "":U */

  /* Now add the extra fields that we need for return values */
  addExtraFields(hTempTable, pcRetValDT, cRetValLabel).

  /* Now prepare the temp-table */
  hTempTable:TEMP-TABLE-PREPARE(pcTableName).

  /* Return a handle to the temp-table. */
  RETURN hTempTable.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setupTTFromTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setupTTFromTable Procedure 
FUNCTION setupTTFromTable RETURNS HANDLE
  ( INPUT pcTableName  AS CHARACTER,
    INPUT pcRetValDT   AS CHARACTER,
    INPUT phParamTable AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Reads the contents of the ttCallParam table and builds it into
            a temp-table structure.
    Notes:  This function accepts a table type 1 or 2. The table must be 
            supplied for the function to work.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hTempTable   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cTTDataType  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cField       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hField       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTTCallParam AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCount       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iTableType   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cFieldName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cInitValue   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParamLabel  AS CHARACTER  NO-UNDO.
  
  /* Figure out what type of table we have */
  iTableType = determineTableType(phParamTable).
  
  /* If the table type is not valid for this function call, return the 
     unknown value */
  IF iTableType <> 1 AND
     iTableType <> 2 THEN
    RETURN ?.

  /* First we create a temp-table object */
  CREATE TEMP-TABLE hTempTable.

  /* phParamTable is valid and could be either a TEMP-TABLE or a BUFFER.
     If not, the call to determineTableType would have failed earlier */
  IF phParamTable:TYPE = "TEMP-TABLE":U THEN
    hBuffer = phParamTable:DEFAULT-BUFFER-HANDLE.
  ELSE
    hBuffer = phParamTable.

  /* Create a query to navigate through the data in the table that was provided
     as an input parameter */
  CREATE QUERY hQuery.

  hQuery:ADD-BUFFER(hBuffer).
  hQuery:QUERY-PREPARE("FOR EACH ":U + hBuffer:NAME + " BY iParamNo":U).
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST().

  /* Now we loop through all the parameters in the table */
  REPEAT WHILE NOT hQuery:QUERY-OFF-END:
    cFieldName  = "":U.
    cParamLabel = "":U.

    /* We need to make sure that the data type in the temp-table points to an
       appropriate data type for a temp-table field. We also need to make sure
       that we obtain the initial value from the appropriate field in the 
       ttCallParam temp-table */
    obtainInitialValueField(hBuffer:BUFFER-FIELD("cDataType":U):BUFFER-VALUE,
                            OUTPUT cField, 
                            OUTPUT cTTDataType).

    /* If the table type is 2 then the only field to contain the value is cValue. */
    IF iTableType = 2 THEN
      cField = "cValue":U.

    /* Get the handle to the field that contains the initial value */
    cInitValue = STRING(hBuffer:HANDLE:BUFFER-FIELD(cField):BUFFER-VALUE).

    /* Set the field name from the cParamName */
    cFieldName = hBuffer:BUFFER-FIELD("cParamName":U):BUFFER-VALUE.

    /* This caters for getting the value of a handle from the caller where the
       expression contains the handle to a temp-table or buffer that was passed
       in for temp-table call */
    IF cTTDataType = "HANDLE":U AND
       LENGTH(cInitValue) = 4 AND
       NUM-ENTRIES(cInitValue, ":") = 2 AND
       (ENTRY(1,cInitValue, ":") = "T":U OR
        ENTRY(1,cInitValue, ":") = "B":U) THEN
    DO:
      cParamLabel = cInitValue.
      cInitValue = STRING(DYNAMIC-FUNCTION("getHandleParam":U IN TARGET-PROCEDURE,
                                           ENTRY(1,cInitValue,":":U),
                                           INTEGER(ENTRY(2,cInitValue,":":U)))).
    END.

    IF cFieldName = "":U THEN
      cFieldName = "CallGenParam":U + STRING(hBuffer:BUFFER-FIELD("iParamNo":U):BUFFER-VALUE, "999":U).

    /* Parameter label contains parameter name unless param name is either a session
       property or a pointer to a table handle */
    IF cParamLabel = "":U THEN
      cParamLabel = cFieldName.

    hTempTable:ADD-NEW-FIELD(cFieldName,   /* field name */
                             cTTDataType,               /* data type */
                             0,                         /* extent */
                             ?,                         /* format */
                             cInitValue,       /* initial value */
                             cParamLabel,   /* label */
    
    /* contatenate the data type and iomode with a separating | into the column-label
       so that we don't need the signature of the procedure that we're calling during 
       the invoke */
                             hBuffer:BUFFER-FIELD("cDataType":U):BUFFER-VALUE
                             + "|":U 
                             + hBuffer:BUFFER-FIELD("cIOMode":U):BUFFER-VALUE).     /* column-label */

    hQuery:GET-NEXT().

  END.

  /* Close the query and delete it */
  hQuery:QUERY-CLOSE().
  DELETE OBJECT hQuery.
  hQuery = ?.

  /* Now add the extra fields that we need for return values */
  addExtraFields(hTempTable, pcRetValDT, "":U).

  /* Now prepare the temp-table */
  hTempTable:TEMP-TABLE-PREPARE(pcTableName).

  /* Return a handle to the temp-table. */
  RETURN hTempTable.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

