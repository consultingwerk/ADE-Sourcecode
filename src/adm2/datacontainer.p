&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***************************************************************************/
/* Copyright (c) 2005 Progress Software Corporation, All rights reserved.  */
/***************************************************************************/
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
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

&IF DEFINED(EXCLUDE-getServiceAdapter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getServiceAdapter Procedure 
FUNCTION getServiceAdapter RETURNS HANDLE
  ( )  FORWARD.

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
  Parameters:  -- one entry per dataset  ---  
                phRequestor      - The requesting object passes its handle,
                                   which currently is used as the key to 
                                   identify the scope of the dataset.
                                   The new dataset procedure subscribes to this 
                                   object's destroyObject event, but is not added
                                   as a container target. 
                pcDatasetSources - Comma separated list of dataset procedures
                                   ? on first request 
                pcEntities       - Comma separated list of entities 
                pcEntityNames    - Comma separated list of entity instance names
               
               --- one entry per table ------- 
               
                pcHandles        - 
                pcDataTables     - Comma separated list of tables                                       
                pcQueries        - Semi colon separated ( query may have comma)
                pcBatchSizes     - Comma separated list of tables
                pcForeignFields  - Semi colon separated ( has comma)
                pcPositionFields - Semi colon separated ( has comma)
                pcRequests       - Semi colon separated (may have query with comma)
             ----- single ---     
                pcNavContext     - Navigation Context 
                plFill           - fill batch
                
  Notes:   As of current this receives the dataview handles in order to set the 
           batch information, datasetsource and calls createObjects.  
        -  expected to become more loosely coupled and just deal with the request
------------------------------------------------------------------------------*/  
  DEFINE INPUT PARAMETER phRequestor      AS HANDLE     NO-UNDO.
  DEFINE INPUT PARAMETER pcDatasetSources AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcEntities       AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcEntityNames    AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcHandles        AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcDataTables     AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcQueries        AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcBatchSizes     AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcForeignFields  AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcPositionFields AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcRequests       AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcNavContext     AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER plFill           AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE cEntity         AS CHARACTER  NO-UNDO EXTENT.
  DEFINE VARIABLE hDataset        AS HANDLE     NO-UNDO EXTENT.
  DEFINE VARIABLE cDataTables     AS CHARACTER  NO-UNDO EXTENT.
  DEFINE VARIABLE cQueries        AS CHARACTER  NO-UNDO EXTENT.
  DEFINE VARIABLE cJoins          AS CHARACTER  NO-UNDO EXTENT.
  DEFINE VARIABLE cPositions      AS CHARACTER  NO-UNDO EXTENT.
  DEFINE VARIABLE cNumRecords     AS CHARACTER  NO-UNDO EXTENT.
  DEFINE VARIABLE cContext        AS CHARACTER  NO-UNDO EXTENT.
  DEFINE VARIABLE cRequests       AS CHARACTER  NO-UNDO EXTENT.
  DEFINE VARIABLE cStartPosition  AS CHARACTER  NO-UNDO EXTENT.
  DEFINE VARIABLE cEndPosition    AS CHARACTER  NO-UNDO EXTENT.
  
  DEFINE VARIABLE iNumEntities  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iEntity       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hEntity       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iNumTables    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTable        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignField AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPosField     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFirst        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLast         AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE iTable         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iTableExt      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lFirstExt      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hObject        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hVar           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cOldList       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDatasetSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lDefs          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iField         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cOtherField    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOtherTable    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iObject        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cRequest       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTable         AS HANDLE     NO-UNDO.

  iNumEntities = NUM-ENTRIES(pcEntityNames).  
  IF iNumEntities = 0  THEN
    RETURN. 
  
  iNumTables = NUM-ENTRIES(pcDataTables).

  IF pcRequests = ? THEN
    pcRequests = ''.

  RUN adecomm/_dimextent.p(iNumEntities, OUTPUT hDataset).
  RUN adecomm/_dimextent.p(iNumEntities, OUTPUT cEntity).
  RUN adecomm/_dimextent.p(iNumEntities, OUTPUT cContext).
  RUN adecomm/_dimextent.p(iNumEntities, OUTPUT cDataTables).
  RUN adecomm/_dimextent.p(iNumEntities, OUTPUT cQueries).
  RUN adecomm/_dimextent.p(iNumEntities, OUTPUT cPositions).
  RUN adecomm/_dimextent.p(iNumEntities, OUTPUT cNumRecords).
  RUN adecomm/_dimextent.p(iNumEntities, OUTPUT cJoins).
  RUN adecomm/_dimextent.p(iNumEntities, OUTPUT cRequests). 
  
  DO iEntity = 1 TO iNumEntities:
    ASSIGN
      cEntity[iEntity] = ENTRY(iEntity,pcEntities)
      hDatasetsource   = WIDGET-HANDLE(ENTRY(iEntity,pcDatasetSources)).

    IF VALID-HANDLE(hDatasetsource) THEN
    DO:
      {get DatasetHandle hDataset[iEntity] hDatasetsource}.
      cOldList = cOldList + STRING(iEntity) + ',':U.  
      
      /* We currently empty tables here if the parent is on another entity */ 
      IF iEntity > 1 THEN
      DO:
        DO iTable = 1 TO iNumTables:
          ASSIGN
            cTable        = ENTRY(iTable,pcDataTables)
            cTable        = ENTRY(2,cTable,'.':U)
            cForeignField = ENTRY(iTable,pcForeignFields,';':U)
            cOtherField   = IF cForeignField > '' 
                            THEN ENTRY(2,cForeignField)
                            ELSE ''.

          IF NUM-ENTRIES(cOtherField,'.') = 3 THEN
            {fnarg emptyBatch cTable hDatasetsource}.
        END.
      END.
    END.
    ELSE DO:
      FIND ttDataset WHERE ttDataset.Requestor      = phRequestor
                     AND   ttDataset.DatasetName    = ENTRY(iEntity,pcEntityNames)
                     AND   ttDataset.BusinessEntity = ENTRY(iEntity,pcEntities)
                     NO-ERROR.
      IF AVAIL ttDataset THEN 
      DO:
        hDataset[iEntity] = {fn getDatasetHandle ttDataset.DatasetProcedure}.
        DO iTable = 1 TO iNumTables:
          cTable = ENTRY(iTable,pcDataTables).
          IF cTable BEGINS ttDataset.datasetname + '.' THEN
          DO:
            cTable = ENTRY(2,cTable,'.':U).
            hTable = {fnarg DataTableHandle cTable ttDataset.DatasetProcedure}.
            IF hTable:TABLE-HANDLE:HAS-RECORDS THEN
            DO:
              IF {fnarg isReposition cTable ttDataset.DatasetProcedure} THEN
              DO:  
                ASSIGN
                  pcDataTables = DYNAMIC-FUNCTION('deleteEntry' IN TARGET-PROCEDURE,
                                                  iTable,pcDataTables,',')
                  pcQueries    = DYNAMIC-FUNCTION('deleteEntry' IN TARGET-PROCEDURE,
                                                  iTable,pcQueries,';')
                  pcBatchSizes = DYNAMIC-FUNCTION('deleteEntry' IN TARGET-PROCEDURE,
                                                  iTable,pcBatchsizes,',')
                  pcForeignFields    = DYNAMIC-FUNCTION('deleteEntry' IN TARGET-PROCEDURE,
                                                  iTable,pcForeignFields,';')
                  pcPositionFields    = DYNAMIC-FUNCTION('deleteEntry' IN TARGET-PROCEDURE,
                                                  iTable,pcPositionFields,';')
                  pcRequests    = DYNAMIC-FUNCTION('deleteEntry' IN TARGET-PROCEDURE,
                                                  iTable,pcRequests,';')
                  .
                ASSIGN
                  iNumTables = NUM-ENTRIES(pcDataTables)
                  iTable     = iTable - 1.
              END.
              ELSE
              DO:
                hTable:TABLE-HANDLE:TRACKING-CHANGES = FALSE.
                hTable:EMPTY-TEMP-TABLE.
              END.
            END.
          END.
        END.
      END. /* avail ttDataset */
      ELSE
        hDataset[iEntity] = ?.
    END.
    
    /* Support 'DEFS' request with no table definition */
    IF pcRequests = 'DEFS':U AND pcDataTables = '' THEN
      ASSIGN
        cRequests[iEntity] = 'DEFS':U
        cQueries[iEntity]  = 'DEFS':U. 

  END. /* do iEntity  */
  
  DO iTable = 1 TO iNumTables:
    ASSIGN
      cTable               = ENTRY(iTable,pcDataTables)
      iEntity              = LOOKUP(ENTRY(1,cTable,'.':U),pcEntityNames)
      cTable               = ENTRY(2,cTable,'.':U)
      cForeignField        = ENTRY(iTable,pcForeignFields,';':U)
      cPosField            = ENTRY(iTable,pcPositionFields,';':U).

    /* Check for Foreignfield links across Business Entities */ 
    DO iField = 2 TO NUM-ENTRIES(cForeignField) BY 2:
      cOtherField = ENTRY(iField,cForeignField).
      
      /* if 2 qualifiers (3 entries) then change dataset instance name 
         qualifier to array ref (we don't pass the instance name to the service) */
      IF NUM-ENTRIES(cOtherField,'.') = 3 THEN
      DO:
        ASSIGN
          cOtherTable = ENTRY(1,cOtherField,'.':U).
          ENTRY(iField,cForeignField) = STRING(LOOKUP(cOtherTable,pcEntityNames))
                                      + '.':U
                                      + ENTRY(2,cOtherField,'.':U)
                                      + '.':U
                                      + ENTRY(3,cOtherField,'.':U).
      END. /* 3 entries in otherfield */
    END. /* iField = 2 to num-entries(ForeignField) by 2  */

    /* Check for Position links across Business Entities */ 
    DO iField = 2 TO NUM-ENTRIES(cPosField) BY 2:
      cOtherField = ENTRY(iField,cPosField).
      
      /* if 2 qualifiers (3 entries) then change dataset instance name 
         qualifier to array ref (we don't pass the instance name to the service) */
      IF NUM-ENTRIES(cOtherField,'.') = 3 THEN
      DO:
        ASSIGN
          cOtherTable = ENTRY(1,cOtherField,'.').
          ENTRY(iField,cPosField) = STRING(LOOKUP(cOtherTable,pcEntityNames))
                                  + '.':U
                                  + ENTRY(2,cOtherField,'.')
                                  + '.':U
                                  + ENTRY(3,cOtherField,'.').
      END. /* 3 entries in otherfield */
    END. /* iField = 2 to num-entries(PosField) by 2  */

    ASSIGN
      lFirstExt            = cDataTables[iEntity] = ''
      cDataTables[iEntity] = cDataTables[iEntity] 
                           + (IF lFirstExt THEN '':U ELSE ',':U) 
                           +  cTable
      cNumRecords[iEntity] = cNumRecords[iEntity] 
                           + (IF lFirstExt THEN '':U ELSE ',':U) 
                           + ENTRY(iTable,pcBatchSizes) 
      cQueries[iEntity]    = cQueries[iEntity] 
                           + (IF lFirstExt THEN '':U ELSE ';':U) 
                           + ENTRY(iTable,pcQueries,';':U)
      cRequests[iEntity]   = cRequests[iEntity] 
                           + (IF lFirstExt THEN '':U ELSE ';':U) 
                           + ENTRY(iTable,pcRequests,';':U)
      cJoins[iEntity]      = cJoins[iEntity] 
                           + (IF lFirstExt THEN '':U ELSE ';':U) 
                           + cForeignField      
      cPositions[iEntity]  = cPositions[iEntity] 
                           + (IF lFirstExt THEN '':U ELSE ';':U) 
                           + cPosField      
      .
    
  END. /* do iTable = 1 to num-entries  */
/*                                                     */
/*    MESSAGE                                          */
/*     'Tables'  cDataTables[1] SKIP                   */
/*     'Queries' REPLACE(cQueries[1],';',CHR(10)) SKIP */
/*     'Joins '  cJoins[1] SKIP                        */
/*     'positions' cPositions[1] SKIP                  */
/*      'Requests' cRequests[1] SKIP                   */
/*                                                     */
/*     VIEW-AS ALERT-BOX INFO BUTTONS OK.              */

  RUN retrieveData IN {fn getServiceAdapter}
                          (cEntity,
                           cDataTables,
                           cQueries,
                           cJoins,
                           cPositions,
                           cRequests,
                           pcNavContext,
                           plFill,
                           INPUT-OUTPUT cNumRecords,
                           INPUT-OUTPUT hDataset,  
                           INPUT-OUTPUT cContext,
                           OUTPUT cStartPosition,
                           OUTPUT cEndPosition) NO-ERROR.
  
  IF ERROR-STATUS:ERROR THEN
  DO:
    RETURN ERROR IF RETURN-VALUE > '' 
                 THEN RETURN-VALUE 
                 ELSE ERROR-STATUS:GET-MESSAGE(1).
  END.
  
  DO iEntity = 1 TO EXTENT(hDataSet):
    IF LOOKUP(STRING(iEntity),cOldList) = 0 THEN 
    DO:
      IF NOT VALID-HANDLE(hDataset[iEntity]) THEN
      DO:
        RETURN ERROR 'Could not retrieve dataset for entity "' 
                       + entry(iEntity,pcEntities) + '"'.
      END.
      /* create new dataset instace */
      IF hDataset[iEntity]:TYPE = 'DATASET':U THEN
        ASSIGN
          hVar              = hDataset[iEntity]
          hDataset[iEntity] = {fnarg newDataset hVar}.
      /* all smart objects publishes destroyobject */
      SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO 'destroyObject':U IN phRequestor
        RUN-PROCEDURE "destroyRequestorDatasets":U.

      FIND ttDataset WHERE ttDataset.Requestor      = phRequestor
                     AND   ttDataset.DatasetName    = ENTRY(iEntity,pcEntityNames)
                     AND   ttDataset.BusinessEntity = ENTRY(iEntity,pcEntities)
                     NO-ERROR.
      IF NOT AVAIL ttDataset THEN
      DO:
        CREATE ttDataset.
        ASSIGN 
          ttDataset.Requestor        = phRequestor
          ttDataset.DatasetName      = ENTRY(iEntity,pcEntityNames)
          ttDataset.BusinessEntity   = ENTRY(iEntity,pcEntities)
          ttDataset.DatasetProcedure = hDataset[iEntity].
      END.
    END. /**/

  END. /* do iEntity = 1 to */  
  
  DO iTable = 1 TO iNumTables:
    hObject   = WIDGET-HANDLE(ENTRY(iTable,pcHandles)).
    IF VALID-HANDLE(hObject) THEN
    DO:
      ASSIGN
        lDefs     = pcQueries = 'Defs':U 
                    OR ENTRY(iTable,pcQueries,';':U) = 'Defs':U
        cTable    = ENTRY(iTable,pcDataTables)
        cRequest  = ENTRY(iTable,pcRequests,';':U) 
        iEntity   = LOOKUP(ENTRY(1,cTable,'.':U),pcEntityNames)
        cTable    = ENTRY(2,cTable,'.':U)
        iTableExt = LOOKUP(cTable,cDataTables[iEntity])
        cFirst    = IF NUM-ENTRIES(cStartPosition[iEntity]) >= iTableExt 
                    THEN ENTRY(iTableExt,cStartPosition[iEntity])
                    ELSE '':U
        cLast     = IF NUM-ENTRIES(cEndPosition[iEntity]) >= iTableExt 
                    THEN ENTRY(iTableExt,cEndPosition[iEntity])
                    ELSE '':U
        hDatasetsource = IF LOOKUP(STRING(iEntity),cOldList) = 0  
                         THEN hDataset[iEntity]
                         ELSE WIDGET-HANDLE(ENTRY(iEntity,pcDatasetSources))
       .  

      IF NOT lDefs 
      /* don't set batchprops for non scrollable if default request ('all') */  
      AND ({fnarg isScrollable cTable hDatasetsource} 
           OR 
           cRequest <> 'ALL':U)  THEN
      DO:   
        /* Set backwards read batch info unless this was an appending next
           request, which cannot overwrite current backwards read information */
        IF cRequest <> 'NEXT':U OR pcNavContext = '':U THEN
        DO:
          IF cFirst = 'FIRST':U OR cFirst = '':U THEN
            {set FirstResultRow '':U hObject}.       
          ELSE 
            {set FirstResultRow cFirst hObject}.
        END.

        /* Set forwards read batch info unless this was an appending prev 
           request, which cannot overwrite current forwards read information */
        IF cRequest <> 'PREV':U OR pcNavContext = '':U THEN
        DO:
          IF cLast = 'LAST':U OR cLast = '':U THEN
            {set LastResultRow '' hObject}.
          ELSE 
            {set LastResultRow cLast hObject}.
        END.
      END.
    END. /* valid-handle(hObject) */
  END. /* iTable loop numtables */
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-retrieveDataset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retrieveDataset Procedure 
PROCEDURE retrieveDataset :
/*------------------------------------------------------------------------------
  Purpose: Retrieve the dataset handle for the specified requestor 
           datasetinstance and enttydefintion pouirposes    
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
                          ?,
                          pcEntity,
                          pcEntityName,
                          phRequestor,
                          '',       /* table */
                          'DEFS':U, /* queries */
                          '':U,
                          '':U,
                          '':U,
                          'DEFS':U,  /* requests */
                          '',
                          ?) NO-ERROR.

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

  FIND bttDataset WHERE bttDataset.DatasetProcedure = phDatasetProcedure NO-ERROR.
  IF AVAIL bttDataset THEN
  DO:
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
  Purpose:  Returns the prefix to use for changes 
    Notes:  
------------------------------------------------------------------------------*/

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
  Purpose:  
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

&IF DEFINED(EXCLUDE-newDataset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION newDataset Procedure 
FUNCTION newDataset RETURNS HANDLE
  ( phDataset AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose: instanitate a dataset procedure for the passed prodataset 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hProc AS HANDLE     NO-UNDO.
  DO ON STOP UNDO,LEAVE:
    RUN VALUE({fn getDatasetProcedure}) PERSISTENT SET hProc.
    {set DatasetHandle phDataset hProc}.
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

