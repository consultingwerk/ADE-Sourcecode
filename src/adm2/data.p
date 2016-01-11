&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/**********************************************************************************/
/* Copyright (C) 2005-2006 by Progress Software Corporation. All rights reserved. */
/* Prior versions of this work may contain portions contributed by            */
/* participants of Possenet.                                                  */             
/**********************************************************************************/

/*--------------------------------------------------------------------------
    File        : data.p
    Purpose     : Super Procedure for all SmartDataObjects
    Syntax      : adm2/data.p
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
 
/* Tell dataprop.i that this is the Super procedure. */
   &SCOP ADMSuper data.p
   
  {src/adm2/custom/dataexclcustom.i}
  
  DEFINE VARIABLE ghCacheManager AS HANDLE     NO-UNDO.

  DEFINE VARIABLE glShowMessageAnswer AS LOGICAL NO-UNDO. /* used in showMessage */
  
  /* This variable is needed at least temporarily so that a called
    fn can tell who the actual source was. */
  DEFINE VARIABLE ghTargetProcedure AS HANDLE     NO-UNDO.

  /* This AddStartRow number, is used as a global sequence for new records, 
   This may very well change in a future release. */
&SCOP  xiAddStartRow 9000000 /* high # for new rows*/
  DEFINE VARIABLE giAddRowNum  AS INTEGER NO-UNDO 
    INIT {&xiAddStartRow}. /* tmp row num for add */

  /* Include the file which defines AppServerConnect procedures. */
  {adecomm/appserv.i}
  {src/adm2/schemai.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-addRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addRow Procedure 
FUNCTION addRow RETURNS CHARACTER
  ( pcViewColList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-applyContextFromClient) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD applyContextFromClient Procedure 
FUNCTION applyContextFromClient RETURNS LOGICAL
  ( pcContext AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-applyContextFromServer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD applyContextFromServer Procedure 
FUNCTION applyContextFromServer RETURNS LOGICAL
  ( pcContext AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-batchRowAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD batchRowAvailable Procedure 
FUNCTION batchRowAvailable RETURNS LOGICAL
  ( pcMode AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cancelRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD cancelRow Procedure 
FUNCTION cancelRow RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-canNavigate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD canNavigate Procedure 
FUNCTION canNavigate RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-closeQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD closeQuery Procedure 
FUNCTION closeQuery RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-commit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD commit Procedure 
FUNCTION commit RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-copyRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD copyRow Procedure 
FUNCTION copyRow RETURNS CHARACTER
  ( pcViewColList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createRow Procedure 
FUNCTION createRow RETURNS LOGICAL
  (pcValueList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createRowObjectTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createRowObjectTable Procedure 
FUNCTION createRowObjectTable RETURNS LOGICAL
  () FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createRowObjUpdTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createRowObjUpdTable Procedure 
FUNCTION createRowObjUpdTable RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataContainerHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD dataContainerHandle Procedure 
FUNCTION dataContainerHandle RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataQueryStringFromQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD dataQueryStringFromQuery Procedure 
FUNCTION dataQueryStringFromQuery RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-defineTempTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD defineTempTables Procedure 
FUNCTION defineTempTables RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD deleteRow Procedure 
FUNCTION deleteRow RETURNS LOGICAL
  ( pcRowIdent AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-emptyRowObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD emptyRowObject Procedure 
FUNCTION emptyRowObject RETURNS LOGICAL
  (pcMode AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fetchRow Procedure 
FUNCTION fetchRow RETURNS CHARACTER
  (piRow AS INTEGER, pcViewColList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchRowIdent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fetchRowIdent Procedure 
FUNCTION fetchRowIdent RETURNS CHARACTER
  (pcRowIdent AS CHARACTER, pcViewColList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchRowWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fetchRowWhere Procedure 
FUNCTION fetchRowWhere RETURNS LOGICAL
  ( pcQueryString AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findRowFromObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findRowFromObject Procedure 
FUNCTION findRowFromObject RETURNS LOGICAL
  ( pcColumns AS CHAR,
    pcValColumns AS CHAR,
    phObject AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findRowObjectUseRowIdent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findRowObjectUseRowIdent Procedure 
FUNCTION findRowObjectUseRowIdent RETURNS LOGICAL
  ( pcRowident AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findRowObjectWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findRowObjectWhere Procedure 
FUNCTION findRowObjectWhere RETURNS LOGICAL
  (pcColumns     AS CHARACTER,   
   pcValues      AS CHARACTER,    
   pcOperators   AS CHARACTER,
   pcMode        AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findRowObjUpd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findRowObjUpd Procedure 
FUNCTION findRowObjUpd RETURNS LOGICAL
  ( phRowObject AS HANDLE,
    phRowObjUpd AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findRowWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findRowWhere Procedure 
FUNCTION findRowWhere RETURNS LOGICAL
  (pcColumns     AS CHARACTER,   
   pcValues      AS CHARACTER,    
   pcOperators   AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-firstRowIds) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD firstRowIds Procedure 
FUNCTION firstRowIds RETURNS CHARACTER
 (pcQueryString AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getManagerHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getManagerHandle Procedure 
FUNCTION getManagerHandle RETURNS HANDLE
  ( pcManager AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTargetProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTargetProcedure Procedure 
FUNCTION getTargetProcedure RETURNS HANDLE
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hasActiveAudit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD hasActiveAudit Procedure 
FUNCTION hasActiveAudit RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hasActiveComments) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD hasActiveComments Procedure 
FUNCTION hasActiveComments RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hasForeignKeyChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD hasForeignKeyChanged Procedure 
FUNCTION hasForeignKeyChanged RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hasOneToOneTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD hasOneToOneTarget Procedure 
FUNCTION hasOneToOneTarget RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeFromCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initializeFromCache Procedure 
FUNCTION initializeFromCache RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isDataQueryComplete) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isDataQueryComplete Procedure 
FUNCTION isDataQueryComplete RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newDataQueryExpression) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD newDataQueryExpression Procedure 
FUNCTION newDataQueryExpression RETURNS CHARACTER
  (pcColumns     AS CHARACTER,   
   pcValues      AS CHARACTER,    
   pcOperators   AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newDataQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD newDataQueryString Procedure 
FUNCTION newDataQueryString RETURNS CHARACTER
  (pcColumns     AS CHARACTER,   
   pcValues      AS CHARACTER,    
   pcOperators   AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newRowObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD newRowObject Procedure 
FUNCTION newRowObject RETURNS LOGICAL
  (pcMode AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainContextForClient) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD obtainContextForClient Procedure 
FUNCTION obtainContextForClient RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainContextForServer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD obtainContextForServer Procedure 
FUNCTION obtainContextForServer RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-openDataQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD openDataQuery Procedure 
FUNCTION openDataQuery RETURNS LOGICAL
  (pcPosition AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-openFromCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD openFromCache Procedure 
FUNCTION openFromCache RETURNS LOGICAL PRIVATE
  ( pcCacheKey AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-openQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD openQuery Procedure 
FUNCTION openQuery RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareColumnsFromRepos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD prepareColumnsFromRepos Procedure 
FUNCTION prepareColumnsFromRepos RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareForFetch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD prepareForFetch Procedure 
FUNCTION prepareForFetch RETURNS CHARACTER
  ( pcOptions AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareRowObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD prepareRowObject Procedure 
FUNCTION prepareRowObject RETURNS LOGICAL
  ( phTable AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-receiveData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD receiveData Procedure 
FUNCTION receiveData RETURNS LOGICAL
  ( phTable AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-refreshQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD refreshQuery Procedure 
FUNCTION refreshQuery RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeQuerySelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD removeQuerySelection Procedure 
FUNCTION removeQuerySelection RETURNS LOGICAL
  (pcColumns   AS CHARACTER,
   pcOperators AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-repositionRowObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD repositionRowObject Procedure 
FUNCTION repositionRowObject RETURNS LOGICAL
   ( pcRowIdent AS CHARACTER ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD resetRow Procedure 
FUNCTION resetRow RETURNS LOGICAL
  ( pcRowident AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resortQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD resortQuery Procedure 
FUNCTION resortQuery RETURNS LOGICAL
  ( pcSort AS CHARACTER  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-retrieveBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD retrieveBatch Procedure 
FUNCTION retrieveBatch RETURNS LOGICAL
  ( pcMode AS CHAR,
    piNumRows AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-submitRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD submitRow Procedure 
FUNCTION submitRow RETURNS LOGICAL
  ( pcRowIdent AS CHARACTER, pcValueList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-undoRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD undoRow Procedure 
FUNCTION undoRow RETURNS LOGICAL
  ( pcRowident AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD updateRow Procedure 
FUNCTION updateRow RETURNS LOGICAL
  (pcKeyValues AS CHAR,
   pcValueList AS CHAR)  FORWARD.

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
         HEIGHT             = 13.86
         WIDTH              = 55.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/dataprop.i}
{src/adm2/cache.p}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

ghCacheManager = {fnarg getManagerHandle 'CacheManager':U}.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-beginTransactionValidate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beginTransactionValidate Procedure 
PROCEDURE beginTransactionValidate :
/*------------------------------------------------------------------------------
  Purpose: Validation hook for code to be executed immediately after the 
           transaction has started before the updates is done. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  RUN bufferTransactionValidate IN TARGET-PROCEDURE ('begin':U). 

  RETURN RETURN-VALUE.  
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-clientSendRows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clientSendRows Procedure 
PROCEDURE clientSendRows :
/*------------------------------------------------------------------------------
  Purpose:     Calls across the AppServer boundary to serverSendRows to fetch
               a batch of RowObject temp-table records.  When the 
               SmartDataObject is split between client and AppServer, 
               this client-side procedure is run from the generic sendRows 
               procedure.  It simply turns around and runs a server-side 
               version which returns the RowObject temp-table records.

  Parameters:  
    INPUT  piStartRow     - The RowNum value of the record to start the batch
                            to return.  Typically piStartRow is ? as a flag to 
                            use pcRowIdent instead of piStartRow.
    INPUT  pcRowIdent     - The RowIdent of the first record of the batch to
                            to return.  Can also be "FIRST" or "LAST" to force
                            the retrieval of the first (or last) batch of 
                            RowObject records.
    INPUT  plNext         - True if serverSendRows is to start on the "next"
                            record from what is indicated by piStartRow or
                            piRowIdent.
    INPUT  piRowsToReturn - The number of rows in a batch.
    OUTPUT piRowsReturned - The actual number of rows returned. This number
                            will either be the same as piRowsToReturn or
                            less when there are not enough records to fill
                            up the batch.
  
  Notes:       All of the parameters are simply received from the caller and
               passed through to serverSendRows on the AppServer.
               If piStartRow is not 0 or ? then pcRowIdent is ignored.
               plNext is ignored if pcRowIdent is "FIRST" or "LAST".
               The most common use of piRowsReturned is to indicate that the
               entire result list has been returned when it is less than 
               piRowToReturn.
               In 9.1B, we are prepared to run in our Container's ASHandle
               if we are in an SBO.
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER piStartRow     AS INTEGER   NO-UNDO.
 DEFINE INPUT  PARAMETER pcRowIdent     AS CHARACTER NO-UNDO.
 DEFINE INPUT  PARAMETER plNext         AS LOGICAL   NO-UNDO.
 DEFINE INPUT  PARAMETER piRowsToReturn AS INTEGER   NO-UNDO.
 DEFINE OUTPUT PARAMETER piRowsReturned AS INTEGER   NO-UNDO.
 
 DEFINE VARIABLE hAppServer      AS HANDLE            NO-UNDO.
 DEFINE VARIABLE hDataQuery      AS HANDLE            NO-UNDO.
 DEFINE VARIABLE hRowNum         AS HANDLE            NO-UNDO.
 DEFINE VARIABLE hRowIdent       AS HANDLE            NO-UNDO.
 DEFINE VARIABLE hRowObject      AS HANDLE            NO-UNDO.
 DEFINE VARIABLE lAdded          AS LOGICAL           NO-UNDO INIT TRUE.
 DEFINE VARIABLE nextPosition    AS ROWID             NO-UNDO.
 DEFINE VARIABLE cLastResult     AS CHARACTER         NO-UNDO.
 DEFINE VARIABLE cOperatingMode  AS CHARACTER         NO-UNDO.
 DEFINE VARIABLE lInitRowObject  AS LOGICAL           NO-UNDO.
 DEFINE VARIABLE hDataContainer  AS HANDLE            NO-UNDO.
 DEFINE VARIABLE cObjectName     AS CHARACTER         NO-UNDO.
 DEFINE VARIABLE cAsDivision     AS CHARACTER         NO-UNDO.
 DEFINE VARIABLE hRowObjectTbl   AS HANDLE            NO-UNDO.
 DEFINE VARIABLE hAppService     AS HANDLE            NO-UNDO.
 DEFINE VARIABLE cServerFileName AS CHARACTER         NO-UNDO.
 DEFINE VARIABLE cContext        AS CHARACTER         NO-UNDO.
 DEFINE VARIABLE cError          AS CHARACTER         NO-UNDO.
 DEFINE VARIABLE cPositionForClient  AS CHARACTER     NO-UNDO.
 DEFINE VARIABLE cLogicalName    AS CHARACTER         NO-UNDO.

  {get DataHandle hDataQuery}.
  IF VALID-HANDLE(hDataQuery) THEN 
    hRowObject = hDataQuery:GET-BUFFER-HANDLE(1).
 
  {get serverOperatingMode cOperatingMode}.                     
  IF piStartRow = ? OR piStartRow = 0 THEN 
  DO:
    /* If the query is already open then we need to get last in order to 
       save the rowid of the last RowObject in the batch so that we can 
       reposition appropriately after retrieving another batch below. */
    IF VALID-HANDLE(hDataQuery) AND hDataQuery:IS-OPEN THEN 
    DO:
      hDataQuery:GET-LAST().
      IF hRowObject:AVAILABLE THEN 
      DO:
        hRowNum = hRowObject:BUFFER-FIELD('RowNum':U).
          /* If the last record has a row number that is greater than
             {&xiAddStartRow} then this is a newly added record and not part 
             of the batch that was retrieved so we do not want to save off
             this rowid. We want to keep getting previous records until
             we get to the rowid of the last RowObject in the last batch 
             that was retrieved - that is the rowid we want to save off.  */  
        DO WHILE lAdded:
          /* The xiAddStartRow preprocessor is used to set the row number 
             for newly added records, 
           - we don't want to make this a property because using row number
             like this will likely change in a future release */
          IF hRowNum:BUFFER-VALUE > {&xiAddStartRow} THEN
          DO:
            hDataQuery:GET-PREV().
            /* If only new rows, we might end up at the top.  */
            IF hRowObject:AVAILABLE = FALSE THEN
              LEAVE. 
          END.
          ELSE lAdded = FALSE.
        END.  /* Do while lAdded */
        nextPosition = hRowObject:ROWID.
        
        /* If we are running stateless we need to re-assign the LastResultRow
           to be the RowNum and RowIdent of the RowObject record which is the 
           last record of the batch (excluding newly added records).  This is
           to handle cases where the last row in the batch may have been 
           deleted.  LastResultRow is used in sendRows (when fetchNext is done) 
           to determine which record to start at when retrieving records for 
           the next batch.  */
        IF cOperatingMode = "STATELESS":U AND hRowObject:AVAILABLE THEN 
        DO:                    
          ASSIGN hRowIdent   = hRowObject:BUFFER-FIELD('RowIdent':U)
                 cLastResult = hRowNum:BUFFER-VALUE + ";":U + hRowIdent:BUFFER-VALUE. 
          {set LastResultRow cLastResult}.                                            
        END.  /* If Stateless */
      END.  /* If hRowObject Available */
    END.  /* If Query is open */
  END.  /* If piStartRow = ? or 0 */
 
  /* Check if the TT is undefined (dynamically defined objects on a client will 
     get the defs from server) */
  {get RowObjectTable hRowObjectTbl}. /* get handle to pass to server call */
  lInitRowObject = NOT VALID-HANDLE(hRowObjectTbl).
  
  /* fetchContainedRows does not handle first-time dynamic calls, so don't 
     check datacontainerhandle if the temp-table is not defined 
    (This would happen if findRowWhere or fetchRowident is called from 
     initializeObject in a dynamic SDO) */ 
  IF NOT lInitRowObject THEN
    hDataContainer = {fn dataContainerHandle}.
  
  /* Only returned from server when not unknown - could have previous vslue*/
  {set PositionForClient ?}.
 
  /* If this object is in a container with its own AppServer Handle,
     then we run fetchContainedRows in that in order to retrieve this objects
     data together with all child objects data. */
  IF VALID-HANDLE(hDataContainer)  THEN
  DO:
    {get ObjectName cObjectName}.
    RUN fetchContainedRows IN hDataContainer 
        (cObjectName, 
         piStartRow, 
         pcRowIdent, 
         plNext, 
         piRowsToReturn, 
         OUTPUT piRowsReturned).
  END.  /* if valid DataContaine */
  ELSE DO:  
    
    /* Checks AppServer properties to see if the object has no current or future 
       server bindings and is using a stateless operating mode.*/    
    IF {fn hasNoServerBinding} THEN
    DO:
      RUN connectServer IN TARGET-PROCEDURE (OUTPUT hAppService). 
      IF hAppService  = ? THEN
         RETURN ERROR 'ADM-ERROR':U.

      &SCOPED-DEFINE xp-assign
      {get LogicalObjectName cLogicalName}
      {get ServerFileName cServerFileName}
       .
      &UNDEFINE xp-assign
      
      cContext = {fn obtainContextForServer}.
      RUN adm2/sendrows.p ON hAppService
                         (cServerFileName 
                          + (IF cLogicalname > '' THEN ':' + cLogicalName ELSE ''),
                          INPUT-OUTPUT cContext,
                          piStartRow, 
                          pcRowIdent, 
                          plNext, 
                          piRowsToReturn, 
                          OUTPUT piRowsReturned, 
                          OUTPUT TABLE-HANDLE hRowObjectTbl APPEND,
                          OUTPUT cError). /* Errors not used yet */
      {fnarg applyContextFromServer cContext}.
    END.
    ELSE DO:
      {get ASHandle hAppServer}. /* use our own ASHandle. */   
      IF VALID-HANDLE(hAppServer) THEN 
      DO:
      /* New to 9.1B: get the handle of the RowObject table itself to receive
         the temp-table from the server. If this is already defined, then
         either this is a static SDO, or it is a dynamic one which has already
         been initialized by going through this code. If not, then simply
         receive the temp-table into the handle, and set the corresponding
         SDO properties now. */
        cContext = {fn obtainContextForServer}.
        RUN remoteSendRows IN hAppServer 
            (INPUT-OUTPUT cContext,
             piStartRow, 
             pcRowIdent, 
             plNext, 
             piRowsToReturn, 
             OUTPUT piRowsReturned, 
             OUTPUT TABLE-HANDLE hRowObjectTbl APPEND,
             OUTPUT cError).
        {fnarg applyContextFromServer cContext}.      
      END. /* if valid-handle(happserver)*/
      RUN endClientDataRequest IN TARGET-PROCEDURE.
    END. /* else (AsBound or stataware etc... )*/
    /* If the RowObject table handle wasn't init'd yet, we set its property 
       to the table handle we got back and also create the RowObjUpdTable,
       if it is undefined  */    
    IF lInitRowObject THEN 
      {set RowObjectTable hRowObjectTbl}.
  END. /* not client sbo  */

  {fnarg openDataQuery '':U}.  
  IF pcRowident = "FIRST":U THEN
    hDataQuery:GET-FIRST.
  
  ELSE IF pcRowident = "LAST":U THEN
    hDataQuery:GET-LAST.

  ELSE DO: 
    {get PositionForClient cPositionForClient}.
    IF cPositionForClient > "":U THEN
    DO:
      {fnarg findRowObjectUseRowident cPositionForClient}.
      {set PositionForClient ?}.
    END.   
  END.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-commitTransaction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE commitTransaction Procedure 
PROCEDURE commitTransaction :
/*------------------------------------------------------------------------------
  Purpose:     This event procedure receives the Commit "command" from a
               Commit panel or other Commit-Source. It then invokes the Commit
               function to actually commit the changes.  After the commit
               function finishes, commitTransaction handles any error messages 
               by calling showDataMessages.
 
  Parameters:  <none>
 
  Notes:       A transaction block is opened in serverCommit (called by the
               commit function) only if the SDO is running C/S.  That is no
               transaction block occurs occurs on the client side of a split
               SDO.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lSuccess       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hSource        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lCancel        AS LOGICAL    NO-UNDO.
  
  /* reset return-value */
  IF RETURN-VALUE > "" THEN
    RUN returnNothing IN TARGET-PROCEDURE.

  /* If they have made record changes they haven't saved, they must
     do that before they Commit. Make this check if it came from the
     Commit Panel, but skip if it came locally or from an SBO */
  {get CommitSource hSource}.
  IF hSource = SOURCE-PROCEDURE THEN
  DO:
     /* Visual dataTargets subscribes to this */
    PUBLISH 'confirmCommit':U FROM TARGET-PROCEDURE (INPUT-OUTPUT lCancel).
    IF lCancel THEN RETURN 'ADM-ERROR':U.
  END.    /* END IF hSource  */
  
  /* Continue only if no unsaved changes. */
  lSuccess = {fn Commit}. 

  /* IF no errors, signal to Commit Panel to disable itself again. */
  IF lSuccess THEN 
    {set RowObjectState 'NoUpdates':U}.
  ELSE DO:
    IF hSource = SOURCE-PROCEDURE THEN  /* coming from commit panel */
    DO:
        DEFINE VARIABLE cSource AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE cDummy AS CHARACTER  NO-UNDO.
          /* If there were errors, get the Update-Source to deal with them. */
        {get UpdateSource cSource}. 
        hSource = widget-handle(entry(1,cSource)).

        IF VALID-HANDLE (hSource) THEN      
          RUN showDataMessagesProcedure IN hSource (OUTPUT cDummy) .
    END.

    RETURN "ADM-ERROR":U.               /* Signal error to caller. */
  END.  /* END ELSE DO IF Not lSuccess */
  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-connectServer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE connectServer Procedure 
PROCEDURE connectServer :
/*------------------------------------------------------------------------------
  Purpose:     Override to show potential error message   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER phAppService AS HANDLE   NO-UNDO.

  DEFINE VARIABLE cMsg AS CHARACTER  NO-UNDO.

  RUN SUPER (OUTPUT phAppService) NO-ERROR.
  
  DEFINE VARIABLE i AS INTEGER    NO-UNDO.
  
  /* Handles only one message, which is sufficent with the current appserver 
     class */
  IF {fn anyMessage} THEN
  DO:
    /* let commit do its own message (error if run showmesage in function) */
    DO i = 1 TO 5:
      IF PROGRAM-NAME(i) BEGINS 'commit ':U THEN
         RETURN ERROR 'ADM-ERROR':U.
    END.  

    cMsg = ENTRY(1,{fn fetchMessages},CHR(4)).
     /*{fnarg showMessage cMsg}. */
    RUN showMessageProcedure IN TARGET-PROCEDURE(cMsg,OUTPUT cMsg). 
    RETURN ERROR 'ADM-ERROR':U.

  END.
  ELSE IF ERROR-STATUS:ERROR THEN
    RETURN ERROR RETURN-VALUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createObjects Procedure 
PROCEDURE createObjects :
/*------------------------------------------------------------------------------
  Purpose:    Define the temp-tables for a dynamic SDO   
  Parameters:  <none>
  Notes:      This is in createObjects because this is the common API that
              should be used to realize objects for design time use.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cBindScope           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainer           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cAsdivision          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCalculatedColumns   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hLogicObject         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lDefined             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lDynamicData         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lInitialized         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cBufferHandles       AS CHARACTER  NO-UNDO.
  &SCOPED-DEFINE xp-assign
  {get AsDivision cAsDivision}
  {get DynamicData lDynamicData}
  {get ObjectInitialized lInitialized}
  .
  &UNDEFINE xp-assign
  
  IF lInitialized THEN
    RETURN.

  /* If client and OpenOnInit then we will get the table from the server */
  IF cAsDivision = 'CLIENT':U THEN 
  DO:
    /* If we have no logic procedure or repository manger, calculatedcolumns 
       cannot be defined on the client. We call the server here if stand-alone 
       design-mode or RETURN if runtime or inside a container */ 
    {get DataLogicObject hLogicObject}.    
    IF  NOT VALID-HANDLE(hLogicObject) 
    AND NOT VALID-HANDLE(gshRepositoryManager) THEN
    DO:
      {get CalculatedColumns cCalculatedColumns}.
      IF cCalculatedColumns > '':U THEN
      DO:
       /* In design mode where the SDO is running standalone we need to 
          get the definitions here. We use BindScope <> 'data' to identify 
          that createobjects is called directly and not from initializeObject. 
          If we are in a container we the SBO's createObjects handles this.
         (initializeObject will call fetchDefinitions for non-container runtime 
          cases) */
        {get BindScope cBindScope}.
        {get ContainerSource hContainer}.
        IF cBindScope <> 'Data':U  AND NOT VALID-HANDLE(hContainer) THEN 
        DO:
          RUN fetchDefinitions IN TARGET-PROCEDURE NO-ERROR.
          IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
            RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
        END.
        ELSE 
          RETURN.
      END. /* calculated columns */
    END. /* no repos manager or logic procedure  */
  END. /* AsDivison = 'CLIENT' */
  ELSE DO: /* db connected, create buffers queries etc..*/
    RUN SUPER.
    /* the check below exists purely to avoid more error messages on the connected 
       client if the buffer creation failed. This is not very elegant error 
       handling, but low risk as it piggy backs on the fact that the SDO 
       already handles error from here with repository failure of any kind. 
      - the dynamic data check is because static sdos behaves very different 
        with these kind of errors (typcially db connection issues) )
        and have not been tested for possible cases that might end up 
        finding an error here. (if they even exist) */
    if lDynamicData and cAsDivision <> "Server" then 
    do:
       {get BufferHandles cBufferHandles}.
       if cBufferHandles = ? or cBufferHandles = "" then  
          RETURN ERROR "ADM-ERROR".  
    end.
  END.
   
  /* Dynamic */
  IF lDynamicData THEN  
    lDefined = {fn createRowObjectTable}.    
  ELSE IF VALID-HANDLE(gshRepositoryManager) THEN
    lDefined = {fn prepareColumnsFromRepos}.
  ELSE   
    lDefined = TRUE.

  IF NOT lDefined THEN
    RETURN ERROR 'ADM-ERROR'.
   
  RETURN. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataAvailable Procedure 
PROCEDURE dataAvailable :
/*------------------------------------------------------------------------------
  Purpose:  Event procedure that handles change of dataSource data or record 
            position or change of this object's data or record position by 
            assigning new ForeignFields values and reopen the query, resetting 
            QueryPosition and republish the event.   
  Parameters:
    INPUT pcRelative - A flag to indicate something about the "new" or "changed"
                       current record.                                       
      SAME          - do nothing .. simply RETURN, because the new record is the 
                      same as the current record.                            
      RESET         - Request to reset statuses and foreignfields and refresh
                      visual objects and panels in all objects in the data-link 
                      chain. This was introduced in 9.1C because in some cases 
                      'same' does too little and 'different' too much. 
                      It achieves the same as 'different' except that queries 
                      will NOT be reopened.   
      VALUE-CHANGED - dataTarget changed position, 
                      Ensure that the query is not reopened here, but publish 
                      as 'different' from here, so this objects data targets  
                      will be opened.
      DIFFERENT     - Request to reapply foreign Fields.  
                     (except if called from a dataTarget where it is treated as 
                     'VALUE-CHANGED')   
      ?             - Workaround used to apply Foreign Fields when caller not 
                      was dataSource. This is kept for backwards compatibility 
                      as 'DIFFERENT' now does the same.        
   -------                    
      FIRST         - as 'different'
      NEXT          - as 'different'
      PREV          - as 'different'
      LAST          - as 'different'
      REPOSITIONED  - as 'different'
                                        
  Notes: - From 9.1C the dataTarget will pass 'VALUE-CHANGED' to indicate
           a change that don't need to reapply foreign fields. 
              
         - This makes dataAvailable self-contained as there is no longer a 
           need to check who the source is. This was done to add support for 
           SBOs as dataSources.  
           
        -  However, we still check the source to support backwards compatibility,
           and deal with data-targets passing 'different' and treat this case 
           as 'VALUE-CHANGED'.  
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcRelative AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cForeignFields    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataTarget       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lInitted          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cRowObjectState   AS CHARACTER  NO-UNDO. 
  DEFINE VARIABLE hContainer        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lOpenOnInit       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cSourceFields     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLocalFields      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValues           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataSource       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iField            AS INTEGER    NO-UNDO.      
  DEFINE VARIABLE hRowObject        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cASDivision       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lFound            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cNewBatchInfo     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lOneToOne         AS LOGICAL    NO-UNDO.

  {get ObjectInitialized lInitted}.
  /* Ignore if we haven't been initialized yet; also, 
     if for some reason this object is in addmode.
    (Called from cancelRow in the first of two SDOs in SBOs for example) 
     updated row (pcRelative = 'SAME') requires no reset.*/
  IF (NOT lInitted) OR (pcRelative = "SAME":U) THEN 
    RETURN.  
  
  /* 10.1C home and end logic might tur off DataIsFetched, which used 
     to protect from rrequesting again after datacontainer retrieval.  */
  if pcRelative = 'first':U or pcRelative = 'last':U then 
    pcRelative = 'reset':U.

  /* For backwards Compatibility we still deal with 'different' calls 
     from DataTargets as a request to NOT reapply ForeignFields. */
  IF pcRelative = 'DIFFERENT':U THEN 
  DO:
    {get DataTarget cDataTarget}.
    IF CAN-DO(cDataTarget,STRING(SOURCE-PROCEDURE)) THEN
       pcRelative = 'VALUE-CHANGED':U.
  END.
  ELSE IF pcRelative = ? THEN
    pcRelative = 'DIFFERENT':U. 
     /* if 'RESET' and no uncommitted changes and foreignkeys has changed
     then change to 'different' */
  ELSE IF pcRelative = 'RESET':U THEN
  DO:
    /* If the originator of the publish is a DataContainer during 
       initialization and this Object has OpenOnInit false we must 
       keep 'reset' to avoid an attempt to open the query 
       (the hasForeignKey check would fail) */
    {get OpenOnInit lOpenOnInit}.
    IF NOT lOpenOnInit THEN
    DO:
      {get ContainerSource hContainer}.
      IF VALID-HANDLE(hContainer) THEN       
        lOpenOnInit =  NOT {fn isFetchPending hContainer}.
      ELSE 
        lOpenOnInit = TRUE.
    END.
    IF lOpenOnInit THEN
    DO:
      {get RowObjectState cRowObjectState}.
      /* Change the modifier to 'different' to force openquery  if
         ForeignFields has changed
         Note that there are logic in query.p that makes this into 'reset' again 
         if the source is in newMode or not available */ 
      IF cRowObjectState = 'NoUpdates':U 
      AND {fn hasForeignKeyChanged} THEN 
        pcRelative = 'DIFFERENT':U.
    END.
  END. /* reset */

  &SCOPED-DEFINE xp-assign
  {get ASDivision cASDivision}
  {get UpdateFromSource lOneToOne}
  {get RowObject hRowObject}
  {get ForeignFields cForeignFields}
  .
  &UNDEFINE xp-assign
  
  IF lOneToOne AND cASDivision <> "SERVER":U THEN 
  DO:
    {get DataSource hDataSource}.
    DO iField = 1 TO NUM-ENTRIES(cForeignFields) BY 2:
      cLocalFields = cLocalFields +  /* 1st of each pair is local db query fld  */
      (IF cLocalFields NE "":U THEN ",":U ELSE "":U) +
        ENTRY(iField, cForeignFields).
      cSourceFields = cSourceFields +   /* 2nd of pair is source RowObject fld */
      (IF cSourceFields NE "":U THEN ",":U ELSE "":U) +
        ENTRY(iField + 1, cForeignFields).
    END.
  
    ghTargetProcedure = TARGET-PROCEDURE.   
    cValues = {fnarg colValues cSourceFields hDataSource} NO-ERROR.
    ghTargetProcedure = ?.
    
     /* Throw away the RowIdent entry returned by colValues*/
    IF cValues NE ? THEN 
      cValues = SUBSTR(cValues, INDEX(cValues, CHR(1)) + 1).

    lFound = DYNAMIC-FUNCTION( "findRowObjectWhere":U IN TARGET-PROCEDURE, 
                    cLocalFields,
                    cValues,
                    "":U,    /* = */
                    "FIRST":U ).
    /* ? is treated as FALSE */ 
    IF NOT (lFound = TRUE) THEN
    DO: /* if the 1-to-1 child is not found, release the current RowObject */
      IF VALID-HANDLE(hRowObject) THEN
        hRowObject:BUFFER-RELEASE().
      IF cASDivision = "CLIENT":U THEN
        pcRelative = "VALUE-CHANGED":U.  /* no need to do anything with the DB query */
      ELSE DO:
        {get NewBatchInfo cNewBatchInfo hDataSource}.
        IF cNewBatchInfo = "":U THEN
          pcRelative = "VALUE-CHANGED":U.
      END.
    END.
    ELSE
      pcRelative = "VALUE-CHANGED":U.  /* no need to do anything with the DB query */
  END.
  IF cForeignFields <> '':U AND pcRelative <> 'VALUE-CHANGED':U THEN 
  DO:
    RUN SUPER(pcRelative).
    IF lOneToOne AND cASDivision <> "SERVER":U THEN 
    DO:
      lFound = DYNAMIC-FUNCTION( "findRowObjectWhere":U IN TARGET-PROCEDURE, 
                      cLocalFields,
                      cValues,
                      "":U,    /* = */
                      "FIRST":U ).
      /* ? is treated as FALSE */
      IF NOT (lFound = TRUE) THEN 
      DO: /* if the 1-to-1 child is not found, release the current RowObject */
        IF VALID-HANDLE(hRowObject) THEN
          hRowObject:BUFFER-RELEASE().
      END.
    END.
  END.
  ELSE DO:
    RUN updateQueryPosition IN TARGET-PROCEDURE.
    /* 'Value-changed' from a data target has told us not to reapply Foreign 
        Fields, but we need to pass this as 'DIFFERENT' to our targets.
       (We could probably always have passed 'DIFFERENT') */  
    IF pcRelative = 'VALUE-CHANGED':U  THEN 
      pcRelative = 'DIFFERENT':U. 
      
    PUBLISH 'DataAvailable':U FROM TARGET-PROCEDURE(pcRelative).
    {set NewBatchInfo '':U}.
  END.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-describeSchema) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE describeSchema Procedure 
PROCEDURE describeSchema :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcIndexFieldList AS CHARACTER                    NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE-HANDLE hTtSchema.

DEFINE VARIABLE iCol                    AS INTEGER      NO-UNDO.
DEFINE VARIABLE hRowObject              AS HANDLE       NO-UNDO.
DEFINE VARIABLE hColumn                 AS HANDLE       NO-UNDO.
DEFINE VARIABLE cUpdatableColumnList    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cColumnsByTable         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cTableList              AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iTable                  AS INTEGER.
DEFINE VARIABLE iColumn                 AS INTEGER.
DEFINE VARIABLE iColumnSequence         AS INTEGER.
DEFINE VARIABLE iIndexSequence          AS INTEGER    NO-UNDO.
DEFINE VARIABLE iIdxFldSeq              AS INTEGER    NO-UNDO.
DEFINE VARIABLE cColumnsForThisTable    AS CHARACTER.
DEFINE VARIABLE cCalculatedColumns      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDBNames                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cWordIndexedFields      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cIndexInformation       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTableIndex             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cThisIndex              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLogicalSDOName         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFieldName              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iSdoOrder               AS INTEGER    NO-UNDO.
DEFINE VARIABLE hContainer              AS HANDLE     NO-UNDO.
DEFINE VARIABLE cContainerObjectType    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDataObjectHandles      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSdoOrder               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hEntityBuffer           AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTranslatedBuffer       AS HANDLE     NO-UNDO.
DEFINE VARIABLE cSchemaLocation         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lDynamicData            AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lTranslateColumnLabel   AS LOGICAL    NO-UNDO.
 
    EMPTY TEMP-TABLE ttSchema.
    hTtSchema = TEMP-TABLE ttSchema:HANDLE.

    &SCOPED-DEFINE xp-assign
    {get RowObject hRowObject}
    {get Tables cTableList}
    {get LogicalObjectName cLogicalSDOName}
    {get UpdatableColumns cUpdatableColumnList}
    {get DBNames cDBNames}
    {get CalculatedColumns cCalculatedColumns}
    {get WordIndexedFields cWordIndexedFields}
    {get IndexInformation cIndexInformation}
    {get DataColumnsByTable cColumnsByTable}
    {get SchemaLocation cSchemaLocation}
    {get DynamicData lDynamicData}
    .
    &UNDEFINE xp-assign

    lTranslateColumnLabel = VALID-HANDLE(gshRepositoryManager) AND NOT (cSchemaLocation = "ENT":U AND lDynamicData).
    
    IF cLogicalSDOName EQ "":U OR cLogicalSDOName EQ ? THEN
        ASSIGN cLogicalSDOName = TARGET-PROCEDURE:FILE-NAME.

    {get ContainerSource hContainer}.

    IF VALID-HANDLE(hContainer) 
    AND {fnarg instanceOf 'SmartBusinessObject':U hContainer} THEN
    DO:        
      &SCOPED-DEFINE xp-assign
      {get ContainedDataObjects cDataObjectHandles hContainer}
      {get DataObjectOrdering cSdoOrder hContainer}.
      &UNDEFINE xp-assign
    
      ASSIGN iSdoOrder = INTEGER(ENTRY(LOOKUP(STRING(TARGET-PROCEDURE:HANDLE), cDataObjectHandles), cSdoOrder)).
    END.    /* SBO */
    ELSE
        ASSIGN iSdoOrder = 1.
    
    DO iCol = 1 TO hRowObject:NUM-FIELDS:
        hColumn = hRowObject:BUFFER-FIELD(iCol).
        /* If the buffer-field is not in the list of fields we want, */
        /* or if it is a calculated field, then skip it */
        IF NOT CAN-DO(pcIndexFieldList, hColumn:NAME) 
               OR CAN-DO(cCalculatedColumns, hColumn:NAME) THEN
            NEXT.
            
        CREATE ttSchema.
        ASSIGN
          ttSchema.sdo_name               = cLogicalSDOName
          ttSchema.column_sequence        = iCol
          ttSchema.column_case_sensitive  = hColumn:CASE-SENSITIVE
          ttSchema.column_dataType        = hColumn:DATA-TYPE
          ttSchema.column_format          = hColumn:FORMAT
          ttSchema.column_label           = hColumn:COLUMN-LABEL           
          ttSchema.column_mandatory       = hColumn:MANDATORY
          ttSchema.column_name            = 'RowObject.' + hColumn:NAME
          ttSchema.column_width_chars     = hColumn:WIDTH-CHARS
          ttSchema.column_updatable       = (LOOKUP(hColumn:NAME, cUpdatableColumnList) > 0)
          ttSchema.adm_column             = (LOOKUP(hColumn:NAME, "RowIdent,RowMod,RowNum") > 0)
          /* initially assign all fields as calculated, except rowobject, then, when assigning the table name, assign calculated_field = NO  */
/*           ttSchema.calculated_field       = IF ttSchema.adm_column THEN NO ELSE YES  */
          /* Set calculated field flag based on field name being in calculatedColumns psuedo-property */
          ttSchema.calculated_field       = (LOOKUP(hColumn:NAME, cCalculatedColumns) > 0) 
          ttSchema.word_index             = (LOOKUP(hColumn:NAME, cWordIndexedFields) > 0)
          ttSchema.COLUMN_indexed         = ttSchema.word_index
          ttSchema.sdo_order              = iSdoOrder
          ttSchema.sdo_handle             = TARGET-PROCEDURE:HANDLE
          .
    END.
    
    ASSIGN iIndexSequence  = 1
           iColumnSequence = 0.

    /* find the table/field/index info */
    DO iTable = 1 TO NUM-ENTRIES(cTableList):
      cTableIndex = ''.    /* Reset in case WHEN clause below fails */
        /* Break out the columns and indexes for each table */
      ASSIGN cColumnsForThisTable=ENTRY(iTable,cColumnsByTable,{&adm-tabledelimiter})
             cTableIndex = ENTRY(iTable,cIndexInformation,CHR(2)) WHEN NUM-ENTRIES(cIndexInformation,CHR(2)) GE iTable.
      IF lTranslateColumnLabel THEN
      DO:
        hEntityBuffer = DYNAMIC-FUNCTION("getCacheEntityObject":U IN gshRepositoryManager, ENTRY(iTable, cTableList)).
        IF VALID-HANDLE(hEntityBuffer) AND hEntityBuffer:AVAILABLE THEN
          ASSIGN hColumn = hEntityBuffer:BUFFER-FIELD("EntityBufferHandle":U)
            hTranslatedBuffer = IF VALID-HANDLE(hColumn) THEN WIDGET-HANDLE(hColumn:BUFFER-VALUE) ELSE ?.
          ELSE
            hTranslatedBuffer = ?.
      END.
      /* Loop through each column and get its TT record and assign fields based on table list */
      DO iColumn = 1 TO NUM-ENTRIES(cColumnsForThisTable):
        FIND FIRST ttSchema WHERE ttSchema.column_name = 
                      'RowObject.':U + ENTRY(iColumn, cColumnsForThisTable) NO-ERROR.
        IF AVAILABLE ttSchema THEN
        DO:
          cFieldName = {fnarg columnDBColumn ttSchema.column_name}.
          cFieldName = ENTRY(NUM-ENTRIES(cFieldName,'.'),cFieldName,'.').
          ASSIGN iColumnSequence = iColumnSequence + 1
                 ttSchema.DATABASE_name    = ENTRY(iTable,cDBNames)
                 ttSchema.TABLE_name       = ENTRY(iTable,cTableList)
                 ttSchema.TABLE_label      = ENTRY(iTable,cTableList)  /* Not worth the trip to the server for this */
                 ttSchema.FIELD_name       = cFieldName
                 ttSchema.table_sequence   = iTable.
          /* Translate ttSchema.column_label */
          IF lTranslateColumnLabel AND VALID-HANDLE(hTranslatedBuffer) THEN
          DO:
            /* The Entity stores array fields (wrongly) without bracket! */
            IF INDEX(cFieldname,"[":U) > 0 THEN
              ASSIGN
               cFieldName = REPLACE(cFieldName,'[':U,'':U)
               cFieldName = REPLACE(cFieldName,']':U,'':U).
            hColumn = hTranslatedBuffer:BUFFER-FIELD(cFieldName) NO-ERROR.                     
            IF VALID-HANDLE(hColumn) THEN
              ttSchema.column_label = hColumn:COLUMN-LABEL. /* Assign column_label from entity cache */
          END.
         /* Remarked out as it is set above */
         /*  ttSchema.calculated_field = NO. /* Previously assigned all fields as calculated, now overwrite fields with tables to NOT calcualted */ */
        END.
      END. 

      /* Now go through the indexes by table, find the TT record and assign index related info  */
      IF cTableIndex NE '' THEN
      DO iCol = 1 TO NUM-ENTRIES(cTableIndex,CHR(1)):
            ASSIGN 
              cThisIndex = ENTRY(iCol,cTableIndex,CHR(1))
              iIdxFldSeq = 0
              .            
            DO iColumn = 5 TO NUM-ENTRIES(cThisIndex):
                FIND FIRST ttSchema WHERE ttSchema.column_name = 'RowObject.':U
                                                               + ENTRY(iColumn, cThisIndex) NO-ERROR.
                IF AVAILABLE ttSchema THEN
                    ASSIGN iIdxFldSeq = iIdxFldSeq + 1
                           ttSchema.COLUMN_indexed = YES
                           ttSchema.INDEX_position = ttSchema.INDEX_position
                                                   + (IF ttSchema.INDEX_position = '' THEN '' ELSE ',')
                                                   + STRING(iIndexSequence) + '.' + STRING(iIdxFldSeq).
            END.
            iIndexSequence = iIndexSequence + 1.
      END.

    END.
    
    /* Lastly, mark all with no index as "None" */
    FOR EACH ttSchema WHERE INDEX_position = "":U:
        ttSchema.INDEX_position = "None":U.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyCache Procedure 
PROCEDURE destroyCache :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  {set DestroyStateless TRUE}.
  RUN destroyObject IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:  override to get rid of the datalogicobject    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hObject           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObjectTable   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObjUpdTable   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lExternal         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDivision         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lInitialized      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hDataHandle       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lDestroyStateless AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cName             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hRowObject        AS HANDLE     NO-UNDO.

  PUBLISH 'unRegisterObject':U FROM TARGET-PROCEDURE. 

  &SCOPED-DEFINE xp-assign
  {get ASDivision cDivision}
  {get ObjectInitialized lInitialized}
  {get DataHandle hDataHandle}
  {get DataLogicObject hObject}
  {get IsRowObjectExternal lExternal}
  {get DestroyStateless lDestroyStateless}
  {get LogicalObjectName cName}
  . 
  &UNDEFINE xp-assign
  
  /* if this object is remotely run (ie RUN... ON <AppserverHandle>) */
  /* we must *not* keep it alive because it will lock the Appserver agent */
  IF (cDivision = "SERVER":U OR SESSION:CLIENT-TYPE = "WEBSPEED":U) 
  AND NOT lDestroyStateless 
  AND NOT TARGET-PROCEDURE:REMOTE THEN 
  DO:
    /* reset and go to sleep */
    RUN removeAllLinks IN TARGET-PROCEDURE.
    &SCOPED-DEFINE xp-assign
    {set ObjectHidden TRUE}
    {set RowObjectState 'NoUpdates':U}
    {set ForeignFields '':U}
    {set ForeignValues ?}
    {set DataReadHandler ?}
    {set QueryWhere '':U}
    .  
    &UNDEFINE xp-assign
    /* In a WEBSPEED session we need to empty the RowObject TT *and* reset */
    /* the batch control properties. In all other session types resetting  */
    /* the batch control properties is enough */
    IF SESSION:CLIENT-TYPE = "WEBSPEED":U THEN
     {fnarg emptyRowObject 'Reset':U}.
    ELSE DO:
      &SCOPED-DEFINE xp-assign
      {set FirstRowNum ?}
      {set LastRowNum ?}
      {set FirstResultRow ?}
      {set LastResultRow ?}
      .  
      &UNDEFINE xp-assign
    END.

    /* set wake-up event */
    SUBSCRIBE PROCEDURE TARGET-PROCEDURE
              TO "searchCache":U + cName ANYWHERE
              RUN-PROCEDURE "returnObjectHandle":U.
    /* set cache shutdown event */
    SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "destroyCache":U  ANYWHERE.
    RETURN.
  END.
  ELSE DO:
    IF VALID-HANDLE(hObject) THEN 
      DELETE PROCEDURE hObject.  

    /* Only delete the RowObjUpd if it's the Client version. 
       The server-side RowObjUpd is returned back to the client 
       AFTER destroyObject is run so it cannot be deleted explicitly here 
       if not initialized then then this is a master started with startdataObject */ 
    IF cDivision <> "Server":U OR NOT lInitialized THEN 
    DO:
      {get RowObjUpdTable hRowObjUpdTable}.
      DELETE OBJECT hRowObjUpdTable NO-ERROR.
    END.

    IF NOT lExternal THEN 
    DO:      
      {get RowObjectTable hRowObjectTable}.
      IF NOT VALID-HANDLE(hRowObjectTable) THEN
      DO:
        {get RowObject hRowObject}.
        {fnarg destroySharedBuffer hRowObject ghCacheManager}.
      END.
      ELSE 
        DELETE OBJECT hRowObjectTable NO-ERROR.
    END.

    /* delete the RowObject Query (in case it is dynamic) */
    DELETE OBJECT hDataHandle NO-ERROR.
    RUN SUPER.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-endTransactionValidate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE endTransactionValidate Procedure 
PROCEDURE endTransactionValidate :
/*------------------------------------------------------------------------------
  Purpose: Validation hook for code to be executed in the transaction after the 
           updates have been done. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  RUN bufferTransactionValidate IN TARGET-PROCEDURE ('end':U). 

  RETURN RETURN-VALUE.  
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchBatch Procedure 
PROCEDURE fetchBatch :
/*------------------------------------------------------------------------------
  Purpose:     To transfer another "batch" of rows from the database query to 
               the RowObject Temp-Table query. 
  Parameters:
    INPUT plForwards - TRUE if we should retrieve a batch of rows after the current rows,
                       FALSE if before.
  Notes:       Run from a Browser to get another batch of rows from the database
               query appended to the RowObject temp-table query (when the 
               browser scrolls to the end).
               fetchBatch does some checking and sets up the proper parameters
               to sendRows, but sendRows is called to do the actual work.
             - repositions query to next or prev record in new batch, but does 
               not publish dataAvailable.     
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER plForwards  AS LOGICAL NO-UNDO.
  
  DEFINE VARIABLE hDataQuery    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iRowsReturned AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iLastRow      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iFirstRow      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iRowsToBatch  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cPosition     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRowState     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE rCurrentRow   AS ROWID     NO-UNDO.

  /* The setting of queryPosition is most likely complete paranoia, so if 
     they ever cause an irritation of any sort, just get rid of them .. */

  {get LastRowNum iLastRow}.
  IF iLastRow NE ? AND plForwards THEN 
  DO:
    /* In case not already set, set it.*/
    {set QueryPosition 'LastRecord':U}.      
    RETURN.      /* We're already at the end of the db query. */
  END.     /* END DO IF iLastRow */
  
  {get FirstRowNum iFirstRow}.
  IF iFirstRow NE ? AND NOT plForwards THEN 
  DO:
    /* In case not already set, set it.*/
    {set QueryPosition 'FirstRecord':U}.      
    RETURN.      /* We're already at the end of the db query. */
  END.     /* END DO IF iLastRow */

  {get DataHandle hDataQuery}.
  IF NOT hDataQuery:IS-OPEN           /* sanity check. */
    THEN RETURN.
   
  {get RowObjectState cRowState}.   
  IF cRowState = 'RowUpdated':U THEN DO: /* if updates are in progress, can not continue */
      /*DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE, "17":U).*/
     RUN showmessageprocedure IN TARGET-PROCEDURE 
                    (INPUT "17":U, OUTPUT glShowMessageAnswer). 
     RETURN.
  END.

  {get RowsToBatch iRowsToBatch}.
  RUN sendRows IN TARGET-PROCEDURE 
      (?, /* Don't repos., just get more rows. */
       ?,  /* no RowIdent specified to repos to */
       true,   /* Do a Next before getting more rows */
         /* Signal whether to move forward or back */
       IF plForwards THEN iRowsToBatch ELSE - iRowsToBatch, 
       OUTPUT iRowsReturned).
      
  IF iRowsReturned NE 0 THEN   
    PUBLISH 'assignMaxGuess':U FROM TARGET-PROCEDURE (iRowsReturned).
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchDefinitions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchDefinitions Procedure 
PROCEDURE fetchDefinitions :
/*------------------------------------------------------------------------------
  Purpose:   Fetch definitions from server  
  Parameters:  <none>
  Notes:     Retrieves the rowobject for dynamic objects when openOnInit 
             is false. It also retrieves other definitional properties like 
             Tables, DbNames, IndexInformation and BaseQuery
           - Dynamics will call this also for static objects when openOninit 
             is false to ensure that Repository field definitions are applied
             to the rowobject table.
           - This should not be called when IsFetchPending as the DataContainer
             will handle data objects with openOnInit.  
           - The SBO has its own version, which is used when the SBO's 
             OpenOnInit is false.
------------------------------------------------------------------------------*/   
 DEFINE VARIABLE hAppservice     AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cServerFileName AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cLogicalName    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cContext        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hRowObjectTable AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hFetchTable     AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cErrors         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hAsHandle       AS HANDLE     NO-UNDO.

 {get RowObjectTable hRowObjectTable}.
 
 IF NOT VALID-HANDLE(hRowObjectTable) THEN
 DO:   
   IF {fn hasNoServerBinding} THEN
   DO:
     RUN connectServer IN TARGET-PROCEDURE (OUTPUT hAppService). 
     IF hAppService  = ? THEN
       RETURN ERROR 'ADM-ERROR':U.

     &SCOPED-DEFINE xp-assign
     {get ServerFileName cServerFileName}
     {get LogicalObjectName cLogicalname}
     .
     &UNDEFINE xp-assign
     
     cContext = {fn obtainContextForServer}.   
  
     RUN adm2/fetchdefs.p ON hAppservice (cServerFileName
                                          + (IF cLogicalName > '' 
                                             THEN ':':U + cLogicalName
                                             ELSE ''),
                                          INPUT-OUTPUT cContext,
                                          OUTPUT TABLE-HANDLE hFetchTable,
                                          OUTPUT cErrors). /* Errors not used yet */
   END.
   ELSE DO:
     {get AsHandle hAshandle}.
     /* a remoteFetchDefinitions with input-output context and output errors
        may be added to the data object if we want errors  */
     RUN fetchRowObjectTable IN hAsHandle( OUTPUT TABLE-HANDLE hFetchTable ).
     cContext = {fn obtainContextForClient hAsHandle}.
   END.

   {fnarg applyContextFromserver cContext}.

   IF VALID-HANDLE(hFetchTable) THEN
     {set RowObjectTable hFetchTable}.
   ELSE 
     RETURN ERROR 'ADM-ERROR':U.
 END.
 
 RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchFirst) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchFirst Procedure 
PROCEDURE fetchFirst :
/*------------------------------------------------------------------------------
  Purpose:     To reposition the RowObject temp-table to the first record, or
               to the row matching the QueryRowIdent property (if it has been
               set.)  If the first record has not been fetched (from the db) 
               yet, then calls sendRows to get the first batch of RowObject 
               records of the SDO and then reposition the RowObject Temp-Table
               to the first row.
 
  Parameters:  <none>
------------------------------ ------------------------------------------------*/
  DEFINE VARIABLE iReturnRows   AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hDataQuery    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowObject    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hColumn       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lHidden       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE iRowsToBatch  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cRowIdent     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iRowNum       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lRowIdent     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lRebuild      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE iFirstRow     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cRowState     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lReposAvail   AS LOGICAL   NO-UNDO.

    &SCOPED-DEFINE xp-assign
    {get DataHandle hDataQuery}
    {get RowObject hRowObject}
    {get FirstRowNum iRowNum}
    .
    &UNDEFINE xp-assign
    
    IF iRowNum = ? THEN       /* First row hasn't been retrieved yet. */      
    DO:
      {get RowsToBatch iRowsToBatch}.
      /* If there are already rows in the temp-table, then
         the query has already been opened and repositioned. In that case,
         pass the special value of "First" to sendRows to get it to flush
         the temp-table and restart from the beginning. Otherwise if
         QueryRowIdent is set, then start at that row. Otherwise just
         start at the beginning. */

      IF NOT VALID-HANDLE(hRowObject) OR NOT hRowObject:AVAILABLE THEN
      DO: /* First time through. */
        {get QueryRowIdent cRowIdent}.     /* See if there's a special start row.*/
        IF cRowIdent NE ? AND cRowIdent NE "":U THEN
        DO:
          lRowIdent = yes.
          {set QueryRowIdent ?}.          /* Reset once we have the value. */
        END.   /* END DO IF cRowIdent has a valid value */
      END.   /* END DO IF there is no RowObject available */
      ELSE cRowIdent = "First":U.  /* Else signal restart at beginning. */
      
      RUN sendRows IN TARGET-PROCEDURE 
        (?                  /* Start at the first row if RowIdent is not set */, 
         cRowIdent          /* or use this RowIdent key if its set. */,
         FALSE              /* Don't next initially (unless skipRowident)  */, 
         iRowsToBatch       /* how many rows to retrieve */, 
         OUTPUT iReturnRows /* how many rows were actually returned */ ).
      /* New to 9.1B: If the temp-table is dynamic and wasn't already 
         initialized, the handle variables set above will be unknown,
         so reset them here -- clientSendRows has set the properties for them.*/
       
      /* if avail after sendrows avoid passing 'home' to avoid problems 
         since value-changed not will fire */
      IF NOT VALID-HANDLE(hDataQuery) THEN
      DO:
        &SCOPED-DEFINE xp-assign 
        {get DataHandle hDataQuery}
        {get RowObject hRowObject}
        .
        &UNDEFINE xp-assign        
      END.
  
      IF NOT hDataQuery:IS-OPEN THEN
        hDataQuery:QUERY-OPEN(). /* Query on the Temp-Table. */

      ASSIGN hColumn = hRowObject:BUFFER-FIELD('RowNum':U).
      IF iReturnRows NE 0 THEN 
      DO:
        hDataQuery:GET-FIRST().
        lReposAvail = hRowObject:AVAILABLE. 
        
        IF NOT lRowIdent THEN /* If there was no QueryRowIdent prop then we */
          {set FirstRowNum hColumn:BUFFER-VALUE}.
      END.     /* END DO IF iReturnRows NE 0 */
      ELSE DO:
        {get RebuildOnRepos lRebuild}.      
        IF lRebuild THEN 
        DO:
           /* See if fetch failed due to an update in progress */
          &SCOPED-DEFINE xp-assign 
          {get FirstRowNum iFirstRow}
          {get RowObjectState cRowState}
          .
          &UNDEFINE xp-assign  
          IF cRowState = 'RowUpdated':U AND iFirstRow eq ? THEN 
          DO:
            /*DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE, "17":U).*/
            RUN showMessageProcedure IN TARGET-PROCEDURE 
                                 (INPUT "17":U, OUTPUT glShowMessageAnswer). 

            {set FirstRowNum ?}.
            RETURN.
          END.   /* If in a commit */
        END.  /* Rebuild On Reposition is set */
        hRowObject:BUFFER-RELEASE().
      END. /* END ELSE DO IF no rows returned */
    END.   /* END IF iRowNum = ? */
    ELSE DO:
      IF NOT hDataQuery:IS-OPEN THEN 
        hDataQuery:QUERY-OPEN().
      hDataQuery:GET-FIRST().
    END.
 
    /* set QueryPosition from FirstRowNum, LastRowNum */
    RUN updateQueryPosition IN TARGET-PROCEDURE.
    /* Send dataAvail whether's a record or not; if not, the recipients
       will close queries or clear frames. */
    PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE ("FIRST":U).     
    {set NewBatchInfo '':U}.
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchLast) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchLast Procedure 
PROCEDURE fetchLast :
/*------------------------------------------------------------------------------
  Purpose:     To reposition the RowObject query to the last row of the dataset.
               If the last row has not yet been retrieved from the DB, then
               fetchLast gets the last batch of RowObject records for the SDO 
               and then repositions the RowObject query to the last row.
  Parameters:  <none>
  Notes:       IF the SDO property RebuildOnReposition is false and the last row
               from the db query has not been fetch yet, fetchLast keeps asking
               for batches of rows till the last batch is recieved. This is 
               required, because otherwise there would be a discontinuous set of
               rows in the RowObject temp-table, and also, the RowNum of the last
               record, which is the key value, can be known by the db query only
               by walking all the way to the end.
               If RebuildOnReposition is true and the last row from the db query
               has not been fetch yet, all RowObject records are discarded and
               just the last batch is fetched. In this case the RowNum of the
               last row becomes 2000000 and all other records have smaller numbers
               (except for additions.)
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataQuery    AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowObject    AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowNum       AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowIdent     AS HANDLE  NO-UNDO.
  DEFINE VARIABLE iRowsReturned AS INTEGER NO-UNDO.
  DEFINE VARIABLE lHidden       AS LOGICAL NO-UNDO.
  DEFINE VARIABLE iLastRow      AS INTEGER NO-UNDO.
  DEFINE VARIABLE iRowsToBatch  AS INTEGER NO-UNDO.
  DEFINE VARIABLE lRebuild      AS LOGICAL NO-UNDO.
  DEFINE VARIABLE lReposAvail   AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cRowState     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cAsDivision   AS CHARACTER NO-UNDO.

    &SCOPED-DEFINE xp-assign
    {get DataHandle hDataQuery}
    {get RowObject hRowObject}       
    {get LastRowNum iLastRow}
    .
    &UNDEFINE xp-assign
    
    hRowNum    = hRowObject:BUFFER-FIELD('RowNum':U).
    IF iLastRow = ? THEN        /* Last row not been retrieved yet.*/
    DO:
      RUN changeCursor IN TARGET-PROCEDURE('WAIT':U).
      
      &SCOPED-DEFINE xp-assign              
      {get RowsToBatch iRowsToBatch}
      {get RebuildOnRepos lRebuild}
      . 
      &UNDEFINE xp-assign
      
      IF lRebuild THEN 
      DO:    /* Jump direct to Last and rebuilt temp-table */
        /* Set the cursor first in case this takes a while. */
        PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE 
            ('LastStart':U).
       
        RUN sendRows IN TARGET-PROCEDURE 
          (?,            /* No particular rownum to start at */
           'Last':U,     /* special value for pcRowIdent */
           FALSE,        /* No need to "next" after repositioning */
           iRowsToBatch, /* sendRows knows to go backwards from Last */
           OUTPUT iRowsReturned).
        PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('LastEnd':U).  
      END.
      ELSE DO:           /* No Rebuild on Reposition */
        /* Set the cursor first in case this takes a while. */    
        PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE 
            ('LastStart':U).
 
        RUN sendRows IN TARGET-PROCEDURE 
            (?,
            'Last':U,
             TRUE, 
             0, /* Last and 0 is use as a signal that we are appending data  */ 
             OUTPUT iRowsReturned).
        PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('LastEnd':U).          
      END.    /* END ELSE DO IF NOT lRebuild */
      
      {get AsDivision cAsDivision}.
      /* If we run locally the browse will not fire value-changed..
        ( because it already knows  ???? ) 
         dataAvailable publishes this  */
      {get LastRowNum iLastRow}.
       
      IF cAsDivision = "":U AND lRebuild THEN 
        lReposAvail = hRowObject:AVAILABLE.
      IF NOT hDataQuery:IS-OPEN THEN
        hDataQuery:QUERY-OPEN(). /* Query on the Temp-Table. */

      IF iRowsReturned = 0 THEN
      DO:
        /* See if fetch failed due to an update in progress */
        &SCOPED-DEFINE xp-assign
        {get LastRowNum iLastRow}
        {get RowObjectState cRowState}
        .
        &UNDEFINE xp-assign
        IF cRowState = 'RowUpdated':U AND iLastRow eq ? THEN 
        DO:
          /*DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE, "17":U).*/
          RUN showmessageprocedure IN TARGET-PROCEDURE 
                     (INPUT "17":U, OUTPUT glShowMessageAnswer). 
          {set LastRowNum ?}.
          RETURN.
        END.   /* If in a commit */
      END.  /* iRowsReturned = 0 */      
      RUN changeCursor IN TARGET-PROCEDURE('':U).
    END.

    hDataQuery:GET-LAST(). 

    IF hRowObject:AVAILABLE THEN
    DO:
      hRowIdent = hRowObject:BUFFER-FIELD('RowIdent':U).
      {set LastRowNum hRowNum:BUFFER-VALUE}.
    END.
    
     /* set QueryPosition from FirstRowNum, LastRowNum  */
    RUN updateQueryPosition IN TARGET-PROCEDURE.
    
    /* Signal row change in any case. */
    PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE("LAST":U).      
    {set NewBatchInfo '':U}.   
  RETURN.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchNext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchNext Procedure 
PROCEDURE fetchNext :
/*------------------------------------------------------------------------------
  Purpose:     To reposition the RowObject query to the next row.  If a new 
               batch is required to do so, then sendRows is called to get the
               new batch.
  
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iRowNum      AS INTEGER NO-UNDO.
  DEFINE VARIABLE iReturnRows  AS INTEGER NO-UNDO.
  DEFINE VARIABLE hDataQuery   AS HANDLE  NO-UNDO. 
  DEFINE VARIABLE hRowObject   AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowNum      AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowIdent    AS HANDLE  NO-UNDO.
  DEFINE VARIABLE cLastDbRowId AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lHidden      AS LOGICAL NO-UNDO.
  DEFINE VARIABLE iRow         AS INTEGER NO-UNDO.
  DEFINE VARIABLE iRowsToBatch AS INTEGER NO-UNDO.
  DEFINE VARIABLE cQueryPos    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lAutoCommit  AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE iFirstRow    AS INTEGER  NO-UNDO.
  DEFINE VARIABLE iLastRow     AS INTEGER  NO-UNDO.
  DEFINE VARIABLE cRowState    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lReposAvail  AS LOG    NO-UNDO.
  DEFINE VARIABLE lFirstDeleted AS LOGICAL  NO-UNDO.

    {get DataHandle hDataQuery}.
    
    IF NOT hDataQuery:IS-OPEN        
      THEN RETURN.
      
    ASSIGN hRowObject = hDataQuery:GET-BUFFER-HANDLE(1)
           hRowNum   = hRowObject:BUFFER-FIELD('RowNum':U)
           hRowIdent = hRowObject:BUFFER-FIELD('RowIdent':U).

    IF hRowObject:AVAILABLE THEN   /* Make sure we're positioned to some row. */
    DO:
      {get LastRowNum iRow}.
      /* Already on the last row. */
      IF iRow = hRowNum:BUFFER-VALUE THEN 
        RETURN.
    END. /* if hRowObject:available */
    ELSE DO:  /* if no record is avail, but queryposition is first we 
                 must have deleted it */ 
      {get QueryPosition cQueryPos}.
      /* This seems to be  handled in updateQueryPos ..
      IF cQueryPos = 'LastRecord':U THEN
         lLastDeleted = TRUE. */  
      IF cQueryPos = 'FirstRecord':U THEN
         lFirstDeleted = TRUE.
    END.
    hDataQuery:GET-NEXT().
   
    IF NOT hRowObject:AVAILABLE THEN
    DO:                                 /* No data so ask the Query. */
      {get RowsToBatch iRowsToBatch}.
      PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('NextStart':U).
      
      RUN sendRows IN TARGET-PROCEDURE
        (?, /* sendRows will know what row to start at */
         ?, /* No pcRowIdent */
         TRUE /* start with next row */, 
         iRowsToBatch, 
         OUTPUT iReturnRows).
      
      PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('NextEnd':U).
      IF iReturnRows NE 0 THEN
      DO:
        PUBLISH 'assignMaxGuess':U FROM TARGET-PROCEDURE (iReturnRows).     
        /* Set ReposAvail flag if avail after reposition above or in sendRows
           (will be avail if we browse) so we can pass right parameter to the
           browser when we publish dataAvailable further down */  
        
        lReposAvail = hRowObject:AVAILABLE. 

        IF NOT lReposAvail THEN 
          hDataQuery:GET-NEXT().           
      END.     /* END DO IF ReturnRows NE 0 */
      ELSE DO:
        hDataQuery:GET-PREV(). /* get-last messes up the browse and get-prev is
                                  the same */
        &SCOPED-DEFINE xp-assign
        {get LastRowNum iLastRow}
        /* See if fetch failed due to an update in progress */
        {get RowObjectState cRowState}
        .
        &UNDEFINE xp-assign
      
        /* Don't return, but publish dataavailable further down */
        IF cRowState = 'RowUpdated':U AND iLastRow eq ? THEN 
         /* DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE, "17":U).*/
         RUN showMessageProcedure IN TARGET-PROCEDURE 
            (INPUT "17":U, OUTPUT glShowMessageAnswer). 

        ELSE IF NOT hRowObject:AVAILABLE THEN
        DO:
          {set LastRowNum ?}.
          RUN fetchLast IN TARGET-PROCEDURE.         
        END. /* if not hRowObject:available */
        ELSE DO:
          iRowNum = hRowNum:BUFFER-VALUE.
          {set LastRowNum iRowNum}.
        END.  /* If there is a last record */
      END.     /* END ELSE DO IF ReturnRows = 0 */
    END.       /* END DO IF no next record AVAILABLE  */
    
    IF lFirstDeleted AND hROwObject:AVAILABLE THEN  
    DO:
      iRowNum = hRowNum:BUFFER-VALUE NO-ERROR.
      {set FirstRowNum iRowNum}.
    END.

    /* Set QueryPosition from FirstRowNum, LastRowNum  */
    RUN updateQueryPosition IN TARGET-PROCEDURE.
    /* Signal row change in any case, even if NoRecordAvail. 
       If REPOSITION-TO-ROWID made the record available it must be browsed 
       so we pass 'REPOSITIONED' to make sure dataAvailable doesn't select-next- */
    PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE 
           (IF lReposAvail THEN "REPOSITIONED":U ELSE "NEXT":U). 
    {set NewBatchInfo '':U}.
  RETURN.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchPrev) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchPrev Procedure 
PROCEDURE fetchPrev :
/*------------------------------------------------------------------------------
  Purpose:     To reposition the RowObject query to the previous row.  If a new
               batch is needed to do so, then sendRows is called to get the new
               batch.  (Getting a new batch will only be necessary when the 
               RebuildOnReposition property is set to true.)
 
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iReturnRows  AS INTEGER NO-UNDO.
  DEFINE VARIABLE hDataQuery   AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowObject   AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowNum      AS HANDLE  NO-UNDO.
  DEFINE VARIABLE lHidden      AS LOGICAL NO-UNDO.
  DEFINE VARIABLE iRow         AS INTEGER NO-UNDO.
  DEFINE VARIABLE iRowsToBatch AS INTEGER NO-UNDO.
  DEFINE VARIABLE lAutoCommit  AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE rCurrentRow  AS ROWID    NO-UNDO.
  DEFINE VARIABLE lRebuild     AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE cRowState    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lReposAvail  AS LOG    NO-UNDO.
   
    {get DataHandle hDataQuery}.

    IF NOT hDataQuery:IS-OPEN        
      THEN RETURN.
      
    ASSIGN hRowObject = hDataQuery:GET-BUFFER-HANDLE(1)
           hRowNum    = hRowObject:BUFFER-FIELD('RowNum':U).
        
    IF hRowObject:AVAILABLE THEN   /* Make sure we're positioned to some row. */
    DO:
      {get FirstRowNum iRow}.
      IF iRow = hRowNum:BUFFER-VALUE THEN 
        RETURN.
    END.
    
    hDataQuery:GET-PREV().
    
    IF NOT hRowObject:AVAILABLE THEN
    DO:                        
      /* If we are rebuilding the query from the end or some middle point,
         then we have to check to see if there are more rows in the dataset.*/      
      {get RebuildOnRepos lRebuild}.

      IF lRebuild THEN
      DO:
        {get RowsToBatch iRowsToBatch}.
        PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('PrevStart':U).
        RUN sendRows IN TARGET-PROCEDURE
         (?, /* sendRows will know what row to start at */
          ?, /* No pcRowIdent */
          TRUE, /* start with previous row */
          - iRowsToBatch, /* Negative rows means move backwards */
          OUTPUT iReturnRows).
         
        PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('PrevEnd':U).

        IF iReturnRows NE 0 THEN
        DO:
          PUBLISH 'assignMaxGuess':U FROM TARGET-PROCEDURE (iReturnRows).
          /* Set ReposAvail flag if avail after reposition above or in sendRows
             (will be avail if we browse) so we can pass right parameter to the
             browser when we publish dataAvailable further down */  
          lReposAvail = hRowObject:AVAILABLE.

          /* Reposition to the record we were on before this was called and 
             then get the now previous record */
          PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('PrevStart':U).
          
          IF NOT lReposAvail THEN /* get the row that we have repositioned to */
            hDataQuery:GET-NEXT(). 
          
          PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('PrevEnd':U).
        END.     /* END DO IF ReturnRows NE 0 */
      END. /* if lRebuild */

      /* ReturnsRow = 0 indicates either 
         NOT RebuildOnRepos OR RebuildonRepos, but no more records */
      IF iReturnRows = 0 THEN
      DO:
        hDataQuery:GET-FIRST().        
         
        /* See if fetch failed due to an update in progress */ 
        IF lRebuild THEN
        DO:

          &SCOPED-DEFINE xp-assign
          {get FirstRowNum iRow} 
          {get RowObjectState cRowState}
          .
          &UNDEFINE xp-assign
          
          IF cRowState = 'RowUpdated':U AND iRow eq ? THEN 
          DO:
            /* DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE, "17":U). */ 
            RUN showmessageprocedure IN TARGET-PROCEDURE 
                    (INPUT "17":U, OUTPUT glShowMessageAnswer). 
        
            {set FirstRowNum ?}.
            RETURN.
          END. /* If in a commit */
        END. /* lRebuild */
        
        IF hRowObject:AVAIL THEN
          {set FirstRowNum hRowNum:BUFFER-VALUE}.
        ELSE 
          {set FirstRowNum ?}.

      END. /* IF ReturnRows = 0 */
    END. /* IF not hRowObject:available */
    
    /* set QueryPosition from FirstRowNum, LastRowNum */
    RUN updateQueryPosition IN TARGET-PROCEDURE.
    /* Signal row change in any case, even if NoRecordAvail. 
       If REPOSITION-TO-ROWID made the record available it must be browsed 
       so we pass 'REPSOTIONED' to make sure dataAvailable doesn't select-prev- */
    PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE 
           (IF lReposAvail THEN "REPOSITIONED":U ELSE "PREV":U). 
    {set NewBatchInfo '':U}.      
  RETURN.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchRowObjectTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchRowObjectTable Procedure 
PROCEDURE fetchRowObjectTable :
/*------------------------------------------------------------------------------
  Purpose:  Fetch the RowObject table    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObjectTable. 
  {get RowObjectTable phRowObjectTable}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchRows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchRows Procedure 
PROCEDURE fetchRows :
/*------------------------------------------------------------------------------
  Purpose:     To transfer a number of rows/batches from the database 
               query to the RowObject Temp-Table query without changing the 
               current record position.
  Parameters:
    INPUT plForward  - Yes  - retrieve rows after current batch(es).                             
                       No   - retrieve rows before current batch(es). 
    INPUT piMinRequested - Minimum number of records requested 
                         - ? use batch size. 
                         - 0 all
    INPUT plUseBatch     - TRUE if we should round up to use defined batch
                           size. 
                           FALSE use minrows as specified.
                         - ignored if piMinRequested = 0 or ?
      Notes:  The piMinRequested always specifies the minimum needed number 
              of rows (not batches). The plUseBatch then specifies whether to 
              use the RowsToBatch to round up so the request is dividible on the 
              defined batch size.               
           -  The 'forward' and 'backward' request is (sort of) a silent append 
              request in that it keeps current position and does not publish 
              anything. 
           -  This is run from a Browser when FetchOnReposToEnd to ensure that 
              it has enough data to fill the browse.      
-----------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER plForward       AS logical    NO-UNDO.
  DEFINE INPUT  PARAMETER piMinRequested  AS integer    NO-UNDO.
  DEFINE INPUT  PARAMETER plUseBatch      AS logical    NO-UNDO.
    
  DEFINE VARIABLE hDataQuery    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cRowState     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iTempBatch    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iRowsReturned AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLastRow      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iFirstRow     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE rRowid        AS ROWID      NO-UNDO.
  DEFINE VARIABLE hRowObject    AS HANDLE     NO-UNDO. 
    
  &scoped-define xp-assign
  {get DataHandle hDataQuery}
  {get RowObject hRowObject} 
  {get RowObjectState cRowState}. 
  &undefine xp-assign
  
  /* this request require a current position as we don't publish */
  if not hDataQuery:is-open or not hRowObject:available then 
    return. 
  
  IF cRowState = 'RowUpdated':U THEN 
  DO: /* if updates are in progress, can not continue */
      /*DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE, "17":U).*/
     RUN showmessageprocedure IN TARGET-PROCEDURE 
                    (INPUT "17":U, OUTPUT glShowMessageAnswer). 
     RETURN.
  END.
  
  If plUseBatch then 
    iTempBatch = {fnarg calcBatchSize piMinRequested}. 
  else
    iTempBatch = piMinRequested.
    
  /* backward does not handle minrequest for 0 (sendrows needs negative...)
     (rowstobatch 0 should not need more data) */
  if iTempBatch = 0 and not plForward then 
    return.
  
  rRowid = hRowObject:rowid.
 
  if plForward then
  do:
    {get LastRowNum iLastRow}.
    if iLastRow ne ? then /* we already have all data at the end */
      return.  
  end.  /* request =  next or last */     
  else 
  do:
    {get FirstRowNum iFirstRow}.
    if iFirstRow ne ? then   
      return.      /* We already have all data at the top. */
  end. /* request = prev or first */ 
  
  /* Deactivate data links as child data must remain as-is */   
  dynamic-function("assignTargetLinkState":U in target-procedure,
                             "Data", /* linktype */
                              NO,   /*  inactive */
                              yes    /* query objects only*/ 
                              ).
  if plForward = false then
    iTempBatch = iTempBatch * -1.
  
  RUN sendRows IN TARGET-PROCEDURE(?,
                                   ?,
                                   true,
                                   iTempBatch,
                                   OUTPUT iRowsReturned).
  
  hDataQuery:reposition-to-rowid(rRowid).
  if not hRowObject:available then 
    hDataQuery:get-next.
     
  /* activate data links again */   
  dynamic-function("assignTargetLinkState":U in target-procedure,
                             "Data", /* linktype */
                              yes,   /*active */
                              yes    /* query objects only*/ 
                              ).
  
  IF iRowsReturned NE 0 THEN   
    PUBLISH 'assignMaxGuess':U FROM TARGET-PROCEDURE (iRowsReturned).
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-genContextList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE genContextList Procedure 
PROCEDURE genContextList :
/*------------------------------------------------------------------------------
  Purpose:     To generate a list of properties and their values needed to save
               (and restore) the context of a stateless SDO between invocations. 
   
  Parameters:
    OUTPUT pcContext - The context string to be returned. pcContext is a CHR(3) 
                       delimited list of propertyCHR(4)Value pairs.
 
  Notes:       Currently there are only 5 properties needed to restore the
               context: CheckCurrentChanged, RowObjectState, FirstResultRow,
               LastResultRow and QueryRowIdent.
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER pcContext     AS CHARACTER   NO-UNDO.

  DEFINE VARIABLE lCheckCurrentChanged  AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE cFirstResultRow       AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cLastResultRow        AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cQueryRowIdent        AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE iLastRowNum           AS INTEGER     NO-UNDO.
  DEFINE VARIABLE iFirstRowNum          AS INTEGER     NO-UNDO.
  DEFINE VARIABLE cLastRowNum           AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cQueryWhere           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryString          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryColumns         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignValues        AS CHARACTER  NO-UNDO.

  /* Dynamic SDO on server  */
  DEFINE VARIABLE cDefs                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTables                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPhysicalTables          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBaseQuery               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataColumns             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataColumnsByTable      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAssignList              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUpdatableColumnsByTable AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataLogicProcedure      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPositionForClient       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEntityFields            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyTableEntityMnemonic  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyTableEntityObjField  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataSource              AS HANDLE     NO-UNDO.

  &SCOPED-DEFINE xp-assign 
  {get CheckCurrentChanged lCheckCurrentChanged}
  {get FirstResultRow cFirstResultRow}
  {get LastResultRow cLastResultRow}
  {get QueryRowIdent cQueryRowIdent}
  {get LastRowNum iLastRowNum} 
  {get FirstRowNum iFirstRowNum} 
  {get FirstRowNum iFirstRowNum} 
  {get PositionForClient cPositionForClient}
  {get ForeignValues cForeignValues} 
  {get DataSource hDataSource} 
  . 
  &UNDEFINE xp-assign
  
    /* Rebuild the context string to look like: 
         prop1 CHR(4) val1 CHR(3) prop2 CHR(4) val2 CHR(3) ...                  */
    pcContext =
        "CheckCurrentChanged":U + CHR(4) +
            (IF lCheckCurrentChanged THEN "Yes":U ELSE "No":U) + CHR(3) +
        "FirstResultRow":U + CHR(4) + 
            (IF cFirstResultRow = ? THEN "?":U ELSE cFirstResultRow) + CHR(3) +
        "LastResultRow":U + CHR(4) + 
            (IF cLastResultRow = ? THEN "?":U ELSE cLastResultRow) + CHR(3) +
        "LastRowNum":U + CHR(4) + 
            (IF iLastRowNum = ? THEN "?":U ELSE STRING(iLastRowNum)) + CHR(3) +
        "FirstRowNum":U + CHR(4) + 
            (IF iFirstRowNum = ? THEN "?":U ELSE STRING(iFirstRowNum)) + CHR(3) +
        /* foreignvalues is not valid with no source and passing ?  to a 
           client will corrupt an object that has a source on client */ 
        (IF VALID-HANDLE(hDataSource) OR cForeignValues <> ?
         THEN "ForeignValues":U + CHR(4) + 
                (IF cForeignValues = ? THEN "?":U ELSE cForeignValues) + CHR(3)
         ELSE '') + 
        "QueryRowIdent":U + CHR(4) + 
            (IF cQueryRowIdent = ? THEN "?":U ELSE cQueryRowIdent)
         /* only needed if not unknown */
         + (IF cPositionForClient <> ? 
            THEN CHR(3) + "PositionForClient":U + CHR(4) + cPositionForClient
            ELSE '':U)
            .
  IF SESSION:CLIENT-TYPE = "WEBSPEED":U THEN 
  DO:
    &SCOPED-DEFINE xp-assign
    {get DataFieldDefs cDefs}
    {get QueryWhere cQueryWhere}
     .
    &UNDEFINE xp-assign
    IF cDefs = '':U THEN
    DO:
      &SCOPED-DEFINE xp-assign
       {get Tables cTables}
       {get PhysicalTables cPhysicalTables}
       {get DataColumns cDataColumns}
       {get DataColumnsByTable cDataColumnsByTable}
       {get UpdatableColumnsByTable cUpdatableColumnsByTable}
       {get AssignList cAssignList}
       {get BaseQuery cBaseQuery}
       {get DataLogicProcedure cDataLogicProcedure}
       {get EntityFields cEntityFields}
       {get KeyTableId  cKeyTableEntityMnemonic}
       {get KeyFields  cKeyTableEntityObjField}
      &UNDEFINE xp-assign
      
       pcContext = pccontext + CHR(3) +
           "Tables":U + CHR(4) +
              (IF cTables = ? THEN "?" ELSE cTables) + CHR(3) +
           "PhysicalTables":U + CHR(4) +
              (IF cPhysicalTables = ? THEN "?" ELSE cPhysicalTables) + CHR(3) +
           "BaseQuery":U + CHR(4) +
              (IF cBaseQuery = ? THEN "?" ELSE cBaseQuery) + CHR(3) +
           "DataColumns":U + CHR(4) +
              (IF cDataColumns = ? THEN "?" ELSE cDataColumns) + CHR(3) +
           "DataColumnsByTable":U + CHR(4) +
              (IF cDataColumnsByTable = ? THEN "?" ELSE cDataColumnsByTable) + CHR(3) +
           "UpdatableColumnsByTable":U + CHR(4) +
              (IF cUpdatableColumnsByTable = ? THEN "?" ELSE cUpdatableColumnsByTable) + CHR(3) +
           "AssignList":U + CHR(4) +
              (IF cAssignList = ? THEN "?" ELSE cAssignList) + CHR(3) +
           "DataLogicProcedure":U + CHR(4) +
              (IF cDataLogicProcedure = ? THEN "?" ELSE cDataLogicProcedure) + CHR(3) +
           "EntityFields":U + CHR(4) +
              (IF cEntityFields = ? THEN "?" ELSE cEntityFields) + CHR(3) +
           "KeyTableId":U + CHR(4) +
              (IF cKeyTableEntityMnemonic = ? THEN "?" ELSE cKeyTableEntityMnemonic) + CHR(3) +
           "KeyFields":U + CHR(4) +
              (IF cKeyTableEntityObjField = ? THEN "?" ELSE cKeyTableEntityObjField)
           .
    END.
    
    IF cQueryWhere = ? THEN cQueryWhere = '':U.
    
    /* if the Qstring <> Qwhere then we better return nothing as it indicates
       something is wrong or out of synch.. known case: the querystring is set
       when dataAvilable('reset') is called (possibly not necessary, but... ) 
       and not applied because the parent had no data after all 
       Under these circum stances we do not need the foreign fields in the 
       query as there is no requests that can happen until the parent 
       changes again. (The reason why we return FF in the query is that 
       the data may be batched) */           
    {get QueryString cQueryString}.  

    IF cQueryString > '':U AND (cQueryString <> cQueryWhere) THEN
      cQueryWhere = '':U.
    
    /* The Qcolumns is in synch with QString, so do not return it if it 
       is not in synch, indicated by queryWhere blank  see above   */     
    IF cQueryWhere > '':U THEN
      {get Querycolumns cQueryColumns}.

    ELSE cQueryColumns = ?.

    pcContext = pcContext  
              + (IF cQueryWhere <> ? 
                 THEN CHR(3) + "QueryWhere":U + CHR(4) + cQueryWhere
                 ELSE '':U)
              + (IF cQueryColumns <> ? 
                 THEN CHR(3) + "QueryColumns":U + CHR(4) + cQueryColumns
                 ELSE '':U).
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContextAndDestroy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getContextAndDestroy Procedure 
PROCEDURE getContextAndDestroy :
/*------------------------------------------------------------------------------
  Purpose:     Server-side procedure run after new data has been requested by 
               the client.
  Parameters:  OUTPUT pcContaineProps - Properties of the Contained SDOs
  Notes:       getContextAndDestroy is invoked from the client side of the
               SmartDataObject and executed on the server side. 
------------------------------------------------------------------------------*/
   DEFINE OUTPUT PARAMETER pcContext AS CHAR NO-UNDO.
                                                                                      
   pcContext = {fn obtainContextForClient}.
   RUN destroyObject IN TARGET-PROCEDURE.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeLogicObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeLogicObject Procedure 
PROCEDURE initializeLogicObject :
/*------------------------------------------------------------------------------
  Purpose:     Start the logic procedure for the data object
  Parameters:  <none>
  Notes:       The Logic Procedure is an optional object that can contain 
               validation and business logic for a particular table.  
               Rules: 
               - The RUN is ALWAYS executed with (or without) the extension that 
                 is defined in DataLogicProcedure property 
                 ( this ensures that program-name and :file-name behave as expected)
               - follows Progress core run rules:       
                1. ANY extention will run r-code if found 
                2. will run .r if NO period in run name 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cLogicProc   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDummy       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDotRFile    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMemberFile  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDbList      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iDb          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lUseProxy    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSourceExt   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iExt         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cProxyName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProxyDotR   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cExtension   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFile        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRunName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hObject      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lWebClient   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lRunProxy    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cMessage     AS CHARACTER NO-UNDO.
  &SCOPED-DEFINE xp-assign
  {get DataLogicProcedure cLogicProc}
  {get DataLogicObject hObject}
  .
  &UNDEFINE xp-assign

  IF cLogicProc = '':U THEN
    RETURN.

  IF VALID-HANDLE(hObject) THEN
    RETURN.

  iExt = R-INDEX(cLogicProc,'.':U).
  IF iExt > 1 THEN
    ASSIGN
      cFile      = SUBSTR(cLogicProc,1,iExt - 1)
      cExtension = SUBSTR(cLogicProc,iExt).
  ELSE
    cFile = cLogicProc.

  lWebClient = SESSION:CLIENT-TYPE = 'WEBCLIENT':U.
  
  /* If not web client and any db connections find r-code for inspection */   
  IF NOT lWebClient AND NUM-DBS > 0 THEN
  DO:
    ASSIGN /* Find the .r file */
      FILE-INFO:FILE-NAME = cFile + ".r":U
      cDotRFile           = FILE-INFO:FULL-PATHNAME
       /* If .r in proc lib, get the member name (ie, filename). */
      cMemberFile = MEMBER(cDotRFile).
  
    IF cMemberFile <> ? THEN
      cDotRFile = cMemberFile.
  END. /* any db */
  ELSE
    lUseProxy = TRUE.

  /* We have found the base .r */
  IF cDotRFile NE ? THEN 
  DO:  
    ASSIGN 
      RCODE-INFO:FILE-NAME = cDotRFile
      cDBList              = RCODE-INFO:DB-REFERENCES.
    DO iDB = 1 TO NUM-ENTRIES(TRIM(cDBList)):   /* Remove blank when no db */
      IF NOT CONNECTED(ENTRY(iDB,cDBList)) THEN 
      DO:
        lUseProxy = TRUE. /* Flag that we can't use the base file. */
        LEAVE.
      END.  /* Found a DB that needs to be connected that isn't */
    END.  /* Do for each required DB */
    IF NOT lUseProxy THEN
      cRunName = cFile + cExtension.
  END.
  
  /* if not connected or no r-code found check if there is proxy r-code */
  IF cRunName = '':U THEN
  DO:
    ASSIGN
      cProxyName = cFile      + '_cl':U
      cProxyDotR = cProxyName + '.r':U.
    
    {get RunDataLogicProxy lRunProxy}.

    /* if no proxy r-code, check if we have source code */
    IF lRunProxy <> NO THEN  /* include 'unknown' */
    DO:
      IF  SEARCH(cProxyDotR) = ? THEN
      DO:
        IF lRunProxy THEN /* if TRUE, force a 'RUN' of the proxy */
          cRunName = cProxyName + cExtension.
        ELSE IF cExtension > '':U THEN
        DO:
          IF lUseProxy THEN
            cRunName = cProxyName + cExtension.
          ELSE 
            cRunName = cFile + cExtension.     
          IF SEARCH(cRunName) = ? THEN
            cRunName = '':U.
        END.
      END. /* SEARCH(cProxyDotR) = ? */
      ELSE
        cRunName = cProxyName + cExtension.
    END. /* if lRunProxy <> NO */
  END.
  
  IF cRunName > '':U THEN
  DO: 
    DO ON STOP UNDO, LEAVE:   
      RUN VALUE(cRunName) PERSISTENT SET hObject.
      TARGET-PROCEDURE:ADD-SUPER-PROCEDURE(hObject, SEARCH-TARGET).
      {set DataLogicObject hObject}.   
    END.
    /* The SDO cannot run without the specified data logic */
    IF NOT VALID-HANDLE(hObject) THEN
      RUN destroyObject IN TARGET-PROCEDURE. 
  END.  
  /* Default behavior is to forgive the absence of a DLP unless */
  /* RunProxy = yes  */
  ELSE IF NOT lUseProxy OR lRunProxy THEN
  DO:
    cMessage = substitute({fnarg messageNumber 33},cLogicProc).
    
    RUN showMessageProcedure IN TARGET-PROCEDURE(cMessage, OUTPUT cDummy).
    
    if {fn getManageReadErrors} then
       run addMessage in target-procedure(cMessage,?,?).
    RUN destroyObject IN TARGET-PROCEDURE. 
  END.
     
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Performs SmartDataObject-specific initialization. 
  Parameters:  <none>
        Note:  Connects to the Appserver, but from version 9.1D the
               Server side object is no longer started at initialization.  
   Note date: 2002/02/02  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAppService     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSvrFileName    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUIBMode        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSource         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContainer      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lQueryContainer AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDynamicSDO     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lOpenOnInit     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hAppService     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lWait           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lInitialized    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hDataSource     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lQuerySource    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cContAppservice AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hRowObject      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cAsDivision     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cReturn         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lHideOnInit     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cEntityFields   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lFoundInCache   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hParentSource   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lParentIsQuery  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lParentAvail    AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE lShareData      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iCacheDuration  AS INTEGER    NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get UIBMode cUIBMode}
  {get AsDivision cAsDivision}
  {get ContainerSource hContainer}
  {get DataSource hDataSource}
  {get OpenOnInit lOpenOnInit}
  .   
  &UNDEFINE xp-assign
  
   /* If this object's Container is itself a query, set a prop
      to indicate that; this tells us if we're in an SBO. */
  IF VALID-HANDLE(hContainer) THEN
  DO:
    {get QueryObject lQueryContainer hContainer} NO-ERROR.
    IF lQueryContainer = YES THEN
      {set QueryContainer YES}.   /* by default it's NO */
  END.  

  /* If the object has a Partition named, then connect to it. */
  /* Skip all this if we're in design mode or AsDivision already is 'server'. */
  IF cAsDivision <> 'SERVER':U AND cUIBMode = "":U THEN
  DO:
    /* ensure that initialization only happens once */
    {get ObjectInitialized lInitialized}.
    IF lInitialized THEN
      RETURN.

    /* If the LogicalObjectName is not set the SDO cannot be kept alive
       on the server (static SDO in a static container). In this case, 
       DestroyStateless must be forced to TRUE to avoid server-side memory 
       leaks caused by SDOs left running */
    IF NOT ({fn getLogicalObjectName} > "") THEN
      {set DestroyStateless TRUE}.
    
    IF lQueryContainer = YES THEN
    DO:
      {get ASDivision cASDivision hContainer}.
      {set ASDivision cASDivision}.
    END.
    IF VALID-HANDLE(hDataSource) THEN
    DO:
      {get QueryObject lQuerySource hDataSource}.
      hParentSource = hDataSource. 
      /* Set openoninit false if parent is closed and has openoninit false */ 
      IF lQuerySource AND NOT lQueryContainer THEN
      DO WHILE VALID-HANDLE(hParentSource) AND lOpenOnInit:
        lParentAvail = {fnarg rowAvailable '' hParentSource}.
        &SCOPED-DEFINE xp-assign
        {get OpenOnInit lOpenOnInit hParentSource} 
        {get DataSource hParentSource hParentSource}
         .
        &UNDEFINE xp-assign
        lOpenOnInit = lOpenOnInit OR lParentAvail.
        /* check if the new found parent is query object to avoid calling 
           non exixisting dtuff in non query objects at the end of an unresolved 
           pass-thru link  */
        if valid-handle(hParentSource) then 
        do:  
           {get QueryObject lParentIsQuery hParentSource}.
           /* bad source.. get out */
           if not lParentIsQuery then 
              leave.
        end.      
      END.
    END.

    /* The sbo subscribes to this event in order to update ObjectMapping
       (This is needed in the case the dataSource is an SBO)*/
    PUBLISH 'registerObject':U FROM TARGET-PROCEDURE.
    
    {get AppService cAppService}.
    IF cAppService NE "":U THEN
    DO:
      /* We have moved the actual server start until later, so it can 
         be done with one request. The connection should ideally also have 
         waited until really required, but it's only the first object of 
         specifc object that actually connects. 
         One reason that the connection happens here is that it may require 
         a login, which fails if it happens from the getAsHandle function 
         (cannot have wait-for in function call ...), 
         but we could of course have checked these properties, but the main 
         reason is that there are some dependencies of the different AS 
         properties that also would need to be resolved .. 
         AsDivison = 'client', asHasStarted etc....  */
      
      RUN connectServer IN TARGET-PROCEDURE (OUTPUT hAppService). 
      IF hAppService  = ? THEN
         RETURN ERROR 'ADM-ERROR':U.
      /* connectserver sets the AsDivision */
      {get AsDivision cAsDivision}.
      IF VALID-HANDLE(hContainer) THEN
        {fnarg registerAppService cAppservice hContainer}.
    END.  /* IF AppService NE "":U */
    ELSE
    DO:
      /* If no AppService defined, check if the user is running the client
         proxy, or the dynamic SDO. If so, there can't be any required databases 
         connected for the object to show data. Probably an AppServer setup 
         problem. If there's no container handle, then we are running on
         the AppServer, so there's nothing to check. */
      IF VALID-HANDLE(hContainer) THEN
      DO:
           /* This new property in 9.1B holds the file name to run on the
              AppServer. If it's a dynamic SDO, the file name being run won't
              be usable (it will be dyndata). */
          {get ServerFileName cSvrFileName}.
          {get DynamicSDOProcedure cDynamicSDO hContainer} NO-ERROR.
          cDynamicSDO = ENTRY(1, cDynamicSDO, ".":U).  /* Remove .r or .w */
          IF (TARGET-PROCEDURE:FILE-NAME MATCHES '*_cl~~.*':U OR
              TARGET-PROCEDURE:FILE-NAME MATCHES '*':U + cDynamicSDO + '.*':U) THEN
          DO:
            IF lQueryContainer THEN DO:  /* if part of SBO make sure we have AppService */
              {get AppService cContAppService hContainer}.
              IF cContAppService = "":U THEN DO:
                RUN showMessageProcedure IN TARGET-PROCEDURE (
                  SUBSTITUTE({fnarg messageNumber 46}, cSvrFileName, hcontainer:FILE-NAME),
                  OUTPUT glShowMessageAnswer).
                       /* This is necessary to inform the SBO of the problem. */
                       /* The RETURN value is not enough as 'initializeObject' has */
                       /* been PUBLISHED and not RUN */
                  RUN addMessage IN TARGET-PROCEDURE ("ADM-ERROR":U,?,?).
                  RETURN "ADM-ERROR":U. 
              END.
            END.
            ELSE DO: 
              /*DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE,*/
              RUN showMessageProcedure IN TARGET-PROCEDURE (
                cSvrFileName 
                + " " + {fnarg messageNumber 47}, 
                OUTPUT glShowMessageAnswer).
                RETURN "ADM-ERROR":U.
            END.
          END.    /* END DO IF running the wrong object -- showMessage */
      END.      /* END DO IF hContainer defined -- not on AppServer. */   
    END.          /* ELSE DO IF AppService EQ "":U */

    /* If this object has a Commit-Source (a Commit Panel or the like) then
       we set the AutoCommit flag off. If this object is just being used
       to update another QueryObject, then this is an error. */
    {get CommitSource hSource}.
    IF hSource NE ? THEN
      {set AutoCommit no}.

  END.  /* AsDivision <> 'server' and not UIBMode   */

  IF VALID-HANDLE(hContainer) AND cAsDivision = 'CLIENT':U THEN
      /* Check AppServer properties to see if the object has no current or future 
         server bindings and is using a stateless operating mode. */  
    lWait = {fn isFetchPending hContainer} AND {fn hasNoServerBinding}.

  /* Create temptables if dynamic, unless we are inside an SBO in which case
     the SBO will run createObjects from its createObjects. */
  IF (NOT (cAsDivision = 'CLIENT' AND lOpenOnInit) AND NOT lQueryContainer) 
  OR cAsDivision = 'SERVER':U THEN
  DO:
    RUN createObjects IN TARGET-PROCEDURE NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> '':U THEN
      RETURN 'ADM-ERROR':U.
  END.
  
  {set ObjectInitialized TRUE}.
  
  IF (NOT cUIBMode BEGINS "Design":U) THEN 
  DO:
    IF cAsDivision <> 'SERVER':U THEN
    DO:
      {get HideOnInit lHideOnInit}.
      IF NOT lHideOnInit THEN 
      DO:
        /* The Objecthidden is set and used also for non-visual objects */
        {set ObjectHidden NO}.
        PUBLISH "LinkState":U FROM TARGET-PROCEDURE ('active':U).  
      END.
      ELSE DO:
        /* The Objecthidden is set and used also for non-visual objects */
        {set ObjectHidden YES}.
        PUBLISH "LinkState":U FROM TARGET-PROCEDURE ('inactive':U).  
      END.
      /* Use cache if inside pending datacontainer request on client 
      (openquery does this otherwise) */ 
      IF lWait THEN 
        lFoundInCache = {fn initializeFromCache}.   
    END. /* asdivision <> 'server' */
  
    IF NOT lFoundInCache THEN
    DO:
      /* Retrieve stored filter information */      
      IF cAsDivision <> 'SERVER':U AND VALID-HANDLE (hContainer) THEN
      DO:
        /* if we're going to cache data then we retrieve all data before 
           we apply the filter or else the filter would apply to other 
           objects using the cache  (We retrievefilter in openFromCache, 
           so that it is applied on the client) */
          /* ok.. default values.. */
        ASSIGN lShareData = FALSE
               iCacheDuration = 0. 
        IF lWait AND cAsDivision = 'CLIENT':U THEN 
        DO:
           &SCOPED-DEFINE xp-assign
          {get ShareData lShareData}
          {get CacheDuration iCacheDuration}
           .
         &UNDEFINE xp-assign
        END.
        IF lShareData = FALSE AND iCacheDuration = 0 THEN
          RUN retrieveFilter IN TARGET-PROCEDURE.
      END.
    
      /* retrieve entitydetails on the first call on server (cEntityFields = ?) */ 
      IF VALID-HANDLE(gshGenManager) AND cAsDivision <> 'CLIENT':U THEN 
      DO:
        {get EntityFields cEntityFields}.
        IF cEntityFields = ? THEN
          RUN initializeEntityDetails IN TARGET-PROCEDURE.
      END.
      
      /* Don't open the query or run dataavailable if we're inside a 
         container such as an SBO or waiting for the datacontainer's fetch
         in that case it gets our data for us. */  
      IF NOT (lQueryContainer = TRUE) AND NOT lWait THEN
      DO:
        IF lOpenOnInit THEN
        DO:
          /* If not managed by a DataContainer or an SBO ensure that any ad-hoc 
             appserver request from this object keeps the connection until the data 
             request has completed */
          {set BindScope 'data':U}. 
          IF hDataSource = ? OR NOT lQuerySource THEN 
            {fn openQuery}.
          ELSE 
            RUN dataAvailable IN TARGET-PROCEDURE (?).  /* Don't know if different row. */
        END.
      END.   
  
      IF lQueryContainer THEN 
        {get OpenOnInit lOpenOnInit hContainer}.
    
      /* If the query is not opened at initialize, we must ensure that 
         queryposition is correct. This is managed from the container if 
         queryContainer (SBO). */
      IF NOT lOpenOnInit THEN 
      do:
        /* ensure that query has foreignkey also when openoninit false
           (client only)  - from 10.1C */ 
        if cAsDivision <> 'server':U and valid-handle(hDataSource) then
          {fn addForeignKey}.
        RUN updateQueryPosition IN TARGET-PROCEDURE.
      end.
    END.
  END. /* NOT uibmode begins 'design' */

  /* If no query container and no fetch pending in datacontainer 
     then do last resort definition retrieval for dynamic object
     and also ensure server is unbound.*/  
  IF NOT lWait THEN
  DO:
    /* Still no TT defined then we go to the server and get it 
       This will typically be the case in dynamic data objects when OpenOnInit 
       is false either in this object or in a datasource object */   
    IF cAsDivision = 'CLIENT':U AND NOT lQueryContainer  THEN
    DO:
      {get RowObject hRowObject}.
      IF NOT VALID-HANDLE(hRowObject) THEN
      DO:
        RUN fetchDefinitions IN TARGET-PROCEDURE NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> '':U THEN
          cReturn = 'ADM-ERROR'.
      END.
    END.          
    RUN unbindServer IN TARGET-PROCEDURE('unconditional':U).
  END. /* not wait */

  IF cRETURN = "ADM-ERROR":U THEN
    RETURN "ADM-ERROR":U.
  ELSE 
    RETURN.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isUpdatePending) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE isUpdatePending Procedure 
PROCEDURE isUpdatePending :
/*------------------------------------------------------------------------------
  Purpose:  Published through data-targets to check if any updates are pending
            Overrides dataview to include UpdateFromSource and RowObjectState.   
  Parameters: input-output plUpdate 
              Returns TRUE and stops the publishing if update is pending. 
  Notes:      New is included as a pending update. 
              Called from canNavigate, which is used by navigating objects to 
              check if they can trust an updateState('updatecomplete') message
          NB! This check is only valid from a DataSource point of view. 
              Use canNavigate to check an actual object.  
------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT PARAMETER plUpdate AS LOGICAL    NO-UNDO.
   
  DEFINE VARIABLE lUpdateFromSource AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cRowObjectState AS CHARACTER  NO-UNDO.

  /* No need to check a pending update was found somewhere else */
  IF NOT plUpdate THEN
  DO:
    &SCOPED-DEFINE xp-assign
    {get UpdateFromSource lUpdateFromSource}
    {get RowObjectState cRowObjectState}
    .
    &UNDEFINE xp-assign
    /* set update pending state if  uncommitted changes */
    plUpdate = (cRowObjectState = 'RowUpdated':U).
    /* No need to check if this SDO is a 1-to-1 child or it was set above. */
    IF NOT lUpdateFromSource AND NOT plUpdate THEN
      RUN SUPER (INPUT-OUTPUT plUpdate).
  END. /* not plUpdate */

  RETURN. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-linkState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkState Procedure 
PROCEDURE linkState :
/*------------------------------------------------------------------------------
  Purpose:     Run LinkStatHandler in source(pcState) if ToggleDataTargets
               And publish the state with a potential appended 'Target' 
               Recieved from DataTargets.                                
  Parameters:  pcState AS CHARACTER -- 'active'/'inactive'
               The event is republished up through a groupAssignSource and 
               a DataSource.
             - Overrides dataview due to the use of getTargetProcedure. 
             - The logic is separated into processLinkState in the dataview in 
               order to allow this override without duplicating all logic.     
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcState  AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE hSourceProcedure AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cObjectType      AS CHARACTER  NO-UNDO.

  hSourceProcedure = SOURCE-PROCEDURE. 
  {get ObjectType cObjectType SOURCE-PROCEDURE}.
  IF cObjectType = 'SUPER':U THEN
    hSourceProcedure = {fn getTargetProcedure SOURCE-PROCEDURE}. 

  RUN processLinkState IN TARGET-PROCEDURE(hSourceProcedure,pcState).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-postTransactionValidate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE postTransactionValidate Procedure 
PROCEDURE postTransactionValidate :
/*------------------------------------------------------------------------------
  Purpose: Validation hook for code to be executed immediately after the 
           transaction. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  RUN bufferTransactionValidate IN TARGET-PROCEDURE ('post':U). 

  RETURN RETURN-VALUE.  
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareDataForFetch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prepareDataForFetch Procedure 
PROCEDURE prepareDataForFetch :
/*------------------------------------------------------------------------------
  Purpose:    Prepare the object and retrieve all info for a stateless server
              request.
  Parameters: 
    phTopContainer Handle of the container that manages the request 
    pcAppService   AppService of this request      
    pcSourceName   Qualified DataSource name
                   Unknown if this is the top level in this request.
                   For a 'POSITION' request this is 
                   handle , KeyField , FieldName   
                   
    pcOptions      Options for this request          
                   - 'INIT', initialization, used to skip DataObjects where 
                      OpenOnInit is false.
                   - 'BATCH', request for another batch, tells prepareForFetch
                     to keep the temp-table.        
                   - 'POSITION', prepare position info. If the object already 
                     is prepared then this just adds another chr(2) entry to 
                     the QueryFields, otherwise we also need to prepare. 
                                        
i-o pcHandles      Data object handle, comma-separated 
i-o pcRunNames     Name that the server can use to start the object, comma-separated. Currently the physical name only.
i-o pcQualNames    [ContainerName: [Containername:].. InstanceName, comma-separated
                   Passed to server to be able to set context in correct objects
i-o pcQueryFields  Contains ForeignField information and position information
i-o pcQueries      QueryString, chr(1)-separated.
i-o pcTempTables   Temp-table handles. comma-separated                     
  
  Notes:           Returns SKIP for SDOs with openOnInit true if they need to 
                   get the table definition from the server.      
------------------------------------------------------------------------------*/
 DEFINE INPUT        PARAMETER phTopContainer  AS HANDLE     NO-UNDO.
 DEFINE INPUT        PARAMETER pcAppService    AS CHARACTER  NO-UNDO.
 DEFINE INPUT        PARAMETER pcSourceName    AS CHARACTER  NO-UNDO.
 DEFINE INPUT        PARAMETER pcOptions       AS CHARACTER  NO-UNDO.
 
 DEFINE INPUT-OUTPUT PARAMETER pcHandles       AS CHARACTER  NO-UNDO.
 DEFINE INPUT-OUTPUT PARAMETER pcRunNames      AS CHARACTER  NO-UNDO.
 DEFINE INPUT-OUTPUT PARAMETER pcQualNames     AS CHARACTER  NO-UNDO.
 DEFINE INPUT-OUTPUT PARAMETER pcQueryFields   AS CHARACTER  NO-UNDO.
 DEFINE INPUT-OUTPUT PARAMETER pcQueries       AS CHARACTER  NO-UNDO.
 DEFINE INPUT-OUTPUT PARAMETER pcTableInfo     AS CHARACTER  NO-UNDO.

 DEFINE VARIABLE lPosition        AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE lVisualTargets   AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cQualName        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hContainerSource AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cContainerName   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iPrepare         AS INTEGER    NO-UNDO.
 DEFINE VARIABLE hParent          AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cTargets         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hTarget          AS HANDLE     NO-UNDO.
 DEFINE VARIABLE iTarget          AS INTEGER    NO-UNDO.
 DEFINE VARIABLE lQuery           AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE iField           AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cForeignFields   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cField           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cRunName         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lFirst           AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE hRowObjectTable  AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cObjectName      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cMode            AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cQuery           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cAppService      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lOpenOnInit      AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE lUseRepository   AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cFieldName       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cContainerType   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cPosition        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cColumn          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cValue           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lRebuild         AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE iLastRowNum      AS INTEGER    NO-UNDO.
 DEFINE VARIABLE iFirstRowNum     AS INTEGER    NO-UNDO.
 DEFINE VARIABLE lInit            AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE lSkip            AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE hRowObject       AS HANDLE     NO-UNDO.
 DEFINE VARIABLE lInitOfOpened    AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE iCacheDuration   AS INTEGER    NO-UNDO.
 DEFINE VARIABLE lShareData       AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE hDataSource      AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cLogicalName     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cSourceType      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cSBOSDO          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cSourceName      AS CHARACTER  NO-UNDO.

 {get AppService cAppService}.
 IF pcAppservice <> ? AND cAppService <> pcAppservice THEN
   RETURN.

 ASSIGN
   lPosition      = LOOKUP('POSITION':U,pcOptions) > 0
   lVisualTargets = LOOKUP('VISUALTARGETS':U,pcOptions) > 0
   lInit          = LOOKUP('INIT':U,pcOptions) > 0.

 /* return or set Skip flag if this is initialization and OpenOnInit is false
   (the skip falg is set if we need to get the rowObject definition from server)*/  
 IF lInit THEN
 DO:
   {get QueryOpen lInitOfOpened}.   
   /* If the query is open then it must have been opened in initializeObject */ 
   IF NOT lInitOfOpened THEN
   DO:
     {get OpenOnInit lOpenOnInit}.

     IF NOT lOpenOnInit THEN 
     DO:
       {get RowObject hRowObject}.
       /* Return if the rowobject is defined */
       IF VALID-HANDLE(hRowObject) THEN
         RETURN.
       /* If this is a dynamic object not yet defined then we pass 'SKIP' 
          to the server to retrieve the definitions */   
       lSkip = TRUE.
     END.
   END.
   /* If position request and object is open on client then bail out  */ 
   ELSE IF lPosition THEN 
     RETURN.
 END.

 /* Skip this data object if the DataSource link is inactive unless this 
    is a position prepare OR we are the top requesting object
   (If a container uses initPages to start this page it (need to) set 
    hideOnInit to true in all objects before notifyPage(initializeObject). 
    The hideOnInit make the SDO link to a potential DataSource inactive, 
    which again made initializeObject -> dataAvailable - openQuery 
     - fetchContainedData -> fail as it bailed out here)  */ 
 IF NOT lPosition AND pcSourceName > '':U AND NOT lSkip THEN
 DO:
   IF DYNAMIC-FUNCTION('isLinkInactive':U IN TARGET-PROCEDURE,'DataSource':U,?) THEN
     RETURN. 
 END.
 
 /* In order to return and pass a unique qualified name we find out where we 
    are in the container hierarchy by looping upwards from our container uptil 
    the container that originated the request. Each containername is prepended
    as qualifier */   
 {get ContainerSource hContainerSource}. 
 DO WHILE hContainerSource <> phTopContainer:
   {get ObjectName cContainerName hContainerSource}
    cQualName = cContainerName
              + (IF cQualName = '':U THEN '':U ELSE ':':U)
              + cQualName
              + (IF cQualName = '':U THEN ':':U ELSE '':U).
   {get ContainerSource hContainerSource hContainerSource}.   
   IF hContainerSource = ? THEN RETURN.
 END. 
 
 &SCOPED-DEFINE xp-assign
 {get ObjectName cObjectName}
 {get ServerFileName cRunName} 
 {get LogicalObjectName cLogicalName} 
  .
  &UNDEFINE xp-assign
 /* We currently pass the rendering procedure to the server also for dynamics */
 IF cLogicalName > '' THEN
   cRunName = cRunName + ':' + cLogicalName.
  
 ASSIGN
   cQualName = cQualName + cObjectName
   iPrepare  = LOOKUP(cQualName,pcQualNames).


 IF iPrepare = 0 THEN
 DO:
   IF lPosition THEN
   DO:
     &SCOPED-DEFINE xp-assign
     {get FirstRowNum iFirstRowNum} 
     {get LastRowNum iLastRowNum}
     {get QueryOpen lInitOfOpened} 
     . 
     &UNDEFINE xp-assign
     /* If we have all data on the client, just return */  
     IF iFirstRowNum <> ? AND iLastRowNum <> ? THEN
        RETURN.

     IF lInitOfOpened THEN
     DO:
       {get RebuildOnRepos lRebuild}.
       IF NOT lRebuild THEN 
       DO:
         RETURN. /* -------------->  get out */
          /* we need better info about the client data set before we can search 
             on the server with some data on the client, but if this is to be 
             supported then we would just set the mode and make this into a batch 
             request  
          cMode = 'Batch':U. 
          */
       END.
     END.
   END.
   IF NOT lInitOfOpened THEN 
   DO:
     IF NOT lSkip THEN
     DO:
       /* set mode to pass to prepareForFetch 
          1 - if parent is part of request 
              -> 'Child' = remove foreignkey in order to reapply on server 
          2 - if parent is NOT part of request     
              -> 'ClientChild' = add foreignkey on client  
          3 - if batch - 
              -> 'Batch' = keep TT and batch properties */  
       IF NOT lPosition AND NOT lVisualtargets THEN 
       DO:
         IF pcSourceName <> ? AND pcSourceName <> '':U THEN
         DO: 
           {get DataSource hDataSource}.
           IF VALID-HANDLE(hDataSource) THEN
           DO:
             {get ObjectType cSourceType hDataSource}.
             
             {get ForeignFields cForeignFields}.             
             /* The SBO IDent is not part of server context and  will thus 
                not be found in pcQualNames, so grab the SDO from the first 
                qualifier in order to use the SDO name to check if the SBO 
                is part of this request. 
                Note that we pass the SDO name as parent id to the server.
                This will be used to link to the SBO on server */ 
             IF cSourceType = 'SmartBusinessObject':U THEN
               ASSIGN 
                 cSBOSDO     = ENTRY(2,cForeignFields)
                 cSBOSDO     = ENTRY(1,cSBOSDO,'.':U)
                 cSourceName = pcSourcename + ":":U + cSBOSDO.
             ELSE 
               cSourceName = pcSourcename.

             IF CAN-DO(pcQualNames,cSourceName) THEN
               ASSIGN
                 cForeignFields = cSourceName + ',':U + cForeignFields
                 cMode          = 'Child':U.

             ELSE /* parent not part of request, set mode to add foreignfields */
               cMode = 'ClientChild':U.
           END. /* valid datasource */
           ELSE /* this should not happen, but set mode to add foreignfields */
             cMode = 'ClientChild':U.
         END.
         ELSE IF CAN-DO(pcOptions,'Batch':U) THEN
           cMode = 'Batch':U.
         ELSE DO:
           /* If datasource exists, but no parent in request at all then 
              set mode to add foreignfields */   
           {get DataSource hDataSource}.
           IF VALID-HANDLE(hDataSource) THEN 
             cMode = 'ClientChild':U.
         END.
       END.
       cQuery = {fnarg prepareForFetch cMode}.
     END. /* if NOT lSkip */
     ELSE 
       cQuery = 'SKIP':U.
       
     &SCOPED-DEFINE xp-assign
       {get CacheDuration iCacheDuration}
       {get ShareData lShareData}
       {get RowObjectTable hRowObjectTable}
       .
     &UNDEFINE xp-assign
     ASSIGN  
       lFirst          = (pcHandles = '':U)  
       pcHandles       = pcHandles
                       + (IF lFirst THEN '':U ELSE ',':U)
                       + STRING(TARGET-PROCEDURE)
       pcQueries       = pcQueries
                       + (IF lFirst THEN '':U ELSE CHR(1))
                       + cQuery      
       pcTableInfo     = pcTableInfo
                       + (IF lFirst THEN '':U ELSE ',':U)
                       + (IF NOT VALID-HANDLE(hRowObjectTable) 
                          OR iCacheDuration <> 0 
                          OR lShareData
                          THEN '?':U
                          ELSE STRING(hRowObjectTable))
       pcQualNames     = pcQualNames
                       + (IF lFirst THEN '':U ELSE ',':U)
                       + cQualName
       pcRunNames = pcRunNames
                       + (IF lFirst THEN '':U ELSE ',':U)
                       + cRunName
       pcQueryFields = pcQueryFields
                       + (IF lFirst THEN '':U ELSE CHR(1))
                       + IF cForeignFields <> ? 
                         THEN cForeignFields ELSE '':u.   
   END.  /* not already open */
 END. /* not prepared*/  
 
 IF lPosition THEN
 DO:
   IF iPrepare > 0  THEN
     ENTRY(iPrepare,pcQueryFields,CHR(1)) = 
           ENTRY(iPrepare,pcQueryFields,CHR(1)) 
           + CHR(2)
           + pcSourceName.
   ELSE 
     pcQueryFields = pcQueryFields
                   + CHR(2)
                   + pcSourceName.   
 END.

 ELSE DO:   
   {get DataTarget cTargets}. 
   TargetLoop:
   DO iTarget = 1 TO NUM-ENTRIES(cTargets):
     ASSIGN
       lQuery = FALSE
       hTarget = WIDGET-HANDLE(ENTRY(iTarget,cTargets))
       .

     &SCOPED-DEFINE xp-assign
     {get QueryObject lQuery hTarget}       
     {get ContainerType cContainerType hTarget}  
     &UNDEFINE xp-assign
     .

     IF lQuery THEN
       /* prepare data object data targets */
       RUN prepareDataForFetch IN hTarget
            (phTopContainer,
             IF pcAppService = ? THEN cAppService ELSE pcAppService,
             cQualName,
             pcOptions,
             INPUT-OUTPUT pcHandles,
             INPUT-OUTPUT pcRunNames,
             INPUT-OUTPUT pcQualNames,
             INPUT-OUTPUT pcQueryFields,
             INPUT-OUTPUT pcQueries,
             INPUT-OUTPUT pcTableInfo).  

     ELSE IF lVisualTargets AND cContainerType > '':U THEN
     DO:
       /* prepare Visual container targets 
           -> prepare position info for their SDF data Sources    */
       RUN prepareDataForFetch IN hTarget
            (phTopContainer,
             IF pcAppService = ? THEN cAppService ELSE pcAppService,
             cQualName,
             'POSITION':U + IF lInit THEN ',INIT':U ELSE '':U,
             INPUT-OUTPUT pcHandles,
             INPUT-OUTPUT pcRunNames,
             INPUT-OUTPUT pcQualNames,
             INPUT-OUTPUT pcQueryFields,
             INPUT-OUTPUT pcQueries,
             INPUT-OUTPUT pcTableInfo).  
     END.
   END.
 END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareErrorsForReturn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prepareErrorsForReturn Procedure 
PROCEDURE prepareErrorsForReturn :
/*------------------------------------------------------------------------------
  Purpose:  This appends the RETURN-VALUE from the user-defined transaction
            validation procedure or other update-related error to the list
            of any errors already in the log, and formats this string to
            prepare for returning it to the client.
    Notes:  invoked internally from serverCommit.
------------------------------------------------------------------------------*/
 DEFINE INPUT        PARAMETER pcReturnValue AS CHARACTER NO-UNDO.
 DEFINE INPUT        PARAMETER pcASDivision  AS CHARACTER NO-UNDO.
 DEFINE INPUT-OUTPUT PARAMETER pcMessages    AS CHARACTER NO-UNDO.  
 
  IF pcReturnValue NE "":U THEN
    RUN addMessage IN TARGET-PROCEDURE (pcReturnValue, ?, ?).

  IF pcASDivision = 'Server':U THEN
     pcMessages = LEFT-TRIM(pcMessages + CHR(3) + {fn fetchMessages} ,CHR(3)).
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-preTransactionValidate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE preTransactionValidate Procedure 
PROCEDURE preTransactionValidate :
/*------------------------------------------------------------------------------
  Purpose: Validation hook for code to be executed immediately before the 
           transaction. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  RUN bufferTransactionValidate IN TARGET-PROCEDURE ('pre':U). 

  RETURN RETURN-VALUE.  
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pushRowObjUpdTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pushRowObjUpdTable Procedure 
PROCEDURE pushRowObjUpdTable :
/*------------------------------------------------------------------------------
  Purpose:     Transfer RowObjUpd table 
  Parameters:  INPUT pcValType AS CHARACTER -- "Pre" or "Post",
               INPUT-OUTPUT TABLE FOR RowObjUpd.
  Notes:       The static override is used for sbo server side updates
               in commitTransaction.p. This dynamic version is not used.   
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER TABLE-HANDLE phRowObjUpd.
   {set RowObjUpdTable phRowObjUpd}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pushTableAndValidate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pushTableAndValidate Procedure 
PROCEDURE pushTableAndValidate :
/*------------------------------------------------------------------------------
  Purpose:     wrapper for pre and postTransactionValidate procedures when
               run from SBO.
  Parameters:  INPUT pcValType AS CHARACTER -- "Pre" or "Post",
               INPUT-OUTPUT TABLE FOR RowObjUpd.
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER pcValType AS CHAR   NO-UNDO.
   DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd.
   {set RowObjUpdTable phRowObjUpd}.

   /* Split into two to accomodate the DynSBO which shares buffers instead of */
   /* transfering tables */

   RUN bufferValidate IN TARGET-PROCEDURE (INPUT pcValType).

   DELETE OBJECT phRowObjUpd NO-ERROR.

   RETURN RETURN-VALUE.   /* Return whatever we got from the val. proc. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-refreshBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshBuffer Procedure 
PROCEDURE refreshBuffer :
/*------------------------------------------------------------------------------
  Purpose: to return the latest version of the record to the client and
           refresh calculated fields
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER pocMessages AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER pocUndoIds  AS CHARACTER NO-UNDO INIT "":U.
    
  DEFINE VARIABLE hRowObjUpd    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObjUpd2   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery2       AS HANDLE     NO-UNDO.
    
  {get RowObjUpd hRowObjUpd}.
  CREATE BUFFER hRowObjUpd2 FOR TABLE hRowObjUpd.    
  CREATE QUERY hQuery2.
  hQuery2:SET-BUFFERS(hRowObjUpd2).
  hQuery2:QUERY-PREPARE('FOR EACH ' + hRowObjUpd2:NAME +
                       ' WHERE RowMod = "A" OR RowMod = "C" OR RowMod = "U"':U).
  hQuery2:QUERY-OPEN().
  hQuery2:GET-FIRST().
  DO WHILE hRowObjUpd2:AVAILABLE:
    RUN refetchDBRow IN TARGET-PROCEDURE (hRowObjUpd2) NO-ERROR.   
    IF ERROR-STATUS:ERROR THEN
    DO:
      pocUndoIds = pocUndoIds 
                 + STRING(hRowObjUpd2:BUFFER-FIELD('RowNum':U):BUFFER-VALUE) + CHR(3) + ",":U.
      /* Errors are now added to the message queue in refetchDbRow, 
         but we still check for return-value just in case.. */ 
      IF RETURN-VALUE <> '':U THEN
        RUN addMessage IN TARGET-PROCEDURE (RETURN-VALUE, ?, ?).
      DELETE OBJECT hRowObjUpd2.
      DELETE OBJECT hQuery2.
      UNDO, LEAVE.
    END.
    hQuery2:GET-NEXT().
  END.
  DELETE OBJECT hRowObjUpd2.
  DELETE OBJECT hQuery2.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-refreshRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshRow Procedure 
PROCEDURE refreshRow :
/*------------------------------------------------------------------------------
  Purpose:     To retrieve the current database values for a row already
               in the RowObject table.

  Parameters:  <none>
  
  Notes:       PUBLISHes dataAvailable ('SAME') to cause a SDViewer or
               Browser to display the latest values. Since the database 
               records are never locked on read, this procedure can fetch the
               latest values but cannot guarantee that they will not change
               before an update is done.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hDataQuery      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowObject      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iRows           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cRowIdent       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRowState       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iRowNum         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lNewRow         AS LOG       NO-UNDO.
  DEFINE VARIABLE rRowid          AS ROWID     NO-UNDO.
  DEFINE VARIABLE lDeleted        AS LOGICAL   NO-UNDO.
  
  DEFINE VARIABLE iTarget         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTargets        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTarget         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lQueryObject    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDisabled       AS CHARACTER  NO-UNDO.

   /* Nothing to refresh ..  */
  &SCOPED-DEFINE xp-assign
  {get NewRow lNewRow}    
  {get DataHandle hDataQuery}
  {get RowObject  hRowObject}
  {get RowObjectState cRowState}
  .
  &UNDEFINE xp-assign
  
  IF cRowState = 'RowUpdated':U THEN
  DO: /* if updates are in progress, can not continue */
     DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE, "24":U).
     RUN showMessageProcedure IN TARGET-PROCEDURE 
                 ('24':U, OUTPUT glShowMessageAnswer).
     RETURN.
  END.  /* if cRowState = rowupdated */
  
  IF lNewRow THEN 
    RETURN.  
  IF NOT hRowObject:AVAILABLE THEN
    RETURN.

  /* Save off the current RowIdent to pass to sendRows. It will re-retrieve
     that row from the database. */
  ASSIGN cRowIdent = hRowObject:BUFFER-FIELD('RowIdent':U):BUFFER-VALUE
         iRowNum   = hRowObject:BUFFER-FIELD('RowNum':U):BUFFER-VALUE.
  
  hRowObject:BUFFER-DELETE().      /* remove the old copy of the row. */
  
  /** find the prev rec as we want to position to it in case the refresh is
      gone (so why not next? at least in a browse this is less slick and
      makes it easier to see that weird stuff happened...maybe...? ) */ 
  hDataQuery:GET-PREV. 
  IF NOT hRowObject:AVAIL THEN
    hdataQuery:GET-FIRST.

  rRowid = hRowObject:ROWID.

  /** need logic and perhaps rules to decide how to deal with children 
  {get Datatarget cTargets}.
  DO iTarget = 1 TO NUM-ENTRIES(cTargets):
    hTarget = WIDGET-HANDLE(ENTRY(iTarget,cTargets)).
    IF VALID-HANDLE(hTarget) THEN
    DO:
      {get QueryObject lQueryObject hTarget}.
      IF lQueryObject THEN 
      DO:
        RUN linkStateHandler IN hTarget ("inactive":U,
                                         TARGET-PROCEDURE,
                                         "DataSource":U).
        cDisabled = cDisabled
                  + (IF iTarget = 1 THEN '':U ELSE ',':U)
                  + STRING(hTarget).
      END. /* QueryObject*/
    END. /* valid datatarget */
  END. /* Do iTarget = 1 to NUM */
  **/
  /* This special calling sequence tells sendRows to retrieve a new copy
     of the record pointed to by cRowIdent, give it the number iRowNum,
     and add it to the existing RowObject table. */
  RUN sendRows IN TARGET-PROCEDURE
                (iRowNum, 
                 cRowIdent, 
                 FALSE /* no Next */, 
                 1 /* Get just 1 row */, 
                 OUTPUT iRows).  
  
  /*
  DO iTarget = 1 TO NUM-ENTRIES(cDisabled):
    hTarget = WIDGET-HANDLE(ENTRY(iTarget,cDisabled)).
    IF VALID-HANDLE(hTarget) THEN
       RUN linkStateHandler IN hTarget ("active":U,
                                         TARGET-PROCEDURE,
                                         "DataSource":U).
  END. /* do iTarget = 1 to */
  */

  /* If nothing to refresh resort to plan B */
  IF iRows = 0 THEN
  DO:
    /* Get rid of the non existing row from the browse 
      (this seems to only be a problem on local connection, probably because
       the sdo does an explicit reposition on appserver? Could perhaps be 
       avoided on client, but only if we find a way to check for stale data 
       in the browse. SDO behavior may change, so use of Asdivision is risky) */
    PUBLISH 'refreshBrowse':U FROM TARGET-PROCEDURE.
    lDeleted  = TRUE.
    IF rRowid <> ? THEN
      hdataQuery:REPOSITION-TO-ROWID(rRowid).
  END.

  /* We check whether the record is available in order NOT to do this on a 
     browser, which fetches the record when the query is repositioned.  */  
  IF NOT hRowObject:AVAILABLE THEN
    hDataQuery:GET-NEXT().          

  /* Tell everyone we have a new copy of the same row. */
  PUBLISH 'dataAvailable' FROM TARGET-PROCEDURE (IF lDeleted THEN 'DIFFERENT' ELSE 'SAME':U).
  {set NewBatchInfo '':U}.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-remoteCommit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE remoteCommit Procedure 
PROCEDURE remoteCommit :
/*------------------------------------------------------------------------------
  Purpose:     Procedure executed on a server side SmartDataObject.   
               This is the equivalent of serverCommit, but can be run in 
               a not intialized object as it has input-ouput parameters for 
               context.  
  Parameters: 
   INPUT-OUTPUT  pcContext  - in Contextfrom client 
                              out new context
   INPUT-OUTPUT TABLE RowObjUpd - The Update version of the RowObject 
                                  Temp-Table
 
   OUTPUT cMessages - a CHR(3) delimited string of accumulated messages from
                      server.
   OUTPUT cUndoIds  - list of any RowObject ROWIDs whose changes need to be 
                       undone as the result of errors in the form of:
               "RowNumCHR(3)ADM-ERROR-STRING,RowNumCHR(3)ADM-ERROR-STRING,..."

 Notes:        If another user has modified the database records since the 
               original was read, the new database values are copied into the 
               RowObjUpd record and returned to Commit so the UI object can 
               display them.
------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT  PARAMETER pcContext AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT  PARAMETER TABLE-HANDLE phRowObjUpd.
  DEFINE OUTPUT PARAMETER pcMessages AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcUndoIds  AS CHARACTER  NO-UNDO.
                          
  {set RowObjUpdTable phRowObjUpd}.

  RUN setContextAndInitialize IN TARGET-PROCEDURE (pcContext).

  RUN bufferCommit IN TARGET-PROCEDURE
                 (OUTPUT pcMessages,
                  OUTPUT pcUndoIds).
                  
  pcContext = {fn obtainContextForClient}.
  
  DELETE OBJECT phRowObjUpd NO-ERROR.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-remoteSendRows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE remoteSendRows Procedure 
PROCEDURE remoteSendRows :
/*------------------------------------------------------------------------------
  Purpose:     Stateless version of sendRows. 
               It does no processing but simply runs sendRows passing all 
               parameters, except the context to it and returning the RowObject 
               table as an output parameter back to the caller which now has the 
               new batch of records created in sendRows.   
  Parameters:  
  
   INPUT-OUTPUT pcContext - in current Context - out new context 
                            in and out (may) have completely different properties                           
                            CHR(3) delimitted list of "propCHR(4)value" pairs.           
                            See synchronizeProperties and genContext for details. 
    INPUT  piStartRow     - The RowNum value of the record to start the batch
                            to return.  Typically piStartRow is ? as a flag to 
                            use pcRowIdent instead of piStartRow.
    INPUT  pcRowIdent     - The RowIdent of the first record of the batch 
                            to return.  Can also be "FIRST" or "LAST" to force
                            the retrieval of the first (or last) batch of 
                            RowObject records.
    INPUT  plNext         - True if serverSendRows is to start on the "next"
                            record from what is indicated by piStartRow or
                            piRowIdent.
    INPUT  piRowsToReturn - The number of rows in a batch.
    OUTPUT piRowsReturned - The actual number of rows returned. This number
                            will either be the same as piRowsToReturn or
                            less when there are not enough records to fill
                            up the batch.
    
    OUTPUT pcMessages       - errors 
                             (just to have a consistent stateless API
                              not in use)   
   
  Notes:       If piStartRow is not 0 or ? then pcRowIdent is ignored.
               plNext is ignored if pcRowIdent is "FIRST" or "LAST".
               The most common use of piRowsReturned is to indicate that the
               entire result list has been returned when it is less than 
               piRowToReturn.
            -  The object should ONLY be started persistently before this is 
               called and NOT initialized as initializeObject is run AFTER the 
               context has been set.
            -  The caller is also responsible for destroying the object 
------------------------------------------------------------------------------*/ 
 DEFINE INPUT-OUTPUT PARAMETER piocContext  AS CHARACTER  NO-UNDO.
 
 DEFINE INPUT  PARAMETER piStartRow     AS INTEGER   NO-UNDO.
 DEFINE INPUT  PARAMETER pcRowIdent     AS CHARACTER NO-UNDO.
 DEFINE INPUT  PARAMETER plNext         AS LOGICAL   NO-UNDO.
 DEFINE INPUT  PARAMETER piRowsToReturn AS INTEGER   NO-UNDO.
 DEFINE OUTPUT PARAMETER pioRowsReturned AS INTEGER   NO-UNDO.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE   phRowObject.
 
 DEFINE OUTPUT PARAMETER pocMessages AS CHARACTER  NO-UNDO.
 
 RUN setContextAndInitialize IN TARGET-PROCEDURE (piocContext). 

 RUN sendRows IN TARGET-PROCEDURE (piStartRow, 
                                   pcRowIdent, 
                                   plNext,
                                   piRowsToReturn, 
                                   OUTPUT pioRowsReturned).
 
 {get RowObjectTable phRowObject}.

 piocContext = {fn obtainContextForClient}.
  
 IF {fn anyMessage} THEN
   pocMessages = {fn fetchMessages}.

 RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeFromCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeFromCache Procedure 
PROCEDURE removeFromCache :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cLogicalName AS CHARACTER  NO-UNDO.

    {get LogicalObjectName cLogicalName}.

    /* get off the cache */
    UNSUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "searchCache":U + cLogicalName.
    UNSUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "destroyCache":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-reopenToRowid) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reopenToRowid Procedure 
PROCEDURE reopenToRowid :
/*------------------------------------------------------------------------------
  Purpose   : reopen the SDO's DataQuery to a specific rowid     
  Parameters: <none>
  Notes     : Used after a new record has been added or the Dataquery is 
              resorted.                    
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER prRowObject AS ROWID NO-UNDO.
  
  DEFINE VARIABLE hDataQuery      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowNum         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iLastRow        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iFirstRow       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hRowObject      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cQuery          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cQueryPosition  AS CHARACTER  NO-UNDO.

    &SCOPED-DEFINE xp-assign
    {get RowObject hRowObject}
    {get DataHandle hDataQuery}
    {get FirstRowNum iFirstRow}
    {get LastRowNum iLastRow}
    {get QueryPosition cQueryPosition}
    .
    &UNDEFINE xp-assign
    
    IF prRowObject = ? THEN
       prRowObject = hRowObject:ROWID.

    {fnarg openDataQuery '':U}.
    
    /* if we have the first record of the batch reset first 
      (or if the Queryposition indicates that it was empty )  */
    IF iFirstRow <> ? OR cQueryPosition BEGINS 'NoRecord':U THEN
    DO:
      hRowNum = hRowObject:BUFFER-FIELD('RowNum':U).
      hDataQuery:GET-FIRST().
      {set FirstRowNum hRowNum:BUFFER-VALUE}.
    END.

    /* if we have the last record of the batch reset last 
      (or if the Queryposition indicates that it was empty )  */
    IF iLastRow <> ? OR cQueryPosition BEGINS 'NoRecord':U THEN 
    DO:
      IF NOT VALID-HANDLE(hRowNum) THEN
        hRowNum = hRowObject:BUFFER-FIELD('RowNum':U).
      hDataQuery:GET-LAST().
      {set LastRowNum hRowNum:BUFFER-VALUE}.
    END. 

    IF prRowObject <> ? THEN
    DO:
      hDataQuery:REPOSITION-TO-ROWID(prRowObject) NO-ERROR.
      /* Make this RowObject available if reposition didn't (not browsed) */
      IF NOT hRowObject:AVAILABLE AND ERROR-STATUS:GET-MESSAGE(1) = '':U THEN
        hDataQuery:GET-NEXT().
    END.

    /* Tell everybody about a potential change of QueryPosition. */
    RUN updateQueryPosition IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-restartServerObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE restartServerObject Procedure 
PROCEDURE restartServerObject :
/*------------------------------------------------------------------------------
  Purpose:    When a SmartDataObject is split and running Statelessly on an
              AppServer, it is shutdown after each use and then restarted for
              the next.  restartServerObject is run on the client to restart
              the SmartDataObject on the server.
 
  Parameters:  <none>
  Notes:      This override is for error handling to show error message and
              return 'adm-error'. 
------------------------------------------------------------------------------*/   
  DEFINE VARIABLE cMsg AS CHARACTER  NO-UNDO.
  
  RUN SUPER NO-ERROR.
  
  /* Handles only one message, which is sufficent with the current appserver 
    class */
  IF {fn anyMessage} THEN
  DO:
    cMsg = ENTRY(1,{fn fetchMessages},CHR(4)).
    /*{fnarg showMessage cMsg}.*/
    RUN showMessageProcedure IN TARGET-PROCEDURE(cMsg,OUTPUT glShowMessageAnswer). 

    RETURN ERROR 'ADM-ERROR':U.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-retrieveFilter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retrieveFilter Procedure 
PROCEDURE retrieveFilter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE hContainerSource                AS HANDLE       NO-UNDO.
DEFINE VARIABLE cContainerName                  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cSdoName                        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cSdoSignature                   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE rRowid                          AS ROWID        NO-UNDO.
DEFINE VARIABLE cFilterSettings                 AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cRunAttribute                   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cFieldNames                     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cFieldValues                    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cFieldOperators                 AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lSuccess                        AS LOGICAL      NO-UNDO.
DEFINE VARIABLE cManualAddQueryWhere            AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iLoop                           AS INTEGER      NO-UNDO.
DEFINE VARIABLE cEntry                          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cBuffer                         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cSDOSettings                    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iRowsToBatch                    AS INTEGER      NO-UNDO.
DEFINE VARIABLE lRebuildOnRepos                 AS LOGICAL      NO-UNDO.
DEFINE VARIABLE cDataContainerName              AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lQueryObject                    AS LOGICAL      NO-UNDO.
DEFINE VARIABLE hSboContainer                   AS HANDLE       NO-UNDO.
DEFINE VARIABLE iCnt                            AS INTEGER      NO-UNDO.
DEFINE VARIABLE cField                          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cColumnSelection                AS CHARACTER  NO-UNDO.

/* RETRIEVAL OF FILTER IS DEPENDANT UPON LINKS WHICH ONLY EXIST CLIENT-SIDE */
    IF (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN RETURN.
    IF VALID-HANDLE(gshProfileManager) THEN
    DO: 
      {get ContainerSource hContainerSource}.
      IF VALID-HANDLE(hContainerSource) THEN
      DO:
              {get LogicalObjectName cSdoName}.
        IF cSdoName EQ "":U OR cSdoName EQ ? THEN 
          ASSIGN cSdoName = TARGET-PROCEDURE:FILE-NAME. 

                {get LogicalObjectName cContainerName hContainerSource}.
        IF cContainerName EQ "":U OR cContainerName EQ ? THEN
            ASSIGN cContainerName = hContainerSource:FILE-NAME.

        /* Determine whether this SDO is contained in an SBO. */
        {get QueryObject lQueryObject hContainerSource}.
        IF lQueryObject THEN
        DO:
            ASSIGN cDataContainerName = cContainerName.
            {get ContainerSource hSboContainer hContainerSource}.

            IF VALID-HANDLE(hSboContainer) THEN
            DO:
                {get LogicalObjectName cContainerName hSboContainer}.
                IF cContainerName EQ "":U OR cContainerName EQ ? THEN
                    ASSIGN cContainerName = hSboContainer:FILE-NAME.
            END.    /* valid SBO container */
        END.    /* SBO */
        ELSE
            ASSIGN cDataContainerName = "":U.

        ASSIGN 
          cSdoSignature = cSdoName + ",":U + cDataContainerName + ",":U + cContainerName + ",":U + cRunAttribute
          rRowid        = ?.
        RUN getProfileData IN gshProfileManager (
            INPUT "BrwFilters":U,
            INPUT "FilterSet":U,
            INPUT cSdoSignature,
            INPUT NO,
            INPUT-OUTPUT rRowid,
            OUTPUT cFilterSettings).
        
        /* re-apply any manual mods to queryWhere */
        {get ManualAddQueryWhere cManualAddQueryWhere}.
        
        IF cFilterSettings <> "" AND NUM-ENTRIES(cFilterSettings,CHR(3)) = 3 THEN
        DO:
            ASSIGN
              cFieldNames     = ENTRY(1,cFilterSettings,CHR(3))
              cFieldValues    = ENTRY(2,cFilterSettings,CHR(3))
              cFieldOperators = ENTRY(3,cFilterSettings,CHR(3))
              .
            /* if assignQuerySelection already is set with this field 
               then ignore the profile setting 
               (The fact that the field is in the profile will make the 
                field available in the filter even if it also is assigned
                from elsewhere ) */
            DO iCnt = 1 TO NUM-ENTRIES(cFieldNames):
              ASSIGN 
                cField           = ENTRY(iCnt, cFieldNames).
                cColumnSelection = DYNAMIC-FUNCTION("ColumnQuerySelection":U IN TARGET-PROCEDURE,
                                                    cField).

              IF cColumnSelection > '' THEN
              DO:
                ASSIGN 
                  cFieldNames  = DYNAMIC-FUNCTION("deleteEntry":U IN TARGET-PROCEDURE,
                                                 iCnt,cFieldNames,",":U)
                  cFieldValues = DYNAMIC-FUNCTION("deleteEntry":U IN TARGET-PROCEDURE,
                                                  iCnt,cFieldValues,CHR(1))
                  cFieldOperators = DYNAMIC-FUNCTION("deleteEntry":U IN TARGET-PROCEDURE,
                                                      iCnt,cFieldOperators,",":U)
                  .
              END.
            END.
            
            loop-1:
            DO iLoop = 1 TO NUM-ENTRIES(cManualAddQueryWhere, CHR(4)):
              cEntry = ENTRY(iLoop, cManualAddQueryWhere, CHR(4)).      
              
              IF NUM-ENTRIES(cEntry, CHR(3)) <> 3 THEN 
                NEXT loop-1.
              
              cBuffer = ENTRY(2,cEntry,CHR(3)).
              
              IF cBuffer = "?":U THEN 
                cBuffer = "":U.

              DYNAMIC-FUNCTION("addQueryWhere":U IN TARGET-PROCEDURE, ENTRY(1,cEntry,CHR(3)),
                                                                      cBuffer,
                                                                      ENTRY(3,cEntry,CHR(3))). 
            END.
            
            /* Set FilterActive property true if filter was applied */
            IF cFieldNames <> "":U THEN 
            DO:
              {set FilterActive TRUE}.
           
              /* assign the retrieved criteria */                                              
    
              lSuccess = DYNAMIC-FUNC("assignQuerySelection":U IN TARGET-PROCEDURE,
                                       cFieldNames,
                                       cFieldValues,
                                       cFieldOperators).
            END. 
        END.
        ELSE IF cManualAddQueryWhere > '':U THEN
        DO:
          /* Ensure any manualaddquerywhere statements are actioned set-up in 
             initializeobject of an sdo clear the existing selection */

          loop-2:
          DO iLoop = 1 TO NUM-ENTRIES(cManualAddQueryWhere, CHR(4)):
            cEntry = ENTRY(iLoop, cManualAddQueryWhere, CHR(4)).      
            IF NUM-ENTRIES(cEntry, CHR(3)) <> 3 THEN 
              NEXT loop-2.
            cBuffer = ENTRY(2,cEntry,CHR(3)).
            IF cBuffer = "?":U THEN 
              cBuffer = "":U.
            DYNAMIC-FUNCTION("addQueryWhere":U IN TARGET-PROCEDURE, ENTRY(1,cEntry,CHR(3)),
                                                                    cBuffer,
                                                                    ENTRY(3,cEntry,CHR(3))). 
          END.
        END.

        /* Store the current (default) rowsToBatch and rebuildOnRepos settings in case *
         * we need them later, for instance when resetting default SDO values.         */
        &SCOPED-DEFINE xp-assign
        {get rowsToBatch iRowsToBatch}
        {get rebuildOnRepos lRebuildOnRepos}
        .
        &UNDEFINE xp-assign
        
        RUN setProfileData IN gshProfileManager (
            INPUT "SDO":U,
            INPUT "Attributes":U,
            INPUT cSDOSignature + ",defAttrs":U,
            INPUT ?,
            INPUT STRING(iRowsToBatch) + CHR(3) + STRING(lRebuildOnRepos),
            INPUT NO,
            INPUT "SES":U). /* We NEVER want to save this profile permanently, always session only */

        /* See if any SDO attributes set */
        ASSIGN rRowid = ?.
        RUN getProfileData IN gshProfileManager (
            INPUT "SDO":U,
            INPUT "Attributes":U,
            INPUT cSdoSignature,
            INPUT NO,
            INPUT-OUTPUT rRowid,
            OUTPUT cSDOSettings).

        IF NUM-ENTRIES(cSDOSettings, CHR(3)) = 2 THEN
        DO:
          /* Now we can set the attributes to the values the user wants */
          ASSIGN
            iRowsToBatch = INTEGER(ENTRY(1,cSDOSettings, CHR(3)))
            lRebuildOnRepos = ENTRY(2,cSDOSettings, CHR(3)) = "YES":U
            NO-ERROR.

          IF iRowsToBatch > 0 THEN
          DO:
            &SCOPED-DEFINE xp-assign
            {set rowstobatch iRowsToBatch}
            {set rebuildonrepos lRebuildOnRepos}
            .
            &UNDEFINE xp-assign
          END.
        END.
      END. /* Valid container */
    END.  /* valid profile manager */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-returnObjectHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnObjectHandle Procedure 
PROCEDURE returnObjectHandle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER phObject AS HANDLE NO-UNDO.

  phObject = TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rowObjectState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowObjectState Procedure 
PROCEDURE rowObjectState :
/*------------------------------------------------------------------------------
  Purpose:     To pass on the flag which indicates when a SmartDataObject row 
               has been changed locally but not committed. This gets passed on 
               until it reaches the Commit Panel or other first Commit-Source.
 
  Parameters:
    INPUT pcState - the new state
  
  Notes:       This SmartDataObject version doesn't do anything itself with 
               the state setting, but simply passes it on up the chain 
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcState AS CHARACTER NO-UNDO.
   
  PUBLISH 'rowObjectState':U FROM TARGET-PROCEDURE (pcState).
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-saveContextAndDestroy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveContextAndDestroy Procedure 
PROCEDURE saveContextAndDestroy :
/*------------------------------------------------------------------------------
  Purpose:  See and use getContextAndDestroy.   
    Notes:  kept for backwards compatibility.
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER pcContext AS CHARACTER     NO-UNDO.
  RUN getContextAndDestroy IN TARGET-PROCEDURE ( OUTPUT pcContext).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sendRows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sendRows Procedure 
PROCEDURE sendRows :
/*-----------------------------------------------------------------------------
Purpose:     To fetch the requested number of rows (views) from the DB Query
             and to create corresponding records in the Row Object Temp-Table.
             The batch will typically start at row indicated by the pcRowIdent
             parameter, but may start on the row indicated by the piStartRow
             parameter.
Parameters:
   INPUT piStartRow      - RowNum to start on. (? indicates that pcRowIdent
                          will determine the start of the batcvh to be 
                           returned.) 
   INPUT pcRowIdent      - An alternative to StartRow. pcRowIdent is either
                           "FIRST", "LAST" or a comma delimited list of DB
                           ROWIDs.  If it is "FIRST" (or "LAST") then the 
                           first (or last) batch of records in the data set
                           are retrieved and piStartRow is forced to ?. If
                           pcRowIdent is a comma delimited list of DB ROWIDs
                           then the batch will start with a RowObject
                           comprised of those records.
                        - Can also contain a query expression for reposition. 
                          The expression must have at least one space. 
                        - Special signals 
                          Appended with +   
                                                                            
   INPUT plNext          - TRUE if query should perform NEXT/PREV (depending
                           on the direction of navigation) before starting
                           to return more rows.  In otherwords, "SKIP" to 
                           the next record at the start of the batch. 
   INPUT piRowsToReturn  - Maximum number of rows to be returned (negative
                           to move backwards in the result set)
                           0 to retrieve ALL rows in the dataset (forward) .
   OUTPUT piRowsReturned - Actual number of rows returned.
    
  Notes:       Before returning, sendRows repositions the RowObject query to
               what was the current row when it started. The pcRowIdent
               argument is used by fetchRowIdent to allow query repositioning
               to a specific db query row.
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER piStartRow     AS INTEGER   NO-UNDO.
 DEFINE INPUT  PARAMETER pcRowIdent     AS CHARACTER NO-UNDO.
 DEFINE INPUT  PARAMETER plNext         AS LOGICAL   NO-UNDO.
 DEFINE INPUT  PARAMETER piRowsToReturn AS INTEGER   NO-UNDO.
 DEFINE OUTPUT PARAMETER piRowsReturned AS INTEGER   NO-UNDO INIT 0.
 
 DEFINE VARIABLE hQuery         AS HANDLE      NO-UNDO.
 DEFINE VARIABLE hRowObject     AS HANDLE      NO-UNDO.
 DEFINE VARIABLE hDataQuery     AS HANDLE      NO-UNDO.
 DEFINE VARIABLE cASDivision    AS CHARACTER   NO-UNDO.
 DEFINE VARIABLE lOK            AS LOGICAL     NO-UNDO.
 DEFINE VARIABLE cRowObjectstate AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lNexting       AS LOGICAL     NO-UNDO.
 DEFINE VARIABLE cFetchOnOpen    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lOpened         AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE lAppend         AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE lFill           AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE iLength         AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cMode           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cLastResultRow  AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cFirstResultRow AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hDataSource     AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cQueryString    AS CHARACTER  NO-UNDO.
  /* The RowObjectState property signals whether there are uncommitted
     changes. If so, we cannot get more rows from the database until
     changes are committed. */
  {get RowObjectState cRowObjectState}.  
  IF cRowObjectState = 'RowUpdated':U THEN
    RETURN.

  /* Filter out invalid input parameters */
  IF piStartRow = 0 THEN
    piStartRow = ?.

  IF LOOKUP(pcRowIdent,"FIRST,LAST":U) > 0 THEN
    ASSIGN piStartRow = ?
           plNext     = NO.

  {get ASDivision cASDivision}.
  {get RowObject hRowObject}.

  /* Remove client sort (can only be applied if isDataQueryComplete */
  IF cASDivision <> 'Server':U AND {fn isDataQueryComplete} THEN
  DO:
    {get DataQueryString cQueryString}. 
    cQueryString = DYNAMIC-FUNCTION('newQuerySort':U IN TARGET-PROCEDURE,
                                     cQueryString,
                                     '':U, 
                                     NO).
    {set DataQueryString cQueryString}. 
  END.

  /* Find out whether we're running with a query on an AppServer.
     If so then run a special client-to-server version of sendRows.*/
  IF cASDivision = 'Client':U THEN
  DO:
    RUN changeCursor IN TARGET-PROCEDURE('WAIT':U).
     /* piRowsToReturn = 0 tells that this is an append (RebuildOnRepos=false) */   
    IF pcRowIdent = "FIRST":U OR (pcRowident = "LAST":U AND piRowsTOReturn <> 0)  THEN 
      {fnarg emptyRowObject 'reset':U}.
    RUN clientSendRows IN TARGET-PROCEDURE
      (piStartRow, pcRowIdent, plNext, piRowsToReturn, OUTPUT piRowsReturned). 
    RUN changeCursor IN TARGET-PROCEDURE('':U).
    RETURN.
  END.
  ELSE IF cASDivision = 'Server':U THEN  /* Always empty RowObject on Server */
    {fnarg emptyRowObject '':U}.

  /* Unknown or 0 means get all, the code below checks for the 0. 
     We do not change this on the client as it used to indicate LAST */
  IF piRowsToReturn = ? THEN piRowsToReturn = 0. 

  &SCOPED-DEFINE xp-assign
  {get LastResultRow cLastResultRow}
  {get FirstResultRow cFirstResultRow}
  .
  &UNDEFINE xp-assign
 
  /* If we're running locally or on a server, continue on... */
  {get QueryHandle hQuery}.
  {get DataHandle hDataQuery}.  
  IF NOT hQuery:IS-OPEN THEN
  DO:
    &SCOPED-DEFINE xp-assign
    {get FetchOnOpen cFetchOnOpen}
    {set FetchOnOpen '':U}
    .
    &UNDEFINE xp-assign
 
    hDataQuery:QUERY-CLOSE. /* just avoid closeQuery */
    {fn openQuery}.
    {set FetchOnOpen cFetchOnOpen}.
    lOpened = TRUE. /* if Refresh we always reopen so set this flag (see below)*/
  END.
 
  IF hQuery:IS-OPEN THEN 
  DO:
    RUN changeCursor IN TARGET-PROCEDURE('WAIT':U).
    ASSIGN 
      lNexting       = (piRowsToReturn >= 0). 

    IF pcRowident = "LAST":U AND piRowsToReturn = 0 THEN
      ASSIGN 
        cMode   = 'LAST':U
        lAppend = YES.

    ELSE IF pcRowIdent > "":U THEN
    DO:
      /* First close the RowObject query and empty the current temp-table. 
         Reset all the associated properties and variables.
         Special case: If RowNum is also specified, then
         the caller wants to *refresh* one or more rows starting with
         pcRowIdent, and to give them numbers starting with
         piStartRow, so in that case, don't empty the current temp-table. */
      IF piStartRow EQ ? THEN
      DO:
        /* IF Local (NOT Server and we don't get here if Client) */
 
        IF cASDivision NE "Server":U THEN 
          hDataQuery:QUERY-CLOSE() no-error. /* shut up if size error in browse*/
 
        IF CAN-DO("LAST,FIRST":U,pcRowIdent) THEN
          ASSIGN 
            lAppend = FALSE
            cMode   = pcRowident.  

        ELSE DO: /* Reposition to a specific RowIdent */
          ASSIGN
            lAppend = piRowsToReturn = 0 /* 0 indicates appending search */  
            iLength = LENGTH(pcRowident).
          /* Special trick-1 appended '+' means start from as rebuild is false */
          IF SUBSTR(pcRowident,iLength,1) = "+":U THEN
            lAppend = TRUE.
          /* Special trick-2 appended '-' means fill batch (- is backwards, ok)*/
          ELSE IF SUBSTR(pcRowident,iLength,1) = "-":U THEN
            lFill = TRUE.
        
          IF lFill OR lAppend THEN
            pcRowident = SUBSTR(pcRowident,1,iLength - 1).
        
          IF lNexting THEN
          DO:
            cMode = "REPOSITION":U.
            IF plNext = TRUE THEN
              cMode = "REPOSITION-AFTER":U.
          END.
          ELSE DO:
            cMode = "REPOSITION-TO":U.
            IF plNext = TRUE THEN
              cMode = "REPOSITION-BEFORE":U.
          END.
        END.
 
        IF NOT lAppend THEN
          {fnarg emptyRowObject 'reset':U}.     
 
      END.  /* END plNext or Return > 1 */
      ELSE DO:
        ASSIGN
          cMode      = "REFRESH":U
          pcRowident = STRING(piStartRow) + ";":U + pcRowIdent.   
        IF NOT lOpened THEN hQuery:QUERY-OPEN. /* include new records */
      END.
    END.    /* END DO pcRowIdent */
    ELSE 
      /* If no rowident is passed then we are batching (or reading the first 
         batch), so set append flag to pass to transferRows. */ 
      ASSIGN
        cMode   = IF piRowsToReturn >= 0 THEN "NEXT":U
                  ELSE "PREV":U 
        lAppend = YES.
 
    RUN transferRows IN TARGET-PROCEDURE (lAppend,
                                          cMode,
                                          IF cMode BEGINS "REPOSITION":U 
                                          OR cMode = "REFRESH":U
                                          THEN pcRowIdent
                                          ELSE "":U,
                                          lFill,
                                          ABS(piRowsToReturn),
                                          OUTPUT piRowsReturned).

    /* if failure return current batch */
    IF NOT lAppend AND piRowsReturned = 0 AND cMode = "REPOSITION":U THEN
    DO:
      /* Avoid this if we do not have info about what was current */
      IF cFirstResultrow <> ? AND cLastResultrow <> ? THEN
      DO:
        
        &SCOPED-DEFINE xp-assign
        {set LastResultRow cLastResultRow}
        {set FirstResultRow cFirstResultRow}
        .
        &UNDEFINE xp-assign
        
        RUN transferRows IN TARGET-PROCEDURE 
                 (lAppend,
                  "CURRENT":U,  
                  "":U,
                  NO,
                  0, /* we may have more than one batch */ 
                  OUTPUT piRowsReturned).
        /* Tell clientSendRows to not position */ 
        {set PositionForClient ?}. 
        /* Tell locally that we have no position */
        hRowObject:BUFFER-RELEASE.
      END.
    END.
    RUN changeCursor IN TARGET-PROCEDURE('':U).
  END.    /* END IF query IS-OPEN */
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-serverCommit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE serverCommit Procedure 
PROCEDURE serverCommit :
/*------------------------------------------------------------------------------
  Purpose:     Update procedure executed on the server side of a split 
               SmartDataObject, called from the client Commit function.
               Commit passes a set of RowObjUpdate records both have changes to
               be committed and their pre-change copies (before-images).  
               commitRows verifies that the records have not been changed 
               since they were read, and then commits the changes to the 
               database.
  Parameters:
   INPUT-OUTPUT TABLE RowObjUpd - The Update version of the RowObject 
                                  Temp-Table
 
   OUTPUT cMessages - a CHR(3) delimited string of accumulated messages from
                       server.
    OUTPUT cUndoIds  - list of any RowObject ROWIDs whose changes need to be 
                       undone as the result of errors in the form of:
               "RowNumCHR(3)ADM-ERROR-STRING,RowNumCHR(3)ADM-ERROR-STRING,..."

 Notes:        If another user has modified the database records since the 
               original was read, the new database values are copied into the 
               RowObjUpd record and returned to Commit so the UI object can 
               display them.
------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT  PARAMETER TABLE-HANDLE phRowObjUpd.
  DEFINE OUTPUT PARAMETER pcMessages AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcUndoIds  AS CHARACTER  NO-UNDO.
  
  {set RowObjUpdTable phRowObjUpd}.
  
  RUN bufferCommit IN TARGET-PROCEDURE (OUTPUT pcMessages,
                                        OUTPUT pcUndoIds).
  
  DELETE OBJECT phRowObjUpd NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-serverFetchRowObjUpdTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE serverFetchRowObjUpdTable Procedure 
PROCEDURE serverFetchRowObjUpdTable :
/*------------------------------------------------------------------------------
  Purpose:     Returns the table-handle of the  Update table
               from the server to a dynamic client Data Object.
  Parameters:  OUTPUT TABLE-HANDLE phRowObjUpd.
  Notes:       We can't use the getRowObjUpdTable function 
               because that only returns the HANDLE, to be used by an object 
               on the same side of the AppServer connection. 
               This procedure returns the TABLE-HANDLE,
               so the entire table definition comes along with it.
------------------------------------------------------------------------------*/
 DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd.

  {get RowObjUpdTable phRowObjUpd}.
 
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-serverSendRows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE serverSendRows Procedure 
PROCEDURE serverSendRows :
/*------------------------------------------------------------------------------
  Purpose:     server-side intermediary for sendRows. serverSendRows is only
               called by clientSendRows and only if the SmartDataObject is 
               split across an AppServer boundary.  It does no processing
               but simply runs sendRows passing all parameters on to it and
               returning the RowObject table as an output parameter back to
               the client which now has the new batch of records created in
               sendRows.
 
  Parameters:  
    INPUT  piStartRow     - The RowNum value of the record to start the batch
                            to return.  Typically piStartRow is ? as a flag to 
                            use pcRowIdent instead of piStartRow.
    INPUT  pcRowIdent     - The RowIdent of the first record of the batch to
                            to return.  Can also be "FIRST" or "LAST" to force
                            the retrieval of the first (or last) batch of 
                            RowObject records.
    INPUT  plNext         - True if serverSendRows is to start on the "next"
                            record from what is indicated by piStartRow or
                            piRowIdent.
    INPUT  piRowsToReturn - The number of rows in a batch.
    OUTPUT piRowsReturned - The actual number of rows returned. This number
                            will either be the same as piRowsToReturn or
                            less when there are not enough records to fill
                            up the batch.
  
  Notes:       If piStartRow is not 0 or ? then pcRowIdent is ignored.
               plNext is ignored if pcRowIdent is "FIRST" or "LAST".
               The most common use of piRowsReturned is to indicate that the
               entire result list has been returned when it is less than 
               piRowToReturn.
------------------------------------------------------------------------------*/ 
 DEFINE INPUT  PARAMETER piStartRow     AS INTEGER NO-UNDO.
 DEFINE INPUT  PARAMETER pcRowIdent     AS CHARACTER NO-UNDO.
 DEFINE INPUT  PARAMETER plNext         AS LOGICAL NO-UNDO.
 DEFINE INPUT  PARAMETER piRowsToReturn AS INTEGER NO-UNDO.
 DEFINE OUTPUT PARAMETER piRowsReturned AS INTEGER NO-UNDO.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE   phRowObject.

 RUN sendRows IN TARGET-PROCEDURE (piStartRow, 
                                   pcRowIdent, 
                                   plNext,
                                   piRowsToReturn, 
                                   OUTPUT piRowsReturned).
 {get RowObjectTable phRowObject}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContextAndInitialize) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setContextAndInitialize Procedure 
PROCEDURE setContextAndInitialize :
/*------------------------------------------------------------------------------
  Purpose:  (Re)set context and initialize this server side object   
  Parameters: pcContainedProps
    Notes: The client now passes serverFirstCall yes to indicate if this 
           is the first call, but we still support the old trick of passing
           ObjectInitialized no as the first entry.           
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcContext    AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE lInitFlag            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lInitialized         AS LOGICAL    NO-UNDO.

  /* Backwards support to identify the first call relying on the 
     client passing ObjectInitialized AS THE FIRST ENTRY.  */
  lInitFlag = pcContext BEGINS "ObjectInitialized":U + CHR(4).
  /* There is no set function and although it's a correct value let's just 
     remove it..  */
  IF lInitFlag THEN
  DO:
    ASSIGN
      lInitFlag = /* Let's pay respect the value of Objectinitialized */    
       CAN-DO('false,no':U,ENTRY(2,ENTRY(1,pcContext,CHR(3)),CHR(4)))
      ENTRY(1,pcContext,CHR(3)) = '':U
      pcContext = TRIM(pcContext,CHR(3)). 

    {set ServerFirstCall TRUE}.

  END.
   
  {fnarg applyContextFromClient pcContext}.
    
  /* Neither initializeObject or restartServerObject on the client does
     a separate initializeObject call, so we do it on the server, unless 
     for some reason it was already initialized. There's however no need 
     to open the query, so set openOnInit to false. The query will be opened 
     later if needed */
  {get ObjectInitialized lInitialized}.
  
  IF NOT lInitialized THEN
  DO:
    {set OpenOninit FALSE}.
    RUN initializeObject IN TARGET-PROCEDURE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPropertyList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setPropertyList Procedure 
PROCEDURE setPropertyList :
/*------------------------------------------------------------------------------
  Purpose:     To set a list of properties taken from a CHR(3) delimitted list
               of "propCHR(4)value" pairs.
  
  Parameters:  
    INPUT pcProperties - the CHR(3) delimitted list of "propCHR(4)value" pairs
                         to be set.
  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcProperties AS CHARACTER                    NO-UNDO.
  
  DEFINE VARIABLE iProp        AS INTEGER                             NO-UNDO.
  DEFINE VARIABLE cProp        AS CHARACTER                           NO-UNDO.
  DEFINE VARIABLE cValue       AS CHARACTER                           NO-UNDO.
  DEFINE VARIABLE iCnt         AS INTEGER                             NO-UNDO.

  iCnt = NUM-ENTRIES(pcProperties,CHR(3)).
  DO iProp = 1 TO iCnt:
    /* Process Prop<->Value pairs */
    ASSIGN cProp  = ENTRY(iProp,pcProperties,CHR(3))
           cValue = ENTRY(2,cProp,CHR(4))
           cValue = IF cValue = "?" THEN ? ELSE cValue
           cProp  = ENTRY(1,cProp,CHR(4)).

  /** The call to the signature function has been removed to improve performance
      and because it was unnecessary as character values will be converted to the 
      correct data-type implicitly. (Issuezilla #11489)
    
      Message code removed to avoid issues with attributes being set which are not 
      available as properties in the object. Objects may conditionally 
      inherit from classes (Issuezilla # 11481) 
  **/ 
    DYNAMIC-FUNCTION("set":U + cProp IN TARGET-PROCEDURE, cValue) NO-ERROR.    
      
  END.  /* DO iProp = 1 TO NUM-ENTRIES */
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-startServerObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startServerObject Procedure 
PROCEDURE startServerObject :
/*------------------------------------------------------------------------------
  Purpose:    When a SmartDataObject is split and running Statelessly on an
              AppServer, startServerObject is run on the client to start
              the SmartDataObject on the server.
  Parameters:  <none>
  Notes:      This override is for error handling to show error message and
              return 'adm-error'. 
------------------------------------------------------------------------------*/ 
  DEFINE VARIABLE cMsg AS CHARACTER  NO-UNDO.
  
  RUN SUPER NO-ERROR.
  /* Handles only one message, which is sufficent with the current appserver 
     class */
  IF {fn anyMessage} THEN
  DO:
    cMsg = ENTRY(1,{fn fetchMessages},CHR(4)).
    /*{fnarg showMessage cMsg}. */
    RUN showMessageProcedure IN TARGET-PROCEDURE(cMsg,OUTPUT glShowMessageAnswer). 
    RETURN ERROR 'ADM-ERROR':U.
  END.
  ELSE IF ERROR-STATUS:ERROR THEN
    RETURN ERROR RETURN-VALUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-submitCommit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE submitCommit Procedure 
PROCEDURE submitCommit :
/*------------------------------------------------------------------------------
  Purpose:     Called by submitRow to commit changes to the database.
  
  Parameters:  
    INPUT pcRowIdent - Identifier of the row to commit.  It is a comma delimited
                       list of ROWIDS.  The first entry is the ROWID of the 
                       RowObject Temp-Table containing the record to commit.
                       Subsequent entries (of the comma delimited list) are the
                       DB ROWIDs of the records to be modified.
    INPUT plReopen   - TRUE if the RowObject query is to be reopened and
                       repositioned to the RowObject record identified by 
                       pcRowIdent.
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcRowIdent AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER plReopen   AS LOGICAL   NO-UNDO.
  
  DEFINE VARIABLE lAutoCommit     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cReturn         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE rRowObject      AS ROWID     NO-UNDO.
  DEFINE VARIABLE hRowObject      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cState          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lQueryContainer AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hSBO            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lAutoCommitSBO  AS LOGICAL    NO-UNDO.

  pcRowIdent = ENTRY(1,pcRowIdent).

  IF DYNAMIC-FUNCTION("anyMessage":U IN TARGET-PROCEDURE) THEN
  DO:
    /* Add the update cancelled message */
    RUN addMessage IN TARGET-PROCEDURE({fnarg messageNumber 15},?,?).
    /* The returntoaddmode undoes the rowobjupd after an add while
       doundorow is for the normal case. we could/should call the applicable
       by a check with getnewmode, but this would require more testing 
       (commit mode and sbo both modes) since we're in the middle of stuff. 
       The end result is ensured with these calls and the state is based on 
       the underlying temp-tables anyways, so any check would really double 
       check the same conditions that the procedures handles. */ 
    RUN doReturnToAddMode IN TARGET-PROCEDURE.
    RUN doUndoRow IN TARGET-PROCEDURE.
    RETURN "ADM-ERROR":U.    /* If there were any Data messages */
  END.
  ELSE DO:
    rRowObject = TO-ROWID(pcRowIdent).   
    {get RowObject hRowObject}.

    /* RowObjectValidate might have lost current position*/
    IF NOT hRowObject:AVAILABLE OR rRowObject <> hRowObject:ROWID THEN
      hRowObject:FIND-BY-ROWID(rRowObject).
      
    /* Tell others the update is done and to redisplay the rec if appropriate */
    RUN dataAvailable IN TARGET-PROCEDURE ("SAME":U).  /* not a different row. */    
    
    {get AutoCommit lAutoCommit}.
    IF lAutoCommit THEN 
    DO:
      /* Go ahead with the DB transaction now. */
      RUN commitTransaction IN TARGET-PROCEDURE.
      cReturn = RETURN-VALUE.
    END.   /* END DO IF lAutoCommit */
    ELSE DO:
      cReturn = "":U.              /* success pending final Commit */
      {set RowObjectState 'RowUpdated':U}.
    END.  /* END ELSE DO IF Not AutoCommit */
    
    IF cReturn = '':U THEN
    DO: 
      {set DataModified FALSE}.

      /* Check if we are inside an SBO with AutoCommit as the SBO 
         handles most of the post commit logic in that case */
      IF NOT lAutoCommit THEN
      DO:
        {get QueryContainer lQueryContainer}.
        IF lQueryContainer THEN
        DO:
          {get ContainerSource hSBO}.
          {get AutoCommit lAutoCommitSBO hSBO}.
        END.      
      END.
                         
      /* Avoid calling reopenToRowid and publish dataAvailable if Autocommit SBO*/
      IF NOT lAutoCommitSBO THEN
      DO:        
        /* If doCreateUpdate told us to reopen (because a new record was added 
           to the RowObject table), re-open the RowObject Query and reposition 
           to the newly added row. */
        IF plReopen THEN
          RUN reopenToRowid IN TARGET-PROCEDURE (rRowObject).
       
        /* From 9.1B+ we also publish uncommitted changes. */  
        cState = (IF plReopen and lAutoCommit 
                  THEN 'DIFFERENT':U
                 /*  Reset ensures reopen if key has changed. 
                     we also use 'RESET' for uncommitted new records, as this 
                     will reset panels and only reopen if child has 
                     no changes */
                  ELSE 'RESET':U).  
        /* Note that submitForeignKey currently still is getting
           the ForeignFields from the parent instead of from the ForeignValues 
           if the source is NewRow and RowObjectState is 'RowUpdated'.
           This is probably not necessary now as 'reset' sets Foreignvalues.*/
        PUBLISH "dataAvailable":U FROM TARGET-PROCEDURE (cState).
        {set NewBatchInfo '':U}.
      END.
    END. /* Return = '' (Successful commit or not autocommit) */
    ELSE DO: 
      /* roll back changes (not create) */
      {fnarg undoRow pcRowident}.

      IF NOT hRowObject:AVAILABLE OR rRowObject <> hRowObject:ROWID THEN
        /* A failed record is not in the query so we cannot reposition */
        hRowObject:FIND-BY-ROWID(rRowObject).
    END.
  END.  /* END DO IF no validation errors */
  RETURN cReturn.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-submitForeignKey) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE submitForeignKey Procedure 
PROCEDURE submitForeignKey :
/*------------------------------------------------------------------------------
  Purpose:     Called from submitRow to define Foreign Key values for a new row.
  
  Parameters:
    INPUT pcRowIdent          - The RowIdent (a comma delimited list of ROWIDs
                                that uniquely identify the RowObject record) of
                                the new RowObject record to be stored in the
                                database.  Since this is a new record, only the
                                first ROWID (that of the RowObject itself) is
                                valid.  There are no DB ROWIDs because they
                                have not yet been created.                                
    INPUT-OUTPUT pcValueList  - A CHR(1) delimited list of ForeignField column
                                and value pairs to be set in the RowObject 
                                record identified by pcRowIdent.  On input it is
                                a list that has been set before submitForeignKey
                                was called.  On output it is the now current list
                                of foreign fields that have been set.
    INPUT-OUTPUT pcUpdColumns - A comma delimited list of column names that are
                                updatable in the SDO.
                                
    Notes:     The list of udpdatable fields (pcUpdColumns - derived from the
               UpdatableColumns property in submitRow) usually doesn't
               contain key fields. However, because submitForiegnKey is called
               when creating a new RowObject record, key fields need to be 
               populated so pcUpdColumns is expanded to allow for this.  
               However, only the variable pcUpdColumns is expanded, the 
               UpdatableColumns property remains unchanged.
               
------------------------------------------------------------------------------*/
  DEFINE INPUT        PARAMETER pcRowIdent   AS CHARACTER NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcValueList  AS CHARACTER NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcUpdColumns AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE cForFields      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cForValues      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDataColumns    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iCol            AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cField          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hField          AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cCurrField      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hSource         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cValue          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRowObjectState AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lNewSource      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lLookupParent   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lQueryContainer AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cObjectName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iPass           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lNew            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cForName        AS CHARACTER  NO-UNDO.

  /* If this is a newly Added row, and there are Foreign Fields, 
     assign those values to the RowObject columns. */
  {get NewRow lNew}.
  IF lNew THEN
  DO:
    /* Find out whether this SDO is inside an SBO */
    {get QueryContainer lQueryContainer}.
    
    /* On first pass, process foreign fields of SDO, on second pass,
       process foreign fields from SBO */
    DO iPass = 1 TO (IF lQueryContainer THEN 2 ELSE 1):
      CASE iPass:
        WHEN 1 THEN
          {get ForeignFields cForFields}.
        WHEN 2 THEN
          cForFields = {fn getForeignFieldsContainer}.
      END CASE.

      IF cForFields NE "":U THEN
      DO:
        IF iPass = 1 THEN
          {get DataSource hSource}.          /* get SDO's dataSource on pass 1 */
        ELSE DO:
          {get ContainerSource hSource}.
          {get DataSource hSource hSource}. /* get SBO's dataSource on pass 2 */     
        END.
        /* if child runs stand-alone foreign fields doesn't matter */
        IF VALID-HANDLE(hSource) THEN 
        DO:
          
          &SCOPED-DEFINE xp-assign
          {get RowObjectState cRowObjectState hSource}
          {get NewRow lNewSource hSource}
          .
          &UNDEFINE xp-assign
          
          /* if multiple add for one-to-one or otherwise uncommitted new parent
             get the foreignkey from the source, becasue submitcommit does not 
             publish DataAvailable under these circumstances (new/autocommit off) 
            NOTE: This is no longer true, but was changed too late to mess with it*/ 
          IF cRowObjectstate = 'RowUpdated' AND lNewSource  THEN
             lLookupParent = TRUE. 
          ELSE 
            {get ForeignValues cForValues}.
          
          {get DataColumns cDataColumns}.
          DO iCol = 1 TO NUM-ENTRIES(cForFields) BY 2:
                          /* Make sure this works with unqualified field */ 
            cCurrField = ENTRY(iCol, cForFields).
            cField = ENTRY(NUM-ENTRIES(cCurrField,".":U),cCurrField, ".":U).

            IF LOOKUP(cField, cDataColumns) NE 0 AND /* It's in the SDO, and */
               LOOKUP(cField, pcValueList, CHR(1)) = 0 THEN /* not already assigned */
            DO:
              ASSIGN cForName     = ENTRY(iCol + 1, cForFields)
                     cValue       = IF NOT lLookupParent 
                                    THEN ENTRY(INT((iCol + 1) / 2), cForValues, CHR(1)) 
                                    ELSE {fnarg columnValue cForName hSource}

                     pcValueList  = cField + CHR(1) 
                                    + (IF cValue = ? THEN "?" ELSE cValue)
                                    + (IF pcValueList = "":U THEN "":U ELSE CHR(1)) 
                                    + pcValueList
                     /* Make it updatable for Add if not already */
                     pcUpdColumns = cField + ",":U + pcUpdColumns.
            END.   /* END DO IF LOOKUP... */
          END.     /* END DO iCol         */
        END.   /* IF VALID-HANDLE(hSource) */
      END.    /* END IF cForFields NE "" */
    END.      /* END DO iPass = 1 to .. */
  END.        /* END DO IF "New"     */
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-submitValidation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE submitValidation Procedure 
PROCEDURE submitValidation :
/*------------------------------------------------------------------------------
  Purpose:     Assign string values passed to submitRow to rowobject and
               do validation on each of the columns of the record as a whole, 
               before committing it to the database.
               
  Parameters:
    INPUT pcValueList  - A CHR(1) delimited list of Column Name<->value pairs
                         that need validation before committing a transaction.
    INPUT pcUpdColumns - A comma delimited list of the SmartDataObject columns
                         that are updatable.

  Notes:       The types of validation performed are:
                 1) Newly entered data meets the format criteria.
                 2) Newly entered data is in an updatable field.
                 2) Record is new or newly entered data is not an 
                    UpdatableWhenNew field.
                 3) Any developer defined validation in the form of a
                    (FieldName)Validation procedure.
                 4) Any developer defined validation in the form of a
                    RowObjectValidation procedure for the whole row.
         - Developer defined validation in the form (FieldName)Validation  
           must be either in the Logic Procedure or in the static SDO. 
           If any field validation procedure is found in the static SDO
           the rest is also assumed to be there.  
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcValueList    AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pcUpdColumns   AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE iColNum           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cColName          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hCol              AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowObject        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cValue            AS CHAR      NO-UNDO.
  DEFINE VARIABLE hLogicObject      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hValRowObject     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lLocalVal         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lLocalFieldVal    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lAnyFieldVal      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDataFieldDefs    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLargeColumns     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cErrorReason      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lNewRow           AS LOGICAL    NO-UNDO. 
  DEFINE VARIABLE cUpdatableWhenNew AS CHARACTER  NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get RowObject hRowObject}
  {get DataLogicObject hLogicObject}
  {get LargeColumns cLargeColumns}
  {get UpdatableWhenNew cUpdatableWhenNew} 
  {get NewRow lNewRow}
  .
  &UNDEFINE xp-assign
  
  IF VALID-HANDLE(hLogicObject) THEN
  DO:
    /* used to check if the SDO TT is static */ 
    {get DataFieldDefs cDataFieldDefs}.
    /* Set the buffer in the logic procedure and also return the handle
       so that it is the Logic procedure buffer values that are passed 
       as input to the field validation procedures */  
    RUN setLogicBuffer IN TARGET-PROCEDURE (INPUT hRowObject, INPUT ?).
    RUN getLogicBuffer IN TARGET-PROCEDURE (OUTPUT hValRowObject).
  END.
  ELSE
    ASSIGN
      hValRowObject  = hRowObject
      lLocalFieldVal = TRUE.
       
  DO iColNum = 1 TO NUM-ENTRIES(pcValueList,CHR(1)) BY 2:
    cColName = ENTRY(iColNum, pcValueList,CHR(1)).
    hCol = hValRowObject:BUFFER-FIELD(cColName) NO-ERROR.
    
    IF hCol = ? THEN 
       RUN addMessage IN TARGET-PROCEDURE (SUBSTITUTE({fnarg messageNumber 53}, cColName), cColName, ?).
    ELSE DO:
      /* Verify that they're not trying to update a non-updatable field. */
      IF LOOKUP(cColName, pcUpdColumns) = 0 THEN
          RUN addMessage IN TARGET-PROCEDURE (SUBSTITUTE({fnarg messageNumber 54}, cColName), cColName, ?).
      else if not lNewRow and LOOKUP(cColName, cUpdatableWhenNew) > 0 then
          RUN addMessage IN TARGET-PROCEDURE (SUBSTITUTE({fnarg messageNumber 101}, cColName), cColName, ?).
      ELSE DO:
        cValue = ENTRY(iColNum + 1, pcValueList,CHR(1)).
        
        IF LOOKUP(cColName, cLargeColumns) > 0 THEN
        DO:         
          cErrorReason = DYNAMIC-FUNCTION('assignBufferValueFromReference':U IN TARGET-PROCEDURE,
                                          hCol,
                                          cValue).
          /* error message 92 (copy of large object to column failed) */ 
          IF cErrorReason > '' THEN
          DO:
            RUN addMessage IN TARGET-PROCEDURE 
                (SUBSTITUTE({fnarg messageNumber 93}, hCol:LABEL, cErrorReason), 
                         hCol:NAME, 
                          ?).

          END.
        END.
        ELSE DO:
          /* Check for unknown values in the list of changes. */
          hCol:BUFFER-VALUE = IF cValue = "?":U 
                              THEN ?
                              ELSE cValue NO-ERROR.
            
          /* Allow for the possibility that the value they entered in the 
             View object may be completely invalid for the format associated 
             with the Frame field. */
          IF ERROR-STATUS:ERROR THEN
            RUN addMessage IN TARGET-PROCEDURE (? /* Use GET-MESSAGE */ , cColName, ?).
          ELSE DO:
            /* If there's a field validation procedure, run it. */
            RUN VALUE(hCol:NAME + 'Validate':U) IN TARGET-PROCEDURE 
                (hCol:BUFFER-VALUE) NO-ERROR. 
            IF NOT ERROR-STATUS:GET-NUMBER(1) = 6456 THEN 
            DO:
              IF NOT lAnyFieldVal THEN lAnyFieldVal = TRUE.
              /* The expectation is that such a procedure will return an error 
                 message if there is one; we will log it for the column. 
                 Otherwise the code assumes that an error-status simply means 
                 there wasn't a validate procedure for this column. 
                 We keep going even if there's a field error. */          
              IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
                RUN addMessage IN TARGET-PROCEDURE 
                      (IF RETURN-VALUE NE "" THEN RETURN-VALUE ELSE ERROR-STATUS:GET-MESSAGE(1), 
                       hCol:NAME, 
                        ?).
              /* if we are using a logic procedure check if the FieldVal is local
                 also ensure that we use the SDO's buffer from now on  */   
              IF cDataFieldDefs > '':U AND NOT lLocalFieldVal 
              AND LOOKUP(hCol:NAME + 'Validate':U,TARGET-PROCEDURE:INTERNAL-ENTRIES) > 0 THEN
                ASSIGN 
                  lLocalFieldVal = TRUE
                  hValRowObject = hRowObject.
            END.
          END. /* END DO Validate procedure. */
        END.
      END.   /* END DO all column validation */
    END.     /* END DO check that column is updatable */
  END.       /* END DO for each updated column */
  
  lLocalVal = NOT VALID-HANDLE(hLogicObject) 
              OR LOOKUP("RowObjectValidate":U,TARGET-PROCEDURE:INTERNAL-ENTRIES) > 0.
  
  /* If we have a logic procedure we may need to copy the data from where 
     the field validation is to where the rowObjectValidate is before we call it.
     If no field validation there's no need as the copy was done above */    
  IF VALID-HANDLE(hLogicObject) AND lAnyFieldVal THEN 
  DO:
    IF NOT lLocalFieldVal AND lLocalVal THEN
      hRowObject:BUFFER-COPY(hValRowObject).  
    ELSE IF lLocalFieldVal AND NOT lLocalVal THEN
      RUN setLogicBuffer IN TARGET-PROCEDURE (INPUT hRowObject, INPUT ?).
  END.

  RUN RowObjectValidate IN TARGET-PROCEDURE NO-ERROR. 

  IF NOT ERROR-STATUS:ERROR  /* Procedure was found and executed. */
  AND RETURN-VALUE NE "":U THEN
    RUN addMessage IN TARGET-PROCEDURE (RETURN-VALUE, ?, ?).

  IF VALID-HANDLE(hLogicObject) THEN
  DO:  
    /* if RowObjectValidation is local we got the values back before we called 
       it (if we needed to) */
    IF NOT lLocalVal THEN 
    do:
      /* synch DLP buffer with RowObject in case RowObjectValidate changed cursor */       
      hValRowObject:find-unique('WHERE RowNum = ':U + string(hRowObject::RowNum)).
      hRowObject:BUFFER-COPY(hValRowObject).
    end.
    RUN clearLogicRows IN TARGET-PROCEDURE.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-undoTransaction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE undoTransaction Procedure 
PROCEDURE undoTransaction :
/*------------------------------------------------------------------------------
  Purpose:     To undo any uncommitted changes to the RowObject table when the
               "Undo" button is pressed in the commit panel.

  Parameters:  <none>

  Notes:       undoTransaction calls doUndoTrans to restore the RowObject 
               Temp-Table and empty the RowObjUpd Temp-Table.
------------------------------------------------------------------------------*/
 
  DEFINE VARIABLE rRowObject  AS ROWID   NO-UNDO.
  DEFINE VARIABLE hDataQuery  AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowObject  AS HANDLE  NO-UNDO.

  DEFINE VARIABLE hContainer         AS HANDLE  NO-UNDO.
  DEFINE VARIABLE lQueryContainer    AS LOGICAL NO-UNDO.
  DEFINE VARIABLE lHasOneToOneTarget AS LOGICAL NO-UNDO.

  DEFINE VARIABLE hSource        AS HANDLE    NO-UNDO.  
  DEFINE VARIABLE lCancel        AS LOGICAL    NO-UNDO.
  
  /* If they have made record changes they haven't saved, they must
     confirm that it is ok to Cancel this also. 
     Make this check if it came from the Commit Panel, but skip if it 
     came locally or from an SBO. */
  {get CommitSource hSource}.
  IF hSource = SOURCE-PROCEDURE THEN
  DO:
     /* Visual dataTargets subscribes to this */
    PUBLISH 'confirmUndo':U FROM TARGET-PROCEDURE (INPUT-OUTPUT lCancel).
    IF lCancel THEN RETURN 'ADM-ERROR':U.
  END.    /* END IF hSource  */

  /* Restore the RowObject Temp-Table and empty the RowObjUpd Temp-Table.*/
  RUN doUndoTrans IN TARGET-PROCEDURE.
     
  /* Now reopen the RowObject query, in order to refresh any dependent 
     SmartDataBrowser, reposition to the previously current row, and do
     dataAvailable to refresh that row in SmartDataViewers and other objects. */
    
  {get DataHandle hDataQuery}.
  hRowObject = hDataQuery:GET-BUFFER-HANDLE(1).
  rRowObject = hRowObject:ROWID.
  hDataQuery:QUERY-CLOSE().
  hDataQuery:QUERY-OPEN().
  hDataQuery:REPOSITION-TO-ROWID(rRowObject) NO-ERROR.
  IF NOT hRowObject:AVAILABLE THEN
    hDataQuery:GET-NEXT().   /* next if needed (for Viewer, not Browser target)*/
    
  /* if we have other targets in update then avoid all publisity..  */
  lHasOneTOOneTarget = {fn hasOneTOOneTarget}.     
  
  &SCOPED-DEFINE xp-assign
  {set RowObjectState 'NoUpdates':U}
  {get QueryContainer lQueryContainer}
  .
  &UNDEFINE xp-assign
  
  /* If we are inside a container with autocommit turned OFF, the container 
     should manage the undo and also has the responsibility to publish 
     dataAvailable. This is necessary because the container's undoTransaction
     calls undoTransaction in all SDOs and publising dataAvailble during this
     makes no sense, amongst other this avoids problems when the dataSources 
     still have rowObjectState 'RowUpdated' when receiving 'dataAvailable' */
  
  IF NOT lhasOneTOOneTarget AND NOT lQueryContainer THEN
  DO:
    PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE ("DIFFERENT":U).
    {set NewBatchInfo '':U}.
  END.
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateAddQueryWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateAddQueryWhere Procedure 
PROCEDURE updateAddQueryWhere :
/*------------------------------------------------------------------------------
  Purpose:     To rebuild query back to design time query, re-add the filters, 
               then add the new where clause and save the new where clause.
  Parameters:  input new where clause (for addquerywhere in correct format)
               input field to search and replace in existing saved manualaddquerywhere
  Notes:       Ensures where clause added is not cleared by filters, and is not duplicated
               in saved manualaddquerywhere.
               Where clause must be in correct format for an addquerywhere.
               If where clause is blank but the field is passed in, then any
               manual query for that field will be removed, therefore defaulting
               back to all.
               Only supports adding a single where clause, but may be called
               many times.
               Used when putting a manual filter viewer above a browser !
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pcWhere                  AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcField                  AS CHARACTER  NO-UNDO.

DEFINE VARIABLE hContainerSource                AS HANDLE       NO-UNDO.
DEFINE VARIABLE cContainerName                  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cSdoName                        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cSdoSignature                   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE rRowid                          AS ROWID        NO-UNDO.
DEFINE VARIABLE cFilterSettings                 AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cFieldNames                     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cFieldValues                    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cFieldOperators                 AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cEmptyString                    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cQueryWhere                     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cManualAddQueryWhere            AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cNewManualAddQueryWhere         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cEntry                          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cBuffer                         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iLoop                           AS INTEGER      NO-UNDO.

{get logicalObjectName cSDOName}.
IF cSDOName = "":U THEN
    ASSIGN cSdoName = TARGET-PROCEDURE:FILE-NAME.

ASSIGN hContainerSource = DYNAMIC-FUNCTION("getContainerSource":U IN TARGET-PROCEDURE).
IF VALID-HANDLE(hContainerSource) THEN
  ASSIGN cContainerName = DYNAMIC-FUNCTION("getLogicalObjectName":U IN hContainerSource).
  
ASSIGN  
  cSdoSignature = cSdoName + ",," + cContainerName + ","
  rRowid = ?.

IF VALID-HANDLE(hContainerSource) THEN
  RUN getProfileData IN gshProfileManager (
      INPUT "BrwFilters":U,
      INPUT "FilterSet":U,
      INPUT cSdoSignature,
      INPUT NO,
      INPUT-OUTPUT rRowid,
      OUTPUT cFilterSettings).

IF cFilterSettings <> "" AND NUM-ENTRIES(cFilterSettings,CHR(3)) = 3 THEN
DO:
  cFieldNames = ENTRY(1,cFilterSettings,CHR(3)).
  cFieldValues = ENTRY(2,cFilterSettings,CHR(3)).
  cFieldOperators = ENTRY(3,cFilterSettings,CHR(3)).
END.

/* clear the existing selection */
&SCOPED-DEFINE xp-assign
{set QueryColumns cEmptyString}
{set QueryWhere   cEmptyString}
/* get manualaddquerywhere that exists, and remove this entry from it */
{get ManualAddQueryWhere cManualAddQueryWhere}
.
&UNDEFINE xp-assign

manual-loop:
DO iLoop = 1 TO NUM-ENTRIES(cManualAddQueryWhere, CHR(4)):
  ASSIGN cEntry = ENTRY(iLoop, cManualAddQueryWhere, CHR(4)).
  
  IF INDEX(cEntry, pcField) > 0 THEN NEXT manual-loop.    /* Ignore passed in field */
  IF NUM-ENTRIES(cEntry, CHR(3)) <> 3 THEN NEXT manual-loop.
  
  ASSIGN cBuffer = ENTRY(2,cEntry,CHR(3)).
  IF cBuffer = "?":U THEN ASSIGN cBuffer = "":U.

  DYNAMIC-FUNCTION("addQueryWhere" IN TARGET-PROCEDURE, ENTRY(1,cEntry,CHR(3)),
                                                        cBuffer,
                                                        ENTRY(3,cEntry,CHR(3))). 
  ASSIGN
    cNewManualAddQueryWhere = cNewManualAddQueryWhere +
        (IF cNewManualAddQueryWhere <> "":U THEN CHR(4) ELSE "":U) +
        cEntry
    .        
END.

IF cFieldNames <> "":U THEN
  DYNAMIC-FUNCTION ("assignQuerySelection":U IN TARGET-PROCEDURE,
                    cFieldNames,
                    cFieldValues,
                    cFieldOperators).

IF pcWhere <> "":U THEN
  ASSIGN
    cNewManualAddQueryWhere = cNewManualAddQueryWhere +
        (IF cNewManualAddQueryWhere <> "":U THEN CHR(4) ELSE "":U) +
        pcWhere + CHR(3) + CHR(3) + "AND":U
    .        

{set ManualAddQueryWhere cNewManualAddQueryWhere}.

IF pcWhere <> "":U THEN
  DYNAMIC-FUNCTION("addQueryWhere":U IN TARGET-PROCEDURE, pcWhere, "":U, "AND":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateQueryPosition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateQueryPosition Procedure 
PROCEDURE updateQueryPosition :
/*------------------------------------------------------------------------------
  Purpose: Reset the QueryPosition property after a record navigation.  
    Notes: LastRowNum, FirstRowNum properties must be set before this is called. 
         - The properties LastRowNum and FirstRowNum stores the 
           RowObject.RowNum of the first and last record in the database query. 
         - Overrides and duplicates some of the logic in dataquery because 
           RowNum is used and because we may be inside an SBO.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRowObject   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLastRowNum  AS INT        NO-UNDO.
  DEFINE VARIABLE iFirstRowNum AS INT        NO-UNDO.  
  DEFINE VARIABLE hRowNum      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lLast        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cQueryPos    AS CHAR       NO-UNDO.
  DEFINE VARIABLE lNew         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hDataSource  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContainer   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lSBO         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lQuery       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cParentPos   AS CHARACTER  NO-UNDO.

  {get RowObject hRowObject}.

  IF VALID-HANDLE(hRowObject) AND hRowObject:AVAILABLE THEN
  DO:
    &SCOPED-DEFINE xp-assign
     {get FirstRowNum iFirstRowNum}
     {get LastRowNum iLastRowNum}
    &UNDEFINE xp-assign
      hRowNum   = hRowObject:BUFFER-FIELD('RowNum':U)
      /* Are we on the last record?  */
      lLast     = hRowNum:BUFFER-VALUE   = iLastRowNum
      cQueryPos = IF hRowNum:BUFFER-VALUE = iFirstRowNum                   
                  THEN (IF NOT lLast 
                        THEN 'FirstRecord':U 
                        ELSE 'OnlyRecord':U) /* first AND last is ONLY */
                  ELSE (IF NOT lLast 
                        THEN 'NotFirstOrLast':U /* not first and not last */ 
                        ELSE 'LastRecord':U)
      .   
  END. /* If hRowObject:available */
  ELSE DO: 
    /* Check for a DataSource. If there is a data source then we check 
       queryPosition in the source */
    {get DataSource hDataSource}.
    /* if no datasource check to see if we're in an SBO with a DataSource */
    IF NOT VALID-HANDLE(hDataSource) THEN 
    DO:
      {get ContainerSource hContainer}.
      /* If we're inside an SBO, get its datasource */
      IF VALID-HANDLE(hContainer) THEN 
      DO:
        {get QueryObject lSBO hContainer}.
        IF lSBO THEN
          {get DataSource hDataSource hContainer}.
      END.
    END. /* not valid DataSource  (check if container is SBO DataTarget)  */
    
    IF VALID-HANDLE(hDataSource) THEN 
    DO:
      {get QueryObject lQuery hDataSource}.
      IF lQuery THEN
      DO:        
        /* Set the "dirty call back identifier" in case the datasource is an SBO */
        ghTargetProcedure = TARGET-PROCEDURE.
        {get QueryPosition cParentPos hDataSource}.
        ghTargetProcedure = ?.
        IF cParentPos BEGINS 'NoRecordAvailable':U THEN
          cQueryPos = 'NoRecordAvailableExt':U.

        IF cQueryPos = '':U THEN
        DO:
          /* Check if dataSource has an unsaved new record */
          {get NewMode lNew hDataSource}.
          IF lNew THEN
            cQueryPos = 'NoRecordAvailableExt':U.
        END. /* cQueryPos = '' */
      END. /* query */
      ELSE /* if datasource not query object ( possibly pass-thru) then
               assume nothing is available (yet) */ 
        cQueryPos = 'NoRecordAvailableExt':U.
    END.  /* valid DataSource */     
    /* If not set above set the cQueryPos variable to NoRecordAvailable */ 
    IF cQueryPos = '':U THEN
      cQueryPos = 'NoRecordAvailable':U.
  END.  /* else (not avail)*/

  {set QueryPosition cQueryPos}.
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-addRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addRow Procedure 
FUNCTION addRow RETURNS CHARACTER
  ( pcViewColList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Creates a new RowObject temp-table record, initializes it, and
               returns CHR(1) delimited list of values for the requested 
               columns (in pcViewColList) of the new RowObject row.
               The first entry in the list is the RowObect ROWID and db RowIds
               separated with commas. (The db Rowids are blank as the record 
               has not been created)    
  Parameters:
    INPUT pcViewColList - comma-separated list of columns names that are to
                          be displayed in the SmartDataViewer that called
                          addRow.
      Notes: Overrides dataview to handle foreignvalues from SBO and call
             newRowObject to set Rowobject fields and call logic procedure hook                    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iCol       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hColumn    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iColCount  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cColList   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRowid     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hDataQuery AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cForFields AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cForValues AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cField     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lQueryContainer AS LOGICAL    NO-UNDO.

    &SCOPED-DEFINE xp-assign
    {get RowObject hRowObject}
    {get ForeignFields cForFields}
    {get DataColumns cColList}
    .
    &UNDEFINE xp-assign
    /* Save off the "current" rowid in case the add is cancelled. 
       If there's no RowObject record available, it's because we're
       being browsed from outside, so use the Browser's RowIdent. */
    IF hRowObject:AVAILABLE THEN
      {set CurrentRowid hRowObject:ROWID}.
    ELSE DO:
      /* ... or it might just be because we're adding multiple new
         rows at a time or for some other reason, so SOURCE-PROC may not be
         a SmartObject. In that case RowIdent will come back Unknown. 
         Use dynamic-function in case the object has no such property. */
      cRowid = DYNAMIC-FUNCTION('getRowIdent':U IN SOURCE-PROCEDURE) NO-ERROR.
      cRowid = ENTRY(1, cRowid).
      {set CurrentRowid TO-ROWID(cRowid)}.
    END.   /* END No RowObject Available */  
    
    hRowObject:BUFFER-CREATE().
    
    /* The creation of the record in the buffer automatically
       populates the field values with the initial values.
       As part of this, the initial values are converted into
       the correct date and/or numeric format (if relevant),
       so we don't need to do anything in this regard.
       The value of TODAY is also correctly converted into
       today's date.
     */
    
    /* If there are Foreign Fields, assign their values as initial
       values for those columns. */
    IF cForFields = "" THEN 
    DO:
      /* Find out whether this SDO is inside an SBO */
      {get QueryContainer lQueryContainer}.
      IF lQueryContainer THEN
        cForFields = {fn getForeignFieldsContainer}.
    END.

    IF cForFields NE "":U THEN
    DO:
      {get ForeignValues cForValues}.
      /* Each ForField pair is db name, RowObject name */
      DO iCol = 1 TO NUM-ENTRIES(cForFields) BY 2:
        cField = ENTRY(iCol, cForFields).
        hColumn = hRowObject:BUFFER-FIELD(ENTRY(NUM-ENTRIES(cField, ".":U), cField, ".":U)).
        IF VALID-HANDLE(hColumn) THEN  /* might not be in SDO */
          hColumn:BUFFER-VALUE = ENTRY(INT((iCol + 1) / 2), cForValues, CHR(1)).
      END.  /* END DO iCol */
    END.    /* END DO IF cForFields NE "" */

    /* set RowNum and first last status */  
    {fnarg newRowObject 'Add':U}.

    RETURN {fnarg colValues pcViewColList}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-applyContextFromClient) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION applyContextFromClient Procedure 
FUNCTION applyContextFromClient RETURNS LOGICAL
  ( pcContext AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Apply context returned from server after a server call
Parameter: CHR(4) separated paired list with attributename and value 
           (Also supports old format CHR(3)<prop>CHR(4)<value> )
    Notes:  
       Typical usage:    
           cContext = obtainContextForServer()
           run <remotecall> (input-output cContext). 
           applyContextFromServer(ccontext)                          
------------------------------------------------------------------------------*/  
 DEFINE VARIABLE cValue             AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cVal               AS CHARACTER  NO-UNDO EXTENT 19.
 DEFINE VARIABLE lProp              AS LOGICAL    NO-UNDO EXTENT 19.
 DEFINE VARIABLE cProperty          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iLoop              AS INTEGER    NO-UNDO.

 /* the forced set properties (with no xp preprocessor should be last in order) 
    to optimize assign using xp-assign with set includes below */
 &SCOPED-DEFINE prop-1  RowsToBatch 
 &SCOPED-DEFINE prop-2  RebuildOnRepos 
 &SCOPED-DEFINE prop-3  FirstRowNum        
 &SCOPED-DEFINE prop-4  LastRowNum
 &SCOPED-DEFINE prop-5  FirstResultRow        
 &SCOPED-DEFINE prop-6  LastResultRow
 &SCOPED-DEFINE prop-7  QueryRowident 
 &SCOPED-DEFINE prop-8  ForeignValues 
 &SCOPED-DEFINE prop-9  CheckCurrentChanged 
 &SCOPED-DEFINE prop-10 ServerSubmitValidation 
 &SCOPED-DEFINE prop-11 KeyTableId
 &SCOPED-DEFINE prop-12 EntityFields 
 &SCOPED-DEFINE prop-13 FetchHasAudit 
 &SCOPED-DEFINE prop-14 FetchHasComment 
 &SCOPED-DEFINE prop-15 FetchAutoComment
 &SCOPED-DEFINE prop-16 DestroyStateless
 &SCOPED-DEFINE prop-17 KeyFields
 &SCOPED-DEFINE prop-18 QueryWhere /* must be set AFTER dynamic meta props 
                                     (set in loop before all of these hardcoded ones)
                                      and BEFORE QueryColumns */
 &SCOPED-DEFINE prop-19 QueryColumns /* Used in DynWeb set AFTER QueryWhere!! */   

 /* support 'old' delimiter format */          
 pcContext = REPLACE(pcContext,CHR(3),CHR(4)).

  /* The main goal of this code is to avoid the calls to setters in the 
    loop. 
    ( The attempt to avoid all loops stranded on complexity, particularly 
      the fact that 
       iProp[1] = lookup (MyHardcodedProp1,pcContext) 
       iProp[2] = lookup (MyHardcodedProp2,pcContext) 
      might find a matching value instead of prop... )    */
    
 DO iLoop = 1 TO NUM-ENTRIES(pcContext,CHR(4)) BY 2:
   ASSIGN
     cProperty = ENTRY(iLoop,pcContext,CHR(4))
     cValue    = ENTRY(iLoop + 1,pcContext,CHR(4))
     cValue    = IF cValue = '?' THEN ? ELSE cValue.
   CASE cProperty:
     WHEN '{&prop-1}':U THEN 
       ASSIGN
         lProp[1] = TRUE 
         cVal[1] = cValue.
     WHEN '{&prop-2}':U THEN 
       ASSIGN
         lProp[2] = TRUE 
         cVal[2] = cValue.
     WHEN '{&prop-3}':U THEN 
       ASSIGN
         lProp[3] = TRUE 
         cVal[3] = cValue.
     WHEN '{&prop-4}':U THEN 
       ASSIGN
         lProp[4] = TRUE 
         cVal[4] = cValue.
     WHEN '{&prop-5}':U THEN 
       ASSIGN
         lProp[5] = TRUE 
         cVal[5] = cValue.
     WHEN '{&prop-6}':U THEN 
       ASSIGN
         lProp[6] = TRUE 
         cVal[6] = cValue.
     WHEN '{&prop-7}':U THEN 
       ASSIGN
         lProp[7] = TRUE 
         cVal[7] = cValue.
     WHEN '{&prop-8}':U THEN 
       ASSIGN
         lProp[8] = TRUE 
         cVal[8] = cValue.
     WHEN '{&prop-9}':U THEN 
       ASSIGN
         lProp[9] = TRUE 
         cVal[9] = cValue.
     WHEN '{&prop-10}':U THEN 
       ASSIGN
         lProp[10] = TRUE 
         cVal[10] = cValue.
     WHEN '{&prop-11}':U THEN 
       ASSIGN
         lProp[11] = TRUE 
         cVal[11] = cValue.
     WHEN '{&prop-12}':U THEN 
       ASSIGN
         lProp[12] = TRUE 
         cVal[12] = cValue.
     WHEN '{&prop-13}':U THEN 
       ASSIGN
         lProp[13] = TRUE 
         cVal[13] = cValue.
     WHEN '{&prop-14}':U THEN 
       ASSIGN
         lProp[14] = TRUE 
         cVal[14] = cValue.
     WHEN '{&prop-15}':U THEN
       ASSIGN
         lProp[15] = TRUE
         cVal[15] = cValue.
     WHEN '{&prop-16}':U THEN
       ASSIGN
         lProp[16] = TRUE
         cVal[16] = cValue.
     WHEN '{&prop-17}':U THEN 
        ASSIGN                
          lProp[17] = TRUE    
          cVal[17] = cValue.  
     WHEN '{&prop-18}':U THEN 
        ASSIGN                
          lProp[18] = TRUE    
          cVal[18] = cValue.  
     WHEN '{&prop-19}':U THEN 
        ASSIGN                
          lProp[19] = TRUE    
          cVal[19] = cValue.  
     OTHERWISE  
        DYNAMIC-FUNCTION("set":U + cProperty IN TARGET-PROCEDURE, cValue) NO-ERROR.  
     
   END CASE.
 END. /* do iloop to num-entries pccontext by 2 */
  &SCOPED-DEFINE xp-assign
    {set {&prop-1} cVal[1]} WHEN lProp[1]
    {set {&prop-2} cVal[2]} WHEN lProp[2]
    {set {&prop-3} cVal[3]} WHEN lProp[3]
    {set {&prop-4} cVal[4]} WHEN lProp[4]
    {set {&prop-5} cVal[5]} WHEN lProp[5]
    {set {&prop-6} cVal[6]} WHEN lProp[6]
    {set {&prop-7} cVal[7]} WHEN lProp[7]
    {set {&prop-8} cVal[8]} WHEN lProp[8]
    {set {&prop-9} cVal[9]} WHEN lProp[9]
    {set {&prop-10} cVal[10]} WHEN lProp[10]
    {set {&prop-11} cVal[11]} WHEN lProp[11]
    {set {&prop-12} cVal[12]} WHEN lProp[12]
    {set {&prop-13} cVal[13]} WHEN lProp[13]
    {set {&prop-14} cVal[14]} WHEN lProp[14]
    {set {&prop-15} cVal[15]} WHEN lProp[15]
    {set {&prop-16} cVal[16]} WHEN lProp[16] 
    {set {&prop-17} cVal[17]} WHEN lProp[17] 
    {set {&prop-18} cVal[18]} WHEN lProp[18] 
    {set {&prop-19} cVal[19]} WHEN lProp[19] 
     .                                  
 &UNDEFINE xp-assign                    
  

  &UNDEFINE prop-1
  &UNDEFINE prop-2
  &UNDEFINE prop-3
  &UNDEFINE prop-4
  &UNDEFINE prop-5
  &UNDEFINE prop-6
  &UNDEFINE prop-7
  &UNDEFINE prop-8
  &UNDEFINE prop-9
  &UNDEFINE prop-10
  &UNDEFINE prop-11
  &UNDEFINE prop-12
  &UNDEFINE prop-13
  &UNDEFINE prop-14
  &UNDEFINE prop-15
  &UNDEFINE prop-16 
  &UNDEFINE prop-17 
  &UNDEFINE prop-18 
  &UNDEFINE prop-19 
                    
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-applyContextFromServer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION applyContextFromServer Procedure 
FUNCTION applyContextFromServer RETURNS LOGICAL
  ( pcContext AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Apply context returned from server after a server call
Parameter: CHR(4) separated paired list with attributename and value 
           (Also supports old format CHR(3)<prop>CHR(4)<value> )
    Notes:  
       Typical usage:    
           cContext = obtainContextForServer()
           run <remotecall> (input-output cContext). 
           applyContextFromServer(ccontext)               
------------------------------------------------------------------------------*/  
 DEFINE VARIABLE cServerOperatingMode AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lAsHasStarted        AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cValue             AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cVal               AS CHARACTER  NO-UNDO EXTENT 17.
 DEFINE VARIABLE lProp              AS LOGICAL    NO-UNDO EXTENT 17.
 DEFINE VARIABLE cProperty          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iLoop              AS INTEGER    NO-UNDO.

 /* the forced set properties (with no xp preprocessor are last in order) 
    to optimize  assign using xp-assign with set includes below */
 &SCOPED-DEFINE prop-1  FirstResultRow 
 &SCOPED-DEFINE prop-2  LastResultRow 
 &SCOPED-DEFINE prop-3  FirstRowNum        
 &SCOPED-DEFINE prop-4  LastRowNum
 &SCOPED-DEFINE prop-5  QueryRowident 
 &SCOPED-DEFINE prop-6  PositionForClient 
 &SCOPED-DEFINE prop-7  CheckCurrentChanged 
 &SCOPED-DEFINE prop-8  PhysicalTables 
 &SCOPED-DEFINE prop-9  EntityFields 
 &SCOPED-DEFINE prop-10 AuditEnabled 
 &SCOPED-DEFINE prop-11 QueryContext 
 &SCOPED-DEFINE prop-12 BaseQuery 
 &SCOPED-DEFINE prop-13 ServerOperatingMode 
 &SCOPED-DEFINE prop-14 KeyFields 
 &SCOPED-DEFINE prop-15 KeyTableId 
 &SCOPED-DEFINE prop-16 IndexInformation 
 &SCOPED-DEFINE prop-17 DbNames 
 
 /* support 'old' delimiter format */          
 pcContext = REPLACE(pcContext,CHR(3),CHR(4)).

 {get AsHasStarted lAsHasStarted}.
 IF NOT lAsHasStarted THEN
   {get ServerOperatingMode cServerOperatingMode}.
 
  /* The main goal of this code is to avoid the calls to setters in the 
    loop. 
    ( The attempt to avoid all loops stranded on complexity, particularly 
      the fact that 
       iProp[1] = lookup (MyHardcodedProp1,pcContext) 
       iProp[2] = lookup (MyHardcodedProp2,pcContext) 
      might find a matching value instead of prop... )    */

 DO iLoop = 1 TO NUM-ENTRIES(pcContext,CHR(4)) BY 2:
   ASSIGN
     cProperty = ENTRY(iLoop,pcContext,CHR(4))
     cValue    = ENTRY(iLoop + 1,pcContext,CHR(4))
     cValue    = IF cValue = '?' THEN ? ELSE cValue.

   CASE cProperty:
     WHEN '{&prop-1}':U THEN 
       ASSIGN
         lProp[1] = TRUE 
         cVal[1] = cValue.
     WHEN '{&prop-2}':U THEN 
       ASSIGN
         lProp[2] = TRUE 
         cVal[2] = cValue.
     WHEN '{&prop-3}':U THEN 
       ASSIGN
         lProp[3] = TRUE 
         cVal[3] = cValue.
     WHEN '{&prop-4}':U THEN 
       ASSIGN
         lProp[4] = TRUE 
         cVal[4] = cValue.
     WHEN '{&prop-5}':U THEN 
       ASSIGN
         lProp[5] = TRUE 
         cVal[5] = cValue.
     WHEN '{&prop-6}':U THEN 
       ASSIGN
         lProp[6] = TRUE 
         cVal[6] = cValue.
     WHEN '{&prop-7}':U THEN 
       ASSIGN
         lProp[7] = TRUE 
         cVal[7] = cValue.
     WHEN '{&prop-8}':U THEN 
       ASSIGN
         lProp[8] = TRUE 
         cVal[8] = cValue.
     WHEN '{&prop-9}':U THEN 
       ASSIGN
         lProp[9] = TRUE 
         cVal[9] = cValue.
     WHEN '{&prop-10}':U THEN 
       ASSIGN
         lProp[10] = TRUE 
         cVal[10] = cValue.
     WHEN '{&prop-11}':U THEN 
       ASSIGN
         lProp[11] = TRUE 
         cVal[11] = cValue.
     WHEN '{&prop-12}':U THEN 
       ASSIGN
         lProp[12] = TRUE 
         cVal[12] = cValue.
     WHEN '{&prop-13}':U THEN 
       ASSIGN
         lProp[13] = TRUE 
         cVal[13] = cValue.
     WHEN '{&prop-14}':U THEN 
       ASSIGN
         lProp[14] = TRUE 
         cVal[14] = cValue.
     WHEN '{&prop-15}':U THEN 
       ASSIGN
         lProp[15] = TRUE 
         cVal[15] = cValue.
     WHEN '{&prop-16}':U THEN 
       ASSIGN
         lProp[16] = TRUE 
         cVal[16] = cValue.
     WHEN '{&prop-17}':U THEN 
       ASSIGN
         lProp[17] = TRUE 
         cVal[17] = cValue.        
     OTHERWISE 
       DYNAMIC-FUNCTION("set":U + cProperty IN TARGET-PROCEDURE, cValue) NO-ERROR.  
   END CASE.
   
 END. /* do iloop to num-entries pccontext by 2 */
 
  &SCOPED-DEFINE xp-assign
    {set ServerFirstCall FALSE}
    {set {&prop-1} cVal[1]} WHEN lProp[1]
    {set {&prop-2} cVal[2]} WHEN lProp[2]
    {set {&prop-3} cVal[3]} WHEN lProp[3]
    {set {&prop-4} cVal[4]} WHEN lProp[4]
    {set {&prop-5} cVal[5]} WHEN lProp[5]
    {set {&prop-6} cVal[6]} WHEN lProp[6]
    {set {&prop-7} cVal[7]} WHEN lProp[7]
    {set {&prop-8} cVal[8]} WHEN lProp[8]
    {set {&prop-9} cVal[9]} WHEN lProp[9]
    {set {&prop-10} cVal[10]} WHEN lProp[10]
    {set {&prop-11} cVal[11]} WHEN lProp[11]
    {set {&prop-12} cVal[12]} WHEN lProp[12]
    {set {&prop-13} cVal[13]} WHEN lProp[13]
    {set {&prop-14} cVal[14]} WHEN lProp[14]
    {set {&prop-15} cVal[15]} WHEN lProp[15]
    {set {&prop-16} cVal[16]} WHEN lProp[16]
    {set {&prop-17} cVal[17]} WHEN lProp[17]
    .                               
 &UNDEFINE xp-assign                    
 
  IF NOT lAsHasStarted THEN
  DO:
    /* We assume that the Appserver now has started */
    {set AsHasStarted TRUE}.
    /* Override the actual state if the instance property is force stateful */
    IF cServerOperatingMode = "STATE-RESET":U THEN
      {set ServerOperatingMode cServerOperatingMode}. 
  END.
  &UNDEFINE prop-1
  &UNDEFINE prop-2
  &UNDEFINE prop-3
  &UNDEFINE prop-4
  &UNDEFINE prop-5
  &UNDEFINE prop-6
  &UNDEFINE prop-7
  &UNDEFINE prop-8
  &UNDEFINE prop-9
  &UNDEFINE prop-10
  &UNDEFINE prop-11
  &UNDEFINE prop-12
  &UNDEFINE prop-13
  &UNDEFINE prop-14
  &UNDEFINE prop-15
  &UNDEFINE prop-16
  &UNDEFINE prop-17

  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-batchRowAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION batchRowAvailable Procedure 
FUNCTION batchRowAvailable RETURNS LOGICAL
  ( pcMode AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Check if there are more records available in the current batch 
Parameters: pcMode - Specifies direction to look  
                   - 'Next' 
                   - 'Prev'
                   - 'current'  
    Notes: Check this before navigating with the normal fetch* navigation 
           methods to avoid an implicit read of a new batch in cases where 
           the intention is to just navigate through one batch of data.    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cLastResultRow   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFirstResultRow  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hRowObject       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowNum          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLastRowInBatch  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iFirstRowInBatch AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hDataQuery       AS HANDLE     NO-UNDO.

  {get RowObject hRowObject}.  
  IF hRowObject:AVAILABLE THEN
  DO:
    hRowNum = hRowObject:BUFFER-FIELD('RowNum':U).
    CASE pcMode:
      WHEN 'Next':U THEN
      DO:
        {get LastResultRow cLastResultRow}.
        iLastRowInBatch = INT(ENTRY(1,cLastResultRow,';':U)). 
        IF hRowNum:BUFFER-VALUE < iLastRowInBatch THEN
          RETURN TRUE.
        IF hRowNum:BUFFER-VALUE = iLastRowInBatch THEN
          RETURN FALSE.
      END.
      WHEN 'First':U THEN
      DO:
        {get FirstResultRow cFirstResultRow}.
        iFirstRowInBatch = INT(ENTRY(1,cFirstResultRow,';':U)). 
        IF hRowNum:BUFFER-VALUE > iFirstRowInBatch THEN
          RETURN TRUE.
        IF hRowNum:BUFFER-VALUE = iFirstRowInBatch THEN
          RETURN FALSE.
      END. 
      OTHERWISE RETURN TRUE.
    END CASE.
  END.
  ELSE DO:
    
    IF pcMode = 'current':U THEN
      RETURN FALSE.
    {get DataHandle hDataQuery}.
    IF hDataQuery:CURRENT-RESULT-ROW = 1 THEN 
      RETURN pcMode = 'NEXT':U.
  END.

  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cancelRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION cancelRow Procedure 
FUNCTION cancelRow RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:     Cancels an Add, Copy, or Save operation.  
  Parameters:  <none>  
  Notes:       cancelRow calls doUndoUpdate which restores the original values
               of a modified row from the RowObjUpd record then deletes the
               RowObjUdp record.  In the case of newMode, the new 
               RowObject is deleted and doUndoUpdate repositions the 
               RowObject temp-table to what was previously the current row.
Note date: 2002/04/11               
------------------------------------------------------------------------------*/
 DEFINE VARIABLE lNew          AS LOG       NO-UNDO.

 {get NewMode lNew}.
 {set DataModified FALSE}.
  /* if not new then we're just going out of updatemode (no saved changes) and
     all we needed was to setDataModified false */
 if lNew then
 do:  
   RUN doUndoUpdate IN TARGET-PROCEDURE.
   /* If cancel new tell the data-targets that we're back in business, if we're NOT in a SBO  */
   IF NOT {fn getQueryContainer} THEN 
   DO:
     PUBLISH "dataAvailable":U FROM TARGET-PROCEDURE('DIFFERENT':U).
     {set NewBatchInfo '':U}.
   END.
 end.
   
 RETURN '':U. /* This used to return a cError variable for some forgotten reason*/

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-canNavigate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION canNavigate Procedure 
FUNCTION canNavigate RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Check if this object or its children has any updates   
    Notes: You can navigate an object that has uncommiited changes, but not 
           if the children has uncommitted changes, so this publishes 
           IsUpdatePending to check children as this includes rowObjectState 
           in the check.
         - Navigating objects will typically call this to check if the object
           that they are navigating can be navigated. Nav objects receives
           updateState from the objects they navigate and will perform this 
           check in the source of any 'updateComplete' message. This is required
           because an 'updateComplete' may come from a branch of a data-link 
           tree while publish isUpdatePending will check the whole tree to 
           ensure that no branches has pending updates. 
         - This returns true if we can navigate while isUpdatePending is the 
           opposite and returns true if update is pending. 
          (The real reason: It's easier to have default false for i-o params)   
------------------------------------------------------------------------------*/
   DEFINE VARIABLE lDataModified   AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE lUpdate         AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE lNewMode        AS LOGICAL    NO-UNDO.  

   {get DataModified lDataModified}.      
    /* Use NewMode refers to the current Object's state, NOT newRow */ 
   {get NewMode lNewMode}.  
   
   /* Use = TRUE to ensure that unknown is treated similar to false */
   lUpdate =  (lDataModified = TRUE) OR (lNewMode = TRUE). 
   /* This object does not block navigation, check all targets, 
      updatePending does the same check, but it always checks rowObjectstate 
      also to see if there are any pending uncommitted changes */         
   IF NOT lUpdate THEN  
     PUBLISH 'isUpdatePending':U FROM TARGET-PROCEDURE (INPUT-OUTPUT lUpdate).
   
   RETURN NOT lUpdate.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-closeQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION closeQuery Procedure 
FUNCTION closeQuery RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Closes the RowObject temp-table query on both the client side
               and the server side (if the SmartDataObject is split.)  Then
               calls SUPER (which resolves to closeQuery in query.p) to close
               the database query.
 
  Parameters:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hBuffer         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataQuery      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hAppServer      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cASDivision     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hRowObject      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lReturnCode     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cOperatingMode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContext        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lQueryContainer AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lAsBound        AS LOGICAL    NO-UNDO.
  
  {get ASDivision cASDivision}.
  {get DataHandle hDataQuery}.  /* Close the RowObject query. */

  IF VALID-HANDLE(hDataQuery) THEN
  DO:
    /* only do this if we are not a 1-to-1 child */
    IF NOT {fn getUpdateFromSource} THEN
      {fnarg emptyRowObject 'reset':U}.

    hDataQuery:QUERY-CLOSE().

    /* Don't do QueryPosition and dataAvailable if we're just closing
       a query to re-open it, because these cause unnecessary flashing. */
    IF ENTRY(1, PROGRAM-NAME(2), " ":U) NE 'openQuery':U AND
       ENTRY(1, PROGRAM-NAME(3), " ":U) NE 'openQuery':U THEN
    DO:
      RUN updateQueryPosition IN TARGET-PROCEDURE.
      PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE("DIFFERENT":U).
      {set NewBatchInfo '':U}.
    END.

  END.  /* If valid-handle */
  
  
  IF cASDivision = 'Client':U THEN
  DO:
     /* No server calls possible inside an SBO */ 
    {get QueryContainer lQueryContainer}. 
    IF NOT lQueryContainer THEN
    DO:
      /* If we're just the client then tell the AppServer to close. */
      {get ServerOperatingMode cOperatingMode}.
      {get Asbound lASbound}.
      /* We don't connect just to close the query in stateless mode. */  
      IF cOperatingMode <> 'STATELESS':U AND lASBound THEN 
      DO:
        {get ASHandle hAppServer}.
        IF VALID-HANDLE(hAppServer) THEN 
          RETURN {fn closeQuery hAppServer}.
        ELSE 
         RETURN FALSE.  
      END. /* IF cOperatingMode <> 'STATELESS':U */
    END. /* not QueryContainer */
    RETURN TRUE. 

  END.    /*  DO IF Client */
  ELSE RETURN SUPER(). /* Get query.p's version of this to close the db query. */
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-commit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION commit Procedure 
FUNCTION commit RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Client-side part of the Commit function. Copies changed records
            into an update temp-table and sends it to the serverCommit (the
            server-side commit procedure.)
    
  Notes:    The code in submitRow (which calls commitTransaction, which calls
            Commit) has already created a pre-change copy of each changed 
            record in the update temp-table.
            This function invokes procedures in the SmartDataObject itself to 
            manipulate the RowObject Temp-Tables.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cUndoIds        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hAppServer      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cMessages       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cASDivision     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hAppservice     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cServerFileName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLogicalname    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContext        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hRowObjUpd      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE rRowid          AS ROWID      NO-UNDO.
  DEFINE VARIABLE lSuccess        AS LOGICAL    NO-UNDO.
  
  /* Transfer modified and added rows to the update table. */
  RUN doBuildUpd IN TARGET-PROCEDURE. 
  /* If we're running across an AppServer connection, run serverCommit
     in that other object. Otherwise just run it in ourself. */
  {get ASDivision cASDivision}.
  IF cASDivision = 'Client':U THEN
  DO:
    /* Check AppServer properties to see if the object has no current or future 
       server bindings and is using a stateless operating mode.*/    
    IF {fn hasNoServerBinding} THEN
    DO:
      RUN connectServer IN TARGET-PROCEDURE (OUTPUT hAppService). 
      IF hAppService  = ? THEN
         RETURN FALSE.
    END.
    ELSE 
      {get ASHandle hAppServer}.

    cContext = {fn obtainContextForServer}.
  END. /* client */

  IF VALID-HANDLE(hAppserver) THEN
  DO:
    {get RowObjUpdTable hRowObjUpd}.
    RUN remoteCommit IN hAppServer
      (INPUT-OUTPUT cContext,
       INPUT-OUTPUT TABLE-HANDLE hRowObjUpd, 
       OUTPUT cMessages, 
       OUTPUT cUndoIds).  
    {fnarg applyContextFromServer cContext}.
    /* unbind if stateless */ 
    RUN endClientDataRequest IN TARGET-PROCEDURE.
  END.
  ELSE IF VALID-HANDLE(hAppService) THEN
  DO:
    &SCOPED-DEFINE xp-assign
    {get RowObjUpdTable hRowObjUpd}
    {get ServerFileName cServerFileName}
    {get LogicalObjectName cLogicalName}
     .
     &UNDEFINE xp-assign
   
    RUN adm2/commit.p ON hAppService
         (cServerFileName 
          + (IF cLogicalname > '' THEN ':' + cLogicalName ELSE ''),
         INPUT-OUTPUT cContext,
         INPUT-OUTPUT TABLE-HANDLE hRowObjUpd, 
         OUTPUT cMessages, 
         OUTPUT cUndoIds).

    {fnarg applyContextFromServer cContext}.
  END.
  ELSE DO:
    /* refetchDbRow may mess with the RowObject -- so keep track of it */
    {get RowObject hRowObject}.
    rRowid = hRowObject:ROWID.
    RUN bufferCommit IN TARGET-PROCEDURE (OUTPUT cMessages, OUTPUT cUndoIds).
    IF rRowid <> ? AND rRowid <> hRowObject:ROWID THEN
      hRowObject:FIND-BY-ROWID(rRowid).  
  END.

  /* If we're running with a separate AppServer DataObject, then we must
     append any error messages returned to the message log. Otherwise they
     are already there. */
  IF cASDivision = 'Client':U AND cMessages NE "" THEN
    RUN addMessage IN TARGET-PROCEDURE (cMessages, ?, ?).

  /* determine the success of the commit operation before anything else */
  /* in case the error buffer is emptied... */
  lSuccess = NOT {fn anyMessage}.

  /* Return any rows to the client that have been changed by the server. */
  RUN doReturnUpd IN TARGET-PROCEDURE (INPUT cUndoIds).
  
  RETURN lSuccess.  /* return success if no error msgs. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-copyRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION copyRow Procedure 
FUNCTION copyRow RETURNS CHARACTER
  ( pcViewColList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Creates a new RowObject temp-table record, copies all of the 
               current row values to it.  The return value of this function is 
               a CHR(1) delimited list of the values of the current row as 
               specified in the input parameter pcViewColList.  The first value 
               of this return value is the RowIdent of the newly created row.
               
  Parameters:  
    INPUT pcViewColList - comma-separated list of columns whose values are to
                          be returned for the newly created row.
      Notes: Overrides dataview mostly because of copyColumns - newRowobject  
             (copycolumns may not necessarily be different, but newRowobject
              is only in data class, so might as well override this and free 
              the dataview to have a (c)leaner implemention)                            
 ------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRowObject AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cRowid     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE rRowObject AS ROWID     NO-UNDO.
  DEFINE VARIABLE hDataQuery AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lBrowsed   AS LOGICAL   NO-UNDO.

   &SCOPED-DEFINE xp-assign
    {get RowObject hRowObject}
    {get DataHandle hDataQuery}
    .
   &UNDEFINE xp-assign
   
    /* Save off the "current" rowid in case the add is cancelled. 
       If there's no RowObject record available, it's because we're
       being browsed from outside, so use the Browser's RowIdent. */
    /* NOTE: Here and in addRow just checking AVAILABLE is not really a reliable
       way to tell whether the record that happens to be current in the DO is the
       one the client wants to COpy. */
    IF hRowObject:AVAILABLE THEN
      {set CurrentRowid hRowObject:ROWID}.
    ELSE DO:
      IF hDataQuery:IS-OPEN THEN    /* not open means not using temp-table */
      DO:
        {get RowIdent cRowid SOURCE-PROCEDURE}.
        cRowid = ENTRY(1, cRowid).
        {set CurrentRowid TO-ROWID(cRowid)}.
        rRowObject = TO-ROWID(cRowid).
        {get DataQueryBrowsed lBrowsed}.
        IF lBrowsed THEN
          hRowObject:FIND-BY-ROWID(rRowObject).
        ELSE DO:
            hDataQuery:REPOSITION-TO-ROWID(rRowObject).
            IF NOT hRowObject:AVAILABLE THEN
              hDataQuery:GET-NEXT().      /* To move onto the row itself. */
        END. /* END Not Browsed */
      END.   /* END DO IF IS-OPEN */
    END.     /* END No RowObject Available */         
    
    /* copyColumns is in  dataextcols */
    RUN copyColumns IN TARGET-PROCEDURE (pcViewColList, hDataQuery).
    

    RETURN {fnarg colValues pcViewColList}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createRow Procedure 
FUNCTION createRow RETURNS LOGICAL
  (pcValueList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Accepts a list of values for a new row to CREATE, returning FALSE
               if any errors occur. This is done only to the RowObject 
               Temp-Table; committing the changes back to the database is 
               a separate step, which will be invoked from here if AutoCommit 
               is set on.
 
  Parameters:
    INPUT pcValueList - CHR(1) delimited list of alternating column names 
                        and values to be assigned.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRowObjId AS CHAR NO-UNDO.
  DEFINE VARIABLE lOk       AS LOG    NO-UNDO.
  
  /* get the RowObject ROWID from the new row */ 
  cRowObjId = ENTRY(1,
                    DYNAMIC-FUNCTION("addRow":U IN TARGET-PROCEDURE,"":U),
                    CHR(1)). 
  
  lOk = DYNAMIC-FUNCTION("submitRow":U IN TARGET-PROCEDURE, 
                         cRowObjId, 
                         pcValueList).
  
  IF NOT lOk THEN  
    DYNAMIC-FUNCTION('cancelRow':U IN TARGET-PROCEDURE).  
  
  RETURN lOk.   
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createRowObjectTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createRowObjectTable Procedure 
FUNCTION createRowObjectTable RETURNS LOGICAL
  ():
/*------------------------------------------------------------------------------
  Purpose:   Creates the RowObjectTable for a dynamic SDO    
  Parameters:  <none>
  Notes:     It normally creates the RowObjectTable, but if there is an 
             unprepared RowObjectTable it will use this in support of the 
             external create required for non-persistent procedures that
             starts this object and need to output the TT.               
          -  The SchemaLocation decides where to get the field defintions from
             If the Repository Entity Cache is used hen all fields must exist 
             in it. The same of course applies to the buffer, while if 
             the DataLogicProcedure is used any missing field will also be 
             searched for in the buffer (in support of tables too big to define
             statically.    
------------------------------------------------------------------------------*/
   DEFINE VARIABLE hLogicObject        AS HANDLE     NO-UNDO.
   DEFINE VARIABLE hLogicBuffer        AS HANDLE     NO-UNDO.
   DEFINE VARIABLE hRowObjectTable     AS HANDLE     NO-UNDO.
   DEFINE VARIABLE cDataColumns        AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cDataColumnsByTable AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cAssignList         AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cPhysicalTables     AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cColumn             AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE hColumn             AS HANDLE     NO-UNDO.
   DEFINE VARIABLE iLoop               AS INTEGER    NO-UNDO.
   DEFINE VARIABLE cBufferHandles      AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cDBColumnName       AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE hRowObject          AS HANDLE     NO-UNDO.
   DEFINE VARIABLE cAsDivision         AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE lExternal           AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE lDbExtent           AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE lFieldAdded         AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE lReposOk            AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE cSchemaLocation     AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE lUseEntity          AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE lUseDLP             AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE lUseBuffer          AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE cInitial            AS CHARACTER  NO-UNDO.

   &SCOPED-DEFINE xp-assign
   {get IsRowObjectExternal lExternal}
   {get RowObject hRowObject}
   {get DataColumns cDataColumns}
   {get SchemaLocation cSchemaLocation}
   .
   &UNDEFINE xp-assign
   
   IF cDataColumns = '':U THEN
     RETURN FALSE.

   {get RowObjectTable hRowObjectTable}.   
   IF NOT lExternal THEN
   DO:
     DELETE OBJECT hRowObjectTable NO-ERROR.
     CREATE TEMP-TABLE hRowObjectTable.
   END.

   ASSIGN /* deal with all variations here, including the fact that Entities 
             only exists for repository */
     lUseBuffer = (cSchemaLocation = 'BUF':U)
     lUseDLP    = (NOT VALID-HANDLE(gshRepositoryManager) 
                   AND NOT (lUseBuffer = TRUE)
                   ) 
                   OR (cSchemaLocation = 'DLP':U)                    
     /* use entity in any case including unknown and blank, except DLP and 'BUF'  */
     lUseEntity = VALID-HANDLE(gshRepositoryManager) 
                  AND NOT (lUseDLP = TRUE) 
                  AND NOT (lUseBuffer = TRUE)
     .  

   /* If no repository or DLP explicitly specified as schema location
      the field definition will be copied from the logic object 
      NOTE (we may still use buffer for fields not in DLP)  
      The no-error is needed as this api does not exist if there is no 
      valid Data Logic Procdure */
   IF lUseDLP THEN
     RUN getLogicBuffer IN TARGET-PROCEDURE (OUTPUT hLogicBuffer) NO-ERROR.     
   
   DELETE OBJECT hRowObject NO-ERROR.
   
   IF lUseEntity THEN
   DO:
     &SCOPED-DEFINE xp-assign
     {get PhysicalTables cPhysicalTables}
     {get DataColumnsByTable cDataColumnsByTable}
     {get AssignList cAssignList}
     .
     &UNDEFINE xp-assign
     
     lReposOk = DYNAMIC-FUNCTION('prepareRowObjectColumns':U IN gshRepositoryManager,
                                  hRowObjectTable,
                                  cPhysicalTables, 
                                  cDataColumns,
                                  cDataColumnsByTable,
                                  cAssignList).
     IF NOT lReposOk THEN
       RETURN FALSE.    
   END.
   ELSE 
   DO:
     {get AsDivision cAsDivision}.
     DO iLoop = 1 TO NUM-ENTRIES(cDataColumns): 
       ASSIGN 
         cColumn     = ENTRY(iLoop,cDataColumns)
         hColumn     = ?.
       
       IF VALID-HANDLE(hLogicBuffer) THEN
         hColumn  = hLogicBuffer:BUFFER-FIELD(cColumn).
       
       /* Don't use ELSE as dynamic data objects may have more columns than 
          defined in the logic procedure */
       IF NOT VALID-HANDLE(hColumn) THEN
       DO:
         cDbColumnName = {fnarg columnDbColumn cColumn}.
         
         IF cDbColumnName > '':U AND cAsDivision <> 'CLIENT':U THEN
           hColumn = {fnarg dbColumnHandle cDbColumnName}.
         
         IF NOT VALID-HANDLE(hColumn) THEN
         DO:
           {get DataLogicObject hLogicObject}.

           MESSAGE 
             "Could not add column '"  cColumn  "' to the dataobject's temp-table."
           SKIP
           IF VALID-HANDLE(hLogicBuffer) THEN 
             " The column is not defined in DataLogicProcedure: " + hLogicObject:FILE-NAME
           ELSE ""
  
           IF cDbColumnName > '':U AND cAsDivision <> 'CLIENT':U THEN 
             "The physical name '" + cDBcolumnName + "' is not a valid reference." 
           ELSE /* createobjects protects against this */
             " Calculated columns require a running Data Logic Procedure."    
           .
  
           RETURN FALSE.
         END. /* no valid column (not found in db) */
       END. /* no valid column (not found in logic proc)*/ 
  
       ASSIGN
         hColumn:VALIDATE-EXPRESSION ='':U
         lDbExtent                   = (hColumn:EXTENT > 0)
         cInitial                    = hColumn:INITIAL
         NO-ERROR.
         
         /* Don't copy extents if we copy from a db field */ 
         /* Also, if there is an INITIAL value, we may need to apply */
         /* format adjustments according to the session settings */
         IF NOT lDbExtent AND cInitial = '':U THEN
           lFieldAdded = hRowObjectTable:ADD-LIKE-FIELD(cColumn,hColumn).
         ELSE
           lFieldAdded = hRowObjectTable:ADD-NEW-FIELD
                         (cColumn,
                          hColumn:DATA-TYPE,
                          0,   /* Extent  */
                          hcolumn:FORMAT,
                          (IF VALID-HANDLE(gshRepositoryManager) THEN
                             {fnarg entityDefaultValue hColumn gshRepositoryManager}
                           ELSE
                             hColumn:INITIAL),
                          hColumn:LABEL,
                          hColumn:COLUMN-LABEL).
     END. /* do iLoop thru DataColumns */ 
   END. /*  Else (non-repos) */
   
   hRowObjectTable:ADD-NEW-FIELD('RowNum':U,'INTEGER':U).
   hRowObjectTable:ADD-NEW-FIELD('RowIdent':U,'CHARACTER':U).
   hRowObjectTable:ADD-NEW-FIELD('RowMod':U,'CHARACTER':U).
   hRowObjectTable:ADD-NEW-FIELD('RowIdentIdx':U,'CHARACTER':U).
   hRowObjectTable:ADD-NEW-FIELD('RowUserProp':U,'CHARACTER':U).
   hRowObjectTable:ADD-NEW-INDEX('RowNum':U,NO,YES).
   hRowObjectTable:ADD-INDEX-FIELD('RowNum':U,'RowNum':U).
   hRowObjectTable:ADD-NEW-INDEX('RowMod':U,NO,NO).
   hRowObjectTable:ADD-INDEX-FIELD('RowMod':U,'RowMod':U).
   hRowObjectTable:ADD-NEW-INDEX('RowIdentIdx':U,NO,NO).
   hRowObjectTable:ADD-INDEX-FIELD('RowIdentIdx':U,'RowIdentIdx':U).
   
   hRowObjectTable:TEMP-TABLE-PREPARE('RowObject':U).
   
   {set RowObjectTable hRowObjectTable}.

   RETURN VALID-HANDLE(hRowObjectTable).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createRowObjUpdTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createRowObjUpdTable Procedure 
FUNCTION createRowObjUpdTable RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Creates the RowObjUpd table from the RowObject table. 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRowObjUpdTable  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFromBuffer      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObjUpd       AS HANDLE     NO-UNDO.
  define variable iFieldLoop       as integer    no-undo.
  define variable hEntityField     as handle     no-undo.
  define variable cInitial         as character  no-undo.
  
  {get RowObject hFromBuffer}.
  
  IF NOT VALID-HANDLE(hFromBuffer) THEN
    RETURN FALSE.

  {get RowObjUpd hRowObjUpd}.
  DELETE OBJECT hRowObjUpd NO-ERROR.

  CREATE TEMP-TABLE hRowObjUpdTable.

  DO iFieldLoop = 1 TO hFromBuffer:NUM-FIELDS:
      ASSIGN hEntityField = hFromBuffer:BUFFER-FIELD(iFieldLoop)
             cInitial     = hEntityField:INITIAL
             NO-ERROR.
      IF cInitial > "":U THEN
          hRowObjUpdTable:ADD-NEW-FIELD(hEntityField:NAME,
                                        hEntityField:DATA-TYPE,
                                        0,   /* Extent  */
                                        hEntityField:FORMAT,
                                        (IF VALID-HANDLE(gshRepositoryManager) THEN
                                            {fnarg entityDefaultValue hEntityField gshRepositoryManager}
                                         ELSE
                                             hEntityField:INITIAL),
                                        hEntityField:LABEL,
                                        hEntityField:COLUMN-LABEL).         
      ELSE
          hRowObjUpdTable:ADD-LIKE-FIELD(hEntityField:NAME, hEntityField).
  END.    /* loop through rowObject buffer fields. */

  hRowObjUpdTable:ADD-NEW-FIELD('Changedfields':U, 'CHARACTER':U).
  hRowObjUpdTable:ADD-NEW-INDEX('RowNum':U,NO,YES).
  hRowObjUpdTable:ADD-INDEX-FIELD('RowNum':U,'RowNum':U).
  hRowObjUpdTable:ADD-NEW-INDEX('RowMod':U,NO,NO).
  hRowObjUpdTable:ADD-INDEX-FIELD('RowMod':U,'RowMod':U).
  hRowObjUpdTable:ADD-NEW-INDEX('RowIdentIdx':U,NO,NO).
  hRowObjUpdTable:ADD-INDEX-FIELD('RowIdentIdx':U,'RowIdentIdx':U).

  hRowObjUpdTable:TEMP-TABLE-PREPARE('RowObjUpd':U).

  {set RowObjUpdTable hRowObjUpdTable}.
  
  RETURN TRUE.  
END FUNCTION.    /* createRowObjUpdTable */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataContainerHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION dataContainerHandle Procedure 
FUNCTION dataContainerHandle RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: The DataContainer handle is an appserver aware container that can 
           handle data requests and also is the container of this object. 
           This can be a standard container or an sbo. This function also 
           encapsulates the required checks of this object's AppServer properties
           and only returns the handle if the current or permanent state allows 
           it to be part of a stateless request handled by another object. 
    Notes: The DataContainer role and client container may be in separate 
           objects in the future.      
         - Currently duplicated in sbo.p.  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cASDivision      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hSource          AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cObjectName      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lDataContainer   AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE lSBO             AS LOGICAL    NO-UNDO.

 {get ContainerSource hSource}.
 IF VALID-HANDLE(hSource) THEN
 DO:
   
   /* The DataContainer flag identifies an Appserver Container */
   &SCOPED-DEFINE xp-assign
   {get DataContainer lDataContainer hSource}
   {get QueryObject   lSBO hSource}
   . 
   &UNDEFINE xp-assign
   
   IF lDataContainer AND NOT lSBO THEN
   DO:
     /* Check AppServer properties to see if the object has no current or future 
        server bindings and is using a stateless operating mode.*/    
     IF {fn hasNoServerBinding} THEN
       RETURN hSource.
   END.
   /* An SBO has AsDivision = 'client'. If the SDO is inside an SBO its data 
      requests are always managed by the SBO, so the Appserver properties do 
      not need to be checked and may not even apply */
   ELSE DO: 
     {get ASDivision cASDivision hSource} NO-ERROR.
     IF (cASDivision = 'Client':U) THEN 
       RETURN hSource.
   END.
 END.
 
 RETURN ?. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataQueryStringFromQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION dataQueryStringFromQuery Procedure 
FUNCTION dataQueryStringFromQuery RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns a new DataQueryString (RowObject) from the current 
           QueryString (Tables)
    Notes: Only expressions added with assignQuerySelection is extracted
           from the QueryString.            
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDataColumns     AS CHAR      NO-UNDO.
  DEFINE VARIABLE iColumn          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cDataTable       AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cDataQueryString AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cColumn          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cSelection       AS CHAR      NO-UNDO.
  DEFINE VARIABLE iValue           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cValue           AS CHARACTER NO-UNDO.  
  DEFINE VARIABLE cOperator        AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE cColumnList      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cValueList       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cOperatorList    AS CHARACTER NO-UNDO.

  {get DataColumns cDataColumns}.
  {get DataTable cDataTable}.
  
  /* would be faster to use QueryColumns directly, but this is simpler */
  do iColumn = 1 to NUM-ENTRIES(cDataColumns):
    assign
      cColumn    = entry(iColumn,cDataColumns)
      cSelection = {fnarg columnQuerySelection cColumn}.    
    IF cSelection <> "":U THEN
    DO iValue = 1 TO NUM-ENTRIES(cSelection,CHR(1)) BY 2:
      ASSIGN
        cOperator   = ENTRY(iValue,cSelection,CHR(1))
        cValue      = ENTRY(iValue + 1,cSelection,CHR(1))      
        cColumnList = cColumnList + ",":U + cColumn
        cValueList  = cValueList + CHR(1) + cValue
        cOperatorList = cOperatorList + "," + cOperator.
    END. /* selection <> '' */
  END. /* do ibuffer = 1 to num-entries */ 
  /* don't use trim on cValues - could have blank */
  assign cColumnList   = substr(cColumnList,2)
         cValueList    = substr(cValueList,2)
         cOperatorList = substr(cOperatorList,2).
   
  cDataQueryString = "FOR EACH ":U + cDataTable.
  IF cColumnList > "":U THEN
    cDataQueryString = cDataQueryString 
                     + " WHERE ":U
                     +  DYNAMIC-FUNCTION('newDataQueryExpression':U IN TARGET-PROCEDURE,
                                         cColumnList,
                                         cValueList,
                                         cOperatorList).
  RETURN cDataQueryString.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-defineTempTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION defineTempTables Procedure 
FUNCTION defineTempTables RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Define temp tables for a dynamic dataobject 
           Returns true if a RowObjectTable is valid on exit.
           I.e it was created here or the TT is static.   
    Notes: Called from createObjects.     
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRowObjectTable      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDefs                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lIsRowObjectExternal AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lUseRepository       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cAsDivision          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hRowObject           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cColumns             AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get DataFieldDefs cDefs}    
  {get AsDivision cAsDivision}
  .
  &UNDEFINE xp-assign
  IF cDefs = '':U THEN  
  DO:
    {fnarg emptyRowObject '':U}.
    {fn createRowObjectTable}. 

  END.
  ELSE IF {fn getUseRepository} THEN
    {fn prepareColumnsFromRepos}.
  


  {get RowObjectTable hRowObjectTable}.
  RETURN VALID-HANDLE(hRowObjectTable).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION deleteRow Procedure 
FUNCTION deleteRow RETURNS LOGICAL
  ( pcRowIdent AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Submits a row for deletion. Returns FALSE if an error occurs. 
  Parameters:  INPUT pcRowIdent - RowId of the RowObject temp-table to delete.
                                  (Usually from the visual object's RowIdent 
                                   or refined by the SBO's deleteRow)    
                                - Unknown means delete current.
  Notes:       If auto-commit is on, the row will immediately be sent back 
               to the db for deletion.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMessages      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cQueryPos      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hRowObject     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowNum        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowObjUpd     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowUpdField   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hUpdRowMod     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hDataQuery     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iCol           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iValue         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lAutoCommit    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lBrowsed       AS LOGICAL   NO-UNDO.  
  DEFINE VARIABLE lNextNeeded    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lSuccess       AS LOGICAL   NO-UNDO INIT yes.
  DEFINE VARIABLE rDataQuery     AS ROWID     NO-UNDO.
  DEFINE VARIABLE rRowAfter      AS ROWID     NO-UNDO.
  DEFINE VARIABLE lUpdFromSource AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lRepos         AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cMsg           AS CHAR      NO-UNDO.
  DEFINE VARIABLE lNewDeleted    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cFirstResult   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLastResult    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iFirstResult   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLastResult    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hRowIdent      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContainer     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lQueryContainer AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hRowObjUpd2     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cRowObjectState AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lFirstDeleted   AS LOGICAL    NO-UNDO.
  
  &SCOPED-DEFINE xp-assign    
  {get RowObject hRowObject}
  {get RowObjUpd hRowObjUpd}
  {get DataHandle hDataQuery}
  {get DataQueryBrowsed lBrowsed}
  .
  &UNDEFINE xp-assign
       
  /* Extract the RowObject ROWID from the RowIdent passed. If it's
     a valid ROWID and found in the Temp-Table, delete that row.
     If that entry isn't defined, then we're doing a delete for
     a query this object isn't managing. Create a RowObjUpd record
     for it (no data needed, just the RowIdent field) and delete it. */

  /* This includes ? which means delete current from 9.1B */
  IF ENTRY(1, pcRowIdent) NE "":U THEN
  DO TRANSACTION:
    IF pcRowIdent <> ? THEN
    DO: 
      rDataQuery = TO-ROWID(ENTRY(1, pcRowIdent)) NO-ERROR.
      IF NOT hRowObject:AVAILABLE OR hRowObject:ROWID <> rDataQuery THEN
      DO:
        hRowObject:BUFFER-RELEASE.
        lRepos = hDataQuery:REPOSITION-TO-ROWID(rDataQuery).
        
        IF lRepos = FALSE THEN
        DO:
          cMSg = string(29) + "," 
                 + 'RowObject' + "," + 'ROWID ' + pcRowident + ''.
          {fnarg showMessage cMsg}.
          RETURN FALSE.
        END.
      END.

      /* If a Viewer is handling the delete, then we must Next on the query
         to make the row available. If the query's being browsed this is 
         implicit */    
      IF NOT hRowObject:AVAILABLE AND lRepos THEN
        hDataQuery:GET-NEXT(). 
      
      /* We need to try to find a RowObjUpd record for this row before 
         creating a new one.  findRowObjUpd takes the RowObject and RowObjUpd
         buffers and returns RowObjUpd buffer. */

    END. /* pcRowIdent <> ?  */
    
    /* We postpone RowObjUpd table creation for dynamic SDOs until really needed, 
       which will be now... */ 
    IF NOT VALID-HANDLE(hRowObjUpd) THEN
    DO:
      {fn createRowObjUpdTable}.
      {get RowObjUpd hRowObjUpd}.
    END.

    DYNAMIC-FUNCTION('findRowObjUpd':U IN TARGET-PROCEDURE,
                      hRowObject, 
                      hRowObjUpd).

    IF NOT hRowObjUpd:AVAILABLE THEN 
    DO:
      /* Copy the record to the Update table to be able to restore it 
         if UNDOne. */
      hRowObjUpd:BUFFER-CREATE().
      hRowObjUpd:BUFFER-COPY(hRowObject).
    END.  /* if RowObjUpd not avail */
    
    hUpdRowMod = hRowObjUpd:BUFFER-FIELD('RowMod':U).

    /* If we deleted a new record then just get rid of the rowobjupd */
    IF CAN-DO('A,C':U,hUpdRowMod:BUFFER-VALUE) THEN
    DO:
      hRowObjUpd:BUFFER-DELETE().  
      lNewDeleted = TRUE.
    END.
    ELSE 
      hUpdRowMod:BUFFER-VALUE = "D":U.
  END.   /* END DO IF ENTRY(1) */
  ELSE DO:
    /* We postpone RowObjUpd table creation for dynamic SDOs until really needed, 
       which will be now... */ 
    IF NOT VALID-HANDLE(hRowObjUpd) THEN
    DO:
      {fn createRowObjUpdTable}.
      {get RowObjUpd hRowObjUpd}.
    END.
    
    /* We need to try to find a RowObjUpd record for this row before 
       creating a new one.  findRowObjUpd takes the RowObject and RowObjUpd
       buffers and returns RowObjUpd buffer. */    
    
    DYNAMIC-FUNCTION('findRowObjUpd':U IN TARGET-PROCEDURE,
                      hRowObject, hRowObjUpd).

    IF hRowObjUpd:AVAILABLE THEN 
    DO:
      hUpdRowMod = hRowObjUpd:BUFFER-FIELD('RowMod':U).

      /* If we deleted a new record then just get rid of the rowobjupd */
      IF CAN-DO('A,C':U,hUpdRowMod:BUFFER-VALUE) THEN
      DO:
        hRowObjUpd:BUFFER-DELETE(). 
        lNewDeleted = TRUE.
      END.
      ELSE 
        hUpdRowMod:BUFFER-VALUE = "D":U.
    END.
    ELSE DO:
        /* IF first entry in RowIdent is blank, use the rest to create
           a row to delete on behalf of a query managed elsewhere. */
      hRowObjUpd:BUFFER-CREATE().
      ASSIGN hRowUpdField = hRowObjUpd:BUFFER-FIELD('RowIdent':U)
             hRowUpdField:BUFFER-VALUE =
                            SUBSTR(pcRowIdent,INDEX(pcRowIdent, ",":U) + 1)
             hRowUpdField = hRowObjUpd:BUFFER-FIELD('RowIdentIdx':U)
             hRowUpdField:BUFFER-VALUE =
                            SUBSTR(SUBSTR(pcRowIdent,INDEX(pcRowIdent, ",":U) + 1), 1, xiRocketIndexLimit)
             hRowUpdField = hRowObjUpd:BUFFER-FIELD('RowMod':U)
             hRowUpdField:BUFFER-VALUE = "D":U.
      /* Make sure we do a Next (in the db query) following the delete,
         if there's no RowObject record. */
    END.  /* Else do - if RowObjUpd not avail */
  END.     /* END DO IF no ENTRY(1) */

  {get AutoCommit lAutoCommit}.
  
  IF lAutoCommit THEN 
  DO:  /* Go ahead with the DB transaction now. */
    RUN commitTransaction IN TARGET-PROCEDURE.
    lSuccess = RETURN-VALUE NE "ADM-ERROR":U.
    /* If there were no errors, delete the RowObject copy of the row. */
  END.  /* END DO IF AutoCommit */
  
  /* If we returned successfully from the Delete, or we have a Commit Panel
     so the delete has been done only locally for now, delete the RowObject. */
  IF (NOT lAutoCommit) OR lSuccess THEN
  DO:
    {get QueryPosition cQueryPos}.  /* Were we on the first/last record? */
    
    IF ENTRY(1, pcRowIdent) NE "":U THEN
    /* if the object has its own query, there's no temp-table rec to delete.*/
    DO:      
      IF NOT hRowObject:AVAILABLE THEN
      DO:
        hDataQuery:REPOSITION-TO-ROWID(rDataQuery).
        /* It's available already if repositioned in a browse */
        IF NOT hRowObject:AVAILABLE THEN
          hDataQuery:GET-NEXT.        
      END.
      
      /* If browsed we check whether the next record will be available 
         after deleteComplete. (implicit delete-current-row) */
      IF lBrowsed THEN 
      DO:
        hDataQuery:GET-NEXT.      
        lNextNeeded = hDataQuery:QUERY-OFF-END. 
        /* Back to Current */
        hDataQuery:GET-PREV.
      END.
      ELSE lNextNeeded = TRUE.
      
      &SCOPED-DEFINE xp-assign
      {get LastResultRow cLastResult}
      {get FirstResultRow cFirstResult}
      .
      &UNDEFINE xp-assign
      
      ASSIGN
        hRowIdent = hRowObject:BUFFER-FIELD('RowIdent':U)      
        hRowNum = hRowObject:BUFFER-FIELD('RowNum':U)      
        iFirstResult = INTEGER(ENTRY(1,cFirstResult,';':U))
        iLastResult  = INTEGER(ENTRY(1,cLastResult,';':U)).

      /* Set to unknown as signal to set new values after the delete */
      IF iFirstResult = hRowNum:BUFFER-VALUE THEN
        cFirstResult = ?.
      IF iLastResult = hRowNum:BUFFER-VALUE THEN
        cLastResult = ?.     
      
      hRowObject:BUFFER-DELETE().

    END.  /* END DO IF pcRowIdent */
    
    /* This will result in a delete-current-row in the browser */
    PUBLISH 'deleteComplete':U FROM TARGET-PROCEDURE. /* Tell Browser, e.g */
    
    /* We deleted the first of the batch */
    IF cFirstResult = ? THEN
    DO:
      IF NOT hRowObject:AVAIL THEN
        hDataQuery:GET-FIRST.
      /* This must now be the first record, unless it is new */
      IF hRowObject:AVAIL AND hRowIdent:BUFFER-VALUE > '':U THEN
      DO:
        lFirstDeleted = true.  
        cFirstResult = hRowNum:BUFFER-VALUE + ';':U + hRowIdent:BUFFER-VALUE.
        {set FirstResultRow cFirstResult}.
      END.
    END.

    IF cLastResult = ? THEN
    DO:
      /* If we deleted the last (including a new which is last of the batch )
         position to the prev */    
      IF NOT hRowObject:AVAIL THEN
        hDataQuery:GET-PREV.
      /* This must be the last record of the current batch, unless it is new */      
      IF hRowObject:AVAIL AND hRowIdent:BUFFER-VALUE > '':U THEN
      DO:
        cLastResult = hRowNum:BUFFER-VALUE + ';':U + hRowIdent:BUFFER-VALUE.
        {set LastResultRow cLastResult}.
      END.
    END.
    
    /* if new deleted then it may not yet be in the browse and thus not
       become available on the deletecomplete */      
    IF lNewDeleted AND NOT hRowObject:AVAILABLE THEN
       hDataQuery:GET-NEXT.
    
    IF NOT hRowObject:AVAIL THEN
      hDataQuery:GET-PREV.

    /* If we deleted the first then this must now be the first record */
    IF hRowObject:AVAIL THEN
    DO:
      IF cQueryPos = 'FirstRecord':U THEN
        {set FirstRowNum hRowNum:BUFFER-VALUE}.        
       /* If we deleted the last then this must now be the last record */
      IF cQueryPos = 'LastRecord':U THEN
        {set LastRowNum hRowNum:BUFFER-VALUE}.              
    END.
    /* Last record deleted */
    ELSE DO:

      &SCOPED-DEFINE xp-assign
      {set FirstRowNum 0}        
      {set LastRowNum 0}
      .
      &UNDEFINE xp-assign
      
    END.

    /* if we are deleted as part of a one-to-one delete there's no need to try 
       to keep track of where we are since the parent will need to change anyway*/  
    {get UpdateFromSource lUpdFromSource}.
    IF NOT lUpdFromSource THEN
    DO:
      /* If there is a Commit-Source, signal that a row has been changed. */
      IF NOT lAutoCommit THEN 
      DO:           
        /* Don't bother if we're in a AutoCommit SBO (IZ 10746)*/
        {get QueryContainer lQueryContainer}.  
        IF lQueryContainer THEN 
        DO:
          {get ContainerSource hContainer}.
          {get AutoCommit lAutoCommit hContainer}.
        END.
        IF NOT lAutoCommit THEN
        DO:
          cRowObjectState = 'RowUpdated':U.
          IF lNewDeleted THEN
          DO:
            /* If the new deleted was the only uncommitted change then
               set RowObjectState to 'NoUpdates' */
            CREATE BUFFER hRowObjUpd2 FOR TABLE hRowObjUpd.
            hRowObjUpd2:FIND-FIRST() NO-ERROR.
            IF NOT hROwObjUpd2:AVAIL THEN 
               cRowObjectState = 'NoUpdates':U.
            DELETE OBJECT hRowObjUpd2.
          END.
          PUBLISH "updateState":U FROM TARGET-PROCEDURE('delete':U).
          {set RowObjectState cRowObjectState}.
          lNextNeeded = FALSE. /* we don't need another batch (IZ 10746) */
        END.
      END.
    
      /* NextNeeded = false if the browse 'autopositioned', also if we deleted 
         the first, only or last record don't try to fetch another batch. */
      IF lNextNeeded 
      AND {fnarg rowAvailable 'NEXT':U} 
      AND NOT lFirstDeleted
      AND NOT lNewDeleted THEN
        RUN fetchNext IN TARGET-PROCEDURE.
      ELSE 
      DO:    
         RUN updateQueryPosition IN TARGET-PROCEDURE.
         PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE ('different':U).   
        {set NewBatchInfo '':U}.
      END.
    END. /* not lUpdFromSource */ 
  END.  /* END DO IF NOT AutoCommit OR Success from Commit */
  else  
     /* In the event of a failed delete, doreturnUpd has deleted the
        Update temp-table row, but copied server changes if the 
        error was due to an optimistic lock conflict */
    PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE ('same':U).   
  /* Return false if there were any error messages returned. */
  RETURN lSuccess.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-emptyRowObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION emptyRowObject Procedure 
FUNCTION emptyRowObject RETURNS LOGICAL
  (pcMode AS CHAR):
/*------------------------------------------------------------------------------
   Purpose: empty the RowObject temp-table
Parameters: pcMode                
             reset - reset batch properties 
                           
     Notes:  This is for internal use, ROwObject and DataQuery properties 
             must be defined.   
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hDataQuery AS HANDLE  NO-UNDO.
 DEFINE VARIABLE hRowObject AS HANDLE  NO-UNDO.
 DEFINE VARIABLE lOpen      AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cTargets   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iVar       AS INTEGER    NO-UNDO.
 DEFINE VARIABLE hSDO       AS HANDLE     NO-UNDO.
 DEFINE VARIABLE lOneToOne  AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE hTable     AS HANDLE     NO-UNDO.

 {get RowObject hRowObject}.
 
 IF VALID-HANDLE(hRowObject) AND TRANSACTION THEN
 DO:
   {get DataHandle hDataQuery}.        
   IF VALID-HANDLE(hDataQuery) THEN
   DO:
     lOpen = hDataQuery:IS-OPEN.   
     IF NOT lopen THEN
       hDataQuery:QUERY-OPEN.
   
     hDataQuery:GET-FIRST().  
     DO WHILE hRowObject:AVAILABLE:
       hRowObject:BUFFER-DELETE.
       /* get next query is ok even if the record is deleted  */ 
       hDataQuery:GET-NEXT(). 
     END.
     /* Ensure that the query is closed  */
     IF hDataQuery:IS-OPEN THEN
       hDataQuery:QUERY-CLOSE.
   END.
 END.
 ELSE IF VALID-HANDLE(hRowObject) THEN
 DO:
   /* Check if valid (shared data does not store the handle) */
   {get RowObjectTable hTable}.
   IF VALID-HANDLE(hTable) THEN
      hRowObject:EMPTY-TEMP-TABLE.
 END.

 /* Reset batch properties */
 IF pcMode = 'reset':U THEN
 DO:
   &SCOPED-DEFINE xp-assign
   {set FirstRowNum ?}
   {set LastRowNum ?}
   {set FirstResultRow ?}
   {set LastResultRow ?}
   .
   &UNDEFINE xp-assign
 END.

 /* Now empty the RowObject TT in all 1-to-1 SDO targets */
 {get DataTarget cTargets}.
 DO iVar = 1 TO NUM-ENTRIES(cTargets):
   hSDO = WIDGET-HANDLE(ENTRY(iVar, cTargets)).
   lOneToOne = DYNAMIC-FUNCTION("getUpdateFromSource":U IN hSDO) NO-ERROR.
   IF lOneToOne THEN
     {fnarg emptyRowObject 'reset':U hSDO}.
 END.

 RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fetchRow Procedure 
FUNCTION fetchRow RETURNS CHARACTER
  (piRow AS INTEGER, pcViewColList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Repositions the Row Object's query to the desired row (indicated
               by piRow) and returns that row's values (as specified in 
               pcViewColList).  The return value is CHR(1) delimited list of
               values (formatted according to each columns FORMAT expression.)
               The first value in the list is the RowIdent of the fetched row.
 
  Parameters:
    INPUT piRow         - desired row number within the result set
    INPUT pcViewColList - comma-separated list of names of columns to be 
                          returned.
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE iRowNum    AS INTEGER NO-UNDO INIT ?.
  DEFINE VARIABLE rRowId     AS ROWID   NO-UNDO.
  DEFINE VARIABLE hDataQuery AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowNum    AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowQuery  AS HANDLE  NO-UNDO.
  DEFINE VARIABLE iRow       AS INTEGER NO-UNDO.
  DEFINE VARIABLE lOK        AS LOGICAL NO-UNDO.
  DEFINE VARIABLE cRow       AS CHAR    NO-UNDO INIT ?.
  DEFINE VARIABLE lBrowsed   AS LOGICAL NO-UNDO.
  
    &SCOPED-DEFINE xp-assign
    {get DataQueryBrowsed lBrowsed}   
    {get DataHandle hDataQuery}
     .
    &UNDEFINE xp-assign
    
    IF NOT hDataQuery:IS-OPEN THEN hDataQuery:QUERY-OPEN().
    
    hRowObject = hDataQuery:GET-BUFFER-HANDLE(1).
       
    IF hRowObject:AVAILABLE THEN
      ASSIGN hRowNum    = hRowObject:BUFFER-FIELD('RowNum':U)
             iRowNum    = hRowNum:BUFFER-VALUE.  /* Save off for comparison.*/
    CREATE QUERY hRowQuery.     /* Get a query to do the "FIND" */
    lOK = hRowQuery:SET-BUFFERS(hRowObject).
    IF lOK THEN
      lOK = hRowQuery:QUERY-PREPARE
         ('FOR EACH RowObject WHERE RowObject.RowNum = ':U + STRING(piRow)).
    IF lOK THEN lOK = hRowQuery:QUERY-OPEN().
    IF lOK THEN lOK = hRowQuery:GET-FIRST().
    IF hRowObject:AVAILABLE THEN
    DO:
        rRowId = hRowObject:ROWID.
        lOK = hDataQuery:REPOSITION-TO-ROWID(rRowId).
        IF lOK AND (NOT lBrowsed) THEN hDataQuery:GET-NEXT().
        IF lOK THEN
        DO:
          IF VALID-HANDLE(hRowNum) THEN
          DO:  /* If we were previously positioned on some actual record... */
            {get LastRowNum iRow}.
            IF iRow = hRowNum:BUFFER-VALUE THEN  
              {set QueryPosition 'LastRecord':U}.
            ELSE IF hRowNum:BUFFER-VALUE = 1 THEN
              {set QueryPosition 'FirstRecord':U}.
            ELSE IF iRowNum = 1 OR iRowNum = iRow THEN
              {set QueryPosition 'NotFirstOrLast':U}.
          END.   /* END DO IF VALID-HANDLE */
          /* Signal row change in any case. */
          PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE ("DIFFERENT":U).
          {set NewBatchInfo '':U}.
          /* This will return ? if not AVAILABLE. */
          cRow = {fnarg colValues pcViewColList}.
        END.     /* END DO IF lOK */
    END. /* if hRowObject:availabel */
    DELETE WIDGET hRowQuery.

    RETURN cRow. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchRowIdent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fetchRowIdent Procedure 
FUNCTION fetchRowIdent RETURNS CHARACTER
  (pcRowIdent AS CHARACTER, pcViewColList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Repositions the RowObject's query to the desired row, based on
            the corresponding database record rowid(s) (specified by 
            pcRowIdent), and returns that row's values (as specified in 
            pcViewColList).  The return value is CHR(1) delimited list of
            values (formatted according to each columns FORMAT expression.)
            The first value in the list is the RowIdent of the fetched row.
            If that row is not in the RowObject table, it repositions the 
            database query to that row and resets the RowObject table.
 
  Parameters:
    INPUT pcRowIdent    - desired rowid(s) within the result set, expressed 
                          as a comma-separated list of db rowids;
    INPUT pcViewColList - comma-separated list of names of columns to be 
                          returned.
                          
       Note: If called with unknown or non-existing rowid the query is closed
             and the SDO will be in a bad state.(fetchNext and -Prev don't work) 
             The application need to call fetchRowident with a valid value 
             or fetchFirst, fetchLast or openQuery to get back to normal.                    
------------------------------------------------------------------------------*/ 
  DEFINE VARIABLE lOnClient        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lFromServer      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cRows            AS CHARACTER  NO-UNDO INIT ?.
  DEFINE VARIABLE hDataReadHandler AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cAsDivision      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lQueryOpen       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lBrowsed         AS LOGICAL    NO-UNDO.
  
  {get AsDivision cAsDivision}.
  {get QueryOpen lQueryOpen}.


 /* We do not support calling this on server before the query is opened 
   (This is to protect the client against bad batch properties, since 
    this call opens the query and obtainContextforCclient will return
    data properties) */ 
  IF cAsDivision = 'SERVER':U AND NOT lQueryOpen THEN
    RETURN ?.

  IF cAsDivision = 'CLIENT':U AND NOT lQueryOpen THEN
    {fn initializeFromCache}.

  lOnClient = {fnarg findRowObjectUseRowident pcRowident}.
  
  IF NOT lOnClient THEN
    lFromServer = {fnarg fetchRowWhere pcRowident}.
  ELSE DO:
     /* ensure browse gets notified also when record is found on client 
        in case it need to fill the viewport (fetchRowWhere ) 
        (fetchRowWhere does this if not onclient) */
    {get DataQueryBrowsed lBrowsed}.
    IF lBrowsed THEN
      PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('BatchEnd':U).
  END.

  IF lOnCLient OR lFromServer THEN
  DO:
    cRows = {fnarg colValues pcViewColList}.
    RUN updateQueryPosition IN TARGET-PROCEDURE.       
    {get DataReadHandler hDataReadHandler}.
    IF NOT VALID-HANDLE(hDataReadHandler) THEN
    DO:
      PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE("DIFFERENT":U). 
      {set NewBatchInfo '':U}.
    END.
  END.

  RETURN cRows. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchRowWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fetchRowWhere Procedure 
FUNCTION fetchRowWhere RETURNS LOGICAL
  ( pcQueryString AS CHAR ) :
/*------------------------------------------------------------------------------
   Purpose: fetch or append rows positioned according to input query data. 
Parameters: pcQueryData 
              - A complete database query string. 
              - Rowident - semi colon separated list of rowids for each table. 
     Notes: This is the wrapper for the call to the server and should be called 
            from code that first checks if the record is on the client.            
          - Used by fetchRowident, findRowWhere and refreshQuery 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRowObjectState  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lRebuild         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iRowsToBatch     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iRowsReturned    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lBrowsed         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lFillBatch       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cSpecial         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAsDivision      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataReadHandler AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cRowIdent        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hRowObject       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataQuery       AS HANDLE     NO-UNDO.
 
  IF pcQueryString = "":U THEN
    RETURN FALSE.

  {get RowObjectState cRowObjectState}.
  IF cRowObjectState = 'RowUpdated':U THEN 
  DO:
    RUN showMessageProcedure IN TARGET-PROCEDURE 
       (INPUT "16":U, OUTPUT glShowMessageAnswer).    
    RETURN FALSE.
  END.   

  &SCOPED-DEFINE xp-assign
  {get RebuildOnRepos lRebuild}
  {get RowObject hRowObject}
  /* Determines if this SDO is being browsed by a SmartDataBrowser */
  {get DataQueryBrowsed lBrowsed}
  .  
  &UNDEFINE xp-assign

  /* We log rowident since the TTs may be recreated (could have used rowid when 
    not rebuild...) */
  cRowident = hRowObject:BUFFER-FIELD('Rowident':U):BUFFER-VALUE NO-ERROR.
  
  
  /* Set browser refreshable = false */
  IF lBrowsed THEN
    PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('BatchStart':U).

   /* If RebuildOnReposition, flush out the current set of RowObject records 
     and reset the associated flags. */
  IF lRebuild THEN 
    {fnarg emptyRowObject '':U}. 
  {get RebuildOnRepos lRebuild}.
  /* We use special signals appended to the passed query to tell whether this 
     is an appending search or a rebuild with fillbatch.  */
  IF NOT lRebuild THEN
    cSpecial = "+":U.
  ELSE IF lBrowsed THEN
  DO: 
    {get fillBatchOnRepos lFillBatch}.
    /* append '-' to indicate go back from found position to fill batch, 
       (almost makes sense ..) */ 
    IF lFillbatch THEN 
      cSpecial = "-":U. 
  END.

  {get RowsTobatch iRowsToBatch}.

  RUN sendRows IN TARGET-PROCEDURE 
            (?,    /* RowNum is only for refresh  */
             pcQueryString + cSpecial, 
             FALSE,  
             iRowsToBatch, 
             OUTPUT iRowsReturned).
  IF iRowsReturned = 0 AND NOT lRebuild THEN
  DO:
    {get DataHandle hDataQuery}.
    hDataQuery:QUERY-OPEN.
    
    /* We could have used rowid directly when not Rebuild 
      (If we logged it above that is) */      
    IF cRowIdent > '':U THEN
      {fnarg findRowObjectUseRowident cRowident}.
    
    iRowsReturned = 0.
  END.
  ELSE IF VALID-HANDLE(hRowObject) AND NOT hRowObject:AVAIL THEN
  DO:
    IF cRowIdent > '':U THEN
      {fnarg findRowObjectUseRowident cRowident}.
    iRowsReturned = 0.
  END.
  
  IF lBrowsed THEN
    PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('BatchEnd':U).

  RETURN iRowsReturned > 0.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findRowFromObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findRowFromObject Procedure 
FUNCTION findRowFromObject RETURNS LOGICAL
  ( pcColumns AS CHAR,
    pcValColumns AS CHAR,
    phObject AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose: Find a row using values from another object 
    Notes: Used server side to position lookup datasource  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValues AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAvail  AS LOGICAL    NO-UNDO.
  cValues = {fnarg colValues pcValColumns phObject}.

  ENTRY(1,cValues,CHR(1)) = '':U.  
  cValues = LEFT-TRIM(cValues,CHR(1)).

  IF cValues <> ? THEN
    lAvail = DYNAMIC-FUNCTION ('findRowWhere':U IN TARGET-PROCEDURE,
                              pcColumns,
                              cValues,
                              '':U). 
  /* Make a record avail, so that something get returned to client..
     Main reason being that this is used for combos.., 
     This logic may be changed to look at RowsTobatch or similar props to 
     figure out the need to return data 
     (f. ex. If RowsToBatch = 0 always return the data..) */  
  IF NOT lAvail THEN
    RUN fetchFirst IN TARGET-PROCEDURE.

  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findRowObjectUseRowIdent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findRowObjectUseRowIdent Procedure 
FUNCTION findRowObjectUseRowIdent RETURNS LOGICAL
  ( pcRowident AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  Repositions the RowObject's query to the desired row, based on
            the corresponding database record rowid(s) (specified by 
            pcRowIdent),            
            If that row is found in the RowObject table, it repositions the 
            RowObject query to that row.
 
  Parameters:
    INPUT pcRowIdent    - desired rowid(s) within the result set, expressed 
                          as a comma-separated list of db rowids;
    Notes:  operates on RowObject only and does not publish the change 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRowObject  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataQuery  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowQuery   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE rRowid      AS ROWID      NO-UNDO.
  DEFINE VARIABLE lOk         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE rCurrent    AS ROWID      NO-UNDO.

  {get DataHandle hDataQuery}.
  {get RowObject hRowObject}.
  IF NOT VALID-HANDLE(hRowObject) OR NOT VALID-HANDLE(hDataQuery) THEN
    RETURN FALSE.
  
  rCurrent = hRowObject:ROWID.

  CREATE QUERY hRowQuery.     /* Get a query to do the "FIND" */
  hRowQuery:SET-BUFFERS(hRowObject).
  /* Note that the where clause uses 'BEGINS' on Rowident because the caller
     may have specified a partial RowIdent (first table of a join). 
     (The RowidentIdx of course has to use BEGINS. It is the indexed version
     of the RowidentIdx */  
  hRowQuery:QUERY-PREPARE
          (
           'FOR EACH ':U + hRowObject:NAME + ' WHERE RowIdentIdx BEGINS "':U 
           + 
           SUBSTR(pcRowIdent, 1, xiRocketIndexLimit) 
           + 
           '" AND ':U 
           + 
           'RowIdent BEGINS "':U 
           + 
           pcRowIdent 
           + 
           '"':U
          ).

  hRowQuery:QUERY-OPEN().
  hRowQuery:GET-FIRST().   
  rRowId = hRowObject:ROWID.

  IF rRowid <> ? THEN 
  DO:
    lOk = hDataQuery:REPOSITION-TO-ROWID(rRowid).
    IF lOK AND (NOT hRowObject:AVAILABLE) THEN 
      hDataQuery:GET-NEXT().
  END.
  ELSE IF rCurrent <> ? THEN 
    hRowObject:FIND-BY-ROWID(rCurrent) NO-ERROR.
  
  DELETE OBJECT hRowQuery.

  RETURN lOk. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findRowObjectWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findRowObjectWhere Procedure 
FUNCTION findRowObjectWhere RETURNS LOGICAL
  (pcColumns     AS CHARACTER,   
   pcValues      AS CHARACTER,    
   pcOperators   AS CHARACTER,
   pcMode        AS CHARACTER):
/*------------------------------------------------------------------------------   
     Purpose: Find a record in the current Rowobject table
  Parameters: 
       pcColumns   - Column names (Comma separated)                    
                     Fieldname of a table in the query in the form of 
                     TBL.FLDNM or DB.TBL.FLDNM (only if qualified with db is specified),
                     (RowObject.FLDNM should be used for SDO's)  
                     If the fieldname isn't qualified it checks the tables in 
                     the TABLES property and assumes the first with a match.

       pcValues    - corresponding Values (CHR(1) separated)
       pcOperators - Operator - one for all columns
                                - blank - defaults to (EQ)  
                                - Use slash to define alternative string operator
                                  EQ/BEGINS etc..
                              - comma separated for each column/value
       pcMode       - FIRST
                    - LAST  (reserved for future, not yet supported)      
     Notes: Returns ? if batching properties combined with seach criteria
            cannot be resolved on the client                     
---------------------------------------------------------------------------*/
 DEFINE VARIABLE iColumn        AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cColumn        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cOperator      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cValue         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cWhere         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cQueryString   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lOk            AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE hRowQuery      AS HANDLE     NO-UNDO.
 DEFINE VARIABLE lBrowsed       AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE hRowObject     AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hRowObjectBuf  AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hDataQuery     AS HANDLE     NO-UNDO.
 DEFINE VARIABLE rRowid         AS ROWID      NO-UNDO.
 DEFINE VARIABLE iFirstRowNum   AS INTEGER    NO-UNDO.
 DEFINE VARIABLE iLastRowNum    AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cKeyFields     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cField         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iField         AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cUniqueColumns AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cEqualColumns  AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lIndexUsed     AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cIndexInfo     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cTableIndexes  AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cTables        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cEnabledTables AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iTableNum      AS INTEGER    NO-UNDO.
 DEFINE VARIABLE iSearchTable   AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cIndexColumns         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iIndex         AS INTEGER    NO-UNDO.
 DEFINE VARIABLE lDefinite      AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE rCurrent       AS ROWID      NO-UNDO.

 {get DataHandle hDataQuery}.

 IF NOT VALID-HANDLE(hDataQuery) THEN
   RETURN ?.
 ELSE
   IF hDataQuery:IS-OPEN = FALSE THEN
     RETURN ?.
 
 IF pcColumns = '':U OR pcColumns = ? THEN
   RETURN NO.
 
 &SCOPED-DEFINE xp-assign  
 {get FirstRowNum iFirstRowNum}
 {get LastRowNum iLastRowNum}
 .
 &UNDEFINE xp-assign
  
 IF pcMode <> 'FIRST':U THEN
 DO:
   MESSAGE 
      SUBSTITUTE({fnarg messageNumber 58}, "findRowObjectWhere()", pcMode) SKIP       
      VIEW-AS ALERT-BOX ERROR.

   RETURN ?.
 END.

 DO iColumn = 1 TO NUM-ENTRIES(pcColumns):   
    /* obtainExpressionEntries, resolves column names to the correct 
       RowObject column names and takes care of adding quotes to the 
       value.  */        
   RUN obtainExpressionEntries IN TARGET-PROCEDURE
         ('RowObject':U,
          iColumn,
          pcColumns,
          pcValues,
          pcOperators,
          OUTPUT cColumn, 
          OUTPUT cOperator,
          OUTPUT cValue). 
   
   IF cColumn > '':U THEN
   DO:
     ASSIGN
       cWhere = cWhere 
              + (If cWhere = "":U 
                 THEN "":U 
                 ELSE " ":U + "AND":U + " ":U)
              + cColumn 
              + " ":U
              + cOperator
              + " ":U
              + cValue.

     /* Build a list of the columns that has equality operators to check
        against the index information to decide whether the request can be 
        resolved on the client.
       (Note that the column names are the RowObject names and need to be 
        unqualified to be checked against the IndexInformation property, 
        which returns unqualified RowObject names for columns in the SDO)  */ 
     IF CAN-DO('=,EQ':U,cOperator) THEN 
       cEqualColumns = cEqualColumns
                     + (IF cEqualcolumns = '' THEN '' ELSE ',')
                     + IF cColumn BEGINS 'RowObject':U 
                       THEN ENTRY(2,cColumn,'.':U) 
                       ELSE cColumn.
   END. /* cColumn > '' */

   /* If 'contains' is used as operator, we cannot resolve the request on the 
      client because the RowObject does not currently inherit any indexes */
   IF cOperator EQ 'Contains' THEN 
     RETURN ?.
 END. /* pcColumn loop */
 
 /* The request cannot be resolved on the client, if the first record of the 
    current query is not here and no equality match is used */ 
 IF iFirstRowNum = ? AND cEqualColumns = '':U THEN
   RETURN ?.

 cQueryString = {fn getDataQueryString}.
 /* insert the request to the rowobject query */ 
 cQueryString = DYNAMIC-FUNCTION('insertExpression' IN TARGET-PROCEDURE,
                                 cQueryString,
                                 cWhere,
                                'AND':U).
 {get RowObject hRowObject}.
 rCurrent = hRowObject:ROWID.
 
 /* Create local buffer and query for the search */
 CREATE BUFFER hRowObjectBuf FOR TABLE hRowObject BUFFER-NAME hRowObject:NAME.
 CREATE QUERY hRowQuery.     /* Get a query to do the "FIND" */

 lOK = hRowQuery:SET-BUFFERS(hRowObjectBuf).
 IF lOK THEN 
    lOK = hRowQuery:QUERY-PREPARE(cQueryString).
 IF lOK THEN
   lOK = hRowQuery:QUERY-OPEN().

 IF lOK THEN
 DO:
   IF pcMode = '':U OR pcMode = 'FIRST':U THEN
     hRowQuery:GET-FIRST() NO-ERROR.
   /** Not supported yet, returned with error message above   
      (This need to be coordinated with the asc/desc sorting to work correctly) */
   ELSE IF pcMode = 'LAST':U THEN
     hRowQuery:GET-LAST().
 END.

 lOK = hRowObjectBuf:AVAILABLE.
 
 /* If the first record is on the client the answer is definite */
 IF lOk AND iFirstRowNum <> ? THEN 
   lDefinite = TRUE.

 /* If this is a 1-to-1 child there's no need for further determination of 
    having found the correct record. */
 ELSE IF {fn getUpdateFromSource} THEN
   lDefinite = TRUE.
 
 /* If we have found something and there's no range, we have a definite answer
    if a unique index is used */    
 ELSE IF lok  THEN
 DO:
   {get KeyFields cKeyFields}.
   IF cKeyFields <> '':U THEN
   DO:
     lIndexUsed = TRUE.
     KeyLoop:
     DO iField = 1 TO NUM-ENTRIES(cKeyFields):
       cField = ENTRY(iField,cKeyFields).
       IF NOT CAN-DO(cEqualColumns,cField) THEN
       DO:
         lIndexUsed = FALSE.
         LEAVE Keyloop.
       END.
     END.
     IF lIndexUsed THEN
       lDefinite = TRUE.
   END. /* KeyFields <> '' */
   
   IF NOT lDefinite THEN
   DO:
   
     &SCOPED-DEFINE xp-assign
     {get Tables cTables}
     {get EnabledTables cEnabledTables}
     {get IndexInformation cIndexInfo}
     .
     &UNDEFINE xp-assign
     
     /* Refine the IndexInformation into a list of unique indexed columns 
        delimited by CHR(1) per index and CHR(2) per tsble */ 
     cUniqueColumns = DYNAMIC-FUNCTION('indexInformation':U IN TARGET-PROCEDURE,
                                       'unique':U,
                                        YES,
                                        cIndexInfo).

     /* The EnabledTables has to be unique also when more than one, so we check 
        their indexes to see if the request is resolved uniquely.  
        If no enabled tables we currently assume the first table, (not always 
        correct, but there is no relationship info that can help us resolve 
        which table is at the 'single' end of a join.. The KeyFields property 
        should be used for many-to-one joins) */   
     Tableloop: 
     DO iSearchTable = 1 TO IF cEnabledTables <> '' THEN 
                            NUM-ENTRIES(cEnabledTables)
                            ELSE 1: 
       iTableNum = IF cEnabledTables <> '' 
                   THEN LOOKUP(ENTRY(iSearchTable,cEnabledTables),cTables)
                   ELSE 1.
       cTableIndexes = ENTRY(iTableNum,cUniqueColumns,CHR(2)).
       IndexLoop:
       DO iIndex = 1 TO NUM-ENTRIES(cTableIndexes,CHR(1)):
         cIndexColumns = ENTRY(iIndex,cTableindexes,CHR(1)).
         lIndexUsed = TRUE.
         IndexKeyLoop:
         DO iField = 1 TO NUM-ENTRIES(cIndexColumns):
           cField = ENTRY(iField,cIndexColumns).
           /* one of the columns in the index is not requested then
              get out of this indexloop */
           IF NOT CAN-DO(cEqualColumns,cField) THEN
           DO:
             lIndexUsed = FALSE.
             LEAVE IndexKeyloop.
           END.
         END.
         IF lIndexUsed THEN 
         DO:
           lDefinite = TRUE.
           LEAVE TableLoop. 
         END.
       END. /* indexLoop */
     END. /* tableloop*/
   END. /* if not definite */
 END. /* else (record was found, but columns need to be checked against index)*/

 /* If the request can be resolved on the client and we have a record then
    position the sdo's query to it */ 
 IF lDefinite AND lOk THEN 
 DO:
   /* Determines if this SDO is being browsed by a SmartDataBrowser */
   {get DataQueryBrowsed lBrowsed}.
   rRowId = hRowObjectBuf:ROWID.

   lOK = hDataQuery:REPOSITION-TO-ROWID(rRowid) NO-ERROR.

   IF lOK AND (NOT lBrowsed) THEN 
      lOK = hDataQuery:GET-NEXT().

   /* Signal row change */
   RUN updateQueryPosition IN TARGET-PROCEDURE.
   PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE ("DIFFERENT":U).   
   {set NewBatchInfo '':U}.
 END.
 ELSE  /* keep current record avail if not found */ 
   hRowObject:FIND-BY-ROWID(rCurrent) NO-ERROR.

 /* delete local widget handles */
 DELETE WIDGET hRowObjectBuf. 
 DELETE WIDGET hRowQuery.

 /* If definite then return yes or no (found or not) otherwise returm ?   */
 RETURN IF lDefinite THEN lOK ELSE ?. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findRowObjUpd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findRowObjUpd Procedure 
FUNCTION findRowObjUpd RETURNS LOGICAL
  ( phRowObject AS HANDLE,
    phRowObjUpd AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose: REturns true if it finds the passed RowObjUpd that corresponds to 
           the current record in the passed RowObject buffer
Parameter: phRowObject AS HANDLE
           phRowObjUpd AS HANDLE  
    Notes: Called from deleteRow to check for a RowObjUpd for a row being deleted
           before creating a new one. 
Note date: 2002/05/31          
------------------------------------------------------------------------------*/

  phRowObjUpd:FIND-UNIQUE('WHERE RowObjUpd.RowNum = ':U + 
                        STRING(phRowObject:BUFFER-FIELD('RowNum':U):BUFFER-VALUE))
                        NO-ERROR.
  RETURN phRowObjUpd:AVAILABLE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findRowWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findRowWhere Procedure 
FUNCTION findRowWhere RETURNS LOGICAL
  (pcColumns     AS CHARACTER,   
   pcValues      AS CHARACTER,    
   pcOperators   AS CHARACTER):
/*------------------------------------------------------------------------------   
Purpose: Find and reposition to a row 
Parameters: 
       pcColumns   - Column names (Comma separated)                    
                     Fieldname of a table in the query in the form of 
                     TBL.FLDNM or DB.TBL.FLDNM (only if qualified with db is specified),
                     (RowObject.FLDNM should be used for SDO's)  
                     If the fieldname isn't qualified it checks the tables in 
                     the TABLES property and assumes the first with a match.

       pcValues    - corresponding Values (CHR(1) separated)
       pcOperators - Operator - one for all columns
                                - blank - defaults to (EQ)  
                                - Use slash to define alternative string operator
                                  EQ/BEGINS etc..
                              - comma separated for each column/value
                                                        
---------------------------------------------------------------------------*/
  DEFINE VARIABLE cColumn          AS CHAR       NO-UNDO.
  DEFINE VARIABLE lOnClient        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cAsDivision      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryString     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataReadHandler AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lQueryOpen       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lBrowsed         AS LOGICAL    NO-UNDO.
 
  {get AsDivision cAsDivision}.
  {get QueryOpen lQueryOpen}.

  /* We do not support calling this on server before the query is opened 
     (This is to protect the client against bad batch properties, since 
      this call opens the query and obtainContextforCclient will return
      data properties) */ 

  IF cAsDivision = 'SERVER':U AND NOT lQueryOpen THEN
    RETURN ?.

  IF cAsDivision = 'CLIENT':U AND NOT lQueryOpen THEN
    lQueryOpen = {fn initializeFromCache}.

   /* don't search onclient if QueryOpen is false; stateless web requests
      may call this after context has been set and findRowObjectWhere will 
      think it has enough info to return no */   
  IF cAsDivision <> 'Server':U AND lQueryOpen THEN
  DO:
    /* Check if the record already is on the client */
    lOnCLient = DYNAMIC-FUNCTION('findRowObjectWhere':U IN TARGET-PROCEDURE,
                                  pcColumns,
                                  pcValues,
                                  pcOperators,
                                  'First':U).  
    /* findRowObjectWhere returns ? if its not able to resolve the query */
    IF lOnCLient <> ? THEN 
    DO:
      {get DataQueryBrowsed lBrowsed}.
      IF lBrowsed THEN
        PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('BatchEnd':U).

      RETURN lOnCLient.
    END.
  END. /* not on server */

  cQueryString = DYNAMIC-FUNCTION('newQueryString':U IN TARGET-PROCEDURE,
                                   pcColumns,
                                   pcValues,
                                   pcOperators,
                                   ?,
                                   ?).

  IF {fnarg fetchRowWhere cQueryString} THEN
  DO:
    RUN updateQueryPosition IN TARGET-PROCEDURE.  
    {get DataReadHandler hDataReadHandler}.
    IF NOT VALID-HANDLE(hDataReadHandler) THEN
    DO:
      PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE("DIFFERENT":U). 
      {set NewBatchInfo '':U}.
    END.
    RETURN TRUE.
  END.
  
  RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-firstRowIds) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION firstRowIds Procedure 
FUNCTION firstRowIds RETURNS CHARACTER
 (pcQueryString AS CHARACTER ) :
/*------------------------------------------------------------------------------
   Purpose:   Returns the ROWID (converted to a character string) of the first 
              database query row satisfying the passed query prepare string.   
Parameters:
    pcWhere - A complete query where clause that matches the database query's 
              buffers.
     Notes:   Used by rowidwhere, findRow and findRowWhere    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cASDivision        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hAppServer         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cRowid             AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lASBound           AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cContext           AS CHARACTER  NO-UNDO.

  /* Determine where to direct the request - client or server.
     The actual code for the function is in query.p. */
  {get ASDivision cASDivision}.
  IF cASDivision = 'Client':U THEN
  DO: 
    /* If we're just the client then do this on the AppServer.
        We must ensure context is set also  */    
    {get AsBound lAsBound}.
    {get ASHandle hAppServer}.

    IF VALID-HANDLE(hAppServer) AND hAppServer NE TARGET-PROCEDURE THEN 
    DO:
      cRowid = DYNAMIC-FUNCTION("firstRowIds":U IN hAppServer, pcQueryString).
   
      /* unbind if getASHandle above did the binding */
      RUN unbindServer IN TARGET-PROCEDURE (?). 
    END. /* valid Appserver */
    ELSE 
      cRowid = ?.
    
    RETURN cRowid. 
  END.  /* END DO IF Client */
  ELSE RETURN SUPER(pcQueryString).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getManagerHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getManagerHandle Procedure 
FUNCTION getManagerHandle RETURNS HANDLE
  ( pcManager AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Override to return this-procedure as default CacheManager 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hManager AS HANDLE     NO-UNDO.
  
  /* In Dynamics this will reach session super when called from main block
     (otherwise it will reach smart.p) */
  hManager = SUPER(pcManager) NO-ERROR.  
  IF NOT VALID-HANDLE(hManager) AND pcManager = 'CacheManager':U THEN 
    hManager = THIS-PROCEDURE.

  RETURN hManager.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTargetProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTargetProcedure Procedure 
FUNCTION getTargetProcedure RETURNS HANDLE
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Temporary fn to return the source-procedure's target-procedure
            to a function such as addRow in an SBO who needs to know who
            the *real* caller object is.
    Notes:  
------------------------------------------------------------------------------*/

  RETURN ghTargetProcedure.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hasActiveAudit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION hasActiveAudit Procedure 
FUNCTION hasActiveAudit RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRowUserProp AS CHARACTER  NO-UNDO.
  
  cRowUserProp = {fnarg columnValue 'RowUserProp':U}.

  RETURN LOOKUP('gstad':U + CHR(3) + 'yes':U,cRowUserProp,CHR(4)) > 0.
     
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hasActiveComments) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION hasActiveComments Procedure 
FUNCTION hasActiveComments RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRowUserProp AS CHARACTER  NO-UNDO.
  cRowUserProp = {fnarg columnValue 'RowUserProp':U}.
  RETURN LOOKUP('gsmcm':U + CHR(3) + 'yes':U,cRowUserProp,CHR(4)) > 0.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hasForeignKeyChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION hasForeignKeyChanged Procedure 
FUNCTION hasForeignKeyChanged RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns true if the dataSource Foreignfields are different 
           from the current ForeignValues  
    Notes: DataAvailable has a 'RESET' mode that indicates that the query only 
           should be opened if necessary. This function is an imporetant part of 
           that logic. If it returns TRUE the query need to be reopened.  
        -  Uncommitted values are currently not considered to be a change, so 
           the DataSource's before-image values is checked if 
           RowObjectState = 'RowUpdated'.
        -  If the query is closed the Key is considered changed.     
           (May be a result of a Cancelled Add or Copy of the parent)  
        -  duplicated in sbo.p  
Note date: 2004/06/06            
-----------------------------------------------------------------------------*/
DEFINE VARIABLE cForeignFields  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCurrentValues  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cParentValues   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSourceFields   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iField          AS INTEGER    NO-UNDO.
DEFINE VARIABLE hField          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDataSource     AS HANDLE     NO-UNDO.
DEFINE VARIABLE cRowObjectState AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hRowObjUpd      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObject      AS HANDLE     NO-UNDO.
DEFINE VARIABLE lNew            AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lQueryOpen      AS LOGICAL    NO-UNDO.

 &SCOPED-DEFINE xp-assign 
 {get ForeignFields cForeignFields}
 {get ForeignValues cCurrentValues}  
 {get DataSource hDataSource}
 {get QueryOpen lQueryOpen}
 .
 &UNDEFINE xp-assign
  
 IF NOT VALID-HANDLE(hDataSource) THEN
   RETURN FALSE.

 /* If the query is not open the ForeignKey is considered changed.  
    It may be closed as the result of a Cancelled Add or Copy of the parent, 
    in which case the ForeignValues is unreliable for this check. 
    (If it never has been opened the logic below would return true also).  */
 IF NOT lQueryOpen THEN
   RETURN TRUE.

 DO iField = 1 TO NUM-ENTRIES(cForeignFields) BY 2:
   cSourceFields =  cSourceFields 
                    + (IF iField = 1 THEN "":U ELSE ",":U)                 
                     /* 2nd of pair is source RowObject fld */ 
                    +  ENTRY(iField + 1, cForeignFields).
 END.

 /* If the DataSource has uncommitted changes, check the before image of the 
    data source (This is admittedly somewhat dirty, but we do not want an API 
    yet...) 
    The intention here is to ensure that this function returns true
    if the parent really is pointing to a different record, but returns 
    false if we still are on the original parent, disregarding changed 
    keyvalues, we also want to disregard uncommitted new records */
 {get RowObjectState cRowObjectState hDataSource}. 
 IF cRowObjectState = 'RowUpdated':U THEN
 DO:
   /* New uncommitted does not constitute a change, but would fail the check 
      below */ 
   {get NewRow lNew}.
   IF lNew THEN
      RETURN FALSE.
   
   {get RowObject hRowObject hDataSource} NO-ERROR.
   {get RowObjUpd hRowObjUpd hDataSource} NO-ERROR.

   /* find the corresponding rowObjUpd -- (really synchronize the buffers) 
      Check the before image values and RETURN this finding. 
     if no RowObjUpd record is available then the current parent has not 
     changed and we will use the general logic below   */
   IF VALID-HANDLE(hRowObject) AND VALID-HANDLE(hRowObjUpd) THEN
   DO:      
     IF DYNAMIC-FUNCTION('findRowObjUpd':U IN hDataSource,
                         hRowObject, 
                         hRowObjUpd) THEN
     DO:
       DO iField = 1 TO NUM-ENTRIES(cSourceFields):
         hField = hRowObjUpd:BUFFER-FIELD(ENTRY(iField,cSourceFields)). 
         cParentValues = cParentValues + ',':U + hField:BUFFER-VALUE.
       END.
       cParentValues = LEFT-TRIM(cParentValues,',':U). 
       /* Return immediately */
       RETURN cParentValues <> cCurrentValues.
     END.
   END.
 END.

 ASSIGN
   cParentValues  = {fnarg colValues cSourceFields hDataSource} NO-ERROR.
   /* Throw away the RowIdent entry returned by colValues*/
   ENTRY(1,cParentValues,CHR(1)) = '':U.
   /* Remove the chr(1).. DON'T TRIM it may cause a problem if the first 
      value(s) in the list is blank */ 
   cParentValues  = SUBSTR(cParentValues,2).

 RETURN cParentValues <> cCurrentValues.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hasOneToOneTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION hasOneToOneTarget Procedure 
FUNCTION hasOneToOneTarget RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns true if this DataObject has DataTargets that are updated
            as part of this.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDataTargets AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hTarget      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lOneToOne    AS LOGICAL    NO-UNDO.

  {get DataTarget cDataTargets}.
  DO i = 1 TO NUM-ENTRIES(cDataTargets):
    hTarget = WIDGET-HANDLE(ENTRY(i,cDataTargets)).
    IF VALID-HANDLE(hTarget) THEN
    DO:
      {get UpdateFromSource lOneToOne hTarget} NO-ERROR.
      IF lOneToOne THEN
        RETURN TRUE.
    END.
  END.
  RETURN FALSE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeFromCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initializeFromCache Procedure 
FUNCTION initializeFromCache RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Initialize the data object from cache 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cCacheKey       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lShareData      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iCacheDuration  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lInSBO          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hDataContainer  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hCheckObject    AS HANDLE     NO-UNDO.
 
  &SCOPED-DEFINE xp-assign
  {get ShareData lShareData}
  {get CacheDuration iCacheDuration}
   .
  &UNDEFINE xp-assign
 
  IF lShareData OR iCacheDuration <> 0 THEN
  DO:
    /* Cache is ONLY supported in a dataContainer (appserver aware container) 
       Mainly because containr.p fetchCointainedData is the only API that adds 
       data to the cache, but also because the SBO is a DataContainer, but does 
       not handle caching and does not exclude a cached master from the request. 
       If this SDO is inside an SBO, check if the SBO is in a DataContainer */    
    {get QueryContainer lInSBO}.
    IF lInSBO THEN
      {get ContainerSource hCheckObject}.
    ELSE 
      hCheckObject = TARGET-PROCEDURE.
 
    hDataContainer = {fn DataContainerHandle hCheckObject}.  
    IF VALID-HANDLE(hDataContainer) THEN
    DO:
      {get LogicalObjectName cCacheKey}. 
      IF cCacheKey = '' THEN 
        {get ServerFileName cCacheKey}.
  
      IF DYNAMIC-FUNCTION('findCacheItem':U in ghCacheManager,
                           cCacheKey,
                           iCacheDuration) THEN
        RETURN {fnarg openFromCache cCacheKey}.
    END.
  END.
  
  RETURN FALSE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isDataQueryComplete) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isDataQueryComplete Procedure 
FUNCTION isDataQueryComplete RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns true if the RowObject temp-table has all records in the 
           currently defined query.    
    Notes: Currently resolved by checking that the First- and LastRowNum is 
           defined.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iLastRowNum  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iFirstRowNum AS INTEGER    NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get FirstRowNum iFirstRowNum}
  {get LastRowNum iLastRowNum}
  . 
  &UNDEFINE xp-assign
  
  RETURN (iLastRowNum <> ?) AND (iFirstRowNum <> ?).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newDataQueryExpression) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION newDataQueryExpression Procedure 
FUNCTION newDataQueryExpression RETURNS CHARACTER
  (pcColumns     AS CHARACTER,   
   pcValues      AS CHARACTER,    
   pcOperators   AS CHARACTER):
/*------------------------------------------------------------------------------   
     Purpose: Returns a Rowobject query expression if all columns are defined
              in the rowobject table.       
     Parameters: 
       pcColumns   - Column names (Comma separated)                    
                     Fieldname of a table in the query in the form of 
                     TBL.FLDNM or DB.TBL.FLDNM (only if qualified with db is specified),
                     (RowObject.FLDNM should be used for SDO's)  
                     If the fieldname isn't qualified it checks the tables in 
                     the TABLES property and assumes the first with a match.

       pcValues    - corresponding Values (CHR(1) separated)
       pcOperators - Operator - one for all columns
                                - blank - defaults to (EQ)  
                                - Use slash to define alternative string operator
                                  EQ/BEGINS etc..
                              - comma separated for each column/value
---------------------------------------------------------------------------*/
 DEFINE VARIABLE iColumn      AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cColumn      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cOperator    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cStringOp    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDataType    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cQuote       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cValue       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cWhere       AS CHARACTER  NO-UNDO.
 
 DO iColumn = 1 TO NUM-ENTRIES(pcColumns):
   cColumn     = ENTRY(iColumn,pcColumns).
     
   /* Convert dbReference to rowObject reference */
   IF NOT (cColumn BEGINS "RowObject" + ".") THEN        
     cColumn =  DYNAMIC-FUNCTION("dbColumnDataName":U IN TARGET-PROCEDURE,
                                  cColumn) NO-ERROR.   
 
   ASSIGN
     /* Get the operator for this valuelist. 
        Be forgiving and make sure we handle '',? and '/begins' as default */                                                  
     cOperator   = IF pcOperators = "":U 
                   OR pcOperators BEGINS "/":U 
                   OR pcOperators = ?                       
                   THEN "=":U 
                   ELSE IF NUM-ENTRIES(pcOperators) = 1 
                        THEN ENTRY(1,pcOperators,"/":U)                                                 
                        ELSE ENTRY(iColumn,pcOperators)

     /* Look for optional string operator if only one entry in operator */          
     cStringOp   = IF NUM-ENTRIES(pcOperators) = 1 
                   AND NUM-ENTRIES(pcOperators,"/":U) = 2  
                   THEN ENTRY(2,pcOperators,"/":U)                                                 
                   ELSE cOperator                    
     cDataType   = {fnarg columnDataType cColumn}.
  
   IF cDataType = ? THEN
     RETURN ?.
   
   ASSIGN          
     cValue     = ENTRY(iColumn,pcValues,CHR(1))                         
     cValue     = IF cValue = ? /*This could happen if only one value*/
                  THEN "?":U 
                  ELSE cValue
     cValue     = (IF cValue <> "":U 
                   THEN REPLACE(cValue,"'","~~~'")
                   ELSE " ":U) 
     cQuote     = (IF cDataType = "CHARACTER":U AND cValue = "?" 
                   THEN "":U 
                   ELSE "'":U)
     cWhere  = cWhere 
                   + (If cWhere = "":U 
                      THEN "":U 
                      ELSE " ":U + "AND":U + " ":U)
                   + cColumn 
                   + " ":U
                   + (IF cDataType = "CHARACTER":U  
                      THEN cStringOp
                      ELSE cOperator)
                   + " ":U
                   + cQuote  
                   + cValue
                   + cQuote.
 END.
 
 RETURN cWhere.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newDataQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION newDataQueryString Procedure 
FUNCTION newDataQueryString RETURNS CHARACTER
  (pcColumns     AS CHARACTER,   
   pcValues      AS CHARACTER,    
   pcOperators   AS CHARACTER):
/*------------------------------------------------------------------------------   
     Purpose: Returns a Rowobject querystring  if all columns are defined
              in the rowobject table.       
     Parameters: 
       pcColumns   - Column names (Comma separated)                    
                     Fieldname of a table in the query in the form of 
                     TBL.FLDNM or DB.TBL.FLDNM (only if qualified with db is specified),
                     (RowObject.FLDNM should be used for SDO's)  
                     If the fieldname isn't qualified it checks the tables in 
                     the TABLES property and assumes the first with a match.

       pcValues    - corresponding Values (CHR(1) separated)
       pcOperators - Operator - one for all columns
                                - blank - defaults to (EQ)  
                                - Use slash to define alternative string operator
                                  EQ/BEGINS etc..
                              - comma separated for each column/value
---------------------------------------------------------------------------*/
 DEFINE VARIABLE cWhere       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cQueryString AS CHARACTER  NO-UNDO.

 cWhere = DYNAMIC-FUNCTION('newDataQueryExpression' IN TARGET-PROCEDURE,
                            pcColumns,pcValues,pcOperators).
 cQueryString = {fn getDataQueryString}.
 cQueryString = DYNAMIC-FUNCTION('insertExpression' IN TARGET-PROCEDURE,
                                 cQueryString,
                                 cWhere,
                                'AND':U).

 RETURN cQueryString. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newRowObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION newRowObject Procedure 
FUNCTION newRowObject RETURNS LOGICAL
  (pcMode AS CHARACTER) :
/*------------------------------------------------------------------------------
   Purpose: Assign some general RowObject fields and update LastRowNum,
            FirstRowNum when a new RowObject has been created . 
Parameters: pcMode - char  - A(dd) or C(opy)     
     Notes: The main purpose for this procedure is to ensure that copy and add
            behaves similar. 
          - The buffer must be created first.  
          - Used in procedure copyColumns and function addRow().  
          - PRIVATE. 
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hColumn       AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hRowObject    AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cBlank        AS CHAR       NO-UNDO.
 DEFINE VARIABLE hLogicObject  AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hNewRowObject AS HANDLE     NO-UNDO.
 DEFINE VARIABLE rRowid        AS ROWID      NO-UNDO.

 &SCOPED-DEFINE xp-assign
 {get RowObject hRowObject}
 {get DataLogicObject hLogicObject}
 . 
 &UNDEFINE xp-assign
 /* rowuserprop is not blanked here, but is excluded from copy... */
 ASSIGN hColumn = hRowObject:BUFFER-FIELD('RowIdent':U)
        hColumn:BUFFER-VALUE = "":U
        hColumn = hRowObject:BUFFER-FIELD('RowIdentIdx':U)
        hColumn:BUFFER-VALUE = "":U
        giAddRowNum = giAddRowNum + 1  /* Assign high temp row number */
        hColumn = hRowObject:BUFFER-FIELD('RowNum':U)
        hColumn:BUFFER-VALUE = giAddRowNum
        hColumn = hRowObject:BUFFER-FIELD('RowMod':U)
        hColumn:BUFFER-VALUE = SUBSTR(pcMode,1,1).  

 /* logic hook */
 IF VALID-HANDLE(hLogicObject) THEN
    RUN setLogicBuffer IN TARGET-PROCEDURE (INPUT hRowObject,INPUT ?).
 
 RUN modifyNewRecord IN TARGET-PROCEDURE NO-ERROR. 
 
 IF VALID-HANDLE(hLogicObject) THEN
 DO:
   RUN getLogicBuffer IN TARGET-PROCEDURE (OUTPUT hNewRowObject).
   hRowObject:BUFFER-COPY(hNewRowObject).
   RUN clearLogicRows IN TARGET-PROCEDURE.
 END.

 rRowid = hRowObject:ROWID.
 
  /* Notify dataSources. They will check NewRow and close the query */  
 PUBLISH "dataAvailable":U FROM TARGET-PROCEDURE ('DIFFERENT':U).    
 {set NewBatchInfo '':U}.

 /* This is probably not needed anymore, this used to protect against 
    focus changing to browsers when disabling children and position being 
    lost, due to browser's implicit reposition, but we have fixed viewer 
    to set focus immediately on add. */
 IF rRowid <> hRowObject:ROWID THEN
   hRowObject:FIND-BY-ROWID(rRowid).
  
 RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainContextForClient) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION obtainContextForClient Procedure 
FUNCTION obtainContextForClient RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Obtain context properties to return to the client after or as part 
           of a server request.   
    Notes: The returned data depends on if this is the first call from the 
           client or not. If this is the first call we still return the regular
           context if this is after a data request, which is the request that 
           may change context. It is considered a data request if the query
           has been opened or RowObjUpd has records
         - The serverside object's serverFirstCall defaults to false so that a 
           normal request does not need to have any special information. 
           It is the client's responsibility to signal a first call by passing 
           serverFirstCall=yes as part of the context.  
          (We also support the 9.1B trick of setting the FIRST entry in the 
           context to ObjectInitialized=no as a way to set ServerFirstCall to 
           true on the server) 
------------------------------------------------------------------------------*/
 DEFINE VARIABLE lFirstCall         AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cContext           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDataContext       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cOperatingMode     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cQueryWhere        AS CHARACTER  NO-UNDO INIT ?.
 DEFINE VARIABLE cOpenQuery         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDBNames           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cPhysicalTables    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cIndexInfo         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cKeyFields         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lData              AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE hRowObjUpdTable    AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cKeyTableId        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cEntityFields      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cPositionForClient AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lAuditEnabled      AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cAuditEnabled      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iRowsToBatch       AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cWordIndexedFields AS CHARACTER  NO-UNDO.
 {get ServerFirstCall lFirstCall}.
 IF lFirstCall THEN
 DO:
   /* If stateless then send back QueryWhere as QueryContext, which will be 
      used to reset the context again and also by getQueryWhere to return 
      data without connecting. */   
   &SCOPED-DEFINE xp-assign
   {get ServerOperatingMode cOperatingMode}
   {get RowsToBatch iRowsToBatch}
   .
   &UNDEFINE xp-assign
   

   IF cOperatingMode = 'STATELESS':U THEN 
     {get QueryWhere cQueryWhere}.

   &SCOPED-DEFINE xp-assign
   {get OpenQuery cOpenQuery}
   {get DBNames cDBNames}
   {get PhysicalTables cPhysicalTables}
   {get KeyFields  cKeyFields}
   {get KeyTableId cKeyTableId}  /* After getKeyfields as it may be set there */
   {get EntityFields cEntityFields}
   {get AuditEnabled lAuditEnabled}
   /* Is this before or after a data request */
   {get QueryOpen lData}
   {get WordIndexedFields cWordIndexedFields} 
   {get IndexInformation cIndexInfo}
   . 
   &UNDEFINE xp-assign
   
   IF NOT lData THEN
   DO:
     /* If not a query, existance of rowObjUpd indicates a commit, which is a data request*/ 
     {get RowObjUpdTable hRowObjUpdTable}.
     lData = VALID-HANDLE(hRowObjUpdTable) AND hRowObjUpdTable:HAS-RECORDS.
   END.

   /* Turn off this as we may do another context request before we destroy, 
      which of course always is the case if we are state aware. */
   {set ServerFirstCall FALSE}.

   /* not all of these should ever be unknown, like word idx fields, 
      but the consequence of an unknown is bad and everything can be 
      overridden, so we check thoroughly...*/  
     
   ASSIGN
     cOperatingMode  = (IF cOperatingMode  = ? THEN '?':U ELSE cOperatingMode)
     cIndexInfo      = (IF cIndexInfo      = ? THEN '?':U ELSE cIndexInfo)
     cOpenQuery      = (IF cOpenQuery      = ? THEN '?':U ELSE cOpenQuery)
     cDBNames        = (IF cDBNames        = ? THEN '?':U ELSE cDBNames)
     cPhysicalTables = (IF cPhysicalTables = ? THEN '?':U ELSE cPhysicalTables)
     cKeyFields      = (IF cKeyFields      = ? THEN '?':U ELSE cKeyFields)
     cKeyTableId     = (IF cKeyTableId     = ? THEN '?':U ELSE cKeyTableId)
     cEntityFields   = (IF cEntityFields   = ? THEN '?':U ELSE cEntityFields)
     cAuditEnabled   = (IF lAuditEnabled   = ? THEN '?':U ELSE STRING(lAuditEnabled))
     /* unknown should not happen, but if it is then make it blank */ 
     cWordIndexedFields = (IF cWordIndexedFields = ? THEN ' ':U ELSE cWordIndexedFields)
     cContext        = "IndexInformation":U + CHR(4) + cIndexInfo + CHR(3) 
                     + "ServerOperatingMode":U + CHR(4) + cOperatingMode
                     + CHR(3) 
                    /* Return as BaseQuery .. setOpenQuery does to much 
                       now when this may be returned as part of a data request */ 
                    + "BaseQuery":U + CHR(4) + cOpenQuery
                    + CHR(3) 
                    + "DBNames":U + CHR(4) + cDBNames
                    + CHR(3) 
                    + "PhysicalTables":U + CHR(4) + cPhysicalTables
                    + CHR(3) 
                    + "KeyFields":U + CHR(4) + cKeyFields
                    + CHR(3) 
                    + "KeyTableId":U + CHR(4) + cKeyTableId
                    + CHR(3) 
                    + "EntityFields":U + CHR(4) + cEntityFields
                    + CHR(3) 
                    + "WordIndexedFields":U + CHR(4) + cWordIndexedFields
                    + CHR(3)  
                    /* we send it back as it usually is set to true on the client 
                       to be passed as context to this (server) side */
                    + "ServerFirstCall":U + CHR(4) + 'NO':U
                    + CHR(3)
                    + "AuditEnabled":U + CHR(4) + cAuditEnabled
                    /* if NOT WebSpeed pass queryWhere as QueryContext 
                       genContextList deals with this for webspeed .. */
                    + (IF SESSION:CLIENT-TYPE <> "WEBSPEED":U 
                       AND cQueryWhere <> ? 
                       THEN CHR(3) + "QueryContext":U + CHR(4) + cQueryWhere
                       ELSE '':U)      
              .  
 END. /* firstCall */

 IF NOT lFirstCall OR lData THEN
   RUN genContextList IN TARGET-PROCEDURE (OUTPUT cDataContext).
 
 RETURN cContext 
        + (IF cContext <> '':U AND cDataContext <> '' THEN CHR(3) ELSE '':U)  
        + cDataContext.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainContextForServer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION obtainContextForServer Procedure 
FUNCTION obtainContextForServer RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: return a list of properties and set required client query context 
           properties.  
    Notes: Called from initializeServerObject and directly when the 
           'one-hit' stateless procedures are called 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lASHasStarted        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lCheck               AS LOGICAL    NO-UNDO.  
  DEFINE VARIABLE lRebuild             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iRowsToBatch         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lSubmitVal           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lFetchHasAudit       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lFetchHasComment     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lFetchAutoComment    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cFetchHasAudit       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFetchHasComment     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFetchAutoComment    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEntityFields        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryWhere          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPropertiesForServer AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lUseRepository       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDefs                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lDestroyStateless    AS LOGICAL    NO-UNDO. 
  
  /* Dynamic SDO on server  */
  DEFINE VARIABLE cTables                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPhysicalTables          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBaseQuery               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataColumns             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataColumnsByTable      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAssignList              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUpdatableColumnsByTable AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataLogicProcedure      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSchemaLocation          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyFields               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyTableID              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNoLockReadOnlyTables    AS CHARACTER  NO-UNDO. 

  &SCOPED-DEFINE xp-assign
  {get ASHasStarted lASHasStarted}
  {get UseRepository lUseRepository}
  .
  &UNDEFINE xp-assign
  IF NOT lASHasStarted THEN
     cPropertiesForServer = 
         /* AsHasStarted is sent to the server to tell if this is the first call 
            will return the properties we need to retrieve at start up.
            We may come up with something better later...  */
           "ServerFirstCall":U  + CHR(4) + "YES":U.
  ELSE DO:   
    RUN genContextList IN TARGET-PROCEDURE (OUTPUT cPropertiesForServer).
    IF lUseRepository THEN 
    DO:
      &SCOPED-DEFINE xp-assign
      {get KeyFields cKeyFields}
      {get KeyTableID cKeyTableID}
      .
      &UNDEFINE xp-assign
    END.  /* if use repository */
  END.
  
  &SCOPED-DEFINE xp-assign
  {get RebuildOnRepos lRebuild} 
  {get RowsToBatch iRowsToBatch} 
  {get ServerSubmitValidation lSubmitVal}
  {get CheckCurrentChanged lCheck}
  {get NoLockReadOnlyTables cNoLockReadOnlyTables} 
  {get DataFieldDefs cDefs}
  {get DestroyStateless lDestroyStateless}
  {get BaseQuery cBaseQuery}
  .
  &UNDEFINE xp-assign
  /* dynamic sdo need to send meta info to server if not repository */ 
  IF cDefs = '':U AND NOT lUseRepository THEN
  DO:
    &SCOPED-DEFINE xp-assign
    {get Tables cTables}
    {get PhysicalTables cPhysicalTables}
    {get DataColumns cDataColumns}
    {get DataColumnsByTable cDataColumnsByTable}
    {get UpdatableColumnsByTable cUpdatableColumnsByTable}
    {get AssignList cAssignList}
    {get DataLogicProcedure cDataLogicProcedure}
    {get SchemaLocation cSchemaLocation}
    .
    &UNDEFINE xp-assign
    cPropertiesForServer = (IF cPropertiesForServer > "":U 
                            THEN cPropertiesForServer + CHR(3)
                            ELSE "":U)
                          + "Tables":U + CHR(4) + cTables 
                          + CHR(3)  
                          + "PhysicalTables":U + CHR(4) + cPhysicalTables 
                          + CHR(3)  
                          + "DataColumns":U + CHR(4) + cDataColumns
                          + CHR(3)  
                          + "DataColumnsByTable":U + CHR(4) + cDataColumnsByTable
                          + CHR(3)  
                          + "UpdatableColumnsByTable":U + CHR(4) + cUpdatableColumnsByTable
                          + CHR(3)  
                          + "AssignList":U + CHR(4) + cAssignList 
                          + CHR(3)  
                          + "DataLogicProcedure":U + CHR(4) + cDataLogicProcedure
                          + CHR(3)  
                          + "SchemaLocation":U + CHR(4) + cSchemaLocation.
  END.

  IF lUseRepository THEN
  DO:
    &SCOPED-DEFINE xp-assign
    {get FetchHasAudit lFetchHasAudit}
    {get FetchHasComment lFetchHasComment}
    {get FetchAutoComment lFetchAutoComment}
    &UNDEFINE xp-assign
    cFetchHasAudit = IF lFetchHasAudit = ? THEN '?':U ELSE STRING(lFetchHasAudit)
    cFetchHasComment = IF lFetchHasComment = ? THEN '?':U ELSE STRING(lFetchHasComment)
    cFetchAutoComment = IF lFetchAutoComment = ? THEN '?':U ELSE STRING(lFetchAutoComment)
    .  
    IF lAsHasStarted THEN
    DO:
      {get EntityFields cEntityFields}.
      cEntityFields = (IF cEntityFields = ? THEN '?':U ELSE cEntityFields).
    END.
  END.

  /* Set QueryWhere on the server to reset context (includes BY phrases)
     First check if it has been changed BY assignQuerySelection or addQueryWhere */
  {get QueryString cQueryWhere}.
  IF cQueryWhere = '':U THEN
    {get QueryWhere cQueryWhere}. /* this will check queryContext on client  */
    
  ELSE /* This is hereby the client context and can be used by openQuery to
          avoid sending QueryString in an extra call */  
    {set QueryContext cQueryWhere}. 
  
  IF cQueryWhere = ? THEN cQuerywhere = '':U.
  /* this would be an error, but... */
  IF cNoLockReadOnlyTables = ? THEN cNoLockReadOnlyTables = '':U.

  cPropertiesForServer = (IF cPropertiesForServer  <> ? 
                          AND cPropertiesForServer <> "":U 
                          THEN cPropertiesForServer + CHR(3)
                          ELSE "":U)
                        + "DestroyStateless":U + CHR(4) 
                        + (IF lDestroyStateless THEN "YES":U ELSE "NO":U) 
                        + (IF cBaseQuery > '' 
                           THEN CHR(3) + "BaseQuery":U + CHR(4) + cBaseQuery 
                           ELSE '')
                        + CHR(3)
                        + "QueryWhere":U + CHR(4) + cQueryWhere 
                        + CHR(3)  
                        + "RebuildOnRepos":U + CHR(4) + STRING(lRebuild)
                        + CHR(3)      
                        + "RowsToBatch":U + CHR(4) + STRING(iRowsToBatch)
                        + CHR(3)      
                        + "ServerSubmitValidation":U + CHR(4) + STRING(lSubmitVal)
                        + CHR(3) 
                        + "CheckCurrentChanged":U + CHR(4) + STRING(lCheck)
                        + CHR(3) 
                        + "NoLockReadOnlyTables":U + CHR(4) + cNoLockReadOnlyTables.
                          
  IF lUseRepository THEN
  DO:
    cPropertiesForServer = cPropertiesForServer
                          + CHR(3) 
                         + "FetchHasAudit":U + CHR(4) + cFetchHasAudit
                         + CHR(3) 
                          + "FetchHasComment":U + CHR(4) + cFetchHasComment
                          + CHR(3) 
                          + "FetchAutoComment":U + CHR(4) + cFetchAutoComment.
     IF lAsHasStarted THEN
       cPropertiesForServer = cPropertiesForServer
                            + CHR(3) 
                            + "EntityFields":U + CHR(4) + cEntityFields
                            + CHR(3)
                            + "KeyFields":U + CHR(4) + cKeyFields
                            + CHR(3)
                            + "KeyTableID":U + CHR(4) + cKeyTableID.
  END.

  RETURN cPropertiesForServer.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-openDataQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION openDataQuery Procedure 
FUNCTION openDataQuery RETURNS LOGICAL
  (pcPosition AS CHAR):
/*------------------------------------------------------------------------------
   Purpose: Open the DataQuery  
Parameters: pcPosition - 'first' or last' 
                         Expected to be extended with Rowid support.  
     Notes: Currently used by SBOs after new temp-tables have been fetched.  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hDataQuery  AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cQuery      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cAsDivision AS CHARACTER  NO-UNDO.
 
 &SCOPED-DEFINE xp-assign
 {get DataHandle hDataQuery}
 {get DataQueryString cQuery}
  .
 &UNDEFINE xp-assign
 
 IF VALID-HANDLE(hDataQuery) THEN
 DO:
   hDataQuery:QUERY-PREPARE(cQuery).
   /* no-error is just used to silence size errors in browser (not fit in frame)
      this is by no means done everywhere this can happen and is not a 
      supported condition, so if errors are wanted just remove the no-error */ 
   hDataQuery:QUERY-OPEN() no-error.
   CASE pcPosition: 
     WHEN 'FIRST':U THEN
       hDataQuery:GET-FIRST() no-error.
     WHEN 'LAST':U THEN
       hDataQuery:GET-LAST() no-error.  
     
     /** Future .. (Note that there is a reopenToRowid that does this and more..... ) 
     OTHERWISE DO:
       IF pcPosition <> '':U AND pcPosition <> ? THEN
       DO:
         hDataQuery:REPOSITION-TO-ROWID(TO-ROWID(pcPosition)) no-error. 
         IF not avail THEN get-next... 
       END.
     END.
     **/ 
   END CASE.

   /* Update QueryPosition property and publish this to toolbars etc unless 
      no positioning took place here) */
   IF pcPosition <> '':U THEN 
     RUN updateQueryPosition IN TARGET-PROCEDURE.

   /* Some visual objects that shows more than one record may need to know 
      that the query changed, this cannot be detected through the ordinary
      publish "dataAvailable" from the navigation methods. 
      The SmartSelect populates its list on this event and OCX objects
      like lists and Tree-views may also need to subscribe to this event. */
   {get AsDivision cAsDivision}.
   IF cAsDivision = 'CLIENT':U THEN
     PUBLISH "queryOpened":U FROM TARGET-PROCEDURE.
 
 END. /* valid hDataquery */

 RETURN IF VALID-HANDLE(hDataQuery) 
        THEN hDataQuery:IS-OPEN 
        ELSE FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-openFromCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION openFromCache Procedure 
FUNCTION openFromCache RETURNS LOGICAL PRIVATE
  ( pcCacheKey AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRowObject       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObjectTable  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lShareData       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hDataHandle      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDataQueryString AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hRowNum          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lNew             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cContext         AS CHARACTER  NO-UNDO.

  {get ShareData lShareData}.
  IF lShareData THEN
  DO:
    &SCOPED-DEFINE xp-assign
    {get DataHandle hDataHandle}.
    {get RowObject hRowObject}.
      .
    &UNDEFINE xp-assign
 
    IF NOT VALID-HANDLE(hRowObject) THEN
    DO:
      lNew = TRUE.
      if not valid-handle(hDataHandle) then
      do:
        CREATE QUERY hDataHandle.
        {set DataHandle hDataHandle}. 
      end.
      
      hRowObject = DYNAMIC-FUNCTION('createSharedBuffer':U IN ghCacheManager,
                                     pcCacheKey).
  
      {set RowObject hRowObject}.
      
      hDataHandle:SET-BUFFERS(hRowObject).
      
      /* if openoninit is false then we did not cache the table */
      {get RowObjectTable hRowObjectTable}.
      IF VALID-HANDLE(hRowObjectTable) THEN
        DELETE OBJECT hRowObjectTable.
    END. /* not valid rowobject */
  END.
  ELSE DO:  
    {get RowObjectTable hRowObjectTable}.
    lNew = NOT VALID-HANDLE(hRowObjectTable).
    
    RUN fetchDataFromCache IN ghCacheManager (pcCacheKey,
                                              OUTPUT TABLE-HANDLE hRowObjectTable).

    IF lNew THEN
      {set RowObjectTable hRowObjectTable}.

    &SCOPED-DEFINE xp-assign
    {get RowObject hRowObject}
    {get DataHandle hDataHandle}
    .
    &UNDEFINE xp-assign
  
  END.

  IF lNew THEN
  DO:
    cContext = {fnarg obtainContextFromCache pcCacheKey ghCacheManager}.
    {fnarg applyContextFromServer cContext}. 
  
    IF lNew THEN 
      RUN retrieveFilter IN TARGET-PROCEDURE.
  
    {set AsDivision 'CLIENT':U}.
    {set AsHasStarted TRUE}.
  END. /* new */

  /* add and convert querystring to dataquerystring  */
  cDataQueryString = {fn dataQueryStringFromQuery}.
  {set DataQueryString cDataQueryString}.
  {fnarg openDataQuery ''}.
  hDataHandle:GET-LAST().
  IF hRowObject:AVAILABLE THEN
  DO:
    hRowNum = hRowObject:BUFFER-FIELD('RowNum':U) NO-ERROR.
    {set LastRowNum hRowNum:BUFFER-VALUE}.
    hDataHandle:GET-FIRST().
    {set FirstRowNum hRowNum:BUFFER-VALUE}.
  END.
  
  RUN updateQueryPosition IN TARGET-PROCEDURE.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-openQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION openQuery Procedure 
FUNCTION openQuery RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Opens the SmartDataObject's database query based on the current 
               WHERE clause.
  
  Parameters:  <none>
------------------------------------------------------------------------------*/    
 DEFINE VARIABLE cASDivision      AS CHARACTER NO-UNDO.
 DEFINE VARIABLE cDataQueryString AS CHARACTER NO-UNDO.
 DEFINE VARIABLE hDataQuery       AS HANDLE    NO-UNDO.
 DEFINE VARIABLE hDataContainer   AS HANDLE    NO-UNDO.
 DEFINE VARIABLE cObjectName      AS CHARACTER NO-UNDO.
 DEFINE VARIABLE lFromCache       AS LOGICAL   NO-UNDO.

 /* Close the RowObject query and empty the current RowObject table. */
 {get DataHandle hDataQuery}.
 IF VALID-HANDLE(hDataQuery) THEN 
 DO: 
   IF hDataQuery:IS-OPEN THEN
     {fn closeQuery}.
   ELSE DO:
     {get DataQueryString cDataQueryString}.
     IF cDataQueryString NE hDataQuery:PREPARE-STRING THEN
        hDataQuery:QUERY-PREPARE(cDataQueryString).
   END.  /* else do - query not open */
 END.  /* if valid hDataQuery */

 /* If this object can use a DataContainer then we run fetchContainedRows 
    in that in order to retrieve this objects data together with all child 
    objects data. */ 
 hDataContainer = {fn dataContainerHandle}.
 
 {get AsDivision cAsDivision}.
 IF VALID-HANDLE(hDataContainer) THEN 
 DO:
   IF cAsDivision = 'CLIENT':U  THEN
     lFromCache = {fn initializeFromCache}.
   IF lFromCache THEN
   DO:
     RUN fetchFirst IN TARGET-PROCEDURE.
     RETURN TRUE.
   END.
   ELSE DO:
     {get ObjectName cObjectName}.
     RUN fetchContainedData IN hDataContainer (INPUT cObjectName).
     RETURN RETURN-VALUE <> 'adm-error':U.
   END.
 END.  
 ELSE 
 DO:
   /* If this is the client half of a divided DataObject, fetchFirst will
      retrieve the Temp-table across the connection. */
   IF cASDivision = 'Client':U THEN
   DO:
     &SCOPED-DEFINE xp-assign
     /* Reset this last-record flag on the client */ 
     {set LastRowNum ?}
     /* keep connected until the actual data request in case the appserver 
        is called during this call */
     {set BindScope 'Data':U}
     . 
     &UNDEFINE xp-assign
     RUN fetchFirst IN TARGET-PROCEDURE.
     /* unbind in case the datarequest did not happen  */
     RUN unbindServer IN TARGET-PROCEDURE (?).
     RETURN TRUE.
   END.   /* END DO client */
   ELSE   /* This is not the client */
     RETURN SUPER().
 END. /* else do (not sbo client ) */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareColumnsFromRepos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION prepareColumnsFromRepos Procedure 
FUNCTION prepareColumnsFromRepos RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Prepares columns from repository with label, columnlabel and format
    Notes: Only called for static objects.  
           Does not prepare calculated fields 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRowObjectTable     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDataColumns        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataColumnsByTable AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAssignList         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPhysicalTables     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lDynamicData        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lOk                 AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cSchemaLocation     AS CHARACTER  NO-UNDO.

  IF VALID-HANDLE(gshRepositoryManager) THEN
  DO:
    &SCOPED-DEFINE xp-assign
    {get DynamicData lDynamicData}
    {get PhysicalTables cPhysicalTables}
    {get DataColumnsByTable cDataColumnsByTable}
    {get DataColumns cDataColumns}
    {get AssignList cAssignList}
    {get RowObjectTable hRowObjectTable}
    {get SchemaLocation cSchemaLocation}
    .
    &UNDEFINE xp-assign
   /* Static objects will NOT to be copied from repository if the  
      SchemaLocation is 'DLP' or 'BUF' (which then really means use the 
      include as-is)  */ 

    IF NOT (cSchemaLocation = 'DLP':U) AND NOT (cSchemaLocation = 'BUF':U) THEN
      lOk = DYNAMIC-FUNCTION('prepareRowObjectColumns':U IN gshRepositoryManager,
                                     hRowObjectTable,
                                     cPhysicalTables, 
                                     cDataColumns,
                                     cDataColumnsByTable,
                                     cAssignList).
    ELSE 
      lOk = TRUE.

    /* An error from Repman is fatal for dynamic data 
       (We currently don't call this for Dynamic Data though, as 
        createRowObjectTable calls the repman API directly, because it need
        to pass an unprepared TT to it */ 
    IF lDynamicData THEN
      RETURN lok.

    RETURN TRUE.
  END.

  RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareForFetch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION prepareForFetch Procedure 
FUNCTION prepareForFetch RETURNS CHARACTER
  ( pcOptions AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: prepares the query before a fetch of a temp table from the server  
Parameters: pcOptions - char
              Comma separated list of options 
              - Batch - Keep the temp-table and batch properties. This is used
                        when another batch is requested.   
              - Child - Specifies that this is a child of the request initiator.
                        This currently results in a removal of ForeignFields
                        (will be reapplied on server)                                    
              - ClientChild - Specifies that this is a child of an object 
                              already on the client, not part of the request
                         Assign ForeignFields from the parent.                                  
    Notes:  This is used when more than one table is being fetched and has been 
            separated for code reuse in the different scenarios. It should only
            be used in loops where the 
            caller need to know the order of the 
            SDOs and their relation ships in order to pass the right options.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cQuery            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBaseQuery        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryWhere       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignFields    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainer        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lUpdateFromSource AS LOGICAL    NO-UNDO.
  
  /* pcOptions = 'Batch' is used when batching in order to keep the temp-table
     and the batch properties  */  
  IF NOT CAN-DO(pcOptions,'Batch':U) THEN
  DO:
    {get UpdateFromSource lUpdateFromSource}.
    IF NOT lUpdateFromSource THEN
      {fnarg emptyRowObject 'reset':U}.
  END.

  IF CAN-DO(pcOptions,'CLIENTCHILD':U) THEN 
  DO:
    {fn addForeignKey}.
    {get QueryString cQuery}.           
  END.
  ELSE DO:
    /* A blank QueryString may indicate that QueryWhere has been set.
       The QueryWhere is stored on the client (also for state-aware objects),
       so we must ensure that it is sent to server if it has been set.*/  
    {get QueryString cQuery}.           
    IF cQuery = '':U THEN
    DO:
  
      &SCOPED-DEFINE xp-assign
      {get BaseQuery cBaseQuery} 
      {get QueryWhere cQueryWhere}
       .
      &UNDEFINE xp-assign
      
      /* We only need this if QueryWhere is different from the base, since a 
         blank entry tells the server to use the base anyway */
      IF cBaseQuery <> cQueryWhere AND cQueryWhere <> ? THEN 
        cQuery = cQueryWhere. 
    END. /* Blank querystring */
    ELSE IF CAN-DO(pcOptions,'CHILD':U) THEN 
    DO: 
      /* The QueryString Foreign Fields criteria are removed for every SDO 
         that are 'below' the one we are requesting, as these SDOs will 
         apply Foreign Fields on the server.  
        (We cannot trust that dataAvailable will replace the FF as the 
         positional info about criteria in QueryString is stored 
         in QueryColumns and the server's QueryColumns may not match.) */
      {fn removeForeignKey}.
      /* Reread the queryString after removal of Foreign Field */
      {get QueryString cQuery}.
    END. /* child */
    ELSE  
    DO:
      /* Even if this is the upper SDO (parent) in this request, it may actually
         be a child, in which case it is possible that the ForeignFields may 
         not yet have been applied to the client's QueryString.
         So we compare the QueryString with the BaseQuery to see if it just has 
         been set to avoid problems with FFs returned from server. If that's
         the case we must use the QueryWhere, which will include potential
         ForeignField criteria as applied on the server. (We know this is correct
         since this only can occur if the parent is the same as it was on the 
         server) */ 
      {get ForeignFields cForeignFields}.
      IF cForeignFields = '':U THEN
      DO:
        {get ContainerSource hContainer}.
        {get ForeignFields cForeignFields hContainer} NO-ERROR. 
      END.
      IF cForeignFields <> '':U AND cForeignFields <> ? THEN
      DO:
        {get BaseQuery cBaseQuery}.
        IF cBaseQuery = cQuery THEN
        DO:
            {fn addForeignKey}.
            {get QueryString cQuery}.   
        END.
      END.
    END. /* iSDO = iSDONum */
  END.

  RETURN cQuery.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareRowObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION prepareRowObject Procedure 
FUNCTION prepareRowObject RETURNS LOGICAL
  ( phTable AS HANDLE) :
/*------------------------------------------------------------------------------
   Purpose: Prepare a rowObject table from the existing definition 
Parameters: phHandle created, but unprepared temp-table 
     Notes: This is used to define a dynamic TT FROM another TT, which may be
            a static one.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRowObjectTable AS HANDLE     NO-UNDO.

  {get RowObjectTable hRowObjectTable}.

  phTable:CREATE-LIKE(hRowObjectTable:DEFAULT-BUFFER-HANDLE).
  phTable:TEMP-TABLE-PREPARE(hRowObjectTable:NAME).

  {set RowObjectTable phTable}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-receiveData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION receiveData Procedure 
FUNCTION receiveData RETURNS LOGICAL
  ( phTable AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose: Receive data ( from DataContainer )  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cCacheKey       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCacheDuration  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lShareData      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iLastRowNum     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hOldTable       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cKeyTableId     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyFields      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPhysicalTables AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDbNames        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContext        AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get CacheDuration iCacheDuration}
  {get ShareData lShareData}
  {get LastRowNum iLastRowNum}.
  &UNDEFINE xp-assign
  IF (iCacheDuration <> 0 OR lShareData) /*AND iLastRownum <> ? */ THEN
  DO:
    &SCOPED-DEFINE xp-assign
    {get LogicalObjectName cCacheKey}
    {get KeyTableId cKeyTableId} 
    {get KeyFields cKeyFields} 
    {get PhysicalTables cPhysicalTables} 
    {get DBNames cDBNames} 
    .
    &UNDEFINE xp-assign

    IF cCacheKey = '' THEN 
      {get ServerFileName cCacheKey}.

    cContext = 'KeyTableId':U + CHR(4) 
             + (IF cKeyTableId = ? THEN '?' ELSE cKeyTableId) + CHR(4) 
             + 'KeyFields':U + CHR(4) 
             + (IF cKeyFields = ? THEN '?' ELSE cKeyFields) + CHR(4)
             + 'PhysicalTables':U + CHR(4) 
             + (IF cPhysicalTables = ? THEN '?' ELSE cPhysicalTables) + CHR(4)
             + 'DBNames':U + CHR(4) 
             + (IF cDBNames = ? THEN '?' ELSE cDBNames).

    DYNAMIC-FUNCTION('registerCacheItem':U IN ghCacheManager,
                      cCacheKey,phTable,iCacheDuration,iLastRowNum,cContext).
      
    {fnarg openFromCache cCacheKey}.
  END.
  ELSE DO:
    {set RowobjectTable phTable}.
    {fnarg openDataQuery 'FIRST':U}.
  END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-refreshQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION refreshQuery Procedure 
FUNCTION refreshQuery RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
 Purpose: Refresh browse query and reposition to currently selected row
   Notes: This is a refresh of the current query, so a never opened or closed 
          query will not be refreshed by this. 
        - Currently refreshes all dependant active child queries.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRowIdent AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lOpen     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lOk       AS LOGICAL    NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get Rowident cRowIdent}
  {get QueryOpen lOpen}
  .
  &UNDEFINE xp-assign
  
  IF lOpen THEN
  DO:
    {fn closeQuery}.
    IF cRowIdent > "":U THEN
      lOk =  {fnarg fetchRowWhere cRowIdent}.
   
    if lok then  
    do:
      run updateQueryPosition in target-procedure.            
     /* different, since we refreshed children and repositioned to first 
       (server only reads children for one parent record) */
      publish "dataAvailable" from target-procedure ('different').
      {set NewBatchInfo '':U}.
    end.  
    else     
      RUN fetchFirst IN TARGET-PROCEDURE. 
    
    RETURN TRUE.
  END.

  RETURN FALSE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeQuerySelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION removeQuerySelection Procedure 
FUNCTION removeQuerySelection RETURNS LOGICAL
  (pcColumns   AS CHARACTER,
   pcOperators AS CHARACTER):
/*------------------------------------------------------------------------------
  Purpose:     Remove field expression(s) for specified column(s) and operator(s) 
               added by assignQuerySelection from the query. 
  Parameters: 
     pcColumns   - Column names (Comma separated)                    
                   Fieldname of a table in the query in the form of 
                   TBL.FLDNM or DB.TBL.FLDNM (only if qualified with db is 
                   specified),
                 - RowObject.FLDNM should be used for SDO columns  
                   If the fieldname isn't qualified it checks the tables in 
                   the TABLES property and assumes the first with a match.              
     pcOperators - Operator - one for all columns
                              - blank - defaults to (EQ)  
                              - Use slash to define alternative string operator
                                EQ/BEGINS etc..
                            - comma separated for each column/value

  Notes:       This procedure modifies the QueryString property and is designed 
               to run on the client and called several times before QueryString
               is used in a QUERY-PREPARE method to modify the database query.
               
               openQuery will prepare the query using the QueryString property.
               
               The removal of the actual field expression is done by the help 
               of the position and length stored in the QueryColumns property. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iLoop   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cColumn AS CHARACTER  NO-UNDO.

  IF INDEX(',':U + pcColumns,',RowObject.':U) > 0 THEN
  DO iLoop = 1 TO NUM-ENTRIES(pcColumns):
    cColumn = ENTRY(iLoop,pcColumns).
    IF cColumn BEGINS "RowObject":U + ".":U THEN
      ASSIGN
        cColumn = DYNAMIC-FUNCTION("columnDBColumn":U IN TARGET-PROCEDURE,
                                    ENTRY(2,cColumn,".":U))
        ENTRY(iLoop,pcColumns) = cColumn.

  END.

  RETURN SUPER(pcColumns,pcOperators). 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-repositionRowObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION repositionRowObject Procedure 
FUNCTION repositionRowObject RETURNS LOGICAL
   ( pcRowIdent AS CHARACTER ): 

/*------------------------------------------------------------------------------
  Purpose: Override in order to handle a comma separated Rowident.
    Notes: A comma separated RowIdent with secondary entries for physical 
           rowids should have been eliminated, but is supported for backwards 
           compatibility.
------------------------------------------------------------------------------*/
  return super(entry(1,pcRowident)).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION resetRow Procedure 
FUNCTION resetRow RETURNS LOGICAL
  ( pcRowident AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Reset (undo) the specified rowobject record   
Parameter: pcRowident 
               - Rowobject rowid 
               - ?  will reset current.    
    Notes: This is normally used to reset current row from a visual object's 
           resetRecord. The rowident parameter allows the same API for SBOs 
           without the ghTargetProcedure workaround to identify which SDO to 
           reset.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lAutoCommit      AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE hContainerSource AS HANDLE   NO-UNDO.
  
  IF {fnarg repositionRowobject pcRowident} THEN
  DO:
    {get AutoCommit lAutoCommit}.
    IF NOT lAutoCommit THEN 
    DO:
      {get ContainerSource hContainerSource}.
      {get AutoCommit lAutoCommit hContainerSource} NO-ERROR.
       /* Reset must reset the RowObjectState for Autocommit SBOs  */ 
       IF lAutoCommit THEN
         {set RowObjectState 'NoUpdates':U}.
    END.
    
    /* if Reset in autocommit or inside an SBO with autocommit ensure that 
       a potential rowObjUpd record left over from a failed save is rolled 
       back and deleted.  */  
    IF lAutoCommit THEN 
      RUN doUndoRow IN TARGET-PROCEDURE.
    
    {set DataModified FALSE}.
    publish 'dataAvailable':u from target-procedure ('same':U).
  END.

  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resortQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION resortQuery Procedure 
FUNCTION resortQuery RETURNS LOGICAL
  ( pcSort AS CHARACTER  ) :
/*------------------------------------------------------------------------------
  Purpose: Resorts the current query  
Parameter: pcSort - sort expression 
                    (see setQuerySort for details)
                  - Blank is remove all sort 
                  - ?  reset to default (BaseQuery).  
    Notes: if the query is closed the passed sort expression will be stored
           in the QueryString.    
          - SOrts locally,..... 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lOpen          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cRowIdent      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTargets       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTarget        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iTarget        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cDisabled      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOldSort       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewSort       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lQueryObject   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSort          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iRowsToBatch   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cOldDataString AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewDataString AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hRowObject     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataQuery     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowNum        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cBaseQuery     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lSBO           AS LOGICAL    NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get QueryOpen lOpen}
  {get RowsToBatch iRowsToBatch}
  .
  &UNDEFINE xp-assign

  /* if the query is open open we check the current sort to avoid resorting if 
     the same sort is applied (the sdo is literally bombarded by sort requests 
     on open... ) */
  IF lOpen THEN
    {get QuerySort cOldSort}.

  /* Store the new sort (also if not opened) */
  lSort = {set QuerySort pcSort}.
  IF lSort AND lOpen THEN
  DO:
    &SCOPED-DEFINE xp-assign 
    {get QuerySort cNewSort}
    {get Rowident cRowIdent}
    .
    &UNDEFINE xp-assign
    IF cNewSort <> cOldSort AND cRowIdent > "":U THEN
    DO:
      /* Sort locally if all data on client */
      IF {fn isDataQueryComplete} THEN
      DO:
        {get DataQueryString cOldDataString}.       
        /* if this is the first apply of local sorting we apply the oldsort 
           first, so that toggling can happen immediately */   
        IF cOldSort <> '':U AND {fnarg sortExpression cOldDataString} = '':U THEN
        DO:
          cOldDataString = DYNAMIC-FUNCTION('newQuerySort':U IN TARGET-PROCEDURE,
                                            cOldDataString,
                                            cOldSort,
                                            NO).
          /* if sort failed (i.e. db fields not in SDO) get the string again.. */
          IF cOldDataString = ? THEN
            {get DataQueryString cOldDataString}.       
        END.

        cNewDataString = DYNAMIC-FUNCTION('newQuerySort':U IN TARGET-PROCEDURE,
                                          cOldDataString,
                                          pcSort,
                                          NO).

        IF cNewDataString > '':U AND cNewDataString <> cOldDataString THEN
        DO:
          {set DataQueryString cNewDataString}.
          RUN reopenToRowid IN TARGET-PROCEDURE (?).
        END. /* if newdatastring <> olddatastring  */
      END. /* if isDataQueryComplete  (local sort) */
      ELSE 
      DO:
        &SCOPED-DEFINE xp-assign
        {get DataTarget cTargets}
        {get QueryContainer lSBO}
        .
        &UNDEFINE xp-assign
        
        /* We disable the data links to dataobjects as there is no need to 
           retrieve child data on the server, since we are going to end up 
           on the same record (unless inside an SBO, which are a more 
           hardwired, the whole SBO do for example start on server.., 
           dataAvailable messages goes through the SBO, so disabling the 
           link does not turn off all messages etc... Note that this seemingly  
           works in most SBO cases except for local 1-1, where the dependant 
           SDOs looses all data.... perhaps from the closeQuery?) */       
        IF NOT lSBO THEN
        DO iTarget = 1 TO NUM-ENTRIES(cTargets):
          hTarget = WIDGET-HANDLE(ENTRY(iTarget,cTargets)).
          IF VALID-HANDLE(hTarget) THEN
          DO:
            {get QueryObject lQueryObject hTarget}.
            IF lQueryObject THEN 
            DO:
              RUN linkStateHandler IN hTarget ("inactive":U,
                                               TARGET-PROCEDURE,
                                               "DataSource":U).
              cDisabled = cDisabled
                        + (IF iTarget = 1 THEN '':U ELSE ',':U)
                        + STRING(hTarget).
            END. /* QueryObject*/
          END. /* valid datatarget */
        END. /* Do iTarget = 1 to NUM-ENTRIES(cTargets) */        
        
        {fn closeQuery}.                      
        {fnarg fetchRowWhere cRowIdent}.
        
        RUN updateQueryPosition IN TARGET-PROCEDURE.

        /* ideally this is not necessary, but we have retrieved new data 
           from server, so as of current we ensure visual objects is in 
           synch (dataobject targets are still disabled) */ 
        PUBLISH 'dataAvailable':u FROM TARGET-PROCEDURE ('reset':U).
        {set NewBatchInfo '':U}.

        /* enable data link to targets again (SDOs in SBOs are not disabled) */ 
        IF NOT lSBO THEN
        DO iTarget = 1 TO NUM-ENTRIES(cDisabled):
          hTarget = WIDGET-HANDLE(ENTRY(iTarget,cDisabled)).
          IF VALID-HANDLE(hTarget) THEN
            RUN linkStateHandler IN hTarget ("active":U,
                                             TARGET-PROCEDURE,
                                            "DataSource":U).
        END. /* do iTarget = 1 to */
      END. /* else (do sort on server) */
    END. /* newsort <> oldsort and rowident > '' */
  END. /* if open */

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-retrieveBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION retrieveBatch Procedure 
FUNCTION retrieveBatch RETURNS LOGICAL
  ( pcMode AS CHAR,
    piNumRows AS INT ) :
/*------------------------------------------------------------------------------
  Purpose: Retrieve a new batch of data   
parameter: pcMode - Tells where to start retrieving in relation to current 
                    batch (and typically current record).
                    It also tells which record to position on after retrieval
                    Values:  
                    - 'NEXT'  - Retrieve next batch
                    - 'PREV'  - Retrieve prev batch
                    - 'LAST'  - Retrieve LAST batch (APPEND if not RebuildOnRepos!)
                    - 'FIRST' - Retrieve FIRST batch. Can only happen if RebuildOnRepos
                    - query expression  (from forward)
        piNumRows - Number of records to retrieve 
                    Special values:
                    - ? - use RowstoBatch
                    - 0 - read all data (not already on client) 
               
    Notes: Passes FillBatch to the server/service
    
           Override that wraps sendRows to allow the data class to reuse other 
           Dataview methods as-is. (The Dataview does not have sendrows) 
        - Currently called from rowvalues 
          (only if first record is on client )
        Future .. (to become more similar with dataview class implementation,
                   which does not implement fetchRowwhere .. )
          Can be merged with fetchRowWhere moving most of the logic in here..
          (fetchRowwhere could call this and keep the publish to the 
          browse and probably the find of current record in same batch on 
          failure  .. not sure since the logic to retrieve current batch 
          on failure is on server, so could also be moved here inside a 
          check on rebuild) 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lNext      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iRows      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lRebuild   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cRowident  AS CHARACTER  NO-UNDO INIT ?.
  DEFINE VARIABLE hRowObject AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataQuery AS HANDLE     NO-UNDO.

  IF pcMode = 'NEXT':U OR pcMode = 'LAST':U THEN
    lNext = TRUE.
  ELSE 
  IF pcMode = 'PREV':U OR pcMode = 'FIRST':U THEN
    lNext = FALSE. 

  IF pcMode = 'LAST':U THEN
  DO:
    {get RebuildOnRepos lRebuild}.
    /* last when not rebuild is like a next with ALL records */  
    IF NOT lRebuild THEN 
      piNumRows = 0. 
    ELSE 
      cRowident = 'LAST':U.  
  END.
  ELSE IF piNumRows = ? THEN
    {get RowsToBatch piNumRows}.
 
  RUN sendRows IN TARGET-PROCEDURE
              (?, 
               cRowident, 
               lNext, 
               IF lNext THEN piNumRows ELSE (piNumRows * -1),
               OUTPUT iRows).

  RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-submitRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION submitRow Procedure 
FUNCTION submitRow RETURNS LOGICAL
  ( pcRowIdent AS CHARACTER, pcValueList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Accepts a list of changed values for a row and ASSIGNs them,
               returning FALSE if any errors occur. 
               This is done only to the RowObject Temp-Table; 
               committing the changes back to the database is 
               a separate step, which will be invoked from here if 
               AutoCommit is set on.
 
  Parameters:
    INPUT pcRowIdent  - "key" with row to update.
                         The RowObject ROWID, typically derrived from the visual 
                         DataTarget's Rowident property, which often also 
                         has an additional list of the ROWID(s) of the db 
                         record(s). This appended list is not used here and is thus 
                         not required.  
                      - ?  indicates current record.    
    INPUT pcValueList - CHR(1) delimited list of alternating column names 
                        and values to be assigned.
 Notes: All current default usage of this API is intended to save data to 
        current record, although the visual Rowident is passed.                       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lReopen        AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cErrorMessages AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cUpdColumns    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hRowObject     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE rRowObject     AS ROWID     NO-UNDO.

  rRowObject = TO-ROWID(ENTRY(1, pcRowIdent)) NO-ERROR.
  
  {get RowObject hRowObject}.
  
  /* ? means current.. */
  IF pcRowident = ? THEN
    pcRowident = STRING(hRowObject:ROWID).  

  IF NOT hRowObject:AVAILABLE OR rRowObject NE hRowObject:ROWID THEN 
  DO:
    hRowObject:FIND-BY-ROWID(rRowObject) NO-ERROR.
    IF NOT hRowObject:AVAILABLE THEN
    DO:
      /* Add the update cancelled message */
      RUN addMessage IN TARGET-PROCEDURE({fnarg messageNumber 15},?,?).
      /* Add the ... not found message .. */ 
      RUN addMessage IN TARGET-PROCEDURE
         (SUBSTITUTE(DYNAMIC-FUNCTION('messageNumber':U IN TARGET-PROCEDURE,29),
                    {fn getTables},
                    'ROWID ':U 
                     + (IF pcRowident = ? THEN '?':U ELSE string(rRowObject))
                    ),
          ?, 
          ?).
      RETURN FALSE.
    END.
  END. /* not avail or passed rowid mismatch */ 
  {get UpdatableColumns cUpdColumns}.
  /* Assign Foreign Key values if needed for new records. */
  RUN submitForeignKey IN TARGET-PROCEDURE
                        (INPUT pcRowIdent,
                         INPUT-OUTPUT pcValueList,
                         INPUT-OUTPUT cUpdColumns).
  /* Create a "before" row in the Update table for an Update, or create a new
     row in the RowObject table for an Add/Copy. */
  RUN doCreateUpdate IN TARGET-PROCEDURE 
                        (INPUT pcRowIdent, 
                         INPUT pcValueList,
                         OUTPUT lReopen, 
                         OUTPUT cErrorMessages).
  
 
  IF cErrorMessages NE "":U THEN
    RETURN FALSE.  
  /* Perform any validation on individual columns. */
  RUN submitValidation In TARGET-PROCEDURE (pcValueList, cUpdColumns).
  
  /* Undo the update if there are errors; else commit if AutoCommit. */
  RUN submitCommit In TARGET-PROCEDURE (pcRowIdent, lReopen).
  
  RETURN RETURN-VALUE NE "ADM-ERROR":U.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-undoRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION undoRow Procedure 
FUNCTION undoRow RETURNS LOGICAL
  ( pcRowident AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Undo the specified rowobject record   
           To a state of unchanged. 
Parameter: pcRowident 
               - Rowobject rowid 
               - ?  will undo current.    
    Notes: undo of deleted rows is not handled here.
           undo of created row is handled by deleteRow
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRowObjUpd    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowObjUpd2   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lDataModified AS LOGICAL   NO-UNDO.

  /* Don't assume rowid as param, call matching function */ 
  IF pcRowIdent <> ? THEN 
    {fnarg repositionRowobject pcRowident}. 

  RUN doUndoRow IN TARGET-PROCEDURE.

  {get RowObjUpd hRowObjUpd}.
  IF VALID-HANDLE(hRowObjUpd) THEN
  DO:
    /* If the undone was the only uncommitted change then 
     set RowObjectState to 'NoUpdates' */
    CREATE BUFFER hRowObjUpd2 FOR TABLE hRowObjUpd.
    hRowObjUpd2:FIND-FIRST() NO-ERROR.
    IF NOT hROwObjUpd2:AVAIL THEN 
      {set RowObjectState 'NoUpdates':U}.

    DELETE OBJECT hRowObjUpd2.
  END. /* valid rowobjupd */
    
  /* if modified don't publish. 
     The modifier (updatetarget) is responsible of redisplay when the state is 
     turned off */
  {get DataModified lDataModified}.
  IF NOT lDataModified THEN
  DO:
    PUBLISH "dataAvailable":U FROM TARGET-PROCEDURE ('SAME':U).
    {set NewBatchInfo '':U}.
  END.

  /* always true.. state is undone */
  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION updateRow Procedure 
FUNCTION updateRow RETURNS LOGICAL
  (pcKeyValues AS CHAR,
   pcValueList AS CHAR) :
/*------------------------------------------------------------------------------
   Purpose: Update an existing row 
Parameters: pcKeyValues - comma separated or chr(1) separated list of keyvalues
                          ? - update current row
            pcValueList - CHR(1) delimited list of alternating column names 
                          and values to be assigned.
     Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lOk       AS LOG    NO-UNDO.
  DEFINE VARIABLE cRowIdent AS CHAR   NO-UNDO.
  DEFINE VARIABLE lNewRow   AS LOG    NO-UNDO.

  IF pcKeyValues <> ? THEN 
  DO:
    lOk = DYNAMIC-FUNCTION('findRow':U IN TARGET-PROCEDURE,
                           pcKeyValues).
    IF NOT lOk THEN
      RETURN FALSE.
  END.

  cRowIdent = ENTRY(1,DYNAMIC-FUNCTION('colValues' IN TARGET-PROCEDURE,'':U),
                    CHR(1)).
  
  IF cRowIdent = ? THEN
    RETURN FALSE.

  {get NewRow lNewRow}.

  lOk = DYNAMIC-FUNCTION("submitRow":U IN TARGET-PROCEDURE, 
                          cRowIdent, 
                          pcValueList).

  IF lNewRow AND NOT lok THEN
    DYNAMIC-FUNCTION('cancelRow':U IN TARGET-PROCEDURE).  
  
  RETURN lOk.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

