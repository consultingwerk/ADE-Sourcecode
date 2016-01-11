&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/**********************************************************************************/
/* Copyright (C) 2005,2006 by Progress Software Corporation. All rights reserved. */
/* Prior versions of this work may contain portions contributed by participants   */      
/* of Possenet.                                                                   */               
/**********************************************************************************/
/*--------------------------------------------------------------------------
    File        : dataset.p
    Purpose     : Super procedure for dataset class.

    Syntax      : RUN start-super-proc("adm2/dataset.p":U).

    Modified    : 08/01/2005
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

CREATE WIDGET-POOL.

&SCOP ADMSuper dataset.p

  /* Custom exclude file */

  {src/adm2/custom/datasetexclcustom.i}

DEFINE TEMP-TABLE ttBatch NO-UNDO
     FIELD TargetProcedure AS HANDLE  
     FIELD TableName AS CHAR
     FIELD TTHandle  AS HANDLE
     INDEX BatchTable AS UNIQUE TargetProcedure TableName.

/* DataTable props are currently stored in adm-data 
   Tests indicates that a temp-table is faster, this was not a 
   scalability test though and the temp-table access was not wrapped 
   in any function, which it would be to support multiple props . 
DEFINE TEMP-TABLE ttDataTable NO-UNDO
     FIELD TargetProcedure AS HANDLE  
     FIELD TableName       AS CHAR
     FIELD NumRecords      AS CHAR 
     FIELD NextContext     AS CHAR 
     INDEX DataTable AS UNIQUE TargetProcedure TableName.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-assignTableContext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignTableContext Procedure 
FUNCTION assignTableContext RETURNS LOGICAL
  ( pcTable AS CHAR,
    pcContext AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignTableInformation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignTableInformation Procedure 
FUNCTION assignTableInformation RETURNS LOGICAL
  ( pcTable         AS CHARACTER,
    pcContext       AS CHARACTER,
    plAppend        AS LOGICAL,
    plForward       AS LOGICAL,
    pcPrev          AS CHARACTER,
    pcNext          AS CHARACTER,
    piNumRecords    AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignTableNumRecords) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignTableNumRecords Procedure 
FUNCTION assignTableNumRecords RETURNS LOGICAL
  ( pcTable AS CHAR,
    piNumRecords AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-childTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD childTables Procedure 
FUNCTION childTables RETURNS CHARACTER
  ( pcTable AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnName Procedure 
FUNCTION columnName RETURNS CHARACTER
  ( phField AS HANDLE  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createBuffer Procedure 
FUNCTION createBuffer RETURNS HANDLE
  ( pcTable AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createRow Procedure 
FUNCTION createRow RETURNS ROWID
  ( pcTable     AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD dataColumns Procedure 
FUNCTION dataColumns RETURNS CHARACTER
  ( pcTable AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD dataQueryString Procedure 
FUNCTION dataQueryString RETURNS CHARACTER
  ( pcTableList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataTableHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD dataTableHandle Procedure 
FUNCTION dataTableHandle RETURNS HANDLE
  ( pcTable AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD deleteRow Procedure 
FUNCTION deleteRow RETURNS LOGICAL
  ( pcTable    AS CHAR,
    pcKeyWhere AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD destroyBuffer Procedure 
FUNCTION destroyBuffer RETURNS LOGICAL
  ( phBuffer AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-emptyBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD emptyBatch Procedure 
FUNCTION emptyBatch RETURNS LOGICAL
  ( pcTable AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-foreignFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD foreignFields Procedure 
FUNCTION foreignFields RETURNS CHARACTER
  ( pcChild AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDatasetHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDatasetHandle Procedure 
FUNCTION getDatasetHandle RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataTables Procedure 
FUNCTION getDataTables RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTableProperty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTableProperty Procedure 
FUNCTION getTableProperty RETURNS CHAR PRIVATE
  ( phTarget AS HANDLE,
    pcTable AS CHAR,
    pcProperty AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hasChanges) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD hasChanges Procedure 
FUNCTION hasChanges RETURNS LOGICAL
  ( pcTable AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isReposition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isReposition Procedure 
FUNCTION isReposition RETURNS LOGICAL
  ( pcTable AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isScrollable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isScrollable Procedure 
FUNCTION isScrollable RETURNS LOGICAL
  ( pcTable AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isUniqueID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isUniqueID Procedure 
FUNCTION isUniqueID RETURNS LOGICAL
  (INPUT pcFields AS CHARACTER,
   INPUT pcTable  AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-lookupProperty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD lookupProperty Procedure 
FUNCTION lookupProperty RETURNS INTEGER PRIVATE
  ( pcProperty AS CHAR,
    pcList     AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mergeBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD mergeBatch Procedure 
FUNCTION mergeBatch RETURNS LOGICAL
  ( pcTable AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-relationFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD relationFields Procedure 
FUNCTION relationFields RETURNS CHARACTER
  ( pcParentTable AS CHAR,
    pcChildTable  AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-relationType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD relationType Procedure 
FUNCTION relationType RETURNS CHARACTER
   (phRelation AS HANDLE) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDatasetHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDatasetHandle Procedure 
FUNCTION setDatasetHandle RETURNS LOGICAL
  ( phDataset AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTableProperty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTableProperty Procedure 
FUNCTION setTableProperty RETURNS LOGICAL PRIVATE
 ( phTarget AS HANDLE,
   pcTable AS CHAR,
   pcProperty AS CHAR,
   pcValue AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sortTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD sortTables Procedure 
FUNCTION sortTables RETURNS CHARACTER
  ( pcTable AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-storeBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD storeBatch Procedure 
FUNCTION storeBatch RETURNS LOGICAL
  ( pcTable AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tableContext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD tableContext Procedure 
FUNCTION tableContext RETURNS CHARACTER
  ( pcTable AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tableIndexInformation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD tableIndexInformation Procedure 
FUNCTION tableIndexInformation RETURNS CHARACTER
  (INPUT pcTable AS CHARACTER,
   INPUT pcQuery AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tableNextContext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD tableNextContext Procedure 
FUNCTION tableNextContext RETURNS CHARACTER
  ( pcTable AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tableNumRecords) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD tableNumRecords Procedure 
FUNCTION tableNumRecords RETURNS INTEGER
  ( pcTable AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tablePrevContext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD tablePrevContext Procedure 
FUNCTION tablePrevContext RETURNS CHARACTER
  ( pcTable AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD updateRow Procedure 
FUNCTION updateRow RETURNS LOGICAL
  ( pcTable     AS CHAR,
    pcKeyWhere  AS CHAR,
    pcValueList AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-viewColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD viewColumns Procedure 
FUNCTION viewColumns RETURNS CHARACTER
  ( pcTable AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-viewHasLobs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD viewHasLobs Procedure 
FUNCTION viewHasLobs RETURNS LOGICAL
  ( pcTable AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-viewTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD viewTables Procedure 
FUNCTION viewTables RETURNS CHARACTER
  ( pcTable AS CHARACTER )  FORWARD.

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

{src/adm2/datasetprop.i}

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
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VARIABLE hDataset AS HANDLE     NO-UNDO.
   {get DatasetHandle hDataset}.
   DELETE OBJECT hDataset NO-ERROR. 
   RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-undoTransaction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE undoTransaction Procedure 
PROCEDURE undoTransaction :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcTable AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cTables  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iBuffer  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cBuffer  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hBuffer  AS HANDLE     NO-UNDO.

  cTables = RIGHT-TRIM(pcTable 
                     + ',':U
                     + {fnarg childTables pcTable},','). 
  
  DO iBuffer = 1 TO NUM-ENTRIES(cTables):
    ASSIGN
      cBuffer = ENTRY(iBuffer,cTables)
      hBuffer = {fnarg dataTableHandle cBuffer}.
    
    /* worksround core bug/problem that may cause row-updated to fire 
       later */  
    IF VALID-HANDLE(hBuffer) THEN
    DO TRANSACTION:
      hBuffer:REJECT-CHANGES.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-assignTableContext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignTableContext Procedure 
FUNCTION assignTableContext RETURNS LOGICAL
  ( pcTable AS CHAR,
    pcContext AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  /*  possible future store props per table and possibly remove successfully 
      applied entries so they don't get applied to dataview ??
  DEFINE VARIABLE iContext AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cProp    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue   AS CHARACTER  NO-UNDO.

  DO iContext = 1 TO NUM-ENTRIES(pcContext,CHR(4)):
    ASSIGN cProp  = ENTRY(1,pcContext,CHR(4))
           cValue = ENTRY(2,pcContext,CHR(4)).
    IF cValue = '?':U THEN
      cValue = ?.
    DYNAMIC-FUNCTION('assignTable':U + cProp IN TARGET-PROCEDURE,
                      cTable,cValue) NO-ERROR.

  END.
  */
  DYNAMIC-FUNCTION('setTableProperty':U IN TARGET-PROCEDURE,
                    TARGET-PROCEDURE, pcTable,'TableContext':U,pcContext).
  RETURN TRUE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignTableInformation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignTableInformation Procedure 
FUNCTION assignTableInformation RETURNS LOGICAL
  ( pcTable         AS CHARACTER,
    pcContext       AS CHARACTER,
    plAppend        AS LOGICAL,
    plForward       AS LOGICAL,
    pcPrev          AS CHARACTER,
    pcNext          AS CHARACTER,
    piNumRecords    AS INTEGER) :
 /*------------------------------------------------------------------------------
  Purpose: Receive table information from datacontainer/service after a 
           service request has been completed.        
  Parameters: pcTable      = table name
              pcContext    = optional context
              plAppend     = data was appended to exisitng data
              plForward    = Direction of the append 
              pcPrev       = Prev context returned from service  
              pcNext       = Next context returned from service 
              piNumRecords = Number of records 
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iNumRecords AS INTEGER NO-UNDO.

  IF pcContext > '' THEN
    DYNAMIC-FUNCTION('assignTableContext':U IN TARGET-PROCEDURE,
                     pcTable,pcContext).

  IF NOT plAppend OR plForward = FALSE THEN
  DO:
    IF pcPrev = 'FIRST':U THEN
      pcPrev = '':U.
    DYNAMIC-FUNCTION('setTableProperty':U IN TARGET-PROCEDURE,
                         TARGET-PROCEDURE, pcTable,'PrevContext':U,pcPrev).

  END.
  
  IF NOT plAppend OR plForward THEN
  DO:
    IF pcNext = 'LAST':U THEN
      pcNext = '':U.
    DYNAMIC-FUNCTION('setTableProperty':U IN TARGET-PROCEDURE,
                          TARGET-PROCEDURE, pcTable,'NextContext':U,pcNext).
  END.

  IF plAppend THEN
  DO:
    iNumRecords = {fnarg tableNumRecords pcTable}.
    IF iNumRecords > 0 THEN
      piNumRecords =  piNumRecords + iNumRecords.
  END.

  DYNAMIC-FUNCTION('assignTableNumRecords':U IN TARGET-PROCEDURE,
                    pcTable,piNumRecords).

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignTableNumRecords) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignTableNumRecords Procedure 
FUNCTION assignTableNumRecords RETURNS LOGICAL
  ( pcTable AS CHAR,
    piNumRecords AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DYNAMIC-FUNCTION('setTableProperty':U IN TARGET-PROCEDURE,
                    TARGET-PROCEDURE, pcTable,'NumRecords':U,STRING(piNumRecords)).
  RETURN TRUE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-childTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION childTables Procedure 
FUNCTION childTables RETURNS CHARACTER
  ( pcTable AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the list of children and their children and their children
           etc..    
    Notes: Goes deep before wide, all children are listed after their parent 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataset        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRelation       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iRel            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cChildren       AS CHARACTER  NO-UNDO.

  hBuffer = {fnarg dataTableHandle pcTable}.
  IF VALID-HANDLE(hbuffer) THEN
  DO:
    DO iRel = 1 TO hBuffer:NUM-CHILD-RELATIONS:
      hRelation = hBuffer:GET-CHILD-RELATION(iRel).
      IF {fnarg relationType hRelation} MATCHES '*-many':U THEN 
        cChildren = cChildren 
                  + (IF cChildren = '':U THEN '':U ELSE ',':U) 
                  + hRelation:CHILD-BUFFER:NAME
                  + ',':U 
                  + {fnarg childTables hRelation:CHILD-BUFFER:NAME}.
    END. /* Do iRel = 1 to hBuffer:NUM-CHILD-RELATIONS: */
  END.  /* valid hbuffer */

  RETURN cChildren. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnName Procedure 
FUNCTION columnName RETURNS CHARACTER
  ( phField AS HANDLE  ) :
/*------------------------------------------------------------------------------
  Purpose: Resolves the external unique name of the column from the passed 
           field handle.  
    Notes: This is the name a visual data-target would use as its identifier.
         - used by assignBufferValueFromReference 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataset      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFieldDataset AS HANDLE     NO-UNDO.

  IF VALID-HANDLE(phField) THEN
  DO:
    {get DatasetHandle hDataset}.

    hFieldDataset = phField:BUFFER-HANDLE:DATASET NO-ERROR.
    IF VALID-HANDLE(hFieldDataset) AND hFieldDataset = hDataset THEN
      RETURN phField:TABLE + '.' + phField:NAME. 

  END.

  RETURN ''.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createBuffer Procedure 
FUNCTION createBuffer RETURNS HANDLE
  ( pcTable AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDefaultBuffer AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iNum           AS INTEGER    NO-UNDO.

  hDefaultBuffer = {fnarg dataTableHandle pcTable}.
  
  IF VALID-HANDLE(hDefaultBuffer) THEN
  DO:
    CREATE BUFFER hBuffer FOR TABLE hDefaultbuffer.
    
    iNum = int(getTableProperty(target-procedure,pcTable,'NumBuffers':U)).
    
    IF iNum = ? THEN
      iNum = 0.
    iNum = iNum + 1.
    
    setTableProperty(target-procedure,pcTable,'NumBuffers':U,STRING(iNum)).
  END.

  RETURN hBuffer.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createRow Procedure 
FUNCTION createRow RETURNS ROWID
  ( pcTable     AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Create a new record for the specified table 
    Notes: Operates on default buffer in order to fire dataset row-created 
           event. 
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE hBuffer AS HANDLE     NO-UNDO.
  DEFINE VARIABLE rRowid  AS ROWID      NO-UNDO.

  hBuffer = {fnarg dataTableHandle pcTable}.
  IF VALID-HANDLE(hBuffer) THEN
  DO TRANSACTION ON ERROR UNDO,LEAVE:
    hBuffer:BUFFER-CREATE().
    rRowid = hBuffer:ROWID.  
  END.

  RETURN rRowid.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION dataColumns Procedure 
FUNCTION dataColumns RETURNS CHARACTER
  ( pcTable AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBuffer     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cColumn     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iColumn     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iNumCols    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cColumnList AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hField      AS HANDLE     NO-UNDO.

  hBuffer = {fnarg dataTableHandle pcTable}.
  IF VALID-HANDLE(hBuffer) THEN
  DO:
    iNumCols = hBuffer:NUM-FIELDS.
    DO iColumn = 1 TO iNumCols:
      hField = hBuffer:BUFFER-FIELD(iColumn).
      /* Ignore arrays */
      IF hField:EXTENT = 0 THEN
       cColumnList = cColumnList + ',' 
                   + hBuffer:NAME + '.' 
                   + hField:NAME.
    END.
    cColumnList = LEFT-TRIM(cColumnList,',').
  END.
  RETURN cColumnList.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION dataQueryString Procedure 
FUNCTION dataQueryString RETURNS CHARACTER
  ( pcTableList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Returns a query string joining the passed tables to the first table             
    Notes: One to many relations are not included. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBuffer         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRelation       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cQueries        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iRel            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cSortTables     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQuery          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iField          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cParentField    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cChildField     AS CHARACTER  NO-UNDO.

  hBuffer = {fnarg dataTableHandle "entry(1,pcTableList)"}.
  IF VALID-HANDLE(hBuffer) THEN
  DO:
    cQueries = 'FOR EACH ':U + hBuffer:NAME. 
    DO iRel = 1 TO hBuffer:NUM-CHILD-RELATIONS:
      hRelation = hBuffer:GET-CHILD-RELATION(iRel).
      IF  LOOKUP(hRelation:CHILD-BUFFER:NAME,pcTableList) > 0 
      AND {fnarg relationType hRelation} MATCHES '*-one':U THEN
      DO:
        ASSIGN
        cQuery   =  RIGHT-TRIM(SUBSTR(hRelation:QUERY:PREPARE-STRING,5),'.':U)
                 + (IF hRelation:REPOSITION 
                    THEN hRelation:WHERE-STRING
                    ELSE '':U)
/*                  + ' OUTER-JOIN ':U */
        cQueries = cQueries + ", ":U 
                  + cQuery.
      END.
    END. /* Do iRel = 1 to hBuffer:NUM-CHILD-RELATIONS: */
    hRelation = hBuffer:PARENT-RELATION.
    IF VALID-HANDLE(hRelation)
    AND LOOKUP(hRelation:PARENT-BUFFER:NAME,pcTableList) > 0 
    AND {fnarg relationType hRelation} MATCHES 'one-*':U THEN
    DO:
      cQuery = "EACH " + hRelation:PARENT-BUFFER:NAME 
             + " WHERE ".
      DO iField = 1 TO NUM-ENTRIES(hRelation:RELATION-FIELDS) BY 2:
        cQuery = cQuery  
               + (IF iField > 1 THEN ' AND ' ELSE '')   
               + hRelation:PARENT-BUFFER:NAME 
               + '.' 
               + ENTRY(iField,hRelation:RELATION-FIELDS)
               + ' = ' 
               + hRelation:CHILD-BUFFER:NAME 
               + '.' 
               + ENTRY(iField + 1,hRelation:RELATION-FIELDS).
      END.
      cQueries = cQueries + ", ":U 
                + cQuery.

    END. /* join parent to our query.. */
  END.  /* valid hbuffer */

  RETURN cQueries.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataTableHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION dataTableHandle Procedure 
FUNCTION dataTableHandle RETURNS HANDLE
  ( pcTable AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the buffer handle of the specified table 
Parameter: pcTable - table name  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataset AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer  AS HANDLE     NO-UNDO.

  {get DatasetHandle hDataset}.   
  hBuffer = hDataset:GET-BUFFER-HANDLE(pcTable) NO-ERROR.           
  
  RETURN hBuffer.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION deleteRow Procedure 
FUNCTION deleteRow RETURNS LOGICAL
  ( pcTable    AS CHAR,
    pcKeyWhere AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Delete a record for the specified table 
    Notes: Operates on default buffer in order to fire dataset row-created 
           event. 
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE hBuffer AS HANDLE     NO-UNDO.
  hBuffer = {fnarg dataTableHandle pcTable}.
  
  IF VALID-HANDLE(hBuffer) THEN
  DO:
    hBuffer:FIND-UNIQUE('WHERE ':U + pcKeyWhere) NO-ERROR.
    IF hBuffer:AVAIL THEN
    DO TRANSACTION:
      RETURN hBuffer:BUFFER-DELETE. 
    END.
  END.

  RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION destroyBuffer Procedure 
FUNCTION destroyBuffer RETURNS LOGICAL
  ( phBuffer AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataset AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iNum     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hTable   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cTable   AS CHARACTER  NO-UNDO.

  {get DatasetHandle hDataset}.  

  hTable = phBuffer:TABLE-HANDLE. 
  
  IF VALID-HANDLE(hTable) AND hTable:DEFAULT-BUFFER-HANDLE:DATASET = hDataset THEN
  DO:
    ASSIGN
      cTable = hTable:NAME
      iNum = INT(getTableProperty(target-procedure,cTable,'NumBuffers':U))
      iNum = iNum - 1.

    setTableProperty(target-procedure,cTable,'NumBuffers':U,STRING(iNum)).
    IF NOT phBuffer:AUTO-DELETE THEN
      DELETE OBJECT phbuffer .

    RETURN TRUE.
  END.

  RETURN FALSE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-emptyBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION emptyBatch Procedure 
FUNCTION emptyBatch RETURNS LOGICAL
  ( pcTable AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Empty the tables that are retrieved together with the passed table 
    Notes:          
 ------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataset        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRelation       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iRel            AS INTEGER    NO-UNDO.

  hBuffer = {fnarg dataTableHandle pcTable}.
  hBuffer:TABLE-HANDLE:TRACKING-CHANGES = FALSE.
  hBuffer:EMPTY-TEMP-TABLE.
  IF VALID-HANDLE(hbuffer) THEN
  DO:
    DO iRel = 1 TO hBuffer:NUM-CHILD-RELATIONS:
      hRelation = hBuffer:GET-CHILD-RELATION(iRel).
      IF NOT hRelation:REPOSITION THEN
        {fnarg emptyBatch hRelation:CHILD-BUFFER:NAME}.
    END. /* Do iRel = 1 to hBuffer:NUM-CHILD-RELATIONS: */
  END.  /* valid hbuffer */

  RETURN TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-foreignFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION foreignFields Procedure 
FUNCTION foreignFields RETURNS CHARACTER
  ( pcChild AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Returns foreignfields in adm format (child, parent) 
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hBuffer        AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hRelation      AS HANDLE     NO-UNDO.
    DEFINE VARIABLE cForeignFields AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE iColumn        AS INTEGER    NO-UNDO.

    hBuffer = {fnarg dataTablehandle pcChild}. 
    IF VALID-HANDLE(hBuffer) THEN
    DO:
      hRelation = hBuffer:PARENT-RELATION.
      IF VALID-HANDLE(hRelation) THEN
      DO:
        DO iColumn = 1 TO NUM-ENTRIES(hRelation:RELATION-FIELDS) BY 2:
          cForeignfields = cForeignFields 
                         + (IF cForeignFields = '' THEN '' ELSE ',')
                         + hBuffer:NAME + '.' 
                         + ENTRY(iColumn + 1,hRelation:RELATION-FIELDS)
                         + ',':U
                         + hRelation:PARENT-BUFFER:NAME + '.'
                         + ENTRY(iColumn,hRelation:RELATION-FIELDS).
        END.
      END.
    END.

    RETURN cForeignFields.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDatasetHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDatasetHandle Procedure 
FUNCTION getDatasetHandle RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:    Returns the handle of the dataset.
  Parameters: <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataset AS HANDLE NO-UNDO.
  {get DatasetHandle hDataset}.
  RETURN hDataset.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataTables Procedure 
FUNCTION getDataTables RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the tables of the dataset 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataset AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cTables  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iTables AS INTEGER     NO-UNDO.

  {get DatasetHandle hDataset}.   
  DO iTables = 1 TO hDataset:NUM-BUFFERS:
    cTables = cTables + ",":U + hDataset:GET-BUFFER-HANDLE(iTables):NAME.           
  END.

  RETURN LEFT-TRIM(cTables,',').

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTableProperty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTableProperty Procedure 
FUNCTION getTableProperty RETURNS CHAR PRIVATE
  ( phTarget AS HANDLE,
    pcTable AS CHAR,
    pcProperty AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Retrieve table prop 
    Notes: Currently stored as chr(1) paired list in the ADM-DATA of the 
           Temp-table. 
   NOT OVERRIDEABLE - currently called directly and not in target
   PRIVATE 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataSet AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLookup  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hTable   AS HANDLE     NO-UNDO.

  {get DatasetHandle hDataset phTarget}.

  hTable = hDataset:GET-BUFFER-HANDLE(pcTable):TABLE-HANDLE NO-ERROR.        
  iLookup = lookupProperty(pcProperty,hTable:ADM-DATA).

  IF iLookup > 0 THEN
    RETURN ENTRY(iLookup + 1,hTable:ADM-DATA,CHR(1)).

  RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hasChanges) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION hasChanges Procedure 
FUNCTION hasChanges RETURNS LOGICAL
  ( pcTable AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Check if any record is changed in the scope of the passed table  
  pcTable: Table name 
    Notes: The transaction scope of the passed table is very likely to 
           change in the future.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTables   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iBuffer   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cBuffer   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hBuffer   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBibuffer AS HANDLE     NO-UNDO.

  cTables = RIGHT-TRIM(pcTable 
                     + ',':U
                     + {fnarg childTables pcTable},','). 
  
  DO iBuffer = 1 TO NUM-ENTRIES(cTables):
    ASSIGN
      cBuffer   = ENTRY(iBuffer,cTables)
      hBuffer   = {fnarg dataTableHandle cBuffer}
      hBiBuffer = hBuffer:BEFORE-BUFFER.
    IF VALID-HANDLE(hBiBuffer) AND hBIBuffer:TABLE-HANDLE:HAS-RECORDS THEN
      RETURN TRUE.
  END.

  RETURN FALSE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isReposition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isReposition Procedure 
FUNCTION isReposition RETURNS LOGICAL
  ( pcTable AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the REPOSITION of the dataset parent relation, (which 
           really is a child) 
    Notes: The reposition is a 'state' for adm as it tells how the table is
           managed. In this context it is somewhat irrelevant who the 
           parent is. (or it is defined by the context) 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBuffer        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRelation      AS HANDLE     NO-UNDO.

  hBuffer = {fnarg dataTableHandle pcTable}. 
  IF VALID-HANDLE(hBuffer) THEN
    hRelation = hBuffer:PARENT-RELATION.

  IF VALID-HANDLE(hRelation) THEN
    RETURN hRelation:REPOSITION.
  
  RETURN ?.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isScrollable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isScrollable Procedure 
FUNCTION isScrollable RETURNS LOGICAL
  ( pcTable AS CHAR ) :
/*------------------------------------------------------------------------------
 Purpose: Returns false if the table cannot be scrolled as a result of it being 
          managed by a child defined as a parent in the dataset. 
   Notes: 
  ------------------------------------------------------------------------------*/
  DEFINE VARIABLE lRepos      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lScrollable AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hBuffer     AS HANDLE     NO-UNDO.
  
  lRepos = {fnarg isReposition pcTable}.
  IF lRepos THEN
    RETURN TRUE.

  hBuffer = {fnarg dataTableHandle pcTable}. 
  IF VALID-HANDLE(hBuffer) THEN
  DO:
    /* repos unknown and valid table means top buffer, which is scrollable */  
    IF lRepos = ? THEN
      RETURN TRUE.

    /* if repos is false we know we have a parent relation, so just check  
       the cardinality. If this is the logical parent managed by a child 
       then it's not scrollable. */
    IF lRepos = FALSE THEN
      RETURN NOT ({fnarg relationType hBuffer:PARENT-RELATION} MATCHES '*-one':U).
  END. /* valid buffer */

  /* invalid table ref  */
  RETURN ?.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isUniqueID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isUniqueID Procedure 
FUNCTION isUniqueID RETURNS LOGICAL
  (INPUT pcFields AS CHARACTER,
   INPUT pcTable  AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose: Returns TRUE if the fields passed as parameter for the specified
           table match with the fields in an unique index,
           otherwise it returns FALSE
  Parameters: pcFields: Field list to be compared with the index fields
              pcTable: ProDataSet table name
  Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE hBuffer           AS HANDLE    NO-UNDO.
DEFINE VARIABLE iKey              AS INTEGER   NO-UNDO.
DEFINE VARIABLE iIndex            AS INTEGER   NO-UNDO.
DEFINE VARIABLE iField            AS INTEGER   NO-UNDO.
DEFINE VARIABLE cField            AS CHARACTER NO-UNDO.
DEFINE VARIABLE cIndexFields      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cIndexInformation AS CHARACTER NO-UNDO.

hBuffer = {fnarg dataTableHandle pcTable}.

IF NOT VALID-HANDLE(hBuffer) THEN
RETURN ?.

DO WHILE TRUE:
   IF iIndex = 0 THEN
     ASSIGN cIndexFields = hBuffer:KEYS
            iIndex       = 1.
   ELSE DO:
      IF iIndex = 1 THEN
        ASSIGN cIndexInformation = DYNAMIC-FUNCTION('tableIndexInformation':U IN TARGET-PROCEDURE, pcTable, 'UNIQUE':U).
 
      ASSIGN cIndexFields =  ENTRY(iIndex,cIndexInformation, CHR(1))
             iIndex       = iIndex + 1 NO-ERROR.
      IF ERROR-STATUS:ERROR THEN LEAVE.
   END.

   IF cIndexfields = pcFields THEN
      RETURN TRUE.

   ELSE IF NUM-ENTRIES(pcFields) LT NUM-ENTRIES(cIndexFields) THEN NEXT.

   ELSE DO iField = 1 TO NUM-ENTRIES(pcFields):
        ASSIGN cField = ENTRY(iField,pcFields)
               iKey   = LOOKUP(cField,cIndexFields).

        IF iKey > 0 THEN
           ENTRY(iKey,cIndexFields) = ''. 
   END.

   IF TRIM(cIndexFields, ",") = '' THEN 
      RETURN TRUE.
END.

RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-lookupProperty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION lookupProperty Procedure 
FUNCTION lookupProperty RETURNS INTEGER PRIVATE
  ( pcProperty AS CHAR,
    pcList     AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: return the position of the prop name in the passed chr(1) delimited 
           list.
    Notes:  
   NOT OVERRIDEABLE - called directly  
   PRIVATE
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iLookup AS INTEGER    NO-UNDO.
  DO WHILE TRUE:
    iLookup = LOOKUP(pcProperty,pcList,CHR(1)).
    
    IF iLookup = 0 OR iLookup = ? THEN 
      LEAVE.
    
    IF iLookup MODULO 2 = 1 THEN 
      RETURN iLookup.

    /* Remove this entry because its data and not a field */ 
    ENTRY(iLookup,pcList,CHR(1)) = "":U.   
  END.

  RETURN 0.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mergeBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION mergeBatch Procedure 
FUNCTION mergeBatch RETURNS LOGICAL
  ( pcTable AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Merge the tables that was retrieved together with the passed 
           table, but not are true children with the data that was stored 
           away before retrieval to avoid conflict with the current data. 
Parameter:
    pcTable - table name 
             
    Notes:          
 ------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBuffer         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRelation       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iRel            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hTable          AS HANDLE     NO-UNDO.

  DEFINE BUFFER bttBatch FOR ttBatch.

  hBuffer = {fnarg dataTableHandle pcTable}.
  IF VALID-HANDLE(hbuffer) THEN
  DO:
    DO iRel = 1 TO hBuffer:NUM-CHILD-RELATIONS:
      hRelation = hBuffer:GET-CHILD-RELATION(iRel).
      IF NOT hRelation:REPOSITION 
      AND {fnarg relationType hRelation} MATCHES '*-one':U  THEN
      DO:
        FIND bttBatch WHERE bttBatch.TargetProcedure = TARGET-PROCEDURE
                        AND bttBatch.TableName       = STRING(hRelation:CHILD-BUFFER:NAME)
                       NO-ERROR.
        IF AVAIL bttBatch THEN
        DO:
          hRelation:CHILD-BUFFER:TABLE-HANDLE:COPY-TEMP-TABLE(bttBatch.TTHandle,YES).
          DELETE OBJECT bttBatch.TTHandle.
          DELETE bttBatch.
        END.
      END.
      {fnarg mergeBatch hRelation:CHILD-BUFFER:NAME}.
    END. /* Do iRel = 1 to hBuffer:NUM-CHILD-RELATIONS: */
  END.  /* valid hbuffer */

  RETURN TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-relationFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION relationFields Procedure 
FUNCTION relationFields RETURNS CHARACTER
  ( pcParentTable AS CHAR,
    pcChildTable  AS CHAR) :
/*------------------------------------------------------------------------------
   Purpose: Returns relationfields in paramter order (parent,child)    
Parameters: pcTable X 2  (order is irrelevant)  
     Notes: 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBufferOne      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBufferTwo      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFieldOne       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldTwo       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hRelation       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cRelationFields AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQualFields     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iColumn         AS INTEGER    NO-UNDO.

  hBufferTwo = {fnarg dataTableHandle pcChildTable}.
  IF NOT VALID-HANDLE(hBufferTwo) THEN
    RETURN ?.

  hRelation = hBufferTwo:PARENT-RELATION.  

  IF VALID-HANDLE(hRelation) AND hRelation:PARENT-BUFFER:NAME = pcParentTable THEN
    hBufferOne = hRelation:PARENT-BUFFER.

  IF NOT VALID-HANDLE(hBufferOne) THEN
  DO:
    hBufferOne = {fnarg dataTableHandle pcParentTable}.
    IF NOT VALID-HANDLE(hBufferOne) THEN
      RETURN ?.
    hRelation = hBufferOne:PARENT-RELATION.  
    IF NOT VALID-HANDLE(hRelation) OR hRelation:PARENT-BUFFER:NAME <> pcChildTable THEN
      RETURN ?. 
    /* set flag to tell that the passed parent is the child of the relation */
  END.

  cRelationFields = hRelation:RELATION-FIELDS.
  DO iColumn = 1 TO NUM-ENTRIES(cRelationFields) BY 2:
    ASSIGN 
      cFieldOne = hBufferOne:NAME + '.' + ENTRY(iColumn,cRelationFields)
      cFieldTwo = hBufferTwo:NAME + '.' + ENTRY(iColumn + 1,cRelationFields)                  
      cQualFields = cQualFields
                  + cFieldOne
                  + ',':U
                  + cFieldTwo.
  END.

  RETURN cQualFields.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-relationType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION relationType Procedure 
FUNCTION relationType RETURNS CHARACTER
   (phRelation AS HANDLE):
/*------------------------------------------------------------------------------
  Purpose: Returns the relation type
           in the form 'one-many', 'many-one' or 'one-one'  
Parameter:
    phRelation - relation handle 
             
    Notes:          
 ------------------------------------------------------------------------------*/
DEFINE VARIABLE iField        AS INTEGER     NO-UNDO.
DEFINE VARIABLE cRelFields    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cChildFields  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cParentFields AS CHARACTER   NO-UNDO.

IF NOT VALID-HANDLE(phRelation) THEN
RETURN ''.

ASSIGN cRelFields = phRelation:RELATION-FIELDS.

DO iField = 1 TO NUM-ENTRIES(cRelFields) BY 2:
   ASSIGN cParentFields = cParentFields + ENTRY(iField,     cRelFields) + ","
          cChildFields  = cChildFields  + ENTRY(iField + 1, cRelFields) + ",".
END.

ASSIGN cParentFields = TRIM(cParentFields, ",")
       cChildFields  = TRIM(cChildFields,  ",").

RETURN (IF DYNAMIC-FUNCTION('isUniqueID':U IN TARGET-PROCEDURE, INPUT cParentFields, INPUT phRelation:PARENT-BUFFER:NAME) THEN "One":U ELSE "Many":U)
       + "-" +
       (IF DYNAMIC-FUNCTION('isUniqueID':U IN TARGET-PROCEDURE, INPUT cChildFields,  INPUT phRelation:CHILD-BUFFER:NAME)  THEN "One":U ELSE "Many":U).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDatasetHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDatasetHandle Procedure 
FUNCTION setDatasetHandle RETURNS LOGICAL
  ( phDataset AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:    Set the handle of the dataset.
  Parameters: Handle of the dataset.
------------------------------------------------------------------------------*/
  {set DatasetHandle phDataset}.
  RETURN TRUE.   
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTableProperty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTableProperty Procedure 
FUNCTION setTableProperty RETURNS LOGICAL PRIVATE
 ( phTarget AS HANDLE,
   pcTable AS CHAR,
   pcProperty AS CHAR,
   pcValue AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Set table prop 
    Notes: Currently stored as chr(1) paired list in the ADM-DATA of the 
           Temp-table. 
   PRIVATE 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataSet AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLookup  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hTable   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cList    AS CHARACTER  NO-UNDO.
  
  {get DatasetHandle hDataset phTarget}.   
  hTable = hDataset:GET-BUFFER-HANDLE(pcTable):TABLE-HANDLE NO-ERROR.        
  IF NOT VALID-HANDLE(hTable) THEN
    RETURN ?.
  
  IF pcValue = ? THEN
    pcValue = '?':U.

  ASSIGN
    cList   = IF hTable:ADM-DATA = ? THEN '' ELSE hTable:ADM-DATA
    iLookup = lookupProperty(pcProperty,cList).

  IF iLookup > 0 THEN 
    ENTRY(iLookup + 1,cList,CHR(1)) = pcValue. 
  
  ELSE 
    ASSIGN 
      cList = cList 
            + (IF cList = "":U THEN "":U ELSE CHR(1))
            + pcProperty
            + CHR(1)
            + pcValue.

  hTable:ADM-DATA = cList.  

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sortTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION sortTables Procedure 
FUNCTION sortTables RETURNS CHARACTER
  ( pcTable AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the tables that can be sorted together with the passed table 
    Notes: The parent relation is either part of this table's query or a 
           reposition parent and is thus not included in the sort. 
        -  DataView QuetyTables defaults to thid.            
 ------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataset        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRelation       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cTables         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iRel            AS INTEGER    NO-UNDO.

  hBuffer = {fnarg dataTableHandle pcTable}.
  IF VALID-HANDLE(hbuffer) THEN
  DO:
    cTables = pcTable.
    DO iRel = 1 TO hBuffer:NUM-CHILD-RELATIONS:
      hRelation = hBuffer:GET-CHILD-RELATION(iRel).
      IF {fnarg relationType hRelation} matches '*-one' THEN
      DO:
        cTables = cTables 
                + (IF ctables = '' THEN '' ELSE ',')
                +  hRelation:CHILD-BUFFER:NAME.
      END.
    END. /* Do iRel = 1 to hBuffer:NUM-CHILD-RELATIONS: */
  END.  /* valid hbuffer */

  RETURN cTables.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-storeBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION storeBatch Procedure 
FUNCTION storeBatch RETURNS LOGICAL
  ( pcTable AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Store away the tables that are retrieved together with the passed 
           table, but not are true children, such that new data may conflict
           with the current data. 
Parameter:
    pcTable - table name 
             
    Notes:          
 ------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBuffer         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRelation       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iRel            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hTable          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lStored         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lStoredChild    AS LOGICAL    NO-UNDO.

  DEFINE BUFFER bttBatch FOR ttBatch.

  hBuffer = {fnarg dataTableHandle pcTable}.
  IF VALID-HANDLE(hbuffer) THEN
  DO:
    DO iRel = 1 TO hBuffer:NUM-CHILD-RELATIONS:
      hRelation = hBuffer:GET-CHILD-RELATION(iRel).
      IF NOT hRelation:REPOSITION 
      AND hRelation:CHILD-BUFFER:TABLE-HANDLE:HAS-RECORDS 
      AND {fnarg relationType hRelation} MATCHES '*-one':U  THEN
      DO:
        CREATE TEMP-TABLE hTable.
        hTable:COPY-TEMP-TABLE(hRelation:CHILD-BUFFER:TABLE-HANDLE).
        CREATE bttBatch.
        ASSIGN
          bttBatch.TargetProcedure = TARGET-PROCEDURE
          bttBatch.TableName       = hRelation:CHILD-BUFFER:NAME
          bttBatch.TTHandle        = hTable
          lStored                  = TRUE
          hRelation:CHILD-BUFFER:TABLE-HANDLE:TRACKING-CHANGES = FALSE.
        hRelation:CHILD-BUFFER:EMPTY-TEMP-TABLE.
      END.

      lStoredChild = {fnarg storeBatch hRelation:CHILD-BUFFER:NAME}.
    END. /* Do iRel = 1 to hBuffer:NUM-CHILD-RELATIONS: */
  END.  /* valid hbuffer */

  RETURN lStored OR lStoredChild.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tableContext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION tableContext Procedure 
FUNCTION tableContext RETURNS CHARACTER
  ( pcTable AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN getTableProperty(TARGET-PROCEDURE, pcTable,'TableContext':U).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tableIndexInformation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION tableIndexInformation Procedure 
FUNCTION tableIndexInformation RETURNS CHARACTER
  (INPUT pcTable AS CHARACTER,
   INPUT pcQuery AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Purpose: Return index Information for the ProDataSet table passed
            as parameter.
            Each index is separated with chr(1).
                        
  Parameters: pcTable - ProDataSet table name.

              pcQuery - What information? 
                - 'All'             All indexed fields
                - 'Standard' or ''  All indexed fields excluding word indexes    
                - 'Word'            Word Indexed 
                - 'Unique'          Unique indexes 
                - 'NonUnique'       Non Unique indexes 
                - 'Primary'         Primary index    

    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE hBuffer      AS HANDLE      NO-UNDO.
DEFINE VARIABLE lFound       AS LOGICAL    NO-UNDO.
DEFINE VARIABLE iIdx         AS INTEGER    NO-UNDO.
DEFINE VARIABLE iField       AS INTEGER    NO-UNDO.
DEFINE VARIABLE cIndexInfo   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cReturnValue AS CHARACTER  NO-UNDO.

  hBuffer = {fnarg dataTableHandle pcTable}.

  IF NOT VALID-HANDLE(hBuffer) THEN
  RETURN "":U.
  
IndexBlock:
DO WHILE TRUE:
    ASSIGN iIdx         = iIdx + 1
           cIndexInfo   = hBuffer:INDEX-INFORMATION(iIdx).

    IF cIndexInfo = ? THEN 
        LEAVE IndexBlock.    
    
    CASE pcQuery:
        WHEN 'Standard':U OR WHEN '':U THEN
          lFound = ENTRY(4,cIndexInfo) = "0":U.
          
        WHEN "Info":U OR WHEN "All" THEN
          lFound = TRUE.
          
        WHEN "Word":U THEN
          lFound = ENTRY(4,cIndexInfo) = "1":U.
          
        WHEN "Unique":U THEN
          lFound = ENTRY(2,cIndexInfo) = "1":U.
          
        WHEN "NonUnique":U THEN
          lFound = ENTRY(2,cIndexInfo) = "0":U AND 
                   ENTRY(4,cIndexInfo) = "0":U.
          
        WHEN "Primary" THEN
          lFound = ENTRY(3,cIndexInfo) = "1":U.
          
        OTHERWISE
        DO:
          /* Design time error */
          MESSAGE "ADM Error:"
                  "Function getIndexInformation() does not understand"
                  "parameter '" + pcQuery "'"
                    
          VIEW-AS ALERT-BOX ERROR.
          RETURN ?.
        END.
    END CASE. /* pcQuery */
    IF lFound THEN
    DO:
        ASSIGN cReturnValue = cReturnValue + CHR(1).

        DO iField = 5 TO NUM-ENTRIES(cIndexInfo) BY 2:
           ASSIGN cReturnValue = cReturnValue + ENTRY(iField, cIndexInfo) + ",".
        END.
        
        ASSIGN cReturnValue = TRIM(cReturnValue, ",").
    END. /*IF lFound*/
END. /*DO WHILE*/

ASSIGN cReturnValue = TRIM(cReturnValue, CHR(1)).

RETURN cReturnValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tableNextContext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION tableNextContext Procedure 
FUNCTION tableNextContext RETURNS CHARACTER
  ( pcTable AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the next context for the table
    Notes:  
------------------------------------------------------------------------------*/
  RETURN getTableProperty(TARGET-PROCEDURE, pcTable,'NextContext':U).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tableNumRecords) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION tableNumRecords Procedure 
FUNCTION tableNumRecords RETURNS INTEGER
  ( pcTable AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the num records of the table
    Notes:  
------------------------------------------------------------------------------*/
  RETURN INT(getTableProperty(TARGET-PROCEDURE, pcTable,'NumRecords':U)).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tablePrevContext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION tablePrevContext Procedure 
FUNCTION tablePrevContext RETURNS CHARACTER
  ( pcTable AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the prev context for the table
    Notes:  
------------------------------------------------------------------------------*/
  RETURN getTableProperty(TARGET-PROCEDURE, pcTable,'PrevContext':U).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION updateRow Procedure 
FUNCTION updateRow RETURNS LOGICAL
  ( pcTable     AS CHAR,
    pcKeyWhere  AS CHAR,
    pcValueList AS CHAR) :
/*------------------------------------------------------------------------------
   Purpose:  update a datatable row    
Parameters:  pcTable     - DataTable 
             pcKeyWhere  - expression uniquely identifying the record 
             pcValuelist - CHR(1) delimited list of alternating column names 
                           and values to be assigned. (same as submitRow)
    Notes:   Called from submitRow of the dataview accesses the default buffer
             in order to fire dataset triggers.
           - The dataview validates that the chagnes are applied only to  
             updatableColumns.   
           - Returns false if any error is encountered with error messages added
             to the adm error stack.
           - As of current no error is added to the stack for invalid buffer 
             or key reference.       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iColNum           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cColumnRef        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumn           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hCol              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cValue            AS CHAR       NO-UNDO.
  DEFINE VARIABLE cErrorReason      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOldValue         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hBuffer           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lSuccess          AS LOGICAL    NO-UNDO.
 
  hBuffer = {fnarg dataTableHandle pcTable}.
  IF VALID-HANDLE(hBuffer) THEN
  DO:
    hBuffer:FIND-UNIQUE('WHERE ':U + pcKeyWhere) NO-ERROR.
    IF hBuffer:AVAILABLE THEN
    DO TRANSACTION:
      lSuccess = TRUE.
      DO iColNum = 1 TO NUM-ENTRIES(pcValueList,CHR(1)) BY 2:
        ASSIGN
          cColumnRef = ENTRY(iColNum, pcValueList,CHR(1))
          cColumn    = ''
          hCol       = ?.
        /* As of current all columns must reference one table */
        IF NUM-ENTRIES(cColumnRef,'.':U) = 2 THEN
        DO:
          IF cColumnRef BEGINS hBuffer:NAME + '.' THEN
            cColumn  = ENTRY(2,cColumnRef,'.':U).
        END.
        ELSE 
          cColumn = cColumnRef.

        IF cColumn > '' THEN
          hCol = hBuffer:BUFFER-FIELD(cColumn) NO-ERROR.
        
        IF hCol = ? THEN 
        DO:
          RUN addMessage IN TARGET-PROCEDURE (SUBSTITUTE({fnarg messageNumber 53}, cColumnRef), cColumnRef, ?).
          lSuccess = FALSE. 
        END.
        ELSE DO:
          cValue = ENTRY(iColNum + 1, pcValueList,CHR(1)).
          IF hCol:DATA-TYPE = 'CLOB':U OR hCol:DATA-TYPE = 'BLOB':U THEN
          DO:         
            cErrorReason = DYNAMIC-FUNCTION('assignBufferValueFromReference':U IN TARGET-PROCEDURE,
                                              hCol,
                                              cValue).
              /* error message 92 (copy of large object to column failed) */ 
            IF cErrorReason > '' THEN
            DO:
              lSuccess = FALSE.
              RUN addMessage IN TARGET-PROCEDURE 
                   (SUBSTITUTE({fnarg messageNumber 93}, hCol:LABEL, cErrorReason), 
                               hCol:NAME, 
                                ?).
    
            END.
          END. /* large column  */
          ELSE DO:
            cOldValue = hCol:BUFFER-VALUE.
            /* Check for unknown values in the list of changes. */
            hCol:BUFFER-VALUE = IF cValue = "?":U 
                                THEN ?
                                ELSE cValue NO-ERROR.
            /* Unique index errors will be trapped here. 
               reset value and add the error to the stack */
            IF ERROR-STATUS:ERROR THEN
            DO:
              lSuccess = FALSE.
              hCol:BUFFER-VALUE = cOldValue.
              RUN addMessage IN TARGET-PROCEDURE 
                       (?,
                        cColumnRef, 
                        ?).
            END. /* error */
          END.  /* else (not large column) */
        END.   /* else (valid column ref) */
      END.    /* do icol loop */
      
      /* if no changes were done on a new record then the column 
         assignment above would not capture the error (nothing modified),
         so we validate to capture potential errors here. 
         (typically key already exists error)  */ 
      IF lSuccess THEN
      DO:
        DO ON ERROR UNDO,LEAVE:
          lSuccess = FALSE.
          /* the method returns true on already exists error, but does throw 
             error....  so set it false before and true after if success. */ 
          hBuffer:BUFFER-VALIDATE() NO-ERROR.
          lSuccess = TRUE. 
        END.
        
        /* Add the error */
        IF NOT lSuccess THEN
        DO:
          RUN addMessage IN TARGET-PROCEDURE 
                         (?,
                          ?,
                          ?).
          UNDO. /* undo all changes (or we'll get the error again when 
                   the transaction ends) */
        END.
      END. /* success */
    END. /* transaction if record found */ 
  END.  /* valid buffer */
  
  RETURN lSuccess.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-viewColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION viewColumns Procedure 
FUNCTION viewColumns RETURNS CHARACTER
  ( pcTable AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the columns that are part of the view of the passed table 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTables  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iTable   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTable   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTable   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cColumns AS CHARACTER  NO-UNDO.

  cTables = {fnarg viewTables pcTable}.

  DO iTable = 1 TO NUM-ENTRIES(cTables):
    cTable = ENTRY(iTable,cTables).
    cColumns = cColumns 
             + (IF cColumns = '' THEN '' ELSE ',') 
             + {fnarg dataColumns cTable}.
  END.

  RETURN cColumns.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-viewHasLobs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION viewHasLobs Procedure 
FUNCTION viewHasLobs RETURNS LOGICAL
  ( pcTable AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the columns that are part of the view of the passed table 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTables  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iTable   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTable   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTable   AS HANDLE     NO-UNDO.

  cTables = {fnarg viewTables pcTable}.
  DO iTable = 1 TO NUM-ENTRIES(cTables):
    ASSIGN
      cTable  = ENTRY(iTable,cTables)
      hTable  = {fnarg dataTableHandle cTable}.
    IF hTable:HAS-LOBS THEN
      RETURN TRUE.
  END.

  RETURN FALSE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-viewTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION viewTables Procedure 
FUNCTION viewTables RETURNS CHARACTER
  ( pcTable AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the tables that are part of the view of the passed table 
    Notes: The passed table is included in the returned value 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBuffer         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRelation       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cTables         AS CHARACTER  NO-UNDO.
  
  hBuffer   = {fnarg dataTableHandle pcTable}.
  IF VALID-HANDLE(hBuffer) THEN
  DO:
    cTables = {fnarg sortTables pcTable}.
    IF cTables > '' THEN
    DO:
      hRelation = hBuffer:PARENT-RELATION.
      IF {fnarg relationType hRelation} BEGINS 'one' THEN
        cTables = cTables + ',' + hRelation:PARENT-BUFFER:NAME.
    END.  /* cTables > ''   */
  END.

  RETURN cTables.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

