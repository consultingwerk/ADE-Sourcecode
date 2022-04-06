&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : messaging.p
    Purpose     : Super procedure for messaging class.

    Syntax      : RUN start-super-proc("adm2/messaging.p":U).

    Modified    : 05/03/2000
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


&SCOP ADMSuper messaging.p

  /* Custom exclude file */

  {src/adm2/custom/messagingexclcustom.i}

/* Temp-table for keeping track of JMS Sessions */
DEFINE TEMP-TABLE tConnection
  FIELD jmsPartition    AS CHARACTER
  FIELD domain          AS CHARACTER
  FIELD sessionHandle   AS HANDLE
  INDEX connection IS UNIQUE jmspartition domain
  INDEX sessionh IS UNIQUE sessionHandle.

/* Temp-table for keeping track of instances using a particular JMS Session */
DEFINE TEMP-TABLE tInstance
  FIELD targetHandle  AS HANDLE
  FIELD sessionHandle AS HANDLE
  INDEX targetinstance targetHandle sessionHandle
  INDEX sessioninstance sessionHandle targetHandle.

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

&IF DEFINED(EXCLUDE-getClientID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getClientID Procedure 
FUNCTION getClientID RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDomain) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDomain Procedure 
FUNCTION getDomain RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getJMSpartition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getJMSpartition Procedure 
FUNCTION getJMSpartition RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getJMSpassword) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getJMSpassword Procedure 
FUNCTION getJMSpassword RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getJMSsession) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getJMSsession Procedure 
FUNCTION getJMSsession RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getJMSuser) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getJMSuser Procedure 
FUNCTION getJMSuser RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMessageType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMessageType Procedure 
FUNCTION getMessageType RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPingInterval) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPingInterval Procedure 
FUNCTION getPingInterval RETURNS INTEGER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPromptLogin) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPromptLogin Procedure 
FUNCTION getPromptLogin RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSupportedMessageTypes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSupportedMessageTypes Procedure 
FUNCTION getSupportedMessageTypes RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setClientID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setClientID Procedure 
FUNCTION setClientID RETURNS LOGICAL
  ( pcClientID AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDomain) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDomain Procedure 
FUNCTION setDomain RETURNS LOGICAL
  ( pcDomain AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setJMSpartition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setJMSpartition Procedure 
FUNCTION setJMSpartition RETURNS LOGICAL
  ( pcJMSpartition AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setJMSpassword) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setJMSpassword Procedure 
FUNCTION setJMSpassword RETURNS LOGICAL
  ( pcJMSpassword AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setJMSuser) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setJMSuser Procedure 
FUNCTION setJMSuser RETURNS LOGICAL
  ( pcJMSuser AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMessageType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setMessageType Procedure 
FUNCTION setMessageType RETURNS LOGICAL
  ( pcType AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPingInterval) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPingInterval Procedure 
FUNCTION setPingInterval RETURNS LOGICAL
  ( piPingInterval AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPromptLogin) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPromptLogin Procedure 
FUNCTION setPromptLogin RETURNS LOGICAL
  ( plPrompt AS LOGICAL )  FORWARD.

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/messprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     This is the version of destroyObject for all messaging objects.
               It deletes the JMS session if no other messaging object instances
               are using it. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hSession       AS HANDLE NO-UNDO.
DEFINE BUFFER bInstance FOR tInstance.

  {get JmsSession hSession}.

  IF VALID-HANDLE(hSession) THEN DO: 
    FIND tInstance WHERE tInstance.targetHandle = TARGET-PROCEDURE AND
      tInstance.sessionHandle = hSession NO-ERROR.
    IF AVAILABLE tInstance THEN DO:
      DELETE tInstance.
      FIND FIRST bInstance WHERE bInstance.sessionHandle = hSession NO-ERROR.
      IF NOT AVAILABLE bInstance THEN DO:
        FIND tConnection WHERE tConnection.sessionHandle = hSession.
        IF AVAILABLE tConnection THEN DELETE tConnection.
        RUN deleteSession IN hSession.
      END.

    END.  /* if avail tInstance */
  END.  /* if valid session */

  RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-errorHandler) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE errorHandler Procedure 
PROCEDURE errorHandler :
/*------------------------------------------------------------------------------
  Purpose:     This procedure handles any asynchronous errors
  Parameters:  phMessage         AS HANDLE
               phMessageConsumer AS HANDLE
               phReply           AS HANDLE
  Notes:       This adds the message to the message queue for later retrieval
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phMessage         AS HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER phMessageConsumer AS HANDLE NO-UNDO.
DEFINE OUTPUT PARAMETER phReply           AS HANDLE NO-UNDO.

DEFINE VARIABLE cErrorCode   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cMessageText AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPropNames   AS CHARACTER NO-UNDO.
DEFINE VARIABLE iNum         AS INTEGER   NO-UNDO.
DEFINE VARIABLE lDestroy     AS LOGICAL   NO-UNDO INIT FALSE.

  cPropNames = DYNAMIC-FUNCTION('getPropertyNames':U IN phMessage).
  IF LOOKUP("errorCode":U, cPropNames) > 0 THEN
    cErrorCode = DYNAMIC-FUNCTION('getCharProperty':U IN phMessage,
                                  INPUT 'errorCode':U).
  
  CASE cErrorCode:
    WHEN "-5":U THEN cMessageText = DYNAMIC-FUNCTION("messageNumber":U IN TARGET-PROCEDURE, 25).
    OTHERWISE cMessageText = DYNAMIC-FUNCTION('getText':U IN phMessage).
  END CASE.

  RUN addMessage IN TARGET-PROCEDURE
    (INPUT cMessageText,
     INPUT ?,
     INPUT ?).
            
  RUN deleteMessage IN phMessage.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Messaging version of initializeObject.  
  Parameters:  <none>
  Notes:       It creates the JMS session and sets the Broker URL in the
               session.  It also gets and set the user, password and clientID
               in the session before starting the session.
------------------------------------------------------------------------------*/
DEFINE VARIABLE cAppServerComm AS CHARACTER NO-UNDO.
DEFINE VARIABLE cBrokerURL     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cJMSpartition  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cClientID      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDomain        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPartitionInfo AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPassword      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cUser          AS CHARACTER NO-UNDO.
DEFINE VARIABLE hSession       AS HANDLE    NO-UNDO.
DEFINE VARIABLE iNum           AS INTEGER   NO-UNDO.
DEFINE VARIABLE iPingInterval  AS INTEGER   NO-UNDO.
DEFINE VARIABLE lPrompt        AS LOGICAL   NO-UNDO.

  {get Domain cDomain}.
  {get JMSpartition cJMSpartition}.

  cPartitionInfo = DYNAMIC-FUNCTION('getJMSptnInfo':U IN THIS-PROCEDURE,
                                    INPUT cJMSpartition).
  ASSIGN
    cAppServerComm = ENTRY(1, cPartitionInfo, CHR(3))
    cBrokerURL     = ENTRY(2, cPartitionInfo, CHR(3)).

  FIND tConnection WHERE jmsPartition = cJMSPartition AND
    domain = cDomain NO-ERROR.
  IF AVAILABLE tConnection THEN DO:
    CREATE tInstance.
    ASSIGN tInstance.targetHandle  = TARGET-PROCEDURE
           tInstance.sessionHandle = tConnection.sessionHandle
           hSession                = tConnection.sessionHandle.
  END.  /* if avail tConnection */
  ELSE DO:
    IF cDomain = "PubSub":U THEN 
      RUN jms/pubsubsession.p PERSISTENT SET hSession (cAppServerComm).
    ELSE RUN jms/ptpsession.p PERSISTENT SET hSession (cAppServerComm).
    RUN setBrokerURL IN hSession (cBrokerURL). 
    
    {get JMSuser cUser}.
    {get JMSpassword cPassword}.
    {get ClientID cClientID}.
    {get PromptLogin lPrompt}.

    /* If lPrompt is TRUE and we are not running in batch mode, we 
       bring up a JMS login dialog */
    IF lPrompt AND NOT SESSION:BATCH-MODE THEN DO:
      RUN adm2/jmslogin.w 
        (INPUT-OUTPUT cUser,
         INPUT-OUTPUT cPassword,
         INPUT-OUTPUT cClientID).

      {set JMSuser cUser}.
      {set JMSpassword cPassword}.
      {set ClientID cClientID}.
    END.  /* if lPrompt */

    /* If we are running in batch mode, the user, password and clientID
       can override the property values if they have been given in -param
       in the startup */
    IF SESSION:BATCH-MODE AND SESSION:PARAMETER NE "":U THEN DO:
      DO iNum = 1 TO NUM-ENTRIES(SESSION:PARAMETER):
        CASE iNum:
          WHEN 1 THEN 
            cUser = ENTRY(1,SESSION:PARAMETER).
          WHEN 2 THEN 
            cPassword = ENTRY(2, SESSION:PARAMETER).
          WHEN 3 THEN
            cClientID = ENTRY(3, SESSION:PARAMETER).
        END CASE.
      END.  /* do iNum */
    END.  /* if batch */

    IF cUser NE "":U THEN RUN setUser IN hSession (cUser).
    IF cPassword NE "":U THEN RUN setPassword IN hSession (cPassword).
    IF cClientID NE "":U THEN RUN setClientID IN hSession (cClientID).

    {get PingInterval iPingInterval}.
    IF iPingInterval > 0 THEN RUN setPingInterval IN hSession (iPingInterval).
    
    RUN beginSession IN hSession NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
      RUN addMessage IN TARGET-PROCEDURE
        (INPUT "JMS Session could not begin for the following reason: ~n":U + RETURN-VALUE,
         INPUT ?, 
         INPUT ?).
      RETURN.
    END.  /* if error */

    CREATE tConnection.
    ASSIGN tConnection.jmsPartition  = cJMSpartition
           tConnection.domain        = cDomain
           tConnection.sessionHandle = hSession.
    CREATE tInstance.
    ASSIGN tInstance.targetHandle  = TARGET-PROCEDURE
           tInstance.sessionHandle = hSession.
  END.  /* else do - existing connection not available */

  IF VALID-HANDLE(hSession) THEN RUN setNoErrorDisplay IN hSession (TRUE).

  RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getClientID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getClientID Procedure 
FUNCTION getClientID RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns Client ID property value 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cClientID AS CHARACTER NO-UNDO.
  {get clientID cClientID} NO-ERROR.
  RETURN cClientID.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDomain) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDomain Procedure 
FUNCTION getDomain RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns Domain property value 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDomain AS CHARACTER NO-UNDO.
  &SCOPED-DEFINE xpDomain
  {get Domain cDomain} NO-ERROR.
  &UNDEFINE xpDomain

  RETURN cDomain.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getJMSpartition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getJMSpartition Procedure 
FUNCTION getJMSpartition RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns JMS Partition property value 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cJMSpartition AS CHARACTER NO-UNDO.
  {get JMSpartition cJMSpartition} NO-ERROR.
  RETURN cJMSpartition.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getJMSpassword) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getJMSpassword Procedure 
FUNCTION getJMSpassword RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns JMS Password property value 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cJMSpassword AS CHARACTER NO-UNDO.
  {get JMSpassword cJMSpassword} NO-ERROR.
  RETURN cJMSpassword.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getJMSsession) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getJMSsession Procedure 
FUNCTION getJMSsession RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of the JMS session this instance is using
    Notes:  
------------------------------------------------------------------------------*/
  FIND tInstance WHERE tInstance.targetHandle = TARGET-PROCEDURE NO-ERROR.
  IF AVAILABLE tInstance THEN RETURN tInstance.sessionHandle.
  ELSE RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getJMSuser) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getJMSuser Procedure 
FUNCTION getJMSuser RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns JMS User property value 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cJMSuser AS CHARACTER NO-UNDO.
  {get JMSuser cJMSuser} NO-ERROR.
  RETURN cJMSuser.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMessageType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMessageType Procedure 
FUNCTION getMessageType RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns Message Type property value 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cType AS CHARACTER NO-UNDO.
  {get MessageType cType} NO-ERROR.
  RETURN cType.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPingInterval) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPingInterval Procedure 
FUNCTION getPingInterval RETURNS INTEGER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns Ping Interval property value 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iPingInterval AS INTEGER NO-UNDO.
  {get PingInterval iPingInterval} NO-ERROR.
  RETURN iPingInterval.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPromptLogin) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPromptLogin Procedure 
FUNCTION getPromptLogin RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns PromptLogin property value 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lPrompt AS LOGICAL NO-UNDO.
  {get PromptLogin lPrompt} NO-ERROR.
  RETURN lPrompt.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSupportedMessageTypes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSupportedMessageTypes Procedure 
FUNCTION getSupportedMessageTypes RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns Supported Message Types property value 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTypes AS CHARACTER NO-UNDO.
  {get SupportedMessageTypes cTypes} NO-ERROR.
  RETURN cTypes.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setClientID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setClientID Procedure 
FUNCTION setClientID RETURNS LOGICAL
  ( pcClientID AS CHARACTER ) :
/*------------------------------------------------------------------------------
     Purpose: Sets the Client ID for the JMS broker connection 
  Parameters: pcClientID AS CHARACTER
       Notes:  
------------------------------------------------------------------------------*/
    {set ClientID pcClientID}.
    RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDomain) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDomain Procedure 
FUNCTION setDomain RETURNS LOGICAL
  ( pcDomain AS CHARACTER ) :
/*------------------------------------------------------------------------------
     Purpose: Sets the domain for messages being sent
  Parameters: pcDomain AS CHARACTER
       Notes: Once a session has been started, the messaging Domain cannot 
              change 
------------------------------------------------------------------------------*/
DEFINE VARIABLE hSession AS HANDLE NO-UNDO.

  {get JmsSession hSession}.
  IF VALID-HANDLE(hSession) THEN RETURN FALSE.

  ELSE DO:
    &SCOPED-DEFINE xpDomain
    {set Domain pcDomain}.
    &UNDEFINE xpDomain

    RETURN TRUE.
  END.  /* else do - no session */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setJMSpartition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setJMSpartition Procedure 
FUNCTION setJMSpartition RETURNS LOGICAL
  ( pcJMSpartition AS CHARACTER ) :
/*------------------------------------------------------------------------------
     Purpose: Sets the JMS partition for the JMS session
  Parameters: pcJMSpartition AS CHARACTER
       Notes:  
------------------------------------------------------------------------------*/
    {set JMSpartition pcJMSpartition}.
    RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setJMSpassword) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setJMSpassword Procedure 
FUNCTION setJMSpassword RETURNS LOGICAL
  ( pcJMSpassword AS CHARACTER ) :
/*------------------------------------------------------------------------------
     Purpose: Sets the JMS Password for the JMS session
  Parameters: pcJMSpassword AS CHARACTER
       Notes:  
------------------------------------------------------------------------------*/
    {set JMSpassword pcJMSpassword}.
    RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setJMSuser) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setJMSuser Procedure 
FUNCTION setJMSuser RETURNS LOGICAL
  ( pcJMSuser AS CHARACTER ) :
/*------------------------------------------------------------------------------
     Purpose: Sets the JMS User for the JMS session
  Parameters: pcJMSuser AS CHARACTER
       Notes:  
------------------------------------------------------------------------------*/
    {set JMSuser pcJMSuser}.
    RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMessageType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setMessageType Procedure 
FUNCTION setMessageType RETURNS LOGICAL
  ( pcType AS CHARACTER ) :
/*------------------------------------------------------------------------------
     Purpose: Sets the type for messages being sent
  Parameters: pcType AS CHARACTER
       Notes:  
------------------------------------------------------------------------------*/

  {set MessageType pcType}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPingInterval) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPingInterval Procedure 
FUNCTION setPingInterval RETURNS LOGICAL
  ( piPingInterval AS INTEGER ) :
/*------------------------------------------------------------------------------
     Purpose: Sets the Ping Interval for the JMS session
  Parameters: piPingInterval AS INTEGER
       Notes:  
------------------------------------------------------------------------------*/
    {set PingInterval piPingInterval}.
    RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPromptLogin) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPromptLogin Procedure 
FUNCTION setPromptLogin RETURNS LOGICAL
  ( plPrompt AS LOGICAL ) :
/*------------------------------------------------------------------------------
     Purpose: Sets the Prompt for login property - this determines whether
              the producer or consumer will prompt the user for JMS
              broker login 
  Parameters: plPrompt AS LOGICAL
       Notes:  
------------------------------------------------------------------------------*/
    {set PromptLogin plPrompt}.
    RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

