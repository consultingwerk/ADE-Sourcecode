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
    File        : xml.p
    Purpose     : Super procedure for xml class.
                  Represents a simplified DOM API that encapsulates the 4GL 
                  DOM statments. The Node API does not use the handle, but
                  a decimal Node Id to identify the node. 
                  This API is currently only used for producer.
                   
                  The Consumer currently only uses the 'event' API.       
                  
    Syntax      : RUN start-super-proc("adm2/xml.p":U).

    Modified    : 08/07/2000
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&SCOP ADMSuper xml.p

  /* Custom exclude file */

  {src/adm2/custom/xmlexclcustom.i}

DEFINE VARIABLE gdNewNode    AS DEC    NO-UNDO.

DEFINE TEMP-TABLE tNode 
  FIELD Node         AS DECIMAL
  FIELD ParentNode   AS DECIMAL
  FIELD NodeHandle   AS HANDLE
  FIELD NodeType     AS CHAR 
  FIELD TagName      AS CHAR
  FIELD UniqueId     AS INT
  FIELD XPath        AS CHAR 
  FIELD TargetHandle AS HANDLE
  INDEX TargetHandle TargetHandle ParentNode Node  
  INDEX NodeId Node TargetHandle 
  INDEX NodeHandle NodeHandle.

DEFINE TEMP-TABLE tAttribute 
  FIELD Node          AS DECIMAL
  FIELD OwnerElement  AS DECIMAL
  FIELD AttributeName AS CHAR 
  FIELD XPath         AS CHAR 
  FIELD TargetHandle  AS HANDLE
  INDEX TargetHandle TargetHandle OwnerElement Node  
  INDEX AttributeId   Node TargetHandle
  INDEX AttributeName OwnerElement AttributeName.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-assignAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignAttribute Procedure 
FUNCTION assignAttribute RETURNS LOGICAL
  ( pdOwner  AS DECIMAL,
    pcName   AS CHAR,
    pcValue  AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignNodeValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignNodeValue Procedure 
FUNCTION assignNodeValue RETURNS LOGICAL
  ( pdNode  AS DECIMAL,
    pcValue  AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createAttribute Procedure 
FUNCTION createAttribute RETURNS DECIMAL
  (pdOwner  AS DEC,
   pcName   AS CHAR,
   pcValue  AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createDocument) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createDocument Procedure 
FUNCTION createDocument RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createElement) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createElement Procedure 
FUNCTION createElement RETURNS DECIMAL
  (pdParent AS DEC,
   pcName   AS CHAR,
   pcText   AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createNode Procedure 
FUNCTION createNode RETURNS DECIMAL
  (pdParent AS DEC,
   pcName   AS CHAR,
   pcType   AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createText) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createText Procedure 
FUNCTION createText RETURNS DECIMAL
  (pdParent AS DEC,
   pcText   AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteDocument) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD deleteDocument Procedure 
FUNCTION deleteDocument RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDocumentElement) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDocumentElement Procedure 
FUNCTION getDocumentElement RETURNS DECIMAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDocumentHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDocumentHandle Procedure 
FUNCTION getDocumentHandle RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDocumentInitialized) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDocumentInitialized Procedure 
FUNCTION getDocumentInitialized RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDTDPublicId) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDTDPublicId Procedure 
FUNCTION getDTDPublicId RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDTDSystemID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDTDSystemID Procedure 
FUNCTION getDTDSystemID RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNewNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNewNode Procedure 
FUNCTION getNewNode RETURNS DECIMAL PRIVATE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUseDTD) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUseDTD Procedure 
FUNCTION getUseDTD RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getValidateOnLoad) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getValidateOnLoad Procedure 
FUNCTION getValidateOnLoad RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-nodeHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD nodeHandle Procedure 
FUNCTION nodeHandle RETURNS HANDLE
  ( pdId AS DEC)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-nodeType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD nodeType Procedure 
FUNCTION nodeType RETURNS CHARACTER
  ( pdId AS DEC)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ownerElement) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD ownerElement Procedure 
FUNCTION ownerElement RETURNS DECIMAL
  ( pdAttributeNode AS DEC)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-parentNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD parentNode Procedure 
FUNCTION parentNode RETURNS DECIMAL
  (pdNode AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDocumentHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDocumentHandle Procedure 
FUNCTION setDocumentHandle RETURNS LOGICAL
  (phDocument AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDTDPublicId) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDTDPublicId Procedure 
FUNCTION setDTDPublicId RETURNS LOGICAL
  (pcPublicId AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDTDSystemID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDTDSystemID Procedure 
FUNCTION setDTDSystemID RETURNS LOGICAL
  (pcSystemId AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setValidateOnLoad) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setValidateOnLoad Procedure 
FUNCTION setValidateOnLoad RETURNS LOGICAL
  (plValidateOnLoad AS LOG)  FORWARD.

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
         HEIGHT             = 9.48
         WIDTH              = 59.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/xmlprop.i}

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
  Purpose: Override in order to delete the document and temp-table.     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDoc    AS HANDLE NO-UNDO.
  
  {fn deleteDocument}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processCDataSection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processCDataSection Procedure 
PROCEDURE processCDataSection :
/*------------------------------------------------------------------------------
  Purpose:    Process a CDATA-Section  node.  
  Parameters: This method just passes the event with path and value 
              information.   
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER phText AS HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER pcPath AS CHAR   NO-UNDO.
    
    RUN characterValue IN TARGET-PROCEDURE (pcPath, phText:NODE-VALUE). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processComment) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processComment Procedure 
PROCEDURE processComment :
/*------------------------------------------------------------------------------ 
Purpose:    Process a Comment node.   
Parameters: This method does nothing and must be overridden if there is a  
            need to process comments.   
   ------------------------------------------------------------------------------*/ 
 DEFINE INPUT PARAMETER phText AS HANDLE NO-UNDO. 
 DEFINE INPUT PARAMETER pcPath AS CHAR   NO-UNDO. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processDocument) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processDocument Procedure 
PROCEDURE processDocument :
/*------------------------------------------------------------------------------
   Purpose: Start the processing of the current document     
Parameters:  
     Notes:       
------------------------------------------------------------------------------*/
  RUN startDocument IN TARGET-PROCEDURE NO-ERROR.
  
  RUN processRoot IN TARGET-PROCEDURE.
  
  IF RETURN-VALUE BEGINS "ADM-ERROR":U THEN
    RETURN RETURN-VALUE. 

  RUN endDocument IN TARGET-PROCEDURE NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processElement) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processElement Procedure 
PROCEDURE processElement :
/*------------------------------------------------------------------------------
  Purpose: Processews an element document     
Parameters: phNode  - Current x-noderef handle 
            pcPath  - Current Documentpath (This is the logical path and not 
                      the numbered XPath)
  Notes:  - Calls startEvent before the children is processed and endEvent 
            after.       
          - Attributes are NOT processed in xml.p, but all the attributes
            names are passed as parameter to the startEvent. The developer 
            or super-procedure extention is responsible of processing data 
            from attributes.  
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phNode AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER pcPath AS CHAR   NO-UNDO.
  
  DEFINE VARIABLE cQualName    AS CHAR   NO-UNDO.
  DEFINE VARIABLE cPrefix      AS CHAR   NO-UNDO.
  DEFINE VARIABLE cName        AS CHAR   NO-UNDO.
  DEFINE VARIABLE cNameSpace   AS CHAR   NO-UNDO.
  DEFINE VARIABLE hChild       AS HANDLE NO-UNDO.
  DEFINE VARIABLE i            AS INT    NO-UNDO.
  DEFINE VARIABLE cAttributes  AS CHAR   NO-UNDO.
  DEFINE VARIABLE cAttr        AS CHAR   NO-UNDO.
  DEFINE VARIABLE cValue       AS CHAR   NO-UNDO.
  DEFINE VARIABLE cType        AS CHARACTER  NO-UNDO.

  ASSIGN
    cQualName    = phNode:NAME
    cPrefix      = IF NUM-ENTRIES(cQualName,":":U) > 1 
                   THEN ENTRY(1,cQualName,":":U)
                   ELSE "":U
    cName        = IF NUM-ENTRIES(cQualName,":":U) > 1 
                   THEN ENTRY(2,cQualName,":":U)
                   ELSE cQualname
    cNameSpace   = "":U
    pcPath       = pcPath + "/":U + cQualName.

  RUN startElement IN TARGET-PROCEDURE
    (pcPath, cNameSpace, cName, cQualName).
  
  IF RETURN-VALUE BEGINS "ADM-ERROR":U THEN
    RETURN RETURN-VALUE.

  cAttributes = phNode:ATTRIBUTE-NAMES.
  
  DO i = 1 TO NUM-ENTRIES(cAttributes):
    ASSIGN 
      cAttr  = ENTRY(i,cAttributes)
      cValue = phNode:GET-ATTRIBUTE(cAttr).

    RUN characterValue IN TARGET-PROCEDURE 
             (pcPath + "/":U + cAttr, cValue ) NO-ERROR.

    IF RETURN-VALUE BEGINS "ADM-ERROR":U THEN
      RETURN RETURN-VALUE.

  END.
  
  CREATE X-NODEREF hChild.
  
  DO i = 1 TO phNode:NUM-CHILDREN:
    IF phNode:GET-CHILD(hChild,i) THEN
    DO:  
       cType = hChild:SUBTYPE.
       
       IF cType = 'CDATA-SECTION':U THEN
          cType = 'CDataSection':U.

       RUN VALUE("process":U + cType) IN TARGET-PROCEDURE 
                (hChild, pcPath).
      
      IF RETURN-VALUE BEGINS "ADM-ERROR":U THEN
        RETURN RETURN-VALUE.

    END.
  END. /* do i = to  num-children */
  
  DELETE WIDGET hChild.

  RUN endElement IN TARGET-PROCEDURE
    (pcPath, cNameSpace, cName, cQualName).

  IF RETURN-VALUE BEGINS "ADM-ERROR":U THEN
    RETURN RETURN-VALUE.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processRoot) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processRoot Procedure 
PROCEDURE processRoot :
/*------------------------------------------------------------------------------
  Purpose:   Start processing the elements of the document    
  Parameters:  
  Notes:     This is just a starting point without events.     
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDoc       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRoot      AS HANDLE NO-UNDO.
  {get DocumentHandle hDoc}.

  CREATE X-NODEREF hRoot.

  hDoc:GET-DOCUMENT-ELEMENT(hRoot).
  
  RUN processElement IN TARGET-PROCEDURE (hRoot,"":U).
  
  DELETE WIDGET hRoot.

  IF RETURN-VALUE BEGINS "ADM-ERROR":U THEN
    RETURN RETURN-VALUE.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processText) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processText Procedure 
PROCEDURE processText :
/*------------------------------------------------------------------------------
  Purpose:    Process a text node.  
  Parameters:  <none>
  Notes:      This method just passes the event with path and value 
              information.   
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER phText AS HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER pcPath AS CHAR   NO-UNDO.
    
    RUN characterValue IN TARGET-PROCEDURE (pcPath, phText:NODE-VALUE). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-receiveHandler) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE receiveHandler Procedure 
PROCEDURE receiveHandler :
/*------------------------------------------------------------------------------
  Purpose:     This procedure handles the receiving of a message 
  Parameters:  phMessage AS HANDLE 
               - A procedure handle to the object with the JMS message
                 or any object with the following API:
                 - getMessageType - Type of message  
                 Types supported
                 BytesMessage
                 - getMemptr  - returns a mempointer with the XML message.                        
                 
  Notes:      An XML document is created and it is loaded from the message. 
              The Document is NOT processed by default. 
              The deveoper can override this to start processing the document 
              either by calling processDocument or other equivalent methods.  
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phMessage AS HANDLE NO-UNDO.

  DEFINE VARIABLE cMessageType AS CHAR    NO-UNDO.
  DEFINE VARIABLE hDocument    AS HANDLE  NO-UNDO.
  DEFINE VARIABLE mDocValue    AS MEMPTR  NO-UNDO.
  DEFINE VARIABLE lValidate    AS LOGICAL NO-UNDO.

  {fn createDocument}.

  {get DocumentHandle hDocument}.
  {get ValidateOnLoad lValidate}
  cMessageType = DYNAMIC-FUNCTION('getMessageType':U IN phMessage).
 
  /* The 9.1B router only supports Bytesmessage */
  CASE cMessageType:
    WHEN 'BytesMessage':U THEN
    DO:
       /* Gets the body of the received message */
       mDocValue = DYNAMIC-FUNCTION('getMemptr':U IN phMessage).
       /* Loads the body of the message into an XML document */
       hDocument:LOAD("MEMPTR":U, mDocValue, lValidate).
    END.

    OTHERWISE DO:
      {fnarg showMessage 
      'Message type ' + cMessageType + ' is currently not supported.'}. 
      RETURN ERROR "ADM-ERROR":U. 
    END.
  END CASE.

  SET-SIZE(mDocValue) = 0. 
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-receiveReplyHandler) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE receiveReplyHandler Procedure 
PROCEDURE receiveReplyHandler :
/*------------------------------------------------------------------------------
  Purpose:     The procedure handles the receiving of a reply to a message that 
               has been sent.
  Parameters:  phMessage AS HANDLE
  Notes:       phMessage is the handle of the JMS reply message being received
               An override of this procedure should get the Correlation ID of 
               the message to sync it to the original message being replied to,
               it should also get any needed property values and the body of
               the reply message.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phMessage AS HANDLE NO-UNDO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sendHandler) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sendHandler Procedure 
PROCEDURE sendHandler :
/*------------------------------------------------------------------------------
  Purpose:     This procedure sets the body of an outgoing message.
  Parameters:  phMessage AS HANDLE
  Notes:       phMessage is the handle of the JMS message being sent
               The document handle is saved into a memptr and the memptr is
               used to set the body of the Bytes Message.
               The DocumentHandle is expected to return an XML document. 
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phMessage AS HANDLE NO-UNDO.

  DEFINE VARIABLE hDocument AS HANDLE NO-UNDO.
  DEFINE VARIABLE mDocValue AS MEMPTR NO-UNDO.

  {get DocumentHandle hDocument}.

  hDocument:SAVE("MEMPTR":U, mDocValue).

    /* Sets the body of the message from the memptr */
  RUN setMemptr IN phMessage (mDocValue, ?, ?).

  SET-SIZE(mDocValue) = 0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sendReplyHandler) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sendReplyHandler Procedure 
PROCEDURE sendReplyHandler :
/*------------------------------------------------------------------------------
  Purpose:     The procedure processes a reply to a message
  Parameters:  phMessage AS HANDLE
  Notes:       phMessage is the handle of the JMS reply message being sent
               An override of this procedure should set any necessary 
               properties and the body of the reply message.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phMessage AS HANDLE NO-UNDO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-assignAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignAttribute Procedure 
FUNCTION assignAttribute RETURNS LOGICAL
  ( pdOwner  AS DECIMAL,
    pcName   AS CHAR,
    pcValue  AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER ownerElement FOR tnode.

  FIND OwnerElement WHERE OwnerElement.Node = pdOwner NO-ERROR.
   
  IF AVAIL OwnerElement THEN
    RETURN OwnerElement.NodeHandle:SET-ATTRIBUTE(pcName,pcValue).  
  ELSE
    RETURN FALSE.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignNodeValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignNodeValue Procedure 
FUNCTION assignNodeValue RETURNS LOGICAL
  ( pdNode  AS DECIMAL,
    pcValue  AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Assign the value of a node  
    Notes: This adds the attribute in the document to its owner  
------------------------------------------------------------------------------*/
  
  DEFINE BUFFER ownerElement FOR tnode.
  
  DEFINE VARIABLE cNodeType   AS CHAR NO-UNDO.
  DEFINE VARIABLE dId         AS DEC  NO-UNDO.
  DEFINE VARIABLE hNodeHandle AS HANDLE NO-UNDO.

  cNodeType = {fnarg NodeType pdNode}.
  
  CASE cNodeType:
    /* If this is an attribute find the temp-table and call assignAttribute
       which will set-attribute in the ownerElement */    
    WHEN "Attribute":U THEN
    DO:
      FIND tAttribute WHERE tAttribute.Node = pdNode NO-ERROR. 
      IF AVAIL tAttribute THEN
        RETURN DYNAMIC-FUNCTION('assignAttribute':U IN TARGET-PROCEDURE,
                                 tAttribute.OwnerElement,
                                 tAttribute.AttributeName,
                                 pcValue).
    END. /* attribute */
    WHEN "Element":U THEN
    DO:
      /* If this is an Element we call createText 
         createText will call this recursively with the created text node ! */

      dId = DYNAMIC-FUNCTION('createText':U IN TARGET-PROCEDURE,
                             pdNode,
                             pcValue).

      RETURN dId <> ?.
    END.
    OTHERWISE
    DO:   /* TEXT and others */
      ASSIGN
        hNodeHandle = {fnarg nodeHandle pdNode}
        hNodeHandle:NODE-VALUE = pcValue.
      
      RETURN TRUE.
    END. /* otherwise - TEXT and ? */

  END CASE.
    
  RETURN FALSE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createAttribute Procedure 
FUNCTION createAttribute RETURNS DECIMAL
  (pdOwner  AS DEC,
   pcName   AS CHAR,
   pcValue  AS CHAR) :
/*------------------------------------------------------------------------------
   Purpose: Create an Attribute in an element and return it's unique id. 
Parameters: pdParent: NodeId of OwnerElement.    
            pcName:   Name of the attribute. 
            pcText:   AttributeValue     
     Notes: The attribute is not added to the actual element if pcValue = ?   
------------------------------------------------------------------------------*/
  DEFINE BUFFER OwnerElement FOR tNode.

  FIND OwnerElement WHERE OwnerElement.Node = pdOwner NO-ERROR.
   
  IF AVAIL OwnerElement THEN
  DO:
    CREATE tAttribute.
    ASSIGN
      tAttribute.Node          = {fn getNewNode}
      tAttribute.OwnerElement  = OwnerElement.Node
      tAttribute.TargetHandle  = TARGET-PROCEDURE
      tAttribute.attributeName = pcName.
    
    IF pcValue <> ? THEN
      DYNAMIC-FUNCTION('assignAttribute':U IN TARGET-PROCEDURE,
                       OwnerElement.Node,
                       tAttribute.AttributeName,
                       pcValue).

    RETURN tAttribute.Node.
  END.
  ELSE 
    RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createDocument) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createDocument Procedure 
FUNCTION createDocument RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDoc AS HANDLE NO-UNDO.
  
  {fn deleteDocument}.

  CREATE X-DOCUMENT hDoc.  
  
  {set DocumentHandle hDoc}.  
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createElement) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createElement Procedure 
FUNCTION createElement RETURNS DECIMAL
  (pdParent AS DEC,
   pcName   AS CHAR,
   pcText   AS CHAR) :
/*------------------------------------------------------------------------------
   Purpose: Create an Element in the document and return it's unique id. 
Parameters: pdParent: NodeId of Parent.    
            pcName:   Name of the node. 
            pcText:   (? is no text)    
     Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dId AS DECIMAL NO-UNDO.
  
  dId = DYNAMIC-FUNCTION ('createNode':U IN TARGET-PROCEDURE,
                           pdParent,
                           pcName,
                           'Element':U).  
  
  IF pcText <> ? THEN
    DYNAMIC-FUNCTION ('createText':U IN TARGET-PROCEDURE,
                       dId,
                       pcText).
  
  RETURN dId.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createNode Procedure 
FUNCTION createNode RETURNS DECIMAL
  (pdParent AS DEC,
   pcName   AS CHAR,
   pcType   AS CHAR) :
/*------------------------------------------------------------------------------
   Purpose: Create a Node in the document and return its id. 
Parameters: pdParent: NodeId of Parent.    
            pcName:   Name of the node. 
            pcType:   Node type (? is element)    
     Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDocument    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cDTDSystemId AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDTDPublicId AS CHARACTER NO-UNDO.

  DEFINE BUFFER ParentNode FOR tNode.

  CREATE tNode.
  
  {get DocumentHandle hDocument}.
    
  CREATE X-NODEREF tNode.NodeHandle.
  
  /* pdParent = 0 means that this is the root element */
  IF pdParent = 0 THEN
  DO: 
    /* SystemId is mandatory info for DTD, so its existence triggers DTD */
    {get DTDSystemId cDTDSystemId}. /* returns blank on 9.1B */   
    /* Create and append the root node to the document if no dtd */ 
    IF cDTDSystemId = '':U THEN
    DO:
      hDocument:CREATE-NODE(tNode.NodeHandle,pcName,pcType).
      hDocument:APPEND-CHILD(tNode.NodeHandle).
    END.
       &IF {&CompileOn91C} &THEN
    ELSE /* Create a DTD and root node (we willnot get here in 9.1B) */
    DO: 
      {get DTDPublicId cDTDPublicId}.  /* returns blank on 9.1B */  
        
      hDocument:INITIALIZE-DOCUMENT-TYPE(?,pcName,cDTDPublicId,cDTDSystemId). 
      /* Get the root element that was created and appended to the document */  
      hDocument:GET-DOCUMENT-ELEMENT(tNode.NodeHandle).
    END.
      &ENDIF /* {&CompileOn91C} */
  END.
  ELSE DO:

    hDocument:CREATE-NODE(tNode.NodeHandle,pcName,pcType).


    IF pdParent <> ? THEN 
    DO:
      FIND ParentNode WHERE ParentNode.Node = pdParent NO-ERROR.
     
      IF AVAIL ParentNode THEN
      DO:
        IF ParentNode.NodeHandle:APPEND-CHILD(tNode.NodeHandle) THEN
          tNode.ParentNode = pdParent.
      END.
    END.
  END. /* pdParent <> 0 */

  ASSIGN 
    tNode.Node         = {fn getNewNode}
    tNode.TargetHandle = TARGET-PROCEDURE
    tNode.UniqueId     = tNode.NodeHandle:UNIQUE-ID
    tNode.NodeType     = tNode.NodeHandle:SUBTYPE.
  
  RETURN tNode.Node.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createText) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createText Procedure 
FUNCTION createText RETURNS DECIMAL
  (pdParent AS DEC,
   pcText   AS CHAR) :
/*------------------------------------------------------------------------------
   Purpose: Create a Text Node in the document and return it's unique id. 
Parameters: pdParent: NodeId of Parent Element.    
            pcText:      
     Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dId AS DECIMAL NO-UNDO.
  DEFINE VARIABLE hNodeHandle AS HANDLE NO-UNDO.
  
  dId = DYNAMIC-FUNCTION ('createNode':U IN TARGET-PROCEDURE,
                           pdParent,
                           ?,
                          'Text':U). 
  DYNAMIC-FUNCTION('assignNodeValue':U IN TARGET-PROCEDURE,
                   dId,
                   pcText).
  RETURN dId. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteDocument) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION deleteDocument Procedure 
FUNCTION deleteDocument RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Delete the document and clean up all the temp-tables 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDoc AS HANDLE NO-UNDO.

  {get DocumentHandle hDoc}.
  
  FOR EACH tNode WHERE tNode.TargetHandle = TARGET-PROCEDURE:
    IF VALID-HANDLE(tNode.NodeHandle) THEN
    DO:
      tNode.nodehandle:DELETE-NODE() NO-ERROR.
      DELETE WIDGET tNode.NodeHandle.
    END.
    DELETE tNode.
  END.

  FOR EACH tAttribute WHERE tAttribute.TargetHandle = TARGET-PROCEDURE:
    DELETE tAttribute.
  END.
  
  IF VALID-HANDLE(hDoc) THEN
    DELETE WIDGET hDoc.
  
  {set DocumentHandle ?}.

  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDocumentElement) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDocumentElement Procedure 
FUNCTION getDocumentElement RETURNS DECIMAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return the Id of the root element 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDoc  AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRoot AS HANDLE NO-UNDO.
  {get DocumentHandle hDoc}.
  FIND tNode WHERE tNode.ParentNode   = 0 
             AND   tNode.TargetHandle = TARGET-PROCEDURE NO-ERROR. 
  RETURN IF AVAIL tNode THEN tNode.Node ELSE ?. 
                                         
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDocumentHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDocumentHandle Procedure 
FUNCTION getDocumentHandle RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return the handle of the current document 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDocument AS HANDLE NO-UNDO.
  {get DocumentHandle hDocument}.
  RETURN hDocument.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDocumentInitialized) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDocumentInitialized Procedure 
FUNCTION getDocumentInitialized RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Check if the document is initialized, ie has a root node  
    Notes: Used by get and set DTDPublicId and DTDSystemId.  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hDoc     AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hRoot    AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cSubType AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lOK      AS LOGICAL    NO-UNDO.

 {get DocumentHandle hDoc}.
  
 IF VALID-HANDLE(hDoc) THEN
 DO:
   CREATE X-NODEREF hroot.
   hDoc:GET-DOCUMENT-ELEMENT(hRoot).
   cSubType = hRoot:SUBTYPE NO-ERROR. /* will give error if no node was found*/
   DELETE OBJECT hRoot. 
 END.

 RETURN VALID-HANDLE(hDOC) AND cSubType = 'ELEMENT':U. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDTDPublicId) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDTDPublicId Procedure 
FUNCTION getDTDPublicId RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
   Purpose: Returns the DTD Public id of the Document. 
Parameters: <none>
     Notes: This property may be stored as an ADM property. 
            - Adm property when DocumentInitialized is false
            - Otherwise the actual document Public-ID.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cID          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lInitialized AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hDoc         AS HANDLE     NO-UNDO.
  
  {get DocumentInitialized lInitialized}.
  
  /* This implies a valid doc */
  IF lInitialized THEN 
  DO:
    {get DocumentHandle hDoc}.
     &IF {&CompileOn91C} &THEN 
    RETURN hDoc:PUBLIC-ID.
     &ELSE 
    RETURN '':U.  
     &ENDIF
  END.

  &SCOPED-DEFINE xpDTDPublicID
  {get DTDPublicId cID}.
  &UNDEFINE xpDTDPublicID
  
  RETURN cID.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDTDSystemID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDTDSystemID Procedure 
FUNCTION getDTDSystemID RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
   Purpose: Returns the DTD System id of the Document. 
Parameters: <none>
     Notes: This property may be stored as an ADM property. 
            - Adm property when DocumentInitialized is false
            - Otherwise the actual document System-ID.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cID          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lInitialized AS LOGICAL NO-UNDO.
  DEFINE VARIABLE hDoc         AS HANDLE  NO-UNDO.
  
  {get DocumentInitialized lInitialized}.
 
  /* This implies a valid doc */
  IF lInitialized THEN 
  DO:
    {get DocumentHandle hDoc}.
       &IF {&CompileOn91C} &THEN 
    RETURN hDoc:SYSTEM-ID.
       &ELSE
    RETURN '':U.
       &ENDIF       
  END.

  &SCOPED-DEFINE xpDTDSystemID
  {get DTDSystemID cID}.
  &UNDEFINE xpDTDSystemID

  RETURN cID.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNewNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNewNode Procedure 
FUNCTION getNewNode RETURNS DECIMAL PRIVATE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Generate unique number for nodes. 
    Notes:  
------------------------------------------------------------------------------*/
  gdNewNode = gdNewNode + 1. 
  RETURN gdNewNode. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUseDTD) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUseDTD Procedure 
FUNCTION getUseDTD RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns true if dtd is to be used.   
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSystemId AS CHARACTER  NO-UNDO.
  
  {get DTDSystemId cSystemID}.
  
  RETURN cSystemID <> '':U.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getValidateOnLoad) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getValidateOnLoad Procedure 
FUNCTION getValidateOnLoad RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Decides whether the document should be validated on load.   
    Notes: Used in receiveHandler.  
           See help for X-DOCUMENT:LOAD      
------------------------------------------------------------------------------*/
  DEFINE VARIABLE plValidateOnLoad AS LOGICAL    NO-UNDO.
  {get ValidateOnLoad plValidateOnLoad}.
  RETURN plValidateOnLoad.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-nodeHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION nodeHandle Procedure 
FUNCTION nodeHandle RETURNS HANDLE
  ( pdId AS DEC) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  FIND tNode WHERE tNode.Node = pdId NO-ERROR.
  
  IF AVAIL tNode THEN 
    RETURN tNode.NodeHandle.   
  
  RETURN ?.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-nodeType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION nodeType Procedure 
FUNCTION nodeType RETURNS CHARACTER
  ( pdId AS DEC) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  FIND tNode WHERE tNode.Node = pdId NO-ERROR.
  IF AVAIL tNode THEN 
    RETURN tNode.NodeType.
  
  FIND tAttribute WHERE tAttribute.Node = pdId NO-ERROR.
  IF AVAIL tAttribute THEN
    RETURN "ATTRIBUTE":U.  
  
  RETURN ?. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ownerElement) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION ownerElement Procedure 
FUNCTION ownerElement RETURNS DECIMAL
  ( pdAttributeNode AS DEC) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  FIND tAttribute WHERE tAttribute.Node = pdAttributeNode NO-ERROR.
  
  IF AVAIL tattribute THEN 
    RETURN tAttribute.OwnerElement.
   
  RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-parentNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION parentNode Procedure 
FUNCTION parentNode RETURNS DECIMAL
  (pdNode AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER Node FOR tNode.

  FIND Node WHERE Node.Node = pdNode NO-ERROR.
  
  IF AVAIL Node THEN
    RETURN Node.ParentNode.
  
  RETURN ?.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDocumentHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDocumentHandle Procedure 
FUNCTION setDocumentHandle RETURNS LOGICAL
  (phDocument AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose: Store the xml document handle   
    Notes:  
------------------------------------------------------------------------------*/
  {set DocumentHandle phDocument}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDTDPublicId) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDTDPublicId Procedure 
FUNCTION setDTDPublicId RETURNS LOGICAL
  (pcPublicId AS CHAR) :
/*------------------------------------------------------------------------------
   Purpose: Sets the DTD Public id of the Document. 
Parameters: The Public Id of the next document that is being created.
     Notes: This property is stored until a document is produced. 
            They will then be used as the DTD publicId in the call to the 
            initialize-document-type method. This method MUST run as soon 
            as the document is created. 
            The get version of this property will return the adm property when 
            DocumentInitialized is false, but otherwise read from the actual 
            document PUBLIC-ID.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lInitialized AS LOGICAL    NO-UNDO.
  
  {get DocumentInitialized lInitialized}.
  
  IF lInitialized THEN 
  DO:
    {fnarg showMessage 
     'Cannot set DTD Public Id after the document has been initialized'}.
    RETURN FALSE.
  END.

  &SCOPED-DEFINE xpDTDPublicId
  {set DTDPublicId pcPublicId}.
  &UNDEFINE xpDTDPublicId
  
  RETURN TRUE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDTDSystemID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDTDSystemID Procedure 
FUNCTION setDTDSystemID RETURNS LOGICAL
  (pcSystemId AS CHAR) :
/*------------------------------------------------------------------------------
   Purpose: Sets the System id of the Document. 
Parameters: The System Id of the next document that is being created.
     Notes: This property is stored until a document is produced. 
            They will then be used as the DTD SystemId in the call to the 
            initialize-document-type method. This method MUST run as soon 
            as the document is created. 
            The get version of this property will return the adm property when 
            DocumentInitialized is false, but otherwise read from the actual 
            document System-ID.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lInitialized AS LOGICAL    NO-UNDO.
  
  {get DocumentInitialized lInitialized}.
  
  IF lInitialized THEN 
  DO:
    {fnarg showMessage 
     'Cannot set DTD System Id after the document has been initialized.'}.
    RETURN FALSE.
  END.

  &SCOPED-DEFINE xpDTDSystemId
  {set DTDSystemId pcSystemId}.
  &UNDEFINE xpDTDSystemId

  RETURN TRUE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setValidateOnLoad) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setValidateOnLoad Procedure 
FUNCTION setValidateOnLoad RETURNS LOGICAL
  (plValidateOnLoad AS LOG) :
/*------------------------------------------------------------------------------
  Purpose: Set validate on load.   
    Notes: Defines whether the document should be validated on load.
           See help for X-DOCUMENT:LOAD      
------------------------------------------------------------------------------*/
  {set ValidateOnLoad plValidateOnLoad}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

