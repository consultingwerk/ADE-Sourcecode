&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Procedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Procedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*---------------------------------------------------------------------------------
  File: insaxparser.p

  Description:  DCU SAX parser

  Purpose:      SAX parser for reading XML files for DCU

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   05/15/2003  Author:     

  Update Notes: Created from Template rytemprocp.p
                

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       insaxparserp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

DEFINE VARIABLE gdNodeNo     AS DECIMAL    NO-UNDO.
DEFINE VARIABLE giNodeLevel  AS INTEGER    NO-UNDO.
DEFINE VARIABLE giParserNo   AS INTEGER    NO-UNDO.


/* Buffer associations - Associates a buffer with a node in the XML file */
DEFINE TEMP-TABLE ttBuffAssoc NO-UNDO
  FIELD cNode           AS CHARACTER
  FIELD hBuffer         AS HANDLE
  INDEX pudx IS PRIMARY UNIQUE
    cNode
  .

/* Field associations - A field in a node buffer is associated with a node or 
   attribute value */
DEFINE TEMP-TABLE ttFieldAssoc NO-UNDO
  FIELD cNode           AS CHARACTER
  FIELD cFieldName      AS CHARACTER
  FIELD cNodeAttr       AS CHARACTER
  FIELD hField          AS HANDLE
  INDEX dx IS PRIMARY
    cNode
    cNodeAttr
  .
 

/* Stack table - Working table used during the parsing of the XML file to 
   store data before it is written to ttNode and ttNodeAttr */
DEFINE TEMP-TABLE ttStack NO-UNDO
  FIELD iStackLevel     AS INTEGER
  FIELD cNodeNamespace  AS CHARACTER
  FIELD cFullNodeName   AS CHARACTER
  FIELD cNodeName       AS CHARACTER
  FIELD cNodeValue      AS CHARACTER
  FIELD dNodeNo         AS DECIMAL
  FIELD hBuffer         AS HANDLE
  INDEX pudx IS PRIMARY UNIQUE
    iStackLevel
  .

/* ttNode - Table containing all data from nodes in a parse */
DEFINE TEMP-TABLE ttNode NO-UNDO
  FIELD dNodeNo         AS DECIMAL    FORMAT ">>>,>>9.9"
  FIELD iNodeLevel      AS INTEGER    FORMAT ">>9"
  FIELD cNodeName       AS CHARACTER  FORMAT "X(40)"
  FIELD cFullNodeName   AS CHARACTER
  FIELD cNodeNamespace  AS CHARACTER
  FIELD cNodeValue      AS CHARACTER  FORMAT "X(80)"
  FIELD dParentNode     AS DECIMAL    FORMAT ">>>,>>9.9"
  INDEX pudx IS PRIMARY UNIQUE
    dNodeNo
  INDEX udx01 IS UNIQUE
    dParentNode
    dNodeNo
  .

/* ttNodeAttr - Table containing all node attributes in a parse. Related to 
   ttNode through dNodeNo. */
DEFINE TEMP-TABLE ttNodeAttr NO-UNDO
  FIELD dNodeNo         AS DECIMAL
  FIELD cAttrNamespace  AS CHARACTER
  FIELD cFullNodeAttr   AS CHARACTER
  FIELD cNodeAttr       AS CHARACTER  FORMAT "X(40)"
  FIELD cNodeAttrVal    AS CHARACTER  FORMAT "X(80)"
  INDEX pudx IS PRIMARY UNIQUE
    dNodeNo
    cFullNodeAttr
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

&IF DEFINED(EXCLUDE-addStringToNodeValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addStringToNodeValue Procedure 
FUNCTION addStringToNodeValue RETURNS LOGICAL
  ( INPUT piNodeLevel AS INTEGER,
    INPUT pcString AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-associateBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD associateBuffer Procedure 
FUNCTION associateBuffer RETURNS LOGICAL
  ( INPUT pcNode      AS CHARACTER,
    INPUT phBuffer    AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createNodeRec) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createNodeRec Procedure 
FUNCTION createNodeRec RETURNS DECIMAL
  ( INPUT piNodeLevel AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-verifyXMLFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD verifyXMLFile Procedure 
FUNCTION verifyXMLFile RETURNS CHARACTER
  ( INPUT pcFileName AS CHARACTER)  FORWARD.

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
         HEIGHT             = 30.48
         WIDTH              = 67.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-addDataToTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addDataToTables Procedure 
PROCEDURE addDataToTables :
/*------------------------------------------------------------------------------
  Purpose:     Loops through all the buffers that have been associated with 
               a node and adds records to the buffer.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttBuffAssoc  FOR ttBuffAssoc.
  DEFINE BUFFER bttFieldAssoc FOR ttFieldAssoc.
  DEFINE BUFFER bttNode       FOR ttNode.
  DEFINE BUFFER bttChildNode  FOR ttNode.
  DEFINE BUFFER bttNodeAttr   FOR ttNodeAttr.

  DEFINE VARIABLE hBuff       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFld        AS HANDLE     NO-UNDO.

  /* Loop through all buffer associations */  
  FOR EACH bttBuffAssoc:

    /* Get the handle to the buffer */
    hBuff = bttBuffAssoc.hBuffer.

    /* Loop through all the nodes that have the same node name as this
       buffer association. */
    FOR EACH bttNode
      WHERE bttNode.cNodeName = bttBuffAssoc.cNode:

      /* Create a record in the buffer */
      hBuff:BUFFER-CREATE().
      
      /* This loop is used repeatedly below. We loop through all field associations
         that we can find for this node and field name and set the value of the 
         field that is specified by bttFieldAssoc.hField to the value of the 
         field being copied. 
         
         In this case we need to set dNodeNo into its appropriate corresponding 
         fields */
      FOR EACH bttFieldAssoc 
        WHERE bttFieldAssoc.cNode     = bttNode.cNodeName
          AND bttFieldAssoc.cNodeAttr = "dNodeNo":U:
        hFld = bttFieldAssoc.hField.
        IF VALID-HANDLE(hBuff) THEN
          hFld:BUFFER-VALUE = bttNode.dNodeNo.
      END.
  
      /* Set the parent node no if appropriate */
      FOR EACH bttFieldAssoc 
        WHERE bttFieldAssoc.cNode     = bttNode.cNodeName
          AND bttFieldAssoc.cNodeAttr = "dParent":U:
        hFld = bttFieldAssoc.hField.
        IF VALID-HANDLE(hBuff) THEN
         hFld:BUFFER-VALUE = bttNode.dParent.
      END.

      /* Loop through all the node attributes on this node and set corresponding
         fields for them if there are any */
      FOR EACH bttNodeAttr
         WHERE bttNodeAttr.dNodeNo = bttNode.dNodeNo:
        FOR EACH bttFieldAssoc 
          WHERE bttFieldAssoc.cNode     = bttNode.cNodeName
            AND bttFieldAssoc.cNodeAttr = bttNodeAttr.cNodeAttr:
          hFld = bttFieldAssoc.hField.
          IF VALID-HANDLE(hBuff) THEN
            hFld:BUFFER-VALUE = bttNodeAttr.cNodeAttrVal.
        END.
      END.
      
      /* Find all the nodes that are related to this node */
      FOR EACH bttChildNode
         WHERE bttChildNode.dParentNode = bttNode.dNodeNo:
        
        /* If we can find an association for this node, skip it. In other words, 
           if we are going to deal with this node in a later iteration of the 
           FOR EACH ttNode loop, then we don't want to look at this node now. */
        IF CAN-FIND(FIRST ttBuffAssoc WHERE ttBuffAssoc.cNode = bttChildNode.cNodeName) AND
           (bttChildNode.cNodeValue = "":U OR bttChildNode.cNodeValue = ?) THEN
          NEXT.
        
        /* Set the field value for this node if appropriate */
        FOR EACH bttFieldAssoc 
          WHERE bttFieldAssoc.cNode     = bttNode.cNodeName
            AND bttFieldAssoc.cNodeAttr = bttChildNode.cNodeName:
          hFld = bttFieldAssoc.hField.
          IF VALID-HANDLE(hBuff) THEN
            hFld:BUFFER-VALUE = bttChildNode.cNodeVal.
        END.

        /* Loop through all the node attributes on this child node and set 
           corresponding fields for them if there are any */
        FOR EACH bttNodeAttr
           WHERE bttNodeAttr.dNodeNo = bttChildNode.dNodeNo:
          FOR EACH bttFieldAssoc 
            WHERE bttFieldAssoc.cNode     = bttNode.cNodeName
              AND bttFieldAssoc.cNodeAttr = bttNodeAttr.cNodeAttr:
            hFld = bttFieldAssoc.hField.
            IF VALID-HANDLE(hBuff) THEN
              hFld:BUFFER-VALUE = bttNodeAttr.cNodeAttrVal.
          END.
        END.

      END.
      
      /* Release the record. */
      hBuff:BUFFER-RELEASE().
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Characters) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Characters Procedure 
PROCEDURE Characters :
/*------------------------------------------------------------------------------
  Purpose:     SAX event for accepting characters in during the parse.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER  pmCharData AS MEMPTR     NO-UNDO.
  DEFINE INPUT  PARAMETER  piNumChars AS INTEGER    NO-UNDO.

  DEFINE VARIABLE cString AS CHARACTER  NO-UNDO.

  cString = GET-STRING(pmCharData,1 , GET-SIZE(pmCharData)).
  IF (TRIM(REPLACE(REPLACE(cString,CHR(10),"":U),CHR(13),"":U))) = "":U THEN
    cString = "":U.

  IF cString <> "":U THEN
    addStringToNodeValue(giNodeLevel, cString).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-EndElement) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EndElement Procedure 
PROCEDURE EndElement :
/*------------------------------------------------------------------------------
  Purpose:     SAX event for end of elements
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcNamespaceURI AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcLocalName    AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcName         AS CHARACTER  NO-UNDO.

  DEFINE BUFFER bttStack    FOR ttStack.

  /* Try and find a stack record for this stack level. */
  FIND bttStack 
    WHERE bttStack.iStackLevel = giNodeLevel NO-ERROR.

  /* We should *never* find a stack record, but if we do, this code
     will delete it. If we find one it is probably because EndElement never
     ran which shouldn't happen. */
  IF AVAILABLE(bttStack) THEN
    DELETE bttStack.

  giNodeLevel = giNodeLevel - 1.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-IgnorableWhitespace) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IgnorableWhitespace Procedure 
PROCEDURE IgnorableWhitespace :
/*------------------------------------------------------------------------------
  Purpose:     SAX Event for ignorable whitespace.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcCharData AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER piNumChars AS INTEGER    NO-UNDO.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-parseDocument) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE parseDocument Procedure 
PROCEDURE parseDocument :
/*------------------------------------------------------------------------------
  Purpose:     Starts parsing of an XML document.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcFileName AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hReader     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lAns        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cText       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFileName   AS CHARACTER  NO-UNDO.
  
  /* Before we do anything else, we need to verify that the file
     is one that we can read. */
  cFileName = verifyXMLFile(pcFileName).

  IF cFileName = ? THEN
    RETURN ERROR "MSG_SAX_File_Not_Found,":U + pcFileName.

  CREATE SAX-READER hReader.
  ASSIGN
    giParserNo                            = giParserNo + 1
    hReader:PRIVATE-DATA                  = STRING(giParserNo)
    hReader:HANDLER                       = TARGET-PROCEDURE:HANDLE
    hReader:VALIDATION-ENABLED            = YES
    lAns = hReader:SET-INPUT-SOURCE("FILE":U, cFileName)
  .
  IF NOT lAns THEN
  DO:
    DELETE OBJECT hReader.
    RETURN ERROR "MSG_SAX_File_Not_Parsed,":U + cFileName.
  END.

  hReader:SAX-PARSE().
  DELETE OBJECT hReader.

  RUN addDataToTables.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetParser) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetParser Procedure 
PROCEDURE resetParser :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is used to clear the contents of all the tables
               and reset the parser.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  EMPTY TEMP-TABLE ttBuffAssoc.
  EMPTY TEMP-TABLE ttFieldAssoc.
  EMPTY TEMP-TABLE ttStack.
  EMPTY TEMP-TABLE ttNode.
  EMPTY TEMP-TABLE ttNodeAttr.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-StartElement) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE StartElement Procedure 
PROCEDURE StartElement :
/*------------------------------------------------------------------------------
  Purpose:     SAX event to handle the start of a new element.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcNamespaceURI AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcLocalName    AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcName         AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER phAttributes   AS HANDLE     NO-UNDO.

  DEFINE BUFFER bttStack    FOR ttStack.
  DEFINE BUFFER bttNodeAttr FOR ttNodeAttr.

  DEFINE VARIABLE dNodeNo   AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iCount    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cNodeAttr AS CHARACTER  NO-UNDO.

  giNodeLevel = giNodeLevel + 1.

  /* Try and find a stack record for this stack level. */
  FIND bttStack 
    WHERE bttStack.iStackLevel = giNodeLevel NO-ERROR.

  /* We should *never* find a stack record, but if we do, this code
     will delete it. If we find one it is probably because EndElement never
     ran which shouldn't happen. */
  IF AVAILABLE(bttStack) THEN
    DELETE bttStack.

  /* Now we create a stack record for the current stack level */
  CREATE bttStack.
  ASSIGN
    bttStack.iStackLevel    = giNodeLevel
    bttStack.cNodeNamespace = pcNamespaceURI
    bttStack.cNodeName      = pcLocalName
    bttStack.cFullNodeName  = pcName
  .

  /* Call the function that creates the node record for this node */
  dNodeNo = createNodeRec(giNodeLevel).
  
  /* Loop through all the attributes in the attributes object */
  REPEAT iCount = 1 TO phAttributes:NUM-ITEMS:

    /* Get the full name of the current attribute */
    cNodeAttr = phAttributes:GET-QNAME-BY-INDEX(iCount).

    /* Now try and find a record for this attribute */
    FIND bttNodeAttr 
      WHERE bttNodeAttr.dNodeNo   = dNodeNo
        AND bttNodeAttr.cFullNodeAttr = cNodeAttr
      NO-ERROR.
    
    /* If it doesn't exist, which it really shouldn't, create one */
    IF NOT AVAILABLE(bttNodeAttr) THEN
    DO:
      CREATE bttNodeAttr.
      ASSIGN
        bttNodeAttr.dNodeNo        = dNodeNo
        bttNodeAttr.cFullNodeAttr  = cNodeAttr
      .
    END.

    /* Assign all the values of this record from the appropriate attribute 
       object methods. */
    ASSIGN
      bttNodeAttr.cNodeAttr      = phAttributes:GET-LOCALNAME-BY-INDEX(iCount)
      bttNodeAttr.cAttrNamespace = phAttributes:GET-URI-BY-INDEX(iCount)
      bttNodeAttr.cNodeAttrVal   = phAttributes:GET-VALUE-BY-INDEX(iCount)
    .
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-zzdbg_displayTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE zzdbg_displayTables Procedure 
PROCEDURE zzdbg_displayTables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  output to saxparse.txt.

  FOR EACH ttNode:
    DISPLAY
      "*Node".
    DISPLAY 
      ttNode       
      WITH WIDTH 254 DOWN NO-BOX NO-LABEL STREAM-IO.
    DOWN.
    FOR EACH ttNodeAttr
      WHERE ttNodeAttr.dNodeNo = ttNode.dNodeNo:
      DISPLAY
        "**NodeAttr".
      DISPLAY 
        ttNodeAttr       
        WITH WIDTH 254 DOWN NO-BOX NO-LABEL STREAM-IO.
      DOWN.
    END.
  END.

  output close.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-addStringToNodeValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addStringToNodeValue Procedure 
FUNCTION addStringToNodeValue RETURNS LOGICAL
  ( INPUT piNodeLevel AS INTEGER,
    INPUT pcString AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:    Adds a string value   
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE BUFFER bttStack  FOR ttStack.
  DEFINE BUFFER bttNode   FOR ttNode.

  FIND bttStack 
    WHERE bttStack.iStackLevel = piNodeLevel
    NO-ERROR.
  IF NOT AVAILABLE(bttStack) THEN
    RETURN FALSE.

  FIND bttNode 
    WHERE bttNode.dNodeNo = bttStack.dNodeNo
    NO-ERROR.
  IF NOT AVAILABLE(bttNode) THEN
    RETURN FALSE.

  ASSIGN
    bttNode.cNodeValue = bttNode.cNodeValue + pcString
  .

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-associateBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION associateBuffer Procedure 
FUNCTION associateBuffer RETURNS LOGICAL
  ( INPUT pcNode      AS CHARACTER,
    INPUT phBuffer    AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose:  Associates a node with a buffer.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttBuffAssoc  FOR ttBuffAssoc.
  DEFINE BUFFER bttFieldAssoc FOR ttFieldAssoc.

  DEFINE VARIABLE iCount      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hField      AS HANDLE     NO-UNDO.

  FIND FIRST bttBuffAssoc
    WHERE bttBuffAssoc.cNode = pcNode
    NO-ERROR.

  IF NOT AVAILABLE(bttBuffAssoc) THEN
  DO:
    CREATE bttBuffAssoc.
    ASSIGN
      bttBuffAssoc.cNode = pcNode
    .
  END.
    
  ASSIGN
    bttBuffAssoc.hBuffer = phBuffer
  .
  REPEAT iCount = 1 TO phBuffer:NUM-FIELDS:
    hField = phBuffer:BUFFER-FIELD(iCount).
    CREATE bttFieldAssoc.
    ASSIGN
      bttFieldAssoc.cNode       = pcNode
      bttFieldAssoc.cFieldName  = hField:NAME
      bttFieldAssoc.cNodeAttr   = hField:LABEL
      bttFieldAssoc.hField      = hField
    .
  END.



  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createNodeRec) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createNodeRec Procedure 
FUNCTION createNodeRec RETURNS DECIMAL
  ( INPUT piNodeLevel AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  Creates a node level record for this node level.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttStack  FOR ttStack.
  DEFINE BUFFER bttParent FOR ttStack.
  DEFINE BUFFER bttNode   FOR ttNode.

  DEFINE VARIABLE dParent AS DECIMAL    NO-UNDO.

  FIND bttStack 
    WHERE bttStack.iStackLevel = piNodeLevel
    NO-ERROR.
  IF NOT AVAILABLE(bttStack) THEN
    RETURN 0.00.

  FIND bttParent 
    WHERE bttParent.iStackLevel = piNodeLevel - 1
    NO-ERROR.
  IF NOT AVAILABLE(bttParent) THEN
    dParent = 0.00.
  ELSE
    dParent = bttParent.dNodeNo.

  CREATE bttNode.
  ASSIGN
    gdNodeNo                = gdNodeNo + 1
    bttNode.dNodeNo         = gdNodeNo
    bttNode.iNodeLevel      = piNodeLevel
    bttNode.cNodeName       = bttStack.cNodeName
    bttNode.cFullNodeName   = bttStack.cFullNodeName
    bttNode.cNodeNamespace  = bttStack.cNodeNamespace
    bttNode.dParentNode     = dParent
    bttStack.dNodeNo        = gdNodeNo
  .

  RETURN gdNodeNo.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-verifyXMLFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION verifyXMLFile Procedure 
FUNCTION verifyXMLFile RETURNS CHARACTER
  ( INPUT pcFileName AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:      Validates that the XML file name actually exists.

  Parameters: 
    pcFileName = Name of the file to be read. May be a URL, standard filename
                 or UNC Filename.
    pcFullPath = The full path of the filename to be verified.

  Notes:
    We do not try and verify whether a file on a URL actually exists as there
    is no efficient way of doing this. We have to accept that the URL will 
    either exist or the attempt to open the file will fail.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFullPath  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFileType  AS CHARACTER  NO-UNDO.

  /* Figure out what type of filename it is. */
  cFileType = DYNAMIC-FUNCTION("detectFileType":U IN THIS-PROCEDURE,
                               pcFileName).

  /* If this is a DOS or UNC filename, and we are not on a
     Unix machine, convert the backslashes to forward slashes */
  IF CAN-DO("D,N":U,cFileType) AND
     OPSYS <> "UNIX":U THEN
    pcFileName = REPLACE(pcFileName,"/":U,"~\":U).

  /* If the filetype is not a URL, see if you can find the file */
  IF cFileType = "U":U THEN
    cFullPath = pcFileName.
  ELSE
    cFullPath = SEARCH(pcFileName).

  RETURN cFullPath.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

