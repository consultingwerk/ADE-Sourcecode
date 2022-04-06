&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
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
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: afxmlhlprp.p

  Description:  XML Support Library

  Purpose:      This procedure contains numerous XML-related functions for reading
                and writing XML files.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000083   UserRef:    
                Date:   01/05/2001  Author:     Bruce Gruenbaum

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afxmlhlprp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

{af/sup2/afglobals.i}
    
{af/sup2/afcheckerr.i &define-only = YES}
{afxmlreplctrl.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-buildElementsFromBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildElementsFromBuffer Procedure 
FUNCTION buildElementsFromBuffer RETURNS LOGICAL
  (INPUT phNode AS HANDLE,
   INPUT phBuff AS HANDLE,
   INPUT pcCanDoList AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildElemsFromBuffWithOpts) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildElemsFromBuffWithOpts Procedure 
FUNCTION buildElemsFromBuffWithOpts RETURNS LOGICAL
  (INPUT phNode AS HANDLE,
   INPUT phBuff AS HANDLE,
   INPUT pcOptions AS CHARACTER,
   INPUT pcCanDoList AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildErrList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildErrList Procedure 
FUNCTION buildErrList RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createElementNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createElementNode Procedure 
FUNCTION createElementNode RETURNS HANDLE
  ( INPUT phParentNode AS HANDLE,
    INPUT pcNodeName   AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createNode Procedure 
FUNCTION createNode RETURNS HANDLE
  ( INPUT phParentNode AS HANDLE,
    INPUT pcNodeName   AS CHARACTER,
    INPUT pcNodeType   AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createTextNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createTextNode Procedure 
FUNCTION createTextNode RETURNS HANDLE
  ( INPUT phParentNode AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-detectFileType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD detectFileType Procedure 
FUNCTION detectFileType RETURNS CHARACTER
  ( INPUT pcFileName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadXMLDoc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD loadXMLDoc Procedure 
FUNCTION loadXMLDoc RETURNS HANDLE
  ( INPUT  pcFileName AS CHARACTER,
    INPUT  pmPtr      AS MEMPTR,
    OUTPUT pcRetVal    AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAttributesFromBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAttributesFromBuffer Procedure 
FUNCTION setAttributesFromBuffer RETURNS LOGICAL
  (INPUT phNode AS HANDLE,
   INPUT phBuff AS HANDLE,
   INPUT pcFieldList AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNodeElementValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setNodeElementValue Procedure 
FUNCTION setNodeElementValue RETURNS LOGICAL
  (INPUT phNode AS HANDLE,
   INPUT pcAttr AS CHARACTER,
   INPUT pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-skipLine) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD skipLine Procedure 
FUNCTION skipLine RETURNS LOGICAL
  ( INPUT phNode AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-verifyFileName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD verifyFileName Procedure 
FUNCTION verifyFileName RETURNS CHARACTER
  (INPUT pcFileName AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeDBSchemaInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD writeDBSchemaInfo Procedure 
FUNCTION writeDBSchemaInfo RETURNS LOGICAL
  ( INPUT phNode AS HANDLE,
    INPUT phBuff AS HANDLE )  FORWARD.

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
         HEIGHT             = 20
         WIDTH              = 50.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

{ry/app/ryplipmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-killPlip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE killPlip Procedure 
PROCEDURE killPlip :
/*------------------------------------------------------------------------------
  Purpose:     entry point to instantly kill the plip if it should get lost in memory
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipkill.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-objectDescription) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE objectDescription Procedure 
PROCEDURE objectDescription :
/*------------------------------------------------------------------------------
  Purpose:     Pass out a description of the PLIP, used in Plip temp-table
  Parameters:  <none>
  Notes:       This should be changed manually for each plip
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER cDescription AS CHARACTER NO-UNDO.

ASSIGN cDescription = "XML Support Library".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipSetup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipSetup Procedure 
PROCEDURE plipSetup :
/*------------------------------------------------------------------------------
  Purpose:    Run by main-block of PLIP at startup of PLIP
  Parameters: <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipsetu.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipShutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown Procedure 
PROCEDURE plipShutdown :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will be run just before the calling program 
               terminates
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipshut.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-buildElementsFromBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildElementsFromBuffer Procedure 
FUNCTION buildElementsFromBuffer RETURNS LOGICAL
  (INPUT phNode AS HANDLE,
   INPUT phBuff AS HANDLE,
   INPUT pcCanDoList AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Deprecated. Use buildElemsFromBuffWithOpts.
    Notes:  
------------------------------------------------------------------------------*/

  buildElemsFromBuffWithOpts(INPUT phNode, INPUT phBuff, INPUT "":U, INPUT pcCanDoList).

  RETURN TRUE.   /* Function return value. */


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildElemsFromBuffWithOpts) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildElemsFromBuffWithOpts Procedure 
FUNCTION buildElemsFromBuffWithOpts RETURNS LOGICAL
  (INPUT phNode AS HANDLE,
   INPUT phBuff AS HANDLE,
   INPUT pcOptions AS CHARACTER,
   INPUT pcCanDoList AS CHARACTER) :
  /*------------------------------------------------------------------------------
  Purpose:  This function creates an element for each field in the table that 
            is in the pcCanDoList. 

    Notes:  pcOptions is a comma separated list of field=value pairs. Valid options 
            are:
            
            ColumnTag=ColName/ColLabel/ColColumnLabel/ColNo
            Specifies what to use for the XML tag. Values may be one of:
              ColName - use the name of the column (field) in the metaschema 
                        (hfield:NAME) - DEFAULT
              ColLabel - use the label of the column (field) in the metaschema
                         (hField:LABEL)
              ColColumnLabel - use the column-label of the column (field) in the 
                               metaschema (hField:COLUMN-LABEL)
              ColNo - use the position of the column (field) in the metaschema
                      (iCount in hBuff:NUM-FIELDS)
    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iCount          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCount2         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hField          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cString         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hNode           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hText           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cColumnTag      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumnTagToken AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEntry          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cField          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue          AS CHARACTER  NO-UNDO.

  /* Parse out the options */
  DO iCount = 1 TO NUM-ENTRIES(pcOptions):
    cEntry = ENTRY(iCount,pcOptions).
    IF NUM-ENTRIES(cEntry,"=":U) > 1 THEN
    DO:
      cField = ENTRY(1,cEntry,"=":U).
      cValue = ENTRY(2,cEntry,"=":U).
      CASE cField:
        WHEN "ColumnTag":U THEN
          cColumnTagToken = cValue.
      END CASE.
    END.
  END.

  /* Loop through all the fields in the buffer */
  DO-BLK:
  DO iCount = 1 TO phBuff:NUM-FIELDS:
    /* Set the field handle */
    ASSIGN 
      hField = phBuff:BUFFER-FIELD(iCount) 
      NO-ERROR.

    /* This is a temporary fix. We have to find a way to support 
       raw data */
    IF hField:DATA-TYPE = "RAW":U OR
       hField:DATA-TYPE = "BLOB":U OR
       hField:DATA-TYPE = "CLOB":U THEN
      NEXT DO-BLK.


    /* If there's an error, or the field handle is invalid or we need to ignore 
       this field or the field is blank, skip it */
    IF ERROR-STATUS:ERROR OR
       NOT VALID-HANDLE(hField) OR
       NOT CAN-DO(pcCanDoList,hField:NAME) THEN
      NEXT DO-BLK.

    CASE cColumnTagToken:
      WHEN "ColLabel":U THEN
        cColumnTag = hField:LABEL.
      WHEN "ColColumnLabel":U THEN
        cColumnTag = hField:COLUMN-LABEL.
      WHEN "ColNo":U THEN
        cColumnTag = STRING(iCount).
      OTHERWISE
        cColumnTag = hField:NAME.
    END CASE.
    
    IF hField:EXTENT > 0 THEN
    DO:
      DO iCount2 = 1 TO hField:EXTENT:
        cString = STRING(hField:BUFFER-VALUE[iCount2]).

        IF hField:DATA-TYPE = "CHARACTER":U THEN
        DO:
          IF cString = ? OR
             cString = "?":U THEN
            cString = "?":U.
          ELSE
            cString = replaceCtrlChar(cString, YES).
        END.

        /* Create a node reference for the attribute */
        hNode = createElementNode(phNode, cColumnTag).

        hNode:SET-ATTRIBUTE("ExtentIndex":U, STRING(iCount2)).

        /* Add the text element into the new node */
        hText = createTextNode(hNode).

        /* Set the node value */
        IF cString = ? THEN
          hText:NODE-VALUE = "?":U.
        ELSE
          hText:NODE-VALUE = cString.

        /* Delete all the objects */
        DELETE OBJECT hText.
        DELETE OBJECT hNode.
        hNode = ?.
        hText = ?.
      END.
    END.
    ELSE
    DO:
      cString = STRING(hField:BUFFER-VALUE).

      IF hField:DATA-TYPE = "CHARACTER":U THEN
      DO:
        IF cString = ? OR
           cString = "?":U THEN
          cString = "?":U.
        ELSE
          cString = replaceCtrlChar(cString, YES).
      END.


      /* Call setNodeElementValue to create the appropriate nodes in the XML */
      setNodeElementValue(phNode, cColumnTag, cString ).
    END.
  END.

  RETURN TRUE.   /* Function return value. */


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildErrList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildErrList Procedure 
FUNCTION buildErrList RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRetVal AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount  AS INTEGER    NO-UNDO.
  
  DO iCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
    cRetVal = cRetVal + (IF cRetVal = "":U THEN "":U ELSE CHR(10))
            + ERROR-STATUS:GET-MESSAGE(iCount).
  END.

  RETURN cRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createElementNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createElementNode Procedure 
FUNCTION createElementNode RETURNS HANDLE
  ( INPUT phParentNode AS HANDLE,
    INPUT pcNodeName   AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Create a node of type "ELEMENT"
    Notes:  
------------------------------------------------------------------------------*/
  RETURN createNode (phParentNode, pcNodeName, "ELEMENT":U).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createNode Procedure 
FUNCTION createNode RETURNS HANDLE
  ( INPUT phParentNode AS HANDLE,
    INPUT pcNodeName   AS CHARACTER,
    INPUT pcNodeType   AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Creates the node object and appends the node to the parent node
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRetNode  AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hXDoc AS HANDLE   NO-UNDO.

  IF phParentNode:TYPE = "X-DOCUMENT":U THEN 
    hXDoc = phParentNode.
  ELSE
    hXDoc = phParentNode:OWNER-DOCUMENT.
  IF NOT VALID-HANDLE(hXDoc) THEN
    RETURN ?.
  /* Put in the node */
  CREATE X-NODEREF  hRetNode.
  hXDoc:CREATE-NODE(hRetNode, pcNodeName, pcNodeType).
  phParentNode:APPEND-CHILD(hRetNode).

  /* Create a text node before each field to result in CR+LF so that 
     the file can be read by SCMs */
  IF pcNodeType = "ELEMENT":U  AND
     phParentNode:TYPE <> "X-DOCUMENT":U THEN
    skipLine(phParentNode).


  RETURN hRetNode.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createTextNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createTextNode Procedure 
FUNCTION createTextNode RETURNS HANDLE
  ( INPUT phParentNode AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose:  Create a node of type "TEXT"
    Notes:  
------------------------------------------------------------------------------*/
  RETURN createNode (phParentNode, "":U, "TEXT":U).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-detectFileType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION detectFileType Procedure 
FUNCTION detectFileType RETURNS CHARACTER
  ( INPUT pcFileName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:   Determines from the filename the type of file.
    Notes:   Valid file types are:
             U = URL
             N = UNC File Name (\\Machine\share\directory\file)
             D = DOS/Windows   (D:\directory\file)
             X = Unix Filename
------------------------------------------------------------------------------*/

  /* If the first 5 characters are http: or the
     first 6 are https: (secure http) this is a URL */
  IF (SUBSTRING(pcFileName,1,5) = "http:":U OR
      SUBSTRING(pcFileName,1,6) = "https:":U) THEN
    RETURN "U":U. 

  /* If the first two characters are // and we are on a WIN32 machine,
     it's a UNC file name */
  IF (SUBSTRING(pcFileName,1,2) = "//":U OR
      SUBSTRING(pcFileName,1,2) = "~\~\":U) THEN
    RETURN "N":U.

  /* If the second character is a colon, or there is a backslash 
     anywhere in this filename, it is DOS filename */
  IF SUBSTRING(pcFileName,2,1) = ":":U OR
     INDEX(pcFileName,"~\":U) <> 0 THEN
    RETURN "D":U.

  /* If the first character is a / we've got a Unix file. */
  IF SUBSTRING(pcFileName,1,1) = "/":U THEN
   RETURN "X":U.

  /* Now we're down to figuring out from the operating system that we're on
     the type of file. */
  IF OPSYS = "UNIX":U THEN
    RETURN "X":U.

  RETURN "D":U.   /* If all else fails it must be DOS */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadXMLDoc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION loadXMLDoc Procedure 
FUNCTION loadXMLDoc RETURNS HANDLE
  ( INPUT  pcFileName AS CHARACTER,
    INPUT  pmPtr      AS MEMPTR,
    OUTPUT pcRetVal    AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Loads an XML file from either a file or a MEMPTR. The file may
            be a URL.
    Notes:  
      If pcFileName contains the string "<MEMPTR>", the document is loaded from
      the pmPtr MEMPTR, otherwise the string contained in pcFileName is 
      assumed to be a file.
      The function calls verifyFileName which will handle conversion of files
      from DOS to Unix format if need be. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hXDoc           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFile           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lSuccess        AS LOGICAL    NO-UNDO.

  /* Set the return value blank */
  pcRetVal = "":U.

  /* If we need to load this from a file, check to see if the 
     filename is valid. */
  IF pcFileName <> "<MEMPTR>":U THEN
    cFile = verifyFileName(pcFileName).

  IF pcFileName = "":U THEN
  DO:
    pcRetVal = "EMPTY FILE":U.
    RETURN ?.
  END.

  /* If the filename is unknown we have an error */
  IF cFile = ? THEN
    pcRetVal = {af/sup2/aferrortxt.i 'AF' '19' '?' '?' 'XML' pcFileName}.

  /* Next thing to do is try creating and loading the XML document */
  CREATE X-DOCUMENT hXDoc.

  /* Now lets try loading the XML file */
  ERROR-STATUS:ERROR = NO.
  IF pcFileName = "<MEMPTR>":U THEN
  DO:
    cFile = "from memory pointer".
    lSuccess = hXDoc:LOAD("MEMPTR":U,pmPtr,FALSE) NO-ERROR.
  END.
  ELSE
    lSuccess = hXDoc:LOAD("FILE":U,cFile,FALSE) NO-ERROR.

  /* If we didn't succeed in loading the XML file, we need to 
     bail out */
  cMessageList = buildErrList().
  IF cMessageList <> "":U AND
     cMessageList <> ? THEN
  DO:
    pcRetVal = {af/sup2/aferrortxt.i 'AF' '117' '?' '?' 'load' cFile cMessageList}.
    DELETE OBJECT hXDoc.
    hXDoc = ?.
  END.

  /* If we have a valid X document */
  IF VALID-HANDLE(hXDoc) THEN
    RETURN hXDoc.
  ELSE
    RETURN ?.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAttributesFromBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAttributesFromBuffer Procedure 
FUNCTION setAttributesFromBuffer RETURNS LOGICAL
  (INPUT phNode AS HANDLE,
   INPUT phBuff AS HANDLE,
   INPUT pcFieldList AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  This function takes the handle to a node and the handle to a buffer
            as well as a list of fields and sets attributes for each field on 
            the node.  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iCount    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hField    AS HANDLE     NO-UNDO.

  /* Iterate through the field list */
  DO-BLK:
  DO iCount = 1 TO NUM-ENTRIES(pcFieldList):

    /* Set the field handle */
    ASSIGN 
      hField = phBuff:BUFFER-FIELD(ENTRY(iCount,pcFieldList)) 
      NO-ERROR.

    /* If we have an invalid handle, skip the field. */
    IF ERROR-STATUS:ERROR OR
       NOT VALID-HANDLE(hField) THEN
      NEXT DO-BLK.

    /* Set the node's attribute */
    phNode:SET-ATTRIBUTE(hField:NAME,hField:STRING-VALUE).

    /* Make the field handle invalid */
    hField = ?.
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNodeElementValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setNodeElementValue Procedure 
FUNCTION setNodeElementValue RETURNS LOGICAL
  (INPUT phNode AS HANDLE,
   INPUT pcAttr AS CHARACTER,
   INPUT pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Creates a node element value.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hAttribute  AS HANDLE   NO-UNDO.
    DEFINE VARIABLE hText       AS HANDLE   NO-UNDO.

    /* Create a node reference for the attribute */
    hAttribute = createElementNode(phNode, pcAttr).

    /* Add the text element into the new node */
    hText = createTextNode(hAttribute).

    /* Set the node value */
    IF pcValue = ? THEN
      hText:NODE-VALUE = "?":U.
    ELSE
      hText:NODE-VALUE = pcValue.

    /* Delete all the objects */
    DELETE OBJECT hText.
    DELETE OBJECT hAttribute.
    hAttribute = ?.
    hText = ?.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-skipLine) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION skipLine Procedure 
FUNCTION skipLine RETURNS LOGICAL
  ( INPUT phNode AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VARIABLE hText     AS HANDLE     NO-UNDO.

  /* Add the text element into the new node */
  hText = createTextNode(phNode).

  /* Set the node value */
  hText:NODE-VALUE = CHR(10).

  DELETE OBJECT hText.
  hText = ?.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-verifyFileName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION verifyFileName Procedure 
FUNCTION verifyFileName RETURNS CHARACTER
  (INPUT pcFileName AS CHARACTER):

/*------------------------------------------------------------------------------
  Purpose: Validates that the config file name actually exists and tries to
           load it into an XML handle to confirm that it is valid.

  Parameters: 
    pcFileName = Name of the file to be read. May be a URL, standard filename
                 or UNC Filename.
  Notes:
    The URL portion of this LOAD only works with Progress V9.1C or later. The
    XML engine prior to 9.1C did not support loading from URLs.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hXDoc         AS HANDLE   NO-UNDO.

  DEFINE VARIABLE cFullPath     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFileType     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lSuccess      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cRetVal       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount        AS INTEGER    NO-UNDO.

  /* Figure out what type of filename it is. */
  cFileType = detectFileType(pcFileName).

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

  /* Check the file size. If it's blank it's not really an error. */
  FILE-INFO:FILE-NAME = cFullPath.
  IF FILE-INFO:FILE-SIZE = 0 THEN
    RETURN "":U.

  /* If the file exists, return it, otherwise return the ? value */
  IF cFullPath <> ? THEN
    RETURN cFullPath.
  ELSE
    RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeDBSchemaInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION writeDBSchemaInfo Procedure 
FUNCTION writeDBSchemaInfo RETURNS LOGICAL
  ( INPUT phNode AS HANDLE,
    INPUT phBuff AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a buffer and writes the schema structure out to the 
            XML file.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hTableNode  AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hFieldNode  AS HANDLE   NO-UNDO.
  DEFINE VARIABLE iCount      AS INTEGER  NO-UNDO.
  DEFINE VARIABLE hField      AS HANDLE   NO-UNDO.
  /* Create a table_def node */
  hTableNode = createElementNode( phNode, "table_definition":U).

  /* Set a node element value for the table name and the dbname */
  setNodeElementValue( hTableNode, "name", phBuff:NAME).
  setNodeElementValue( hTableNode, "dbname", LC(phBuff:DBNAME)).

  iCount = 1.
  /* Write a node for each index */
  DO WHILE  phBuff:INDEX-INFORMATION(iCount) <> ?:
    setNodeElementValue( hTableNode, "index-":U + STRING(iCount), phBuff:INDEX-INFORMATION(iCount)).
    iCount = iCount + 1.
  END.

  /* Iterate through all the fields in the buffer handle */
  DO iCount = 1 TO phBuff:NUM-FIELDS:
    /* Get a handle to the buffer field */
    hField = phBuff:BUFFER-FIELD(iCount).

    /* Create a field node */
    hFieldNode = createElementNode( hTableNode, "field":U).

    /* Set a node element value for all the fields that make up the
       parameters in the ADD-NEW-FIELD method on the buffer handle */
    setNodeElementValue( hFieldNode, "name":U, hField:NAME).
    setNodeElementValue( hFieldNode, "data-type":U, hField:DATA-TYPE).
    setNodeElementValue( hFieldNode, "extent":U, STRING(hField:EXTENT)).
    setNodeElementValue( hFieldNode, "format":U, hField:FORMAT).
    setNodeElementValue( hFieldNode, "initial":U, hField:INITIAL).
    setNodeElementValue( hFieldNode, "label":U, hField:LABEL).
    setNodeElementValue( hFieldNode, "column-label":U, hField:COLUMN-LABEL).
    /* Delete the field node object */
    DELETE OBJECT hFieldNode.
    hFieldNode = ?.
  END.

  /* Delete the table node object */
  DELETE OBJECT hTableNode.
  hTableNode = ?.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

