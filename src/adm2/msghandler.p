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
    File        : msghandler.p
    Purpose     : Super procedure for msghandler class.

    Syntax      : RUN start-super-proc("adm2/msghandler.p":U).

    Modified    : 05/11/2000
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


&SCOP ADMSuper msghandler.p

  /* Custom exclude file */

  {src/adm2/custom/msghandlerexclcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getCurrentMessageId) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentMessageId Procedure 
FUNCTION getCurrentMessageId RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDestination) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDestination Procedure 
FUNCTION getDestination RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInMessageSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInMessageSource Procedure 
FUNCTION getInMessageSource RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOutMessageTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getOutMessageTarget Procedure 
FUNCTION getOutMessageTarget RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getReplyRequired) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getReplyRequired Procedure 
FUNCTION getReplyRequired RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getReplySelector) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getReplySelector Procedure 
FUNCTION getReplySelector RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCurrentMessageId) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCurrentMessageId Procedure 
FUNCTION setCurrentMessageId RETURNS LOGICAL
  ( pcCurrentMessageID AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDestination) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDestination Procedure 
FUNCTION setDestination RETURNS LOGICAL
  ( pcDestination AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setInMessageSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setInMessageSource Procedure 
FUNCTION setInMessageSource RETURNS LOGICAL
  ( phSource AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setOutMessageTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setOutMessageTarget Procedure 
FUNCTION setOutMessageTarget RETURNS LOGICAL
  ( phTarget AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setReplyRequired) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setReplyRequired Procedure 
FUNCTION setReplyRequired RETURNS LOGICAL
  ( plReplyRequired AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setReplySelector) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setReplySelector Procedure 
FUNCTION setReplySelector RETURNS LOGICAL
  ( pcReplySelector AS CHARACTER )  FORWARD.

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

{src/adm2/msghprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-sendMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sendMessage Procedure 
PROCEDURE sendMessage :
/*------------------------------------------------------------------------------
  Purpose:     This procedure sends the Message to the Out Message Target
  Parameters:  <None>
  Notes:       This runs sendMessage with NO-ERROR and checks the error-status
               after the call. If an error occured, the errors are retrieved
               with fetchMessages and passed to the sendErrorHandler. Errors
               that occur in sendMessage in the OutMessageTarget is expected to 
               be added to the message queue with addMessage.
               The Message Id returned from the Out Message Target will be 
               stored in the CurrentMessageId property if ReplyRequired.
------------------------------------------------------------------------------*/
DEFINE VARIABLE cDestination      AS CHARACTER NO-UNDO.
DEFINE VARIABLE lReplyReq         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cReplySelector    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cMessageID        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cMessages         AS CHARACTER NO-UNDO.
DEFINE VARIABLE hOutMessageTarget AS HANDLE    NO-UNDO.

  {get OutMessageTarget hOutMessageTarget}.

  IF NOT VALID-HANDLE(hOutMessageTarget) THEN
    RETURN.

  {get Destination cDestination}.
  {get ReplyRequired lReplyReq}.
  {get ReplySelector cReplySelector}.

  RUN sendMessage IN hOutMessageTarget
    (INPUT cDestination,
     INPUT lReplyReq,
     INPUT cReplySelector,
     OUTPUT cMessageID) NO-ERROR.

  IF ERROR-STATUS:ERROR THEN 
  DO:
    cMessages = DYNAMIC-FUNCTION('fetchMessages':U IN hOutMessageTarget).    
    {set CurrentMessageId ?}.
    RUN sendErrorHandler IN TARGET-PROCEDURE(cMessages) NO-ERROR. 
  END. /* if error */
  ELSE IF lReplyReq THEN
    {set CurrentMessageId cMessageId}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getCurrentMessageId) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentMessageId Procedure 
FUNCTION getCurrentMessageId RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the Current Message Id value 
    Notes: The Current Message Id holds the id from the last sendMessage 
           with ReplyRequired.    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cCurrentMessageID AS CHARACTER NO-UNDO.
  {get CurrentMessageID cCurrentMessageID} NO-ERROR.
  RETURN cCurrentMessageID.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDestination) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDestination Procedure 
FUNCTION getDestination RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns Destination property value 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDestination AS CHARACTER NO-UNDO.
  {get Destination cDestination} NO-ERROR.
  RETURN cDestination.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInMessageSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInMessageSource Procedure 
FUNCTION getInMessageSource RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the handle of the In Message source
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSource AS HANDLE NO-UNDO.
  {get InMessageSource hSource} NO-ERROR.
  RETURN hSource. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOutMessageTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getOutMessageTarget Procedure 
FUNCTION getOutMessageTarget RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the handle of the Out Message target
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hTarget AS HANDLE NO-UNDO.
  {get OutMessageTarget hTarget} NO-ERROR.
  RETURN hTarget. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getReplyRequired) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getReplyRequired Procedure 
FUNCTION getReplyRequired RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns Reply Required property value 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lReplyRequired AS LOGICAL NO-UNDO.
  {get ReplyRequired lReplyRequired} NO-ERROR.
  RETURN lReplyRequired.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getReplySelector) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getReplySelector Procedure 
FUNCTION getReplySelector RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns Reply Selector property value 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cReplySelector AS CHARACTER NO-UNDO.
  {get ReplySelector cReplySelector} NO-ERROR.
  RETURN cReplySelector.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCurrentMessageId) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCurrentMessageId Procedure 
FUNCTION setCurrentMessageId RETURNS LOGICAL
  ( pcCurrentMessageID AS CHARACTER ) :
/*------------------------------------------------------------------------------
   Purpose: Sets the Current Message Id value 
Parameters: pcCurrentMessageID AS CHARACTER
     Notes:     
------------------------------------------------------------------------------*/
  {set CurrentMessageID pcCurrentMessageID}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDestination) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDestination Procedure 
FUNCTION setDestination RETURNS LOGICAL
  ( pcDestination AS CHARACTER ) :
/*------------------------------------------------------------------------------
     Purpose: Sets the Destination for the current message
  Parameters: pcDestination AS CHARACTER
       Notes:  
------------------------------------------------------------------------------*/
  {set Destination pcDestination}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setInMessageSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setInMessageSource Procedure 
FUNCTION setInMessageSource RETURNS LOGICAL
  ( phSource AS HANDLE ) :
/*------------------------------------------------------------------------------
     Purpose: Sets the InMessage Source
  Parameters: phSource AS HANDLE
       Notes:  
------------------------------------------------------------------------------*/
  {set InMessageSource phSource}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setOutMessageTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setOutMessageTarget Procedure 
FUNCTION setOutMessageTarget RETURNS LOGICAL
  ( phTarget AS HANDLE ) :
/*------------------------------------------------------------------------------
     Purpose: Sets the Out Message Target
  Parameters: phTarget AS HANDLE
       Notes:  
------------------------------------------------------------------------------*/
  {set OutMessageTarget phTarget}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setReplyRequired) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setReplyRequired Procedure 
FUNCTION setReplyRequired RETURNS LOGICAL
  ( plReplyRequired AS LOGICAL ) :
/*------------------------------------------------------------------------------
     Purpose: Sets the Reply Required flag for the current message
  Parameters: plReplyRequired AS LOGICAL
       Notes:  
------------------------------------------------------------------------------*/
    {set ReplyRequired plReplyRequired}.
    RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setReplySelector) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setReplySelector Procedure 
FUNCTION setReplySelector RETURNS LOGICAL
  ( pcReplySelector AS CHARACTER ) :
/*------------------------------------------------------------------------------
     Purpose: Sets the Reply Selector for the current message
  Parameters: pcReplySelector AS CHARACTER
       Notes:  
------------------------------------------------------------------------------*/
  {set ReplySelector pcReplySelector}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

