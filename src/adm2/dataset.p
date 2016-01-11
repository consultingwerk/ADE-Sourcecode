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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-activateRelation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD activateRelation Procedure 
FUNCTION activateRelation RETURNS LOGICAL
        ( pcTable AS CHAR,
          pcRelTable AS CHAR ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-allForeignFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD allForeignFields Procedure 
FUNCTION allForeignFields RETURNS CHARACTER
        ( pcTable AS CHAR  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignTableContext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignTableContext Procedure 
FUNCTION assignTableContext RETURNS LOGICAL
  ( pcTable AS CHAR,
    pcContext AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignTableExceptionBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignTableExceptionBuffer Procedure 
FUNCTION assignTableExceptionBuffer RETURNS LOGICAL
  ( pcTable AS CHAR,
    phBuffer AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignTableFetchTree) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignTableFetchTree Procedure 
FUNCTION assignTableFetchTree RETURNS LOGICAL
         ( pcTable     AS CHAR,
           pcFetchTree AS CHAR ) FORWARD.

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

&IF DEFINED(EXCLUDE-collectChanges) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD collectChanges Procedure 
FUNCTION collectChanges RETURNS LOGICAL PRIVATE
  ( phChangeDataset AS HANDLE,
    pcTable         AS CHAR,
    pcPrefix        AS CHAR,
    plChildren      AS LOGICAL)  FORWARD.

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

&IF DEFINED(EXCLUDE-createChangeDataset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createChangeDataset Procedure 
FUNCTION createChangeDataset RETURNS HANDLE
  ( pcDataTable      AS CHAR,
    plSubmitParent   AS LOGICAL,
    plSubmitChildren AS LOGICAL,
    pcChangePrefix   AS CHARACTER)  FORWARD.

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

&IF DEFINED(EXCLUDE-isChild) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isChild Procedure 
FUNCTION isChild RETURNS LOGICAL
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

&IF DEFINED(EXCLUDE-mergeChangeDataset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD mergeChangeDataset Procedure 
FUNCTION mergeChangeDataset RETURNS LOGICAL
  ( phChangeDataset AS HANDLE,
    plCopyAll       AS LOGICAL  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-relationFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD relationFields Procedure 
FUNCTION relationFields RETURNS CHARACTER
  ( pcFromTable AS CHAR,
    pcToTable  AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-relationHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD relationHandle Procedure 
FUNCTION relationHandle RETURNS HANDLE
        ( pcParent AS CHAR ,
          pcChild AS CHAR ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-relationHandleFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD relationHandleFields Procedure 
FUNCTION relationHandleFields RETURNS CHARACTER PRIVATE
  ( phRelation   AS HANDLE,
    plChildFirst AS LOGICAL,
    plExpression AS LOGICAL)  FORWARD.

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

&IF DEFINED(EXCLUDE-removeTableExceptionBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD removeTableExceptionBuffer Procedure 
FUNCTION removeTableExceptionBuffer RETURNS LOGICAL
  ( pcTable AS CHAR )  FORWARD.

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

&IF DEFINED(EXCLUDE-tableExceptionBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD tableExceptionBuffer Procedure 
FUNCTION tableExceptionBuffer RETURNS HANDLE
  ( pcTable AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tableFetchTree) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD tableFetchTree Procedure 
FUNCTION tableFetchTree RETURNS CHARACTER
        ( pcTable as CHAR ) FORWARD.

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

&IF DEFINED(EXCLUDE-undoRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD undoRow Procedure 
FUNCTION undoRow RETURNS LOGICAL
  ( pcTable     AS CHAR,
    pcKeyWhere  AS CHAR,
    plUndoCreate as logical)  FORWARD.

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

&IF DEFINED(EXCLUDE-buildViewRequest) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildViewRequest Procedure 
PROCEDURE buildViewRequest :
/*------------------------------------------------------------------------------
    Purpose:
    Parameters: <none>
    Notes:
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcDataTable     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcKeyWhere      AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcJoinTables    AS CHARACTER  NO-UNDO. 
  DEFINE INPUT  PARAMETER plRepos         AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcTables        AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcQueries       AS CHARACTER  NO-UNDO. 
  DEFINE OUTPUT PARAMETER pcPositions     AS CHARACTER  NO-UNDO.
    
  DEFINE VARIABLE hBuffer      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cExpressions AS CHARACTER  NO-UNDO. 
  DEFINE VARIABLE iTable       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTableWhere  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTable       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lQuery       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lFirst       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cFieldList   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDlm1        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAvail       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDlm2        AS CHARACTER  NO-UNDO.
  
  hBuffer = {fnarg dataTableHandle pcDataTable}.
  IF VALID-HANDLE(hBuffer) THEN 
  DO:
    IF pcKeyWhere > "" THEN 
    DO:
      IF NOT pcKeyWhere BEGINS 'WHERE' THEN 
        pcKeyWhere = 'WHERE ' + pcKeyWhere.
      CREATE BUFFER hBuffer FOR TABLE hBuffer.
      hBuffer:FIND-UNIQUE(pcKeyWhere) NO-ERROR. 
      lAvail = hBuffer:AVAIL.   
    END.   
       
    RUN obtainBufferExpressions IN TARGET-PROCEDURE 
           (hBuffer,
            YES, /* unique relations */
            plRepos, /* include repos relations */
            lAvail,
            INPUT-OUTPUT pcJoinTables,
            INPUT-OUTPUT cExpressions).
            
    DO iTable = 1 TO NUM-ENTRIES(pcJoinTables):
      cTableWhere = ENTRY(iTable,cExpressions,CHR(1)).
      IF cTableWhere > '':U THEN 
      DO:
        ASSIGN 
          cTable   = ENTRY(iTable,pcJoinTables)
          lQuery   = (INDEX(cTableWhere,'"':U) > 0 
                      OR
                      INDEX(cTableWhere,"'":U) > 0)                  
          pcTables = pcTables 
                   + cDlm1
                   + cTable
          pcQueries = pcQueries 
                    + cDlm2
                    + "FOR EACH ":U + cTable
          pcPositions = pcPositions
                      + cDlm2
          cDlm1 = ",":U
          cDlm2 = CHR(1).     
              
        IF lQuery THEN 
          pcQueries = pcQueries + " WHERE "
                    + cTableWhere.
        ELSE 
        DO:
          ASSIGN 
            cFieldList = REPLACE(cTableWhere," AND ":U,",":U)             
            cFieldList = REPLACE(cFieldList,"=":U,",":U)             
            cFieldList = REPLACE(cFieldList," ":U,"":U)             
            pcPositions = pcPositions
                        + cFieldList.
        END.              
      END.                                 
    END.
    IF lAvail THEN 
      DELETE OBJECT hBuffer.
  END.   
           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:   Super will publish the event which is picked up by the 
           datacontainer and possibly passed to the service adapter.   
------------------------------------------------------------------------------*/
   DEFINE VARIABLE hDataset AS HANDLE     NO-UNDO.
   {get DatasetHandle hDataset}.
   RUN SUPER.
   DELETE OBJECT hDataset NO-ERROR. 
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainBufferExpressions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtainBufferExpressions Procedure 
PROCEDURE obtainBufferExpressions :
/*------------------------------------------------------------------------------
  Purpose: Obtain join expression with corresponding tables
    Notes:          
 ------------------------------------------------------------------------------*/
  DEFINE INPUT        PARAMETER phBuffer      AS HANDLE     NO-UNDO.
  DEFINE INPUT        PARAMETER plUnique      AS LOGICAL    NO-UNDO.
  DEFINE INPUT        PARAMETER plRepos       AS LOGICAL    NO-UNDO.
  DEFINE INPUT        PARAMETER plCheckAvail   AS LOGICAL    NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcTables      AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcExpressions AS CHARACTER  NO-UNDO.
   
  DEFINE VARIABLE hRelation       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cTables         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iRel            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cChild          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParent         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iEntry          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cWhere          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hChild          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iField          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cField          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAvailWhere     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAvailChild     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lUseList        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hAvailBuffer    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lNoValue        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hField          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cTableNoValues  AS CHARACTER  NO-UNDO. 
  
  IF pcExpressions = '' THEN 
    pcExpressions = FILL(CHR(1),NUM-ENTRIES(pcTables) - 1).
  
  IF VALID-HANDLE(phBuffer) THEN
  DO:
    IF plCheckAvail THEN 
      ASSIGN 
        hAvailBuffer = phBuffer
        phBuffer     = {fnarg dataTableHandle phBuffer:name}.
      
    DO iRel = 1 TO phBuffer:NUM-CHILD-RELATIONS:
      ASSIGN 
        hRelation = phBuffer:GET-CHILD-RELATION(iRel)
        hChild    = hRelation:CHILD-BUFFER
        cChild    = hChild:NAME
        iEntry    = LOOKUP(cChild,pcTables).
      IF iEntry > 0
      AND (plRepos OR hRelation:REPOSITION = FALSE)  
      AND ((plUnique AND {fnarg relationType hRelation} MATCHES '*-one')
            OR  
           (NOT plUnique AND {fnarg relationType hRelation} MATCHES 'one-*')
          ) THEN          
      DO:
        assign
          lNoValue = false 
          lUseList = plCheckAvail AND hAvailBuffer:AVAIL
          cWhere   = DYNAMIC-FUNCTION('relationHandleFields' IN TARGET-PROCEDURE,
                                     hRelation,
                                     YES, /* parent on right */
                                     NOT lUseList /* return expression */).
   
        IF plCheckAvail AND hAvailBuffer:AVAIL THEN 
        DO:
          cAvailWhere = "".         
          /* allow override of no values  
              - Trick: '?' will make 0 or blank into values that need data 
            NOTE: currently applies to ANY of the keyfields if multi key  */
          cTableNoValues = dynamic-function("tableNoValues" in target-procedure,
                                             cChild) no-error.
          
          DO iField = 1 TO NUM-ENTRIES(cWhere) BY 2:
            ASSIGN 
              cField      = ENTRY(2,ENTRY(iField + 1,cWhere),".") 
              hField      = hAvailBuffer:BUFFER-FIELD(cField).
            
            if iField = 1 or not lNoValue then 
            do:
              if hField:buffer-value = ? then 
                lNoValue = true.
              else do: 
                if cTableNoValues > "" then 
                  lookup(hField:buffer-value,cTableNoValues,chr(1)) > 0.
                else do:   
                  case hField:data-type:
                    when "character" then
                      lNoValue = hField:buffer-value = "".
                    when "integer" or when "int64" then
                      lNoValue = (hField:buffer-value = 0).                             
                    when "decimal" then
                      lNoValue = (hField:buffer-value = 0.0).                             
                  end. /* case data type */
                end. /* else (no tableNoValues property) */ 
              end. /* else (not unknown) */ 
            end. /* first field or not novalue */. 
            
            if not lNoValue then
              cAvailWhere = (if iField = 1 then ""
                             else cAvailWhere + ' AND ')             
                          + ENTRY(iField,cWhere) 
                          + ' = ':U
                          + QUOTER(hField:BUFFER-VALUE).             
          END. /* iField loop */
          
          if not lNoValue then
          do:
            CREATE BUFFER hChild FOR TABLE hChild.
            lAvailChild = hChild:FIND-UNIQUE('WHERE ' + cAvailWhere) NO-ERROR.
            /* if nothing found then return the expression so it can 
               be passed to server */ 
            IF NOT lAvailChild THEN
              ENTRY(iEntry,pcExpressions,CHR(1)) = cAvailWhere.
          end. /* if not lnovalue */
        END. /* checkavail and buffer avail */           
        ELSE
        IF cWhere > '' THEN 
          ENTRY(iEntry,pcExpressions,CHR(1)) = cWhere.
        
        if not lNoValue then
        do:
          RUN obtainBufferExpressions IN TARGET-PROCEDURE 
           (hChild,
            plUnique, /* unique relations */
            plRepos, /* include repos relations */
            lAvailChild,
            INPUT-OUTPUT pcTables,
            INPUT-OUTPUT pcExpressions).
            
          if plCheckAvail AND phBuffer:AVAIL then
            delete object hChild no-error.
        end.    
      END.
    END. /* Do iRel = 1 to hBuffer:NUM-CHILD-RELATIONS: */
    
    /* check parent of buffer if buffer not in list (meaning top table) */
    IF LOOKUP(phBuffer:NAME,pcTables) = 0 AND NOT plCheckAvail THEN 
    DO: 
      hRelation = phBuffer:PARENT-RELATION.
      IF VALID-HANDLE(hRelation) THEN 
      DO:
        ASSIGN 
          cParent = hRelation:PARENT-BUFFER:NAME
          iEntry  = LOOKUP(cParent,pcTables).
        IF iEntry > 0 THEN 
        DO:  
          cWhere = DYNAMIC-FUNCTION('relationHandleFields' IN TARGET-PROCEDURE,
                                     hRelation,
                                     NO, /* parent on left */
                                     YES).
          IF cWhere > '' THEN 
            ENTRY(iEntry,pcExpressions,CHR(1)) = cWhere.
        END. 
      END. /* valid relation */ 
    END. /* parent of phBuffer in list and not phbuffer */       
  END.  /* valid hbuffer */
  RETURN. 
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

&IF DEFINED(EXCLUDE-activateRelation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION activateRelation Procedure 
FUNCTION activateRelation RETURNS LOGICAL
        ( pcTable AS CHAR,
          pcRelTable AS CHAR ):
/*------------------------------------------------------------------------------
    Purpose:
    Notes:
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataSet  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iRelation AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hRelation AS HANDLE     NO-UNDO.
  
  {get DatasetHandle hDataset}.
  DO iRelation = 1 TO hDataset:NUM-RELATIONS:
    hRelation = hDataset:GET-RELATION(iRelation).
    IF  hRelation:CHILD-BUFFER:TABLE = pcRelTable 
    AND hRelation:PARENT-BUFFER:TABLE = pcTable THEN
    DO:
      hRelation:ACTIVE = TRUE.  
      RETURN TRUE.
    END.   
  END.  
  RETURN FALSE. 
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-allForeignFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION allForeignFields Procedure 
FUNCTION allForeignFields RETURNS CHARACTER
        ( pcTable AS CHAR  ):
/*------------------------------------------------------------------------------
    Purpose: Return a comma separated list of ALL foreignfields of the table
      Notes: A single foreign key may consist of one or more of the returned 
             fields. 
-----------------------------------------------------------------------------*/
  DEFINE VARIABLE hBuffer        AS HANDLE     NO-UNDO. 
  DEFINE VARIABLE cFields        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataset       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iRelation      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hRelation      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lActiveParent  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lRelFound      AS LOGICAL    NO-UNDO.
  
  DEFINE VARIABLE cRelationType  AS CHARACTER  NO-UNDO.

  hBuffer = {fnarg dataTableHandle pcTable}.
  
  IF VALID-HANDLE(hBuffer) THEN 
  DO:
    {get DataSetHandle hDataset}.
    DO iRelation = 1 TO hDataset:NUM-RELATIONS:
      ASSIGN 
        hRelation     = hDataset:GET-RELATION(iRelation)
        lRelFound     = (hRelation:PARENT-BUFFER:NAME = pcTable)
        lActiveParent = (hRelation:CHILD-BUFFER:NAME  = pcTable).
      IF lRelFound OR lActiveParent THEN 
      DO:    
        cRelationType = {fnarg relationType hRelation}.
        IF lRelFound     AND cRelationType MATCHES "*-one" 
        OR lActiveParent AND cRelationType MATCHES "one-*" THEN
        DO: 
          cFields = cFields  
                    + (IF cFields = "" THEN "" ELSE ",")  
                    + DYNAMIC-FUNCTION("relationHandleFields":U IN TARGET-PROCEDURE,
                                       hRelation,lActiveParent,NO).   
        END. /* pcTable relation found */
      END. 
    END.  /* do iRelation 1 to num-relations */      
  END. /* valid buffer */
  ELSE /* return ? for bad request */
    cFields = ?.
    
  RETURN cFields.
   
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

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

&IF DEFINED(EXCLUDE-assignTableExceptionBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignTableExceptionBuffer Procedure 
FUNCTION assignTableExceptionBuffer RETURNS LOGICAL
  ( pcTable AS CHAR,
    phBuffer AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose: Stores the buffer that has failed changes.  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cBuffer AS CHARACTER  NO-UNDO.

  /* an invalid handle makes no sense so just ignore it (for now..)  */ 
  IF VALID-HANDLE(phBuffer) THEN
  DO:
    cBuffer = STRING(phBuffer).
    DYNAMIC-FUNCTION('setTableProperty':U IN TARGET-PROCEDURE,
                      TARGET-PROCEDURE, pcTable,'ErrorBuffer':U,cBuffer).
    RETURN TRUE.   
  END.
  
  RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignTableFetchTree) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignTableFetchTree Procedure 
FUNCTION assignTableFetchTree RETURNS LOGICAL
         ( pcTable     AS CHAR,
           pcFetchTree AS CHAR ):
/*------------------------------------------------------------------------------
    Purpose: Set fetch information for table retrieval 
             Retrieved by parent - grandparent (tree) when table also are 
             retrieving itself - Dataisfetched = false.
    Notes:   Used indirectly in dataAvailable to avoid retrieving 
             if parent positions matches retrieved position   
------------------------------------------------------------------------------*/
  DYNAMIC-FUNCTION('setTableProperty':U IN TARGET-PROCEDURE,
                    TARGET-PROCEDURE, 
                    pcTable,
                    'FetchTree':U,
                    /* both adm and table prop currently uses chr(1)  */
                    replace(pcFetchTree,chr(1),chr(2))).
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
           one-to-one relations are included
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataset        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRelation       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iRel            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cChildren       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cChildTables    AS CHARACTER  NO-UNDO.

  hBuffer = {fnarg dataTableHandle pcTable}.
  IF VALID-HANDLE(hbuffer) THEN
  DO:
    DO iRel = 1 TO hBuffer:NUM-CHILD-RELATIONS:
      hRelation = hBuffer:GET-CHILD-RELATION(iRel).
      IF {fnarg relationType hRelation} BEGINS 'one-':U THEN 
      DO:
        ASSIGN  
          cChildren = cChildren 
                    + (IF cChildren = '':U THEN '':U ELSE ',':U) 
                    + hRelation:CHILD-BUFFER:NAME
          cChildTables = {fnarg childTables hRelation:CHILD-BUFFER:NAME}.
        IF cChildTables > '':U THEN
           cChildren = cChildren + ',':U + cChildTables.
      END.
    END. /* Do iRel = 1 to hBuffer:NUM-CHILD-RELATIONS: */
  END.  /* valid hbuffer */
 
  RETURN RIGHT-TRIM(cChildren,","). 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-collectChanges) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION collectChanges Procedure 
FUNCTION collectChanges RETURNS LOGICAL PRIVATE
  ( phChangeDataset AS HANDLE,
    pcTable         AS CHAR,
    pcPrefix        AS CHAR,
    plChildren      AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBuffer   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iRel      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hRelation AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lOk       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lChildOk  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lTrack    AS LOGICAL    NO-UNDO.
  hBuffer  = {fnarg dataTableHandle pcTable}.
  IF VALID-HANDLE(hBuffer) THEN
  DO:
    IF hBuffer:TABLE-HANDLE:TRACKING-CHANGES = TRUE THEN
    DO: 
      hBuffer:TABLE-HANDLE:TRACKING-CHANGES = FALSE. 
      lOk = phChangeDataset:GET-BUFFER-HANDLE(pcPrefix + hBuffer:NAME):GET-CHANGES(hBuffer). 
      hBuffer:TABLE-HANDLE:TRACKING-CHANGES = TRUE.
    END.      
    IF plChildren THEN
    DO iRel = 1 TO hBuffer:NUM-CHILD-RELATIONS:
      hRelation = hBuffer:GET-CHILD-RELATION(iRel).
      IF {fnarg relationType hRelation} BEGINS 'one-':U THEN 
      DO:
        lChildOk = DYNAMIC-FUNCTION("collectChanges" IN TARGET-PROCEDURE,
                                     phChangeDataset,
                                     hRelation:CHILD-BUFFER:NAME,
                                     pcPrefix,
                                     YES). 
        IF NOT lok AND lChildOk THEN
          lOk = TRUE.
      END. /* true child relation */
    END. /* if plchildren then do iRel = 1 to num-child */
  END.

  RETURN lOk.   

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

&IF DEFINED(EXCLUDE-createChangeDataset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createChangeDataset Procedure 
FUNCTION createChangeDataset RETURNS HANDLE
  ( pcDataTable      AS CHAR,
    plSubmitParent   AS LOGICAL,
    plSubmitChildren AS LOGICAL,
    pcChangePrefix   AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose: Create a dataset from the changes  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hChangeDataset AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataset       AS HANDLE     NO-UNDO.

  {get DatasetHandle hDataset}.
    
  CREATE DATASET hChangeDataset.
  hChangeDataset:CREATE-LIKE(hDataSet, pcChangePrefix).
  
  IF pcDataTable = '' OR plSubmitParent THEN
    hChangeDataset:GET-CHANGES(hDataset,plSubmitParent).   
  ELSE
    DYNAMIC-FUNCTION("collectChanges":U IN TARGET-PROCEDURE,
                      hChangeDataset,
                      pcDataTable,
                      pcChangePrefix,
                      plSubmitChildren).  
 
  RETURN hChangeDataset.

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
  
  DEFINE VARIABLE cQueries        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iRel            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cExpressions    AS CHARACTER  NO-UNDO. 
  DEFINE VARIABLE cJoinTables     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRelTable       AS CHARACTER  NO-UNDO.
   
  DEFINE VARIABLE cDataTable AS CHARACTER  NO-UNDO.
  ASSIGN 
    cDataTable  = ENTRY(1,pcTableList)
    cJoinTables = SUBSTR(pcTableList,LENGTH(cDataTable) + 2) 
    hBuffer = {fnarg dataTableHandle cDataTable}.
  IF VALID-HANDLE(hBuffer) THEN 
  DO:
    RUN obtainBufferExpressions IN TARGET-PROCEDURE 
           (hBuffer,
            YES, /* unique relations */
            YES , /* include repos relations */
            NO , /* don't check available */
            INPUT-OUTPUT cJoinTables,
            INPUT-OUTPUT cExpressions).
    cQueries     = 'FOR EACH ':U + hBuffer:NAME.
    
    DO iRel = 1 TO NUM-ENTRIES(cJoinTables):
      ASSIGN 
        cRelTable = ENTRY(iRel,cJoinTables)
        cQueries  = cQueries 
                  + ", EACH ":U
                  + cRelTable
                  + " WHERE ":U
                  + ENTRY(iRel,cExpressions,CHR(1)).     
    END.                          
                        
  END.
  
  /*
  DEFINE VARIABLE iField          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cParentField    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cChildField     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hRelation       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cQuery          AS CHARACTER  NO-UNDO.
  IF VALID-HANDLE(hBuffer) THEN
  DO:
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
  */
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
  IF VALID-HANDLE(hBuffer) THEN
  DO:
    hBuffer:TABLE-HANDLE:TRACKING-CHANGES = FALSE.
    hBuffer:EMPTY-TEMP-TABLE.
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
  /* probably only a problem if dataset is lost */
  IF VALID-HANDLE(hTable) THEN
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

&IF DEFINED(EXCLUDE-isChild) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isChild Procedure 
FUNCTION isChild RETURNS LOGICAL
  ( pcTable AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Returns true if the dataset has a parent relation that is 
           unique and not reposition (which really is a child) 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBuffer        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRelation      AS HANDLE     NO-UNDO.

  hBuffer = {fnarg dataTableHandle pcTable}.
  IF VALID-HANDLE(hBuffer) THEN
  DO:
    hRelation = hBuffer:PARENT-RELATION.
    RETURN VALID-HANDLE(hRelation) 
           AND hRelation:REPOSITION = FALSE 
           AND {fnarg relationType hRelation} BEGINS 'one-':U. 
  END.
  RETURN ?.   

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

   ELSE IF NUM-ENTRIES(pcFields) LT NUM-ENTRIES(cIndexFields) THEN 
     NEXT.

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
           table, but not are true children, with the data that was stored 
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
      IF NOT hRelation:REPOSITION THEN
      DO:
        IF {fnarg relationType hRelation} MATCHES '*-one':U  THEN
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
      END. /* NOT reposition*/
    END. /* Do iRel = 1 to hBuffer:NUM-CHILD-RELATIONS: */
  END.  /* valid hbuffer */

  RETURN TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mergeChangeDataset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION mergeChangeDataset Procedure 
FUNCTION mergeChangeDataset RETURNS LOGICAL
  ( phChangeDataset AS HANDLE,
    plCopyAll       AS LOGICAL  ) :
/*------------------------------------------------------------------------------
  Purpose: Merge the change dataset to the origin if successfully submitted
           or add the change buffers to TableExceptionBuffer for processing later
           if not ( dataset:ERROR ). 
    Notes: The Dataset:ERROR is defined as the Service Adapter API's way to
           signal data errors. It is typically set to true implicitly when 
           save-row-changes errors and is marshalled automatically over 
           the session, but it's the repsonsibility of the Service Adapter
           to ensure that this is set to true to signal a data submit error
           if the service uses different mechanisms, XML or non progress
           etc... It may also be necessary to set this to true explicitly 
           if manual pre trans or transaction processing returns before 
           the actual save is attempted.
        -  All buffers are added to the table property if the dataset:error 
           is true, even if there may be only one buffer with the actual 
           error. 
         - Although there is an error property on the table, we currently rely on 
           record by record processing to find the actual error. The dataview 
           is responsible for record processing and merge of correct records
           and error management.           
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hChangeBuffer  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cBuffer        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iBuffer        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lok            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lMerge         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hDatasetHandle AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lComplete      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cTracking      AS CHARACTER  NO-UNDO.

  lComplete = NOT phChangeDataset:ERROR.
  
  /* if everything is ok, just merge and get rid of the change dataset */
  IF lComplete AND plCopyAll THEN
  DO:
    {get DatasetHandle hDatasetHandle}.
    /* turn off tracking changes before the merge */
    DO iBuffer = 1 TO hDatasetHandle:NUM-BUFFERS:

      hTable = hDatasetHandle:GET-BUFFER-HANDLE(iBuffer):TABLE-HANDLE. 
      IF hTable:TRACKING-CHANGES THEN
        ASSIGN 
          cTracking = cTracking 
                    + (IF cTracking = "":U THEN "":U ELSE ",":U)
                    + STRING(hTable)
          hTable:TRACKING-CHANGES = FALSE.
    END. /* do ibuffer loop num-buffers */
    
    /* Use transaction prevent row-update triggers from firing when record goes out of 
       scope later  */
    DO TRANSACTION:
      phChangeDataset:MERGE-CHANGES(hDatasetHandle,plCopyAll).
    END.

    DO iBuffer = 1 TO NUM-ENTRIES(cTracking):
      hTable = WIDGET-HANDLE(ENTRY(iBuffer,cTracking)).
      
      hTable:TRACKING-CHANGES = TRUE.
    END. /* do ibuffer loop num-entries ctracking */
  END. /* complete (not error) */
  /**/
  ELSE
  DO iBuffer = 1 TO phChangeDataset:NUM-BUFFERS:
    hChangeBuffer = phChangeDataset:GET-BUFFER-HANDLE(iBuffer).    
    IF hChangeBuffer:TABLE-HANDLE:HAS-RECORDS THEN 
    DO:   
      ASSIGN 
        hChangeBuffer = phChangeDataset:GET-BUFFER-HANDLE(iBuffer)
        cBuffer       = hChangeBuffer:TABLE-HANDLE:ORIGIN-HANDLE:NAME
        hBuffer       = {fnarg dataTableHandle cBuffer}. 
      IF VALID-HANDLE(hBuffer) THEN
      DO:
        IF lComplete THEN
        DO TRANSACTION: /* transaction to avoid row-update triggers to fire
                                 when reord goes out of scope later */
          hBuffer:TABLE-HANDLE:TRACKING-CHANGES = FALSE.
          IF VALID-HANDLE(hChangeBuffer:BEFORE-BUFFER)
          AND hChangeBuffer:BEFORE-BUFFER:TABLE-HANDLE:HAS-RECORDS THEN
            hChangeBuffer:MERGE-CHANGES(hBuffer).
          ELSE /* refresh (parent of the changed , for example) */
            hBuffer:TABLE-HANDLE:COPY-TEMP-TABLE(hChangeBuffer:TABLE-HANDLE, NO, YES).
          
          hBuffer:TABLE-HANDLE:TRACKING-CHANGES = TRUE.
        END. /* transaction */
        /* if any error store the buffer to be processed by the dataview
          (we do not trust table:error since it is not propagated if 
           buffer:error is set true in code and no error is thrown ) */
        ELSE
          DYNAMIC-FUNCTION('assignTableExceptionBuffer':U IN TARGET-PROCEDURE,
                            cBuffer, hChangeBuffer).
      END. /* valid buffer */
    END.
    /* Catch deleted rows only. only before record in the changed dataset */
    else  
    if valid-handle(hChangeBuffer:before-buffer)  
    and hChangeBuffer:before-buffer:table-handle:has-records   THEN
    do:
      assign cBuffer = hChangeBuffer:table-handle:origin-handle:name.
      dynamic-function('assignTableExceptionBuffer':U in target-procedure ,
                        cBuffer, hChangeBuffer).
    end.
  end. /* else ibuffer = 1 to dataset:num-buffers */
  
  RETURN lComplete.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-relationFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION relationFields Procedure 
FUNCTION relationFields RETURNS CHARACTER
  ( pcFromTable AS CHAR,
    pcToTable  AS CHAR) :
/*------------------------------------------------------------------------------
   Purpose: Returns relationfields in passed order     
Parameters: pcFromTable - from table 
            pcToTable   - to table   
     Notes: If no relation found in queried order the fields will be attempted
            found in a non-recursive relation in opposite direction. 
 -----------------------------------------------------------------------------*/
  DEFINE VARIABLE hRelation       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lOpposite       AS LOGICAL    NO-UNDO.
  
  hRelation = DYNAMIC-FUNCTION('relationHandle' IN TARGET-PROCEDURE,pcFromTable,pcToTable). 
   
  /* Check if fields can be derived from relation in opposite direction */
  IF NOT VALID-HANDLE(hRelation) THEN 
  DO: 
    hRelation = DYNAMIC-FUNCTION('relationHandle' IN TARGET-PROCEDURE,pcToTable,pcFromTable). 
    /* Cannot derrive opposite from recursive relation as it will point to 
       a different record */ 
    IF NOT VALID-HANDLE(hRelation) OR hRelation:RECURSIVE THEN 
      RETURN ''.
       
    lOpposite = TRUE.     
  END.

  /* We should only get here with valid relations .. but .. */
  IF VALID-HANDLE(hRelation) THEN 
    RETURN DYNAMIC-FUNCTION("relationHandleFields":U IN TARGET-PROCEDURE,
                             hRelation,lOpposite,NO).  
  
  RETURN ''.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-relationHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION relationHandle Procedure 
FUNCTION relationHandle RETURNS HANDLE
        ( pcParent AS CHAR ,
          pcChild AS CHAR ):
/*------------------------------------------------------------------------------
    Purpose: Returns THE relation handle  
    Notes:   This is used to identify a relation in queried order.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataset     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iRelation    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hRelation    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hChildBuffer AS HANDLE     NO-UNDO.
  
  hChildBuffer = {fnarg dataTableHandle pcChild}.
 
  IF NOT VALID-HANDLE(hChildBuffer) THEN
    RETURN ?.

  hRelation = hChildBuffer:PARENT-RELATION.  

  IF VALID-HANDLE(hRelation) AND hRelation:PARENT-BUFFER:NAME = pcParent THEN
    RETURN hRelation.
  
  /* if no parent relation matching for child check for inactive relation */ 
  {get DatasetHandle hDataset}.
  DO iRelation = 1 TO hDataset:NUM-RELATIONS:
    hRelation = hDataset:GET-RELATION(iRelation).
    IF  hRelation:PARENT-BUFFER:NAME = pcParent 
    AND hRelation:CHILD-BUFFER:NAME = pcChild THEN 
      RETURN hRelation.   
  END.
  
  RETURN ?. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-relationHandleFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION relationHandleFields Procedure 
FUNCTION relationHandleFields RETURNS CHARACTER PRIVATE
  ( phRelation   AS HANDLE,
    plChildFirst AS LOGICAL,
    plExpression AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose: Returns a qualified list of the handle's relation fields 
  Paramters: phRelation - relationhandle
             plChildFirst - return child first in paired list  
             plExpression - No - Return as klist
                           Yes - Return as where expression 
 Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRelationFields AS CHARACTER  NO-UNDO. 
  DEFINE VARIABLE hParentField    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hChildField     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cParentField    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cChildField     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParent         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cChild          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iColumn         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cQualFields     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSep1           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSep2           AS CHARACTER  NO-UNDO.
  
  IF NOT VALID-HANDLE(phRelation) THEN 
    RETURN ?. 
  
  ASSIGN 
    cRelationFields = phRelation:RELATION-FIELDS
    cParent         = phRelation:PARENT-BUFFER:NAME
    cChild          = phRelation:CHILD-BUFFER:NAME
    cSep1           = (IF plExpression THEN ' AND ':U ELSE ',') 
    cSep2           = (IF plExpression THEN ' = ':U ELSE ','). 
    
  DO iColumn = 1 TO NUM-ENTRIES(cRelationFields) BY 2:
    ASSIGN 
      cParentField = cParent + '.' + ENTRY(iColumn,cRelationFields)
      cChildField  = cChild  + '.' + ENTRY(iColumn + 1,cRelationFields)                  
      cQualFields = cQualFields
                  + (IF iColumn = 1 THEN '' ELSE cSep1)
                  + (IF plChildFirst THEN cChildField ELSE cParentField) 
                  + cSep2
                  + (IF plChildFirst THEN cParentField ELSE cChildField).
  END.  /* do icolumn loop */

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

RETURN (IF DYNAMIC-FUNCTION('isUniqueID':U IN TARGET-PROCEDURE, 
                            cParentFields, 
                            phRelation:PARENT-BUFFER:NAME) 
        THEN "One":U 
        ELSE "Many":U)
       + "-" +
       (IF DYNAMIC-FUNCTION('isUniqueID':U IN TARGET-PROCEDURE, 
                            cChildFields,
                            phRelation:CHILD-BUFFER:NAME)  
        THEN "One":U 
        ELSE "Many":U).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeTableExceptionBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION removeTableExceptionBuffer Procedure 
FUNCTION removeTableExceptionBuffer RETURNS LOGICAL
  ( pcTable AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBuffer     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iBuffer     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hChgDataset AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lEmpty      AS LOGICAL    NO-UNDO.

  hBuffer = {fnarg TableExceptionBuffer pcTable}.
  IF VALID-HANDLE(hBuffer) THEN
  DO:
    hBuffer:EMPTY-TEMP-TABLE.
    DYNAMIC-FUNCTION('assignTableExceptionBuffer':U IN TARGET-PROCEDURE,
                      pcTable, ?).

    ASSIGN
      hChgDataset = hBuffer:DATASET.
      lEmpty = TRUE.
    
    Bufferloop:
    DO iBuffer = 1 TO hChgDataset:NUM-BUFFERS:
      ASSIGN
        hBuffer   = hChgDataset:GET-BUFFER-HANDLE(iBuffer).
        IF hBuffer:TABLE-HANDLE:HAS-RECORDS THEN
        DO:
          lEmpty = FALSE.
          LEAVE bufferloop.
        END.
    END.
    IF lEmpty THEN 
      DELETE OBJECT hChgDataset.
  END.

  RETURN lEmpty. 

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
        -  DataView QuetyTables gets its default value from this.            
 ------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataset        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRelation       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cTables         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSortTables     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iRel            AS INTEGER    NO-UNDO.

  hBuffer = {fnarg dataTableHandle pcTable}.
  IF VALID-HANDLE(hbuffer) THEN
  DO:
    cTables = pcTable.
    DO iRel = 1 TO hBuffer:NUM-CHILD-RELATIONS:
      hRelation = hBuffer:GET-CHILD-RELATION(iRel).
      IF {fnarg relationType hRelation} MATCHES '*-one' THEN
      DO:
        cSortTables = {fnarg sortTables hRelation:CHILD-BUFFER:NAME}.
        IF cSortTables > '' THEN 
          cTables = cTables + "," + cSortTables.
                  
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
  Purpose: Store away and empty the tables that are retrieved together with the 
           passed table and may conflict with existing data because they have 
           a many-to-one or one-to-one relationship.   
Parameter: pcTable - table name              
    Notes: Use when a new batch is to be appended to an existing batch        
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
      IF NOT hRelation:REPOSITION THEN
      DO:
        IF hRelation:CHILD-BUFFER:TABLE-HANDLE:HAS-RECORDS 
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
      END.
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

&IF DEFINED(EXCLUDE-tableExceptionBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION tableExceptionBuffer Procedure 
FUNCTION tableExceptionBuffer RETURNS HANDLE
  ( pcTable AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the buffer that has the failed changes frm previous submit.
    Notes:  
------------------------------------------------------------------------------*/
  RETURN WIDGET-HANDLE(getTableProperty(TARGET-PROCEDURE,pcTable,'ErrorBuffer':U)).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tableFetchTree) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION tableFetchTree Procedure 
FUNCTION tableFetchTree RETURNS CHARACTER
        ( pcTable as CHAR ):
/*------------------------------------------------------------------------------
    Purpose: Return fetched by info for tables that also need to 
             do their own retrieval.      
    Notes:   This is set in the case where a child that needs to handle 
             its own retrieval was retrieved by the parent. 
             The dataAvaialble can then avoid going to the server  
             when the current tree-position matches the retrieved tree.            
------------------------------------------------------------------------------*/
  define variable cFetchTree as character no-undo.
  cFetchTree = getTableProperty(TARGET-PROCEDURE,pcTable,'FetchTree':U).
  /* both adm and table prop currently uses chr(1)  */
  if cFetchTree > '' then  
    return replace(cFetchTree,chr(2),chr(1)).
  return ''. 
end function.

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

&IF DEFINED(EXCLUDE-undoRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION undoRow Procedure 
FUNCTION undoRow RETURNS LOGICAL
  ( pcTable     AS CHAR,
    pcKeyWhere  AS CHAR,
    plUndoCreate as LOG) :
/*------------------------------------------------------------------------------
   Purpose:  undo a datatable row    
Parameters:  pcTable      - DataTable 
             pcKeyWhere   - expression uniquely identifying the record 
             plUndoCreate - Yes - undo create
                            No  - undo changes in new  
    Notes:   Called from undoRow of the dataview   
------------------------------------------------------------------------------*/
  define variable hBuffer as handle no-undo.
  define variable hbefore as handle no-undo.
  define variable rRowid  as rowid  no-undo.
   
  hBuffer = {fnarg dataTableHandle pcTable}.
  if valid-handle(hBuffer) then 
  do:
    hBuffer:find-unique('WHERE ':U + pcKeyWhere) no-error.
    if hBuffer:available and hBuffer:before-rowid <> ? then 
    do:
      hBuffer:before-buffer:find-by-rowid(hBuffer:before-rowid).
      /* a normal ADM2 undo will pass NO to this and only roll back changes 
         in a new record */
      if not plUndoCreate and hBuffer:row-state = row-created then 
        hBuffer:buffer-copy(hBuffer:before-buffer). 
      else do:
        rRowid = hBuffer:ROWID.
        hBefore = hBuffer:before-buffer.
        hBefore:find-by-rowid(hBuffer:before-rowid).   
        /* NOTE : if we add this property then we need set tracking changes 
                  false in updatewRow's call to this 
        if getFireTriggerOnUndo then
        DO TRANSACTION:
          hBuffer:buffer-copy(hBefore).
        END.
        */    
        hBuffer:table-handle:tracking-changes = false.
        /* the transaction here is probably not necessary, but core issues used 
           to cause row level trigger to fire at weird places unless wrapped in
           transaction  */ 
        do transaction:
          hBuffer:before-buffer:reject-row-changes().
        end.
        hBuffer:table-handle:tracking-changes = true.
        hBuffer:find-by-rowid(rRowid) no-error. 
      end.
      return true.
    end.   
  end. /* if valid-handle(hBuffer)*/  
  RETURN false.

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
                               hCol:name, 
                               hBuffer:name).
    
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
          lSuccess = false.
          hBuffer:BUFFER-validate() NO-ERROR.
          lSuccess = true.
        END.
        
        /* Add the error */
        IF NOT lSuccess THEN
        DO:
          /* Add the update cancelled message */
      
          RUN addMessage IN TARGET-PROCEDURE({fnarg messageNumber 15},?,?).
          RUN addMessage IN TARGET-PROCEDURE 
                         (?,
                          ?,
                          hBuffer:name).
          UNDO. /* undo all changes (or we'll get the ABL error again when 
                   the transaction ends) */
        END.
      END. /* success */
    END. /* transaction if record found */
    /* Add row-updated trigger error */
    IF lsuccess and hBuffer:error or error-status:error THEN
    do: 
      /* Add the update cancelled message, unless messages already present  */
      IF NOT {fn anyMessage} THEN 
        RUN addMessage IN TARGET-PROCEDURE({fnarg messageNumber 15},?,?). 
      
      RUN addMessage IN target-procedure(if hBuffer:error-string = '' 
                                         then ? 
                                         else hBuffer:error-string,
                                         ?,hBuffer:name).
                                         
      /* if we add support to call row level triggers from undo then we need 
         to disable it from here as follows:  
         hBuffer:table-handle:tracking-changes =false.*/
      dynamic-function('undoRow':U in target-procedure,
                       pcTable,pcKeyWhere,NO /* only undo changes in create*/).
      /* hBuffer:table-handle:tracking-changes =true. */
      lSuccess = false.
    end.
  end. /* if valid-hanlde(hBuffer)*/  
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

