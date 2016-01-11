&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/******************************************************************************/
/* Copyright (c) 2005,2006 Progress Software Corporation, All rights reserved.*/
/******************************************************************************/
/*------------------------------------------------------------------------
    File        : adm2/datacontainer.p
    Purpose     : Manages data and data requests including batching for dataview 
                  objects.  

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       : The data container communicates with the Service Adapter, 
                  as the connector between this and a standard service.    
                  The ADM issues all requests to this so from the ADM's 
                  perspective this is the data service 
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/*
&Scoped-define PROCEDURE-TYPE SmartContainer
&Scoped-define DB-AWARE NO
&Scoped-define ADM-CONTAINER VIRTUAL
&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,OutMessage-Source,OutMessage-Target
*/
CREATE WIDGET-POOL.

DEFINE VARIABLE ghService AS HANDLE     NO-UNDO.
/* exclude included function in order to override here, undefined in main-block */
&SCOPED-DEFINE exclude-getobjecttype

/* This TT is used to keep track of the requested datasets.
   This could/may be replaced by making the datasets into container targets
   of the requestor. Note that the current implementation also allows
   non-containers to own a dataset though */
DEFINE TEMP-TABLE ttDataset NO-UNDO
  FIELD Requestor        AS HANDLE
  FIELD DatasetName      AS CHARACTER
  FIELD BusinessEntity   AS CHARACTER
  FIELD DatasetProcedure AS HANDLE
  INDEX Requestor AS PRIMARY UNIQUE Requestor DatasetName BusinessEntity
  INDEX DatasetProcedure DatasetProcedure.

DEFINE TEMP-TABLE ttError NO-UNDO
  FIELD TableName      AS CHARACTER
  FIELD ChgHandle      AS HANDLE  
  FIELD ChgRowid       AS ROWID 
  FIELD IsConflict     AS LOGICAL 
  FIELD IsError        AS LOGICAL 
  FIELD IsRejected     AS LOGICAL 
  INDEX Change   AS PRIMARY UNIQUE ChgHandle ChgRowid
  INDEX TableIDx TableName.

/* Note: the current relationship to ttDataset is using 3 fields...,
         this is however not exposed in code, so not a big deal..
         Can also be changed without code changes 
         ( OF is being used in code, the assumption being that no amateur 
           adds ambiguous relations..)  */  
DEFINE TEMP-TABLE ttDataTable NO-UNDO
  FIELD Requestor        AS HANDLE
  FIELD DatasetName      AS CHARACTER
  FIELD BusinessEntity   AS CHARACTER
  FIELD DataTable        AS CHARACTER 
  FIELD RequestType      AS CHARACTER
  FIELD NumRows          AS INTEGER
  FIELD NextContext      AS CHARACTER
  FIELD PrevContext      AS CHARACTER
  INDEX DataTable AS PRIMARY 
    UNIQUE Requestor DatasetName BusinessEntity DataTable.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-cloneDataset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD cloneDataset Procedure 
FUNCTION cloneDataset RETURNS CHARACTER
  ( phDatasetProcedure AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyDataset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD destroyDataset Procedure 
FUNCTION destroyDataset RETURNS LOGICAL
  ( phDatasetProcedure AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getChangePrefix) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getChangePrefix Procedure 
FUNCTION getChangePrefix RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDatasetProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDatasetProcedure Procedure 
FUNCTION getDatasetProcedure RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectType Procedure 
FUNCTION getObjectType RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRequestDelimiter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRequestDelimiter Procedure 
FUNCTION getRequestDelimiter RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getServiceAdapter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getServiceAdapter Procedure 
FUNCTION getServiceAdapter RETURNS HANDLE
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTableDelimiter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTableDelimiter Procedure 
FUNCTION getTableDelimiter RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newDataset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD newDataset Procedure 
FUNCTION newDataset RETURNS HANDLE
  ( phDataset AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-originDataset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD originDataset Procedure 
FUNCTION originDataset RETURNS CHARACTER
  ( phDatasetProcedure AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-relationFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD relationFields Procedure 
FUNCTION relationFields RETURNS CHARACTER
  ( pcRelationFields AS CHAR,
    pcEntityNames    AS CHAR)  FORWARD.

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
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

&UNDEFINE exclude-getobjecttype

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-datasetDestroyed) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE datasetDestroyed Procedure 
PROCEDURE datasetDestroyed :
/*------------------------------------------------------------------------------
  Purpose:   Subscribed to destroyObject in newdataset   
  Parameters:  <none>
  Notes:     This is subscribed to destroyObject in the dataset to ensure 
             that datasets deleted separately is noticed.  
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttDataset FOR ttDataset.

  FIND bttDataset WHERE bttDataset.DatasetProcedure = SOURCE-PROCEDURE NO-ERROR.
  IF AVAIL bttDataset THEN
    DELETE bttDataset.
                                       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:    Clean up started datasets after calling super  
  Parameters: <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttDataset FOR ttDataset.
  
  RUN SUPER. 
  IF RETURN-VALUE <> 'adm-error':U  THEN
  FOR EACH bttDataset:    
    {fnarg destroyDataset bttDataset.DatasetProcedure}.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyRequestorDatasets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyRequestorDatasets Procedure 
PROCEDURE destroyRequestorDatasets :
/*------------------------------------------------------------------------------
  Purpose: Clean up dataset for a requestor (source of this event)
  Parameters:  <none>
  Notes:   subscribed to requestor's destroyObject     
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttDataset FOR ttDataset.

  FOR EACH bttDataset WHERE bttDataset.Requestor = SOURCE-PROCEDURE:    
    {fnarg destroyDataset bttDataset.DatasetProcedure}.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disable_ui) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_ui Procedure 
PROCEDURE disable_ui :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-retrieveData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retrieveData Procedure 
PROCEDURE retrieveData :
/*------------------------------------------------------------------------------
  Purpose:    Retrieve data from the service  
  Parameters:   phRequestor      - The requesting object passes its handle,
                                   which is used as the key to identify the 
                                   scope of the dataset.
                                   The new dataset procedure subscribes to the 
                                   requesting object's destroyObject event, but 
                                   is not added as a container target. 
                                   (the requestor may be the actual dataview)
                plRefresh        - Refresh, empties existing data 
                plAppend         - Append to existing data. This is the 
                                   equivalent of RebuildOnReposition, except 
                                   for NEXT and PREV which currently always 
                                   appends. 
                                   The reason why there are both an Refresh
                                   and Append is that it is valid to have a 
                                   refresh = yes and append = yes which means 
                                   start from top (Pass 'FIRST' in the 
                                   navcontext to the service adapter)                                                        
                plFill           - fill batch
               --- one entry per table ------- 
    
                pcRequests       - chr(1) separated (may have query with comma)
                pcDataTables     - Comma separated list of tables                                       
                pcQueries        - chr(1) separated ( query may have comma)
                pcBatchSizes     - Comma separated list of tables
                pcForeignFields  - chr(1) separated ( has comma)
                pcPositionFields - chr(1) separated ( has comma)
                pcContext        - chr(1) separated  
               -- one entry per dataset  ---  
                pcDatasetSources - Comma separated list of dataset procedures
                                   ? on first request 
                pcEntities       - Comma separated list of entities 
                pcEntityNames    - Comma separated list of entity instance names
                            
  Notes:   
------------------------------------------------------------------------------*/  
  DEFINE INPUT PARAMETER phRequestor      AS HANDLE     NO-UNDO.
  DEFINE INPUT PARAMETER plRefresh        AS LOGICAL    NO-UNDO.
  DEFINE INPUT PARAMETER plAppend         AS LOGICAL    NO-UNDO.
  DEFINE INPUT PARAMETER plFill           AS LOGICAL    NO-UNDO.
  DEFINE INPUT PARAMETER pcRequests       AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcDataTables     AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcQueries        AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcBatchSizes     AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcForeignFields  AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcPositionFields AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcContext        AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcDatasetSources AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcEntities       AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcEntityNames    AS CHARACTER  NO-UNDO.

     /* Define extents to pass to the service adapter */
  DEFINE VARIABLE hDataset        AS HANDLE     NO-UNDO EXTENT.
  DEFINE VARIABLE cEntity         AS CHARACTER  NO-UNDO EXTENT.
  DEFINE VARIABLE cDataTables     AS CHARACTER  NO-UNDO EXTENT.
  DEFINE VARIABLE cQueries        AS CHARACTER  NO-UNDO EXTENT.
  DEFINE VARIABLE cNumRecords     AS CHARACTER  NO-UNDO EXTENT.
  DEFINE VARIABLE cJoins          AS CHARACTER  NO-UNDO EXTENT.
  DEFINE VARIABLE cPositions      AS CHARACTER  NO-UNDO EXTENT.
  DEFINE VARIABLE cRequests       AS CHARACTER  NO-UNDO EXTENT.
  DEFINE VARIABLE cContextLists   AS CHARACTER  NO-UNDO EXTENT.
  /* to be returned from service adapter */ 
  DEFINE VARIABLE cStartPosition  AS CHARACTER  NO-UNDO EXTENT.
  DEFINE VARIABLE cEndPosition    AS CHARACTER  NO-UNDO EXTENT.

  /* support extents */
  DEFINE VARIABLE hDSProcedure    AS HANDLE     NO-UNDO EXTENT.
  
  DEFINE VARIABLE cNavContext     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iNumEntities    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iNumTables      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iTable          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTable          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRequest        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTableContext   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iEntity         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cEntityName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignField   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPosField       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lFirstTable     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lAddTable       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iTablePos       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cPrev           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNext           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAppendBatch    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iNumRecords     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cDlmTable       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDlmRequest     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDlmADM         AS CHARACTER  NO-UNDO.

 /* DEFINE VARIABLE iNumRecords     AS INTEGER    NO-UNDO.*/

  DEFINE BUFFER bDataset   FOR TEMP-TABLE ttDataset.
  DEFINE BUFFER bDataTable FOR TEMP-TABLE ttDataTable.

  ASSIGN
    iNumEntities = NUM-ENTRIES(pcEntityNames)  
    iNumTables   = NUM-ENTRIES(pcDataTables)
    cDlmRequest  = {fn getRequestDelimiter}
    cDLmTable    = {fn getTableDelimiter}
    cDlmADM      = CHR(1).
  
  IF iNumEntities = 0  THEN
    RETURN. 

  /* Dim the input(-output) extent parameters */
  RUN adecomm/_dimextent.p(iNumEntities, OUTPUT hDataset).
  RUN adecomm/_dimextent.p(iNumEntities, OUTPUT cEntity).
  RUN adecomm/_dimextent.p(iNumEntities, OUTPUT cDataTables).
  RUN adecomm/_dimextent.p(iNumEntities, OUTPUT cQueries).
  RUN adecomm/_dimextent.p(iNumEntities, OUTPUT cNumRecords).
  RUN adecomm/_dimextent.p(iNumEntities, OUTPUT cPositions).
  RUN adecomm/_dimextent.p(iNumEntities, OUTPUT cJoins).
  RUN adecomm/_dimextent.p(iNumEntities, OUTPUT cRequests). 
  RUN adecomm/_dimextent.p(iNumEntities, OUTPUT cContextLists). 
  
  RUN adecomm/_dimextent.p(iNumEntities, OUTPUT hDSProcedure). 

  IF pcDataTables = '' THEN
  DO:
    IF pcRequests = 'DEFS':U THEN
    DO iEntity = 1 TO iNumEntities:
      ASSIGN
        cEntity[iEntity]  = ENTRY(iEntity,pcEntities)
        cRequests[iEntity] = 'DEFS':U         
        hDataset[iEntity] = ?.
    END.
    ELSE RETURN ERROR.
  END.
  ELSE
  DO iTable = 1 TO iNumTables:    
    ASSIGN 
      lAddTable    = FALSE 
      iTablePos    = 0
      cRequest     = ENTRY(iTable,pcRequests,cDlmADM)
      cTable       = ENTRY(iTable,pcDataTables)
      cEntityName  = ENTRY(1,cTable,'.':U)
      cTable       = ENTRY(2,cTable,'.':U)
      iEntity      = LOOKUP(cEntityName,pcEntityNames)
      lFirstTable  = cDataTables[iEntity] = ''.

    IF cEntity[iEntity] = '' THEN
      ASSIGN 
        cEntity[iEntity]      = ENTRY(iEntity,pcEntities)
        hDSProcedure[iEntity] = WIDGET-HANDLE(ENTRY(iEntity,pcDatasetSources)).
    
    FIND bDataTable WHERE bDataTable.Requestor = phRequestor
                    AND   bDataTable.DatasetName = cEntityName
                    AND   bDataTable.BusinessEntity = ENTRY(iEntity,pcEntities)
                    AND   bDataTable.DataTable = cTable
                    NO-ERROR.
    /* first request for this entity and table(s) */
    IF NOT VALID-HANDLE(hDSProcedure[iEntity]) THEN
    DO: 
      hDataset[iEntity] = ?.
      /* next, prev and last requests are currently only allowed on existing data 
         (We may loosen this restriction, at least for last requests) */
      IF cRequest = 'ALL':U OR cRequest = 'DEFS':U OR cRequest = 'FIRST':U OR cRequest BEGINS 'WHERE ':U THEN
      DO:
        /* If this table and dataset is already requested either in a previous 
           request or another entry in this request, we ensure that it is a 
           request that indicates that it is legal, either for the same object
           or a child object.  */            
        IF AVAIL bDataTable THEN
        DO:
          /* Deny request from separate object than an earlier request */
          IF cRequest = 'DEFS':U
          OR (    bDataTable.RequestType <> 'DEFS':U  
              AND bDataTable.RequestType <> 'ALL':U) THEN
          DO:
            RETURN ERROR
             'Duplicate request "' + cRequest 
             + '" for "' 
             + cEntityName + '" "' + cTable  + '". '
             + 'A "' + bDataTable.RequestType + '" request has already been issued by '
             +  phRequestor:FILE-NAME + '.'.

          END.
          ELSE DO:
             /* Check if the table is part of this request (could be a 
               viewTable of another object) in which case we do some 
               changes to current criteria below. Otherwise the table is 
               not added as we can use existing data. */
            iTablePos = LOOKUP(cTable,cDataTables[iEntity],cDlmTable).

          END.
        END.
        ELSE 
          lAddTable = TRUE.
      END. /* if crequest = ..OR OR . */
      ELSE 
        RETURN ERROR
         'Invalid dataset for request "' + cRequest + '" for "' + cTable  + '"'.
    END. /* first request (not valid dataset procedure)  */
    ELSE 
    DO:
      lAddTable = TRUE.
      {get DatasetHandle hDataset[iEntity] hDSProcedure[iEntity]}.
      /* If this is the first requested table and entity then store or empty 
         batch */
      IF iEntity = 1 AND lFirstTable THEN
      DO:
        IF cRequest = 'PREV':U THEN
          cNavContext = {fnarg tablePrevContext cTable hDSProcedure[iEntity]}.
        ELSE IF cRequest = 'NEXT':U THEN
          cNavContext = {fnarg tableNextContext cTable hDSProcedure[iEntity]}.        
        ELSE IF plAppend THEN
        DO:
          IF NOT plRefresh THEN
            cNavContext = {fnarg tableNextContext cTable hDSProcedure[iEntity]}.        
          IF cNavContext = '':U THEN
            cNavContext = 'FIRST':U. 
        END. /* if plappend */
        IF plAppend AND NOT plRefresh THEN
          {fnarg storeBatch cTable hDSProcedure[iEntity]}.
        ELSE  
          {fnarg emptyBatch cTable hDSProcedure[iEntity]}.
      END. /* first table of entity in this equest */
      ELSE IF iEntity = 1 THEN
      DO:
        /* Ensure that secondary tables in the first entity also are emptied 
           when necessary. */
        IF NOT plAppend OR plRefresh THEN
        DO:
          /* A secondary non-child table must be emptied. 
            (if append it will have been stored away by storebatch above 
             and merged after the request) */    
          IF LOOKUP(cTable,
                   {fnarg childTables ENTRY(1,pcDataTables) hDSProcedure[iEntity]}
                   ) = 0 THEN 
            {fnarg emptyBatch cTable hDSProcedure[iEntity]}.
        END.
        /* Appending parent; empty child tables if not 'ALL' mode (keep them
           if 'ALL' mode). 
           (non appending parent takes care of this through emptyBatch above) */
        ELSE IF cRequest <> 'ALL':U THEN
        DO:
          IF LOOKUP(cTable,
               {fnarg childTables ENTRY(1,pcDataTables) hDSProcedure[iEntity]}
               ) > 0 THEN 
          {fnarg emptyBatch cTable hDSProcedure[iEntity]}.
        END.
      END.
      ELSE        
        /* currently just empty (could possibly check if current data is 
              complete for position dataviews)*/ 
        {fnarg emptyBatch cTable hDSProcedure[iEntity]}.
     
    END.  /* else (valid dataset)*/
    
    IF NOT AVAIL bDataTable THEN
    DO:
      CREATE bDataTable.
      ASSIGN bDataTable.Requestor   = phRequestor
             bDataTable.DatasetName = cEntityName
             bDataTable.BusinessEntity = ENTRY(iEntity,pcEntities)
             bDataTable.DataTable = cTable.
    END.

    ASSIGN
      bDataTable.RequestType = cRequest
      cForeignField  = DYNAMIC-FUNCTION('relationFields':U IN TARGET-PROCEDURE,
                                         ENTRY(iTable,pcForeignFields,cDlmADM),
                                         pcEntityNames) 
      cPosField      = DYNAMIC-FUNCTION('relationFields':U IN TARGET-PROCEDURE,
                                         ENTRY(iTable,pcPositionFields,cDlmADM),
                                         pcEntityNames)
      cTableContext  = (IF NUM-ENTRIES(pcContext) >= iTable 
                        THEN ENTRY(iTable,pcContext,cDlmADM)
                        ELSE '':U). 
   
    IF lAddTable THEN
      ASSIGN
        cDataTables[iEntity]   = cDataTables[iEntity] 
                               + (IF lFirstTable THEN '':U ELSE cDlmTable) 
                               +  cTable
        cNumRecords[iEntity]   = cNumRecords[iEntity] 
                               + (IF lFirstTable THEN '':U ELSE cDlmTable) 
                               + ENTRY(iTable,pcBatchSizes) 
        cQueries[iEntity]      = cQueries[iEntity] 
                               + (IF lFirstTable THEN '':U ELSE cDlmRequest) 
                               + ENTRY(iTable,pcQueries,cDlmADM)
        cRequests[iEntity]     = cRequests[iEntity] 
                               + (IF lFirstTable THEN '':U ELSE cDlmRequest) 
                               + cRequest
        cJoins[iEntity]        = cJoins[iEntity] 
                               + (IF lFirstTable THEN '':U ELSE cDlmRequest) 
                               + cForeignField      
        cPositions[iEntity]    = cPositions[iEntity] 
                               + (IF lFirstTable THEN '':U ELSE cDlmRequest) 
                               + cPosField 
        /* if no context ensure adapter also receives blank */
        cContextLists[iEntity] = IF pcContext = '' THEN '' 
                                 ELSE (cContextLists[iEntity]
                                      + (IF lFirstTable THEN '':U ELSE cDlmRequest) 
                                      + cTablecontext).   
    /* second entry for same table is legal in some cases (handled above)          
       We deliberately avoid setting the query as we need all data and 
       also ensure that rowstobatch is 0  */
    ELSE IF iTablePos > 0 THEN
    DO:
      ASSIGN 
        ENTRY(iTablePos,cNumRecords[iEntity])      = '0':U
        ENTRY(iTablePos,cRequests[iEntity],cDlmRequest)  = cRequest
        ENTRY(iTablePos,cPositions[iEntity],cDlmRequest) = cPosField
        ENTRY(iTablePos,cJoins[iEntity],cDlmRequest)     = cForeignField.
      IF pcContext > '':U THEN
        ENTRY(iTablePos,cContextLists[iEntity],cDlmRequest) = cTableContext.
    END.

  END.  /* do iTable = 1 to iNumTables */
  
  /* avoid request if none of the tables needed data */
  IF cDataTables[1] > '' OR pcRequests = 'DEFS':U THEN
  DO:
    RUN retrieveData IN {fn getServiceAdapter}
                            (cEntity,
                             cDataTables,
                             cQueries,
                             cJoins,
                             cPositions,
                             cRequests,
                             cNavContext,
                             plFill,
                             INPUT-OUTPUT cNumRecords,
                             INPUT-OUTPUT hDataset,  
                             INPUT-OUTPUT cContextLists,
                             OUTPUT cStartPosition,
                             OUTPUT cEndPosition) NO-ERROR.
    
    IF ERROR-STATUS:ERROR THEN
    DO:
      RETURN ERROR IF RETURN-VALUE > '' 
                   THEN RETURN-VALUE 
                   ELSE ERROR-STATUS:GET-MESSAGE(1).
    END.
    DO iEntity = 1 TO iNumEntities:
      IF NOT VALID-HANDLE(hDSProcedure[iEntity]) THEN
      DO:    
        IF NOT VALID-HANDLE(hDataset[iEntity]) THEN
        DO:
          RETURN ERROR 'Could not retrieve dataset for entity "' 
                     + entry(iEntity,pcEntities) + '"'.
        END.
  
        hDSprocedure[iEntity] = {fnarg newDataset hDataset[iEntity]}.
        /* all smart objects publish destroyobject */
        SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO 'destroyObject':U IN phRequestor
          RUN-PROCEDURE "destroyRequestorDatasets":U.
        CREATE bDataset.
        ASSIGN 
          bDataset.Requestor        = phRequestor
          bDataset.DatasetName      = ENTRY(iEntity,pcEntityNames)
          bDataset.BusinessEntity   = ENTRY(iEntity,pcEntities)
          bDataset.DatasetProcedure = hDSprocedure[iEntity].
      END. /* not valid dataset procedure */
  
      DO iTable = 1 TO NUM-ENTRIES(cDataTables[iEntity],cDlmTable):
        ASSIGN
          cTable        = ENTRY(iTable,cDataTables[iEntity],cDlmTable)
          cRequest      = ENTRY(iTable,cRequests[iEntity],cDlmRequest)
          cTableContext = (IF NUM-ENTRIES(cContextLists[iEntity],cDlmRequest) >= iTable 
                           THEN ENTRY(iTable,cContextLists[iEntity],cDlmRequest)
                           ELSE '':U)
          .
        
        IF iEntity = 1 AND iTable = 1 AND plAppend AND NOT plRefresh THEN
          {fnarg mergeBatch cTable hDSProcedure[iEntity]}.
        
        IF cRequest <> 'DEFS':U THEN
        DO:
          /* 'ALL' - default dataset child retrieval, 
              we have all data if scrollable and don't know if not */  
          IF cRequest = 'ALL':U THEN
          DO:
            lAppendBatch = FALSE.
            IF {fnarg isScrollable cTable hDSProcedure[iEntity]} THEN
              ASSIGN
                cPrev = '' 
                cNext = ''.
            ELSE 
              ASSIGN
                cPrev = ?
                cNext = ?. 
          END.
          ELSE
            ASSIGN
              lAppendBatch = iEntity = 1 AND iTable = 1 AND plAppend AND NOT plRefresh                     
              cPrev = IF NUM-ENTRIES(cStartPosition[iEntity],cDlmTable) >= iTable 
                      THEN ENTRY(iTable,cStartPosition[iEntity],cDlmTable)
                      ELSE '':U
              cNext = IF NUM-ENTRIES(cEndPosition[iEntity],cDlmTable) >= iTable 
                      THEN ENTRY(iTable,cEndPosition[iEntity],cDlmTable)
                      ELSE '':U.

          iNumRecords = INT(ENTRY(iTable,cNumRecords[iEntity],cDlmTable)). 
          
          DYNAMIC-FUNCTION('assignTableInformation':U IN hDSProcedure[iEntity],
                     cTable,
                     cTableContext,
                     /* append */
                     iEntity = 1 AND iTable = 1 AND plAppend AND NOT plRefresh,
                     cRequest <> 'PREV':U, /* forward */
                     cPrev,
                     cNext,
                     iNumRecords).
        END.
        ELSE 
          DYNAMIC-FUNCTION('assignTableContext':U IN hDSProcedure[iEntity],
                           cTable,cTableContext).


      END.  /* do iTable = 1 to */    
    END. /* do iEntity = 1 to  */
  END. /* if any tables requested */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-retrieveDataset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retrieveDataset Procedure 
PROCEDURE retrieveDataset :
/*------------------------------------------------------------------------------
  Purpose: Retrieve the dataset handle for the specified requestor 
           datasetinstance and entitydefintion pouirposes    
  Parameters: 
            phRequestor   - The requesting object passes its handle,
                            which currently is used as the key to 
                            identify the scope of the dataset.
            pcEntity      - The entity name as known by the service
            pcEntityName  - The entity name for this instance.
  Notes:    Called from a dataview's createObjects    
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phRequestor   AS HANDLE     NO-UNDO.
DEFINE INPUT  PARAMETER pcEntity      AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcEntityName  AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER phDataset     AS HANDLE     NO-UNDO.

 DEFINE BUFFER bttDataset FOR ttDataset.

 FIND bttDataset WHERE bttDataset.Requestor      = phRequestor
                 AND   bttDataset.BusinessEntity = pcEntity
                 AND   bttDataset.DatasetName    = pcEntityName
                 NO-ERROR.
 
 IF NOT AVAIL bttDataset THEN
 DO:
   RUN retrieveData IN {fn getDataContainerHandle}
                         (phRequestor,
                          NO,
                          NO,
                          NO,
                          'DEFS':U,  /* requests */
                          '',       /* table */
                          'DEFS':U, /* queries */
                          '':U,
                          '':U,
                          '':U,
                          '':U,
                          ?,
                          pcEntity,
                          pcEntityName).

   IF ERROR-STATUS:ERROR THEN
   DO:
     RETURN ERROR IF RETURN-VALUE > '' 
                  THEN RETURN-VALUE 
                  ELSE ERROR-STATUS:GET-MESSAGE(1).
   END.

   FIND bttDataset WHERE bttDataset.Requestor      = phRequestor
                   AND   bttDataset.BusinessEntity = pcEntity
                   AND   bttDataset.DatasetName    = pcEntityName
                   NO-ERROR.
 END. /* not avail bttDataset */

 IF AVAIL bttDataset THEN 
   phDataset = bttDataset.DatasetProcedure.
  
 RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-submitDataset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE submitDataset Procedure 
PROCEDURE submitDataset :
/*------------------------------------------------------------------------------
  Purpose:    Submit changes for a dataset     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phDatasetSource  AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER pcEntity         AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcDataTable      AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcContext        AS CHARACTER  NO-UNDO.
  
  DEFINE OUTPUT PARAMETER plSuccess        AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE hQuery       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cBuffer      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hBuffer      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBefore      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hChgBuffer   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hChgBefore   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iBuffer      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cError       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataset     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE rRowid       AS ROWID      NO-UNDO EXTENT.
  
  DEFINE VARIABLE cChangePrefix   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSubmitTables   AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cContext        AS CHARACTER EXTENT 1 NO-UNDO.
  DEFINE VARIABLE cEntity         AS CHARACTER EXTENT 1 NO-UNDO.
  DEFINE VARIABLE hChangedDataset AS HANDLE    EXTENT 1 NO-UNDO.
  
  CREATE DATASET hChangedDataset[1].

  {get ChangePrefix cChangePrefix}.

  {get DatasetHandle hDataset phDatasetSource}.
  
  /* dim the rowid */
  hChangedDataset[1]:CREATE-LIKE(hDataSet, cChangePrefix).
  cContext[1] = pcContext.
  cSubmitTables = RIGHT-TRIM(pcDataTable 
                             + ',':U
                             + {fnarg childTables pcDataTable phDatasetSource},','). 

  RUN adecomm/_dimextent.p(NUM-ENTRIES(cSubmitTables),OUTPUT rRowid).

  DO iBuffer = 1 TO NUM-ENTRIES(cSubmitTables):
    ASSIGN
      cBuffer = ENTRY(iBuffer,cSubmitTables)
      hBuffer = {fnarg dataTableHandle cBuffer phDatasetSource}.

    IF VALID-HANDLE(hBuffer:BEFORE-BUFFER) THEN
    DO:
      rRowid[iBuffer] = hBuffer:ROWID.
      hBuffer:TABLE-HANDLE:TRACKING-CHANGES = FALSE. 
      hChangedDataset[1]:GET-BUFFER-HANDLE(cChangePrefix +  hBuffer:NAME):GET-CHANGES(hBuffeR /*, TRUE*/).   
    END.
  END.
  
  cEntity[1] = pcEntity.
  RUN submitData IN {fn getServiceAdapter}
                            (cEntity,
                             INPUT-OUTPUT hChangedDataset,
                             INPUT-OUTPUT cContext) NO-ERROR.
  IF ERROR-STATUS:ERROR THEN
  DO:
    MESSAGE 'Data was not saved due to an unexpexted error:' SKIP(1)
            IF RETURN-VALUE > '' 
            THEN RETURN-VALUE 
            ELSE ERROR-STATUS:GET-MESSAGE(1).
    plSuccess = false.             
  END.
  ELSE 
  DO:
    IF cContext[1] > '' THEN
      DYNAMIC-FUNCTION('assignTableContext':U IN phDatasetSource,
                           pcDataTable,cContext[1]).

    /* Check the ERROR status that might have been returned. */
    IF hChangedDataset[1]:ERROR THEN
    DO:
      plSuccess = FALSE. 
      CREATE QUERY hQuery.
      DO iBuffer = 1 TO NUM-ENTRIES(cSubmitTables):
        ASSIGN
          cBuffer    = ENTRY(iBuffer,cSubmitTables)
          hBuffer    = {fnarg dataTableHandle cBuffer phDatasetSource}
          hBefore    = hBuffer:BEFORE-BUFFER
          hChgBuffer = hChangedDataset[1]:GET-BUFFER-HANDLE(cChangePrefix +  hBuffer:NAME) 
          hChgBefore = hChgBuffer:BEFORE-BUFFER
          .
        IF VALID-HANDLE(hChgBefore) THEN
        DO:
          hQuery:SET-BUFFERS(hChgBefore).
          hQuery:QUERY-PREPARE('FOR EACH ':U + hChgBefore:NAME ).
          hQuery:QUERY-OPEN().
          hQuery:GET-FIRST.
          DO WHILE hChgBefore:AVAIL:
            CREATE ttError.
            ASSIGN  
              ttError.TableName  = hBuffer:NAME
              ttError.ChgHandle  = hChgBefore
              ttError.ChgRowid   = hChgBefore:ROWID
              ttError.IsError    = hChgBefore:ERROR 
              ttError.IsRejected = hChgBefore:REJECTED
              ttError.IsConflict = hChgBefore:DATA-SOURCE-MODIFIED
              .
            IF hChgBefore:ERROR-STRING > '' THEN
              RUN addMessage IN TARGET-PROCEDURE(hChgBefore:ERROR-STRING,
                                                 ?,
                                                 hBuffer:NAME).
            hQuery:GET-NEXT.
          END.  /* do while hChgbefore avail */
        END. /* valid hChgbefore */
      END. /* DO iBuffer = 1 to num */
      /* Accept changes that was successful (submit.. is not necessarily commit)  */
      FOR EACH ttError WHERE ttError.Iserror = FALSE
                       AND   ttError.IsRejected = FALSE
                       AND   ttError.IsConflict = FALSE:
        hBefore = ttError.ChgHandle:TABLE-HANDLE:ORIGIN-HANDLE:DEFAULT-BUFFER-HANDLE.
        ttError.ChgHandle:FIND-BY-ROWID(ttError.ChgRowid).
        hBefore:FIND-BY-ROWID(ttError.ChgHandle:ORIGIN-ROWID).
        DO TRANSACTION: 
          hBefore:ACCEPT-CHANGES().
        END.
      END.
      EMPTY TEMP-TABLE ttError. 
      DELETE OBJECT hQuery.
    END. /* IF hChangedDataset[1]:ERROR  */
    ELSE 
      plSuccess = TRUE.

    DO iBuffer = 1 TO NUM-ENTRIES(cSubmitTables):
      ASSIGN
        cBuffer = ENTRY(iBuffer,cSubmitTables)
        hBuffer = {fnarg dataTableHandle cBuffer phDatasetSource}.
        
      hBuffer:BUFFER-RELEASE().
      /* Without the transaction block row-updated trigger would/could fire  
         later  */
      IF plSuccess AND VALID-HANDLE(hBuffer:BEFORE-BUFFER) THEN
      DO TRANSACTION:
        hChangedDataset[1]:GET-BUFFER-HANDLE(cChangePrefix +  hBuffer:NAME):MERGE-CHANGES(hBuffer).
      END.
      hBuffer:TABLE-HANDLE:TRACKING-CHANGES = TRUE. 
      IF rRowid[iBuffer] <> ? THEN
        hBuffer:FIND-BY-ROWID(rRowid[ibuffer]).
    END.
  END. /* else (not unexpected error) */

  DELETE OBJECT hChangedDataset[1].            

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-cloneDataset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION cloneDataset Procedure 
FUNCTION cloneDataset RETURNS CHARACTER
  ( phDatasetProcedure AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose: Clones the passed dataset procedure and returns the new name  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttOldDataset FOR ttDataset.
  DEFINE BUFFER bttNewDataset FOR ttDataset.

  DEFINE VARIABLE hNewDataset    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNewProcedure  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hOldDataset    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cNewName       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i AS INTEGER    NO-UNDO.

  FIND bttOldDataset WHERE bttOldDataset.DatasetProcedure = phDatasetProcedure 
                           NO-ERROR.
  
  IF AVAIL bttOldDataset THEN 
  DO:
    DO WHILE TRUE:
      ASSIGN i        = i + 1 
             cNewName = bttOldDataset.DatasetName + "(" + STRING(i) + ")".

      IF NOT CAN-FIND(ttDataset WHERE ttDataset.Requestor      = bttOldDataset.Requestor
                                AND   ttDataset.BusinessEntity = bttOldDataset.BusinessEntity
                                AND   ttDataset.DatasetName    = cNewName) THEN 
        LEAVE.
    END.

    {get DatasetHandle hOldDataset bttOldDataset.DatasetProcedure}.

    CREATE DATASET hNewDataset.
    hNewDataset:CREATE-LIKE(hOldDataset). 
    hNewProcedure = {fnarg newDataset hNewDataset}.

    CREATE bttNewDataset. 
    ASSIGN
      bttNewDataset.Requestor        = bttOldDataset.Requestor
      bttNewDataset.BusinessEntity   = bttOldDataset.BusinessEntity
      bttNewDataset.DatasetName      = cNewName  
      bttNewDataset.DatasetProcedure = hNewProcedure.
  END.

  RETURN cNewName. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyDataset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION destroyDataset Procedure 
FUNCTION destroyDataset RETURNS LOGICAL
  ( phDatasetProcedure AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose: Destroy a dataset. 
    Notes: This is for internal use only, there is no check if this actually 
           can/should be deleted.
           Called from destroyRequestorDatasets and destroyObject.    
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttDataset FOR ttDataset.
  DEFINE BUFFER bttDataTable FOR ttDataTable. 

  FIND bttDataset WHERE bttDataset.DatasetProcedure = phDatasetProcedure NO-ERROR.
  IF AVAIL bttDataset THEN
  DO:
    /* OF is perfectly valid (the relationship can be changed without changes 
       to this code ) */
    FOR EACH bttDataTable OF bttDataset: 
      DELETE bttDataTable.
    END.

    /* We subscribed datasetDestroyed to this event and delete the record there
       in case someone calls destroyObject directly in the dataset procedure */ 
    RUN destroyObject IN bttDataset.DatasetProcedure.
    /* this should have been deleted above .. */
    IF AVAIL bttDataset THEN 
      DELETE bttDataset.

    RETURN TRUE.
  END.

  RETURN FALSE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getChangePrefix) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getChangePrefix Procedure 
FUNCTION getChangePrefix RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the change prefix to use for changed tables 
    Notes: Uses service adapter value if defined. 
------------------------------------------------------------------------------*/ 
  DEFINE VARIABLE cPrefix    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hAdapter   AS HANDLE     NO-UNDO.
  
  hAdapter = {fn getServiceAdapter}.
  cPrefix  = {fn getChangePrefix hAdapter} NO-ERROR.
  IF cPrefix > '' THEN
    RETURN cPrefix.
  ELSE 
    RETURN "ch_":U.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDatasetProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDatasetProcedure Procedure 
FUNCTION getDatasetProcedure RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return the renderer/wrapper for dataset     
    Notes:  
------------------------------------------------------------------------------*/

  RETURN "adm2/dyndataset.w":U.    

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectType Procedure 
FUNCTION getObjectType RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN 'Service'. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRequestDelimiter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRequestDelimiter Procedure 
FUNCTION getRequestDelimiter RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the delimiter to use for table request service adapter 
           parameters that cannot use comma as delimiter;
           Requests, Queries, ForeignFields, Joins and Context            
    Notes:  
------------------------------------------------------------------------------*/ 
  DEFINE VARIABLE cDelimiter AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hAdapter   AS HANDLE     NO-UNDO.
  
  hAdapter = {fn getServiceAdapter}.
  cDelimiter = {fn getRequestDelimiter hAdapter} NO-ERROR.
  IF cDelimiter > '' THEN
    RETURN cDelimiter.
  ELSE 
    RETURN CHR(1).  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getServiceAdapter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getServiceAdapter Procedure 
FUNCTION getServiceAdapter RETURNS HANDLE
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the serviceadapter that handles all data requests.  
    Notes:  
------------------------------------------------------------------------------*/
  IF NOT VALID-HANDLE(ghService) THEN
     ghService = {fnarg getManagerHandle 'ServiceAdapter':U}.

  RETURN ghService.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTableDelimiter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTableDelimiter Procedure 
FUNCTION getTableDelimiter RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the delimiter to use for table request service adapter 
           parameters that can use comma as delimiter;
           Tables, BatchSizes, DatasetSources, PrevContext, NextContext          
    Notes:  
------------------------------------------------------------------------------*/ 
  DEFINE VARIABLE cDelimiter AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hAdapter   AS HANDLE     NO-UNDO.
  
  hAdapter = {fn getServiceAdapter}.
  cDelimiter = {fn getTableDelimiter hAdapter} NO-ERROR.
  IF cDelimiter > '' THEN
    RETURN cDelimiter.
  ELSE 
    RETURN ',':U.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newDataset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION newDataset Procedure 
FUNCTION newDataset RETURNS HANDLE
  ( phDataset AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose: instantiate a dataset procedure for the passed prodataset 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hProc AS HANDLE     NO-UNDO.
  
  DO ON STOP UNDO,LEAVE:
    RUN VALUE({fn getDatasetProcedure}) PERSISTENT SET hProc.
    {set DatasetHandle phDataset hProc}.
    /* Ensure cleanup here if the dataset is destroyed from outside */
    SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO 'destroyObject':U IN hProc 
      RUN-PROCEDURE 'datasetDestroyed':U. 
  END.
  
  RETURN hProc.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-originDataset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION originDataset Procedure 
FUNCTION originDataset RETURNS CHARACTER
  ( phDatasetProcedure AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose: Return the name of the oroigianl dataset if the passed dataset is 
           a clone.  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttClone    FOR ttDataset.
  DEFINE BUFFER bttOriginal FOR ttDataset.

  DEFINE VARIABLE iPos      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cOrigName AS CHARACTER  NO-UNDO.

  FIND bttClone WHERE bttClone.DatasetProcedure = phDatasetProcedure 
                 NO-ERROR.
  
  IF AVAIL bttClone THEN
  DO:
    iPos = INDEX(bttClone.Datasetname,'(':U).
    IF iPos > 0 THEN
    DO:
      cOrigName = SUBSTR(bttClone.DatasetName,1,iPos - 1).
      FIND bttOriginal WHERE bttOriginal.Requestor      = bttClone.Requestor
                       AND   bttOriginal.BusinessEntity = bttClone.BusinessEntity
                       AND   bttOriginal.DatasetName    = cOrigName 
                       NO-ERROR.
      IF AVAIL bttOriginal THEN 
        RETURN bttOriginal.DatasetName.
    END.
  END.
  
  RETURN ''.    

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-relationFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION relationFields Procedure 
FUNCTION relationFields RETURNS CHARACTER
  ( pcRelationFields AS CHAR,
    pcEntityNames    AS CHAR) :
/*------------------------------------------------------------------------------
   Purpose: Return field relations to pass to the service with numbered 
            entity references if relation to a different entity.
Parameters: pcRelationfields - paired list of child , parent  optionally 
                               qualified with entitynames for cross entity 
                               reference.
            pcentityNames - list of entity instancenames of request                            
     Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cOtherField AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOtherTable AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iField      AS INTEGER    NO-UNDO.

  DO iField = 2 TO NUM-ENTRIES(pcRelationFields) BY 2:
    cOtherField = ENTRY(iField,pcRelationFields).
      
    /* if 2 qualifiers (3 entries) then change dataset instance name 
       qualifier to array ref (we don't pass the instance name to the service) */
    IF NUM-ENTRIES(cOtherField,'.') = 3 THEN
    DO:
      ASSIGN
        cOtherTable = ENTRY(1,cOtherField,'.').
        ENTRY(iField,pcRelationFields) = STRING(LOOKUP(cOtherTable,pcEntityNames))
                                + '.':U
                                + ENTRY(2,cOtherField,'.')
                                + '.':U
                                + ENTRY(3,cOtherField,'.').
    END. /* 3 entries in otherfield */
  END. /* iField = 2 to num-entries(PosField) by 2  */

  RETURN pcRelationFields.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

