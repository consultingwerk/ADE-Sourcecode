&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
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

&IF DEFINED(EXCLUDE-getAsDivision) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAsDivision Procedure 
FUNCTION getAsDivision RETURNS CHARACTER
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

&IF DEFINED(EXCLUDE-getServerFileName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getServerFileName Procedure 
FUNCTION getServerFileName RETURNS CHARACTER
  (   )  FORWARD.

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

&IF DEFINED(EXCLUDE-setServerFileName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setServerFileName Procedure 
FUNCTION setServerFileName RETURNS LOGICAL
  ( pcFileName AS CHARACTER )  FORWARD.

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
         HEIGHT             = 11.71
         WIDTH              = 52.6.
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
   {fn getASHandle}.
   
   IF NOT {fn anyMessage} THEN
     {set BindSignature PROGRAM-NAME(2)}.

   ELSE RETURN ERROR 'ADM-ERROR':U.

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
  RUN SUPER. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyServerObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyServerObject Procedure 
PROCEDURE destroyServerObject :
/*------------------------------------------------------------------------------
  Purpose:    Destroy the server object.    
  Parameters: <none>
  Notes:      Called from unbindServer when ServerOperatingMode = 'STATELESS'
              and ASDivision = 'CLIENT'. 
            - Objects that need to keep context overrides this with calls 
              to the server that both destroys and returns context.    
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE lASBound  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hASHandle AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cContext  AS CHARACTER  NO-UNDO.

  {get ASBound lASBound}.
  
  IF lASBound THEN
  DO:
    {get ASHandle hASHandle}.
    RUN destroyObject IN hASHandle.
    /* getAsHandle checks valid-handle, but handles are resused so make sure
       that valid-handle returns false */
    {set AsHandle ?}. 
  END. /* if ASBound */
  
  RETURN. 

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
  DEFINE VARIABLE hASHandle      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lASBound       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cAppService    AS CHARACTER NO-UNDO.

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
  
  {get AppService cAppService}.
  IF cAppService <> '':U THEN
    RUN appServerDisconnect(cAppService).
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeServerObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeServerObject Procedure 
PROCEDURE initializeServerObject :
/*------------------------------------------------------------------------------
  Purpose:  initialize the server object after it has been started/restarted    
  Parameters:  <none>
  Notes:    This does an extra call to the Appserver the first time to retrieve
            the ServerOperatingMode. This is expensive and could have been  
            avoided by implementing and calling a 
            serverInitializeAndGetOperatingMode, but because most implementors 
            of this class either will block this procedure completely by setting 
            ASInitializeOnRun to false or override this for more complete 
            context management this has not been implemented.
          - This is an internal 'event' that is called from runServerObject 
            after a successful run on server, so it silently ignores any calls 
            when not bound.                  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lHasStarted    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hASHandle      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cOperatingMode AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lASBound       AS LOGICAL    NO-UNDO.

  {get ASBound lASBound}.
  /* This call only makes sense when bound to the server */
  IF lASBound THEN
  DO:
    {get ASHasStarted lHasStarted}.
    {get ASHandle hASHandle}.
         
    RUN initializeObject IN hAsHandle.

    IF NOT lHasStarted THEN
    DO:
      cOperatingMode = DYNAMIC-FUNCTION('getServerOperatingMode':U IN hASHandle).
      {set ServerOperatingMode cOperatingMode}.
    END. /* not ASHasStarted*/
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
  DEFINE VARIABLE cAppService    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hAppService    AS HANDLE    NO-UNDO.  
  DEFINE VARIABLE lBound         AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hContainer     AS HANDLE    NO-UNDO.

  {get ASBound lBound}.
  IF lBound THEN 
    RETURN.

  {get AppService cAppService}.
  
  /* We allow to borrow the container's appservice and do a separate connection
     independently of the container if someone would want to do that. */
  IF cAppService = '':U THEN 
  DO:
    {get ContainerSource hContainer}.
    {get AppService cAppService hContainer} NO-ERROR.
  END.
  
  IF cAppService = '':U THEN 
    RETURN.

  RUN appServerConnect(cAppService, ?, ?, OUTPUT hAppService).

  IF RETURN-VALUE = 'ERROR':U THEN
    RETURN ERROR 'ADM-ERROR':U.

  IF VALID-HANDLE(hAppService) THEN
  DO:
    RUN runServerObject IN TARGET-PROCEDURE (hAppService) NO-ERROR.
    
    IF ERROR-STATUS:ERROR OR RETURN-VALUE = 'ADM-ERROR':U THEN
       RETURN ERROR RETURN-VALUE.
  END. /* valid hAppservice */
  ELSE DO: 
    RUN addMessage IN TARGET-PROCEDURE
       ("Lost connection to partition ":U + cAppService,?,?).

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
    {set ASDivision 'Client':U}. 
    /* This property (9.1B) holds the file name to run on the AppServer. 
       Dynamic object names won't be usable (it will be dyn*). */
    {get ServerFileName cServerFileName}.    
    
    hASHandle = DYNAMIC-FUNCTION('runServerProcedure':U IN TARGET-PROCEDURE,
                                  cServerFileName,
                                  phAppservice).

    IF VALID-HANDLE(hASHandle) THEN
    DO:
      /* Save the handle of the connected ServerObject */
      {set ASHandle hASHandle}.
      {get ASInitializeOnRun lInitialize}.    
      
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
  DEFINE VARIABLE hASHandle      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lASUsePrompt   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cASInfo        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cASDivision    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAppService    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hAppService    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContainer     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lBound         AS LOGICAL    NO-UNDO.
  
  /* Silent error. See notes */ 
  {get ASBound lBound}.
  IF lBound THEN 
    RETURN.
  
  /* Silent error. See notes */ 
  {get AppService cAppService}.
  
  /* We allow to borrow the container's appservice and do a separate connection
     independently of the container if someone would want to do that.  */
  IF cAppService = '':U THEN 
  DO:
    {get ContainerSource hContainer}.
    {get AppService cAppService hContainer} NO-ERROR.
  END.

  IF cAppService = '':U THEN
    RETURN.

  {get ASUsePrompt lASUsePrompt}.  
  {get ASInfo cASInfo}. 
  /* The values for the parameters to appServerConnect can be specified in the 
     AppBuilder's Service table. So we pass ? for the parameters and let the 
     Connect procedure fill in the values from the table, unless they have been 
     specifically set to some value for this object.*/
  ASSIGN 
    lASUsePrompt = IF lASUsePrompt = NO   THEN ? ELSE lASUsePrompt.
    cASInfo      = IF cASInfo      = '':U THEN ? ELSE cASInfo.
  
  RUN appServerConnect(cAppService, lASUsePrompt, cASInfo, OUTPUT hAppService).
    
  /* If the AppServer handle is the SESSION:HANDLE and we are running a
     client proxy - (ASDivision = "Client") then the user doesn't have the
     right databases connected and needs an error message.   */
  IF (hAppService = SESSION:HANDLE OR RETURN-VALUE = "ERROR":U) THEN
  DO:
    {get ASDivision cASDivision}.
    IF cASDivision = 'CLIENT':U THEN
    DO:
      RUN addMessage IN TARGET-PROCEDURE 
        (cAppService +
        ' partition is running locally without the proper database connection(s).',
         ?,?).
      RETURN ERROR 'ADM-ERROR':U.
    END.
  END. /* hAppService = session or return-value = 'error' */
  
  {get ServerOperatingMode cOperatingMode}.
  /* We run this also if not valid handle just to set ASHandle. */  
  RUN runServerObject IN TARGET-PROCEDURE(hAppService) NO-ERROR.
  IF ERROR-STATUS:ERROR OR RETURN-VALUE = 'ADM-ERROR':U THEN
    RETURN ERROR RETURN-VALUE.
  
  /* Override the actual state if the instance property is to force stateful */
  IF cOperatingMode = "STATE-RESET":U THEN
    {set ServerOperatingMode cOperatingMode}.
  
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
                       program-name(x)) or any space delimited string 
                        - Unbind if passed string  =  BindSignature
                      'unconditional' 
                        - Unbind unconditionally                       
  Notes:     This procedure allows nested calls of procedures that binds and 
             unbinds, but still postpone the unbinding until we are back 
             at the level that did the actual binding.
          -  The logic in this procedure is dependent of the fact that  
             getAsHandle or bindServer does the actual binding (if AsHandle is ?)
             and logs the call level by setBindSignature = program-name(2).
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
             
          - Overrides need to do the following
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
  DEFINE VARIABLE hAppServer           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cContext             AS CHAR       NO-UNDO.
  DEFINE VARIABLE cBindSignature       AS CHAR       NO-UNDO.
  DEFINE VARIABLE cWhere               AS CHAR       NO-UNDO.
  DEFINE VARIABLE lASBound             AS LOGICAL    NO-UNDO.
  
  IF pcMode = '':U THEN 
  DO:
    /* We reserve this for the future in the case we need an alternative easy 
       to use parameter.  */
    MESSAGE PROGRAM-NAME(2) 'called unbindserver with a blank input parameter.'
            SKIP
            'This is currently not supported.'
    VIEW-AS ALERT-BOX WARNING.
    RETURN.
  END.
  
  /****** Future  
  We should fix this so that overrides was overlooked 
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

  {get ASDivision cAsDivision}.
  {get ServerOperatingMode cServerOperatingMode}.
  {get ASBound lASBound}.  

  /* Shutdown Server side SDO if stateless client is bound */
  IF  cServerOperatingMode = 'STATELESS':U 
  AND cASDivision          = 'CLIENT':U 
  AND lASBound                           THEN 
  DO: 
    {get BindSignature cBindSignature}.
    /* Destroy server side procedure if Mode 'unconditional' or if this is 
       called from the level that did the binding */ 
   
    IF pcMode BEGINS 'unconditional':U 
 
    /* This is intended to unbind with a passed signature, but ALSO when 
       bindSignature is ? and pcMode is ? */ 

    OR pcMode = cBindSignature   
    OR cBindSignature = PROGRAM-NAME(2) THEN
    DO:    
      RUN destroyServerObject IN TARGET-PROCEDURE.
      {set BindSignature ?}.
    END. /* if pcMode = 'unconditional':U or cBindSignature = program-name(2)*/      
  END. /* if asDivision = 'client' */ 
  
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
  
  ASSIGN ghProp      = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp      = ghProp:BUFFER-FIELD('AppService':U)
         cAppService = ghProp:BUFFER-VALUE NO-ERROR.

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
  ASSIGN ghProp    = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp    = ghProp:BUFFER-FIELD('ASHandle':U)
         hAsHandle = ghProp:BUFFER-VALUE.

  RETURN VALID-HANDLE(hAsHandle) AND hASHAndle <> TARGET-PROCEDURE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAsDivision) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAsDivision Procedure 
FUNCTION getAsDivision RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a string indicating which side of the AppServer this
            Object is running on; 'Client', 'Server', or none.
   Params:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDivision AS CHAR  NO-UNDO.

  {get ASDivision cDivision}.
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
  DEFINE VARIABLE lHasStarted    AS LOGICAL   NO-UNDO.
  
  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('ASHandle':U)
         hAS    = ghProp:BUFFER-VALUE NO-ERROR.
  
  IF NOT VALID-HANDLE(hAS) THEN 
  DO: /* Perhaps it needs to be re-established */        
    /* Store the caller info that unbindServer uses to unbind conditionally */
    {set BindSignature PROGRAM-NAME(2)}.
    {get ASHasStarted lHasStarted}.
      
    /* Both start and restart will arrive at runServerObject */
    IF lHasStarted THEN
      RUN restartServerObject IN TARGET-PROCEDURE.
    ELSE 
      RUN startServerObject IN TARGET-PROCEDURE.

    /* runServerObject has set the property */
    ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
           ghProp = ghProp:BUFFER-FIELD('ASHandle':U)
           hAS    = ghProp:BUFFER-VALUE NO-ERROR.
  END.  /* If it needs to be re-established */

  RETURN hAS.

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
    Notes:  There is no set function as this must only be set internally.        
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
  DEFINE VARIABLE cName AS CHARACTER  NO-UNDO.

  ASSIGN 
    ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
    ghProp = ghProp:BUFFER-FIELD('ServerFileName':U)
    cName  = ghProp:BUFFER-VALUE NO-ERROR.

  IF cName = ? OR cName = '':U THEN
    cName = REPLACE(TARGET-PROCEDURE:FILE-NAME, "_cl.":U, ".":U).
  
  RETURN cName.

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
  DEFINE VARIABLE hASHandle AS HANDLE     NO-UNDO.

  DO ON STOP UNDO, LEAVE: 
    RUN VALUE(pcServerFileName) ON phAppService PERSISTENT SET hASHandle.  
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
  ASSIGN ghProp      = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp      = ghProp:BUFFER-FIELD('AppService':U)
                               /* (None) Untranslatable in the dialog also */
         ghProp:BUFFER-VALUE = IF pcAppService = '(None)':U 
                               THEN '':U 
                               ELSE pcAppService NO-ERROR.

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
  {set ASDivision pcDivision}.
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
  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('ASHandle':U)
         ghProp:BUFFER-VALUE = phASHandle NO-ERROR.

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
  ASSIGN 
    ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
    ghProp = ghProp:BUFFER-FIELD('ServerFileName':U)
    ghProp:BUFFER-VALUE = pcFileName NO-ERROR.
  
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
             'none' only works for outside callers. 
             (WebSpeed specifically ) 
             The instance property can be forced to STATE-RESET.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cCurrentMode AS CHAR NO-UNDO.
  DEFINE VARIABLE cAsDivision  AS CHAR NO-UNDO.

  {get ServerOperatingMode cCurrentMode}.

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

