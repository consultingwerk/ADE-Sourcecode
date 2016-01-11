&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/**************************************************************************
* Copyright (C) 2000,2005-2007 by Progress Software Corporation.          * 
* All rights reserved.  Prior versions of this work may contain portions  *
* contributed by participants of Possenet.                                *
*                                                                         *
***************************************************************************/
/*--------------------------------------------------------------------------
    File        : appserver.p
    Purpose     : Super procedure for appserver class.
                  Implements methods to start/restart and communicate with a  
                  server part of an object.                       
    Syntax      : RUN start-super-proc("adm2/appserver.p":U).
    
    Author      : Roland de Pijper, Progress Software BV
    Modified    : 17/11/200
    Modified    : 01/24/2001  Progress Software Corp. 
                  Made part of 9.1C ADM2 (inherited by data and sbo classes) with
                  the following changes.  
                  - Removed use of connectServerObject.p in anticipation of 
                    ICF session and context services... A runServerProcedure 
                    function was implemented to simplify an override to achieve 
                    this functionality. 
                  - Minor adjustments of some comments and logic from equivalent
                    methods in data and sbo classes.
                  - Added unbindServer and bindserver (from sbo class 9.1B05)
                    and removed setASBound.    
                  - Added stateless client 'events' initializeServerObject
                    and destroyServerObject to simplify overrides for 
                    objects that needs context management and also to make 
                    a call to initializeObject on the server as default as 
                    this is a current adm 'rule'. A ASInitializeOnRun property
                    that defaults to yes, decides whether initializeServerObject
                    is run.         
                  - destroyObject -> disconnectObject (both from data class)
                  - Added a startServerObject that encapsulates logic from 
                    initializeObject in data and sbo classes. A new logical 
                    AsHasStarted property decides whether to start or 
                    restart from getASHandle. Also added a runServerObject 
                    procedure that is called from start- and restartServerObject
                    and has (most of) the common start/restart code.                                                             
    Notes:        This class does not directly support context management,
                  but its two stateless client 'events'; initializeServerObject 
                  and destroyServerObject is the 'events' that implementors 
                  overrides for context management on the client. 
               -  This class does NOT show any messages.   
                  Errors hardcoded messages to addMessage. The methods also
                  returns ERROR 'ADM-ERROR' on an error, but this is just for 
                  direct calls and are NOT returned up the stack.        
                  Implementors can override getAsHandle and/or start-, 
                  restartServerProcedure to check for anyMessage and show 
                  messages.     
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


&SCOP ADMSuper appserver.p

  /* Custom exclude file */

  {src/adm2/custom/appserverexclcustom.i}

 /* Include the file which defines AppServerConnect procedures. */
  {adecomm/appserv.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getAppService) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAppService Procedure 
FUNCTION getAppService RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getASBound) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getASBound Procedure 
FUNCTION getASBound RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getASDivision) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getASDivision Procedure 
FUNCTION getASDivision RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getASHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getASHandle Procedure 
FUNCTION getASHandle RETURNS WIDGET-HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getASHasConnected) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getASHasConnected Procedure 
FUNCTION getASHasConnected RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getASHasStarted) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getASHasStarted Procedure 
FUNCTION getASHasStarted RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getASInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getASInfo Procedure 
FUNCTION getASInfo RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getASInitializeOnRun) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getASInitializeOnRun Procedure 
FUNCTION getASInitializeOnRun RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getASUsePrompt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getASUsePrompt Procedure 
FUNCTION getASUsePrompt RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBindScope) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBindScope Procedure 
FUNCTION getBindScope RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNeedContext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNeedContext Procedure 
FUNCTION getNeedContext RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getServerFileName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getServerFileName Procedure 
FUNCTION getServerFileName RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getServerFirstCall) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getServerFirstCall Procedure 
FUNCTION getServerFirstCall RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getServerOperatingMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getServerOperatingMode Procedure 
FUNCTION getServerOperatingMode RETURNS CHARACTER
   ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hasNoServerBinding) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD hasNoServerBinding Procedure 
FUNCTION hasNoServerBinding RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-runServerProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD runServerProcedure Procedure 
FUNCTION runServerProcedure RETURNS HANDLE
  (pcServerFileName AS CHAR,
   phAppService     AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAppService) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAppService Procedure 
FUNCTION setAppService RETURNS LOGICAL
  ( pcAppService AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setASDivision) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setASDivision Procedure 
FUNCTION setASDivision RETURNS LOGICAL
  ( pcDivision AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setASHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setASHandle Procedure 
FUNCTION setASHandle RETURNS LOGICAL
 ( phASHandle AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setASHasConnected) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setASHasConnected Procedure 
FUNCTION setASHasConnected RETURNS LOGICAL
  ( plASHasConnected AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setASHasStarted) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setASHasStarted Procedure 
FUNCTION setASHasStarted RETURNS LOGICAL
  ( plHasStarted AS LOGICAL  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setASInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setASInfo Procedure 
FUNCTION setASInfo RETURNS LOGICAL
  ( pcInfo AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setASInitializeOnRun) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setASInitializeOnRun Procedure 
FUNCTION setASInitializeOnRun RETURNS LOGICAL
  ( plInitialize AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setASUsePrompt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setASUsePrompt Procedure 
FUNCTION setASUsePrompt RETURNS LOGICAL
  ( plFlag AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBindScope) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBindScope Procedure 
FUNCTION setBindScope RETURNS LOGICAL
  ( pcScope AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNeedContext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setNeedContext Procedure 
FUNCTION setNeedContext RETURNS LOGICAL
  ( plNeedContext AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setServerFileName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setServerFileName Procedure 
FUNCTION setServerFileName RETURNS LOGICAL
  ( pcFileName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setServerFirstCall) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setServerFirstCall Procedure 
FUNCTION setServerFirstCall RETURNS LOGICAL
  ( plFirstCall AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setServerOperatingMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setServerOperatingMode Procedure 
FUNCTION setServerOperatingMode RETURNS LOGICAL
  ( pcServerOperatingMode AS CHARACTER )  FORWARD.

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
         HEIGHT             = 18.71
         WIDTH              = 58.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/appsprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-bindServer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE bindServer Procedure 
PROCEDURE bindServer :
/*------------------------------------------------------------------------------
  Purpose:  Bind the object to the server.  
  Parameters:  <none>
  Notes:     This provides the same functionality as getAsHandle, but does not
             expose the handle and is considered to be the API for an outside 
             caller.                   
------------------------------------------------------------------------------*/    
   DEFINE VARIABLE cBindScope AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE iStack     AS INTEGER    NO-UNDO.

   {fn getASHandle}.
   IF NOT {fn anyMessage} THEN
   DO:
     {get BindScope cBindScope}.
     /* if Bindscope is not blank then the signature should already indicate 
        where the unbind should take place 
        Loop to ignore possible overrides of bindServer
        (10 is just a lazy and paranoid do while true ) */ 
     IF cBindScope = '':U THEN
     DO iStack = 2 TO 10:
       IF NOT (PROGRAM-NAME(iStack) BEGINS 'bindServer':U) THEN
       DO:
         {set BindSignature PROGRAM-NAME(iStack)}.
         LEAVE.
       END.
     END.
   END.

   ELSE RETURN ERROR 'ADM-ERROR':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-connectServer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE connectServer Procedure 
PROCEDURE connectServer :
/*------------------------------------------------------------------------------
  Purpose:    connect and get the handle of the appServer 
  Parameters:  <none>
  Notes:      If AsDivison is blank, prompt parameters will be passed to
              the global appserverConnect. 
              (Note that these parameters are ignored in ICF and are 
               only kept for backwards compatibility)  
              This is part of getAsHandle, which returns ? to indicate errors
              so most errors are just returned.       
   
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER phAppService AS HANDLE   NO-UNDO.
  
  DEFINE VARIABLE lASUsePrompt    AS LOGICAL    NO-UNDO.
  
  DEFINE VARIABLE cASInfo         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cASDivision     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAppService     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainer      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lAsHasConnected AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lAsHasStarted   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lConnected      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lUseRepository  AS LOGICAL    NO-UNDO.

  /* Silent error. See notes */ 
  {get AppService cAppService}.

  /* We allow to borrow the container's appservice and do a separate connection
       independently of the container if someone would want to do that.  */
  IF cAppService = '':U THEN 
  DO:
    {get ContainerSource hContainer}.
    {get AppService cAppService hContainer} NO-ERROR.
  END.

  IF cAppService = '':U OR cAppService = ? THEN
    RETURN.

  &SCOPED-DEFINE xp-assign
  {get AsHasConnected lAsHasConnected}
  {get UseRepository lUseRepository}
   .
  &UNDEFINE xp-assign

  /* if this object never has connected then get the AsUsePrompt and AsInfo 
     prop in case this service has not been connected at all */ 
  IF NOT lAsHasConnected THEN
  DO:
    &SCOPED-DEFINE xp-assign
    {get ASUsePrompt lASUsePrompt}
    {get ASInfo cASInfo}. 
    &UNDEFINE xp-assign
    /* The values for the parameters to appServerConnect can be specified in the 
       AppBuilder's Service table. So we pass ? for the parameters and let the 
       Connect procedure fill in the values from the table, unless they have been 
       specifically set to some value for this object.*/
    ASSIGN 
      lASUsePrompt = IF lASUsePrompt = NO   THEN ? ELSE lASUsePrompt.
      cASInfo      = IF cASInfo      = '':U THEN ? ELSE cASInfo.
  END.
  ELSE 
    ASSIGN 
      lAsUsePrompt = ?
      cAsInfo      = ?.

  /* We do not get the service handle if this object not has connected yet, 
     since state-aware objects relies on each object calling appserverConnect 
     ONCE for appserverDisconnect to work correctly (as_utils uses a counter to
     keep track of when it really can disconnect..)
  -  On Dynamics, however, the AS-manager connect method always disconnects 
     and connects, so we use the existing handle if possible also for the 
     first connection.  */
  IF lAsHasConnected OR lUseRepository THEN
    ASSIGN
      phAppService = DYNAMIC-FUNCTION('getServiceHandle':U IN appSrvUtils,cAppService)
      lConnected   = VALID-HANDLE(phAppService) AND 
                   (phAppService = SESSION:HANDLE OR phAppService:CONNECTED()).  

  IF NOT lConnected THEN
  DO:
    RUN appServerConnect IN appSrvUtils
        (cAppService, lASUsePrompt, cASInfo, OUTPUT phAppService).
    IF RETURN-VALUE = "ERROR":U THEN    
    DO:
      RUN addMessage IN TARGET-PROCEDURE 
          (cAppService +
          ' partition is running locally without the proper database connection(s).',
           ?,?).
      RETURN ERROR 'ADM-ERROR':U.
    END. /* hAppService not defined  or return-value = 'error' */
  END.

  IF NOT lAsHasConnected THEN
  DO:
    {set AsHasConnected TRUE}.
    IF phAppService NE ? AND phAppService NE SESSION:HANDLE THEN
      {set ASDivision 'Client':U}. 
    ELSE 
      {set AsDivision  '':U}.
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
  Purpose:     Disconnects the AppServer connection if present before invoking 
               the standard destroy code.
  
  Parameters:  <none>
------------------------------------------------------------------------------*/
  
  
  RUN disconnectObject IN TARGET-PROCEDURE. /* Disc. from AppServer */  
  
  RUN SUPER NO-ERROR.  
  IF ERROR-STATUS:ERROR OR RETURN-VALUE = "ADM-ERROR":U THEN
      RETURN ERROR "ADM-ERROR":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyServerObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyServerObject Procedure 
PROCEDURE destroyServerObject :
/*------------------------------------------------------------------------------
  Purpose:  Destroy the server object and retrieve its context.    
  Parameters:  <none>
  Notes:    Called from unbindServer when stateless.  
          - The intention is to move context management up to this class
            from data.p and sbo.p, but as of current this method calls 
            APIs that is not implemented here, but only exists in QueryObjects 
            if QueryObject is true  
          - This event is not always called as queryobjects now supports 
            'one-hit' datarequests or call destroyObject directly 
            when BindScope is 'data'.     
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE lASBound     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hASHandle    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cContext     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lNeedContext AS LOGICAL    NO-UNDO.

  {get ASBound lASBound}.
  
  IF lASBound THEN
  DO:
    &SCOPED-DEFINE xp-assign
    {get ASHandle hASHandle}
    {get NeedContext lNeedContext}. 
    &UNDEFINE xp-assign             /* QueryObjects like the sdo and sbo 
                                       need context, so we assume context 
                                       methods are available even if not yet 
                                       implemented in this class */
    IF lNeedContext THEN 
    DO:
      RUN getContextAndDestroy IN hASHandle (OUTPUT cContext).
      {fnarg applyContextFromServer cContext}.
    END.    
    ELSE 
      RUN destroyObject IN hASHandle.
    /* getAsHandle checks valid-handle, but handles are resused so make sure
       that valid-handle returns false */
    {set AsHandle ?}. 
  END. /* if ASBound */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disconnectObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disconnectObject Procedure 
PROCEDURE disconnectObject :
/*------------------------------------------------------------------------------
  Purpose:     To disconnect from the AppServer if there is one. 
  Parameters:  <none>
  Notes:       If lAsbound we do an explicit destroyObject on the AppServer 
               to give that object an opportunity to clean up.                
               This procedure is invoked from destroyObject, but can also be 
               run directly to disconnect without exiting. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hASHandle            AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lASBound             AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cAppService          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cServerOperatingMode AS CHARACTER  NO-UNDO.

  /* we might be connected even if we have no Appservice 
    (borrowed from container) */ 
  {get ASBound lASBound}.

  IF lASBound THEN
  DO:
    {get ASHandle hASHandle}.    
    IF VALID-HANDLE(hASHAndle) AND hASHandle NE TARGET-PROCEDURE THEN
    DO:
      RUN destroyObject IN hASHandle.
      /* ensure AsHandle is not-valid  */            
      {set AsHandle ?}.
    END. /* if valid and not target */
  END.  /* if lAsBound  */  
  
  &SCOPED-DEFINE xp-assign
  {get ServerOperatingMode cServerOperatingMode}
  {get AppService cAppService}
  .
  &UNDEFINE xp-assign
  
  /* Only disconnect if state aware: 
    non-dynamics -
    (as-utils currently uses a counter to check if the disconnect really can 
     disconnect. Objects of this class will only do ONE appServerConnect, so 
     this counter should be correct, but the logic could rather have checked
     if server:first-procedure was valid) 
    dynamics -  
      appServerDisconnect does nothing, due to the fact that disconnect is non 
      conditional in the ASManager and this logic relies on a conditional 
      disconnect. (Since this now is called only when state-aware, dynamics 
      really does not matter..)  */

  IF cServerOperatingMode <> 'STATELESS':U AND cAppService <> '':U THEN
    RUN appServerDisconnect IN appSrvUtils (cAppService) .

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-endClientDataRequest) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE endClientDataRequest Procedure 
PROCEDURE endClientDataRequest :
/*------------------------------------------------------------------------------
  Purpose: Common 'event' called after any data request. Both read and save of 
           data are considered to be data requests.                    
    Notes: The task is to ensure that a stateless connection is unbound correctly 
           with a call to the unbindServer procedure, which has the logic to 
           unbind or not.  
         - Even if this event implies that the data request is over, the 
           BindScope property must be set to 'Data' to ensure an immediate 
           unbind by passing 'UNCONDITIONAL' to unbindServer. 
         - The adm sets BindScope to 'data' as early as possible in all methods 
           that eventually will cause a data request.
         - The appserver class has no data requests, but the logic here is
           common for both data.p and sbo.p 
         - Historically, this event's main purpose was to retrieve context from 
           the server if still bound, to ensure that important properties were 
           returned as early as possible, but this is no longer required as the
           new server data requests implemented for 9.1D all have context as 
           input-output parameter. 
Note Date: 2002/02/05                              
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAsDivision       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOperatingMode    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hAsHandle         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cContext          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lASBound          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hObject           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cBindScope        AS CHARACTER  NO-UNDO.
  
  {get AsDivision cAsDivision}.

  /* Get out if not 'client' */
  IF cAsDivision <> 'Client':U THEN 
    RETURN.
  
  {get ServerOperatingMode cOperatingMode}.

  IF cOperatingMode = 'stateless':U THEN  
  DO:
    {get BindScope cBindScope}.     
    /* We pass the caller to unbindServer to ensure proper unbinding unless
       the BindScope is 'data', which we use as an indication to pass 
       'unconditional' to ensure that the unbind takes place independent 
       of BindSignature. */ 
    RUN unbindServer IN TARGET-PROCEDURE
           (IF cBindScope = 'Data':U THEN 'UNCONDITIONAL':U
            ELSE                           PROGRAM-NAME(2)).
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeServerObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeServerObject Procedure 
PROCEDURE initializeServerObject :
/*------------------------------------------------------------------------------
   Purpose: Initialize the server object after it has been started/restarted    
Parameters: <none>
     Notes: An extra call to the Appserver is required on the first call to 
            retrieve the ServerOperatingMode. This is expensive and could have 
            been avoided by implementing synchronizeProperties in this class 
            that returns this property, but most implementors of this will
            class either avoid this procedure completely by setting 
            ASInitializeOnRun to false or override it for more complete 
            context management so this has not been implemented.
          - From 9.1D this is not called as part of a normal data request.      
          - This is an internal 'event' that is called from runServerObject 
            after a successful run on server. It assumes that the server is 
            bound and silently ignores any calls when not bound.                  

Note date:  2002/02/05               
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lHasStarted    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hASHandle      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cOperatingMode AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lASBound       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lNeedContext   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cContext       AS CHARACTER  NO-UNDO.

  {get ASBound lASBound}.
  /* This call only makes sense when bound to the server */
  IF lASBound THEN
  DO:
    &SCOPED-DEFINE xp-assign
    {get ASHasStarted lHasStarted}
    {get ASHandle hASHandle}
    {get NeedContext lNeedContext}. 
    &UNDEFINE xp-assign             /* QueryObjects like the sdo and sbo 
                                       need context, so we assume context 
                                       methods are available even if not yet 
                                       implemented in this class */
    IF lNeedContext THEN 
    DO:
      cContext = {fn obtainContextForServer}.  
      /* certain getters called from obtainContextForServer may have finalized 
         connection already  */
      if valid-handle(hAsHandle) then
      do:
        /* synchronizeProperties does not currently exist in SBO, so the SBO 
	         overrides this and calls super only if hasStarted  */
        IF NOT lHasStarted THEN
        DO:
          RUN synchronizeProperties IN hASHandle (INPUT  cContext,
                                                  OUTPUT cContext).
          {fnarg applyContextFromServer cContext}.
        END.
        ELSE  
          RUN setContextAndInitialize IN hAsHandle(cContext).
      end. /* valid ashandle */  
    END.
    ELSE 
    DO:
      RUN initializeObject IN hAsHandle.
      IF NOT lHasStarted THEN
      DO:
        cOperatingMode = DYNAMIC-FUNCTION('getServerOperatingMode':U IN hASHandle).
        {set ServerOperatingMode cOperatingMode}.
      END. /* not ASHasStarted*/
    END.
  END. /* if ASBound */.
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-restartServerObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE restartServerObject Procedure 
PROCEDURE restartServerObject :
/*------------------------------------------------------------------------------
  Purpose:    When a SmartDataObject is split and running Statelessly on an
              AppServer, it is shutdown after each use and then restarted for
              the next. restartServerObject is run on the client to restart
              the SmartDataObject on the server.
  Parameters:  
  Notes:      The startServerObject will (should) be run on the first connection. 
            - Both start- and restart- runs runServerObject, which does the 
              actual run and the optional initialize.    
            - This procedure is considered to be an 'internal event' and 
              does silently return if the object is bound or Appservice = ''
              and does not check if ASHasStarted is true (As this may not be 
              damaging if there's no difference between start/restart). 
              It is assumed to be called only when unbound and ASHasStarted is 
              true as when called from getAsHandle. 
            - getASHandle is depending on the 'silent error' when Appservice 
              is blank for backwards compatibility with data and sbo classes, 
             (not completely true, it actually checked ASDivision='client', but
              that is too restrictive) so if errors are added here, make sure 
              getAsHandle deals with (removes) them before returning  
------------------------------------------------------------------------------*/ 
  DEFINE VARIABLE hAppService    AS HANDLE    NO-UNDO.  
  DEFINE VARIABLE lBound         AS LOGICAL   NO-UNDO.
  
  {get ASBound lBound}.
  IF lBound THEN 
    RETURN.

  RUN connectServer IN TARGET-PROCEDURE (OUTPUT hAppService). 
  IF hAppService = ? THEN
    RETURN ERROR 'ADM-ERROR':U.

  IF VALID-HANDLE(hAppService) THEN
  DO:
    RUN runServerObject IN TARGET-PROCEDURE (hAppService) NO-ERROR.
    
    IF ERROR-STATUS:ERROR OR RETURN-VALUE = 'ADM-ERROR':U THEN
       RETURN ERROR RETURN-VALUE.
  END. /* valid hAppservice */
  ELSE DO: 
    RUN addMessage IN TARGET-PROCEDURE
       ("Lost connection to partition ":U + {fn getAppService},?,?).

    RETURN ERROR 'ADM-ERROR':U.   
  END.

  RETURN. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-runServerObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runServerObject Procedure 
PROCEDURE runServerObject :
/*------------------------------------------------------------------------------
  Purpose:    Run the server part of this object and set AShandle.
  Parameters: phAppservice - AppServer Session handle
  Notes:      Called from startServerObject and restartServerObject.   
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phAppService AS HANDLE  NO-UNDO.

  DEFINE VARIABLE cServerFileName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hASHandle         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lInitialize       AS LOGICAL    NO-UNDO.

  IF phAppService NE ? and phAppService NE SESSION:HANDLE THEN
  DO:
    /* This property (9.1B) holds the file name to run on the AppServer. 
       Dynamic object names won't be usable (it will be dyn*). */
    {get ServerFileName cServerFileName}.    
 
    hASHandle = DYNAMIC-FUNCTION('runServerProcedure':U IN TARGET-PROCEDURE,
                                  cServerFileName,
                                  phAppservice).
    IF VALID-HANDLE(hASHandle) THEN
    DO:
      /* Save the handle of the connected ServerObject */
      &SCOPED-DEFINE xp-assign
      {set ASHandle hASHandle}
      {get ASInitializeOnRun lInitialize}.    
      &UNDEFINE xp-assign
      
      IF lInitialize THEN
        RUN initializeServerObject IN TARGET-PROCEDURE. 
      /* Set the flag that is used to decide whether to start or restart*/  
      {set ASHasStarted TRUE}.
    END. /* valid hASHandle */
    ELSE DO:
      RUN addMessage IN TARGET-PROCEDURE
       ("AppServer startup failed for ":U + cServerFileName,?,?).
      RETURN ERROR 'ADM-ERROR':U.  
    END.
  END. /* phAppservice <> ? and <> session */
  ELSE {set ASHandle TARGET-PROCEDURE}.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-startServerObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startServerObject Procedure 
PROCEDURE startServerObject :
/*------------------------------------------------------------------------------
  Purpose:    Run on the client to start the Object on the server.
  Parameters:  
  Notes:      restartServerObject will (should) be run the next time the object 
              needs to communicate with its server part. 
            - Both start- and restart- runs runServerObject, which does the 
              actual run and optional initialize.  
            - This procedure is considered to be an 'internal event' and 
              does silently return if the object is bound or Appservice = ''
              and does not check if ASHasStarted is false (As this may not be 
              damaging if there's no difference between start/restart). 
              It is assumed to be called only when unbound and ASHasStarted is 
              false as when called from getAsHandle or from initializeObject
              in objects that need to connect at start up.
            - getASHandle is depending on the 'silent error' when Appservice 
              is blank for backwards compatibility with data and sbo classes,
             (not completely true, it actually checked ASDivision='client', but
              that is too restrictive) so if errors are added here, make sure 
              getAsHandle deals with (removes) them before returning ?.  
-----------------------------------------------------------------------------*/
  DEFINE VARIABLE lASBound       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cOperatingMode AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hAppService    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lBound         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cBindScope     AS CHARACTER  NO-UNDO.
  
  /* Silent error. See notes */ 
  {get ASBound lBound}.
  IF lBound THEN 
    RETURN.

  RUN connectServer IN TARGET-PROCEDURE (OUTPUT hAppService). 
  IF hAppService = ? THEN
    RETURN ERROR 'ADM-ERROR':U.
 
  {get ServerOperatingMode cOperatingMode}.
  
  /* We run this also if not valid handle just to set ASHandle. */  
  RUN runServerObject IN TARGET-PROCEDURE(hAppService) NO-ERROR.
  IF ERROR-STATUS:ERROR OR RETURN-VALUE = 'ADM-ERROR':U THEN
    RETURN ERROR RETURN-VALUE.
  
    /* Override the actual state if the instance property is to force stateful */
  IF cOperatingMode = "STATE-RESET":U THEN
    {set ServerOperatingMode cOperatingMode}.
  
  /* This procedure may be called from the outside just to initialize 
     properties, ensure that it unbinds if called with no bindScope 
    (Example:
      get* properties in SDOs calls this in the containing SBO in order 
      to get ALL data from the server. This would normally be during 
      initialization in which case BindScope is defined, but it is possible 
      to call them separately) */  

  {get BindScope cBindScope}.
  IF cBindScope = '':u THEN
    RUN unbindserver IN TARGET-PROCEDURE(?).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-synchronizeProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE synchronizeProperties Procedure 
PROCEDURE synchronizeProperties :
/*------------------------------------------------------------------------------
   Purpose:   To synchronize certain properties on the server side with its
              client side.
Parameters:
    INPUT pcPropertiesForServer  CHAR
             - The format is defined by the classes that extends this 
    OUTPUT pcPropertiesForClient CHAR
             - The format is defined by the classes that extends this   
             
    Notes:   This procedure is designed to be invoked from the client side, but 
             executed on the server half of a SmartDataObject. While executing 
             on the server side it runs setContextAndInitialize to set the 
             passed properties, then calls obtainContextForClient to accumulate 
             properties to return in the output parameter to be applied on the 
             client.  
         -   See obtainContextForClient for further details on when and how 
             special 'first request' data is returned.
         -   This is one of many variations on client server communication and
             is now only used on the first request and even in that case only 
             if getAsHandle is being called prior to the actual data request.  
         -   This is using APIs that (not yet) exists in this clas, but only
             in classes that NeedContext (containr, data  and sbo)                
Note date: 2002/02/04                      
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcPropertiesForServer AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcPropertiesForClient AS CHARACTER  NO-UNDO.
  
  RUN setContextAndInitialize IN TARGET-PROCEDURE(pcPropertiesForServer).
  
  pcPropertiesForClient = {fn obtainContextForClient}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-unbindServer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE unbindServer Procedure 
PROCEDURE unbindServer :
/*------------------------------------------------------------------------------
    Purpose:  unbind the AppServer by destroying the server side object 
              started by the client.        
  Parameters: pcMode - Rules for unbinding
                      'conditional' or  ?   
                        - Unbind if called from same level as BindSignature
                          unless BindScope is 'STRONG'. 
                      'unconditional' 
                        - Unbind unconditionally                       
                       program-name(x)) or any space delimited string 
                        - Unbind if passed string  =  BindSignature
                          Only if BindScope is blank.
  Notes:     This procedure allows nested calls of procedures that binds and 
             unbinds, but still postpone the unbinding until we are back 
             at the level that did the actual binding.
          -  The logic in this procedure is dependent of the fact that  
             getAsHandle or bindServer does the actual binding (if AsHandle is ?)
             and logs the call level by setBindSignature = program-name(2).
             or that setBindScope defines the call level by 
             setBindSignature = program-name(2). 
          -  An external caller will use the following sequence to ensure that 
             all calls are done with one connection. 
             -- 
              RUN bindServer in <handle>.
              <some request> in <handle>
              <some request> in <handle>
              RUN unbindServer(?). 
             --
             
          -  Internal calls will typically look like this.
             --
             hAsHandle = getAsHandle(). 
             <some request> in hasHandle 
             RUN unbindServer(?).  
             --                                      
          - Currently overrides need to do the following 
             --- 
             def input param pcmode as char.
              run SUPER(if pcMode = ? then program-name(2) else pcMode). 
             --- 
          - Limitations applies as recursive calls and external callers have
            the same signature, so an unbind may happen to early. 
           (This can probably be fixed by saving the complete stack in
            BindSignature)                     
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcMode  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cAsDivision          AS CHAR       NO-UNDO.  
  DEFINE VARIABLE cServerOperatingMode AS CHAR       NO-UNDO.
  DEFINE VARIABLE hAsHandle            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cBindSignature       AS CHAR       NO-UNDO.
  DEFINE VARIABLE cBindScope           AS CHAR       NO-UNDO.
  DEFINE VARIABLE lASBound             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cCaller              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iStack               AS INTEGER    NO-UNDO.

  IF pcMode = '':U THEN 
  DO:
    /* We reserve this for the future in the case we need an alternative easy 
       to use parameter.  */
    MESSAGE SUBSTITUTE({fnarg messageNumber 41}, PROGRAM-NAME(2))   
      VIEW-AS ALERT-BOX WARNING.
    RETURN.
  END.
  
  /****** Future ? 
  We could fix this so that overrides was overlooked;
  something like this + a check of the targets super-procedures...    
  i = 2.
  callerIp = entry(1,PROGRAM-NAME(2),'').
  cProgramName = PROGRAM-NAME(i).
  DO WHILE program-name(1) BEGINS callerIp:
    i = i + 1.  
    callerIp = ENTRY(1,PROGRAM-NAME(i)," ":U).
    cProgramName = PROGRAM-NAME(i).
  END.
  ***********/
  &SCOPED-DEFINE xp-assign
  {get ASDivision cAsDivision}
  {get ServerOperatingMode cServerOperatingMode}.
  &UNDEFINE xp-assign
  /* Shutdown Server side SDO if stateless client is bound */  
  IF  LOOKUP(cServerOperatingMode,'state-aware,state-reset':U) = 0
  AND cASDivision          = 'CLIENT':U THEN
  DO:
    DO iStack = 2 TO 10:
      IF NOT (PROGRAM-NAME(iStack) BEGINS 'unbindServer':U) THEN
      DO:
        cCaller = PROGRAM-NAME(iStack).
        LEAVE.
      END.
    END.

    &SCOPED-DEFINE xp-assign
    {get BindScope cBindScope}
    {get BindSignature cBindSignature}.      
    &UNDEFINE xp-assign
      /* Destroy server side procedure if Mode 'unconditional' or if this is 
         called from the level that did the binding unless the scope is STRONG*/   
    IF pcMode BEGINS 'unconditional':U 
    OR (cBindScope <> 'STRONG':U
            /* This is intended to unbind with a passed signature, 
               but ALSO when bindSignature is ? and pcMode is ? */ 
        AND (pcMode = cBindSignature OR cBindSignature = cCaller )) THEN
    DO:    
      {get ASBound lASBound}.  
      IF lASBound THEN 
      DO:
        /* We assume that we already have context if unbinding a data scope*/
        IF cBindScope = 'Data':U THEN
        DO:
          {get ASHandle hAsHandle}.
          RUN destroyObject IN hAsHandle.
          {set AsHandle ?}.
        END.
        ELSE /* Call the get context and destroy  */
          RUN destroyServerObject IN TARGET-PROCEDURE.
      END.
      
      /* We reset the BindScope even if we are not bound if we are at the 
         defined unbind level */
      {set BindScope '':U}. /* this will also set Bindsignature ? */
    END. /* if pcMode = 'unconditional':U or cBindSignature = program-name(2)*/      
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getAppService) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAppService Procedure 
FUNCTION getAppService RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the property naming the logical partition name of
            the AppService to be used to connect to an AppServer
   Params:  none
            No xp preprocessor in order not to return '(None)' as saved from 
            the Instance Property dialog. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAppService AS CHARACTER  NO-UNDO.
  
  &SCOPED-DEFINE xpAppService
  {get AppService cAppService}.
  &UNDEFINE xpAppService
  /* Probably not required to check for (none) here as we fix this in set,
     and Inst Props from containers uses set, but just in case someone actually 
     stores Inst Props in a db/repository..*/
  RETURN IF cAppService <> '(None)':U /* Untranslatable in the dialog also */
         THEN cAppService
         ELSE '':U.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getASBound) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getASBound Procedure 
FUNCTION getASBound RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns TRUE if this object binds the AppServer with a persistently
           running procedure, usually the 'server' part of this object.              
    Notes: Uses the AsHandle property to check this. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hAsHandle AS HANDLE NO-UNDO.

  &SCOPED-DEFINE xpASHandle
  {get ASHandle hAsHandle}.
  &UNDEFINE xpASHandle

  RETURN VALID-HANDLE(hAsHandle) AND hASHAndle <> TARGET-PROCEDURE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getASDivision) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getASDivision Procedure 
FUNCTION getASDivision RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a string indicating which side of the AppServer this
            Object is running on; 'Client', 'Server', or none.
   Params:  <none>
     Note:  This is the main condition used in code to separate/trigger 
            client or server specific logic.
            It's immediately set to 'server' at start up if session:remote. 
            On the client, we traditionally connected in initializeObject 
            and immediately set this property there, but as we now postpone the
            connection, this value is now unknown (default) until we know a 
            connection has succeeded. In order for client specific logic to 
            function as before also when not yet connected, we return 'client' 
            when the property is unknown. (otherwise we would never connect...)            
            It's set to blank immediately if Appservice is blank, but otherwise 
            it is kept as unknown until we REALLY know.
          - getAsHasConnected uses this unknown value to return false until we 
            have connected!   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDivision     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAppService   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAsHasStarted AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lInitialized  AS LOGICAL    NO-UNDO.
  
  &SCOPED-DEFINE xpAsDivision
  {get ASDivision cDivision}.
  &UNDEFINE xpAsDivision
  
  IF cDivision = ? THEN
  DO:
     /* return ? if not initialized */
    {get ObjectInitialized lInitialized}.
    IF NOT lInitialized THEN
       RETURN cDivision.

    /* If an appservice is defined and we have not started the value is still
       unknown, but we must assume that we are on a client as this is the 
       main conditional check that triggers a connection */
    {get AppService cAppService}.
    IF cAppService <> '':U THEN
    DO:
      {get AsHasStarted lAsHasStarted}.
      IF NOT lAsHasStarted AND ({fn getUIBMode} = '':U) THEN
        cDivision = 'Client':U.
      ELSE /* Something has gone astray if we get here, but whatever reason
              we certainly do not have a 'client', so return blank, but keep
              the property value as is, since we really have no clue  */
        cDivision = '':U.
    END.
    ELSE DO:
      cDivision = '':U.
      {set AsDivision cDivision}. /* Avoid this check in the future */
    END.
  END. /* cDivision = ? */
  
  RETURN cDivision.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getASHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getASHandle Procedure 
FUNCTION getASHandle RETURNS WIDGET-HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the handle to this object's companion procedure 
               (the copy of itself) running on the AppServer.
 
  Parameters:  <none>
  
  Notes:       Note that what is returned is *not* the handle of the connection,
               but rather the persistent procedure handle in which internal 
               procedures and functions can be invoked.           
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hAS            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lHasStarted    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cBindScope     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iStack         AS INTEGER    NO-UNDO.
 
  &SCOPED-DEFINE xpAsHandle
  {get AsHandle hAs}.
  &UNDEFINE xpAsHandle
  IF NOT VALID-HANDLE(hAS) THEN 
  DO: /* Perhaps it needs to be re-established */        
     /* Store the caller info that unbindServer uses to unbind conditionally 
        unless the Bindscope is not blank as the signature then already is set
        and must override this */   
    {get BindScope cBindScope}.
    IF cBindScope = '':U THEN
    DO:
      /* set BindSignature as the caller, loop to ignore possible overrides
         of getAshandle
        (10 is just a lazy and paranoid do while true ) */ 
      DO iStack = 2 TO 10:
        IF NOT (PROGRAM-NAME(iStack) BEGINS 'getAsHandle':U) THEN
        DO:
          {set BindSignature PROGRAM-NAME(iStack)}.
          LEAVE.
        END.
      END.
    END.
    {get ASHasStarted lHasStarted}.
        
    /* Both start and restart will call connectServer and runServerObject */
    IF lHasStarted THEN
      RUN restartServerObject IN TARGET-PROCEDURE.
    ELSE 
      RUN startServerObject IN TARGET-PROCEDURE.

    /* runServerObject has set the property */
    &SCOPED-DEFINE xpAsHandle
    {get AsHandle hAs}.
    &UNDEFINE xpAsHandle


  END.  /* If it needs to be re-established */
  RETURN hAS.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getASHasConnected) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getASHasConnected Procedure 
FUNCTION getASHasConnected RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Return yes if a connection has taken place 
    Notes: Does only know that a connection HAS taken place. Not if we still
           are connected. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lASHasConnected AS LOGICAL NO-UNDO.
  
  {get ASHasConnected lASHasConnected}.
  RETURN lASHasConnected.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getASHasStarted) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getASHasStarted Procedure 
FUNCTION getASHasStarted RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns (LOGICAL) a flag indicating whether the object has
            done its first call to its server side object.
   Params:  <none>
    Notes:          
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lHasStarted AS LOGICAL NO-UNDO.
  {get ASHasStarted lHasStarted}.
  RETURN lHasStarted.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getASInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getASInfo Procedure 
FUNCTION getASInfo RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the value of the AppServer Information string, if any,
            used as a parameter when this object connects to its 
            Partition for the first time.
   Params:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cASInfo AS CHARACTER NO-UNDO.
  {get ASInfo cASInfo}.
  RETURN cASInfo.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getASInitializeOnRun) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getASInitializeOnRun Procedure 
FUNCTION getASInitializeOnRun RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the flag on or off which indicates whether runServerObject             
            should call initializeServerObject
   Params:  <none>
     Note:  initializeServerObject is called on the client, but will usually 
            have a call to the server to set and/or retrieve context.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lInitialize  AS LOGICAL    NO-UNDO.
  {get ASInitializeOnRun lInitialize}.
  RETURN lInitialize.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getASUsePrompt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getASUsePrompt Procedure 
FUNCTION getASUsePrompt RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns (LOGICAL) a flag indicating whether the supporting code
            should prompt for a Username and Password, when connecting to
            its Application Partition.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lASUse AS LOGICAL NO-UNDO.
  {get ASUsePrompt lASuse}.
  RETURN lASUse.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBindScope) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBindScope Procedure 
FUNCTION getBindScope RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the bind scope    
    Notes: This basically decides when a stateless connection should be unbound.
           See setBindScope  for details   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cBindScope AS CHARACTER  NO-UNDO.
  
  &SCOPED-DEFINE xpBindScope
  {get BindScope cBindScope}.
  &UNDEFINE xpBindScope

  RETURN cBindScope. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNeedContext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNeedContext Procedure 
FUNCTION getNeedContext RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns true if the object requires context to be passed back 
           and forth between client and server. 
    Notes: Will be set to true on first call if not explicitly set (unknown) 
           and the object is a QueryObject or an appserver aware Container.    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lNeedContext   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cContainerType AS CHARACTER  NO-UNDO.

  &GLOBAL-DEFINE xpNeedContext
  {get NeedContext lNeedContext}.
  &UNDEFINE xpNeedContext
  
  IF lNeedContext = ? THEN
  DO:
    /* QueryObjects like the sdo and sbo need context */
    {get QueryObject lNeedContext}.
    /* A container that is Appserver Aware need context
      (Appserver Aware is given by the existence of this super-procedure)*/ 
    IF NOT lNeedContext THEN
    DO:
      {get ContainerType cContainerType} NO-ERROR. 
      IF cContainerType <> ? OR cContainerType <> '':U THEN
        lNeedContext = TRUE.
    END.
    {set NeedContext lNeedContext}.
  END.

  RETURN lNeedContext.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getServerFileName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getServerFileName Procedure 
FUNCTION getServerFileName RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  returns the property value that stores the actual server-side
             SDO filename to run on the AppServer -- may not be the ObjectName
             if that has been modified.
   Params:  <none>
    Notes:  Defaults to the target-procedure file-name without the _cl.      
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lQuery AS LOGICAL    NO-UNDO.
  
  &SCOPED-DEFINE xpServerFileName
  {get ServerFileName cName}.
  &UNDEFINE xpServerFileName
  
  IF cName = ? OR cName = '':U THEN
  DO:
    {get QueryObject lQuery}.
    IF lQuery THEN
      cName = REPLACE(TARGET-PROCEDURE:FILE-NAME, "_cl.":U, ".":U).
    ELSE 
      cName = 'adm2/dyncontainer.w':U.
  END.

  RETURN cName.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getServerFirstCall) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getServerFirstCall Procedure 
FUNCTION getServerFirstCall RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns (LOGICAL) a flag indicating whether this is the first 
            call to the server side object.
   Params:  <none>
    Notes:  Server side property! (The client uses AsHasStarted)
            Typically usage:
             Client  
              if not AsHasStarted 
                contextForServer = ServerFirstCall=YES
             Server       
              if ServerFirstCall 
                contextForClient = AsHasStarted=YES 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lFirstCall AS LOGICAL NO-UNDO.
  {get ServerFirstCall lFirstCall}.
  RETURN lFirstCall.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getServerOperatingMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getServerOperatingMode Procedure 
FUNCTION getServerOperatingMode RETURNS CHARACTER
   ( ) :
 /*------------------------------------------------------------------------------
   Purpose: get the ServerOperatingMode which tells whether the object is 
            running. 
              'Stateless',
              'State-Reset',
              'State-Aware' or 
              'none' (running locally)
     Notes:  
 ------------------------------------------------------------------------------*/
  DEFINE VARIABLE cServerOperatingMode AS CHARACTER  NO-UNDO.    
  {get ServerOperatingMode cServerOperatingMode}.
  RETURN cServerOperatingMode.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hasNoServerBinding) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION hasNoServerBinding Procedure 
FUNCTION hasNoServerBinding RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Encapsulates logic to check AppServer properties to see if the 
           object has no current or future server bindings and is using a 
           stateless operating mode.    
    Notes: Used by data objects to check if data can be retrieved with one 
           appserver hit together with other data objects and by another 
           object (DataContainer).   
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cASDivision      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lASBound         AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cOperatingMode   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cBindScope       AS CHARACTER  NO-UNDO.
  
 &SCOPED-DEFINE xp-assign
 {get ASDivision cASDivision}
 {get AsBound lASBound}
 {get ServerOperatingMode cOperatingMode}
 {get BindScope cBindScope}.
 &UNDEFINE xp-assign
     
 RETURN cAsDivision = 'Client':U
        AND NOT lAsBound 
        AND NOT CAN-DO('state-aware,state-reset':U,cOperatingMode)
        AND NOT CAN-DO('Strong,this':U,cBindScope).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-runServerProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION runServerProcedure Procedure 
FUNCTION runServerProcedure RETURNS HANDLE
  (pcServerFileName AS CHAR,
   phAppService     AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose: Returns handle of the (a) procedure after a run on server.  
    Notes: Intended to simplify an override of the run statement for example 
           to use a bind procedure instead of running the procedure directly. 
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE hASHandle      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lQuery         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lUseRepository AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cLogicalName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectType    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lDynamic       AS LOGICAL    NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get QueryObject lQuery}
  {get UseRepository lUseRepository}
  .
  &UNDEFINE xp-assign
  
  DO ON STOP UNDO, LEAVE: 
    
    IF lQuery AND lUseRepository THEN
    DO:
      &SCOPED-DEFINE xp-assign
      {get DynamicData lDynamic}
      {get LogicalObjectName cLogicalName}
      {get ObjectType cObjectType}
      .
      &UNDEFINE xp-assign    
    END.

    IF NOT lDynamic THEN
      RUN VALUE(pcServerFileName) ON phAppService PERSISTENT SET hASHandle.  
    ELSE
    DO:
      IF cObjectType ='SmartDataObject':U THEN
        RUN adm2/remotedynsdo.w ON phAppService PERSISTENT SET hASHandle (cLogicalName).
      ELSE IF cObjectType ='SmartBusinessObject':U THEN
        RUN ry/obj/remotedynsbo.w ON phAppService PERSISTENT SET hASHandle (cLogicalName).
    END.
  END.  

  RETURN hASHandle.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAppService) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAppService Procedure 
FUNCTION setAppService RETURNS LOGICAL
  ( pcAppService AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:    Sets the AppService property which names logical partition name 
              of the AppService to be used to connect to an AppServer
               
  Parameters: INPUT pcPartition - 
                 Partition name that this Object has registered.  
  Notes:      The default value is the APPLICATION-PARTITION preprocessor value 
              which can be defined in the procedure settings dialog in the 
              AppBuilder.
              No xp preprocessor in order to fix '(None)' as saved from 
              the Instance Property dialog or AppBuilder.  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cAppService AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xpAppService
  cAppService = IF pcAppService = '(None)':U THEN '':U ELSE pcAppService.  
  {set AppService cAppService}.
  &UNDEFINE xpAppService

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setASDivision) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setASDivision Procedure 
FUNCTION setASDivision RETURNS LOGICAL
  ( pcDivision AS CHARACTER ) :
/*------------------------------------------------------------------------------
   Purpose:  Sets a string property indicating which side of the AppServer this
             Object is running on; 'Client', 'Server', or none.
   Params:   pcDivision AS CHARACTER 
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpAsDivision
  {set ASDivision pcDivision}.
  &UNDEFINE xpAsDivision
 RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setASHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setASHandle Procedure 
FUNCTION setASHandle RETURNS LOGICAL
 ( phASHandle AS HANDLE) :
/*------------------------------------------------------------------------------
     Purpose:    Sets the handle to this object's companion procedure 
                 (the copy of itself) running on the AppServer.
    Parameters:  phASHandle - The handle of the server object. 
    Notes:       Note that this is *not* the handle of the connection,
                 but the persistent procedure in which internal procedures and 
                 functions can be invoked.           
--------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpASHandle
  {set ASHandle phASHandle}.
  &UNDEFINE xpASHandle
  
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setASHasConnected) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setASHasConnected Procedure 
FUNCTION setASHasConnected RETURNS LOGICAL
  ( plASHasConnected AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose: Set to yes when a connection has taken place 
    Notes: 
------------------------------------------------------------------------------*/
  {set ASHasConnected plASHasConnected}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setASHasStarted) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setASHasStarted Procedure 
FUNCTION setASHasStarted RETURNS LOGICAL
  ( plHasStarted AS LOGICAL  ) :
/*------------------------------------------------------------------------------
  Purpose:  Set the flag that indicates whether the client object has done its 
            first call to its server side object.
   Params:  <none>
------------------------------------------------------------------------------*/
  {set ASHasStarted plHasStarted}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setASInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setASInfo Procedure 
FUNCTION setASInfo RETURNS LOGICAL
  ( pcInfo AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the value of the AppServer Information string 
            which is passed to the AppServer connection as a parameter.
   Params:  pcInfo -- information string 
------------------------------------------------------------------------------*/
  {set ASInfo pcInfo}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setASInitializeOnRun) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setASInitializeOnRun Procedure 
FUNCTION setASInitializeOnRun RETURNS LOGICAL
  ( plInitialize AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the flag on or off which indicates whether runServerObject             
            should call initializeServerObject
   Params:  plInitialize AS LOGICAL  -- If true, run initializeServerObject.
     Note:  initializeServerObject is called on the client, but will usually 
            have a call to the server to set and/or retrieve context.  
------------------------------------------------------------------------------*/
  {set ASInitializeOnRun plInitialize}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setASUsePrompt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setASUsePrompt Procedure 
FUNCTION setASUsePrompt RETURNS LOGICAL
  ( plFlag AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the flag on or off which indicates whether the support code 
            should prompt for a Username and Password when connecting to an
            AppServer session.
   Params:  plFlag AS LOGICAL  -- If true, the code will prompt.
------------------------------------------------------------------------------*/
  {set ASUsePrompt plFlag}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBindScope) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBindScope Procedure 
FUNCTION setBindScope RETURNS LOGICAL
  ( pcScope AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Define the scope of an stateless appserver connection 
Parameter: pcScope - A character string defining the scope 
               The order below also indicates the scope 'strength' with the 
               weakest scopes first, this is important as a weaker scope never 
               can override a stronger or even itself. (blank is the exception)    
               - Blank (Default) 
                 Unbind at the level where the bind takes place.                 
                 It overrides all other scopes and should NOT need to be used 
                 except by unbindServer itself in order to reset to default!     
                 - getAsHandle and bindServer will set BindSignature which 
                   then is used by unbindServer.
                 - A 'one-hit' DataRequest will be used if not already bound.   
               - 'Data' 
                 Unbind immediately after a data request, but keep any 
                 connection that happens before the data request. 
                  - This is enforced by endClientDataReqest or implicit by 
                    allowing a 'one-hit' datarequest. 
                  - unbindServer will unbind at the first/upper level it was 
                    set if not dataRequest took place.    
                  - A 'one hit' datarequest can be used if not bound.      
               - 'This'  
                 Don't unbind until we are back at this level. 
                   This is different from bindServer as no connection is being 
                   done until required.
                  - Prevents a 'one hit' datarequest 
               - 'Strong'  
                 Only unbind when unbindServer('unconditional')                 
               - ? 
                 This is the weakest scope, but the strongest rule and should 
                 really only be used to reset the value to blank. 
                                
    Notes: The property is enforced by endClientdataRequest and unbindServer
           or in some cases in an actual dataRequest. 
         - unbindServer should ALWAYS be called at the end of a procedure where 
           this is set, to ensure that an unbind takes place under all 
           circumstances and that the scope is reset to blank. 
           The only exception being the STRONG connection, which relies on an 
           unbindServer('unconditional') further up in the call stack.        
         - endClientdataRequest is normally used further down and will unbind
           if the scope is 'Data'. (It also ensures that context is retrieved 
           from server if it is still unbound)            
         - The BindSignature property is used to identify the scope level and
           is set here unless blank, in which case it need to be set in 
           bindServer and getAsHandle for unbindServer to enforce the rule.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cCurrentScope AS CHARACTER  NO-UNDO.
  
  &SCOPED-DEFINE xpBindScope
  {get BindScope cCurrentScope}.  
  CASE pcScope:
    WHEN '':U THEN
    DO:
      &SCOPED-DEFINE xp-assign
      {set BindSignature ?}
      {set BindScope '':U}.
      &UNDEFINE xp-assign
    END.
    WHEN 'Strong':U THEN
    DO:
      &SCOPED-DEFINE xp-assign
      {set BindSignature ?}
      {set BindScope pcScope}.
      &UNDEFINE xp-assign
    END.
    WHEN 'This':U THEN
    DO:
      IF NOT CAN-DO('Strong,This':U,cCurrentScope) THEN
      DO:
        &SCOPED-DEFINE xp-assign
        {set BindSignature PROGRAM-NAME(2)}
        {set BindScope pcScope}.
        &UNDEFINE xp-assign
      END.
    END.
    WHEN 'Data':U THEN
    DO:
      IF NOT CAN-DO('Strong,This,Data':U,cCurrentScope) THEN
      DO:
        &SCOPED-DEFINE xp-assign
        {set BindSignature PROGRAM-NAME(2)}
        {set BindScope pcScope}.
        &UNDEFINE xp-assign
      END.
    END.
    OTHERWISE RETURN FALSE. 
  END.
 
  &UNDEFINE xpBindScope
  
 
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNeedContext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setNeedContext Procedure 
FUNCTION setNeedContext RETURNS LOGICAL
  ( plNeedContext AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose: Set to true to indicate that the object requires context to be 
           passed back and forth between client and server.  
    Notes: No xp defined because the get has logic to figure out the default 
------------------------------------------------------------------------------*/
  &GLOBAL-DEFINE xpNeedContext
  {set NeedContext plNeedContext}.  
  &UNDEFINE xpNeedContext
 
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setServerFileName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setServerFileName Procedure 
FUNCTION setServerFileName RETURNS LOGICAL
  ( pcFileName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the property value that stores the actual server-side
            filename to run on the AppServer -- may not be the ObjectName
            if that has been modified or if it is a dynamic clientobject.
    Params: INPUT pcFileName AS CHARACTER
     Notes: xp- preprocessor parameter is NOT defined because 
            getServerFileName has logic to return a default name.  
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpServerFileName
  {set ServerFileName pcFileName}.
  &UNDEFINE xpServerFileName
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setServerFirstCall) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setServerFirstCall Procedure 
FUNCTION setServerFirstCall RETURNS LOGICAL
  ( plFirstCall AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Set the flag indicating that this is the first call to the server 
            side object.
   Params:  plFirstCall
    Notes:  Server side property manged from the client! 
                   (The client uses AsHasStarted) 
            It's the client's responsibility to tell the server that this is 
            the first call.
            Client:  
              if not AsHasStarted 
                contextForServer = ServerFirstCall=YES 
------------------------------------------------------------------------------*/
  {set ServerFirstCall plFirstCall}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setServerOperatingMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setServerOperatingMode Procedure 
FUNCTION setServerOperatingMode RETURNS LOGICAL
  ( pcServerOperatingMode AS CHARACTER ) :
/*------------------------------------------------------------------------------
   Purpose: set the serverOperatingMode.   
Parameters: pcServerOperatingMode can be:
              'Stateless'
              'State-Reset'
              'State-Aware' or
              'none'        (when running locally)
     Notes:  The xp Preprocessor IS defined, so the protection against 
             'none' only works for outside callers! 
             (WebSpeed specifically ) 
             The instance property can be forced to STATE-RESET.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cCurrentMode AS CHAR NO-UNDO.
  DEFINE VARIABLE cAsDivision  AS CHAR NO-UNDO.

  {get ServerOperatingMode cCurrentMode}.

  /* ignore any setting on server (inst prop of static sdo, causing problems 
     in static SBOs) */

  IF SESSION:REMOTE THEN
    RETURN FALSE.

  /* 'Stateless' is set from the AppServer, it can be forced to 'state-reset',
     but must NOT be set to NONE when this is a 'client' 
     See notes above. */
  IF  cCurrentMode BEGINS 'STATE':U  
  AND pcServerOperatingMode = "NONE":U 
  AND SOURCE-PROCEDURE <> TARGET-PROCEDURE THEN
  DO:
    {get ASDivision cASDivision}.
    IF cASDivision = 'Client':U THEN
      RETURN FALSE.
  END. /* if changing 'stateless' to 'none' */
  
  {set ServerOperatingMode pcServerOperatingMode}.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

