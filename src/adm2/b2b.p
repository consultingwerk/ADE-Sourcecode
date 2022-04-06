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
    File        : b2b.p
    Purpose     : Read or store data from XML to BL (SDO/SBO) and vice versa 
                  based on W3C XML schema mapped to BL objects.   

    Description : Contains logic that uses the XML mapping schema to read or 
                  store data in dataobjects. This super procedure inherits from
                  xml.p which presents a simplified DOM API by encapsulating 
                  the 4GL DOM statements, so that x-noderef handles never need 
                  to be exposed to this super procedure.      
                  The consumation and producing of documents are separate.
                  See also xml.p                                              
    Created     : Summer 1999
    Modified    : August 17 2000
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&SCOPED-DEFINE ADMSuper b2b.p

 /* Custom exclude file */

  {src/adm2/custom/b2bexclcustom.i}

DEFINE VARIABLE ghDoc           AS HANDLE NO-UNDO.
DEFINE VARIABLE ghSchemaManager AS HANDLE NO-UNDO.
DEFINE VARIABLE xcSchemaManager AS CHAR   NO-UNDO INIT "adecomm/xmlschema.p":U.
 
/* Register each dataSource, this is not implemented for performance reasons,
   but in order to:
   - Detect the first time we connect to an object in order to call 
     connectDataObject 
   - Register the path that will trigger all updates at endElement. */
DEFINE TEMP-TABLE tDataSource  
  FIELD TargetProc   AS HANDLE
  FIELD DataSource   AS HANDLE
  FIELD ObjectName   AS CHAR
  FIELD DocumentPath AS CHAR  /* Consumer only */
  FIELD Commit       AS LOG  
  /* One index must have targetproc first, don't care which. */
  INDEX DataSource AS UNIQUE TargetProc DataSource  
  INDEX ObjectName           ObjectName TargetProc 
  INDEX DocumentPath         DocumentPath TargetProc
  INDEX Commit               TargetProc Commit.

/** Producer temp-tables **/
/* Register all datasource/methods that update nodes with out parameters */ 
DEFINE TEMP-TABLE tMethodNode
  FIELD TargetProc AS HANDLE
  FIELD DataSource AS HANDLE
  FIELD Method     AS CHAR
  FIELD MethodNode AS DEC
  FIELD NumParam   AS INT
  INDEX Method     AS UNIQUE TargetProc DataSource Method 
  INDEX Node                 TargetProc MethodNode. 

/* Children of tMethodNode (one record for each node and parameter) */   
DEFINE TEMP-TABLE tParamNode  
  FIELD TargetProc AS HANDLE
  FIELD DataSource AS HANDLE
  FIELD Method     AS CHAR
  FIELD Num        AS INT
  FIELD Node       AS DEC 
  INDEX Method     TargetProc DataSource Method Num.

/** Consumer temp-tables **/
/* Created for each node that represents a row of data (mapped to object)
   updated from startEvent -> startDataRow */
DEFINE TEMP-TABLE tDataRow       
  FIELD TargetProc   AS HANDLE
  FIELD DataSource   AS HANDLE
  FIELD Seq          AS INT  
  FIELD Action       AS CHAR  
  INDEX DataSource  AS UNIQUE  TargetProc DataSource Seq
  INDEX Seq         AS PRIMARY TargetProc Seq.
  
/* Children of tDataRow updated from characterValue -> storeNodeValue and
   used to update the datasource from endElement. */
DEFINE TEMP-TABLE tKeyData  
  FIELD TargetProc   AS HANDLE
  FIELD DataSource   AS HANDLE
  FIELD Seq          AS INT  
  FIELD ValueList    AS CHAR  
  INDEX DataSource AS UNIQUE TargetProc DataSource Seq. 

/* Children of tDataRow updated from characterValue -> storeNodevalue and
   used to update the datasource from endElement. */
DEFINE TEMP-TABLE tUpdateData  
  FIELD TargetProc   AS HANDLE
  FIELD DataSource   AS HANDLE
  FIELD Seq          AS INT  
  FIELD ColValues    AS CHAR
  INDEX DataSource TargetProc DataSource.

/* Register all datasource/methods that needs to be updated from nodes */ 
DEFINE TEMP-TABLE tMethod
  FIELD TargetProc AS HANDLE
  FIELD DataSource AS HANDLE
  FIELD Seq        AS INTEGER
  FIELD Method     AS CHAR
  FIELD NumParam   AS INT
  INDEX Method     AS UNIQUE TargetProc DataSource Seq Method. 
 
  /* Children of tMethodColumn (one record for each parameter) */   
DEFINE TEMP-TABLE tParamValue  
  FIELD TargetProc AS HANDLE
  FIELD DataSource AS HANDLE
  FIELD Seq        AS INTEGER
  FIELD Method     AS CHAR
  FIELD Num        AS INT
  FIELD NodeValue  AS CHAR 
  INDEX Method     TargetProc DataSource Seq Method Num.

DEFINE TEMP-TABLE tMapping
  FIELD TargetProc    AS HANDLE
  FIELD Direction     AS CHAR
  FIELD Name          AS CHAR
  FIELD XMLSchema     AS CHAR
  FIELD DTDPublicId   AS CHAR
  FIELD DTDSystemId   AS CHAR
  FIELD Destination   AS CHAR
  FIELD ReplyReq      AS LOG
  FIELD ReplySelector AS CHAR
  INDEX Direction  TargetProc Direction Name.

DEFINE STREAM webStream.  
 
&SCOP OUT PUT STREAM webStream UNFORMATTED

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-callOutParams) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD callOutParams Procedure 
FUNCTION callOutParams RETURNS LOGICAL
  (pdNode AS DEC)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createSchemaAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createSchemaAttributes Procedure 
FUNCTION createSchemaAttributes RETURNS HANDLE
  (piParentNode AS INT)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createSchemaChildren) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createSchemaChildren Procedure 
FUNCTION createSchemaChildren RETURNS HANDLE
  (piParentNode AS INT)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createSchemaPath) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createSchemaPath Procedure 
FUNCTION createSchemaPath RETURNS HANDLE
  (pcPath AS CHAR)   FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD dataSource Procedure 
FUNCTION dataSource RETURNS HANDLE
  (pcName AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-defineMapping) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD defineMapping Procedure 
FUNCTION defineMapping RETURNS LOGICAL
  ( pcName    AS CHARACTER,
    pcColumns AS CHARACTER,
    pcValues  AS CHARACTER  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findDataRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findDataRow Procedure 
FUNCTION findDataRow RETURNS LOGICAL
  (phObject     AS HANDLE,
   pcKeyValues  AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getConsumerSchema) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getConsumerSchema Procedure 
FUNCTION getConsumerSchema RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDestinationList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDestinationList Procedure 
FUNCTION getDestinationList RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDirectionList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDirectionList Procedure 
FUNCTION getDirectionList RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDocTypeList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDocTypeList Procedure 
FUNCTION getDocTypeList RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDTDPublicIdList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDTDPublicIdList Procedure 
FUNCTION getDTDPublicIdList RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDTDSystemIdList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDTDSystemIdList Procedure 
FUNCTION getDTDSystemIdList RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLoadedByRouter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLoadedByRouter Procedure 
FUNCTION getLoadedByRouter RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMapNameProducer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMapNameProducer Procedure 
FUNCTION getMapNameProducer RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMapObjectProducer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMapObjectProducer Procedure 
FUNCTION getMapObjectProducer RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMapTypeProducer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMapTypeProducer Procedure 
FUNCTION getMapTypeProducer RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNameList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNameList Procedure 
FUNCTION getNameList RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNameSpaceHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNameSpaceHandle Procedure 
FUNCTION getNameSpaceHandle RETURNS HANDLE
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getReplyReqList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getReplyReqList Procedure 
FUNCTION getReplyReqList RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getReplySelectorList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getReplySelectorList Procedure 
FUNCTION getReplySelectorList RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSchemaHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSchemaHandle Procedure 
FUNCTION getSchemaHandle RETURNS HANDLE
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSchemaList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSchemaList Procedure 
FUNCTION getSchemaList RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSchemaManager) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSchemaManager Procedure 
FUNCTION getSchemaManager RETURNS HANDLE
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTargetNameSpace) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTargetNameSpace Procedure 
FUNCTION getTargetNameSpace RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTypeName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTypeName Procedure 
FUNCTION getTypeName RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadProducerSchema) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD loadProducerSchema Procedure 
FUNCTION loadProducerSchema RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadSchema) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD loadSchema Procedure 
FUNCTION loadSchema RETURNS LOGICAL
  (pcSchema AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mapNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD mapNode Procedure 
FUNCTION mapNode RETURNS DECIMAL
  (pdNode         AS DEC,
   phDataSource   AS HANDLE,
   pcMapType      AS CHAR,
   pcMapName      AS CHAR,
   pcConversion   AS CHAR,
   pcMapParameter AS CHAR,
   pcNodeType     AS CHAR,
   pcNodeName     AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-NotFoundError) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD NotFoundError Procedure 
FUNCTION NotFoundError RETURNS CHARACTER
  (phDataSource AS HANDLE,
   pcKeyValues  AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-numParameters) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD numParameters Procedure 
FUNCTION numParameters RETURNS INTEGER
  ( phProc   AS HANDLE,
    pcMethod AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rowNotFoundError) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD rowNotFoundError Procedure 
FUNCTION rowNotFoundError RETURNS CHARACTER
  (phDataSource AS HANDLE,
   pcKeyValues  AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-schemaField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD schemaField Procedure 
FUNCTION schemaField RETURNS CHARACTER PRIVATE
  (phQuery AS HANDLE,
   pcName  AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDestinationList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDestinationList Procedure 
FUNCTION setDestinationList RETURNS LOGICAL
  ( pcDestinationList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDirectionList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDirectionList Procedure 
FUNCTION setDirectionList RETURNS LOGICAL
  ( pcDirectionList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDocTypeList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDocTypeList Procedure 
FUNCTION setDocTypeList RETURNS LOGICAL
  ( pcDocTypeList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDTDPublicIdList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDTDPublicIdList Procedure 
FUNCTION setDTDPublicIdList RETURNS LOGICAL
  ( pcDTDPublicIdList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDTDSystemIdList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDTDSystemIdList Procedure 
FUNCTION setDTDSystemIdList RETURNS LOGICAL
  ( pcDTDSystemIdList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLoadedByRouter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLoadedByRouter Procedure 
FUNCTION setLoadedByRouter RETURNS LOGICAL
  (plLoadedByRouter AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMapNameProducer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setMapNameProducer Procedure 
FUNCTION setMapNameProducer RETURNS LOGICAL
  (pcMapNameProducer AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMapObjectProducer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setMapObjectProducer Procedure 
FUNCTION setMapObjectProducer RETURNS LOGICAL
  (pcMapObjectProducer AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMapTypeProducer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setMapTypeProducer Procedure 
FUNCTION setMapTypeProducer RETURNS LOGICAL
  (pcMapTypeProducer AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNameList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setNameList Procedure 
FUNCTION setNameList RETURNS LOGICAL
  ( pcNameList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setReplyReqList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setReplyReqList Procedure 
FUNCTION setReplyReqList RETURNS LOGICAL
  ( pcReplyReqList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setReplySelectorList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setReplySelectorList Procedure 
FUNCTION setReplySelectorList RETURNS LOGICAL
  ( pcReplySelectorList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSchemaHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSchemaHandle Procedure 
FUNCTION setSchemaHandle RETURNS LOGICAL
  (phSchema AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSchemaList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSchemaList Procedure 
FUNCTION setSchemaList RETURNS LOGICAL
  ( pcSchemaList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTypeName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTypeName Procedure 
FUNCTION setTypeName RETURNS LOGICAL
  ( pcName AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-startDataRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD startDataRow Procedure 
FUNCTION startDataRow RETURNS LOGICAL
  (phDataSource AS HANDLE,
   pcAction     AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-storeNodeValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD storeNodeValue Procedure 
FUNCTION storeNodeValue RETURNS LOGICAL
  (phDataSource AS HANDLE,
   pcColumnName AS CHAR,
   pcNodeValue  AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-storeParameterNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD storeParameterNode Procedure 
FUNCTION storeParameterNode RETURNS LOGICAL
  (phDataSource AS HANDLE,
   pcMethod     AS CHAR,
   pdNode       AS DEC,
   piNum        AS INT,
   piNumParam   AS INT)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-storeParameterValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD storeParameterValue Procedure 
FUNCTION storeParameterValue RETURNS LOGICAL
  (phDataSource AS HANDLE,
   pcMethod     AS CHAR,
   piNum        AS INT,
   piNumParam   AS INT,
   pcValue      AS CHAR)  FORWARD.

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
         HEIGHT             = 15.14
         WIDTH              = 50.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/b2bprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/* There's nothing to see here, please move on */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-characterValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE characterValue Procedure 
PROCEDURE characterValue :
/*------------------------------------------------------------------------------
  Purpose: Trap the event of a text node being parsed.     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcPath  AS CHAR   NO-UNDO.
  DEFINE INPUT PARAMETER pcValue AS CHAR NO-UNDO.
  
  DEFINE VARIABLE hSchemaBuffer AS HANDLE NO-UNDO.
  DEFINE VARIABLE hSchemaQuery  AS HANDLE NO-UNDO.
  DEFINE VARIABLE cMapType      AS CHAR   NO-UNDO.
  DEFINE VARIABLE cMapName      AS CHAR   NO-UNDO.
  DEFINE VARIABLE cDataObject   AS CHAR   NO-UNDO.
  DEFINE VARIABLE cConversion   AS CHAR   NO-UNDO.
  DEFINE VARIABLE iMapParameter AS INT    NO-UNDO.
  DEFINE VARIABLE hDataSource   AS HANDLE NO-UNDO.
  DEFINE VARIABLE iNumParams    AS INT    NO-UNDO.

  hSchemaQuery = {fnarg createSchemaPath pcPath}.
  hSchemaQuery:GET-FIRST.
  
  IF NOT hSchemaQuery:QUERY-OFF-END THEN 
  DO:
    ASSIGN
      cMapType      = schemaField(hSchemaQuery,'MapType':U)
      cMapName      = schemaField(hSchemaQuery,'MapName':U)
      iMapParameter = int(schemaField(hSchemaQuery,'MapParameter':U))
      cDataObject   = schemaField(hSchemaQuery,'ObjectName':U)
      cConversion   = schemaField(hSchemaQuery,'mapConversion':U)
      hDataSource   = {fnarg dataSource cDataObject}.
    
    IF cConversion <> "":U THEN
      pcValue = DYNAMIC-FUNCTION(cConversion IN TARGET-PROCEDURE, pcValue).

    IF CAN-DO("procedure,function":U,cMapType) THEN
    DO:
      iNumParams = DYNAMIC-FUNCTION('numParameters':U IN TARGET-PROCEDURE,
                                    hDataSource,
                                    cMapName).

      DYNAMIC-FUNCTION('storeParameterValue':U IN TARGET-PROCEDURE,
                       hDataSource,
                       cMapName,
                       iMapParameter,
                       iNumParams,
                       pcValue).
    END. 
    ELSE IF cMaptype = "Column":U THEN
    DO:
      /* We currently call the SDOs for the column mappings in the SBO,
         so if this is a SBO qualifed column fix it so that it looks like 
         it's mapped to the SDO */

      IF NUM-ENTRIES(cMapName,".":U) > 1 THEN
      DO:
        ASSIGN
          cDataObject = cDataObject  + ".":U + ENTRY(1,cMapName,".":U) 
          cMapName    = ENTRY(2,cMapName,".":U) 
          hDataSource = {fnarg dataSource cDataObject}.
      END.

      DYNAMIC-FUNCTION('storeNodeValue':U IN TARGET-PROCEDURE,
                        hDataSource, 
                        cMapName, 
                        pcValue ).
    END.
  END. /* if not SchemaQuery:off-end  */ 

  hSchemaBuffer = hSchemaQuery:GET-BUFFER-HANDLE(1).
  DELETE OBJECT hSchemaQuery.
  DELETE OBJECT hSchemaBuffer.  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:  Override in order to delete the schema temp-table.   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hNameSpace AS HANDLE NO-UNDO.
  DEFINE VARIABLE hSchema    AS HANDLE NO-UNDO.
  
  {get SchemaHandle hSchema}.
  
  IF VALID-HANDLE(hSchema) THEN
    DELETE OBJECT hSchema.

  {get NameSpaceHandle hNameSpace}.

  IF VALID-HANDLE(hNameSpace) THEN
    DELETE OBJECT hNameSpace.

  FOR EACH tMapping WHERE tMapping.TargetProc = TARGET-PROCEDURE:
    DELETE tMapping.
  END.
  
  FOR EACH tMethodNode WHERE tMethodNode.TargetProc = TARGET-PROCEDURE:
    DELETE tMethodNode.
  END.
  
  FOR EACH tDataSource WHERE tDataSource.TargetProc = TARGET-PROCEDURE:
   /* Event procedure that enables the developer to undo properties like
      Keyfields etc.that was set in mapDataSource when the object was mapped*/
    RUN unmapDataSource IN TARGET-PROCEDURE(TDataSource.DataSource) NO-ERROR.
    DELETE tDataSource.
  END.
  
  RUN SUPER.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-endDocument) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE endDocument Procedure 
PROCEDURE endDocument :
/*------------------------------------------------------------------------------
  Purpose:   Traps the event that the document has been processed and 
             passes all the collected data that has been stored on other
             events during the processing.      
  Parameters: 
  Notes:     We collect all the data to ensure that all the updates is done 
             in the order of which the mapped objects are linked to nodes. 
             It's too early on startEvent and even on endEvent because child
             nodes ends before parent nodes (we don't want orderlines to be 
             saved BEFORE the order)                                                                             
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lOk         AS LOG  NO-UNDO.
  DEFINE VARIABLE lFound      AS LOG  NO-UNDO.
  DEFINE VARIABLE cMessages   AS CHAR NO-UNDO.
  DEFINE VARIABLE cType       AS CHAR NO-UNDO.
  DEFINE VARIABLE cValue      AS CHAR NO-UNDO EXTENT 8.
  DEFINE VARIABLE cLocalMsg   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cKeyError   AS CHAR       NO-UNDO.

  /* This needs to use the Seq index which is the PRIMARY index */
  RowLoop: 
  FOR EACH tDataRow WHERE tDataRow.TargetProc = TARGET-PROCEDURE:
    
    lFound = FALSE.

    IF CAN-DO('Find,Delete':U,tDataRow.Action)
    OR CAN-DO(tDataRow.Action,'Update':U) THEN
    DO:
      lFound = FALSE.
      
      FIND tKeyData OF tDataRow NO-ERROR.

      IF AVAIL tKeyData THEN
        lFound = DYNAMIC-FUNCTION('findDataRow':U IN TARGET-PROCEDURE,
                                   tDataRow.DataSource,
                                   tKeyData.ValueList). 
      ELSE DO: 
         /* No key fields mapped, this is a design error  */
         MESSAGE SUBSTITUTE({fnarg messageNumber 42}, {fn getObjectName tDataRow.DataSource})
                 VIEW-AS ALERT-BOX INFORMATION.
         LEAVE RowLoop. /* Get out of the loop ---------------------> */
      END.
      
      /* If this is a find or update-must (ie create is not in the action list), 
         and find failed we must give an error message */
      IF NOT lFound AND NOT CAN-DO(tDataRow.Action,'Create':U) THEN
      DO:
        cLocalMsg = DYNAMIC-FUNCTION('rowNotFoundError':U IN TARGET-PROCEDURE,
                                      tDataRow.DataSource,
                                      IF AVAIL tKeydata 
                                      THEN tKeyData.ValueList
                                      ELSE '':U).  
           
      END. /* not found */
    END. /* Find,delete or update */
    
    FIND tUpdateData OF tDataRow NO-ERROR.

    /* We need to addRow here if this is a create and methods are used */
    IF  CAN-FIND(tMethod OF tDataRow) 
    AND CAN-DO(tDataRow.Action,'Create') 
    AND lFound = FALSE THEN
    DO:
       RUN updateDataValues IN TARGET-PROCEDURE 
                           (tDataRow.DataSource,
                           'Create':U,
                            INPUT-OUTPUT tUpdateData.ColValues) NO-ERROR.
      
      DYNAMIC-FUNCTION('addRow':U IN tDataRow.dataSource,'':U).     
      tDataRow.Action = 'Update':U.
      lFound = TRUE.
    END.
    
    FOR EACH tMethod OF tDataRow:
      FOR EACH tParamValue OF tMethod:
        ASSIGN 
         cValue[tParamValue.Num] = tParamValue.NodeValue.      
        DELETE tParamValue.
      END.  
      
      cType = ENTRY(1,tDataRow.DataSource:GET-SIGNATURE(tMethod.Method)). 
      
      CASE tMethod.NumParam:
        WHEN 1 THEN
          IF cType = "Procedure":U THEN
            RUN VALUE(tMethod.Method) IN tDataRow.DataSource 
                     (cValue[1]).
          ELSE 
            DYNAMIC-FUNCTION(tMethod.Method IN tDataRow.DataSource,
                    cValue[1]).
        WHEN 2 THEN
          IF cType = "Procedure":U THEN
            RUN VALUE(tMethod.Method) IN tDataRow.DataSource 
                    (cValue[1],cValue[2]).
          ELSE 
            DYNAMIC-FUNCTION(tMethod.Method IN tDataRow.DataSource,
                    cValue[1],cValue[2]).                    
        WHEN 3 THEN
          IF cType = "Procedure":U THEN
            RUN VALUE(tMethod.Method) IN tDataRow.DataSource 
                    (cValue[1],cValue[2],cValue[3]).
          ELSE 
            DYNAMIC-FUNCTION(tMethod.Method IN tDataRow.DataSource,
                    cValue[1],cValue[2],cValue[3]).
        WHEN 4 THEN
          IF cType = "Procedure":U THEN
            RUN VALUE(tMethod.Method) IN tDataRow.DataSource 
                    (cValue[1],cValue[2],cValue[3],cValue[4]).
          ELSE 
            DYNAMIC-FUNCTION(tMethod.Method IN tDataRow.DataSource,
                    cValue[1],cValue[2],cValue[3],cValue[4]).
        WHEN 5 THEN
          IF cType = "Procedure":U THEN
            RUN VALUE(tMethod.Method) IN tDataRow.DataSource 
                    (cValue[1],cValue[2],cValue[3],cValue[4],cValue[5]).
          ELSE 
            DYNAMIC-FUNCTION(tMethod.Method IN tDataRow.DataSource,
                    cValue[1],cValue[2],cValue[3],cValue[4],cValue[5]).
        WHEN 6 THEN
          IF cType = "Procedure":U THEN
           RUN VALUE(tMethod.Method) IN tDataRow.DataSource 
                    (cValue[1],cValue[2],cValue[3],cValue[4],cValue[5],cValue[6]).
          ELSE 
            DYNAMIC-FUNCTION(tMethod.Method IN tDataRow.DataSource,
                    cValue[1],cValue[2],cValue[3],cValue[4],cValue[5],cValue[6]).
        WHEN 7 THEN
          IF cType = "Procedure":U THEN
            RUN VALUE(tMethod.Method) IN tDataRow.DataSource 
                    (cValue[1],cValue[2],cValue[3],cValue[4],cValue[5],cValue[6],
                     cValue[7]).
          ELSE 
            DYNAMIC-FUNCTION(tMethod.Method IN tDataRow.DataSource,
                    cValue[1],cValue[2],cValue[3],cValue[4],cValue[5],cValue[6],
                    cValue[7]).
        WHEN 8 THEN
          IF cType = "Procedure":U THEN
            RUN VALUE(tMethod.Method) IN tDataRow.DataSource 
                     (cValue[1],cValue[2],cValue[3],cValue[4],cValue[5],cValue[6],
                     cValue[7],cValue[8]).
          ELSE 
            DYNAMIC-FUNCTION(tMethod.Method IN tDataRow.DataSource,
                    cValue[1],cValue[2],cValue[3],cValue[4],cValue[5],cValue[6],
                    cValue[7],cValue[8]).
      END CASE.

      DELETE tMethod.
    END.

    IF CAN-DO(tDataRow.Action,'Find':U) THEN
      lOk = lFound.
    
    IF CAN-DO(tDataRow.Action,'Create':U) AND lFound = FALSE THEN
    DO:
      lOk = FALSE.
      IF AVAIL tUpdateData THEN
      DO:
        /* Event procedure that enables changing the data  */
        RUN updateDataValues IN TARGET-PROCEDURE 
                              (tDataRow.DataSource,
                              'Create':U,
                              INPUT-OUTPUT tUpdateData.ColValues) NO-ERROR.

        lOk = DYNAMIC-FUNCTION('createRow':U IN tDataRow.DataSource,
                                tUpdateData.ColValues).              
      END. 
    END.
    
    ELSE 
    IF CAN-DO(tDataRow.Action,'Update') AND lFound THEN
    DO:
      lOk = FALSE.
      IF AVAIL tUpdateData THEN
      DO:
        /* Event procedure that enables changing the data  */
        RUN updateDataValues IN TARGET-PROCEDURE 
                              (tDataRow.DataSource, 
                               'Update':U,
                               INPUT-OUTPUT tUpdateData.ColValues) NO-ERROR.

        lOk = DYNAMIC-FUNCTION('updateRow':U IN tDataRow.DataSource,
                               ?,                        
                               tUpdateData.ColValues).                 
      END.
    END.
    ELSE
    IF CAN-DO(tDataRow.Action,'Delete':U) AND lFound THEN
    DO:
      lOk = FALSE.
      IF AVAIL tUpdateData THEN
        lOk = DYNAMIC-FUNCTION('deleteRow':U IN tDataRow.DataSource,?).                 
    END.
    ELSE IF tDataRow.Action = '':U THEN 
      lOk = TRUE.

    IF NOT lOk OR {fn anymessage tDataRow.DataSource} THEN
    DO:
      ASSIGN 
        cMessages = DYNAMIC-FUNCTION('fetchMessages':U IN tDataRow.DataSource)
        cMessages = cLocalMsg  
                 + (IF cLocalMsg = '':U OR cMessages = '':U THEN '':U ELSE CHR(3))  
                 + cMessages.
      
      /* Add errors to this object's que, the  receiveHandler checks for 
         anyMessage and calls the   */          
      RUN addMessage IN TARGET-PROCEDURE(cMessages,?,?).
      LEAVE RowLoop. /* delete further down. */
    END.

    DELETE tDataRow.

    IF AVAIL tUpdateData THEN
      DELETE tUpdateData.
    
    IF AVAIL tKeyData THEN
      DELETE tKeyData.
  END. /* for each  */ 


  FOR EACH tDataSource WHERE  tDataSource.targetProc = TARGET-PROCEDURE:
              
    IF lOk AND tDataSource.Commit = TRUE THEN
      RUN commitTransaction IN tDataSource.DataSource.
    
    /* If something went wrong, undo transaction or 
      cancel in case we are in addmode */  
    IF NOT lok THEN
    DO:
       IF tDataSource.Commit THEN 
         RUN undoTransaction IN tDataSource.DataSource NO-ERROR.
       ELSE
         {fn cancelRow tDataSource.DataSource} NO-ERROR. 
    END.

    DELETE tDataSource.
  END.

  /* clean up in case of errors */
  FOR EACH tDataRow WHERE tDataRow.TargetProc = TARGET-PROCEDURE:    
    FIND tUpdateData OF tDataRow NO-ERROR.

    IF AVAIL tUpdateData THEN
      DELETE tUpdateData.
    
    FIND tKeyData OF tDataRow NO-ERROR.
    
    IF AVAIL tKeyData THEN
      DELETE tKeyData.

    FOR EACH tMethod OF tDataRow:
      FOR EACH tParamValue OF tMethod:
        DELETE tParamValue.
      END.
      DELETE tMethod.
    END.
    DELETE tDataRow.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-endElement) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE endElement Procedure 
PROCEDURE endElement :
/*------------------------------------------------------------------------------
  Purpose: Trap the event of an XML element having been processed, 
  Parameters: 
    pcPath       - The logical path (not the numbered XPath) 
    pcNameSpace  - The NameSpace (future support)
    pcName       - the name of the element
    pcQualName   - Name qualifed with the namespace prefix 
    pcAttributes - The names of all the attrributes. 
    
  Notes: This is just an empty stub to override. 
         It really belongs in xml.p.....   or xml.p should use no-error.      
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcPath       AS CHAR   NO-UNDO.
  DEFINE INPUT PARAMETER pcNameSpace  AS CHAR   NO-UNDO.
  DEFINE INPUT PARAMETER pcName       AS CHAR   NO-UNDO.
  DEFINE INPUT PARAMETER pcQualName   AS CHAR   NO-UNDO.
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:   Load schema 
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSchema AS CHAR   NO-UNDO.
  
  RUN processMappings IN TARGET-PROCEDURE.

  RUN SUPER.  
  IF RETURN-VALUE BEGINS "ADM-ERROR:U" THEN
    RETURN RETURN-VALUE.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processMappings) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processMappings Procedure 
PROCEDURE processMappings :
/*------------------------------------------------------------------------------
  Purpose:     This procedure creates tMapping temp-table records from
               Intance Properties: DirectionList, NameList, DestinationList,
               SchemaList, DTDPublicIdList, DTDSystemIdList, ReplyReqList and 
               ReplySelectorList property values.
  Parameters:  <none>
  Notes:       These properties are stored in list formats to support 
               several mappings for one Producer instance.
             - loadProducerSchema will identify which is the current one and
               use it to load the correct schema and store some of them in 
               properties: Destination, ReplyReq,ReplySelector, DTDPublicId 
               DTDSystemId   
------------------------------------------------------------------------------*/
DEFINE VARIABLE cDirections     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNames          AS CHARACTER NO-UNDO.
DEFINE VARIABLE cSchemas        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDTDPublicIds   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDTDSystemIds   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDestinations   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cReplyReqs      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cReplySelectors AS CHARACTER NO-UNDO.
DEFINE VARIABLE iNumDir         AS INTEGER   NO-UNDO.

  {get DirectionList cDirections}.
  {get NameList cNames}.
  {get SchemaList cSchemas}.
  {get DTDPublicIdList cDTDPublicIds}.
  {get DTDSystemIdList cDTDSystemIds}.
  {get DestinationList cDestinations}.
  {get ReplyReqList cReplyReqs}.
  {get ReplySelectorList cReplySelectors}.

  DO iNumDir = 1 TO NUM-ENTRIES(cDirections, CHR(1)):
    CREATE tMapping.
    ASSIGN
      tMapping.Direction     = ENTRY(iNumDir, cDirections, CHR(1))
      tMapping.Name          = ENTRY(iNumDir, cNames, CHR(1))
      tMapping.XMLSchema     = ENTRY(iNumDir, cSchemas, CHR(1))
      tMapping.DTDPublicId   = ENTRY(iNumDir, cDTDPublicIds, CHR(1))
      tMapping.DTDSystemId   = ENTRY(iNumDir, cDTDSystemIds, CHR(1))
      tMapping.Destination   = ENTRY(iNumDir, cDestinations, CHR(1))
      tMapping.ReplyReq      = IF ENTRY(iNumDir, cReplyReqs, CHR(1)) = "yes":U THEN TRUE 
                               ELSE FALSE
      tMapping.ReplySelector = IF ENTRY(iNumDir, cReplySelectors, CHR(1)) = "":U THEN ?
                               ELSE ENTRY(iNumDir, cReplySelectors, CHR(1))
      tMapping.TargetProc    = TARGET-PROCEDURE.

  END.  /* do iNumDir */
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processMessages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processMessages Procedure 
PROCEDURE processMessages :
/*------------------------------------------------------------------------------
  Purpose: Called from receivehandler wwhen an error occurs.     
  Parameters:  pcChar  chr(3) ond chr(4) delimited list 
              (as returned from fetchMessages)
  Notes:    This is expected to be overridden, so we pass the data from 
            fetchmessages so the user don't have to do this. Otherwise the 
            default is exactly as in ShowDataMessages in other adm objects.
            This is called from ReceiveHandler so 
            RETURN ERROR or 'ADM-ERROR' will make sure that the message is 
            not acknowledged.                
-------------------------------------------------------------- ----------------*/
  DEFINE INPUT PARAMETER pcMessages AS CHAR   NO-UNDO.

  DEFINE VARIABLE iMsgCnt  AS INT    NO-UNDO.
  DEFINE VARIABLE iMsg     AS INT    NO-UNDO.
  DEFINE VARIABLE cfield   AS CHAR   NO-UNDO.
  DEFINE VARIABLE cTable   AS CHAR   NO-UNDO.
  DEFINE VARIABLE cText    AS CHAR   NO-UNDO.
  DEFINE VARIABLE cMessage AS CHAR   NO-UNDO.

  iMsgCnt = NUM-ENTRIES(pcMessages, CHR(3)).
  DO iMsg = 1 TO iMsgCnt:
    /* Format a string of messages; each has a first line of
       "Field:  <field>    "Table:  <table>"
       (if either of these is defined) plus the error message on a
        separate line. */

    ASSIGN 
      cMessage = ENTRY(iMsg, pcMessages, CHR(3))
          
      cField   = (IF NUM-ENTRIES(cMessage, CHR(4)) > 1 
                  THEN ENTRY(2, cMessage, CHR(4)) 
                  ELSE "":U)
      cTable   = (IF NUM-ENTRIES(cMessage, CHR(4)) > 2 
                  THEN ENTRY(3, cMessage, CHR(4)) 
                  ELSE "":U)
      cText    = cText 
               + (IF cField NE "":U 
                  THEN DYNAMIC-FUNCTION('messageNumber':U IN TARGET-PROCEDURE,10) 
                  ELSE "":U)              
               + cField 
               + "   ":U 
               + (IF cTable NE "":U 
                  THEN DYNAMIC-FUNCTION('messageNumber':U IN TARGET-PROCEDURE, 11) 
                  ELSE "":U) 
               + cTable 
               + (IF cField NE "":U OR cTable NE "":U 
                  THEN "~n":U 
                  ELSE "":U)
               + "  ":U 
               + ENTRY(1, cMessage, CHR(4)) + "~n":U.

  END.   /* Do iMsg = 1 to   */
  
  IF cText NE "":U THEN
    MESSAGE cText VIEW-AS ALERT-BOX ERROR.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-produceAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE produceAttributes Procedure 
PROCEDURE produceAttributes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER piParentSchemaNode AS INT NO-UNDO.
  DEFINE INPUT PARAMETER pdOwnerNode        AS DEC NO-UNDO.
  DEFINE INPUT PARAMETER phDataSource       AS HANDLE NO-UNDO.

  DEFINE VARIABLE dId             AS DEC    NO-UNDO.

  DEFINE VARIABLE hSchemaQuery    AS HANDLE NO-UNDO.
  DEFINE VARIABLE cDataObject     AS CHAR   NO-UNDO.
  DEFINE VARIABLE hLinkDataSource AS HANDLE NO-UNDO. /* Passed to children */
  DEFINE VARIABLE hMapDataSource  AS HANDLE NO-UNDO.
  DEFINE VARIABLE hSchemaBuffer   AS HANDLE NO-UNDO.

  hSchemaQuery = {fnarg createSchemaAttributes piParentSchemaNode}.
  hSchemaQuery:GET-FIRST.
  hLinkDataSource = phDataSource. 
  
  DO WHILE hSchemaQuery:QUERY-OFF-END = FALSE:          
    ASSIGN
      cDataObject = schemaField(hSchemaQuery,'ObjectName':U).

    IF cDataObject <> "":U THEN
      hMapDataSource = {fnarg dataSource cDataObject}.
    ELSE 
      hMapDataSource = hLinkDataSource.

    DYNAMIC-FUNCTION('mapNode' IN TARGET-PROCEDURE,
                      pdOwnerNode,
                      hMapdataSource,
                      schemaField(hSchemaQuery,'MapType':U),
                      schemaField(hSchemaQuery,'MapName':U),
                      schemaField(hSchemaQuery,'mapConversion':U),
                      schemaField(hSchemaQuery,'MapParameter':U),
                      'Attribute':U, 
                      schemaField(hSchemaQuery,'NodeName':U)).

    hSchemaQuery:GET-NEXT.
  END.

  hSchemaBuffer = hSchemaQuery:GET-BUFFER-HANDLE(1).
  DELETE OBJECT hSchemaQuery.
  DELETE OBJECT hSchemaBuffer.  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-produceChildren) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE produceChildren Procedure 
PROCEDURE produceChildren :
/*------------------------------------------------------------------------------
  Purpose: Produce all child nodes of an element/document   
  Parameters: piParentSchemaNode - Schema parent node 
              pdParentNode       - Actual parent node
              phDataSource       - The LINKed datasource of the parent.                
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER piParentSchemaNode AS INT NO-UNDO.
  DEFINE INPUT PARAMETER pdParentNode       AS DEC NO-UNDO.
  DEFINE INPUT PARAMETER phDataSource       AS HANDLE NO-UNDO.
   
  DEFINE VARIABLE dId             AS DEC    NO-UNDO.
  DEFINE VARIABLE hSchemaQuery    AS HANDLE NO-UNDO.
  DEFINE VARIABLE lLink           AS LOG    NO-UNDO.
   
  DEFINE VARIABLE cDataObject     AS CHAR   NO-UNDO.
  DEFINE VARIABLE cMapType        AS CHAR   NO-UNDO.
  DEFINE VARIABLE hLinkDataSource AS HANDLE NO-UNDO. /* Passed to children */
  DEFINE VARIABLE hMapDataSource  AS HANDLE NO-UNDO.
  DEFINE VARIABLE hSchemaBuffer   AS HANDLE NO-UNDO.
  DEFINE VARIABLE cMapName        AS CHAR   NO-UNDO.
  DEFINE VARIABLE lCancel         AS LOG    NO-UNDO.
  DEFINE VARIABLE lRecordAvail    AS LOG    NO-UNDO.
   
  hSchemaQuery = {fnarg createSchemaChildren piParentSchemaNode}.
  hSchemaQuery:GET-FIRST.
  hLinkDataSource = phDataSource. 
   
  DO WHILE hSchemaQuery:QUERY-OFF-END = FALSE: 
    
    ASSIGN
      cMapType     = schemaField(hSchemaQuery,'MapType':U)
      cDataObject  = schemaField(hSchemaQuery,'ObjectName':U)
      lRecordAVAIL = TRUE.
    
    IF cMapType = 'Object':U THEN
    DO:
      cMapName = schemaField(hSchemaQuery,'MapName':U).
      /*SBO?*/
      IF cMapName <> cDataObject THEN 
        cDataObject = cDataObject + ".":U + cMapname.

      hMapDataSource = {fnarg dataSource cDataObject}.
    
      IF NOT VALID-HANDLE(hMapDataSource) THEN
      DO:
         MESSAGE {fnarg messageNumber 43} + " " +  cDataObject 
          VIEW-AS ALERT-BOX.
         RETURN "ADM-ERROR":U.
      END.
      ELSE DO:
         RUN confirmContinue IN hMapDataSource (INPUT-OUTPUT lCancel) NO-ERROR.
         IF lCancel THEN RETURN "ADM-ERROR":U.
      END.  /* else do - valid Data Source */

      IF NOT lLink AND cMapType = "Object":U THEN 
      DO:
        ASSIGN  
           hLinkDataSource = hMapDataSource
           lLink           = TRUE.  

        IF VALID-HANDLE(hLinkDataSource) AND pdParentNode <> 0 THEN
           RUN fetchFirst IN hLinkDataSource.
        
        IF DYNAMIC-FUNCTION('getQueryPosition':U IN hLinkDataSource)
        BEGINS "NoRecord":U THEN
          ASSIGN lRecordAvail = FALSE
                 lLink        = FALSE .
        ELSE lRecordAvail = TRUE.
      END. /* not lLink */
    END.  /* cDataObject <> '' */
    ELSE
    DO:
      /*SBO columns have SDO name as first entry */ 
      cMapName = schemaField(hSchemaQuery,'MapName':U).

      IF cMapName NE '':U THEN
      DO:
        IF cMaptype = 'column':U 
        AND NUM-ENTRIES(cMapName,'.':U) > 1 THEN
          cDataObject = cDataObject + ".":U + entry(1,cMapName,'.':U).
      
        hMapDataSource = {fnarg dataSource cDataObject}.

        IF NOT VALID-HANDLE(hMapDataSource) THEN
        DO:
           MESSAGE {fnarg messageNumber 43} + " " +  cDataObject 
           VIEW-AS ALERT-BOX.
           RETURN "ADM-ERROR":U.
        END.
        ELSE DO:
           RUN confirmContinue IN hMapDataSource (INPUT-OUTPUT lCancel) NO-ERROR.
           IF lCancel THEN RETURN "ADM-ERROR":U.
        END.  /* else do - valid Data Source */
      END.  /* if cMapName ne '' */
      
    END.

    IF lRecordAvail THEN
    DO:
      
       dId = DYNAMIC-FUNCTION('mapNode':U IN TARGET-PROCEDURE,
                           pdParentNode,
                           hMapDataSource,
                           cMapType,
                           schemaField(hSchemaQuery,'MapName':U),
                           schemaField(hSchemaQuery,'mapConversion':U),
                           schemaField(hSchemaQuery,'MapParameter':U),
                           'Element':U, 
                           schemaField(hSchemaQuery,'NodeName':U)).

       RUN produceChildren IN TARGET-PROCEDURE
                          (schemaField(hSchemaQuery,'Node':U),
                           dId,
                           hLinkDataSource).
    
       IF RETURN-VALUE = "ADM-ERROR":U THEN
          RETURN "ADM-ERROR":U.

       RUN produceAttributes IN TARGET-PROCEDURE
                        (schemaField(hSchemaQuery,'Node':U),
                         dId,
                         hLinkDataSource).
    
       DYNAMIC-FUNCTION("callOutParams":U IN TARGET-PROCEDURE,
                         dId).
    
      /* If we are processing a link-mapping we need to check if there 
        are more records available */  
      IF lLink THEN 
      DO: 
        IF pdParentNode = 0 OR CAN-DO("LastRecord,OnlyRecord":U,
                 DYNAMIC-FUNCTION('getQueryPosition' IN hLinkDataSource)) THEN  
          lLink = FALSE.                
        ELSE 
          RUN fetchNext IN hLinkDataSource.
      END. /* lLink */
    END. /* lrecordavail */
    IF lLink = FALSE THEN
       hSchemaQuery:GET-NEXT.
  END. /* do while  */  
   
  hSchemaBuffer = hSchemaQuery:GET-BUFFER-HANDLE(1).
  DELETE OBJECT hSchemaQuery.
  DELETE OBJECT hSchemaBuffer.  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-produceDocument) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE produceDocument Procedure 
PROCEDURE produceDocument :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dId               AS DECIMAL NO-UNDO.
  DEFINE VARIABLE cTargetNameSpace  AS CHAR    NO-UNDO.
  DEFINE VARIABLE lDTD              AS LOGICAL NO-UNDO.
  SESSION:SET-WAIT-STATE('general':U).
  
  {fn createDocument}.
  
  RUN produceChildren IN TARGET-PROCEDURE(0,0,?).

  {get UseDTD lDTD}.
  IF NOT lDTD THEN
  DO:     
    /* Assign the TargetNameSpace to the root element */
    {get DocumentElement dId}.
    IF did <> ? THEN 
    DO:
      {get TargetNameSpace cTargetNameSpace}.
      IF cTargetNameSpace <> '':U THEN
        DYNAMIC-FUNCTION('assignAttribute':U IN TARGET-PROCEDURE,
                          did,
                          'xmlns':U,
                          cTargetNameSpace). 
    END. /* did <> ? */
  END.

  SESSION:SET-WAIT-STATE('':U).

  IF RETURN-VALUE = "ADM-ERROR":U THEN
        RETURN "ADM-ERROR":U.

  RETURN. 

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
  Notes:       phMessage is the handle of the JMS message being received
               The xml.p SUPER creates an XML document and loads it from the 
               message.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phMessage AS HANDLE NO-UNDO.
  
  DEFINE VARIABLE cConsumerSchema  AS CHAR   NO-UNDO.
  DEFINE VARIABLE cMessages        AS CHAR   NO-UNDO.
  DEFINE VARIABLE lLoadedByRouter  AS LOG    NO-UNDO.

  {get LoadedByRouter lLoadedByRouter}.

  /* Skip createDocument and :LOAD in super and loadSchema if this already 
     has been done by the router */   

  IF NOT lLoadedByRouter THEN
  DO:
    RUN SUPER(phMessage). 
  
    {get ConsumerSchema cConsumerSchema}.
  
    {fnarg loadSchema cConsumerSchema}.
  END.

  RUN processDocument IN TARGET-PROCEDURE.
  
  /* Don't aknowledge the message if 'adm-error' */
  IF RETURN-VALUE BEGINS "ADM-ERROR":U THEN
    RETURN ERROR. /* The consumer takes care of this */ 
  
  /* Logical errors needs to be handled  */ 
  IF {fn anyMessage} THEN
  DO:
    cMessages = DYNAMIC-FUNCTION('fetchMessages':U IN TARGET-PROCEDURE).  

    RUN processMessages IN TARGET-PROCEDURE (cMessages) NO-ERROR.

    /* Normally this is a logical error so the messages should be acknowledged,
       but we allow overrides to return error or 'adm-error' to indicate that 
       the messages should not be acknowledged */
    IF ERROR-STATUS:ERROR OR RETURN-VALUE BEGINS "ADM-ERROR":U THEN
      RETURN ERROR. /* The consumer takes care of this */   

  END.
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sendHandler) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sendHandler Procedure 
PROCEDURE sendHandler :
/*------------------------------------------------------------------------------
   Purpose: Event handler for the send of the message.      
Parameters: phMsgHandler - the handle of the message being sent. 
     Notes: Get the actual schema and produce an XML document before 
            call super, which takes care of the actual saving of the document 
            to the memptr that is transfered to the message object.       
            Override this to set header and other message information       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phMsgHandler AS HANDLE NO-UNDO.

  RUN produceDocument IN TARGET-PROCEDURE.
  
  IF RETURN-VALUE = "ADM-ERROR":U THEN
    RETURN "ADM-ERROR":U.
    
  RUN SUPER(phMsgHandler).
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sendMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sendMessage Procedure 
PROCEDURE sendMessage :
/*------------------------------------------------------------------------------
  Purpose:    Override the msghandler message in order to load scheam and 
              set message specific properties.       
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/     
  {fn deleteDocument}.

  IF {fn loadProducerSchema} THEN
    RUN SUPER.             
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-startElement) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startElement Procedure 
PROCEDURE startElement :
/*------------------------------------------------------------------------------
  Purpose: Trap the event of a new XML element being processed, check if it's
           mapped to a dataObject and register it if it is.     
  Parameters: 
    pcPath       - The logical path (not the numbered XPath) 
    pcNameSpace  - The NameSpace (future support)
    pcName       - the name of the element
    pcQualName   - Name qualifed with the namespace prefix 
    pcAttributes - The names of all the attrributes. 
    
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcPath       AS CHAR   NO-UNDO.
  DEFINE INPUT PARAMETER pcNameSpace  AS CHAR   NO-UNDO.
  DEFINE INPUT PARAMETER pcName       AS CHAR   NO-UNDO.
  DEFINE INPUT PARAMETER pcQualName   AS CHAR   NO-UNDO.

  DEFINE VARIABLE hSchemaBuffer AS HANDLE NO-UNDO.
  DEFINE VARIABLE hSchemaQuery  AS HANDLE NO-UNDO.
  DEFINE VARIABLE cMapType      AS CHAR   NO-UNDO.
  DEFINE VARIABLE cNodeName     AS CHAR   NO-UNDO.
  DEFINE VARIABLE cDataObject   AS CHAR   NO-UNDO.
  DEFINE VARIABLE hDataSource   AS HANDLE NO-UNDO.
  DEFINE VARIABLE iAttr         AS INT    NO-UNDO.
  DEFINE VARIABLE cMode         AS CHAR   NO-UNDO.
  DEFINE VARIABLE lAutoCommit   AS LOG    NO-UNDO.
  DEFINE VARIABLE cMapName      AS CHAR   NO-UNDO.

  hSchemaQuery = {fnarg createSchemaPath pcPath}.
  hSchemaQuery:GET-FIRST.
  
  IF NOT hSchemaQuery:QUERY-OFF-END THEN 
  DO:
    ASSIGN
      cNodeName   = schemaField(hSchemaQuery,'NodeName':U)
      cMapType    = schemaField(hSchemaQuery,'mapType':U)
      cDataObject = schemaField(hSchemaQuery,'ObjectName':U).

    IF cMapType = "Object":U AND cDataObject <> '':U THEN
    DO:
      cMapName = schemaField(hSchemaQuery,'MapName':U).
      
      /* Is this mapped to an SDO inside of the SBO? */
      IF cMapName <> cDataObject THEN
        cDataObject = cDataObject + "." + cMapname.
      
      hDataSource = {fnarg dataSource cDataObject}.
      
      IF NOT VALID-HANDLE(hDataSource) THEN
        RETURN "ADM-ERROR":U.
      
      cMode = schemaField(hSchemaQuery,'MapUpdate':U).
      
      IF cMode BEGINS "update-may":U THEN
        cMode = "Update,Create":U. 

      ELSE IF cMode BEGINS "update":U THEN
        cMode = "Update":U.

      ELSE IF cMode BEGINS "Create":U THEN
         cMode = "Create":U.

      /* Register the Row */
      DYNAMIC-FUNCTION('startDataRow':U IN TARGET-PROCEDURE,
                        hDataSource, 
                        cMode).

    END. /* MapType = 'Object'  */
  END. /* if not off-end */

  hSchemaBuffer = hSchemaQuery:GET-BUFFER-HANDLE(1).
  DELETE OBJECT hSchemaQuery.
  DELETE OBJECT hSchemaBuffer.  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-targetProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE targetProcedure Procedure 
PROCEDURE targetProcedure :
/*------------------------------------------------------------------------------
  Purpose: The router subscribes this to an event of the schema name
           in order to find it if it's already started.      
Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER phHandle AS HANDLE.
  phHandle = TARGET-PROCEDURE.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-callOutParams) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION callOutParams Procedure 
FUNCTION callOutParams RETURNS LOGICAL
  (pdNode AS DEC) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE cValue    AS CHAR NO-UNDO EXTENT 8. 
  
  DEFINE VARIABLE iNumParam AS INT  NO-UNDO.
  
  FOR EACH tMethodNode WHERE tMethodNode.TargetProc = TARGET-PROCEDURE
                       AND   tMethodNode.MethodNode = pdNode.

    CASE tMethodNode.NumParam:
      WHEN 1 THEN
        RUN VALUE(tMethodNode.Method) IN tMethodNode.DataSource 
            (OUTPUT cValue[1]).
      WHEN 2 THEN
        RUN VALUE(tMethodNode.Method) IN tMethodNode.DataSource 
            (OUTPUT cValue[1], 
             OUTPUT cValue[2]).
      WHEN 3 THEN
        RUN VALUE(tMethodNode.Method) IN tMethodNode.DataSource 
            (OUTPUT cValue[1], 
             OUTPUT cValue[2], 
             OUTPUT cValue[3]).
      WHEN 4 THEN
        RUN VALUE(tMethodNode.Method) IN tMethodNode.DataSource 
            (OUTPUT cValue[1], 
             OUTPUT cValue[2], 
             OUTPUT cValue[3],
             OUTPUT cValue[4]).   
      WHEN 5 THEN
        RUN VALUE(tMethodNode.Method) IN tMethodNode.DataSource 
           (OUTPUT cValue[1], 
            OUTPUT cValue[2], 
            OUTPUT cValue[3],
            OUTPUT cValue[4],
            OUTPUT cValue[5]).
      WHEN 6 THEN
        RUN VALUE(tMethodNode.Method) IN tMethodNode.DataSource 
           (OUTPUT cValue[1], 
            OUTPUT cValue[2], 
            OUTPUT cValue[3],
            OUTPUT cValue[4],
            OUTPUT cValue[5],
            OUTPUT cValue[6]).
      WHEN 7 THEN
        RUN VALUE(tMethodNode.Method) IN tMethodNode.DataSource 
           (OUTPUT cValue[1], 
            OUTPUT cValue[2], 
            OUTPUT cValue[3],
            OUTPUT cValue[4],
            OUTPUT cValue[5],
            OUTPUT cValue[6],
            OUTPUT cValue[7]).
      WHEN 8 THEN
        RUN VALUE(tMethodNode.Method) IN tMethodNode.DataSource 
           (OUTPUT cValue[1], 
            OUTPUT cValue[2], 
            OUTPUT cValue[3],
            OUTPUT cValue[4],
            OUTPUT cValue[5],
            OUTPUT cValue[6],
            OUTPUT cValue[7],
            OUTPUT cValue[8]).
    END CASE.

    FOR EACH tParamNode OF tMethodNode:
      DYNAMIC-FUNCTION('assignNodeValue':U IN TARGET-PROCEDURE,
                        tParamNode.Node,
                        cValue[tParamNode.Num]).
       DELETE tParamNode.
    END.
    DELETE tMethodNode.
  END.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createSchemaAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createSchemaAttributes Procedure 
FUNCTION createSchemaAttributes RETURNS HANDLE
  (piParentNode AS INT) :
/*------------------------------------------------------------------------------
  Purpose: Return a new query handle for the schema temp-table to use for 
           navigation through a schema node's children.   
    Notes: Currently the caller is responsible of deleting the object.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSchema AS HANDLE NO-UNDO.
  DEFINE VARIABLE hQuery  AS HANDLE NO-UNDO.
  DEFINE VARIABLE hBuffer AS HANDLE NO-UNDO.
  DEFINE VARIABLE cWhere  AS CHAR   NO-UNDO.

  {get SchemaHandle hSchema}.
    
  CREATE QUERY hQuery. 

  CREATE BUFFER hBuffer FOR TABLE hSchema:DEFAULT-BUFFER-HANDLE.

  hQuery:SET-BUFFERS(hBuffer).
  
  hQuery:QUERY-PREPARE("For each tData where tData.ParentNode = ":U 
                        + STRING(piParentNode) +
                       " and tData.Element = 'attribute'":U
                       ).

  hQuery:QUERY-OPEN.
  
  RETURN hQuery. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createSchemaChildren) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createSchemaChildren Procedure 
FUNCTION createSchemaChildren RETURNS HANDLE
  (piParentNode AS INT) :
/*------------------------------------------------------------------------------
  Purpose: Return a new query handle for the schema temp-table to use for 
           navigation through a schema node's children.   
    Notes: Currently the caller is responsible of deleting the object.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSchema AS HANDLE NO-UNDO.
  DEFINE VARIABLE hQuery  AS HANDLE NO-UNDO.
  DEFINE VARIABLE hBuffer AS HANDLE NO-UNDO.
  DEFINE VARIABLE cWhere  AS CHAR   NO-UNDO.

  {get SchemaHandle hSchema}.
    
  CREATE QUERY hQuery. 

  CREATE BUFFER hBuffer FOR TABLE hSchema:DEFAULT-BUFFER-HANDLE.

  hQuery:SET-BUFFERS(hBuffer).
  
  hQuery:QUERY-PREPARE("For each tData where tData.ParentNode = ":U 
                        + STRING(piParentNode) +
                       " and tData.element = 'element'":U
                       ).

  hQuery:QUERY-OPEN.
  
  RETURN hQuery. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createSchemaPath) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createSchemaPath Procedure 
FUNCTION createSchemaPath RETURNS HANDLE
  (pcPath AS CHAR)  :
/*------------------------------------------------------------------------------
  Purpose: Return a new query handle for the schema temp-table to use for 
           navigation through a schema node's children.   
    Notes: Currently the caller is responsible of deleting the object.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSchema AS HANDLE NO-UNDO.
  DEFINE VARIABLE hQuery  AS HANDLE NO-UNDO.
  DEFINE VARIABLE hBuffer AS HANDLE NO-UNDO.
  DEFINE VARIABLE cWhere  AS CHAR   NO-UNDO.

  {get SchemaHandle hSchema}.
    
  CREATE QUERY hQuery. 

  CREATE BUFFER hBuffer FOR TABLE hSchema:DEFAULT-BUFFER-HANDLE.

  hQuery:SET-BUFFERS(hBuffer).
  
  hQuery:QUERY-PREPARE("For each tData where tData.DocumentPath = ":U 
                        + "'" 
                        + pcPath 
                        + "'").

  hQuery:QUERY-OPEN.
  
  RETURN hQuery. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION dataSource Procedure 
FUNCTION dataSource RETURNS HANDLE
  (pcName AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSource    AS CHAR   NO-UNDO.
  DEFINE VARIABLE hContainer AS HANDLE NO-UNDO.
  DEFINE VARIABLE hSource    AS HANDLE NO-UNDO.
  DEFINE VARIABLE hSBO       AS HANDLE NO-UNDO.
  DEFINE VARIABLE i          AS INT    NO-UNDO.
  

  FIND tDataSource WHERE tDataSource.ObjectName = pcName
                   AND   tDataSource.TargetProc = TARGET-PROCEDURE NO-ERROR.   
  
  IF AVAIL tDataSource THEN
    RETURN tDataSource.DataSource.

  {get ContainerSource hContainer}.
  {get ContainerTarget cSource hContainer}.
  
  DO i = 1 TO NUM-ENTRIES(cSource):
    hSource = WIDGET-HANDLE(ENTRY(i,cSource)).
    
    IF ENTRY(1,pcName,".":U) = {fn getObjectName hSource} THEN
    DO:
      IF NUM-ENTRIES(pcName,".") > 1 THEN
      DO:
        ASSIGN
         hSBO    = hSource
         hSource = {fnarg dataObjectHandle ENTRY(2,pcName,'.':U) hSource}.
      END.

      LEAVE. /* The current iterating block of code.....*/
    END.
    hSource = ?.
  END. /* do i = 1 to num-entries */
  
  IF hSource <> ? THEN
  DO:
    CREATE tDataSource.
   
    ASSIGN 
      tDataSource.DataSource = hSource 
      tDataSource.TargetProc = TARGET-PROCEDURE
      tDataSource.ObjectName = pcName.

    /* Event procedure that enables the developer to set properties like
       Keyfields etc.the first time the object is connected. */
    RUN mapDataSource IN TARGET-PROCEDURE(hSource) NO-ERROR. 
  END.

  /* if the object was inside an SBO create the SBO reference */ 
  IF hSBO <> ? THEN
  DO:
    FIND tDataSource WHERE tDataSource.ObjectName = ENTRY(1,pcName,".":U)
                     AND   tDataSource.TargetProc = TARGET-PROCEDURE NO-ERROR.   
    
    IF NOT AVAIL tDataSource THEN
    DO:
      CREATE tdataSource.
      ASSIGN 
       tDataSource.DataSource = hSBO 
       tDataSource.TargetProc = TARGET-PROCEDURE
       tDataSource.ObjectName = ENTRY(1,pcName,".":U)
       tDataSource.Commit     = TRUE.

     /* Register the SBO Row (We only need one per SBO per DOC, because 
                             it's only required for proc there's no concept
                             of rows) */
      DYNAMIC-FUNCTION('startDataRow':U IN TARGET-PROCEDURE,
                        hSBO, 
                        '':U). 

     /* Event procedure that enables the developer to set properties like
        Keyfields etc.the first time the object is connected. */
     RUN mapDataSource IN TARGET-PROCEDURE(hSBO) NO-ERROR. 
    END.
  END. /* hsbo <> ? */

  RETURN hSource.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-defineMapping) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION defineMapping Procedure 
FUNCTION defineMapping RETURNS LOGICAL
  ( pcName    AS CHARACTER,
    pcColumns AS CHARACTER,
    pcValues  AS CHARACTER  ) :
/*------------------------------------------------------------------------------
  Purpose:  This function creates a tMapping temp-table record 
    Notes:  This can be called from an override of processMappings to 
            explicitly create tMapping temp-table records rather than
            using instance properties.
------------------------------------------------------------------------------*/
DEFINE VARIABLE cColumn  AS CHARACTER NO-UNDO.
DEFINE VARIABLE hBuffer  AS HANDLE    NO-UNDO.
DEFINE VARIABLE hColumn  AS HANDLE    NO-UNDO.
DEFINE VARIABLE iNumCols AS INTEGER   NO-UNDO.

  ASSIGN hBuffer = BUFFER tMapping:HANDLE.
  
  hBuffer:BUFFER-CREATE().
  ASSIGN 
    hColumn = hBuffer:BUFFER-FIELD('Name':U)
    hColumn:BUFFER-VALUE = pcName
    hColumn = hBuffer:BUFFER-FIELD('TargetProc':U)
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

&IF DEFINED(EXCLUDE-findDataRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findDataRow Procedure 
FUNCTION findDataRow RETURNS LOGICAL
  (phObject     AS HANDLE,
   pcKeyValues  AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Find a row of a mapped DataObject.
           If any of the keyfields are blank try to use ForeignFields 
           from the object's DataSource
Parameters: phObject    - DataObject that we want to find row in
            pcKeyValues - CHR(1) separated list with the exact same number 
                          of entries as the KeyFields property of the object               
    Notes: The findRow in the SDO should probably be improved to support 
           use of datasource when blank parameters instead of having the 
           logic here.. 
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE iBlankKey      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iKeyLookup     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLoop          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hDataSource    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cForeignFields AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyFields     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyField      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyValue      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignField  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignValue  AS CHARACTER  NO-UNDO.

  /* If any of the entries in the keyFields are blank, we will try to 
     get the value from the DataSource.  */   
  iBlankKey = LOOKUP('':U,pcKeyValues,CHR(1)).
  
  IF iBlankKey > 0 THEN 
  DO: 
    {get DataSource hDataSource phObject}.
    IF VALID-HANDLE(hDataSource) THEN
    DO:
      {get ForeignFields cForeignFields phObject}.
      {get KeyFields cKeyFields phObject}.
      
      /* Loop through the foreignfields and check if they can be used as 
         values for missing KeyValues. (It's easier to loop through 
         foreignfields and lookup keyfields as foreignfields is a paired list)*/  
      DO iLoop = 1 TO NUM-ENTRIES(cForeignFields) BY 2: 
        ASSIGN         /* first of ForeignField pair is internal  */
          cKeyField  = ENTRY(iLoop,cForeignFields)  
          cKeyField  = {fnarg dbColumnDataName cKeyField phObject}  
          iKeyLookup = LOOKUP(cKeyField,cKeyFields).
        
        /* Don't bother if the lookup is < the first blank entry */ 
        IF iKeyLookup >= iBlankKey THEN
        DO:
          cKeyValue = ENTRY(iKeyLookup,pcKeyValues,CHR(1)).
          /* We check for length because StoreNodeValue adds (' ') 
             if this is an intended blank value. */
          IF LENGTH(cKeyValue) = 0 THEN
          DO:
            ASSIGN            /* 2 of ForeignField pair is foreign/external */
              cForeignField = ENTRY(iLoop + 1,cForeignFields)
              cForeignValue = {fnarg columnValue cForeignField hDataSource}.
            IF cForeignValue <> ? THEN
              ENTRY(iKeyLookup,pcKeyValues,CHR(1)) = cForeignValue. 
          END. /* if length(cKeyValue > 0)*/
        END. /* if iKeyLookup >= iBlankKey */
      END. /* DO iloop ... */ 
    END. /* valid-handle(hDataSource) -- Source of phObject */
  END. /* iBlankKey > 0 */

  RETURN DYNAMIC-FUNCTION('findRow':U IN phObject,pcKeyValues).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getConsumerSchema) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getConsumerSchema Procedure 
FUNCTION getConsumerSchema RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Return the XML Schema filename   
    Notes:  
------------------------------------------------------------------------------*/
  
  FIND FIRST tMapping WHERE tMapping.Direction = "consumer":U NO-ERROR.
  
  RETURN tMapping.XMLSchema. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDestinationList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDestinationList Procedure 
FUNCTION getDestinationList RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns DestinationList property value 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDestinationList AS CHARACTER NO-UNDO.
  {get DestinationList cDestinationList} NO-ERROR.
  RETURN cDestinationList.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDirectionList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDirectionList Procedure 
FUNCTION getDirectionList RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns DirectionList property value 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDirectionList AS CHARACTER NO-UNDO.
  {get DirectionList cDirectionList} NO-ERROR.
  RETURN cDirectionList.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDocTypeList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDocTypeList Procedure 
FUNCTION getDocTypeList RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns DocTypeList property value 
    Notes: NOT IN USE
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDocTypeList AS CHARACTER NO-UNDO.
  {get DocTypeList cDocTypeList} NO-ERROR.
  RETURN cDocTypeList.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDTDPublicIdList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDTDPublicIdList Procedure 
FUNCTION getDTDPublicIdList RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns DTDPublicIdList property value 
    Notes: Stores a chr(1) separated list of DTD Public Ids for producer
           If this or DTDSystemId is defined an DTD reference will
           be produced instead of an xml namespace     
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDTDPublicIDList AS CHARACTER NO-UNDO.
  
  {get DTDPublicIdList cDTDPublicIdList}.
  RETURN cDTDPublicIdList.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDTDSystemIdList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDTDSystemIdList Procedure 
FUNCTION getDTDSystemIdList RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns DTDSystemIdList property value 
    Notes: Stores a chr(1) separated list of DTD System Ids for producer
           If this or DTDPublicId list is defined an DTD reference will
           be produced instead of an xml namespace     
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDTDSystemIdList AS CHARACTER NO-UNDO.

  {get DTDSystemIdList cDTDSystemIdList}.
  RETURN cDTDSystemIdList.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLoadedByRouter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLoadedByRouter Procedure 
FUNCTION getLoadedByRouter RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns true if the XML and Schema already is loaded by the router
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lLoadedByRouter AS LOGICAL  NO-UNDO.
  {get LoadedByRouter lLoadedByRouter}.
  RETURN lLoadedByRouter.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMapNameProducer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMapNameProducer Procedure 
FUNCTION getMapNameProducer RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns DestinationList property value 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMapNameProducer AS CHARACTER NO-UNDO.
  {get MapNameProducer cMapNameProducer} NO-ERROR.
  RETURN cMapNameProducer.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMapObjectProducer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMapObjectProducer Procedure 
FUNCTION getMapObjectProducer RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns DestinationList property value 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMapObjectProducer AS CHARACTER NO-UNDO.
  {get MapObjectProducer cMapObjectProducer} NO-ERROR.
  RETURN cMapObjectProducer.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMapTypeProducer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMapTypeProducer Procedure 
FUNCTION getMapTypeProducer RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns DestinationList property value 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMapTypeProducer AS CHARACTER NO-UNDO.  
  {get MapTypeProducer cMapTypeProducer} NO-ERROR.
  RETURN cMapTypeProducer.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNameList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNameList Procedure 
FUNCTION getNameList RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns NameList property value 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cNameList AS CHARACTER NO-UNDO.
  {get NameList cNameList} NO-ERROR.
  RETURN cNameList.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNameSpaceHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNameSpaceHandle Procedure 
FUNCTION getNameSpaceHandle RETURNS HANDLE
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Return the handle of the loaded XML mapping schema namespaces   
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hNameSpace AS HANDLE NO-UNDO.  
  {get NameSpaceHandle hNameSpace}.
  RETURN hNameSpace.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getReplyReqList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getReplyReqList Procedure 
FUNCTION getReplyReqList RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns ReplyReqList property value 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cReplyReqList AS CHARACTER NO-UNDO.
  {get ReplyReqList cReplyReqList} NO-ERROR.
  RETURN cReplyReqList.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getReplySelectorList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getReplySelectorList Procedure 
FUNCTION getReplySelectorList RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns Reply Selector List property value 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cReplySelectorList AS CHARACTER NO-UNDO.
  {get ReplySelectorList cReplySelectorList} NO-ERROR.
  RETURN cReplySelectorList.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSchemaHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSchemaHandle Procedure 
FUNCTION getSchemaHandle RETURNS HANDLE
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Return the handle pof the loaded XML mapping schema  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSchema AS HANDLE NO-UNDO.
  {get SchemaHandle hSchema}.
  RETURN hSchema.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSchemaList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSchemaList Procedure 
FUNCTION getSchemaList RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns Schema List property value 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSchemaList AS CHARACTER NO-UNDO.
  {get SchemaList cSchemaList} NO-ERROR.
  RETURN cSchemaList.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSchemaManager) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSchemaManager Procedure 
FUNCTION getSchemaManager RETURNS HANDLE
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Return (and start if not started) the procedure handle of the 
           schema manager.
    Notes: This is a Class Property shared by all instances. 
           There's currently duplicate code in b2b.p   
------------------------------------------------------------------------------*/
 IF NOT VALID-HANDLE(ghSchemaManager) THEN
   RUN VALUE(xcSchemaManager) PERSISTENT SET ghSchemaManager.  
  
 RETURN ghSchemaManager. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTargetNameSpace) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTargetNameSpace Procedure 
FUNCTION getTargetNameSpace RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Return the XML Schema TargetNameSpace 
           This defines the xmlns attribute of the document instance.   
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hNameSpace AS HANDLE NO-UNDO. 
  DEFINE VARIABLE hQuery     AS HANDLE NO-UNDO.
  DEFINE VARIABLE hBuffer    AS HANDLE NO-UNDO.
  DEFINE VARIABLE hAttrValue AS HANDLE NO-UNDO.
  DEFINE VARIABLE cReturn    AS CHAR   NO-UNDO.
  DEFINE VARIABLE cWhere     AS CHAR   NO-UNDO.

  {get NameSpaceHandle hNameSpace}.

  CREATE QUERY hQuery. 

  CREATE BUFFER hBuffer FOR TABLE hNameSpace:DEFAULT-BUFFER-HANDLE.

  hQuery:SET-BUFFERS(hBuffer).
  
  hQuery:QUERY-PREPARE("For each tSchema where tSchema.attrname = ":U 
                        + "'TargetNameSpace'":U).

  hQuery:QUERY-OPEN.
  hQuery:GET-FIRST.
  IF hBuffer:AVAILABLE THEN
  DO:
    hAttrValue = hBuffer:BUFFER-FIELD('attrvalue':U).
    ASSIGN cReturn = hAttrValue:BUFFER-VALUE.
  END.

  DELETE OBJECT hQuery.
  DELETE OBJECT hBuffer.  
  
  RETURN cReturn. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTypeName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTypeName Procedure 
FUNCTION getTypeName RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
   DEFINE VARIABLE cName AS CHARACTER  NO-UNDO.
    {get TypeName cName}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadProducerSchema) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION loadProducerSchema Procedure 
FUNCTION loadProducerSchema RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Find the schema to use in the next send, Load it and set mapping
           properties.
    Notes: The producer may define several mappings for one instance so this
           also includes the logic to find the correct mapping properties.  
         - The properties are stored in a set of *List Instance Properties.
         - We parse these lists at start up in processMappings and store them 
           in the tMapping temp-table. 
         - The key to the Mapping is the name, which is resolved   
           1. From a Mapped objecxt.
              - MapObjectProducer is the InstanceName of a mapped object. 
              - MapNameProducer is the method in the object that returns the 
                name,
              - MapTypeProducer is 'function' or 'column'.
           2. TypeName property (no default, for user manipulation)
           3. Find first mapping where Direction = producer. (Assumes only one)      
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMapObjectProducer  AS CHAR   NO-UNDO.
  DEFINE VARIABLE cMapNameProducer    AS CHAR   NO-UNDO.
  DEFINE VARIABLE cMapTypeProducer    AS CHAR   NO-UNDO.
  DEFINE VARIABLE hDataSOurce         AS HANDLE NO-UNDO.
  DEFINE VARIABLE cName               AS CHAR   NO-UNDO.

  {get MapObjectProducer cMapObjectProducer}.
  
  IF cMapObjectProducer <> '':U AND cMapObjectProducer <> ? THEN
  DO:
    hDataSource = {fnarg dataSource cMapObjectProducer}.
    IF VALID-HANDLE(hDataSource) THEN
    DO:
      {get MapNameProducer cMapNameProducer}.
      {get MapTypeProducer cMapTypeProducer}.
      
      IF cMapTypeProducer = 'Function':U THEN
        cName = DYNAMIC-FUNCTION(cMapNameProducer IN hDataSource).
      ELSE IF cMapTypeProducer = 'Column':U THEN
        cName = DYNAMIC-FUNCTION('columnValue':U IN hDataSource,cMapNameProducer).
    END.
    ELSE RETURN FALSE.
  END.
  ELSE DO:
     /* has this been set from the caller? */
     {get TypeName cName}.
     IF cName = ? THEN cName = '':U.
  END.

  IF cName <> '':U THEN
    FIND FIRST tMapping WHERE tMapping.Direction  = 'Producer':U
                        AND   tMapping.TargetProc = TARGET-PROCEDURE
                        AND   tMapping.NAME       = cName NO-ERROR.
  ELSE
    FIND FIRST tMapping WHERE tMapping.Direction  = 'Producer':U
                        AND   tMapping.TargetProc = TARGET-PROCEDURE NO-ERROR.
    
  IF AVAIL tMapping THEN
  DO:
    {set Destination   tMapping.Destination}.  
    {set ReplyRequired tMapping.ReplyReq}.  
    {set ReplySelector tMapping.ReplySelector}. 
    {set DTDSystemId   tMapping.DTDSystemId}.
    {set DTDPublicId   tMapping.DTDPublicId}.
    RETURN {fnarg loadSchema tMapping.xmlSchema}.
  END.

  RETURN FALSE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadSchema) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION loadSchema Procedure 
FUNCTION loadSchema RETURNS LOGICAL
  (pcSchema AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Load the schema temp-table
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSchemaMngr AS HANDLE NO-UNDO.
  DEFINE VARIABLE hSchema     AS HANDLE NO-UNDO.
  DEFINE VARIABLE hNode       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hNameSpace  AS HANDLE NO-UNDO.
  DEFINE VARIABLE cSchema     AS CHAR   NO-UNDO.
  DEFINE VARIABLE cType       AS CHAR   NO-UNDO.

  {get SchemaManager hSchemaMngr}.
  {get SchemaHandle hSchema}.    
  {get NameSpaceHandle hNameSpace}.    
  
  DELETE OBJECT hSchema NO-ERROR.
  DELETE OBJECT hNameSpace NO-ERROR.

  RUN loadSchema IN hSchemaMngr (pcSchema,
                                 YES, /* delete after load */
                                 OUTPUT TABLE-HANDLE hNode,
                                 OUTPUT TABLE-HANDLE hSchema,
                                 OUTPUT TABLE-HANDLE hNameSpace).

  RUN reset IN hSchemaMngr.
  {set SchemaHandle hSchema}.    
  {set NameSpaceHandle hNameSpace}.    
  DELETE OBJECT hNode NO-ERROR.
  
  RETURN VALID-HANDLE(hSchema). 
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mapNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION mapNode Procedure 
FUNCTION mapNode RETURNS DECIMAL
  (pdNode         AS DEC,
   phDataSource   AS HANDLE,
   pcMapType      AS CHAR,
   pcMapName      AS CHAR,
   pcConversion   AS CHAR,
   pcMapParameter AS CHAR,
   pcNodeType     AS CHAR,
   pcNodeName     AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Create a none and map it to the data source 'node' 
           (proc, func. column ).    
    Notes: If the node is mapped to more than 1 parameter of the datasource
           method, the mapping is stored in storeParameters and the data 
           will be processed in callOutParams()    
------------------------------------------------------------------------------*/
   DEFINE VARIABLE dId         AS DEC    NO-UNDO.  /* Returns the new node */
   DEFINE VARIABLE iNumParams  AS INT    NO-UNDO.
   DEFINE VARIABLE lParam      AS LOG    NO-UNDO.
   DEFINE VARIABLE cValue      AS CHAR   NO-UNDO.
   
   ASSIGN
     lParam      = FALSE
     iNumParams  = 0
     cValue      = ?.
    /*   
       cMapType    = schemaField(hSchemaQuery,'MapType':U)
       cMapName    = schemaField(hSchemaQuery,'MapName':U).
      */
   IF CAN-DO('Procedure,Function':U,pcMapType) THEN
   DO:
     iNumParams = DYNAMIC-FUNCTION('numParameters' IN TARGET-PROCEDURE,
                                    phDataSource,
                                    pcMapName).

     IF pcMapType = "Function":U AND iNumParams = 0 THEN
       cValue = DYNAMIC-FUNCTION(pcMapName IN phDataSource).
       
     ELSE IF pcMapType = "Procedure":U AND iNumParams = 1 THEN
       RUN VALUE(pcMapName) IN phDataSource (OUTPUT cValue).
       
     ELSE IF iNumParams > 0 THEN
       lParam = TRUE.
  END.
  ELSE IF pcMapType = "Column" THEN
  DO:
    /* Currently we read data directly from the SDO also in SBOs */
    pcMapName = ENTRY(NUM-ENTRIES(pcMapName,".":U),pcMapName,".":U).
    cValue = DYNAMIC-FUNCTION('columnValue' IN phDataSource,pcMapName).
    IF pcConversion <> "":U THEN
      cValue = DYNAMIC-FUNCTION(pcConversion IN TARGET-PROCEDURE, cValue).
  END. /* maptype = 'column' */

  dId = DYNAMIC-FUNCTION('create':U + pcNodeType IN TARGET-PROCEDURE,
                          pdNode,
                          pcNodeName,
                          cValue).
  
  IF lParam AND dId <> ? THEN
  DO:
    DYNAMIC-FUNCTION("storeParameterNode":U IN TARGET-PROCEDURE,
                      phDataSource,
                      pcMapName,
                      dId, 
                      pcMapParameter,
                      iNumParams).
  END.

  RETURN dId.   /* The new node */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-NotFoundError) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION NotFoundError Procedure 
FUNCTION NotFoundError RETURNS CHARACTER
  (phDataSource AS HANDLE,
   pcKeyValues  AS CHAR) :
/*------------------------------------------------------------------------------
   Purpose: Return a decent 'Record not found' error message with keyfields
Parameters: phDataSource - DataSource 
            pcKeyValues  - CHR(1) list with keyvalues corresponding to KeyFields   
     Notes:  
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE cKeyError  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyFields AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop      AS INTEGER    NO-UNDO.

  {get KeyFields cKeyFields phDataSource}.  
        
  /* Add label and value to the error message */
  DO iLoop = 1 TO NUM-ENTRIES(cKeyFields):
    cKeyError = cKeyError + ' ':U +  
                {fnarg columnLabel ENTRY(iLoop,cKeyFields) phDataSource}
                + ' ':U
                + IF NUM-ENTRIES(pcKeyValues,CHR(1)) >= iLoop
                  THEN ENTRY(iLoop,pcKeyValues,CHR(1))
                  ELSE ' ':U  .

  END. /* do iloop = 1 to num-entries(cKeyFields) */ 
   
  /* The error message has substitutable parameters for table and keys/values */ 
  RETURN SUBSTITUTE(DYNAMIC-FUNCTION('messageNumber':U IN TARGET-PROCEDURE,29),
                   {fn getTables tDataRow.DataSource},
                   TRIM(cKeyError)).
     
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-numParameters) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION numParameters Procedure 
FUNCTION numParameters RETURNS INTEGER
  ( phProc   AS HANDLE,
    pcMethod AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Return the number of parameters for a prochandle's method  
   Params: phProc    - Valid procedure handle.
           pcMethod  - Function or procedure name.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSignature AS CHAR NO-UNDO.
  
  cSignature = phProc:GET-SIGNATURE(pcMethod).
  
  IF cSignature = ? THEN
    RETURN ?.

  IF ENTRY(3,cSignature) = '':U THEN
    RETURN 0.    
   
  RETURN NUM-ENTRIES(cSignature) - 2.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rowNotFoundError) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION rowNotFoundError Procedure 
FUNCTION rowNotFoundError RETURNS CHARACTER
  (phDataSource AS HANDLE,
   pcKeyValues  AS CHAR) :
/*------------------------------------------------------------------------------
   Purpose: Return a decent 'Record not found' error message with keyfields
Parameters: phDataSource - DataSource 
            pcKeyValues  - CHR(1) list with keyvalues corresponding to KeyFields   
     Notes:  
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE cKeyError  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyFields AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop      AS INTEGER    NO-UNDO.

  {get KeyFields cKeyFields phDataSource}.  
        
  /* Add label and value to the error message */
  DO iLoop = 1 TO NUM-ENTRIES(cKeyFields):
    cKeyError = cKeyError + ' ':U +  
                {fnarg columnLabel ENTRY(iLoop,cKeyFields) phDataSource}
                + ' ':U
                + IF NUM-ENTRIES(pcKeyValues,CHR(1)) >= iLoop
                  THEN ENTRY(iLoop,pcKeyValues,CHR(1))
                  ELSE ' ':U  .

  END. /* do iloop = 1 to num-entries(cKeyFields) */ 
   
  /* The error message has substitutable parameters for table and keys/values */ 
  RETURN SUBSTITUTE(DYNAMIC-FUNCTION('messageNumber':U IN TARGET-PROCEDURE,29),
                   {fn getTables tDataRow.DataSource},
                   TRIM(cKeyError)).
     
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-schemaField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION schemaField Procedure 
FUNCTION schemaField RETURNS CHARACTER PRIVATE
  (phQuery AS HANDLE,
   pcName  AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  Return the buffer-value of a schema field.
Parameter:  phQuery - Handle of a query defined for the schema
            pcName  - buffer name. 
    Notes:  This is PRIVATE as it is expected to be replaced by a an open API 
            to the XML Mapping Schema.   
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hBuffer AS HANDLE NO-UNDO.
 DEFINE VARIABLE hField  AS HANDLE NO-UNDO.
    
 ASSIGN
   hBuffer = phQuery:GET-BUFFER-HANDLE(1)
   hField  = hBuffer:BUFFER-FIELD(pcName).

 RETURN IF VALID-HANDLE(hfield) 
        THEN hField:BUFFER-VALUE
        ELSE ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDestinationList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDestinationList Procedure 
FUNCTION setDestinationList RETURNS LOGICAL
  ( pcDestinationList AS CHARACTER ) :
/*------------------------------------------------------------------------------
     Purpose: Sets the list of Destinations this B2B uses as a producer
  Parameters: pcDestinationList AS CHARACTER
       Notes:  
------------------------------------------------------------------------------*/

  {set DestinationList pcDestinationList}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDirectionList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDirectionList Procedure 
FUNCTION setDirectionList RETURNS LOGICAL
  ( pcDirectionList AS CHARACTER ) :
/*------------------------------------------------------------------------------
     Purpose: Sets the list of Directions this B2B uses 
  Parameters: pcDirectionList AS CHARACTER
       Notes:  
------------------------------------------------------------------------------*/

  {set DirectionList pcDirectionList}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDocTypeList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDocTypeList Procedure 
FUNCTION setDocTypeList RETURNS LOGICAL
  ( pcDocTypeList AS CHARACTER ) :
/*------------------------------------------------------------------------------
     Purpose: Sets the list of Document Types this B2B uses 
  Parameters: pcDocTypeList AS CHARACTER
       Notes: NOT IN USE 
------------------------------------------------------------------------------*/
  {set DocTypeList pcDocTypeList}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDTDPublicIdList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDTDPublicIdList Procedure 
FUNCTION setDTDPublicIdList RETURNS LOGICAL
  ( pcDTDPublicIdList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Stores the DTDPublicIdList property value 
    Notes: Stores a chr(1) separated list of DTD PublicIds for producer. 
           If this or DTDSystemId is defined an DTD reference will
           be produced instead of an xml namespace     
------------------------------------------------------------------------------*/

   {set DTDPublicIdList pcDTDPublicIdList}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDTDSystemIdList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDTDSystemIdList Procedure 
FUNCTION setDTDSystemIdList RETURNS LOGICAL
  ( pcDTDSystemIdList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Stores the DTDSystemIdList property value 
    Notes: Stores a chr(1) separated list of DTD SystemIds for producer. 
           If this or DTDPublicId is defined an DTD reference will
           be produced instead of an xml namespace     
------------------------------------------------------------------------------*/

  {set DTDSystemIdList pcDTDSystemIdList}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLoadedByRouter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLoadedByRouter Procedure 
FUNCTION setLoadedByRouter RETURNS LOGICAL
  (plLoadedByRouter AS LOG ) :
/*------------------------------------------------------------------------------
  Purpose: Set to true from the router to indicate that XML and Schema already 
           is loaded by the router
    Notes:  
------------------------------------------------------------------------------*/
  {set LoadedByRouter plLoadedByRouter}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMapNameProducer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setMapNameProducer Procedure 
FUNCTION setMapNameProducer RETURNS LOGICAL
  (pcMapNameProducer AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {set MapNameProducer pcMapNameProducer} NO-ERROR.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMapObjectProducer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setMapObjectProducer Procedure 
FUNCTION setMapObjectProducer RETURNS LOGICAL
  (pcMapObjectProducer AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {set MapObjectProducer pcMapObjectProducer} NO-ERROR.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMapTypeProducer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setMapTypeProducer Procedure 
FUNCTION setMapTypeProducer RETURNS LOGICAL
  (pcMapTypeProducer AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {set MapTypeProducer pcMapTypeProducer} NO-ERROR.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNameList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setNameList Procedure 
FUNCTION setNameList RETURNS LOGICAL
  ( pcNameList AS CHARACTER ) :
/*------------------------------------------------------------------------------
     Purpose: Sets the list of logical schema Names this B2B uses 
  Parameters: pcNameList AS CHARACTER
       Notes:  
------------------------------------------------------------------------------*/

  {set NameList pcNameList}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setReplyReqList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setReplyReqList Procedure 
FUNCTION setReplyReqList RETURNS LOGICAL
  ( pcReplyReqList AS CHARACTER ) :
/*------------------------------------------------------------------------------
     Purpose: Sets the list of Reply Required flags this B2B uses as a producer 
              to determine if a reply is required for an outgoing message
  Parameters: pcReplyReqList AS CHARACTER
       Notes:  
------------------------------------------------------------------------------*/

  {set ReplyReqList pcReplyReqList}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setReplySelectorList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setReplySelectorList Procedure 
FUNCTION setReplySelectorList RETURNS LOGICAL
  ( pcReplySelectorList AS CHARACTER ) :
/*------------------------------------------------------------------------------
     Purpose: Sets the list of Reply Selectors this B2B uses as a producer
  Parameters: pcReplySelectorList AS CHARACTER
       Notes:  
------------------------------------------------------------------------------*/

  {set ReplySelectorList pcReplySelectorList}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSchemaHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSchemaHandle Procedure 
FUNCTION setSchemaHandle RETURNS LOGICAL
  (phSchema AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose: Set the handle of the loaded XML mapping schema  
    Notes:  
------------------------------------------------------------------------------*/
  {set SchemaHandle phSchema}.
  RETURN TRUE.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSchemaList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSchemaList Procedure 
FUNCTION setSchemaList RETURNS LOGICAL
  ( pcSchemaList AS CHARACTER ) :
/*------------------------------------------------------------------------------
     Purpose: Sets the list of Schemas this B2B uses 
  Parameters: pcSchemaList AS CHARACTER
       Notes:  
------------------------------------------------------------------------------*/

  {set SchemaList pcSchemaList}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTypeName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTypeName Procedure 
FUNCTION setTypeName RETURNS LOGICAL
  ( pcName AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Set the name that identifes the document/destination for multi 
           document producers  
    Notes:  
------------------------------------------------------------------------------*/
  {set TypeName pcName}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-startDataRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION startDataRow Procedure 
FUNCTION startDataRow RETURNS LOGICAL
  (phDataSource AS HANDLE,
   pcAction     AS CHAR):
/*------------------------------------------------------------------------------
   Purpose: Register the dataRow record used to find,create or update the data.
Parameters: phdataSource - DataSource handle 
            pcMode       - 'FIND' 'CREATE' 'UPDATE' 'CREATE,UPDATE' or 'DELETE'
     Notes: This record is used to 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iSeq AS INT  NO-UNDO.
  DEFINE BUFFER bDataRow FOR tDataRow.
  
  FIND LAST bDataRow WHERE bDataRow.TargetProc = TARGET-PROCEDURE 
                                                 USE-INDEX Seq NO-ERROR.
  
  iSeq = IF AVAIL bDataRow THEN bDataRow.Seq + 1 ELSE 1.

  CREATE tDataRow.
  ASSIGN 
    tDataRow.TargetProc = TARGET-PROCEDURE
    tDataRow.DataSource = phDataSource    
    tDataRow.Seq        = iSeq
    tDataRow.Action     = pcAction.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-storeNodeValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION storeNodeValue Procedure 
FUNCTION storeNodeValue RETURNS LOGICAL
  (phDataSource AS HANDLE,
   pcColumnName AS CHAR,
   pcNodeValue  AS CHAR) :
/*------------------------------------------------------------------------------
   Purpose: Store nodevalues for a datasource. (Consume XML)
     
Parameters:   
   phDataSource - DataSource 
   pdColumnName - The ColumnName
   pcNodeValue  - The data value 
     
     Notes:  This information is stored until the endDocument event  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cKeyFields   AS CHAR   NO-UNDO.
  DEFINE VARIABLE iKeyNum      AS INT    NO-UNDO.
  DEFINE VARIABLE cObjectName  AS CHAR   NO-UNDO.

  FIND LAST tDataRow WHERE tDataRow.TargetProc = TARGET-PROCEDURE
                     AND   tDataRow.DataSource = phDataSource NO-ERROR.
  
  
  {get ObjectName cObjectName phDataSource}.
  IF NOT AVAIL tDataRow THEN
  DO:
    /* Developer error */
    MESSAGE SUBSTITUTE({fnarg messageNumber 44}, cObjectName, pcColumnName)
      VIEW-AS ALERT-BOX.
    RETURN FALSE. 
  END.

  /* We probably need key values unless the action is 'Create'. 
     NOTE: This also includes ? to support cases where the action is 
           defined by a node later */ 
  
  IF tDataRow.Action <> 'Create':U THEN
  DO:
    {get KeyFields cKeyFields phDataSource}.
  
    /*  remove a potential qualifier  */
    iKeyNum = LOOKUP(ENTRY(NUM-ENTRIES(pcColumnName,".":U),pcColumnName,".":U),
                     cKeyFields).
  
    IF iKeyNum > 0 THEN
    DO:
      FIND tKeyData OF tDataRow NO-ERROR.
      IF NOT AVAIL tKeyData THEN
      DO:
        CREATE tKeyData.
        ASSIGN
          tKeyData.TargetProc = TARGET-PROCEDURE 
          tKeyData.DataSource = phDataSource
          tKeyData.Seq        = tDataRow.Seq
          tKeyData.ValueList  = FILL(CHR(1),NUM-ENTRIES(cKeyFields) - 1).
      END.
      /* Insert the value at the corresponding entry. 
         If this is a blank value we ensure that the length is 1, 
         so we can check this before we add a foreignfield from a datasource */

      ENTRY(iKeyNum,tKeyData.ValueList,CHR(1)) = IF pcNodeValue <> '':U 
                                                 THEN pcNodeValue 
                                                 ELSE ' ':U. 
      RELEASE tKeyData.

    END. /* iKeyNum > 0 */
  END. /* Action <> create */

  /* We don't need the values if 'Find' or when 'update' and this 
     is a keyfield. 
     NOTE: This also includes ? to support cases where the action is 
           defined by a node later */

  IF tDataRow.Action <> 'Find':U 
  AND (iKeyNum = 0 OR tDataRow.Action <> 'Update':U) THEN
  DO:

    FIND tUpdateData OF tDataRow NO-ERROR.
    IF NOT AVAIL tUpdateData THEN
    DO:
      CREATE tUpdateData.
      ASSIGN
        tUpdateData.TargetProc = TARGET-PROCEDURE
        tUpdateData.DataSource = phDataSource
        tUpdateData.Seq        = tDataRow.Seq.
    END.
    /* Build the chr(1) list */
    tUpdateData.ColValues  = tUpdateData.ColValues
                             + (IF tUpdateData.ColValues <> "":U 
                                THEN CHR(1) 
                                ELSE "":U)
                             /* Currently we call the SDOs in the SBO directly 
                                so we remove the qualifier  */
                             + ENTRY(NUM-ENTRIES(pcColumnName,".":U),
                                     pcColumnName,".":U)
                             + CHR(1)
                             + pcNodeValue.
  
  END. /* Action <> find and (no key or Action <> update)*/
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-storeParameterNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION storeParameterNode Procedure 
FUNCTION storeParameterNode RETURNS LOGICAL
  (phDataSource AS HANDLE,
   pcMethod     AS CHAR,
   pdNode       AS DEC,
   piNum        AS INT,
   piNumParam   AS INT) :
/*------------------------------------------------------------------------------
   Purpose: Store mapping information for Output parameters (Produce XML )
Parameters:   
   phDataSource - DataSource 
   pcMethod     - Procedure or function
   pdNode       - The Node that has the value
   piNum        - Parameter number
   piNumParam   - Number of parameters in the method
     
     Notes:  This information is stored until the parent node of the first
             parameter is processed, callOutParams() will then call the pcmethod
             in phDataSource and use the piNum parameter values to populate 
             the node or attribute.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dFirstNode  AS DEC  NO-UNDO.
  DEFINE VARIABLE cNodeType   AS CHAR NO-UNDO.
  DEFINE VARIABLE dMethodNode AS DEC    NO-UNDO.

  /* Is this dataSource method registered */ 
  FIND tMethodNode WHERE tMethodNode.TargetProc = TARGET-PROCEDURE
                   AND   tMethodNode.DataSource = phDataSource
                   AND   tMethodNode.Method     = pcMethod      NO-ERROR.
  
  IF NOT AVAIL tMethodNode THEN
  DO:
    /* Consumer currently doesn't use nodes to track this */
    IF pdNode <> ? THEN
      ASSIGN
        cNodeType   = {fnarg NodeType pdNode}
        
      /* The Methodnode decides when the method is called. We set it to the 
         parent/owner of the first parameter we found to ensure that this
         happens when all parameters has been found. 
         (DOM: Attributes has no ParentNode only OwnerElement!)  */
        dMethodNode = IF cNodeType = 'Attribute':U 
                      THEN {fnarg OwnerElement pdNode}
                      ELSE {fnarg ParentNode pdNode}.

    CREATE tMethodNode.
    ASSIGN
      tMethodNode.TargetProc = TARGET-PROCEDURE
      tMethodNode.DataSource = phDataSource
      tMethodNode.Method     = pcMethod  
      tMethodNode.MethodNode = dMethodNode
      tMethodNode.NumParam   = piNumParam.
  END.

  CREATE tParamNode.
  
  ASSIGN
    tParamNode.TargetProc = tMethodNode.TargetProc
    tParamNode.DataSource = tMethodNode.DataSource
    tParamNode.Method     = tMethodNode.Method   
    tParamNode.Node       = pdNode
    tParamNode.Num        = piNum.
 
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-storeParameterValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION storeParameterValue Procedure 
FUNCTION storeParameterValue RETURNS LOGICAL
  (phDataSource AS HANDLE,
   pcMethod     AS CHAR,
   piNum        AS INT,
   piNumParam   AS INT,
   pcValue      AS CHAR) :
/*------------------------------------------------------------------------------
   Purpose: Store values for input parameters (Consume XML)
Parameters:   
   phDataSource - DataSource 
   pcMethod     - Procedure or function
   piNum        - Parameter number
   piNumParam   - Number of parameters in the method
   pcValue      - the value to pass as input.
      
     Notes:  This information is stored until the endDocument 
             callInParams will call the pcmethod in phDataSource and pass
             the PcValue as the piNum parameter.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dFirstNode  AS DEC  NO-UNDO.
  DEFINE VARIABLE cNodeType   AS CHAR NO-UNDO.
  DEFINE VARIABLE dMethodNode AS DEC    NO-UNDO.

  FIND LAST tDataRow WHERE tDataRow.TargetProc = TARGET-PROCEDURE
                     AND   tDataRow.DataSource = phDataSource NO-ERROR.
  
  /* Is this dataSource method seq registered?  */ 
  FIND tMethod OF tDataRow 
               WHERE tMethod.Method = pcMethod  NO-ERROR.
  
  IF NOT AVAIL tMethod THEN
  DO:
    CREATE tMethod.
    ASSIGN
      tMethod.TargetProc = TARGET-PROCEDURE
      tMethod.DataSource = phDataSource
      tMethod.Method     = pcMethod  
      tMethod.Seq        = tDataRow.Seq
      tMethod.NumParam   = piNumParam.
  END.

  CREATE tParamValue.
  
  ASSIGN
    tParamValue.TargetProc = tMethod.TargetProc
    tParamValue.DataSource = tMethod.DataSource
    tParamValue.Seq        = tMethod.Seq
    tParamValue.Method     = tMethod.Method   
    tParamValue.Num        = piNum
    tParamValue.Node       = pcValue.
 
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

