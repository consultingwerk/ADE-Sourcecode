&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*      Bruce S Gruenbaum                                             *
*********************************************************************/
/*------------------------------------------------------------------------
    File        :   afddo.p
    Purpose     :   This procedure contains a number of functions and 
                    procedures that can be used to manipulate buffers, 
                    queries, and their contents.

    Description :

    Author(s)   :   Bruce S Gruenbaum
    Created     :   08/17/2001
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE TEMP-TABLE ttMessage NO-UNDO
  FIELD iMessageNo   AS INTEGER
  FIELD cMessageText AS CHARACTER
  FIELD iMessageCode AS INTEGER
  INDEX pudx IS UNIQUE PRIMARY
    iMessageNo
  .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-addMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addMessage Procedure 
FUNCTION addMessage RETURNS LOGICAL
  ( INPUT pcMessageString AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-checkError) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD checkError Procedure 
FUNCTION checkError RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-checkIntrinsicError) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD checkIntrinsicError Procedure 
FUNCTION checkIntrinsicError RETURNS LOGICAL PRIVATE
  ( /* No parameters */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-clearMessages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD clearMessages Procedure 
FUNCTION clearMessages RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createBuffers) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createBuffers Procedure 
FUNCTION createBuffers RETURNS CHARACTER
  ( INPUT pcBuffers AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createQuery Procedure 
FUNCTION createQuery RETURNS HANDLE
  ( INPUT pcBuffers AS CHARACTER,
    INPUT pcForEach AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteBuffers) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD deleteBuffers Procedure 
FUNCTION deleteBuffers RETURNS LOGICAL
  (  INPUT pcBuffers AS CHARACTER  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD deleteQuery Procedure 
FUNCTION deleteQuery RETURNS LOGICAL
  ( INPUT phQuery AS HANDLE,
    INPUT plDeleteBuffers AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findCurrent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findCurrent Procedure 
FUNCTION findCurrent RETURNS LOGICAL
  ( INPUT phBuffer AS HANDLE,
    INPUT pcLock   AS CHARACTER,
    INPUT plWait   AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findFirst) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findFirst Procedure 
FUNCTION findFirst RETURNS LOGICAL
  ( INPUT phBuffer AS HANDLE,
    INPUT pcWhere  AS CHARACTER,
    INPUT pcLock   AS CHARACTER,
    INPUT plWait   AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findLast) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findLast Procedure 
FUNCTION findLast RETURNS LOGICAL
  ( INPUT phBuffer AS HANDLE,
    INPUT pcWhere  AS CHARACTER,
    INPUT pcLock   AS CHARACTER,
    INPUT plWait   AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findUnique) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findUnique Procedure 
FUNCTION findUnique RETURNS LOGICAL
  ( INPUT phBuffer AS HANDLE,
    INPUT pcWhere  AS CHARACTER,
    INPUT pcLock   AS CHARACTER,
    INPUT plWait   AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMessage Procedure 
FUNCTION getMessage RETURNS CHARACTER
  ( INPUT iMessageNo AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNumMessages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNumMessages Procedure 
FUNCTION getNumMessages RETURNS INTEGER
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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-addMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addMessage Procedure 
FUNCTION addMessage RETURNS LOGICAL
  ( INPUT pcMessageString AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttMessage FOR ttMessage.
  DEFINE VARIABLE iMessage   AS INTEGER    NO-UNDO.

  iMessage = getNumMessages(). 

  DO TRANSACTION:
    CREATE bttMessage.
    ASSIGN
      bttMessage.iMessageNo = iMessage + 1
      bttMessage.cMessage = pcMessageString
      .
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-checkError) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION checkError Procedure 
FUNCTION checkError RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Checks whether there are any errors (intrinsic or otherwise) that
            have occurred since the last call.
    Notes:  
------------------------------------------------------------------------------*/

  /* By returning one or the other, the first function is executed. If it 
     returns YES, the second function is never run */
  RETURN checkIntrinsicError() OR 
         getNumMessages() > 0.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-checkIntrinsicError) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION checkIntrinsicError Procedure 
FUNCTION checkIntrinsicError RETURNS LOGICAL PRIVATE
  ( /* No parameters */ ) :
/*------------------------------------------------------------------------------
  Purpose:  This function checks the error status handle and adds messages to 
            the message list that can be returned to the client.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iCount AS INTEGER    NO-UNDO.

  IF NOT ERROR-STATUS:ERROR AND
     ERROR-STATUS:NUM-MESSAGES = 0 THEN
    RETURN FALSE.

  IF ERROR-STATUS:NUM-MESSAGES = 0 THEN
    addMessage("Unknown Error - No message on ERROR-STATUS handle"). 
  ELSE
  DO iCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
    addMessage(ERROR-STATUS:GET-MESSAGE(iCount)).
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-clearMessages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION clearMessages Procedure 
FUNCTION clearMessages RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Clears the message list temp-table.
    Notes:  
------------------------------------------------------------------------------*/

  EMPTY TEMP-TABLE ttMessage.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createBuffers) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createBuffers Procedure 
FUNCTION createBuffers RETURNS CHARACTER
  ( INPUT pcBuffers AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBuffer     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCount      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cRetVal     AS CHARACTER  NO-UNDO.

  DO iCount = 1 TO NUM-ENTRIES(pcBuffers):
    hBuffer= ?.
    hBuffer = WIDGET-HANDLE(ENTRY(iCount,pcBuffers)) NO-ERROR.
    ERROR-STATUS:ERROR = NO.
    IF NOT VALID-HANDLE(hBuffer) THEN
      CREATE BUFFER hBuffer FOR TABLE ENTRY(iCount,pcBuffers) NO-ERROR.

    checkIntrinsicError().
      
    ERROR-STATUS:ERROR = NO.

    IF VALID-HANDLE(hBuffer) THEN
      cRetVal = cRetVal + (IF cRetVal = "":U THEN "":U ELSE ",":U) 
              + STRING(hBuffer).
    ELSE
      cRetVal = ?.
  END.

  RETURN cRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createQuery Procedure 
FUNCTION createQuery RETURNS HANDLE
  ( INPUT pcBuffers AS CHARACTER,
    INPUT pcForEach AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Creates and prepares a query based on the buffer(s).
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBuffer     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCount      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cBufferList AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewBuffs   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lError      AS LOGICAL    INITIAL NO NO-UNDO.

  /* First make sure we have buffer handles for all the buffers */
  cBufferList = createBuffers(pcBuffers). 
  IF cBufferList = ? THEN
    RETURN ?.

  CREATE QUERY hQuery.

  DO iCount = 1 TO NUM-ENTRIES(cBufferList):
    hBuffer = ?.
    IF ENTRY(iCount,cBufferList) <> ENTRY(iCount,pcBuffers) THEN
      cNewBuffs = cNewBuffs + (IF cNewBuffs = "":U THEN "":U ELSE ",":U)
                + ENTRY(iCount,cBufferList).
    hBuffer = WIDGET-HANDLE(ENTRY(iCount,cBufferList)) NO-ERROR.
    IF NOT lError AND VALID-HANDLE(hBuffer) THEN
      hQuery:ADD-BUFFER(hBuffer).
    ELSE
      lError = YES.
  END.

  IF NOT lError THEN
    lError = NOT hQuery:QUERY-PREPARE(pcForEach) NO-ERROR.

  lError = lError OR checkIntrinsicError().

  ERROR-STATUS:ERROR = NO.

  IF lError THEN
  DO:
    deleteBuffers(cNewBuffs).
    DELETE OBJECT hQuery.
    hQuery = ?.
  END.

  RETURN hQuery.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteBuffers) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION deleteBuffers Procedure 
FUNCTION deleteBuffers RETURNS LOGICAL
  (  INPUT pcBuffers AS CHARACTER  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBuffer     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCount      AS INTEGER    NO-UNDO.

  DO iCount = 1 TO NUM-ENTRIES(pcBuffers):
    hBuffer = WIDGET-HANDLE(ENTRY(iCount,pcBuffers)) NO-ERROR.
    IF VALID-HANDLE(hBuffer) THEN
    DO:
      DELETE OBJECT hBuffer.
      hBuffer = ?.
    END.
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION deleteQuery Procedure 
FUNCTION deleteQuery RETURNS LOGICAL
  ( INPUT phQuery AS HANDLE,
    INPUT plDeleteBuffers AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:   Deletes a query and (optionally) its associated buffers.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cBuffList AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hBuffer   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCount    AS INTEGER    NO-UNDO.

  IF NOT VALID-HANDLE(phQuery) THEN
    RETURN FALSE.

  IF plDeleteBuffers THEN
  DO iCount = 1 TO phQuery:NUM-BUFFERS:
    hBuffer = phQuery:GET-BUFFER-HANDLE(iCount).
    cBuffList = cBuffList + (IF cBuffList = "":U THEN "":U ELSE ",":U)
              + STRING(hBuffer).
  END.

  IF phQuery:IS-OPEN THEN
    phQuery:QUERY-CLOSE().

  DELETE OBJECT phQuery.
  phQuery = ?.

  IF plDeleteBuffers THEN
    deleteBuffers(cBuffList).

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findCurrent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findCurrent Procedure 
FUNCTION findCurrent RETURNS LOGICAL
  ( INPUT phBuffer AS HANDLE,
    INPUT pcLock   AS CHARACTER,
    INPUT plWait   AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Re-find the current record in the buffer with a different lock.
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE roRowid AS ROWID      NO-UNDO.
  DEFINE VARIABLE lAns    AS LOGICAL    NO-UNDO.

  clearMessages().

  roRowid = phBuffer:ROWID.

  phBuffer:BUFFER-RELEASE().

  CASE pcLock:
    WHEN "EXCLUSIVE-LOCK":U THEN
    DO:
      IF plWait THEN
        lAns = phBuffer:FIND-BY-ROWID(roRowid, EXCLUSIVE-LOCK) NO-ERROR.
      ELSE
        lAns = phBuffer:FIND-BY-ROWID(roRowid, EXCLUSIVE-LOCK, NO-WAIT) NO-ERROR.
    END.
    WHEN "SHARE-LOCK" THEN
    DO:
      IF plWait THEN
        lAns = phBuffer:FIND-BY-ROWID(roRowid, SHARE-LOCK) NO-ERROR.
      ELSE
        lAns = phBuffer:FIND-BY-ROWID(roRowid, SHARE-LOCK, NO-WAIT) NO-ERROR.
    END.
    OTHERWISE
      lAns = phBuffer:FIND-BY-ROWID(roRowid, NO-LOCK) NO-ERROR.
  END CASE.

  checkIntrinsicError().

  ERROR-STATUS:ERROR = NO.

  RETURN phBuffer:AVAILABLE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findFirst) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findFirst Procedure 
FUNCTION findFirst RETURNS LOGICAL
  ( INPUT phBuffer AS HANDLE,
    INPUT pcWhere  AS CHARACTER,
    INPUT pcLock   AS CHARACTER,
    INPUT plWait   AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Finds the first record that matches the WHERE criteria
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cForEach AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAns     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lError   AS LOGICAL    NO-UNDO.
  
  clearMessages().

  cForEach = "FOR EACH ":U + phBuffer:NAME 
           + " WHERE ":U + pcWhere.

  hQuery = createQuery(STRING(phBuffer), cForEach).

  /* If we failed to create a query then the query handle
     is invalid. This can only happen because the buffers
     were invalid or the QUERY-PREPARE failed. */
  IF hQuery = ? THEN
    RETURN FALSE.

  hQuery:QUERY-OPEN().

  CASE pcLock:
    WHEN "EXCLUSIVE-LOCK":U THEN
    DO:
      IF plWait THEN
        lAns = hQuery:GET-FIRST(EXCLUSIVE-LOCK) NO-ERROR.
      ELSE
        lAns = hQuery:GET-FIRST(EXCLUSIVE-LOCK, NO-WAIT) NO-ERROR.
    END.
    WHEN "SHARE-LOCK" THEN
    DO:
      IF plWait THEN
        lAns = hQuery:GET-FIRST(SHARE-LOCK) NO-ERROR.
      ELSE
        lAns = hQuery:GET-FIRST(SHARE-LOCK, NO-WAIT) NO-ERROR.
    END.
    OTHERWISE
      lAns = hQuery:GET-FIRST(NO-LOCK) NO-ERROR.
  END CASE.

  lError = checkIntrinsicError().

  /* No matter what happened above, we have to close the query here
     and delete the query object. */
  hQuery:QUERY-CLOSE().
  deleteQuery(hQuery, NO).

  /* If there is an error, make sure no record is available in the 
     buffer */
  IF lError OR 
     ERROR-STATUS:ERROR THEN
    phBuffer:REPOSITION-TO-ROWID(?) NO-ERROR.
     
  /* Reset error status. */
  ERROR-STATUS:ERROR = NO.

  RETURN phBuffer:AVAILABLE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findLast) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findLast Procedure 
FUNCTION findLast RETURNS LOGICAL
  ( INPUT phBuffer AS HANDLE,
    INPUT pcWhere  AS CHARACTER,
    INPUT pcLock   AS CHARACTER,
    INPUT plWait   AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Finds the first record that matches the WHERE criteria
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cForEach AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAns     AS LOGICAL    NO-UNDO.
  
  clearMessages().

  cForEach = "FOR EACH ":U + phBuffer:NAME 
           + " WHERE ":U + pcWhere.

  hQuery = createQuery(STRING(phBuffer), cForEach).

  IF hQuery = ? THEN
    RETURN FALSE.

  hQuery:QUERY-OPEN().

  CASE pcLock:
    WHEN "EXCLUSIVE-LOCK":U THEN
    DO:
      IF plWait THEN
        lAns = hQuery:GET-LAST(EXCLUSIVE-LOCK) NO-ERROR.
      ELSE
        lAns = hQuery:GET-LAST(EXCLUSIVE-LOCK, NO-WAIT) NO-ERROR.
    END.
    WHEN "SHARE-LOCK" THEN
    DO:
      IF plWait THEN
        lAns = hQuery:GET-LAST(SHARE-LOCK) NO-ERROR.
      ELSE
        lAns = hQuery:GET-LAST(SHARE-LOCK, NO-WAIT) NO-ERROR.
    END.
    OTHERWISE
      lAns = hQuery:GET-LAST(NO-LOCK) NO-ERROR.
  END CASE.

  checkIntrinsicError().

  hQuery:QUERY-CLOSE().
  deleteQuery(hQuery, NO).
  
  ERROR-STATUS:ERROR = NO.

  RETURN phBuffer:AVAILABLE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findUnique) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findUnique Procedure 
FUNCTION findUnique RETURNS LOGICAL
  ( INPUT phBuffer AS HANDLE,
    INPUT pcWhere  AS CHARACTER,
    INPUT pcLock   AS CHARACTER,
    INPUT plWait   AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Finds a record and ensures that the find is unique.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lAns   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hBuff1 AS HANDLE     NO-UNDO.

  clearMessages().

  lAns = findFirst(phBuffer, pcWhere, pcLock, plWait).

  IF NOT lAns THEN
  DO:
    addMessage (phBuffer:NAME + " not found where " + pcWhere).
    RETURN FALSE. /* Record not found */
  END.

  CREATE BUFFER hBuff1 FOR TABLE phBuffer NO-ERROR.
  IF checkIntrinsicError() THEN
  DO:
    addMessage("Failed to alternate buffer for " + phBuffer:NAME).
    phBuffer:BUFFER-RELEASE().
    RETURN FALSE.
  END.

  lAns = findLast(hBuff1, pcWhere, "":U, NO). /* Find the last record in the query */
  IF lAns AND
     hBuff1:ROWID <> phBuffer:ROWID THEN
  DO:
    addMessage("More than one " + phBuffer:NAME + " exists where " + pcWhere). 
    phBuffer:BUFFER-RELEASE().
  END.
  
  hBuff1:BUFFER-RELEASE().
  DELETE OBJECT hBuff1.

  RETURN phBuffer:AVAILABLE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMessage Procedure 
FUNCTION getMessage RETURNS CHARACTER
  ( INPUT iMessageNo AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a message from the message list.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttMessage FOR ttMessage.

  DO FOR bttMessage:
    FIND bttMessage NO-LOCK 
      WHERE bttMessage.iMessageNo = iMessageNo
      NO-ERROR.
    IF AVAILABLE(bttMessage) THEN
      RETURN bttMessage.cMessage.
    ELSE
      RETURN "":U.
  END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNumMessages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNumMessages Procedure 
FUNCTION getNumMessages RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Gets the number of messages in the temp-table
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttMessage     FOR ttMessage.
  DEFINE VARIABLE iNumMessages AS INTEGER    NO-UNDO.

  FIND LAST bttMessage NO-LOCK NO-ERROR.
  IF AVAILABLE(bttMessage) THEN
    iNumMessages = bttMessage.iMessageNo.
  ELSE
    iNumMessages = 0.

  RETURN iNumMessages.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

