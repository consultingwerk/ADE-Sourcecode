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
    File        : producer.p
    Purpose     : Super procedure for producer class.

    Syntax      : RUN start-super-proc("adm2/producer.p":U).

    Modified    : 04/26/2000
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


&SCOP ADMSuper producer.p

  /* Custom exclude file */

  {src/adm2/custom/producerexclcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getCurrentMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentMessage Procedure 
FUNCTION getCurrentMessage RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOutMessageSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getOutMessageSource Procedure 
FUNCTION getOutMessageSource RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPersistency) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPersistency Procedure 
FUNCTION getPersistency RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPriority) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPriority Procedure 
FUNCTION getPriority RETURNS INTEGER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTimeToLive) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTimeToLive Procedure 
FUNCTION getTimeToLive RETURNS DECIMAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCurrentMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCurrentMessage Procedure 
FUNCTION setCurrentMessage RETURNS LOGICAL
  ( phMessage AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setOutMessageSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setOutMessageSource Procedure 
FUNCTION setOutMessageSource RETURNS LOGICAL
  ( phSource AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPersistency) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPersistency Procedure 
FUNCTION setPersistency RETURNS LOGICAL
  ( pcPersistency AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPriority) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPriority Procedure 
FUNCTION setPriority RETURNS LOGICAL
  ( piPriority AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTimeToLive) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTimeToLive Procedure 
FUNCTION setTimeToLive RETURNS LOGICAL
  ( pdTimeToLive AS DECIMAL )  FORWARD.

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
         WIDTH              = 58.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/prodprop.i}

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
  Purpose:     This is the message producer's version of destroyObject.  It
               deletes the Reply and Error message consumers
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hErrorConsumer AS HANDLE NO-UNDO.
DEFINE VARIABLE hReplyConsumer AS HANDLE NO-UNDO.

  {get ErrorConsumer hErrorConsumer}.
  {get ReplyConsumer hReplyConsumer}.
  
  IF VALID-HANDLE(hErrorConsumer) THEN RUN deleteConsumer IN hErrorConsumer.
  IF VALID-HANDLE(hReplyConsumer) THEN RUN deleteConsumer IN hReplyConsumer.

  RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     SmartMessageProducer version of initializeObject.  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cUIBmode       AS CHARACTER NO-UNDO.
DEFINE VARIABLE cMessages      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cMsgText       AS CHARACTER NO-UNDO.
DEFINE VARIABLE hReplyConsumer AS HANDLE    NO-UNDO.
DEFINE VARIABLE hErrorConsumer AS HANDLE    NO-UNDO.
DEFINE VARIABLE hSession       AS HANDLE    NO-UNDO.
DEFINE VARIABLE iMsg           AS INTEGER   NO-UNDO.
DEFINE VARIABLE iNumError      AS INTEGER   NO-UNDO.
                   
  {get UIBMode cUIBmode}. 
  
  IF NOT (cUIBMode BEGINS "Design":U) THEN DO:
    
    RUN SUPER.

    /* If an error occured while creating or starting the JMS Session, we
       display the errors */
    IF DYNAMIC-FUNCTION('anyMessage':U IN TARGET-PROCEDURE) THEN DO:
      cMessages = DYNAMIC-FUNCTION('fetchMessages':U IN TARGET-PROCEDURE).
      DO iMsg = 1 TO NUM-ENTRIES(cMessages, CHR(3)):
        cMsgText = cMsgText + 
          RIGHT-TRIM(ENTRY(iMsg, cMessages, CHR(3)), CHR(4)) + "~n":U.
      END.  /* do iMsg */
      IF cMsgText NE "":U THEN
        MESSAGE cMsgText VIEW-AS ALERT-BOX ERROR.
    END.  /* if error */
    ELSE DO:
      {get JmsSession hSession}.
   
      RUN createMessageConsumer IN hSession
        (TARGET-PROCEDURE, 'errorHandler':U, OUTPUT hErrorConsumer).
      {set ErrorConsumer hErrorConsumer}.

      RUN setReuseMessage IN hErrorConsumer.
      RUN setErrorHandler IN hSession (hErrorConsumer).

      RUN createMessageConsumer IN hSession
        (TARGET-PROCEDURE, 'replyHandler', OUTPUT hReplyConsumer).
      {set ReplyConsumer hReplyConsumer}.
    
      RUN setReuseMessage IN hReplyConsumer.

      RUN startReceiveMessages IN hSession.  
    END.  /* else do - no error */

  END.  /* if not Design mode */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-replyHandler) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE replyHandler Procedure 
PROCEDURE replyHandler :
/*------------------------------------------------------------------------------
  Purpose:     This procedure handles replies to messages
  Parameters:  phReply AS HANDLE
               phConsumer AS HANDLE
               phResponse AS HANDLE
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phReply    AS HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER phConsumer AS HANDLE NO-UNDO.
DEFINE OUTPUT PARAMETER phResponse AS HANDLE NO-UNDO.
 
DEFINE VARIABLE hOutMsgSource AS HANDLE NO-UNDO.

  {get OutMessageSource hOutMsgSource}.

  IF VALID-HANDLE(hOutMsgSource) THEN
    RUN receiveReplyHandler IN hOutMsgSource (INPUT phReply) NO-ERROR.
  /* If an error occured or receiveReplyHandler was not found then the
     reply message is not acknowledged and the Sonic broker will re-send it */
  IF ERROR-STATUS:ERROR THEN 
    RUN setNoAcknowledge IN phConsumer.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sendMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sendMessage Procedure 
PROCEDURE sendMessage :
/*------------------------------------------------------------------------------
  Purpose:     This procedure creates and sends a message
  Parameters:  pcDestination   AS CHARACTER
               plReplyRequired AS LOGICAL
  Notes:       This is run from the InMessage-Source to send a message
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcDestination   AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER plReplyRequired AS LOGICAL   NO-UNDO.
DEFINE INPUT  PARAMETER pcReplySelector AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcMessageID     AS CHARACTER NO-UNDO.

DEFINE VARIABLE cDomain        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cMessageID     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cMessageType   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPersistency   AS CHARACTER NO-UNDO.
DEFINE VARIABLE dTimeToLive    AS DECIMAL   NO-UNDO.
DEFINE VARIABLE hConsumer      AS HANDLE    NO-UNDO.
DEFINE VARIABLE hMessage       AS HANDLE    NO-UNDO.
DEFINE VARIABLE hMessageSource AS HANDLE    NO-UNDO.
DEFINE VARIABLE hSession       AS HANDLE    NO-UNDO.
DEFINE VARIABLE iPriority      AS INTEGER   NO-UNDO.
DEFINE VARIABLE lReplyRequired AS LOGICAL   NO-UNDO.
  
  {get JmsSession hSession}.

  IF VALID-HANDLE(hSession) THEN DO:
    
    {get MessageType cMessageType}.

    CASE cMessageType:
      WHEN "BytesMessage":U  THEN RUN createBytesMessage  IN hSession (OUTPUT hMessage).
      WHEN "HeaderMessage":U THEN RUN createHeaderMessage IN hSession (OUTPUT hMessage).
      WHEN "MapMessage":U    THEN RUN createMapMessage    IN hSession (OUTPUT hMessage).
      WHEN "StreamMessage":U THEN RUN createStreamMessage IN hSession (OUTPUT hMessage).
      WHEN "TextMessage":U   THEN RUN createTextMessage   IN hSession (OUTPUT hMessage).
      WHEN "XMLMessage":U    THEN RUN createXMLMessage    IN hSession (OUTPUT hMessage).
    END CASE.

    {set CurrentMessage hMessage}.
  
    {get OutMessageSource hMessageSource}.
    IF VALID-HANDLE(hMessageSource) THEN 
      RUN sendHandler IN hMessageSource (hMessage) NO-ERROR.

    IF RETURN-VALUE = "ADM-ERROR":U THEN
      RETURN "ADM-ERROR":U.
  
    {get Priority iPriority}.
    {get TimeToLive dTimeToLive}.
    {get Persistency cPersistency}.

    /* If a reply is required, requestReply is used to send the message 
       rather the publish (for Pub/Sub) or sendToQueue (for PTP) */
    IF plReplyRequired THEN DO:

      {get ReplyConsumer hConsumer}.
     
      IF pcReplySelector = '':U THEN pcReplySelector = ?.

      RUN requestReply IN hSession 
        (pcDestination,             /* Queue or Topic */ 
         hMessage,                  /* Handle of message */
         pcReplySelector,           /* Reply Selector */
         hConsumer,                 /* Handle of message consumer */
         iPriority,                 /* Priority */
         dTimeToLive,               /* Time to Live */
         cPersistency) NO-ERROR.    /* Persistency */

      ASSIGN pcMessageID = DYNAMIC-FUNCTION('getJMSMessageID':U IN hMessage).
    END.  /* ReplyRequired */
    ELSE DO:
      {get Domain cDomain}.
    
      IF cDomain = "PubSub":U THEN DO:
        RUN PUBLISH IN hSession
          (pcDestination,             /* Topic */
           hMessage,                  /* Handle of message */
           iPriority,                 /* Priority */
           dTimeToLive,               /* Time to Live */
           cPersistency) NO-ERROR.    /* Persistency */
      END.  /* if domain is Publish/Subscribe */
      ELSE DO:
        RUN sendToQueue IN hSession
          (pcDestination,    /* Queue */
           hMessage,         /* Handle of message */         
           iPriority,        /* Priority */
           dTimeToLive,      /* Time to Live */
           cPersistency) NO-ERROR.    /* Persistency */
      END.  /* if domain is Point-to-Point */
   
    END.  /* Reply is not required */
                                   
    /* If an error occured while attempting to send a message */
    IF ERROR-STATUS:ERROR THEN DO:
      RUN addMessage IN TARGET-PROCEDURE
        (INPUT {fnarg messageNumber 67} + CHR(10) + RETURN-VALUE,
         INPUT ?,
         INPUT ?).
      RETURN ERROR.
    END.  /* if error */

    RUN deleteMessage IN hMessage.
    {set CurrentMessage ?}.
  END.  /* if valid Session */
  ELSE DO:
    RUN addMessage IN TARGET-PROCEDURE
      (INPUT DYNAMIC-FUNCTION("messageNumber":U IN TARGET-PROCEDURE, 26),
       INPUT ?,
       INPUT ?).
    RETURN ERROR.
  END.  /* else do - invalid JMS Session */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getCurrentMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentMessage Procedure 
FUNCTION getCurrentMessage RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the handle to the current message 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hMessage AS HANDLE NO-UNDO.
  {get CurrentMessage hMessage} NO-ERROR.
  RETURN hMessage. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOutMessageSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getOutMessageSource Procedure 
FUNCTION getOutMessageSource RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the handle of the Out Message source
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSource AS HANDLE NO-UNDO.
  {get OutMessageSource hSource} NO-ERROR.
  RETURN hSource. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPersistency) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPersistency Procedure 
FUNCTION getPersistency RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns Persistency property value 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cPersistency AS CHARACTER NO-UNDO.
  {get Persistency cPersistency} NO-ERROR.
  RETURN cPersistency.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPriority) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPriority Procedure 
FUNCTION getPriority RETURNS INTEGER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns Priority property value 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iPriority AS INTEGER NO-UNDO.
  {get Priority iPriority} NO-ERROR.
  RETURN iPriority.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTimeToLive) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTimeToLive Procedure 
FUNCTION getTimeToLive RETURNS DECIMAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns TimeToLive property value 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dTimeToLive AS DECIMAL NO-UNDO.
  {get TimeToLive dTimeToLive} NO-ERROR.
  RETURN dTimeToLive.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCurrentMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCurrentMessage Procedure 
FUNCTION setCurrentMessage RETURNS LOGICAL
  ( phMessage AS HANDLE ) :
/*------------------------------------------------------------------------------
     Purpose: Sets the Current Message property to the handle of a newly created
              message
  Parameters: phMessage AS HANDLE
       Notes:  
------------------------------------------------------------------------------*/

  {set CurrentMessage phMessage}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setOutMessageSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setOutMessageSource Procedure 
FUNCTION setOutMessageSource RETURNS LOGICAL
  ( phSource AS HANDLE ) :
/*------------------------------------------------------------------------------
     Purpose: Sets the OutMessage Source
  Parameters: phSource AS HANDLE
       Notes:  
------------------------------------------------------------------------------*/

  {set OutMessageSource phSource}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPersistency) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPersistency Procedure 
FUNCTION setPersistency RETURNS LOGICAL
  ( pcPersistency AS CHARACTER ) :
/*------------------------------------------------------------------------------
     Purpose: Sets Persistency value for messages being sent
  Parameters: pcPersistency AS CHARACTER
       Notes:  
------------------------------------------------------------------------------*/

  {set Persistency pcPersistency}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPriority) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPriority Procedure 
FUNCTION setPriority RETURNS LOGICAL
  ( piPriority AS INTEGER ) :
/*------------------------------------------------------------------------------
     Purpose: Sets priority value for messages being sent 
  Parameters: piPriority AS INTEGER
       Notes:  
------------------------------------------------------------------------------*/

  {set Priority piPriority}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTimeToLive) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTimeToLive Procedure 
FUNCTION setTimeToLive RETURNS LOGICAL
  ( pdTimeToLive AS DECIMAL ) :
/*------------------------------------------------------------------------------
     Purpose: Sets Time To Live value for messages being sent
  Parameters: pdTimeToLive AS DECIMAL
       Notes:  
------------------------------------------------------------------------------*/

  {set TimeToLive pdTimeToLive}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

