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
    File        : consumer.p
    Purpose     : Super procedure for consumer class.

    Syntax      : RUN start-super-proc("adm2/consumer.p":U).

    Modified    : 05/03/2000
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


&SCOP ADMSuper consumer.p

  /* Custom exclude file */

  {src/adm2/custom/consumerexclcustom.i}

/* Temp table used to keep track of destinations (queues/topics) that need
   message consumers */
DEFINE TEMP-TABLE tDestination NO-UNDO
  FIELD destination      AS CHARACTER
  FIELD selector         AS CHARACTER INIT ?
  FIELD subscription     AS CHARACTER INIT ?
  FIELD unsubscribeclose AS LOGICAL
  FIELD consumer         AS HANDLE
  FIELD targetHandle     AS HANDLE
  INDEX dest targetHandle destination subscription.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-defineDestination) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD defineDestination Procedure 
FUNCTION defineDestination RETURNS LOGICAL
  ( pcDestination AS CHARACTER,
    pcColumns     AS CHARACTER,
    pcValues      AS CHARACTER  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDestinations) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDestinations Procedure 
FUNCTION getDestinations RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInMessageTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInMessageTarget Procedure 
FUNCTION getInMessageTarget RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLogFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLogFile Procedure 
FUNCTION getLogFile RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRouterTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRouterTarget Procedure 
FUNCTION getRouterTarget RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSelectors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSelectors Procedure 
FUNCTION getSelectors RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getShutDownDest) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getShutDownDest Procedure 
FUNCTION getShutDownDest RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSubscriptions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSubscriptions Procedure 
FUNCTION getSubscriptions RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWaiting) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWaiting Procedure 
FUNCTION getWaiting RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDestinations) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDestinations Procedure 
FUNCTION setDestinations RETURNS LOGICAL
  ( pcDestinations AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setInMessageTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setInMessageTarget Procedure 
FUNCTION setInMessageTarget RETURNS LOGICAL
  ( phTarget AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLogFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLogFile Procedure 
FUNCTION setLogFile RETURNS LOGICAL
  ( pcLogFile AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRouterTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRouterTarget Procedure 
FUNCTION setRouterTarget RETURNS LOGICAL
  ( phTarget AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSelectors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSelectors Procedure 
FUNCTION setSelectors RETURNS LOGICAL
  ( pcSelectors AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setShutDownDest) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setShutDownDest Procedure 
FUNCTION setShutDownDest RETURNS LOGICAL
  ( pcShutDownDest AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSubscriptions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSubscriptions Procedure 
FUNCTION setSubscriptions RETURNS LOGICAL
  ( pcSubscriptions AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setWaiting) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setWaiting Procedure 
FUNCTION setWaiting RETURNS LOGICAL
  ( plWaiting AS LOGICAL )  FORWARD.

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
         HEIGHT             = 15.57
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/consprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-assignUnsubscribe) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignUnsubscribe Procedure 
PROCEDURE assignUnsubscribe :
/*------------------------------------------------------------------------------
  Purpose:     This procedure changes the unsubscribe on close flag for a durable
               subscription.
  Parameters:  pcDestination  AS CHARACTER
               pcSubscription AS CHARACTER
               plUnsubscribe  AS LOGICAL
  Notes:       This gives the application the ability to ask a user at logoff
               if they would like to unsubscribe from a durable subscription.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcDestination  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcSubscription AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER plUnsubscribe  AS LOGICAL   NO-UNDO.

  FIND tDestination WHERE 
    tDestination.targetHandle = TARGET-PROCEDURE AND
    tDestination.destination  = pcDestination AND
    tDestination.subscription = pcSubscription NO-ERROR.
  IF AVAILABLE tDestination THEN
    ASSIGN unsubscribeclose = plUnsubscribe.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createConsumers) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createConsumers Procedure 
PROCEDURE createConsumers :
/*------------------------------------------------------------------------------
  Purpose:    This procedure creates message consumers for normal message 
              retrieval, shutdown message retrieval and error handling. 
  Parameters:  
  Notes:      A message consumer for normal message delivery is created for
              each destination temp-table record.  A message consumer is 
              created to receive a shutdown message if the ShutDown property
              has a value.  And a message consumer is created to handle errors. 
------------------------------------------------------------------------------*/
DEFINE VARIABLE cDomain        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cShutDownDest  AS CHARACTER NO-UNDO.
DEFINE VARIABLE hConsumer      AS HANDLE    NO-UNDO.
DEFINE VARIABLE hErrorConsumer AS HANDLE    NO-UNDO. 
DEFINE VARIABLE hSession       AS HANDLE    NO-UNDO.
DEFINE VARIABLE hStopConsumer  AS HANDLE    NO-UNDO.

  {get JMSsession hSession}.
  {get Domain cDomain}.
                                 
  FOR EACH tDestination WHERE tDestination.targetHandle = TARGET-PROCEDURE:
    
    RUN createMessageConsumer IN hSession 
      (INPUT TARGET-PROCEDURE, 
       INPUT "messageHandler":U, 
       OUTPUT hConsumer) NO-ERROR.

    RUN setReplyAutoDelete IN hConsumer (INPUT TRUE).
    RUN setReuseMessage IN hConsumer.

    ASSIGN tDestination.consumer = hConsumer.

    IF cDomain = "PubSub":U THEN
      RUN SUBSCRIBE IN hSession
        (INPUT tDestination.destination,
         INPUT tDestination.subscription,
         INPUT tDestination.selector,
         INPUT NO,
         INPUT tDestination.consumer) NO-ERROR.
    ELSE 
      RUN receiveFromQueue IN hSession
        (INPUT tDestination.destination,
         INPUT tDestination.selector,
         INPUT tDestination.consumer).

  END.  /* for each tDestination */

  {get ShutDownDest cShutDownDest}.
  IF cShutDownDest NE "":U AND cShutDownDest NE ? THEN DO:
    RUN createMessageConsumer IN hSession
      (INPUT TARGET-PROCEDURE,
       INPUT "stopHandler":U,
       OUTPUT hStopConsumer).
    {set StopConsumer hStopConsumer}.

    IF cDomain = "PubSub":U THEN
      RUN SUBSCRIBE IN hSession
        (INPUT cShutDownDest,
         INPUT ?,
         INPUT ?,
         INPUT NO,
         INPUT hStopConsumer) NO-ERROR.
    ELSE 
      RUN receiveFromQueue IN hSession
        (INPUT cShutDownDest,
         INPUT ?,
         INPUT hStopConsumer).

  END.  /* if shutdown destination set */

  RUN createMessageConsumer IN hSession
    (INPUT TARGET-PROCEDURE,
     INPUT "errorHandler":U,
     OUTPUT hErrorConsumer).
  {set ErrorConsumer hErrorConsumer}.

  RUN setReuseMessage IN hErrorConsumer.
  RUN setErrorHandler IN hSession (hErrorConsumer).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     This is the message consumer's version of destroyObject.  It
               deletes the message consumers and cancels any durable 
               subscriptions that need to be cancelled.
  Parameters:  <none>
  Notes:      
------------------------------------------------------------------------------*/
DEFINE VARIABLE hErrorConsumer AS HANDLE NO-UNDO.
DEFINE VARIABLE hStopConsumer  AS HANDLE NO-UNDO.
DEFINE VARIABLE hSession       AS HANDLE NO-UNDO.

  {get ErrorConsumer hErrorConsumer}.
  {get StopConsumer hStopConsumer}.
  {get JMSsession hSession}.
  
  IF VALID-HANDLE(hErrorConsumer) THEN RUN deleteConsumer IN hErrorConsumer.
  IF VALID-HANDLE(hStopConsumer) THEN RUN deleteConsumer IN hStopConsumer.

  FOR EACH tDestination WHERE tDestination.targetHandle = TARGET-PROCEDURE:
    IF VALID-HANDLE(tDestination.consumer) THEN
      RUN deleteConsumer IN tDestination.consumer.

    IF tDestination.subscription NE ? AND tDestination.unsubscribeclose THEN
      RUN cancelDurableSubscription IN hSession
        (INPUT tDestination.subscription).
  END.  /* for each tDestination */

  RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-errorHandler) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE errorHandler Procedure 
PROCEDURE errorHandler :
/*------------------------------------------------------------------------------
  Purpose:     This is the SmartConsumer's version of initializeObject.  It
               fetchesMessages to get and display any messages from the 
               its SUPER version of ErrorHandler.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phMessage         AS HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER phMessageConsumer AS HANDLE NO-UNDO.
DEFINE OUTPUT PARAMETER phReply           AS HANDLE NO-UNDO.

DEFINE VARIABLE cMessages      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cMsgText       AS CHARACTER NO-UNDO.
DEFINE VARIABLE iMsg           AS INTEGER   NO-UNDO.

  RUN SUPER
    (INPUT phMessage,
     INPUT phMessageConsumer,
     OUTPUT phReply).

  IF DYNAMIC-FUNCTION('anyMessage':U IN TARGET-PROCEDURE) THEN DO:
    cMessages = DYNAMIC-FUNCTION('fetchMessages':U IN TARGET-PROCEDURE).
    DO iMsg = 1 TO NUM-ENTRIES(cMessages, CHR(3)):
      cMsgText = cMsgText + 
        RIGHT-TRIM(ENTRY(iMsg, cMessages, CHR(3)), CHR(4)) + "~n":U.
    END.  /* do iMsg */
    IF cMsgText NE "":U THEN
      MESSAGE cMsgText VIEW-AS ALERT-BOX ERROR.
  END.  /* if error */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     SmartMessageConsumer version of initializeObject
  Parameters:  <none>
  Notes:       This re-directs output to a log file when running in batch mode.
               If a JMS Session was started without errors, processDestinations
               is run to get the destinations needed for creating message 
               consumers.  When running in batch mode, startWaitFor is invoked
               to start the Adapter's waitForMessages.
------------------------------------------------------------------------------*/
DEFINE VARIABLE cUIBmode   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cLogFile   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cMessages  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cMsgText   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPrefix    AS CHARACTER NO-UNDO.
DEFINE VARIABLE hContainer AS HANDLE    NO-UNDO.
DEFINE VARIABLE hRouter    AS HANDLE    NO-UNDO.
DEFINE VARIABLE hSession   AS HANDLE    NO-UNDO.
DEFINE VARIABLE iMsg       AS INTEGER   NO-UNDO.

  {get UIBmode cUIBmode}.
  
  IF NOT (cUIBmode BEGINS "Design":U) THEN DO:

    /* When running in batch, output needs to be directed to a log
      file, the name of the log file is based on the LogFile property
      value or the base file name + ".log" */
    IF SESSION:BATCH-MODE THEN DO:
      {get LogFile cLogFile}.

      IF cLogFile = "":U THEN DO: 
        RUN adecomm/_osprefx.p
          (INPUT SOURCE-PROCEDURE:FILE-NAME,
           OUTPUT cPrefix,
           OUTPUT cLogFile).
        cLogFile = ENTRY(1, cLogFile, ".":U) + ".log":U.
        {set LogFile cLogFile}.
      END.  /* if LogFile blank */

      OUTPUT TO VALUE(cLogFile).

    END.  /* if running in batch */

    RUN SUPER.

    /* If an error occured while creating or starting the JMS Session, we
       display the errors and destroy the container (which destroys this
       object when running in batch mode */
    IF DYNAMIC-FUNCTION('anyMessage':U IN TARGET-PROCEDURE) THEN DO:
      cMessages = DYNAMIC-FUNCTION('fetchMessages':U IN TARGET-PROCEDURE).
      DO iMsg = 1 TO NUM-ENTRIES(cMessages, CHR(3)):
        cMsgText = cMsgText + RIGHT-TRIM(ENTRY(iMsg, cMessages, CHR(3)), CHR(4)).
      END.  /* do iMsg */
      IF cMsgText NE "":U THEN
        MESSAGE cMsgText VIEW-AS ALERT-BOX ERROR.

      IF SESSION:BATCH-MODE THEN DO: 
        {get ContainerSource hContainer}.
        IF VALID-HANDLE(hContainer) THEN
          RUN destroyObject IN hContainer.
      END.  /* if running in batch */
    END.  /* if error */
    ELSE DO:
      {get JMSsession hSession}.
      
      /* processDestinations creates temp-table records for the destinations
         this consumer is receiving message from 
         createConsumers reads those temp-table records to create the 
         message consumers */
      RUN processDestinations IN TARGET-PROCEDURE.
      RUN createConsumers IN TARGET-PROCEDURE.
      RUN startReceiveMessages IN hSession.

      /* This sets the WaitForObject handle in the container so that the
         container will run startWaitFor in this object when it is 
         running in batch */
      IF SESSION:BATCH-MODE THEN DO:
        {get ContainerSource hContainer}.
        IF VALID-HANDLE(hContainer) THEN
          {set WaitForObject TARGET-PROCEDURE hContainer}.
      END.  /* if batch mode */
    END.  /* else do - no error */
  END.  /* if not Design mode */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-messageHandler) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE messageHandler Procedure 
PROCEDURE messageHandler :
/*------------------------------------------------------------------------------
  Purpose:     This procedure runs when a message is received.  It handles
               the incoming message by calling appropriate procedures in 
               its INMESSAGE-TARGET
  Parameters:  phMessage         AS HANDLE
               phMessageConsumer AS HANDLE
               phReply           AS HANDLE
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phMessage         AS HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER phMessageConsumer AS HANDLE NO-UNDO.
DEFINE OUTPUT PARAMETER phReply           AS HANDLE NO-UNDO.

DEFINE VARIABLE cMessageType     AS CHARACTER NO-UNDO.
DEFINE VARIABLE hInMessageTarget AS HANDLE    NO-UNDO.
DEFINE VARIABLE hRouterTarget    AS HANDLE    NO-UNDO.
DEFINE VARIABLE hSession         AS HANDLE    NO-UNDO.

  {get JMSsession hSession}.

  /* If this object is linked to a SmartRouter it passes the message to the
     SmartRouter and gets the handle of an InMessage Target (SmartB2BObject or
     SmartReceiver) with which it can communicate with otherwise it 
     communicates directly with the InMessage Target it is linked to.  */
  {get RouterTarget hRouterTarget}.
  IF VALID-HANDLE (hRouterTarget) THEN DO:
    RUN obtainInMsgTarget IN hRouterTarget 
      (INPUT phMessage,
       OUTPUT hInMessageTarget).
  END.  /* if linked to router object */
  ELSE DO:
    {get InMessageTarget hInMessageTarget}.
  END.  /* else do - not linked to router */

  /* If the router did not pass back a valid InMessage Target or this
     object is not linked to an InMessage Target, the message is not
     acknowledged so that the Sonic broker can re-send it.  */
  IF NOT VALID-HANDLE (hInMessageTarget) THEN
    RUN setNoAcknowledge IN phMessageConsumer.
  ELSE DO:
    RUN receiveHandler IN hInMessageTarget (INPUT phMessage) NO-ERROR.
    /* If there was an error processing the incoming message, or the 
       InMessage Target did not have a receiveHandler, the message is
       not acknowledged.  */
    IF ERROR-STATUS:ERROR THEN 
      RUN setNoAcknowledge IN phMessageConsumer.
    ELSE DO:
      /* If the incoming message has a ReplyTo set, then a reply is 
         created for the message based on the current message type.  */
      IF DYNAMIC-FUNCTION('hasReplyTo':U IN phMessage) THEN DO:
        {get MessageType cMessageType}.
        CASE cMessageType:
          WHEN "BytesMessage":U THEN
            RUN createBytesMessage IN hSession (OUTPUT phReply).
          WHEN "HeaderMessage":U THEN
            RUN createHeaderMessage IN hSession (OUTPUT phReply).
          WHEN "MapMessage":U THEN
            RUN createMapMessage IN hSession (OUTPUT phReply).
          WHEN "StreamMessage":U THEN
            RUN createStreamMessage IN hSession (OUTPUT phReply).
          WHEN "TextMessage":U THEN
            RUN createTextMessage IN hSession (OUTPUT phReply).
          WHEN "XMLMessage":U THEN
            RUN createXMLMessage IN hSession (OUTPUT phReply).
        END CASE.
        
        RUN sendReplyHandler IN hInMessageTarget (INPUT phReply) NO-ERROR.

      END.  /* replyto set on message */
    END.  /* else do - message was received */  
  END.  /* else do - In Message Target is valid */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processDestinations) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processDestinations Procedure 
PROCEDURE processDestinations :
/*------------------------------------------------------------------------------
  Purpose:    This procedure creates tDestination temp-table records from 
              Destinations, Subscriptions, and Selectors property values
  Parameters:  <none>
  Notes:      tDestination temp-table records are used to create message
              consumers for the destinations (queues/topics) this consumer
              is receiving messages from.  This can be overridden with a 
              version of processDestinations that creates its own tDestination 
              temp-table records rather than using the property values. 
------------------------------------------------------------------------------*/
DEFINE VARIABLE cDestinations  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cSubscriptions AS CHARACTER NO-UNDO.
DEFINE VARIABLE cSelectors     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cSub           AS CHARACTER NO-UNDO.
DEFINE VARIABLE iNumDest       AS INTEGER   NO-UNDO.

  {get Destinations cDestinations}.
  {get Subscriptions cSubscriptions}.
  {get Selectors cSelectors}.

  DO iNumDest = 1 TO NUM-ENTRIES(cDestinations, CHR(1)):
    CREATE tDestination.
    ASSIGN 
      tDestination.destination  = ENTRY(iNumDest, cDestinations, CHR(1))
      tdestination.selector     = IF ENTRY(iNumDest, cSelectors, CHR(1)) = "":U THEN ?
                                  ELSE ENTRY(iNumDest, cSelectors, CHR(1))
      tdestination.targetHandle = TARGET-PROCEDURE.
    
    cSub = ENTRY(iNumDest, cSubscriptions, CHR(1)).
    IF cSub = "":U THEN tdestination.subscription = ?.
    ELSE 
      ASSIGN
        tdestination.subscription = ENTRY(1, cSub, CHR(2))
        tdestination.unsubscribeclose = IF ENTRY(2, cSub, CHR(2)) = "yes":U THEN TRUE
                                        ELSE FALSE.

  END.  /* do iNumDest */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-startWaitFor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startWaitFor Procedure 
PROCEDURE startWaitFor :
/*------------------------------------------------------------------------------
  Purpose:     This procedure starts waiting for messages.
  Parameters:  <none>
  Notes:       This is called from initializeObject of the consumers
               Container-Source (when the container is non-visual) and when 
               SESSION:BATCH-MODE = YES.
               This should not be called if the consumer is running in a 
               non-batch environment, it blocks user input.
------------------------------------------------------------------------------*/
DEFINE VARIABLE cLogFile   AS CHARACTER NO-UNDO.
DEFINE VARIABLE hContainer AS HANDLE    NO-UNDO.
DEFINE VARIABLE hSession   AS HANDLE    NO-UNDO.

{get JMSsession hSession}.

    {get LogFile cLogFile}.
    OUTPUT TO VALUE(cLogFile).

    RUN waitForMessages IN hSession
      (INPUT "getWaiting":U,
       INPUT TARGET-PROCEDURE,
       INPUT ?).

    /* When waitForMessages has been satisfied, when a ShutDown message has
       been received, the container for this consumer is destroyed which 
       destroys this consumer as well */
    {get ContainerSource hContainer}.
    IF VALID-HANDLE(hContainer) THEN
      RUN destroyObject IN hContainer.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-stopHandler) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE stopHandler Procedure 
PROCEDURE stopHandler :
/*------------------------------------------------------------------------------
  Purpose:     This procedure sets the waiting property to FALSE to shut down
               the consumer object.
  Parameters:  <none>
  Notes:       The stopHandler is used for receiving a ShutDown message, this is
               most likely to be used when the consumer is running in batch mode.
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phMessage         AS HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER phMessageConsumer AS HANDLE NO-UNDO.
DEFINE OUTPUT PARAMETER phReply           AS HANDLE NO-UNDO.

  RUN deleteMessage IN phMessage.
  {set Waiting FALSE}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-defineDestination) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION defineDestination Procedure 
FUNCTION defineDestination RETURNS LOGICAL
  ( pcDestination AS CHARACTER,
    pcColumns     AS CHARACTER,
    pcValues      AS CHARACTER  ) :
/*------------------------------------------------------------------------------
  Purpose:  This function creates a tDestination temp-table record for use by
            createConsumers for creating message consumers
    Notes:  This can be called from an override of processDestinations to 
            explicitly create tDestination temp-table records rather than
            using instance properties.
------------------------------------------------------------------------------*/
DEFINE VARIABLE cColumn  AS CHARACTER NO-UNDO.
DEFINE VARIABLE hBuffer  AS HANDLE    NO-UNDO.
DEFINE VARIABLE hColumn  AS HANDLE    NO-UNDO.
DEFINE VARIABLE iNumCols AS INTEGER   NO-UNDO.

  ASSIGN hBuffer = BUFFER tDestination:HANDLE.

  hBuffer:BUFFER-CREATE().
  ASSIGN 
    hColumn = hBuffer:BUFFER-FIELD('destination':U)
    hColumn:BUFFER-VALUE = pcDestination
    hColumn = hBuffer:BUFFER-FIELD('targetHandle':U)
    hColumn:BUFFER-VALUE = TARGET-PROCEDURE.

  DO iNumCols = 1 TO NUM-ENTRIES(pcColumns):
    cColumn = ENTRY(iNumCols, pcColumns).
    ASSIGN 
      hColumn = hBuffer:BUFFER-FIELD(cColumn)
      hColumn:BUFFER-VALUE = IF NUM-ENTRIES(pcValues, CHR(1)) >= iNumCols
                             THEN ENTRY(iNumCols, pcValues, CHR(1))
                             ELSE ?.
  END.  /* do iNumcols */
                         
  RETURN hBuffer:AVAILABLE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDestinations) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDestinations Procedure 
FUNCTION getDestinations RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns Destinations property value 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDestinations AS CHARACTER NO-UNDO.
  {get Destinations cDestinations} NO-ERROR.
  RETURN cDestinations.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInMessageTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInMessageTarget Procedure 
FUNCTION getInMessageTarget RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the handle of the In Message target
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hTarget AS HANDLE NO-UNDO.
  {get InMessageTarget hTarget} NO-ERROR.
  RETURN hTarget. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLogFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLogFile Procedure 
FUNCTION getLogFile RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns Log File property value 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cLogFile AS CHARACTER NO-UNDO.
  {get LogFile cLogFile} NO-ERROR.
  RETURN cLogFile.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRouterTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRouterTarget Procedure 
FUNCTION getRouterTarget RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the handle of the Router target
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hTarget AS HANDLE NO-UNDO.
  {get RouterTarget hTarget} NO-ERROR.
  RETURN hTarget. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSelectors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSelectors Procedure 
FUNCTION getSelectors RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns Selectors property value 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSelectors AS CHARACTER NO-UNDO.
  {get Selectors cSelectors} NO-ERROR.
  RETURN cSelectors.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getShutDownDest) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getShutDownDest Procedure 
FUNCTION getShutDownDest RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns Shut Down Destination property value 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cShutDownDest AS CHARACTER NO-UNDO.
  {get ShutDownDest cShutDownDest} NO-ERROR.
  RETURN cShutDownDest.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSubscriptions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSubscriptions Procedure 
FUNCTION getSubscriptions RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns Subscriptions property value 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSubscriptions AS CHARACTER NO-UNDO.
  {get Subscriptions cSubscriptions} NO-ERROR.
  RETURN cSubscriptions.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWaiting) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWaiting Procedure 
FUNCTION getWaiting RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns Waiting property value 
    Notes: Waiting determines when waitForMessages is satisfied. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lWaiting AS LOGICAL NO-UNDO.
  {get Waiting lWaiting} NO-ERROR.
  RETURN lWaiting.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDestinations) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDestinations Procedure 
FUNCTION setDestinations RETURNS LOGICAL
  ( pcDestinations AS CHARACTER ) :
/*------------------------------------------------------------------------------
     Purpose: Sets the Destinations (Topics or Queues) this consumer can 
              receive messages from
  Parameters: pcDestinations AS CHARACTER
       Notes:  
------------------------------------------------------------------------------*/

  {set Destinations pcDestinations}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setInMessageTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setInMessageTarget Procedure 
FUNCTION setInMessageTarget RETURNS LOGICAL
  ( phTarget AS HANDLE ) :
/*------------------------------------------------------------------------------
     Purpose: Sets the InMessage Target
  Parameters: phTarget AS HANDLE
       Notes:  
------------------------------------------------------------------------------*/

  {set InMessageTarget phTarget}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLogFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLogFile Procedure 
FUNCTION setLogFile RETURNS LOGICAL
  ( pcLogFile AS CHARACTER ) :
/*------------------------------------------------------------------------------
     Purpose: Sets the LogFile used to log errors for the consumer when running
              in batch mode
  Parameters: pcLogFile AS CHARACTER
       Notes:  
------------------------------------------------------------------------------*/

  {set LogFile pcLogFile}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRouterTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRouterTarget Procedure 
FUNCTION setRouterTarget RETURNS LOGICAL
  ( phTarget AS HANDLE ) :
/*------------------------------------------------------------------------------
     Purpose: Sets the Router Target
  Parameters: phTarget AS HANDLE
       Notes:  
------------------------------------------------------------------------------*/

  {set RouterTarget phTarget}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSelectors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSelectors Procedure 
FUNCTION setSelectors RETURNS LOGICAL
  ( pcSelectors AS CHARACTER ) :
/*------------------------------------------------------------------------------
     Purpose: Sets the Message Selectors used for receiving messages
  Parameters: pcSelectors AS CHARACTER
       Notes:  
------------------------------------------------------------------------------*/

  {set Selectors pcSelectors}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setShutDownDest) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setShutDownDest Procedure 
FUNCTION setShutDownDest RETURNS LOGICAL
  ( pcShutDownDest AS CHARACTER ) :
/*------------------------------------------------------------------------------
     Purpose: Sets the Shut Down Destination used to consume a shut down 
              message which shuts down the consumer
  Parameters: pcShutDownDest AS CHARACTER
       Notes:  
------------------------------------------------------------------------------*/

  {set ShutDownDest pcShutDownDest}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSubscriptions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSubscriptions Procedure 
FUNCTION setSubscriptions RETURNS LOGICAL
  ( pcSubscriptions AS CHARACTER ) :
/*------------------------------------------------------------------------------
     Purpose: Sets the Subscriptions this consumer uses when subscribing
              to topics (only for Pub/Sub domain)
  Parameters: pcSubscriptions AS CHARACTER
       Notes:  
------------------------------------------------------------------------------*/

  {set Subscriptions pcSubscriptions}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setWaiting) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setWaiting Procedure 
FUNCTION setWaiting RETURNS LOGICAL
  ( plWaiting AS LOGICAL ) :
/*------------------------------------------------------------------------------
     Purpose: Sets the Waiting property which is used by the 
              adapter's waitForMessages to determne whether to continue
              waiting for messages.  
  Parameters: plWaiting AS LOGICAL
       Notes:  
------------------------------------------------------------------------------*/

  {set Waiting plWaiting}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

