&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: sax.p

  Description: A library of procedures for processing each of the SAX 
               callback events.

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Updated: 03/05/02 adams@progress.com
             Initial version
  Notes:   In this context, SELF handle refers to the SAX parser.  
           To stop the parser, set the STOP-PARSE property to TRUE.
  
           SELF:STOP-PARSING = TRUE.
------------------------------------------------------------------------*/
/*         This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created by this procedure. 
   This is a good default which assures that this procedure's triggers and 
   internal procedures will execute in this procedure's storage, and that 
   proper cleanup will occur on deletion of the procedure. */
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
&SCOPED-DEFINE ADMSuper sax.p

{src/adm2/custom/saxexclcustom.i}

/* Local Variable Definitions ---                                       */

DEFINE TEMP-TABLE ttStack NO-UNDO
  FIELD iSequence   AS INTEGER
  FIELD dParentNode AS DECIMAL
  FIELD dNode       AS DECIMAL
  FIELD cLocalName  AS CHARACTER
  FIELD cNamespace  AS CHARACTER
  FIELD cQName      AS CHARACTER
  FIELD cPath       AS CHARACTER
  INDEX iSequence iSequence
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

&IF DEFINED(EXCLUDE-getContextMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getContextMode Procedure 
FUNCTION getContextMode RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNode Procedure 
FUNCTION getNode RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getParentNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getParentNode Procedure 
FUNCTION getParentNode RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPath) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPath Procedure 
FUNCTION getPath RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSequence) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSequence Procedure 
FUNCTION getSequence RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getStackHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getStackHandle Procedure 
FUNCTION getStackHandle RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContextMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setContextMode Procedure 
FUNCTION setContextMode RETURNS LOGICAL
  ( plContextMode AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setNode Procedure 
FUNCTION setNode RETURNS LOGICAL
  ( dNode AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setParentNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setParentNode Procedure 
FUNCTION setParentNode RETURNS LOGICAL
  ( dParentNode AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPath) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPath Procedure 
FUNCTION setPath RETURNS LOGICAL
  ( pcPath AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSequence) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSequence Procedure 
FUNCTION setSequence RETURNS LOGICAL
  ( iSequence AS INTEGER )  FORWARD.

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
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 16.81
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/saxprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-characters) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE characters Procedure 
PROCEDURE characters :
/*------------------------------------------------------------------------------
  Purpose:     Report each chunk of character data.  
  Parameters:  <none>
  Notes:       The SAX parser may report contiguous character data in one chunk 
               or split it into several chunks.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pmCharArray   AS MEMPTR     NO-UNDO.
  DEFINE INPUT  PARAMETER piArrayLength AS INTEGER    NO-UNDO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-endDocument) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE endDocument Procedure 
PROCEDURE endDocument :
/*------------------------------------------------------------------------------
  Purpose:     Receives notification of the end of a document.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-endElement) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE endElement Procedure 
PROCEDURE endElement :
/*------------------------------------------------------------------------------
  Purpose:     End processing of an XML element.
  Parameters:  <none>
  Notes:       This procedure corresponds to a preceding startElement, after
               all element content is reported.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcNamespaceURI AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcLocalName    AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcQName        AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cPath        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iPos         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lContextMode AS LOGICAL    NO-UNDO.

  {get ContextMode lContextMode}.

  IF lContextMode THEN DO:
    {get Path cPath}.

    ASSIGN
      iPos   = R-INDEX(cPath, "/":U)

      /* Remove last node from cPath */
      cPath = IF iPos <= 1 THEN "" ELSE
                SUBSTRING(cPath, 1, iPos - 1, "character":U).
    
    /* Pop the node off the stack */
    FIND LAST ttStack.
    DELETE ttStack.

    {set Path cPath}.
  END.
      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-endPrefixMapping) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE endPrefixMapping Procedure 
PROCEDURE endPrefixMapping :
/*------------------------------------------------------------------------------
  Purpose:     Invoked when the XML parser detects that a prefix associated
               with a namespace mapping has gone out of scope.
  Notes:       This callback is invoked only when namespace processing is 
               enabled.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcPrefix AS CHARACTER  NO-UNDO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-error) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE error Procedure 
PROCEDURE error :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is run when a error condition occurs as defined 
               in section 1.2 of the XML 1.0 specification.
  Parameters:  <none>
  Notes:       The parser continues to provide normal parsing events after
               invoking this procedure.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcMessage      AS CHARACTER  NO-UNDO.
  
  RETURN ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fatalError) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fatalError Procedure 
PROCEDURE fatalError :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is run when a fatal error condition occurs as 
               defined in section 1.2 of the XML 1.0 specification.
  Parameters:  <none>
  Notes:       After a fatal error is reported, the assumption is made that the 
               document is unusable and future parsing events may not be
               reported.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcMessage      AS CHARACTER  NO-UNDO.
  
  RETURN ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ignorableWhitespace) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ignorableWhitespace Procedure 
PROCEDURE ignorableWhitespace :
/*------------------------------------------------------------------------------
  Purpose:     Report ignorable whitespace.
  Parameters:  <none>
  Notes:       When in validating mode, a parser must use this procedure to
               report ignorable whitespace.  It may optionally run this
               procedure when not validating.  A character string is used
               instead of a MEMPTR, because it is unlikely that an XML document
               will have over 32K of contiguous, ignorable whitespace.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcCharArray   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER piArrayLength AS INTEGER    NO-UNDO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-notationDecl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE notationDecl Procedure 
PROCEDURE notationDecl :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcName     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcPublicID AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcSystemID AS CHARACTER  NO-UNDO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processingInstruction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processingInstruction Procedure 
PROCEDURE processingInstruction :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       The parser will invoke this procedure once for each processing
               instruction.  Processing instructions can appear before or after
               the root document element.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcTarget AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcData   AS CHARACTER  NO-UNDO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resolveEntity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resolveEntity Procedure 
PROCEDURE resolveEntity :
/*------------------------------------------------------------------------------
  Purpose:     This procedure allows an application to specify a way to resolve
               entities in an XML document.
  Parameters:  <none>
  Notes:       Entities are identified with a required System Identifier and an
               optional Public Identifier.  Entities are defined in a DTD and
               include the DTD itself.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcPublicID     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcSystemID     AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcFilePath     AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pmMemPointer   AS MEMPTR     NO-UNDO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-startDocument) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startDocument Procedure 
PROCEDURE startDocument :
/*------------------------------------------------------------------------------
  Purpose:     Receives notification of the start of a document.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lContextMode AS LOGICAL NO-UNDO.

  {get ContextMode lContextMode}.

  /* Initialize temp-tables */
  IF lContextMode THEN
    EMPTY TEMP-TABLE ttStack.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-startElement) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startElement Procedure 
PROCEDURE startElement :
/*------------------------------------------------------------------------------
  Purpose:     Begin processing of an XML element.
  Notes:       This procedure is run at the beginning of every element in an
               XML document.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcNamespaceURI AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcLocalName    AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcQName        AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER phAttributes   AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE cPath        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dNode        AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dParentNode  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iSequence    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lContextMode AS LOGICAL    NO-UNDO.

  DEFINE BUFFER bufStack FOR ttStack.

  {get ContextMode lContextMode}.

  IF lContextMode THEN DO:
    {get Node dNode}.
    {get Path cPath}.

    FIND LAST bufStack NO-ERROR.
    ASSIGN
      iSequence   = (IF NOT AVAILABLE bufStack THEN 1
                     ELSE bufStack.iSequence + 1)
      dParentNode = (IF NOT AVAILABLE bufStack THEN 0
                     ELSE bufStack.dNode)
      dNode       = dNode + 1
      cPath       = (IF NOT AVAILABLE bufStack THEN "/":U + pcQName
                     ELSE bufStack.cPath + "/":U + pcQName).

    /* Push node onto stack */
    CREATE ttStack.
    ASSIGN
      ttStack.iSequence   = iSequence
      ttStack.dParentNode = dParentNode
      ttStack.dNode       = dNode
      ttStack.cLocalName  = pcLocalName
      ttStack.cQName      = pcQName
      ttStack.cNameSpace  = pcNamespaceURI
      ttStack.cPath       = cPath
      .

    {set ParentNode dParentNode}.
    {set Sequence iSequence}.
    {set Node dNode}.
    {set Path cPath}.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-startPrefixMapping) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startPrefixMapping Procedure 
PROCEDURE startPrefixMapping :
/*------------------------------------------------------------------------------
  Purpose:     Invoked when the XML parser detects that a prefix associated
               with namespace mapping is coming into scope.
  Notes:       This callback is invoked only when namespace processing is
               enabled.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcPrefix AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcURI    AS CHARACTER  NO-UNDO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-unparsedEntityDecl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE unparsedEntityDecl Procedure 
PROCEDURE unparsedEntityDecl :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcName         AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcPublicID     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcSystemID     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcNotationName AS CHARACTER  NO-UNDO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-warning) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE warning Procedure 
PROCEDURE warning :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is run when a non-error or non-fatal condition
               occurs as defined by the XML 1.0 specification.
  Parameters:  <none>
  Notes:       The parser continues to provided normal parsing events after
               invoking this procedure.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcMessage      AS CHARACTER  NO-UNDO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getContextMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getContextMode Procedure 
FUNCTION getContextMode RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lContextMode AS LOGICAL    NO-UNDO.

  {get ContextMode lContextMode}.

  RETURN lContextMode.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNode Procedure 
FUNCTION getNode RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dNode AS DECIMAL    NO-UNDO.

  {get Node dNode}.

  RETURN dNode.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getParentNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getParentNode Procedure 
FUNCTION getParentNode RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dParentNode AS DECIMAL    NO-UNDO.

  {get ParentNode dParentNode}.

  RETURN dParentNode.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPath) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPath Procedure 
FUNCTION getPath RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cPath AS CHARACTER  NO-UNDO.

  {get Path cPath}.

  RETURN cPath.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSequence) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSequence Procedure 
FUNCTION getSequence RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iSequence AS INTEGER    NO-UNDO.

  {get Sequence iSequence}.

  RETURN iSequence.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getStackHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getStackHandle Procedure 
FUNCTION getStackHandle RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hStack AS HANDLE     NO-UNDO.

  hStack = TEMP-TABLE ttStack:HANDLE.

  RETURN hStack.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContextMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setContextMode Procedure 
FUNCTION setContextMode RETURNS LOGICAL
  ( plContextMode AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:     Determine whether we should turn on context management, i.e. 
               keeping track of path information for the current node.
  Notes:       
------------------------------------------------------------------------------*/
  {set ContextMode plContextMode}.
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setNode Procedure 
FUNCTION setNode RETURNS LOGICAL
  ( dNode AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {set Node dNode}.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setParentNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setParentNode Procedure 
FUNCTION setParentNode RETURNS LOGICAL
  ( dParentNode AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {set ParentNode dParentNode}.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPath) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPath Procedure 
FUNCTION setPath RETURNS LOGICAL
  ( pcPath AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {set Path pcPath}.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSequence) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSequence Procedure 
FUNCTION setSequence RETURNS LOGICAL
  ( iSequence AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {set Sequence iSequence}.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

