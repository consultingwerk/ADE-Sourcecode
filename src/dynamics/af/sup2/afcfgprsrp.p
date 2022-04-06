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
  File: afcfgprsrp.p

  Description:  XML configuration file parser

  Purpose:      This procedure reads in the contents of an XML file into the temp-tables that
                it needs to contain.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   09/01/2003  Author:     Bruce S Gruenbaum

  Update Notes: Derived from code that was originally contained in afxmlcfgp.p
                Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afcfgprsrp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

/* The following include brings in the temp-tables that we need to parse
   the XML file */
{af/sup2/afxmlcfgtt.i}

/* The following include contains the replaceCtrlChar function */
{af/sup2/afxmlreplctrl.i}

/* The following include contains the manipulation of the ttNode table */
{af/sup2/afttnode.i}

DEFINE TEMP-TABLE ttSession NO-UNDO 
  FIELD cSessionType AS CHARACTER
  INDEX pudx IS PRIMARY UNIQUE
     cSessionType
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

&IF DEFINED(EXCLUDE-writeConfigRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD writeConfigRecord Procedure 
FUNCTION writeConfigRecord RETURNS LOGICAL
  ( INPUT phBuffer AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD writeNode Procedure 
FUNCTION writeNode RETURNS LOGICAL
  ( /* No Parameters */ )  FORWARD.

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
         HEIGHT             = 16.62
         WIDTH              = 59.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-getTableHandles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTableHandles Procedure 
PROCEDURE getTableHandles :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER htProperty AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER htManager  AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER htService  AS HANDLE     NO-UNDO.
  
  htProperty = TEMP-TABLE ttProperty:HANDLE.
  htManager  = TEMP-TABLE ttManager:HANDLE.
  htService  = TEMP-TABLE ttService:HANDLE.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainCFGTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtainCFGTables Procedure 
PROCEDURE obtainCFGTables :
/*------------------------------------------------------------------------------
  Purpose:     This procedure simply returns the tables that were created by the
               parse of the XML file.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER TABLE FOR ttProperty.
  DEFINE OUTPUT PARAMETER TABLE FOR ttService.
  DEFINE OUTPUT PARAMETER TABLE FOR ttManager.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainSessionList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtainSessionList Procedure 
PROCEDURE obtainSessionList :
/*------------------------------------------------------------------------------
  Purpose:     This procedure establishes the list of sessions in the session
                table and returns it as a CHR(3) separated list.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER pcSessList  AS CHARACTER  NO-UNDO.

  EMPTY TEMP-TABLE ttSession.

  DEFINE BUFFER bttSession FOR ttSession.
 
  FOR EACH ttProperty:
    FIND FIRST bttSession
      WHERE bttSession.cSessionType = ttProperty.cSessionType
      NO-ERROR.
    IF NOT AVAILABLE(bttSession) THEN
    DO:
      CREATE bttSession.
      ASSIGN
        bttSession.cSessionType = ttProperty.cSessionType
      .
    END.
  END.
  
  FOR EACH ttManager:
    FIND FIRST bttSession
      WHERE bttSession.cSessionType = ttManager.cSessionType
      NO-ERROR.
    IF NOT AVAILABLE(bttSession) THEN
    DO:
      CREATE bttSession.
      ASSIGN
        bttSession.cSessionType = ttManager.cSessionType
      .
    END.
  END.

  FOR EACH ttService:
    FIND FIRST bttSession
      WHERE bttSession.cSessionType = ttService.cSessionType
      NO-ERROR.
    IF NOT AVAILABLE(bttSession) THEN
    DO:
      CREATE bttSession.
      ASSIGN
        bttSession.cSessionType = ttService.cSessionType
      .
    END.
  END.

  FOR EACH bttSession:
    ASSIGN
      pcSessList = pcSessList + MIN(CHR(3),pcSessList)
                 + bttSession.cSessionType
    .
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-parseConfig) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE parseConfig Procedure 
PROCEDURE parseConfig :
/*------------------------------------------------------------------------------
  Purpose:     Takes the handle to the XML document and retrieves the contents 
               of the requested session types into the configuration temp-tables.
  Parameters:  phXDoc    - Handle to the X Document that has the info.
               pcSessType - Session Type(s) to read in. A blank value will retrieve
                            all the data.
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER phXDoc      AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER pcSessType  AS CHARACTER  NO-UNDO.


  DEFINE VARIABLE hRootNode           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSessionNode        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lSuccess            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iCount              AS INTEGER    NO-UNDO.

  DEFINE VARIABLE lSessTypeFound AS LOGICAL    NO-UNDO.



  /* Create two node references */
  CREATE X-NODEREF hRootNode.
  CREATE X-NODEREF hSessionNode.

  /* Set the root node */
  lSuccess = phXDoc:GET-DOCUMENT-ELEMENT(hRootNode).

  /* If we're not successful we have an invalid XML file */
  IF NOT lSuccess THEN
    RETURN "ICFSTARTUPERR: COULD NOT PARSE CONFIG FILE":U.

  /* Iterate through the root node's children */
  REPEAT iCount = 1 TO hRootNode:NUM-CHILDREN:

    /* Set the current Session Node */
    lSuccess = hRootNode:GET-CHILD(hSessionNode,iCount).

    IF NOT lSuccess THEN
      NEXT.

    /* If the session node is blank, skip it */
    IF hSessionNode:SUBTYPE = "TEXT":U AND
       hSessionNode:NODE-VALUE = CHR(10) THEN
      NEXT.
    /* If the name of this node is "Session" and the SessionType attribute matches the
       one(s) we need to retrieve, we'll process this node */  
    IF hSessionNode:NAME = "session":U AND
       CAN-DO(hSessionNode:ATTRIBUTE-NAMES,"SessionType":U) AND
       (pcSessType = "":U OR
        CAN-DO(pcSessType,hSessionNode:GET-ATTRIBUTE("SessionType":U))) THEN
    DO:
      EMPTY TEMP-TABLE ttNode.
      lSessTypeFound = YES.
      RUN recurseNodes(hSessionNode,hSessionNode:GET-ATTRIBUTE("SessionType":U)).
    END.
  END.
   
  /* Make sure that ttNode is empty */
  EMPTY TEMP-TABLE ttNode.
  
  /* Delete the objects */
  DELETE OBJECT hRootNode.
  hRootNode = ?.
  DELETE OBJECT hSessionNode.
  hSessionNode = ?.

  /* If we don't find the session type, return an error message to that effect */
  IF NOT lSessTypeFound THEN
    RETURN "SESSION TYPE " + pcSessType + " NOT FOUND IN CONFIGURATION FILE.".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-readConfigFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE readConfigFile Procedure 
PROCEDURE readConfigFile :
/*------------------------------------------------------------------------------
  Purpose:     Reads in a configuration xml file specified and parses it for 
               either a specific session type or all session types.
               
  Parameters:  
    pcConfigFile  - Configuration file to parse
    pcSessType    - Session Types to read in
  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcConfigFile AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcSessTypes  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plReturnhDoc AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER phConfig     AS HANDLE     NO-UNDO.

  DEFINE VARIABLE hConfig              AS HANDLE     NO-UNDO.

  RUN resetParser.

  /* Confirm that the configuration file is correct, and obtain a handle to 
     the X document. */
  RUN validateConfigFile (INPUT pcConfigFile, OUTPUT hConfig).
  IF RETURN-VALUE <> "":U THEN
  DO:
    RUN releaseConfigDoc (hConfig).
    RETURN "ICFSTARTUPERR: ":U + RETURN-VALUE.
  END.

  /* We decided that if the configuration file is empty, nothing happens.
     IOW, if we can't find a config file, or the config file is invalid,
     we ignore it and carry on. */
  IF NOT VALID-HANDLE(hConfig) THEN
    RETURN "ICFSTARTUPERR: INVALID CONFIG FILE OR CONFIG FILE NOT FOUND":U.

  /* Now we need to parse the configuration file and read in the data from
     the file. */
  RUN parseConfig (hConfig, pcSessTypes).
  IF RETURN-VALUE <> "":U THEN
    RETURN "ICFSTARTUPERR: ":U + RETURN-VALUE.

  /* If there was a RETURN-VALUE from the parse, we need to return it */
  IF RETURN-VALUE <> "":U THEN
  DO:
    RUN releaseConfigDoc (hConfig).
    RETURN RETURN-VALUE.
  END.

  IF plReturnhDoc THEN
    phConfig = hConfig.
  ELSE
  DO:
    phConfig = ?.
    RUN releaseConfigDoc (hConfig).
  END.

  RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-recurseNodes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recurseNodes Procedure 
PROCEDURE recurseNodes :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is responsible for constructing the attributes
               into the node table to prepare them for the write into the
               appropriate tables.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phParent      AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER pcStack       AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hNode       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lSuccess    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iCount      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLevel      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTest       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRecordType AS CHARACTER  NO-UNDO.


  /* If we're at the top of the stack, put the name in the node table */
  IF NUM-ENTRIES(pcStack) = 1 THEN
    setNode("SessionType":U,pcStack,NUM-ENTRIES(pcStack),NO).

  /* Set the node to look at the next child */
  CREATE X-NODEREF hNode.

  /* Iterate through the children */
  REPEAT iCount = 1 TO phParent:NUM-CHILDREN:
    /* Set the node to the child node */
    lSuccess = phParent:GET-CHILD(hNode,iCount).
    IF NOT lSuccess THEN
      NEXT.

    /* If the text has nothing in it, skip it */
    IF hNode:SUBTYPE = "TEXT":U THEN
    DO:
      cTest = REPLACE(hNode:NODE-VALUE, CHR(10), "":U).
      cTest = REPLACE(cTest, CHR(13), "":U).
      cTest = TRIM(cTest).
      IF cTest = "" THEN
        NEXT.
    END.

    /* When we hit level 2, we know what kind of records these are,
       and we need to make sure that they get appropriately set. */
    IF NUM-ENTRIES(pcStack) = 2 THEN
    DO:
      cRecordType = ENTRY(1,pcStack).
      setNode("RecordType":U,cRecordType,NUM-ENTRIES(pcStack),NO).
    END.

    /* Set a node value for this node */
    IF hNode:SUBTYPE = "TEXT":U THEN
      setNode(ENTRY(1,pcStack),hNode:NODE-VALUE,NUM-ENTRIES(pcStack),YES).

    /* Go down lower if need be */
    RUN recurseNodes(hNode,hNode:NAME + ",":U + pcStack).

    /* If this is level 2 on the stack, we can write out this data
       to the appropriate files */
    IF NUM-ENTRIES(pcStack) = 2 THEN
      writeNode().

  END.

  DELETE OBJECT hNode.
  hNode = ?.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-releaseConfigDoc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE releaseConfigDoc Procedure 
PROCEDURE releaseConfigDoc :
/*------------------------------------------------------------------------------
  Purpose:     Deletes the handle to the XDOC thereby releasing it.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phXDoc AS HANDLE     NO-UNDO.

  IF VALID-HANDLE(phXDoc) THEN
    DELETE OBJECT phXDoc.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetParser) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetParser Procedure 
PROCEDURE resetParser :
/*------------------------------------------------------------------------------
  Purpose:     Empties the temp-tables associated with the parser.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  EMPTY TEMP-TABLE ttNode.
  EMPTY TEMP-TABLE ttSession.
  EMPTY TEMP-TABLE ttProperty.
  EMPTY TEMP-TABLE ttService.
  EMPTY TEMP-TABLE ttManager.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateConfigFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateConfigFile Procedure 
PROCEDURE validateConfigFile :
/*------------------------------------------------------------------------------
  Purpose: Validates that the config file name actually exists and tries to
           load it into an XML handle to confirm that it is valid.

  Parameters: 
    pcFileName = Name of the file to be read. May be a URL, standard filename
                 or UNC Filename.
    phXDoc     = Handle to the XML document object that gets created in here.

  Notes:
    The URL portion of this LOAD only works with Progress V9.1C or later. The
    XML engine prior to 9.1C did not support loading from URLs.  
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcFileName  AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER phXDoc      AS HANDLE   NO-UNDO.

  DEFINE VARIABLE cFullPath     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFileType     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lSuccess      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cRetVal       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount        AS INTEGER    NO-UNDO.

  /* Figure out what type of filename it is. */
  cFileType = DYNAMIC-FUNCTION("detectFileType":U IN TARGET-PROCEDURE,
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

  /* If the file does not exist, return the ? value */
  IF cFullPath <> ? THEN
  DO:
    /* Next thing to do is try creating and loading the XML document */
    CREATE X-DOCUMENT phXDoc.
    lSuccess = phXDoc:LOAD("FILE":U,cFullPath,FALSE) NO-ERROR.

    /* If we didn't succeed in loading the XML file, we need to 
       bail out */
    cRetVal = "":U.
    IF ERROR-STATUS:ERROR OR 
       NOT lSuccess THEN
    DO:
      /* Build up a string that contains the error information */
      cRetVal = "XML LOAD FAILED.":U. 
      IF ERROR-STATUS:ERROR THEN
      DO:
        cRetVal = cRetVal + CHR(10) + "Progress returned these errors: ".
        DO iCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
          cRetVal = cRetVal + CHR(10) + ERROR-STATUS:GET-MESSAGE(iCount).
        END.
        ERROR-STATUS:ERROR = NO.
      END.

      /* Delete the object or we'll have a memory leak */
      DELETE OBJECT phXDoc.
      phXDoc = ?.
    END.
  END.
  
  RETURN cRetVal.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-writeConfigRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION writeConfigRecord Procedure 
FUNCTION writeConfigRecord RETURNS LOGICAL
  ( INPUT phBuffer AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:   Creates a buffer record and populates the contents with the
             data contained in the ttNodes table.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSessType   AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hOrder      AS HANDLE   NO-UNDO.
  DEFINE VARIABLE iNextRec    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cSessType   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hCurrField  AS HANDLE   NO-UNDO.

  /* Get the current session type */
  cSessType = getNode("SessionType":U).

  hSessType = phBuffer:BUFFER-FIELD("cSessionType":U).

  /* Figure out if there is an iOrder field. If there is, get the next
     number */
  hOrder = phBuffer:BUFFER-FIELD("iOrder":U).
  IF VALID-HANDLE(hOrder) THEN
    iNextRec = getNextOrderNum(phBuffer,cSessType).

  /* Go into a transaction */
  DO TRANSACTION:
    /* Create a record */
    phBuffer:BUFFER-CREATE().

    /* Set the value of the cSessionType and iOrder fields */
    hSessType:BUFFER-VALUE = cSessType.
    IF VALID-HANDLE(hOrder) THEN
      hOrder:BUFFER-VALUE = iNextRec.

    /* Loop through the records in the ttNode table that are not 
       either RecordType or SessionType properties.*/
    FOR EACH ttNode
      WHERE NOT CAN-DO("RecordType,SessionType",ttNode.cNode):

      /* Get the handle to a field in the TEMP-TABLE that has 
         the name of this node. If we find
         it we set its value */
      hCurrField = phBuffer:BUFFER-FIELD(ttNode.cNode).
      IF VALID-HANDLE(hCurrField) THEN
        hCurrField:BUFFER-VALUE = ttNode.cValue.
    END.

    /* Release the buffer so that it gets written */
    phBuffer:BUFFER-RELEASE().
  END.

  RETURN TRUE.   /* Function return value. */


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION writeNode Procedure 
FUNCTION writeNode RETURNS LOGICAL
  ( /* No Parameters */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Writes the data from the Node table out to the appropriate
            temp table.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRecordType AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSessType   AS CHARACTER  NO-UNDO.

  /* Figure out what type of record we're dealing with */
  cRecordType = getNode("RecordType":U).


  /* Handle each record type appropriately */
  CASE cRecordType:
    /* Properties are set up as a record per property.
       We use the setProperty function in this procedure to
       do this. */
    WHEN "properties":U THEN
    DO:
      /* Get the session type */
      cSessType   = getNode("SessionType":U).
      /* If this is a property record, set a property for the
         session type */
      FOR EACH ttNode
        WHERE NOT CAN-DO("RecordType,SessionType",ttNode.cNode):
        setProperty(cSessType,ttNode.cNode,ttNode.cValue).
      END.
    END.

    /* For services and managers we can use the 
       writeConfigRecord function and pass in the appropriate 
       temp-table's buffer as a handle */
    WHEN "services":U THEN
      writeConfigRecord(INPUT BUFFER ttService:HANDLE).
    WHEN "managers":U THEN
      writeConfigRecord(INPUT BUFFER ttManager:HANDLE).
  END CASE.

  /* Empty the node table for all old values */
  FOR EACH ttNode WHERE ttNode.lDelete:
    DELETE ttNode.
  END.

  RETURN TRUE.   /* Function return value. */


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

